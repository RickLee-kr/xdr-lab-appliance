# DSP v1.2.0 Operational Design Audit

**Audit Date:** 2026-06-09  
**Audit Type:** Read-only operational design audit (no code changes)  
**Repository:** `/home/aella/xdr-lab-appliance`  
**Primary Code Root:** `detection-scenario-platform/`

---

## 1. Executive Summary

본 감사는 코드 수정·구현·릴리스 작업 없이, 저장소 전체를 대상으로 DSP v1.2.0 운영 설계 일치 여부를 **코드 근거만**으로 평가한다.

### 감사 기준 문서 상태

| 요청 문서 | 저장소 내 존재 | 대체/관찰 |
|-----------|---------------|-----------|
| `CHATGPT-DATA-RELAY-GUARDRAIL.md` | **NOT FOUND** | — |
| `PRODUCT-CHARTER.md` | **NOT FOUND** | — |
| `MASTER-WBS.md` | **NOT FOUND** | — |
| `PROJECT_CHARTER.md` | FOUND | `detection-scenario-platform/PROJECT_CHARTER.md` |

**3개 필수 문서는 저장소에 존재하지 않는다.** 본 감사는 사용자가 명시한 운영 기준(`Success = Traffic Generated`, DSP = Traffic Generator / Scenario Runner / Event Collector / Evidence Generator, DSP ≠ Detection Engine)을 **재해석 없이** 1차 기준으로 적용한다. `PROJECT_CHARTER.md`는 참조용으로만 인용하며, 해당 문서 §2의 *"DSP는 Traffic Generator가 아니라 Detection Scenario Platform"* 문구와 사용자 감사 기준이 **상충**함을 기록한다.

### 버전 관찰

| 항목 | 코드 근거 |
|------|-----------|
| DSP 패키지 버전 | `detection-scenario-platform/pyproject.toml` L3 → **`1.1.0`** |
| v1.2.0 참조 | `stellar_poc_event_sot.sh` `EVENT_SOT_VERSION="1.2.0"` (레거시 Bash Event SOT) |
| 시나리오 수 | `scenarios/*/manifest.yaml` → **12개** |

### 핵심 결론

| 영역 | 판정 | 요약 |
|------|------|------|
| Live 트래픽 생성 (Local) | **PARTIAL** | 10/12 시나리오가 live 모드에서 실제 I/O 가능. `dummy`/`dns_dummy`는 네트워크 미전송 |
| Success = Traffic Generated | **PARTIAL** | 다수 시나리오 validation은 sent/attempt 기준이나, `dns_dummy`·`dga`·`ssh_failure`·`smb_login_failure`는 response/outcome 의존 |
| Webshell Remote Execution | **PARTIAL** | HTTP 전송·bundle import 구현. `dsp-remote-scenario` 바이너리 없음. RunManager 미통합 |
| CI / pytest | **MOCK ONLY** | 실제 target_net 트래픽 검증 테스트 **0건** |
| Detection Engine 분리 | **COMPLIANT** | 시나리오 success는 ValidationEngine + Event Store. `--confirm-detection`은 optional |

---

## 2. Repository Overview

### 2.1 구조

```
detection-scenario-platform/
├── dsp/
│   ├── runner/run_manager.py          # CLI run lifecycle
│   ├── engine/scenario_engine.py      # Scenario ABC
│   ├── engine/orchestrator.py         # prepare → execute → summarize
│   ├── event_store/store.py           # SQLite append-only SOT
│   ├── validation/engine.py           # manifest-driven validation
│   ├── protocols/                     # DNS, HTTP, SSH, LDAP, SMB, Kerberos, recon
│   ├── execution/                     # local_provider, webshell_provider, remote/
│   ├── lab/operational_runner.py      # host direct + webshell lab entry
│   ├── evidence/                      # JSON/Markdown export
│   └── manual_verification/           # checklist, investigation notes
├── scenarios/                         # 12 scenario plugins
└── tests/                             # 113 test_*.py files
```

### 2.2 공통 실행 모델

- `RunManager.run()` → `create_execution_provider("local")` 고정 (`run_manager.py` L169)
- 시나리오 executor: `mode = "mock" if ctx.dry_run else "live"` (대부분)
- Validation: `ValidationEngine` → manifest `validation_profile` → EventStore aggregate only (`validation/engine.py` L59–90)
- Detection: `--confirm-detection` 시에만 `DetectionManager` 호출 (`run_manager.py` L206–219) — **기본 success 경로 아님**

