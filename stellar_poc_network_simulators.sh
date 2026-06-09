# ==============================================================================
# Stellar PoC — Rebuilt DNS Tunnel / DGA network simulators
# Observable traffic only; dummy payloads; EVENT SOT is the sole decision path.
# @stellar-poc-version: 1.2.0
# ==============================================================================

DNS_TUNNEL_SIM_DOMAIN="${DNS_TUNNEL_SIM_DOMAIN:-dns-tunnel.com}"
DNS_TUNNEL_PAYLOAD_MB="${DNS_TUNNEL_PAYLOAD_MB:-2}"
DNS_TUNNEL_CHUNK_SIZE="${DNS_TUNNEL_CHUNK_SIZE:-30}"
DNS_TUNNEL_DURATION_SEC="${DNS_TUNNEL_DURATION_SEC:-180}"
DNS_TUNNEL_MAX_SENT_CAP="${DNS_TUNNEL_MAX_SENT_CAP:-0}"
DNS_TUNNEL_FILE_TARGETS=""
DNS_TUNNEL_FILE_TARGET_COUNT=0
DNS_TUNNEL_FILE_CLIENT_DURATION_SEC=0
DNS_TUNNEL_RUNTIME_GUARD=false
DNS_TUNNEL_LEGACY_PATH_HIT=false
DNS_TUNNEL_RUNTIME_PATH="stellar_dns_tunnel_file_client.py"
DGA_MODEL_BASE_DOMAIN="${DGA_MODEL_BASE_DOMAIN:-xdr.ooo}"
DGA_MODEL_NX_COUNT="${DGA_MODEL_NX_COUNT:-500}"
DGA_MODEL_RESOLVABLE_COUNT="${DGA_MODEL_RESOLVABLE_COUNT:-30}"
NET_SIM_DGA_QUERY_COUNT="${NET_SIM_DGA_QUERY_COUNT:-500}"
NET_SIM_DGA_QUERY_MIN=500
NET_SIM_DGA_QUERY_MAX=500

net_sim_rand_hex() {
    local n="${1:-8}"
    if command -v openssl >/dev/null 2>&1; then
        openssl rand -hex "${n}" 2>/dev/null | head -c $((n * 2))
    else
        printf '%s%x' "${RANDOM}" "${RANDOM}"
    fi
}

net_sim_rand_base32_label() {
    local n="${1:-44}"
    local s=""
    if command -v openssl >/dev/null 2>&1; then
        s=$(openssl rand -base32 48 2>/dev/null | tr -d '=\n+/' | head -c "${n}")
    fi
    if [[ ${#s} -lt "${n}" ]]; then
        s=$(head -c 64 /dev/urandom 2>/dev/null | base32 2>/dev/null | tr -d '=\n+/' | head -c "${n}")
    fi
    [[ ${#s} -lt 8 ]] && s="dummy$(net_sim_rand_hex 16)"
    printf '%s' "${s}"
}

net_sim_dns_tunnel_script_path() {
    local base="${_SCRIPT_DIR_FOLLOWUP:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    printf '%s/stellar_dns_tunnel_file_client.py' "${base}"
}

net_sim_dga_model_script_path() {
    local base="${_SCRIPT_DIR_FOLLOWUP:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
    printf '%s/stellar_dga_model_client.py' "${base}"
}

# Pick up to 2 alive scan hosts — no DNS server or UDP/53 validation.
select_dns_tunnel_file_targets() {
    local merged="" host="" count=0 targets="" env_targets="${DNS_TUNNEL_FILE_TARGETS:-}"
    DNS_TUNNEL_FILE_TARGETS=""
    DNS_TUNNEL_FILE_TARGET_COUNT=0
    if [[ -n "${env_targets}" ]]; then
        targets="${env_targets}"
        count=$(printf '%s' "${targets}" | tr ',' '\n' | awk 'NF{c++} END{print c+0}')
        DNS_TUNNEL_FILE_TARGETS="${targets}"
        DNS_TUNNEL_FILE_TARGET_COUNT="${count}"
        dns_tunnel_log_both "DNS_TUNNEL_TARGET_SELECTED count=${count} targets=${targets:-none} source=env"
        (( count >= 1 ))
        return $?
    fi
    for f in alive_hosts.txt ssh_hosts.txt smb_hosts.txt http_targets.txt https_targets.txt ldap_hosts.txt; do
        merged=$(printf '%s\n%s' "${merged}" "$(collect_hosts_from_remote_file "${f}" 2>/dev/null || true)")
    done
    while IFS= read -r host; do
        [[ -z "${host}" ]] && continue
        host=$(poc_extract_ipv4 "${host}")
        [[ -z "${host}" ]] && continue
        case ",${targets}," in
            *",${host},"*) continue ;;
        esac
        targets="${targets:+$targets,}${host}"
        count=$((count + 1))
        (( count >= 2 )) && break
    done < <(printf '%s\n' "${merged}" | awk '/^[0-9]+\./ { line=$1; sub(/:.*/,"",line); print line }' | sort -u)
    DNS_TUNNEL_FILE_TARGETS="${targets}"
    DNS_TUNNEL_FILE_TARGET_COUNT="${count}"
    dns_tunnel_log_both "DNS_TUNNEL_TARGET_SELECTED count=${count} targets=${targets:-none}"
    (( count >= 1 ))
}

net_sim_dga_event_line() {
    local ts="$1" run_id="$2" resolver="$3" domain="$4" tld="$5" seed="$6" qtype="$7" status="$8" source="${9:-remote_event}"
    printf 'DGA_EVENT timestamp=%s run_id=%s module=DGA stage=dga_simulator target=%s domain=%s tld=%s algorithm_seed=%s qtype=%s status=%s source=%s\n' \
        "${ts}" "${run_id}" "${resolver}" "${domain}" "${tld}" "${seed}" "${qtype}" "${status}" "${source}"
}

# --- DNS Tunnel file client (UDP/53 sendto; strt/idx-*/end; base32 payloads) ---
build_dns_tunnel_simulation_remote_cmd() {
    build_dns_tunnel_file_client_remote_cmd "$@"
}

build_dns_tunnel_simulator_remote_cmd() {
    build_dns_tunnel_file_client_remote_cmd "$@"
}

net_sim_remote_dns_event_path() {
    if [[ -n "${REMOTE_STATE_DIR:-}" ]]; then
        printf '%s/events/dns_events.tsv' "${REMOTE_STATE_DIR}"
    elif [[ -n "${POC_RUNTIME_DIR:-}" ]]; then
        printf '%s/state/events/dns_events.tsv' "${POC_RUNTIME_DIR}"
    else
        printf '/tmp/.poc_runtime_root/state/events/dns_events.tsv'
    fi
}

net_sim_remote_dns_status_path() {
    if [[ -n "${REMOTE_STATE_DIR:-}" ]]; then
        printf '%s/dns_simulator.status' "${REMOTE_STATE_DIR}"
    else
        printf '/tmp/.poc_runtime_root/state/dns_simulator.status'
    fi
}

net_sim_remote_dns_stdout_path() {
    if [[ -n "${REMOTE_STATE_DIR:-}" ]]; then
        printf '%s/dns_simulator.stdout' "${REMOTE_STATE_DIR}"
    else
        printf '/tmp/.poc_runtime_root/state/dns_simulator.stdout'
    fi
}

net_sim_remote_dns_stderr_path() {
    if [[ -n "${REMOTE_STATE_DIR:-}" ]]; then
        printf '%s/dns_simulator.stderr' "${REMOTE_STATE_DIR}"
    else
        printf '/tmp/.poc_runtime_root/state/dns_simulator.stderr'
    fi
}

net_sim_remote_dga_event_path() {
    if [[ -n "${REMOTE_STATE_DIR:-}" ]]; then
        printf '%s/events/dga_events.tsv' "${REMOTE_STATE_DIR}"
    elif [[ -n "${POC_RUNTIME_DIR:-}" ]]; then
        printf '%s/state/events/dga_events.tsv' "${POC_RUNTIME_DIR}"
    else
        printf '/tmp/.poc_runtime_root/state/events/dga_events.tsv'
    fi
}

net_sim_remote_new_tld_event_path() {
    if [[ -n "${REMOTE_STATE_DIR:-}" ]]; then
        printf '%s/events/new_tld_events.tsv' "${REMOTE_STATE_DIR}"
    elif [[ -n "${POC_RUNTIME_DIR:-}" ]]; then
        printf '%s/state/events/new_tld_events.tsv' "${POC_RUNTIME_DIR}"
    else
        printf '/tmp/.poc_runtime_root/state/events/new_tld_events.tsv'
    fi
}

net_sim_dns_tunnel_classify_bootstrap_failure() {
    local reason="${1:-unknown}"
    case "${reason}" in
        python_missing|python3_missing) printf '%s' "python_missing" ;;
        script_missing|dns_tunnel_file_client_script_missing) printf '%s' "script_missing" ;;
        syntax_error|DNS_PAYLOAD_SYNTAX_ERROR) printf '%s' "syntax_error" ;;
        runtime_error|no_dns_tunnel_events|remote_dns_events_missing) printf '%s' "runtime_error" ;;
        permission_error|permission_denied|udp53_blocked) printf '%s' "permission_error" ;;
        event_file_missing|remote_dns_events_missing) printf '%s' "event_file_missing" ;;
        *) printf '%s' "${reason}" ;;
    esac
}

