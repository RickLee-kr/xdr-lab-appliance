# DSP Scenario Catalog

**문서 버전:** 1.0.0 (Phase 17)  
**상태:** Operator-facing catalog  
**대상:** Sales Engineer, PoC Engineer, Customer Success Engineer

---

## How to Read This Catalog

| Column | Meaning |
|--------|---------|
| **Scenario ID** | `dsp run --scenarios` 에 사용하는 플러그인 식별자 |
| **Category** | DSP 분류 (`manifest.yaml` `category`) |
| **Protocol** | 생성되는 네트워크/인증 프로토콜 |
| **Detection Goal** | Stellar에서 확인하려는 탐지 use case |
| **Safe Mode** | 고객 환경에서 안전하게 실행 가능한 제약 설명 |
| **Default Behavior** | 기본 파라미터로 실행 시 동작 |
| **Configurable Parameters** | 시나리오 manifest 기본값 (CLI `--scenario-params` 미지원, v1.0.2) |
| **Validation Criteria (S2)** | Event Store 기반 S2 성공 조건 |
| **Expected Stellar Evidence (S3)** | Stellar Detection Adapter가 기대하는 증거 유형 |
| **Confidence Level** | 계약상 S3 확인 신뢰도 (`scenario_contracts.yaml`) |

**중요:** S2(트래픽 검증)는 Event Store가 유일한 진실 소스입니다. S3(탐지 확인)는 선택적이며 Runner exit code에 영향을 주지 않습니다.

---

## 1. DNS Tunnel

| Attribute | Value |
|-----------|-------|
| **Scenario ID** | `dns_tunnel` |
| **Category** | `dns` |
| **Protocol** | DNS UDP/53 |
| **Detection Goal** | DNS 터널링 / DNS 익스필트레이션 탐지 |
| **Confidence Level** | **HIGH** |

### Safe Mode Description

- 2MB 더미 페이로드를 `idx-{seq:06d}-{base32}` 패턴의 FQDN으로 분할 전송
- 허용 도메인: `dns-tunnel.com` 만
- 허용 포트: UDP/53
- DNS 응답 불필요 — 쿼리 전송만으로 S2 검증
- 익스플로잇·실제 데이터 유출 없음

### Default Behavior

- 페이로드: 2.0 MB
- 청크 크기: 30 bytes
- 도메인: `dns-tunnel.com`
- 최대 호스트: 2
- UDP/53 DNS 쿼리 전송 → Event Store에 `dns_tunnel_query_sent` 이벤트 기록

### Configurable Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `payload_mb` | `2.0` | 더미 페이로드 크기 (MB) |
| `chunk_size` | `30` | FQDN당 페이로드 청크 크기 |
| `domain` | `dns-tunnel.com` | 터널 FQDN 베이스 도메인 |
| `max_hosts` | `2` | 대상 호스트 수 |
| `hosts` | (target provider) | 명시적 대상 IP 목록 |

### Validation Criteria (S2)

| Metric | Minimum |
|--------|---------|
| `dns_tunnel_chunk_created_count` | ≥ 1 |
| `dns_tunnel_query_sent_count` | ≥ 1 |

Fail-fast: `SOT_EMPTY_AFTER_EXECUTE`

### Expected Stellar Evidence (S3)

| Type | Required | Details |
|------|----------|---------|
| Alert | Yes | DNS Tunnel, DNS Exfiltration 계열 |
| Analytics | Yes | `dns_query_volume_anomaly`, `long_subdomain_pattern` |
| Entity | Yes | `ip`, `host`, `domain` |
| Timeline | Optional | DNS 쿼리 버스트, 서브도메인 길이 이상 |

Search window: **30 minutes**

---

## 2. DGA

| Attribute | Value |
|-----------|-------|
| **Scenario ID** | `dga` |
| **Category** | `dns` |
| **Protocol** | DNS UDP/53 |
| **Detection Goal** | Domain Generation Algorithm (DGA) 탐지 |
| **Confidence Level** | **HIGH** |

### Safe Mode Description

