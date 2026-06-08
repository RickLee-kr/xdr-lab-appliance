# DSP Lab Execution Runbook

**문서 버전:** 1.0.0 (Phase 17)  
**상태:** Operator runbook  
**대상:** Lab Operator, PoC Engineer, Customer Success Engineer

---

## 1. Environment Preparation

### 1.1 Software Prerequisites

```bash
cd detection-scenario-platform
python3 -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"

# Verify installation
dsp --version
dsp plugins list
pytest --co -q   # Expect 278 tests
```

### 1.2 Lab Topology (Minimum)

| Component | Requirement |
|-----------|-------------|
| DSP runner host | Python 3.11+; egress to lab `target_net` |
| Stellar Cyber | NDR sensor licensed; analytics processing enabled |
| Target network | `10.10.10.0/24` or documented lab CIDR |
| DNS resolver | Reachable for `dns_tunnel`, `dga` |
| Web server | HTTP/HTTPS for `http_followup`, `sql_injection` |
| Linux host | SSH port 22 for `ssh_failure` |
| Windows host | SMB port 445 for `smb_login_failure` |
| Domain Controller | LDAP 389/636, Kerberos 88 for AD scenarios |

### 1.3 Target Host Reference

| Host IP (example) | Role | Scenarios |
|-------------------|------|-----------|
| `10.10.10.10` | Domain Controller | `ldap_enumeration`, `kerberos_failure` |
| `10.10.10.20` | DNS resolver / Web server | `dns_tunnel`, `dga`, `http_followup`, `sql_injection` |
| `10.10.10.21` | Linux server | `ssh_failure`, `port_sweep` |
| `10.10.10.22`–`.24` | Additional hosts | `port_sweep` |
| `10.10.10.30` | Windows server | `smb_login_failure` |

Adjust IPs to match your lab configuration.

### 1.4 Run Configuration

```bash
export DSP_RUNS_DIR=/path/to/lab-evidence/runs
```

**Normal S3 validation does not require Stellar API tokens.** Use manual evidence workflow (default).

**Experimental HTTP API** (optional — see `detection-scenario-platform/docs/experimental/STELLAR_HTTP_API_MODE.md`):

```bash
export DSP_STELLAR_BASE_URL=https://stellar.lab.example
export DSP_STELLAR_API_TOKEN=<token>

# Optional Phase 12 tuning
export DSP_STELLAR_PAGE_SIZE=100
export DSP_STELLAR_REQUEST_DELAY_SECONDS=0.5
export DSP_STELLAR_MAX_REQUESTS_PER_RUN=200
```

---

## 2. Required Network Access

### 2.1 Firewall Rules (Runner → Targets)

| Protocol | Port | Scenarios |
|----------|------|-----------|
| UDP | 53 | `dns_tunnel`, `dga` |
| TCP | 22 | `ssh_failure`, `port_sweep` |
| TCP | 80, 443, 8080, 8000, 8443 | `http_followup`, `sql_injection` |
| TCP | 445, 139 | `smb_login_failure`, `port_sweep` |
| TCP | 389, 636 | `ldap_enumeration`, `port_sweep` |
| TCP/UDP | 88 | `kerberos_failure` |

### 2.2 Sensor Requirements

| Sensor | Required For | Verification |
|--------|--------------|--------------|
| NDR / Network sensor | All scenarios | Stellar → confirm runner IP in baseline |
| Traffic mirror / SPAN / TAP | DNS, HTTP, SSH, SMB | Runner-to-target path mirrored |
| Identity analytics | Auth scenarios | Auth failure correlation enabled |

**Pre-flight sensor check:**

1. Stellar → Analytics → confirm runner source IP appears in last 24h
2. Verify `target_net_enforced: true` — all targets within configured CIDR

### 2.3 Egress Path

DSP runner → targets must traverse monitored network segment. Traffic that bypasses NDR sensor will produce S2 success but S3_NOT_OBSERVED.

---

## 3. Stellar Permissions (Experimental HTTP Mode Only)

> **Skip this section** for normal manual S3 validation. Required only for `--stellar-client http`.

API token must have read access to:

| Endpoint | Evidence Type |
|----------|---------------|
| Alerts search | Alert evidence |
| Analytics / Incidents search | Analytics evidence |
| Entities search | Entity evidence |
| Timeline search | Timeline evidence (optional) |

**Verify permissions:**

```bash
# Manual S3 evidence (default — no API)
dsp run --scenarios dns_tunnel --confirm-detection

# Experimental live API connectivity
dsp run --scenarios dns_tunnel \
  --target-net 10.10.10.0/24 \
  --confirm-detection --detection-provider stellar --stellar-client http
```

