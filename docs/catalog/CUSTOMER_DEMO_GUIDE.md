# DSP Customer Demo Guide

**문서 버전:** 1.0.0 (Phase 17)  
**상태:** Customer-facing demo guide  
**대상:** Sales Engineer, PoC Engineer, Customer Success Engineer

---

## Before You Begin

### Prerequisites

```bash
cd detection-scenario-platform
source .venv/bin/activate
dsp plugins list   # 9 production scenarios ACTIVE 확인
```

### Demo Modes

| Mode | Command | Use Case |
|------|---------|----------|
| Traffic only (S2) | `dsp run --scenarios <id>` | dry-run 또는 라이브 트래픽 검증 |
| Manual S3 evidence (default) | `dsp run --scenarios <id> --confirm-detection` | Stellar UI 수동 상관 — **API 토큰 불필요** |
| Experimental API S3 | `--confirm-detection --stellar-client http` | 자동 API 폴링 (선택, `docs/experimental/STELLAR_HTTP_API_MODE.md`) |

### Environment Variables

**Normal demo (S2 + manual S3):** none required beyond optional `DSP_RUNS_DIR`.

```bash
export DSP_RUNS_DIR=/path/to/demo-evidence
```

**Experimental HTTP S3 only** (not required for normal demos):

```bash
export DSP_STELLAR_BASE_URL=https://stellar.lab.example
export DSP_STELLAR_API_TOKEN=<token>
```

---

## 1. DNS Tunnel

### Purpose

DNS 터널링 탐지 능력을 검증합니다. NDR/SIEM이 비정상 DNS 쿼리 패턴(긴 서브도메인, 고볼륨 UDP/53)을 식별하는지 확인합니다.

### What the Customer Should Observe

- DSP 리포트: `dns_tunnel_query_sent_count` ≥ 1
- Stellar: DNS Tunnel 또는 DNS Exfiltration 알림
- Analytics: `dns_query_volume_anomaly`, `long_subdomain_pattern`
- Entity: 소스 IP, 대상 DNS 서버, `dns-tunnel.com` 도메인

### Expected Detection Timeline

| Phase | Time |
|-------|------|
| Traffic generation | 1–5 min |
| Stellar alert surfacing | 5–30 min |
| S3 auto-poll window | run_end + 30 min |

### Expected Stellar Evidence

- Alert families: DNS Tunnel, DNS Exfiltration
- Analytics: `dns_query_volume_anomaly`, `long_subdomain_pattern`
- Entities: source IP, host, domain

### Example Command

```bash
dsp run --scenarios dns_tunnel \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

After run, complete manual S3 evidence in `evidence/<run_id>/manual/` using Stellar UI.

Experimental API automation (optional):

```bash
dsp run --scenarios dns_tunnel \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Expected Validation Result (S2)

```json
{
  "decision": "success",
  "metrics": {
    "dns_tunnel_chunk_created_count": ">= 1",
    "dns_tunnel_query_sent_count": ">= 1"
  }
}
```

### Expected S3 Result

| Condition | S3 Status |
|-----------|-----------|
| Stellar evidence + correlation score ≥ 0.70 | `S3_CONFIRMED` |
| Evidence present but score 0.40–0.69 | `S3_INCONCLUSIVE` |
| No evidence or score < 0.40 | `S3_NOT_OBSERVED` |

### Suggested Talking Points

- "DSP는 실제 익스필 없이 idx-pattern DNS 쿼리만 생성합니다 — 고객 환경에 안전합니다."
- "S2는 Event Store로 트래픽을 증명하고, S3는 Stellar가 같은 트래픽을 탐지했는지 독립적으로 확인합니다."
- "알림 이름이 바뀌어도 IP·시간·엔티티 기반 상관분석으로 탐지를 확인합니다."

---

## 2. DGA

### Purpose

Domain Generation Algorithm 탐지를 검증합니다. NXDOMAIN 버스트와 높은 엔트로피 도메인 조회 패턴을 생성합니다.

### What the Customer Should Observe

- DSP: Phase 1 NXDOMAIN 500건 + Phase 2 resolvable 30건
- Stellar: DGA 알림, NXDOMAIN 클러스터
- Analytics: `nxdomain_burst`, `dga_domain_entropy`

### Expected Detection Timeline

| Phase | Time |
|-------|------|
| Phase 1 (NXDOMAIN) | 2–8 min |
| Phase 2 (resolvable) | 1–2 min |
| Stellar alert surfacing | 5–30 min |

### Expected Stellar Evidence

