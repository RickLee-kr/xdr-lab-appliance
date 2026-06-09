# ==============================================================================
# Stellar PoC — fast-safe field PoC mode (≤10 min, dedicated execution pipeline)
# @stellar-poc-version: 1.2.0
# ==============================================================================

FAST_SAFE_MODE=false
FAST_SAFE_MAX_WORKERS=4
FAST_SAFE_TARGET_RUNTIME_SEC=600
FAST_SAFE_HARD_TIMEOUT_SEC=600
FAST_SAFE_START_EPOCH=0
FAST_SAFE_DEADLINE_EPOCH=0
FAST_SAFE_HARD_STOP=false
FAST_SAFE_DEADLINE_ENFORCED=false
FAST_SAFE_RESULTS_DIR=""
FAST_SAFE_WORKER_PIDS=()
FAST_SAFE_WORKER_LABELS=()
FAST_SAFE_WORKER_SLUGS=()
FAST_SAFE_WORKER_TIMEOUTS=()
FAST_SAFE_COMPLETED_STAGES=""
FAST_SAFE_PARTIAL_STAGES=""
FAST_SAFE_SKIPPED_STAGES=""
FAST_SAFE_FAILED_STAGES=""
FAST_SAFE_ENV_ISSUES=""
FAST_SAFE_DETECTION_READINESS="unknown"
FAST_SAFE_CALLBACK_BEACON_MIN=5
FAST_SAFE_CALLBACK_BEACON_MAX=8
FAST_SAFE_NONSTANDARD_CONNECTION_TARGET=100
FAST_SAFE_DISCOVERY_PORTS=(22 53 80 443 445 8080 8443 8888 9000 9090)

# Per-stage runtime budgets (seconds); total ≤ FAST_SAFE_HARD_TIMEOUT_SEC
FAST_SAFE_BUDGET_DISCOVERY=120
FAST_SAFE_BUDGET_HTTP=120
FAST_SAFE_BUDGET_DNS=120
FAST_SAFE_BUDGET_MISC=60
FAST_SAFE_BUDGET_VALIDATION=60

FAST_SAFE_STAGE_T0=0
FAST_SAFE_CURRENT_STAGE_SLUG=""
FAST_SAFE_SKIP_HTTP_WORKER=false
FAST_SAFE_SKIP_DNS_WORKER=false
FAST_SAFE_DISCOVERY_CACHE_WARM=false

discovery_cache_has_services() {
    local total=0 f cache
    [[ -z "${LOCAL_STATE_DIR}" ]] && return 1
    for f in ssh_hosts.txt dns_hosts.txt http_targets.txt https_targets.txt smb_hosts.txt; do
        cache="${LOCAL_STATE_DIR}/remote_hosts/${f}"
        [[ -s "${cache}" ]] || continue
        total=$((total + $(safe_int "$(count_discovered_ips_in_file "${cache}" 2>/dev/null || echo 0)")))
    done
    (( total > 0 ))
}

fast_safe_discovery_cache_warm() {
    if discovery_cache_has_services; then
        FAST_SAFE_DISCOVERY_CACHE_WARM=true
        count_all_discovered_services >/dev/null 2>&1 || true
        log_message "OK" "FAST_SAFE_DISCOVERY_CACHE_REUSE services=${SERVICES_DISCOVERED_TOTAL:-0} action=skip_rescan"
        return 0
    fi
    FAST_SAFE_DISCOVERY_CACHE_WARM=false
    return 1
}

fast_safe_run_dns_detection_bundle() {
    local resolver="$1"
    [[ "${DNS_ENVIRONMENT_BLOCKED}" == true ]] && return 1
    [[ "${FAST_SAFE_SKIP_DNS_WORKER}" == true ]] && return 0
    pipeline_stop_requested && return 130
    fast_safe_stage_budget_exceeded "dns" && return 0
    log_message "OK" "FAST_SAFE_DNS_BUNDLE start resolver=${resolver:-system} dga=${DGA_SIMULATION_ENABLED} new_tld=${DNS_NEW_TLD_ENABLED}"
    if [[ "${DGA_SIMULATION_ENABLED}" == true ]]; then
        followup_stage_dga || true
    fi
    if [[ "${DNS_NEW_TLD_ENABLED}" == true ]]; then
        followup_stage_dns_new_tld || true
    fi
    log_message "OK" "FAST_SAFE_DNS_BUNDLE complete dga_queries=${DGA_TOTAL_QUERIES:-0} ntld_queries=${DNS_NEW_TLD_QUERY_COUNT:-0}"
    return 0
}

fast_safe_mode_enabled() {
    [[ "${MODE}" == "fast-safe" || "${FAST_SAFE_MODE}" == true ]]
}

validate_fast_safe_options() {
    fast_safe_mode_enabled || return 0
    _validate_positive_int "--fast-safe-workers" "${FAST_SAFE_MAX_WORKERS}" 2 8
}

parse_fast_safe_cli_switches() {
    case "$1" in
        --fast-safe-workers) FAST_SAFE_MAX_WORKERS="${2:-}"; return 0 ;;
    esac
    return 1
}

fast_safe_discovery_ports_csv() {
    local IFS=,
    printf '%s' "${FAST_SAFE_DISCOVERY_PORTS[*]}"
}

fast_safe_discovery_port_target_file() {
    case "$1" in
        443|8443) printf '%s' "https_targets.txt" ;;
        80|8080|8888|9000|9090) printf '%s' "http_targets.txt" ;;
        22) printf '%s' "ssh_hosts.txt" ;;
        53) printf '%s' "dns_hosts.txt" ;;
        445) printf '%s' "smb_hosts.txt" ;;
        *) printf '%s' "" ;;
    esac
}

fast_safe_discovery_all_ports() {
    printf '%s\n' "${FAST_SAFE_DISCOVERY_PORTS[@]}"
}

