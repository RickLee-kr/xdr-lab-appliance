# ==============================================================================
# Stellar PoC — Event-based Source of Truth (DNS/HTTP/DGA/NewTLD)
# @stellar-poc-version: 1.2.0
# Summary / validation / final decision read only state/events/*.tsv
# ==============================================================================

EVENT_STORE_DIR=""
EVENT_DNS_EVENTS=""
EVENT_HTTP_EVENTS=""
EVENT_DGA_EVENTS=""
EVENT_NEW_TLD_EVENTS=""
EVENT_CALLBACK_EVENTS=""
EVENT_TSV_HEADER=$'timestamp\trun_id\tmodule\tstage\ttarget\taction\tartifact\tstatus\texit_code\tevidence_value\tsource'
declare -gA EVENT_STAGE_EXECUTED=()
declare -gA EVENT_MODULE_SUMMARY=()
declare -gA EVENT_MODULE_VALIDATION=()
declare -gA EVENT_MODULE_DECISION=()
declare -gA EVENT_MODULE_FAILURE_REASON=()
EVENT_SOT_FAIL_FAST_FLAGS=""
EVENT_SOT_FINAL_REPORT=""
E2E_VALIDATION_REPORT=""
E2E_FAIL_FAST_FLAGS=""
LEGACY_DECISION_REFERENCES_FOUND=0
EVENT_SOT_VERSION="1.2.0"

event_store_state_dir() {
    if [[ -n "${POC_RUNTIME_DIR:-}" ]]; then
        printf '%s/state' "${POC_RUNTIME_DIR}"
    else
        printf '%s' "${LOCAL_STATE_DIR:-.}"
    fi
}

event_store_run_id() {
    printf '%s' "${POC_RUN_ID:-${CAMPAIGN_ID:-run}}"
}

event_store_paths_refresh() {
    local sdir
    sdir=$(event_store_state_dir)
    EVENT_STORE_DIR="${sdir}/events"
    EVENT_DNS_EVENTS="${EVENT_STORE_DIR}/dns_events.tsv"
    EVENT_HTTP_EVENTS="${EVENT_STORE_DIR}/http_events.tsv"
        EVENT_DGA_EVENTS="${EVENT_STORE_DIR}/dga_events.tsv"
    EVENT_NEW_TLD_EVENTS="${EVENT_STORE_DIR}/new_tld_events.tsv"
    EVENT_CALLBACK_EVENTS="${EVENT_STORE_DIR}/callback_events.tsv"
    EVENT_STORE_PATHS="dns=${EVENT_DNS_EVENTS} http=${EVENT_HTTP_EVENTS} dga=${EVENT_DGA_EVENTS} new_tld=${EVENT_NEW_TLD_EVENTS} callback=${EVENT_CALLBACK_EVENTS}"
}

ensure_event_store_files() {
    event_store_paths_refresh
    mkdir -p "${EVENT_STORE_DIR}" 2>/dev/null || true
    [[ -f "${EVENT_DNS_EVENTS}" ]] || printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_DNS_EVENTS}"
    [[ -f "${EVENT_HTTP_EVENTS}" ]] || printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_HTTP_EVENTS}"
        [[ -f "${EVENT_DGA_EVENTS}" ]] || printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_DGA_EVENTS}"
    [[ -f "${EVENT_NEW_TLD_EVENTS}" ]] || printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_NEW_TLD_EVENTS}"
    [[ -f "${EVENT_CALLBACK_EVENTS}" ]] || printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_CALLBACK_EVENTS}"
}

init_event_store() {
    event_store_paths_refresh
    log_message "OK" "EVENT_SOT_VERSION=${EVENT_SOT_VERSION}" >&2
    mkdir -p "${EVENT_STORE_DIR}" 2>/dev/null || true
    printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_DNS_EVENTS}"
    printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_HTTP_EVENTS}"
        printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_DGA_EVENTS}"
    printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_NEW_TLD_EVENTS}"
    printf '%s\n' "${EVENT_TSV_HEADER}" > "${EVENT_CALLBACK_EVENTS}"
    EVENT_STAGE_EXECUTED=()
    EVENT_MODULE_SUMMARY=()
    EVENT_SOT_FAIL_FAST_FLAGS=""
    log_message "OK" "EVENT_STORE_PATHS ${EVENT_STORE_PATHS}" >&2
}

event_store_append_tsv() {
    local file="$1" line="$2"
    local lock="${file}.lock"
    [[ -n "${file}" && -n "${line}" ]] || return 1
    if command -v flock >/dev/null 2>&1; then
        { flock -w 60 9 || return 1; printf '%s\n' "${line}" >> "${file}"; } 9>"${lock}"
    else
        printf '%s\n' "${line}" >> "${file}"
    fi
}

event_store_escape_tsv() {
    printf '%s' "${1:-}" | tr '\t\r\n' '   '
}

record_event() {
    local category="$1" file="" ts="" run_id="" line=""
    shift
    event_store_paths_refresh
    case "${category}" in
        dns) file="${EVENT_DNS_EVENTS}" ;;
        http) file="${EVENT_HTTP_EVENTS}" ;;
        dga) file="${EVENT_DGA_EVENTS}" ;;
        new_tld|newtld) file="${EVENT_NEW_TLD_EVENTS}" ;;
        callback) file="${EVENT_CALLBACK_EVENTS}" ;;
        *) return 1 ;;
    esac
    [[ -n "${file}" ]] || return 1
    ts=$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%SZ)
    run_id=$(event_store_run_id)
    # shellcheck disable=SC2034
    local timestamp="${ts}" run_id="${run_id}" module="" stage="" target="" action="" artifact="" status="" exit_code="0" evidence_value="" source="local"
    local kv k v
    for kv in "$@"; do
        [[ "${kv}" != *"="* ]] && continue
        k="${kv%%=*}"
        v="${kv#*=}"
        case "${k}" in
            timestamp) timestamp="${v}" ;;
            run_id) run_id="${v}" ;;
            module) module="${v}" ;;
            stage) stage="${v}" ;;
            target) target="${v}" ;;
            action) action="${v}" ;;
            artifact) artifact="${v}" ;;
            status) status="${v}" ;;
            exit_code) exit_code="${v}" ;;
            evidence_value) evidence_value="${v}" ;;
            source) source="${v}" ;;
            value) evidence_value="${v}" ;;
            fqdn) evidence_value="${v}"; artifact="fqdn" ;;
            url) evidence_value="${v}"; artifact="url" ;;
        esac
    done
    [[ -n "${module}" && -n "${stage}" ]] || return 1
    line="$(event_store_escape_tsv "${timestamp}")$(printf '\t')$(event_store_escape_tsv "${run_id}")$(printf '\t')$(event_store_escape_tsv "${module}")$(printf '\t')$(event_store_escape_tsv "${stage}")$(printf '\t')$(event_store_escape_tsv "${target}")$(printf '\t')$(event_store_escape_tsv "${action}")$(printf '\t')$(event_store_escape_tsv "${artifact}")$(printf '\t')$(event_store_escape_tsv "${status}")$(printf '\t')$(event_store_escape_tsv "${exit_code}")$(printf '\t')$(event_store_escape_tsv "${evidence_value}")$(printf '\t')$(event_store_escape_tsv "${source}")"
    event_store_append_tsv "${file}" "${line}"
}

event_stage_key() {
    printf '%s|%s' "$1" "$2"
}

event_stage_mark_executed() {
    local module="$1" stage="$2" key=""
    [[ -n "${module}" && -n "${stage}" ]] || return 0
    key=$(event_stage_key "${module}" "${stage}")
    EVENT_STAGE_EXECUTED["${key}"]=yes
}

record_dns_event() {
    local stage="$1" target="$2" action="$3" fqdn="$4" qtype="${5:-A}" status="${6:-sent}" exit_code="${7:-0}" source="${8:-local}" module="${9:-DNS_TUNNEL}"
    record_event dns \
        "module=${module}" "stage=${stage}" "target=${target}" "action=${action}" \
        "artifact=fqdn" "value=${fqdn}" "status=${status}" "exit_code=${exit_code}" \
        "evidence_value=${fqdn}|${qtype}" "source=${source}"
}

