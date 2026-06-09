# Detection Scenario Platform — Executive Overview

**문서 버전:** 1.0.0 (Phase 17)  
**대상:** Managers, Directors, Customers  
**분량:** 2–3 pages

---

## What Is DSP?

**Detection Scenario Platform (DSP)** is a safe, repeatable platform for validating security detection capabilities. It generates controlled network traffic and authentication patterns, then verifies whether your security platform (Stellar Cyber) detects them.

DSP answers three independent questions for every test:

| Question | State | Meaning |
|----------|-------|---------|
| Did traffic execute? | S1 | Operational (non-authoritative) |
| Was traffic proven? | **S2** | Event Store validation (authoritative) |
| Was it detected? | **S3** | Vendor platform confirmation (optional) |

This separation prevents the common PoC failure mode where "traffic was sent" is mistaken for "detection was validated."

---

## Business Value

### For Security Vendors (Stellar Cyber)

- **Proof of detection:** Demonstrate that Stellar detects real attack patterns, not just theoretical rules
- **Repeatable PoC:** Standardized scenarios produce consistent, auditable results across customer engagements
- **Competitive differentiation:** Evidence-based validation vs. manual traffic generation

### For Customer Organizations

- **Detection assurance:** Verify that purchased security tools actually detect relevant threats
- **Safe testing:** All scenarios run in safe mode — no exploitation, credential theft, or data exfiltration
- **Audit trail:** Every test produces timestamped evidence (Event Store + Stellar API responses) for compliance and reporting

### For Sales & Customer Success Teams

- **No source code required:** Complete operator documentation for scenario selection, execution, and validation
- **Structured demos:** 30-minute executive, 2-hour technical, and full-day PoC flows documented
- **Clear outcomes:** S2/S3 status provides unambiguous pass/fail for PoC reports

---

## How It Works

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐     ┌──────────────┐
│  Scenario   │────▶│  Event Store │────▶│ Validation (S2) │────▶│   Report     │
│  Execution  │     │    (SOT)     │     │   Engine        │     │              │
└─────────────┘     └──────────────┘     └─────────────────┘     └──────────────┘
       │                                                                    │
       │              ┌─────────────────┐     ┌──────────────┐             │
       └─────────────▶│ Stellar API     │────▶│ Detection    │─────────────┘
                      │ Evidence Poll   │     │ Confirm (S3) │
                      └─────────────────┘     └──────────────┘
```

1. **Execute:** DSP runs a scenario plugin (e.g., DNS Tunnel) against lab targets
2. **Record:** All traffic events are stored in Event Store (SQLite, append-only)
3. **Validate (S2):** Validation Engine checks Event Store metrics against success criteria
4. **Confirm (S3):** Detection Adapter polls Stellar API for matching alerts/analytics
5. **Report:** Human-readable report with S2 decision and S3 status

---

## Detection Validation

### What Gets Validated

DSP currently supports **9 production scenarios** covering major detection domains:

| Domain | Scenarios | Detection Signal |
|--------|-----------|------------------|
| DNS | DNS Tunnel, DGA | NDR, DNS analytics |
| Web | HTTP Follow-up, SQL Injection | WAF, NDR, web attack |
| Identity | SSH, SMB, Kerberos failures | Auth failure, identity analytics |
| Reconnaissance | Port Sweep, LDAP Enumeration | Network scan, directory discovery |

### Evidence-Based Verification

S3 detection confirmation uses **evidence-based correlation**, not alert name matching:

- **Run identity:** Evidence tied to specific test run
- **Time window:** Events within test execution window
- **IP entities:** Source and destination IP correlation
- **Detection model:** Scenario type alignment

This approach survives Stellar alert renames, localization, and tenant-specific rule naming.

### S3 Outcomes

| Status | Meaning | PoC Impact |
|--------|---------|------------|
| **S3_CONFIRMED** | Stellar detected correlated evidence | ✅ Detection validated |
| **S3_INCONCLUSIVE** | Partial evidence; manual review needed | ⚠️ Follow-up required |
| **S3_NOT_OBSERVED** | No Stellar evidence found | ❌ Detection gap identified |

**Important:** S3 failure does not invalidate S2. Traffic was proven even if detection was not observed — this is valuable diagnostic information.

---

## Safe Operation

### Safe Mode Guarantees

Every DSP scenario operates under strict safety constraints:

| Constraint | Implementation |
|------------|----------------|
| No exploitation | Controlled traffic patterns only |
| No credential theft | Dummy credentials; auth failures only |
| No data exfiltration | Dummy payloads; no real data transfer |
| No brute force | Limited, bounded attempt counts |
| Network boundary | `target_net_enforced` — lab CIDR only |
| Duration limits | `max_duration_sec` per scenario |
| Event limits | `max_events` cap per run |

### Forbidden Actions (Examples)

- `privilege_escalation`, `valid_credential_use`, `brute_force`
- `data_exfiltration`, `destructive_sql`, `credential_extraction`
- `kerberoasting`, `as_rep_roasting`, `ticket_abuse`
- `exploitation`, `vulnerability_scanning`, `service_fingerprinting`

### Customer Environment Safety

- DSP runs against **lab targets only** (configurable CIDR)
- No production system interaction
- No persistent changes to target systems
- All traffic is identifiable and bounded

---

## PoC Engagement Models

### 30-Minute Executive Demo

**Audience:** CISO, IT Director  
**Scenarios:** DNS Tunnel + SSH Failure  
**Outcome:** Demonstrate safe operation and evidence-based validation

### 2-Hour Technical PoC

**Audience:** SOC Manager, Security Engineer  
**Scenarios:** DNS, Web, Auth (5 scenarios)  
**Outcome:** Multi-domain detection validation with evidence package

### Full-Day Comprehensive Validation

**Audience:** PoC Engineer  
**Scenarios:** All 9 production scenarios  
**Outcome:** Complete detection coverage report with S2/S3 results for all domains

---

## Key Differentiators

| Traditional PoC | DSP PoC |
|-----------------|---------|
| Manual traffic generation | Automated, repeatable scenarios |
| "We sent traffic" | S2: Event Store proof |
| Alert name matching | Evidence-based correlation |
| Ad-hoc documentation | Structured operator catalog |
| Unknown safety boundaries | Explicit safe mode constraints |
| Single-vendor scripts | Vendor-neutral platform (Stellar first) |

---

## Current Status

| Metric | Value |
|--------|-------|
| Production scenarios | 9 |
| Automated tests | 278 passing |
| Stellar integration | Live API + mock |
| Documentation | Complete operator catalog |
| Platform phases | 0–17 complete |

**DSP is ready for customer-facing PoC engagements.**

---

## Next Steps

For operators and engineers:

- [Scenario Catalog](./SCENARIO_CATALOG.md) — Full scenario specifications
- [Customer Demo Guide](./CUSTOMER_DEMO_GUIDE.md) — Execution commands and talking points
- [Lab Execution Runbook](./LAB_EXECUTION_RUNBOOK.md) — End-to-end lab workflow

For technical architecture:

- `detection-scenario-platform/ARCHITECTURE_SPEC.md`
- `detection-scenario-platform/docs/detection/`

---

## Contact & Support

DSP documentation is self-contained in `docs/catalog/`. No source code reading required for scenario execution and validation.

For platform issues, refer to [DETECTION_PLAYBOOKS.md](./DETECTION_PLAYBOOKS.md) troubleshooting sections.
