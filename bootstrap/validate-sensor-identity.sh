#!/usr/bin/env bash
# Validate sensor-vm identity and whether real Stellar Sensor artifacts are present.
set -euo pipefail

REQUIRE_ROOT=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_runtime-validation-lib.sh
. "${SCRIPT_DIR}/_runtime-validation-lib.sh"

rv_reexec_as_root_if_needed "$@" || true

cfg="${XDR_LAB_VMS_JSON:-${XDR_ROOT}/config/lab-vms.json}"
sensor="${XDR_LAB_SENSOR_VM:-sensor-vm}"

fail() {
  rv_check_fail sensor_identity "$1"
  exit 42
}

pass() {
  rv_check_pass sensor_identity "$1"
  exit 0
}

[[ -f "${cfg}" ]] || fail "lab-vms.json missing: ${cfg}"

if ! command -v python3 >/dev/null 2>&1; then
  fail "python3 missing"
fi

read -r declared_type sensor_version cache_dir script_name image_url qcow2_name < <(python3 - "${cfg}" "${sensor}" <<'PY'
import json, sys
path, sensor = sys.argv[1:3]
with open(path, encoding="utf-8") as fh:
    cfg = json.load(fh)
vm = (cfg.get("vms") or {}).get(sensor) or {}
print(
    vm.get("type", ""),
    vm.get("sensor_version", ""),
    vm.get("sensor_cache_dir", ""),
    vm.get("virt_deploy_script_name", ""),
    vm.get("image_url", ""),
    vm.get("qcow2_name", ""),
)
PY
)

