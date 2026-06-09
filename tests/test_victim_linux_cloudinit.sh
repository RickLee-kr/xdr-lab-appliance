#!/usr/bin/env bash
# Static checks for victim-linux cloud-init credential policy (labuser / lab1234).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VM_MGR="${ROOT}/scripts/xdr-lab-vm-manager.sh"
CREATE_VM="${ROOT}/scripts/create-cloud-vm.sh"
LAB_VMS="${ROOT}/config/lab-vms.json"

echo "=== bash -n ==="
bash -n "$VM_MGR"
bash -n "$CREATE_VM"

if command -v shellcheck >/dev/null 2>&1; then
  echo "=== shellcheck (subset) ==="
  shellcheck -x "$CREATE_VM"
  shellcheck -x "$VM_MGR" -e SC2317 || true
fi

echo "=== python syntax ==="
python3 -m py_compile \
  "${ROOT}/scripts/caldera_orchestration.py" \
  "${ROOT}/scripts/vm_runtime_state.py"

echo "=== create-cloud-vm.sh policy ==="
grep -q 'name: labuser' "$CREATE_VM"
grep -q 'labuser:\${VICTIM_LINUX_PASSWORD}' "$CREATE_VM"
grep -q 'chpasswd:' "$CREATE_VM"
grep -q 'ssh_pwauth: true' "$CREATE_VM"
! grep -q 'plain_text_passwd' "$CREATE_VM"
! grep -qE 'name:[[:space:]]+lab[[:space:]]*$' "$CREATE_VM" || { echo "legacy name: lab in create-cloud-vm.sh"; exit 1; }

echo "=== xdr-lab-vm-manager.sh policy ==="
grep -q 'name: labuser' "$VM_MGR"
grep -q 'labuser:%s' "$VM_MGR"
grep -q 'linux_server_pre_snapshot_validate' "$VM_MGR"
grep -q 'validate_linux_server_password_ssh' "$VM_MGR"
grep -q 'validate_linux_server_deploy_ready' "$VM_MGR"
grep -q 'linux_server_prepare_victim_linux_base_image' "$VM_MGR"
grep -q 'linux_server_warn_guest_agent_optional' "$VM_MGR"
grep -q 'XDR_LAB_SSH_VALIDATION_TIMEOUT:=300' "$VM_MGR"
if awk '/^generate_user_data\(\)/,/^PY$/' "$VM_MGR" | grep -qE '^\s*"(packages:|runcmd:)'; then
  echo "packages/runcmd still present in generate_user_data"
  exit 1
fi
grep -q 'validate_victim_linux_ssh_connectivity' "$VM_MGR"
grep -q 'linux_server_require_sshpass' "$VM_MGR"
grep -q 'linux_server_emit_legacy_credential_warnings' "$VM_MGR"
grep -q "VICTIM_LINUX_SSH_PASSWORD_USER:=labuser" "$VM_MGR"
grep -q 'LINUX_SERVER_SSH_USER_CANDIDATES:-labuser}' "$VM_MGR"
! grep -qE 'LINUX_SERVER_SSH_USER_CANDIDATES.*ubuntu lab' "$VM_MGR" || { echo "legacy ubuntu lab candidates"; exit 1; }
if awk '/^generate_user_data\(\)/,/^}$/' "$VM_MGR" | grep -q 'plain_text_passwd'; then
  echo "plain_text_passwd still in generate_user_data"
  exit 1
fi

echo "=== lab-vms.json ==="
python3 - "$LAB_VMS" <<'PY'
import json, pathlib, sys
cfg = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
assert cfg["vms"]["victim-linux"]["ssh_user"] == "labuser"
assert cfg["vms"]["windows-victim"]["ssh_user"] == "labuser"
# sensor-vm must not define victim ssh_user override
print("ok lab-vms.json victim ssh_user=labuser")
PY

echo "=== sensor-vm cloud-init untouched ==="
grep -q 'name: lab' "${ROOT}/cloud-init/sensor-vm/user-data" || {
  echo "sensor-vm user-data changed unexpectedly"
  exit 1
}

echo "=== PASS ==="

if [[ "${XDR_LAB_VICTIM_LINUX_SMOKE_DEPLOY:-}" == "1" ]]; then
  echo "=== smoke deploy victim-linux ==="
  bash "$VM_MGR" deploy victim-linux --nodownload
fi
