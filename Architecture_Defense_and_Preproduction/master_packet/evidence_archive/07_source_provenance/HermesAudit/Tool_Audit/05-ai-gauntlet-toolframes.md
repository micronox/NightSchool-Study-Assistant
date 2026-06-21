# Bucket 5: AI Gauntlet — Mandatory Toolframes, Spec Sheets, ADRs, and Workflows

> **Purpose:** Define the mandatory toolframes, decision infrastructure, and workflow patterns
> required for entry into a production-grade agentic development OS (the "Gauntlet").
> **Date:** 2026-06-18
> **Basis:** GitHub Spec Kit (111k ★), Spec Kitty (Priivacy-ai fork), MADR / adr-tools,
> CCPM (automazeio), Agentic Project Management frameworks, GitHub Agentic Workflows
> (public preview June 2026)

---

## Overview: The Five Gauntlet Toolframes

The Gauntlet is the standard that separates "using AI to code" from "running a governed
software factory with AI agents." Five toolframes must be in place:

| # | Toolframe | Mandatory artifact | Gate |
|---|-----------|-------------------|------|
| 1 | Spec-Driven Development | GitHub Spec Kit → Spec Kitty | Must produce a Spec before any implementation |
| 2 | Decision Log | `DECISIONS.md` + log structure | Every non-trivial choice must be recorded |
| 3 | Architecture Decision Records | MADR + adr-tools | Every architectural choice gets a numbered ADR |
| 4 | Agent Idea Harvesting | Idea → PRD pipeline | Agent proposals must be captured before execution |
| 5 | PRD → Ticket → Epic → PR | CCPM or equivalent | One PR per spec, full traceability required |

None of these are optional in the Gauntlet. A system missing any one of them is not a
governed software factory — it is a chat session with a side effect.

---

## Toolframe 1: Spec-Driven Development (Spec Kit → Spec Kitty)

### What it is

Spec-Driven Development (SDD) is the discipline of writing a machine-readable specification
before any implementation begins. The spec is the contract between human intent and agent
execution. Without it, agents vibe-code: they produce plausible-looking output that may
not match what was wanted, and there is no formal artifact to validate against.

GitHub Spec Kit (111k ★ as of June 2026, 200+ contributors, 30+ agent integrations) is the
official open-source toolkit from GitHub for SDD. It provides a CLI (`specify`), slash
commands, and templates that structure work into four phases: **Spec → Plan → Tasks →
Implement**. Spec Kitty is a community fork that adds a fifth loop: **→ Review → Accept →
Merge**, plus a live Kanban dashboard, git worktrees for parallel execution, and a
multi-agent coordination layer. Together they form the full SDD stack for a Hermes-style OS.

### Two-track strategy

**Track A: GitHub Spec Kit** (learn and baseline)
Use this for every project from day one. It is the safer, better-supported, more
integrated baseline. All 30+ agent integrations (Claude Code, Copilot, Cursor, Gemini CLI,
Codex, Amp, Roo Code, Windsurf) work with it out of the box.

**Track B: Spec Kitty** (orchestration and production)
Use this when a project involves multiple agents, parallel implementation tracks, review
gates, or merge decisions. Spec Kitty keeps all of this repo-native: specs, plans, work
packages, acceptance criteria, review state, and merge decisions live in the repository
itself. Isolated git worktrees mean agents can implement in parallel without branch chaos.

The transition rule: **start every new project on Spec Kit; graduate to Spec Kitty when
you need more than one agent working simultaneously or when you need a formal review gate
before merge.**


### Spec Kit — Design Spec

**Installation:**
```bash
# In any repo you want to use SDD on:
npx specify init --integration claude-code
# Or for Hermes in WSL:
npx specify init --integration claude-code --integration-options="--skills"
```

**Directory structure created by Spec Kit:**
```
.github/
  specs/
    <feature-name>.md       # The spec file — your contract
  plans/
    <feature-name>.md       # Tech plan generated from spec
  tasks/
    <feature-name>.md       # Task breakdown, [P] marks parallel tasks
AGENTS.md                   # Agent instructions for this repo (root level)
```

**The four-phase workflow:**
```
1. SPEC:     specify new "<feature description>"
             → produces .github/specs/<slug>.md
             → human reviews and approves

2. PLAN:     specify plan <spec-slug>
             → produces .github/plans/<slug>.md
             → tech stack choices, architectural notes, dependencies

3. TASKS:    specify tasks <spec-slug>
             → produces .github/tasks/<slug>.md
             → granular tasks with [P] markers for parallelism
             → file paths where implementation should occur
             → test tasks ordered before implementation tasks

4. IMPLEMENT: specify implement <spec-slug> --integration claude-code
             → hands the task list to the agent
             → agent works task by task, checking off as it goes
```

