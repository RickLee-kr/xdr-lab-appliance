#!/usr/bin/env bash
# Detection-focused HTTP follow-up: max 2 hosts, 10 fixed URLs, <=20 planned requests
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_http_followup_opt_$$"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" "${LOCAL_STATE_DIR}/logs"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.10.10.0/24"
export CAMPAIGN_ID="http-followup-opt-test"
export POC_RUN_ID="http-followup-opt-test"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_http_followup_opt_$$"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts"

# Reachable candidates: port priority should pick 443 then 80
cat > "${LOCAL_STATE_DIR}/remote_hosts/reachable_https_targets.txt" <<'EOF'
10.10.10.20:443
10.10.10.35:8080
10.10.10.40:80
EOF
cat > "${LOCAL_STATE_DIR}/remote_hosts/reachable_http_targets.txt" <<'EOF'
10.10.10.35:80
EOF

resolve_http_scan_wave_plan

if (( HTTP_FOLLOWUP_MAX_HOSTS == 2 && HTTP_FOLLOWUP_URLS_PER_HOST == 10 && HTTP_FOLLOWUP_MAX_REQUESTS == 20 )); then
    pass "HTTP limits constants max_hosts=2 urls_per_host=10 cap=20"
else
    fail "HTTP limits expected 2/10/20 got hosts=${HTTP_FOLLOWUP_MAX_HOSTS} urls=${HTTP_FOLLOWUP_URLS_PER_HOST} cap=${HTTP_FOLLOWUP_MAX_REQUESTS}"
fi

candidates=$(collect_http_url_scan_candidates)
selected=$(select_http_followup_targets "${candidates}")
sel_n=$(printf '%s\n' "${selected}" | awk 'NF{c++} END{print c+0}')

if (( sel_n <= 2 && sel_n >= 1 )); then
    pass "HTTP target selection count=${sel_n} (max 2)"
else
    fail "HTTP target selection expected 1-2 hosts got ${sel_n}"
fi

if grep -q 'HTTP_TARGET_SELECTED host=10.10.10.20 port=443 rank=1' "${LOCAL_STATE_DIR}/http_url_scan_target_selection.log" 2>/dev/null; then
    pass "HTTP_TARGET_SELECTED rank=1 port=443"
else
    fail "HTTP_TARGET_SELECTED missing 10.10.10.20:443 rank=1"
fi

planned_logged=$(grep -oE 'planned_requests=[0-9]+' "${LOCAL_STATE_DIR}/http_url_scan.log" 2>/dev/null | tail -n1 | sed 's/planned_requests=//')
planned_logged=$(safe_int "${planned_logged}")
if (( planned_logged > 0 && planned_logged <= 20 )); then
    pass "planned_requests=${planned_logged} (<=20)"
else
    fail "planned_requests from log expected 1-20 got ${planned_logged}"
fi

if grep -q 'HTTP_SCAN_LIMIT_APPLIED' "${LOCAL_STATE_DIR}/http_url_scan.log" 2>/dev/null; then
    pass "HTTP_SCAN_LIMIT_APPLIED logged"
else
    fail "HTTP_SCAN_LIMIT_APPLIED not found in http_url_scan.log"
fi

paths_csv=$(http_followup_fixed_paths_csv)
path_ok=true
for p in / /login /admin /api /status /health /robots.txt /favicon.ico /index.html /dashboard; do
    [[ "${paths_csv}" == *"${p}"* ]] || path_ok=false
done
if [[ "${path_ok}" == true ]]; then
    pass "fixed URL path set (10 paths)"
else
    fail "fixed URL path set incomplete in csv=${paths_csv}"
fi

remote_cmd=$(build_http_url_scan_curl_remote_cmd "10.10.10.20" "443" "https" "${CAMPAIGN_ID}")
if [[ "${remote_cmd}" != *"next_attack_url"* && "${remote_cmd}" != *"mandatory_payload_urls"* && "${remote_cmd}" != *"payload_recon_urls"* ]]; then
    pass "remote cmd has no wordlist/burst generators"
else
    fail "remote cmd still contains bulk URL scan logic"
fi
if [[ "${remote_cmd}" == *"/login"* && "${remote_cmd}" == *"/admin"* && "${remote_cmd}" == *"fixed_paths"* ]]; then
    pass "remote cmd includes fixed paths"
else
    fail "remote cmd missing fixed path loop"
fi

# Success criteria via event SOT
init_event_store
http_sot_init_run
http_record_url_event "http://10.10.10.20:443" "/" "GET" "rare" "200" "0" "response_2xx" "5"
http_record_url_event "http://10.10.10.20:443" "/login" "GET" "payload" "404" "0" "response_4xx" "6"
read -r dec _ <<< "$(http_url_scan_decision_evaluate 2 2 1 0 2 1)"
if [[ "${dec}" == *success* ]]; then
    pass "HTTP success when attempted>0 and responses>0"
else
    fail "HTTP success decision expected success got ${dec}"
fi

init_event_store
http_sot_init_run
http_record_url_event "http://10.10.10.20:443" "/" "GET" "rare" "000" "28" "timeout" "30"
read -r dec2 _ <<< "$(http_url_scan_decision_evaluate 1 0 0 1 1 0)"
if [[ "${dec2}" == *partial* ]]; then
    pass "HTTP partial when attempted>0 connection only"
else
    fail "HTTP partial decision expected partial got ${dec2}"
fi

init_event_store
read -r dec3 _ <<< "$(http_url_scan_decision_evaluate 0 0 0 0 0 0)"
if [[ "${dec3}" == *failed* ]]; then
    pass "HTTP fail when attempted=0"
else
    fail "HTTP fail decision expected failed got ${dec3}"
fi

http_emit_url_execution_summary 2>/dev/null || true
if grep -qE 'HTTP_URL_EXECUTION_SUMMARY attempted=[0-9]+ responses=[0-9]+ success_rate=' "${LOCAL_STATE_DIR}/http_url_scan.log" 2>/dev/null; then
    pass "HTTP_URL_EXECUTION_SUMMARY format"
else
    fail "HTTP_URL_EXECUTION_SUMMARY missing from http_url_scan.log"
fi

rm -rf "${LOCAL_STATE_DIR}"
if (( failures > 0 )); then
    printf '\n%d test(s) failed.\n' "${failures}"
    exit 1
fi
printf '\nAll HTTP follow-up optimized tests passed.\n'
