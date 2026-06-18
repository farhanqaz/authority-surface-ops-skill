# Architecture

Progressive-loading skill addon for [Solana AI Kit](https://github.com/solanabr/solana-ai-kit). Follows the same layout as [solana-game-skill](https://github.com/solanabr/solana-game-skill): hub `SKILL.md`, focused module files, optional agent and command definitions.

## Routing

```
Engagement type (SKILL.md)
    │
    ├── launch_gate ─── launch-checklist.md
    ├── weekly ─────── weekly-review.md → authority-drift.md
    ├── drift ──────── authority-drift.md
    ├── anomaly ────── incident-handoff.md
    └── point_check ── surface module(s)
            │
            ├── mint / freeze → mint-freeze-authority.md
            ├── metadata ─── metadata-authority.md
            ├── upgrade ──── upgrade-authority.md
            └── multisig ─── multisig-verification.md
    │
    ▼
Authority Surface Report (YAML)
```

## Report schema

All workflows converge on a single report format (`report_version: 1`) documented in `skill/SKILL.md`. Findings carry severity, affected surface, and optional `blocks_launch` for launch-gate mode.

## Boundaries

| Concern | Handled by |
|---------|------------|
| Live authority state | This skill |
| Program / client implementation | solana-dev-skill |
| Token creation | token-engineer (kit) |
| Source-code audit | Trail of Bits, safe-solana-builder |
| User transaction debugging | `/debug-user-tx` (kit) |

## Design principles

1. **Progressive disclosure** — hub stays small; modules load on demand.
2. **Ops, not audit** — on-chain state and cadences, not vulnerability scanning.
3. **Human sign-off** — launch verdicts require named approvers; reports are input to decisions, not replacements.
4. **No automated monitoring** — baselines and diffs are manual or agent-driven, not background services.

## Extension points

Future modules may cover additional authority-bearing Token-2022 extensions or expanded multisig platforms. Out of scope: treasury, payroll, governance, compliance, and monitoring bots.