**AGENTS.md — mandatory file for every Gauntlet repo:**
The `AGENTS.md` file at repo root tells every agent what it needs to know before touching
the repo: coding standards, directory layout, how to run tests, what NOT to do, and which
spec file to refer to. This replaces ad-hoc system prompts. Every Gauntlet repo must have
one. Contents template:
```markdown
# Agent Instructions — <repo name>

## What this repo is
<one paragraph>

## Directory layout
<brief tree>

## How to run tests
<command>

## Coding standards
<language, style, lint rules>

## What not to do
- Never commit directly to main
- Never modify files outside the spec's stated scope
- Never skip the task checklist

## Active spec
See .github/specs/<current-spec>.md
```

### Spec Kitty — Design Spec

**When to switch:** multi-agent projects, parallel feature tracks, or any time you need
a formal human review gate before merge.

**Additional workflow phases beyond Spec Kit:**
```
5. NEXT:    kitty next
            → picks the highest-priority unblocked task from Kanban
            → assigns it to an available agent worktree

6. REVIEW:  kitty review <task-id>
            → human reviews agent output against acceptance criteria
            → marks PASS or FAIL with notes

7. ACCEPT:  kitty accept <task-id>
            → marks task complete, updates Kanban
            → prepares merge commit

8. MERGE:   kitty merge <task-id>
            → merges isolated worktree branch into main
            → closes the associated GitHub Issue
```

**Repo-native state files (Spec Kitty adds these):**
```
.kitty/
  mission.md              # Active mission state
  kanban.json             # Board state: backlog / in-progress / review / done
  worktrees/
    <task-id>/            # Isolated git worktree per task
  review-log.md           # All review decisions with notes
```

### Gauntlet Acceptance Criteria for Toolframe 1

- [ ] `AGENTS.md` exists at root of every active repo
- [ ] At least one spec file exists in `.github/specs/` before any implementation starts
- [ ] Every spec produces a plan file before task breakdown
- [ ] Every task file includes at least one test task
- [ ] Parallel tasks are explicitly marked `[P]`
- [ ] For multi-agent projects: Spec Kitty is installed and `kitty review` runs before merge


---

## Toolframe 2: Decision Log

### What it is

A Decision Log is the lightweight, chronological record of every non-trivial choice made
in a project — technology choices, scope changes, prioritization calls, provider decisions,
security posture choices, and anything else where "why did we do it this way?" matters
six months from now. It is distinct from ADRs (Toolframe 3), which are structured and
numbered. The Decision Log is the fast-capture layer: lower friction, more frequent, and
human-readable in a single glance.

In a Hermes OS context, the Decision Log also captures **agent-proposed decisions** that
a human has reviewed and accepted. This is critical: agents make architectural suggestions
constantly, and without a log, those decisions become invisible technical debt.

### Two formats

**Inline DECISIONS.md (per-project):**
Every Gauntlet repo gets a `DECISIONS.md` at root. This is the chronological log for
that project. Format is deliberately minimal to maximize adoption — if it's too complex
to fill in under pressure, it won't get filled in.

**Vault-level decision log (cross-project):**
A running decision log in Obsidian at `vault/Products/<project>/decisions/` captures
decisions that span multiple repos or affect the Hermes OS itself. Cross-project decisions
live here, not in any single repo.

### Design Spec: DECISIONS.md

**Location:** repo root (`DECISIONS.md`)
**Format:** reverse-chronological, newest first. Each entry is a level-3 heading.

```markdown
# Decision Log — <project name>

---

### YYYY-MM-DD — <Decision title in imperative form>

**Status:** Decided | Superseded by DEC-YYYY-MM-DD | Revisiting
**Made by:** <human / agent-proposed, human-confirmed>
**Context:** One to three sentences. What was the situation that forced this choice?
**Options considered:**
- Option A: <brief description> — ruled out because <reason>
- Option B: <brief description> — ruled out because <reason>
- Option C (chosen): <brief description>
**Decision:** What exactly was decided, in one sentence.
**Rationale:** Why option C. What matters here.
**Consequences:** What this makes easier, harder, or impossible going forward.
**Review trigger:** Under what conditions should this decision be revisited?

---
```

