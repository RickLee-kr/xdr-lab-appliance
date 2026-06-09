# Stellar Expected Evidence Guide

**문서 버전:** 1.0.0 (Phase 17)  
**상태:** Operator evidence reference  
**대상:** PoC Engineer, Customer Success Engineer, Lab Operator

---

## Purpose

이 문서는 DSP 시나리오 실행 후 Stellar Cyber에서 기대되는 증거 유형, S3 상태 해석, 그리고 증거 예시를 정의합니다.

**핵심 원칙:** S3 상관분석은 **알림 이름이 아닌** run_id, 시간 창, IP 엔티티, detection_model_id 기반입니다.

---

## Evidence Types

| Type | DSP Model | Stellar Source | Correlation Role |
|------|-----------|----------------|------------------|
| Alert | `AlertEvidence` | Alerts API | Primary detection signal |
| Analytics | `AnalyticsEvidence` | Analytics/Incidents API | Behavioral pattern confirmation |
| Entity | `EntityEvidence` | Entities API | IP/host/user/domain correlation |
| Timeline | `TimelineEvidence` | Timeline API | Narrative confirmation (optional) |

---

## S3 Status Interpretation

### S3_CONFIRMED

**Condition:** S2 success AND evidence_count > 0 AND correlation_score ≥ **0.70**

**Meaning:** Stellar이 DSP가 생성한 트래픽과 상관관계가 있는 탐지 증거를 반환했습니다. PoC 검증 **성공**.

**Typical reason string:**
```
correlation_score=0.85 meets confirmed threshold
```

**Operator action:** PoC 리포트에 validated로 기록. 고객에게 S2 + S3 양쪽 성공을 제시.

---

### S3_NOT_OBSERVED

**Condition:** evidence_count = 0 OR correlation_score < **0.40**

**Meaning:** Stellar API가 증거를 반환하지 않았거나, 반환된 증거가 run context와 상관관계가 없습니다.

**Typical reason strings:**
```
no vendor evidence returned
correlation_score=0.25 below not_observed threshold
```

**Operator action:**
1. Stellar sensor coverage 확인
2. Detection latency 대기 (최대 search window)
3. Source IP가 Stellar entity에 존재하는지 확인
4. 시나리오 파라미터 증가 후 재실행

**Important:** S3_NOT_OBSERVED는 S2 실패를 의미하지 **않습니다**. 트래픽은 생성되었으나 Stellar 탐지가 관측되지 않은 것입니다.

---

### S3_INCONCLUSIVE

**Condition:** S2 ≠ success OR (evidence present AND 0.40 ≤ score < 0.70)

**Meaning:** 부분 증거가 있으나 확정적 상관관계를 확립하지 못했습니다.

**Typical reason strings:**
```
correlation_score=0.55 below confirmed threshold
s2_decision=fail_fast; detection poll skipped
Stellar API error: timeout
partial evidence after pagination failure
```

**Operator action:**
1. `detection.log`에서 API 오류 확인
2. Stellar UI에서 수동 알림 검색
3. Time window 확장 후 재시도
4. Source/destination IP entity 매칭 확인

---

## Correlation Scoring Dimensions

| Dimension | Weight | Signal |
|-----------|--------|--------|
| `run_id` | 0.30 | Evidence `run_id` matches context |
| `time_window` | 0.25 | `observed_at` within search window |
| `source_ip` | 0.15 | Entity matches context source IP |
| `destination_ip` | 0.15 | Entity matches context destination IP |
| `scenario_type` | 0.15 | `detection_model_id` matches scenario |

**Aggregate score:** max(individual item scores) across evidence pack

---

## Per-Scenario Evidence Reference

### 1. DNS Tunnel (`dns_tunnel`)

| Evidence Type | Required | Expected Content |
|---------------|----------|------------------|
| Alert | **Yes** | DNS Tunnel, DNS Exfiltration families |
| Analytics | **Yes** | `dns_query_volume_anomaly`, `long_subdomain_pattern` |
| Entity | **Yes** | source IP, DNS server, `dns-tunnel.com` domain |
| Timeline | Optional | DNS query bursts |

**Search window:** 30 minutes  
**Confidence:** HIGH

**Evidence example (Alert):**
```json
{
  "evidence_id": "alert-12345",
  "alert_name": "DNS Exfiltration Alert",
  "severity": "high",
  "observed_at": "2026-06-06T10:15:00Z",
  "entity_refs": ["10.10.10.5", "dns-tunnel.com"],
  "attributes": {"detection_model_id": "stellar.dns_tunnel"}
}
```

**Evidence example (Analytics):**
```json
{
  "evidence_id": "incident-67890",
  "analytic_type": "long_subdomain_pattern",
  "summary": "Unusually long subdomain queries detected",
  "observed_at": "2026-06-06T10:14:30Z"
}
```

---

