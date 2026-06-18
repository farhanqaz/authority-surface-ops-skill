# Authority Surface Ops Skill

A Claude Code skill for **live on-chain admin surface operations** on Solana — mint, freeze, metadata, and upgrade authority verification, multisig pre-sign checks, drift detection, and incident handoff.

> **Addon** for [Solana AI Kit](https://github.com/solanabr/solana-ai-kit) · **Extends** [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill)

## Overview

Security audit skills review **code before deployment**. Token skills cover **creation and integration**. Neither covers **ongoing authority state** after launch.

```
┌─────────────────────────────────────────────────────────────┐
│              authority-surface-ops-skill (addon)            │
│                                                             │
│  Launch gate · Weekly review · Authority drift · Multisig   │
│  pre-sign · Incident handoff                                │
│                             │                               │
│                             ▼ references                    │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  solana-dev-skill · audit skills · token-engineer     │  │
│  │  (programs, clients, code review, token setup)        │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Problem

After launch, teams often stop checking admin surfaces:

- Metadata update authority remains on a deployer wallet
- Program upgrade authority stays on a single signer while TVL grows
- Squads proposals are signed without reviewing authority-changing instructions
- Authority changes go unnoticed until users report an issue

This skill provides repeatable **ops cadences** and structured **Authority Surface Reports** for those surfaces.

## Modules

| Surface / workflow | File |
|---------------------|------|
| Mint & freeze authority | `skill/mint-freeze-authority.md` |
| Metadata authority | `skill/metadata-authority.md` |
| Upgrade authority | `skill/upgrade-authority.md` |
| Multisig pre-sign | `skill/multisig-verification.md` |
| Authority drift | `skill/authority-drift.md` |
| Launch week gate | `skill/launch-checklist.md` |
| Weekly review | `skill/weekly-review.md` |
| Incident handoff | `skill/incident-handoff.md` |

## Installation

```bash
git clone https://github.com/farhanqaz/authority-surface-ops-skill
cd authority-surface-ops-skill
chmod +x install.sh
./install.sh              # ~/.claude/skills/
./install.sh --project    # ./.claude/skills/
./install.sh -y           # non-interactive
```

Installs the skill directory plus bundled agent and command definitions. Recommended alongside `solana-dev-skill` for program and client context.

## Usage

```
Run launch-week authority surface audit for mint <MINT> and program <PROGRAM_ID>
```

```
Weekly authority review using baseline at ops/authority-baseline.json
```

```
Verify this Squads proposal before I sign — does it change mint authority?
```

```
Compare current mint authorities against last week's baseline and flag drift
```

## Agent & command

| Asset | Purpose |
|-------|---------|
| `authority-ops-engineer` | Surface reads, checklists, drift diffs, YAML reports |
| `/authority-surface-audit` | End-to-end audit workflow |

## Output

Engagements produce an **Authority Surface Report** (YAML): severity-ranked findings, `launch_verdict` or `drift_summary`, and escalation routing. Schema defined in `skill/SKILL.md`.

Example reports: [`examples/reports/`](examples/reports/).

## CLI verification

Read-only helper for mint authority checks (RPC only, no keys required):

```bash
chmod +x scripts/check-mint-authorities.sh
./scripts/check-mint-authorities.sh 4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R mainnet-beta
```

See [docs/CLI.md](docs/CLI.md) for usage and sample output.

## Validation

```bash
./validate.sh
```

## Scope

**Included:** Authority verification, launch and weekly cadences, baseline drift, Squads pre-sign review, incident handoff to audit skills.

**Excluded:** Treasury, payroll, governance voting, compliance, automated monitoring services, end-user transaction support, source-code security audits.

## Repository layout

```
.
├── skill/SKILL.md          # Entry point and routing
├── agents/
├── commands/
├── scripts/                # Optional CLI helpers
├── examples/               # Baseline and report samples
├── docs/
└── install.sh
```

## Related projects

- [Solana AI Kit](https://github.com/solanabr/solana-ai-kit)
- [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill)
- [solana-game-skill](https://github.com/solanabr/solana-game-skill) — structural reference

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Architecture notes: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## License

MIT — see [LICENSE](LICENSE).
