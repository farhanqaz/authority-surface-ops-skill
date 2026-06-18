# Incident Escalation Handoff

Authority **anomaly** response — internal ops only. Not public comms.

## Trigger conditions

Enter this flow when any of:

- Drift diff shows `critical` authority change
- Unexpected mint supply increase
- Upgrade authority exercised without release tag
- Multisig member/threshold changed without approval
- Mint/freeze authority moved to unknown pubkey

## First 15 minutes

### 1. Freeze human actions

- [ ] **Stop signing** pending multisig proposals
- [ ] Do not publish "all clear" statements
- [ ] Assign incident lead (human) + scribe

### 2. Preserve evidence

Capture immediately:

```yaml
evidence:
  cluster: mainnet-beta
  detected_at: <ISO8601>
  affected_assets: []
  explorer_links: []
  baseline_snapshot_ref: <git sha or file>
  current_read: <Authority Surface Report>
  recent_proposals: []  # Squads URLs
```

### 3. Classify severity

| Level | Criteria | Example |
|-------|----------|---------|
| **SEV-0** | Active drain or mint in progress | Live mint from compromised authority |
| **SEV-1** | Authority compromised, no drain yet | Upgrade key on attacker wallet |
| **SEV-2** | Suspicious but unconfirmed | URI changed, supply unchanged |
| **SEV-3** | False alarm / scheduled change missed in baseline | Planned metadata update |

### 4. Containment (authority-specific)

| Surface | Immediate action |
|---------|------------------|
| Mint authority hot | Revoke if still reachable; pause minting frontend |
| Upgrade authority hot | Do not deploy; assess malicious upgrade tx in mempool/explorer |
| Multisig compromised | Contact other signers; do not approve pending txs |
| Metadata changed | Document URI diff; assess phishing risk separately |

This skill does **not** provide exploit remediation code.

## Handoff map

| Need | Route to |
|------|----------|
| Code vulnerability / malicious program logic | solana-dev → security.md + Trail of Bits ext |
| Formal property check | QEDGen ext skill |
| Transaction forensics (user impact) | `/debug-user-tx` (kit command) — supplemental only |
| Full audit engagement | External auditor — use prior reports as context |

## Internal status template

```yaml
incident:
  id: INC-2026-001
  severity: SEV-1
  status: investigating | contained | resolved | false_alarm
  authority_surfaces: [mint, upgrade]
  owner: <human name>
  next_update: +30min
  public_comms: none  # v1 — human/legal decides
```

## Exit criteria

- [ ] Root cause identified (compromise vs ops mistake vs scheduled)
- [ ] Authorities restored or revoked to known-good state
- [ ] New baseline captured
- [ ] Post-incident entry in weekly review notes
- [ ] Optional: schedule code audit if upgrade authority was involved

## Out of scope

- Twitter/Discord announcement drafts
- Law enforcement / legal
- Insurance claims
- On-chain counter-exploits
