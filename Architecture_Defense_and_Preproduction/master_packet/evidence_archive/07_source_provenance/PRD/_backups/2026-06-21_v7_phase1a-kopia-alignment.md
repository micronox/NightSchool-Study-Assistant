# NightSchool — Local Hermes Study Companion
## PRD, Isolation Architecture, Architecture Defense System, Context Management, and Session-Bounded Execution

**Owner:** operator
**Target hardware:** Local workstation, Blackwell RTX 6000 (full GPU), 96GB RAM, Nous subscription (Nemotron Super + Ultra — primary model lanes)
**Confirmed dir:** `$PROJECTS_ROOT\Nightschool_Study\` — outside `/operator` user scope, contains `Prototype_workingFiles\` and `App_Final_Deliverable\`
**Date:** 2026-06-21 (v3)
**Status:** Active — pre-architecture-defense pass complete, Phase 0 execution next
**File location:** `Prototype_workingFiles\PRD\NightSchool_PRD_and_Execution_System.md` (this is always the master — filename never gets a version number appended)

---

## Revision Log

| Date | Version Tag | Changed By | What Changed | Backup File |
|---|---|---|---|---|
| 2026-06-21 | v2 | Claude (chat) | Added Architecture Defense (Lane F), Context Management, confirmed WSL dir structure, Discord master-server research, GPU/Nous routing, User Instructions appendix | `_backups\2026-06-21_v1_pre-defense-system.md` |
| 2026-06-21 | v3 | Claude (Cowork) + Codex | Pre-architecture-defense pass: PRD filename corrected, _backups folder created, Ollama+Qwen3.6 confirmed as local stack, Nemotron routing tiers adopted, Architecture_Defense folder classified, Phase 0/1 scope realigned, Before Phase 0 prereqs corrected, Open Question on GPU runtime closed | `_backups\2026-06-21_v2_pre-review-rename.md` |
| 2026-06-21 | v4 | Claude (Cowork) | Frontier-first routing policy: §5 rewritten with explicit Model Routing Policy rules (frontier-first, Qwen as fallback only); Lane F routing audit added to isolation_manifest; pyenv+nvm installed (nvm 0.40.3, Node 22.23.0), setup scripts written, DEPENDENCIES.md and isolation_manifest.md created, .nvmrc and .python-version pins set | `_backups\2026-06-21_v3_pre-routing-policy.md` |
| 2026-06-21 | v5 | Claude (Cowork) | Phase 0 COMPLETE: all cards ticked; WSL=/mnt/l confirmed; Hermes v0.5.6 baselined; Ollama+qwen3.6:35b-a3b verified; port range 8100-8199 reserved; qwen3.6:latest→qwen3.6:35b-a3b corrected throughout; isolation_manifest primary Hermes section filled; Phase 0 verification note written | `_backups\2026-06-21_v4_pre-phase0-close.md` |
| 2026-06-21 | v6 | Claude (Cowork) | Phase 1 Hermes discovery complete: native profile isolation confirmed via HERMES_DESKTOP_USER_DATA_DIR + HERMES_HOME env vars (source-verified from app.asar); Phase 1 cards updated with specific implementation detail; PRD Phase 1 definition updated per Option A decision; isolation_manifest updated with NightSchool profile paths | *(no backup — cards-only update)* |

*Add a new row every time the master file is edited. See "Revision Control" section immediately below for the backup-before-edit rule.*

---

## Revision Control (read before editing this file)

This project uses lightweight folder-based version control instead of git for the Prototype working drafts — git is reserved for the eventual `App_Final_Deliverable` → GitHub push, not for in-progress PRD edits.

**Folder structure:**
```
Prototype_workingFiles\
└── PRD\
    ├── NightSchool_PRD_and_Execution_System.md     ← master, always current
    └── _backups\
        ├── 2026-06-21_v1_pre-defense-system.md
        └── (one snapshot per meaningful revision)
