<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# Take the research you've gathered and use this focus as a lens:

I'd Like you to distinguish:
official Hermes-supported patterns
maintainer-endorsed practices
community patterns
hacks or unsupported workarounds
Ask it for concrete examples, file layouts, and command patterns.
Ask it to cite GitHub issues, docs pages, release notes, maintainer comments,
and creator walkthroughs where possible.
High-Level Research Priorities
Best supported location and architecture for Windows Hermes Desktop when WSL
remains backend authority.
Best practice for future projects and project switching.
Best path to building a Hermes-native local agentic loop.
Best memory layering strategy across built-in memory, Obsidian, Honcho, and
OpenViking/Viking memory.
Best safety model for client work, side work, and external GitHub commits.
Highest-signal community customization routes.

Now I want you to take that lens and apply it to the 01-hermes-architecture-and-desktop-location.md I am attaching

Shortest version: keep Hermes Desktop on Windows in its default AppData home as a thin remote UI; keep *all* runtime authority in WSL under `~/.hermes`; do **not** couple Desktop state to project folders; layer memory via built‑in files + Obsidian + an external provider like OpenViking; and borrow Mission‑Control patterns (Kanban, Workspace, WebUI) from official/docs/maintainer‑endorsed tools rather than from per‑project `HERMES_HOME` hacks.[^1][^2][^3][^4][^5][^6]

Below is your 01‑packet, reinterpreted through the lens you asked for.

***

## 1. Windows Desktop Architecture \& Location (Options 1–4)

### 1.1 What *officially* lives where

**Official Hermes‑supported patterns**

- Hermes treats `~/.hermes` as the canonical home on Unix and `%LOCALAPPDATA%\hermes` as the default on Windows; installers and docs assume these defaults for the gateway/CLI.[^3][^7][^8]
- v0.16 “Surface Release” and docs treat the desktop app as a **thin client** connecting to local or remote gateways (including WSL/VPS), with the gateway remaining runtime authority.[^2][^9][^10]
- Windows desktop and CLI store binaries and `.env` under `%LOCALAPPDATA%\hermes` and desktop‑specific config (such as `connection.json`) under a separate `%APPDATA%\Hermes`‑style folder.[^11][^12][^3]

**Maintainer‑endorsed practices**

- A core Windows issue on `load_hermes_dotenv` confirms that, on Windows, the gateway and CLI resolve `.env` via `%LOCALAPPDATA%\hermes` (influenced by `HERMES_HOME`), reinforcing that this path is the expected home for runtime state rather than something to casually move into project trees.[^11]
- Release notes and install guides treat **remote gateway + desktop** as a first‑class architecture, with Linux/WSL recommended as the production runtime and desktop as a UI surface, not as a second authoritative runtime.[^7][^10][^2][^3]

**Community patterns**

- Mission‑Control/Agent‑OS guides overwhelmingly use:
    - Hermes agent running on a stable server/WSL/VPS home (`~/.hermes` or `%LOCALAPPDATA%\hermes`).
    - A web dashboard or desktop app as a stateless client pointing at that gateway (`http://localhost:<port>` or VPS URL).[^13][^14][^15][^16]
- Community dashboards like `hermes-webui`, `hermes-control-interface`, and `hermes-dashboard` all assume the default gateway home and paths; they don’t advocate relocating Hermes home per project.[^5][^17][^18]

**Hacks / unsupported workarounds**

- Putting `HERMES_HOME` or `%APPDATA%`/`%LOCALAPPDATA%\Hermes` **inside project folders or Git repos** is not documented and is explicitly cautioned against in community ops threads, due to risk of state corruption, massive `.git` noise, and upgrade conflicts.[^4][^19][^13]
- Using *per‑project* `HERMES_HOME` values on Windows so that each codebase has its own Hermes home is also a hack: the code path was built for “one runtime, one home” and issues suggest edge‑cases even when only changing the user‑scope default.[^11]


### 1.2 Evaluating your four options

Using your criteria (support, maintainability, upgrade safety, etc.):


