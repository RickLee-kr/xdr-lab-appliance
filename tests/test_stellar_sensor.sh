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
  *.sh|*.sh.part)
    case "${MOCK_CURL_MODE:-ok}" in
      fail)
        exit 22
        ;;
      missing)
        exit 0
        ;;
      empty)
        : >"${out}"
        ;;
      *)
        printf '#!/bin/sh\necho sensor deploy "$@"\n' >"${out}"
        ;;
    esac
    ;;
  *.qcow2|*.qcow2.part)
    case "${MOCK_CURL_MODE:-ok}" in
      fail)
        exit 22
        ;;
      missing)
        exit 0
        ;;
      empty)
        : >"${out}"
        ;;
      bad-qcow2)
        printf 'not-qcow2\n' >"${out}"
        ;;
      *)
        printf '\x51\x46\x49\xfbmock-qcow2\n' >"${out}"
        ;;
    esac
    ;;
  *)
    printf 'unexpected output %s\n' "${out}" >&2
    exit 10
    ;;
esac
exit 0
MOCK
  chmod +x "${bindir}/curl"
  cat >"${bindir}/qemu-img" <<'MOCK'
#!/bin/bash
set -euo pipefail
cmd="${1:-}"
target="${@: -1}"
case "${cmd}" in
  info)
    if /bin/grep -aq 'mock-qcow2' "${target}"; then
      printf '{"format":"qcow2"}\n'
      exit 0
    fi
    printf 'Image is corrupt\n' >&2
    exit 1
    ;;
  check)
    if /bin/grep -aq 'mock-qcow2' "${target}"; then
      printf 'No errors were found on the image.\n'
      exit 0
    fi
    printf 'Image is corrupt\n' >&2
    exit 1
    ;;
  *)
    exit 0
    ;;
esac
MOCK
  chmod +x "${bindir}/qemu-img"
}

run_image_download() {
  local tmp="$1"
  shift
  env -i \
    PATH="${tmp}/bin" \
    STELLAR_DOWNLOAD_USER="${STELLAR_DOWNLOAD_USER:-}" \
    STELLAR_DOWNLOAD_PASSWORD="${STELLAR_DOWNLOAD_PASSWORD:-}" \
    MOCK_CURL_MODE="${MOCK_CURL_MODE:-ok}" \
    "${PYTHON}" "${ROOT}/scripts/image_download_manager.py" \
      --manifest "${tmp}/config/images-manifest.json" \
      --state "${tmp}/state/images.json" \
      --xdr-root "${tmp}" \
      --log-file "${tmp}/logs/vm-manager.log" \
      --stellar-env "${tmp}/stellar-download.env" \
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
  assert_contains "credential expected mode" "owner root:xdr-lab, mode 0640 recommended" "${out}"
  assert_not_contains "credential missing no traceback" "Traceback" "${out}"
  rm -rf "${tmp}"
}

test_credential_file_unreadable() {
  local tmp out rc
  if [[ "$(id -u)" == "0" ]]; then
    echo "SKIP credential unreadable requires non-root test user"
    return 0
  fi
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  write_mock_curl "${tmp}/bin"
  mkdir -p "${tmp}/logs"
  cat >"${tmp}/stellar-download.env" <<'EOF'
STELLAR_DOWNLOAD_USER=file_secret_user
STELLAR_DOWNLOAD_PASSWORD=file_secret_password
EOF
  chmod 000 "${tmp}/stellar-download.env"
  set +e
  out="$(STELLAR_DOWNLOAD_USER= STELLAR_DOWNLOAD_PASSWORD= run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  chmod 600 "${tmp}/stellar-download.env"
  assert_eq "credential unreadable exit" "2" "${rc}"
  assert_contains "credential unreadable classified" "file exists but is not readable" "${out}"
  assert_contains "credential unreadable user" "current_user=" "${out}"
  assert_contains "credential unreadable path" "credential_file=${tmp}/stellar-download.env" "${out}"
  assert_contains "credential unreadable group" "required_owner_group=root:xdr-lab" "${out}"
  assert_contains "credential unreadable mode" "required_mode=0640" "${out}"
  assert_contains "credential unreadable remediation" "sudo chown root:xdr-lab ${tmp}/stellar-download.env && sudo chmod 640" "${out}"
  assert_not_contains "credential unreadable no traceback" "Traceback" "${out}"
  assert_not_contains "credential unreadable hides user" "file_secret_user" "${out}"
  assert_not_contains "credential unreadable hides password" "file_secret_password" "${out}"
  rm -rf "${tmp}"
}

test_env_override_unreadable_file() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  write_mock_curl "${tmp}/bin"
  mkdir -p "${tmp}/logs"
  cat >"${tmp}/stellar-download.env" <<'EOF'