record_http_event() {
    local stage="$1" target="$2" url="$3" method="${4:-GET}" http_status="${5:-000}" curl_exit="${6:-0}" status="${7:-response}" source="${8:-local}" module="${9:-HTTP_URL_SCAN}"
    record_event http \
        "module=${module}" "stage=${stage}" "target=${target}" "action=request" \
        "artifact=url" "value=${url}" "status=${status}" "exit_code=${curl_exit}" \
        "evidence_value=${url}|${method}|${http_status}" "source=${source}"
}


record_dga_event() {
    local stage="$1" target="$2" domain="$3" qtype="${4:-A}" status="${5:-sent}" exit_code="${6:-0}" source="${7:-local}" tld="${8:-}"
    [[ -z "${tld}" && -n "${domain}" ]] && tld="${domain##*.}"
    record_event dga \
        "module=DGA" "stage=${stage}" "target=${target}" "action=query" \
        "artifact=domain" "value=${domain}" "status=${status}" "exit_code=${exit_code}" \
        "evidence_value=${domain}|${qtype}|${tld}" "source=${source}"
}

record_new_tld_event() {
    local stage="$1" target="$2" domain="$3" tld="$4" status="${5:-sent}" exit_code="${6:-0}" source="${7:-local}"
    record_event new_tld \
        "module=DNS_NEW_TLD" "stage=${stage}" "target=${target}" "action=query" \
        "artifact=domain" "value=${domain}" "status=${status}" "exit_code=${exit_code}" \
        "evidence_value=${domain}|${tld}" "source=${source}"
}

event_parse_kv_from_line() {
    local line="$1" key="$2"
    printf '%s' "${line}" | tr ' ' '\n' | sed -n "s/^${key}=//p" | head -n1
}

event_append_from_event_line() {
    local line="$1"
    line=$(printf '%s' "${line}" | tr -d '\r')
    case "${line}" in
        DNS_EVENT*|DNS_TUNNEL_EVENT*)
            local _fq _qt _sid _seq _plen
            _fq=$(event_parse_kv_from_line "${line}" fqdn)
            [[ -z "${_fq}" ]] && _fq=$(event_parse_kv_from_line "${line}" value)
            _qt=$(event_parse_kv_from_line "${line}" qtype)
            _sid=$(event_parse_kv_from_line "${line}" session_id)
            _seq=$(event_parse_kv_from_line "${line}" seq)
            _plen=$(event_parse_kv_from_line "${line}" payload_length)
            local _bid
            _bid=$(event_parse_kv_from_line "${line}" burst_id)
            record_event dns \
                "timestamp=$(event_parse_kv_from_line "${line}" timestamp)" \
                "run_id=$(event_parse_kv_from_line "${line}" run_id)" \
                "module=$(event_parse_kv_from_line "${line}" module)" \
                "stage=$(event_parse_kv_from_line "${line}" stage)" \
                "target=$(event_parse_kv_from_line "${line}" target)" \
                "action=$(event_parse_kv_from_line "${line}" action)" \
                "artifact=fqdn" \
                "value=${_fq}" \
                "status=$(event_parse_kv_from_line "${line}" status)" \
                "exit_code=$(event_parse_kv_from_line "${line}" exit_code)" \
                "evidence_value=${_fq}|${_qt}|${_sid}|${_seq}|${_plen}|${_bid}" \
                "source=$(event_parse_kv_from_line "${line}" source)"
            ;;
        HTTP_EVENT*|HTTP_URL_SCAN_EVENT*)
            record_event http \
                "timestamp=$(event_parse_kv_from_line "${line}" timestamp)" \
                "run_id=$(event_parse_kv_from_line "${line}" run_id)" \
                "module=$(event_parse_kv_from_line "${line}" module)" \
                "stage=$(event_parse_kv_from_line "${line}" stage)" \
                "target=$(event_parse_kv_from_line "${line}" target)" \
                "action=$(event_parse_kv_from_line "${line}" action)" \
                "artifact=url" \
                "value=$(event_parse_kv_from_line "${line}" url)" \
                "status=$(event_parse_kv_from_line "${line}" status)" \
                "exit_code=$(event_parse_kv_from_line "${line}" curl_exit)" \
                "evidence_value=$(event_parse_kv_from_line "${line}" url)|$(event_parse_kv_from_line "${line}" method)|$(event_parse_kv_from_line "${line}" http_status)" \
                "source=$(event_parse_kv_from_line "${line}" source)"
            ;;
        DGA_EVENT*)
            local _dom _tld _seed _qt
            _dom=$(event_parse_kv_from_line "${line}" domain)
            [[ -z "${_dom}" ]] && _dom=$(event_parse_kv_from_line "${line}" value)
            _tld=$(event_parse_kv_from_line "${line}" tld)
            [[ -z "${_tld}" && -n "${_dom}" ]] && _tld="${_dom##*.}"
            _seed=$(event_parse_kv_from_line "${line}" algorithm_seed)
            _qt=$(event_parse_kv_from_line "${line}" qtype)
            record_event dga \
                "timestamp=$(event_parse_kv_from_line "${line}" timestamp)" \
                "run_id=$(event_parse_kv_from_line "${line}" run_id)" \
                "module=$(event_parse_kv_from_line "${line}" module)" \
                "stage=$(event_parse_kv_from_line "${line}" stage)" \
                "target=$(event_parse_kv_from_line "${line}" target)" \
                "action=$(event_parse_kv_from_line "${line}" action)" \
                "artifact=domain" \
                "value=${_dom}" \
                "status=$(event_parse_kv_from_line "${line}" status)" \
                "exit_code=$(event_parse_kv_from_line "${line}" exit_code)" \
                "evidence_value=${_dom}|${_qt}|${_tld}|${_seed}" \
                "source=$(event_parse_kv_from_line "${line}" source)"
            ;;
        DNS_NEW_TLD_EVENT*|NEW_TLD_EVENT*)
            record_event new_tld \
                "timestamp=$(event_parse_kv_from_line "${line}" timestamp)" \
                "run_id=$(event_parse_kv_from_line "${line}" run_id)" \
                "module=$(event_parse_kv_from_line "${line}" module)" \
                "stage=$(event_parse_kv_from_line "${line}" stage)" \
                "target=$(event_parse_kv_from_line "${line}" target)" \
                "action=$(event_parse_kv_from_line "${line}" action)" \
                "status=$(event_parse_kv_from_line "${line}" status)" \
                "exit_code=$(event_parse_kv_from_line "${line}" exit_code)" \
                "evidence_value=$(event_parse_kv_from_line "${line}" value)" \
                "source=$(event_parse_kv_from_line "${line}" source)"
            ;;
    esac
}

event_merge_dns_tsv_content() {
    local content="$1" local_file="" line="" merged=0 hdr_seen=0
    event_store_paths_refresh
    local_file="${EVENT_DNS_EVENTS}"
    [[ -n "${local_file}" ]] || return 1
    mkdir -p "$(dirname "${local_file}")" 2>/dev/null || true
    [[ -f "${local_file}" ]] || printf '%s\n' "${EVENT_TSV_HEADER}" > "${local_file}"
    while IFS= read -r line || [[ -n "${line}" ]]; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        [[ -z "${line}" ]] && continue
        if [[ "${line}" == timestamp* ]]; then
            if (( hdr_seen == 0 )) && ! grep -q '^timestamp' "${local_file}" 2>/dev/null; then
                printf '%s\n' "${line}" >> "${local_file}"
            fi
            hdr_seen=1
            continue
        fi
        [[ "${line}" != *$'\t'* ]] && continue
        event_store_append_tsv "${local_file}" "${line}"
        merged=$((merged + 1))
    done <<< "$(printf '%s\n' "${content}")"
    printf '%s' "${merged}"
}