**Naming convention for entries:** Use `DEC-YYYY-MM-DD-<slug>` when you need to
cross-reference from an ADR, a PR, or a spec file. Example:
`DEC-2026-06-18-wsl-as-hermes-authority`

### Decision Log — Implementation Steps

```bash
# Create DECISIONS.md in a repo:
touch DECISIONS.md
# Add the template header and first entry manually or via a Hermes skill

# Hermes skill: decision-capture
# Triggered when: a significant choice is made in a session
# Steps:
#   1. Extract the decision from session context
#   2. Format it using the template above
#   3. Prepend it to DECISIONS.md (newest first)
#   4. Commit: "docs: add decision DEC-<date>-<slug>"
```

**Vault cross-project log location:**
```
vault/Products/<project>/decisions/
  YYYY-MM-DD-<slug>.md     # One file per major decision, for searchability
vault/Products/HermesOS/decisions/
  YYYY-MM-DD-<slug>.md     # OS-level decisions (profiles, memory, providers)
```

### Gauntlet Acceptance Criteria for Toolframe 2

- [ ] `DECISIONS.md` exists at root of every active Gauntlet repo
- [ ] Every decision entry follows the template (Status / Made by / Context / Options / Decision / Rationale / Consequences / Review trigger)
- [ ] Agent-proposed decisions are marked `agent-proposed, human-confirmed` in the "Made by" field
- [ ] Cross-project decisions are captured in the vault decision log, not buried in a single repo
- [ ] A `decision-capture` Hermes skill exists and is wired to the relevant profiles
- [ ] DECISIONS.md is committed on every new entry (not left uncommitted)


---

## Toolframe 3: Architecture Decision Records (ADRs)

### What it is

An Architecture Decision Record (ADR) is a structured, numbered, versioned document
that captures a single architecturally significant decision. Where the Decision Log is
fast-capture and informal, ADRs are the formal record. They have a canonical number,
a stable status lifecycle (Proposed → Accepted → Deprecated → Superseded), and a
structured template that forces you to articulate options, trade-offs, and consequences.

The gold standard format is **MADR** (Markdown Architectural Decision Records), maintained
by the `adr` GitHub organization (last updated June 12, 2026). MADR is the most widely
adopted ADR format because it balances rigor with readability — it includes considered
options with explicit pros/cons, which is the part that matters most when revisiting a
decision a year later.

**Tools:**
- `npryce/adr-tools` — CLI for managing ADR files, initializing ADR directories, and
  generating a `README.md` index of all ADRs
- `adr/adr-log` — generates a chronological ADR log from a folder of MADR files
- `adr/madr` — the canonical MADR template repo and format spec

### Design Spec: MADR Template

**Location:** `doc/adr/` (default for adr-tools) or `docs/decisions/` (MADR convention)

**Numbered file format:** `NNNN-<slug>.md` (e.g., `0001-use-wsl-as-hermes-backend.md`)

**Full MADR template:**
```markdown
# NNNN — <Title: short noun phrase describing the decision>

Date: YYYY-MM-DD
Status: [Proposed | Accepted | Deprecated | Superseded by ADR-NNNN]
Decision makers: <names or roles>
Technical story: <link to spec, issue, or ticket if applicable>

---

## Context and Problem Statement

One to three paragraphs. What is the architectural problem or question being addressed?
What forces are in play? Why does this need to be decided now?

## Decision Drivers

- <driver 1 — e.g., "must work without internet access">
- <driver 2 — e.g., "must not store client data in cloud providers">
- <driver 3>

## Considered Options

- Option A: <name>
- Option B: <name>
- Option C: <name> ← chosen

## Decision Outcome

**Chosen option: Option C**, because <one sentence rationale>.

### Positive Consequences

- <what this makes easier or better>
- <what risk it eliminates>

### Negative Consequences

- <what this makes harder>
- <what new risk it introduces>
- <what is now ruled out>

## Pros and Cons of the Options

### Option A — <name>

<brief description>

Pros:
- <pro>
Cons:
- <con>

### Option B — <name>

<brief description>

Pros:
- <pro>
Cons:
- <con>

### Option C — <name> (chosen)

<brief description>

Pros:
- <pro>
Cons:
- <con>

## More Information

<links to related ADRs, specs, external references, or open questions>
```

### ADR Tooling Setup