- Alert families: DGA, Domain Generation Algorithm
- Analytics: `nxdomain_burst`, `dga_domain_entropy`
- Entities: source IP, generated domains

### Example Command

```bash
dsp run --scenarios dga \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Expected Validation Result (S2)

```json
{
  "decision": "success",
  "metrics": {
    "dga_domain_generated_count": ">= 1",
    "dga_nxdomain_observed_count": ">= 1",
    "dga_resolved_observed_count": ">= 1"
  }
}
```

### Expected S3 Result

`S3_CONFIRMED` when NXDOMAIN burst analytics correlate with source IP within 30-minute window.

### Suggested Talking Points

- "두 단계 DGA 시뮬레이션: NXDOMAIN 버스트 후 일부 resolvable 도메인 — 실제 봇넷 C2 패턴과 유사합니다."
- "모든 도메인은 `xdr.ooo` TLD 하에 생성되어 라벨 환경에서만 동작합니다."

---

## 3. HTTP Follow-up

### Purpose

HTTP 정찰/경로 열거 탐지를 검증합니다. WAF/NDR이 의심스러운 HTTP 접근 패턴을 식별하는지 확인합니다.

### What the Customer Should Observe

- DSP: `http_request_sent_count` ≥ 1
- Stellar: HTTP Reconnaissance 또는 Suspicious HTTP Activity 알림
- Analytics: `http_path_enumeration`

### Expected Detection Timeline

| Phase | Time |
|-------|------|
| Traffic generation | 1–3 min |
| Stellar alert surfacing | 5–15 min |

### Expected Stellar Evidence

- Alert families: HTTP Reconnaissance, Suspicious HTTP Activity
- Analytics: `http_path_enumeration`
- Entities: source IP, destination IP, URL paths

### Example Command

```bash
dsp run --scenarios http_followup \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Expected Validation Result (S2)

```json
{
  "decision": "success",
  "metrics": {
    "http_request_sent_count": ">= 1"
  }
}
```

### Expected S3 Result

`S3_CONFIRMED` when path enumeration analytics match source/destination IP pair.

### Suggested Talking Points

- "취약점 스캐너가 아닌, 탐지 가능한 정찰 패턴만 생성합니다."
- "고정 경로 HTTP 요청으로 NDR/WAF 탐지 규칙을 안전하게 검증합니다."

---

## 4. SSH Login Failure

### Purpose

SSH 인증 실패/브루트포스 탐지를 검증합니다. Identity/NDR이 반복 인증 실패를 식별하는지 확인합니다.

### What the Customer Should Observe

- DSP: `ssh_auth_attempt_count` 및 `ssh_auth_failed_count` ≥ 1
- Stellar: SSH Login Failure 또는 Brute Force SSH 알림
- Analytics: `ssh_auth_failure_burst`
- Entities: source IP, target host, username

### Expected Detection Timeline

| Phase | Time |
|-------|------|
| Traffic generation | 2–5 min |
| Stellar alert surfacing | 5–30 min |

### Expected Stellar Evidence

- Alert families: SSH Login Failure, Brute Force SSH
- Analytics: `ssh_auth_failure_burst`
- Entities: ip, host, user

### Example Command

```bash
dsp run --scenarios ssh_failure \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Expected Validation Result (S2)

```json
{
  "decision": "success",
  "metrics": {
    "ssh_auth_attempt_count": ">= 1",
    "ssh_auth_failed_count": ">= 1"
  }
}
```

### Expected S3 Result

`S3_CONFIRMED` when auth failure burst analytics correlate with source/destination IP and username.

### Suggested Talking Points

- "유효 자격증명을 사용하지 않습니다 — 제어된 실패 인증만 생성합니다."
- "Identity 모니터링과 NDR 양쪽에서 SSH 실패를 관측할 수 있습니다."

---

## 5. SQL Injection

### Purpose

SQL Injection / Web Attack 탐지를 검증합니다. WAF/NDR이 SQLi 페이로드 패턴을 식별하는지 확인합니다.

### What the Customer Should Observe

- DSP: `sql_payload_generated_count` 및 `sql_request_sent_count` ≥ 1
- Stellar: SQL Injection 또는 Web Attack SQLi 알림
- Analytics: `sqli_payload_detected`

### Expected Detection Timeline

| Phase | Time |
|-------|------|
| Traffic generation | 1–3 min |
| Stellar alert surfacing | 5–15 min |

### Expected Stellar Evidence

- Alert families: SQL Injection, Web Attack SQLi
- Analytics: `sqli_payload_detected`
- Entities: source IP, destination IP, URL with payload

### Example Command

```bash
dsp run --scenarios sql_injection \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Expected Validation Result (S2)