event_merge_dga_tsv_content() {
    local content="$1" local_file="" line="" merged=0 hdr_seen=0
    event_store_paths_refresh
    local_file="${EVENT_DGA_EVENTS}"
    [[ -n "${local_file}" ]] || return 1
    mkdir -p "$(dirname "${local_file}")" 2>/dev/null || true
    [[ -f "${local_file}" ]] || printf '%s\n' "${EVENT_TSV_HEADER}" > "${local_file}"
    while IFS= read -r line || [[ -n "${line}" ]]; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        [[ -z "${line}" ]] && continue
        if [[ "${line}" == timestamp* ]]; then
            if (( hdr_seen == 0 )) && ! grep -q '^timestamp' "${local_file}" 2>/dev/null; then
                printf '%s\n' "${line}" >> "${local_file}"
            fi
            hdr_seen=1
            continue
        fi
        [[ "${line}" != *$'\t'* ]] && continue
        event_store_append_tsv "${local_file}" "${line}"
        merged=$((merged + 1))
    done <<< "$(printf '%s\n' "${content}")"
    printf '%s' "${merged}"
}

event_merge_new_tld_tsv_content() {
    local content="$1" local_file="" line="" merged=0 hdr_seen=0
    event_store_paths_refresh
    local_file="${EVENT_NEW_TLD_EVENTS}"
    [[ -n "${local_file}" ]] || return 1
    mkdir -p "$(dirname "${local_file}")" 2>/dev/null || true
    [[ -f "${local_file}" ]] || printf '%s\n' "${EVENT_TSV_HEADER}" > "${local_file}"
    while IFS= read -r line || [[ -n "${line}" ]]; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        [[ -z "${line}" ]] && continue
        if [[ "${line}" == timestamp* ]]; then
            if (( hdr_seen == 0 )) && ! grep -q '^timestamp' "${local_file}" 2>/dev/null; then
                printf '%s\n' "${line}" >> "${local_file}"
            fi
            hdr_seen=1
            continue
        fi
        [[ "${line}" != *$'\t'* ]] && continue
        event_store_append_tsv "${local_file}" "${line}"
        merged=$((merged + 1))
    done <<< "$(printf '%s\n' "${content}")"
    printf '%s' "${merged}"
}


ingest_remote_events() {
    local out="$1" module_filter="${2:-}" stage_filter="${3:-}"
    local line="" n=0
    [[ -n "${out}" ]] || return 1
    event_store_paths_refresh
    while IFS= read -r line || [[ -n "${line}" ]]; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        case "${line}" in
            DNS_EVENT*|DNS_TUNNEL_EVENT*|HTTP_EVENT*|HTTP_URL_SCAN_EVENT*|DGA_EVENT*|DNS_NEW_TLD_EVENT*|NEW_TLD_EVENT*)
                if [[ -n "${module_filter}" ]]; then
                    case "${line}" in
                        DNS_EVENT*|DNS_TUNNEL_EVENT*) [[ "${module_filter}" == DNS* ]] || continue ;;
                        HTTP_EVENT*|HTTP_URL_SCAN_EVENT*) [[ "${module_filter}" == HTTP* ]] || continue ;;
                        DGA_EVENT*) [[ "${module_filter}" == DGA* ]] || continue ;;
                        *NEW_TLD*) [[ "${module_filter}" == *NEW_TLD* ]] || continue ;;
                    esac
                fi
                if [[ -n "${stage_filter}" && "${line}" != *"stage=${stage_filter}"* ]]; then
                    continue
                fi
                event_append_from_event_line "${line}"
                n=$((n + 1))
                ;;
        esac
    done <<< "$(printf '%s\n' "${out}")"
    (( n > 0 )) && return 0
    return 1
}

event_store_row_count() {
    local file="$1" n=0
    [[ -f "${file}" ]] || { printf '0'; return 0; }
    n=$(awk 'NR>1' "${file}" 2>/dev/null | wc -l | awk '{print $1}')
    printf '%s' "$(safe_int "${n}")"
}

event_sot_file_for_module() {
    case "${1}" in
        DNS_TUNNEL|DNS*) printf '%s' "${EVENT_DNS_EVENTS}" ;;
        HTTP_URL_SCAN|HTTP*) printf '%s' "${EVENT_HTTP_EVENTS}" ;;
        DGA|DGA*|DGA_SIMULATION) printf '%s' "${EVENT_DGA_EVENTS}" ;;
        DNS_NEW_TLD|NEW_TLD*) printf '%s' "${EVENT_NEW_TLD_EVENTS}" ;;
        *) printf '%s' "" ;;
    esac
}

event_local_label_entropy() {
    local lbl="$1" len unique score
    lbl="${lbl%%.*}"
    len=${#lbl}
    (( len < 1 )) && { printf '0'; return; }
    unique=$(printf '%s' "${lbl}" | fold -w1 | sort -u | wc -l | awk '{print $1}')
    score=$((unique * 100 / (len > 20 ? 20 : len)))
    (( len >= 18 )) && score=$((score + 10))
    printf '%s' "${score}"
}

build_module_summary_from_events() {
    local module="$1" file="" summary=""
    event_store_paths_refresh
    file=$(event_sot_file_for_module "${module}")
    if [[ -z "${file}" || ! -f "${file}" ]]; then
        printf '%s' "events=0 evidence_missing=yes"
        return 1
    fi
    case "${module}" in
        DNS_NEW_TLD|NEW_TLD*)
            summary=$(awk -F'\t' '
                NR==1 {next}
                ($3 ~ /^DNS_NEW_TLD/ || $3 ~ /^NEW_TLD/) {
                    generated++
                    if ($8=="sent" || $6=="query") sent++
                    if ($8=="response") response++
                    split($10,a,"|"); if (a[2]!="") tld[a[2]]=1
                }
                END {
                    nt=0; for (k in tld) nt++
                    ec=0
                    for (i=2; i<=NR; i++) if ($3 ~ /^DNS_NEW_TLD/ || $3 ~ /^NEW_TLD/) ec++
                    printf "generated=%d sent=%d response=%d unique_tld=%d events=%d event_count=%d",
                        generated+0, sent+0, response+0, nt, sent+response+0, ec
                }' "${file}" 2>/dev/null || printf 'generated=0 sent=0 response=0 unique_tld=0 events=0 event_count=0')
            ;;
        DNS_TUNNEL|DNS*)
            summary=$(awk -F'\t' '
                function idx_payload_len(lbl,   p) {
                    if (lbl !~ /^idx-[0-9]+-/) return 0
                    p=lbl; sub(/^idx-[0-9]+-/,"",p); return length(p)
                }
                NR==1 {next}
                $3 ~ /^DNS/ && ($4=="dns_tunnel_file_client" || $4=="dns_tunnel_simulator") {
                    if ($6=="query" && $8 ~ /^(sent|response|timeout|error)$/) {
                        sent++
                        tgt[$5]=1
                        if ($8=="sent") sendto_ok++
                    }
                    if ($10!="") {
                        split($10,a,"|"); fq=a[1]
                        if (fq!="") {
                            fqdn[fq]=1
                            lbl=fq; sub(/\..*/,"",lbl)
                            pl=idx_payload_len(lbl)
                            if (pl>0) { pl_sum+=pl; pl_n++ }
                            if (lbl ~ /^idx-/) idx_cnt++
                            if (length(a)>=6 && a[6]+0>0) bytes_sum+=a[6]+0
                        }
                    }
                }
                END {
                    n=0; for (k in fqdn) n++
                    nt=0; for (k in tgt) nt++
                    avg_pl=0
                    if (pl_n>0) avg_pl=int(pl_sum/pl_n)
                    ec=0
                    for (i=2; i<=NR; i++) if ($3 ~ /^DNS/ && ($4=="dns_tunnel_file_client" || $4=="dns_tunnel_simulator")) ec++
                    printf "generated=0 sent=%d response=0 timeout=0 nxdomain=0 error=0 unique_fqdn=%d avg_payload_label_length=%d avg_label_length=%d entropy_score=0 idx_pattern_count=%d unique_sequence=0 burst_count=0 session_count=0 target_count=%d bytes_encoded=%d sendto_success=%d events=%d event_count=%d",
                        sent+0, n, avg_pl, avg_pl, idx_cnt+0, nt, bytes_sum+0, sendto_ok+0, sent+0, ec
                }' "${file}" 2>/dev/null || printf 'generated=0 sent=0 response=0 timeout=0 nxdomain=0 error=0 unique_fqdn=0 avg_payload_label_length=0 avg_label_length=0 entropy_score=0 idx_pattern_count=0 unique_sequence=0 burst_count=0 session_count=0 target_count=0 bytes_encoded=0 sendto_success=0 events=0 event_count=0')
            ;;
        HTTP_URL_SCAN|HTTP*)
            summary=$(awk -F'\t' '
                NR==1 {next}
                $3 ~ /^HTTP/ {
                    attempted++
                    st=$8
                    if (st=="response") completed++
                    if (st=="timeout") timeout++
                    if (st=="connection_refused") conn_ref++
                    if (st=="dns_failure") dns_fail++
                    split($10,a,"|")
                    hs=a[3]+0
                    if (hs>=400 && hs<500) h4++
                    if (hs>=500) h5++
                }
                END {
                    ec=0
                    for (i=2; i<=NR; i++) if ($3 ~ /^HTTP/) ec++
                    printf "generated=%d attempted=%d completed=%d responses=%d timeout=%d connection_refused=%d dns_failure=%d http_4xx=%d http_5xx=%d events=%d event_count=%d",
                        attempted, attempted, completed, completed, timeout, conn_ref+0, dns_fail+0, h4+0, h5+0, attempted, ec
                }' "${file}" 2>/dev/null || printf 'generated=0 attempted=0 completed=0 responses=0 timeout=0 connection_refused=0 dns_failure=0 http_4xx=0 http_5xx=0 events=0 event_count=0')
            ;;
        DGA|DGA*|DGA_SIMULATION)
            summary=$(awk -F'\t' '
                NR==1 {next}
                ($3=="DGA" || $3 ~ /^DGA/) && ($4=="dga_model_client" || $4=="dga_simulator") {
                    if ($8=="generated") generated++
                    if ($8=="sent") sent++
                    if ($8=="nxdomain") nx++
                    if ($8=="response") resolvable++
                    if ($8=="timeout") to++
                    if ($8=="error") err++
                    split($10,a,"|")
                    if (a[1]!="") dom[a[1]]=1
                    if (a[3]=="nx") nx_sent++
                    if (a[3]=="res") resolvable_sent++
                    if (a[4]!="") base_dom[a[4]]=1
                }
                END {
                    n=0; for (k in dom) n++
                    bd="unknown"
                    for (k in base_dom) { bd=k; break }
                    ec=0
                    for (i=2; i<=NR; i++) if (($3=="DGA" || $3 ~ /^DGA/) && ($4=="dga_model_client" || $4=="dga_simulator")) ec++
                    printf "generated=%d sent=%d nxdomain=%d resolvable=%d timeout=%d error=%d unique_domain=%d nx_sent=%d resolvable_sent=%d base_domain=%s same_base_domain=%s events=%d event_count=%d",
                        generated+0, sent+0, nx+0, resolvable+0, to+0, err+0, n, nx_sent+0, resolvable_sent+0, bd, (bd=="xdr.ooo"?"yes":"no"), sent+nx+resolvable+to+err, ec
                }' "${file}" 2>/dev/null || printf 'generated=0 sent=0 nxdomain=0 resolvable=0 timeout=0 error=0 unique_domain=0 nx_sent=0 resolvable_sent=0 base_domain=unknown same_base_domain=no events=0 event_count=0')
            ;;
        *)
            printf '%s' "events=0"
            return 1
            ;;
    esac
    EVENT_MODULE_SUMMARY["${module}"]="${summary}"
    printf '%s' "${summary}"
}