```

**Rules — any agent or session editing this file must follow these:**
1. **The master filename never changes.** No version numbers in the filename itself — version tags live in the Revision Log table above and in the backup filenames only.
2. **Copy before you edit, not after.** Before making any change to this master file, copy the *current, pre-edit* version into `_backups\` with the naming convention `YYYY-MM-DD_vN_short-reason.md`. Editing first and backing up second risks backing up the already-changed version, which defeats the point.
3. **One backup per session/phase close, not per line edit.** Tie backup creation to the same cadence as phase status notes in `handoffs\` — a backup should correspond to a meaningful checkpoint (a phase closing, a major section added), not every small wording fix.
4. **Add a Revision Log row for every backup created**, so the history is visible at a glance without opening every backup file individually.
5. **If you're an agent and unsure whether a change is "meaningful" enough to warrant a backup, default to creating one.** A redundant backup costs nothing; a missing one loses history permanently.

---

## 0. What Changed Since v1
This revision adds, per your direction:
1. An **Architecture Defense System** as a first-class spec component, not an afterthought bolted onto Phase 5.
2. Explicit **context management** as a cross-cutting concern, sized for both Codex and Claude sessions.
3. A confirmed **WSL working-folder structure** (`Prototype_workingFiles` → `App_Final_Deliverable` → GitHub) replacing the earlier generic install-root assumption.
4. Researched **Discord master-server vs. per-project-server** tradeoff, with a recommendation.
5. **GPU + Nous subscription** model-routing decision baked into agent persona design.
6. A **"User Instructions" appendix** — the literal pre-session checklist of things only you can do (account creation, button clicks, key generation) attached to each phase, so no session stalls waiting on you mid-flight.

---

## 1. Confirmed Local Directory Architecture

Your screenshot confirms the structure. This replaces the v1 assumption of a single `~/hermes-nightschool` root with your actual layout:

```
`$PROJECTS_ROOT\
├── Architecture_Defense\        ← Adjacent planning/audit context. Contains
│                                   Codex pre-install snapshots and headroom
│                                   vetting docs. In scope for audit/history/
│                                   reference. NOT the NightSchool app root —
│                                   agents do not read/write here during the
│                                   build. Out of scope for Prototype_workingFiles
│                                   write operations.
└── Nightschool_Study\
    ├── Prototype_workingFiles\  ← Hermes' live working directory. All agent
    │                               read/write, revisions, experiments,
    │                               broken builds, half-finished features
    │                               live here. Nothing here is "shippable"
    │                               by default.
    └── App_Final_Deliverable\   ← Clean-room target. Nothing gets written
                                    here directly by an agent mid-task.
                                    Promotion is a deliberate, verified,
                                    controller-gated step (see §2.1).
                                    This folder is what gets pushed to
                                    GitHub.
```

**Why this matters for isolation:** putting `Nightschool_Study\` under `L:\` rather than under your Windows user profile or your primary Hermes install path is itself the isolation boundary — the primary/worker Hermes lives elsewhere (outside `$PROJECTS_ROOT\`) and is treated as an external, read-only reference for Lane F drift checks. Inside WSL, this will mount as something like `/mnt/l/WSL_Projects_Folder/Nightschool_Study/` — confirm the exact WSL mount point in Phase 0 (don't assume `/mnt/l/`; verify it).

**Promotion rule (Prototype → Final):** nothing moves from `Prototype_workingFiles` to `App_Final_Deliverable` without passing a Verification card. This is the same Done-with-evidence discipline as the rest of the system, applied specifically to the one transition that has real consequences (GitHub push). Treat `App_Final_Deliverable` the way you'd treat a release branch — agents propose, controller (you, or a controller-thread agent acting on your sign-off) promotes.

---

## 2. Architecture Defense System (new — major component)

This is the piece you flagged as missing. "Architecture Defense" here means: **the system actively protects its own structural integrity against drift, scope creep, agent overreach, and silent corruption of the Prototype/Final boundary** — not just a one-time isolation check at Phase 0. Treat it as a standing subsystem that runs throughout the build and persists after v1 ships.

### 2.1 What it defends against
| Threat | Defense mechanism |
|---|---|
| An agent (or a Codex/Claude session) writes into `App_Final_Deliverable` without going through promotion | Filesystem-level: agents' working directory is pinned to `Prototype_workingFiles` only. `App_Final_Deliverable` is **not** in any agent's default write scope — it's touched only by an explicit promotion action, logged. |
| Cross-contamination with your primary/worker Hermes install | Phase 0 isolation verification + a recurring "drift check" card re-run periodically, not just once — config roots, venv paths, and bot tokens diffed against the primary install's known values. |
| Scope creep — agents quietly expanding beyond the six-agent design (e.g., Dev starts doing Scholar's job) | Each `soul.md` includes an explicit **boundary statement** ("Dev does not write study content; Scholar does not touch the dashboard codebase") and the controller thread spot-checks task-log entries against persona boundaries. |
| Silent partial failures presented as "done" | Evidence field mandatory (carried from v1). Architecture Defense adds: a **second-pass review** card at the end of each phase where the controller (not the building agent) re-checks the evidence, not just the builder self-certifying. |
| Dependency rot / unverified package installs into either Prototype or your primary install | All installs happen inside `Prototype_workingFiles`' own isolated Python/Node scope. No global pip/npm installs. Every new dependency gets a one-line entry in a `DEPENDENCIES.md` inside Prototype, so the defense system has a manifest to diff against, not just a `node_modules` folder to trust blindly. |
| GitHub push of something half-broken | `App_Final_Deliverable` promotion requires the Phase 5 smoke test (or equivalent feature-level smoke test) to have a fresh evidence entry **dated after** the most recent change being promoted — stale evidence does not count. |

### 2.2 Standing roles
- **Architecture Defense is not a one-time card — it's a recurring lane**, same tier as Lanes A–E from v1. Call it **Lane F — Architecture Defense.**
- Lane F's job: run the drift check, audit promotion requests, verify persona-boundary compliance, and maintain `DEPENDENCIES.md` and the isolation manifest.
- Lane F reports to the controller thread exactly like the other lanes — it does not have unilateral veto power baked into automation (you stay the actual decision-maker), but it surfaces evidence-backed flags the controller must address before a promotion or merge proceeds.

### 2.3 Where this lives in the kanban
Add a permanent **"Defense"** swimlane alongside the phase columns, populated with recurring cards (not one-and-done):
- [ ] Recurring: Drift check — primary install vs. NightSchool isolation (run at start of every session block, not just Phase 0).
- [ ] Recurring: Persona boundary audit (run at end of each phase).
- [ ] Recurring: `DEPENDENCIES.md` diff review (run whenever a new install happens).
- [ ] Gate: Promotion review (run every time something is proposed to move Prototype → Final).

---

## 3. Context Management (cross-cutting, applies to every phase/lane/card)

You confirmed: size for **both** Codex and Claude, no further specifics on numeric budgets — so the spec builds a *method*, not a guessed token number, since the right number depends on what model/context window each tool is actually running at the time of the session.

### 3.1 Principles
1. **One card = one verifiable unit of work**, sized so a single session (Codex or Claude) can read the relevant context, do the work, and produce evidence without needing a mid-task context reset. If a card requires re-reading more than ~3-4 prior files/notes just to understand scope, it's too big — split it.
2. **Status notes are the context-compression layer.** Every phase/card produces a timestamped note. These notes exist specifically so the *next* session — Codex or Claude, doesn't matter which — can load a 1-page note instead of replaying the whole phase's conversation history. This is the actual mechanism that makes cross-tool, cross-session work possible.
3. **Context budget is asymmetric by design, not by accident.** Research/discovery subagent lanes (A, B, Architecture Defense drift checks) can run with smaller, narrower context — they're reading specific files and reporting findings. Build lanes (Dashboard/Dev, Pipeline) need more context because they're holding more state (existing code, schema, prior decisions) — size those cards smaller in *scope* to compensate, not by hoping a bigger context window saves you.
4. **Codex vs. Claude division of labor, by what each is good at holding in context, not just availability:** Codex (via your ChatGPT subscription per the original video pattern) is well-suited to scoped code-execution tasks with a tight, well-defined diff target (install scripts, dependency wiring, single-feature dashboard builds). Claude/Terran-pattern sessions are better suited to the controller-thread role — synthesis across multiple notes, merging subagent findings, writing the phase handoff, resolving contradictions — because that role is read-heavy and judgment-heavy rather than diff-heavy. Recommend: **Codex for Lane D (Dashboard/Dev) and Lane B (Messaging) cards. Claude for Controller-thread duties and Lane F (Architecture Defense) audits**, since defense/audit work is exactly the "synthesize and judge" shape Claude sessions handle well. Lanes A, C, E can go either way depending on which tool has a free session at the time — they're narrow enough not to matter.
5. **Every card states its own context budget intent** as a one-line note on the card itself: e.g., "Context: reads `soul_template.md` + this phase's status note only — should not need Phase 1-3 history." This makes oversized cards visible before they're picked up, not after a session runs out of room mid-task.

### 3.2 Mechanism: the note chain
```
Phase N status note (1 page, timestamped)
   ↓ read by