net_sim_dns_tunnel_local_bootstrap_precheck() {
    local pyfile="" err_file=""
    DNS_TUNNEL_BOOTSTRAP_CLASS=""
    DNS_TUNNEL_BOOTSTRAP_STDERR=""
    if ! command -v python3 >/dev/null 2>&1; then
        DNS_TUNNEL_BOOTSTRAP_CLASS="python_missing"
        return 1
    fi
    pyfile=$(net_sim_dns_tunnel_script_path)
    if [[ ! -f "${pyfile}" ]]; then
        DNS_TUNNEL_BOOTSTRAP_CLASS="script_missing"
        return 1
    fi
    err_file="${TMPDIR:-/tmp}/dns_tunnel_py_compile_$$.err"
    if ! python3 -m py_compile "${pyfile}" 2>"${err_file}"; then
        DNS_TUNNEL_BOOTSTRAP_CLASS="syntax_error"
        DNS_TUNNEL_BOOTSTRAP_STDERR=$(cat "${err_file}" 2>/dev/null || true)
        rm -f "${err_file}" 2>/dev/null || true
        return 1
    fi
    rm -f "${err_file}" 2>/dev/null || true
    return 0
}

net_sim_fetch_remote_file_blob() {
    local label="$1" remote_path="$2" size=0 blob=""
    size=$(safe_int "$(run_webshell_quick "${label}-sz" \
        "RP='${remote_path}'; if [ -f \"\$RP\" ]; then wc -c <\"\$RP\" | tr -d ' \\n'; else echo 0; fi" \
        2>/dev/null || true)")
    size=$(safe_int "$(normalize_webshell_response "${size}")")
    (( size < 1 )) && return 1
    if (( size < 400000 )); then
        blob=$(run_webshell_quick "${label}-cat" "cat '${remote_path}' 2>/dev/null" 2>/dev/null || true)
    else
        blob=$(run_webshell_quick "${label}-gz" \
            "gzip -c '${remote_path}' 2>/dev/null | (base64 -w0 2>/dev/null || base64 | tr -d '\\n')" \
            2>/dev/null || true)
        blob=$(printf '%s' "${blob}" | tr -d '\r\n' | base64 -d 2>/dev/null | gzip -dc 2>/dev/null || true)
    fi
    blob=$(normalize_webshell_response "${blob}")
    [[ -n "${blob}" ]] || return 1
    printf '%s' "${blob}"
}

net_sim_fetch_remote_dns_diagnostics() {
    local st_path="" out_path="" err_path="" st_blob="" out_blob="" err_blob="" exit_code=""
    st_path=$(net_sim_remote_dns_status_path)
    out_path=$(net_sim_remote_dns_stdout_path)
    err_path=$(net_sim_remote_dns_stderr_path)
    st_blob=$(net_sim_fetch_remote_file_blob "dns-st" "${st_path}" 2>/dev/null || true)
    out_blob=$(net_sim_fetch_remote_file_blob "dns-out" "${out_path}" 2>/dev/null || true)
    err_blob=$(net_sim_fetch_remote_file_blob "dns-err" "${err_path}" 2>/dev/null || true)
    exit_code=$(printf '%s' "${st_blob}" | tr -d '\r\n' | head -n1)
    [[ -n "${exit_code}" ]] || exit_code="unknown"
    dns_tunnel_log_both "DNS_REMOTE_DIAG status_path=${st_path} exit_code=${exit_code}"
    if [[ -n "${out_blob}" ]]; then
        dns_tunnel_log_both "DNS_REMOTE_DIAG stdout_path=${out_path} bytes=${#out_blob}"
    fi
    if [[ -n "${err_blob}" ]]; then
        dns_tunnel_log_both "DNS_REMOTE_DIAG stderr_path=${err_path} bytes=${#err_blob}"
        printf '%s\n' "${err_blob}" | head -n20 | while IFS= read -r line; do
            dns_tunnel_log_both "DNS_REMOTE_DIAG_STDERR ${line}"
        done
    fi
    DNS_TUNNEL_REMOTE_EXIT_CODE="${exit_code}"
    DNS_TUNNEL_REMOTE_STDERR_SNIP="${err_blob}"
    DNS_TUNNEL_REMOTE_STDOUT_SNIP="${out_blob}"
}

net_sim_fetch_remote_dns_events() {
    local remote_path="" meta="" size=0 exists=no blob="" merged=0 local_before=0 local_after=0 lines=0
    remote_path=$(net_sim_remote_dns_event_path)
    poc_sot_paths_init
    event_store_paths_refresh
    local_before=$(event_store_row_count "${EVENT_DNS_EVENTS}")
    net_sim_fetch_remote_dns_diagnostics || true
    meta=$(run_webshell_quick "dns-ev-meta" \
        "RP='${remote_path}'; ST='$(net_sim_remote_dns_status_path)'; SO='$(net_sim_remote_dns_stdout_path)'; SE='$(net_sim_remote_dns_stderr_path)'; \
        for f in \"\$RP\" \"\$ST\" \"\$SO\" \"\$SE\"; do \
          bn=\$(basename \"\$f\"); \
          if [ -f \"\$f\" ]; then echo DNS_REMOTE_ARTIFACT name=\${bn} exists=yes size=\$(wc -c <\"\$f\" | tr -d ' \\n'); \
          else echo DNS_REMOTE_ARTIFACT name=\${bn} exists=no size=0; fi; \
        done; \
        if [ -f \"\$RP\" ]; then sz=\$(wc -c <\"\$RP\" | tr -d ' \\n'); ln=\$(awk 'END{print NR}' \"\$RP\" 2>/dev/null || echo 0); echo DNS_REMOTE_META exists=yes size=\${sz} lines=\${ln}; else echo DNS_REMOTE_META exists=no size=0 lines=0; fi" \
        2>/dev/null || true)
    meta=$(normalize_webshell_response "${meta}")
    while IFS= read -r line; do
        [[ "${line}" == DNS_REMOTE_ARTIFACT* ]] || continue
        dns_tunnel_log_both "${line}"
    done <<< "$(printf '%s\n' "${meta}")"
    exists=$(printf '%s' "${meta}" | tr ' ' '\n' | sed -n 's/^exists=//p' | head -n1)
    size=$(safe_int "$(printf '%s' "${meta}" | tr ' ' '\n' | sed -n 's/^size=//p' | head -n1)")
    lines=$(safe_int "$(printf '%s' "${meta}" | tr ' ' '\n' | sed -n 's/^lines=//p' | head -n1)")
    dns_tunnel_log_both "DNS_REMOTE_EVENT_FILE path=${remote_path} exists=${exists:-no} size=${size} lines=${lines}"
    if [[ "${exists}" != yes ]]; then
        DNS_REMOTE_EVENT_FETCH_LINES=0
        return 1
    fi
    if (( size < 400000 )); then
        blob=$(run_webshell_quick "dns-ev-cat" "cat '${remote_path}' 2>/dev/null" 2>/dev/null || true)
    else
        blob=$(run_webshell_quick "dns-ev-gz" \
            "gzip -c '${remote_path}' 2>/dev/null | (base64 -w0 2>/dev/null || base64 | tr -d '\\n')" \
            2>/dev/null || true)
        blob=$(printf '%s' "${blob}" | tr -d '\r\n' | base64 -d 2>/dev/null | gzip -dc 2>/dev/null || true)
    fi
    blob=$(normalize_webshell_response "${blob}")
    [[ -n "${blob}" ]] || return 1
    merged=$(event_merge_dns_tsv_content "${blob}")
    merged=$(safe_int "${merged}")
    DNS_REMOTE_EVENT_FETCH_LINES="${merged}"
    local_after=$(event_store_row_count "${EVENT_DNS_EVENTS}")
    dns_tunnel_log_both "DNS_REMOTE_EVENT_FETCH lines=${merged}"
    dns_tunnel_log_both "DNS_EVENT_MERGE_RESULT local_events=${local_after} merged_rows=${merged} prior_rows=${local_before}"
    (( merged > 0 )) && return 0
    return 1
}

build_dns_tunnel_file_client_remote_cmd() {
    local targets="$1" run_id="${2:-${CAMPAIGN_ID:-run}}"
    local pyfile="" py_body="" remote_ev="" remote_py="" st_file="" so_file="" se_file="" state_base=""
    [[ -n "${targets}" ]] || return 1
    pyfile=$(net_sim_dns_tunnel_script_path)
    [[ -f "${pyfile}" ]] || return 1
    py_body=$(cat "${pyfile}")
    remote_ev=$(net_sim_remote_dns_event_path)
    state_base="${REMOTE_STATE_DIR:-/tmp/.poc_runtime_root/state}"
    remote_py="${state_base}/stellar_dns_tunnel_file_client.py"
    st_file=$(net_sim_remote_dns_status_path)
    so_file=$(net_sim_remote_dns_stdout_path)
    se_file=$(net_sim_remote_dns_stderr_path)
    remote_bash_script_open 'DNS_TUNNEL_FILE_CLIENT_SCRIPT'
    cat <<EOF
dns_bs_fail() {
  phase="\$1"; result="\$2"
  echo "DNS_TUNNEL_REMOTE_BOOTSTRAP phase=\${phase} result=\${result}"
  printf '%s' "\${result}" > '${st_file}' 2>/dev/null || true
  exit 0
}
echo "DNS_TUNNEL_REMOTE_BOOTSTRAP phase=precheck result=starting"
if ! command -v python3 >/dev/null 2>&1; then
  dns_bs_fail precheck python_missing
fi
mkdir -p "\$(dirname '${remote_ev}')" "\$(dirname '${remote_py}')" 2>/dev/null || true
cat > '${remote_py}' <<'STELLAR_DNS_TUNNEL_FILE_CLIENT_PY'
${py_body}
STELLAR_DNS_TUNNEL_FILE_CLIENT_PY
if [ ! -f '${remote_py}' ]; then
  dns_bs_fail deploy script_missing
fi
if ! python3 -m py_compile '${remote_py}' 2>'${se_file}'; then
  dns_bs_fail syntax_check syntax_error
fi
mkdir -p "\$(dirname '${remote_ev}')" 2>/dev/null || true
: > '${remote_ev}'
echo "DNS_TUNNEL_REMOTE_BOOTSTRAP phase=event_file result=initialized path='${remote_ev}'"
export DNS_TUNNEL_TARGETS='${targets}'
export DNS_TUNNEL_RUN_ID='${run_id}'
export DNS_TUNNEL_DOMAIN='${DNS_TUNNEL_SIM_DOMAIN}'
export DNS_TUNNEL_PAYLOAD_MB='${DNS_TUNNEL_PAYLOAD_MB}'
export DNS_TUNNEL_CHUNK_SIZE='${DNS_TUNNEL_CHUNK_SIZE}'
export DNS_TUNNEL_DURATION_SEC='${DNS_TUNNEL_DURATION_SEC}'
export DNS_TUNNEL_EVENT_FILE='${remote_ev}'
if [ '${DNS_TUNNEL_MAX_SENT_CAP:-0}' -gt 0 ] 2>/dev/null; then
  export DNS_TUNNEL_MAX_SENT='${DNS_TUNNEL_MAX_SENT_CAP}'
fi
echo "DNS_TUNNEL_REMOTE_BOOTSTRAP phase=run result=starting script='${remote_py}' targets='${targets}' event_file='${remote_ev}'"
python3 '${remote_py}' >'${so_file}' 2>'${se_file}'
rc=\$?
printf '%s' "\${rc}" > '${st_file}' 2>/dev/null || true
if [ -s '${so_file}' ]; then cat '${so_file}'; fi
if [ "\${rc}" -ne 0 ]; then
  if [ -s '${se_file}' ]; then
    if grep -qiE 'permission|not permitted|denied' '${se_file}' 2>/dev/null; then
      bs_rc=permission_error
    else
      bs_rc=runtime_error
    fi
  else
    bs_rc=runtime_error
  fi
else
  bs_rc=ok
fi
if [ ! -f '${remote_ev}' ] || [ ! -s '${remote_ev}' ]; then
  bs_rc=event_file_missing
fi
echo "DNS_TUNNEL_REMOTE_PROCESS_RESULT exit_code=\${rc} bootstrap_result=\${bs_rc} status_file='${st_file}' stdout_file='${so_file}' stderr_file='${se_file}' event_file='${remote_ev}'"
if [ "\${bs_rc}" = event_file_missing ]; then
  echo "DNS_TUNNEL_REMOTE_BOOTSTRAP phase=post result=event_file_missing"
fi
if [ "\${bs_rc}" = syntax_error ] && [ -s '${se_file}' ]; then
  sed -n '1,12p' '${se_file}' 2>/dev/null | while IFS= read -r ln; do echo "DNS_TUNNEL_REMOTE_STDERR \${ln}"; done
fi
if [ "\${bs_rc}" = runtime_error ] && [ -s '${se_file}' ]; then
  sed -n '1,12p' '${se_file}' 2>/dev/null | while IFS= read -r ln; do echo "DNS_TUNNEL_REMOTE_STDERR \${ln}"; done
fi
EOF
    remote_bash_script_close 'DNS_TUNNEL_FILE_CLIENT_SCRIPT'
}

net_sim_dns_tunnel_ingest_output() {
    local out="$1" sim_started=false merged=0 bs_result="" sendto_ok=0
    if [[ "${out}" == *DNS_TUNNEL_FILE_CLIENT_START* || "${out}" == *DNS_TUNNEL_TARGET_SELECTED* || "${out}" == *DNS_TUNNEL_REMOTE_BOOTSTRAP* ]]; then
        sim_started=true
    fi
    bs_result=$(printf '%s' "${out}" | tr ' ' '\n' | sed -n 's/^bootstrap_result=//p' | head -n1)
    [[ -z "${bs_result}" ]] && bs_result=$(printf '%s' "${out}" | tr ' ' '\n' | sed -n 's/^result=//p' | grep -E '^(python_missing|script_missing|syntax_error|runtime_error|permission_error|event_file_missing)$' | head -n1)
    if [[ -n "${bs_result}" && "${bs_result}" != ok && "${bs_result}" != starting ]]; then
        DNS_TUNNEL_BOOTSTRAP_CLASS=$(net_sim_dns_tunnel_classify_bootstrap_failure "${bs_result}")
        DNS_TUNNEL_SKIP_REASON="${DNS_TUNNEL_BOOTSTRAP_CLASS}"
        EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} DNS_REMOTE_BOOTSTRAP_FAIL"
        log_message "ERROR" "DNS_REMOTE_BOOTSTRAP_FAIL class=${DNS_TUNNEL_BOOTSTRAP_CLASS} bootstrap_result=${bs_result}"
        return 1
    fi
    if [[ "${DRY_RUN}" != true ]]; then
        net_sim_fetch_remote_dns_events && merged=$(safe_int "${DNS_REMOTE_EVENT_FETCH_LINES:-0}") || merged=0
        if (( merged < 1 )); then
            ingest_remote_events "${out}" "DNS" || true
        fi
    else
        ingest_remote_events "${out}" "DNS" || true
    fi
    event_stage_mark_executed "DNS_TUNNEL" "dns_tunnel_file_client"
    sendto_ok=$(safe_int "$(printf '%s' "${out}" | tr ' ' '\n' | sed -n 's/^sendto_success=//p' | awk '{s+=$1} END{print s+0}')")
    if [[ "${sim_started}" == true && "${DRY_RUN}" != true ]]; then
        local summary="" sent=0 ev_lines=0
        summary=$(build_module_summary_from_events "DNS_TUNNEL" 2>/dev/null || true)
        sent=$(safe_int "$(event_summary_field "${summary}" sent 0)")
        ev_lines=$(event_store_row_count "${EVENT_DNS_EVENTS}")
        dns_refresh_sot_from_generated_domains "DNS_TUNNEL" || true
        if (( sendto_ok < 1 && sent < 1 )); then
            DNS_TUNNEL_SKIP_REASON="no_sendto_packets"
            log_message "ERROR" "DNS_TUNNEL_CODE_FAILURE sendto_success=0 sent=${sent} reason=no_udp53_packets"
            return 1
        fi
        if (( ev_lines < 1 )); then
            EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} DNS_REMOTE_BOOTSTRAP_FAIL"
            DNS_TUNNEL_SKIP_REASON="event_file_missing"
            DNS_TUNNEL_BOOTSTRAP_CLASS="event_file_missing"
            log_message "ERROR" "DNS_REMOTE_BOOTSTRAP_FAIL file_client_started event_lines=0 bootstrap_result=${bs_result:-unknown}"
            return 1
        fi
    fi
    return 0
}

