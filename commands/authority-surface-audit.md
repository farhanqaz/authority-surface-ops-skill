---
description: "Run structured authority surface audit — mint, freeze, metadata, upgrade, multisig — output Authority Surface Report"
---

Run an **Authority Surface Audit** using the authority-surface-ops skill.

## Step 1 — Collect inputs

Ask if missing:

1. Cluster (`mainnet-beta` | `devnet`)
2. Asset list: mints, program IDs, multisig vaults
3. Mode: `launch_gate` | `weekly` | `point_check` | `drift`
4. Baseline JSON path (required for `drift`)

## Step 2 — Load skill routing

Read in order:

1. [SKILL.md](../skill/SKILL.md) — output schema
2. Mode file:
   - `launch_gate` → [launch-checklist.md](../skill/launch-checklist.md)
   - `weekly` → [weekly-review.md](../skill/weekly-review.md)
   - `drift` → [authority-drift.md](../skill/authority-drift.md)

## Step 3 — Surface reads

For each asset, apply:

- Mints → [mint-freeze-authority.md](../skill/mint-freeze-authority.md)
- Metadata → [metadata-authority.md](../skill/metadata-authority.md)
- Programs → [upgrade-authority.md](../skill/upgrade-authority.md)
- Pending multisig → [multisig-verification.md](../skill/multisig-verification.md)

Use RPC / Helius MCP / explorer — show addresses checked.

## Step 4 — Produce report

Emit YAML **Authority Surface Report**:

```yaml
report_version: 1
mode: launch_gate
cluster: mainnet-beta
assets: [...]
findings: [...]
launch_verdict: go | no-go  # if launch_gate
drift_summary: {...}        # if drift
escalate: none | audit_skill | incident
new_baseline: {...}         # if clean review
```

## Step 5 — Escalate if needed

- Any `critical` finding on mainnet → [incident-handoff.md](../skill/incident-handoff.md)
- Code vulnerability suspected → recommend audit skills (do not duplicate audit)

## Step 6 — Human signoff reminder

For `launch_verdict: go`, remind user: AI does not replace human signoff — record approver names.

---

**Do not include in output**: treasury advice, payroll, governance analysis, public announcement drafts.