Phase N+1's first card
   ↓ produces
Phase N+1 status note
   ↓ ...
```
No session should need to read more than: (a) the current phase's relevant cards, (b) the immediately preceding phase's status note, (c) the standing `DEPENDENCIES.md` and isolation manifest if the card touches install/config. That's the entire context contract. If a card seems to require more than that, it's a sign the task is underspecified or too large, and it should be split rather than solved by feeding more history into the session.

---

## 4. Discord: Master Server vs. Per-Project Server (researched)

You asked for research on whether a single master Discord server with project-specific lanes (vs. fully separate servers) is workable for segregated agent teams "under one roof." Short answer: **yes, this is a standard and well-supported pattern, and it's the better fit for your use case than spinning up a new server per project.**

### 4.1 How Discord actually supports this
- A server (guild) is organized into **categories**, and Discord's permission model is built so that **permissions set at the category level automatically propagate to every channel inside it** — this is the exact mechanism for "segregated lanes under one roof." You set NightSchool's category once, and every channel under it (vault/scholar/quizmaster/planner/dev) inherits that scoping without per-channel repetition.
- Permission resolution is layered and computed per-channel: base permissions come from the @everyone role, then role-based permissions apply cumulatively, then channel-specific overwrites can explicitly allow or deny — with channel-specific overwrites taking precedence, and an explicit deny at any level overriding an allow from a previous level. Practically: you can give your NightSchool bot/agents access scoped tightly to the NightSchool category, and a future second-project category stays fully walled off, on the same server.
- Bot-specific gotcha worth flagging now (this will bite you if skipped): channel-level permissions take precedence over a bot's global role permissions, so a bot can have full server-wide access yet still fail to post in a specific channel if that channel's settings block it — the fix is to either grant the bot a dedicated role with the permissions it needs at the category level, or manually grant channel access, since admins often avoid giving bots full Administrator rights for security reasons.
- Scale guidance from current best-practice writeups: most well-organized servers keep to roughly 4-8 top-level categories to balance organization with simplicity — comfortably enough room for NightSchool plus future projects (your headroom/ponytail-style future installs, Nimbalyst, etc.) without the server becoming unmanageable.
- Recommended internal pattern: build broad access at the role level, then use categories and channels for exceptions, rather than minting a new role for every channel-specific rule — keeping structural roles (who can act) separate from identity/project roles (which project a channel belongs to) avoids brittle, hard-to-audit permission stacks as you add projects over time.

### 4.2 Recommendation
**Go with one master Discord server, organized by category-per-project.** Concretely for NightSchool:

```
[NightSchool] (category)
  #ns-vault
  #ns-scholar
  #ns-quizmaster
  #ns-planner
  #ns-dev
  #ns-controller   ← new: a channel for Bill/controller-thread status notes
                       and phase handoffs, visible only to you + the bots