event_summary_field() {
    local summary="$1" key="$2" default="${3:-0}"
    local v
    v=$(printf '%s' "${summary}" | tr ' ' '\n' | sed -n "s/^${key}=//p" | head -n1)
    [[ -n "${v}" ]] || v="${default}"
    printf '%s' "${v}"
}

event_fail_fast_invariants() {
    local module="$1" summary="$2" stage="${3:-}"
    local sent=0 unique=0 attempted=0 completed=0 timeout=0 conn=0 dnsf=0 ev_count=0
    local ps=0 gen=0 ec=0 file=""
    sent=$(safe_int "$(event_summary_field "${summary}" sent 0)")
    unique=$(safe_int "$(event_summary_field "${summary}" unique_fqdn 0)")
    attempted=$(safe_int "$(event_summary_field "${summary}" attempted 0)")
    completed=$(safe_int "$(event_summary_field "${summary}" completed 0)")
    timeout=$(safe_int "$(event_summary_field "${summary}" timeout 0)")
    conn=$(safe_int "$(event_summary_field "${summary}" connection_refused 0)")
    dnsf=$(safe_int "$(event_summary_field "${summary}" dns_failure 0)")
    ev_count=$(safe_int "$(event_summary_field "${summary}" events 0)")
    ec=$(safe_int "$(event_summary_field "${summary}" event_count 0)")
    ps=$(safe_int "$(event_summary_field "${summary}" packets_sent 0)")
    gen=$(safe_int "$(event_summary_field "${summary}" generated 0)")
    file=$(event_sot_file_for_module "${module}")
    if (( ec == 0 )) && [[ -n "${file}" && -f "${file}" ]]; then
        ec=$(event_store_row_count "${file}")
    fi
    (( ev_count == 0 && ec > 0 )) && ev_count="${ec}"

    if [[ -n "${stage}" && "${EVENT_STAGE_EXECUTED[$(event_stage_key "${module}" "${stage}")]:-}" == yes && ec -eq 0 ]]; then
        EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} ${module}_EVENT_FILE_MISSING"
        log_message "ERROR" "${module}_BUG_FAIL_FAST reason=EVENT_file_missing_while_stage_executed stage=${stage}" >&2
        printf '%s' "CODE_FAILURE"
        return 1
    fi
    if [[ ! -f "${file}" && "${EVENT_STAGE_EXECUTED[$(event_stage_key "${module}" "${stage}")]:-}" == yes ]]; then
        EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} ${module}_SOT_FILE_DELETED"
        log_message "ERROR" "${module}_BUG_FAIL_FAST reason=SOT_file_deleted stage=${stage}" >&2
        printf '%s' "CODE_FAILURE"
        return 1
    fi
    case "${module}" in
        DNS_TUNNEL|DNS*)
            if (( sent > 0 && ec == 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} DNS_TUNNEL_SOT_FAIL_FAST"
                log_message "ERROR" "DNS_TUNNEL_SOT_FAIL_FAST query_sent=${sent} event_count=0" >&2
                printf '%s' "CODE_FAILURE"
                return 1
            fi
            if (( sent > 0 && unique == 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} DNS_SOT_BUG_FAIL_FAST"
                log_message "ERROR" "DNS_SOT_BUG_FAIL_FAST sent=${sent} unique_fqdn=0" >&2
                printf '%s' "CODE_FAILURE"
                return 1
            fi
            ;;
        HTTP_URL_SCAN|HTTP*)
            if (( (attempted > 0 || completed > 0) && ec == 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} HTTP_SOT_BUG_FAIL_FAST"
                log_message "ERROR" "HTTP_SOT_BUG_FAIL_FAST attempted=${attempted} responses=${completed} event_count=0" >&2
                printf '%s' "CODE_FAILURE"
                return 1
            fi
            if (( attempted > 0 && completed == 0 && timeout == 0 && conn == 0 && dnsf == 0 && ec > 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} HTTP_SOT_BUG_FAIL_FAST"
                log_message "ERROR" "HTTP_SOT_BUG_FAIL_FAST attempted=${attempted} completed=0 timeouts=0 connection_refused=0 dns_failure=0" >&2
                printf '%s' "CODE_FAILURE"
                return 1
            fi
            ;;
        DGA*|DGA_SIMULATION)
            local dga_log_sent=0
            dga_log_sent=$(state_log_count_pattern "dga_simulation.log" '^DGA_QUERY_SENT ')
            if (( dga_log_sent > 0 && ec == 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} DGA_SOT_BUG_FAIL_FAST"
                log_message "ERROR" "DGA_SOT_BUG_FAIL_FAST log_sent=${dga_log_sent} event_count=0" >&2
                printf '%s' "CODE_FAILURE"
                return 1
            fi
            if (( gen > 0 && ec == 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} DGA_SOT_BUG_FAIL_FAST"
                log_message "ERROR" "DGA_SOT_BUG_FAIL_FAST generated=${gen} event_count=0" >&2
                printf '%s' "CODE_FAILURE"
                return 1
            fi
            ;;
        DNS_NEW_TLD|NEW_TLD*)
            local ntld_log_sent=0
            ntld_log_sent=$(state_log_count_pattern "dns_new_tld_test.log" 'DNS_NEW_TLD_SENT ')
            if (( ntld_log_sent > 0 && ec == 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} NEW_TLD_SOT_BUG_FAIL_FAST"
                log_message "ERROR" "NEW_TLD_SOT_BUG_FAIL_FAST log_sent=${ntld_log_sent} event_count=0" >&2
                printf '%s' "CODE_FAILURE"
                return 1
            fi
            if (( sent > 0 && ec == 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} NEW_TLD_SOT_BUG_FAIL_FAST"
                log_message "ERROR" "NEW_TLD_SOT_BUG_FAIL_FAST sent=${sent} event_count=0" >&2
                printf '%s' "CODE_FAILURE"
                return 1
            fi
            ;;
    esac
    return 0
}

validate_event_store_integrity() {
    local module="" summary="" ff="" ok=true stage=""
    event_store_paths_refresh
    for module in DNS_TUNNEL HTTP_URL_SCAN DGA_SIMULATION DNS_NEW_TLD; do
        case "${module}" in
            DNS_TUNNEL) stage="dns_tunnel_file_client" ;;
            HTTP_URL_SCAN) stage="${HTTP_URL_SCAN_RUN_ID:-main}" ;;
            *) stage="" ;;
        esac
        summary=$(build_module_summary_from_events "${module}" 2>/dev/null || true)
        ff=$(event_fail_fast_invariants "${module}" "${summary}" "${stage}" 2>/dev/null || true)
        if [[ "${ff}" == CODE_FAILURE ]]; then
            ok=false
        fi
    done
    [[ "${ok}" == true ]]
}

event_reject_stdout_only_success() {
    local module="$1" stdout_blob="${2:-}"
    local summary="" ev_count=0 attempted=0 sent=0
    local stdout_attempted=0 stdout_responses=0
    summary=$(build_module_summary_from_events "${module}" 2>/dev/null || true)
    ev_count=$(safe_int "$(event_summary_field "${summary}" event_count 0)")
    (( ev_count == 0 )) && ev_count=$(safe_int "$(event_summary_field "${summary}" events 0)")
    if [[ -n "${stdout_blob}" ]]; then
        stdout_attempted=$(safe_int "$(printf '%s' "${stdout_blob}" | tr ' ' '\n' | sed -n 's/^attempted=//p' | head -n1)")
        stdout_responses=$(safe_int "$(printf '%s' "${stdout_blob}" | tr ' ' '\n' | sed -n 's/^responses=//p' | head -n1)")
        (( stdout_attempted == 0 )) && stdout_attempted=$(safe_int "$(printf '%s' "${stdout_blob}" | tr ' ' '\n' | sed -n 's/^total_requests=//p' | head -n1)")
        (( stdout_responses == 0 )) && stdout_responses=$(safe_int "$(printf '%s' "${stdout_blob}" | tr ' ' '\n' | sed -n 's/^success=//p' | head -n1)")
    fi
    if (( ev_count == 0 && ( stdout_attempted > 0 || stdout_responses > 0 ) )); then
        printf '%s %s' "CODE_FAILURE" "evidence_missing"
        return 1
    fi
    read -r _dec _reason <<< "$(validate_module_from_summary "${module}" "${summary}" "")"
    if [[ "${_dec}" == success ]]; then
        printf '%s %s' "CODE_FAILURE" "evidence_missing"
        return 1
    fi
    printf '%s %s' "${_dec}" "${_reason}"
    return 0
}

validate_module_from_summary() {
    local module="$1" summary="$2" stage="${3:-}"
    local decision="" reason="" ff=""
    ff=$(event_fail_fast_invariants "${module}" "${summary}" "${stage}" 2>/dev/null || true)
    if [[ "${ff}" == CODE_FAILURE ]]; then
        printf '%s %s' "failed" "code_failure:${EVENT_SOT_FAIL_FAST_FLAGS}"
        return 0
    fi
    case "${module}" in
        DNS_TUNNEL|DNS*)
            local sent unique ev_count
            sent=$(safe_int "$(event_summary_field "${summary}" sent 0)")
            unique=$(safe_int "$(event_summary_field "${summary}" unique_fqdn 0)")
            ev_count=$(safe_int "$(event_summary_field "${summary}" event_count 0)")
            (( ev_count < 1 )) && ev_count=$(event_module_event_count "${module}")
            if (( ev_count == 0 && sent == 0 )); then
                printf '%s %s' "failed" "no_queries_executed"
                return 0
            fi
            if (( ev_count > 0 )); then
                printf '%s %s' "success" "dns_tunnel_event_count=${ev_count}"
                return 0
            fi
            printf '%s %s' "failed" "no_dns_events"
            ;;
        HTTP_URL_SCAN|HTTP*)
            local attempted completed ev_count h4 responses gen
            attempted=$(safe_int "$(event_summary_field "${summary}" attempted 0)")
            completed=$(safe_int "$(event_summary_field "${summary}" completed 0)")
            responses=$(safe_int "$(event_summary_field "${summary}" responses 0)")
            (( responses < 1 )) && responses="${completed}"
            gen=$(safe_int "$(event_summary_field "${summary}" generated 0)")
            (( gen < 1 )) && gen="${attempted}"
            ev_count=$(safe_int "$(event_summary_field "${summary}" event_count 0)")
            (( ev_count < 1 )) && ev_count=$(safe_int "$(event_summary_field "${summary}" events 0)")
            (( ev_count < 1 )) && ev_count=$(event_module_event_count "${module}")
            h4=$(safe_int "$(event_summary_field "${summary}" http_4xx 0)")
            if (( ev_count == 0 )); then
                printf '%s %s' "failed" "sot_file_missing"
                return 0
            fi
            if (( attempted > 0 && responses > 0 )); then
                printf '%s %s' "success" "http_access_detected"
                return 0
            fi
            if (( attempted > 0 )); then
                printf '%s %s' "partial" "http_connection_attempted"
                return 0
            fi
            printf '%s %s' "failed" "http_no_access"
            ;;
        DGA|DGA*|DGA_SIMULATION)
            local nx res nx_sent res_sent same_bd base_dom ev_count
            nx=$(safe_int "$(event_summary_field "${summary}" nxdomain 0)")
            res=$(safe_int "$(event_summary_field "${summary}" resolvable 0)")
            nx_sent=$(safe_int "$(event_summary_field "${summary}" nx_sent 0)")
            res_sent=$(safe_int "$(event_summary_field "${summary}" resolvable_sent 0)")
            same_bd=$(event_summary_field "${summary}" same_base_domain "no")
            base_dom=$(event_summary_field "${summary}" base_domain "unknown")
            ev_count=$(safe_int "$(event_summary_field "${summary}" event_count 0)")
            (( ev_count < 1 )) && ev_count=$(event_module_event_count "${module}")
            if (( ev_count > 0 && nx == 0 && res == 0 )); then
                printf '%s %s' "failed" "dga_event_count_only_forbidden"
                return 0
            fi
            if [[ "${same_bd}" != yes && "${base_dom}" != xdr.ooo ]]; then
                printf '%s %s' "failed" "dga_wrong_base_domain"
                return 0
            fi
            if (( nx >= 500 && res >= 20 )); then
                printf '%s %s' "success" "dga_model_full_success"
                return 0
            fi
            if (( nx >= 300 && res >= 10 )); then
                printf '%s %s' "success" "dga_model_success"
                return 0
            fi
            if (( nx >= 150 && res >= 5 )); then
                printf '%s %s' "partial" "dga_model_partial"
                return 0
            fi
            printf '%s %s' "failed" "dga_model_insufficient"
            ;;
        DNS_NEW_TLD|NEW_TLD*)
            local resp ut
            resp=$(safe_int "$(event_summary_field "${summary}" response 0)")
            ut=$(safe_int "$(event_summary_field "${summary}" unique_tld 0)")
            if (( resp > 0 && ut > 0 )); then
                printf '%s %s' "success" "new_tld_sot"
            elif (( resp > 0 )); then
                printf '%s %s' "partial" "new_tld_partial"
            else
                printf '%s %s' "failed" "new_tld_insufficient"
            fi
            ;;
        *)
            printf '%s %s' "failed" "unknown_module"
            ;;
    esac
}

