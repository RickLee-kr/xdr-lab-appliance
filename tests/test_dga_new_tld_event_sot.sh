#!/usr/bin/env bash
# DGA / New TLD remote EVENT SOT — TSV merge must match log query counts
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dga_ntld_sot_$$"
mkdir -p "${LOCAL_STATE_DIR}"
export DRY_RUN=false
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export NETWORK_PREFIX="10.0.0.0"
export CAMPAIGN_ID="dga-ntld-sot-test"
export POC_RUN_ID="dga-ntld-sot-test"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"
export REMOTE_STATE_DIR="${LOCAL_STATE_DIR}/remote_state"
export DGA_SIMULATION_ENABLED=true
export DNS_NEW_TLD_ENABLED=true
mkdir -p "${REMOTE_STATE_DIR}/events" "${LOG_DIR}"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dga_ntld_sot_$$"
POC_RUN_ID="dga-ntld-sot-test"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
REMOTE_STATE_DIR="${LOCAL_STATE_DIR}/remote_state"
mkdir -p "${LOCAL_STATE_DIR}" "${LOG_DIR}" "${REMOTE_STATE_DIR}/events"
export LOCAL_STATE_DIR LOG_DIR REMOTE_STATE_DIR POC_RUN_ID DRY_RUN
poc_sot_paths_init 2>/dev/null || true

init_event_store

# --- Mock DGA remote: 20 DGA_QUERY_SENT + remote TSV ---
dga_remote="${REMOTE_STATE_DIR}/events/dga_events.tsv"
printf '%s\n' "${EVENT_TSV_HEADER}" > "${dga_remote}"
mock_dga_webshell() {
    local i dom tld
    for ((i = 1; i <= 20; i++)); do
        dom="dg$(printf '%04x' "${i}").test$(printf '%02d' "${i}").invalid"
        tld="invalid"
        printf 'DGA_DOMAIN_GENERATED domain=%s phase=nx\n' "${dom}"
        printf 'DGA_QUERY_SENT domain=%s qtype=A phase=nx\n' "${dom}"
        printf 'DGA_EVENT timestamp=2020-01-01T00:00:00Z module=DGA stage=dga_simulator target=8.8.8.8 action=query status=sent value=%s\n' "${dom}"
        printf 'DGA_QUERY_RESULT domain=%s rcode=nxdomain qtype=A phase=nx\n' "${dom}"
        printf '%s\t%s\tDGA\tdga_simulator\t8.8.8.8\tquery\tdomain\tsent\t0\t%s|A|%s|seed\tremote_dga_simulator\n' \
            "2020-01-01T00:00:01Z" "${CAMPAIGN_ID}" "${dom}" "${tld}"
        printf '%s\t%s\tDGA\tdga_simulator\t8.8.8.8\tquery\tdomain\tnxdomain\t0\t%s|A|%s|seed\tremote_dga_simulator\n' \
            "2020-01-01T00:00:02Z" "${CAMPAIGN_ID}" "${dom}" "${tld}"
    done
    echo "DGA_REMOTE_EVENT_FILE path=${dga_remote} exists=yes lines=42"
    echo 'DGA_CHUNK_SUMMARY queries=20 nxdomain=20 resolvable=0 generated=20 query_sent=20 query_responded=20'
}
run_webshell_quick() { mock_dga_webshell; }
export -f run_webshell_quick
DGA_QUERY_TOOL=dig
DGA_DNS_SERVER="8.8.8.8"
DGA_NXDOMAIN_QUERIES=20
DGA_RESOLVABLE_QUERIES=0
DGA_SIM_CHUNK_SIZE=20
dga_out=$(mock_dga_webshell)
dga_replay_structured_logs "${dga_out}"
net_sim_dga_ingest_output "${dga_out}"
dga_log_sent=$(state_log_count_pattern "dga_simulation.log" '^DGA_QUERY_SENT ')
dga_ec=$(event_module_event_count "DGA_SIMULATION")
if (( dga_log_sent >= 20 || dga_ec >= 20 )); then
    if (( dga_ec >= 20 )); then
        pass "DGA_QUERY_SENT 20 => DGA_EVENT rows=${dga_ec} (>=20)"
    else
        fail "DGA_EVENT count=${dga_ec} expected >=20 (log_sent=${dga_log_sent})"
    fi
else
    fail "mock DGA ingest did not produce enough events (ec=${dga_ec})"
fi
ff=$(event_fail_fast_invariants "DGA_SIMULATION" "$(build_module_summary_from_events DGA_SIMULATION)" "dga_simulator" 2>/dev/null || true)
[[ "${ff}" != CODE_FAILURE ]] && pass "DGA fail-fast OK with events" || fail "unexpected DGA_SOT_BUG_FAIL_FAST with ec=${dga_ec}"

