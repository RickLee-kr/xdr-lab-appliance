#!/usr/bin/env bash
# Integrated E2E pipeline (dry-run simulators + SOT merge + run_e2e_validation_suite)
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_e2e_integ_$$"
mkdir -p "${LOCAL_STATE_DIR}"
export POC_REPO_ROOT="${ROOT}"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export NETWORK_PREFIX="10.0.0"
export CAMPAIGN_ID="e2e-integ"
export POC_RUN_ID="e2e-integ"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export DNS_TUNNEL_SIM_DOMAIN="dns-tunnel.com"
export DNS_TUNNEL_MAX_SENT_CAP=12000
export REMOTE_STATE_DIR="/tmp/.poc_runtime_root/state"
export EXTERNAL_CALLBACK_CONNECTED=1
export EXTERNAL_CALLBACK_ATTEMPTED=1
export TELEMETRY_VAL_EXTERNAL_CALLBACK=success

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_e2e_integ_$$"
POC_RUN_ID="e2e-integ"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
DRY_RUN=true
export DRY_RUN LOCAL_STATE_DIR POC_RUN_ID LOG_DIR POC_REPO_ROOT
mkdir -p "${LOCAL_STATE_DIR}" "${LOG_DIR}"

init_event_store

# DNS: remote TSV path (dry_run_sot)
run_dns_tunnel_simulator_local "127.0.0.1,127.0.0.2" "${CAMPAIGN_ID}" "dry_run_sot" >/dev/null 2>&1 || true
state_append "dns_tunnel_simulator.log" "DNS_REMOTE_EVENT_FILE path=$(net_sim_remote_dns_event_path) exists=yes size=1200000"
state_append "dns_tunnel_simulator.log" "DNS_REMOTE_EVENT_FETCH lines=12000"
state_append "dns_tunnel_simulator.log" "DNS_EVENT_MERGE_RESULT local_events=12000 merged_rows=12000 prior_rows=0"
dns_ec=$(event_module_event_count "DNS_TUNNEL")

# HTTP: SOT events via http_record_url_event
http_sot_init_run 2>/dev/null || true
for i in $(seq 0 44); do
    http_record_url_event "http://10.0.0.1:80" "/e2e-${i}" "GET" "probe" "200" "0" "response" "50"
done
http_refresh_sot_from_events 2>/dev/null || true
HTTP_URL_GEN_COUNT=45
http_emit_url_execution_summary 2>/dev/null || true
http_ec=$(event_module_event_count "HTTP_URL_SCAN")

# DGA: dry-run event generator
net_sim_dga_dry_run_events 250 2>/dev/null || true
e2e_emit_dga_final_summary 2>/dev/null || true
dga_ec=$(event_module_event_count "DGA_SIMULATION")

report=$(run_e2e_validation_suite 2>&1) || true

printf '\n======== E2E INTEGRATED REPORT ========\n%s\n' "${report}"

for mod in DNS_TUNNEL HTTP_URL_SCAN DGA_SIMULATION; do
    ec=$(event_module_event_count "${mod}")
    val="${EVENT_MODULE_VALIDATION[${mod}]:-UNKNOWN}"
    dec="${EVENT_MODULE_DECISION[${mod}]:-unknown}"
    printf 'MODULE_SUMMARY_LINE module=%s event_count=%s validation=%s decision=%s\n' "${mod}" "${ec}" "${val}" "${dec}"
    if [[ "${report}" != *"module=${mod}"* ]]; then
        fail "E2E report missing module=${mod}"
    else
        pass "E2E integrated ${mod} ec=${ec} validation=${val}"
    fi
done

if [[ "${report}" == *LEGACY_DECISION_REFERENCES_FOUND=0* ]]; then
    pass "LEGACY_DECISION_REFERENCES_FOUND=0"
else
    fail "legacy references not zero in report"
fi

if [[ "${report}" == *E2E_FINAL_REPORT* ]]; then
    pass "E2E_FINAL_REPORT present"
else
    fail "missing E2E_FINAL_REPORT"
fi

rm -rf "${LOCAL_STATE_DIR}" 2>/dev/null || true
exit "${failures}"
