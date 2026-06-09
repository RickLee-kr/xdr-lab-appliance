#!/usr/bin/env bash
# E2E validation suite — module status, fail-fast, final report, legacy audit
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_e2e_val_test_$$"
mkdir -p "${LOCAL_STATE_DIR}"
export POC_REPO_ROOT="${ROOT}"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export NETWORK_PREFIX="10.0.0"
export CAMPAIGN_ID="e2e-val-test"
export POC_RUN_ID="e2e-val-test"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"
export DNS_TUNNEL_SIM_DOMAIN="dns-tunnel.com"
export DNS_TUNNEL_MAX_SENT_CAP=12000
export REMOTE_STATE_DIR="/tmp/.poc_runtime_root/state"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_e2e_val_test_$$"
POC_RUN_ID="e2e-val-test"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
DRY_RUN=true
export DRY_RUN LOCAL_STATE_DIR POC_RUN_ID LOG_DIR POC_REPO_ROOT
mkdir -p "${LOCAL_STATE_DIR}" "${LOG_DIR}"

if ! declare -F run_e2e_validation_suite >/dev/null 2>&1; then
    fail "run_e2e_validation_suite not defined"
    exit "${failures}"
fi

# --- HTTP E2E missing event fail-fast (summary shows traffic but zero SOT rows) ---
init_event_store
E2E_FAIL_FAST_FLAGS=""
summary='generated=33 attempted=33 completed=33 responses=33 timeout=0 connection_refused=0 dns_failure=0 http_4xx=0 http_5xx=0 events=0 event_count=0'
: > "${EVENT_HTTP_EVENTS}"
printf '%s\n' "${EVENT_TSV_HEADER}" >> "${EVENT_HTTP_EVENTS}"
if e2e_check_module_event_missing "HTTP_URL_SCAN" "${summary}"; then
    fail "HTTP_E2E_EVENT_MISSING should trigger"
else
    pass "HTTP_E2E_EVENT_MISSING when attempted/responses>0 and event_count=0"
fi
[[ "${E2E_FAIL_FAST_FLAGS}" == *HTTP_E2E_EVENT_MISSING* ]] || fail "E2E_FAIL_FAST_FLAGS missing HTTP_E2E_EVENT_MISSING"

# --- DNS pipeline log replay ---
init_event_store
state_append "dns_tunnel_simulator.log" "DNS_REMOTE_EVENT_FILE path=/tmp/ev exists=yes size=12000"
state_append "dns_tunnel_simulator.log" "DNS_REMOTE_EVENT_FETCH lines=12000"
state_append "dns_tunnel_simulator.log" "DNS_EVENT_MERGE_RESULT local_events=12000 merged_rows=12000 prior_rows=0"
state_append "dns_tunnel_simulator.log" "DNS_SOT_REFRESH sent=12000 event_count=12000"
out=$(run_dns_tunnel_simulator_local "127.0.0.1,127.0.0.2" "${CAMPAIGN_ID}" "dry_run_sot" 2>&1) || true
event_apply_all_module_validations || true
E2E_FAIL_FAST_FLAGS=""
LEGACY_DECISION_REFERENCES_FOUND=0
report=$(run_e2e_validation_suite 2>&1) || true
if [[ "${report}" == *E2E_MODULE_STATUS* && "${report}" == *E2E_FINAL_REPORT* ]]; then
    pass "run_e2e_validation_suite emits E2E_MODULE_STATUS and E2E_FINAL_REPORT"
else
    fail "E2E report missing expected sections"
fi
if [[ "${report}" == *module=DNS_TUNNEL* ]]; then
    pass "E2E report includes DNS_TUNNEL"
else
    fail "E2E report missing DNS_TUNNEL"
fi
dns_ec=$(event_module_event_count "DNS_TUNNEL")
if [[ "${report}" == *"MODULE=DNS_TUNNEL"* ]] && [[ "${report}" == *"EVENT_COUNT=${dns_ec}"* ]]; then
    pass "E2E_FINAL_REPORT DNS event_count=${dns_ec}"
else
    fail "E2E_FINAL_REPORT DNS event_count mismatch"
fi

# --- Legacy audit (decision path functions only) ---
e2e_audit_legacy_decision_references || true
if (( LEGACY_DECISION_REFERENCES_FOUND == 0 )); then
    pass "LEGACY_DECISION_REFERENCES_FOUND=0 in decision functions"
else
    fail "LEGACY_DECISION_REFERENCES_FOUND=${LEGACY_DECISION_REFERENCES_FOUND} (expected 0)"
fi

# --- DGA_FINAL_SUMMARY ---
init_event_store
hdr="${EVENT_TSV_HEADER}"
printf '%s\n' "${hdr}" > "${EVENT_DGA_EVENTS}"
for _ in $(seq 1 20); do
    printf '2020-01-01T00:00:00Z\te2e\tdga\tmain\tx%02d.dga.invalid\tA\tnxdomain\t0\t1\tlocal\n' "${_}" >> "${EVENT_DGA_EVENTS}"
done
dga_log=$(e2e_emit_dga_final_summary 2>&1 || true)
if [[ "${dga_log}" == *DGA_FINAL_SUMMARY* && "${dga_log}" == *event_count=20* ]]; then
    pass "DGA_FINAL_SUMMARY with event_count"
else
    fail "DGA_FINAL_SUMMARY output: ${dga_log}"
fi

rm -rf "${LOCAL_STATE_DIR}" 2>/dev/null || true
exit "${failures}"
