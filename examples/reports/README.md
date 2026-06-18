# Example reports

Structured **Authority Surface Report** samples. Schema: `skill/SKILL.md`.

| File | Mode | Scenario |
|------|------|----------|
| [launch-go-ray.yaml](launch-go-ray.yaml) | `launch_gate` | Mainnet RAY — revoked mint/freeze authorities |
| [launch-no-go-active-authorities.yaml](launch-no-go-active-authorities.yaml) | `launch_gate` | Devnet USDC — active mint/freeze authorities under fixed-supply profile |
| [upgrade-immutable-program.yaml](upgrade-immutable-program.yaml) | `point_check` | SPL Token program — upgrade authority revoked |
| [drift-critical-mint.yaml](drift-critical-mint.yaml) | `drift` | Synthetic mint — authority appeared since baseline |
| [weekly-review-clean.yaml](weekly-review-clean.yaml) | `weekly` | No drift, pending multisig noted |

## Live CLI output

Read-only RPC verification (fixed-supply launch profile):

| Asset | Cluster | Output |
|-------|---------|--------|
| RAY `4k3Dyj...` | mainnet-beta | [ray-mainnet-report.txt](../output/ray-mainnet-report.txt) |
| SPL Token program | mainnet-beta | [token-program-upgrade-report.txt](../output/token-program-upgrade-report.txt) |
| USDC devnet `4zMMC9...` | devnet | [devnet-usdc-report.txt](../output/devnet-usdc-report.txt) |

Regenerate:

```bash
./scripts/check-mint-authorities.sh 4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R mainnet-beta
./scripts/check-program-upgrade.sh TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA mainnet-beta
```

## Baseline sample

[authority-baseline.example.json](../authority-baseline.example.json) — drift detection input format (`skill/authority-drift.md`).
