#!/usr/bin/env bash
# DGA Model client (xdr.ooo) — phase/SOT validation tests
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dga_model_test_$$"
mkdir -p "${LOCAL_STATE_DIR}"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export NETWORK_PREFIX="10.0.0"
export CAMPAIGN_ID="dga-model-test"
export POC_RUN_ID="dga-model-test"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"
export DGA_MODEL_BASE_DOMAIN="xdr.ooo"
export DGA_MODEL_NX_COUNT=500
export DGA_MODEL_RESOLVABLE_COUNT=30

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dga_model_test_$$"
POC_RUN_ID="dga-model-test"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
mkdir -p "${LOCAL_STATE_DIR}" "${LOG_DIR}"
export LOCAL_STATE_DIR LOG_DIR POC_RUN_ID DRY_RUN
poc_sot_paths_init 2>/dev/null || true

# --- Python client dry-run: required logs ---
out=$(python3 "${ROOT}/stellar_dga_model_client.py" --dry-run-sot --run-id test \
    --base-domain xdr.ooo --nx-count 500 --resolvable-count 30 2>&1 || true)

for pat in DGA_TARGET_DOMAIN DGA_PHASE1_START DGA_PHASE1_PROGRESS DGA_PHASE1_DONE \
    DGA_PHASE2_START DGA_PHASE2_PROGRESS DGA_PHASE2_DONE DGA_PACKET_EVIDENCE DGA_MODEL_SUMMARY; do
    if [[ "${out}" == *"${pat}"* ]]; then
        pass "log ${pat} present"
    else
        fail "missing log ${pat}"
    fi
done

if [[ "${out}" == *"base_domain=xdr.ooo"* && "${out}" == *".xdr.ooo"* ]]; then
    pass "xdr.ooo base domain in output"
else
    fail "xdr.ooo not found in client output"
fi

if [[ "${out}" == *"nx_nxdomain=500"* && "${out}" == *"resolvable_resolved=30"* ]]; then
    pass "dry-run nx_nxdomain=500 resolvable_resolved=30"
else
    fail "dry-run phase counts unexpected: $(echo "${out}" | grep DGA_MODEL_SUMMARY | tail -n1)"
fi

# --- SOT dry-run via shell integration ---
init_event_store
net_sim_dga_dry_run_events
dga_sum=$(build_module_summary_from_events "DGA_SIMULATION")
nx=$(safe_int "$(event_summary_field "${dga_sum}" nxdomain 0)")
res=$(safe_int "$(event_summary_field "${dga_sum}" resolvable 0)")
nx_sent=$(safe_int "$(event_summary_field "${dga_sum}" nx_sent 0)")
res_sent=$(safe_int "$(event_summary_field "${dga_sum}" resolvable_sent 0)")
same_bd=$(event_summary_field "${dga_sum}" same_base_domain "no")
base_dom=$(event_summary_field "${dga_sum}" base_domain "unknown")

if [[ "${base_dom}" == xdr.ooo && "${same_bd}" == yes ]]; then
    pass "SOT base_domain=xdr.ooo same_base_domain=yes"
else
    fail "SOT base_domain=${base_dom} same_base_domain=${same_bd}"
fi

if (( nx >= 500 && res >= 30 && nx_sent >= 500 && res_sent >= 30 )); then
    pass "SOT phase counts nx=${nx} res=${res} nx_sent=${nx_sent} res_sent=${res_sent}"
else
    fail "SOT phase counts nx=${nx} res=${res} nx_sent=${nx_sent} res_sent=${res_sent}"
fi

read -r decision reason <<< "$(validate_module_from_summary "DGA_SIMULATION" "${dga_sum}" "dga_model_client")"
if [[ "${decision}" == success ]]; then
    pass "SOT success criteria met (${reason})"
else
    fail "SOT expected success got ${decision} (${reason})"
fi

# --- event_count-only success forbidden ---
init_event_store
printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_DGA_EVENTS}"
printf '2020-01-01T00:00:00Z\ttest\tDGA\tdga_model_client\tsystem\tquery\tdomain\tsent\t0\tevent-only|A|nx|xdr.ooo\tlocal\n' >> "${EVENT_DGA_EVENTS}"
ev_only=$(build_module_summary_from_events "DGA_SIMULATION")
read -r dec_ev ev_reason <<< "$(validate_module_from_summary "DGA_SIMULATION" "${ev_only}" "dga_model_client")"
if [[ "${dec_ev}" == failed && "${ev_reason}" == *event_count_only* ]]; then
    pass "event_count-only success forbidden (${ev_reason})"
else
    fail "event_count-only should fail got ${dec_ev} ${ev_reason}"
fi

# --- wrong base domain rejected ---
init_event_store
printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_DGA_EVENTS}"
for ((i = 1; i <= 350; i++)); do
    printf '2020-01-01T00:00:00Z\ttest\tDGA\tdga_model_client\tsystem\tquery\tdomain\tnxdomain\t0\trnd%04d.test.invalid|A|nx|invalid\tlocal\n' "${i}" >> "${EVENT_DGA_EVENTS}"
done
for ((i = 1; i <= 15; i++)); do
    printf '2020-01-01T00:00:00Z\ttest\tDGA\tdga_model_client\tsystem\tquery\tdomain\tresponse\t0\trnd%04d.live.test.invalid|A|res|invalid\tlocal\n' "${i}" >> "${EVENT_DGA_EVENTS}"
done
wrong_sum=$(build_module_summary_from_events "DGA_SIMULATION")
read -r dec_wrong wr_reason <<< "$(validate_module_from_summary "DGA_SIMULATION" "${wrong_sum}" "dga_model_client")"
if [[ "${dec_wrong}" == failed && "${wr_reason}" == *wrong_base_domain* ]]; then
    pass "wrong base domain rejected"
else
    fail "wrong base domain should fail got ${dec_wrong} ${wr_reason}"
fi

# --- finalize stage judgment ---
init_event_store
net_sim_dga_dry_run_events
finalize_dga_simulation_stage_judgment "DGA Simulation" "test "
if [[ "${DGA_FINAL_RESULT:-}" == success && "${DGA_STAGE_STATUS}" == Success ]]; then
    pass "finalize_dga_model success"
else
    fail "finalize expected success got ${DGA_FINAL_RESULT:-} status=${DGA_STAGE_STATUS:-}"
fi

rm -rf "${LOCAL_STATE_DIR}"
if (( failures > 0 )); then
    printf '\n%d test(s) failed\n' "${failures}"
    exit 1
fi
printf '\nAll DGA model client tests passed\n'
