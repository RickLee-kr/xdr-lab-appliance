#!/usr/bin/env bash
# DNS remote event file ingest — TSV on remote host, chunk fetch, local SOT merge
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dns_remote_ev_test_$$"
mkdir -p "${LOCAL_STATE_DIR}"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export NETWORK_PREFIX="10.0.0"
export CAMPAIGN_ID="dns-remote-ev-test"
export POC_RUN_ID="dns-remote-ev-test"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"
export DNS_TUNNEL_SIM_DOMAIN="dns-tunnel.com"
export DNS_TUNNEL_MAX_SENT_CAP=5000
export REMOTE_STATE_DIR="/tmp/.poc_runtime_root/state"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dns_remote_ev_test_$$"
POC_RUN_ID="dns-remote-ev-test"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
DRY_RUN=true
mkdir -p "${LOCAL_STATE_DIR}" "${LOG_DIR}"

if python3 -m py_compile "${ROOT}/stellar_dns_tunnel_file_client.py" 2>/dev/null; then
    pass "stellar_dns_tunnel_file_client.py syntax OK"
else
    fail "stellar_dns_tunnel_file_client.py syntax error"
fi

init_event_store
out=$(run_dns_tunnel_simulator_local "127.0.0.1,127.0.0.2" "${CAMPAIGN_ID}" "dry_run_sot")
event_count=$(event_store_row_count "${EVENT_DNS_EVENTS}")
sent=$(safe_int "$(event_summary_field "$(build_module_summary_from_events DNS_TUNNEL)" sent 0)")
stdout_events=$(printf '%s' "${out}" | grep -cE '^(DNS_EVENT|DNS_TUNNEL_EVENT)' || true)
stdout_events=$(safe_int "${stdout_events}")
summary_lines=$(printf '%s' "${out}" | grep -cE 'DNS_TUNNEL_FILE_CLIENT_(START|PROGRESS|DONE|SUMMARY)' || true)
summary_lines=$(safe_int "${summary_lines}")

if (( event_count >= 5000 )); then
    pass "remote/local TSV path has ${event_count} events (>=5000)"
else
    fail "expected >=5000 events in dns_events.tsv got ${event_count}"
fi

if (( stdout_events == 0 )); then
    pass "stdout has 0 DNS_EVENT lines (summary-only)"
else
    fail "stdout should have 0 EVENT lines got ${stdout_events}"
fi

if (( summary_lines >= 1 )); then
    pass "stdout has DNS_TUNNEL_FILE_CLIENT summary lines (${summary_lines})"
else
    fail "stdout missing DNS_TUNNEL_FILE_CLIENT_START/PROGRESS/DONE"
fi

if (( sent >= 5000 )); then
    pass "SOT sent=${sent} (>=5000)"
else
    fail "SOT sent=${sent} expected >=5000"
fi

event_apply_module_validation "DNS_TUNNEL" "dns_tunnel_file_client"
dns_refresh_sot_from_generated_domains "DNS_TUNNEL" || true
ref_sent=$(safe_int "${DNS_QUERY_SENT_COUNT:-0}")
ref_ec=$(event_module_event_count "DNS_TUNNEL")
if (( ref_sent >= 5000 && ref_ec >= 5000 )); then
    pass "DNS_SOT_REFRESH sent=${ref_sent} event_count=${ref_ec}"
else
    fail "DNS_SOT_REFRESH sent=${ref_sent} event_count=${ref_ec}"
fi

if [[ "${EVENT_MODULE_DECISION[DNS_TUNNEL]:-}" == success || "${EVENT_MODULE_DECISION[DNS_TUNNEL]:-}" == partial ]]; then
    pass "validation success/partial with sendto-based SOT"
else
    fail "expected success/partial got ${EVENT_MODULE_DECISION[DNS_TUNNEL]:-} reason=${EVENT_MODULE_FAILURE_REASON[DNS_TUNNEL]:-}"
fi

# Missing remote file => CODE_FAILURE path
init_event_store
DNS_TUNNEL_SKIP_REASON=""
EVENT_SOT_FAIL_FAST_FLAGS=""
export DRY_RUN=false
run_webshell_quick() { echo 'DNS_TUNNEL_SIM_START resolver=8.8.8.8'; echo 'DNS_TUNNEL_SIM_DONE sent=0'; }
export -f run_webshell_quick
if ! net_sim_dns_tunnel_ingest_output $'DNS_TUNNEL_SIM_START resolver=8.8.8.8 domain=dns-tunnel.com\nDNS_TUNNEL_SIM_DONE sent=0'; then
    if [[ "${DNS_TUNNEL_SKIP_REASON:-}" == remote_dns_events_missing ]]; then
        pass "missing remote event file => skip reason remote_dns_events_missing"
    else
        pass "missing remote event file => ingest failed (reason=${DNS_TUNNEL_SKIP_REASON:-none})"
    fi
else
    fail "ingest should fail when remote file missing"
fi
unset -f run_webshell_quick 2>/dev/null || true
export DRY_RUN=true

# Visibility gate: 5/5 responses => visible
DNS_VISIBILITY_VALID_RESPONSE=5
DNS_VISIBILITY_RESPONSE=5
DNS_VISIBILITY_VALID_SENT=5
DNS_VISIBILITY_SENT=5
DNS_ENVIRONMENT_BLOCKED=false
if evaluate_dns_visibility_gate; then
    [[ "${DNS_VISIBILITY_DECISION}" == visible ]] && pass "visibility 5/5 => decision=visible" \
        || fail "expected visible got ${DNS_VISIBILITY_DECISION}"
else
    fail "evaluate_dns_visibility_gate should pass with 5 responses"
fi

DNS_VISIBILITY_VALID_RESPONSE=0
DNS_VISIBILITY_RESPONSE=0
if ! evaluate_dns_visibility_gate; then
    [[ "${DNS_VISIBILITY_DECISION}" == blocked ]] && pass "visibility 0/5 => decision=blocked" \
        || fail "expected blocked got ${DNS_VISIBILITY_DECISION}"
else
    fail "visibility gate should block with 0 responses"
fi

rm -rf "${LOCAL_STATE_DIR}"

if (( failures == 0 )); then
    printf '\nAll DNS remote event file ingest tests passed.\n'
    exit 0
fi
printf '\n%d test(s) failed.\n' "${failures}"
exit 1
