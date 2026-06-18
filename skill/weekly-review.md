# Weekly Review Checklist

~30-minute recurring authority ops cadence for live projects.

## Prerequisites

- Current baseline JSON ([authority-drift.md](authority-drift.md))
- List of in-scope assets (mints, programs, multisigs) — changes require explicit add/remove

## Weekly script (same order every week)

### 1. Inventory confirm (5 min)

- [ ] All mints still in scope
- [ ] All programs still in scope
- [ ] Multisig vault unchanged

### 2. Surface re-read (15 min)

For each asset:

- [ ] Mint + freeze ([mint-freeze-authority.md](mint-freeze-authority.md))
- [ ] Metadata ([metadata-authority.md](metadata-authority.md))
- [ ] Upgrade ([upgrade-authority.md](upgrade-authority.md))

### 3. Drift diff (5 min)

- [ ] Run [authority-drift.md](authority-drift.md) against baseline
- [ ] `critical` or `high` drift → [incident-handoff.md](incident-handoff.md) same day

### 4. Pending multisig (5 min)

- [ ] List open Squads proposals touching authorities
- [ ] Run [multisig-verification.md](multisig-verification.md) before any signatures this week

### 5. Update baseline

- [ ] If clean: update `captured_at` timestamp only
- [ ] If intentional authority change: new baseline + document reason in commit message

## Weekly report template

```yaml
weekly_review:
  week_of: "2026-W25"
  assets_reviewed: 4
  drift:
    critical: 0
    high: 0
  pending_multisig: 1
  verdict: clean | investigate | incident
  next_review: "2026-06-25"
```

## When to skip

Never skip if:

- TVL > 0
- Launch was within last 30 days
- Any open incident

## When to escalate frequency

Move to **daily** surface read if:

- Active launch campaign
- Known ecosystem exploit in similar protocol
- Team member with authority access departed

## Delegation

- Engineering sprints / feature work → solana-dev
- Full code audit schedule → audit skills (quarterly, separate calendar)
