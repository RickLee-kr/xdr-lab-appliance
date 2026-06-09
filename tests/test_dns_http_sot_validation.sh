#!/usr/bin/env bash
# Source-of-truth validation: event store (state/events/*.tsv)
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_sot_test_$$"
mkdir -p "${LOCAL_STATE_DIR}"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export CAMPAIGN_ID="sot-test"
export POC_RUN_ID="sot-test"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"
# shellcheck disable=SC1091
source "${ROOT}/stellar_poc_followup.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_sot_test_$$"
POC_RUN_ID="sot-test"
mkdir -p "${LOCAL_STATE_DIR}"

init_event_store

# --- DNS: 200 FQDN events => unique>=160, entropy>0 ---
i=0
while (( i < 200 )); do
    fqdn="$(printf 'x%040d-%03d.lab.local' "${RANDOM}" "${i}")"
    fqdn="$(printf 'idx-%06d-JBSWY3DPFQQHO33SJBSWY3DPFQQHO33SJBSWY3DPFQ%03d.dns-tunnel.com' "${i}" "${i}")"
    dns_record_generated_fqdn "DNS_TUNNEL" "${fqdn}" "A" "dns_tunnel_file_client"
    i=$((i + 1))
done
dns_refresh_sot_from_generated_domains "DNS_TUNNEL"
dns_summary=$(build_module_summary_from_events "DNS_TUNNEL")
ent=$(safe_int "$(event_summary_field "${dns_summary}" entropy_score 0)")
cnt=$(safe_int "$(event_summary_field "${dns_summary}" unique_fqdn 0)")
if (( cnt == 200 && ent > 0 )); then
    pass "DNS_SOT_REFRESH fqdn_count=200 entropy_score=${ent}"
else
    fail "DNS_SOT expected fqdn_count=200 entropy>0 got fqdn_count=${cnt} entropy=${ent}"
fi

init_event_store
event_stage_mark_executed "DNS_TUNNEL" "dns_tunnel_file_client"
if dns_sot_enhanced_fail_fast 2>/dev/null; then
    fail "DNS_SOT_BUG_FAIL_FAST should trigger when stage executed and SOT empty"
else
    pass "DNS_SOT_BUG_FAIL_FAST when tunnel simulator FQDN not recorded"
fi

# --- HTTP: events drive summary counters ---
init_event_store
http_sot_init_run
j=0
while (( j < 45 )); do
    http_record_url_event "http://10.0.0.1:80" "/path-${j}" "GET" "payload" "400" "0" "response_4xx" "12"
    j=$((j + 1))
done
http_refresh_sot_from_events || true
att=$(safe_int "${HTTP_URL_ATTEMPT_COUNT:-0}")
comp=$(safe_int "${HTTP_URL_COMPLETE_COUNT:-0}")
rf=$(safe_int "${HTTP_URL_SCAN_REAL_FAILED:-0}")
if (( att == 45 && comp == 45 && rf == 45 )); then
    pass "HTTP_SOT_REFRESH attempted=45 completed=45 real_failed=45"
else
    fail "HTTP_SOT counters att=${att} comp=${comp} rf=${rf}"
fi

read -r dec _ <<< "$(http_url_scan_decision_evaluate 45 45 45 0 45 45)"
if [[ "${dec}" == *success* ]]; then
    pass "HTTP decision success from SOT"
else
    fail "HTTP decision expected success got ${dec}"
fi

if http_sot_bug_fail_fast 2>/dev/null; then
    pass "HTTP SOT present — no fail-fast when events logged"
else
    fail "HTTP_SOT_BUG_FAIL_FAST should not trigger when SOT has events"
fi

init_event_store
event_stage_mark_executed "HTTP_URL_SCAN" "main"
if http_sot_bug_fail_fast 2>/dev/null; then
    fail "HTTP_SOT_BUG_FAIL_FAST should trigger when SOT empty and stage executed"
else
    pass "HTTP_SOT_BUG_FAIL_FAST when events not recorded"
fi

rm -rf "${LOCAL_STATE_DIR}"
if (( failures > 0 )); then
    printf '\n%d test(s) failed\n' "${failures}"
    exit 1
fi
printf '\nAll SOT validation tests passed\n'