STELLAR_DOWNLOAD_USER=file_secret_user
STELLAR_DOWNLOAD_PASSWORD=file_secret_password
EOF
  chmod 000 "${tmp}/stellar-download.env"
  set +e
  out="$(STELLAR_DOWNLOAD_USER=env_secret_user STELLAR_DOWNLOAD_PASSWORD=env_secret_password run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  chmod 600 "${tmp}/stellar-download.env"
  assert_eq "env override unreadable exit" "0" "${rc}"
  assert_contains "env override script verified" "shell-script" "${out}"
  assert_not_contains "env override hides env user" "env_secret_user" "${out}"
  assert_not_contains "env override hides env password" "env_secret_password" "${out}"
  assert_not_contains "env override hides file user" "file_secret_user" "${out}"
  assert_not_contains "env override hides file password" "file_secret_password" "${out}"
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
  assert_contains "download logs resolved version" '"resolved_version": "6.2.0"' "${out}"
  assert_contains "download logs target path" '"target_path":' "${out}"
  assert_contains "download logs curl exit" '"image_download_curl_result"' "${out}"
  assert_contains "download hard validation pass" "RESULT: PASS" "${out}"
  [[ -x "${tmp}/images/sensor/6.2.0/virt_deploy_modular_ds.sh" ]]
  assert_eq "script path executable" "0" "$?"
  [[ -f "${tmp}/images/sensor/6.2.0/aella-modular-ds-6.2.0.qcow2" ]]
  assert_eq "qcow2 path exists" "0" "$?"
  rm -rf "${tmp}"
}

test_bad_url_curl_exit_nonzero() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  write_mock_curl "${tmp}/bin"
  mkdir -p "${tmp}/logs"
  set +e
  out="$(MOCK_CURL_MODE=fail STELLAR_DOWNLOAD_USER=user STELLAR_DOWNLOAD_PASSWORD=pass run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  assert_eq "curl nonzero exit" "2" "${rc}"
  assert_contains "curl nonzero logged" '"image_download_curl_result"' "${out}"
  assert_contains "curl nonzero rc logged" '"rc": 22' "${out}"
  assert_contains "curl nonzero result fail" "curl failed (rc=22)" "${out}"
  rm -rf "${tmp}"
}

test_missing_file_after_download_fails() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  write_mock_curl "${tmp}/bin"
  mkdir -p "${tmp}/logs"
  set +e
  out="$(MOCK_CURL_MODE=missing STELLAR_DOWNLOAD_USER=user STELLAR_DOWNLOAD_PASSWORD=pass run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  assert_eq "missing artifact exit" "2" "${rc}"
  assert_contains "missing artifact reason" "missing_or_empty_download" "${out}"
  assert_contains "missing artifact result" "curl produced no artifact" "${out}"
  rm -rf "${tmp}"
}

test_empty_file_fails_validation() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  write_mock_curl "${tmp}/bin"
  mkdir -p "${tmp}/logs"
  set +e
  out="$(MOCK_CURL_MODE=empty STELLAR_DOWNLOAD_USER=user STELLAR_DOWNLOAD_PASSWORD=pass run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  assert_eq "empty artifact exit" "2" "${rc}"
  assert_contains "empty artifact rejected" "missing_or_empty_download" "${out}"
  rm -rf "${tmp}"
}

test_corrupt_qcow2_fails_deep_validation() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  write_mock_curl "${tmp}/bin"
  mkdir -p "${tmp}/logs"
  set +e
  out="$(MOCK_CURL_MODE=bad-qcow2 STELLAR_DOWNLOAD_USER=user STELLAR_DOWNLOAD_PASSWORD=pass run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  assert_eq "corrupt qcow2 exit" "2" "${rc}"
  assert_contains "corrupt qcow2 rejected" "artifact is not a QEMU QCOW2 image" "${out}"
  assert_contains "corrupt qcow2 result fail" "validation_result" "${out}"
  rm -rf "${tmp}"
}

test_wrong_filename_manifest_mismatch_fails() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  write_mock_curl "${tmp}/bin"
  mkdir -p "${tmp}/logs"
  "${PYTHON}" - "${tmp}/config/images-manifest.json" <<'PY'
import json, sys
path = sys.argv[1]
data = json.loads(open(path, encoding="utf-8").read())
for image in data["images"]:
    if image.get("name") == "sensor-virt-deploy-script":
        image["output_path"] = "images/sensor/6.2.0/wrong_deploy_name.sh"
