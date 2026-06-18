# Solana AI Kit integration

Instructions for maintainers adding this skill as an external submodule to [solana-ai-kit](https://github.com/solanabr/solana-ai-kit).

## Submodule entry

Add to `.gitmodules`:

```ini
[submodule ".claude/skills/ext/authority-surface-ops"]
    path = .claude/skills/ext/authority-surface-ops
    url = https://github.com/farhanqaz/authority-surface-ops-skill.git
```

Initialize:

```bash
git submodule add https://github.com/farhanqaz/authority-surface-ops-skill.git .claude/skills/ext/authority-surface-ops
git submodule update --init --recursive
```

## Hub routing

Add a row to `.claude/skills/SKILL.md` (kit hub) under an appropriate section:

```markdown
### Authority surface ops (live admin state)
- [authority-surface-ops/SKILL.md](ext/authority-surface-ops/SKILL.md) — mint/freeze/metadata/upgrade authorities, Squads pre-sign, drift, launch gate
```

Suggested trigger keywords for the hub: `mint authority`, `freeze authority`, `upgrade authority`, `authority drift`, `Squads pre-sign`, `launch authority gate`.

## Agents and commands

Copy or symlink into the kit tree (same pattern as `solana-game-skill`):

| Source | Kit destination |
|--------|-----------------|
| `agents/authority-ops-engineer.md` | `.claude/agents/authority-ops-engineer.md` |
| `commands/authority-surface-audit.md` | `.claude/commands/authority-surface-audit.md` |

Agent and command files reference skill modules at `../skills/authority-surface-ops/` (installed layout).

## Boundaries vs existing kit skills

| Need | Route to |
|------|----------|
| Live mint/freeze/metadata/upgrade state | **authority-surface-ops** (this skill) |
| Anchor program source audit | ext/trailofbits, ext/safe-solana-builder |
| Token creation / Token-2022 setup | token-engineer agent |
| User transaction failure | `/debug-user-tx` |
| Program/client implementation | ext/solana-dev |

Do not duplicate audit checklists or token creation flows in this submodule.

## Validation

From the submodule root:

```bash
./validate.sh
```

From kit root after submodule add:

```bash
./validate.sh   # kit validator — confirm hub link resolves
```

## License

MIT — compatible with solana-ai-kit submodule policy.