net_sim_dns_tunnel_classify_env_failure() {
    local reason="$1"
    case "${reason}" in
        *udp*53*|*UDP*53*|*permission*denied*|*host_unreachable*|*unreachable*|*blocked*|*python3_missing*)
            printf '%s' "environment_failure"
            return 0
            ;;
    esac
    return 1
}

net_sim_dns_tunnel_plan_idx_count() {
    python3 -c "mb=float('${DNS_TUNNEL_PAYLOAD_MB:-2}');cs=int('${DNS_TUNNEL_CHUNK_SIZE:-30}');print(max(1,(int(mb*1024*1024)+cs-1)//cs))" 2>/dev/null || printf '69906'
}

net_sim_dns_tunnel_parse_max_duration() {
    local out="${1:-}"
    printf '%s' "${out}" | tr ' ' '\n' | sed -n 's/^duration_sec=//p' | awk 'BEGIN{m=0}{v=$1+0;if(v>m)m=v}END{printf "%.0f", m+0}'
}

dns_tunnel_emit_runtime_call_chain() {
    dns_tunnel_log_both "DNS_RUNTIME_CALL_CHAIN"
    dns_tunnel_log_both "stellar_poc.sh"
    if fast_safe_mode_enabled 2>/dev/null; then
        dns_tunnel_log_both "-> run_fast_safe_pipeline_once"
        dns_tunnel_log_both "-> run_fast_safe_parallel_stages"
        dns_tunnel_log_both "-> stage_dns_tunnel_enhanced"
    else
        dns_tunnel_log_both "-> stage_dns_tunnel_simulation"
    fi
    dns_tunnel_log_both "-> run_dns_tunnel_simulation"
    dns_tunnel_log_both "-> run_dns_tunnel_simulator"
    dns_tunnel_log_both "-> ${DNS_TUNNEL_RUNTIME_PATH}"
}