event_apply_module_validation() {
    local module="$1" stage="${2:-}" telem_var="" reason_var=""
    local summary="" decision="" reason="" validation="" ff=""
    case "${module}" in
        DNS_TUNNEL) telem_var=TELEMETRY_VAL_DNS_TUNNEL; reason_var=TELEMETRY_VAL_DNS_REASON; stage="${stage:-dns_tunnel_file_client}" ;;
        HTTP_URL_SCAN) telem_var=TELEMETRY_VAL_HTTP_URL_SCAN; reason_var=TELEMETRY_VAL_HTTP_REASON ;;
        DGA_SIMULATION|DGA) telem_var=TELEMETRY_VAL_DGA_SIMULATION; reason_var=TELEMETRY_VAL_DGA_REASON ;;
        DNS_NEW_TLD) telem_var=TELEMETRY_VAL_NEW_TLD; reason_var=TELEMETRY_VAL_NEW_TLD_REASON ;;
        *) return 1 ;;
    esac
    summary=$(build_module_summary_from_events "${module}" 2>/dev/null || true)
    ff=$(event_fail_fast_invariants "${module}" "${summary}" "${stage}" 2>/dev/null || true)
    if [[ "${ff}" == CODE_FAILURE ]]; then
        decision="failed"
        reason="code_failure:${EVENT_SOT_FAIL_FAST_FLAGS}"
        validation="CODE_FAILURE"
    else
        read -r decision reason <<< "$(validate_module_from_summary "${module}" "${summary}" "${stage}")"
        validation="${decision^^}"
        [[ "${decision}" == success ]] && validation="SUCCESS"
        [[ "${decision}" == partial ]] && validation="PARTIAL"
        [[ "${decision}" == failed ]] && validation="FAILED"
        [[ "${decision}" == skipped ]] && validation="SKIPPED"
    fi
    EVENT_MODULE_SUMMARY["${module}"]="${summary}"
    EVENT_MODULE_VALIDATION["${module}"]="${validation}"
    EVENT_MODULE_DECISION["${module}"]="${decision}"
    EVENT_MODULE_FAILURE_REASON["${module}"]="${reason}"
    printf -v "${telem_var}" '%s' "${decision}"
    printf -v "${reason_var}" '%s' "${reason} ${summary}"
    if [[ "${module}" == DNS_TUNNEL ]]; then
        local dns_ec=0
        dns_ec=$(safe_int "$(event_summary_field "${summary}" event_count 0)")
        (( dns_ec < 1 )) && dns_ec=$(event_module_event_count "${module}")
        log_message "OK" "MODULE_VALIDATION module=${module} result=${validation} event_count=${dns_ec} decision=${decision} reason=${reason}" >&2
    else
        log_message "OK" "EVENT_SOT_VALIDATION module=${module} decision=${decision} validation=${validation} reason=${reason}" >&2
    fi
}

