# Upgrade Authority

Verify whether a deployed program can be replaced and who controls upgrades.

## Applies to

- BPF Loader Upgradeable programs
- Not applicable to **immutable** (non-upgradeable) deployments

## Read procedure

1. Confirm program ID and cluster.
2. Fetch program account — note `programData` address.
3. Fetch ProgramData account — read **upgrade authority** field.

```yaml
program_id: <address>
loader: bpf-upgradeable-v2
program_data: <address>
upgrade_authority:
  present: true | false
  holder: <pubkey | null>  # null = immutable (authority revoked)
slot_last_deploy: <optional from explorer>
```

4. If `upgrade_authority` is null → program is **immutable** (verify this matches team intent).

## Severity rubric

| State | Severity | blocks_launch |
|-------|----------|---------------|
| Upgrade authority on single hot wallet | **critical** | true |
| Upgrade authority on multisig without documented timelock | **high** | review |
| Upgrade authority revoked (immutable) but docs say "upgradeable" | medium | review |
| Upgrade authority = expected Squads vault | info | false |
| Unexpected upgrade slot activity in drift review | **critical** | escalate |

## Launch-week expectations

| Stage | Expected state |
|-------|----------------|
| Pre-audit | Upgradeable + multisig (for fixes) |
| Post-audit, pre-TVL | Document upgrade policy |
| Mature / high TVL | Many teams revoke (immutable) — explicit decision |

## Drift signal

ProgramData account size or authority field change without scheduled upgrade → treat as [incident-handoff.md](incident-handoff.md).

## Output snippet

```yaml
findings:
  - id: F-upg-001
    severity: critical
    surface: upgrade
    observation: "Upgrade authority 5def... — single wallet, not Squads"
    recommendation: "Transfer upgrade authority to multisig before accepting user funds"
    blocks_launch: true
```

## Delegation

- Writing upgrade txs / buffer deploy → solana-dev → programs-anchor.md
- Reviewing upgrade instruction handlers → security / audit skills