open(path, "w", encoding="utf-8").write(json.dumps(data) + "\n")
PY
  set +e
  out="$(STELLAR_DOWNLOAD_USER=user STELLAR_DOWNLOAD_PASSWORD=pass run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  assert_eq "wrong filename exit" "2" "${rc}"
  assert_contains "wrong filename hard validation" "Stellar sensor deploy script missing" "${out}"
  assert_contains "wrong filename result fail" "RESULT: FAIL" "${out}"
  rm -rf "${tmp}"
}

test_manifest_missing_required_sensor_artifact_fails() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  write_mock_curl "${tmp}/bin"
  mkdir -p "${tmp}/logs"
  "${PYTHON}" - "${tmp}/config/images-manifest.json" <<'PY'
import json, sys
path = sys.argv[1]
data = json.loads(open(path, encoding="utf-8").read())
data["images"] = [image for image in data["images"] if image.get("name") != "aella-modular-ds-qcow2"]
open(path, "w", encoding="utf-8").write(json.dumps(data) + "\n")
PY
  set +e
  out="$(STELLAR_DOWNLOAD_USER=user STELLAR_DOWNLOAD_PASSWORD=pass run_image_download "${tmp}" download --select sensor-vm --version 6.2.0 2>&1)"
  rc=$?
  set -e
  assert_eq "manifest mismatch exit" "2" "${rc}"
  assert_contains "manifest mismatch qcow2 missing" "Stellar sensor qcow2 missing" "${out}"
  assert_contains "manifest mismatch result fail" "RESULT: FAIL" "${out}"
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

test_debug_paths_redacts_credential_state() {
  local tmp out rc
  tmp="$(mktemp -d)"
  cat >"${tmp}/stellar-download.env" <<'EOF'
STELLAR_DOWNLOAD_USER=debug_secret_user
STELLAR_DOWNLOAD_PASSWORD=debug_secret_password
EOF
  chmod 640 "${tmp}/stellar-download.env"
  set +e
  out="$(XDR_LAB_STELLAR_DOWNLOAD_ENV="${tmp}/stellar-download.env" "${PYTHON}" "${ROOT}/appliance/appliance_cli.py" lab debug paths 2>&1)"
  rc=$?
  set -e
  assert_eq "debug paths exit" "0" "${rc}"
  assert_contains "debug paths credential readable" "stellar_download_env_readable=true" "${out}"
  assert_contains "debug paths credential mode" "stellar_download_env_mode=0640" "${out}"
  assert_contains "debug paths redacted marker" "stellar_download_env_values=redacted" "${out}"
  assert_not_contains "debug paths hides user" "debug_secret_user" "${out}"
  assert_not_contains "debug paths hides password" "debug_secret_password" "${out}"
  rm -rf "${tmp}"
}

test_cli_classifies_stellar_unreadable_as_permission_denied() {
  local out rc
  set +e
  out="$("${PYTHON}" - "${ROOT}" <<'PY'
import sys
sys.path.insert(0, sys.argv[1])
from appliance.appliance_cli import _failure_class
print(_failure_class(1, "ERROR: Stellar download credentials file exists but is not readable"))
PY
)"
  rc=$?
  set -e
  assert_eq "cli failure class helper exit" "0" "${rc}"
  assert_eq "cli stellar unreadable class" "permission_denied" "${out}"
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
  assert_contains "deploy nointeract" "--nointeract=true" "${out}"
  assert_contains "deploy bridge" "--bridge=br0" "${out}"
  assert_contains "deploy capture attach" "virsh attach-interface --domain sensor-vm --type network --source ovs-net --model virtio --config --live" "${out}"
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
case "${1:-}" in
  dominfo)
    exit 1
    ;;
  *)
    exit 1
    ;;
esac
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
  cat >"${tmp}/bin/virsh" <<'MOCK'
#!/bin/bash
case "${1:-}" in
  dominfo)
    exit 0
    ;;
  dumpxml)
    cat <<'XML'
<domain type='kvm'>
  <name>sensor-vm</name>
  <os><type arch='x86_64'>hvm</type></os>
  <devices>
    <disk type='file' device='disk'>
      <source file='/var/lib/libvirt/images/sensor-vm/images/sensor-vm/sensor-vm.raw'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <interface type='bridge'>
      <source network='ovs-net' bridge='br0'/>
      <target dev='vnet8'/>
      <model type='virtio'/>
    </interface>
    <interface type='bridge'>
      <source network='ovs-net' bridge='br0'/>
      <target dev='vnet9'/>
      <model type='virtio'/>
    </interface>
  </devices>
</domain>
XML
    ;;
  domstate)
    echo running
    ;;
  domifaddr)
    cat <<'EOF'
 Name       MAC address          Protocol     Address