### 2.3 Traffic Profile

`dsp/runtime/traffic_profiles.py` — `low` / `balanced` / `burst` → 시나리오별 volume 파라미터 매핑 (L12–93). detection logic 없음 (L1 주석).

---

## 3. Scenario Audit

각 시나리오에 대해 감사 질문 1–12를 답변한다.  
**공통:** live 모드 = `dry_run=False`. 응답 없을 때 조기 종료하는 시나리오는 **없음** (cancelled 외).

---

### 3.1 dummy

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 네트워크 패킷 전송? | **NO** | `scenarios/dummy/scenario.py` L39–55: EventStore synthetic append only |
| 2 | 실제 Target Host 사용? | **YES (메타)** | L37: `targets.hosts[0]` or fallback `10.10.10.20` |
| 3 | 응답 대기? | **NO** | socket/subprocess 없음 |
| 4 | 응답 없으면 종료? | **NO** | planned count까지 루프 |
| 5 | 응답 성공 = 성공 조건? | **NO** | validation: `synthetic_action_count min 3` (`manifest.yaml` L28–30) |
| 6 | Traffic Attempt만으로 Event? | **YES** | L42–54: 루프마다 즉시 `synthetic_action` |
| 7 | Response Success 이후에만 Event? | **NO** | — |
| 8 | 센서 관찰 트래픽 목적? | **NO** | manifest L6–7: architecture validation, no network I/O |
| 9 | low/balanced/burst 변경? | **YES** | `traffic_profiles.py` L13–17: action_count 3/10/25 |
| 10 | Host Direct Execution? | **YES** | RunManager → LocalExecutionProvider |
| 11 | Webshell Remote Execution? | **NO** | manifest L57: `remote_capable: false` |
| 12 | Charter | **PARTIAL** | Event 생성 OK. 센서 가시 트래픽 목적 아님 — 설계상 dry-run/architecture용 |

---

### 3.2 dns_dummy

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **NO** | `scenarios/dns_dummy/executor.py` L21: `DnsClient(dry_run=True, mock=True)` **항상 mock** |
| 2 | Target Host? | **YES** | L18: resolver = params or `targets.hosts[0]` or `10.10.10.20` |
| 3 | 응답 대기? | **NO** | mock query, no sendto/recvfrom |
| 4 | 응답 없으면 종료? | **NO** | — |
| 5 | 응답 성공 = 성공 조건? | **YES** | manifest L48–52: `dns_response_count min: 3` |
| 6 | Attempt만으로 Event? | **NO** | L37–45: query 완료 후 `build_dns_events` 일괄 |
| 7 | Response Success 이후에만? | **YES (mock response)** | mock outcome → response event |
| 8 | 센서 트래픽 목적? | **NO** | manifest L6–7: mock/dry-run only |
| 9 | Profile 변경? | **YES** | `traffic_profiles.py` L83–87: query_count 3/8/20 |
| 10 | Host Direct? | **YES** (mock only) | — |
| 11 | Webshell? | **NO** | manifest L87: `remote_capable: false` |
| 12 | Charter | **VIOLATION** | live UDP/53 전송 불가. validation이 mock response에 의존 |

---

### 3.3 dns_transport_dummy

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **YES (live)** | `executor.py` L20–36 + `dns/client.py` L67 `sendto` |
| 2 | Target Host? | **YES** | `executor.py` L18 |
| 3 | 응답 대기? | **YES** | `dns/client.py` L69 `recvfrom`, L70–79 timeout |
| 4 | 응답 없으면 종료? | **NO** | timeout → outcome event, 루프 계속 |
| 5 | 응답 성공 = 성공? | **NO** | manifest L48–50: `dns_query_sent_count min: 1` only |
| 6 | Attempt만 Event? | **NO** | query 완료 후 `build_dns_events` |
| 7 | Response 이후에만? | **NO** | sent + outcome 동시 생성 |
| 8 | 센서 트래픽? | **YES** | manifest L6–7: live UDP/53 verification |
| 9 | Profile? | **YES** | `traffic_profiles.py` L88–92 |
| 10 | Host Direct? | **YES** | — |
| 11 | Webshell? | **NO** | manifest L87 |
| 12 | Charter | **COMPLIANT** | live UDP 전송, validation sent 기준 |

---