```json
{
  "decision": "success",
  "metrics": {
    "sql_payload_generated_count": ">= 1",
    "sql_request_sent_count": ">= 1"
  }
}
```

### Expected S3 Result

`S3_CONFIRMED` when SQLi payload analytics match HTTP traffic from source IP.

### Suggested Talking Points

- "실제 DB 익스플로잇 없이 탐지 가능한 SQLi 패턴만 HTTP GET으로 전송합니다."
- "WAF와 NDR 양쪽 탐지 규칙을 동시에 검증할 수 있습니다."

---

## 6. SMB Login Failure

### Purpose

SMB 인증 실패 탐지를 검증합니다. Windows/Identity 환경에서 SMB Bad Auth 패턴을 확인합니다.

### What the Customer Should Observe

- DSP: `smb_auth_attempt_count` 및 `smb_auth_failed_count` ≥ 1
- Stellar: SMB Authentication Failure 또는 SMB Bad Auth 알림
- Entities: source IP, target host, username

### Expected Detection Timeline

| Phase | Time |
|-------|------|
| Traffic generation | 2–5 min |
| Stellar alert surfacing | 5–30 min |

### Expected Stellar Evidence

- Alert families: SMB Authentication Failure, SMB Bad Auth
- Analytics (optional): `smb_auth_failure_burst`
- Entities: ip, host, user

### Example Command

```bash
dsp run --scenarios smb_login_failure \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Expected Validation Result (S2)

```json
{
  "decision": "success",
  "metrics": {
    "smb_auth_attempt_count": ">= 1",
    "smb_auth_failed_count": ">= 1"
  }
}
```

### Expected S3 Result

`S3_CONFIRMED` when SMB auth failure alerts correlate with source IP and target Windows host.

### Suggested Talking Points

- "Safe mode가 기본 활성화 — 브루트포스나 자격증명 수집 없이 실패 인증만 생성합니다."
- "Active Directory 환경의 lateral movement 전 단계 탐지를 검증합니다."

---

## 7. Port Sweep

### Purpose

수평 포트 스캔/Port Sweep 탐지를 검증합니다. NDR/IDS가 내부 정찰 활동을 식별하는지 확인합니다.

### What the Customer Should Observe

- DSP: `port_probe_count` 및 `port_connection_attempt_count` ≥ 1
- Stellar: Port Sweep 또는 Horizontal Port Scan 알림
- Entities: scanner source IP, target hosts

### Expected Detection Timeline

| Phase | Time |
|-------|------|
| Traffic generation | 2–5 min |
| Stellar alert surfacing | 5–30 min |

### Expected Stellar Evidence

- Alert families: Port Sweep, Horizontal Port Scan
- Analytics (optional): `port_scan_burst`
- Entities: ip, host

### Example Command

```bash
dsp run --scenarios port_sweep \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Expected Validation Result (S2)

```json
{
  "decision": "success",
  "metrics": {
    "port_probe_count": ">= 1",
    "port_connection_attempt_count": ">= 1"
  }
}
```

### Expected S3 Result

`S3_CONFIRMED` when port scan alerts correlate with source IP probing multiple hosts/ports.

### Suggested Talking Points

- "13개 일반 포트에 대한 제어된 TCP 연결 시도 — 익스플로잇 없음."
- "내부 lateral movement 전 정찰 단계를 NDR로 탐지하는 능력을 검증합니다."

---

## 8. LDAP Enumeration

### Purpose

LDAP 열거/Anonymous Bind �탐지를 검증합니다. Identity/NDR이 디렉터리 정찰 활동을 식별하는지 확인합니다.

### What the Customer Should Observe

- DSP: `ldap_connection_attempt_count` 및 `ldap_bind_or_search_attempt_count` ≥ 1
- Stellar: LDAP Enumeration 또는 LDAP Anonymous Bind 알림
- Entities: source IP, domain controller

### Expected Detection Timeline

| Phase | Time |
|-------|------|
| Traffic generation | 2–5 min |
| Stellar alert surfacing | 5–30 min |

### Expected Stellar Evidence

- Alert families: LDAP Enumeration, LDAP Anonymous Bind
- Analytics (optional): `ldap_query_burst`
- Entities: ip, host

### Example Command

