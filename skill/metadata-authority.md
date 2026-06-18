# Metadata Authority

Verify who can change token name, symbol, URI, and seller fee basis points.

## Applies to

- Metaplex Token Metadata (legacy)
- Metaplex Core assets (different model — flag asset type first)

## Read procedure

1. Confirm mint address and cluster.
2. Derive metadata PDA (Token Metadata program):

```
seeds = ["metadata", TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA, <MINT>]
program = metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s
```

3. Fetch metadata account (Helius DAS `getAsset` with mint or metadata address, or explorer decode).
4. Record:

```yaml
metadata_account: <address>
mint: <address>
update_authority:
  holder: <pubkey>
  is_mutable: true | false
primary_sale_happened: true | false
seller_fee_basis_points: <u16>
uri: <string>
```

## Severity rubric

| State | Severity | blocks_launch |
|-------|----------|---------------|
| Update authority on deployer hot wallet post-launch | **high** | true |
| `is_mutable: true` after "immutable collection" marketing | medium | review |
| Update authority = program PDA (expected for dynamic NFT) | info | false |
| Update authority revoked / immutable | info | false |
| URI points to centralized server without backup plan | medium | review |

## Launch-week expectations

| Asset type | Typical update authority |
|------------|-------------------------|
| Fixed art PFP | Revoked or burned after reveal |
| Dynamic/game item | Program PDA |
| Collection with ongoing drops | Multisig |

## Relationship to mint authority

These are **independent surfaces**. A token can have:

- Revoked mint + **live** metadata authority (URI rug vector)
- Live mint + revoked metadata

Always report both in launch gate.

## Output snippet

```yaml
findings:
  - id: F-meta-001
    severity: high
    surface: metadata
    observation: "Update authority 9abc... matches deployer wallet"
    recommendation: "Transfer to multisig or revoke after metadata freeze"
    blocks_launch: true
```

## Delegation

- Metaplex minting/integration patterns → ext/metaplex skill (kit)
- On-chain metadata program code → solana-dev → programs-anchor.md
