# Bucket 2: Hermes Dreaming Task Ladder — Enhanced Audit

> **Compared against:** `steps/02-hermes-dreaming-task-ladder.md` (small thinking model output)
> **Audit date:** 2026-06-18
> **Auditor:** Claude Sonnet 4.6 (full context synthesis across all 10 research files)

---

## A. What the Small Model Got Right

The three-tier task ladder (small / medium / large) is the correct mental model for how
Hermes Dreaming should operate. This matches the "one automation per week" cadence
recommended across Agent OS content and the self-improving agent loop described in the
`Perplexity_Hermes-on-WSL` §4 material. The prompt pattern at the end of the small model
file is also solid and directly usable.

The output rules (small → note, medium → skill/artifact, large → roadmap/architecture) are
well-calibrated and match how advanced Hermes users actually organize work.

---

## B. Gaps, Under-Specifications, and Corrections

### B1. "Hermes Dreaming" was never defined mechanically
The small model treats Dreaming as an implicit mode. The research reveals it should be
implemented as a dedicated **profile** (`research` or a dedicated `hermes-dreaming` profile)
with a specific SOUL.md that instructs the agent to synthesize, not just execute. It is not
a separate runtime — it is a profile persona configured for high-level reasoning tasks.

### B2. Task ladder had no connection to Kanban
The small model lists tasks but does not connect them to Hermes' native **Kanban board**,
which is the official mechanism for durable task management. Tasks should be cards on a
Kanban board attached to the appropriate profile, not just a markdown list.

### B3. No cron wiring for the "large task" loop
Large tasks (stack architecture, profile architecture, agentic OS roadmap) should be
triggered and tracked via scheduled jobs, not just ad hoc prompts. The nightly synthesis
job pattern from §4.4 of the research is the right implementation vehicle.

### B4. Output destinations were vague
"Write results back into a markdown note" is correct but needs specificity: where in the
vault, in what format, under what naming convention. This matters because the vault is also
the Layer 2 memory and the human editing surface.

### B5. Missing: the skill-from-repeated-work pattern
The research (Perplex_6 §4, Perplex_3 §4) describes a key Dreaming behavior: identifying
when a pattern has been repeated enough to warrant packaging as a skill. This should be
explicit in the task ladder as a medium task category.

---

## C. Complete Description

Hermes Dreaming is the name for the high-level reasoning and synthesis operating mode within
your Hermes OS. It is implemented as one or more Hermes profiles configured with personas
that emphasize synthesis, architecture, and planning rather than direct execution.

The core idea: you have a production Hermes OS doing real work across five profiles. Hermes
Dreaming is the meta-layer that watches the OS evolve, extracts patterns, identifies gaps,
proposes improvements, and feeds those proposals back into the skill library and vault.

The Task Ladder is the concrete queue that Dreaming works from. It is a three-tier system:

**Small tasks** (calibration + reconnaissance): fast, low-risk, typically completed in a
single session. These are the bread-and-butter operations that keep the OS informed about
its own state. Examples: repo scan, config inventory, research condensation, diff review,
note summary. Output: a note, checklist, or updated REPO_MAP.md.

**Medium tasks** (capability building): multi-step, require planning and tool use, produce
durable artifacts. These grow the environment. Examples: write a new skill, wire Obsidian
note capture, design a project manifest format, convert a repeated workflow into a skill,
produce a client brief. Output: a skill file, script, workflow document, or Kanban board
update.

**Large tasks** (architecture and strategy): these are the jobs that only Hermes Dreaming
should own. They require synthesizing across many sessions, files, and sources. Examples:
reconstruct a codebase architecture, design the full Hermes OS operating model, propose
the profile taxonomy, design the memory policy, produce a multi-repo synthesis, plan the
"build Hermes from within Hermes" loop. Output: a roadmap, architecture note, decision log,
or new skill spec. These should be treated as multi-session projects with intermediate
vault checkpoints.


---

## D. Implementation Plan

### Phase 1 — Define the Dreaming Profile (Day 1–2)

Hermes Dreaming is a profile, not a magic mode. Create it as either the `research` profile
(from Bucket 1) or a dedicated `hermes-dreaming` profile. The key is the SOUL.md.

```bash
hermes profile create hermes-dreaming
hermes-dreaming setup   # Ollama primary + OpenRouter for web synthesis
```

