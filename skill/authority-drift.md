# Authority Drift Detection

Detect changes to admin surfaces since a saved baseline.

## Purpose

Weekly ops and incident triage: **what changed?** without automated bots — manual/agent-driven diff.

## Baseline snapshot schema

Store after launch gate or each weekly review (`authority-baseline.json` in repo — **not** secrets):

```json
{
  "version": 1,
  "cluster": "mainnet-beta",
  "captured_at": "2026-06-18T12:00:00Z",
  "assets": {
    "mints": [
      {
        "address": "...",
        "mint_authority": null,
        "freeze_authority": null,
        "metadata_update_authority": "..."
      }
    ],
    "programs": [
      {
        "program_id": "...",
        "upgrade_authority": "..."
      }
    ],
    "multisigs": [
      {
        "vault": "...",
        "threshold": 2,
        "members": ["...", "..."]
      }
    ]
  }
}
```

## Drift procedure

1. Load latest baseline (user provides path or paste).
2. Re-read all surfaces using surface modules.
3. Emit diff:

```yaml
drift:
  - asset: mint:...
    field: mint_authority
    before: null
    after: "7xKX..."
    severity: critical
    action: incident-handoff
  - asset: program:...
    field: upgrade_authority
    before: "SquadsVault..."
    after: "SquadsVault..."
    severity: none
```

## Severity for unexpected changes

| Change | Severity |
|--------|----------|
| Any authority null → non-null | **critical** |
| Authority holder pubkey changed | **critical** |
| Multisig member added/removed | **high** |
| Metadata URI changed | **high** (if not scheduled) |
| Supply increased | **critical** |
| Threshold lowered | **critical** |

## First review (no baseline)

- Run [launch-checklist.md](launch-checklist.md) or [weekly-review.md](weekly-review.md)
- **Create baseline** as deliverable — do not skip

## Storage guidance

- Commit baseline to private repo or password manager attachment
- Never commit private keys; pubkeys only
- Date baseline files: `authority-baseline-2026-06-18.json`

## Output

Always include:

```yaml
drift_summary:
  critical: 0
  high: 0
  unchanged_assets: 3
recommendation: continue | weekly_only | incident-handoff
new_baseline_required: true
```

## Delegation

- If drift + user funds at risk → [incident-handoff.md](incident-handoff.md)