event_apply_all_module_validations() {
    event_store_paths_refresh
    event_apply_module_validation "DNS_TUNNEL" "dns_tunnel_file_client"
    event_apply_module_validation "HTTP_URL_SCAN" "main"
    event_apply_module_validation "DGA_SIMULATION" ""
    event_apply_module_validation "DNS_NEW_TLD" ""
}

event_sync_legacy_counters_from_sot() {
    local dns_sum http_sum dga_sum ntld_sum
    dns_sum=$(build_module_summary_from_events "DNS_TUNNEL" 2>/dev/null || true)
    http_sum=$(build_module_summary_from_events "HTTP_URL_SCAN" 2>/dev/null || true)
    dga_sum=$(build_module_summary_from_events "DGA_SIMULATION" 2>/dev/null || true)
    ntld_sum=$(build_module_summary_from_events "DNS_NEW_TLD" 2>/dev/null || true)
    DNS_QUERY_SENT_COUNT=$(safe_int "$(event_summary_field "${dns_sum}" sent 0)")
    DNS_TUNNEL_FQDN_COUNT=$(safe_int "$(event_summary_field "${dns_sum}" unique_fqdn 0)")
    DNS_TUNNEL_UNIQUE_QUERIES="${DNS_TUNNEL_FQDN_COUNT}"
    DNS_TUNNEL_APPROX_ENTROPY=$(safe_int "$(event_summary_field "${dns_sum}" entropy_score 0)")
    DNS_QUERY_RESPONDED_COUNT=$(safe_int "$(event_summary_field "${dns_sum}" response 0)")
    DNS_QUERIES_ATTEMPTED="${DNS_QUERY_SENT_COUNT}"
    HTTP_URL_ATTEMPT_COUNT=$(safe_int "$(event_summary_field "${http_sum}" attempted 0)")
    HTTP_URL_COMPLETE_COUNT=$(safe_int "$(event_summary_field "${http_sum}" completed 0)")
    HTTP_URL_SCAN_REAL_FAILED=$(safe_int "$(event_summary_field "${http_sum}" http_4xx 0)")
    HTTP_RESPONSES_RECEIVED="${HTTP_URL_COMPLETE_COUNT}"
    HTTP_REQUESTS_ATTEMPTED="${HTTP_URL_ATTEMPT_COUNT}"
    DGA_TOTAL_QUERIES=$(safe_int "$(event_summary_field "${dga_sum}" sent 0)")
    DGA_NXDOMAIN_COUNT=$(safe_int "$(event_summary_field "${dga_sum}" nxdomain 0)")
    DGA_RESOLVED_COUNT=$(safe_int "$(event_summary_field "${dga_sum}" resolvable 0)")
    DGA_QUERY_SENT_COUNT="${DGA_TOTAL_QUERIES}"
    DNS_NEW_TLD_ACTUAL_DNS_QUERIES_SENT=$(safe_int "$(event_summary_field "${ntld_sum}" sent 0)")
    DNS_NEW_TLD_SUCCESSFUL_QUERIES=$(safe_int "$(event_summary_field "${ntld_sum}" response 0)")
    DNS_NEW_TLD_UNIQUE_TLDS=$(safe_int "$(event_summary_field "${ntld_sum}" unique_tld 0)")
}

event_module_event_count() {
    local module="$1" file=""
    event_store_paths_refresh
    file=$(event_sot_file_for_module "${module}")
    event_store_row_count "${file}"
}

e2e_state_log_tail() {
    local logfile="$1" pattern="$2"
    local path=""
    [[ -n "${LOCAL_STATE_DIR:-}" ]] || return 0
    path="${LOCAL_STATE_DIR}/${logfile}"
    [[ -f "${path}" ]] || return 0
    grep -E "${pattern}" "${path}" 2>/dev/null | tail -n1 | while IFS= read -r line; do
        [[ -n "${line}" ]] && log_message "OK" "${line}" >&2
    done
}

e2e_emit_dns_pipeline_replay() {
    e2e_state_log_tail "dns_tunnel_simulator.log" '^DNS_REMOTE_EVENT_FILE '
    e2e_state_log_tail "dns_tunnel_simulator.log" '^DNS_REMOTE_EVENT_FETCH '
    e2e_state_log_tail "dns_tunnel_simulator.log" '^DNS_EVENT_MERGE_RESULT '
    e2e_state_log_tail "dns_tunnel_simulator.log" '^DNS_SOT_REFRESH '
}

