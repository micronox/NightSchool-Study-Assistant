# Bucket 4: Nice-to-Haves and MVP Prep — Enhanced Audit

> **Compared against:** `steps/04-nice-to-haves-and-mvp-prep.md` (small thinking model output)
> **Audit date:** 2026-06-18
> **Auditor:** Claude Sonnet 4.6 (full context synthesis across all 10 research files)

---

## A. What the Small Model Got Right

The small model's framing is excellent: these are the "10x" improvements that dramatically
change the workflow after the core stack is stable. The categories it identifies (daily
reports, nightly summaries, cron jobs, memory hygiene, skill libraries, Kanban + profiles
together, dashboard visibility, webhook hooks, client-safe namespaces, Git discipline) all
appear in the research as high-signal, proven improvements from real Hermes OS deployments.

The MVP prep checklist at the end is clean and accurate as a minimum bar. The automation
list and the Git/history discipline section are both well-calibrated.

---

## B. Gaps, Under-Specifications, and Corrections

### B1. No concrete implementation of the automation items
The small model lists nightly review, daily status, stuck-task detection, repo health
checks, memory pruning, vault sync — all correct — but doesn't say how to implement any
of them. Each is a concrete Hermes cron job + skill combination that can be specified.

### B2. "Webhook or notification hooks" was mentioned but not developed
The research (Perplex_5, the webhook automation video reference) covers this explicitly.
Webhooks are a real Hermes feature for inbound/outbound automation: GitHub PR webhooks
triggering Hermes reviews, outbound Telegram/Discord notifications for job completion.
This deserves its own implementation note.

### B3. Memory hygiene was underspecified
"Automatic summaries," "periodic cleanup" are correct but need mechanics. The research
shows the specific pattern: a memory-hygiene skill that reads session logs, condenses them,
writes summaries to vault, and removes stale built-in memory entries. The cron schedule
and trigger conditions matter.

### B4. Client-work prep was listed without cross-referencing the isolation model
The items in §5 of the small model overlap heavily with Bucket 1 (client isolation). The
nice-to-haves here should be additive to what Bucket 1 establishes — things like billing
summaries, portfolio generation, and Upwork-specific automation that go beyond the safety
baseline.

### B5. "Hermes Dreaming niceties" overlaps with Bucket 2
The auto-synthesized notes, skill suggestions from repeated work, and task decomposition
are already covered as the core Dreaming loop in Bucket 2. In this bucket they should be
framed as the automation layer on top of the manual Dreaming profile — specifically the
cron-driven versions that run without prompting.

### B6. Missing: the external channel integration layer
The research explicitly mentions Telegram/Discord/Slack as notification and control
channels for Hermes OS at the "nice-to-have" tier. This is a meaningful quality-of-life
upgrade that the small model omitted.

---

## C. Complete Description

The Nice-to-Haves and MVP Prep bucket covers two distinct things that are easy to conflate:

**MVP Readiness Criteria:** A checklist of what the system must be able to do before you
can call it a working Hermes OS. This is a hard threshold, not a wishlist. Below this line,
you have a partially-working system. Above it, you have an OS you can rely on for real work.

**Nice-to-Have Automation Layer:** The set of improvements that you layer on after MVP is
stable. These are not optional eventually — they're what makes the OS feel dramatically
better and self-sustaining. They include: automated reporting, nightly synthesis, memory
hygiene, webhook integration, external channel notifications, and advanced Git discipline.
Each of these has a concrete implementation as a Hermes skill + cron job.

The right framing: MVP gets you a reliable machine. Nice-to-haves make the machine feel
alive and self-improving.

**The "10x" improvements, ranked by impact:**

1. **Daily report skill + nightly cron** — you stop losing track of what happened and can
   hand context to the next session automatically.

2. **Memory hygiene cron** — built-in memory stops degrading over time; vault stays clean.

3. **Vault sync cron** — Hermes and Obsidian stay in agreement without manual intervention.

4. **Webhook integration** — GitHub PRs, build failures, or Upwork messages can trigger
   Hermes jobs automatically.

5. **External channel notifications** — Telegram or Discord DMs when overnight jobs
   complete, fail, or produce interesting proposals.

6. **Skill improvement planner** — Dreaming spots patterns and proposes new skills before
   you notice the repetition manually.

7. **Project retrospective skill** — at the end of each client engagement or sprint, a
   structured summary is automatically written to the vault.


---

## D. Implementation Plan

### Phase 1 — Confirm MVP Threshold (Before Any Nice-to-Haves)

The MVP checklist from the small model is the right gate. Do not move to Phase 2 until
every item is confirmed working. The MVP criteria (from the small model, annotated):