dns_tunnel_guard_legacy_call() {
    local fn="$1"
    [[ "${DNS_TUNNEL_RUNTIME_GUARD}" == true ]] || return 0
    local caller="${FUNCNAME[2]:-${FUNCNAME[1]:-unknown}}"
    DNS_TUNNEL_LEGACY_PATH_HIT=true
    dns_tunnel_log_both "DNS_LEGACY_PATH_DETECTED"
    dns_tunnel_log_both "function=${fn}"
    dns_tunnel_log_both "caller=${caller}"
    return 1
}

dns_tunnel_runtime_guard_on() {
    DNS_TUNNEL_RUNTIME_GUARD=true
    DNS_TUNNEL_LEGACY_PATH_HIT=false
    if [[ -z "${DNS_TUNNEL_REAL_DIG:-}" ]]; then
        DNS_TUNNEL_REAL_DIG=$(command -v dig 2>/dev/null || true)
        DNS_TUNNEL_REAL_NSLOOKUP=$(command -v nslookup 2>/dev/null || true)
    fi
    dig() {
        dns_tunnel_guard_legacy_call "dig"
        return 1
    }
    nslookup() {
        dns_tunnel_guard_legacy_call "nslookup"
        return 1
    }
}

dns_tunnel_runtime_guard_off() {
    DNS_TUNNEL_RUNTIME_GUARD=false
    unset -f dig nslookup 2>/dev/null || true
}

dns_tunnel_parse_summary_field() {
    local out="${1:-}" key="$2" default="${3:-0}"
    local val=""
    val=$(printf '%s' "${out}" | tr ' ' '\n' | sed -n "s/^${key}=//p" | head -n1)
    [[ -n "${val}" ]] || val="${default}"
    printf '%s' "${val}"
}

dns_tunnel_relay_stdout_markers() {
    local out="${1:-}" line="" tag="" relay=false
    local seen_start=false seen_sent=false seen_response=false seen_event=false seen_summary=false
    [[ -n "${out}" ]] || return 0
    while IFS= read -r line || [[ -n "${line}" ]]; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        [[ -z "${line}" ]] && continue
        case "${line}" in
            DNS_TUNNEL_START)
                [[ "${seen_start}" == true ]] && continue
                seen_start=true
                dns_tunnel_log_both "${line}"
                relay=true
                tag="${line}"
                ;;
            DNS_QUERY_SENT)
                [[ "${seen_sent}" == true ]] && { relay=false; tag=""; continue; }
                seen_sent=true
                dns_tunnel_log_both "${line}"
                relay=true
                tag="${line}"
                ;;
            DNS_QUERY_RESPONSE)
                [[ "${seen_response}" == true ]] && { relay=false; tag=""; continue; }
                seen_response=true
                dns_tunnel_log_both "${line}"
                relay=true
                tag="${line}"
                ;;
            DNS_EVENT_WRITTEN)
                [[ "${seen_event}" == true ]] && { relay=false; tag=""; continue; }
                seen_event=true
                dns_tunnel_log_both "${line}"
                relay=true
                tag="${line}"
                ;;
            DNS_TUNNEL_EXECUTION_SUMMARY|DNS_TUNNEL_FAIL_FAST|DNS_EVENT_FILE_CHECK|DNS_EVENT_COUNT=*)
                dns_tunnel_log_both "${line}"
                relay=true
                tag="${line}"
                seen_summary=true
                ;;
            resolver=*|fqdn=*|type=*|result=*|event_file=*|row_count=*|generated_queries=*|sent_queries=*|response_count=*|event_count=*|file=*|exists=*|line_count=*|targets=*|domain=*|planned=*|payload_mb=*|duration_sec=*|mode=*)
                if [[ "${relay}" == true && -n "${tag}" ]]; then
                    dns_tunnel_log_both "${line}"
                fi
                ;;
            *)
                relay=false
                tag=""
                ;;
        esac
    done <<< "$(printf '%s\n' "${out}")"
}

dns_tunnel_emit_event_file_check() {
    local file="" exists=no line_count=0 size_bytes=0
    event_store_paths_refresh
    file="${EVENT_DNS_EVENTS:-}"
    if [[ -n "${file}" && -f "${file}" ]]; then
        exists=yes
        line_count=$(event_store_row_count "${file}")
        size_bytes=$(wc -c < "${file}" 2>/dev/null | awk '{print $1+0}')
    fi
    dns_tunnel_log_both "DNS_EVENT_FILE_CHECK"
    dns_tunnel_log_both "file=${file:-none}"
    dns_tunnel_log_both "exists=${exists}"
    dns_tunnel_log_both "line_count=${line_count}"
    dns_tunnel_log_both "size_bytes=${size_bytes}"
    log_message "OK" "DNS_EVENT_FILE_CHECK file=${file:-none} exists=${exists} line_count=${line_count} size_bytes=${size_bytes}" >&2
}

dns_tunnel_emit_event_count() {
    local ec=0
    ec=$(event_module_event_count "DNS_TUNNEL")
    dns_tunnel_log_both "DNS_EVENT_COUNT=${ec}"
    log_message "OK" "DNS_EVENT_COUNT=${ec}" >&2
}

