# Bucket 3: UI, UX, and Capability Path — Enhanced Audit

> **Compared against:** `steps/03-ui-ux-capability-path.md` (small thinking model output)
> **Audit date:** 2026-06-18
> **Auditor:** Claude Sonnet 4.6 (full context synthesis across all 10 research files)

---

## A. What the Small Model Got Right

The small model correctly identified the core tension: the current Hermes Desktop is likely
a thinner client surface than the full Mission Control capability described in the research.
Its list of power tools to surface (profile switching, session grouping, Kanban, skill
launcher, file/context panel, memory visibility, logs, model/provider status, health and
diagnostics) is accurate and matches the official Hermes Workspace/WebUI feature set.

The recommended UX layout (left: projects/profiles/sessions; center: task/conversation;
right: files/memory/tools/Kanban; top/footer: provider/health/mode) is directly drawn
from community Mission Control walkthroughs and is a sound target.

---

## B. Gaps, Under-Specifications, and Corrections

### B1. The thin vs full surface distinction needed a concrete explanation
The small model correctly infers a gap but doesn't explain what specifically distinguishes
the thin client from the full surface. The research is explicit: the full surface is
`hermes-webui` (three-pane web dashboard) plus the Workspace V2 and Kanban features. These
are separate from the Desktop app and serve complementary roles.

### B2. No concrete path from thin client to Mission Control
The small model identifies what's missing but doesn't say how to get there. The research
provides three concrete paths: (1) use `hermes-webui` in a browser tab pointed at WSL
gateway, (2) use the official Workspace V2 with profile switcher and Kanban, (3) use
community dashboards like `hermes-control-interface` or `hermes-dashboard` for admin/ops
views.

### B3. "Hermes Dreaming in the UI" was correct but underspecified
The small model lists Dreaming UI actions correctly. The concrete implementation is: a
dedicated Kanban board for the Dreaming profile, visible in the WebUI, with tasks that
persist across sessions. Not a special UI mode — just the Dreaming profile's Kanban.

### B4. Capability gaps were listed without priority or implementation path
"Kanban not visible in thin surface" is correct, but it needs: which tool adds it, how to
configure it, and what the integration looks like with your WSL backend.

### B5. Missing: the admin/ops layer
The small model focused on the operator UX (developer-facing) but the research also covers
an admin/ops layer (`hermes-control-interface`, `hermes-dashboard`) that exposes cron
management, MCP config, gateway health, and metrics. This is important for a power-user
OS.

---

## C. Complete Description

The UI/UX and Capability Path has three tiers, each serving a different level of need:

**Tier 1: Desktop thin client (already working)**
Hermes Desktop connected in remote mode to WSL gateway at `http://localhost:9119`.
This is your daily driver for conversational interaction. It handles: chat sessions,
basic session management, provider status display, and file browsing (Windows-rooted,
which is expected). It does NOT natively surface Kanban, profile switching in a polished
way, or memory visibility.

**Tier 2: WebUI Mission Control (primary upgrade target)**
`hermes-webui` is the official three-pane web dashboard for Hermes. Run it in a browser
tab pointed at your WSL gateway. It surfaces: session grouping by project, skill launcher,
the Workspace V2 profile switcher, Kanban board, and a file/context panel. This is what
the research's "Mission Control" concept looks like in practice. It runs against the same
gateway as Desktop — both can be open simultaneously.

**Tier 3: Admin/Ops Dashboard (power-user layer)**
Community tools like `hermes-control-interface` (Hermes Atlas) and `hermes-dashboard`
expose the ops layer: cron job management, MCP server config, model switching, gateway
health metrics, and terminal access. These complement the WebUI rather than replacing it.
Think of the WebUI as the operator cockpit and the admin dashboard as the engine room.

The target state is: Desktop for quick interactions → WebUI for full Mission Control →
Admin dashboard for infra ops. All three connect to the same WSL gateway.


---

## D. Implementation Plan

### Phase 1 — Inventory Current Desktop Capabilities (Day 1)

Before building anything, take a precise inventory of what the current Desktop surface
actually shows. This prevents mistaking a configuration gap for a capability gap.

Checklist for current Desktop:
- Does it show a Kanban board? (If not, this is the gap)
- Does it show a profile switcher? (Or just a single session view?)
- Does it show memory visibility? (Memory.md contents, recall events)
- Does it show skill launcher? (Can you invoke a skill from the UI?)
- Does it show model/provider selector? (Can you switch between Ollama and OpenRouter?)
- Does it show logs or run history?