```bash
dsp run --scenarios ldap_enumeration \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Expected Validation Result (S2)

```json
{
  "decision": "success",
  "metrics": {
    "ldap_connection_attempt_count": ">= 1",
    "ldap_bind_or_search_attempt_count": ">= 1"
  }
}
```

### Expected S3 Result

`S3_CONFIRMED` (confidence MEDIUM) when LDAP enumeration alerts correlate with source IP and DC.

Note: LDAP scenarios may require longer Stellar processing time; `S3_INCONCLUSIVE` is acceptable on first run.

### Suggested Talking Points

- "패스워드 스프레이나 데이터 추출 없이 bind/search 시도만 생성합니다."
- "Active Directory 환경에서 디렉터리 정찰 탐지를 검증합니다."

---

## 9. Kerberos Failure

### Purpose

Kerberos 인증 실패 탐지를 검증합니다. Identity/NDR이 Kerberos pre-auth 실패 버스트를 식별하는지 확인합니다.

### What the Customer Should Observe

- DSP: `kerberos_auth_attempt_count` 및 `kerberos_auth_failed_count` ≥ 1
- Stellar: Kerberos Authentication Failure 또는 Kerberos Anomaly 알림
- Entities: source IP, DC, username/realm

### Expected Detection Timeline

| Phase | Time |
|-------|------|
| Traffic generation | 2–5 min |
| Stellar alert surfacing | 5–30 min |

### Expected Stellar Evidence

- Alert families: Kerberos Authentication Failure, Kerberos Anomaly
- Analytics (optional): `kerberos_auth_failure_burst`
- Entities: ip, host, user

### Example Command

```bash
dsp run --scenarios kerberos_failure \
  --target-net 10.10.10.0/24 \
  --confirm-detection
```

### Expected Validation Result (S2)

```json
{
  "decision": "success",
  "metrics": {
    "kerberos_auth_attempt_count": ">= 1",
    "kerberos_auth_failed_count": ">= 1"
  }
}
```

### Expected S3 Result

`S3_CONFIRMED` when Kerberos failure alerts correlate with source IP, DC, and realm.

### Suggested Talking Points

- "Kerberoasting이나 AS-REP Roasting 없이 pre-auth 실패만 생성합니다."
- "Golden Ticket 등 고급 공격 없이 기본 Kerberos 인증 실패 탐지를 검증합니다."

---

## Full Demo Battery (Recommended Sequence)

고객 전체 데모 시 아래 순서로 실행하고 시나리오 간 **5분 이상 간격**을 둡니다:

1. `dns_tunnel` — DNS 탐지 소개
2. `dga` — DNS 고급 탐지
3. `http_followup` — 웹 정찰
4. `sql_injection` — 웹 공격
5. `ssh_failure` — Linux 인증
6. `smb_login_failure` — Windows 인증
7. `port_sweep` — 네트워크 정찰
8. `ldap_enumeration` — AD 정찰
9. `kerberos_failure` — Kerberos 인증

```bash
export DSP_RUNS_DIR=/path/to/demo-evidence

for scenario in dns_tunnel dga http_followup sql_injection ssh_failure \
  smb_login_failure port_sweep ldap_enumeration kerberos_failure; do
  dsp run --scenarios "$scenario" \
    --target-net 10.10.10.0/24 \
    --confirm-detection
  echo "Waiting 5 minutes before next scenario..."
  sleep 300
done
```

---

## Demo Artifacts to Show the Customer

각 run 후 다음 파일을 고객에게 제시합니다:

| Artifact | Path | Purpose |
|----------|------|---------|
| Human report | `~/.dsp/runs/<run_id>/report.md` | S2/S3 요약 |
| Validation | `~/.dsp/runs/<run_id>/validation.json` | S2 상세 |
| S3 manual result | `~/.dsp/runs/<run_id>/evidence/<run_id>/manual/s3_result_manual.json` | S3 pending review |
| Manual evidence | `~/.dsp/runs/<run_id>/evidence/<run_id>/manual/` | Checklist, correlation notes, UI template |
| Stellar API evidence (experimental) | `~/.dsp/runs/<run_id>/evidence/<run_id>/stellar/` | Only with `--stellar-client http` |

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [SCENARIO_CATALOG.md](./SCENARIO_CATALOG.md) | 시나리오 상세 스펙 |
| [LAB_EXECUTION_RUNBOOK.md](./LAB_EXECUTION_RUNBOOK.md) | 랩 실행 절차 |
| [STELLAR_EXPECTED_EVIDENCE_GUIDE.md](./STELLAR_EXPECTED_EVIDENCE_GUIDE.md) | S3 증거 해석 |
