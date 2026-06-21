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

Now I want you to take that lens and apply it to the 06-skills-user-groups-and-community-patterns.md which is attached

Short version: treat skills as your primary extension surface, sourced first from the official Skills Hub/marketplace, then from a few high‑signal community libraries; wire them into WSL‑resident profiles and Kanban/cron loops; and ignore per‑repo “magic” skills or anything that blurs the line between Hermes tools, MCPs, and plain scripts.[^1][^2][^3][^4]

Below is Packet 06 through that lens.

***

## 1. Official Hermes Skill Model (What a Skill Is)

**Official Hermes‑supported patterns**

Docs and the skills/marketplace pages define a **skill** as a reusable workflow package (prompt + tool wiring + metadata) installed under Hermes home, not inside individual repos.[^2][^3][^4]

Canonical layout (global skills):

```text
~/.hermes/
  skills/
    repo-map/
      SKILL.md
      skill.yaml
      scripts/
    daily-report/
      SKILL.md
      skill.yaml
```

Per‑profile skills live under `~/.hermes/profiles/<profile>/skills/…` when you want tighter scoping (e.g., `myku-dev`‑only tools).[^5][^6]

Official docs and marketplace materials emphasize:

- Installation from the **Skill Marketplace/Skills Hub** via CLI or dashboard (one command).[^4][^7][^2]
- Skills are **versioned units**, with their own readme/metadata, not random prompt snippets.

This is the core pattern you should follow in WSL; Windows Desktop just calls into these.

***

## 2. Maintainer‑Endorsed Practices: Skill vs Tool vs MCP vs Script

Across docs, blog posts, and advanced tips, the split looks like this:[^3][^8][^9][^2]

- **Skill**
    - Multi‑step workflow the agent runs: “Onboard repo”, “Produce daily report”, “Summarize vault changes”, “Run PR review”.
    - Encodes prompts, call‑order, and which tools to use.
    - Lives in `skills/` and is invoked by name or via the UI.
- **Tool**
    - Low‑level capability: shell commands, file I/O, HTTP call, Git, etc.
    - Provided by Hermes core or by MCP servers.
- **MCP**
    - External service surface (search, Obsidian connector, custom APIs).
    - Skills call MCP tools; MCPs are how Hermes talks to other systems.
- **Script**
    - Plain Python/shell living in your repos; skills or tools may execute it (e.g., `scripts/health_check.py`).
    - Good for heavy logic and local environment actions.

**Maintainer‑endorsed pattern:** complex behavior lives in scripts and tools; **skills orchestrate** them; MCP is the bridge to external services.[^8][^9][^2][^3]

**Hack/anti‑pattern:** putting all logic in one giant prompt/skill that does shell, Git, HTTP, and memory manipulation itself—hard to test, hard to secure, and inconsistent with the designed division of responsibility.[^8]

***

## 3. Skill Categories Advanced Users Actually Build

From Skills Hub, marketplace write‑ups, dev‑workflow blogs, and master threads:[^10][^11][^2][^3][^4]

**Official + maintainer‑aligned categories**

- Repo onboarding / codebase mapping.
- Coding loops (plan → implement → review → test).
- Note capture and summarization.
- Research automation (web + docs → memo).

**Community power‑user categories** (matches Packet 06 list):

- **Repo onboarding** – map tree, detect frameworks, create `REPO_MAP.md`, spot entrypoints.[^11][^12][^10]
- **Debugging \& test loops** – run tests/build, parse errors, propose fixes.
- **Deployment helpers** – generate or validate CI configs, deployment docs, or release notes.
- **Note capture \& memory hygiene** – append daily logs, create/update Obsidian notes, perform “memory pruning”.[^13][^8]
- **Coding loops** – one skill that sequences: inspect diff → review → suggest tests → generate docs.
- **Research automation** – multi‑URL ingest → comparative brief → risk/opportunity lists.[^12][^10]

This lines up well with how you already think about MyKu/AI Docs and your agentic loop.

***

## 4. Concrete Skill Patterns \& File Layouts for Your Stack

For a WSL‑authoritative Hermes + Desktop client OS, high‑value skill patterns are:

### 4.1 Repo onboarding skill (per dev profile)