dns_tunnel_required_markers_present() {
    local out="${1:-}" blob="" marker="" state_log=""
    blob="${out}"
    if [[ -n "${LOCAL_STATE_DIR:-}" && -f "${LOCAL_STATE_DIR}/dns_tunnel_simulation.log" ]]; then
        state_log="${LOCAL_STATE_DIR}/dns_tunnel_simulation.log"
    elif [[ -f "${LOG_DIR:-}/dns_tunnel_simulation.log" ]]; then
        state_log="${LOG_DIR}/dns_tunnel_simulation.log"
    fi
    [[ -n "${state_log}" ]] && blob="${blob}$(cat "${state_log}" 2>/dev/null || true)"
    for marker in DNS_TUNNEL_START DNS_QUERY_SENT DNS_QUERY_RESPONSE DNS_EVENT_WRITTEN DNS_EVENT_FILE_CHECK DNS_EVENT_COUNT DNS_TUNNEL_EXECUTION_SUMMARY; do
        [[ "${blob}" == *"${marker}"* ]] || return 1
    done
    return 0
}

dns_tunnel_fail_fast_no_queries_sent() {
    local planned="$1" sent_queries="$2"
    planned=$(safe_int "${planned}")
    sent_queries=$(safe_int "${sent_queries}")
    if (( planned > 0 && sent_queries == 0 )); then
        dns_tunnel_log_both "DNS_TUNNEL_FAIL_FAST"
        dns_tunnel_log_both "planned=${planned}"
        dns_tunnel_log_both "sent_queries=${sent_queries}"
        dns_tunnel_log_both "reason=no_queries_sent"
        DNS_TUNNEL_SKIP_REASON="no_queries_sent"
        EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} DNS_TUNNEL_FAIL_FAST"
        log_message "ERROR" "DNS_TUNNEL_FAIL_FAST planned=${planned} sent_queries=${sent_queries} reason=no_queries_sent" >&2
        return 1
    fi
    return 0
}

dns_tunnel_fail_fast_no_events_generated() {
    local sent_queries="$1" event_count="$2"
    sent_queries=$(safe_int "${sent_queries}")
    event_count=$(safe_int "${event_count}")
    if (( sent_queries > 0 && event_count == 0 )); then
        dns_tunnel_log_both "DNS_TUNNEL_FAIL_FAST"
        dns_tunnel_log_both "sent_queries=${sent_queries}"
        dns_tunnel_log_both "event_count=${event_count}"
        dns_tunnel_log_both "reason=no_events_generated"
        DNS_TUNNEL_SKIP_REASON="no_events_generated"
        EVENT_SOT_FAIL_FAST_FLAGS="${EVENT_SOT_FAIL_FAST_FLAGS} DNS_TUNNEL_FAIL_FAST"
        log_message "ERROR" "DNS_TUNNEL_FAIL_FAST sent_queries=${sent_queries} event_count=${event_count} reason=no_events_generated" >&2
        return 1
    fi
    return 0
}

dns_tunnel_emit_runtime_proof() {
    local out="${1:-}" generated_queries=0 sent_queries=0 responses=0 event_count=0 event_file=""
    generated_queries=$(safe_int "$(dns_tunnel_parse_summary_field "${out}" generated_queries 0)")
    sent_queries=$(safe_int "$(dns_tunnel_parse_summary_field "${out}" sent_queries 0)")
    responses=$(safe_int "$(dns_tunnel_parse_summary_field "${out}" response_count 0)")
    event_count=$(event_module_event_count "DNS_TUNNEL")
    event_store_paths_refresh
    event_file="${EVENT_DNS_EVENTS:-none}"
    dns_tunnel_log_both "DNS_TUNNEL_RUNTIME_PROOF"
    dns_tunnel_log_both "generated_queries=${generated_queries}"
    dns_tunnel_log_both "sent_queries=${sent_queries}"
    dns_tunnel_log_both "responses=${responses}"
    dns_tunnel_log_both "event_count=${event_count}"
    dns_tunnel_log_both "event_file=${event_file}"
    dns_tunnel_log_both "runtime_path=${DNS_TUNNEL_RUNTIME_PATH}"
    log_message "OK" "DNS_TUNNEL_RUNTIME_PROOF sent_queries=${sent_queries} event_count=${event_count} runtime_path=${DNS_TUNNEL_RUNTIME_PATH}" >&2
}

dns_tunnel_finalize_execution() {
    local out="${1:-}" planned="${2:-0}" sent_queries=0 event_count=0 summary="" generated=0 responses=0
    dns_tunnel_relay_stdout_markers "${out}"
    event_sync_legacy_counters_from_sot || true
    sent_queries=$(safe_int "${DNS_QUERIES_ATTEMPTED:-0}")
    if (( sent_queries == 0 )); then
        summary=$(build_module_summary_from_events "DNS_TUNNEL" 2>/dev/null || true)
        sent_queries=$(safe_int "$(event_summary_field "${summary}" sent 0)")
    fi
    if (( sent_queries == 0 )); then
        sent_queries=$(safe_int "$(dns_tunnel_parse_summary_field "${out}" sent_queries 0)")
    fi
    DNS_QUERIES_ATTEMPTED="${sent_queries}"
    dns_tunnel_emit_event_file_check
    dns_tunnel_emit_event_count
    event_count=$(event_module_event_count "DNS_TUNNEL")
    if [[ "${DNS_TUNNEL_LEGACY_PATH_HIT}" == true ]]; then
        DNS_TUNNEL_SKIP_REASON="legacy_path_detected"
        dns_tunnel_log_both "DNS_TUNNEL_FAIL_FAST reason=legacy_path_detected"
        log_message "ERROR" "DNS_TUNNEL_FAIL_FAST reason=legacy_path_detected" >&2
        return 1
    fi
    if [[ "${out}" == *DNS_TUNNEL_SIM_STATS* || "${out}" == *DNS_TUNNEL_SIM_START* ]]; then
        dns_tunnel_guard_legacy_call "dns tunnel simulator" || true
        DNS_TUNNEL_SKIP_REASON="legacy_path_detected"
        dns_tunnel_log_both "DNS_TUNNEL_FAIL_FAST reason=legacy_path_detected"
        return 1
    fi
    if ! dns_tunnel_fail_fast_no_queries_sent "${planned}" "${sent_queries}"; then
        return 1
    fi
    if ! dns_tunnel_fail_fast_no_events_generated "${sent_queries}" "${event_count}"; then
        return 1
    fi
    if ! dns_tunnel_required_markers_present "${out}"; then
        DNS_TUNNEL_SKIP_REASON="missing_execution_markers"
        dns_tunnel_log_both "DNS_TUNNEL_FAIL_FAST reason=missing_execution_markers"
        log_message "ERROR" "DNS_TUNNEL_FAIL_FAST reason=missing_execution_markers" >&2
        return 1
    fi
    event_apply_module_validation "DNS_TUNNEL" "dns_tunnel_file_client" || true
    dns_tunnel_emit_runtime_proof "${out}"
    return 0
}

dns_tunnel_fail_fast_planned_attempted() {
    dns_tunnel_fail_fast_no_queries_sent "$1" "$2"
}

run_dns_tunnel_simulator_local() {
    local targets="$1" run_id="${2:-${CAMPAIGN_ID:-run}}" mode="${3:-live}" out=""
    local pyfile="" extra=() max_cap=0 tsv_path=""
    pyfile=$(net_sim_dns_tunnel_script_path)
    [[ -f "${pyfile}" ]] || return 1
    [[ -n "${targets}" ]] || targets="127.0.0.1,127.0.0.2"
    max_cap=$(safe_int "${DNS_TUNNEL_MAX_SENT_CAP:-0}")
    event_store_paths_refresh
    tsv_path="${EVENT_DNS_EVENTS:-}"
    case "${mode}" in
        dry_run_sot)
            extra=(--dry-run-sot)
            (( max_cap < 1 )) && max_cap=5000
            ;;
        plan) extra=(--dry-run-sot) ;;
    esac
    [[ -n "${tsv_path}" ]] && extra+=(--event-file "${tsv_path}")
    if (( max_cap > 0 )); then
        extra+=(--max-sent "${max_cap}")
    fi
    out=$(python3 "${pyfile}" --targets "${targets}" --run-id "${run_id}" \
        --domain "${DNS_TUNNEL_SIM_DOMAIN}" --payload-mb "${DNS_TUNNEL_PAYLOAD_MB}" \
        --chunk-size "${DNS_TUNNEL_CHUNK_SIZE}" --duration-sec "${DNS_TUNNEL_DURATION_SEC}" \
        "${extra[@]}" 2>&1) || true
    printf '%s' "${out}"
}