- Phase 1: `*.xdr.ooo` 도메인 500건 NXDOMAIN 트래픽
- Phase 2: `*.live.xdr.ooo` 도메인 30건 resolvable 트래픽
- 허용 도메인: `xdr.ooo` 만
- 허용 포트: UDP/53
- 실제 C2 통신 없음 — 알고리즘적 도메인 생성 시뮬레이션

### Default Behavior

- Phase 1: 500 NXDOMAIN 쿼리
- Phase 2: 30 resolvable 쿼리
- TLD: `xdr.ooo`
- 기본 리졸버: `10.10.10.20`

### Configurable Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `effective_tld` | `xdr.ooo` | DGA 도메인 TLD |
| `phase1_count` | `500` | NXDOMAIN 쿼리 수 |
| `phase2_count` | `30` | Resolvable 쿼리 수 |
| `resolver` | `10.10.10.20` | DNS 리졸버 IP |

### Validation Criteria (S2)

| Metric | Minimum |
|--------|---------|
| `dga_domain_generated_count` | ≥ 1 |
| `dga_nxdomain_observed_count` | ≥ 1 |
| `dga_resolved_observed_count` | ≥ 1 |

Fail-fast: `SOT_EMPTY_AFTER_EXECUTE`

### Expected Stellar Evidence (S3)

| Type | Required | Details |
|------|----------|---------|
| Alert | Yes | DGA, Domain Generation Algorithm 계열 |
| Analytics | Yes | `nxdomain_burst`, `dga_domain_entropy` |
| Entity | Optional | `ip`, `domain` |
| Timeline | Optional | NXDOMAIN 클러스터, 엔트로피 스파이크 |

Search window: **30 minutes**

---

## 3. HTTP Follow-up

| Attribute | Value |
|-----------|-------|
| **Scenario ID** | `http_followup` |
| **Category** | `web` |
| **Protocol** | HTTP, HTTPS |
| **Detection Goal** | HTTP 정찰 / 경로 열거 탐지 |
| **Confidence Level** | **HIGH** |

### Safe Mode Description

- 고정 경로(fixed paths)에 대한 HTTP GET/HEAD 요청
- 호스트당 최대 10건, 총 20건
- 취약점 스캐너 아님 — 탐지 가능한 정찰 패턴만 생성
- 허용 포트: 80, 443, 8080, 8000, 8443

### Default Behavior

- 최대 2 호스트
- 호스트당 10 요청, 총 20 요청
- 타임아웃: 10초
- `http_request_sent` / `http_response_received` 이벤트 기록

### Configurable Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `max_hosts` | `2` | 대상 호스트 수 |
| `max_per_host` | `10` | 호스트당 요청 수 |
| `max_total` | `20` | 총 요청 수 |
| `timeout` | `10.0` | HTTP 타임아웃 (초) |
| `hosts` | (target provider) | 명시적 대상 IP/호스트 |

### Validation Criteria (S2)

| Metric | Minimum |
|--------|---------|
| `http_request_sent_count` | ≥ 1 |

Fail-fast: `SOT_EMPTY_AFTER_EXECUTE`

### Expected Stellar Evidence (S3)

| Type | Required | Details |
|------|----------|---------|
| Alert | Yes | HTTP Reconnaissance, Suspicious HTTP Activity |
| Analytics | Yes | `http_path_enumeration` |
| Entity | Optional | `ip`, `host`, `url` |
| Timeline | Optional | 순차적 HTTP GET/HEAD 이벤트 |

Search window: **15 minutes**

---

## 4. SSH Login Failure

| Attribute | Value |
|-----------|-------|
| **Scenario ID** | `ssh_failure` |
| **Category** | `auth` |
| **Protocol** | SSH (TCP/22) |
| **Detection Goal** | SSH 인증 실패 / 브루트포스 탐지 |
| **Confidence Level** | **HIGH** |

### Safe Mode Description

- 공개키 기반 시도 + 더미 패스워드 라벨 (증거용)
- 유효 자격증명 사용 금지
- 브루트포스 엔진 아님 — 제한된 실패 인증 시도
- 금지: `privilege_escalation`, `valid_credential_use`, `brute_force`

### Default Behavior

- 최대 2 호스트
- 호스트당 30 시도, 총 60 시도
- 포트: 22
- `ssh_auth_attempt` / `ssh_auth_failed` 이벤트 기록