- [ ] WSL Hermes gateway starts and is accessible from Windows Desktop (Bucket 1, Phase 1)
- [ ] Windows Desktop connects in remote mode (Bucket 1, Phase 1)
- [ ] At least one profile exists and is configured (Bucket 1, Phase 2)
- [ ] Built-in memory contains global preferences and operating rules (Bucket 1, Phase 3)
- [ ] Vault is mounted in WSL and Hermes can read/write it (Bucket 1, Phase 3)
- [ ] At least 3 skills exist and can be invoked (Bucket 1, Phase 4)
- [ ] `client-dev` profile is configured with local-only provider (Bucket 1, Phase 6)
- [ ] Git commit history exists for at least one personal project (simple discipline)
- [ ] Kanban board is visible and has at least one active card (Bucket 3, Phase 3)

**Gate rule:** all nine items confirmed → proceed to nice-to-haves.

### Phase 2 — Daily Report + Nightly Summary (Week 1 after MVP)

This is the first and most impactful nice-to-have. Implement it as two skills and one
cron job per active profile:

**`daily-report` skill** (should exist from Bucket 1 starter pack):
```
Skill: daily-report
Steps:
  1. Read recent session summaries from ~/.hermes/sessions/ (last 24 hrs)
  2. Read recent git log from ~/projects/ (last 24 hrs)
  3. Read the current Kanban board state for this profile
  4. Produce a structured note:
     - What was worked on
     - What was completed
     - What is still open
     - Any blockers or surprises
  5. Write to vault/Products/HermesOS/daily/<YYYY-MM-DD>-<profile>.md
```

**Cron job per profile:**
```bash
hermes job add --profile myku-dev --cron "0 23 * * *" \
  --task "daily-report --profile myku-dev"

hermes job add --profile client-dev --cron "0 23 * * *" \
  --task "daily-report --profile client-dev"
```

**`nightly-summary` skill** (for the Dreaming profile, broader synthesis):
```
Skill: nightly-summary
Steps:
  1. Read all daily-report outputs from today
  2. Identify cross-project themes, risks, and unresolved questions
  3. Write a synthesis note to vault/Products/HermesOS/nightly-queue.md
  4. Propose the highest-priority task for tomorrow
```

### Phase 3 — Memory Hygiene Cron (Week 2 after MVP)

Memory hygiene prevents both the built-in MEMORY.md and the vault from becoming stale
or contradictory.

**`memory-hygiene` skill:**
```
Skill: memory-hygiene
Steps:
  1. Read current MEMORY.md for the active profile
  2. Identify entries older than 30 days that have not been referenced in recent sessions
  3. Flag for removal or condensation (DO NOT auto-delete; write flagged items to a review list)
  4. Read vault/Products/HermesOS/ for notes older than 60 days
  5. Propose archive actions (move to vault/Archive/) — again, for human review
  6. Write hygiene report to vault/Products/HermesOS/memory-hygiene-<date>.md
```

Weekly cron on Sunday night:
```bash
hermes job add --profile hermes-dreaming --cron "0 4 * * 0" \
  --task "memory-hygiene --all-profiles"
```

### Phase 4 — Vault Sync Cron (Week 2 after MVP)

Keeps the Obsidian vault in sync with what Hermes produces. Two-directional:
- Hermes writes → vault (already handled by skills that write directly)
- Vault changes → Hermes awareness (new notes the human added)

**`vault-sync` skill:**
```
Skill: vault-sync
Steps:
  1. List all .md files in vault/ modified in the last 24 hours
  2. For each file not already known to the active profile's memory:
     - Add a brief reference to MEMORY.md: file path + one-line summary
  3. For any Hermes-generated notes with "DRAFT" in the title:
     - Check if human has edited them (file mtime vs hermes write time)
     - If edited: promote to "curated" status, remove DRAFT flag
  4. Write sync log to vault/Products/HermesOS/vault-sync-<date>.md
```

Nightly cron:
```bash
hermes job add --profile hermes-dreaming --cron "30 2 * * *" \
  --task "vault-sync"
```

### Phase 5 — Webhook Integration (Month 2)

Webhooks let external events trigger Hermes jobs. The two most valuable for your stack:

**GitHub PR webhook → Hermes diff-review:**
```
When a PR is opened in ~/projects/myku/ or ~/projects/clients/<name>/:
  → Trigger: hermes job run --profile <relevant-profile> \
       --task "diff-review --pr <PR_URL>"
  → Output: PR review note written to vault/Products/<project>/pr-reviews/<date>.md
  → Notify: write summary to configured notification channel
```

Set up the webhook receiver:
- Hermes has native webhook/job endpoint support via the gateway
- GitHub webhook → POST to `http://your-wsl-ip:9119/webhooks/github`
- Configure in `config.yaml` or via admin dashboard

**Build failure webhook → Hermes diagnosis:**
```
When CI/CD fails:
  → Trigger: run env-audit + read the build log
  → Output: diagnosis note with proposed fixes
```

