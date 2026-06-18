---
description: "Run structured authority surface audit — mint, freeze, metadata, upgrade, multisig — output Authority Surface Report"
---

Run an **Authority Surface Audit** using the **authority-surface-ops** skill.

## Step 1 — Collect inputs

Ask if missing:

1. Cluster (`mainnet-beta` | `devnet`)
2. Asset list: mints, program IDs, multisig vaults
3. Mode: `launch_gate` | `weekly` | `point_check` | `drift`
4. Token model (for mints): `fixed-supply` | `stablecoin` | `program-controlled`
5. Baseline JSON path (required for `drift`)

## Step 2 — Load skill routing

Read from `../skills/authority-surface-ops/`:

1. [SKILL.md](../skills/authority-surface-ops/SKILL.md) — output schema
2. Mode file:
   - `launch_gate` → [launch-checklist.md](../skills/authority-surface-ops/launch-checklist.md)
   - `weekly` → [weekly-review.md](../skills/authority-surface-ops/weekly-review.md)
   - `drift` → [authority-drift.md](../skills/authority-surface-ops/authority-drift.md)

Compare output structure to [examples/reports/](https://github.com/farhanqaz/authority-surface-ops-skill/tree/main/examples/reports) when unsure.

## Step 3 — Surface reads

For each asset, apply:

- Mints → [mint-freeze-authority.md](../skills/authority-surface-ops/mint-freeze-authority.md)
- Metadata → [metadata-authority.md](../skills/authority-surface-ops/metadata-authority.md)
- Programs → [upgrade-authority.md](../skills/authority-surface-ops/upgrade-authority.md)
- Pending multisig → [multisig-verification.md](../skills/authority-surface-ops/multisig-verification.md)

Use RPC / Helius MCP / explorer — list every address checked.

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

- Any `critical` finding on mainnet → [incident-handoff.md](../skills/authority-surface-ops/incident-handoff.md)
- Code vulnerability suspected → audit skills (do not duplicate audit checklists here)

## Step 6 — Human signoff

For `launch_verdict: go`, require named approvers in `signed_off_by`.

---

Do not include: treasury advice, payroll, governance analysis, or public announcement drafts.