SOUL.md content for Dreaming profile:
```markdown
# Hermes Dreaming — Role

You are the synthesis and architecture layer of this Hermes OS.
Your job is NOT to execute small tasks. Your job is to:
- Observe the current state of the OS (skills, profiles, memory, vault)
- Identify patterns, gaps, contradictions, and opportunities
- Propose next skills to build, next architecture decisions to make
- Break large goals into ordered task ladders
- Write your findings to the vault under /Products/HermesOS/

You think in systems, not in single responses.
When you finish a large task, produce a checkpoint note and propose the next one.
```

### Phase 2 — Wire the Kanban Board (Day 2–3)

The Task Ladder is not a markdown list to maintain manually. It maps to the Hermes Kanban
board, which is the official mechanism for durable task state.

Set up the board with three swim lanes corresponding to the task tiers:
- **Calibration** (small tasks): always has 3–5 cards ready
- **Capability** (medium tasks): 2–3 cards in progress or queued
- **Architecture** (large tasks): 1 card in progress, 1–2 queued

Card format (standard):
```
Title: [task name]
Profile: [which profile executes]
Output destination: [vault path or skill path]
Success criteria: [what "done" looks like]
```

### Phase 3 — First Small Task Queue (Day 3)

Populate the Calibration lane immediately with these tasks so Dreaming has something
useful to do while the rest of the OS is being assembled:

1. Scan `~/.hermes` and produce a skills inventory note at `vault/Products/HermesOS/skills-inventory.md`
2. Scan `~/projects` and produce a project map at `vault/Products/HermesOS/project-map.md`
3. Read all 10 research files and extract a list of confirmed vs speculative claims
4. Classify the current skill list (what exists vs what was planned vs what is missing)
5. Summarize the gap between the "steps/" plan and current `~/.hermes` reality

These are all single-session tasks for the Dreaming profile and feed directly into Phase 4.

### Phase 4 — First Medium Task Queue (Week 1–2)

Promote these to the Capability lane after the small tasks above complete:

1. Write `repo-onboard` skill using the patterns found in the small task inventory
2. Write `daily-report` skill with output to vault
3. Write `grow_environment` skill (from §4.3 of `Perplexity_Hermes-on-WSL`):
   - Accepts a goal description
   - Reads skills inventory + project manifests
   - Proposes filesystem changes (new skill files, config updates)
   - Writes proposal to vault for human review before applying
4. Design the project manifest format (`myku.yaml`, `ai_docs.yaml`, `client_<name>.yaml`)
5. Convert the repeated "inspect → summarize → propose" prompt into a reusable skill

### Phase 5 — Large Task Loop (Week 2+)

These are the Dreaming profile's flagship jobs. Each should be a Kanban card that stays
open across multiple sessions:

1. **Hermes OS Architecture Note:** synthesize the full system map — profiles, skills,
   memory layers, vault, providers, Kanban, crons — into a single architecture document
   at `vault/Products/HermesOS/architecture.md`

2. **Profile Taxonomy Decision Log:** document why each profile was defined as it was,
   what the tradeoffs are, and what signals would trigger adding or merging profiles

3. **Memory Policy Doc:** formalize what goes in each layer, retention rules, hygiene jobs,
   and the cron schedule that enforces them

4. **Skill Improvement Planner:** a recurring job (weekly) that reads the cron logs from
   all profiles, identifies failures or repeated corrections, and writes a skill improvement
   proposal to the vault

5. **"Build Hermes from within Hermes" Loop Design:** a meta-skill that uses the
   `grow_environment` skill to propose and apply improvements to Hermes itself, with a
   human checkpoint before applying anything outside `~/.hermes/skills/`

### Phase 6 — Nightly Synthesis Job (Week 2)

```bash
hermes job add --profile hermes-dreaming --cron "0 3 * * *" \
  --task "run env-audit, read vault/Products/HermesOS/project-map.md,
          identify the next small task and one medium task,
          write proposals to vault/Products/HermesOS/nightly-queue.md"
```

This is the mechanical implementation of the small model's "learning loop." It gives
Dreaming a standing job to observe, propose, and document — without executing anything
destructive overnight.


---

## E. Design Spec Sheet

### Dreaming Profile Spec

| Field | Value |
|-------|-------|
| Profile name | `hermes-dreaming` (or `research`) |
| Provider | Ollama primary, OpenRouter for web synthesis |
| Tools enabled | file_read, file_write, memory_recall, shell (read-only) |
| Skills | `env-audit`, `repo-onboard`, `grow_environment`, `skill-improvement-planner` |
| Output location | `vault/Products/HermesOS/` |
| Cron | Nightly at 03:00 |
| Kanban board | Hermes-OS-Build |