Check `detection.log` for 401/403 errors (permission denied → S3_INCONCLUSIVE).

---

## 4. Execution Order

### 4.1 Pre-Run Checklist

- [ ] Record lab date, operator name, Stellar tenant version
- [ ] Confirm target hosts alive (`ping` or documented reachability)
- [ ] Note runner source IP (for entity correlation)
- [ ] Set `DSP_RUNS_DIR` to writable evidence directory
- [ ] Export Stellar env vars (if S3 demo)
- [ ] Clear or document existing Stellar alerts in test window

### 4.2 Single Scenario Run (Template)

```bash
export DSP_RUNS_DIR=/path/to/lab-evidence/runs

dsp run --scenarios <scenario_id> \
  --target-net 10.10.10.0/24 \
  --confirm-detection --stellar-client http
```

**Do NOT use `--dry-run` for live S3 validation.**

### 4.3 Recommended Scenario Sequence

Run scenarios in order with **≥5 min gap** between runs:

| Order | Scenario | Gap After |
|-------|----------|-----------|
| 1 | `dns_tunnel` | 5 min |
| 2 | `dga` | 5 min |
| 3 | `http_followup` | 5 min |
| 4 | `sql_injection` | 5 min |
| 5 | `ssh_failure` | 5 min |
| 6 | `smb_login_failure` | 5 min |
| 7 | `port_sweep` | 5 min |
| 8 | `ldap_enumeration` | 5 min |
| 9 | `kerberos_failure` | — |

**Rationale:** DNS scenarios first (isolated protocol), then web, then auth, then recon. Gaps prevent alert correlation confusion.

### 4.4 Full Battery Script

```bash
#!/bin/bash
set -euo pipefail

export DSP_RUNS_DIR=/path/to/lab-evidence/runs
export DSP_STELLAR_BASE_URL=https://stellar.lab.example
export DSP_STELLAR_API_TOKEN=<token>

SCENARIOS=(
  "dns_tunnel"
  "dga"
  "http_followup"
  "sql_injection"
  "ssh_failure"
  "smb_login_failure"
  "port_sweep"
  "ldap_enumeration"
  "kerberos_failure"
)

for scenario in "${SCENARIOS[@]}"; do
  echo "=== Running $scenario ==="
  dsp run --scenarios "$scenario" \
    --target-net 10.10.10.0/24 \
    --confirm-detection --stellar-client http
  
  if [ "$scenario" != "kerberos_failure" ]; then
    echo "Waiting 5 minutes..."
    sleep 300
  fi
done

echo "=== Full battery complete ==="
```

---

## 5. Evidence Collection Workflow

### 5.1 Per-Run Artifacts

After each run, collect from `~/.dsp/runs/<run_id>/` (or `$DSP_RUNS_DIR/<run_id>/`):

| Artifact | Purpose | Required |
|----------|---------|----------|
| `run.json` | Run metadata, timestamps | Yes |
| `validation.json` | S2 result | Yes |
| `detection.json` | S3 result | Yes (if confirm-detection) |
| `report.md` | Human-readable summary | Yes |
| `report.json` | Machine-readable bundle | Yes |
| `events.db` | Event Store (SOT) | Yes |
| `events.jsonl` | Event export | Recommended |
| `detection.log` | API call trace | Yes (if confirm-detection) |
| `evidence/<run_id>/stellar/raw/` | Stellar raw JSON | Yes (if confirm-detection) |

### 5.2 Archive Structure

```
lab-evidence/
├── 2026-06-06-demo/
│   ├── run-manifest.json          # List of run_ids with scenario mapping
│   ├── dns_tunnel_<run_id>/       # Archived run directory
│   ├── dga_<run_id>/
│   └── ...
└── poc-report/
    └── 2026-06-06-validation-summary.md
```

### 5.3 Run Manifest Template

```json
{
  "lab_date": "2026-06-06",
  "operator": "operator@example.com",
  "stellar_version": "6.x",
  "runner_ip": "10.10.10.5",
  "runs": [
    {
      "scenario_id": "dns_tunnel",
      "run_id": "20260606_abc123",
      "s2_decision": "success",
      "s3_status": "S3_CONFIRMED",
      "correlation_score": 0.85
    }
  ]
}
```

---

## 6. Post-Run Validation Workflow

### 6.1 Immediate Actions (within 5 min of run end)