### 2. DGA (`dga`)

| Evidence Type | Required | Expected Content |
|---------------|----------|------------------|
| Alert | **Yes** | DGA, Domain Generation Algorithm |
| Analytics | **Yes** | `nxdomain_burst`, `dga_domain_entropy` |
| Entity | Optional | source IP, generated domains |
| Timeline | Optional | NXDOMAIN clusters |

**Search window:** 30 minutes  
**Confidence:** HIGH

**Evidence example (Analytics):**
```json
{
  "evidence_id": "incident-11111",
  "analytic_type": "nxdomain_burst",
  "summary": "500 NXDOMAIN responses from single source in 5 minutes",
  "observed_at": "2026-06-06T10:20:00Z"
}
```

---

### 3. HTTP Follow-up (`http_followup`)

| Evidence Type | Required | Expected Content |
|---------------|----------|------------------|
| Alert | **Yes** | HTTP Reconnaissance, Suspicious HTTP Activity |
| Analytics | **Yes** | `http_path_enumeration` |
| Entity | Optional | source IP, dest IP, URL paths |
| Timeline | Optional | Sequential HTTP GET/HEAD |

**Search window:** 15 minutes  
**Confidence:** HIGH

**Evidence example (Analytics):**
```json
{
  "evidence_id": "incident-22222",
  "analytic_type": "http_path_enumeration",
  "summary": "Multiple common paths accessed from single source",
  "observed_at": "2026-06-06T10:25:00Z"
}
```

---

### 4. SSH Login Failure (`ssh_failure`)

| Evidence Type | Required | Expected Content |
|---------------|----------|------------------|
| Alert | **Yes** | SSH Login Failure, Brute Force SSH |
| Analytics | **Yes** | `ssh_auth_failure_burst` |
| Entity | **Yes** | source IP, target host, username |
| Timeline | Optional | Repeated port 22 auth failures |

**Search window:** 30 minutes  
**Confidence:** HIGH

**Evidence example (Entity):**
```json
{
  "evidence_id": "entity-33333",
  "entity_type": "user",
  "entity_value": "admin",
  "role": "target_username"
}
```

---

### 5. SQL Injection (`sql_injection`)

| Evidence Type | Required | Expected Content |
|---------------|----------|------------------|
| Alert | **Yes** | SQL Injection, Web Attack SQLi |
| Analytics | **Yes** | `sqli_payload_detected` |
| Entity | Optional | source IP, dest IP, URL with payload |
| Timeline | Optional | HTTP requests with SQLi signatures |

**Search window:** 15 minutes  
**Confidence:** HIGH

**Evidence example (Analytics):**
```json
{
  "evidence_id": "incident-44444",
  "analytic_type": "sqli_payload_detected",
  "summary": "SQL injection pattern in HTTP GET parameter",
  "observed_at": "2026-06-06T10:30:00Z"
}
```

---

### 6. SMB Login Failure (`smb_login_failure`)

| Evidence Type | Required | Expected Content |
|---------------|----------|------------------|
| Alert | **Yes** | SMB Authentication Failure, SMB Bad Auth |
| Entity | **Yes** | source IP, Windows host, username |
| Analytics | Optional | `smb_auth_failure_burst` |
| Timeline | Optional | SMB auth failure events |

**Search window:** 30 minutes  
**Confidence:** HIGH

**Evidence example (Alert):**
```json
{
  "evidence_id": "alert-55555",
  "alert_name": "SMB Authentication Failure",
  "severity": "medium",
  "observed_at": "2026-06-06T10:35:00Z",
  "entity_refs": ["10.10.10.5", "10.10.10.30"],
  "attributes": {"detection_model_id": "stellar.smb_login_failure"}
}
```

---

### 7. Port Sweep (`port_sweep`)

| Evidence Type | Required | Expected Content |
|---------------|----------|------------------|
| Alert | **Yes** | Port Sweep, Horizontal Port Scan |
| Entity | **Yes** | scanner source IP, target hosts |
| Analytics | Optional | `port_scan_burst` |
| Timeline | Optional | Multi-port connection attempts |

**Search window:** 30 minutes  
**Confidence:** HIGH

**Evidence example (Analytics):**
```json
{
  "evidence_id": "incident-66666",
  "analytic_type": "port_scan_burst",
  "summary": "13 ports probed across 3 hosts from single source",
  "observed_at": "2026-06-06T10:40:00Z"
}
```

---

### 8. LDAP Enumeration (`ldap_enumeration`)

| Evidence Type | Required | Expected Content |
|---------------|----------|------------------|
| Alert | **Yes** | LDAP Enumeration, LDAP Anonymous Bind |
| Entity | **Yes** | source IP, domain controller |
| Analytics | Optional | `ldap_query_burst` |
| Timeline | Optional | LDAP bind/search attempts |