### 3.4 dns_tunnel

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **YES (live)** | `scenarios/dns_tunnel/executor.py` L122–125: `DnsClient(mode=live).query()` |
| 2 | Target Host? | **YES** | `select_tunnel_targets()` → targets.hosts |
| 3 | 응답 대기? | **YES** | `dns/client.py` L69 recvfrom, profile timeout 0.05–0.1s |
| 4 | 응답 없으면 종료? | **NO** | chunk loop 완료까지 |
| 5 | 응답 성공 = 성공? | **NO** | `tunnel_validation.py` L35–38: chunk + query_sent only |
| 6 | Attempt만 Event? | **PARTIAL** | chunk_created before query; tunnel_query_sent after query |
| 7 | Response 이후에만? | **NO** | — |
| 8 | 센서 트래픽? | **YES** | raw UDP/53 tunnel FQDN pattern |
| 9 | Profile? | **YES** | `traffic_profiles.py` L18–41: chunks/payload_mb/hosts |
| 10 | Host Direct? | **YES** | — |
| 11 | Webshell? | manifest `remote_capable` — scenario manifest 확인 필요 |
| 12 | Charter | **COMPLIANT** | traffic sent 기준 validation |

---

### 3.5 dga

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **YES (live)** | `scenarios/dga/executor.py`: `client.query(resolver, fqdn)` |
| 2 | Target Host? | **YES** | `select_dga_resolver()` |
| 3 | 응답 대기? | **YES** | `dns/client.py` recvfrom |
| 4 | 응답 없으면 종료? | **NO** | — |
| 5 | 응답 성공 = 성공? | **YES** | `dga_validation.py` L44–47: nxdomain **AND** resolved 각 min 1 |
| 6 | Attempt만 Event? | **PARTIAL** | domain_generated before query |
| 7 | Response 이후에만? | **NO** | — |
| 8 | 센서 트래픽? | **YES** | NXDOMAIN + resolvable 2-phase DNS |
| 9 | Profile? | **YES** | `traffic_profiles.py` L43–47: phase1/phase2 counts |
| 10 | Host Direct? | **YES** | — |
| 11 | Webshell? | **NO** (local executor) | — |
| 12 | Charter | **PARTIAL** | 트래픽 생성 OK. **validation이 resolver response outcome에 강하게 의존** |

---

### 3.6 http_followup

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **YES (live)** | `http/client.py` L49–50 urllib open |
| 2 | Target Host? | **YES** | `executor.py` L48 `select_followup_hosts()` |
| 3 | 응답 대기? | **YES** | L50 timeout + L64 `resp.read(1024)` |
| 4 | 응답 없으면 종료? | **NO** | timeout → error event, 다음 요청 |
| 5 | 응답 성공 = 성공? | **NO** | `http/validation.py` L35–37: request_sent only |
| 6 | Attempt만 Event? | **YES (sent)** | L103–115: `http_request_sent` **before** I/O |
| 7 | Response 이후에만? | **NO** | outcome after I/O |
| 8 | 센서 트래픽? | **YES** | HTTP GET fixed paths |
| 9 | Profile? | **YES** | `traffic_profiles.py` L48–52 |
| 10 | Host Direct? | **YES** | — |
| 11 | Webshell? | **NO** | — |
| 12 | Charter | **COMPLIANT** | sent 기준 validation, live HTTP |

---

### 3.7 kerberos_failure

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **YES (live)** | `kerberos/client.py` L108 `sendto` UDP AS-REQ |
| 2 | Target Host? | **YES** | `executor.py` L34 default `10.10.10.30` |
| 3 | 응답 대기? | **YES** | L110 `recvfrom`; L126 TimeoutError |
| 4 | 응답 없으면 종료? | **NO** | timeout → auth_failed outcome |
| 5 | 응답 성공 = 성공? | **NO (outcome)** | validation: auth_failed min 1; **timeout도 auth_failed** (`client.py` L126–139) |
| 6 | Attempt만 Event? | **YES (attempt)** | executor: connection/auth attempt before I/O |
| 7 | Response 이후에만? | **NO** | — |
| 8 | 센서 트래픽? | **YES** | UDP/88 AS-REQ probe |
| 9 | Profile? | **YES** | `traffic_profiles.py` L68–72 |
| 10 | Host Direct? | **YES** | — |
| 11 | Webshell? | **NO** | — |
| 12 | Charter | **COMPLIANT** | UDP 전송 + auth_failed (timeout 포함) validation |