```

- One Discord **application/bot** for NightSchool, scoped via a role tied to the NightSchool category — not Administrator. This satisfies least-privilege without needing a second server.
- Future projects get their own category + their own bot/role, same server. Segregation is enforced by category-level permission inheritance, not by physical server separation.
- Channel naming prefix (`ns-`) is a small but real defense-in-depth measure — makes cross-project bleed visually obvious in logs/screenshots even before checking permissions.
- **One open item for you (Phase 2 user-instruction, see §6):** decide whether your *existing* agent work (if any currently lives on a Discord server) should be migrated into this same master-server pattern, or stay separate. Not required for NightSchool v1 — flagging as a P1 follow-on decision, not a blocker.

---

## 5. GPU + Model Routing (confirmed)

### Confirmed inference stack

| Lane | Model | Access | When to use |
|---|---|---|---|
| **Primary (frontier default)** | Nemotron 3 Super 120b A12b:Free | Nous subscription | Default for all planning, synthesis, research, controller-thread work, and higher-complexity reasoning |
| **Escalation (frontier heavy)** | Nemotron 3 Ultra 550b A55b:Free | Nous subscription | Hard architecture disputes, final design synthesis, high-stakes reviews, one-shot deep reasoning. Use selectively — not the default. |
| **Fallback (local)** | qwen3.6:35b-a3b via Ollama | Local GPU, on-disk | Fallback when frontier is unavailable; mechanical/high-frequency tasks; offline resilience; recovery operations |

### Model Routing Policy (explicit rules — not soft guidance)

**Rule 1 — Frontier-first.** Agents must not silently default to local Qwen when frontier access is available. Nemotron Super is the primary model lane. If an agent or session is running on Qwen when Super is reachable, that is a routing error, not a valid default.

**Rule 2 — Local Qwen is fallback only.** Qwen is for: offline operation, frontier unavailability, mechanical/repetitive execution that does not benefit from frontier reasoning, and recovery operations. It is not the default lane by virtue of being on-disk.

**Rule 3 — Planning and synthesis use frontier.** All controller-thread work, PRD refinement, phase synthesis, research, and higher-complexity reasoning runs on Nemotron Super by default. These tasks must not be silently downgraded to local.

**Rule 4 — Ultra is reserved.** Nemotron Ultra is used selectively for the hardest tasks: architecture disputes, final synthesis passes, high-stakes one-shot reviews. It is not a general-purpose escalation for "when Super seems slow."

**Rule 5 — Lane F audits routing.** Major phase notes must record which model lane was used for significant work items. Lane F may flag model-routing drift if sessions are found defaulting to local Qwen when the PRD says frontier-first. Routing drift is treated the same as other Lane F flags — it must be addressed before the phase closes.

### Per-agent routing

| Agent | Primary lane | Fallback | Notes |
|---|---|---|---|
| Bill (orchestrator) | Nemotron Super | Qwen | Orchestration and synthesis are explicitly frontier work |
| Scholar (research/notes) | Nemotron Super | Qwen | Deep research synthesis requires frontier; note structuring may use local |
| Quiz Master | Nemotron Super | Qwen | Question generation quality benefits from frontier reasoning |
| Planner | Nemotron Super | Qwen | Scheduling logic is mechanical but planning synthesis is frontier |
| Dev (dashboard) | Codex (via Codex CLI) for code generation | Qwen for routine edits | Codex is the primary code lane; Nemotron Super for architecture decisions |
| Vault (storage/logging) | Qwen (local) | — | Mechanical logging and storage — local is appropriate, no frontier required |

*Per-agent routing confirmed in Phase 1 as actual workloads become concrete. The table above is the policy intent; Phase 1 may refine per-agent assignments based on observed behavior.*

### Local runtime (confirmed)
- **Ollama → qwen3.6:35b-a3b** — operationally verified in the primary Hermes environment. Phase 0 confirms reachability from NightSchool isolated install.
- Ollama endpoint is the custom local endpoint; Hermes desktop/runtime is confirmed live against it.

### Remaining open question
Per-agent escalation thresholds: when exactly does a task warrant Nemotron Ultra vs. Super? Resolve empirically in Phase 3+ as workloads are observed. The policy hierarchy (Super default → Ultra for hardest tasks → Qwen for fallback/mechanical) is fixed; the per-task trigger thresholds are not.

---

## 6. User Instructions Appendix — What Only You Can Do

Pulled out explicitly per your request, organized by lane/phase, so a session never stalls mid-task waiting on a human-only action it can't itself perform (account creation, clicking "authorize," copying a token). Do these *ahead of* the phase that needs them, not during.

### Before Phase 0 (Infra)
- [ ] Confirm Python/Node version manager you want NightSchool's Prototype env to use (pyenv/venv, nvm, etc.) — same as primary, or deliberately different?

*Note: WSL mount path and primary Hermes install path are Phase 0 deliverables (things Phase 0 discovers and documents), not prerequisites you need to provide in advance. Phase 0 will locate these via read-only inspection and record them as the Lane F baseline.*

### Before Phase 1 (Isolated Install)
- [ ] Have your ChatGPT Plus/Pro login ready (for Codex auth handshake — the `hermes model` → OpenAI Codex flow requires a browser-based sign-in code).
- [ ] Have your Nous subscription credentials/API key ready and decide where it gets stored (env var inside Prototype's isolated scope — not committed to any file that could land in `App_Final_Deliverable`/GitHub).

*Note: Local GPU runtime is confirmed as Ollama → qwen3.6:35b-a3b (see §5). No decision needed here — Phase 1 wires to the confirmed stack.*

### Before Phase 2 (Messaging)
- [ ] **Telegram:** message @BotFather, create new bot, get the token, save it somewhere you'll paste from (not in chat).
- [ ] **Telegram:** message @userinfobot to get your numeric Telegram user ID, for binding Bill so only you can trigger it.
- [ ] **Discord:** create the master server if it doesn't exist yet, or confirm which existing server you want the `[NightSchool]` category added to.
- [ ] **Discord:** go to the Discord Developer Portal, create a new application + bot for NightSchool, copy the bot token.
- [ ] **Discord:** enable Presence, Server Members, and Message Content intents on the bot (off by default — install will silently misbehave without them).
- [ ] **Discord:** invite the bot to your server with a role scoped to the `[NightSchool]` category — not Administrator.
- [ ] **Discord:** create the `[NightSchool]` category and its channels (`#ns-vault`, `#ns-scholar`, `#ns-quizmaster`, `#ns-planner`, `#ns-dev`, `#ns-controller`) and confirm the bot can see/post in each (Discord's own "View Server As Role" feature is the fastest way to verify this yourself before declaring it done).