```bash
# Install adr-tools (macOS/Linux/WSL):
brew install adr-tools
# or:
npm install -g adr-tools

# Initialize ADR directory in a repo:
adr init doc/adr

# Create a new ADR (auto-increments the number):
adr new "Use WSL as Hermes authoritative backend"
# → creates doc/adr/0001-use-wsl-as-hermes-authoritative-backend.md

# Generate the ADR log index:
adr generate toc > doc/adr/README.md

# Mark an ADR as superseded:
adr new -s 1 "Use OpenViking as memory provider"
# → creates 0002-... and adds "Superseded by ADR-0002" to 0001
```

```bash
# Generate a chronological log from all ADRs:
# Install adr-log:
npm install -g adr-log
adr-log -d doc/adr -o doc/adr/CHANGELOG.md
```

### ADR Index for Hermes OS (Starter Set)

These are the ADRs that must exist before Gauntlet acceptance. Each maps to a
decision already made in the technical spec and research files:

| # | Title | Status | Related |
|---|-------|--------|---------|
| 0001 | Use WSL2 as Hermes authoritative backend | Accepted | Perplex_1, spec §2 |
| 0002 | Use Hermes Desktop as thin remote client only | Accepted | Perplex_1 §1.1–1.3 |
| 0003 | Use five named profiles instead of per-repo installs | Accepted | Perplex_2 §1 |
| 0004 | Use three-layer memory model (built-in / Obsidian / OpenViking) | Accepted | Perplex_3 §4 |
| 0005 | Use OpenViking as external memory provider (over Honcho) | Accepted | Perplex_3 §2 |
| 0006 | Use client-dev profile with local-only Ollama provider | Accepted | Perplex_4 §2–3 |
| 0007 | Use GitHub Spec Kit as baseline SDD toolframe | Proposed | This bucket §1 |
| 0008 | Use MADR format for all ADRs | Accepted | This bucket §3 |
| 0009 | Use CCPM for PRD → Epic → Task → PR pipeline | Proposed | This bucket §5 |

### Gauntlet Acceptance Criteria for Toolframe 3

- [ ] `adr-tools` installed in WSL
- [ ] `doc/adr/` initialized in every Gauntlet repo (`adr init`)
- [ ] ADRs 0001–0006 exist and are in Accepted status (documenting already-made decisions)
- [ ] ADRs 0007–0009 exist in Proposed or Accepted status
- [ ] `adr generate toc` runs cleanly and produces a readable `doc/adr/README.md`
- [ ] Every new architectural decision produces an ADR before implementation begins
- [ ] ADRs are committed on creation, not left as drafts in the working tree
- [ ] A `adr-capture` Hermes skill exists: given a decision context, drafts a MADR file for human review


---

## Toolframe 4: Agent Idea Harvesting

### What it is

Agents generate ideas constantly — during a session, while debugging, while reviewing a
diff, while synthesizing research. Without a harvesting workflow, these ideas evaporate:
they live in the session transcript and die when the session ends. Idea Harvesting is the
practice of capturing agent-generated proposals, evaluating them against current priorities,
and converting the valuable ones into tracked work items before they are lost.

This is distinct from the Decision Log (Toolframe 2), which captures choices already made.
The Idea Harvest captures proposals that have not yet been decided — they are candidates,
not decisions. The harvest pipeline moves them from raw proposal → evaluated candidate →
accepted work item (Kanban card, GitHub Issue, or Spec file) → or explicitly rejected with
a reason.

Without this toolframe, agents are idea generators that leak. With it, agents become
research and proposal engines whose output actually reaches production.

### The Harvest Pipeline

```
Session (any profile)
  │
  ▼
Agent produces a proposal, suggestion, or insight
  │
  ▼
[Harvest trigger] — one of:
  - Human notices something worth capturing ("add to harvest")
  - End-of-session harvest skill runs automatically
  - Nightly Dreaming cron runs harvest pass on session logs
  │
  ▼
idea-harvest skill
  │
  ├── Classifies the idea:
  │     SKILL       → candidate for a new Hermes skill
  │     ARCH        → candidate for an ADR
  │     FEATURE     → candidate for a spec / PRD
  │     PROCESS     → candidate for a workflow change
  │     RESEARCH    → candidate for a research task
  │     REJECT      → not useful, log reason and discard
  │
  ├── Writes to vault/Products/HermesOS/harvest/YYYY-MM-DD-raw.md
  │
  ▼
Weekly triage (human + Dreaming profile)
  │
  ├── Promote to Kanban card (Dreaming board)
  ├── Promote to GitHub Issue (for code-touching work)
  ├── Promote to Spec file (for feature-level work)
  ├── Promote to ADR draft (for architectural work)
  └── Mark REJECTED with reason
```

