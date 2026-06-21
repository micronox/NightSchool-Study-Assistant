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

Now I want you to take that lens and apply it to the 05-github-youtube-customization-routes.md which is attached

For Packet 05, the “right” customization routes are basically:

- **Official/maintainer repos and docs** for your mental model and primitives.
- **A small set of power‑user repos and videos** that show real, local‑first Hermes OS builds.
- Avoid broad “AI agent” channels that don’t speak Hermes, WSL, or local‑stack realities.[^1][^2][^3][^4]

Below is that lens applied directly to GitHub + YouTube, tied back to your architecture and safety goals.

***

## Official / Maintainer Resources (Start Here)

### Core Hermes code \& docs

1. **`NousResearch/hermes-agent` (GitHub)** – canonical codebase
Why it matters:
    - Source of truth for **profiles**, **skills**, **memory providers**, and **multi‑gateway** patterns.[^5][^6][^7]
    - `website/docs` covers installation, providers (Ollama, OpenRouter), profiles, and multi‑profile gateways.[^6][^7][^8][^9]

Read order inside the repo/docs:
    - Installation \& providers → multi‑profile gateways → profiles → skills reference.[^7][^8][^9][^10][^6]
2. **Profile \& multi‑gateway docs**
    - Profiles: how to run multiple agents with separate config, memory, and ports.[^11][^12][^6]
    - “Running many gateways at once”: shows the **official pattern** for multiple profiles/gateways on one machine—directly aligned with your WSL‑backend + multiple profiles plan.[^7]
3. **Providers \& memory docs**
    - Providers page: shows how to wire **Ollama** and **OpenRouter** into Hermes, exactly what you’re running.[^9]
    - Memory providers page: lists Honcho, OpenViking, Mem0, etc., and explains that a **single provider** is configured at a time alongside built‑in memory.[^13][^14]

These are **official Hermes‑supported patterns** and should be your baseline for:

- WSL backend architecture (already implemented).
- Profile separation for MyKu, AI Docs, and clients.
- Provider config for local Ollama + OpenRouter auxiliary.
- Memory layering with Honcho/OpenViking as optional extras.

***

## Maintainer‑Endorsed / First‑Party Adjacent Tools

### Hermes WebUI / Workspace / Kanban

- **`hermes-webui` (WebUI)** – “best way to use Hermes from the web”
    - Three‑pane layout (sessions, chat, context) that maps naturally onto your “Mission Control” concept.[^3][^15]
    - Integrates with **profiles**, **Kanban**, and **skills**, using the official gateway API.
- **Workspace \& Kanban features (docs + blog)**
    - Workspace V2 articles: profile switcher, multi‑agent orchestration, Kanban board integration.[^16][^3]
    - Kanban docs: durable multi‑agent task board; canonical pattern for your “agentic OS” loop.[^17][^16]

Why it matters for you:

- These are effectively **maintainer‑endorsed shells** for the Hermes gateway; they give you dashboard, multi‑profile UX, and Kanban without fighting your WSL‑first architecture.[^15][^18][^3]

***

## Community Power‑User Repos (High Signal)

### Control and admin dashboards

1. **`hermes-control-interface` (Hermes Atlas)** – control panel / admin UI
    - Browser‑based terminal, file explorer, session overview, cron management, and metrics for Hermes gateways.[^19]
    - Shows how to surface WSL Hermes state into a web UI—good reference if you later want a MyKu‑style control center.
2. **`hermes-dashboard`**
    - Web dashboard for Hermes gateway: config, MCP, cron, and model management without CLI.[^20]

These repos show **real customization patterns**: multiple gateways, cron jobs, and MCP integration, not toy demos.

### Skills \& skill ecosystems

1. **Skills Hub / skill marketplace**
    - Hermes “Skill Marketplace” and Skills Hub docs describe bundled skills and community skill hubs, plus one‑command installation.[^21][^22][^23][^24]
    - Master thread on Reddit tracks best community skills and custom skill patterns.[^25]

Why they matter:

- They are your **primary extension surface** for agentic loops—repo mapping, environment checks, code review flows, vault syncing—without reinventing everything.[^22][^24][^21]


### Memory \& context DB

1. **OpenViking Hermes integration**
    - Docs page “Hermes Agent – OpenViking” shows configuration and usage as an external memory provider.[^26][^27][^13]
    - Ideal reference when you move from built‑in + Obsidian to a proper semantic memory backend in WSL.

These are **maintainer‑recognized integrations**, not random RAG projects.

***

## YouTube / Creator Routes (High Signal vs Hype)

### High‑signal, Hermes‑specific creators

1. **Nemanja (Hermes “better than 99% of people” guide)**
    - Video: “How to use Hermes Agent better than 99% of people” – deep, practical cover of:
        - VPS vs local setup.
        - Memory architecture.
        - Skills and profile strategy.
        - Kanban + cron workflows.[^2]
Why it’s good for you:
    - Very close to your stack: self‑hosted Hermes, local‑first mindset, skill‑driven dev workflows.
2. **Workspace / Mission Control / Agentic OS series**
    - Videos like “Hermes Agent OS is INSANE”, “Hermes Agent Workspace V2”, “Mission Control” episodes:
        - Show multi‑profile dashboards, Kanban, Obsidian memory layers, and VPS/WSL remote gateways.[^28][^29][^30][^31][^32]
Why they matter:
    - They illustrate exactly the patterns you’re designing: a Mission Control view over many workflows and agents, not just a chat UI.
3. **Webhooks + automation deep dives (Tonbi Studio, etc.)**
    - “Hermes Agent + Webhooks: How to Actually Build Automated Workflows” shows inbound/outbound webhooks, GitHub PR reviews, cron‑driven app enrichment.[^33]
    - Perfect patterns for turning Hermes into a back‑of‑house automation engine behind your MyKu / AI Docs stack.

