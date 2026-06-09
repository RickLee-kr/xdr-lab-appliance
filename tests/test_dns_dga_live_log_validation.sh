#!/usr/bin/env bash
# test_dns_dga_live_log_validation.sh — fixture-based live log judgment checks (no webshell required)
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURE_DIR="${ROOT}/tests/fixtures/live_logs"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

# Minimal env to source stellar_poc (includes followup helpers)
export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_live_log_test_$$"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="221.139.249.0/24"
export NETWORK_PREFIX="221.139.249"
export REMOTE_RUNTIME_DIR="/tmp/.poc_runtime_test"
export CAMPAIGN_ID="live-log-fixture"
export ATTACKER_BASE_URL="http://127.0.0.1:5000"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"
mkdir -p "${EFFECTIVE_REPORT_DIR}" "${LOG_DIR}"
export STOP_REQUESTED=false
export HAS_bash=true
export WEBSHELL_CMD_STYLE=raw

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_live_log_test_$$"
EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
REPORT_DIR="${LOCAL_STATE_DIR}/report"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" "${EFFECTIVE_REPORT_DIR}" "${LOG_DIR}"
DRY_RUN=true

validate_fixture() {
    local label="$1" fn="$2" fixture="$3" expect_rc="${4:-0}"
    local err=""
    if "${fn}" "${fixture}" err; then
        rc=0
    else
        rc=$?
    fi
    if (( rc == expect_rc )); then
        pass "${label} (${err:-ok})"
    else
        fail "${label} rc=${rc} expect=${expect_rc} err=${err:-none}"
    fi
}

validate_fixture "dns_tunnel partial chunk15 LOW likelihood" poc_validate_dns_tunnel_live_log \
    "${FIXTURE_DIR}/dns_tunnel_success_chunk15.log" 0

validate_fixture "dns_tunnel detection success HIGH" poc_validate_dns_tunnel_live_log \
    "${FIXTURE_DIR}/dns_tunnel_detection_success.log" 0

validate_fixture "dns_tunnel zero stats failed" poc_validate_dns_tunnel_live_log \
    "${FIXTURE_DIR}/dns_tunnel_zero_stats_failed.log" 0

validate_fixture "dns_tunnel unique_zero failed" poc_validate_dns_tunnel_live_log \
    "${FIXTURE_DIR}/dns_tunnel_unique_zero_failed.log" 0

validate_fixture "dga chunk15 partial (nx=15)" poc_validate_dga_live_log \
    "${FIXTURE_DIR}/dga_success_chunk15.log" 0

validate_fixture "dga zero nxdomain failed" poc_validate_dga_live_log \
    "${FIXTURE_DIR}/dga_zero_nxdomain_failed.log" 0

validate_fixture "dga zero queries failed" poc_validate_dga_live_log \
    "${FIXTURE_DIR}/dga_zero_queries_failed.log" 0

# Negative: fabricated Success with zero stats must fail validation
bad_dns="${LOCAL_STATE_DIR}/bad_dns_success_zero.log"
cat > "${bad_dns}" <<'EOF'
DNS_PAYLOAD_TRANSPORT context=simulation_once payload_bytes=1000 webshell_method=GET limit=4000 planned=15
DNS_TUNNEL_SIM_STATS attempted=0 planned=15 unique=0 success=0 fail=0 nx=0 resolved=0 timeout=0 error=0 a=0 txt=0 avg_fqdn=32 max_fqdn=64 entropy=0 mode=auto server=10.10.10.5 tool=dig campaign=x ex1= ex2= ex3=
DNS_TUNNEL_STATISTICS queries=0 unique_queries=0 average_length=0 entropy_score=0 txt_queries=0 a_queries=0 nxdomain=0 resolved=0 detection_likelihood=LOW
DNS_TUNNEL_FINAL_SUMMARY planned=15 attempted=0 unique_queries=0 nxdomain=0 query_generated=0 query_sent=0 query_responded=0 actual_dns_queries=0 actual_txt_queries=0 actual_nxdomain=0 payload_bytes=1000 webshell_method=GET result=success
Stage result: DNS Tunnel = Success — attempted=0 unique=0
EOF
validate_fixture "dns_tunnel false success rejected" poc_validate_dns_tunnel_live_log "${bad_dns}" 1

