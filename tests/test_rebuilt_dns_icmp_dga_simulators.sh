#!/usr/bin/env bash
# Rebuilt DNS Tunnel / DGA simulators — EVENT SOT validation tests
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_rebuilt_sim_test_$$"
mkdir -p "${LOCAL_STATE_DIR}"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export NETWORK_PREFIX="10.0.0"
export CAMPAIGN_ID="rebuilt-sim-test"
export POC_RUN_ID="rebuilt-sim-test"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_rebuilt_sim_test_$$"
POC_RUN_ID="rebuilt-sim-test"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
REPORT_DIR="${LOCAL_STATE_DIR}/report"
EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
DRY_RUN=true
mkdir -p "${LOCAL_STATE_DIR}" "${LOG_DIR}"

# --- DNS Tunnel simulator: SOT thresholds (synthetic dry-run cap 12000) ---
export DNS_TUNNEL_MAX_SENT_CAP=12000
export DNS_TUNNEL_BURST_QUERIES=4000
init_event_store
net_sim_dns_tunnel_dry_run_events 0
dns_sum=$(build_module_summary_from_events "DNS_TUNNEL")
sent=$(safe_int "$(event_summary_field "${dns_sum}" sent 0)")
unique=$(safe_int "$(event_summary_field "${dns_sum}" unique_fqdn 0)")
idx_cnt=$(safe_int "$(event_summary_field "${dns_sum}" idx_pattern_count 0)")
avg_pl=$(safe_int "$(event_summary_field "${dns_sum}" avg_payload_label_length 0)")
sendto_ok=$(safe_int "$(event_summary_field "${dns_sum}" sendto_success 0)")
target_count=$(safe_int "$(event_summary_field "${dns_sum}" target_count 0)")
idx_queries=$(( sent - target_count * 2 ))
(( idx_queries < 1 )) && idx_queries="${sent}"
idx_min=$(( idx_queries * 80 / 100 ))
if (( sent >= 10000 && idx_cnt >= idx_min && avg_pl >= 40 && sendto_ok > 0 && target_count >= 2 )); then
    pass "DNS tunnel file client: sent=${sent} unique=${unique} idx=${idx_cnt} avg_pl=${avg_pl} sendto=${sendto_ok} targets=${target_count}"
else
    fail "DNS tunnel metrics sent=${sent} unique=${unique} idx=${idx_cnt} avg_pl=${avg_pl} sendto=${sendto_ok} targets=${target_count}"
fi

# --- DNS and DGA summaries must not mix ---
init_event_store
net_sim_dns_tunnel_dry_run_events 50
net_sim_dga_dry_run_events 50
dns_only=$(build_module_summary_from_events "DNS_TUNNEL")
dga_only=$(build_module_summary_from_events "DGA_SIMULATION")
dga_in_dns=$(awk -F'\t' 'NR>1 && $3 ~ /^DGA/' "${EVENT_DNS_EVENTS}" 2>/dev/null | wc -l | awk '{print $1}')
dns_in_dga=$(awk -F'\t' 'NR>1 && $3 ~ /^DNS/' "${EVENT_DGA_EVENTS}" 2>/dev/null | wc -l | awk '{print $1}')
if (( dga_in_dns == 0 && dns_in_dga == 0 )); then
    pass "DNS and DGA event stores isolated (cross_rows dns=${dga_in_dns} dga=${dns_in_dga})"
else
    fail "DNS/DGA mixed: dga_in_dns=${dga_in_dns} dns_in_dga=${dns_in_dga}"
fi
if [[ "${dns_only}" == *sent=* && "${dga_only}" == *sent=* ]]; then
    pass "Separate module summaries dns=${dns_only%% *} dga=${dga_only%% *}"
else
    fail "Missing module summaries"
fi

# --- DGA model: xdr.ooo nx + resolvable ---
init_event_store
net_sim_dga_dry_run_events
dga_sum=$(build_module_summary_from_events "DGA_SIMULATION")
d_nx=$(safe_int "$(event_summary_field "${dga_sum}" nxdomain 0)")
d_res=$(safe_int "$(event_summary_field "${dga_sum}" resolvable 0)")
d_nx_sent=$(safe_int "$(event_summary_field "${dga_sum}" nx_sent 0)")
d_base=$(event_summary_field "${dga_sum}" base_domain "unknown")
if (( d_nx >= 500 && d_res >= 30 && d_nx_sent >= 500 )) && [[ "${d_base}" == xdr.ooo ]]; then
    pass "DGA model: nx=${d_nx} res=${d_res} nx_sent=${d_nx_sent} base=${d_base}"
else
    fail "DGA model metrics nx=${d_nx} res=${d_res} nx_sent=${d_nx_sent} base=${d_base}"
fi

# --- stdout-only success must not validate ---
init_event_store
read -r dec_stdout _ <<< "$(event_reject_stdout_only_success "DNS_TUNNEL" $'DNS_TUNNEL_SIM_STATS attempted=220 unique=220 success=220')"
if [[ "${dec_stdout}" == *CODE_FAILURE* || "${dec_stdout}" == *failed* ]]; then
    pass "stdout-only DNS blocked from success (${dec_stdout})"
else
    fail "stdout-only DNS should not succeed got ${dec_stdout}"
fi

# --- environment_failure is not code_failure ---
TELEMETRY_VAL_DNS_TUNNEL=""
DNS_TUNNEL_SKIP_REASON="resolver unreachable UDP/53 blocked"
evaluate_telemetry_dns_tunnel
if [[ "${TELEMETRY_VAL_DNS_TUNNEL}" == environment_failure ]]; then
    pass "DNS resolver unreachable => environment_failure"
else
    fail "expected environment_failure got ${TELEMETRY_VAL_DNS_TUNNEL}"
fi

# --- Final decision from SOT only ---
init_event_store
net_sim_dns_tunnel_dry_run_events 0
event_apply_module_validation "DNS_TUNNEL" "dns_tunnel_file_client"
case "${EVENT_MODULE_DECISION[DNS_TUNNEL]:-}" in
    success|partial) pass "DNS SOT decision from SOT (${EVENT_MODULE_DECISION[DNS_TUNNEL]:-} ${EVENT_MODULE_VALIDATION[DNS_TUNNEL]:-})" ;;
    *) fail "DNS SOT decision expected success/partial got ${EVENT_MODULE_DECISION[DNS_TUNNEL]:-} reason=${EVENT_MODULE_FAILURE_REASON[DNS_TUNNEL]:-}" ;;
esac

init_event_store
net_sim_dga_dry_run_events
finalize_dga_simulation_stage_judgment "DGA Simulation" "test "
if [[ "${DGA_FINAL_RESULT:-}" == success ]]; then
    pass "DGA final decision success from SOT"
else
    fail "DGA SOT decision expected success got ${DGA_FINAL_RESULT:-}"
fi

rm -rf "${LOCAL_STATE_DIR}"
if (( failures > 0 )); then
    printf '\n%d test(s) failed\n' "${failures}"
    exit 1
fi
printf '\nAll rebuilt simulator tests passed\n'