### Where to start watching

For your purposes:

1. **Nemanja’s Hermes guide** – for overall architecture and profile/skill discipline.[^2]
2. **Workspace / Mission Control / Kanban videos** – for dashboard design and agentic OS patterns.[^29][^30][^31][^32][^28]
3. **Webhook automation video** – once you’re ready to plug Hermes into GitHub, webhooks, or external services (PR review, digest jobs).[^33]

***

## What to Ignore or Deprioritize

- Generic “AI agent” videos that barely mention Hermes, WSL, or local providers—these rarely address the realities of profiles, memory providers, and self‑hosted constraints.[^4][^1]
- Any repo that ships a **completely separate agent framework** and treats Hermes as a footnote; for your stack, Hermes is the OS, not a plugin.
- Tutorials that recommend **per‑repo installs, shared `.env` across unrelated contexts, or scattering Hermes state into project folders**—these conflict with official docs and your isolation requirements.[^34][^4][^6][^13]

***

## How This Maps to Your High‑Level Priorities

- **Best supported Desktop/WSL architecture:**
    - Confirmed by core Hermes docs + multi‑gateway patterns: WSL Hermes backend, Windows Desktop as a remote thin client, profiles and gateways managed in WSL.[^8][^35][^7]
- **Future projects \& project switching:**
    - Profile docs + Nemanja/Workspace content show “small number of profiles + tags/boards” as the scalable pattern, not per‑repo installs.[^3][^6][^11][^2]
- **Hermes‑native agentic loop:**
    - Skills Hub, Kanban, and cron features, plus dev‑workflow articles, are your primitives for “inspect → plan → implement → validate → learn → skill.”[^24][^36][^16][^21][^22][^3]
- **Memory layering:**
    - Memory provider docs + OpenViking integration + Obsidian patterns from Agent‑OS videos give the blueprint we already sketched for built‑in + vault + one external provider.[^14][^37][^4][^13][^26][^3]
- **Client safety \& GitHub commits:**
    - Profile docs, provider configuration, and best‑practice videos (Nemanja, automation/webhook series) show how to isolate profiles, scope providers, and keep Git ops under your control.[^4][^6][^2][^33]
- **Highest‑signal customization routes:**
    - Official Hermes docs/repos + `hermes-webui`/Workspace + control dashboards + Skills Hub + OpenViking integration + a handful of deep, Hermes‑centric YouTube series—that’s the small, high‑leverage set that actually maps to your WSL + Desktop + local‑first stack.[^5][^15][^19][^20][^21][^22][^24][^2][^3][^33]

If you’d like, I can now crystallize this into a short “reading + watching list” markdown file you can drop straight into your MyKu/Hermes docs and track as part of your agentic OS buildout.

<div align="center">⁂</div>

[^1]: 05-github-youtube-customization-routes.md

[^2]: https://www.youtube.com/watch?v=NvakBZyc1Sg

[^3]: https://aisuccesslabjuliangoldie.com/blog/hermes-agent-workspace/

[^4]: https://dreamsaicanbuy.com/blog/hermes-agent-tips

[^5]: https://github.com/nousresearch/hermes-agent

[^6]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/profiles.md

[^7]: https://hermes-agent.nousresearch.com/docs/user-guide/multi-profile-gateways

[^8]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/getting-started/installation.md

[^9]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/integrations/providers.md

[^10]: https://hermes-agent.nousresearch.com/docs/reference/profile-commands/

[^11]: https://hermes.ai.vn/docs/user-guide/profiles/

[^12]: https://hermesagent.org.cn/docs/user-guide/profiles

[^13]: https://www.glukhov.org/ai-systems/memory/agent-memory-providers/

[^14]: https://hermes.ai.vn/docs/user-guide/features/memory-providers/

[^15]: https://github.com/nesquena/hermes-webui

[^16]: https://hermes-agent.nousresearch.com/docs/user-guide/features/kanban

[^17]: https://www.reddit.com/r/hermesagent/comments/1t2sqjj/hermes_agent_just_added_real_multiagent/

[^18]: hermes_perplexity_research.md

[^19]: https://hermesatlas.com/projects/xaspx/hermes-control-interface

[^20]: https://github.com/chrisryugj/hermes-dashboard

[^21]: https://aiskill.market/blog/hermes-skills-hub-publishing-community-skills

[^22]: https://hermes-ai.net/skills/

[^23]: https://hermes-agent.ai/features/skill-marketplace

[^24]: https://www.youtube.com/watch?v=T_AVEOuul0M

[^25]: https://www.reddit.com/r/hermesagent/comments/1snwkog/master_thread_skills_hub_custom_skill_development/

[^26]: https://docs.openviking.ai/en/agent-integrations/05-hermes

[^27]: https://docs.openviking.ai/zh/agent-integrations/05-hermes

[^28]: https://www.youtube.com/watch?v=P3BJl_V_UZ8

[^29]: https://aisuccesslabjuliangoldie.com/blog/hermes-agent-mission-control/

[^30]: https://www.youtube.com/watch?v=zIcXS-bZ_m0

[^31]: https://aimoneylabjuliangoldie.com/blog/hermes-workspace/

[^32]: https://www.youtube.com/watch?v=t6W_Zpohb7g

[^33]: https://www.youtube.com/watch?v=WNYe5mD4fY8

[^34]: https://github.com/NousResearch/hermes-agent/issues/31144

[^35]: https://hermesatlas.com/guide/install/

[^36]: https://chenguangliang.com/en/posts/blog122_hermes-agent-dev-workflow/

[^37]: https://www.youtube.com/watch?v=6QLzDqB5YKU