fast_safe_discovery_remote_port_specs() {
    local p file
    for p in "${FAST_SAFE_DISCOVERY_PORTS[@]}"; do
        file=$(fast_safe_discovery_port_target_file "${p}")
        [[ -n "${file}" ]] && printf '%s:%s ' "${p}" "${file}"
    done
}

fast_safe_discovery_all_specs_inline() {
    fast_safe_discovery_remote_port_specs
}

# Clock arms once at script start (main); never reset by deadline/watchdog.
fast_safe_arm_runtime_clock() {
    if [[ "${FAST_SAFE_START_EPOCH}" =~ ^[0-9]+$ && "${FAST_SAFE_START_EPOCH}" -gt 0 ]]; then
        return 0
    fi
    FAST_SAFE_START_EPOCH=$(date +%s)
    log_message "OK" "FAST_SAFE_START_EPOCH=${FAST_SAFE_START_EPOCH} total_budget_sec=${FAST_SAFE_HARD_TIMEOUT_SEC}"
}

fast_safe_total_runtime_seconds() {
    local now=0 elapsed=0
    now=$(date +%s)
    if [[ "${FAST_SAFE_START_EPOCH}" =~ ^[0-9]+$ && "${FAST_SAFE_START_EPOCH}" -gt 0 ]]; then
        elapsed=$((now - FAST_SAFE_START_EPOCH))
        (( elapsed < 0 )) && elapsed=0
    fi
    printf '%s' "${elapsed}"
}

fast_safe_init_deadline() {
    fast_safe_arm_runtime_clock
    FAST_SAFE_DEADLINE_EPOCH=$((FAST_SAFE_START_EPOCH + FAST_SAFE_HARD_TIMEOUT_SEC))
    FAST_SAFE_HARD_STOP=false
    FAST_SAFE_DEADLINE_ENFORCED=true
    log_message "OK" "FAST_SAFE_DEADLINE start_epoch=${FAST_SAFE_START_EPOCH} hard_timeout_sec=${FAST_SAFE_HARD_TIMEOUT_SEC} deadline_epoch=${FAST_SAFE_DEADLINE_EPOCH}"
}

fast_safe_time_remaining() {
    local now rem=0
    now=$(date +%s)
    if [[ "${FAST_SAFE_DEADLINE_EPOCH}" =~ ^[0-9]+$ && "${FAST_SAFE_DEADLINE_EPOCH}" -gt 0 ]]; then
        rem=$((FAST_SAFE_DEADLINE_EPOCH - now))
        (( rem < 0 )) && rem=0
    fi
    printf '%s' "${rem}"
}

fast_safe_log_time_remaining() {
    local rem
    rem=$(fast_safe_time_remaining)
    log_message "OK" "FAST_SAFE_TIME_REMAINING seconds=${rem} total_runtime=$(fast_safe_total_runtime_seconds)"
}

fast_safe_deadline_exceeded() {
    local now
    [[ "${FAST_SAFE_DEADLINE_ENFORCED}" == true ]] || return 1
    [[ "${FAST_SAFE_DEADLINE_EPOCH}" =~ ^[0-9]+$ && "${FAST_SAFE_DEADLINE_EPOCH}" -gt 0 ]] || return 1
    now=$(date +%s)
    (( now >= FAST_SAFE_DEADLINE_EPOCH )) && return 0
    return 1
}

fast_safe_elapsed_seconds() {
    fast_safe_total_runtime_seconds
}

fast_safe_begin_stage_budget() {
    local slug="$1"
    FAST_SAFE_CURRENT_STAGE_SLUG="${slug}"
    FAST_SAFE_STAGE_T0=$(date +%s)
}

fast_safe_stage_budget_sec() {
    case "$1" in
        discovery) printf '%s' "${FAST_SAFE_BUDGET_DISCOVERY}" ;;
        http) printf '%s' "${FAST_SAFE_BUDGET_HTTP}" ;;
        dns) printf '%s' "${FAST_SAFE_BUDGET_DNS}" ;;
        misc|ssh|callback|edr|nonstandard|ids_waf) printf '%s' "${FAST_SAFE_BUDGET_MISC}" ;;
        validation) printf '%s' "${FAST_SAFE_BUDGET_VALIDATION}" ;;
        *) printf '%s' "60" ;;
    esac
}

fast_safe_stage_budget_exceeded() {
    local slug="$1" budget=0 spent=0 now=0 global_rem=0
    slug="${slug:-${FAST_SAFE_CURRENT_STAGE_SLUG}}"
    [[ -z "${slug}" ]] && return 1
    fast_safe_deadline_exceeded && return 0
    budget=$(safe_int "$(fast_safe_stage_budget_sec "${slug}")")
    now=$(date +%s)
    if [[ "${FAST_SAFE_STAGE_T0}" =~ ^[0-9]+$ && "${FAST_SAFE_STAGE_T0}" -gt 0 ]]; then
        spent=$((now - FAST_SAFE_STAGE_T0))
    else
        spent=0
    fi
    global_rem=$(safe_int "$(fast_safe_time_remaining)")
    if (( global_rem < 1 || spent >= budget )); then
        log_message "WARN" "FAST_SAFE_STAGE_BUDGET_EXCEEDED slug=${slug} spent=${spent} budget=${budget} global_remaining=${global_rem}"
        return 0
    fi
    return 1
}

fast_safe_adjust_stage_timeout() {
    local stage_name="$1" original_sec="$2" slug="$3" remaining adjusted budget
    original_sec=$(safe_int "${original_sec}")
    slug="${slug:-misc}"
    budget=$(safe_int "$(fast_safe_stage_budget_sec "${slug}")")
    remaining=$(fast_safe_time_remaining 2>/dev/null || printf '0')
    remaining=$(safe_int "${remaining}")
    adjusted="${original_sec}"
    (( budget > 0 && budget < adjusted )) && adjusted="${budget}"
    if (( remaining < adjusted )); then
        adjusted="${remaining}"
        log_message "WARN" "FAST_SAFE_STAGE_TIMEOUT_ADJUST name=${stage_name} original=${original_sec} adjusted=${adjusted} reason=global_deadline"
    fi
    (( adjusted < 1 )) && adjusted=1
    printf '%s' "${adjusted}"
}