### Design Spec: Harvest Entry Format

**Raw harvest file:** `vault/Products/HermesOS/harvest/YYYY-MM-DD-raw.md`
```markdown
## [HARVEST] YYYY-MM-DD HH:MM — <one-line title>

**Source:** <profile name> / <session slug>
**Class:** SKILL | ARCH | FEATURE | PROCESS | RESEARCH
**Raw idea:**
<verbatim or lightly edited agent output, 1–5 sentences>

**Why it might matter:**
<agent's or human's assessment, 1–2 sentences>

**Triage status:** PENDING | PROMOTED-TO:<link> | REJECTED:<reason>
```

**Weekly triage summary:** `vault/Products/HermesOS/harvest/YYYY-MM-DD-triage.md`
Records the disposition of every PENDING item from the week, with links to what was
promoted and why others were rejected.

### Hermes Skill: `idea-harvest`

```yaml
# ~/.hermes/skills/idea-harvest/skill.yaml
name: idea-harvest
version: 0.1.0
description: >
  Scans the current or recent session for agent-generated ideas, proposals,
  and suggestions. Classifies each and writes to the raw harvest file for
  weekly triage.
tools_required: [file_read, file_write, memory_recall]
profiles: [global]
trigger: [manual, end-of-session, nightly-cron]
output: vault/Products/HermesOS/harvest/{date}-raw.md
```

**Skill steps (SKILL.md):**
```
1. Read the last N turns of the current session (or the session log file).
2. Identify all agent-generated proposals, suggestions, and insights.
   Look for: "you could", "consider", "an alternative", "it might be worth",
   "future improvement", "I'd suggest", "one option", "a better approach".
3. For each identified idea:
   a. Write a harvest entry using the format above
   b. Classify it (SKILL / ARCH / FEATURE / PROCESS / RESEARCH)
   c. Write "Why it might matter" based on the session context
4. Append all entries to vault/Products/HermesOS/harvest/{date}-raw.md
5. Report: "Harvested N ideas. See harvest file for review."
```

**Nightly cron (Dreaming profile):**
```bash
hermes job add --profile hermes-dreaming --cron "0 1 * * *" \
  --task "idea-harvest --source session-logs --date yesterday"
```

**Weekly triage cron (Dreaming profile, Monday morning):**
```bash
hermes job add --profile hermes-dreaming --cron "0 8 * * 1" \
  --task "idea-harvest --triage --week-ending $(date -d 'last sunday' +%Y-%m-%d)"
```

### Integration with Other Toolframes

- **SKILL ideas** → promoted to a medium task on the Dreaming Kanban board (Bucket 2)
- **ARCH ideas** → promoted to an ADR draft (Toolframe 3), status: Proposed
- **FEATURE ideas** → promoted to a spec file via Spec Kit (Toolframe 1)
- **PROCESS ideas** → promoted to a DECISIONS.md entry candidate (Toolframe 2)
- **RESEARCH ideas** → added to the Research profile's Kanban backlog

### Gauntlet Acceptance Criteria for Toolframe 4

- [ ] `idea-harvest` skill exists in `~/.hermes/skills/`
- [ ] `vault/Products/HermesOS/harvest/` directory exists
- [ ] Nightly harvest cron is active on the Dreaming profile
- [ ] Weekly triage cron is active on the Dreaming profile
- [ ] At least one full harvest-triage cycle has completed (raw → triage → dispositions)
- [ ] PROMOTED ideas have visible downstream artifacts (Kanban card, ADR draft, or spec file)
- [ ] REJECTED ideas have explicit reasons logged (not just silently dropped)
- [ ] The triage file is committed weekly to the Hermes OS repo or vault


---

## Toolframe 5: PRD → Tickets → Epics → Spec → Evals → One PR per Spec

### What it is

This is the full production pipeline: the governed path from a product idea all the way to
a merged pull request with a traceable audit trail. Every step produces a concrete artifact.
Every artifact feeds the next step. No step can be skipped without breaking the chain.

The implementation backbone is **CCPM** (Claude Code Project Manager, `automazeio/ccpm`),
which is a project management skill system that uses GitHub Issues and git worktrees for
parallel agent execution. CCPM transforms PRDs into GitHub Issues, enables up to 12 agents
working concurrently on a single epic, and maintains the full audit trail:
`PRD → Epic → Task → Issue → Code → Commit → PR → Review → Merge`.

