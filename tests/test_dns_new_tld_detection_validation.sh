#!/usr/bin/env bash
# test_dns_new_tld_detection_validation.sh — dns_new_tld stage/fixture contract tests
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURE_DIR="${ROOT}/tests/fixtures/live_logs"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dns_new_tld_test_$$"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" "${LOCAL_STATE_DIR}/logs"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="221.139.249.0/24"
export NETWORK_PREFIX="221.139.249"
export REMOTE_RUNTIME_DIR="/tmp/.poc_runtime_test"
export CAMPAIGN_ID="dns-new-tld-fixture"
export ATTACKER_BASE_URL="http://127.0.0.1:5000"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"
export STOP_REQUESTED=false
export HAS_bash=true
export HAS_dig=true
export WEBSHELL_CMD_STYLE=raw

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dns_new_tld_test_$$"
EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
REPORT_DIR="${LOCAL_STATE_DIR}/report"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" "${EFFECTIVE_REPORT_DIR}" "${LOG_DIR}"
DRY_RUN=true

primary_n=$(dns_new_tld_primary_pool | wc -l | tr -d ' ')
secondary_n=$(dns_new_tld_secondary_pool | wc -l | tr -d ' ')
(( primary_n >= 16 )) && pass "primary TLD pool count=${primary_n}" || fail "primary TLD pool count=${primary_n}"
(( secondary_n >= 10 )) && pass "secondary TLD pool count=${secondary_n}" || fail "secondary TLD pool count=${secondary_n}"
dns_new_tld_primary_pool | grep -qxF click && pass "primary pool contains click" || fail "primary pool missing click"
dns_new_tld_secondary_pool | grep -qxF zip && pass "secondary pool contains zip" || fail "secondary pool missing zip"

dns_new_tld_compute_detection_likelihood 8 35
[[ "${DNS_NEW_TLD_DETECTION_LIKELIHOOD}" == HIGH ]] && pass "detection_likelihood HIGH for 8 TLDs / 35 domains" \
    || fail "detection_likelihood expected HIGH got ${DNS_NEW_TLD_DETECTION_LIKELIHOOD}"
dns_new_tld_compute_detection_likelihood 3 15
[[ "${DNS_NEW_TLD_DETECTION_LIKELIHOOD}" == MEDIUM ]] && pass "detection_likelihood MEDIUM for 3 TLDs" \
    || fail "detection_likelihood expected MEDIUM got ${DNS_NEW_TLD_DETECTION_LIKELIHOOD}"
dns_new_tld_compute_detection_likelihood 2 10
[[ "${DNS_NEW_TLD_DETECTION_LIKELIHOOD}" == LOW ]] && pass "detection_likelihood LOW for 2 TLDs" \
    || fail "detection_likelihood expected LOW got ${DNS_NEW_TLD_DETECTION_LIKELIHOOD}"

cmd=$(build_dns_new_tld_simulation_remote_cmd "10.10.10.5" 25 dig)
if [[ "${cmd}" == *'primary_tlds='*'click'* && "${cmd}" == *'forms api cdn'* && "${cmd}" == *'DNS_NEW_TLD_QUERY'* ]]; then
    pass "build_dns_new_tld_simulation_remote_cmd contract"
else
    fail "build_dns_new_tld_simulation_remote_cmd missing expected markers"
fi

if poc_validate_dns_new_tld_live_log "${FIXTURE_DIR}/dns_new_tld_success.log" err_ok; then
    pass "success fixture validates (${err_ok})"
else
    fail "success fixture should validate (${err_ok})"
fi

if poc_validate_dns_new_tld_live_log "${FIXTURE_DIR}/dns_new_tld_partial.log" err_part; then
    pass "partial fixture validates (${err_part})"
else
    fail "partial fixture should validate (${err_part})"
fi

if poc_validate_dns_new_tld_live_log "${FIXTURE_DIR}/dns_new_tld_failed.log" err_fail; then
    pass "failed fixture validates (${err_fail})"