| Option (from 01‑packet) | Classification | Notes |
| :-- | :-- | :-- |
| 1) Leave Desktop at `%LOCALAPPDATA%\hermes` | **Official + maintainer‑aligned** | Matches installer defaults, issue behavior, and docs; best for upgrades and support.[^11][^3][^7] |
| 2) Relocate Desktop to single custom path `L:\HermesDesktopHome` | **Advanced / partially supported** | `HERMES_HOME` works for CLI/gateway; no explicit guarantee for desktop UX; must keep separate from project repos.[^11][^3] |
| 3) Project‑specific Desktop homes | **Hack / discouraged** | Conflicts with how Hermes expects a single home; increases corruption and upgrade risk; no docs support this.[^11][^4][^19] |
| 4) Avoid Desktop, use pure WSL CLI/dashboard | **Official alternative** | Fully supported; many guides still show “gateway + web dashboard only” without desktop.[^3][^10] |

**Recommendation for your exact architecture (WSL backend authority):**

- Prefer **Option 1**: keep Windows Hermes Desktop and CLI in `%LOCALAPPDATA%\hermes` and treat it purely as a thin client for your WSL gateway. This gives you official paths and the least friction on upgrades.[^1][^2][^3]
- Treat **Option 2** only as an **advanced ops move** if you are truly constrained on C: and want to consolidate to `L:\`. If you do it, use `HERMES_HOME` at the *user* level and keep this home separate from any repo (`L:\HermesDesktopHome` is fine), but assume fewer people have exercised this path.[^3][^11]
- Avoid Options 3 and 4 for now: 3 is a state‑corruption trap; 4 throws away a now‑first‑class desktop capability you have already proven works against WSL.[^10][^20][^2]


### 1.3 Concrete file layout and division of responsibility

**WSL (authoritative backend) – Official pattern**

```text
/home/larry/
  .hermes/
    config.yaml
    .env
    skills/
    memory/
    logs/
    sessions/
  projects/
    myku/
    ai-docs/
    clients/
    hermes-os/
```

- All Hermes runtime authority: config, skills, memory, sessions.[^20][^1]
- All provider wiring: Ollama (`http://127.0.0.1:11434/v1`), OpenRouter keys.[^8][^20]
- All scheduled jobs and crons live here (via `config.yaml` and gateway settings).[^10]

**Windows (desktop + tools) – Official/maintainer‑aligned pattern**

```text
C:\Users\<you>\AppData\Local\hermes\
  hermes.exe / hermes-cli
  .env           (Windows-specific if needed)
  logs\          (CLI-related)

C:\Users\<you>\AppData\Roaming\Hermes\
  connection.json   (mode: "remote", url: "http://localhost:9119")
  ui-settings.json  (themes, panes, etc.)

L:\AI_Vault\
  Ollama_Models\
  HuggingFace_Hub\

L:\Vaults\
  MyKu-Obsidian\
  AI-Docs-Obsidian\
```

- Desktop: thin UI, can be blown away and re‑installed without touching WSL authority.[^12][^2][^3]
- Vaults: shared between Windows and WSL via mounts and Hermes file tools (for memory layer).[^21][^4][^20]

**Key “do this / do not do this” from the architecture packet, now annotated**

- **Do**: keep `~/.hermes` as the only backend authority on WSL.
- **Do**: let Windows Desktop live in `%LOCALAPPDATA%\hermes` (or one dedicated, non‑repo path if you must move it via `HERMES_HOME`).[^1][^11]
- **Do not**: put Hermes Desktop home or `HERMES_HOME` inside project folders or Git repos; treat it like `.npm` or `.cargo`, not like `node_modules` vendor folders.[^19][^4][^1]
- **Do not**: run a second “full” Hermes backend on Windows for the same account; keep one gateway of record (WSL) and treat desktop as a client.[^9][^2][^20]

***

## 2. Best Practice for Future Projects \& Project Switching

### 2.1 Official / maintainer patterns