Layout (per‑profile, e.g., `myku-dev`):

```text
~/.hermes/profiles/myku-dev/skills/repo-onboard/
  SKILL.md
  skill.yaml
  scripts/
    scan_repo.py
```

Behavior:

- Inputs: repo path, language/framework hints.
- Steps:

1) Use a file‑listing tool to scan directories.
2) Group by concern (src, tests, shaders, docs).
3) Write `REPO_MAP.md` into `docs/` in the repo.

This matches both the Hermes skill philosophy and the real “what devs actually do” blog examples.[^2][^3][^10]

### 4.2 Daily status / memory hygiene skill

Global skill in `~/.hermes/skills/daily-report/`:[^12][^13][^8]

- Reads commit history + recent sessions.
- Writes a `DAILY.md` or similar note into your Obsidian vault for each active project.
- Optionally prunes or summarizes older notes.

Triggered via cron in the profile:

```bash
client-dev jobs add --cron "0 2 * * *" --task "daily-report --scope clients"
```


### 4.3 Client safety skill

Per‑profile skill under `client-dev` to check environment before work:[^9][^14][^8]

- Verify:
    - Provider config: local models vs cloud.
    - Working directory under `~/projects/clients/**`.
    - No risky outbound MCPs are enabled.
- Output a checklist and warn if conditions fail.

This turns your Packet‑04 safety model into a Hermes‑native workflow.

***

## 5. Skill‑Sharing Mechanisms \& Libraries

**Official/maintainer channels**

- **Skill Marketplace / Skills Hub** – the first place to look:[^7][^3][^4][^2]
    - Discover skills by category (dev, ops, research).
    - Install via CLI or Workspace/desktop UI.
    - Often authored or reviewed by maintainers and trusted contributors.

**Community mechanisms**

- **GitHub skills repos** – curated skill libraries, e.g. one maintained by Matt Pocock and others.[^4][^12]
- **Reddit Master Thread** – “[MASTER THREAD] Skills Hub \& Custom Skill Development” tracks notable skills and patterns, including repo onboarding, memory hygiene, and dev loops.[^11]
- **Discord \& GitHub Discussions** – maintainers and power users share skill snippets, SKILL.md patterns, and design critiques there.[^5][^8][^11]

These are **maintainer‑endorsed or community‑sanctioned** routes; random gists are fine for inspiration but not your primary feed.

***

## 6. User Groups \& Where to Learn from Real Builders

**Official / maintainer venues**

- **GitHub issues / discussions on `NousResearch/hermes-agent`** – lots of advanced questions and answers on profiles, memory providers, external tools, and desktop/remote mode; maintainers reply here most consistently.[^15][^16][^5]
- **Official docs site \& blog** – Workspace V2, Skill Marketplace, remote gateway, and security tips.[^17][^18][^7][^13]

**Community venues with strong signal**

- **Hermes subreddit (`r/hermesagent`)** – skill/master threads, config patterns, warnings about anti‑patterns (e.g., per‑repo installs, over‑ambitious auto‑editors).[^19][^11]
- **YouTube communities** around Nemanja, Workspace/Mission‑Control, and Tonbi’s webhook/automation series – they show end‑to‑end systems, not just “type /help and chat”.[^9][^13][^12]
- **Blogs \& newsletters** – deep‑dive write‑ups of dev workflows (repo mapping, PR review, daily reports) using Hermes as a real engineering assistant.[^10][^8]

**Hacks / low‑signal areas**

- Random “AI agent” Discords or X threads that don’t speak specifically about Hermes profiles, skills, or self‑hosting; they’re mostly hype and generic advice.

***

## 7. Signals of Serious Hermes Usage (vs Shallow Demos)

From docs, blogs, and community consensus:[^13][^8][^10][^11][^12]

**Serious usage tends to show:**

- Clear **profile taxonomy** (by role/domain), not per‑repo chaos.
- Skills that encode real workflows: repo onboarding, daily reports, PR review, memory pruning, vault updates.
- WSL/server Hermes backend with local providers (Ollama), plus remote Desktop/WebUI as thin clients—exactly your stack.[^20][^21][^17][^12]
- Kanban + cron + skills working together to form an agentic loop.
- Obsidian or similar used as a structured KB, not a dumping ground; memory providers configured intentionally (often one).[^22][^23][^8][^13]