### Task Tier Reference

| Tier | Duration | Output type | Output location | Kanban lane |
|------|----------|-------------|-----------------|-------------|
| Small | Single session (< 1hr) | Note, checklist, map | `vault/Products/HermesOS/notes/` | Calibration |
| Medium | 1–3 sessions | Skill, script, workflow doc | `~/.hermes/skills/` or `vault/` | Capability |
| Large | Multi-session (days) | Architecture doc, roadmap, decision log | `vault/Products/HermesOS/` | Architecture |

### Vault Output Naming Convention

```
vault/Products/HermesOS/
  architecture.md           # System map (large task output)
  profile-taxonomy.md       # Profile decision log (large task output)
  memory-policy.md          # Memory layer rules (large task output)
  skills-inventory.md       # Current skill state (small task, refreshed weekly)
  project-map.md            # Current project tree (small task, refreshed weekly)
  nightly-queue.md          # Dreaming overnight proposals (overwritten nightly)
  notes/
    YYYY-MM-DD-<topic>.md   # Session-specific notes from small tasks
  decisions/
    YYYY-MM-DD-<decision>.md # Decision logs from large tasks
```

### Prompt Pattern (usable directly)

```
Inspect this workspace.
Scan: ~/.hermes/skills/, ~/projects/, vault/Products/HermesOS/
Map the relevant files and current state.
Summarize what exists vs what was planned.
Identify the next two small tasks that are unblocked right now.
Propose one medium task that would have the highest leverage.
If relevant, propose the next step on the current large task in progress.
Write a structured summary to vault/Products/HermesOS/nightly-queue.md.
```

### Output Rules (refined from small model)

| Task size | Required output | Optional output |
|-----------|----------------|-----------------|
| Small | A note or checklist in vault | Updated REPO_MAP.md or skills-inventory.md |
| Medium | A skill file OR a workflow doc | A Kanban card update |
| Large | An architecture note or decision log | A new medium task spawned from findings |

Each task output should explicitly state: what was found, what was decided, and what the
next task should be. This creates the forward chain that makes the loop self-sustaining.

---

## F. Step-by-Step Implementation Checklist

- [ ] **F1.** Create `hermes-dreaming` profile (or configure `research` profile with Dreaming SOUL.md)
- [ ] **F2.** Write SOUL.md for Dreaming profile (synthesis-first, not execution-first persona)
- [ ] **F3.** Open Hermes Kanban board and create three swim lanes: Calibration, Capability, Architecture
- [ ] **F4.** Add 5 small task cards to the Calibration lane (skills inventory, project map, etc.)
- [ ] **F5.** Add 5 medium task cards to the Capability lane (skill writing, manifest design, etc.)
- [ ] **F6.** Add 2 large task cards to the Architecture lane (OS architecture note, memory policy)
- [ ] **F7.** Create `vault/Products/HermesOS/` directory structure in Obsidian
- [ ] **F8.** Run the first small task manually (env-audit / skills inventory) to validate output
- [ ] **F9.** Confirm output lands in vault at the correct path
- [ ] **F10.** Write `grow_environment` skill with vault-write output and human-approval gate
- [ ] **F11.** Write `skill-improvement-planner` skill (reads cron logs, writes proposals)
- [ ] **F12.** Add nightly Dreaming cron job
- [ ] **F13.** After first nightly run, review `nightly-queue.md` and promote/reject proposals
- [ ] **F14.** Establish weekly cadence: promote one medium task to Architecture per week

---

## G. Divergences from Small Model Plan

| Small model said | Audit verdict | Correction |
|-----------------|---------------|------------|
| "Hermes Dreaming handles reasoning" | Correct but undefined | Define as a named profile with specific SOUL.md |
| Task list was markdown only | Incomplete | Map to Hermes Kanban board (official feature) |
| Prompt pattern was standalone | Good but incomplete | Add output destination and forward-chain requirement |
| Large tasks "Hermes Dreaming should own" | Correct | Add cron job and multi-session vault checkpoint pattern |
| Medium tasks end in "a skill or artifact" | Correct | Specify path: `~/.hermes/skills/` or vault with naming convention |
| No skill-from-repeated-work pattern | Missing | Add as explicit medium task category |

---

*Source cross-references: `Perplexity_Hermes-on-WSL` §4, `Perplex_2_project-workflow` §4,
`Perplex_6_skills` §3–4, `Perplex_2_Designing-Mission-Control` §3,
`steps/02-hermes-dreaming-task-ladder.md`*
