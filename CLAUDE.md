# Authority Surface Ops

Solana **live admin surface operations** addon for Claude Code. Extends [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill).

> Audit skills review code before ship. This config covers **mint, freeze, metadata, and upgrade authorities** after deploy.

## When to load skills

| User asks… | Read |
|------------|------|
| Mint / freeze authority | `skill/mint-freeze-authority.md` |
| Metadata update authority | `skill/metadata-authority.md` |
| Program upgrade authority | `skill/upgrade-authority.md` |
| Squads pre-sign | `skill/multisig-verification.md` |
| Authority drift | `skill/authority-drift.md` |
| Launch gate | `skill/launch-checklist.md` |
| Weekly review | `skill/weekly-review.md` |
| Authority anomaly | `skill/incident-handoff.md` |

## Agent & command

| Task | Use |
|------|-----|
| Full audit workflow | `/authority-surface-audit` |
| Ops execution | `authority-ops-engineer` agent |

## Rules

1. Confirm cluster before any mainnet read.
2. Every engagement ends in an **Authority Surface Report** (YAML) — schema in `skill/SKILL.md`.
3. Do not draft public "funds are safe" messages.
4. Launch `go` requires named humans in `signed_off_by`.
5. RPC/decode fails twice → stop and ask.

## Delegate

| Need | Route |
|------|-------|
| Source code audit | Trail of Bits / safe-solana-builder |
| Token creation | token-engineer |
| User tx failure | `/debug-user-tx` |

**Entry point:** [skill/SKILL.md](skill/SKILL.md)
