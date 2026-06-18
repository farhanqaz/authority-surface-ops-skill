# Multisig Verification

Pre-sign verification for Squads and Realms proposals that touch authorities.

## Scope (v1)

- **Squads v4** vault transactions (most common founder multisig)
- **Realms** governance accounts (authority holder identification only — not governance ops)

Out of scope: proposal creation, payroll, voting strategy.

## Pre-sign checklist

Before user signs in Phantom/Squads UI:

### 1. Identity

- [ ] Proposal URL / vault address matches team's **documented** multisig
- [ ] Threshold and members match last approved baseline (see [authority-drift.md](authority-drift.md))

### 2. Instruction decode

For each instruction in the proposal:

| Instruction pattern | Verify |
|--------------------|--------|
| `SetAuthority` (mint) | New authority is intended recipient; not EOA unless documented |
| `SetAuthority` (freeze) | Same |
| Metadata update | URI/signer expected |
| `Upgrade` / buffer deploy | Matches scheduled release tag |
| SOL/token transfer | Recipient labeled in internal runbook |

### 3. Simulation

- [ ] Simulate proposal on correct cluster
- [ ] Post-simulation token balances / authorities match intent
- [ ] No unexpected inner instructions (CPI to unknown program → **stop**)

### 4. Diff against baseline

- [ ] If proposal changes any authority field, require second reviewer (human)
- [ ] Compare to [launch-checklist.md](launch-checklist.md) approved state

## Severity rubric

| State | Severity |
|-------|----------|
| Unknown program in CPI chain | **critical** — do not sign |
| Authority transferred to unrecognized pubkey | **critical** |
| Mint/freeze revoke mismatch with stated intent | **high** |
| Simulation fails | **high** — do not sign until eng review |

## Squads-specific notes

- Vault PDA ≠ member wallet — always audit **vault transaction effects**
- Draft proposals can be edited — re-verify hash/instructions immediately before sign

## Realms-specific notes (v1)

- Use Realms to **identify** who holds program/token authorities
- Do not analyze vote economics or proposal politics

## Output snippet

```yaml
findings:
  - id: F-msig-001
    severity: critical
    surface: multisig
    observation: "Proposal includes SetAuthority mint → unknown EOA 8xyz..."
    recommendation: "Reject signature; open internal review"
    blocks_launch: false
multisig_verdict: reject | approve_with_notes | needs_second_reviewer
```

## Delegation

- Building Squads txs → solana-dev client patterns
- Smart contract logic in proposal → audit skills