-------------------------------------------------------------------------------
 vnet8      52:54:00:00:00:01    ipv4         10.10.10.10/24
EOF
    ;;
  *)
    exit 0
    ;;
esac
MOCK
  chmod +x "${tmp}/bin/virsh"
  cat >"${tmp}/bin/ovs-vsctl" <<'MOCK'
#!/bin/bash
cmd="$*"
if [[ "${cmd}" == *"find mirror"* ]]; then
  echo uuid-mirror-1
  exit 0
fi
if [[ "${cmd}" == *"list mirror"* && "${cmd}" == *output_port* ]]; then
  echo uuid-port-1
  exit 0
fi
if [[ "${cmd}" == *"list port uuid-port-1"* ]]; then
  echo vnet9
  exit 0
fi
exit 0
MOCK
  chmod +x "${tmp}/bin/ovs-vsctl"
  set +e
  out="$(PATH="${tmp}/bin:${PATH}" XDR_ROOT="${tmp}" bash "${ROOT}/bootstrap/validate-sensor-identity.sh" 2>&1)"
  rc=$?
  set -e
  assert_eq "verify found exit" "0" "${rc}"
  assert_contains "verify sensor type" "sensor_type=stellar_sensor" "${out}"
  assert_contains "verify version" "sensor_version=6.2.0" "${out}"
  assert_contains "verify found true" "stellar_sensor_artifact_found=true" "${out}"
  assert_contains "verify capture present" "sensor_capture_nic_present=true" "${out}"
  assert_contains "verify capture no ip" "sensor_capture_nic_has_ip=false" "${out}"
  assert_contains "verify capture mirror" "sensor_capture_nic_mirror_target=true" "${out}"
  assert_contains "verify ready true" "READY_FOR_STELLAR_SENSOR_SCENARIO=true" "${out}"
  rm -rf "${tmp}"
}

test_verify_rejects_generic_cloud_runtime_disk() {
  local tmp out rc
  tmp="$(mktemp -d)"
  copy_config "${tmp}"
  mkdir -p "${tmp}/bin" "${tmp}/images/sensor/6.2.0"
  printf '#!/bin/sh\nexit 0\n' >"${tmp}/images/sensor/6.2.0/virt_deploy_modular_ds.sh"
  chmod +x "${tmp}/images/sensor/6.2.0/virt_deploy_modular_ds.sh"
  printf '\x51\x46\x49\xfbmock-qcow2\n' >"${tmp}/images/sensor/6.2.0/aella-modular-ds-6.2.0.qcow2"
  cat >"${tmp}/bin/virsh" <<'MOCK'
#!/bin/bash
case "${1:-}" in
  dominfo)
    exit 0
    ;;
  dumpxml)
    cat <<'XML'
<domain type='kvm'>
  <name>sensor-vm</name>
  <os><type arch='x86_64'>hvm</type></os>
  <devices>
    <disk type='file' device='disk'>
      <source file='/opt/xdr-lab/images/victim-linux/ubuntu-24.04-server-cloudimg-amd64.img'/>
      <target dev='vda' bus='virtio'/>
    </disk>
  </devices>
</domain>
XML
    ;;
  domstate)
    echo running
    ;;
  *)
    exit 0
    ;;
esac
MOCK
  chmod +x "${tmp}/bin/virsh"
  set +e
  out="$(PATH="${tmp}/bin:${PATH}" XDR_ROOT="${tmp}" bash "${ROOT}/bootstrap/validate-sensor-identity.sh" 2>&1)"
  rc=$?
  set -e
  assert_eq "verify generic disk exit" "42" "${rc}"
  assert_contains "verify generic disk rejected" "deprecated Ubuntu cloud-image runtime detected" "${out}"
  rm -rf "${tmp}"
}

echo "=== test_stellar_sensor ==="
test_credential_missing
test_credential_file_unreadable
test_env_override_unreadable_file
test_placeholder_blocked
test_version_path_resolution_and_mock_download
test_bad_url_curl_exit_nonzero
test_missing_file_after_download_fails
test_empty_file_fails_validation
test_corrupt_qcow2_fails_deep_validation
test_wrong_filename_manifest_mismatch_fails
test_manifest_missing_required_sensor_artifact_fails
test_resource_minimum_validation
test_debug_paths_redacts_credential_state
test_cli_classifies_stellar_unreadable_as_permission_denied
test_deploy_command_rendering
test_verify_artifact_missing_and_found
test_verify_rejects_generic_cloud_runtime_disk

echo "---"
echo "passed=${PASS} failed=${FAIL}"
if [[ "${FAIL}" -gt 0 ]]; then
  exit 1
fi
exit 0