fast_safe_skip_stage_deadline() {
    local label="$1" slug="$2"
    fast_safe_log_stage_end "${label}" "skipped" "0"
    fast_safe_write_result_file "${slug}" "skipped" "0" "reason=deadline_exceeded"
    fast_safe_record_stage_outcome "${label}" "skipped"
    log_message "WARN" "FAST_SAFE_STAGE_SKIPPED name=${label} reason=deadline_exceeded"
}

fast_safe_terminate_all_workers() {
    local pid
    for pid in "${FAST_SAFE_WORKER_PIDS[@]}"; do
        [[ -n "${pid}" ]] && kill -TERM "${pid}" 2>/dev/null || true
    done
    interruptible_sleep 2 || true
    for pid in "${FAST_SAFE_WORKER_PIDS[@]}"; do
        [[ -n "${pid}" ]] && kill -KILL "${pid}" 2>/dev/null || true
    done
}

fast_safe_enforce_hard_timeout() {
    local elapsed
    FAST_SAFE_HARD_STOP=true
    elapsed=$(fast_safe_total_runtime_seconds)
    log_message "WARN" "FAST_SAFE_HARD_TIMEOUT_REACHED total_runtime=${elapsed} action=terminate_workers_and_summarize"
    fast_safe_terminate_all_workers
    fast_safe_reap_workers
}

fast_safe_init_results_dir() {
    FAST_SAFE_RESULTS_DIR="${LOCAL_STATE_DIR}/.fast_safe_results"
    mkdir -p "${FAST_SAFE_RESULTS_DIR}" 2>/dev/null || true
    : > "${FAST_SAFE_RESULTS_DIR}/.manifest" 2>/dev/null || true
}

fast_safe_write_result_file() {
    local slug="$1" status="$2" duration="$3"
    shift 3
    local f="${FAST_SAFE_RESULTS_DIR}/${slug}.result"
    {
        printf 'stage_slug=%s\n' "${slug}"
        printf 'status=%s\n' "${status}"
        printf 'duration_sec=%s\n' "${duration}"
        while [[ $# -gt 0 ]]; do
            printf '%s\n' "$1"
            shift
        done
    } > "${f}"
    echo "${slug}" >> "${FAST_SAFE_RESULTS_DIR}/.manifest"
}

fast_safe_record_stage_outcome() {
    local name="$1" status="$2"
    case "${status}" in
        success) FAST_SAFE_COMPLETED_STAGES="${FAST_SAFE_COMPLETED_STAGES}${name};" ;;
        partial) FAST_SAFE_PARTIAL_STAGES="${FAST_SAFE_PARTIAL_STAGES}${name};" ;;
        skipped) FAST_SAFE_SKIPPED_STAGES="${FAST_SAFE_SKIPPED_STAGES}${name};" ;;
        *) FAST_SAFE_FAILED_STAGES="${FAST_SAFE_FAILED_STAGES}${name};" ;;
    esac
}

fast_safe_infer_status_from_stage() {
    local label="$1"
    local line result reason
    line=$(grep -F "label=${label} " "${LOCAL_STATE_DIR}/stage_results.log" 2>/dev/null | tail -n1 || true)
    if [[ -z "${line}" ]]; then
        printf '%s' "partial"
        return 0
    fi
    if [[ "${line}" == *"result=Success"* || "${line}" == *"result=Fallback"* ]]; then
        printf '%s' "success"
    elif [[ "${line}" == *"result=Partial"* ]]; then
        printf '%s' "partial"
    elif [[ "${line}" == *"result=Skipped"* ]]; then
        printf '%s' "skipped"
    else
        printf '%s' "failed"
    fi
}

fast_safe_export_worker_env() {
    export FAST_SAFE_MODE LOCAL_STATE_DIR REMOTE_RUNTIME_DIR CAMPAIGN_ID TARGET_NET LOG_DIR EFFECTIVE_REPORT_DIR
    export HAS_dig HAS_nslookup HAS_host HAS_python3 HAS_curl HAS_ping HAS_bash HAS_ssh HAS_timeout HAS_nmap
    export REMOTE_SHELL_BIN WEBSHELL_CMD_STYLE REMOTE_SHELL_HELPERS POC_INTENSITY DRY_RUN
    export WEB_SHELL_URL WEBSHELL_METHOD WEBSHELL_LOCK_FILE ATTACKER_IP ATTACKER_BASE_URL ATTACKER_PORT
    export HTTP_SCAN_UNIQUE_URL_TARGET DNS_TUNNEL_QUERY_COUNT SSH_BURST_ATTEMPTS SSH_AUTH_BURST_ENABLED
    export EDR_STATIC_TEST_ENABLED FAST_SAFE_CALLBACK_BEACON_MIN FAST_SAFE_CALLBACK_BEACON_MAX
    export FAST_SAFE_NONSTANDARD_CONNECTION_TARGET
    export FAST_SAFE_SKIP_HTTP_WORKER FAST_SAFE_SKIP_DNS_WORKER
    export FAST_SAFE_START_EPOCH FAST_SAFE_DEADLINE_EPOCH FAST_SAFE_DEADLINE_ENFORCED
}