**Search window:** 30 minutes  
**Confidence:** **MEDIUM**

**Note:** LDAP scenarios have MEDIUM confidence due to longer Stellar processing and AD environment variability. `S3_INCONCLUSIVE` on first run is acceptable.

---

### 9. Kerberos Failure (`kerberos_failure`)

| Evidence Type | Required | Expected Content |
|---------------|----------|------------------|
| Alert | **Yes** | Kerberos Authentication Failure, Kerberos Anomaly |
| Entity | **Yes** | source IP, DC, username/realm |
| Analytics | Optional | `kerberos_auth_failure_burst` |
| Timeline | Optional | Pre-auth failure events |

**Search window:** 30 minutes  
**Confidence:** HIGH

---

## Evidence Pack Location

After `--confirm-detection` run:

```
~/.dsp/runs/<run_id>/
├── detection.json              # S3 result summary
├── detection.log               # API call log (no tokens)
└── evidence/<run_id>/stellar/
    └── raw/
        ├── alerts.json         # Sanitized Stellar alerts
        ├── analytics.json      # Sanitized analytics
        ├── entities.json       # Sanitized entities
        └── timeline.json       # Sanitized timeline
```

---

## Worked S3 Examples

### Example A — S3_CONFIRMED (dns_tunnel)

**Context:**
- run_id: `20260606_demo01`
- source_ip: `10.10.10.5`
- destination_ip: `10.10.10.53`
- time window: run start − 2 min → run end + 30 min

**Evidence scoring:**
- run_id match → +0.30
- observed_at in window → +0.25
- entity_refs includes `10.10.10.5` → +0.15
- detection_model_id `stellar.dns_tunnel` → +0.15

**Score: 0.85 → S3_CONFIRMED**

Alert name `"DNS Exfiltration Alert v3"` is irrelevant to scoring.

---

### Example B — S3_NOT_OBSERVED

**Context:** Valid S2 success, Stellar returns zero items.

**Evidence pack:** evidence_count = 0

**Status:** S3_NOT_OBSERVED  
**Reason:** `no vendor evidence returned`

**Operator action:** Check sensor coverage, wait for detection latency, retry.

---

### Example C — S3_INCONCLUSIVE (wrong time window)

**Context:**
- run_id matches (+0.30)
- source_ip matches via entity (+0.15)
- observed_at **outside** time window (no +0.25)

**Score:** 0.45

**Status:** S3_INCONCLUSIVE (0.40 ≤ 0.45 < 0.70)

**Operator action:** Widen time window or wait for delayed Stellar processing.

---

### Example D — S3_INCONCLUSIVE (S2 failure)

**Context:** S2 decision = `fail_fast`

**Status:** S3_INCONCLUSIVE regardless of vendor evidence  
**Reason:** `s2_decision=fail_fast; detection poll skipped`

**Operator action:** Fix S2 failure first; S3 is not meaningful without S2 success.

---

### Example E — Alert name match would mislead

Two alerts in search window:

| Alert Name | source_ip ref | run_id | Score |
|------------|---------------|--------|-------|
| "DNS Tunnel Detected" | unrelated IP | different run | 0.25 |
| "Generic Anomaly" | `10.10.10.5` | matching run | 0.85 |

Evidence-based scoring selects the second alert. Name-based selection would pick the wrong one.

---

## Fallback Strategies (from contracts)

When primary query dimensions are missing, DSP applies contract-defined fallbacks:

| Scenario | Missing Field | Fallback |
|----------|---------------|----------|
| `dns_tunnel` | source_ip | Widen time window + entity-only |
| `dns_tunnel` | hostname | Protocol + time only |
| `dns_tunnel` | empty alerts | Rely on analytics + entities |
| `dga` | source_ip | Widen time window |
| `dga` | empty alerts | Rely on analytics only |
| `ssh_failure` | username | IP pair + auth failure analytics |
| `sql_injection` | empty alerts | Rely on analytics with payload match |
| `ldap_enumeration` | empty analytics | Rely on alerts + entities |

---

## Environment Variables for Live Stellar

```bash
export DSP_STELLAR_BASE_URL=https://stellar.lab.example
export DSP_STELLAR_API_TOKEN=<token>

# Optional tuning (Phase 12)
export DSP_STELLAR_PAGE_SIZE=100
export DSP_STELLAR_REQUEST_DELAY_SECONDS=0.5
export DSP_STELLAR_MAX_REQUESTS_PER_RUN=200
export DSP_STELLAR_MAX_RETRIES=2
```

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [SCENARIO_CATALOG.md](./SCENARIO_CATALOG.md) | Scenario specifications |
| [DETECTION_PLAYBOOKS.md](./DETECTION_PLAYBOOKS.md) | Validation procedures |
| `detection-scenario-platform/docs/detection/STELLAR_CORRELATION_RULES.md` | Technical correlation spec |
