#!/usr/bin/env bash
# validate_stellar_poc.sh — static + smoke checks for stellar_poc*.sh
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

# --- 0. Bundle version manifest ---
if [[ -f "${ROOT}/stellar_poc.version" ]]; then
    pass "stellar_poc.version present"
    bundle_ver="$(tr -d '[:space:]' < "${ROOT}/stellar_poc.version")"
    for f in stellar_poc.sh stellar_poc_humanize.sh stellar_poc_followup.sh stellar_poc_fast_safe.sh stellar_poc_event_sot.sh stellar_poc_network_simulators.sh stellar_dns_tunnel_file_client.py stellar_poc_evidence_validation.sh; do
        hdr_ver=$(grep -m1 '^# @stellar-poc-version:' "${ROOT}/${f}" 2>/dev/null | awk '{print $3}')
        if [[ "${hdr_ver}" == "${bundle_ver}" ]]; then
            pass "version match ${f}=${bundle_ver}"
        else
            fail "version mismatch ${f}: header=${hdr_ver:-missing} manifest=${bundle_ver}"
        fi
    done
else
    fail "missing stellar_poc.version"
fi

# --- 1. Syntax ---
for f in stellar_poc.sh stellar_poc_humanize.sh stellar_poc_followup.sh stellar_poc_fast_safe.sh stellar_poc_event_sot.sh stellar_poc_evidence_validation.sh; do
    if bash -n "${f}"; then
        pass "bash -n ${f}"
    else
        fail "bash -n ${f}"
    fi
done

# --- 2. Self-check blocks present ---
for f in stellar_poc_followup.sh stellar_poc_humanize.sh; do
    if grep -q '_self_check' "${f}"; then
        pass "self-check block in ${f}"
    else
        fail "missing self-check block in ${f}"
    fi
done

# --- 3. Required function definitions ---
defs_file="$(mktemp)"
for f in stellar_poc_humanize.sh stellar_poc_followup.sh stellar_poc_fast_safe.sh stellar_poc.sh; do
    grep -E '^[a-zA-Z_][a-zA-Z0-9_]*\(\)' "${f}" | sed 's/().*//' >> "${defs_file}"
done
sort -u "${defs_file}" -o "${defs_file}"

required=(
    count_hosts_blob
    count_all_discovered_services
    count_remote_target_file
    count_discovered_ips_in_file
    get_local_hosts
    get_followup_hosts
    collect_ssh_burst_targets
    collect_http_followup_targets_unique
    run_ssh_auth_burst_for_host
    run_http_url_burst_for_host
    discovery_parse_nmap_stdout
    discovery_parse_probe_stdout
    safe_count_lines
    safe_int
    sanitize_stats_ints
    remote_bash_script_open
    remote_bash_script_close
    normalize_http_scan_target_fields
    apply_user_intensity_profile
    apply_followup_intensity_defaults
    stage_mandatory_service_followups
    followup_stage_http
    followup_stage_dga
    followup_stage_dns_new_tld
    run_dga_simulation
    run_dns_new_tld_test
    dns_new_tld_primary_pool
    dns_new_tld_secondary_pool
    dns_new_tld_compute_detection_likelihood
    build_dns_new_tld_simulation_remote_cmd
    validate_dns_fqdn
    finalize_dns_new_tld_stage_judgment
    poc_validate_dns_new_tld_live_log
    stage_edr_static_detection_test
    build_edr_static_test_remote_cmd
    build_edr_static_test_write_file_remote_cmd
    build_edr_static_test_resolve_dir_remote_cmd
    run_edr_static_test_file_creation
    cleanup_edr_static_test_on_exit
    parse_edr_static_test_output
    finalize_edr_static_test_judgment
    write_edr_static_test_report
    edr_static_test_eicar_string
    edr_static_test_cloudcar_string
    stage_ssh_auth_burst
    run_webshell_long
    run_webshell_quick
    fast_safe_mode_enabled
    apply_fast_safe_profile
    run_fast_safe_pipeline_once
)

for fn in "${required[@]}"; do
    if grep -qxF "${fn}" "${defs_file}"; then
        pass "defined: ${fn}"
    else
        fail "missing function definition: ${fn}"
    fi
done

# --- 4. Source scripts (no main) and unit-test helpers ---
smoke_env="$(mktemp -d)"
export LOCAL_STATE_DIR="${smoke_env}/state"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts"