- Hermes’ docs and WebUI focus on **sessions, profiles, and Kanban boards** as the way to partition work rather than on per‑project runtime homes.[^6][^15][^5]
- Workspace/Mission‑Control guides show multiple “profiles” and “workspaces” driving parallel projects from a single runtime, with tags and boards for per‑project scoping.[^15][^22]

**Maintainer‑endorsed practice:** single Hermes home, multiple projects represented as:

- Tags on sessions.
- Separate Kanban boards.
- Different profiles/agents with per‑project prompts.[^6][^15]


### 2.2 Community patterns

- Agent‑OS walkthroughs show one Hermes instance orchestrating multiple client/business projects using a shared Kanban and Obsidian vault, not separate installations per client or project.[^23][^13][^21]


### 2.3 Applied to your packet

Given your 01‑spec’s decision questions, the best practice for **future projects and switching** is:

- **One Hermes runtime in WSL** (`/home/larry/.hermes`).
- **One Windows Desktop install**, connected in remote mode.
- Projects distinguished by:
    - Manifest files in `~/projects/hermes-os/projects/*.yaml`.
    - Hermes Kanban boards per project (or columns per project).[^19][^6]
    - Profiles like `MyKu-Dev`, `AI-Docs-Research`, `Client-X-Reviewer` in Workspace.[^22][^15]

Switching projects becomes: change the active profile + board + repo, not `HERMES_HOME`.

***

## 3. Hermes‑Native Local Agentic Loop

### 3.1 Official / maintainer‑aligned pieces

- Hermes core is “the agent that grows with you”; v0.16 release notes highlight improved model picking, leaner skills, and better web dashboard/admin to support self‑improving workflows.[^24][^2][^9]
- Kanban is the official **multi‑agent board**, giving durable tasks for collaboration and automation.[^6][^19]
- Cron/job support via the gateway enables recurring jobs (nightly reviews, memory sync, etc.).[^10]


### 3.2 Community patterns (Agent OS, Mission Control)

- Mission‑Control content shows a canonical **loop**:

1) Kanban task appears.
2) Orchestrator agent decomposes it.
3) Specialized agents work, logging steps.
4) Nightly jobs summarize and propose improvements.[^14][^16][^13]


### 3.3 Best path on *your* stack (WSL‑first)

Applied to your architecture packet:

- Keep all **agentic loop logic in WSL** as skills + crons under `~/.hermes`.
- Use Desktop only to observe and steer: select tasks, inspect logs, adjust prompts.

**Concrete example skill + command pattern:**

- Skill `tool_inventory` (WSL): scans `~/.hermes/skills` and `~/projects`, writes `skills_inventory.md`.
- Skill `grow_environment`: reads `skills_inventory.md` + project manifest, proposes new skills and scripts, writes patches to disk for your review.
- Cron job: `hermes job add --cron '0 3 * * *' --task 'run grow_environment for myku.yaml'`.

This is purely Hermes‑native (skills + jobs) and lives entirely in WSL, in line with official runtime expectations.[^24][^10]

***

## 4. Memory Layering: Built‑in, Obsidian, Honcho, OpenViking

### 4.1 Official / maintainer‑endorsed memory model

- Hermes has built‑in `MEMORY.md` and `USER.md` mechanisms and a pluggable `memory.provider` for external backends such as Honcho, OpenViking, Mem0, etc.[^25][^4]
- Docs explain that exactly one external provider is active at a time, but this is **in addition** to the built‑in memory files.[^4][^25]


### 4.2 OpenViking/Viking and Honcho

- OpenViking docs include a dedicated \"Hermes Agent\" integration, with clear instructions for setting `memory.provider: openviking` and connecting to a Viking server.[^26][^27]
- Hermes memory‑provider comparison articles show Honcho and OpenViking as high‑signal options for long‑term semantic memory in self‑hosted Hermes stacks.[^4]


### 4.3 Community patterns (Obsidian + Agent OS)

- Mission‑Control/Agent‑OS content often uses **Obsidian as the human‑facing knowledge graph**, with Hermes reading and writing notes via file tools or MCP.[^28][^21][^23]


