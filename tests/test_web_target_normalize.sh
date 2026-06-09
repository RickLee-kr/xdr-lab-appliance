#!/usr/bin/env bash
# Regression tests for web target normalization and candidate merge.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0
FAIL=0

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [[ "${actual}" == "${expected}" ]]; then
    echo "PASS ${label}"
    PASS=$((PASS + 1))
  else
    echo "FAIL ${label} expected='${expected}' actual='${actual}'" >&2
    FAIL=$((PASS + 1))
  fi
}

assert_gt() {
  local label="$1" min="$2" actual="$3"
  if (( actual > min )); then
    echo "PASS ${label}"
    PASS=$((PASS + 1))
  else
    echo "FAIL ${label} expected>${min} actual=${actual}" >&2
    FAIL=$((FAIL + 1))
  fi
}

assert_fail_norm() {
  local label="$1" line="$2" scheme="${3:-http}"
  if normalize_web_target_line "${line}" "${scheme}" >/dev/null 2>&1; then
    echo "FAIL ${label} expected malformed drop" >&2
    FAIL=$((FAIL + 1))
  else
    echo "PASS ${label}"
    PASS=$((PASS + 1))
  fi
}

# shellcheck source=stellar_poc.sh
source "${ROOT}/stellar_poc.sh"

DRY_RUN=true
LOCAL_STATE_DIR=$(mktemp -d)
REMOTE_RUNTIME_DIR="/tmp/.poc_runtime_root"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts"

printf '%s\n' \
  "221.139.249.110:80" \
  "221.139.249.110:8080" \
  "221.139.249.111:8080" \
  "221.139.249.113:80" \
  "221.139.249.118:8080" \
  "221.139.249.122:80" \
  "221.139.249.122:8080" \
  "221.139.249.126:80" > "${LOCAL_STATE_DIR}/remote_hosts/http_targets.txt"

printf '%s\n' \
  "221.139.249.110:80" \
  "221.139.249.113:80" > "${LOCAL_STATE_DIR}/remote_hosts/usable_http_targets.txt"

read -r h p s <<< "$(normalize_web_target_line "221.139.249.113:80" "http")"
assert_eq "parse host:port" "221.139.249.113" "${h}"
assert_eq "parse port" "80" "${p}"
assert_eq "parse scheme" "http" "${s}"

url=$(build_web_target_url "http" "221.139.249.110" "80" "/api")
assert_eq "build url" "http://221.139.249.110:80/api" "${url}"

assert_fail_norm "reject concatenated hosts" "221.139.249.110221.139.249.111"
assert_fail_norm "reject double port token" "221.139.249.110:80:80"

http_n=$(collect_web_target_candidates "http" | safe_count_lines)
assert_gt "merged http candidates" 0 "${http_n}"

discovered=$(count_web_targets_in_file "http_targets.txt")
assert_gt "discovered from raw+usable" 0 "${discovered}"

# discovery_sync must not wipe local cache when remote read is empty
run_webshell_quick() { :; }
normalize_webshell_response() { printf ''; }
n=$(discovery_sync_remote_host_file "http_targets.txt")
assert_gt "discovery_sync keeps cache count" 7 "${n}"

rm -rf "${LOCAL_STATE_DIR}"
echo "---"
echo "Results: ${PASS} passed, ${FAIL} failed"
[[ "${FAIL}" -eq 0 ]]
