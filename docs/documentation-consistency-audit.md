# DSP v1.2.0 Documentation Consistency Audit

**Audit Date:** 2026-06-09  
**Audit Type:** Read-only 2차 감사 (코드·문서 근거만)  
**Repository:** `/home/aella/xdr-lab-appliance`  
**Primary Code Root:** `detection-scenario-platform/`

---

## 1. Document Discovery

| 문서 | 저장소 존재 | 경로 | 비고 |
|------|:-----------:|------|------|
| `PROJECT_CHARTER` | **YES** | `detection-scenario-platform/PROJECT_CHARTER.md` (canonical) | README L58: `docs/detection-scenario-platform/`는 Historical Draft |
| `PROJECT_CHARTER` (draft) | **YES** | `docs/detection-scenario-platform/PROJECT_CHARTER.md` | canonical과 동일 §2 철학 문구 포함 |
| `PRODUCT_CHARTER` | **NO** | — | `PRODUCT-CHARTER.md`, `PRODUCT_CHARTER.md` 등 전체 검색 결과 없음 |
| `MASTER_WBS` | **NO** | — | `MASTER-WBS.md`, `MASTER_WBS.md` 등 전체 검색 결과 없음 |

1차 감사(`docs/operational-design-audit-v1.2.0.md` L16–23)와 동일하게, `PRODUCT_CHARTER`·`MASTER_WBS`는 저장소에 **존재하지 않는다**.

---

## 2. 필수 확인: "DSP는 Traffic Generator가 아니다"

### 존재 여부: **YES**

| 파일 | 라인 | 원문 |
|------|------|------|
| `detection-scenario-platform/PROJECT_CHARTER.md` | 47 | `> DSP는 Traffic Generator가 아니라 **Detection Scenario Platform**이다.` |
| `docs/detection-scenario-platform/PROJECT_CHARTER.md` | 28 | `> DSP는 Traffic Generator가 아니라 **Detection Scenario Platform**이다.` |

### 관련 맥락 (동일 문서)

- `detection-scenario-platform/PROJECT_CHARTER.md` L24: 향후 통합은 "PoC Traffic Generator 완료 **이후**"
- `detection-scenario-platform/PROJECT_CHARTER.md` L196–197 (P4): Traffic Generator는 시나리오 executor 역할로 **분리** 정의
- `detection-scenario-platform/PROJECT_CHARTER.md` L332: "원격 실행 (webshell) | Phase 1은 local executor; remote는 Phase 2 adapter"

---

## 3. 항목별 비교 표

아래 `PRODUCT`·`WBS` 열은 저장소 내 문서가 없으므로, 1차 감사에서 명시된 운영 기준(감사 요청서에 기재된 기대값)을 **외부 기준**으로 표기한다. 저장소에서 해당 문구를 찾을 수 없는 항목은 `NOT IN REPO`로 기록한다.

| 항목 | PROJECT | PRODUCT | WBS | 충돌 여부 |
|------|---------|---------|-----|-----------|
| **Mission** | 탐지 검증·재현 가능성·확장성·안전성 (L38–43) | NOT IN REPO | NOT IN REPO | **PARTIAL CONFLICT** — PROJECT는 "Detection Scenario Platform"; 1차 기준은 Traffic Generator / Scenario Runner / Event Collector / Evidence Generator 역할 강조 |
| **DSP란 무엇인가** | "Detection Scenario Platform" — Traffic Generator **아님** (L47) | NOT IN REPO (1차: DSP = Traffic Generator) | NOT IN REPO | **MAJOR CONFLICT** — PROJECT §2 vs 1차 PRODUCT 기대 |
| **Success Criteria** | Event Store SOT, lifecycle 준수, stdout-only FAIL (L230–238) | NOT IN REPO (1차: Success = Traffic Generated) | NOT IN REPO | **MAJOR CONFLICT** — PROJECT는 validation/SOT 중심; 1차 PRODUCT는 traffic 생성 = success |
| **Validation Philosophy** | P1 Unified Path: Execution = Validation = Reporting = Event Store (L175–181) | NOT IN REPO | NOT IN REPO | **CONSISTENT** (저장소 내 구현과 일치, 아래 §4) |
| **Reporting Philosophy** | Event Store + ValidationResult only (DEFINITION_OF_DONE.md L53–59) | NOT IN REPO | NOT IN REPO | **CONSISTENT** (저장소 내) |
| **Release Completion Criteria** | Phase 1 MVP 체크리스트 (PROJECT L232–238); DEFINITION_OF_DONE.md | NOT IN REPO | NOT IN REPO | **PARTIAL CONFLICT** — formal release gate 문서 없음; README는 Release 1.1.0, pyproject는 1.1.0 |
| **Remote Execution 정의** | Phase 1 local; remote Phase 2 (PROJECT L332); EXECUTION_MODEL_SPEC.md Mode B | NOT IN REPO | NOT IN REPO (1차: Real JSP/PHP/ASPX, Remote Scenario Runner) | **PARTIAL CONFLICT** — PROJECT는 remote를 Phase 2로 미룸; 코드는 webshell/remote 모듈 존재하나 RunManager 미통합 |