run_dns_tunnel_simulator() {
    local _override_targets="${1:-}" run_id="${2:-${CAMPAIGN_ID:-run}}"
    local out="" remote_cmd="" targets="" t0=0 t1=0 elapsed=0 sendto_ok=0
    DNS_TUNNEL_SKIP_REASON=""
    DNS_TUNNEL_MODE_USED="dns_tunnel_file_client"
    DNS_TUNNEL_DOMAIN_SUFFIX="${DNS_TUNNEL_SIM_DOMAIN}"
    DNS_TUNNEL_RUNTIME_PATH="$(net_sim_dns_tunnel_script_path)"
    DNS_QUERIES_PLANNED=$(net_sim_dns_tunnel_plan_idx_count)
    dns_tunnel_emit_runtime_call_chain
    dns_tunnel_runtime_guard_on
    poc_sot_paths_init
    init_event_store 2>/dev/null || ensure_event_store_files 2>/dev/null || true
    targets="${_override_targets}"
    if [[ -z "${targets}" && -n "${DNS_TUNNEL_FILE_TARGETS:-}" ]]; then
        targets="${DNS_TUNNEL_FILE_TARGETS}"
    fi
    if [[ -z "${targets}" ]]; then
        select_dns_tunnel_file_targets || true
        targets="${DNS_TUNNEL_FILE_TARGETS}"
    fi
    if [[ -z "${targets}" ]]; then
        DNS_TUNNEL_SKIP_REASON="no_alive_targets"
        dns_tunnel_log_both "skip reason=no_alive_targets"
        dns_tunnel_runtime_guard_off
        return 1
    fi
    DNS_TARGET_SERVER="${targets%%,*}"
    DNS_TUNNEL_FILE_TARGETS="${targets}"
    DNS_TUNNEL_FILE_TARGET_COUNT=$(printf '%s' "${targets}" | tr ',' '\n' | awk 'NF{c++} END{print c+0}')
    dns_tunnel_log_both "DNS_TUNNEL_START"
    dns_tunnel_log_both "targets=${targets}"
    dns_tunnel_log_both "domain=${DNS_TUNNEL_SIM_DOMAIN}"
    dns_tunnel_log_both "planned_idx=${DNS_QUERIES_PLANNED}"
    dns_tunnel_log_both "payload_mb=${DNS_TUNNEL_PAYLOAD_MB}"
    dns_tunnel_log_both "duration_sec=${DNS_TUNNEL_DURATION_SEC}"
    dns_tunnel_log_both "mode=dns_tunnel_file_client"
    dns_tunnel_log_both "DNS_TUNNEL_FILE_CLIENT start targets=${targets} domain=${DNS_TUNNEL_SIM_DOMAIN} payload_mb=${DNS_TUNNEL_PAYLOAD_MB} planned_idx=${DNS_QUERIES_PLANNED} duration_sec=${DNS_TUNNEL_DURATION_SEC}"
    log_message "OK" "DNS Tunnel File Client: UDP/53 sendto strt/idx/end domain=${DNS_TUNNEL_SIM_DOMAIN} targets=${targets}"

    if [[ "${DRY_RUN}" == true ]]; then
        out=$(run_dns_tunnel_simulator_local "${targets}" "${run_id}" "dry_run_sot")
        DNS_TUNNEL_FILE_CLIENT_DURATION_SEC=$(net_sim_dns_tunnel_parse_max_duration "${out}")
        event_stage_mark_executed "DNS_TUNNEL" "dns_tunnel_file_client"
        net_sim_block_stdout_final_decision "DNS_TUNNEL" "${out}"
        if ! dns_tunnel_finalize_execution "${out}" "${DNS_QUERIES_PLANNED}"; then
            DNS_TUNNEL_STAGE_STATUS="${TELEMETRY_VAL_DNS_TUNNEL:-failed}"
            dns_tunnel_runtime_guard_off
            return 1
        fi
        DNS_TUNNEL_STAGE_STATUS="${TELEMETRY_VAL_DNS_TUNNEL:-success}"
        dns_tunnel_log_both "dry_run_sot sent=$(event_summary_field "${EVENT_MODULE_SUMMARY[DNS_TUNNEL]:-}" sent 0)"
        dns_tunnel_runtime_guard_off
        return 0
    fi

    if ! net_sim_dns_tunnel_local_bootstrap_precheck; then
        DNS_TUNNEL_SKIP_REASON="${DNS_TUNNEL_BOOTSTRAP_CLASS:-python_missing}"
        dns_tunnel_log_both "DNS_TUNNEL_REMOTE_BOOTSTRAP phase=local result=${DNS_TUNNEL_SKIP_REASON}"
        [[ -n "${DNS_TUNNEL_BOOTSTRAP_STDERR}" ]] && dns_tunnel_log_both "DNS_TUNNEL_REMOTE_STDERR ${DNS_TUNNEL_BOOTSTRAP_STDERR}"
        dns_tunnel_fail_fast_no_queries_sent "${DNS_QUERIES_PLANNED}" 0 || true
        dns_tunnel_runtime_guard_off
        return 1
    fi
    dns_tunnel_log_both "DNS_TUNNEL_REMOTE_BOOTSTRAP phase=local result=ok script=$(net_sim_dns_tunnel_script_path)"
    remote_cmd=$(build_dns_tunnel_file_client_remote_cmd "${targets}" "${run_id}") || {
        DNS_TUNNEL_SKIP_REASON="script_missing"
        dns_tunnel_fail_fast_no_queries_sent "${DNS_QUERIES_PLANNED}" 0 || true
        dns_tunnel_runtime_guard_off
        return 1
    }
    t0=$(date +%s)
    out=$(run_webshell_long "dns-tunnel-file-client" "${remote_cmd}" 2>/dev/null || true)
    DNS_TUNNEL_LAST_REMOTE_OUT="${out}"
    t1=$(date +%s)
    elapsed=$((t1 - t0))
    if ! net_sim_dns_tunnel_ingest_output "${out}"; then
        DNS_TUNNEL_SKIP_REASON="${DNS_TUNNEL_SKIP_REASON:-no_sendto_packets}"
        net_sim_block_stdout_final_decision "DNS_TUNNEL" "${out}"
        dns_tunnel_finalize_execution "${out}" "${DNS_QUERIES_PLANNED}" || true
        dns_tunnel_runtime_guard_off
        return 1
    fi
    net_sim_block_stdout_final_decision "DNS_TUNNEL" "${out}"
    DNS_TUNNEL_FILE_CLIENT_DURATION_SEC=$(net_sim_dns_tunnel_parse_max_duration "${out}")
    if [[ "${out}" == *"DNS_TUNNEL_FILE_CLIENT_ENV"* ]]; then
        DNS_TUNNEL_SKIP_REASON=$(printf '%s' "${out}" | tr ' ' '\n' | sed -n 's/^failure=//p' | head -n1)
        dns_tunnel_finalize_execution "${out}" "${DNS_QUERIES_PLANNED}" || true
        dns_tunnel_runtime_guard_off
        return 1
    fi
    if ! dns_tunnel_finalize_execution "${out}" "${DNS_QUERIES_PLANNED}"; then
        dns_tunnel_runtime_guard_off
        return 1
    fi
    sendto_ok=$(safe_int "$(printf '%s' "${out}" | tr ' ' '\n' | sed -n 's/^sendto_success=//p' | awk '{s+=$1} END{print s+0}')")
    DNS_TUNNEL_STAGE_STATUS="${TELEMETRY_VAL_DNS_TUNNEL:-success}"
    dns_tunnel_runtime_guard_off
    (( sendto_ok > 0 || DNS_QUERIES_ATTEMPTED >= 1 )) && return 0
    DNS_TUNNEL_SKIP_REASON="no_sendto_packets"
    return 1
}

# --- DGA Model client (xdr.ooo NXDOMAIN + live.xdr.ooo resolvable) ---
net_sim_dga_model_local_bootstrap_precheck() {
    local pyfile="" err_file=""
    DGA_MODEL_BOOTSTRAP_CLASS=""
    DGA_MODEL_BOOTSTRAP_STDERR=""
    if ! command -v python3 >/dev/null 2>&1; then
        DGA_MODEL_BOOTSTRAP_CLASS="python_missing"
        return 1
    fi
    pyfile=$(net_sim_dga_model_script_path)
    if [[ ! -f "${pyfile}" ]]; then
        DGA_MODEL_BOOTSTRAP_CLASS="script_missing"
        return 1
    fi
    err_file="${TMPDIR:-/tmp}/dga_model_py_compile_$$.err"
    if ! python3 -m py_compile "${pyfile}" 2>"${err_file}"; then
        DGA_MODEL_BOOTSTRAP_CLASS="syntax_error"
        DGA_MODEL_BOOTSTRAP_STDERR=$(cat "${err_file}" 2>/dev/null || true)
        rm -f "${err_file}" 2>/dev/null || true
        return 1
    fi
    rm -f "${err_file}" 2>/dev/null || true
    return 0
}

