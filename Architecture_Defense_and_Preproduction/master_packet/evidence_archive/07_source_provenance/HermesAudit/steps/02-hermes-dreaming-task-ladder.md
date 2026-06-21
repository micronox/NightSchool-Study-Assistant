# Hermes Dreaming Task Ladder

> **Purpose:** give Hermes work it can handle immediately, from small calibration tasks to large internal architecture jobs.

**Goal:** keep Hermes busy on useful work while the surrounding OS is still being assembled.

**Architecture:** Hermes Dreaming handles the larger reasoning and synthesis jobs. It breaks them into medium and small tasks that can be executed safely and repeatedly. The output should feed back into memory, skills, notes, and the task system.

**Source basis:** `Perplexity_Hermes-on-WSL Stack Analysis and Agentic OS Buildout Plan.md`, `Perplex_2_Designing a Hermes Mission Control for Multiple Workflows.md`, `Perplex_2_project-workflow-profiles-and-agentic-loop.md`, `Perplex_3_memory-obsidian-honcho-openviking.md`, `Perplex_4_client-work-upwork-github-isolation.md`, `Perplex_6_skills-user-groups-and-community-patterns.md`.

---

## 1. Small Tasks

These are fast, low-risk, and ideal for calibration.

- scan a repo and build a file map
- summarize a markdown folder into themes and decisions
- inspect `~/.hermes` and inventory current state
- review a diff for correctness and missing tests
- summarize a session into a note
- classify files into architecture, workflow, memory, client, or skills
- extract contradictions from a research dump
- identify what is already supported versus what is speculative

## 2. Medium Tasks

These require multiple steps but still stay bounded.

- write a repo onboarding skill
- write an environment audit skill
- write a daily report skill
- write a client safety check skill
- wire Hermes into Obsidian note capture
- create a simple Kanban or task file convention
- build a project manifest format for projects and clients
- convert repeated prompts into reusable skills
- design a profile-specific workflow for `myku-dev` or `client-dev`

## 3. Large Tasks

These are the jobs Hermes Dreaming should own directly.

- reconstruct a repo’s architecture from code, docs, and file layout
- design the first Hermes OS operating model
- propose the profile taxonomy for the whole stack
- design the full memory policy and provider layering
- plan the migration from ad hoc use to a durable agentic OS
- map the relationships between Desktop, WSL backend, profiles, skills, memory, and client isolation
- analyze multiple repos together and propose a unifying workflow
- design an internal “build Hermes from within Hermes” loop

## 4. Suggested Work Queue

### Small first

Use these to get Hermes productive immediately:

- repo map
- config inventory
- note summary
- diff review
- research condensation

### Then medium

Use these to grow the environment:

- onboarding skill
- daily report skill
- vault sync skill
- client safety skill
- task board convention

### Then large

Use Hermes Dreaming for these:

- stack architecture
- profile architecture
- memory architecture
- agentic OS roadmap
- multi-repo synthesis

## 5. Prompt Pattern

Use a repeatable prompt shape:

```text
Inspect this workspace.
Map the relevant files.
Summarize the current state.
Identify the next small tasks.
If useful, propose one medium task and one large task.
Write the result back into a markdown note.
```

## 6. Output Rules

- Small tasks should end in a concrete note or checklist.
- Medium tasks should end in a skill, script, or workflow artifact.
- Large tasks should end in a roadmap, architecture note, or decision log.
- Every task should produce something that can feed the next task.