fast_safe_wait_worker_slot() {
    local max="${FAST_SAFE_MAX_WORKERS}" running=0
    while :; do
        pipeline_stop_requested && return 130
        fast_safe_reap_workers
        running=${#FAST_SAFE_WORKER_PIDS[@]}
        (( running < max )) && break
        interruptible_sleep 1 || return 130
    done
}

fast_safe_reap_workers() {
    local new_pids=() new_labels=() new_slugs=() new_timeouts=() i pid
    for i in "${!FAST_SAFE_WORKER_PIDS[@]}"; do
        pid="${FAST_SAFE_WORKER_PIDS[$i]}"
        [[ -z "${pid}" ]] && continue
        if kill -0 "${pid}" 2>/dev/null; then
            new_pids+=("${pid}")
            new_labels+=("${FAST_SAFE_WORKER_LABELS[$i]}")
            new_slugs+=("${FAST_SAFE_WORKER_SLUGS[$i]}")
            new_timeouts+=("${FAST_SAFE_WORKER_TIMEOUTS[$i]}")
        else
            wait "${pid}" 2>/dev/null || true
        fi
    done
    FAST_SAFE_WORKER_PIDS=("${new_pids[@]}")
    FAST_SAFE_WORKER_LABELS=("${new_labels[@]}")
    FAST_SAFE_WORKER_SLUGS=("${new_slugs[@]}")
    FAST_SAFE_WORKER_TIMEOUTS=("${new_timeouts[@]}")
}

fast_safe_launch_worker() {
    local label="$1" slug="$2" timeout_sec="$3" fn="$4"
    local pid t0
    if fast_safe_deadline_exceeded; then
        fast_safe_skip_stage_deadline "${label}" "${slug}"
        return 0
    fi
    if fast_safe_hard_stop_requested; then
        fast_safe_skip_stage_deadline "${label}" "${slug}"
        return 0
    fi
    case "${slug}" in
        http) [[ "${FAST_SAFE_SKIP_HTTP_WORKER}" == true ]] && { fast_safe_skip_stage_deadline "${label}" "${slug}"; return 0; } ;;
        dns) [[ "${FAST_SAFE_SKIP_DNS_WORKER}" == true ]] && { fast_safe_skip_stage_deadline "${label}" "${slug}"; return 0; } ;;
    esac
    timeout_sec=$(fast_safe_adjust_stage_timeout "${label}" "${timeout_sec}" "${slug}")
    fast_safe_wait_worker_slot || return 130
    if fast_safe_deadline_exceeded; then
        fast_safe_skip_stage_deadline "${label}" "${slug}"
        return 0
    fi
    t0=$(date +%s)
    fast_safe_log_stage_start "${label}"
  (
        fast_safe_export_worker_env
        fast_safe_begin_stage_budget "${slug}"
        FAST_SAFE_WORKER_T0="${t0}"
        FAST_SAFE_WORKER_TIMEOUT="${timeout_sec}"
        FAST_SAFE_WORKER_LABEL="${label}"
        FAST_SAFE_WORKER_SLUG="${slug}"
        run_stage_safe "${label}" "${fn}"
    ) &
    pid=$!
    FAST_SAFE_WORKER_PIDS+=("${pid}")
    FAST_SAFE_WORKER_LABELS+=("${label}")
    FAST_SAFE_WORKER_SLUGS+=("${slug}")
    FAST_SAFE_WORKER_TIMEOUTS+=("${timeout_sec}")
    state_append "fast_safe_workers.log" "label=${label} slug=${slug} pid=${pid} timeout=${timeout_sec}"
}

fast_safe_wait_all_workers() {
    local i pid label slug t0 now dur rc=0 status timeout_sec remaining
    for i in "${!FAST_SAFE_WORKER_PIDS[@]}"; do
        pid="${FAST_SAFE_WORKER_PIDS[$i]}"
        label="${FAST_SAFE_WORKER_LABELS[$i]:-unknown}"
        slug="${FAST_SAFE_WORKER_SLUGS[$i]:-$(fast_safe_slugify "${label}")}"
        timeout_sec="${FAST_SAFE_WORKER_TIMEOUTS[$i]:-90}"
        [[ -z "${pid}" ]] && continue
        pipeline_stop_requested && break
        fast_safe_deadline_exceeded && fast_safe_enforce_hard_timeout
        t0=$(date +%s)
        dur=0
        status=""
        while kill -0 "${pid}" 2>/dev/null; do
            pipeline_stop_requested && kill -TERM "${pid}" 2>/dev/null || true
            fast_safe_hard_stop_requested && kill -TERM "${pid}" 2>/dev/null || true
            if fast_safe_deadline_exceeded; then
                fast_safe_enforce_hard_timeout
                kill -TERM "${pid}" 2>/dev/null || true
                interruptible_sleep 2 || true
                kill -KILL "${pid}" 2>/dev/null || true
                status="partial"
                set_stage_result "${label}" "Partial" "fast-safe hard deadline exceeded"
                break
            fi
            now=$(date +%s)
            dur=$((now - t0))
            remaining=$(fast_safe_time_remaining 2>/dev/null || printf '0')
            remaining=$(safe_int "${remaining}")
            (( remaining > 0 && remaining < timeout_sec )) && timeout_sec="${remaining}"
            if (( dur >= timeout_sec )); then
                log_message "WARN" "FAST_SAFE worker timeout — terminating: ${label} (${dur}s)"
                kill -TERM "${pid}" 2>/dev/null || true
                interruptible_sleep 2 || true
                kill -KILL "${pid}" 2>/dev/null || true
                status="partial"
                set_stage_result "${label}" "Partial" "fast-safe stage timeout (${dur}s)"
                break
            fi
            interruptible_sleep 1 || break
        done
        if [[ -z "${status}" ]]; then
            wait "${pid}" 2>/dev/null || rc=$?
            now=$(date +%s)
            dur=$((now - t0))
            if (( rc == 124 || rc == 137 || rc == 143 )); then
                status="partial"
            else
                status=$(fast_safe_infer_status_from_stage "${label}")
            fi
        fi
        fast_safe_log_stage_end "${label}" "${status}" "${dur}"
        fast_safe_write_result_file "${slug}" "${status}" "${dur}" "label=${label}"
        fast_safe_record_stage_outcome "${label}" "${status}"
    done
    FAST_SAFE_WORKER_PIDS=()
    FAST_SAFE_WORKER_LABELS=()
    FAST_SAFE_WORKER_SLUGS=()
    FAST_SAFE_WORKER_TIMEOUTS=()
}