### Configurable Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `max_hosts` | `2` | 대상 호스트 수 |
| `max_per_host` | `30` | 호스트당 시도 수 |
| `max_total` | `60` | 총 시도 수 |
| `port` | `22` | SSH 포트 |
| `timeout` | `10.0` | 연결 타임아웃 (초) |
| `hosts` | (target provider) | 명시적 대상 IP |

### Validation Criteria (S2)

| Metric | Minimum |
|--------|---------|
| `ssh_auth_attempt_count` | ≥ 1 |
| `ssh_auth_failed_count` | ≥ 1 |

Fail-fast: `SOT_EMPTY_AFTER_EXECUTE`

### Expected Stellar Evidence (S3)

| Type | Required | Details |
|------|----------|---------|
| Alert | Yes | SSH Login Failure, Brute Force SSH |
| Analytics | Yes | `ssh_auth_failure_burst` |
| Entity | Yes | `ip`, `host`, `user` |
| Timeline | Optional | 포트 22 반복 인증 실패 |

Search window: **30 minutes**

---

## 5. SQL Injection

| Attribute | Value |
|-----------|-------|
| **Scenario ID** | `sql_injection` |
| **Category** | `web` |
| **Protocol** | HTTP, HTTPS |
| **Detection Goal** | SQL Injection / Web Attack 탐지 |
| **Confidence Level** | **HIGH** |

### Safe Mode Description

- HTTP GET 쿼리스트링에 안전한 SQLi 페이로드 패턴 삽입
- 호스트당 10건, 총 20건
- 취약점 스캐너·익스플로잇 도구 아님
- 금지: `data_exfiltration`, `destructive_sql`, `credential_extraction`, `blind_sqli_engine`, `vulnerability_scanning`

### Default Behavior

- 최대 2 호스트
- SQLi 페이로드 생성 → HTTP 요청 전송
- `sql_payload_generated` / `sql_request_sent` 이벤트 기록

### Configurable Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `max_hosts` | `2` | 대상 호스트 수 |
| `max_per_host` | `10` | 호스트당 요청 수 |
| `max_total` | `20` | 총 요청 수 |
| `timeout` | `10.0` | HTTP 타임아웃 (초) |
| `hosts` | (target provider) | 명시적 대상 IP/호스트 |

### Validation Criteria (S2)

| Metric | Minimum |
|--------|---------|
| `sql_payload_generated_count` | ≥ 1 |
| `sql_request_sent_count` | ≥ 1 |

Fail-fast: `SOT_EMPTY_AFTER_EXECUTE`

### Expected Stellar Evidence (S3)

| Type | Required | Details |
|------|----------|---------|
| Alert | Yes | SQL Injection, Web Attack SQLi |
| Analytics | Yes | `sqli_payload_detected` |
| Entity | Optional | `ip`, `host`, `url` |
| Timeline | Optional | SQLi 페이로드 포함 HTTP 요청 |

Search window: **15 minutes**

---

## 6. SMB Login Failure

| Attribute | Value |
|-----------|-------|
| **Scenario ID** | `smb_login_failure` |
| **Category** | `auth` |
| **Protocol** | SMB (TCP/445, 139) |
| **Detection Goal** | SMB 인증 실패 / Bad Auth 탐지 |
| **Confidence Level** | **HIGH** |

### Safe Mode Description

- Safe mode 기본 활성화 (`safe_mode: true`)
- 유효 자격증명 없음, 브루트포스 없음, 자격증명 수집 없음
- 제어된 실패 인증만 수행
- 금지: `privilege_escalation`, `valid_credential_use`, `brute_force`, `credential_harvesting`

### Default Behavior

- 최대 5 호스트
- 호스트당 10 시도
- 포트: 445
- `smb_auth_attempt` / `smb_auth_failed` 이벤트 기록

### Configurable Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `max_hosts` | `5` | 대상 호스트 수 |
| `attempts_per_host` | `10` | 호스트당 시도 수 |
| `port` | `445` | SMB 포트 |
| `timeout` | `10.0` | 연결 타임아웃 (초) |
| `safe_mode` | `true` | 안전 모드 (변경 비권장) |
| `hosts` | (target provider) | 명시적 대상 IP |