### Before Phase 3 (Personas & Logging)
- Nothing human-only required — this phase is agent-writable once Phases 0-2 are confirmed. Your only role: review the drafted `soul.md` files for tone/boundary accuracy before they're considered final.

### Before Phase 4 (Dashboard)
- [x] Port range decided — **8100–8199** (confirmed clear by Phase 0 port audit). Dashboard primary: port 8100.
- [ ] If you want any visual/branding direction for the dashboard, provide it before Lane D starts — avoids a redo cycle.

### Before Phase 5 (Pipeline Smoke Test)
- [ ] Have one real (or representative) PDF ready to use as the test document for the ingestion pipeline.

### Before Phase 6 (Automation, P1)
- [ ] Decide what location/units the weather portion of the morning digest should use.
- [ ] Decide whether the lecture schedule source is a calendar you already maintain (and if so, which one / how Planner should read it) or something net-new.

### Before any Promotion (Prototype → App_Final_Deliverable)
- [ ] Confirm you have a GitHub repo created/ready (or want one created) for the eventual push, and confirm whether it's public or private — affects what, if anything, needs scrubbing before promotion (API keys, tokens, local paths).

---

## 7. PRD (updated)

### Problem Statement
You're building a personal multi-agent study/research companion (NightSchool) on top of a local, isolated Hermes install. The build needs to (a) respect a confirmed Prototype/Final folder separation feeding a GitHub push, (b) defend its own architectural boundaries actively rather than just checking them once, (c) be broken into context-appropriately-sized, session-bounded chunks usable by both Codex and Claude, and (d) route inference frontier-first: Nemotron 3 Super as the primary lane, Nemotron 3 Ultra for escalation, and local Ollama → qwen3.6:35b-a3b as fallback/mechanical only — never the silent default.