bad_dga="${LOCAL_STATE_DIR}/bad_dga_success_zero.log"
cat > "${bad_dga}" <<'EOF'
DGA_PAYLOAD_TRANSPORT chunk=1/1 payload_bytes=2000 webshell_method=GET limit=4000
DGA_NX_CHUNK_SUMMARY chunk=1 queries=0 nxdomain=0 timeout=0 error=0
DGA_STAGE_FINAL_SUMMARY stage=DGA Simulation status=Success planned=150 queries=0 nxdomain=0 resolved=0 query_generated=0 query_sent=0 query_responded=0 actual_dns_queries=0 actual_random_domains=0 actual_nxdomain=0 payload_bytes=2000 webshell_method=GET result=success
Stage result: DGA Simulation = Success — queries=0 nx=0
EOF
validate_fixture "dga false success rejected" poc_validate_dga_live_log "${bad_dga}" 1

# ROOT_CAUSE classification from log-style samples
dga_cmd=$(build_dga_simulation_remote_cmd "10.10.10.5" "com" 15 0 dig no 1 yes)
dns_cmd=$(build_dns_tunnel_simulation_remote_cmd 15 "10.10.10.5" "lab.invalid" auto 50 100 dig "fixture" yes)

if poc_validate_root_cause_log_sample "DGA" "${dga_cmd}" $'rand_bytes: command not found\n' function_scope_corruption; then
    pass "ROOT_CAUSE rand_bytes -> function_scope_corruption"
else
    fail "ROOT_CAUSE rand_bytes classification"
fi

if poc_validate_root_cause_log_sample "DGA" "${dga_cmd}" $'dga_gen_domain: not found\n' function_scope_corruption; then
    pass "ROOT_CAUSE dga_gen_domain -> function_scope_corruption"
else
    fail "ROOT_CAUSE dga_gen_domain classification"
fi

if poc_validate_root_cause_log_sample "DNS" "${dns_cmd}" $'here-document delimiter must be alone on a line\n' heredoc_termination_corruption; then
    pass "ROOT_CAUSE here-document -> heredoc_termination_corruption"
else
    fail "ROOT_CAUSE here-document classification"
fi

if poc_validate_root_cause_log_sample "DNS" "${dns_cmd}" $'bash: line 42: syntax error: unexpected end of file\n' heredoc_termination_corruption; then
    pass "ROOT_CAUSE unexpected EOF -> heredoc_termination_corruption"
else
    fail "ROOT_CAUSE unexpected EOF classification"
fi

if poc_validate_root_cause_log_sample "DNS" "${dns_cmd}" $'command timed out\n' COMMAND_TIMEOUT 000; then
    pass "ROOT_CAUSE command timed out -> COMMAND_TIMEOUT"
else
    fail "ROOT_CAUSE command timeout classification"
fi

if poc_validate_root_cause_log_sample "DNS" "${dns_cmd}" "" webshell_transport_limit 000; then
    pass "ROOT_CAUSE HTTP 000 empty -> webshell_transport_limit"
else
    fail "ROOT_CAUSE HTTP 000 classification"
fi

# Simulate live pipeline: ingest fixture lines into globals and verify finalize never Success on zero
ingest_dns_from_fixture() {
    local f="$1"
    local line final=""
    final=$(grep 'DNS_TUNNEL_FINAL_SUMMARY' "${f}" | tail -n1)
    DNS_QUERIES_PLANNED=$(safe_int "$(dns_stats_field_from_line "${final}" planned)")
    DNS_QUERIES_ATTEMPTED=$(safe_int "$(dns_stats_field_from_line "${final}" attempted)")
    DNS_TUNNEL_UNIQUE_QUERIES=$(safe_int "$(dns_stats_field_from_line "${final}" unique_queries)")
    DNS_TUNNEL_NXDOMAIN_COUNT=$(safe_int "$(dns_stats_field_from_line "${final}" nxdomain)")
    DNS_TUNNEL_LAST_PAYLOAD_BYTES=$(safe_int "$(dns_stats_field_from_line "${final}" payload_bytes)")
    DNS_TUNNEL_LAST_WEBSHELL_METHOD=$(dns_stats_field_from_line "${final}" webshell_method)
    DNS_TUNNEL_ENH_ATTEMPTED=0
    DNS_TUNNEL_FB_ATTEMPTED=0
}

ingest_dga_from_fixture() {
    local f="$1"
    local line=""
    line=$(grep 'DGA_STAGE_FINAL_SUMMARY' "${f}" | tail -n1)
    DGA_TOTAL_QUERIES=$(safe_int "$(dns_stats_field_from_line "${line}" queries)")
    DGA_NXDOMAIN_COUNT=$(safe_int "$(dns_stats_field_from_line "${line}" nxdomain)")
    DGA_RESOLVED_COUNT=$(safe_int "$(dns_stats_field_from_line "${line}" resolved)")
    DGA_LAST_PAYLOAD_BYTES=$(safe_int "$(dns_stats_field_from_line "${line}" payload_bytes)")
    DGA_LAST_WEBSHELL_METHOD=$(dns_stats_field_from_line "${line}" webshell_method)
    DGA_STAGE_STATUS=Success
    DGA_SIMULATION_ENABLED=true
}