e2e_emit_dga_final_summary() {
    local summary="" nx=0 res=0 nx_sent=0 res_sent=0 base_dom="" same_bd="" ec=0 msg="" success_rate=0
    summary=$(build_module_summary_from_events "DGA_SIMULATION" 2>/dev/null || true)
    nx=$(safe_int "$(event_summary_field "${summary}" nxdomain 0)")
    res=$(safe_int "$(event_summary_field "${summary}" resolvable 0)")
    nx_sent=$(safe_int "$(event_summary_field "${summary}" nx_sent 0)")
    res_sent=$(safe_int "$(event_summary_field "${summary}" resolvable_sent 0)")
    base_dom=$(event_summary_field "${summary}" base_domain "xdr.ooo")
    same_bd=$(event_summary_field "${summary}" same_base_domain "no")
    ec=$(safe_int "$(event_summary_field "${summary}" event_count 0)")
    (( ec < 1 )) && ec=$(event_module_event_count "DGA_SIMULATION")
    (( nx_sent + res_sent > 0 )) && success_rate=$(( (nx + res) * 100 / (nx_sent + res_sent) ))
    msg="DGA Model Traffic base_domain=${base_dom} nx_sent=${nx_sent} nx_nxdomain=${nx} resolvable_sent=${res_sent} resolvable_resolved=${res} success_rate=${success_rate} same_base_domain=${same_bd} event_count=${ec}"
    log_message "OK" "${msg}" >&2
    state_append "dga_simulation.log" "${msg}" 2>/dev/null || true
    msg="DGA_FINAL_SUMMARY base_domain=${base_dom} nx_sent=${nx_sent} nx_nxdomain=${nx} resolvable_sent=${res_sent} resolvable_resolved=${res} success_rate=${success_rate} event_count=${ec}"
    log_message "OK" "${msg}" >&2
    state_append "dga_simulation.log" "${msg}" 2>/dev/null || true
}

state_log_count_pattern() {
    local log_name="$1" pattern="$2" log_file="" n=0
    if [[ -n "${LOCAL_STATE_DIR:-}" && -f "${LOCAL_STATE_DIR}/${log_name}" ]]; then
        log_file="${LOCAL_STATE_DIR}/${log_name}"
    else
        log_file="${LOG_DIR:-${LOCAL_STATE_DIR:-/tmp}/logs}/${log_name}"
    fi
    [[ -f "${log_file}" ]] || { printf '0'; return 0; }
    n=$(grep -cE "${pattern}" "${log_file}" 2>/dev/null || true)
    printf '%s' "$(safe_int "${n}")"
}

e2e_check_module_event_missing() {
    local module="$1" summary="$2"
    local attempted=0 responses=0 completed=0 gen=0 sent=0 ps=0 ec=0 flag="" log_sent=0 log_ev=0
    ec=$(safe_int "$(event_summary_field "${summary}" event_count 0)")
    (( ec < 1 )) && ec=$(event_module_event_count "${module}")
    case "${module}" in
        HTTP_URL_SCAN)
            attempted=$(safe_int "$(event_summary_field "${summary}" attempted 0)")
            responses=$(safe_int "$(event_summary_field "${summary}" responses 0)")
            completed=$(safe_int "$(event_summary_field "${summary}" completed 0)")
            (( responses < 1 )) && responses="${completed}"
            if (( attempted > 0 && responses > 0 && ec == 0 )); then
                flag="HTTP_E2E_EVENT_MISSING"
            fi
            ;;
        DGA_SIMULATION)
            gen=$(safe_int "$(event_summary_field "${summary}" generated 0)")
            sent=$(safe_int "$(event_summary_field "${summary}" sent 0)")
            log_sent=$(state_log_count_pattern "dga_simulation.log" '^DGA_QUERY_SENT ')
            log_ev=$(state_log_count_pattern "dga_simulation.log" '^DGA_EVENT ')
            if (( log_sent > 0 && ec == 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} DGA_SOT_BUG_FAIL_FAST"
                log_message "ERROR" "DGA_SOT_BUG_FAIL_FAST log_sent=${log_sent} event_count=${ec}" >&2
                flag="DGA_SOT_BUG_FAIL_FAST"
            elif (( gen > 0 && sent > 0 && ec == 0 )); then
                flag="DGA_E2E_EVENT_MISSING"
            fi
            ;;
        DNS_NEW_TLD)
            sent=$(safe_int "$(event_summary_field "${summary}" sent 0)")
            log_sent=$(state_log_count_pattern "dns_new_tld_test.log" 'DNS_NEW_TLD_SENT ')
            if (( log_sent > 0 && ec == 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} NEW_TLD_SOT_BUG_FAIL_FAST"
                log_message "ERROR" "NEW_TLD_SOT_BUG_FAIL_FAST log_sent=${log_sent} event_count=${ec}" >&2
                flag="NEW_TLD_SOT_BUG_FAIL_FAST"
            elif (( sent > 0 && ec == 0 )); then
                flag="NEW_TLD_E2E_EVENT_MISSING"
            fi
            ;;
        DNS_TUNNEL)
            sent=$(safe_int "$(event_summary_field "${summary}" sent 0)")
            log_sent=$(state_log_count_pattern "dns_tunnel_simulator.log" 'DNS_TUNNEL_FILE_CLIENT start|DNS_TUNNEL_FILE_CLIENT_START|DNS_TUNNEL_TARGET_SELECTED|DNS_TUNNEL_REMOTE_BOOTSTRAP phase=run')
            if (( log_sent > 0 && ec == 0 )); then
                EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} DNS_REMOTE_BOOTSTRAP_FAIL"
                log_message "ERROR" "DNS_REMOTE_BOOTSTRAP_FAIL log_started=${log_sent} event_count=${ec}" >&2
                flag="DNS_REMOTE_BOOTSTRAP_FAIL"
            elif (( sent > 0 && ec == 0 )); then
                flag="DNS_E2E_EVENT_MISSING"
            fi
            ;;
    esac
    if [[ -n "${flag}" ]]; then
        E2E_FAIL_FAST_FLAGS="${E2E_FAIL_FAST_FLAGS} ${flag}"
        log_message "ERROR" "${flag} module=${module} summary=${summary}" >&2
        return 1
    fi
    return 0
}

e2e_extract_function_body() {
    local file="$1" fn="$2"
    awk -v fn="${fn}" '
        $0 ~ "^" fn "\\(\\)" { active=1; next }
        active && /^[a-zA-Z_][a-zA-Z0-9_]*\(\)/ { active=0 }
        active { print }
    ' "${file}" 2>/dev/null || true
}

e2e_audit_legacy_decision_references() {
    local root="${POC_REPO_ROOT:-.}" count=0 hits="" f="" pat="" body="" fn=""
    local -a decision_funcs=(
        validate_module_from_summary
        event_apply_module_validation
        event_fail_fast_invariants
        net_sim_block_stdout_final_decision
        compute_final_telemetry_validation
        apply_dns_tunnel_enhanced_final_decision
        finalize_dga_simulation_stage_judgment
        http_url_scan_decision_evaluate
    )
    local -a patterns=(
        'grep -c'
        'attempted_success'
        'DNS_QUERY_SENT_COUNT'
        'HTTP_URL_GENERATED'
    )
    for f in "${root}/stellar_poc_event_sot.sh" "${root}/stellar_poc_network_simulators.sh" "${root}/stellar_poc_followup.sh"; do
        [[ -f "${f}" ]] || continue
        for fn in "${decision_funcs[@]}"; do
            body=$(e2e_extract_function_body "${f}" "${fn}")
            [[ -n "${body}" ]] || continue
            for pat in "${patterns[@]}"; do
                if [[ "${body}" == *"${pat}"* ]]; then
                    hits+="${f}:${fn}:${pat};"
                    count=$((count + 1))
                fi
            done
        done
    done
    LEGACY_DECISION_REFERENCES_FOUND="${count}"
    if (( count > 0 )); then
        log_message "ERROR" "LEGACY_DECISION_REFERENCES hits=${hits}" >&2
    fi
    log_message "OK" "LEGACY_DECISION_REFERENCES_FOUND=${LEGACY_DECISION_REFERENCES_FOUND}" >&2
    return 0
}

