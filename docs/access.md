# Operator access — XDR Lab

Canonical reverse-NAT contract for the three core VMs. Host `iptables` (Golden
Image) and `config/lab-vms.json` must agree.

| VM | Internal IP | Service | External (host) → guest |
| --- | --- | --- | --- |
| `sensor-vm` | `10.10.10.10` | SSH | TCP **1022** → 22 |
| `victim-linux` | `10.10.10.20` | SSH | TCP **2022** → 22 |
| `windows-victim` | `10.10.10.30` | RDP | TCP **3389** → 3389 |

Print the live summary:

```bash
bash scripts/xdr-lab-vm-manager.sh access
```

---

## Victim credentials (standard)

Operators only need one mnemonic for attack targets:

| VM | Username | Password |
| --- | --- | --- |
| `victim-linux` | `labuser` | `lab1234` |
| `windows-victim` | `labuser` | `lab1234` |

### victim-linux (SSH)

Internal lab network:

```bash
ssh labuser@10.10.10.20
# password: lab1234
```

Via reverse NAT (replace `<EXT>` with appliance routable IP):

```bash
ssh -p 2022 labuser@<EXT>
# password: lab1234
```

Key-based access (deploy embeds operator public keys):

```bash
ssh -i ~/.ssh/id_ed25519 labuser@10.10.10.20
```

### windows-victim (RDP)

```text
<EXT>:3389
Username: labuser
Password: lab1234
```

OpenSSH on the golden image (when enabled) uses the same **labuser** account;
see `XDR_LAB_WINDOWS_SSH_USER` and `lab-vms.json` → `ssh_user`.

---

## sensor-vm (intentionally unmanaged)

Stellar Cyber Modular Data Sensor credentials are **vendor-defined**. XDR Lab
does **not** remap sensor accounts for “consistency” with victim VMs — the
sensor is observer-only (mirror/capture) and already stable under its own
contract.

Typical external SSH (vendor user — consult Stellar documentation):

```bash
ssh -p 1022 sensor@<EXT>
```

---

## Validation (read-only)

```bash
bash scripts/xdr-lab-vm-manager.sh nat verify --iptables-only
bash scripts/xdr-lab-vm-manager.sh web-console verify windows-victim
```

Deploy-time victim-linux checks (password SSH, cloud-init logs) run
automatically inside `deploy victim-linux`; see `docs/linux-cloudinit.md`.