build_dga_model_client_remote_cmd() {
    local run_id="${1:-${CAMPAIGN_ID:-run}}"
    local pyfile="" py_body="" remote_ev="" remote_py="" st_file="" so_file="" se_file="" state_base=""
    pyfile=$(net_sim_dga_model_script_path)
    [[ -f "${pyfile}" ]] || return 1
    py_body=$(cat "${pyfile}")
    remote_ev=$(net_sim_remote_dga_event_path)
    state_base="${REMOTE_STATE_DIR:-/tmp/.poc_runtime_root/state}"
    remote_py="${state_base}/stellar_dga_model_client.py"
    st_file="${state_base}/dga_model_client.status"
    so_file="${state_base}/dga_model_client.stdout"
    se_file="${state_base}/dga_model_client.stderr"
    remote_bash_script_open 'DGA_MODEL_CLIENT_SCRIPT'
    cat <<EOF
dga_bs_fail() {
  phase="\$1"; result="\$2"
  echo "DGA_MODEL_REMOTE_BOOTSTRAP phase=\${phase} result=\${result}"
  printf '%s' "\${result}" > '${st_file}' 2>/dev/null || true
  exit 0
}
echo "DGA_MODEL_REMOTE_BOOTSTRAP phase=precheck result=starting"
if ! command -v python3 >/dev/null 2>&1; then
  dga_bs_fail precheck python_missing
fi
mkdir -p "\$(dirname '${remote_ev}')" "\$(dirname '${remote_py}')" 2>/dev/null || true
cat > '${remote_py}' <<'STELLAR_DGA_MODEL_CLIENT_PY'
${py_body}
STELLAR_DGA_MODEL_CLIENT_PY
if [ ! -f '${remote_py}' ]; then
  dga_bs_fail deploy script_missing
fi
if ! python3 -m py_compile '${remote_py}' 2>'${se_file}'; then
  dga_bs_fail syntax_check syntax_error
fi
mkdir -p "\$(dirname '${remote_ev}')" 2>/dev/null || true
: > '${remote_ev}'
echo "DGA_MODEL_REMOTE_BOOTSTRAP phase=event_file result=initialized path='${remote_ev}'"
export DGA_MODEL_RUN_ID='${run_id}'
export DGA_MODEL_BASE_DOMAIN='${DGA_MODEL_BASE_DOMAIN}'
export DGA_MODEL_NX_COUNT='${DGA_MODEL_NX_COUNT}'
export DGA_MODEL_RESOLVABLE_COUNT='${DGA_MODEL_RESOLVABLE_COUNT}'
export DGA_MODEL_RESOLVER='system'
export DGA_MODEL_EVENT_FILE='${remote_ev}'
echo "DGA_MODEL_REMOTE_BOOTSTRAP phase=run result=starting script='${remote_py}' event_file='${remote_ev}'"
python3 '${remote_py}' >'${so_file}' 2>'${se_file}'
rc=\$?
printf '%s' "\${rc}" > '${st_file}' 2>/dev/null || true
if [ -s '${so_file}' ]; then cat '${so_file}'; fi
if [ "\${rc}" -ne 0 ]; then
  if [ -s '${se_file}' ]; then
    if grep -qiE 'permission|not permitted|denied' '${se_file}' 2>/dev/null; then
      bs_rc=permission_error
    else
      bs_rc=runtime_error
    fi
  else
    bs_rc=runtime_error
  fi
else
  bs_rc=ok
fi
if [ ! -f '${remote_ev}' ] || [ ! -s '${remote_ev}' ]; then
  bs_rc=event_file_missing
fi
echo "DGA_MODEL_REMOTE_PROCESS_RESULT exit_code=\${rc} bootstrap_result=\${bs_rc} status_file='${st_file}' stdout_file='${so_file}' stderr_file='${se_file}' event_file='${remote_ev}'"
if [ "\${bs_rc}" = event_file_missing ]; then
  echo "DGA_MODEL_REMOTE_BOOTSTRAP phase=post result=event_file_missing"
fi
if [ "\${bs_rc}" = syntax_error ] && [ -s '${se_file}' ]; then
  sed -n '1,12p' '${se_file}' 2>/dev/null | while IFS= read -r ln; do echo "DGA_MODEL_REMOTE_STDERR \${ln}"; done
fi
if [ "\${bs_rc}" = runtime_error ] && [ -s '${se_file}' ]; then
  sed -n '1,12p' '${se_file}' 2>/dev/null | while IFS= read -r ln; do echo "DGA_MODEL_REMOTE_STDERR \${ln}"; done
fi
EOF
    remote_bash_script_close 'DGA_MODEL_CLIENT_SCRIPT'
}

build_dga_simulation_remote_cmd() {
    build_dga_model_client_remote_cmd "$@"
}

run_dga_model_client_local() {
    local run_id="${1:-${CAMPAIGN_ID:-run}}" mode="${2:-live}" out=""
    local pyfile="" extra=() tsv_path=""
    pyfile=$(net_sim_dga_model_script_path)
    [[ -f "${pyfile}" ]] || return 1
    case "${mode}" in
        dry_run_sot)
            extra=(--dry-run-sot)
            event_store_paths_refresh
            tsv_path="${EVENT_DGA_EVENTS:-}"
            [[ -n "${tsv_path}" ]] && extra+=(--event-file "${tsv_path}")
            ;;
    esac
    out=$(python3 "${pyfile}" --run-id "${run_id}" \
        --base-domain "${DGA_MODEL_BASE_DOMAIN}" \
        --nx-count "${DGA_MODEL_NX_COUNT}" \
        --resolvable-count "${DGA_MODEL_RESOLVABLE_COUNT}" \
        --resolver system \
        "${extra[@]}" 2>&1) || true
    printf '%s' "${out}"
}

dga_model_replay_stdout() {
    local out="$1" line=""
    while IFS= read -r line; do
        line=$(printf '%s' "${line}" | tr -d '\r')
        [[ -z "${line}" ]] && continue
        case "${line}" in
            DGA_TARGET_DOMAIN*|DGA_PHASE*|DGA_PACKET_EVIDENCE*|DGA_MODEL_SUMMARY*)
                dga_simulation_log_both "${line}"
                ;;
        esac
    done <<< "$(printf '%s\n' "${out}" | tr -d '\r' | grep -E '^DGA_(TARGET_DOMAIN|PHASE|PACKET_EVIDENCE|MODEL_)' || true)"
}

