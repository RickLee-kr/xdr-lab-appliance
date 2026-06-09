# Scenarios — CALDERA and lab automation

Scenario orchestration uses `scripts/caldera_orchestration.py` and
`config/caldera-lab.json`. VM lifecycle (deploy, snapshot, NAT) stays in
`scripts/xdr-lab-vm-manager.sh`.

---

## Victim credentials in scenarios

Attack-target VMs share one operator mnemonic:

| VM | SSH / access user | Password |
| --- | --- | --- |
| `victim-linux` | `labuser` | `lab1234` |
| `windows-victim` | `labuser` (OpenSSH when enabled) | `lab1234` |

Configure overrides in `config/caldera-lab.json`:

```json
"agents": {
  "victim-linux": { "ssh_user": "labuser" },
  "windows-victim": { "ssh_user": "labuser" }
}
```

Environment overrides:

- `VICTIM_LINUX_SSH_USER` / `VICTIM_LINUX_SSH_PASSWORD_USER`
- `VICTIM_LINUX_PASSWORD`
- `XDR_LAB_WINDOWS_SSH_USER`

`sensor-vm` remains **`ssh_user: ubuntu`** (or vendor default) in CALDERA config —
do not change sensor credentials for victim consistency.

---

## Deterministic snapshot workflow

Recommended sequence for repeatable adversary emulation:

```bash
# 1. Deploy and let automation validate password SSH (whoami == labuser)
aella_cli lab deploy victim-linux

# 2. Create snapshot only after validation (blocked if login fails)
aella_cli lab snapshot create pre-attack

# 3. Run scenario …

# 4. Revert and confirm login still works
aella_cli lab snapshot revert pre-attack
```

`snapshot create` for `victim-linux` runs **pre-snapshot credential validation**
(SSH, `whoami`, sudo, hostname, IP). Failed validation **blocks** snapshot
creation.

`snapshot revert` for `victim-linux` runs a **post-revert password SSH** check.
Legacy snapshots that still contain user `lab` trigger warnings — redeploy and
recreate the baseline snapshot.

---

## Atomic / ART validation

```bash
aella_cli lab scenario atomic validate
```

Linux paths SSH as `labuser` to `victim-linux` (`10.10.10.20`). Windows paths
use `labuser` when OpenSSH is reachable. See `docs/caldera-integration.md` for
HTTP/API and Sandcat details.

---

## Related docs

- `docs/access.md` — ports and SSH/RDP examples
- `docs/linux-cloudinit.md` — cloud-init and deploy verification
- `docs/troubleshooting.md` — login and snapshot drift triage
