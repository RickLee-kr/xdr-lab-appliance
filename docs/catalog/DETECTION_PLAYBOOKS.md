# DSP Detection Playbooks

**문서 버전:** 1.0.0 (Phase 17)  
**상태:** Operator validation playbooks  
**S3 default (Phase 18):** Manual operator evidence — `--confirm-detection` (no API token).  
Experimental HTTP: `--stellar-client http` — see `detection-scenario-platform/docs/experimental/STELLAR_HTTP_API_MODE.md`.

---

## Playbook Structure

각 플레이북은 다음 섹션으로 구성됩니다:

1. **Run Procedure** — 시나리오 실행 절차
2. **Validation Procedure** — S2/S3 검증 절차
3. **Evidence Collection** — 증거 수집 및 보관
4. **Expected Alerts** — Stellar에서 기대하는 알림
5. **Troubleshooting** — 일반적인 문제 해결

---

## Playbook 1: DNS Tunnel

### Run Procedure

**Pre-flight:**

- [ ] DNS 리졸버 또는 대상 DNS 서버 reachable (`10.10.10.20` 등)
- [ ] NDR sensor가 UDP/53 트래픽을 모니터링 중
- [ ] Runner source IP 기록
- [ ] `target_net` CIDR 확인 (`10.10.10.0/24`)

**Execute:**

```bash
cd detection-scenario-platform
source .venv/bin/activate
export DSP_RUNS_DIR=/path/to/lab-evidence/runs

dsp run --scenarios dns_tunnel \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

**Post-run:**

- [ ] `run.json`에서 `run_id`, `started_at`, `ended_at` 기록
- [ ] `validation.json` → `decision: success` 확인

### Validation Procedure

**S2 (Traffic Validated):**

1. Open `validation.json`
2. Confirm `decision == "success"`
3. Verify metrics:
   - `dns_tunnel_chunk_created_count >= 1`
   - `dns_tunnel_query_sent_count >= 1`

**S3 (Detection Confirmed):**

1. Open `detection.json` (if `--confirm-detection` used)
2. Check `status`:
   - `S3_CONFIRMED` → detection validated
   - `S3_INCONCLUSIVE` → partial evidence, manual review
   - `S3_NOT_OBSERVED` → no Stellar evidence
3. Review `correlation_score` and `reason`

**Manual Stellar validation (optional):**

1. Stellar → Alerts
2. Time filter: `[run_start - 2m, run_end + 30m]`
3. Search entity: runner source IP
4. Look for DNS Tunnel / DNS Exfiltration alerts

### Evidence Collection

| Artifact | Location |
|----------|----------|
| Event Store | `<run_dir>/events.db` |
| Validation | `<run_dir>/validation.json` |
| S3 result | `<run_dir>/detection.json` |
| Stellar raw | `<run_dir>/evidence/<run_id>/stellar/raw/` |
| Detection log | `<run_dir>/detection.log` |
| Report | `<run_dir>/report.md` |

Archive entire run directory after validation.

### Expected Alerts

| Alert Family | Analytics | Entity Types |
|--------------|-----------|--------------|
| DNS Tunnel | `dns_query_volume_anomaly` | ip, host, domain |
| DNS Exfiltration | `long_subdomain_pattern` | ip, host, domain |

### Troubleshooting

| Symptom | Likely Cause | Resolution |
|---------|--------------|------------|
| S2 fail: `SOT_EMPTY_AFTER_EXECUTE` | Network blocked or dry-run | Confirm `--dry-run` not set; check UDP/53 egress |
| S2 success, S3_NOT_OBSERVED | Stellar sensor gap or latency | Wait 30 min; verify NDR sees UDP/53 from source IP |
| S3_INCONCLUSIVE | Time window mismatch | Widen search; confirm source IP in Stellar entities |
| Low query count | `max_chunks` too low | Increase to 100+ in scenario_params |
| DNS resolver unreachable | Wrong target | Set explicit `hosts` in scenario_params |

---

## Playbook 2: DGA

### Run Procedure

**Pre-flight:**

- [ ] DNS resolver reachable and forwards `xdr.ooo` queries
- [ ] NDR sensor monitors DNS traffic
- [ ] Lab DNS allows NXDOMAIN responses for `*.xdr.ooo`

**Execute:**

```bash
dsp run --scenarios dga \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Validation Procedure

**S2:**

- `dga_domain_generated_count >= 1`
- `dga_nxdomain_observed_count >= 1`
- `dga_resolved_observed_count >= 1`

**S3:**

- Expected analytics: `nxdomain_burst`, `dga_domain_entropy`
- Correlation on source IP + time window (30 min)

**Manual Stellar validation:**

1. Stellar → Analytics → filter `nxdomain_burst`
2. Entity: source IP
3. Time: run window + 30 min

### Evidence Collection

Same as DNS Tunnel playbook. Additionally export:

- `events.jsonl` filtered for `dga_domain_generated` events
- Sample generated domain names from report

### Expected Alerts

