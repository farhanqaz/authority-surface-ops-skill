# Authority Surface Ops Skill

[![CI](https://github.com/farhanqaz/authority-surface-ops-skill/actions/workflows/ci.yml/badge.svg)](https://github.com/farhanqaz/authority-surface-ops-skill/actions/workflows/ci.yml)

Live on-chain **admin surface operations** for Solana — mint, freeze, metadata, and upgrade authority verification, multisig pre-sign checks, drift detection, and incident handoff.

> **Addon** for [Solana AI Kit](https://github.com/solanabr/solana-ai-kit) · **Extends** [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill)

## Overview

| Phase | Existing kit coverage | Gap this skill fills |
|-------|----------------------|----------------------|
| Pre-ship | Audit skills review **source code** | — |
| Launch day | token-engineer covers **creation** | — |
| Post-ship | — | **Live authority state** on mints, programs, multisigs |

```
┌─────────────────────────────────────────────────────────────┐
│              authority-surface-ops-skill (addon)            │
│  Launch gate · Weekly review · Drift · Multisig pre-sign    │
│                             │                               │
│                             ▼ references                    │
│  solana-dev-skill · audit skills · token-engineer           │
└─────────────────────────────────────────────────────────────┘
```

## Problem

After launch, teams often stop checking admin surfaces:

- Metadata update authority remains on a deployer wallet
- Program upgrade authority stays on a single signer while TVL grows
- Squads proposals are signed without reviewing authority-changing instructions
- Authority changes go unnoticed until users report an issue

Audit skills review **code before ship**. This skill operates **live admin surfaces after ship**.

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
chmod +x install.sh validate.sh scripts/check-mint-authorities.sh scripts/check-program-upgrade.sh
./install.sh              # ~/.claude/skills/
./install.sh --project    # ./.claude/skills/
./install.sh -y           # non-interactive
```

Installs skill modules plus `authority-ops-engineer` agent and `/authority-surface-audit` command. Use alongside `solana-dev-skill`.

### Solana AI Kit submodule

Maintainers: [docs/KIT_INTEGRATION.md](docs/KIT_INTEGRATION.md)

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

Every engagement produces an **Authority Surface Report** (YAML). Schema: `skill/SKILL.md`.

| Example | Description |
|---------|-------------|
| [examples/reports/](examples/reports/) | Launch, drift, weekly, upgrade samples |
| [examples/output/ray-mainnet-report.txt](examples/output/ray-mainnet-report.txt) | Live RPC — RAY mint |
| [examples/output/token-program-upgrade-report.txt](examples/output/token-program-upgrade-report.txt) | Live RPC — SPL Token program upgrade |
| [examples/output/devnet-usdc-report.txt](examples/output/devnet-usdc-report.txt) | Live RPC — devnet USDC mint |

Sample output (mainnet RAY, fixed-supply profile):

```yaml
launch_verdict: go
findings:
  - severity: info
    observation: "Mint authority revoked (null)"
  - severity: info
    observation: "Freeze authority revoked (null)"
```

## Verified addresses

| Asset | Address | Cluster | Expected verdict (fixed-supply) |
|-------|---------|---------|--------------------------------|
| RAY | `4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R` | mainnet-beta | `go` |
| SPL Token program | `TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA` | mainnet-beta | Upgrade authority none (immutable) |
| USDC (devnet) | `4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU` | devnet | `no-go` |

Reproduce:

```bash
./scripts/check-mint-authorities.sh 4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R mainnet-beta
./scripts/check-program-upgrade.sh TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA mainnet-beta
./scripts/check-mint-authorities.sh 4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU devnet
./scripts/check-mint-authorities.sh EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v mainnet-beta stablecoin
```

See [docs/CLI.md](docs/CLI.md).

## CLI verification

Read-only RPC helpers (no keys required):

| Script | Surfaces |
|--------|----------|
| `scripts/check-mint-authorities.sh` | Mint + freeze |
| `scripts/check-program-upgrade.sh` | Program upgrade authority |

Metadata and Squads checks are agent-driven (Helius DAS / explorer / simulation) — see skill modules.

```bash
chmod +x scripts/check-mint-authorities.sh scripts/check-program-upgrade.sh
```

Live captured output: [`examples/output/`](examples/output/).

## Validation

```bash
./validate.sh
```

## Scope

**Included:** Authority verification, launch and weekly cadences, baseline drift, Squads pre-sign review, incident handoff to audit skills.

**Excluded:** Treasury, payroll, governance voting, compliance, automated monitoring services, end-user transaction support, source-code security audits.

## Related projects

- [Solana AI Kit](https://github.com/solanabr/solana-ai-kit)
- [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill)
- [solana-game-skill](https://github.com/solanabr/solana-game-skill) — structural reference

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Architecture: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## License

MIT — see [LICENSE](LICENSE).