---

### 3.8 ldap_enumeration

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **YES (live)** | TCP connect + bind bytes (`ldap/client.py` L37–49); ldapsearch subprocess L83 |
| 2 | Target Host? | **YES** | `select_ldap_hosts()` |
| 3 | 응답 대기? | **YES** | L49 recv; L83 subprocess.run timeout |
| 4 | 응답 없으면 종료? | **NO** | — |
| 5 | 응답 성공 = 성공? | **NO** | `ldap_validation.py` L72–75: connection + bind/search **attempt** (sent) |
| 6 | Attempt만 Event? | **YES (attempt)** | executor: attempt events before I/O |
| 7 | Response 이후에만? | **NO** | — |
| 8 | 센서 트래픽? | **YES** | LDAP bind/search patterns |
| 9 | Profile? | **YES** | `traffic_profiles.py` L78–82 |
| 10 | Host Direct? | **YES** | — |
| 11 | Webshell? | **NO** | — |
| 12 | Charter | **COMPLIANT** | attempt sent 기준 |

---

### 3.9 port_sweep

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **YES (live)** | `recon/client.py` L52 `create_connection` |
| 2 | Target Host? | **YES** | `select_port_sweep_hosts()` |
| 3 | 응답 대기? | **YES** | TCP handshake timeout |
| 4 | 응답 없으면 종료? | **NO** | refused/timeout → failure event |
| 5 | 응답 성공 = 성공? | **NO** | `port_sweep_validation.py` L54–57: probe + attempt |
| 6 | Attempt만 Event? | **YES (probe_sent)** | executor: probe_sent before probe |
| 7 | Response 이후에만? | **NO** | — |
| 8 | 센서 트래픽? | **YES** | TCP SYN/connect attempts |
| 9 | Profile? | **YES** | `traffic_profiles.py` L63–67 |
| 10 | Host Direct? | **YES** | — |
| 11 | Webshell? | **NO** | — |
| 12 | Charter | **COMPLIANT** | — |

---

### 3.10 smb_login_failure

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **YES (제한)** | `smb/client.py` L54 TCP connect only — **SMB auth 프로토콜 미구현** |
| 2 | Target Host? | **YES** | `select_smb_hosts()` |
| 3 | 응답 대기? | **YES** | TCP handshake |
| 4 | 응답 없으면 종료? | **NO** | — |
| 5 | 응답 성공 = 성공? | **YES (outcome)** | validation auth_failed min 1; connection_refused 시 auth_failed event **없음** (`smb_events.py` L204–228) |
| 6 | Attempt만 Event? | **YES (auth_attempt)** | before I/O |
| 7 | Response 이후에만? | **NO** | — |
| 8 | 센서 트래픽? | **PARTIAL** | TCP/445 only, not SMB negotiation |
| 9 | Profile? | **YES** | `traffic_profiles.py` L73–77 |
| 10 | Host Direct? | **YES** | — |
| 11 | Webshell? | **NO** | — |
| 12 | Charter | **PARTIAL** | TCP connect는 생성. validation은 reachable host 필요. real SMB failure traffic 아님 |

---

### 3.11 sql_injection

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **YES (live)** | HTTP GET via HttpClient |
| 2 | Target Host? | **YES** | `select_sqli_hosts()` |
| 3 | 응답 대기? | **YES** | HttpClient timeout + read |
| 4 | 응답 없으면 종료? | **NO** | — |
| 5 | 응답 성공 = 성공? | **NO** | `sqli_validation.py` L35–38: payload + request_sent |
| 6 | Attempt만 Event? | **YES (sent)** | payload_generated + request_sent before I/O |
| 7 | Response 이후에만? | **NO** | — |
| 8 | 센서 트래픽? | **YES** | SQLi pattern HTTP requests |
| 9 | Profile? | **YES** | `traffic_profiles.py` L58–62 |
| 10 | Host Direct? | **YES** | — |
| 11 | Webshell? | **NO** | — |
| 12 | Charter | **COMPLIANT** | — |

---

### 3.12 ssh_failure