run_dga_model_client() {
    local run_id="${1:-${CAMPAIGN_ID:-run}}" out="" remote_cmd="" t0=0 t1=0 elapsed=0
    DGA_SKIP_REASON=""
    DGA_MODEL_LAST_OUT=""
    poc_sot_paths_init
    dga_simulation_log_both "DGA model client start base_domain=${DGA_MODEL_BASE_DOMAIN} nx=${DGA_MODEL_NX_COUNT} resolvable=${DGA_MODEL_RESOLVABLE_COUNT}"

    if [[ "${DRY_RUN}" == true ]]; then
        init_event_store 2>/dev/null || true
        out=$(run_dga_model_client_local "${run_id}" "dry_run_sot")
        dga_model_replay_stdout "${out}"
        event_stage_mark_executed "DGA_SIMULATION" "dga_model_client"
        event_sync_legacy_counters_from_sot || true
        dga_simulation_log_both "dry_run_sot tsv=$(event_store_row_count "${EVENT_DGA_EVENTS}")"
        return 0
    fi

    if ! net_sim_dga_model_local_bootstrap_precheck; then
        DGA_SKIP_REASON="${DGA_MODEL_BOOTSTRAP_CLASS:-python_missing}"
        dga_simulation_log_both "DGA_MODEL_REMOTE_BOOTSTRAP phase=local result=${DGA_SKIP_REASON}"
        [[ -n "${DGA_MODEL_BOOTSTRAP_STDERR}" ]] && dga_simulation_log_both "DGA_MODEL_REMOTE_STDERR ${DGA_MODEL_BOOTSTRAP_STDERR}"
        return 1
    fi
    dga_simulation_log_both "DGA_MODEL_REMOTE_BOOTSTRAP phase=local result=ok script=$(net_sim_dga_model_script_path)"
    remote_cmd=$(build_dga_model_client_remote_cmd "${run_id}") || {
        DGA_SKIP_REASON="script_missing"
        return 1
    }
    t0=$(date +%s)
    out=$(run_webshell_long "dga-model-client" "${remote_cmd}" 2>/dev/null || true)
    DGA_MODEL_LAST_OUT="${out}"
    t1=$(date +%s)
    elapsed=$((t1 - t0))
    dga_model_replay_stdout "${out}"
    if ! net_sim_dga_ingest_output "${out}"; then
        DGA_SKIP_REASON="${DGA_SKIP_REASON:-no_dga_model_events}"
        net_sim_block_stdout_final_decision "DGA_SIMULATION" "${out}"
        return 1
    fi
    net_sim_block_stdout_final_decision "DGA_SIMULATION" "${out}"
    event_sync_legacy_counters_from_sot || true
    local nx_nx=0 res_res=0
    nx_nx=$(safe_int "$(printf '%s' "${out}" | tr ' ' '\n' | sed -n 's/^nx_nxdomain=//p' | head -n1)")
    res_res=$(safe_int "$(printf '%s' "${out}" | tr ' ' '\n' | sed -n 's/^resolvable_resolved=//p' | head -n1)")
    if (( nx_nx < 1 && res_res < 1 )); then
        DGA_SKIP_REASON="dga_model_no_nx_or_resolved"
        return 1
    fi
    dga_simulation_log_both "DGA model client complete elapsed=${elapsed}s nx_nxdomain=${nx_nx} resolvable_resolved=${res_res}"
    return 0
}

net_sim_fetch_remote_dga_events() {
    local remote_path="" meta="" exists=no blob="" merged=0 local_before=0 local_after=0
    remote_path=$(net_sim_remote_dga_event_path)
    poc_sot_paths_init
    event_store_paths_refresh
    local_before=$(event_store_row_count "${EVENT_DGA_EVENTS}")
    meta=$(run_webshell_quick "dga-ev-meta" \
        "RP='${remote_path}'; if [ -f \"\$RP\" ]; then sz=\$(wc -c <\"\$RP\" | tr -d ' \\n'); ln=\$(awk 'END{print NR}' \"\$RP\" 2>/dev/null || echo 0); echo DGA_REMOTE_META exists=yes size=\${sz} lines=\${ln}; else echo DGA_REMOTE_META exists=no size=0 lines=0; fi" \
        2>/dev/null || true)
    meta=$(normalize_webshell_response "${meta}")
    exists=$(printf '%s' "${meta}" | tr ' ' '\n' | sed -n 's/^exists=//p' | head -n1)
    dga_simulation_log_both "DGA_REMOTE_EVENT_FILE path=${remote_path} exists=${exists:-no}"
    if [[ "${exists}" != yes ]]; then
        DGA_REMOTE_EVENT_FETCH_LINES=0
        return 1
    fi
    blob=$(net_sim_fetch_remote_file_blob "dga-ev" "${remote_path}" 2>/dev/null || true)
    [[ -n "${blob}" ]] || return 1
    merged=$(event_merge_dga_tsv_content "${blob}")
    merged=$(safe_int "${merged}")
    DGA_REMOTE_EVENT_FETCH_LINES="${merged}"
    local_after=$(event_store_row_count "${EVENT_DGA_EVENTS}")
    dga_simulation_log_both "DGA_REMOTE_EVENT_FETCH lines=${merged}"
    dga_simulation_log_both "DGA_EVENT_MERGE_RESULT local_events=${local_after} merged_rows=${merged} prior_rows=${local_before}"
    (( merged > 0 )) && return 0
    return 1
}

net_sim_fetch_remote_new_tld_events() {
    local remote_path="" meta="" exists=no blob="" merged=0 local_before=0 local_after=0
    remote_path=$(net_sim_remote_new_tld_event_path)
    poc_sot_paths_init
    event_store_paths_refresh
    local_before=$(event_store_row_count "${EVENT_NEW_TLD_EVENTS}")
    meta=$(run_webshell_quick "ntld-ev-meta" \
        "RP='${remote_path}'; if [ -f \"\$RP\" ]; then sz=\$(wc -c <\"\$RP\" | tr -d ' \\n'); ln=\$(awk 'END{print NR}' \"\$RP\" 2>/dev/null || echo 0); echo NEW_TLD_REMOTE_META exists=yes size=\${sz} lines=\${ln}; else echo NEW_TLD_REMOTE_META exists=no size=0 lines=0; fi" \
        2>/dev/null || true)
    meta=$(normalize_webshell_response "${meta}")
    exists=$(printf '%s' "${meta}" | tr ' ' '\n' | sed -n 's/^exists=//p' | head -n1)
    dns_new_tld_log_both "NEW_TLD_REMOTE_EVENT_FILE path=${remote_path} exists=${exists:-no}"
    if [[ "${exists}" != yes ]]; then
        NEW_TLD_REMOTE_EVENT_FETCH_LINES=0
        return 1
    fi
    blob=$(net_sim_fetch_remote_file_blob "ntld-ev" "${remote_path}" 2>/dev/null || true)
    [[ -n "${blob}" ]] || return 1
    merged=$(event_merge_new_tld_tsv_content "${blob}")
    merged=$(safe_int "${merged}")
    NEW_TLD_REMOTE_EVENT_FETCH_LINES="${merged}"
    local_after=$(event_store_row_count "${EVENT_NEW_TLD_EVENTS}")
    dns_new_tld_log_both "NEW_TLD_REMOTE_EVENT_FETCH lines=${merged}"
    dns_new_tld_log_both "NEW_TLD_EVENT_MERGE_RESULT local_events=${local_after} merged_rows=${merged} prior_rows=${local_before}"
    (( merged > 0 )) && return 0
    return 1
}

net_sim_dga_ingest_output() {
    local out="$1" merged=0
    if [[ "${DRY_RUN}" != true ]]; then
        net_sim_fetch_remote_dga_events && merged=$(safe_int "${DGA_REMOTE_EVENT_FETCH_LINES:-0}") || merged=0
    fi
    if (( merged < 1 )); then
        ingest_remote_events "${out}" "DGA" || true
    fi
    event_stage_mark_executed "DGA_SIMULATION" "dga_model_client"
}

net_sim_dga_dry_run_events() {
    local _run_id="${CAMPAIGN_ID:-run}" _out=""
    poc_sot_paths_init
    init_event_store 2>/dev/null || true
    _out=$(run_dga_model_client_local "${_run_id}" "dry_run_sot" 2>&1) || true
    dga_model_replay_stdout "${_out}"
    event_stage_mark_executed "DGA_SIMULATION" "dga_model_client"
}

net_sim_dns_tunnel_dry_run_events() {
    local _count="${1:-0}" out="" targets="127.0.0.1,127.0.0.2"
    poc_sot_paths_init
    init_event_store 2>/dev/null || true
    DNS_TUNNEL_MAX_SENT_CAP="${DNS_TUNNEL_MAX_SENT_CAP:-5000}"
    DNS_QUERIES_PLANNED=$(net_sim_dns_tunnel_plan_idx_count)
    dns_tunnel_log_both "DNS_TUNNEL_START mode=dry_run_sot targets=${targets}"
    out=$(run_dns_tunnel_simulator_local "${targets}" "${CAMPAIGN_ID:-run}" "dry_run_sot")
    event_stage_mark_executed "DNS_TUNNEL" "dns_tunnel_file_client"
    dns_tunnel_finalize_execution "${out}" "${DNS_QUERIES_PLANNED}" || true
    dns_tunnel_log_both "dry_run_sot tsv=$(event_store_row_count "${EVENT_DNS_EVENTS}") log_lines=$(printf '%s' "${out}" | wc -l | awk '{print $1}')"
}

net_sim_block_stdout_final_decision() {
    local module="$1" stdout_blob="${2:-}"
    event_reject_stdout_only_success "${module}" "${stdout_blob}" >/dev/null 2>&1 || true
}
