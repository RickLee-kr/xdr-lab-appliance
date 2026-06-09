# DSP Scenario Selection Matrix

**문서 버전:** 1.0.0 (Phase 17)  
**상태:** Operator guidance  
**대상:** Sales Engineer, PoC Engineer, Customer Success Engineer

---

## How to Use This Matrix

1. 고객의 **검증 목표**를 확인합니다.
2. 아래 매트릭스에서 **권장 시나리오**를 선택합니다.
3. 필요 시 **보조 시나리오**를 추가하여 커버리지를 확장합니다.
4. [CUSTOMER_DEMO_GUIDE.md](./CUSTOMER_DEMO_GUIDE.md)에서 실행 명령을 참조합니다.

---

## Primary Selection Matrix

| Customer Goal | Primary Scenario | Secondary Scenario | Detection Signal |
|---------------|------------------|--------------------|------------------|
| DNS Detection Validation | `dns_tunnel` | `dga` | NDR, DNS analytics |
| DNS Exfiltration Validation | `dns_tunnel` | — | DNS Tunnel, long subdomain |
| DGA / Botnet C2 Validation | `dga` | `dns_tunnel` | NXDOMAIN burst, entropy |
| Identity Monitoring — Linux | `ssh_failure` | — | SSH auth failure burst |
| Identity Monitoring — Windows | `smb_login_failure` | `kerberos_failure` | SMB/Kerberos auth failure |
| Active Directory Security | `ldap_enumeration` | `kerberos_failure` | LDAP enum, Kerberos failure |
| Kerberos / AD Auth Validation | `kerberos_failure` | `smb_login_failure` | Kerberos pre-auth failure |
| Recon Validation — Network | `port_sweep` | — | Horizontal port scan |
| Recon Validation — Web | `http_followup` | — | HTTP path enumeration |
| Recon Validation — Directory | `ldap_enumeration` | `port_sweep` | LDAP bind/search burst |
| Web Threat Validation | `sql_injection` | `http_followup` | SQLi payload, web attack |
| WAF Validation | `sql_injection` | — | SQLi payload detection |
| NDR Baseline Coverage | `dns_tunnel`, `port_sweep` | `http_followup` | Multi-protocol NDR |
| SIEM Use Case Validation | `ssh_failure`, `sql_injection` | `dga` | Auth + web + DNS events |
| Full Platform PoC | All 9 scenarios | — | Complete detection coverage |

---

## By Detection Domain

### DNS / Network Exfiltration

| Goal | Scenario | Why |
|------|----------|-----|
| DNS tunneling detection | `dns_tunnel` | idx-pattern FQDN, high-volume UDP/53 |
| DGA / C2 domain detection | `dga` | NXDOMAIN burst + entropy analytics |
| Combined DNS coverage | `dns_tunnel` + `dga` | Tunnel + algorithmic domain patterns |

### Identity / Authentication

| Goal | Scenario | Why |
|------|----------|-----|
| Linux SSH brute force detection | `ssh_failure` | Repeated SSH auth failures |
| Windows SMB bad auth | `smb_login_failure` | SMB authentication failure burst |
| Kerberos / AD authentication | `kerberos_failure` | Pre-auth failure on port 88 |
| Full identity coverage | `ssh_failure` + `smb_login_failure` + `kerberos_failure` | Multi-OS auth failure |

### Reconnaissance / Discovery

| Goal | Scenario | Why |
|------|----------|-----|
| Internal port scanning | `port_sweep` | 13-port horizontal sweep |
| Web path enumeration | `http_followup` | Fixed-path HTTP recon |
| LDAP / AD enumeration | `ldap_enumeration` | Bind/search discovery |
| Full recon coverage | `port_sweep` + `http_followup` + `ldap_enumeration` | Network + web + directory |

### Web / Application Security

| Goal | Scenario | Why |
|------|----------|-----|
| SQL injection detection | `sql_injection` | Safe SQLi payload patterns |
| Web reconnaissance | `http_followup` | HTTP path enumeration |
| Combined web coverage | `sql_injection` + `http_followup` | Attack + recon patterns |

---

## By Customer Environment

### Linux-Only Lab

| Priority | Scenario | Target Requirement |
|----------|----------|-------------------|
| P0 | `dns_tunnel`, `dga` | DNS resolver |
| P0 | `ssh_failure` | Linux host port 22 |
| P1 | `http_followup`, `sql_injection` | Web server |
| P1 | `port_sweep` | Multiple alive hosts |