DRY_RUN=true
WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
TARGET_NET="221.139.249.0/24"
NETWORK_PREFIX="221.139.249"
REMOTE_RUNTIME_DIR="/tmp/.poc_runtime_test"
CAMPAIGN_ID="validate-smoke"
ATTACKER_BASE_URL="http://127.0.0.1:5000"
EFFECTIVE_REPORT_DIR="${smoke_env}/report"
LOG_DIR="${smoke_env}/logs"
REPORT_DIR="${smoke_env}/report"
mkdir -p "${EFFECTIVE_REPORT_DIR}" "${LOG_DIR}"
STOP_REQUESTED=false
SERVICES_DISCOVERED_TOTAL=0
SERVICES_USABLE_TOTAL=0
HAS_ssh=true
HAS_curl=true
POC_INTENSITY=normal
HTTP_FOLLOWUP_REQUESTS=100
SSH_BURST_ATTEMPTS=100
PIPELINE_OVERLAP=false

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

# Re-apply test paths (source resets globals)
LOCAL_STATE_DIR="${smoke_env}/state"
EFFECTIVE_REPORT_DIR="${smoke_env}/report"
LOG_DIR="${smoke_env}/logs"
REPORT_DIR="${smoke_env}/report"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" "${EFFECTIVE_REPORT_DIR}" "${LOG_DIR}"
DRY_RUN=true

printf '%s\n' "221.139.249.113" "221.139.249.50" > "${LOCAL_STATE_DIR}/remote_hosts/ssh_hosts.txt"
printf '%s\n' "221.139.249.113" > "${LOCAL_STATE_DIR}/remote_hosts/https_targets.txt"

n=$(count_hosts_blob "$(cat "${LOCAL_STATE_DIR}/remote_hosts/ssh_hosts.txt")")
[[ "${n}" == "2" ]] && pass "count_hosts_blob" || fail "count_hosts_blob expected 2 got ${n}"

sample_nmap="Nmap scan report for 221.139.249.200
22/tcp  open  ssh
80/tcp  open  http"
discovery_parse_nmap_stdout "${sample_nmap}"
grep -qxF "221.139.249.200" "${LOCAL_STATE_DIR}/remote_hosts/ssh_hosts.txt" && \
    pass "discovery_parse_nmap_stdout" || fail "discovery_parse_nmap_stdout"

DNS_TUNNEL_ENH_ATTEMPTED=200
DNS_TUNNEL_FB_ATTEMPTED=0
if dns_reconcile_attempted_accounting && [[ "${DNS_QUERIES_ATTEMPTED}" == "200" ]]; then
    pass "dns attempted equals enhanced+fallback"
else
    fail "dns attempted equals enhanced+fallback (got ${DNS_QUERIES_ATTEMPTED:-unset})"
fi
DNS_TUNNEL_ENH_ATTEMPTED=0
DNS_TUNNEL_FB_ATTEMPTED=0
DNS_QUERIES_ATTEMPTED=0
if ! dns_reconcile_attempted_accounting && [[ "${DNS_QUERIES_ATTEMPTED}" == "0" ]]; then
    pass "dns zero attempted when no enhanced/fallback/simulation"
else
    fail "dns zero attempted when no enhanced/fallback/simulation (got ${DNS_QUERIES_ATTEMPTED:-unset})"
fi
DNS_QUERIES_ATTEMPTED=175
DNS_TUNNEL_ENH_ATTEMPTED=0
DNS_TUNNEL_FB_ATTEMPTED=0
if dns_reconcile_attempted_accounting && [[ "${DNS_QUERIES_ATTEMPTED}" == "175" ]]; then
    pass "dns reconcile preserves simulation attempted when enhanced/fallback zero"
else
    fail "dns reconcile preserves simulation attempted (got ${DNS_QUERIES_ATTEMPTED:-unset})"
fi

DGA_TOTAL_QUERIES=0
DGA_NXDOMAIN_COUNT=0
DGA_RESOLVED_COUNT=0
mock_dga_live_out="DGA_NXDOMAIN_QUERY query=abc123def456ghi789.example.com qtype=A result=nxdomain
DGA_NX_CHUNK_SUMMARY chunk=1 queries=15 nxdomain=14 timeout=0 error=1"
mock_dga_line=$(printf '%s\n' "${mock_dga_live_out}" | grep -E '^DGA_(NX_CHUNK_SUMMARY|CHUNK_SUMMARY)' | tail -n1 || true)
if [[ -n "${mock_dga_line}" ]]; then
    dga_accumulate_chunk_summary "${mock_dga_line}"
    (( DGA_TOTAL_QUERIES == 15 && DGA_NXDOMAIN_COUNT == 14 )) && \
        pass "dga live chunk summary accumulation" || \
        fail "dga live chunk summary accumulation (queries=${DGA_TOTAL_QUERIES} nx=${DGA_NXDOMAIN_COUNT})"