### Goals
1. Stand up an isolated NightSchool Hermes instance rooted at `$PROJECTS_ROOT\Nightschool_Study\Prototype_workingFiles\`, zero shared state with the primary install — verified, not assumed.
2. Stand up a standing **Architecture Defense lane (Lane F)** that runs recurring drift/boundary/dependency checks, not a one-time gate.
3. Produce a session-bounded, context-budgeted task breakdown (kanban-ready) usable interchangeably by Codex and Claude sessions, each card stating its own context-read footprint.
4. Replicate the six-agent architecture + Mission Control dashboard locally, with frontier-first model routing: Nemotron Super as primary, Nemotron Ultra for escalation, Qwen as fallback/mechanical only — no VPS/Tailscale dependency for v1.
5. Stand up a single master Discord server with category-scoped segregation (`[NightSchool]` category) per the researched pattern in §4, rather than a dedicated new server.
6. Ship a working document-ingestion pipeline (PDF in → Vault → Scholar → Quiz Master → Planner) inside Prototype as the v1 acceptance bar, with a deliberate, evidence-gated promotion path to `App_Final_Deliverable` and GitHub.

### Non-Goals (v1)
- VPS hosting / 24-7 uptime — local-only.
- Tailscale/remote mobile access — deferred until local-only is proven stable.
- Desktop app shell (Electron/Tauri wrapper) — P2, after the dashboard is stable inside Prototype.
- Multi-user / multi-tenant support.
- Migrating or modifying the primary Hermes/worker install — explicitly forbidden, enforced by Lane F.
- Splitting Discord into multiple servers per project — explicitly decided against in §4.2 in favor of one master server with category segregation.

### User Stories
- As the orchestrator-level user, I want to upload a PDF and have it automatically chunked through Vault → Scholar → Quiz Master → Planner so I don't manually trigger each agent.
- As the user, I want a Mission Control dashboard showing agent activity, task logs, and study tools so I have one pane of glass.
- As the user, I want Bill to send me a morning digest via Telegram so I start the day oriented.
- As the user, I want each specialist agent isolated to its own category-scoped Discord channel so agent context doesn't bleed across tasks.
- As the user, I want every agent action logged to SQLite for an audit trail.
- **New:** As the user, I want nothing to land in `App_Final_Deliverable` or GitHub without a verified, evidence-backed promotion step, so my shipped repo never contains half-finished or untested work.
- **New:** As the user, I want a standing check that NightSchool hasn't drifted into touching my primary Hermes install, so I don't have to re-verify isolation by hand every session.

### Requirements

**P0 — Must Have**
- Isolated NightSchool Hermes install rooted under `Prototype_workingFiles`, own venv/node scope, own config — *Acceptance: config path resolution inside the NightSchool shell shows zero overlap with primary install paths.*
- Lane F (Architecture Defense) operational with at least the drift check and promotion-gate cards functioning.
- New Telegram bot token bound to Bill, restricted to your Telegram user ID.
- Master Discord server with `[NightSchool]` category, scoped bot role (not Administrator), required intents enabled, channels created and verified visible/postable.
- Five specialist agent `soul.md` personas with explicit boundary statements.
- SQLite task-log DB operational and verified.
- Document ingestion pipeline working end-to-end inside Prototype on one test PDF.
- Local web dashboard at `localhost:PORT`, port pre-confirmed by you to avoid collision.
- Ollama → qwen3.6:35b-a3b confirmed reachable from NightSchool isolated install before Phase 3 personas are finalized.

**P1 — Nice to Have**
- Activity heatmap, PDF reader/annotator, flashcards, quizzes, kanban board, Pomodoro timer.
- Morning digest automation.
- Research tool (Scholar web-search trigger).
- Nemotron Super confirmed as primary path for at least Scholar and Bill (via Nous subscription).
- Lane F model-routing audit log active — phase notes recording which model lane was used.
- Tailscale exposure, if confirmed wanted.

**P2 — Future**
- Desktop native shell (Electron/Tauri).
- Reusing this exact controller/subagent/Architecture-Defense pattern for future installs (Nimbalyst, etc.) — same logic as your headroom/ponytail brief.
- Second project category added to the master Discord server, proving out the multi-project segregation pattern for real.

### Success Metrics
- **Leading:** PDF-to-quiz pipeline completes successfully on 3 consecutive test uploads with zero manual intervention, entirely inside Prototype.
- **Leading:** Each kanban card closes within a single agent session (Codex or Claude), no card requires a context reset mid-task.
- **Leading:** Zero drift-check failures across the build (Architecture Defense never has to flag actual contamination of the primary install).
- **Lagging:** Daily/weekly actual use of the morning digest and dashboard over a 2-week period post-launch.

### Open Questions (remaining)
- **[You]** Should existing/other Discord-based agent work (if any) eventually migrate into the same master-server category pattern, or stay permanently separate? Not a v1 blocker.
- **[You]** GitHub repo: existing repo to push `App_Final_Deliverable` into, or net-new? Public or private?
- **[Phase 1]** Per-agent escalation thresholds: which NightSchool agents stay on local Qwen by default, and which tasks should trigger Nemotron Super or Ultra? Resolve after Phase 0 evidence surfaces actual Qwen performance — do not pre-decide.

*Closed: GPU-local inference runtime — confirmed as Ollama → qwen3.6:35b-a3b (operationally verified in primary Hermes environment, Phase 0 will confirm reachability from NightSchool isolated install).*

### Timeline Considerations
No hard deadline. Phasing below replaces a calendar — each phase gates on the prior phase's verification note plus, where applicable, on the relevant items in the §6 User Instructions appendix being complete.

---

## 8. Execution Architecture: Controller + Subagent Swarm, Kanban-Driven (updated with Lane F)

### Kanban structure
- **Columns:** Backlog → Ready → In Progress → Verification → Blocked → Done
- **Permanent swimlane:** Defense (recurring cards, not phase-bound — see §2.3)
- **Card requirements (every card):** Scope, Owner, Acceptance criteria, Evidence field, Rollback note, Timestamp, **Context-read footprint**.

### Subagent lanes
- **Lane A — Infra/Isolation:** install paths, venv/node isolation, port audit, WSL mount verification.
- **Lane B — Messaging:** Telegram bot creation/binding, Discord category/channel/bot setup per §4.2. *(Codex-preferred per §3.1.)*
- **Lane C — Agent Personas:** writes `soul.md` per agent including explicit boundary statements.
- **Lane D — Dashboard/Dev:** one dashboard feature per card. *(Codex-preferred per §3.1.)*
- **Lane E — Pipeline/Verification:** document-ingestion smoke test, task-log DB schema/verification.
- **Lane F — Architecture Defense (new, standing):** drift checks, persona-boundary audits, `DEPENDENCIES.md` maintenance, promotion-gate reviews. *(Claude-preferred per §3.1.)*
- **Controller thread:** dispatches lanes, merges findings, resolves contradictions, holds decision gates, performs final installs/merges and Prototype→Final promotions, writes phase handoff notes. *(Claude-preferred per §3.1.)*

---

## 9. Build Phases (Kanban-Sized Cards, Context-Budgeted)

### Phase 0 — Verification Before Anything Else ✓ COMPLETE
*Context: reads only §1 + your confirmed dir structure. No prior history needed.*
- [x] Card: Delete `Prototype_workingFiles\.tools\` directory — confirmed gone 2026-06-21.
- [x] Card: Confirm WSL mount path — **`L:\ → /mnt/l` (type 9p)**. Full path: `/mnt/l/WSL_Projects_Folder/Nightschool_Study/`.
- [x] Card: Primary Hermes baseline documented — **Hermes Desktop v0.5.6**, config root `$APPDATA_ROAMING_ROOT\Hermes\`, local endpoint `localhost:9119`. Read-only, no modifications. See `isolation_manifest.md`.
- [x] Card: Ollama confirmed — **`qwen3.6:35b-a3b` (23.9GB)** on `localhost:11434`. Test call returned `'ok'`. PASS.
- [x] Card: Port audit complete — ports 3000, 9000, 9119, 11434 in use. **NightSchool reserved range: 8100–8199**. Dashboard primary: 8100.
- [x] Card: `handoffs\` folder present.
- [x] Card: Lane F skeleton complete — `isolation_manifest.md` and `DEPENDENCIES.md` created and populated.
- [x] Card: Phase 0 verification note written — `handoffs\2026-06-21_phase0_verification.md`. **Decision gate: PASSED. Safe to proceed to Phase 1.**

### Phase 1 — Isolated Hermes Profile Lane
*Context: reads Phase 0 status note + this section only.*

**Definition (confirmed 2026-06-21):** "Isolated NightSchool Hermes install" means a second Hermes desktop lane with a separate NightSchool profile/config/state directory, isolated from the primary Hermes profile. This is NOT a pip/npm/venv install. Hermes is a Windows Electron desktop app; isolation is achieved via Electron-style profile separation (e.g. `--user-data-dir` flag or equivalent), not by installing a second copy of the binary.

**Stop rule:** Do not mutate the active primary Hermes profile at any point. If native profile separation is impossible, stop and document the safest fallback before any mutation.

- [x] Card: Discover Hermes profile separation capability — ✓ COMPLETE (2026-06-21). Native isolation confirmed via two env vars. See `handoffs/2026-06-21_phase1_hermes_discovery.md`.
  - `HERMES_DESKTOP_USER_DATA_DIR` — redirects all Electron userData (connection.json, active-profile.json, GUI state). Source-confirmed in `electron/main.cjs` lines 112–116 of app.asar.
  - `HERMES_HOME` — redirects backend agent root (venv, profiles, logs, bootstrap cache). Source-confirmed in `electron/bootstrap-runner.cjs`.
  - Hermes.exe location: `$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe`
- [ ] Card: Create NightSchool Hermes launch script — PowerShell `.ps1` at `scripts\launch_hermes_nightschool.ps1` setting:
  - `HERMES_DESKTOP_USER_DATA_DIR = $APPDATA_ROAMING_ROOT\Hermes-NightSchool`
  - `HERMES_HOME = $USER_HOME\.hermes-nightschool`
  - Then launch: `$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe`
- [ ] Card: First NightSchool Hermes launch — run the launch script; confirm `Hermes-NightSchool\connection.json` is created; verify primary `Hermes\connection.json` is unchanged (Lane F check before and after).
- [ ] Card: Configure NightSchool `connection.json` endpoint — set to NightSchool's own port in the 8100 range, not 9119.
- [ ] Card: Confirm Ollama → qwen3.6:35b-a3b is reachable from the NightSchool Hermes profile (not assumed — verify NightSchool calls the endpoint and receives a response).
- [ ] Card: Confirm per-agent routing defaults — which agents stay local vs. escalate to Nemotron Super. Resolve based on observed behavior, not pre-decision.
- [ ] Card: Configure Nous API key (for Nemotron Super/Ultra tiers) as env var inside isolated NightSchool scope only — never committed to any file.
- [ ] Card: Lane F drift check — confirm `Hermes-NightSchool\` and `.hermes-nightschool\` paths do not overlap with primary `Hermes\` or `.hermes\` paths. Port 9119 must not appear in NightSchool config.
- [ ] Card: Phase 1 status note.

### Phase 2 — Identity & Messaging
*Context: reads Phase 1 status note + §4 (Discord research) + this section.*
- [ ] Card: Telegram bot creation/binding (blocked on your §6 actions).
- [ ] Card: Discord master-server `[NightSchool]` category + channels + scoped bot role (blocked on your §6 actions).
- [ ] Card: Verify bot can see/post in each `#ns-*` channel (use Discord's "View Server As Role" check).
- [ ] Card: Lane F — confirm no Administrator-level bot permissions were granted.
- [ ] Card: Phase 2 status note.

