---
name: authority-surface-ops
description: Live on-chain admin surface operations for Solana builders — mint/freeze/metadata/upgrade authority verification, multisig pre-sign checks, authority drift detection, launch-week and weekly review cadences, and incident escalation handoff. Extends solana-dev-skill for ops; does NOT replace security audits or token creation.
user-invocable: true
---

# Authority Surface Ops Skill

> **Extends**: [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill) for program/client context only.
> **Does NOT replace**: Trail of Bits / safe-solana-builder (code audit), token-engineer (token creation).

## What This Skill Is For

Use when the user asks about **live admin surfaces on-chain** — not how to write programs.

## When NOT to Use (route elsewhere)

| User need | Route to |
|-----------|----------|
| Audit Anchor/Rust source code | Trail of Bits / safe-solana-builder / solana-dev → security.md |
| Create or configure a token | token-engineer / solana-dev |
| Debug a user's failed wallet transaction | `/debug-user-tx` (kit) |
| Treasury runway or payroll | Out of scope |
| DAO governance voting strategy | Out of scope |

Example reports: [examples/reports/](https://github.com/farhanqaz/authority-surface-ops-skill/tree/main/examples/reports)

| Trigger phrases | Route to |
|-----------------|----------|
| "revoke mint authority", "who can mint", "freeze authority" | [mint-freeze-authority.md](mint-freeze-authority.md) |
| "metadata authority", "update URI", "Metaplex authority" | [metadata-authority.md](metadata-authority.md) |
| "upgrade authority", "program upgradeable", "immutable program" | [upgrade-authority.md](upgrade-authority.md) |
| "Squads before sign", "multisig verification", "Realms proposal" | [multisig-verification.md](multisig-verification.md) |
| "authority changed", "drift", "diff since last week" | [authority-drift.md](authority-drift.md) |
| "launch checklist", "before mainnet", "day-0 authorities" | [launch-checklist.md](launch-checklist.md) |
| "weekly authority review", "ops cadence" | [weekly-review.md](weekly-review.md) |
| "authority anomaly", "possible exploit", "escalate" | [incident-handoff.md](incident-handoff.md) |

## Default Stack (January 2026)

| Surface | Where it lives | Read via |
|---------|----------------|----------|
| SPL mint/freeze | Mint account | `getAccountInfo` + SPL layout / explorer |
| Token-2022 mint/freeze | Mint account (Token-2022 program) | Same + extension scan |
| Metadata (Metaplex) | Metadata PDA | DAS or Metaplex decode |
| Program upgrade | Program account + ProgramData | `getAccountInfo` on program ID |
| Multisig custody | Squads v4 / Realms | Explorer + proposal simulation |

**Clusters**: Always confirm `mainnet-beta` vs `devnet`. Never assume.

## Operating Procedure

### 1. Classify the engagement

| Mode | When | Primary files |
|------|------|---------------|
| **Launch gate** | Pre-mainnet or launch week | launch-checklist.md → surface-specific files |
| **Weekly ops** | Recurring review | weekly-review.md → authority-drift.md |
| **Point check** | Single mint/program/multisig | Surface-specific file |
| **Anomaly** | Unexpected change detected | incident-handoff.md first |

### 2. Collect minimum inputs

Always ask or infer:

- Cluster
- Asset type: `mint` | `program` | `multisig_proposal`
- Address(es)
- Baseline snapshot (if drift review) — prior JSON or "first review"

### 3. Produce structured output

Every engagement ends with an **Authority Surface Report**:

```yaml
report_version: 1
cluster: mainnet-beta
assets: [...]
findings:
  - id: F-001
    severity: critical | high | medium | low | info
    surface: mint | freeze | metadata | upgrade | multisig
    observation: ""
    recommendation: ""
    blocks_launch: true | false
escalate: none | audit_skill | incident
```

Do **not** draft public announcements or user-facing "your funds are safe" messages.

### 4. Escalation rules

| Condition | Action |
|-----------|--------|
| Critical finding + live mainnet | [incident-handoff.md](incident-handoff.md) |
| Code-level vulnerability suspected | Delegate to solana-dev → security.md or Trail of Bits ext skill |
| Token creation / extensions setup | Delegate to token-engineer (kit agent) |

### 5. Two-strike rule

If RPC/decode fails twice on the same address: STOP, show raw response, ask user for explorer link or corrected address.

---

## Progressive Disclosure

### Surface modules
- [mint-freeze-authority.md](mint-freeze-authority.md) — SPL + Token-2022 mint & freeze holders
- [metadata-authority.md](metadata-authority.md) — Metaplex metadata update authority
- [upgrade-authority.md](upgrade-authority.md) — BPF upgrade authority & immutability
- [multisig-verification.md](multisig-verification.md) — Pre-sign verification for Squads/Realms

### Ops cadences
- [launch-checklist.md](launch-checklist.md) — Launch week gate (day -7 → day +7)
- [weekly-review.md](weekly-review.md) — 30-minute weekly review script
- [authority-drift.md](authority-drift.md) — Baseline diff methodology

### Escalation
- [incident-handoff.md](incident-handoff.md) — Anomaly → war room → audit skills

### Reference
- [resources.md](resources.md) — Program IDs, RPC patterns, snapshot schema

---

## Task Routing Guide

| User asks… | Read first |
|------------|------------|
| Can someone mint more tokens? | mint-freeze-authority.md |
| Is mint authority revoked? | mint-freeze-authority.md |
| Can accounts be frozen? | mint-freeze-authority.md |
| Who can change token metadata/URI? | metadata-authority.md |
| Is our program upgradeable? | upgrade-authority.md |
| Verify Squads tx before I sign | multisig-verification.md |
| What changed since last review? | authority-drift.md |
| Mainnet launch authority gate | launch-checklist.md |
| Weekly ops routine | weekly-review.md |
| Mint authority changed overnight | incident-handoff.md |

---

## Commands & Agents

| Command | Description |
|---------|-------------|
| `/authority-surface-audit` | Structured audit → Authority Surface Report |

| Agent | Purpose |
|-------|---------|
| **authority-ops-engineer** | Executes surface reads, checklists, drift diffs, reports |

---

## Out of scope

Treasury runway, payroll, governance voting, tax/compliance, automated monitoring bots, user transaction support triage, source-code security audits.

See [resources.md](resources.md) for boundaries vs other kit skills.
