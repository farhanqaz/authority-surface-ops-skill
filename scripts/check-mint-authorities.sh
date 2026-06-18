#!/usr/bin/env bash
# Read-only mint authority check via public RPC
# Profile: fixed-supply (default) | stablecoin
set -euo pipefail

MINT="${1:?Usage: check-mint-authorities.sh <MINT> [cluster] [profile]}"
CLUSTER="${2:-devnet}"
PROFILE="${3:-fixed-supply}"

case "$CLUSTER" in
  mainnet-beta) RPC="https://api.mainnet-beta.solana.com" ;;
  devnet) RPC="https://api.devnet.solana.com" ;;
  *) echo "Unsupported cluster: $CLUSTER" >&2; exit 1 ;;
esac

RESP=$(curl -s "$RPC" -X POST -H "Content-Type: application/json" -d "{
  \"jsonrpc\":\"2.0\",\"id\":1,
  \"method\":\"getAccountInfo\",
  \"params\":[\"$MINT\", {\"encoding\":\"jsonParsed\"}]
}")

python3 - "$MINT" "$CLUSTER" "$PROFILE" "$RESP" <<'PY'
import json, sys

mint, cluster, profile, raw = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
data = json.loads(raw)
val = data.get("result", {}).get("value")
if not val:
    print("error: account not found", file=sys.stderr)
    sys.exit(1)

parsed = val["data"].get("parsed", {})
if parsed.get("type") != "mint":
    print("error: not a mint account", file=sys.stderr)
    sys.exit(1)

info = parsed["info"]
mint_auth = info.get("mintAuthority")
freeze_auth = info.get("freezeAuthority")

findings = []

if mint_auth:
    if profile == "stablecoin":
        sev = "info"
        blocks = False
        rec = "Stablecoin model — verify holder is documented issuer/multisig"
    elif cluster == "mainnet-beta":
        sev = "critical"
        blocks = True
        rec = "Revoke or move to multisig before fixed-supply launch"
    else:
        sev = "high"
        blocks = True
        rec = "Revoke or move to multisig before fixed-supply launch"
    findings.append({
        "id": "F-mint-001",
        "severity": sev,
        "surface": "mint",
        "observation": f"Mint authority present: {mint_auth}",
        "recommendation": rec,
        "blocks_launch": blocks,
    })
else:
    findings.append({
        "id": "F-mint-001",
        "severity": "info",
        "surface": "mint",
        "observation": "Mint authority revoked (null)",
        "recommendation": "No action for fixed-supply model",
        "blocks_launch": False,
    })

if freeze_auth:
    if profile == "stablecoin":
        sev = "info"
        blocks = False
        rec = "Stablecoin model — verify freeze policy and holder"
    else:
        sev = "high"
        blocks = True
        rec = "Revoke unless required and held by multisig"
    findings.append({
        "id": "F-freeze-001",
        "severity": sev,
        "surface": "freeze",
        "observation": f"Freeze authority present: {freeze_auth}",
        "recommendation": rec,
        "blocks_launch": blocks,
    })
else:
    findings.append({
        "id": "F-freeze-001",
        "severity": "info",
        "surface": "freeze",
        "observation": "Freeze authority revoked (null)",
        "recommendation": "No action",
        "blocks_launch": False,
    })

blocking = [f["id"] for f in findings if f.get("blocks_launch")]
verdict = "no-go" if blocking else "go"

report = {
    "report_version": 1,
    "mode": "point_check",
    "cluster": cluster,
    "token_model": profile,
    "assets": [{"type": "mint", "address": mint}],
    "findings": findings,
    "launch_verdict": verdict,
    "blocking_findings": blocking,
    "escalate": "incident" if any(f["severity"] == "critical" for f in findings) else "none",
}

def emit_yaml(obj, indent=0):
    sp = "  " * indent
    if isinstance(obj, dict):
        for k, v in obj.items():
            if isinstance(v, (dict, list)):
                print(f"{sp}{k}:")
                emit_yaml(v, indent + 1)
            else:
                print(f"{sp}{k}: {json.dumps(v) if isinstance(v, str) else v}")
    elif isinstance(obj, list):
        for item in obj:
            if isinstance(item, dict):
                print(f"{sp}-")
                for k, v in item.items():
                    print(f"{sp}  {k}: {json.dumps(v) if isinstance(v, str) else v}")
            else:
                print(f"{sp}- {item}")

emit_yaml(report)
PY