### Windows / Active Directory Lab

| Priority | Scenario | Target Requirement |
|----------|----------|-------------------|
| P0 | `smb_login_failure` | Windows host port 445 |
| P0 | `kerberos_failure` | Domain Controller port 88 |
| P0 | `ldap_enumeration` | Domain Controller port 389 |
| P1 | `port_sweep` | Multiple Windows hosts |

### Mixed Environment (Recommended)

| Priority | Scenario | Notes |
|----------|----------|-------|
| P0 | All DNS scenarios | Universal NDR validation |
| P0 | `ssh_failure` + `smb_login_failure` | Cross-OS identity |
| P1 | `http_followup` + `sql_injection` | Web layer |
| P1 | `port_sweep` + `ldap_enumeration` | Recon layer |
| P2 | `kerberos_failure` | Requires AD DC |

---

## By PoC Duration

### 30-Minute Quick Demo

Focus on high-confidence, fast-detection scenarios:

1. `dns_tunnel` (5 min)
2. `ssh_failure` (5 min)
3. `sql_injection` (5 min)

### 2-Hour Standard PoC

1. `dns_tunnel`
2. `dga`
3. `http_followup`
4. `ssh_failure`
5. `sql_injection`

### Full-Day Comprehensive PoC

All 9 scenarios in recommended sequence (see [LAB_EXECUTION_RUNBOOK.md](./LAB_EXECUTION_RUNBOOK.md)).

---

## By Stellar Module

| Stellar Module | Scenarios | Expected Evidence |
|----------------|-----------|-------------------|
| NDR / Network Analytics | `dns_tunnel`, `dga`, `port_sweep`, `http_followup` | Network alerts, flow analytics |
| Identity Analytics | `ssh_failure`, `smb_login_failure`, `kerberos_failure` | Auth failure alerts, user entities |
| Web / Application | `http_followup`, `sql_injection` | Web attack alerts, URL entities |
| Directory / AD | `ldap_enumeration`, `kerberos_failure` | LDAP/Kerberos alerts |

---

## Scenario Difficulty & Confidence

| Scenario | Implementation Difficulty | S3 Confidence | Notes |
|----------|--------------------------|---------------|-------|
| `dns_tunnel` | Medium | HIGH | Requires DNS path monitoring |
| `dga` | Medium | HIGH | Requires resolver NXDOMAIN |
| `http_followup` | Low | HIGH | Requires web server |
| `ssh_failure` | Low | HIGH | Requires SSH daemon |
| `sql_injection` | Low | HIGH | May need WAF bypass consideration |
| `smb_login_failure` | Medium | HIGH | Requires Windows host |
| `port_sweep` | Low | HIGH | Requires multiple alive hosts |
| `ldap_enumeration` | Medium | **MEDIUM** | Requires DC; longer detection latency |
| `kerberos_failure` | Medium | HIGH | Requires AD DC with Kerberos |

---

## Anti-Patterns — Scenarios NOT to Combine

| Combination | Reason |
|-------------|--------|
| `dns_tunnel` + `dga` (same run) | DNS alert correlation confusion |
| Multiple auth scenarios (same minute) | Auth failure alert merging |
| `port_sweep` + `ldap_enumeration` (same target) | Port noise may mask LDAP signal |

**Rule:** Separate runs by ≥5 minutes. Use distinct `run_id` for each scenario.

---

## Decision Flowchart

```
Customer Goal?
│
├─ DNS Detection?
│   ├─ Tunnel/Exfil → dns_tunnel
│   └─ DGA/C2 → dga
│
├─ Identity/Auth?
│   ├─ Linux → ssh_failure
│   ├─ Windows SMB → smb_login_failure
│   └─ AD/Kerberos → kerberos_failure
│
├─ Reconnaissance?
│   ├─ Network scan → port_sweep
│   ├─ Web paths → http_followup
│   └─ AD enum → ldap_enumeration
│
├─ Web Threat?
│   ├─ SQLi → sql_injection
│   └─ Recon → http_followup
│
└─ Full PoC → All 9 scenarios (sequential)
```

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [SCENARIO_CATALOG.md](./SCENARIO_CATALOG.md) | Full scenario specifications |
| [CUSTOMER_DEMO_GUIDE.md](./CUSTOMER_DEMO_GUIDE.md) | Demo execution guide |
| [DETECTION_PLAYBOOKS.md](./DETECTION_PLAYBOOKS.md) | Validation playbooks |