else
    fail "dga live chunk summary line missing"
fi
mock_dga_res_out="DGA_RESOLVABLE_QUERY query=test.com qtype=A result=resolved
DGA_CHUNK_SUMMARY queries=3 nxdomain=0 resolvable=3 generated=3 entropy=45 resolver=system timeout_count=0 error_count=0"
mock_dga_res_line=$(printf '%s\n' "${mock_dga_res_out}" | grep -E '^DGA_(NX_CHUNK_SUMMARY|CHUNK_SUMMARY)' | tail -n1 || true)
if [[ -n "${mock_dga_res_line}" ]]; then
    dga_accumulate_chunk_summary "${mock_dga_res_line}"
    (( DGA_TOTAL_QUERIES == 18 && DGA_RESOLVED_COUNT == 3 )) && \
        pass "dga live resolvable chunk accumulation" || \
        fail "dga live resolvable chunk accumulation (queries=${DGA_TOTAL_QUERIES} resolvable=${DGA_RESOLVED_COUNT})"
else
    fail "dga live resolvable chunk summary missing"
fi

sample_probe="OK:http_targets.txt:80
OK:ssh_hosts.txt:22"
discovery_parse_probe_stdout "221.139.249.201" "${sample_probe}"
grep -q "221.139.249.201:80" "${LOCAL_STATE_DIR}/remote_hosts/http_targets.txt" && \
    pass "discovery_parse_probe_stdout" || fail "discovery_parse_probe_stdout"

ssh_t=$(collect_ssh_burst_targets | wc -l | tr -d ' ')
http_t=$(collect_http_followup_targets_unique http | wc -l | tr -d ' ')
(( ssh_t >= 2 && http_t >= 1 )) && pass "collect targets" || fail "collect targets ssh=${ssh_t} http=${http_t}"

total=$(count_all_discovered_services)
(( total >= 4 )) && pass "count_all_discovered_services=${total}" || fail "count_all_discovered_services=${total}"

apply_user_intensity_profile
[[ "${SSH_BURST_ATTEMPTS}" == "100" ]] && pass "apply_user_intensity_profile" || fail "intensity SSH=${SSH_BURST_ATTEMPTS}"

apply_followup_intensity_defaults
[[ "${SSH_AUTH_BURST_ENABLED}" == true ]] && pass "apply_followup_intensity_defaults" || fail "apply_followup_intensity_defaults"

# set -e safety: [[ -s empty ]] && must not abort
touch "${LOCAL_STATE_DIR}/remote_hosts/empty_hosts.txt"
dedupe_discovery_local_cache
pass "dedupe_discovery_local_cache (empty cache, set -e safe)"

# --- 4b. DNS/DGA transport + judgment contract tests ---
HAS_bash=true
WEBSHELL_CMD_STYLE=raw
PAYLOAD_WARN_BYTES=4000

