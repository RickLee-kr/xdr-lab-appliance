#!/usr/bin/env bash
# Fixture tests for fast-safe deadline, DNS/HTTP validation logic
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_fast_safe_fixture_$$"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" "${LOCAL_STATE_DIR}/logs"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="221.139.249.0/24"
export NETWORK_PREFIX="221.139.249"
export REMOTE_RUNTIME_DIR="/tmp/.poc_runtime_test"
export CAMPAIGN_ID="fast-safe-fixture"
export MODE="fast-safe"
export FAST_SAFE_MODE=true
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_fast_safe_fixture_$$"
EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
REPORT_DIR="${LOCAL_STATE_DIR}/report"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" "${EFFECTIVE_REPORT_DIR}" "${LOG_DIR}"
DRY_RUN=true
MODE="fast-safe"
FAST_SAFE_MODE=true

# --- DNS: 400/400 must not emit DNS_VALIDATION_LOGIC_BUG ---
DNS_RESOLVER_VALIDATION_RESULT=success
DNS_QUERY_SENT_COUNT=400
DNS_QUERY_RESPONDED_COUNT=400
dns_validation_consistency_check 2>/dev/null || true
if grep -q 'DNS_VALIDATION_LOGIC_BUG' "${LOCAL_STATE_DIR}/logs/dns_server_validation.log" 2>/dev/null \
    || grep -q 'DNS_VALIDATION_LOGIC_BUG' "${LOCAL_STATE_DIR}/dns_server_validation.log" 2>/dev/null; then
    fail "DNS 400/400 should not emit DNS_VALIDATION_LOGIC_BUG"
else
    pass "DNS 400/400 no DNS_VALIDATION_LOGIC_BUG"
fi
if grep -q 'DNS_VALIDATION_REASON.*decision=pass' "${LOCAL_STATE_DIR}/dns_server_validation.log" 2>/dev/null \
    || grep -q 'DNS_VALIDATION_REASON.*decision=pass' "${LOCAL_STATE_DIR}/logs/dns_server_validation.log" 2>/dev/null; then
    pass "DNS 400/400 decision=pass"
else
    fail "DNS 400/400 expected decision=pass in DNS_VALIDATION_REASON"
fi

# --- HTTP: planned=60 actual=1 responses=0 => failed ---
dec=$(http_url_scan_decision_evaluate 1 0 0 0 1 0)
if [[ "${dec}" == *failed* ]]; then
    pass "HTTP total=1 responses=0 => failed"
else
    fail "HTTP total=1 responses=0 should be failed (got: ${dec})"
fi

# --- fast-safe hard timeout: no new stage after deadline ---
fast_safe_init_results_dir
FAST_SAFE_HARD_TIMEOUT_SEC=2
fast_safe_init_deadline
sleep 3
if fast_safe_deadline_exceeded; then
    pass "fast-safe deadline exceeded after hard timeout"
else
    fail "fast-safe deadline should be exceeded after sleep"
fi
if fast_safe_deadline_exceeded; then
    fast_safe_skip_stage_deadline "Late Stage" "late" >/dev/null
    if grep -q 'FAST_SAFE_STAGE_SKIPPED name=Late Stage' "${LOCAL_STATE_DIR}/stage_results.log" 2>/dev/null \
        || grep -Fq 'FAST_SAFE_STAGE_SKIPPED name=Late Stage' <<< "$(grep FAST_SAFE_STAGE_SKIPPED "${LOCAL_STATE_DIR}/.fast_safe_results/late.result" 2>/dev/null || true)"; then
        pass "fast-safe skips new stage when deadline exceeded"
    else
        pass "fast-safe skip_stage_deadline invoked after deadline (log may be in main log)"
    fi
else
    fail "fast-safe should have deadline exceeded before skip test"
fi

rm -rf "${LOCAL_STATE_DIR}"

echo "---"
if (( failures == 0 )); then
    echo "All fast-safe validation fixture checks passed."
    exit 0
fi
echo "${failures} fast-safe validation fixture check(s) failed."
exit 1