### 4.4 Best layering strategy applied to your architecture spec

With WSL backend and Windows vaults:

- **Layer 1 (built‑in)**: `MEMORY.md` and `USER.md` inside `~/.hermes` for global identity and top‑level behavior.[^25][^4]
- **Layer 2 (Obsidian / Open‑Brain)**: vaults on `L:\Vaults\...` mounted into WSL; Hermes file tools and skills read/write key .md files (film‑language schemas, project READMEs, client SOPs).[^20][^21]
- **Layer 3 (external provider)**: OpenViking or Honcho as `memory.provider`, storing semantic memory and structured facts linked to sessions; Hermes uses this on every turn.[^26][^25][^4]

This layering is **official + maintainer‑aligned** (external memory) plus **community‑endorsed** (Obsidian), and it keeps heavy state off Windows Desktop and squarely in WSL and your vaults.

***

## 5. Safety Model for Client Work, Side Work, GitHub Commits

### 5.1 Official / maintainer patterns

- Hermes docs and gateway design emphasize self‑hosting and provider configuration per environment, allowing separation between local/self‑hosted models (e.g., Ollama) and cloud APIs (OpenRouter, Anthropic, etc.).[^29][^8]
- Multi‑profile and multi‑workspace features let you scope different provider mixes and prompts per profile.[^15][^22]


### 5.2 Community best practice (Agent OS + freelance scenarios)

- Agent OS and podcast walkthroughs highlight **client isolation** as a key concern: separate vault folders, separate Kanban lanes, and sometimes even separate Hermes instances per high‑sensitivity client.[^30][^13][^14]


### 5.3 Applied guidance for your spec

Given your architecture and goal of Upwork/side work:

- Keep **one Hermes runtime on WSL**, but **isolate client data** at the filesystem and configuration level:
    - `~/clients/<client-name>/repo`.
    - Per‑client Obsidian sub‑vault and Hermes Kanban lane.
- For sensitive repos, set the profile to **local‑only providers** (Ollama Qwen/Gemma) and explicitly disable OpenRouter/other cloud providers in that profile.[^8][^29]
- Use Hermes to:
    - Draft code, tests, and docs.
    - Map repos and generate PR descriptions.
    - Never automatically push; Git operations (commit, push, branch) remain under your direct CLI/VSCode control.

This is official (self‑hosted, provider‑scoped) plus community‑endorsed (Agent OS for client pipelines) and stays far away from the hack of mixing Hermes’s own home into client repos.

***

## 6. Highest‑Signal Customization Routes (for Your Stack)

### 6.1 Official / maintainer‑endorsed

- **Hermes WebUI** (`hermes-webui`): best‑practice web surface for Hermes agent; three‑panel layout, session grouping, file view.[^5]
- **Kanban / multi‑agent board**: official Hermes feature for multi‑agent coordination and persistent tasks.[^19][^6]
- **Workspace / profiles**: multiple agent profiles and swarms in one UI; excellent fit for your multi‑workflow MyKu/AI‑Docs/client world.[^22][^15]


### 6.2 High‑signal community patterns

- Mission‑Control and Agent‑OS dashboards that integrate Hermes with Kanban, Obsidian, and remote gateways; these are the primary reference designs for building a command center.[^16][^13][^14][^21][^23]
- Admin‑focused dashboards (`hermes-control-interface`, `hermes-dashboard`) that expose terminals, cron, metrics, and MCP in one UI.[^17][^18]


### 6.3 Low‑signal / hacky routes to avoid

- Per‑project `HERMES_HOME` juggling on Windows.
- Putting Hermes home or desktop config inside Git repos.
- Running multiple competing Hermes backends (WSL + Windows full installs) for the same user account without a clear separation plan.

These conflict directly with the questions and risks you articulated in `01-hermes-architecture-and-desktop-location.md`, and they are neither documented nor encouraged by maintainers.[^1][^4][^11]

***

## 7. Direct Answers to the 01‑Packet’s Central Questions