| # | 질문 | 답 | 코드 근거 |
|---|------|-----|-----------|
| 1 | 실제 패킷? | **YES (live)** | `ssh/client.py` L99 subprocess `ssh` |
| 2 | Target Host? | **YES** | `select_ssh_hosts()` |
| 3 | 응답 대기? | **YES** | L99–104 subprocess.run timeout |
| 4 | 응답 없으면 종료? | **NO** | TimeoutExpired → timeout outcome |
| 5 | 응답 성공 = 성공? | **YES (outcome)** | validation auth_failed min 1; connection_refused → `ssh_connection_error` not auth_failed (`ssh/events.py` L166–185) |
| 6 | Attempt만 Event? | **YES (auth_attempt)** | before I/O |
| 7 | Response 이후에만? | **NO** | — |
| 8 | 센서 트래픽? | **YES** | SSH auth attempt (invalid user) |
| 9 | Profile? | **YES** | `traffic_profiles.py` L53–57 |
| 10 | Host Direct? | **YES** | — |
| 11 | Webshell? | **NO** | — |
| 12 | Charter | **PARTIAL** | 트래픽 시도 OK. unreachable target 시 validation FAIL (outcome 의존) |

---

## 4. Protocol Audit

### 4.1 프로토콜별 요약

| Protocol | Send | Timeout | Retry | Response Dependency | Event Timing | Hang Risk | Infinite Wait |
|----------|------|---------|-------|---------------------|--------------|-----------|-----------------|
| **DNS** | UDP sendto (`dns/client.py` L67) | sock.settimeout (L66), default 2.0s | **None** | recvfrom for outcome classification | After query: sent + outcome batch | **Low** — bounded timeout | **No** |
| **HTTP** | urllib open (`http/client.py` L49) | timeout param, default 10s | **None** | read(1024) for response | sent before I/O; outcome after | **Low** | **No** |
| **SSH** | subprocess ssh (L99) | timeout param | **None** | stdout/stderr capture | attempt before; outcome after | **Low** | **No** — subprocess timeout |
| **LDAP** | TCP sendall bind (L48); ldapsearch subprocess | sock + subprocess timeout | **None** | recv(4096) for bind | attempt before; outcome after | **Low** | **No** |
| **SMB** | TCP create_connection only | timeout on connect | **None** | connect result only | attempt before; outcome after | **Low** | **No** |
| **Kerberos** | UDP sendto AS-REQ (L108) | sock.settimeout | **None** | recvfrom optional | attempt before; outcome after | **Low** | **No** |
| **Port Sweep** | TCP create_connection | timeout | **None** | connect handshake | probe_sent before | **Low** | **No** |

### 4.2 Blocking I/O 패턴 검색 결과

| Pattern | Production Protocol Code | Response-Dependent Success? |
|---------|-------------------------|----------------------------|
| `recvfrom(` | `dns/client.py` L69, `kerberos/client.py` L110 | Outcome classification only; executor continues. Validation mostly sent-based except dga/dns_dummy |
| `recv(` | `ldap/client.py` L49 | Bind outcome; validation uses attempt sent |
| `read(` | `http/client.py` L64 | Response body read; validation uses request_sent |
| `readline(` | **Not found** in protocol clients | — |
| `communicate(` | **Not found** | — |
| `wait(` | **Not found** in protocol clients | — |
| `join(` | Test fixture only (`webshell_test_server.py` L111) | — |
| `poll(` | **Not found** | — |
| `select(` | **Not found** | — |
| `subprocess.run(` | `ssh/client.py` L99, `ldap/client.py` L83 | Outcome for event type; SSH/SMB validation needs auth_failed outcome |

**Hang 가능성:** 모든 프로토콜 클라이언트에 bounded timeout 존재. unbounded wait 패턴 **미발견**.

**Infinite wait:** **없음** (코드 기준).

### 4.3 Webshell HTTP Transport (별도)

- `RealHttpTransport` — retry with backoff (`real_http_transport.py` L192–226)
- Default `max_retries=0` (`webshell_config.py`)
- Delivery-only semantics — HTTP success ≠ remote command success

---

## 5. Traffic vs Response Dependency Audit

| 시나리오 | 분류 | 근거 |
|----------|------|------|
| dummy | **A** | Synthetic events, no network |
| dns_dummy | **A** (mock) / validation **B** | Always mock; validation requires dns_response_count |
| dns_transport_dummy | **C** | Live send + wait; validation sent-only |
| dns_tunnel | **C** | Send + wait; validation sent/chunk |
| dga | **C** | Send + wait; validation **requires nxdomain AND resolved (B-like validation)** |
| http_followup | **C** | sent before I/O; validation sent-only |
| kerberos_failure | **C** | send + optional recv; validation auth_failed (timeout counts) |
| ldap_enumeration | **C** | attempt before I/O; validation attempt-based |
| port_sweep | **C** | probe before connect; validation probe-based |
| smb_login_failure | **C** | TCP connect; validation auth_failed (connection error fails validation) |
| sql_injection | **C** | sent before I/O; validation sent-only |
| ssh_failure | **C** | attempt before ssh; validation auth_failed (connection error fails validation) |