ingest_dns_from_fixture "${FIXTURE_DIR}/dns_tunnel_zero_stats_failed.log"
if ! finalize_dns_tunnel_stage_judgment "DNS Tunnel Fixture" "fixture " && [[ "${DNS_TUNNEL_STAGE_STATUS}" == failed ]]; then
    pass "finalize_dns from zero-stats fixture -> Failed"
else
    fail "finalize_dns from zero-stats fixture (status=${DNS_TUNNEL_STAGE_STATUS})"
fi

ingest_dga_from_fixture "${FIXTURE_DIR}/dga_zero_nxdomain_failed.log"
finalize_dga_simulation_stage_judgment "DGA Simulation Fixture" "fixture "
if [[ "${DGA_STAGE_STATUS}" == Failed ]]; then
    pass "finalize_dga from zero-nx fixture -> Failed"
else
    fail "finalize_dga from zero-nx fixture (status=${DGA_STAGE_STATUS})"
fi

rm -rf "${LOCAL_STATE_DIR}"

# --- Auto-collect path (simulates live run log bundle) ---
auto_dir="$(mktemp -d)"
export LOG_DIR="${auto_dir}/logs"
export LOCAL_STATE_DIR="${auto_dir}/state"
mkdir -p "${LOG_DIR}" "${LOCAL_STATE_DIR}"
cp "${FIXTURE_DIR}/dns_tunnel_detection_success.log" "${LOG_DIR}/dns_tunnel_waves.log"
grep 'Stage result: DNS Tunnel' "${FIXTURE_DIR}/dns_tunnel_detection_success.log" | tail -n1 | \
    sed 's/Stage result: DNS Tunnel = \(.*\) — \(.*\)/DNS Tunnel: \1 | Reason: \2/' > "${LOCAL_STATE_DIR}/stage_results.log"
dns_bundle=$(poc_collect_dns_tunnel_live_log)
if poc_validate_dns_tunnel_live_log "${dns_bundle}" auto_dns_err; then
    pass "auto-collect dns_tunnel live log validation (${auto_dns_err})"
else
    fail "auto-collect dns_tunnel live log validation (${auto_dns_err})"
fi
DNS_TUNNEL_STAGE_STATUS="success"
DRY_RUN=false
if poc_run_dns_tunnel_live_log_validation >/dev/null 2>&1; then
    [[ "${DNS_LIVE_LOG_VALIDATION}" == passed ]] && pass "poc_run_dns_tunnel_live_log_validation passed" || fail "DNS_LIVE_LOG_VALIDATION=${DNS_LIVE_LOG_VALIDATION}"
else
    fail "poc_run_dns_tunnel_live_log_validation should pass on success fixture"
fi

export LOG_DIR="${auto_dir}/logs_dga"
export LOCAL_STATE_DIR="${auto_dir}/state_dga"
mkdir -p "${LOG_DIR}" "${LOCAL_STATE_DIR}"
cp "${FIXTURE_DIR}/dga_success_chunk15.log" "${LOG_DIR}/dga_simulation.log"
grep 'Stage result: DGA Simulation' "${FIXTURE_DIR}/dga_success_chunk15.log" | tail -n1 | \
    sed 's/Stage result: DGA Simulation = \(.*\) — \(.*\)/DGA Simulation: \1 | Reason: \2/' > "${LOCAL_STATE_DIR}/stage_results.log"
dga_bundle=$(poc_collect_dga_live_log)
if poc_validate_dga_live_log "${dga_bundle}" auto_dga_err; then
    pass "auto-collect dga live log validation (${auto_dga_err})"
else
    fail "auto-collect dga live log validation (${auto_dga_err})"
fi
DGA_STAGE_STATUS="Partial"
DGA_SIMULATION_ENABLED=true
DRY_RUN=false
if poc_run_dga_live_log_validation >/dev/null 2>&1; then
    [[ "${DGA_LIVE_LOG_VALIDATION}" == passed ]] && pass "poc_run_dga_live_log_validation passed" || fail "DGA_LIVE_LOG_VALIDATION=${DGA_LIVE_LOG_VALIDATION}"
else
    fail "poc_run_dga_live_log_validation should pass on success fixture"
fi

rm -rf "${auto_dir}"

echo "---"
if (( failures == 0 )); then
    echo "All live log fixture checks passed."
    exit 0
fi
echo "${failures} live log fixture check(s) failed."
exit 1