The one-PR-per-spec rule is the structural guarantee that every pull request is traceable
to exactly one spec file. No spec = no PR. This prevents the "mystery PR" problem where
agent-generated code lands in main without a human ever having approved the intent.

### The Full Pipeline

```
STAGE 0: IDEA (from Harvest or direct)
  Input:  A validated idea from Toolframe 4, or a direct human feature request
  Output: A brief (1 paragraph) feature statement
  Gate:   Human confirms the idea is worth pursuing

STAGE 1: PRD (Product Requirements Document)
  Input:  Feature statement
  Tool:   agentic-prd-generation skill or CCPM's PRD mode
  Output: PRD.md — structured requirements document (see template below)
  Gate:   Human reviews and approves PRD before anything else happens

STAGE 2: EPIC
  Input:  Approved PRD
  Tool:   CCPM epic generation
  Output: One GitHub Issue per Epic, tagged [EPIC], with:
          - Technical approach
          - Architecture decisions referenced (links to ADRs)
          - Dependency map
          - Acceptance criteria (measurable, testable)
  Gate:   Human confirms epic scope before task breakdown

STAGE 3: TASKS / TICKETS
  Input:  Approved Epic
  Tool:   CCPM task breakdown + Spec Kit task phase
  Output: One GitHub Issue per Task, tagged [TASK], with:
          - Description and file paths
          - Acceptance criteria (2–5 per task)
          - Story point estimate (prefer 1–3)
          - `parallel: true/false` flag
          - Dependency list (other task Issue numbers)
  Gate:   Automatic (CCPM validates task structure)

STAGE 4: SPEC FILE
  Input:  Epic + Task set
  Tool:   Spec Kit `specify` CLI
  Output: .github/specs/<slug>.md — the machine-readable contract
          This is the spec that the one-PR-per-spec rule is enforced against
  Gate:   Human reviews spec file before implementation begins

STAGE 5: EVALS (Acceptance Criteria as Tests)
  Input:  Spec file + task acceptance criteria
  Tool:   Agent (via Spec Kit task phase) + test framework
  Output: Eval files (tests) written BEFORE implementation
          One eval file per major acceptance criterion
          Evals must fail before implementation (red-green discipline)
  Gate:   CI must show evals exist and fail before implementation is approved to start

STAGE 6: IMPLEMENTATION (parallel where flagged)
  Input:  Approved spec + failing evals
  Tool:   CCPM worktrees + agent (Claude Code, Codex, Cursor, etc.)
  Output: Implementation code in isolated git worktree per task
          Evals pass (green)
          No code outside spec scope is touched
  Gate:   All evals pass + Spec Kitty `kitty review` confirms scope compliance

STAGE 7: ONE PR PER SPEC
  Input:  Passing implementation from isolated worktree
  Tool:   Spec Kitty `kitty accept` + `kitty merge` / CCPM merge
  Output: Exactly ONE pull request per spec file
          PR description includes:
          - Link to PRD
          - Link to Epic Issue(s)
          - Link to spec file
          - Link to all Task Issues (checked off)
          - List of passing evals
          - ADR references if any architectural decisions were made
  Gate:   Human approves PR — no auto-merge without human sign-off
          Merge closes all associated Task Issues
          Merge updates DECISIONS.md if any new decisions were made
```

### Design Spec: PRD Template

**Location:** `docs/prd/<feature-slug>.md` or vault-linked
```markdown
# PRD — <Feature Name>

**Date:** YYYY-MM-DD
**Author:** <human / agent-drafted, human-approved>
**Status:** Draft | Approved | Implemented | Deprecated
**Related ADRs:** ADR-NNNN, ADR-NNNN
**Harvest source:** <HARVEST entry link or "direct">

---

## Problem Statement
What user or system problem does this solve? (2–4 sentences)

## Goals
- <Goal 1 — measurable>
- <Goal 2 — measurable>

## Non-Goals (explicit out of scope)
- <Non-goal 1>
- <Non-goal 2>

## User Stories
- As a <role>, I want to <action> so that <outcome>.
- As a <role>, I want to <action> so that <outcome>.

## Acceptance Criteria (top-level)
- [ ] <Criterion 1 — testable>
- [ ] <Criterion 2 — testable>
- [ ] <Criterion 3 — testable>

## Technical Constraints
- <Constraint 1 — e.g., "must run in WSL, no cloud dependency">
- <Constraint 2>

## Open Questions
- <Question 1 and who owns answering it>

## Implementation Notes
<Optional: any hints for the implementation agent>
```