resolved_cache="${cache_dir}"
if [[ -n "${resolved_cache}" && "${resolved_cache}" != /* ]]; then
  resolved_cache="${XDR_ROOT}/${resolved_cache}"
fi

script_path="${resolved_cache}/${script_name}"
image_name="${qcow2_name:-$(basename "${image_url:-aella-modular-ds.qcow2}")}"
image_path="${resolved_cache}/${image_name}"
if [[ "${image_name}" == *.zst ]]; then
  image_path="${image_path%.zst}"
fi

script_ok=0
image_ok=0
[[ -n "${script_name}" && -x "${script_path}" ]] && script_ok=1
if [[ -f "${image_path}" ]]; then
  if python3 - "${image_path}" <<'PY' >/dev/null 2>&1
import sys
with open(sys.argv[1], "rb") as fh:
    sys.exit(0 if fh.read(4) == b"QFI\xfb" else 1)
PY
  then
    image_ok=1
  fi
fi

stellar_sensor_artifact_found=false
if [[ "${script_ok}" -eq 1 && "${image_ok}" -eq 1 ]]; then
  stellar_sensor_artifact_found=true
fi
stellar_sensor_ready="${stellar_sensor_artifact_found}"
ready_for_stellar_sensor_scenario="${stellar_sensor_ready}"

runtime_looks_generic=0
sensor_capture_nic_present=false
sensor_capture_nic_has_ip=false
sensor_capture_nic_mirror_target=false
sensor_network_separation_valid=false
sensor_mgmt_interface=""
sensor_capture_interface=""
sensor_capture_mac=""
if command -v virsh >/dev/null 2>&1 && virsh dominfo "${sensor}" >/dev/null 2>&1; then
  xml="$(virsh dumpxml "${sensor}" 2>/dev/null || true)"
  read -r sensor_mgmt_interface sensor_capture_interface sensor_capture_mac < <(python3 -c '
import sys
import xml.etree.ElementTree as ET

xml = sys.stdin.read()
try:
    root = ET.fromstring(xml)
except ET.ParseError:
    print(" ")
    sys.exit(0)
ifaces = []
for iface in root.findall("./devices/interface"):
    target = iface.find("target")
    dev = (target.get("dev") if target is not None else "") or ""
    if dev.startswith("vnet"):
        mac_el = iface.find("mac")
        mac = (mac_el.get("address") if mac_el is not None else "") or ""
        ifaces.append((dev, mac.lower()))
mgmt = ifaces[0] if len(ifaces) >= 1 else ""
capture = ifaces[1] if len(ifaces) >= 2 else ""
print(mgmt[0] if mgmt else "", capture[0] if capture else "", capture[1] if capture else "")
' <<<"${xml}")
  if [[ -n "${sensor_capture_interface}" ]]; then
    sensor_capture_nic_present=true
  fi
  domifaddr_out="$(virsh domifaddr "${sensor}" 2>/dev/null || true)"
  if [[ -n "${sensor_capture_interface}" ]] && grep -qE "^[[:space:]]*${sensor_capture_interface}[[:space:]]" <<<"${domifaddr_out}"; then
    sensor_capture_nic_has_ip=true
  elif [[ -n "${sensor_capture_mac}" ]] && grep -qiF "${sensor_capture_mac}" <<<"${domifaddr_out}"; then
    sensor_capture_nic_has_ip=true
  fi
  mirror_uuid="$(rv_ovs_mirror_uuid_by_name "${XDR_LAB_MIRROR_NAME:-mirror-to-sensor}" 2>/dev/null || true)"
  mirror_output=""
  if [[ -n "${mirror_uuid}" ]]; then
    mirror_output="$(rv_ovs_mirror_output_port_name "${mirror_uuid}" 2>/dev/null || true)"
  fi
  if [[ -n "${sensor_capture_interface}" && "${mirror_output}" == "${sensor_capture_interface}" ]]; then
    sensor_capture_nic_mirror_target=true
  fi
  if [[ -n "${sensor_mgmt_interface}" \
      && -n "${sensor_capture_interface}" \
      && "${sensor_mgmt_interface}" != "${sensor_capture_interface}" \
      && "${sensor_capture_nic_has_ip}" != "true" ]]; then
    sensor_network_separation_valid=true
  fi
  if python3 -c '
import sys
import xml.etree.ElementTree as ET

xml = sys.stdin.read()
try:
    root = ET.fromstring(xml)
except ET.ParseError:
    sys.exit(1)

generic_markers = ("ubuntu-", "cloud", "cloud.img", "cloudimg")
for disk in root.findall("./devices/disk"):
    if disk.get("device") != "disk":
        continue
    source = disk.find("source")
    if source is None:
        continue
    source_text = " ".join(str(v).lower() for v in source.attrib.values())
    if any(marker in source_text for marker in generic_markers):
        sys.exit(0)
sys.exit(1)
' <<<"${xml}"
  then
    runtime_looks_generic=1
  fi
  state="$(virsh domstate "${sensor}" 2>/dev/null | tr -d '\r' || true)"
else
  state=""
fi

sensor_type="stellar_sensor"
if [[ "${declared_type}" != "sensor" || "${runtime_looks_generic}" -eq 1 ]]; then
  stellar_sensor_ready=false
fi
if [[ "${sensor_capture_nic_present}" != "true" || "${sensor_capture_nic_has_ip}" == "true" || "${sensor_capture_nic_mirror_target}" != "true" || "${sensor_network_separation_valid}" != "true" ]]; then
  stellar_sensor_ready=false
fi
if [[ -n "${state}" && "${state}" != "running" ]]; then
  stellar_sensor_ready=false
fi
ready_for_stellar_sensor_scenario="${stellar_sensor_ready}"

cat <<EOF
sensor_type=${sensor_type}
sensor_version=${sensor_version:-unknown}
stellar_sensor_artifact_found=${stellar_sensor_artifact_found}
stellar_sensor_ready=${stellar_sensor_ready}
sensor_mgmt_interface=${sensor_mgmt_interface:-unknown}
sensor_capture_interface=${sensor_capture_interface:-unknown}
sensor_capture_nic_present=${sensor_capture_nic_present}
sensor_capture_nic_has_ip=${sensor_capture_nic_has_ip}
sensor_capture_nic_mirror_target=${sensor_capture_nic_mirror_target}
sensor_network_separation_valid=${sensor_network_separation_valid}
READY_FOR_STELLAR_SENSOR_SCENARIO=${ready_for_stellar_sensor_scenario}
EOF

detail="sensor_type=${sensor_type} sensor_version=${sensor_version:-unknown} stellar_sensor_artifact_found=${stellar_sensor_artifact_found} stellar_sensor_ready=${stellar_sensor_ready} sensor_capture_nic_present=${sensor_capture_nic_present} sensor_capture_nic_has_ip=${sensor_capture_nic_has_ip} sensor_capture_nic_mirror_target=${sensor_capture_nic_mirror_target} sensor_network_separation_valid=${sensor_network_separation_valid} READY_FOR_STELLAR_SENSOR_SCENARIO=${ready_for_stellar_sensor_scenario}"

if [[ "${declared_type}" != "sensor" ]]; then
  fail "${detail} sensor-vm declared type must be sensor, got ${declared_type:-missing}"
fi

if [[ "${runtime_looks_generic}" -eq 1 ]]; then
  fail "${detail} deprecated Ubuntu cloud-image runtime detected for sensor-vm; deploy Stellar Cyber Modular Data Sensor artifacts"
fi

if [[ -n "${state}" && "${state}" != "running" ]]; then
  fail "${detail} sensor domain defined but not running: ${state:-unknown}"
fi

if [[ "${sensor_capture_nic_present}" != "true" ]]; then
  fail "${detail} dedicated capture NIC missing; single-NIC mirror reuse is unsupported"
fi

if [[ "${sensor_capture_nic_has_ip}" == "true" ]]; then
  fail "${detail} capture NIC must not have an IP address"
fi

if [[ "${sensor_capture_nic_mirror_target}" != "true" ]]; then
  fail "${detail} capture NIC is not the OVS mirror output-port"
fi

if [[ "${sensor_network_separation_valid}" != "true" ]]; then
  fail "${detail} management/capture network separation is invalid"
fi

if [[ "${stellar_sensor_artifact_found}" != "true" ]]; then
  cat <<EOF
Missing required Stellar Sensor artifacts:
  ${script_path}
  ${image_path}
Remediation:
  sudo install -D -m 0755 <artifact>/virt_deploy_modular_ds.sh ${script_path}
  sudo install -D -m 0644 <artifact>/aella-modular-ds-<version>.qcow2 ${image_path}
EOF
  fail "${detail} Missing required Stellar Sensor artifacts: ${script_path}; ${image_path}"
fi

pass "${detail} sensor-vm declared type=${declared_type:-missing} and Stellar artifacts are present"