1. **Verify S2:**
   ```bash
   cat $DSP_RUNS_DIR/<run_id>/validation.json | jq '.[].decision'
   # Expected: "success"
   ```

2. **Record timestamps:**
   ```bash
   cat $DSP_RUNS_DIR/<run_id>/run.json | jq '{run_id, started_at, ended_at}'
   ```

3. **Check S3 (if confirm-detection):**
   ```bash
   cat $DSP_RUNS_DIR/<run_id>/detection.json | jq '{status, correlation_score, reason}'
   ```

4. **Archive run directory**

### 6.2 Detection Latency Wait

| Scenario | Search Window | Recommended Wait |
|----------|---------------|------------------|
| `http_followup`, `sql_injection` | 15 min | 15 min after run end |
| All others | 30 min | 30 min after run end |

If S3_NOT_OBSERVED immediately after run, wait full search window before declaring failure.

### 6.3 Manual Stellar Validation (Optional)

For each run:

1. Stellar → Alerts / Incidents
2. Filter time: `[run_start - 2m, run_end + search_window]`
3. Filter entity: runner source IP
4. Compare with DSP `detection.json` S3 result

### 6.4 Re-validation (Offline)

Re-run validation without re-executing traffic:

```bash
dsp validate --run-id <run_id>
dsp report --run-id <run_id>
```

---

## 7. Recommended Customer Demo Flow

### 7.1 30-Minute Executive Demo

**Audience:** CISO, IT Director  
**Focus:** Business value, safe operation, evidence-based verification

| Time | Activity | Scenario |
|------|----------|----------|
| 0–5 min | DSP 소개, S1/S2/S3 모델 설명 | — |
| 5–10 min | DNS 탐지 데모 | `dns_tunnel` |
| 10–15 min | S2/S3 결과 리포트 제시 | report.md |
| 15–20 min | Identity 탐지 데모 | `ssh_failure` |
| 20–25 min | Stellar UI에서 알림 확인 | Manual |
| 25–30 min | Q&A, PoC 다음 단계 | — |

### 7.2 2-Hour Technical PoC

**Audience:** SOC Manager, Security Engineer  
**Focus:** Multi-scenario coverage, detection validation

1. Environment walkthrough (15 min)
2. DNS scenarios: `dns_tunnel`, `dga` (25 min)
3. Web scenarios: `http_followup`, `sql_injection` (25 min)
4. Auth scenario: `ssh_failure` (15 min)
5. Evidence review workshop (30 min)
6. PoC report delivery (10 min)

### 7.3 Full-Day Comprehensive Validation

**Audience:** PoC Engineer, Customer Success  
**Focus:** All 9 scenarios, complete evidence package

Follow Section 4.3 sequence. Deliver run manifest + individual reports + summary validation document.

### 7.4 Demo Talking Points

- **Safe operation:** "모든 시나리오는 safe mode — 실제 익스플로잇, 자격증명 탈취, 데이터 유출 없음"
- **Evidence-based:** "S2는 Event Store로 트래픽 증명, S3는 Stellar 탐지 독립 확인"
- **Auditable:** "모든 run은 run_id, timestamps, raw evidence로 재현 가능"
- **Non-disruptive:** "Runner exit code는 S2만 반영 — S3 실패가 PoC 중단을 유발하지 않음"

---

## 8. Troubleshooting Quick Reference

| Symptom | Check | Resolution |
|---------|-------|------------|
| All S2 fail | `--dry-run` flag? | Remove `--dry-run` for live |
| All S2 fail | Target unreachable | Verify network, ping targets |
| All S3_NOT_OBSERVED | Sensor gap | Verify NDR coverage of runner path |
| All S3_INCONCLUSIVE | API auth | Check `DSP_STELLAR_API_TOKEN`, `detection.log` |
| Single scenario S2 fail | Service not running | Verify target port open |
| LDAP S3_INCONCLUSIVE | Expected (MEDIUM confidence) | Manual Stellar review, retry |

---

## 9. Related Documents

| Document | Purpose |
|----------|---------|
| [CUSTOMER_DEMO_GUIDE.md](./CUSTOMER_DEMO_GUIDE.md) | Per-scenario demo guide |
| [DETECTION_PLAYBOOKS.md](./DETECTION_PLAYBOOKS.md) | Validation playbooks |
| [STELLAR_EXPECTED_EVIDENCE_GUIDE.md](./STELLAR_EXPECTED_EVIDENCE_GUIDE.md) | S3 evidence interpretation |
| [SCENARIO_SELECTION_MATRIX.md](./SCENARIO_SELECTION_MATRIX.md) | Scenario selection |
