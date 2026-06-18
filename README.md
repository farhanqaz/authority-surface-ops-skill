# Authority Surface Ops Skill

Live on-chain **admin surface operations** for Solana builders — mint, freeze, metadata, and upgrade authority verification, multisig pre-sign checks, drift detection, and incident handoff.

> **Addon skill** for [Solana AI Kit](https://github.com/solanabr/solana-ai-kit).  
> **Extends** [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill) for program context only.  
> **Does not replace** security audit skills or token creation workflows.

## Problem

Teams revoke mint authority once, then never look again. Meanwhile:

- Metadata update authority stays on the deployer wallet
- Upgrade authority sits on a hot key while TVL grows
- Squads proposals get signed without instruction review
- Nobody notices an authority changed until users panic

Audit skills review **code before ship**. This skill operates **live admin surfaces after ship**.

## What it covers

| Surface | Module |
|---------|--------|
| Mint authority | `skill/mint-freeze-authority.md` |
| Freeze authority | `skill/mint-freeze-authority.md` |
| Metadata authority | `skill/metadata-authority.md` |
| Upgrade authority | `skill/upgrade-authority.md` |
| Multisig pre-sign | `skill/multisig-verification.md` |
| Authority drift | `skill/authority-drift.md` |
| Launch week gate | `skill/launch-checklist.md` |
| Weekly review | `skill/weekly-review.md` |
| Incident handoff | `skill/incident-handoff.md` |

## Install

```bash
git clone https://github.com/farhanqaz/authority-surface-ops-skill
cd authority-surface-ops-skill
chmod +x install.sh
./install.sh          # ~/.claude/skills/
./install.sh --project  # ./.claude/skills/ (project-local)
./install.sh -y         # non-interactive
```

## Usage examples

```
Run launch-week authority audit for mint So111... and program Tokenkeg...
```

```
Weekly authority review — baseline is ops/authority-baseline.json
```

```
Verify this Squads proposal before I sign — does it change mint authority?
```

```
Mint authority changed since yesterday — drift vs baseline, escalate if critical
```

## Agent & command

| Asset | Purpose |
|-------|---------|
| **authority-ops-engineer** | Runs checklists, reads surfaces, produces reports |
| **/authority-surface-audit** | Structured audit → YAML Authority Surface Report |

## Output format

Every run produces an **Authority Surface Report** (YAML) with severity-ranked findings and explicit `launch_verdict` or `drift_summary`. See `skill/SKILL.md`.

## Repository structure

```
authority-surface-ops-skill/
├── README.md
├── LICENSE
├── DESIGN.md              # Maintainer spec (bounty / merge criteria)
├── install.sh
├── skill/
│   ├── SKILL.md           # Entry point + routing
│   └── *.md               # Progressive disclosure modules
├── agents/
│   └── authority-ops-engineer.md
└── commands/
    └── authority-surface-audit.md
```

## Boundaries

**In scope:** Authority reads, checklists, baselines, multisig pre-sign, incident handoff to audit skills.

**Out of scope (v1):** Treasury, payroll, governance voting, compliance/tax, monitoring bots, user tx support, code audits.

## Related

- [Solana AI Kit](https://github.com/solanabr/solana-ai-kit)
- [solana-game-skill](https://github.com/solanabr/solana-game-skill) (structure reference)
- [solana-dev-skill](https://github.com/solana-foundation/solana-dev-skill) (core dev)

## Demo

```bash
chmod +x scripts/demo-audit.sh
./scripts/demo-audit.sh 4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R mainnet-beta  # go
./scripts/demo-audit.sh 4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU devnet      # no-go
```

See [DEMO.md](DEMO.md) for CLI demo commands (no video required).

```bash
./validate.sh   # link + structure checks
```

## License

MIT — see [LICENSE](LICENSE).