Mapping back to the exact questions in `01-hermes-architecture-and-desktop-location.md`:

- **What stays on Windows in remote/Desktop mode?**
Binaries and CLI in `%LOCALAPPDATA%\hermes`, desktop config in `%APPDATA%\Hermes`, transient logs/cache; no runtime authority or provider config that matters for WSL.[^12][^3][^11]
- **Is `%LOCALAPPDATA%\hermes` intended as the long‑term home?**
Yes. That is the installer default and the path used in env‑loader code and docs; relocating is advanced, not the expected norm.[^7][^3][^11]
- **Is relocating via `HERMES_HOME` officially supported?**
Supported for CLI/gateway; effect on desktop is under‑documented and thus “advanced / use at your own risk”.[^3][^11]
- **Best practice for location:**
Single global home, either `%LOCALAPPDATA%\hermes` or a dedicated non‑repo `L:\HermesDesktopHome` if you are willing to live with a lightly‑trodden path—**not** project‑specific homes.[^11][^1]
- **Relationship between Desktop, helper processes, `hermes dashboard`, WSL authority:**
Desktop is a thin Electron UI; helper Python/dashboard processes on Windows are bootstrap/UX; `hermes dashboard` on WSL is the real gateway; WSL `~/.hermes` is ultimate authority.[^2][^9][^20][^10]
- **File semantics in remote mode:**
Desktop file browsing is Windows‑local; Hermes tools execute against WSL paths; effectively a **mixed** model, but runtime actions are backend‑remote.[^5][^20][^10]

That is the cleanest interpretation that aligns both with your ground truths and with what maintainers and high‑signal community materials show today.

<div align="center">⁂</div>

[^1]: 01-hermes-architecture-and-desktop-location.md

[^2]: https://agentwikis.com/wiki/hermes/wiki/summaries/release-v0.16.0.md

[^3]: https://hermesatlas.com/guide/install/

[^4]: https://www.glukhov.org/ai-systems/memory/agent-memory-providers/

[^5]: https://github.com/nesquena/hermes-webui

[^6]: https://hermes-agent.nousresearch.com/docs/user-guide/features/kanban

[^7]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/getting-started/installation.md

[^8]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/integrations/providers.md

[^9]: https://hermes-agent.ai/blog/hermes-agent-v0-16-surface-release

[^10]: https://www.youtube.com/watch?v=3k3ve358jBo

[^11]: https://github.com/NousResearch/hermes-agent/issues/31144

[^12]: https://apimaster.ai/docs/en/agents/hermes

[^13]: https://aisuccesslabjuliangoldie.com/blog/hermes-agent-mission-control/

[^14]: https://juliangoldieaiautomation.com/blog/hermes-agent-mission-control/

[^15]: https://aimoneylabjuliangoldie.com/blog/hermes-workspace/

[^16]: https://www.youtube.com/watch?v=t6W_Zpohb7g

[^17]: https://hermesatlas.com/projects/xaspx/hermes-control-interface

[^18]: https://github.com/chrisryugj/hermes-dashboard

[^19]: https://www.reddit.com/r/hermesagent/comments/1t2sqjj/hermes_agent_just_added_real_multiagent/

[^20]: hermes_perplexity_research.md

[^21]: https://www.youtube.com/watch?v=6QLzDqB5YKU

[^22]: https://www.youtube.com/watch?v=zIcXS-bZ_m0

[^23]: https://www.youtube.com/watch?v=P3BJl_V_UZ8

[^24]: https://github.com/nousresearch/hermes-agent

[^25]: https://hermes.ai.vn/docs/user-guide/features/memory-providers/

[^26]: https://docs.openviking.ai/en/agent-integrations/05-hermes

[^27]: https://docs.openviking.ai/zh/agent-integrations/05-hermes

[^28]: https://www.youtube.com/watch?v=dMEuVbSr7AQ

[^29]: https://hermes-agent.org

[^30]: https://podcasts.apple.com/au/podcast/hermes-agent-os-just-changed-everything/id1851256047?i=1000769506428

