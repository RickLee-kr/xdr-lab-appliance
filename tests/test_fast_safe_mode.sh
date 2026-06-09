#!/usr/bin/env bash
# Fixture/dry-run checks for fast-safe default mode and --mode comprehensive
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0
FAIL=0

pass() { echo "PASS $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL $1: $2" >&2; FAIL=$((FAIL + 1)); }

run_poc_dry() {
    "${ROOT}/stellar_poc.sh" --dry-run \
        --target-net 221.139.249.0/24 \
        --webshell http://127.0.0.1/shell.jsp \
        --attacker-ip 221.139.249.110 --attacker-port 5000 \
        "$@" 2>&1
}

out="$(mktemp)"
comp_out="$(mktemp)"
trap 'rm -f "${out}" "${comp_out}"' EXIT

if bash -n "${ROOT}/stellar_poc_fast_safe.sh"; then
    pass "bash -n stellar_poc_fast_safe.sh"
else
    fail "bash -n stellar_poc_fast_safe.sh" "syntax error"
fi

if run_poc_dry --fast-safe-workers 4 >"${out}"; then
    pass "stellar_poc.sh --dry-run (default mode) exit 0"
else
    fail "default dry-run exit" "non-zero"
fi

for needle in \
    "FAST_SAFE_MODE enabled=true" \
    "FAST_SAFE_MAX_WORKERS=4" \
    "FAST_SAFE_TARGET_RUNTIME=8m" \
    "FAST_SAFE_HARD_TIMEOUT=10m" \
    "FAST_SAFE_STAGE_START name=HTTP URL Scan" \
    "FAST_SAFE_STAGE_END name=HTTP URL Scan" \
    "[FAST-SAFE PLAN]"; do
    if grep -Fq "${needle}" "${out}"; then
        pass "default output contains: ${needle}"
    else
        fail "default missing output" "${needle}"
    fi
done

if grep -Fq "Pipeline overlap configured: true" "${out}"; then
    fail "default should not enable pipeline overlap" "overlap=true in dry-run plan"
else
    pass "default dry-run does not plan full overlap pipeline"
fi

if run_poc_dry --mode comprehensive >"${comp_out}"; then
    pass "stellar_poc.sh --dry-run --mode comprehensive exit 0"
else
    fail "comprehensive dry-run exit" "non-zero"
fi

if grep -Fq "FAST_SAFE_MODE enabled=true" "${comp_out}"; then
    fail "comprehensive mode must not activate fast-safe" "FAST_SAFE_MODE in output"
else
    pass "comprehensive mode does not activate fast-safe"
fi

if grep -Fq "Mode/Profile: comprehensive" "${comp_out}" \
    && grep -Fq "Overlap: true" "${comp_out}"; then
    pass "comprehensive dry-run plans full lab pipeline (overlap enabled)"
else
    fail "comprehensive pipeline plan" "missing comprehensive/overlap markers"
fi

if grep -Fq "EXTERNAL_CALLBACK_SKIPPED reason=listener_unreachable_or_blocked" "${out}" \
    || grep -Fq "Beacon fast-safe:" "${out}" \
    || grep -Fq "External Callback" "${out}"; then
    pass "callback stage present in default dry-run output"
else
    fail "callback output" "no callback-related lines"
fi

echo "---"
if (( FAIL == 0 )); then
    echo "All fast-safe / mode tests passed (${PASS})."
    exit 0
fi
echo "${FAIL} test(s) failed (${PASS} passed)."
exit 1