**Charter 기준 (`Success = Traffic Generated`) 위반 후보:**

| 시나리오 | 문제 |
|----------|------|
| dns_dummy | Live traffic 불가 + response validation |
| dga | Validation requires specific DNS response types |
| ssh_failure | Unreachable host: traffic attempted but validation FAILED |
| smb_login_failure | Same as SSH for connection_refused |
| dns_dummy manifest | `dns_response_count min: 3` even in dry-run |

---

## 6. Dry Run Audit

### 6.1 pytest PASS ≠ Live Traffic

**결론: pytest PASS는 실제 target_net 트래픽 생성을 검증하지 않는다.**

| 패턴 | 설명 | 예시 |
|------|------|------|
| dry-run only | `dry_run=True`, synthetic/mock events | `tests/scenarios/test_dummy_e2e.py` |
| mock-patched live | `dry_run=False` + patch socket/urllib/subprocess | `tests/scenarios/test_dns_tunnel_e2e.py` L35–54 |
| store injection | EventStore manual append → validation only | `tests/validation/test_path_equality.py` |
| localhost webshell mock | In-process HTTP server | `tests/e2e/fixtures/webshell_test_server.py` L24 |

**real traffic generation 테스트: 0건**

### 6.2 시나리오별 테스트 분류

| 시나리오 | dry-run E2E | live E2E (mocked I/O) | Path Equality | Protocol Unit |
|----------|:-----------:|:---------------------:|:-------------:|:-------------:|
| dummy | ✅ | ❌ | ✅ | ✅ |
| dns_dummy | ✅ | ❌ | ✅ | ✅ |
| dns_transport_dummy | ✅ | ✅ mock DNS | — | ✅ |
| dns_tunnel | ✅ | ✅ mock DNS | ✅ | ✅ |
| dga | ✅ | ✅ mock DNS | ✅ | ✅ |
| http_followup | ✅ | ✅ mock urllib | ✅ | ✅ |
| kerberos_failure | ✅ | ✅ mock UDP | ✅ | ✅ |
| ldap_enumeration | ✅ | ✅ mock socket | ✅ | ✅ |
| port_sweep | ✅ | ✅ mock TCP | ✅ | ✅ |
| smb_login_failure | ✅ | ✅ mock socket | ✅ | ✅ |
| sql_injection | ✅ | ✅ mock urllib | ✅ | ✅ |
| ssh_failure | ✅ | ✅ mock subprocess | ✅ | ✅ |

### 6.3 전체 테스트 파일 분류 (113 files)

| 분류 | 약식 count | 비고 |
|------|-----------|------|
| dry-run only | ~12 | dummy, dns_dummy, release e2e |
| mock only | ~28 | webshell, remote collector, stellar mock |
| unit only | ~35 | protocols, validation, event_store |
| integration only | ~13 | RunManager scenario E2E |
| platform only | ~19 | webshell transport, runtime contract |
| **real traffic generation** | **0** | — |

Live validation은 `docs/runtime/LIVE_VALIDATION_CHECKLIST.md` 수동 절차에 의존.

---

## 7. Webshell Audit

### 7.1 WBS 항목 대비 구현

| WBS 항목 | 구현 상태 | 코드 근거 |
|----------|-----------|-----------|
| Real JSP Execution | **PARTIAL** | `jsp/jsp_runtime.py` L78–109: HTTP GET/POST to webshell. `delivery_only: True` — HTTP delivery success only |
| Real PHP Execution | **PARTIAL** | `php/php_command_encoder.py` — same cmd param pattern |
| Real ASPX Execution | **PARTIAL** | `aspx/aspx_command_encoder.py` — same pattern |
| Remote Scenario Runner | **PARTIAL** | Class `RemoteScenarioRunner` exists (`remote/runner.py` L20–37). Command `dsp-remote-scenario` (`remote/payload.py` L10). **Binary NOT in repo** — pyproject entry point `dsp` only (L16–17) |
| Remote Event Collection | **COMPLIANT (code path)** | `RemoteEventCollector.collect()` (`remote/collector.py` L40–71). Tested with mocks |
| Remote Traffic Generation | **EXTERNAL DEPEND** | DSP sends command string only; traffic on remote host requires `dsp-remote-scenario` + lab infra |