fast_safe_hard_stop_requested() {
    [[ "${FAST_SAFE_HARD_STOP}" == true ]]
}

fast_safe_start_hard_timeout_watchdog() {
    fast_safe_init_deadline
    (
        sleep "${FAST_SAFE_HARD_TIMEOUT_SEC}" 2>/dev/null || sleep 600
        fast_safe_enforce_hard_timeout
    ) &
    FAST_SAFE_WATCHDOG_PID=$!
}

fast_safe_stop_hard_timeout_watchdog() {
    [[ -n "${FAST_SAFE_WATCHDOG_PID:-}" ]] && kill "${FAST_SAFE_WATCHDOG_PID}" 2>/dev/null || true
    FAST_SAFE_WATCHDOG_PID=""
}

fast_safe_slugify() {
    printf '%s' "${1:-unknown}" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '_' | sed 's/^_//;s/_$//;s/__*/_/g'
}

fast_safe_log_stage_start() {
    log_message "OK" "FAST_SAFE_STAGE_START name=${1}"
}

fast_safe_log_stage_end() {
    local name="$1" status="$2" duration="$3"
    log_message "OK" "FAST_SAFE_STAGE_END name=${name} status=${status} duration=${duration} total_runtime=$(fast_safe_total_runtime_seconds)"
}

fast_safe_count_reachable_web() {
    local http=0 https=0
    http=$(safe_int "$(count_reachable_web_targets "http" 2>/dev/null || echo 0)")
    https=$(safe_int "$(count_reachable_web_targets "https" 2>/dev/null || echo 0)")
    printf '%s %s' "${http}" "${https}"
}

fast_safe_evaluate_fail_fast_gates() {
    local http_r=0 https_r=0 dns_n=0 alive_n=0
    read -r http_r https_r <<< "$(fast_safe_count_reachable_web)"
    FAST_SAFE_SKIP_HTTP_WORKER=false
    FAST_SAFE_SKIP_DNS_WORKER=false

    if (( http_r + https_r == 0 )); then
        FAST_SAFE_SKIP_HTTP_WORKER=true
        FAST_SAFE_ENV_ISSUES="${FAST_SAFE_ENV_ISSUES}fail_fast_no_reachable_http;"
        log_message "WARN" "FAST_SAFE_FAIL_FAST module=http reachable_http=0 reachable_https=0 action=skip_http_worker"
    fi

    if [[ -n "${DNS_TUNNEL_FILE_TARGETS:-}" ]]; then
        alive_n=$(printf '%s' "${DNS_TUNNEL_FILE_TARGETS}" | tr ',' '\n' | awk 'NF{c++} END{print c+0}')
    else
        alive_n=$(count_alive_hosts_from_discovery 2>/dev/null || echo 0)
        alive_n=$(safe_int "${alive_n}")
        if (( alive_n == 0 )); then
            dns_n=$(safe_int "$(count_remote_target_file "dns_hosts.txt" 2>/dev/null || echo 0)")
            alive_n="${dns_n}"
        fi
    fi
    if (( alive_n == 0 )); then
        FAST_SAFE_SKIP_DNS_WORKER=true
        FAST_SAFE_ENV_ISSUES="${FAST_SAFE_ENV_ISSUES}fail_fast_no_dns_targets;"
        log_message "WARN" "FAST_SAFE_FAIL_FAST module=dns alive_target_count=0 action=skip_dns_worker"
    fi
}

stage_fast_safe_service_discovery() {
    fast_safe_begin_stage_budget "discovery"
    poc_obs_stage_start "Discovery"
    add_executed_stage "Service Discovery"
    write_report_entries "service_discovery" "T1046" "NDR" "Internal Port Scan" "${TARGET_NET}" "start" "fast-safe key ports"
    run_webshell_quick "init-target-files" \
        "mkdir -p '${REMOTE_RUNTIME_DIR}' && for f in ssh_hosts.txt dns_hosts.txt http_targets.txt https_targets.txt smb_hosts.txt; do : > '${REMOTE_RUNTIME_DIR}'/\$f; done" \
        >/dev/null 2>&1 || true
    if [[ "${FAST_SAFE_DISCOVERY_CACHE_WARM}" != true ]]; then
        rm -rf "${LOCAL_STATE_DIR}/remote_hosts" 2>/dev/null || true
    fi
    mkdir -p "${LOCAL_STATE_DIR}/remote_hosts" 2>/dev/null || true
    DISCOVERY_NMAP_INLINE_OK=false
    log_message "OK" "FAST_SAFE discovery: key ports $(fast_safe_discovery_ports_csv) on ${TARGET_NET}"
    if fast_safe_stage_budget_exceeded "discovery"; then
        set_stage_result "Service Discovery" "Partial" "fast-safe discovery budget exceeded before scan"
        poc_obs_stage_end "Discovery"
        return 0
    fi
    if [[ "${HAS_nmap:-false}" == true ]]; then
        set_stage_result "Service Discovery" "Success" "fast-safe chunked nmap key ports"
        run_nmap_discovery_chunked
        count_all_discovered_services >/dev/null
    fi
    if fast_safe_stage_budget_exceeded "discovery"; then
        set_stage_result "Service Discovery" "Partial" "fast-safe discovery budget exceeded after nmap"
        poc_obs_stage_end "Discovery"
        return 0
    fi
    if [[ "${HAS_nmap:-false}" != true ]] || (( SERVICES_DISCOVERED_TOTAL == 0 )); then
        set_stage_result "Service Discovery" "Fallback" "fast-safe TCP probe key ports"
        add_fallback_usage "FAST_SAFE: TCP probe on key ports only"
        run_fallback_discovery_chunked
        count_all_discovered_services >/dev/null
    fi
    log_discovery_diagnostics
    record_discovered_services_snapshot
    poc_obs_emit_discovery_from_cache
    POC_OBS_ALIVE_HOSTS=$(count_alive_hosts_from_discovery 2>/dev/null || echo 0)
    poc_obs_stage_end "Discovery"
    write_report_entries "service_discovery" "T1046" "NDR" "Internal Port Scan" "${TARGET_NET}" "success" "fast-safe total=${SERVICES_DISCOVERED_TOTAL}"
}

