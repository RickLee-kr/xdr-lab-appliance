#!/usr/bin/env bash
# test_event_architecture_regression.sh — event SOT architecture regression suite
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_event_arch_$$"
mkdir -p "${LOCAL_STATE_DIR}"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export CAMPAIGN_ID="event-arch-regression"
export POC_RUN_ID="event-arch-regression"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"
# shellcheck disable=SC1091
source "${ROOT}/stellar_poc_followup.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_event_arch_$$"
POC_RUN_ID="event-arch-regression"
mkdir -p "${LOCAL_STATE_DIR}"

# --- Test 1: DNS 200 events ---
init_event_store
i=0
while (( i < 200 )); do
    fqdn="$(printf 'x%040d-%03d.lab.local' "${RANDOM}" "${i}")"
    record_dns_event "enhanced_chunk" "10.0.0.53" "query" "${fqdn}" "TXT" "sent" "0" "local" "DNS_TUNNEL"
    i=$((i + 1))
done
dns_summary=$(build_module_summary_from_events "DNS_TUNNEL")
dns_ec=$(event_module_event_count "DNS_TUNNEL")
dns_unique=$(event_summary_field "${dns_summary}" unique_fqdn 0)
dns_ent=$(event_summary_field "${dns_summary}" entropy_score 0)
read -r dns_dec _ <<< "$(validate_module_from_summary "DNS_TUNNEL" "${dns_summary}" "enhanced_chunk")"
if (( dns_ec >= 200 && dns_unique >= 160 && dns_ent > 0 )) && [[ "${dns_dec}" == success ]]; then
    pass "Test1 DNS 200 events (count=${dns_ec} unique=${dns_unique} entropy=${dns_ent})"
else
    fail "Test1 DNS events=${dns_ec} unique=${dns_unique} ent=${dns_ent} dec=${dns_dec}"
fi

# --- Test 2: HTTP 60 events ---
init_event_store
j=0
while (( j < 60 )); do
    record_http_event "main" "10.0.0.1" "http://10.0.0.1/path-${j}" "GET" "400" "0" "response" "local"
    j=$((j + 1))
done
http_summary=$(build_module_summary_from_events "HTTP_URL_SCAN")
http_completed=$(event_summary_field "${http_summary}" completed 0)
read -r http_dec _ <<< "$(validate_module_from_summary "HTTP_URL_SCAN" "${http_summary}" "main")"
if (( http_completed >= 40 )) && [[ "${http_dec}" == success || "${http_dec}" == partial ]]; then
    pass "Test2 HTTP 60 events (completed=${http_completed} dec=${http_dec})"
else
    fail "Test2 HTTP completed=${http_completed} dec=${http_dec}"
fi

# --- Test 3: stdout summary only, no events ---
init_event_store
fake_stdout=$'HTTP_URL_SCAN_FINAL_SUMMARY attempted=200 responses=200 success=200\nDNS_TUNNEL_FINAL_SUMMARY query_sent=200 unique_queries=200'
read -r stdout_dec stdout_reason <<< "$(event_reject_stdout_only_success "HTTP_URL_SCAN" "${fake_stdout}")"
if [[ "${stdout_dec}" == CODE_FAILURE && "${stdout_reason}" == evidence_missing ]]; then
    pass "Test3 stdout-only => CODE_FAILURE evidence_missing"
else
    fail "Test3 stdout-only (dec=${stdout_dec} reason=${stdout_reason})"
fi

# --- Test 4: SOT file deleted while stage executed ---
init_event_store
record_http_event "main" "10.0.0.1" "http://10.0.0.1/x" "GET" "400" "0" "response" "local"
EVENT_STAGE_EXECUTED["HTTP_URL_SCAN|main"]=yes
rm -f "${EVENT_HTTP_EVENTS}"
ff=$(event_fail_fast_invariants "HTTP_URL_SCAN" "attempted=1 completed=1 events=1 event_count=0" "main" 2>/dev/null || true)
if [[ "${ff}" == CODE_FAILURE ]] || [[ "${EVENT_SOT_FAIL_FAST_FLAGS}" == *SOT_FILE_DELETED* || "${EVENT_SOT_FAIL_FAST_FLAGS}" == *EVENT_FILE_MISSING* ]]; then
    pass "Test4 SOT deleted => BUG_FAIL_FAST (${EVENT_SOT_FAIL_FAST_FLAGS})"
else
    fail "Test4 expected BUG_FAIL_FAST flags=${EVENT_SOT_FAIL_FAST_FLAGS} ff=${ff}"
fi

# --- Test 5: parallel workers 20 ---
init_event_store
p=0
while (( p < 20 )); do
    ( record_dns_event "enhanced_chunk" "resolver" "query" "parallel-${p}.test.local" "A" "sent" "0" "local" ) &
    p=$((p + 1))
done
wait
par_count=$(event_module_event_count "DNS_TUNNEL")
if (( par_count >= 20 )); then
    pass "Test5 parallel workers recorded ${par_count} events (loss=0)"
else
    fail "Test5 parallel event loss count=${par_count}"
fi

# --- Test 6: emergency burst append only ---
init_event_store
k=0
while (( k < 10 )); do
    record_http_event "main" "10.0.0.1" "http://10.0.0.1/main-${k}" "GET" "400" "0" "response" "local"
    k=$((k + 1))
done
main_lines=$(awk 'NR>1' "${EVENT_HTTP_EVENTS}" | wc -l | awk '{print $1}')
e=0
while (( e < 5 )); do
    record_http_event "emergency" "10.0.0.1" "http://10.0.0.1/em-${e}" "GET" "403" "0" "response" "local"
    e=$((e + 1))
done
total_lines=$(awk 'NR>1' "${EVENT_HTTP_EVENTS}" | wc -l | awk '{print $1}')
header_only=$(head -n1 "${EVENT_HTTP_EVENTS}")
if (( total_lines == main_lines + 5 )) && [[ "${header_only}" == *timestamp*module* ]]; then
    pass "Test6 emergency append (main=${main_lines} total=${total_lines})"
else
    fail "Test6 emergency append main=${main_lines} total=${total_lines}"
fi

# --- Test: DGA ingest via EVENT lines ---
init_event_store
dga_out=$'DGA_EVENT timestamp=2026-01-01T00:00:00Z module=DGA_SIMULATION stage=nx target=10.0.0.53 action=query status=sent value=abc.xyz
DGA_EVENT timestamp=2026-01-01T00:00:01Z module=DGA_SIMULATION stage=nx target=10.0.0.53 action=query status=nxdomain value=abc.xyz'
ingest_remote_events "${dga_out}" "DGA_SIMULATION" || true
dga_s=$(build_module_summary_from_events "DGA_SIMULATION")
if (( $(safe_int "$(event_summary_field "${dga_s}" nxdomain 0)") >= 1 )); then
    pass "DGA_EVENT ingest"
else
    fail "DGA_EVENT ingest summary=${dga_s}"
fi

rm -rf "${LOCAL_STATE_DIR}"
if (( failures > 0 )); then
    printf '\n%d regression test(s) failed\n' "${failures}"
    exit 1
fi
printf '\nAll event architecture regression tests passed\n'
