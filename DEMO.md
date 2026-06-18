# Demo (CLI — no video required)

Optional 90-second screen recording script for judges who prefer video.

## Setup (before recording)

```bash
git clone https://github.com/farhanqaz/authority-surface-ops-skill
cd authority-surface-ops-skill
chmod +x install.sh scripts/demo-audit.sh
./install.sh -y
```

## Script

| Time | Say | Do |
|------|-----|-----|
| 0:00 | "Audit skills review code before launch. Nobody watches live mint authority after ship." | Show repo `skill/SKILL.md` routing table |
| 0:15 | "Launch gate on a real mainnet mint." | Terminal below |
| 0:45 | "RAY — revoked mint and freeze. Verdict: go." | Show output |
| 0:55 | "Devnet test mint — open authority. Verdict: no-go." | Second command |
| 1:10 | "Critical drift routes to incident handoff; code issues route to audit skills." | Open `incident-handoff.md` |
| 1:25 | "MIT skill, slots into Solana AI Kit as ext submodule." | README + https://github.com/farhanqaz/authority-surface-ops-skill |

## Commands

**Clean (fixed supply — mainnet RAY):**

```bash
./scripts/demo-audit.sh 4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R mainnet-beta
```

Expected: `launch_verdict: go`, mint/freeze info severity.

**Open authority (create devnet mint first):**

```bash
spl-token create-token --url devnet
# paste mint address:
./scripts/demo-audit.sh <MINT> devnet
```

Expected: `launch_verdict: no-go`, `blocks_launch: true`.

## Claude Code prompt (optional second take)

```
/authority-surface-audit
mode: launch_gate
cluster: mainnet-beta
mints: 4k3Dyjzvzp8eMZWUXbBCjEvwSkkk59S5iCNLY3QrkX6R
```

## Program upgrade demo (optional)

```bash
solana program show TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA --url mainnet-beta
```

Show `Authority: none` → immutable program surface.

## What not to demo

- Treasury, payroll, bots, user tx support (out of scope v1)
