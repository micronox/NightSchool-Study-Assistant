# Mandatory Stack Path

> **Purpose:** establish the minimum Hermes stack that can safely grow, learn, and be upgraded without rework.

**Goal:** turn Hermes into a WSL-authoritative operating layer with memory, skills, and a repeatable learning loop.

**Architecture:** keep Windows Hermes Desktop as a client surface only. Keep authoritative runtime, provider config, memory, skills, sessions, and task execution in WSL under `~/.hermes`. Build the first working loop around inspection, planning, execution, and summarization, then let Hermes Dreaming propose the next layer from within that loop.

**Source basis:** `hermes_perplexity_research.md`, `Perplexity_Hermes-on-WSL Stack Analysis and Agentic OS Buildout Plan.md`, `Perplex_1_hermes-architecture-and-desktop-location.md`, `Perplex_2_project-workflow-profiles-and-agentic-loop.md`, `Perplex_3_memory-obsidian-honcho-openviking.md`, `Perplex_4_client-work-upwork-github-isolation.md`, `Perplex_6_skills-user-groups-and-community-patterns.md`.

---

## 1. Non-Negotiables

- WSL is the authoritative Hermes backend.
- Windows Hermes Desktop is the operator UI, not the source of truth.
- Hermes runtime lives under `~/.hermes` in WSL.
- Model/provider config is owned in WSL.
- Built-in memory stays small and curated.
- Obsidian/Open Brain is the human-editable knowledge layer.
- One external semantic memory backend is enough for the first MVP.
- Profiles separate roles and safety boundaries.
- Skills are the reusable workflow layer.
- Client work is isolated by profile, directory, and provider choice.

## 2. Mandatory Build Order

### Step 1: Lock backend authority

- Confirm WSL Hermes works end-to-end.
- Keep all state under `/home/larry/.hermes`.
- Keep model endpoints local to WSL when possible.
- Treat Desktop config as disposable client state.

### Step 2: Define the profile set

Start with a small taxonomy:

- `infra-ops`
- `research`
- `myku-dev`
- `ai-docs-dev`
- `client-dev`

Use profiles for role boundaries, not per-repo fragmentation.

### Step 3: Seed the memory stack

Use a three-layer model:

- Layer 1: Hermes built-in memory for identity, preferences, and operating rules.
- Layer 2: Obsidian/Open Brain for curated notes, project context, and decisions.
- Layer 3: one external provider such as OpenViking or Honcho for semantic recall.

Keep built-in memory small. Put long-form notes and history in the vault. Put retrieval-heavy facts in the provider.

### Step 4: Create the first skill pack

The first skills should be practical and reusable:

- repo onboarding
- environment audit
- implementation planning
- diff review
- daily report
- vault sync
- client safety check

These should live in WSL and be callable from the active profile.

### Step 5: Start the learning path

Hermes should learn by doing:

- inspect a repo or workspace
- build a map
- propose a plan
- execute or review work
- summarize the outcome
- write learnings back into notes or a skill

That loop should happen on every meaningful task.

### Step 6: Isolate client work

For client or Upwork work:

- keep code in `~/projects/clients/...`
- keep notes in a client vault subtree
- keep providers local-first unless a contract allows otherwise
- keep Git identity and Hermes context aligned with the client profile

### Step 7: Preserve Git history deliberately

Use clean branches, frequent commits, and tags so the evolution of the stack can be reconstructed later.

## 3. Hermes Dreaming Role

Hermes Dreaming should own the internal reasoning layer for this path.

Use it to:

- inspect the current stack
- synthesize architecture decisions
- identify gaps and dependencies
- propose the next skills to build
- propose what should be learned from each task

This is the mode that should decide what the system needs next, while smaller tasks do the execution.

## 4. First Deliverables

The first artifacts to produce from this path are:

- profile definitions
- memory policy
- starter skill specs
- a repo onboarding skill
- a daily report skill
- a vault sync skill
- a client safety skill
- a simple task board or task file convention

