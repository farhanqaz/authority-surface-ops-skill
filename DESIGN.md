# Authority Surface Ops Skill — Maintainer Design (v1)

Smallest v1 scoped for **solo builder, <1 week**, **top-5 bounty placement**.

---

## 1. Repository structure

```
authority-surface-ops-skill/
├── LICENSE                          # MIT
├── README.md                        # Problem, install, examples, boundaries
├── DESIGN.md                        # This file
├── install.sh                       # ~/.claude/skills/ or --project
├── skill/
│   ├── SKILL.md                     # Hub: triggers, procedure, routing, report schema
│   ├── mint-freeze-authority.md     # Mint + freeze (SPL + Token-2022)
│   ├── metadata-authority.md        # Metaplex update authority
│   ├── upgrade-authority.md         # BPF upgrade authority
│   ├── multisig-verification.md     # Squads/Realms pre-sign (no governance ops)
│   ├── authority-drift.md           # Baseline JSON + diff methodology
│   ├── launch-checklist.md          # T-7 → T+7 gate
│   ├── weekly-review.md             # 30-min recurring cadence
│   ├── incident-handoff.md          # SEV classify + audit skill routing
│   └── resources.md                 # Program IDs, boundaries vs kit
├── agents/
│   └── authority-ops-engineer.md    # One agent — sufficient for v1
└── commands/
    └── authority-surface-audit.md     # One command — demo-friendly
```

**File count:** 16 files. No tests dir, no bots, no examples/ fixtures in v1 (optional v1.1).

---

## 2. SKILL.md routing architecture

```
User message
    │
    ▼
SKILL.md — classify engagement
    │
    ├── launch_gate ──────► launch-checklist.md
    ├── weekly ───────────► weekly-review.md ──► authority-drift.md
    ├── drift ────────────► authority-drift.md
    ├── anomaly ──────────► incident-handoff.md
    └── point_check ──────► surface module(s)
              │
              ├── mint/freeze ──► mint-freeze-authority.md
              ├── metadata ─────► metadata-authority.md
              ├── upgrade ──────► upgrade-authority.md
              └── multisig ─────► multisig-verification.md
    │
    ▼
Authority Surface Report (YAML)
    │
    ├── escalate: audit_skill ──► solana-dev/security + Trail of Bits ext
    └── escalate: incident ─────► incident-handoff.md (already run)
```

**Token budget:** SKILL.md ~180 lines. Detail only in linked files when task matches routing table.

**Overlap firewall:** SKILL.md frontmatter + resources.md explicitly defer code audit, token creation, user tx debug.

---

## 3. Exact markdown files

| File | Lines (target) | Purpose |
|------|----------------|---------|
| `skill/SKILL.md` | ~180 | Hub, schema, routing, OOS list |
| `skill/mint-freeze-authority.md` | ~90 | SPL + Token-2022 mint/freeze reads + rubric |
| `skill/metadata-authority.md` | ~70 | Metaplex update authority |
| `skill/upgrade-authority.md` | ~75 | ProgramData upgrade authority |
| `skill/multisig-verification.md` | ~90 | Pre-sign checklist (Squads v4 focus) |
| `skill/authority-drift.md` | ~85 | Baseline JSON schema + diff severity |
| `skill/launch-checklist.md` | ~80 | T-7/T-3/T-0/T+0/T+7 |
| `skill/weekly-review.md` | ~70 | 30-min script |
| `skill/incident-handoff.md` | ~95 | SEV0-3, evidence, handoff map |
| `skill/resources.md` | ~60 | IDs, RPC hints, kit boundaries |
| `agents/authority-ops-engineer.md` | ~55 | Agent frontmatter + delegate table |
| `commands/authority-surface-audit.md` | ~65 | Step workflow for judges |
| `README.md` | ~100 | Public-facing |
| `DESIGN.md` | This doc | Maintainer + bounty |

**Total skill content:** ~1,000 lines markdown — achievable in 5–7 days solo.

---

## 4. Agent definitions

### `authority-ops-engineer` (only agent in v1)

| Field | Value |
|-------|-------|
| model | sonnet |
| role | Read authorities, run cadences, emit YAML reports |
| delegates | anchor-engineer (tx build), qa + Trail of Bits (code), token-engineer (create) |
| never | Public comms, launch go-ahead without human signoff |

No second agent in v1 — avoids hub bloat and maintenance.

---

## 5. Optional commands

### `/authority-surface-audit` (include in v1 — high judge demo value)

Single command mirroring the skill's happy path. Optional for users; **required for bounty demo**.

Do **not** add in v1:

- `/authority-drift-watch` (implies bot)
- `/revoke-mint` (coding — dev skill)
- `/squads-payroll` (treasury — OOS)

---

## 6. README outline

1. **One-liner** — live admin surface ops
2. **Problem** — audit = pre-ship; this = post-ship
3. **Table** — 9 focus areas → module files
4. **Install** — `./install.sh`
5. **Usage examples** — 4 prompts (launch, weekly, multisig, drift)
6. **Agent + command** table
7. **Output format** — YAML report mention
8. **Repo structure** tree
9. **Boundaries** — explicit OOS
10. **Related links** — AI Kit, solana-dev, game-skill reference
11. **License** MIT

---

## 7. Judge demo flow (90 seconds)

| Time | Action | Show |
|------|--------|------|
| 0:00–0:15 | Hook | "Audit skills check code. Nobody checks live mint authority after launch." |
| 0:15–0:30 | Prompt | `/authority-surface-audit launch_gate mainnet mint <REAL_OR_DEVNET_MINT> program <ID>` |
| 0:30–0:55 | Live | Agent reads mint (RPC/explorer) → YAML report with `findings[]`, severities |
| 0:55–1:15 | Differentiator | Show `blocks_launch: true` on hot-wallet mint authority; contrast with "audit skill would miss this" |
| 1:15–1:25 | Composability | "Escalate: incident" → incident-handoff.md; code audit → Trail of Bits |
| 1:25–1:30 | Close | Repo link, MIT, slots into kit as ext submodule |

**Prep:** Use a known mainnet mint with **revoked** mint authority (clean) + devnet mint with **open** authority (critical) for contrast.

---

## 8. Acceptance criteria

### Must pass (merge / top-5)

- [ ] MIT LICENSE, public repo
- [ ] `skill/SKILL.md` with frontmatter, routing table, report YAML schema
- [ ] All 9 focus modules exist and are linked from SKILL.md (no broken links)
- [ ] `install.sh` installs skill to `~/.claude/skills/authority-surface-ops`
- [ ] README: problem, install, ≥4 usage examples, boundaries
- [ ] One agent + one command with valid frontmatter
- [ ] Demo: `/authority-surface-audit` produces structured report on real address
- [ ] Explicit OOS: no treasury, payroll, governance, compliance, bots
- [ ] resources.md maps boundaries vs solana-dev, token-engineer, audit skills
- [ ] No user-facing "funds are safe" templates

### Quality signals (top-5 vs top-10)

- [ ] Severity rubric consistent across surface modules
- [ ] Baseline JSON schema documented and example-ready
- [ ] Launch `no-go` demo on insecure devnet fixture
- [ ] Human signoff reminder on launch verdict
- [ ] Submission questionnaire: competing skill = safe-solana-builder / token-engineer with gap analysis

### Not required for v1 acceptance

- Submodule PR to solana-ai-kit (bonus)
- Test fixtures directory
- install-custom.sh
- CLAUDE.md overlay

---

## 9. What NOT to build in v1

| Do not build | Why |
|--------------|-----|
| Monitoring bot / cron / webhook | Scope creep, maintenance, "product not skill" |
| Treasury runway / payroll | Explicit exclusion |
| Governance / Realms voting ops | Explicit exclusion |
| Tax / compliance / legal | Seed is crypto-legal-skill |
| User tx triage / support templates | Overlaps `/debug-user-tx` |
| Code audit checklists | Overlaps Trail of Bits / safe-solana-builder |
| Token creation guides | Overlaps token-engineer |
| Automated Slack/Discord alerts | Bot territory |
| Second agent (incident commander) | Fold into incident-handoff.md |
| Rust/TS scripts in repo | Prefer RPC + explorer; scripts = maintenance |
| 20+ fixture txs | v1.1; demo uses live devnet mint |
| Full Realms governance module | Identify authority holder only |

---

## Week plan (solo builder)

| Day | Deliverable |
|-----|-------------|
| 1 | SKILL.md + resources.md + report schema |
| 2 | mint-freeze + metadata + upgrade modules |
| 3 | multisig + drift + baseline schema |
| 4 | launch + weekly + incident modules |
| 5 | agent + command + install.sh |
| 6 | README + devnet demo + record 90s video |
| 7 | Questionnaire, tweet, polish links, submit |

---

## Bounty questionnaire cheatsheet

- **Competing skill:** safe-solana-builder, Trail of Bits (pre-deploy code); token-engineer (creation). Gap: **live authority state ops**.
- **New vs existing:** New repo, addon pattern like solana-game-skill.
- **Market fit:** Founder who lost sleep over "did we revoke mint?" — ops, not coding.