run_fast_safe_discovery_phase() {
    pipeline_stop_requested && return 130
    fast_safe_deadline_exceeded && return 0
    fast_safe_begin_stage_budget "discovery"
    if fast_safe_discovery_cache_warm; then
        poc_obs_emit_discovery_from_cache 2>/dev/null || true
        POC_OBS_ALIVE_HOSTS=$(count_alive_hosts_from_discovery 2>/dev/null || echo 0)
        stage_validate_web_reachability || true
        fast_safe_evaluate_fail_fast_gates
        return 0
    fi
    run_pipeline_stage "Initial Foothold" stage_initial_foothold
    fast_safe_stage_budget_exceeded "discovery" && return 0
    run_pipeline_stage "Host Discovery" stage_host_discovery
    fast_safe_stage_budget_exceeded "discovery" && return 0
    run_pipeline_stage "Network Discovery" stage_network_discovery
    fast_safe_stage_budget_exceeded "discovery" && return 0
    run_pipeline_stage "Service Discovery" stage_fast_safe_service_discovery
    fast_safe_stage_budget_exceeded "discovery" && return 0
    # Fast-safe: service discovery + reachability only (no HTTP candidate / recursive / re-discovery sweeps)
    stage_validate_web_reachability || true
    fast_safe_evaluate_fail_fast_gates
    if (( SERVICES_DISCOVERED_TOTAL == 0 )); then
        FAST_SAFE_ENV_ISSUES="${FAST_SAFE_ENV_ISSUES}no_services_discovered;"
        log_message "WARN" "FAST_SAFE: no services discovered — continuing baseline DNS/callback/EDR where supported"
    fi
}

run_fast_safe_parallel_stages() {
    fast_safe_init_results_dir
    if [[ "${FAST_SAFE_DEADLINE_ENFORCED}" != true ]]; then
        fast_safe_start_hard_timeout_watchdog
    fi
    apply_followup_intensity_defaults
    resolve_http_scan_wave_plan

    if [[ "${DRY_RUN}" == true ]]; then
        local s t
        for s in \
            "HTTP URL Scan:http:120:followup_stage_http" \
            "IDS/WAF Signature Probe:ids_waf:60:stage_ids_waf_signature_probe" \
            "DNS Tunnel Enhanced:dns:120:stage_dns_tunnel_enhanced" \
            "SSH Auth Telemetry:ssh:60:stage_ssh_auth_burst" \
            "External Callback:callback:45:stage_external_callback" \
            "EDR Static Signature Test:edr:45:stage_edr_static_detection_test" \
            "Non-Standard Port Follow-up:nonstandard:45:stage_nonstandard_port_followup"; do
            IFS=':' read -r label slug timeout fn <<< "${s}"
            fast_safe_log_stage_start "${label}"
            run_stage_safe "${label}" "${fn}"
            t=$(fast_safe_infer_status_from_stage "${label}")
            fast_safe_log_stage_end "${label}" "${t}" "0"
            fast_safe_write_result_file "${slug}" "${t}" "0" "dry_run=true"
            fast_safe_record_stage_outcome "${label}" "${t}"
        done
        simulate_correlation_telemetry_dry_run || true
        fast_safe_stop_hard_timeout_watchdog
        return 0
    fi

    fast_safe_launch_worker "HTTP URL Scan" "http" "${FAST_SAFE_BUDGET_HTTP}" followup_stage_http
    fast_safe_launch_worker "IDS/WAF Signature Probe" "ids_waf" 60 stage_ids_waf_signature_probe
    fast_safe_launch_worker "DNS Tunnel Enhanced" "dns" "${FAST_SAFE_BUDGET_DNS}" stage_dns_tunnel_enhanced
    fast_safe_launch_worker "SSH Auth Telemetry" "ssh" 60 stage_ssh_auth_burst
    fast_safe_launch_worker "External Callback" "callback" 45 stage_external_callback
    fast_safe_launch_worker "EDR Static Signature Test" "edr" 45 stage_edr_static_detection_test
    fast_safe_launch_worker "Non-Standard Port Follow-up" "nonstandard" 45 stage_nonstandard_port_followup

    fast_safe_wait_all_workers || true
    if fast_safe_deadline_exceeded; then
        fast_safe_enforce_hard_timeout
    fi
    fast_safe_stop_hard_timeout_watchdog
    load_overlap_stage_results_from_state
}

fast_safe_collect_telemetry_counts() {
    printf 'http_unique=%s http_attempted=%s dns_queries=%s ssh_failures=%s callback_connected=%s nonstandard=%s edr_files=%s\n' \
        "${URL_SCAN_UNIQUE_ATTEMPTED:-${HTTP_SCAN_UNIQUE_URL_TARGET:-0}}" \
        "${HTTP_REQUESTS_ATTEMPTED:-0}" \
        "${DNS_QUERIES_ATTEMPTED:-0}" \
        "${SSH_AUTH_FAILURES_OBSERVED:-${FOLLOWUP_SSH_AUTH_FAILURES:-0}}" \
        "${EXTERNAL_CALLBACK_CONNECTED:-0}" \
        "${NONSTANDARD_PORT_CONNECTIONS:-0}" \
        "${EDR_TEST_FILES_SUCCESS:-0}"
}

