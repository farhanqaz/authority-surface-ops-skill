# Mint & Freeze Authority

Verify who can inflate supply and who can freeze token accounts.

## Applies to

- SPL Token (`TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA`)
- Token-2022 (`TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb`)

## Read procedure

1. Confirm cluster and mint address.
2. Fetch mint account (`getAccountInfo`, jsonParsed preferred).
3. Record:

```yaml
mint: <address>
program: spl-token | token-2022
supply: <u64>
decimals: <u8>
mint_authority:
  present: true | false
  holder: <pubkey | null>
freeze_authority:
  present: true | false
  holder: <pubkey | null>
is_initialized: true
extensions: []  # Token-2022 only — list active extensions
```

4. For Token-2022, scan extensions that add **secondary authorities** (transfer hook, permanent delegate, etc.) — flag any unexpected authority-bearing extension as **high**.

## Severity rubric

| State | Severity | blocks_launch |
|-------|----------|---------------|
| Mint authority on hot wallet / single EOA | **critical** | true |
| Mint authority present after "fixed supply" claim | **critical** | true |
| Mint authority on multisig (expected) | info | false |
| Mint authority revoked (`null`) | info | false (desired for fixed supply) |
| Freeze authority on unknown key | **high** | true |
| Freeze authority retained "for compliance" without doc | medium | review |
| Freeze authority revoked | info | false (usually desired) |

## Launch-week expectations

| Token model | Mint authority | Freeze authority |
|-------------|----------------|------------------|
| Fixed supply meme/token | **Revoked** | Revoked (typical) |
| Stablecoin / RWA | Multisig + timelock | Multisig (if used) |
| Gaming consumable | Program PDA or multisig | Usually revoked |

## Known production patterns

| Mint | Mint authority | Interpretation |
|------|----------------|----------------|
| RAY `4k3Dyj...` | `null` | Fixed supply — launch gate pass |
| USDC `EPjFWdd5...` | Circle-controlled key | **Expected** for stablecoin mint/burn — use `stablecoin` token model, not fixed-supply rubric |
| Devnet test mint | Deployer wallet | Expected on devnet; **never** treat as mainnet launch pass |

Always confirm **token model** before applying `blocks_launch`. A present mint authority is critical for fixed-supply launches and informational for stablecoins on documented multisig/holder keys.

## Multisig as holder

If holder is a Squads vault / multisig:

1. Do **not** mark safe without [multisig-verification.md](multisig-verification.md).
2. Record vault address and threshold if visible on explorer.

## Common false positives

- User confuses **mint authority** with **update authority** (metadata) — cross-check [metadata-authority.md](metadata-authority.md).
- Devnet mint with open authority — OK on devnet, **never** extrapolate to mainnet.

## Output snippet

```yaml
findings:
  - id: F-mint-001
    severity: critical
    surface: mint
    observation: "Mint authority held by 7xKX... (single signer wallet)"
    recommendation: "Revoke or transfer to Squads vault before mainnet launch"
    blocks_launch: true
```

## Delegation

- Writing revoke instructions → solana-dev-skill (client tx building)
- Code allowing unauthorized mint → solana-dev → security.md
