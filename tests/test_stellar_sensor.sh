#!/usr/bin/env bash
# Tests for Stellar Modular Data Sensor download/deploy/verify without live downloads.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON="$(command -v python3)"
PASS=0
FAIL=0

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [[ "${actual}" == "${expected}" ]]; then
    echo "PASS ${label}"
    PASS=$((PASS + 1))
  else
    echo "FAIL ${label} expected=${expected} actual=${actual}" >&2
    FAIL=$((FAIL + 1))
  fi
}

assert_contains() {
  local label="$1" needle="$2" haystack="$3"
  if grep -Fq -- "${needle}" <<<"${haystack}"; then
    echo "PASS ${label}"
    PASS=$((PASS + 1))
  else
    echo "FAIL ${label} missing '${needle}' in output" >&2
    FAIL=$((FAIL + 1))
  fi
}

assert_not_contains() {
  local label="$1" needle="$2" haystack="$3"
  if grep -Fq -- "${needle}" <<<"${haystack}"; then
    echo "FAIL ${label} unexpected '${needle}' in output" >&2
    FAIL=$((FAIL + 1))
  else
    echo "PASS ${label}"
    PASS=$((PASS + 1))
  fi
}

copy_config() {
  local tmp="$1"
  mkdir -p "${tmp}/config"
  cp "${ROOT}/config/lab-vms.json" "${tmp}/config/lab-vms.json"
  cp "${ROOT}/config/images-manifest.json" "${tmp}/config/images-manifest.json"
}

write_mock_curl() {
  local bindir="$1"
  mkdir -p "${bindir}"
  cat >"${bindir}/curl" <<'MOCK'
#!/bin/bash
set -euo pipefail
out=""
prev=""
for arg in "$@"; do
  if [[ "${prev}" == "-o" ]]; then
    out="${arg}"
    break
  fi
  prev="${arg}"
done
[[ -n "${out}" ]] || exit 9
case "${out}" in
  *.sh)
    printf '#!/bin/sh\necho sensor deploy "$@"\n' >"${out}"
    ;;
  *.qcow2)
    printf '\x51\x46\x49\xfbmock-qcow2\n' >"${out}"
    ;;
  *)
    printf 'unexpected output %s\n' "${out}" >&2
    exit 10
    ;;
esac
exit 0
MOCK
  chmod +x "${bindir}/curl"
}

run_image_download() {
  local tmp="$1"
  shift
  env -i \
    PATH="${tmp}/bin" \
    STELLAR_DOWNLOAD_USER="${STELLAR_DOWNLOAD_USER:-}" \
    STELLAR_DOWNLOAD_PASSWORD="${STELLAR_DOWNLOAD_PASSWORD:-}" \
    "${PYTHON}" "${ROOT}/scripts/image_download_manager.py" \
      --manifest "${tmp}/config/images-manifest.json" \
      --state "${tmp}/state/images.json" \
      --xdr-root "${tmp}" \
      --log-file "${tmp}/logs/vm-manager.log" \
      "$@"
}

test_credential_missing() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  write_mock_curl "${tmp}/bin"
  mkdir -p "${tmp}/logs"
  set +e
  out="$(STELLAR_DOWNLOAD_USER= STELLAR_DOWNLOAD_PASSWORD= run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  assert_eq "credential missing exit" "2" "${rc}"
  assert_contains "credential missing message" "Stellar download credentials missing" "${out}"
  rm -rf "${tmp}"
}

test_placeholder_blocked() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  "${PYTHON}" - "${tmp}/config/images-manifest.json" <<'PY'
import json, sys
path = sys.argv[1]
data = json.loads(open(path, encoding="utf-8").read())
for image in data["images"]:
    if image.get("vm_role") == "sensor-vm":
        image["url"] = "https://REPLACE_ME.example.invalid/sensor"
open(path, "w", encoding="utf-8").write(json.dumps(data) + "\n")
PY
  set +e
  out="$(STELLAR_DOWNLOAD_USER=user STELLAR_DOWNLOAD_PASSWORD=pass run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  assert_eq "placeholder exit" "2" "${rc}"
  assert_contains "placeholder error" "CONFIG_PLACEHOLDER_ERROR" "${out}"
  rm -rf "${tmp}"
}

test_version_path_resolution_and_mock_download() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  write_mock_curl "${tmp}/bin"
  mkdir -p "${tmp}/logs"
  set +e
  out="$(STELLAR_DOWNLOAD_USER=user STELLAR_DOWNLOAD_PASSWORD=pass run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  assert_eq "mock download exit" "0" "${rc}"
  assert_contains "script type verified" "shell-script" "${out}"
  assert_contains "qcow2 type verified" "qcow2" "${out}"
  [[ -x "${tmp}/images/sensor/6.2.0/virt_deploy_modular_ds.sh" ]]
  assert_eq "script path executable" "0" "$?"
  [[ -f "${tmp}/images/sensor/6.2.0/aella-modular-ds-6.2.0.qcow2" ]]
  assert_eq "qcow2 path exists" "0" "$?"
  rm -rf "${tmp}"
}

