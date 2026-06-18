# CLI reference

Optional read-only utilities for verifying mint authorities outside an agent session.

## check-mint-authorities.sh

Fetches mint and freeze authority fields via public RPC and prints an Authority Surface Report (YAML).

### Usage

```bash
./scripts/check-mint-authorities.sh <MINT_ADDRESS> [cluster] [profile]
```

| Argument | Default | Values |
|----------|---------|--------|
| `MINT_ADDRESS` | required | SPL or Token-2022 mint |
| `cluster` | `devnet` | `devnet`, `mainnet-beta` |
| `profile` | `fixed-supply` | `fixed-supply`, `stablecoin` |

The **profile** selects the rubric from `skill/mint-freeze-authority.md`. Stablecoins (e.g. mainnet USDC) retain mint authority by design — use `stablecoin` to avoid false critical findings.

### Examples

Fixed-supply token (revoked authorities):

```bash
./scripts/check-mint-authorities.sh 4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R mainnet-beta
```

Expected: `launch_verdict: go`, informational findings for revoked mint and freeze authorities.

Token with active authorities:

```bash
./scripts/check-mint-authorities.sh 4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU devnet
```

Expected: `launch_verdict: no-go`, blocking findings when authorities are present on a fixed-supply launch profile.

### Requirements

- `curl`
- `python3`
- Network access to Solana public RPC endpoints

No wallet, API keys, or signing capabilities are used.

### Program upgrade check

For upgrade authority on deployed programs:

```bash
solana program show <PROGRAM_ID> --url mainnet-beta
```

Inspect the `Authority` field on the ProgramData account (`none` indicates an immutable deployment).