### Validation Criteria (S2)

| Metric | Minimum |
|--------|---------|
| `smb_auth_attempt_count` | ≥ 1 |
| `smb_auth_failed_count` | ≥ 1 |

Fail-fast: `SOT_EMPTY_AFTER_EXECUTE`

### Expected Stellar Evidence (S3)

| Type | Required | Details |
|------|----------|---------|
| Alert | Yes | SMB Authentication Failure, SMB Bad Auth |
| Entity | Yes | `ip`, `host`, `user` |
| Analytics | Optional | `smb_auth_failure_burst` |
| Timeline | Optional | SMB 인증 실패 이벤트 |

Search window: **30 minutes**

---

## 7. Port Sweep

| Attribute | Value |
|-----------|-------|
| **Scenario ID** | `port_sweep` |
| **Category** | `network` |
| **Protocol** | TCP |
| **Detection Goal** | 수평 포트 스캔 / Port Sweep 탐지 |
| **Confidence Level** | **HIGH** |

### Safe Mode Description

- Safe mode 기본 활성화
- 13개 일반 포트에 대한 제어된 TCP 연결 시도
- 익스플로잇, 취약점 스캔, 서비스 핑거프린팅 없음
- 금지: `exploitation`, `vulnerability_scanning`, `service_fingerprinting`, `payload_delivery`

### Default Behavior

- 최대 5 호스트
- 13 포트: 22, 23, 25, 53, 80, 110, 135, 139, 143, 389, 443, 445, 3389
- `port_probe_sent`, `port_connection_opened`/`port_connection_failed` 이벤트 기록

### Configurable Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `max_hosts` | `5` | 대상 호스트 수 |
| `max_ports` | `13` | 스캔 포트 수 |
| `ports` | (13 common ports) | 스캔 대상 포트 목록 |
| `timeout` | `3.0` | 연결 타임아웃 (초) |
| `safe_mode` | `true` | 안전 모드 (변경 비권장) |
| `hosts` | (target provider) | 명시적 대상 IP |

### Validation Criteria (S2)

| Metric | Minimum |
|--------|---------|
| `port_probe_count` | ≥ 1 |
| `port_connection_attempt_count` | ≥ 1 |

Fail-fast: `SOT_EMPTY_AFTER_EXECUTE`

### Expected Stellar Evidence (S3)

| Type | Required | Details |
|------|----------|---------|
| Alert | Yes | Port Sweep, Horizontal Port Scan |
| Entity | Yes | `ip`, `host` |
| Analytics | Optional | `port_scan_burst` |
| Timeline | Optional | 다중 포트 연결 시도 |

Search window: **30 minutes**

---

## 8. LDAP Enumeration

| Attribute | Value |
|-----------|-------|
| **Scenario ID** | `ldap_enumeration` |
| **Category** | `identity` |
| **Protocol** | LDAP (TCP/389, 636) |
| **Detection Goal** | LDAP 열거 / Anonymous Bind 탐지 |
| **Confidence Level** | **MEDIUM** |

### Safe Mode Description

- Safe mode 기본 활성화
- 익명 또는 의도적 실패 bind/search 시도만
- 자격증명 탈취, 데이터 추출, 패스워드 스프레이 없음
- 금지: `credential_theft`, `data_extraction`, `password_spraying`, `exploitation`

### Default Behavior

- 최대 5 호스트
- 호스트당 10 쿼리
- 포트: 389, 636
- `ldap_connection_attempt`, `ldap_bind_attempt`, `ldap_search_attempt` 이벤트 기록

### Configurable Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `max_hosts` | `5` | 대상 호스트 수 |
| `max_queries_per_host` | `10` | 호스트당 LDAP 쿼리 수 |
| `ports` | `[389, 636]` | LDAP 포트 |
| `timeout` | `5.0` | 연결 타임아웃 (초) |
| `safe_mode` | `true` | 안전 모드 (변경 비권장) |
| `hosts` | (target provider) | 명시적 대상 IP (DC 권장) |

### Validation Criteria (S2)