### 종합 Documentation Status

```
CONFLICTED
```

**근거:**
1. `PRODUCT_CHARTER`·`MASTER_WBS` 부재 — 3문서 교차 검증 불가
2. `PROJECT_CHARTER` L47 "Traffic Generator가 아님" ↔ 1차 감사 PRODUCT 기대("DSP is Traffic Generator") 직접 상충
3. `PROJECT_CHARTER` L332 (remote = Phase 2) ↔ 코드베이스에 `dsp/execution/remote/`, `WebshellExecutionProvider` 존재 — 설계 문서와 구현 시점 불일치

---

## 4. 저장소 내 대체 문서 (WBS 유사 항목)

`MASTER_WBS`가 없으나, WBS 유사 항목이 아래 문서에 분산 존재한다.

| 문서 | WBS 유사 내용 |
|------|---------------|
| `PHASE_ROADMAP.md` L128–138 | Execution Provider Framework, Webshell Provider 로드맵 |
| `RELEASE_1_0_SUMMARY.md` L16–23 | Local/Webshell execution, RemoteScenarioRunner, RemoteEventCollector |
| `docs/architecture/EXECUTION_MODEL_SPEC.md` | Mode A (local) / Mode B (remote) 정의 |
| `docs/architecture/JSP_WEBSHELL_EXECUTION_SPEC.md` L41 | PHP, ASPX, Remote Scenario Runner 범위 언급 |

이 문서들은 `MASTER_WBS`를 대체하지 않으며, formal WBS ID·완료 기준 매핑이 없다.

---

## 5. 핵심 질문 4번 답변

**PROJECT_CHARTER · PRODUCT_CHARTER · MASTER_WBS 사이 설계 충돌 존재 여부:**

| 판정 | **YES — CONFLICTED** |
|------|----------------------|
| 저장소 내 확인 가능한 충돌 | PROJECT §2 ("Traffic Generator 아님") vs 1차 PRODUCT 기대 ("Traffic Generator") |
| 저장소 내 확인 불가 | PRODUCT_CHARTER·MASTER_WBS 원문 부재로 직접 대조 불가 |
| 추가 불일치 | PROJECT Phase 0 "구현 금지" (L5) vs 현재 `dsp/` 전체 구현 존재; PROJECT remote=Phase 2 (L332) vs `dsp/execution/remote/` 구현 존재 |

---

## 6. 결과 분류 요약

| 범위 | 결과 |
|------|------|
| PROJECT vs PRODUCT (1차 기준) | **MAJOR CONFLICT** |
| PROJECT vs WBS (1차 기준) | **PARTIAL CONFLICT** (remote 항목: 코드는 부분 구현, PROJECT는 Phase 2) |
| PROJECT vs 저장소 구현 | **PARTIAL CONFLICT** (remote·webshell 구현이 charter Phase 정의보다 앞섬) |
| Validation/Reporting 철학 (PROJECT vs 코드) | **CONSISTENT** |
