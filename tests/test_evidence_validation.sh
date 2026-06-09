#!/usr/bin/env bash
# test_evidence_validation.sh — evidence-chain validation architecture fixtures
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_evidence_test_$$"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" "${LOCAL_STATE_DIR}/logs"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="221.139.249.0/24"
export NETWORK_PREFIX="221.139.249"
export REMOTE_RUNTIME_DIR="/tmp/.poc_runtime_test"
export CAMPAIGN_ID="evidence-fixture"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"
export STOP_REQUESTED=false
export HAS_bash=true
export WEBSHELL_CMD_STYLE=raw

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_evidence_test_$$"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" "${LOG_DIR}"
DRY_RUN=true

# DNS tunnel: generated>0 sent=0 must fail
DNS_QUERY_GENERATED=200
DNS_QUERY_SENT_COUNT=0
DNS_QUERY_RESPONDED_COUNT=0
DNS_QUERIES_PLANNED=200
DNS_ENVIRONMENT_BLOCKED=false
evidence_validate_dns_tunnel_module
if [[ "${TELEMETRY_VAL_DNS_TUNNEL}" == failed && "${EVID_RESULT[DNS_TUNNEL]}" == FAILED ]]; then
    pass "DNS generated=200 sent=0 => FAILED"
else
    fail "DNS generated=200 sent=0 should FAILED (got telem=${TELEMETRY_VAL_DNS_TUNNEL} result=${EVID_RESULT[DNS_TUNNEL]:-})"
fi

# DNS tunnel: full chain => success path (requires server_observed)
DNS_QUERY_GENERATED=200
DNS_QUERY_SENT_COUNT=200
DNS_QUERY_RESPONDED_COUNT=195
DNS_TUNNEL_LABEL_COUNT=50
DNS_TUNNEL_APPROX_ENTROPY=45
DNS_QUERIES_PLANNED=200
DNS_SERVER_OBSERVED_QUERIES=180
evidence_validate_dns_tunnel_module
if [[ "${TELEMETRY_VAL_DNS_TUNNEL}" == success && $(safe_int "${EVID_VALIDATED[DNS_TUNNEL]:-0}") -ge 150 ]]; then
    pass "DNS full chain validated + server_observed => success"
else
    fail "DNS full chain should success (t=${TELEMETRY_VAL_DNS_TUNNEL} v=${EVID_VALIDATED[DNS_TUNNEL]:-0})"
fi

# DNS tunnel: validated but server_observed=0 => PARTIAL not SUCCESS
DNS_SERVER_OBSERVED_QUERIES=0
evidence_validate_dns_tunnel_module
if [[ "${EVID_RESULT[DNS_TUNNEL]}" == PARTIAL && "${TELEMETRY_VAL_DNS_TUNNEL}" == partial ]]; then
    pass "DNS server_observed=0 blocks SUCCESS"
else
    fail "DNS server_observed=0 should PARTIAL (got result=${EVID_RESULT[DNS_TUNNEL]:-} telem=${TELEMETRY_VAL_DNS_TUNNEL})"
fi

# DGA: sent>0 nx=0 must fail immediately
DGA_SIMULATION_ENABLED=true
DGA_QUERY_GENERATED=50
DGA_QUERY_SENT_COUNT=50
DGA_QUERY_RESPONDED_COUNT=50
DGA_ACTUAL_NXDOMAIN=0
DGA_NXDOMAIN_COUNT=0
evidence_validate_dga_module
if [[ "${TELEMETRY_VAL_DGA_SIMULATION}" == failed ]]; then
    pass "DGA sent>0 nx=0 => failed"
else
    fail "DGA nx=0 should fail (got ${TELEMETRY_VAL_DGA_SIMULATION})"
fi

# DNS visibility gate blocks modules
DNS_VISIBILITY_VALID_SENT=0
DNS_VISIBILITY_VALID_RESPONSE=0
evaluate_dns_visibility_gate || true
if [[ "${DNS_ENVIRONMENT_BLOCKED}" == true ]]; then
    pass "DNS visibility failure => ENVIRONMENT_BLOCKED"
else
    fail "DNS visibility should block"
fi

# Detection quality gate blocks HIGH without validated
EVID_VALIDATED[DNS_TUNNEL]=0
EVID_RESULT[DNS_TUNNEL]=FAILED
if evidence_detection_quality_allowed "DNS Tunnel" "HIGH"; then
    fail "HIGH quality should be blocked without validated"
else
    pass "DETECTION_QUALITY blocked without validated"
fi

rm -rf "${LOCAL_STATE_DIR}"

echo "---"
if (( failures == 0 )); then
    echo "All evidence validation checks passed."
    exit 0
fi
echo "${failures} evidence validation check(s) failed."
exit 1