### Phase 3 — Agent Personas & Logging
*Context: reads Phase 2 status note + a `soul.md` template only.*
- [ ] Card: Write `soul.md` for Bill, including explicit boundary statement.
- [ ] Card: Write `soul.md` for Vault, Scholar, Quiz Master, Planner, Dev (batch if context allows; split per-agent if not).
- [ ] Card: Stand up SQLite task-log schema; verify a live write.
- [ ] Card: Lane F — persona boundary audit (confirm no overlapping responsibilities across the six souls).
- [ ] Card: Phase 3 status note.

### Phase 4 — Dashboard (one feature per card, Codex-preferred)
*Context: each feature card reads only the current dashboard codebase state + its own feature spec.*
- [ ] Card: Python back-end scaffold, local-only, bound to your pre-confirmed port range.
- [ ] Card: Front-end shell + activity heatmap.
- [ ] Card: PDF reader/upload tab.
- [ ] Card: Flashcards + quiz interface.
- [ ] Card: Kanban board.
- [ ] Card: Pomodoro timer.
- [ ] Card: Lane F — dependency diff review (every new package this phase introduces gets logged in `DEPENDENCIES.md`).
- [ ] Card: Phase 4 status note with evidence per feature.

### Phase 5 — Pipeline Integration & Smoke Test (v1 ship gate)
*Context: reads Phase 3 + Phase 4 status notes only.*
- [ ] Card: Wire upload → Vault → Scholar → Quiz Master → Planner trigger chain.
- [ ] Card: Run the acceptance test (your test PDF from §6) end to end.
- [ ] Card: Lane F — full drift + boundary + dependency check, fresh evidence (this is the gate that unlocks promotion eligibility).
- [ ] Card: Phase 5 status note — this is the v1 ship gate.