| Metric | Minimum |
|--------|---------|
| `ldap_connection_attempt_count` | ≥ 1 |
| `ldap_bind_or_search_attempt_count` | ≥ 1 |

Fail-fast: `SOT_EMPTY_AFTER_EXECUTE`

### Expected Stellar Evidence (S3)

| Type | Required | Details |
|------|----------|---------|
| Alert | Yes | LDAP Enumeration, LDAP Anonymous Bind |
| Entity | Yes | `ip`, `host` |
| Analytics | Optional | `ldap_query_burst` |
| Timeline | Optional | LDAP bind/search 시도 |

Search window: **30 minutes**

---

## 9. Kerberos Failure

| Attribute | Value |
|-----------|-------|
| **Scenario ID** | `kerberos_failure` |
| **Category** | `auth` |
| **Protocol** | Kerberos (TCP/UDP/88) |
| **Detection Goal** | Kerberos 인증 실패 / Anomaly 탐지 |
| **Confidence Level** | **HIGH** |

### Safe Mode Description

- Safe mode 기본 활성화
- 유효 자격증명 없음, Kerberoasting/AS-REP Roasting 없음
- 제어된 실패 인증만 수행
- 금지: `privilege_escalation`, `valid_credential_use`, `brute_force`, `credential_harvesting`, `ticket_abuse`, `kerberoasting`, `as_rep_roasting`

### Default Behavior

- 최대 5 호스트
- 호스트당 10 시도
- 포트: 88, realm: `LOCAL.REALM`
- `kerberos_auth_attempt` / `kerberos_auth_failed` 이벤트 기록

### Configurable Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `max_hosts` | `5` | 대상 호스트 수 |
| `attempts_per_host` | `10` | 호스트당 시도 수 |
| `port` | `88` | Kerberos 포트 |
| `realm` | `LOCAL.REALM` | Kerberos realm |
| `timeout` | `10.0` | 연결 타임아웃 (초) |
| `safe_mode` | `true` | 안전 모드 (변경 비권장) |
| `hosts` | (target provider) | 명시적 대상 IP (DC 권장) |

### Validation Criteria (S2)

| Metric | Minimum |
|--------|---------|
| `kerberos_auth_attempt_count` | ≥ 1 |
| `kerberos_auth_failed_count` | ≥ 1 |

Fail-fast: `SOT_EMPTY_AFTER_EXECUTE`

### Expected Stellar Evidence (S3)

| Type | Required | Details |
|------|----------|---------|
| Alert | Yes | Kerberos Authentication Failure, Kerberos Anomaly |
| Entity | Yes | `ip`, `host`, `user` |
| Analytics | Optional | `kerberos_auth_failure_burst` |
| Timeline | Optional | Kerberos pre-auth 실패 이벤트 |

Search window: **30 minutes**

---

## Quick Reference — Scenario IDs

| Display Name | Scenario ID | Category |
|--------------|-------------|----------|
| DNS Tunnel | `dns_tunnel` | dns |
| DGA | `dga` | dns |
| HTTP Follow-up | `http_followup` | web |
| SSH Login Failure | `ssh_failure` | auth |
| SQL Injection | `sql_injection` | web |
| SMB Login Failure | `smb_login_failure` | auth |
| Port Sweep | `port_sweep` | network |
| LDAP Enumeration | `ldap_enumeration` | identity |
| Kerberos Failure | `kerberos_failure` | auth |

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [CUSTOMER_DEMO_GUIDE.md](./CUSTOMER_DEMO_GUIDE.md) | 고객 데모 실행 가이드 |
| [DETECTION_PLAYBOOKS.md](./DETECTION_PLAYBOOKS.md) | 탐지 검증 플레이북 |
| [SCENARIO_SELECTION_MATRIX.md](./SCENARIO_SELECTION_MATRIX.md) | 시나리오 선택 가이드 |
| [STELLAR_EXPECTED_EVIDENCE_GUIDE.md](./STELLAR_EXPECTED_EVIDENCE_GUIDE.md) | Stellar 증거 상세 |
| [LAB_EXECUTION_RUNBOOK.md](./LAB_EXECUTION_RUNBOOK.md) | 랩 실행 런북 |