# --- Mock New TLD remote: 20 DNS_NEW_TLD_SENT ---
ntld_remote="${REMOTE_STATE_DIR}/events/new_tld_events.tsv"
printf '%s\n' "${EVENT_TSV_HEADER}" > "${ntld_remote}"
mock_ntld_webshell() {
    local i dom tld
    for ((i = 1; i <= 20; i++)); do
        dom="svc$(printf '%04x' "${i}").lbl${i}.click"
        tld="click"
        printf 'DNS_NEW_TLD_GENERATED domain=%s\n' "${dom}"
        printf 'DNS_NEW_TLD_SENT fqdn=%s qtype=A\n' "${dom}"
        printf 'NEW_TLD_EVENT timestamp=2020-01-01T00:00:00Z module=DNS_NEW_TLD stage=new_tld target=8.8.8.8 action=query status=sent value=%s|%s\n' "${dom}" "${tld}"
        printf '%s\t%s\tDNS_NEW_TLD\tnew_tld\t8.8.8.8\tquery\tdomain\tsent\t0\t%s|%s\tremote_new_tld_simulator\n' \
            "2020-01-01T00:00:01Z" "${CAMPAIGN_ID}" "${dom}" "${tld}"
        printf '%s\t%s\tDNS_NEW_TLD\tnew_tld\t8.8.8.8\tquery\tdomain\tresponse\t0\t%s|%s\tremote_new_tld_simulator\n' \
            "2020-01-01T00:00:02Z" "${CAMPAIGN_ID}" "${dom}" "${tld}"
    done
    echo "NEW_TLD_REMOTE_EVENT_FILE path=${ntld_remote} exists=yes lines=42"
    echo 'DNS_NEW_TLD_SUMMARY tested_domains=20 tested_tlds=click unique_tlds=1 query_count=20 query_types=A=20/AAAA=0/HTTPS=0/TXT=0 successful_queries=20 failed_queries=0 generated=20 valid=20 invalid=0 duration_seconds=0 detection_likelihood=LOW'
}
run_webshell_quick() {
    local tag="${1:-}"
    case "${tag}" in
        dga-ev-meta)
            if [[ -f "${dga_remote}" ]]; then
                printf 'DGA_REMOTE_META exists=yes size=%s lines=%s\n' \
                    "$(wc -c <"${dga_remote}" | tr -d ' ')" "$(awk 'END{print NR}' "${dga_remote}")"
            else
                printf 'DGA_REMOTE_META exists=no size=0 lines=0\n'
            fi
            ;;
        dga-ev-cat|dga-ev*)
            cat "${dga_remote}" 2>/dev/null || true
            ;;
        ntld-ev-meta)
            if [[ -f "${ntld_remote}" ]]; then
                printf 'NEW_TLD_REMOTE_META exists=yes size=%s lines=%s\n' \
                    "$(wc -c <"${ntld_remote}" | tr -d ' ')" "$(awk 'END{print NR}' "${ntld_remote}")"
            else
                printf 'NEW_TLD_REMOTE_META exists=no size=0 lines=0\n'
            fi
            ;;
        ntld-ev-cat|ntld-ev*)
            cat "${ntld_remote}" 2>/dev/null || true
            ;;
        *)
            mock_ntld_webshell
            ;;
    esac
}
export -f run_webshell_quick
init_event_store
ntld_out=$(mock_ntld_webshell)
dns_new_tld_replay_structured_logs "${ntld_out}" 2>/dev/null || true
parse_dns_new_tld_output "${ntld_out}"
ntld_log_sent=$(grep -c 'DNS_NEW_TLD_SENT ' "${LOG_DIR}/dns_new_tld_test.log" 2>/dev/null || echo 0)
ntld_log_sent=$(safe_int "${ntld_log_sent}")
ntld_ec=$(event_module_event_count "DNS_NEW_TLD")
if (( ntld_ec >= 20 )); then
    pass "NEW_TLD_SENT 20 => NEW_TLD_EVENT rows=${ntld_ec} (>=20)"
else
    fail "NEW_TLD_EVENT count=${ntld_ec} expected >=20 (log_sent=${ntld_log_sent})"
fi

# Fail-fast: log sent but zero events
_ff_local="${LOCAL_STATE_DIR}"
init_event_store
LOCAL_STATE_DIR="${_ff_local}"
export LOCAL_STATE_DIR
unset 'EVENT_STAGE_EXECUTED[DGA_SIMULATION|dga_simulator]' 2>/dev/null || true
EVENT_STAGE_EXECUTED=()
declare -gA EVENT_STAGE_EXECUTED 2>/dev/null || true
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
mkdir -p "${LOG_DIR}"
state_append "dga_simulation.log" "DGA_QUERY_SENT domain=x.test qtype=A phase=nx"
sent_n=$(state_log_count_pattern "dga_simulation.log" '^DGA_QUERY_SENT ')
(( sent_n > 0 )) && pass "fail-fast fixture log_sent=${sent_n}" || fail "fail-fast fixture missing DGA_QUERY_SENT in log"
EVENT_SOT_FAIL_FAST_FLAGS=""
ff=""
if ! event_fail_fast_invariants "DGA_SIMULATION" "generated=0 sent=0 event_count=0" "" >/dev/null 2>&1; then
    ff=CODE_FAILURE
fi
case "${ff}:${EVENT_SOT_FAIL_FAST_FLAGS}" in
    CODE_FAILURE:*DGA_SOT_BUG_FAIL_FAST*)
        pass "DGA_SOT_BUG_FAIL_FAST when log sent but events=0"
        ;;
    *)
        fail "expected DGA_SOT_BUG_FAIL_FAST got ff=${ff} flags=${EVENT_SOT_FAIL_FAST_FLAGS}"
        ;;
esac

unset -f run_webshell_quick 2>/dev/null || true
rm -rf "${LOCAL_STATE_DIR}" 2>/dev/null || true

if (( failures == 0 )); then
    printf '\nAll DGA/New TLD EVENT SOT tests passed.\n'
    exit 0
fi
printf '\n%d test(s) failed.\n' "${failures}"
exit 1