### Phase 6 — External Channel Notifications (Month 2)

Connect Hermes to Telegram or Discord so overnight jobs report to you asynchronously:

```yaml
# ~/.hermes/config.yaml (or profile config)
notifications:
  channel: telegram
  telegram:
    bot_token: <your-bot-token>
    chat_id: <your-chat-id>
  triggers:
    - on: job_complete
    - on: job_failure
    - on: nightly_summary_ready
```

Useful triggers:
- Nightly summary ready → sends a one-paragraph digest to your phone
- Cron job failure → immediate alert
- Dreaming proposed a new skill → sends the proposal for your review

### Phase 7 — Advanced Git Discipline (Ongoing)

Git discipline is the one nice-to-have that is actually a discipline, not a skill.
It cannot be automated away — it requires habit. The concrete practices:

```bash
# Tag major Hermes OS milestones:
git tag -a v0.1.0-mvp -m "MVP: all 5 profiles, 7 skills, OpenViking, daily reports"

# Branch naming convention:
feat/<profile>/<what>        # e.g., feat/myku-dev/scene-scaffold-skill
fix/<profile>/<what>         # e.g., fix/client-dev/safety-check-false-positive
chore/hermes-os/<what>       # e.g., chore/hermes-os/memory-hygiene-cron

# Commit message convention:
[<profile>] <imperative verb> <what>
# e.g., [myku-dev] add repo-onboard skill with shader detection
# e.g., [client-dev] harden safety-check for API key exposure

# Weekly: tag the state of ~/.hermes as a git snapshot (keep it in version control)
cd ~/.hermes
git init (if not already)
git add -A && git commit -m "weekly snapshot: $(date +%Y-%m-%d)"
```


---

## E. Design Spec Sheet

### MVP Threshold (All Must Pass)

| # | Criterion | Verified by |
|---|-----------|-------------|
| 1 | WSL gateway running and accessible on port 9119 | `hermes --version` + Desktop remote connect |
| 2 | Desktop connects in remote mode | Desktop UI shows connected to `http://localhost:9119` |
| 3 | At least one profile configured | `hermes profile list` shows ≥ 1 |
| 4 | Built-in memory populated with identity and rules | `cat ~/.hermes/profiles/*/MEMORY.md` non-empty |
| 5 | Vault mounted and accessible to Hermes file tools | Tool reads from `/mnt/l/Vaults/` successfully |
| 6 | At least 3 skills invocable | Manually run 3 skills, each produces expected output |
| 7 | `client-dev` profile has local-only provider | `cat ~/.hermes/profiles/client-dev/.env` has no OPENROUTER key |
| 8 | Git history exists for at least one project | `git log` in one project shows meaningful commits |
| 9 | Kanban board visible with active card | WebUI or Dashboard shows ≥ 1 board with ≥ 1 card |

### Nice-to-Have Priority Matrix

| Feature | Implementation | Profile | Cron schedule | Priority | MVP required? |
|---------|---------------|---------|---------------|----------|--------------|
| Daily report | `daily-report` skill | All active | Nightly 23:00 | P0 | No |
| Nightly summary | `nightly-summary` skill | hermes-dreaming | Nightly 23:30 | P0 | No |
| Memory hygiene | `memory-hygiene` skill | hermes-dreaming | Weekly Sun 04:00 | P1 | No |
| Vault sync | `vault-sync` skill | hermes-dreaming | Nightly 02:30 | P1 | No |
| GitHub webhook | Gateway webhook config | Relevant profile | Event-driven | P2 | No |
| Build failure webhook | Gateway webhook config | infra-ops | Event-driven | P2 | No |
| Telegram notifications | `config.yaml` channel | All | On job events | P2 | No |
| Skill improvement planner | `skill-improvement-planner` skill | hermes-dreaming | Weekly Mon 06:00 | P3 | No |
| Project retrospective | `project-retro` skill | Relevant profile | End of engagement | P3 | No |
| MyKu 3D scene catalog | `scene-catalog` skill | myku-dev | On scene creation | P4 | No |
| Portfolio generator | `portfolio-gen` skill | client-dev | On engagement close | P4 | No |

### Cron Job Master Schedule

| Time | Day | Job | Profile |
|------|-----|-----|---------|
| 23:00 | Daily | `daily-report` | myku-dev, ai-docs-dev |
| 23:00 | Daily | `daily-report` | client-dev |
| 23:30 | Daily | `nightly-summary` | hermes-dreaming |
| 02:30 | Daily | `vault-sync` | hermes-dreaming |
| 03:00 | Daily | `nightly-queue` (Dreaming proposals) | hermes-dreaming |
| 04:00 | Sunday | `memory-hygiene --all-profiles` | hermes-dreaming |
| 06:00 | Monday | `skill-improvement-planner` | hermes-dreaming |

### Skill Specs for Nice-to-Have Tier