**Shallow demos often show:**

- Single profile, no clear file or profile structure.
- “Look, it can call a shell tool!” with no safety or repeatability.
- Skills that duplicate trivial one‑shot prompts instead of codifying workflows.
- Everything happening in the desktop UI as though Hermes were ChatGPT, ignoring the gateway, WSL, or cron.

Use these as a filter when choosing which repos and videos to invest in.

***

## 8. How This Ties Back to Your OS Design

- **Architecture \& Desktop/WSL** – serious skill authors assume Hermes is running on a server/WSL and they interact via CLI, dashboard, or desktop; that matches your WSL‑backend/Windows‑Desktop thin‑client model.[^21][^24][^17][^13]
- **Future projects / project switching** – profiles + skill libraries + Kanban, not per‑project Hermes installs; the Skills Hub and Nemanja/Workspace guides reinforce that.[^16][^25][^5][^12][^13]
- **Agentic loop** – skills + Kanban + cron + memory are the official and community‑approved building blocks of a local agentic OS.[^25][^26][^3][^2][^9][^13]
- **Memory layering** – many high‑value skills revolve around vault notes and memory hygiene, so your built‑in + Obsidian + single provider design is exactly what community patterns assume.[^23][^27][^28][^22][^8][^13]
- **Client safety** – profile‑local skills, cautious provider config, and filesystem segregation are common themes in advanced advice; avoid any skill bundles that blur client boundaries or auto‑edit everything.[^14][^8][^9][^12]

Net: your Packet 06 “skills + user groups” focus is well supported by both official Hermes design and what power users are actually doing. The highest leverage next move is to pick 5–10 skills from the Skill Hub and the better community repos that directly implement your MyKu/AI‑Docs/client loops, install them into WSL under the right profiles, and wire them into your Kanban + cron workflow.

<div align="center">⁂</div>

[^1]: 06-skills-user-groups-and-community-patterns.md

[^2]: https://aiskill.market/blog/hermes-skills-hub-publishing-community-skills

[^3]: https://hermes-ai.net/skills/

[^4]: https://www.youtube.com/watch?v=T_AVEOuul0M

[^5]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/profiles.md

[^6]: https://hermes.ai.vn/docs/user-guide/profiles/

[^7]: https://hermes-agent.ai/features/skill-marketplace

[^8]: https://dreamsaicanbuy.com/blog/hermes-agent-tips

[^9]: https://www.youtube.com/watch?v=WNYe5mD4fY8

[^10]: https://chenguangliang.com/en/posts/blog122_hermes-agent-dev-workflow/

[^11]: https://www.reddit.com/r/hermesagent/comments/1snwkog/master_thread_skills_hub_custom_skill_development/

[^12]: https://www.youtube.com/watch?v=NvakBZyc1Sg

[^13]: https://aisuccesslabjuliangoldie.com/blog/hermes-agent-workspace/

[^14]: 04-client-work-upwork-github-isolation.md

[^15]: https://github.com/nousresearch/hermes-agent

[^16]: https://hermes-agent.nousresearch.com/docs/user-guide/multi-profile-gateways

[^17]: https://hermesatlas.com/guide/install/

[^18]: https://hermes-agent.ai/blog/hermes-agent-v0-16-surface-release

[^19]: https://www.reddit.com/r/hermesagent/comments/1t2sqjj/hermes_agent_just_added_real_multiagent/

[^20]: https://hermes-agent.org

[^21]: https://github.com/nesquena/hermes-webui

[^22]: https://www.glukhov.org/ai-systems/memory/agent-memory-providers/

[^23]: https://www.youtube.com/watch?v=6QLzDqB5YKU

[^24]: 01-hermes-architecture-and-desktop-location.md

[^25]: 02-project-workflow-profiles-and-agentic-loop.md

[^26]: https://hermes-agent.nousresearch.com/docs/user-guide/features/kanban

[^27]: 03-memory-obsidian-honcho-openviking.md

[^28]: https://hermes.ai.vn/docs/user-guide/features/memory-providers/

