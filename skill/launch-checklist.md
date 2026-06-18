# Launch Week Checklist

Authority surface gate from **T-7** through **T+7** (mainnet).

## Inputs required

- Cluster (must be explicit before mainnet steps)
- Mint address(es)
- Program ID(s)
- Multisig vault address(es)
- Intended token model (fixed supply / upgradeable program / etc.)

## T-7 — Design alignment

- [ ] Document intended final state for each surface (mint, freeze, metadata, upgrade)
- [ ] Map each surface to expected holder (revoked | multisig | program PDA)
- [ ] Review with second human — not AI-only signoff

## T-3 — Devnet / staging proof

- [ ] Run full surface read on staging assets
- [ ] Execute dry-run revoke/transfer txs on devnet mirroring mainnet plan
- [ ] Save devnet baseline for comparison

## T-0 — Pre-launch gate (blocks launch)

Run modules in order:

1. [mint-freeze-authority.md](mint-freeze-authority.md) — all mints
2. [metadata-authority.md](metadata-authority.md) — all collections
3. [upgrade-authority.md](upgrade-authority.md) — all programs
4. [multisig-verification.md](multisig-verification.md) — any pending authority txs

### Hard stop conditions (`blocks_launch: true`)

- Mint authority on hot wallet for fixed-supply token
- Freeze authority on unrecognized key
- Upgrade authority on single signer with TVL expected
- Metadata mutable on deployer wallet without documented plan
- Any pending Squads proposal transferring authority to unknown key

**Deliverable**: Authority Surface Report with `launch_verdict: go | no-go`

## T+0 — Launch window (first 24h)

- [ ] Re-read all surfaces 6h and 24h post-launch
- [ ] Compare to T-0 report — any drift → [incident-handoff.md](incident-handoff.md)
- [ ] Capture **mainnet baseline** JSON ([authority-drift.md](authority-drift.md))

## T+7 — Launch week close

- [ ] Confirm final authority state matches public commitments (site/docs)
- [ ] Revoke or transfer any remaining temporary authorities
- [ ] Archive launch report + baseline in team repo
- [ ] Schedule recurring [weekly-review.md](weekly-review.md)

## Launch verdict template

```yaml
launch_verdict: no-go
blocking_findings:
  - F-mint-001
  - F-upg-001
signed_off_by: []  # human names — never AI-only
next_review: T+0 + 6h
```

## Delegation

- Token deployment steps → token-engineer / solana-dev
- Marketing copy about "immutable" → not this skill