### 7.2 확인 질문

| # | 질문 | 답 | 근거 |
|---|------|-----|------|
| 1 | 실제 원격 명령 실행? | **PARTIAL** | HTTP transport delivers command to webshell URL. No command output parsing |
| 2 | 실제 JSP? | **PARTIAL** | Requires external JSP webshell server in lab |
| 3 | 실제 PHP? | **PARTIAL** | Same |
| 4 | 실제 ASPX? | **PARTIAL** | Same |
| 5 | Remote Scenario Runner 존재? | **YES (class)** / **NO (binary)** | `RemoteScenarioRunner` + missing `dsp-remote-scenario` |
| 6 | 실제 원격 트래픽 생성? | **NO (in-repo)** | `WebshellExecutionProvider.capabilities()` traffic_origin=remote_host; depends on external runner |
| 7 | Event Bundle Collection? | **YES** | `EventSyncBridge.sync_bundle()` + operational_runner auto-collect in webshell mode |
| 8 | Charter | **PARTIAL** | Transport + bundle wiring exist; end-to-end live remote path unverified |

### 7.3 RunManager vs Operational Runner

| 경로 | Local | Webshell |
|------|-------|----------|
| `RunManager` | ✅ hardcoded local L169 | ❌ not integrated |
| `operational_runner.run_local_lab()` | ✅ | — |
| `operational_runner.run_webshell_lab()` | — | ✅ execute + collect + export |

---

## 8. Charter Compliance Matrix

감사 기준: `Success = Traffic Generated`; DSP ≠ Detection Engine.

| 항목 | 평가 | 근거 |
|------|------|------|
| Generate Scenario Traffic | **PARTIAL** | 10/12 live-capable. `dummy`/`dns_dummy` no network. SMB TCP-only |
| Collect Execution Events | **COMPLIANT** | EventStore append-only SQLite (`event_store/store.py` L89–127) |
| Store Events | **COMPLIANT** | Per-run `events.db`, export JSONL |
| Export Evidence | **COMPLIANT** | `EvidenceExporter` → JSON + Markdown (`evidence/exporter.py`) |
| Support Manual Verification | **COMPLIANT** | `ManualVerificationPackageGenerator` — checklist, notes, summary template |
| Local Provider | **COMPLIANT** | `LocalExecutionProvider` → `run_scenario()` (`local_provider.py` L14–46) |
| Webshell Provider | **PARTIAL** | Implemented; not in RunManager; delivery-only |
| Real JSP Execution | **PARTIAL** | HTTP transport only; no in-repo webshell server |
| Real PHP Execution | **PARTIAL** | Same |
| Real ASPX Execution | **PARTIAL** | Same |
| Remote Scenario Runner | **PARTIAL** | Class + payload; no `dsp-remote-scenario` package |
| Remote Event Collection | **COMPLIANT** | `RemoteEventCollector` + tests |
| Evidence Export | **COMPLIANT** | operational_runner integrates export |
| Manual Verification Package | **COMPLIANT** | Generator + templates |

**Detection Engine 분리:** Scenario validation does not call Stellar/detection adapters. `--confirm-detection` is optional post-validation (`run_manager.py` L206–219). **COMPLIANT** with "DSP ≠ Detection Engine" for default run path.

---

## 9. Release Readiness Assessment

### 9.1 질문별 평가

| # | 질문 | 답 | 근거 |
|---|------|-----|------|
| 1 | Platform Ready? | **NOT READY** | Package version 1.1.0 not 1.2.0. Core platform functional but version/charter doc gap |
| 2 | Traffic Generator Ready? | **NOT READY** | dns_dummy live blocked; dga/ssh/smb validation outcome-dependent; SMB not real SMB |
| 3 | Operationally Ready? | **NOT READY** | operational_runner exists; no automated live traffic CI; webshell path incomplete |
| 4 | Lab Validation Ready? | **PARTIAL** | LIVE_VALIDATION_CHECKLIST.md exists; manual only; pytest does not prove live traffic |
| 5 | Release Ready? | **NOT READY** | Blockers below |

---

## 10. Blockers

### BLOCKER — 실제 트래픽 생성 방해

