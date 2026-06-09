#!/usr/bin/env bash
# test_pre_webshell_url_scan.sh — set -e safety and stdout leak checks for Pre-WebShell URL scan
set -Eeo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

smoke_env="$(mktemp -d)"
export LOCAL_STATE_DIR="${smoke_env}/state"
mkdir -p "${LOCAL_STATE_DIR}"
DRY_RUN=false
WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
CAMPAIGN_ID="test-pre-webshell"
LOCAL_HAS_CURL=true
DEBUG=true
VERBOSE=true
POC_START_EPOCH=$(date +%s)

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${smoke_env}/state"
mkdir -p "${LOCAL_STATE_DIR}"

pre_webshell_local_http_request() { printf '404'; }

PRE_WEBSHELL_SCAN_BASE_URL="http://127.0.0.1"
PRE_WEBSHELL_SCAN_TARGET="${PRE_WEBSHELL_SCAN_BASE_URL}"
PRE_WEBSHELL_SCAN_TOTAL=0
PRE_WEBSHELL_SCAN_UNIQUE=0
PRE_WEBSHELL_SCAN_200=0
PRE_WEBSHELL_SCAN_301=0
PRE_WEBSHELL_SCAN_302=0
PRE_WEBSHELL_SCAN_400=0
PRE_WEBSHELL_SCAN_401=0
PRE_WEBSHELL_SCAN_403=0
PRE_WEBSHELL_SCAN_404=0
PRE_WEBSHELL_SCAN_405=0
PRE_WEBSHELL_SCAN_500=0
PRE_WEBSHELL_SCAN_TIMEOUT=0
PRE_WEBSHELL_SCAN_REAL_FAILED=0
PRE_WEBSHELL_SCAN_REDIRECT=0
PRE_WEBSHELL_SCAN_UA_PRESENT=0
PRE_WEBSHELL_SCAN_ABNORMAL_UA=0
PRE_WEBSHELL_SCAN_DURATION=0
PRE_WEBSHELL_SCAN_LIKELIHOOD="low"
PRE_WEBSHELL_SCAN_REASON=""
PRE_WEBSHELL_LAST_TRACK_RESULT=""
PRE_WEBSHELL_SCAN_REQUEST_REAL_FAILED=0

paths=(
    '/.git/config' '/.env' '/admin' '/login' '/backup.zip'
)
seen="" unique_count=0 total_count=0
t0=$(date +%s)

stdout_file="$(mktemp)"
set +e
{
    for path in "${paths[@]}"; do
        if [[ " ${seen} " == *" ${path} "* ]]; then
            continue
        fi
        seen="${seen} ${path}"
        unique_count=$((unique_count + 1))
        url="${PRE_WEBSHELL_SCAN_BASE_URL}${path#/}"
        ua=$(pre_webshell_pick_ua)
        ua_class=$(pre_webshell_classify_ua "${ua}")
        PRE_WEBSHELL_SCAN_UA_PRESENT=$((PRE_WEBSHELL_SCAN_UA_PRESENT + 1))
        PRE_WEBSHELL_SCAN_ABNORMAL_UA=$((PRE_WEBSHELL_SCAN_ABNORMAL_UA + 1))
        total_count=$((total_count + 1))
        code=$(pre_webshell_local_http_request "${url}" "${ua}" || printf '000')
        pre_webshell_track_status_code "${code}" || true
        result="${PRE_WEBSHELL_LAST_TRACK_RESULT}"
        log_pre_webshell_request_debug "${url}" "${code}" "${ua}" "${ua_class}" "${result}"
    done
    PRE_WEBSHELL_SCAN_TOTAL="${total_count}"
    PRE_WEBSHELL_SCAN_UNIQUE="${unique_count}"
    PRE_WEBSHELL_SCAN_DURATION=$(($(date +%s) - t0))
    compute_pre_webshell_detection_likelihood
    log_pre_webshell_url_scan_summary
} >"${stdout_file}" 2>&1
loop_rc=$?
set -e

if (( loop_rc == 0 )); then
    pass "pre_webshell scan loop completed under set -e"
else
    fail "pre_webshell scan loop exit ${loop_rc}"
fi

for leak in real_failed success redirect timeout; do
    if grep -qxF "${leak}" "${stdout_file}"; then
        fail "stdout leak: bare '${leak}'"
    else
        pass "no stdout leak: ${leak}"
    fi
done

if grep -q 'PRE_WEBSHELL_URL_SCAN_SUMMARY' "${stdout_file}"; then
    pass "PRE_WEBSHELL_URL_SCAN_SUMMARY emitted"
else
    fail "missing PRE_WEBSHELL_URL_SCAN_SUMMARY"
fi

if [[ "${PRE_WEBSHELL_SCAN_UNIQUE}" == "${#paths[@]}" ]]; then
    pass "unique_count=${PRE_WEBSHELL_SCAN_UNIQUE}"
else
    fail "unique_count expected ${#paths[@]} got ${PRE_WEBSHELL_SCAN_UNIQUE}"
fi

if [[ "${PRE_WEBSHELL_SCAN_REAL_FAILED}" == "${#paths[@]}" ]]; then
    pass "real_failed=${PRE_WEBSHELL_SCAN_REAL_FAILED}"
else
    fail "real_failed expected ${#paths[@]} got ${PRE_WEBSHELL_SCAN_REAL_FAILED}"
fi

rm -rf "${smoke_env}" "${stdout_file}"

if (( failures == 0 )); then
    exit 0
fi
exit 1