Record what is and isn't present. This becomes the baseline for the upgrade path.

### Phase 2 — Deploy hermes-webui (Day 2–3)

`hermes-webui` is the official web dashboard that runs in a browser and provides the
three-pane Mission Control layout. Deploy it in WSL:

```bash
# Install hermes-webui (check official repo for current install method)
# Typically:
cd ~/projects/hermes-os
git clone https://github.com/nesquena/hermes-webui
cd hermes-webui
npm install && npm run build
# Or follow their documented setup

# Run it, pointing at your existing gateway:
npm start -- --gateway http://127.0.0.1:9119 --port 3001
```

Open in browser: `http://localhost:3001`

This gives you the three-pane layout immediately:
- Left: sessions grouped by project/profile
- Center: chat and task view
- Right: file panel, memory panel, skills panel

### Phase 3 — Configure Workspace V2 and Kanban (Day 3–4)

Within the WebUI (or via gateway config), activate Workspace V2 and Kanban. These are
official Hermes features. The Workspace V2 adds the profile switcher and multi-agent
orchestration view. The Kanban board adds durable task cards per profile.

For each profile from Bucket 1, create a dedicated Kanban board:
- `infra-ops` board: infra tasks, health checks, upgrade queue
- `research` board: research topics, source reading queue, synthesis tasks
- `myku-dev` board: feature cards for MyKu, 3D scene tasks, shader work
- `ai-docs-dev` board: documentation pipeline, content queue
- `client-dev` board: per-client task columns
- `hermes-dreaming` board: small/medium/large task ladder (from Bucket 2)

### Phase 4 — Add Memory Visibility Panel (Day 4)

The research identifies memory visibility as a key capability gap. In the WebUI, this
surfaces as a panel showing:
- What is currently in the active profile's MEMORY.md and SOUL.md
- What OpenViking last recalled in this session
- The ability to manually add or remove memory entries

If the WebUI doesn't provide this natively, create a skill that dumps the current memory
state to a readable format:

```bash
# Skill: memory-status
# Reads MEMORY.md, SOUL.md, and makes an OpenViking recall query
# Writes result to a temp note displayed in session
```

### Phase 5 — Deploy Admin/Ops Dashboard (Week 2)

Once the WebUI is stable, add the admin layer. Options in priority order:

**Option A: hermes-control-interface (Hermes Atlas)**
- Browser-based terminal, file explorer, session overview, cron management, metrics
- Best for WSL backend visibility and ops control

**Option B: hermes-dashboard**
- Web dashboard for config, MCP, cron, and model management
- Simpler, less opinionated

Deploy whichever fits your ops style, again pointing at the WSL gateway. Run on port 3002.

### Phase 6 — MyKu-Specific UI Extensions (Future)

The research points to a visualization-centric OS path for MyKu. Once the base control
surface is stable, this means:
- Embedding 3D scene previews in the Hermes dashboard (Kanban card thumbnails)
- A skill that launches or controls a MyKu 3D viewer from the dashboard
- A catalog skill that maintains 3D asset metadata in the vault and surfaces it in the WebUI

This is the "Visualization OS" customization route and comes after the core Mission Control
is working.


---

## E. Design Spec Sheet

### Three-Tier UI Architecture

| Tier | Tool | Port | Role | Gateway |
|------|------|------|------|---------|
| Desktop thin client | Hermes Desktop (.exe) | Remote → 9119 | Daily conversational UI | WSL gateway |
| Mission Control WebUI | hermes-webui | 3001 | Full operator surface, Kanban, profiles | WSL gateway |
| Admin/Ops dashboard | hermes-control-interface | 3002 | Cron, MCP, model, health, terminal | WSL gateway |

All three point to the same WSL gateway. Desktop runs on Windows natively. WebUI and Admin
run in WSL and are accessed via browser on Windows.

### WebUI Panel Layout Target

```
┌─────────────────────────────────────────────────────────────────┐
│  [Profile: myku-dev ▼]  [Provider: Ollama ●]  [Health: OK ✓]  │
├──────────────┬──────────────────────────┬───────────────────────┤
│              │                          │                       │
│  Sessions    │   Task / Conversation    │   Files               │
│  ─────────   │   ─────────────────────  │   ─────────────────   │
│  myku-dev    │                          │   ~/projects/myku/    │
│  ─────────   │   [current session]      │                       │
│  research    │                          │   Memory              │
│  ─────────   │                          │   ─────────────────   │
│  client-dev  │                          │   SOUL.md preview     │
│              │                          │   Last recall event   │
│  Kanban      │                          │                       │
│  ─────────   │                          │   Skills              │
│  [Board]     │                          │   ─────────────────   │
│              │                          │   [Skill launcher]    │
└──────────────┴──────────────────────────┴───────────────────────┘
```

