#!/usr/bin/env bash
# Read-only mint authority audit — demo helper for judges (not a monitoring bot)
set -euo pipefail

MINT="${1:?Usage: demo-audit.sh <MINT_ADDRESS> [cluster]}"
CLUSTER="${2:-devnet}"

case "$CLUSTER" in
  mainnet-beta) RPC="https://api.mainnet-beta.solana.com" ;;
  devnet) RPC="https://api.devnet.solana.com" ;;
  *) echo "Unsupported cluster: $CLUSTER"; exit 1 ;;
esac

RESP=$(curl -s "$RPC" -X POST -H "Content-Type: application/json" -d "{
  \"jsonrpc\":\"2.0\",\"id\":1,
  \"method\":\"getAccountInfo\",
  \"params\":[\"$MINT\", {\"encoding\":\"jsonParsed\"}]
}")

python3 - "$MINT" "$CLUSTER" "$RESP" <<'PY'
import json, sys

mint, cluster, raw = sys.argv[1], sys.argv[2], sys.argv[3]
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
    sev = "critical" if cluster == "mainnet-beta" else "high"
    findings.append({
        "id": "F-mint-001",
        "severity": sev,
        "surface": "mint",
        "observation": f"Mint authority present: {mint_auth}",
        "recommendation": "Revoke or move to multisig before fixed-supply launch",
        "blocks_launch": True,
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
    findings.append({
        "id": "F-freeze-001",
        "severity": "high",
        "surface": "freeze",
        "observation": f"Freeze authority present: {freeze_auth}",
        "recommendation": "Revoke unless required and held by multisig",
        "blocks_launch": True,
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