fast_safe_compute_detection_readiness() {
    local score=0
    (( HTTP_REQUESTS_ATTEMPTED >= 20 || URL_SCAN_UNIQUE_ATTEMPTED >= 20 )) && score=$((score + 1))
    (( DNS_QUERIES_ATTEMPTED >= 50 )) && score=$((score + 1))
    (( SSH_AUTH_FAILURES_OBSERVED >= 10 || FOLLOWUP_SSH_AUTH_FAILURES >= 10 )) && score=$((score + 1))
    case "${score}" in
        3) FAST_SAFE_DETECTION_READINESS="HIGH" ;;
        2|3) FAST_SAFE_DETECTION_READINESS="MEDIUM" ;;
        *) FAST_SAFE_DETECTION_READINESS="LOW" ;;
    esac
}

fast_safe_merge_result_files_to_report() {
    local slug f status dur
    [[ -n "${REPORT_MD}" ]] || return 0
    {
        echo ""
        echo "## FAST-SAFE Mode Report"
        echo ""
        echo "- Mode: fast-safe (dedicated pipeline v2)"
        echo "- Total runtime: ${FAST_SAFE_TOTAL_RUNTIME_SEC:-0}s (budget ${FAST_SAFE_HARD_TIMEOUT_SEC}s, start_epoch=${FAST_SAFE_START_EPOCH})"
        echo "- Completed stages: ${FAST_SAFE_COMPLETED_STAGES:-none}"
        echo "- Partial stages: ${FAST_SAFE_PARTIAL_STAGES:-none}"
        echo "- Skipped stages: ${FAST_SAFE_SKIPPED_STAGES:-none}"
        echo "- Failed stages: ${FAST_SAFE_FAILED_STAGES:-none}"
        echo "- Environment issues: ${FAST_SAFE_ENV_ISSUES:-none}"
        echo "- Detection readiness: ${FAST_SAFE_DETECTION_READINESS:-unknown}"
        echo "- Telemetry generated: $(fast_safe_collect_telemetry_counts)"
        echo ""
        echo "### Per-stage results (.fast_safe_results)"
    } >> "${REPORT_MD}" 2>/dev/null || true
    if [[ -d "${FAST_SAFE_RESULTS_DIR}" ]]; then
        for f in "${FAST_SAFE_RESULTS_DIR}"/*.result; do
            [[ -f "${f}" ]] || continue
            slug=$(basename "${f}" .result)
            status=$(sed -n 's/^status=//p' "${f}" | head -n1)
            dur=$(sed -n 's/^duration_sec=//p' "${f}" | head -n1)
            echo "- ${slug}: status=${status:-unknown} duration=${dur:-0}s" >> "${REPORT_MD}" 2>/dev/null || true
        done
    fi
}

stage_fast_safe_followup_validation() {
    fast_safe_begin_stage_budget "validation"
    if declare -F sync_module_final_summaries_for_validation >/dev/null 2>&1; then
        sync_module_final_summaries_for_validation || true
    fi
    stage_followup_validation || true
    compute_and_log_final_validation || true
}

write_fast_safe_summary_block() {
    local elapsed=0 deadline_enforced=no
    elapsed=$(fast_safe_total_runtime_seconds)
    FAST_SAFE_TOTAL_RUNTIME_SEC="${elapsed}"
    [[ "${FAST_SAFE_DEADLINE_ENFORCED}" == true ]] && deadline_enforced=yes
    log_message "OK" "FINAL_RUNTIME_SUMMARY mode=fast-safe total_runtime=${elapsed} start_epoch=${FAST_SAFE_START_EPOCH} hard_timeout=${FAST_SAFE_HARD_TIMEOUT_SEC} deadline_enforced=${deadline_enforced}"
    fast_safe_compute_detection_readiness
    compute_final_telemetry_validation 2>/dev/null || true
    poc_final_internal_consistency_check 2>/dev/null || true
    fast_safe_merge_result_files_to_report
    if [[ -n "${SUMMARY_TXT}" ]]; then
        cat >> "${SUMMARY_TXT}" 2>/dev/null <<EOF || true

[FAST-SAFE SUMMARY]
Mode=fast-safe runtime=${elapsed}s readiness=${FAST_SAFE_DETECTION_READINESS}
completed=${FAST_SAFE_COMPLETED_STAGES:-none}
partial=${FAST_SAFE_PARTIAL_STAGES:-none}
skipped=${FAST_SAFE_SKIPPED_STAGES:-none}
failed=${FAST_SAFE_FAILED_STAGES:-none}
env_issues=${FAST_SAFE_ENV_ISSUES:-none}
telemetry=$(fast_safe_collect_telemetry_counts)
EOF
    fi
}

run_fast_safe_pipeline_once() {
    FAST_SAFE_HARD_STOP=false
    FAST_SAFE_COMPLETED_STAGES=""
    FAST_SAFE_PARTIAL_STAGES=""
    FAST_SAFE_SKIPPED_STAGES=""
    FAST_SAFE_FAILED_STAGES=""
    fast_safe_arm_runtime_clock
    if [[ "${FAST_SAFE_DEADLINE_ENFORCED}" != true ]]; then
        fast_safe_init_deadline
        fast_safe_start_hard_timeout_watchdog
    fi
    run_fast_safe_discovery_phase || true
    pipeline_stop_requested && return 130
    run_fast_safe_parallel_stages || true
    stage_fast_safe_followup_validation || true
    write_fast_safe_summary_block
    fast_safe_stop_hard_timeout_watchdog
}

apply_fast_safe_profile() {
    fast_safe_mode_enabled || return 0
    FAST_SAFE_MODE=true
    PROFILE="normal"
    POC_INTENSITY="${POC_INTENSITY:-normal}"
    FOLLOWUP_INTENSITY="normal"
    MODE="fast-safe"

    PERSISTENT_BEACON=false
    PIPELINE_OVERLAP=false
    BURST_MODE=false
    SERVICE_SPIKE=false
    SLOW_HTTP=false
    AUTO_OVERLAP=false
    STRICT_FOLLOWUP_VALIDATION=false
    DGA_SIMULATION_ENABLED=true
    DNS_NEW_TLD_ENABLED=true
    DGA_NXDOMAIN_QUERIES=500
    DGA_RESOLVABLE_QUERIES=30
    DGA_SIM_CHUNK_SIZE=500
    DNS_NEW_TLD_DEFAULT_DOMAINS=15
    SSH_AUTH_BURST_ENABLED=true

    HTTP_FOLLOWUP_REQUESTS=20
    HTTP_FOLLOWUP_MAX_HOSTS=2
    HTTP_FOLLOWUP_URLS_PER_HOST=10
    HTTP_FOLLOWUP_MAX_REQUESTS=20
    HTTP_SCAN_UNIQUE_URL_TARGET=10
    HTTP_SCAN_MIN_REQUESTS_FAST_SAFE=10
    HTTP_SCAN_WAVES=1
    HTTP_SCAN_WAVE_FAIL_MIN=0
    HTTP_SCAN_WAVE_FAIL_MAX=0
    HTTP_SCAN_WAVE_SLEEP=0
    HTTP_SCAN_WAVE_ATTEMPT_CAP=15
    HTTP_SCAN_INTER_REQUEST_SLEEP=0

    SSH_BURST_ATTEMPTS=40
    SSH_BURST_CONCURRENCY=2
    SSH_AUTH_FAILURE_TARGET=40
    MIN_SSH_AUTH_FAILURES=30

    DNS_BURST_COUNT=200
    DNS_TUNNEL_QUERY_COUNT=200
    MIN_DNS_QUERIES=180
    DNS_QUERY_COUNT=200


    BEACON_COUNT=6
    INTERNAL_FANOUT_PER_TARGET=8
    SMB_PROBE_TARGET=5
    MIN_HTTP_FOLLOWUP=10
    MIN_SMB_PROBES=5

    PING_SWEEP_PARALLELISM=48
    FALLBACK_SCAN_PARALLELISM=32
    DISCOVERY_CHUNK_SIZE=64

    PIPELINE_CYCLE_SLEEP=5
    TIMING_PROFILE="balanced"
    NOISE_LEVEL="low"

    SSH_FAIL_COUNT="${SSH_BURST_ATTEMPTS}"
    HTTP_SCAN_REPEAT="${HTTP_FOLLOWUP_REQUESTS}"

    if [[ ! "${REPEAT_COUNT}" =~ ^[0-9]+$ || "${REPEAT_COUNT}" -lt 1 ]]; then
        REPEAT_COUNT=1
    fi
    if [[ ! "${DURATION_MINUTES}" =~ ^[0-9]+$ || "${DURATION_MINUTES}" -lt 1 ]]; then
        DURATION_MINUTES=10
    fi

    fast_safe_arm_runtime_clock

    log_message "OK" "FAST_SAFE_MODE enabled=true pipeline=dedicated_v2"
    log_message "OK" "FAST_SAFE_MAX_WORKERS=${FAST_SAFE_MAX_WORKERS}"
    log_message "OK" "FAST_SAFE_RUNTIME_BUDGET total=${FAST_SAFE_HARD_TIMEOUT_SEC}s discovery=${FAST_SAFE_BUDGET_DISCOVERY}s http=${FAST_SAFE_BUDGET_HTTP}s dns=${FAST_SAFE_BUDGET_DNS}ss misc=${FAST_SAFE_BUDGET_MISC}s validation=${FAST_SAFE_BUDGET_VALIDATION}s"
}

print_fast_safe_dry_run_plan() {
    cat <<EOF
[FAST-SAFE PLAN v2]
- Clock: FAST_SAFE_START_EPOCH at script start; TOTAL_RUNTIME = now - start (no mid-run reset)
- Discovery: parallel /24 ping + key ports $(fast_safe_discovery_ports_csv) (budget ${FAST_SAFE_BUDGET_DISCOVERY}s)
- No HTTP Candidate / Recursive / Re-discovery / Retry discovery stages
- HTTP targets: service-discovery reachable_http/https only + HTTP_TARGET_SCORE selection
- Parallel workers (max ${FAST_SAFE_MAX_WORKERS}): HTTP(${FAST_SAFE_BUDGET_HTTP}s) DNS(${FAST_SAFE_BUDGET_DNS}s) SSH/misc(${FAST_SAFE_BUDGET_MISC}s) Validation(${FAST_SAFE_BUDGET_VALIDATION}s)
- Hard stop: ${FAST_SAFE_HARD_TIMEOUT_SEC}s total
- Validation: module Final Summary → telemetry validation → FINAL_RUNTIME_SUMMARY
- Results: ${LOCAL_STATE_DIR}/.fast_safe_results/*.result
EOF
}

_stellar_fast_safe_self_check() {
    local fn missing=()
    for fn in fast_safe_mode_enabled apply_fast_safe_profile run_fast_safe_pipeline_once \
        fast_safe_arm_runtime_clock; do
        declare -F "${fn}" >/dev/null 2>&1 || missing+=("${fn}")
    done
    if ((${#missing[@]} > 0)); then
        printf 'STELLAR_POC_ERROR: stellar_poc_fast_safe.sh missing functions: %s\n' "${missing[*]}" >&2
        exit 1
    fi
}
_stellar_fast_safe_self_check