### Capability Gap Priority Matrix

| Capability | Current Desktop | After WebUI | After Admin Dashboard | Priority |
|------------|----------------|-------------|----------------------|----------|
| Kanban board | Missing | Present | Present | P0 |
| Profile switcher | Partial | Full | Full | P0 |
| Skill launcher | Missing | Present | Present | P1 |
| Memory visibility | Missing | Partial | Full | P1 |
| Model/provider selector | Partial | Full | Full | P1 |
| File scope visibility | Windows-only | Both | Both | P2 |
| Logs and run history | Partial | Full | Full | P2 |
| Health and diagnostics | Minimal | Minimal | Full | P2 |
| Cron management | CLI only | CLI only | Present | P3 |
| MCP config | CLI only | CLI only | Present | P3 |

### UX Priorities (ordered)

1. Make project context obvious (which project, which profile, which Kanban board)
2. Make agent role obvious (which SOUL.md is active)
3. Make task state obvious (Kanban board visible without leaving the main surface)
4. Make memory retrieval visible (what was recalled on this turn)
5. Make model/provider selection visible (and switchable without restarting)
6. Make file scope visible (are file tools pointing at WSL or Windows paths?)
7. Make health and logs visible (is the gateway healthy, did the last cron job succeed?)

---

## F. Step-by-Step Implementation Checklist

- [ ] **F1.** Take inventory of current Desktop capabilities (check all items in Phase 1 list)
- [ ] **F2.** Document the gaps (what's missing vs what was expected)
- [ ] **F3.** Clone and install `hermes-webui` in WSL
- [ ] **F4.** Start WebUI pointed at `http://127.0.0.1:9119`, confirm it connects
- [ ] **F5.** Open WebUI in browser, confirm three-pane layout appears
- [ ] **F6.** Enable Workspace V2 in WebUI settings
- [ ] **F7.** Enable Kanban board in WebUI settings
- [ ] **F8.** Create a Kanban board for each profile (6 boards total including Dreaming)
- [ ] **F9.** Pin three sessions per profile to the WebUI sidebar (3×5 = 15 pinned sessions)
- [ ] **F10.** Confirm profile switcher works (switch between myku-dev and client-dev)
- [ ] **F11.** Confirm skill launcher works (launch `repo-onboard` from the UI)
- [ ] **F12.** Add memory visibility to WebUI (via native panel or memory-status skill)
- [ ] **F13.** Deploy and start admin dashboard (hermes-control-interface or hermes-dashboard)
- [ ] **F14.** Confirm admin dashboard shows cron job list
- [ ] **F15.** Confirm admin dashboard shows MCP server status
- [ ] **F16.** Set up Windows browser bookmarks: Desktop → WebUI → Admin Dashboard
- [ ] **F17.** Document the three-tier access pattern for your own reference

---

## G. Divergences from Small Model Plan

| Small model said | Audit verdict | Correction |
|-----------------|---------------|------------|
| "current version may be thinner" | Correct inference | Confirm by inventory; WebUI is the concrete upgrade |
| Power tools list is accurate | Confirmed | All items map to WebUI or Admin dashboard features |
| "add the richer dashboard layer" | Correct direction | Specify: `hermes-webui` (WebUI) + `hermes-control-interface` (Admin) |
| "Hermes Dreaming in UI = visible operator mode" | Correct | Implement as Dreaming profile's Kanban board, visible in WebUI |
| Good UI target layout | Good target | Add explicit panel names and the three-tier architecture |
| "WSL in charge even when UI gets sophisticated" | Correct | Confirmed: all three UI tiers point at the same WSL gateway |

---

*Source cross-references: `Perplex_1` §1.2–1.3, `Perplex_2_Designing-Mission-Control` §1–3,
`Perplex_2_project-workflow` §2–3, `Perplex_5_github-youtube` §maintainer-endorsed tools,
`Perplexity_Hermes-on-WSL` §3, `steps/03-ui-ux-capability-path.md`*