```yaml
# daily-report/skill.yaml
name: daily-report
version: 0.1.0
description: Reads session history and git log, produces daily status note
tools_required: [file_read, file_write, shell]
profiles: [global]
output: vault/Products/HermesOS/daily/{date}-{profile}.md
cron: "0 23 * * *"

# memory-hygiene/skill.yaml
name: memory-hygiene
version: 0.1.0
description: Flags stale memory entries and proposes archive actions
tools_required: [file_read, file_write, memory_recall]
profiles: [hermes-dreaming]
output: vault/Products/HermesOS/memory-hygiene-{date}.md
cron: "0 4 * * 0"

# vault-sync/skill.yaml
name: vault-sync
version: 0.1.0
description: Syncs vault changes to profile memory awareness
tools_required: [file_read, file_write, file_list]
profiles: [hermes-dreaming]
output: vault/Products/HermesOS/vault-sync-{date}.md
cron: "30 2 * * *"
```

---

## F. Step-by-Step Implementation Checklist

### MVP Gate
- [ ] **F1.** Confirm all 9 MVP threshold criteria (table above)
- [ ] **F2.** Document the pass date: MVP confirmed on `<date>`

### Daily Report + Nightly Summary
- [ ] **F3.** Verify `daily-report` skill exists from Bucket 1 work
- [ ] **F4.** Test `daily-report` manually for `myku-dev` profile
- [ ] **F5.** Confirm output lands in vault at correct path
- [ ] **F6.** Add daily report cron job for `myku-dev`
- [ ] **F7.** Add daily report cron job for `client-dev`
- [ ] **F8.** Write `nightly-summary` skill
- [ ] **F9.** Add nightly-summary cron job for `hermes-dreaming`

### Memory Hygiene
- [ ] **F10.** Write `memory-hygiene` skill
- [ ] **F11.** Run manually first and review its output before adding cron
- [ ] **F12.** Add weekly memory-hygiene cron job
- [ ] **F13.** Review first automated run output and confirm it's not deleting things it shouldn't

### Vault Sync
- [ ] **F14.** Write `vault-sync` skill
- [ ] **F15.** Test manually: add a new Obsidian note, run vault-sync, confirm it appears in MEMORY.md reference
- [ ] **F16.** Add nightly vault-sync cron job

### Webhook Integration
- [ ] **F17.** Identify which repos to wire (start with one: myku or one client repo)
- [ ] **F18.** Configure GitHub webhook to POST to WSL gateway webhook endpoint
- [ ] **F19.** Test: open a PR, confirm Hermes receives the webhook and runs diff-review
- [ ] **F20.** Confirm output lands in vault

### External Channel Notifications
- [ ] **F21.** Set up a Telegram bot (BotFather) or Discord webhook
- [ ] **F22.** Add notification config to `~/.hermes/config.yaml`
- [ ] **F23.** Test: trigger a manual job and confirm notification arrives
- [ ] **F24.** Set notification triggers: job_complete, job_failure, nightly_summary_ready

### Git Discipline
- [ ] **F25.** Initialize `git init` in `~/.hermes` (if not already)
- [ ] **F26.** Create `.gitignore` in `~/.hermes` to exclude `.env` and large binaries
- [ ] **F27.** Make first meaningful commit: "initial MVP state"
- [ ] **F28.** Tag it: `git tag -a v0.1.0-mvp`
- [ ] **F29.** Establish branch naming convention (document in vault)
- [ ] **F30.** Add weekly snapshot to cron: `git add -A && git commit -m "weekly: $(date +%Y-%m-%d)"`

---

## G. Divergences from Small Model Plan

| Small model said | Audit verdict | Correction |
|-----------------|---------------|------------|
| "webhook or notification hooks" listed without spec | Incomplete | Add webhook config, cron triggers, Telegram/Discord setup |
| Memory hygiene items listed without mechanics | Incomplete | Add `memory-hygiene` skill spec and flagging vs auto-delete rule |
| Client-work prep overlaps with Bucket 1 | Partially redundant | Reframe as additive: billing, portfolio, Upwork automation on top of safety baseline |
| "Hermes Dreaming niceties" listed without cron wiring | Incomplete | Add `skill-improvement-planner` and `project-retro` as skills with cron schedules |
| MVP checklist was correct | Confirmed | Kept with verification column added |
| Git discipline items were correct | Confirmed | Added branch naming convention and `~/.hermes` git repo setup |

---

*Source cross-references: `Perplexity_Hermes-on-WSL` §4.4–7.3, `Perplex_2_Designing-Mission-Control` §1–3,
`Perplex_3_memory` §4, `Perplex_4_client-work` §5–6, `Perplex_5_github-youtube` §webhook-automation,
`Perplex_6_skills` §4, `steps/04-nice-to-haves-and-mvp-prep.md`*
