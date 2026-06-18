# Resources

## Program IDs (mainnet)

| Program | Address |
|---------|---------|
| SPL Token | `TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA` |
| Token-2022 | `TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb` |
| BPF Upgradeable Loader | `BPFLoaderUpgradeab1e11111111111111111111111` |
| Metaplex Token Metadata | `metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s` |

## RPC read patterns

```bash
# Mint (jsonParsed)
solana account <MINT> --output json --url mainnet-beta

# Program + upgrade authority (explorer often clearer for ProgramData)
solana program show <PROGRAM_ID> --url mainnet-beta
```

Prefer Helius MCP (kit) for batch reads when available.

## Snapshot files

| File | Purpose |
|------|---------|
| `authority-baseline.json` | Drift detection reference |
| `authority-launch-report.yaml` | T-0 gate output |
| `authority-weekly-YYYY-Www.yaml` | Weekly review archive |

Store in private repo `ops/authorities/` — pubkeys only.

## Skill boundaries (kit)

| Topic | Use instead |
|-------|-------------|
| Write Anchor / client code | solana-dev-skill |
| Create token / Token-2022 setup | token-engineer agent |
| Code audit / vuln scan | Trail of Bits, safe-solana-builder |
| Metaplex integration patterns | ext/metaplex |
| User tx failed in wallet | `/debug-user-tx` (not authority ops) |
| Treasury runway / payroll | Out of scope |
| Governance voting / DAO ops | Out of scope |

## External links

- [Solana AI Kit](https://github.com/solanabr/solana-ai-kit)
- [solana-game-skill](https://github.com/solanabr/solana-game-skill) (reference structure)
- [Squads](https://squads.so) — verify vault addresses on official UI
- [Solana explorers](https://explorer.solana.com) — cross-check RPC reads

## Maintenance notes (maintainers)

Refresh when:

- Token-2022 extension set changes materially
- Squads v4 account layout changes (update multisig module only)
- Metaplex Core becomes default for new launches (extend metadata module)

Quarterly review is sufficient under normal ecosystem churn.