### Phase 6 — Automation & Polish (P1)
- [ ] Card: Morning digest automation (blocked on your §6 weather/calendar decisions).
- [ ] Card: Research tool wiring.
- [ ] Card: Tailscale exposure — only if remote access is confirmed wanted.
- [ ] Card: Phase 6 status note.

### Phase 7 — Promotion to App_Final_Deliverable + GitHub
*Context: reads Phase 5 (and 6, if applicable) status notes + the promotion-gate checklist in §2.1 only.*
- [ ] Card: Lane F promotion-gate review — fresh evidence dated after the most recent Prototype change.
- [ ] Card: Scrub check — confirm no API keys/tokens/local paths are present in anything being promoted.
- [ ] Card: Controller-executed copy from `Prototype_workingFiles` → `App_Final_Deliverable`.
- [ ] Card: GitHub repo push (blocked on your §6 repo decision).
- [ ] Card: Phase 7 status note.

### Phase 8 — Desktop Shell (P2, optional)
- [ ] Card: Evaluate Electron vs. Tauri for wrapping the stable dashboard.
- [ ] Card: Build minimal native shell pointing at `localhost:PORT`.
- [ ] Card: Phase 8 status note.

---

## 10. Verification Standard (unchanged, non-negotiable)
"Done" means the controller has an evidence field on the card showing the exact command/action and result. No phase advances past its gate without this. No promotion to `App_Final_Deliverable` happens without a fresh Lane F gate review. Every phase note is timestamped and saved so any future session — Codex or Claude — can resume cold.

---

## 11. Immediate Next Action
Phase 0 is the only thing that should happen next. Cards are fully scoped in §9 Phase 0. The one remaining user decision before Phase 0 can fully close: confirm which Python/Node version manager you want for the NightSchool isolated env (see §6 Before Phase 0). Everything else in Phase 0 is agent-executable — no other user prerequisites are outstanding.