| ID | 문제 | 근거 |
|----|------|------|
| B1 | `dns_dummy` live UDP 전송 불가 | `executor.py` L21: always `mock=True` |
| B2 | `dsp-remote-scenario` 미존재 | `remote/payload.py` L10; pyproject L16–17 — webshell remote traffic path broken in-repo |
| B3 | pytest가 live traffic 미검증 | 0 real traffic tests; mock-only PASS |

### HIGH

| ID | 문제 | 근거 |
|----|------|------|
| H1 | DGA validation requires nxdomain AND resolved | `dga_validation.py` L44–47 — lab resolver config required |
| H2 | dns_dummy validation requires dns_response_count | `dns_dummy/manifest.yaml` L48–52 |
| H3 | SSH validation fails on connection_refused | `ssh/events.py` L176–185 vs `ssh/validation.py` L37 |
| H4 | SMB validation fails on connection_refused | `smb_events.py` L204–216 vs `smb_validation.py` L37 |
| H5 | RunManager webshell 미통합 | `run_manager.py` L169 local only |

### MEDIUM

| ID | 문제 | 근거 |
|----|------|------|
| M1 | SMB TCP connect only — not SMB auth traffic | `smb/client.py` L65 note |
| M2 | DNS events emitted after query complete, not at send | `dns/events.py` L82–95 after `client.query()` |
| M3 | Required charter docs missing from repo | find: no PRODUCT-CHARTER, MASTER-WBS, GUARDRAIL |
| M4 | PROJECT_CHARTER vs audit criteria conflict | PROJECT_CHARTER L47 vs user Success=Traffic Generated |

### LOW

| ID | 문제 | 근거 |
|----|------|------|
| L1 | DSP package version 1.1.0 vs audit label v1.2.0 | `pyproject.toml` L3 |
| L2 | dummy scenario notes say dry-run even in live | `scenario.py` L75 |

---

## 11. Recommended Fix Priority

| Priority | Action | Rationale |
|----------|--------|-----------|
| P0 | Add/commit missing charter docs OR document authoritative source | Audit baseline undefined in repo |
| P0 | Implement or package `dsp-remote-scenario` | Webshell remote path blocked |
| P0 | Fix `dns_dummy` to support live mode OR remove from live operational matrix | B1 |
| P1 | Align validation profiles with Traffic Generated principle (dga, ssh, smb, dns_dummy) | H1–H4 |
| P1 | Add opt-in live traffic integration tests (lab-gated) | B3 |
| P1 | Integrate webshell provider into RunManager OR document operational_runner as sole remote entry | H5 |
| P2 | Implement real SMB negotiation for smb_login_failure | M1 |
| P2 | Emit dns_query_sent at send time (before recv) | M2 accuracy |
| P3 | Align package version to v1.2.0 when releasing | L1 |

---

## 12. Final Verdict

```
DSP v1.2.0

Platform Status:
NOT READY

Traffic Generator Status:
NOT READY

Operational Status:
NOT READY

Release Status:
NOT READY

Overall Assessment:

코드베이스는 Local Execution Provider 경로에서 10개 시나리오(dns_transport_dummy,
dns_tunnel, dga, http_followup, kerberos_failure, ldap_enumeration, port_sweep,
smb_login_failure, sql_injection, ssh_failure)가 dry_run=False 시 실제 네트워크 I/O를
수행하는 구현을 갖추고 있다. Event Store 기반 validation/reporting/evidence export/
manual verification 패키지 생성 경로는 동작한다.

그러나 (1) 요청된 3개 Charter/WBS 문서가 저장소에 없고, (2) DSP 패키지 버전은 1.1.0이며,
(3) dns_dummy는 live 트래픽을 생성할 수 없고, (4) dga/ssh/smb/dns_dummy validation이
response/outcome에 의존하여 "Traffic Generated = Success" 원칙과 불일치하며,
(5) webshell remote path는 dsp-remote-scenario 바이너리 부재로 end-to-end 미완성,
(6) pytest 113개 파일 전부 mock/dry-run/store-injection 기반이며 실제 lab 트래픽을
검증하지 않는다.

Detection confirmation(--confirm-detection)은 optional이며 시나리오 success 판정과
분리되어 있어 "DSP ≠ Detection Engine" 원칙에는 부합한다.

v1.2.0 Release Ready 판정: NOT READY.
```

---

*End of audit document. No code was modified during this audit.*