### CCPM Setup and Integration

```bash
# Install CCPM in WSL (Claude Code project management skill):
cd ~/.hermes/skills
git clone https://github.com/automazeio/ccpm.git
# Follow CCPM README for skill registration

# CCPM activates when agent detects PM intent:
# - "create a PRD for..."
# - "break this epic into tasks"
# - "set up parallel worktrees for..."

# CCPM workflow commands:
ccpm init                          # initialize in a repo
ccpm prd "<feature description>"   # generate PRD draft
ccpm epic <prd-file>               # generate Epic Issues from PRD
ccpm tasks <epic-issue-number>     # break Epic into Task Issues with worktrees
ccpm status                        # show Kanban state across all Issues
ccpm merge <task-issue-number>     # merge worktree, close Issue, update audit trail
```

**CCPM parallel execution model:**
Tasks marked `parallel: true` each get their own git worktree. Up to 12 agents can work
simultaneously on different tasks in the same Epic without branch conflicts. Each worktree
maps to one GitHub Issue. When all tasks in an Epic are complete, CCPM collects them for
the final PR.

### One-PR-Per-Spec Enforcement

The one-PR-per-spec rule is enforced structurally, not by honor system:

1. **Every PR must reference a spec file** in its description (PR template enforces this)
2. **CCPM generates the PR** from the worktree merge, automatically linking the spec
3. **Spec Kitty's `kitty review`** validates that only files within the spec's stated scope
   were modified — if agent touched files outside scope, review fails
4. **CI check:** a GitHub Actions workflow verifies that `spec_slug` in the PR body
   matches a file in `.github/specs/` and that the spec's status is "Approved"

**PR template (`.github/PULL_REQUEST_TEMPLATE.md`):**
```markdown
## Spec
<!-- Required: link to the spec file this PR implements -->
Spec: .github/specs/<slug>.md

## PRD
<!-- Link to the PRD that originated this work -->
PRD: docs/prd/<slug>.md

## Epic
<!-- GitHub Issue number(s) for the Epic(s) this closes -->
Closes Epic: #

## Tasks completed
<!-- GitHub Issue numbers for all Tasks this closes -->
- [x] #<task-issue> — <task description>
- [x] #<task-issue> — <task description>

## Evals
<!-- List of eval files and their pass status -->
- [x] `tests/evals/<criterion>.test.ts` — PASS

## ADR references
<!-- Any new ADRs created during this implementation -->
- ADR-NNNN: <title>

## Decision log
<!-- Any entries added to DECISIONS.md -->
- DEC-YYYY-MM-DD-<slug>: <decision title>

## Scope compliance
<!-- Confirm no files outside spec scope were modified -->
- [ ] All modified files are within the spec's stated scope
- [ ] No unrelated changes are included
```

### Gauntlet Acceptance Criteria for Toolframe 5

- [ ] PRD template exists at `docs/prd/TEMPLATE.md` in every Gauntlet repo
- [ ] CCPM is installed and registered as a Hermes skill
- [ ] At least one PRD has been created and approved before any implementation started
- [ ] At least one Epic Issue exists with technical approach + ADR references + acceptance criteria
- [ ] All task Issues have `parallel: true/false` flags and story point estimates
- [ ] At least one spec file in `.github/specs/` was created from the Epic before coding started
- [ ] Eval files exist and failed (red) before implementation began
- [ ] Eval files pass (green) after implementation
- [ ] PR template exists at `.github/PULL_REQUEST_TEMPLATE.md`
- [ ] At least one PR has been merged that links: PRD → Epic → Tasks → Spec → Evals → PR
- [ ] DECISIONS.md was updated in that PR if any new choices were made
- [ ] No PR exists that lacks a spec file reference


---

## Master Gauntlet Checklist

This is the single gate list. All items must be checked before claiming Gauntlet
acceptance. It collapses the five toolframe checklists into one view.

### Toolframe 1: Spec-Driven Development
- [ ] `AGENTS.md` at root of every active repo
- [ ] Spec Kit initialized (`npx specify init`) in every active repo
- [ ] At least one spec → plan → tasks → implement cycle completed
- [ ] Parallel tasks marked `[P]` in task files
- [ ] For multi-agent projects: Spec Kitty installed, `kitty review` runs before merge

