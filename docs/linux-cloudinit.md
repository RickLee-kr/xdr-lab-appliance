# Linux cloud-init — victim-linux (Ubuntu 24.04)

`victim-linux` is provisioned from an Ubuntu 24.04 **cloud image** with a per-deploy
**seed ISO** (`user-data`, `meta-data`, `network-config`). Automation lives in
`scripts/xdr-lab-vm-manager.sh`.

---

## Best practice: no apt in cloud-init

**Do not** use `packages:`, `package_update`, `package_upgrade`, or heavy `runcmd`
in victim-linux `user-data`.

| Why | Detail |
| --- | --- |
| Deterministic deploy | First-boot `apt` races (lock, mirror, DNS) stall or break cloud-init |
| Reproducible snapshots | Disk state must not depend on transient mirror content |
| Faster SSH | Ubuntu cloud images already ship **openssh-server** |

Cloud-init on victim-linux is limited to:

- `hostname`
- `users` + `chpasswd` (labuser / lab1234)
- `ssh_pwauth` / `disable_root`
- operator `ssh_authorized_keys`
- static network via seed `network-config` (not in `#cloud-config`)

Runtime packages (e.g. **qemu-guest-agent**) are **baked into the base image** before
deploy, not installed on first boot.

---

## Golden base image preparation

After the Ubuntu cloud image is downloaded to
`/opt/xdr-lab/images/victim-linux/ubuntu-24.04-server-cloudimg-amd64.img`, the VM
manager runs `virt-customize` once (idempotent marker: `*.xdr-lab-baked`):

```bash
sudo apt-get install -y guestfs-tools   # provides virt-customize

sudo virt-customize -a /opt/xdr-lab/images/victim-linux/ubuntu-24.04-server-cloudimg-amd64.img \
  --install qemu-guest-agent \
  --run-command 'systemctl enable qemu-guest-agent'
```

Manual equivalent inside a prepared guest:

```bash
sudo apt install -y qemu-guest-agent
sudo systemctl enable qemu-guest-agent
```

Re-bake after replacing the base `.img` (delete `*.xdr-lab-baked` marker or redeploy
with a fresh download).

---

## Credential policy (victim)

| Field | Value |
| --- | --- |
| Username | `labuser` |
| Password | `lab1234` |
| SSH | password auth **and** operator `ssh_authorized_keys` |

Do **not** use `plain_text_passwd` on Ubuntu 24.04 cloud images. Use `chpasswd`:

```yaml
#cloud-config
hostname: victim-linux
ssh_pwauth: true
disable_root: true

users:
  - name: labuser
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    lock_passwd: false

chpasswd:
  list: |
    labuser:lab1234
  expire: false
```

Operator SSH public keys are embedded under `users[].ssh_authorized_keys`.

---

## Deploy verification (host)

After `virt-install`, the VM manager:

1. Optional **ping** to the materialized IP.
2. Waits until **tcp/22** is open (5 s interval, 300 s max).
3. Polls **password SSH** until `whoami` returns `labuser`.
4. **qemu-guest-agent**: best-effort warning only (not a deploy failure).
5. Optional remote cloud-init diagnostics (non-fatal if SSH diagnostics fail).
6. Optionally validates key-based SSH and reboot persistence (`XDR_LAB_SKIP_REBOOT_TEST=1` to skip reboot test).

Example manual check:

```bash
sshpass -p lab1234 ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 \
  labuser@10.10.10.20 'whoami'
```

---

## Redeploy / stale state

```bash
virsh destroy victim-linux || true
virsh undefine victim-linux --nvram || true
rm -f ${XDR_RUNTIME_DIR}/victim-linux/root.qcow2 \
      ${XDR_RUNTIME_DIR}/victim-linux/seed.iso
```

`XDR_LAB_VICTIM_LINUX_FORCE_REDEPLOY=1` destroys an existing domain and redeploys.

Each deploy uses a unique `instance-id` in `meta-data` so cloud-init treats the
instance as new when the disk overlay is recreated from the base image.

---

## Snapshot credential drift

Create baseline snapshots **only after** deploy verification (`whoami` == `labuser`).
Reverting an old snapshot can restore legacy user `lab` or stale passwords — see
legacy warnings in deploy output.

Remediation: redeploy with current minimal cloud-init, validate SSH, recreate snapshot.

---

## Host dependency: sshpass

```bash
sudo apt-get install -y sshpass
# or
sudo /opt/xdr-lab/installer/lab-host-victim-deps.sh
```

Re-install after source changes:

```bash
cd ~/xdr-lab-appliance
sudo XDR_LAB_OPERATOR_USER=aella ./installer/cli-installer.sh
```

---

## References

- `docs/access.md` — reverse NAT and operator SSH
- `docs/troubleshooting.md` — login failure triage
- `docs/specs/003-vm-image-policy/spec.md` — image cache layout