test_resource_minimum_validation() {
  local out rc
  set +e
  out="$("${PYTHON}" "${ROOT}/appliance/appliance_cli.py" lab sensor deploy --version 6.2.0 --cpus 3 2>&1)"
  rc=$?
  set -e
  assert_eq "cpus minimum exit" "2" "${rc}"
  assert_contains "cpus minimum message" "--cpus must be an integer >= 4" "${out}"

  set +e
  out="$("${PYTHON}" "${ROOT}/appliance/appliance_cli.py" lab sensor deploy --version 6.2.0 --memory-mb notnum 2>&1)"
  rc=$?
  set -e
  assert_eq "memory numeric exit" "2" "${rc}"
  assert_contains "memory numeric message" "--memory-mb must be an integer >= 6144" "${out}"
}

test_deploy_command_rendering() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  mkdir -p "${tmp}/images/sensor/6.2.0" "${tmp}/runtime" "${tmp}/logs"
  printf '#!/bin/sh\necho deploy "$@"\n' >"${tmp}/images/sensor/6.2.0/virt_deploy_modular_ds.sh"
  chmod +x "${tmp}/images/sensor/6.2.0/virt_deploy_modular_ds.sh"
  printf '\x51\x46\x49\xfbmock-qcow2\n' >"${tmp}/images/sensor/6.2.0/aella-modular-ds-6.2.0.qcow2"
  set +e
  out="$(XDR_LAB_DEV_MODE=1 XDR_ROOT="${tmp}" XDR_BASE="${tmp}" XDR_IMAGES_DIR="${tmp}/images" \
    XDR_RUNTIME_DIR="${tmp}/runtime" XDR_LOGS_DIR="${tmp}/logs" XDR_LAB_DRY_RUN=1 \
    bash "${ROOT}/scripts/xdr-lab-vm-manager.sh" sensor deploy --version 6.2.0 \
      --cpus 8 --memory-mb 12288 --disk-gb 120 2>&1)"
  rc=$?
  set -e
  assert_eq "deploy render exit" "0" "${rc}"
  assert_contains "deploy release" "--release=6.2.0" "${out}"
  assert_contains "deploy cpus" "--CPUS=8" "${out}"
  assert_contains "deploy memory" "--MEM=12288" "${out}"
  assert_contains "deploy disk" "--DISKSIZE=120" "${out}"
  assert_contains "deploy nodownload" "--nodownload=true" "${out}"
  assert_contains "deploy bridge" "--bridge=br0" "${out}"
  assert_not_contains "no span option" "--span" "${out}"
  assert_not_contains "no br0-span" "br0-span" "${out}"
  rm -rf "${tmp}"
}

test_verify_artifact_missing_and_found() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  mkdir -p "${tmp}/bin"
  cat >"${tmp}/bin/virsh" <<'MOCK'
#!/bin/bash
exit 1
MOCK
  chmod +x "${tmp}/bin/virsh"
  set +e
  out="$(PATH="${tmp}/bin:${PATH}" XDR_ROOT="${tmp}" bash "${ROOT}/bootstrap/validate-sensor-identity.sh" 2>&1)"
  rc=$?
  set -e
  assert_eq "verify missing exit" "42" "${rc}"
  assert_contains "verify missing found false" "stellar_sensor_artifact_found=false" "${out}"
  assert_contains "verify missing ready false" "READY_FOR_STELLAR_SENSOR_SCENARIO=false" "${out}"

  mkdir -p "${tmp}/images/sensor/6.2.0"
  printf '#!/bin/sh\nexit 0\n' >"${tmp}/images/sensor/6.2.0/virt_deploy_modular_ds.sh"
  chmod +x "${tmp}/images/sensor/6.2.0/virt_deploy_modular_ds.sh"
  printf '\x51\x46\x49\xfbmock-qcow2\n' >"${tmp}/images/sensor/6.2.0/aella-modular-ds-6.2.0.qcow2"
  set +e
  out="$(PATH="${tmp}/bin:${PATH}" XDR_ROOT="${tmp}" bash "${ROOT}/bootstrap/validate-sensor-identity.sh" 2>&1)"
  rc=$?
  set -e
  assert_eq "verify found exit" "0" "${rc}"
  assert_contains "verify sensor type" "sensor_type=stellar_sensor" "${out}"
  assert_contains "verify version" "sensor_version=6.2.0" "${out}"
  assert_contains "verify found true" "stellar_sensor_artifact_found=true" "${out}"
  assert_contains "verify ready true" "READY_FOR_STELLAR_SENSOR_SCENARIO=true" "${out}"
  rm -rf "${tmp}"
}

echo "=== test_stellar_sensor ==="
test_credential_missing
test_placeholder_blocked
test_version_path_resolution_and_mock_download
test_resource_minimum_validation
test_deploy_command_rendering
test_verify_artifact_missing_and_found

echo "---"
echo "passed=${PASS} failed=${FAIL}"
if [[ "${FAIL}" -gt 0 ]]; then
  exit 1
fi
exit 0
