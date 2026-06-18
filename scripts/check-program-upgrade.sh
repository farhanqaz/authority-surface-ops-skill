#!/usr/bin/env bash
# Read-only BPF upgrade authority check via public RPC
set -euo pipefail

PROGRAM="${1:?Usage: check-program-upgrade.sh <PROGRAM_ID> [cluster]}"
CLUSTER="${2:-mainnet-beta}"

case "$CLUSTER" in
  mainnet-beta) RPC="https://api.mainnet-beta.solana.com" ;;
  devnet) RPC="https://api.devnet.solana.com" ;;
  *) echo "Unsupported cluster: $CLUSTER" >&2; exit 1 ;;
esac

export PROGRAM CLUSTER RPC
python3 <<'PY'
import base64, json, os, sys, urllib.request

program_id = os.environ["PROGRAM"]
cluster = os.environ["CLUSTER"]
rpc = os.environ["RPC"]

ALPHABET = b"123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

def b58encode(b: bytes) -> str:
    n = int.from_bytes(b, "big")
    res = bytearray()
    while n > 0:
        n, r = divmod(n, 58)
        res.insert(0, ALPHABET[r])
    pad = len(b) - len(b.lstrip(b"\0"))
    return (ALPHABET[0:1] * pad + res).decode()

def rpc_call(addr: str) -> dict:
    body = json.dumps({
        "jsonrpc": "2.0", "id": 1,
        "method": "getAccountInfo",
        "params": [addr, {"encoding": "base64"}],
    }).encode()
    req = urllib.request.Request(rpc, data=body, headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read())

prog = rpc_call(program_id)["result"]["value"]
if not prog:
    print("error: program account not found", file=sys.stderr)
    sys.exit(1)

if prog["owner"] != "BPFLoaderUpgradeab1e11111111111111111111111":
    print("error: not upgradeable BPF (owner: %s)" % prog["owner"], file=sys.stderr)
    sys.exit(1)

prog_bytes = base64.b64decode(prog["data"][0])
pd_addr = b58encode(prog_bytes[4:36])

pd = rpc_call(pd_addr)["result"]["value"]
if not pd:
    print("error: program data account not found", file=sys.stderr)
    sys.exit(1)

pd_bytes = base64.b64decode(pd["data"][0])
# ProgramData: u32 tag (3) + u64 slot + COption<Pubkey> (1 tag + 32 key)
tag = pd_bytes[12]
if tag == 0:
    upgrade_auth = None
    obs = "Upgrade authority revoked (immutable deployment)"
    sev = "info"
    blocks = False
    rec = "Confirm immutability matches team policy"
else:
    upgrade_auth = b58encode(pd_bytes[13:45])
    obs = f"Upgrade authority present: {upgrade_auth}"
    sev = "critical" if cluster == "mainnet-beta" else "high"
    blocks = True
    rec = "Transfer to multisig or revoke before accepting external TVL"

findings = [{
    "id": "F-upg-001",
    "severity": sev,
    "surface": "upgrade",
    "observation": obs,
    "recommendation": rec,
    "blocks_launch": blocks,
}]
blocking = [f["id"] for f in findings if f["blocks_launch"]]
report = {
    "report_version": 1,
    "mode": "point_check",
    "cluster": cluster,
    "assets": [{"type": "program", "address": program_id, "program_data": pd_addr}],
    "findings": findings,
    "launch_verdict": "no-go" if blocking else "go",
    "blocking_findings": blocking,
    "escalate": "incident" if sev == "critical" else "none",
}

def emit_yaml(obj, indent=0):
    sp = "  " * indent
    if isinstance(obj, dict):
        for k, v in obj.items():
            if isinstance(v, (dict, list)):
                print(f"{sp}{k}:")
                emit_yaml(v, indent + 1)
            else:
                print(f"{sp}{k}: {json.dumps(v) if isinstance(v, (str, bool)) else v}")
    elif isinstance(obj, list):
        for item in obj:
            if isinstance(item, dict):
                print(f"{sp}-")
                for k, v in item.items():
                    print(f"{sp}  {k}: {json.dumps(v) if isinstance(v, (str, bool)) else v}")
            else:
                print(f"{sp}- {item}")

emit_yaml(report)
PY
