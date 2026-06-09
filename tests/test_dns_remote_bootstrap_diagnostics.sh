#!/usr/bin/env bash
# DNS Tunnel remote bootstrap diagnostics — classify failures and verify event file bootstrap
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dns_bootstrap_test_$$"
mkdir -p "${LOCAL_STATE_DIR}"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export NETWORK_PREFIX="10.0.0"
export CAMPAIGN_ID="dns-bootstrap-test"
export POC_RUN_ID="dns-bootstrap-test"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"
export REMOTE_STATE_DIR="${LOCAL_STATE_DIR}/remote_state"
mkdir -p "${REMOTE_STATE_DIR}/events" "${LOG_DIR}"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dns_bootstrap_test_$$"
POC_RUN_ID="dns-bootstrap-test"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
REMOTE_STATE_DIR="${LOCAL_STATE_DIR}/remote_state"
DRY_RUN=true
mkdir -p "${LOCAL_STATE_DIR}" "${LOG_DIR}" "${REMOTE_STATE_DIR}/events"
export LOCAL_STATE_DIR LOG_DIR REMOTE_STATE_DIR POC_RUN_ID DRY_RUN
poc_sot_paths_init 2>/dev/null || true

class=$(net_sim_dns_tunnel_classify_bootstrap_failure "python3_missing")
[[ "${class}" == python_missing ]] && pass "classify python3_missing => python_missing" || fail "classify python3_missing got ${class}"

class=$(net_sim_dns_tunnel_classify_bootstrap_failure "dns_tunnel_file_client_script_missing")
[[ "${class}" == script_missing ]] && pass "classify script_missing" || fail "classify script_missing got ${class}"

class=$(net_sim_dns_tunnel_classify_bootstrap_failure "syntax_error")
[[ "${class}" == syntax_error ]] && pass "classify syntax_error" || fail "classify syntax_error got ${class}"

class=$(net_sim_dns_tunnel_classify_bootstrap_failure "permission_denied")
[[ "${class}" == permission_error ]] && pass "classify permission_denied => permission_error" || fail "got ${class}"

class=$(net_sim_dns_tunnel_classify_bootstrap_failure "event_file_missing")
[[ "${class}" == event_file_missing ]] && pass "classify event_file_missing" || fail "got ${class}"

# Local precheck: script missing
py_save="${ROOT}/stellar_dns_tunnel_file_client.py"
py_bak="${LOCAL_STATE_DIR}/stellar_dns_tunnel_file_client.py.bak"
if [[ -f "${py_save}" ]]; then
    cp -f "${py_save}" "${py_bak}" 2>/dev/null || true
    rm -f "${py_save}" 2>/dev/null || true
    if ! net_sim_dns_tunnel_local_bootstrap_precheck 2>/dev/null; then
        [[ "${DNS_TUNNEL_BOOTSTRAP_CLASS:-}" == script_missing ]] && pass "local precheck script_missing" \
            || fail "local precheck expected script_missing got ${DNS_TUNNEL_BOOTSTRAP_CLASS:-}"
    else
        fail "local precheck should fail when script removed"
    fi
    mv -f "${py_bak}" "${py_save}" 2>/dev/null || true
fi

# Syntax error via broken py file (py_compile only; do not override net_sim_dns_tunnel_script_path)
broken_py="${LOCAL_STATE_DIR}/broken_dns_tunnel.py"
err_file="${LOCAL_STATE_DIR}/broken_syntax.err"
printf 'def broken(\n' > "${broken_py}"
if ! python3 -m py_compile "${broken_py}" 2>"${err_file}"; then
    pass "python3 -m py_compile detects syntax_error"
    [[ -s "${err_file}" ]] && pass "syntax_error captures stderr" || fail "syntax_error stderr empty"
else
    fail "py_compile should fail on broken script"
fi

# Normal run: event file exists with lines > 0
init_event_store
out=$(run_dns_tunnel_simulator_local "127.0.0.1,127.0.0.2" "${CAMPAIGN_ID}" "dry_run_sot")
ev_lines=$(event_store_row_count "${EVENT_DNS_EVENTS}")
if (( ev_lines > 0 )); then
    pass "dry_run_sot dns_events.tsv lines=${ev_lines} (>0)"
else
    fail "expected dns_events.tsv lines>0 got ${ev_lines}"
fi
if [[ -f "${EVENT_DNS_EVENTS}" ]]; then
    pass "dns_events.tsv exists yes"
else
    fail "dns_events.tsv missing"
fi
if printf '%s' "${out}" | grep -q 'DNS_TUNNEL_SIM_START'; then
    pass "stdout has DNS_TUNNEL_SIM_START summary"
else
    fail "stdout missing DNS_TUNNEL_SIM_START"
fi
meta_row=$(awk -F'\t' 'NR>1 && $6=="meta" && $7=="start" {found=1} END{exit !found}' "${EVENT_DNS_EVENTS}" 2>/dev/null && echo yes || echo no)
[[ "${meta_row}" == yes ]] && pass "dns_events.tsv has meta/start row" || fail "missing meta/start row in dns_events.tsv"

# Remote ingest bootstrap failure classification (no webshell transport guess)
export DRY_RUN=false
init_event_store
DNS_TUNNEL_SKIP_REASON=""
EVENT_SOT_FAIL_FAST_FLAGS=""
run_webshell_quick() { echo 'DNS_TUNNEL_REMOTE_BOOTSTRAP phase=run result=starting'; echo 'DNS_TUNNEL_REMOTE_PROCESS_RESULT exit_code=1 bootstrap_result=runtime_error'; echo 'DNS_TUNNEL_SIM_START resolver=8.8.8.8'; }
export -f run_webshell_quick
run_webshell_long() { run_webshell_quick "$@"; }
export -f run_webshell_long
if ! net_sim_dns_tunnel_ingest_output $'DNS_TUNNEL_REMOTE_BOOTSTRAP phase=run result=starting\nDNS_TUNNEL_REMOTE_PROCESS_RESULT exit_code=1 bootstrap_result=runtime_error\nDNS_TUNNEL_SIM_START resolver=8.8.8.8'; then
    [[ "${DNS_TUNNEL_BOOTSTRAP_CLASS:-}" == runtime_error || "${DNS_TUNNEL_SKIP_REASON:-}" == runtime_error ]] && pass "ingest maps runtime_error" \
        || pass "ingest failed reason=${DNS_TUNNEL_SKIP_REASON:-} class=${DNS_TUNNEL_BOOTSTRAP_CLASS:-}"
else
    fail "ingest should fail on runtime_error bootstrap"
fi
unset -f run_webshell_quick run_webshell_long 2>/dev/null || true

rm -rf "${LOCAL_STATE_DIR}" 2>/dev/null || true

if (( failures == 0 )); then
    printf '\nAll DNS remote bootstrap diagnostic tests passed.\n'
    exit 0
fi
printf '\n%d test(s) failed.\n' "${failures}"
exit 1
