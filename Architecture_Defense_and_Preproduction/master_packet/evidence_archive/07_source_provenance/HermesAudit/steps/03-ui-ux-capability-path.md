# UI, UX, and Capability Path

> **Purpose:** improve the operator experience and expose the power tools that are not visible in the thin Desktop surface.

**Goal:** move from “chat app” to a real control surface for Hermes work.

**Architecture:** keep the current Desktop lane as a client if that is what it is, but add or connect the richer Mission Control / WebUI / Workspace style surface where profiles, Kanban, skills, sessions, and memory can be managed. Treat the current UI generation as possibly thinner than the examples in the research.

**Source basis:** `Perplex_1_hermes-architecture-and-desktop-location.md`, `Perplex_2_Designing a Hermes Mission Control for Multiple Workflows.md`, `Perplex_2_project-workflow-profiles-and-agentic-loop.md`, `Perplex_5_github-youtube-customization-routes.md`, `Perplex_6_skills-user-groups-and-community-patterns.md`, `Perplexity_Hermes-on-WSL Stack Analysis and Agentic OS Buildout Plan.md`.

---

## 1. Current UI Reality

The research strongly suggests two different Hermes Desktop workflows:

- a thin remote client workflow
- a fuller mission-control workflow with Kanban, profiles, skills, and workspace controls

If the current version does not show Kanban, persona, or skills, that likely means it is the thinner surface or a different UI generation. That is an inference, but it matches the packet.

## 2. Power Tools to Surface

The UI should expose:

- profile switching
- session grouping by project
- Kanban or durable task board
- skill launcher
- file/context panel
- memory visibility and retrieval controls
- logs and run history
- model/provider status
- health and diagnostics
- project and client isolation views

## 3. Hermes Dreaming in the UI

Dreaming should be a visible operator mode, not just an invisible behavior.

Useful UI actions:

- “inspect this repo”
- “design this subsystem”
- “extract decisions”
- “propose next tasks”
- “convert this workflow into a skill”

## 4. Capability Gaps to Close

The research points to these gaps as the most useful upgrades:

- Kanban not visible in the thin surface
- profile management not obvious enough
- skills not surfaced as first-class tools
- memory not visible enough to explain why Hermes remembers things
- file browsing semantics are unclear across Desktop and WSL
- remote backend state is not transparent enough

## 5. UX Priorities

Prioritize these improvements in order:

- make project context obvious
- make agent role obvious
- make task state obvious
- make memory retrieval visible
- make model/provider selection visible
- make file scope visible
- make health and logs visible

## 6. Good UI Target

A strong Hermes control surface should feel like:

- left side: projects, profiles, and sessions
- center: current task or conversation
- right side: files, memory, tools, and Kanban
- top or footer: provider, health, and active mode

That is the “power tools” layer the packet keeps pointing toward.

## 7. Implementation Notes

- Do not confuse a thin Desktop client with the full Hermes operating surface.
- Do not assume missing controls mean the architecture is wrong.
- Add the richer dashboard or workspace layer where those controls actually live.
- Keep WSL in charge even when the UI gets more sophisticated.