### Toolframe 2: Decision Log
- [ ] `DECISIONS.md` at root of every active repo
- [ ] Every entry uses the full template (Status / Made by / Context / Options / Decision / Rationale / Consequences / Review trigger)
- [ ] Agent-proposed decisions marked `agent-proposed, human-confirmed`
- [ ] `decision-capture` Hermes skill deployed

### Toolframe 3: Architecture Decision Records
- [ ] `adr-tools` installed in WSL
- [ ] `doc/adr/` initialized in every active repo
- [ ] Starter ADRs 0001–0009 exist and committed
- [ ] `adr generate toc` produces a clean `README.md`
- [ ] `adr-capture` Hermes skill deployed
- [ ] Every new architectural decision triggers an ADR before implementation

### Toolframe 4: Agent Idea Harvesting
- [ ] `idea-harvest` skill deployed globally
- [ ] `vault/Products/HermesOS/harvest/` directory exists
- [ ] Nightly harvest cron active
- [ ] Weekly triage cron active
- [ ] At least one harvest-triage cycle completed end-to-end

### Toolframe 5: PRD → Tickets → Epics → Spec → Evals → One PR per Spec
- [ ] PRD template deployed to every active repo
- [ ] CCPM installed as Hermes skill
- [ ] At least one full pipeline run: PRD → Epic → Tasks → Spec → Evals → PR → Merge
- [ ] PR template deployed (`.github/PULL_REQUEST_TEMPLATE.md`)
- [ ] CI check enforces spec file reference on every PR
- [ ] No orphan PRs (PRs without a spec reference) exist in any active repo

---

## Implementation Order (Recommended)

The toolframes build on each other. Do not skip ahead.

```
Week 1:  Toolframe 3 (ADRs) — document existing decisions first;
         this is the fastest to set up and immediately captures what you've already decided

Week 1:  Toolframe 2 (Decision Log) — lightweight, add to every active repo;
         start capturing decisions as they happen

Week 2:  Toolframe 1 (Spec Kit) — start with one small feature on one repo;
         complete one full Spec → Plan → Tasks → Implement cycle before moving on

Week 2:  Toolframe 4 (Idea Harvest) — deploy the skill and run the first manual harvest;
         don't wait for the nightly cron to be perfect before starting

Week 3:  Toolframe 5 (PRD pipeline) — install CCPM, create your first PRD,
         complete one full PRD → Epic → PR cycle on a real feature

Week 4+: Spec Kitty — install after Spec Kit is running smoothly;
         graduate one project to Spec Kitty's multi-agent worktree model
```

---

## Tool Reference Summary

| Tool | Type | Location | Stars | Purpose |
|------|------|----------|-------|---------|
| `github/spec-kit` | CLI + templates | `github.github.com/spec-kit/` | 111k | Spec-Driven Development baseline |
| `Priivacy-ai/spec-kitty` | CLI + dashboard | `github.com/Priivacy-ai/spec-kitty` | 1.3k | Multi-agent SDD with Kanban + worktrees |
| `npryce/adr-tools` | CLI | `github.com/npryce/adr-tools` | — | ADR file management |
| `adr/madr` | Template | `adr.github.io/madr/` | — | MADR format spec |
| `adr/adr-log` | CLI | `github.com/adr/adr-log` | — | ADR changelog generation |
| `automazeio/ccpm` | Skill system | `github.com/automazeio/ccpm` | — | PRD → Epic → Task → Issue → PR pipeline |
| Hermes `idea-harvest` | Skill (custom) | `~/.hermes/skills/idea-harvest/` | — | Agent idea capture and triage |
| Hermes `decision-capture` | Skill (custom) | `~/.hermes/skills/decision-capture/` | — | DECISIONS.md automation |
| Hermes `adr-capture` | Skill (custom) | `~/.hermes/skills/adr-capture/` | — | ADR draft generation |

---

*Source cross-references: `github/spec-kit` (github.github.com/spec-kit), `Priivacy-ai/spec-kitty`
(github.com/Priivacy-ai/spec-kitty), `adr.github.io`, `npryce/adr-tools`, `adr/madr`,
`automazeio/ccpm` (github.com/automazeio/ccpm), GitHub Agentic Workflows public preview
(github.blog, June 11 2026), `agentic-prd-generation` (SeeknnDestroy/agentic-prd-generation)*