run_e2e_validation_suite() {
    local block="" mod="" summary="" validation="" decision="" reason="" ec=0 ff="" stage=""
    local -a modules=(DNS_TUNNEL HTTP_URL_SCAN DGA_SIMULATION DNS_NEW_TLD EXTERNAL_CALLBACK)
    E2E_FAIL_FAST_FLAGS=""
    event_store_paths_refresh
    event_apply_all_module_validations || true
    block="E2E_MODULE_STATUS
"
    for mod in "${modules[@]}"; do
        case "${mod}" in
            DNS_TUNNEL) stage="dns_tunnel_file_client"; e2e_emit_dns_pipeline_replay ;;
            HTTP_URL_SCAN)
                stage="${HTTP_URL_SCAN_RUN_ID:-main}"
                if declare -F http_emit_url_execution_summary >/dev/null 2>&1; then
                    http_emit_url_execution_summary || true
                fi
                ;;
            DGA_SIMULATION) stage="main"; e2e_emit_dga_final_summary ;;
            EXTERNAL_CALLBACK)
                summary="planned=$(safe_int "${EXTERNAL_CALLBACK_PLANNED:-0}") attempted=$(safe_int "${EXTERNAL_CALLBACK_ATTEMPTED:-0}") connected=$(safe_int "${EXTERNAL_CALLBACK_CONNECTED:-0}")"
                decision="${TELEMETRY_VAL_EXTERNAL_CALLBACK:-skipped}"
                case "${decision}" in
                    success|fallback_success) validation="SUCCESS" ;;
                    partial) validation="PARTIAL" ;;
                    skipped) validation="SKIPPED" ;;
                    *) validation="FAILED" ;;
                esac
                reason="${TELEMETRY_VAL_CALLBACK_REASON:-none}"
                ec=$(safe_int "${EXTERNAL_CALLBACK_CONNECTED:-0}")
                block+="module=${mod}
event_count=${ec}
summary=${summary}
validation=${validation}
decision=${decision}
failure_reason=${reason}

"
                continue
                ;;
            *) stage="" ;;
        esac
        [[ "${mod}" == EXTERNAL_CALLBACK ]] && continue
        summary=$(build_module_summary_from_events "${mod}" 2>/dev/null || true)
        e2e_check_module_event_missing "${mod}" "${summary}" || true
        ff=$(event_fail_fast_invariants "${mod}" "${summary}" "${stage}" 2>/dev/null || true)
        if [[ "${ff}" == CODE_FAILURE ]]; then
            decision="failed"
            validation="CODE_FAILURE"
            reason="code_failure:${EVENT_SOT_FAIL_FAST_FLAGS}${E2E_FAIL_FAST_FLAGS}"
        else
            read -r decision reason <<< "$(validate_module_from_summary "${mod}" "${summary}" "${stage}")"
            validation="${decision^^}"
            [[ "${decision}" == success ]] && validation="SUCCESS"
            [[ "${decision}" == partial ]] && validation="PARTIAL"
            [[ "${decision}" == failed ]] && validation="FAILED"
            [[ "${decision}" == skipped ]] && validation="SKIPPED"
        fi
        EVENT_MODULE_SUMMARY["${mod}"]="${summary}"
        EVENT_MODULE_VALIDATION["${mod}"]="${validation}"
        EVENT_MODULE_DECISION["${mod}"]="${decision}"
        EVENT_MODULE_FAILURE_REASON["${mod}"]="${reason}"
        ec=$(safe_int "$(event_summary_field "${summary}" event_count 0)")
        (( ec < 1 )) && ec=$(event_module_event_count "${mod}")
        block+="module=${mod}
event_count=${ec}
summary=${summary}
validation=${validation}
decision=${decision}
failure_reason=${reason}

"
        log_message "OK" "E2E_MODULE_STATUS module=${mod} event_count=${ec} validation=${validation} decision=${decision} failure_reason=${reason}" >&2
    done
    e2e_audit_legacy_decision_references || true
    block+="$(build_e2e_final_report)"
    E2E_VALIDATION_REPORT="${block}"
    log_message "OK" "${block}" >&2
    state_append "e2e_validation_report.log" "${block}" 2>/dev/null || true
    [[ -n "${REPORT_MD:-}" ]] && {
        cat <<EOF >> "${REPORT_MD}" 2>/dev/null || true

## E2E Validation Report

\`\`\`text
${block}
\`\`\`
EOF
    }
    printf '%s' "${block}"
}

build_e2e_final_report() {
    local block="E2E_FINAL_REPORT
" mod="" ec=0 validation="" decision=""
    for mod in DNS_TUNNEL HTTP_URL_SCAN DGA_SIMULATION DNS_NEW_TLD EXTERNAL_CALLBACK; do
        ec=$(event_module_event_count "${mod}")
        validation="${EVENT_MODULE_VALIDATION[${mod}]:-UNKNOWN}"
        decision="${EVENT_MODULE_DECISION[${mod}]:-unknown}"
        [[ "${validation}" == SUCCESS ]] && decision="SUCCESS"
        [[ "${validation}" == PARTIAL ]] && decision="PARTIAL"
        [[ "${validation}" == FAILED || "${validation}" == CODE_FAILURE ]] && decision="FAILED"
        block+="MODULE=${mod}
EVENT_COUNT=${ec}
VALIDATION=${validation}
DECISION=${decision}

"
    done
    block+="LEGACY_DECISION_REFERENCES_FOUND=${LEGACY_DECISION_REFERENCES_FOUND}
"
    if [[ -n "${E2E_FAIL_FAST_FLAGS}" ]]; then
        block+="E2E_FAIL_FAST_FLAGS=${E2E_FAIL_FAST_FLAGS}
"
    fi
    log_message "OK" "${block}" >&2
    printf '%s' "${block}"
}

build_event_sot_final_report() {
    local block="" mod="" summary="" validation="" decision="" reason="" ec=0
    local dns_ec=0 http_ec=0 dga_ec=0 ntld_ec=0
    local dns_file="" dns_exists=no dns_line_count=0
    event_store_paths_refresh
    dns_file="${EVENT_DNS_EVENTS:-}"
    if [[ -n "${dns_file}" && -f "${dns_file}" ]]; then
        dns_exists=yes
        dns_line_count=$(event_store_row_count "${dns_file}")
    fi
    dns_ec=$(event_module_event_count "DNS_TUNNEL")
    http_ec=$(event_module_event_count "HTTP_URL_SCAN")
    dga_ec=$(event_module_event_count "DGA_SIMULATION")
    ntld_ec=$(event_module_event_count "DNS_NEW_TLD")
    block="EVENT_SOT_FINAL_REPORT

EVENT_STORE_PATHS
${EVENT_STORE_PATHS}

DNS_EVENT_FILE_CHECK
file=${dns_file:-none}
exists=${dns_exists}
line_count=${dns_line_count}

DNS_EVENT_COUNT=${dns_ec}
HTTP_EVENT_COUNT=${http_ec}
DGA_EVENT_COUNT=${dga_ec}
NEW_TLD_EVENT_COUNT=${ntld_ec}
"
    for mod in DNS_TUNNEL HTTP_URL_SCAN DGA_SIMULATION DNS_NEW_TLD; do
        summary="${EVENT_MODULE_SUMMARY[${mod}]:-$(build_module_summary_from_events "${mod}" 2>/dev/null || true)}"
        validation="${EVENT_MODULE_VALIDATION[${mod}]:-UNKNOWN}"
        decision="${EVENT_MODULE_DECISION[${mod}]:-unknown}"
        reason="${EVENT_MODULE_FAILURE_REASON[${mod}]:-none}"
        ec=$(safe_int "$(event_summary_field "${summary}" event_count 0)")
        (( ec == 0 )) && ec=$(event_module_event_count "${mod}")
        block+="
${mod}

EVENT_COUNT=${ec}

MODULE_SUMMARY
${summary}

MODULE_VALIDATION
result=${validation}

MODULE_DECISION
${decision}

MODULE_FAILURE_REASON
${reason}
"
    done
    EVENT_SOT_FINAL_REPORT="${block}"
    log_message "OK" "${block}" >&2
    state_append "event_sot_final_report.log" "${block}"
    [[ -n "${REPORT_MD:-}" ]] && {
        cat <<EOF >> "${REPORT_MD}" 2>/dev/null || true

## Event SOT Final Report

\`\`\`text
${block}
\`\`\`
EOF
    }
    printf '%s' "${block}"
}

# Stubs for legacy evidence hooks — delegate to event SOT only
evidence_reset_all() {
    EVENT_SOT_FAIL_FAST_FLAGS=""
}

evidence_apply_all_module_validations() {
    event_apply_all_module_validations
}

evidence_compute_overall_from_validated() {
    compute_overall_telemetry_validation
}

evidence_emit_final_validation_table() {
    : # table emitted via compute_and_log_final_validation
}

evidence_validate_dns_tunnel_module() {
    event_apply_module_validation "DNS_TUNNEL" "dns_tunnel_file_client"
}

evidence_validate_dga_module() {
    event_apply_module_validation "DGA_SIMULATION" ""
}
