#!/usr/bin/env bash
# Contract tests for parse_* / read / normalize field alignment (regression guard).
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

# Minimal env before sourcing
export DRY_RUN=true HAS_bash=true REMOTE_SHELL_BIN=bash WEBSHELL_CMD_STYLE=raw
export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/stellar-parse-test-$$"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts"
export REMOTE_RUNTIME_DIR="/tmp/.poc_runtime_test"
export CAMPAIGN_ID="parse-test"
export TARGET_NET="221.139.249.0/24"
export HTTP_SCAN_WAVES=2 HTTP_SCAN_WAVE_FAIL_MIN=5 HTTP_SCAN_WAVE_FAIL_MAX=10
export HTTP_SCAN_WAVE_SLEEP=1 HTTP_SCAN_WAVE_ATTEMPT_CAP=20
export ATTACKER_IP="127.0.0.1"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"
# shellcheck disable=SC1091
source "${ROOT}/stellar_poc_followup.sh"

# 1) normalize_http_scan_target_fields must be one line for read <<<
norm=$(normalize_http_scan_target_fields "221.139.249.110" "80" "http")
if [[ "${norm}" != *$'\n'* ]]; then
    pass "normalize_http_scan_target_fields single-line"
else
    fail "normalize_http_scan_target_fields multi-line (${norm})"
fi
read -r h p s <<< "${norm}"
[[ "${h}" == "221.139.249.110" && "${p}" == "80" && "${s}" == "http" ]] && pass "normalize read host/port/scheme" || fail "normalize read mismatch h=${h} p=${p} s=${s}"

# 2) Remote bash wrappers wired for bash-only payload builders
for needle in \
    "bash <<'HTTP_SCAN_SCRIPT'" \
    "dns_remote_script_open 'DNS_ENHANCED_SCRIPT'" \
    "remote_bash_script_open 'INTERNAL_FANOUT_SCRIPT'"; do
    if grep -qF "${needle}" "${ROOT}/stellar_poc_followup.sh"; then
        pass "wrapper present: ${needle}"
    else
        fail "missing wrapper: ${needle}"
    fi
done

rm -rf "${LOCAL_STATE_DIR}"
exit "${failures}"