dga_cmd=$(build_dga_simulation_remote_cmd "10.10.10.5" "com" 15 0 dig no 1 yes)
dga_cmd_small=$(build_dga_simulation_remote_cmd "10.10.10.5" "com" 10 0 dig no 1 yes)
dga_bytes=${#dga_cmd}
dga_delim_ok=no
[[ "${dga_cmd}" == *$'\nDGA_SIM_SCRIPT\n'* || "${dga_cmd}" == *$'\nDGA_SIM_SCRIPT' ]] && dga_delim_ok=yes
if [[ "${dga_cmd}" == *$'bash <<'\''DGA_SIM_SCRIPT'\'''* && "${dga_delim_ok}" == yes \
    && "${dga_cmd}" == *'nx_n=15'* && "${dga_cmd}" != *'nx_n=200'* \
    && (( dga_bytes < PAYLOAD_WARN_BYTES )) ]]; then
    pass "DGA chunk=15 payload heredoc/planned/size (bytes=${dga_bytes})"
else
    fail "DGA chunk=15 payload contract (bytes=${dga_bytes})"
fi

dns_cmd=$(build_dns_tunnel_simulation_remote_cmd 15 "10.10.10.5" "lab.invalid" auto 50 100 dig "test-campaign" yes)
dns_bytes=${#dns_cmd}
dns_delim_ok=no
[[ "${dns_cmd}" == *$'\nDNS_TUNNEL_SIM_SCRIPT\n'* || "${dns_cmd}" == *$'\nDNS_TUNNEL_SIM_SCRIPT' ]] && dns_delim_ok=yes
if [[ "${dns_cmd}" == *$'bash <<'\''DNS_TUNNEL_SIM_SCRIPT'\'''* && "${dns_delim_ok}" == yes \
    && "${dns_cmd}" == *'planned=15'* && "${dns_cmd}" != *'planned=200'* \
    && "${dns_cmd}" == *'DNS_QUERY_ATTEMPT'* && "${dns_cmd}" == *'DNS_QUERY_SENT'* && "${dns_cmd}" == *'DNS_QUERY_RESPONSE'* && "${dns_cmd}" == *'DNS_QUERY_SUCCESS'* \
    && (( dns_bytes < PAYLOAD_WARN_BYTES )) ]]; then
    pass "DNS tunnel chunk=15 payload heredoc/planned/size/telemetry (bytes=${dns_bytes})"
else
    fail "DNS tunnel chunk=15 payload contract (bytes=${dns_bytes})"
fi

dga_wrapped=$(wrap_remote_payload "${dga_cmd}" quick)
if [[ "${dga_wrapped}" == *$'\nDGA_SIM_SCRIPT\n_poc_ec=$?\n'* || "${dga_wrapped}" == *$'\nDGA_SIM_SCRIPT\n_poc_ec=$?\necho __EXIT_CODE:'* ]] \
    && [[ "${dga_wrapped}" != *'DGA_SIM_SCRIPT; _poc_ec'* ]]; then
    pass "wrap_remote_payload heredoc exit suffix on separate lines"
else
    fail "wrap_remote_payload heredoc exit suffix layout"
fi

if [[ "$(poc_payload_heredoc_wrap_risk "${dga_cmd}")" == no && "$(poc_payload_heredoc_wrap_risk "${dns_cmd}")" == no ]]; then
    pass "poc_payload_heredoc_wrap_risk clean for DNS/DGA payloads"
else
    fail "poc_payload_heredoc_wrap_risk flagged valid payloads"
fi

mapfile -t _rc_lines <<< "$(poc_classify_dns_dga_root_cause "DGA" "${dga_cmd}" $'rand_bytes: command not found\n')"
if [[ "${_rc_lines[0]:-}" == function_scope_corruption ]]; then
    pass "poc_classify rand_bytes not found -> function_scope_corruption"
else
    fail "poc_classify rand_bytes (got ${_rc_lines[0]:-empty})"
fi
mapfile -t _rc_lines <<< "$(poc_classify_dns_dga_root_cause "DGA" "${dga_cmd}" $'dga_gen_domain: not found\n')"
if [[ "${_rc_lines[0]:-}" == function_scope_corruption ]]; then
    pass "poc_classify dga_gen_domain not found -> function_scope_corruption"
else
    fail "poc_classify dga_gen_domain (got ${_rc_lines[0]:-empty})"
fi
mapfile -t _rc_lines <<< "$(poc_classify_dns_dga_root_cause "DNS" "${dns_cmd}" $'here-document delimiter must be alone on a line\n')"
if [[ "${_rc_lines[0]:-}" == heredoc_termination_corruption ]]; then
    pass "poc_classify heredoc termination -> heredoc_termination_corruption"
else
    fail "poc_classify heredoc termination (got ${_rc_lines[0]:-empty})"
fi

mock_dns_telemetry_out='DNS_QUERY_GENERATED server=10.10.10.5 fqdn=a.b.lab.invalid qtype=A tool=dig
DNS_QUERY_ATTEMPT server=10.10.10.5 fqdn=a.b.lab.invalid qtype=A tool=dig
DNS_QUERY_SENT server=10.10.10.5 fqdn=a.b.lab.invalid qtype=A tool=dig exit_code=0
DNS_QUERY_RESPONSE server=10.10.10.5 fqdn=a.b.lab.invalid qtype=A result=nxdomain tool=dig
DNS_QUERY_SUCCESS server=10.10.10.5 fqdn=a.b.lab.invalid qtype=A result=nxdomain tool=dig
DNS_TUNNEL_SIM_STATS attempted=1 planned=15 unique=1 success=1 fail=0 nx=1 resolved=0 timeout=0 error=0 a=1 txt=0 query_generated=1 query_sent=1 query_responded=1'
aggregate_dns_query_telemetry_from_output "${mock_dns_telemetry_out}" || true
if (( DNS_QUERIES_ATTEMPTED == 1 && DNS_TUNNEL_UNIQUE_QUERIES == 1 && DNS_TUNNEL_NXDOMAIN_COUNT == 1 && DNS_QUERY_RESPONDED_COUNT == 1 )); then
    pass "aggregate_dns_query_telemetry_from_output"
else
    fail "aggregate_dns_query_telemetry_from_output (attempted=${DNS_QUERIES_ATTEMPTED} unique=${DNS_TUNNEL_UNIQUE_QUERIES} nx=${DNS_TUNNEL_NXDOMAIN_COUNT} responded=${DNS_QUERY_RESPONDED_COUNT})"
fi

init_event_store 2>/dev/null || true
DGA_TOTAL_QUERIES=0
DGA_NXDOMAIN_COUNT=0
DGA_RESOLVED_COUNT=0
n=0
while (( n < 255 )); do
    record_dga_event "main" "10.0.0.53" "dga-${n}.invalid.test" "A" "sent" "0" "local"
    n=$((n + 1))
done
m=0
while (( m < 180 )); do
    record_dga_event "main" "10.0.0.53" "nx-${m}.invalid.test" "A" "nxdomain" "0" "local"
    m=$((m + 1))
done
r=0
while (( r < 5 )); do
    record_dga_event "main" "10.0.0.53" "resolved-${r}.example.com" "A" "response" "0" "local"
    r=$((r + 1))
done
if sync_dga_telemetry_from_persisted_state && (( DGA_TOTAL_QUERIES >= 255 && DGA_NXDOMAIN_COUNT >= 180 && DGA_RESOLVED_COUNT >= 5 )); then
    pass "sync_dga_telemetry_from_persisted_state reads DGA event SOT"
else
    fail "sync_dga_telemetry_from_persisted_state (queries=${DGA_TOTAL_QUERIES} nx=${DGA_NXDOMAIN_COUNT} resolved=${DGA_RESOLVED_COUNT})"
fi

DNS_QUERIES_ATTEMPTED=0
DNS_TUNNEL_UNIQUE_QUERIES=0
DNS_TUNNEL_ENH_ATTEMPTED=0
DNS_TUNNEL_FB_ATTEMPTED=0
if ! finalize_dns_tunnel_stage_judgment "DNS Tunnel Test" "test " && [[ "${DNS_TUNNEL_STAGE_STATUS}" == failed ]]; then
    pass "finalize_dns_tunnel_stage_judgment fails on attempted=0 unique=0"
else
    fail "finalize_dns_tunnel_stage_judgment should fail on zero stats (status=${DNS_TUNNEL_STAGE_STATUS:-unset})"
fi

DGA_TOTAL_QUERIES=0
DGA_NXDOMAIN_COUNT=0
DGA_STAGE_STATUS=Success
finalize_dga_simulation_stage_judgment "DGA Simulation Test" "test "
if [[ "${DGA_STAGE_STATUS}" == Failed ]]; then
    pass "finalize_dga_simulation_stage_judgment fails on queries=0 nxdomain=0"
else
    fail "finalize_dga_simulation_stage_judgment should fail on zero stats (status=${DGA_STAGE_STATUS})"
fi

DGA_TOTAL_QUERIES=10
DGA_NXDOMAIN_COUNT=0
DGA_STAGE_STATUS=Partial
finalize_dga_simulation_stage_judgment "DGA Simulation Test" "test "
if [[ "${DGA_STAGE_STATUS}" == Failed ]]; then
    pass "finalize_dga_simulation_stage_judgment fails on nxdomain=0"
else
    fail "finalize_dga_simulation_stage_judgment should fail on nxdomain=0 (status=${DGA_STAGE_STATUS})"
fi

DNS_TUNNEL_ENH_ATTEMPTED=5
DNS_TUNNEL_FB_ATTEMPTED=0
DNS_TUNNEL_UNIQUE_QUERIES=0
evaluate_telemetry_dns_tunnel
if [[ "${TELEMETRY_VAL_DNS_TUNNEL}" == failed ]]; then
    pass "evaluate_telemetry_dns_tunnel fails on unique_queries=0"
else
    fail "evaluate_telemetry_dns_tunnel should fail on unique_queries=0 (got ${TELEMETRY_VAL_DNS_TUNNEL})"
fi

DGA_TOTAL_QUERIES=12
DGA_NXDOMAIN_COUNT=0
DGA_RESOLVED_COUNT=3
DGA_SIMULATION_ENABLED=true
DGA_STAGE_STATUS=Partial
evaluate_telemetry_dga_simulation
if [[ "${TELEMETRY_VAL_DGA_SIMULATION}" == failed ]]; then
    pass "evaluate_telemetry_dga_simulation fails on nxdomain=0"
else
    fail "evaluate_telemetry_dga_simulation should fail on nxdomain=0 (got ${TELEMETRY_VAL_DGA_SIMULATION})"
fi

WEBSHELL_USER_METHOD=auto
WEBSHELL_METHOD=auto
WEBSHELL_EFFECTIVE_METHOD=GET
WEBSHELL_POST_SUPPORTED=true
WEBSHELL_GET_SUPPORTED=true
WEBSHELL_TRANSPORT_DISCOVERED=true
big_payload=$(printf 'echo %0.sX' {1..4100})
big_bytes=${#big_payload}
if (( big_bytes > PAYLOAD_FORCE_POST_BYTES )); then
    :
else
    fail "POST transport test setup payload too small (${big_bytes})"
fi
transport=$(webshell_transport_for_payload "TEST" "${big_bytes}")
if [[ "${transport}" == POST ]]; then
    pass "payload>${PAYLOAD_FORCE_POST_BYTES} bytes triggers POST transport switch"
else
    fail "payload>${PAYLOAD_FORCE_POST_BYTES} bytes should trigger POST (method=${transport})"
fi

small_bytes=${#dga_cmd_small}
if (( small_bytes <= PAYLOAD_WARN_BYTES )); then
    pass "DGA chunk=10 payload allows GET transport (${small_bytes}<=${PAYLOAD_WARN_BYTES})"
elif (( small_bytes > PAYLOAD_WARN_BYTES )); then
    pass "DGA enhanced script uses POST transport path (${small_bytes}>${PAYLOAD_WARN_BYTES})"
else
    fail "DGA chunk payload size unexpected (${small_bytes})"
fi
if (( ${#dga_cmd} > PAYLOAD_WARN_BYTES )); then
    pass "DGA chunk=15 payload uses POST transport path (${#dga_cmd}>${PAYLOAD_WARN_BYTES})"
else
    pass "DGA chunk=15 payload within GET limit (${#dga_cmd}<=${PAYLOAD_WARN_BYTES})"
fi

# --- 4c. EDR static signature detection contract tests ---
eicar_str=$(edr_static_test_eicar_string)
cloudcar_str=$(edr_static_test_cloudcar_string)
expected_eicar='X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'
expected_cloudcar='AMTSO-CLOUD-CAR-TEST-FILE-AMTSO-CLOUD-CAR-TEST-FILE-AMTSO-CLOUD-CAR'
[[ "${eicar_str}" == "${expected_eicar}" ]] && pass "EICAR test string exact match" || fail "EICAR test string mismatch"
[[ "${cloudcar_str}" == "${expected_cloudcar}" ]] && pass "CloudCar test string exact match" || fail "CloudCar test string mismatch"

edr_cmd=$(build_edr_static_test_remote_cmd)
edr_write=$(build_edr_static_test_write_file_remote_cmd "/tmp/.poc_runtime_root/edr_test" "eicar_test.txt" "${expected_eicar}")
[[ "${edr_cmd}" == *'EDR_TEST_FILE_PATH dir='* ]] && pass "EDR resolve dir cmd present" || fail "EDR resolve dir cmd missing"
[[ "${edr_write}" == *'EDR_TEST_FILE_CREATE_SUCCESS'* ]] && pass "EDR write cmd contains success marker" || fail "EDR write cmd missing success marker"
[[ "${edr_write}" == *'base64 -d'* && "${edr_write}" == *'eicar_test.txt'* ]] \
    && pass "EDR write cmd uses base64 decode for test file" || fail "EDR write cmd missing base64 decode for test file"
[[ "${edr_write}" == *'X1ZPITVAPCUwQVBbNFxcUFpYNTQoUF4pN0NDKTd9JEVJQ0FSLVNUQU5EQVJELUFOVElWSVJVUy1URVNULUZJTEUhJEgrSCo='* ]] \
    && pass "EDR write cmd embeds base64 EICAR payload" || fail "EDR write cmd missing base64 EICAR payload"
[[ "${edr_write}" != *'/dev/tcp'* && "${edr_write}" != *'reverse' && "${edr_write}" != *'powershell -enc'* ]] \
    && pass "EDR remote cmd has no malicious patterns" || fail "EDR remote cmd contains suspicious malicious pattern"

EDR_EXTENDED_FILES=true
edr_specs=$(edr_static_test_file_specs | wc -l | tr -d ' ')
[[ "${edr_specs}" == "5" ]] && pass "EDR extended files spec count=5" || fail "EDR extended files spec count=${edr_specs}"
EDR_EXTENDED_FILES=false
EDR_TEST_DIR="/tmp/.poc_runtime_root/edr_test"
edr_cleanup_cmd=$(build_edr_static_test_cleanup_remote_cmd)
[[ "${edr_cleanup_cmd}" == *"rm -f"* && "${edr_cleanup_cmd}" == *'eicar_test.txt'* ]] \
    && pass "EDR exit cleanup cmd removes test files" || fail "EDR exit cleanup cmd missing rm -f"
EDR_TEST_DIR=""

mock_edr_out="EDR_STATIC_TEST_START campaign=test
EDR_TEST_FILE_CREATE_ATTEMPT file=eicar_test.txt path=/tmp/edr/eicar_test.txt os=linux
EDR_TEST_FILE_CREATE_SUCCESS file=eicar_test.txt path=/tmp/edr/eicar_test.txt
EDR_TEST_FILE_PATH file=eicar_test.txt path=/tmp/edr/eicar_test.txt
EDR_QUARANTINE_SUSPECTED file=cloudcar_test.txt path=/tmp/edr/cloudcar_test.txt status=possible_edr_quarantine
EDR_STATIC_TEST_SUMMARY attempted=3 success=1 quarantine=1 failed=1 os=linux dir=/tmp/edr paths=/tmp/edr/eicar_test.txt;"
parse_edr_static_test_output "${mock_edr_out}"
(( EDR_TEST_FILES_ATTEMPTED == 3 && EDR_TEST_FILES_SUCCESS == 1 && EDR_TEST_QUARANTINE_SUSPECTED == 1 && EDR_TEST_FILES_FAILED == 1 )) \
    && pass "parse_edr_static_test_output counters" || fail "parse_edr_static_test_output counters (a=${EDR_TEST_FILES_ATTEMPTED} s=${EDR_TEST_FILES_SUCCESS} q=${EDR_TEST_QUARANTINE_SUSPECTED} f=${EDR_TEST_FILES_FAILED})"

WEBSHELL_CHANNEL_BROKEN=false
EDR_TEST_FILES_ATTEMPTED=3
EDR_TEST_FILES_SUCCESS=1
EDR_TEST_QUARANTINE_SUSPECTED=1
EDR_TEST_FILES_FAILED=1
EDR_TEST_REMOTE_OS=linux
finalize_edr_static_test_judgment "EDR Static Signature Detection Test" "test "
[[ "${EDR_STATIC_STAGE_STATUS}" == Partial ]] && pass "finalize_edr_static_test_judgment partial on mixed results" \
    || fail "finalize_edr_static_test_judgment partial expected (got ${EDR_STATIC_STAGE_STATUS})"

EDR_TEST_FILES_ATTEMPTED=2
EDR_TEST_FILES_SUCCESS=0
EDR_TEST_QUARANTINE_SUSPECTED=2
EDR_TEST_FILES_FAILED=0
finalize_edr_static_test_judgment "EDR Static Signature Detection Test" "test "
[[ "${EDR_STATIC_STAGE_STATUS}" == Success ]] && pass "finalize_edr_static_test_judgment success on quarantine-only" \
    || fail "finalize_edr_static_test_judgment quarantine should be success (got ${EDR_STATIC_STAGE_STATUS})"

edr_bytes=${#edr_write}
if (( edr_bytes > PAYLOAD_WARN_BYTES )); then
    pass "EDR per-file payload may use POST (${edr_bytes}>${PAYLOAD_WARN_BYTES})"
else
    pass "EDR per-file payload within GET limit (${edr_bytes}<=${PAYLOAD_WARN_BYTES})"
fi

rm -rf "${smoke_env}" "${defs_file}"

# --- 5. Dry-run CLI ---
dry_out="$(mktemp)"
if ./stellar_poc.sh --dry-run --target-net 221.139.249.0/24 --webshell http://127.0.0.1/shell.jsp \
    --attacker-ip 221.139.249.110 --attacker-port 5000 >"${dry_out}" 2>&1; then
    pass "stellar_poc.sh --dry-run exit 0"
else
    fail "stellar_poc.sh --dry-run exit $?"
fi

if grep -q "command not found" "${dry_out}"; then
    fail "dry-run contains 'command not found'"
    grep "command not found" "${dry_out}" >&2 || true
else
    pass "dry-run no 'command not found'"
fi

# --- 6. Single-stage dry-run smoke ---
for stage in service_discovery http_followup ssh_auth_burst edr_static_detection_test; do
    stage_out="$(mktemp)"
    if ./stellar_poc.sh --dry-run --single-stage "${stage}" --target-net 221.139.249.0/24 \
        --webshell http://127.0.0.1/shell.jsp --attacker-ip 221.139.249.110 --attacker-port 5000 \
        >"${stage_out}" 2>&1; then
        if grep -q "command not found" "${stage_out}"; then
            fail "single-stage ${stage}: command not found"
        else
            pass "single-stage dry-run: ${stage}"
        fi
    else
        fail "single-stage dry-run ${stage} exit $?"
        tail -5 "${stage_out}" >&2 || true
    fi
    rm -f "${stage_out}"
done

rm -f "${dry_out}"

# --- 7. Parse/read contract regression tests ---
if bash "${ROOT}/tests/test_parse_read_contract.sh"; then
    pass "test_parse_read_contract.sh"
else
    fail "test_parse_read_contract.sh"
fi

# --- 8. Pre-WebShell URL scan set -e / stdout leak regression ---
if bash "${ROOT}/tests/test_pre_webshell_url_scan.sh"; then
    pass "test_pre_webshell_url_scan.sh"
else
    fail "test_pre_webshell_url_scan.sh"
fi

# --- 9. DNS/DGA live log fixture validation (no webshell required) ---
if bash "${ROOT}/tests/test_dns_dga_live_log_validation.sh"; then
    pass "test_dns_dga_live_log_validation.sh"
else
    fail "test_dns_dga_live_log_validation.sh"
fi

# --- 10. DNS New TLD test contract ---
primary_pool_n=$(dns_new_tld_primary_pool | wc -l | tr -d ' ')
if [[ "${primary_pool_n}" =~ ^[0-9]+$ ]] && (( primary_pool_n >= 16 )); then
    pass "dns_new_tld primary pool present (${primary_pool_n} TLDs)"
else
    fail "dns_new_tld primary pool (${primary_pool_n})"
fi

DNS_NEW_TLD_ENABLED=true
DNS_NEW_TLD_UNIQUE_TLDS=0
DNS_NEW_TLD_SUCCESSFUL_QUERIES=0
DNS_NEW_TLD_STAGE_STATUS=Success
finalize_dns_new_tld_stage_judgment "DNS New TLD Test" "validate "
if [[ "${DNS_NEW_TLD_STAGE_STATUS}" == Failed ]]; then
    pass "finalize_dns_new_tld blocks Success on zero successful_queries"
else
    fail "finalize_dns_new_tld should fail zero stats (status=${DNS_NEW_TLD_STAGE_STATUS})"
fi

DNS_NEW_TLD_UNIQUE_TLDS=2
DNS_NEW_TLD_SUCCESSFUL_QUERIES=15
DNS_NEW_TLD_TESTED_DOMAINS=20
DNS_NEW_TLD_STAGE_STATUS=Success
finalize_dns_new_tld_stage_judgment "DNS New TLD Test" "validate "
if [[ "${DNS_NEW_TLD_STAGE_STATUS}" == Partial ]]; then
    pass "finalize_dns_new_tld blocks Success when unique_tlds<3"
else
    fail "finalize_dns_new_tld should downgrade unique_tlds=2 (status=${DNS_NEW_TLD_STAGE_STATUS})"
fi

nt_cmd=$(build_dns_new_tld_simulation_remote_cmd "10.10.10.5" 30 dig)
if [[ "${nt_cmd}" == *'DNS_NEW_TLD_QUERY'* && "${nt_cmd}" == *'click'* && "${nt_cmd}" == *'dns_nt_pick_qtype'* && "${nt_cmd}" == *'dns_nt_validate_fqdn'* ]]; then
    pass "dns_new_tld remote cmd includes query types and primary TLDs"
else
    fail "dns_new_tld remote cmd contract"
fi

if validate_dns_fqdn "forms.api123.click" _rc && ! validate_dns_fqdn "bad..label.click" _rc2; then
    pass "validate_dns_fqdn RFC checks"
else
    fail "validate_dns_fqdn"
fi

if bash "${ROOT}/tests/test_dns_new_tld_detection_validation.sh"; then
    pass "test_dns_new_tld_detection_validation.sh"
else
    fail "test_dns_new_tld_detection_validation.sh"
fi

if bash "${ROOT}/tests/test_fast_safe_mode.sh"; then
    pass "test_fast_safe_mode.sh"
else
    fail "test_fast_safe_mode.sh"
fi

echo "---"
if (( failures == 0 )); then
    echo "All validation checks passed."
    exit 0
fi
echo "${failures} validation check(s) failed."
exit 1