| Alert Family | Analytics | Entity Types |
|--------------|-----------|--------------|
| DGA | `nxdomain_burst` | ip, domain |
| Domain Generation Algorithm | `dga_domain_entropy` | ip, domain |

### Troubleshooting

| Symptom | Likely Cause | Resolution |
|---------|--------------|------------|
| `dga_nxdomain_observed_count == 0` | Resolver returns SERVFAIL instead of NXDOMAIN | Use lab resolver that returns proper NXDOMAIN |
| S3_NOT_OBSERVED | Phase 1 count too low | Increase `phase1_count` to 500 |
| S3_INCONCLUSIVE | Background NXDOMAIN noise | Run during low-traffic window; note source IP |
| Phase 2 failures | `live.xdr.ooo` not configured | Phase 2 optional for S2; configure DNS A record if needed |

---

## Playbook 3: Authentication Failures

Covers: **SSH Login Failure** (`ssh_failure`), **SMB Login Failure** (`smb_login_failure`), **Kerberos Failure** (`kerberos_failure`)

### Run Procedure

**Pre-flight:**

- [ ] Target hosts running expected services (SSH:22, SMB:445, Kerberos:88)
- [ ] Identity analytics enabled in Stellar (recommended)
- [ ] Windows DC reachable for SMB/Kerberos scenarios
- [ ] Linux host reachable for SSH scenario

**Execute SSH:**

```bash
dsp run --scenarios ssh_failure \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

**Execute SMB:**

```bash
dsp run --scenarios smb_login_failure \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

**Execute Kerberos:**

```bash
dsp run --scenarios kerberos_failure \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

**Timing:** Run each auth scenario with ≥5 min gap to avoid alert correlation confusion.

### Validation Procedure

**S2 per scenario:**

| Scenario | Required Metrics |
|----------|------------------|
| `ssh_failure` | `ssh_auth_attempt_count >= 1`, `ssh_auth_failed_count >= 1` |
| `smb_login_failure` | `smb_auth_attempt_count >= 1`, `smb_auth_failed_count >= 1` |
| `kerberos_failure` | `kerberos_auth_attempt_count >= 1`, `kerberos_auth_failed_count >= 1` |

**S3:**

| Scenario | Required Evidence | Confidence |
|----------|-------------------|------------|
| `ssh_failure` | alert + analytics + entity | HIGH |
| `smb_login_failure` | alert + entity | HIGH |
| `kerberos_failure` | alert + entity | HIGH |

**Manual Stellar validation:**

1. Stellar → Alerts → filter by protocol (SSH/SMB/Kerberos)
2. Entity: source IP + destination IP + username
3. Analytics: `*_auth_failure_burst`

### Evidence Collection

| Scenario | Key Events |
|----------|------------|
| SSH | `ssh_auth_attempt`, `ssh_auth_failed` |
| SMB | `smb_auth_attempt`, `smb_auth_failed` |
| Kerberos | `kerberos_auth_attempt`, `kerberos_auth_failed` |

Export sample events from `events.jsonl` showing auth failure status codes.

### Expected Alerts

| Scenario | Alert Families | Analytics |
|----------|----------------|-----------|
| SSH | SSH Login Failure, Brute Force SSH | `ssh_auth_failure_burst` |
| SMB | SMB Authentication Failure, SMB Bad Auth | `smb_auth_failure_burst` |
| Kerberos | Kerberos Authentication Failure, Kerberos Anomaly | `kerberos_auth_failure_burst` |

### Troubleshooting

| Symptom | Likely Cause | Resolution |
|---------|--------------|------------|
| S2 fail: no auth_failed events | Target not running service | Verify port open: `nc -zv <host> <port>` |
| SSH: connection refused | SSH not on port 22 | Confirm target IP and SSH daemon running |
| SMB: timeout | Firewall blocking 445 | Allow TCP/445 from runner to target |
| Kerberos: realm mismatch | Wrong realm configured | Set `realm` to match lab AD domain |
| S3_NOT_OBSERVED | Identity analytics disabled | Enable identity module in Stellar |
| S3_INCONCLUSIVE | Low attempt count | Increase `max_total` or `attempts_per_host` |
| All auth: S2 success but no Stellar alert | Sensor not on auth path | Verify traffic traverses monitored segment |

---

## Playbook 4: Reconnaissance

Covers: **HTTP Follow-up** (`http_followup`), **Port Sweep** (`port_sweep`), **LDAP Enumeration** (`ldap_enumeration`)

### Run Procedure

**Pre-flight:**

- [ ] Web server reachable for HTTP Follow-up (ports 80/443)
- [ ] Multiple internal hosts reachable for Port Sweep
- [ ] Domain Controller reachable for LDAP (ports 389/636)
- [ ] NDR sensor covers runner-to-target path

**Execute HTTP Follow-up:**

```bash
dsp run --scenarios http_followup \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

**Execute Port Sweep:**

```bash
dsp run --scenarios port_sweep \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

**Execute LDAP Enumeration:**

```bash
dsp run --scenarios ldap_enumeration \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Validation Procedure

