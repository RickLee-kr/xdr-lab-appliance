#!/usr/bin/env bash
# test_event_sot_architecture.sh — event-based SOT validation architecture
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_event_sot_test_$$"
mkdir -p "${LOCAL_STATE_DIR}"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export CAMPAIGN_ID="event-sot-test"
export POC_RUN_ID="event-sot-test"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"
# shellcheck disable=SC1091
source "${ROOT}/stellar_poc_followup.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_event_sot_test_$$"
POC_RUN_ID="event-sot-test"
mkdir -p "${LOCAL_STATE_DIR}"

init_event_store

# --- Test 1: DNS tunnel file client idx-pattern 1500 events (partial threshold) ---
i=0
while (( i < 1500 )); do
    i=$((i + 1))
    fqdn="$(printf 'idx-%06d-JBSWY3DPFQQHO33SJBSWY3DPFQQHO33SJBSWY3DPFQ%03d.dns-tunnel.com' "${i}" "${i}")"
    record_dns_event "dns_tunnel_file_client" "10.0.0.10" "query" "${fqdn}" "A" "sent" "0" "local" "DNS_TUNNEL"
done
dns_summary=$(build_module_summary_from_events "DNS_TUNNEL")
dns_events=$(awk 'NR>1' "${EVENT_DNS_EVENTS}" | wc -l | awk '{print $1}')
dns_sent=$(event_summary_field "${dns_summary}" sent 0)
dns_unique=$(event_summary_field "${dns_summary}" unique_fqdn 0)
dns_sendto=$(event_summary_field "${dns_summary}" sendto_success 0)
read -r dns_dec dns_reason <<< "$(validate_module_from_summary "DNS_TUNNEL" "${dns_summary}" "dns_tunnel_file_client")"
if (( dns_events >= 1500 && dns_sent >= 1400 && dns_sendto >= 1000 )) && [[ "${dns_dec}" == success ]]; then
    pass "DNS tunnel file client 1500 events success (events=${dns_events} sent=${dns_sent} sendto=${dns_sendto} decision=${dns_dec})"
else
    fail "DNS test1 events=${dns_events} sent=${dns_sent} unique=${dns_unique} sendto=${dns_sendto} dec=${dns_dec} reason=${dns_reason}"
fi

# --- Test 2: HTTP main 60 requests ---
init_event_store
j=0
while (( j < 60 )); do
    record_http_event "main" "10.0.0.1" "http://10.0.0.1/path-${j}" "GET" "400" "0" "response" "local"
    j=$((j + 1))
done
http_summary=$(build_module_summary_from_events "HTTP_URL_SCAN")
http_events=$(awk 'NR>1' "${EVENT_HTTP_EVENTS}" | wc -l | awk '{print $1}')
http_completed=$(event_summary_field "${http_summary}" completed 0)
read -r http_dec http_reason <<< "$(validate_module_from_summary "HTTP_URL_SCAN" "${http_summary}" "main")"
if (( http_events >= 60 && http_completed >= 40 )) && [[ "${http_dec}" == success || "${http_dec}" == partial ]]; then
    pass "HTTP main 60 events (events=${http_events} completed=${http_completed} decision=${http_dec})"
else
    fail "HTTP test2 events=${http_events} completed=${http_completed} dec=${http_dec} reason=${http_reason}"
fi
if [[ "${EVENT_SOT_FAIL_FAST_FLAGS}" == *HTTP_SOT_BUG_FAIL_FAST* ]]; then
    fail "HTTP_SOT_BUG_FAIL_FAST should not trigger when events exist"
else
    pass "HTTP_SOT_BUG_FAIL_FAST absent when SOT populated"
fi

# --- Test 3: stdout summary only, no EVENT lines ---
init_event_store
fake_out=$'HTTP_URL_SCAN_FINAL_SUMMARY attempted=200 responses=200 success=200\nDNS_TUNNEL_FINAL_SUMMARY query_sent=200 unique_queries=200'
read -r no_ev_dec no_ev_reason <<< "$(event_reject_stdout_only_success "HTTP_URL_SCAN" "${fake_out}")"
if [[ "${no_ev_dec}" == CODE_FAILURE && "${no_ev_reason}" == evidence_missing ]]; then
    pass "stdout summary without EVENT => CODE_FAILURE evidence_missing"
else
    fail "stdout-only summary must not succeed (dec=${no_ev_dec} reason=${no_ev_reason})"
fi

# --- Test 4: attempted>0 but SOT empty ---
init_event_store
EVENT_STAGE_EXECUTED["HTTP_URL_SCAN|main"]=yes
ff=$(event_fail_fast_invariants "HTTP_URL_SCAN" "attempted=33 completed=0 events=0" "main" 2>/dev/null || true)
if [[ "${ff}" == CODE_FAILURE ]] || [[ "${EVENT_SOT_FAIL_FAST_FLAGS}" == *HTTP* ]]; then
    pass "BUG_FAIL_FAST when stage executed and SOT empty"
else
    fail "expected BUG_FAIL_FAST for empty SOT with stage executed flags=${EVENT_SOT_FAIL_FAST_FLAGS}"
fi

# --- Test 5: emergency burst appends, does not overwrite main ---
init_event_store
k=0
while (( k < 10 )); do
    record_http_event "main" "10.0.0.1" "http://10.0.0.1/main-${k}" "GET" "400" "0" "response" "local"
    k=$((k + 1))
done
main_before=$(awk 'NR>1' "${EVENT_HTTP_EVENTS}" | wc -l | awk '{print $1}')
e=0
while (( e < 5 )); do
    record_http_event "emergency" "10.0.0.1" "http://10.0.0.1/em-${e}" "GET" "403" "0" "response" "local"
    e=$((e + 1))
done
total_after=$(awk 'NR>1' "${EVENT_HTTP_EVENTS}" | wc -l | awk '{print $1}')
if (( total_after == main_before + 5 )); then
    pass "emergency burst appends to main events (main=${main_before} total=${total_after})"
else
    fail "emergency should append: main=${main_before} total=${total_after}"
fi

# --- Test 6: parallel subshell event append ---
init_event_store
p=0
while (( p < 20 )); do
    (
        record_dns_event "enhanced_chunk" "resolver" "query" "parallel-${p}.test.local" "A" "sent" "0" "local"
    ) &
    p=$((p + 1))
done
wait
par_count=$(awk 'NR>1' "${EVENT_DNS_EVENTS}" | wc -l | awk '{print $1}')
if (( par_count >= 20 )); then
    pass "parallel subshell recorded ${par_count} DNS events"
else
    fail "parallel subshell missing events count=${par_count}"
fi

rm -rf "${LOCAL_STATE_DIR}"
if (( failures > 0 )); then
    printf '\n%d test(s) failed\n' "${failures}"
    exit 1
fi
printf '\nAll event SOT architecture tests passed\n'