else
    fail "failed fixture should validate (${err_fail})"
fi

bad_success="${LOCAL_STATE_DIR}/bad_dns_new_tld_false_success.log"
cat > "${bad_success}" <<'EOF'
DNS_NEW_TLD_TEST_START resolver=10.10.10.5 tool=dig planned_domains=10
DNS_NEW_TLD_SUMMARY tested_domains=10 tested_tlds=click unique_tlds=2 query_count=40 query_types=A=16/AAAA=8/HTTPS=8/TXT=8 successful_queries=5 failed_queries=35 duration_seconds=4 detection_likelihood=LOW
DNS_NEW_TLD_STAGE_FINAL_SUMMARY stage=DNS New TLD Test status=Success tested_domains=10 unique_tlds=2 query_count=40 successful_queries=5 failed_queries=35 detection_likelihood=LOW resolver=10.10.10.5 result=success
Stage result: DNS New TLD Test = Success — false positive
EOF
if poc_validate_dns_new_tld_live_log "${bad_success}" err_bad; then
    fail "false success (unique_tlds=2 LOW) should be rejected"
else
    pass "false success blocked (${err_bad})"
fi

bad_zero="${LOCAL_STATE_DIR}/bad_dns_new_tld_zero_success.log"
cat > "${bad_zero}" <<'EOF'
DNS_NEW_TLD_TEST_START resolver=10.10.10.5 tool=dig planned_domains=12
DNS_NEW_TLD_SUMMARY tested_domains=12 tested_tlds=click fun top link xyz page unique_tlds=6 query_count=48 query_types=A=20/AAAA=10/HTTPS=10/TXT=8 successful_queries=0 failed_queries=48 duration_seconds=3 detection_likelihood=HIGH
DNS_NEW_TLD_STAGE_FINAL_SUMMARY stage=DNS New TLD Test status=Success tested_domains=12 unique_tlds=6 query_count=48 successful_queries=0 failed_queries=48 detection_likelihood=HIGH resolver=10.10.10.5 result=success
Stage result: DNS New TLD Test = Success — zero successful
EOF
if poc_validate_dns_new_tld_live_log "${bad_zero}" err_zero; then
    fail "successful_queries=0 Success should be rejected"
else
    pass "zero successful_queries Success blocked (${err_zero})"
fi

DNS_NEW_TLD_TESTED_DOMAINS=35
DNS_NEW_TLD_UNIQUE_TLDS=8
DNS_NEW_TLD_QUERY_COUNT=140
DNS_NEW_TLD_SUCCESSFUL_QUERIES=132
DNS_NEW_TLD_FAILED_QUERIES=8
DNS_NEW_TLD_DETECTION_LIKELIHOOD=HIGH
DNS_NEW_TLD_STAGE_STATUS=Success
finalize_dns_new_tld_stage_judgment "DNS New TLD Test" "fixture "
[[ "${DNS_NEW_TLD_STAGE_STATUS}" == Success ]] && pass "finalize success judgment" \
    || fail "finalize expected Success got ${DNS_NEW_TLD_STAGE_STATUS}"

DNS_NEW_TLD_UNIQUE_TLDS=2
DNS_NEW_TLD_SUCCESSFUL_QUERIES=10
DNS_NEW_TLD_STAGE_STATUS=Success
finalize_dns_new_tld_stage_judgment "DNS New TLD Test" "fixture "
[[ "${DNS_NEW_TLD_STAGE_STATUS}" == Partial ]] && pass "finalize downgrades unique_tlds<3 Success" \
    || fail "finalize should downgrade unique_tlds=2 Success (got ${DNS_NEW_TLD_STAGE_STATUS})"

rm -rf "${LOCAL_STATE_DIR}"

echo "---"
if (( failures == 0 )); then
    echo "All dns_new_tld detection validation checks passed."
    exit 0
fi
echo "${failures} dns_new_tld validation check(s) failed."
exit 1