**S2 per scenario:**

| Scenario | Required Metrics |
|----------|------------------|
| `http_followup` | `http_request_sent_count >= 1` |
| `port_sweep` | `port_probe_count >= 1`, `port_connection_attempt_count >= 1` |
| `ldap_enumeration` | `ldap_connection_attempt_count >= 1`, `ldap_bind_or_search_attempt_count >= 1` |

**S3:**

| Scenario | Required Evidence | Confidence |
|----------|-------------------|------------|
| `http_followup` | alert + analytics | HIGH |
| `port_sweep` | alert + entity | HIGH |
| `ldap_enumeration` | alert + entity | MEDIUM |

### Evidence Collection

| Scenario | Key Events | Stellar Focus |
|----------|------------|---------------|
| HTTP | `http_request_sent`, `http_response_received` | URL paths, source/dest IP |
| Port Sweep | `port_probe_sent`, `port_connection_opened/failed` | Multi-port, multi-host pattern |
| LDAP | `ldap_bind_attempt`, `ldap_search_attempt` | DC IP, bind failures |

### Expected Alerts

| Scenario | Alert Families | Analytics |
|----------|----------------|-----------|
| HTTP Follow-up | HTTP Reconnaissance, Suspicious HTTP Activity | `http_path_enumeration` |
| Port Sweep | Port Sweep, Horizontal Port Scan | `port_scan_burst` |
| LDAP Enumeration | LDAP Enumeration, LDAP Anonymous Bind | `ldap_query_burst` |

### Troubleshooting

| Symptom | Likely Cause | Resolution |
|---------|--------------|------------|
| HTTP: no requests sent | Web server down or wrong port | Test: `curl -I http://10.10.10.20` |
| Port Sweep: low probe count | Hosts unreachable | Verify targets alive with ping |
| Port Sweep: S3_NOT_OBSERVED | Scan below detection threshold | Increase host count or port list |
| LDAP: connection refused | DC not on 389/636 | Verify DC IP and LDAP service |
| LDAP: S3_INCONCLUSIVE | MEDIUM confidence scenario | Allow extra 30 min; manual Stellar review |
| All recon: alerts from other runs | Insufficient gap between scenarios | Wait 5+ min between runs; filter by run_id time |

---

## Playbook 5: SQL Injection

### Run Procedure

**Pre-flight:**

- [ ] Web server with HTTP/HTTPS reachable
- [ ] WAF or NDR monitoring HTTP traffic (if applicable)
- [ ] No production database on target (lab web server only)

**Execute:**

```bash
dsp run --scenarios sql_injection \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Validation Procedure

**S2:**

- `sql_payload_generated_count >= 1`
- `sql_request_sent_count >= 1`

**S3:**

- Required: alert + analytics
- Expected analytics: `sqli_payload_detected`
- Search window: 15 minutes

**Manual Stellar validation:**

1. Stellar → Alerts → Web Attack / SQL Injection
2. Filter source IP = runner IP
3. Check analytics for payload signature match

### Evidence Collection

| Artifact | Focus |
|----------|-------|
| `events.jsonl` | `sql_payload_generated`, `sql_request_sent` events |
| Stellar raw analytics | `sqli_payload_detected` records |
| Report sample events | Payload strings (sanitized) |

### Expected Alerts

| Alert Family | Analytics | Entity Types |
|--------------|-----------|--------------|
| SQL Injection | `sqli_payload_detected` | ip, host, url |
| Web Attack SQLi | `sqli_payload_detected` | ip, host, url |

### Troubleshooting

| Symptom | Likely Cause | Resolution |
|---------|--------------|------------|
| S2 fail: no payloads | Web server unreachable | Test HTTP connectivity first |
| S3_NOT_OBSERVED | WAF blocking before NDR | Check if WAF logs show blocked requests; adjust target |
| S3_INCONCLUSIVE | Payload below detection threshold | Increase `max_total` to 20 |
| Alert but wrong URL | Background SQLi noise | Filter by run time window and source IP |
| WAF blocks all requests | Strict WAF rules | Use internal lab web server without WAF for baseline |

---

## Cross-Playbook: S3 Status Interpretation

| Status | Meaning | Operator Action |
|--------|---------|-----------------|
| `S3_CONFIRMED` | Stellar evidence correlates (score ≥ 0.70) | Document as validated; include in PoC report |
| `S3_INCONCLUSIVE` | Partial evidence (0.40–0.69) or S2 failure | Manual Stellar review; retry with adjusted params |
| `S3_NOT_OBSERVED` | No evidence (score < 0.40) | Check sensor coverage; verify Stellar config |

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [SCENARIO_CATALOG.md](./SCENARIO_CATALOG.md) | Scenario specifications |
| [STELLAR_EXPECTED_EVIDENCE_GUIDE.md](./STELLAR_EXPECTED_EVIDENCE_GUIDE.md) | Evidence details |
| [LAB_EXECUTION_RUNBOOK.md](./LAB_EXECUTION_RUNBOOK.md) | Full lab workflow |
