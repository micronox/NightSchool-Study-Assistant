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

Now I want you to take that lens and apply it to the 02-project-workflow-profiles-and-agentic-loop.md ive attached

You can treat Packet 02 as “how do I turn Hermes into a sane, multi‑project dev OS” and the ecosystem is surprisingly consistent: one WSL backend, a small number of well‑scoped profiles, project segregation via files/boards/tags rather than separate installs, and an agentic loop built from skills + Kanban + crons, not from per‑project Hermes homes.[^1][^2][^3][^4][^5]

Below is that lens applied directly to profiles, project layout, and the agentic loop you described.

***

## 1. Profiles: What’s Official, Recommended, and Hacky

### Official Hermes‑supported profile model

Docs are very explicit: a **profile is a separate Hermes home directory** with its own `config.yaml`, `.env`, `SOUL.md`, memory, sessions, skills, cron jobs, and state.[^2][^6][^7][^5][^8]

- Creating a profile (official pattern):

```bash
hermes profile create coder        # creates ~/.hermes/profiles/coder
coder setup                        # configure API keys/model for this profile
coder chat                         # chat with coder profile
```

Each profile becomes its own command namespace (e.g., `coder gateway start`).[^6][^5][^2]
- Directory layout per profile (official):

```text
~/.hermes/profiles/<name>/
  .env          # keys, tokens (chmod 600)
  config.yaml   # models, provider, toolsets, gateway
  SOUL.md       # persona / system prompt
  skills/
  memory/
  jobs/         # cron/scheduled tasks
  sessions/
```


[^7][^5][^2][^6]

Profiles are meant to isolate **roles** or **major agents**, not to mirror every repo 1:1.[^4][^5][^2]

### Maintainer‑endorsed practices

From docs and multi‑gateway examples, maintainers push patterns like:[^5][^8][^2][^6]

- “One profile per major **agent role** or channel”: `coder`, `personal-bot`, `research`, `inbox-bot`.
- Running multiple gateways, one per profile, when you truly need multiple always‑on agents:

```bash
hermes profile create coder
hermes profile create personal-bot
coder gateway install && coder gateway start
personal-bot gateway install && personal-bot gateway start
```


[^5]

Nemanja’s “how to use Hermes better than 99% of people” video reinforces that you do **not** need five Hermes installs for five clients; instead, use profile boundaries + file structure to keep things clean.[^4]

### Community patterns

Two recurring community strategies:[^3][^9][^10][^4]

- **“One agent per major project”** (blog from a dev who embeds Hermes into real workflows):
    - Create one profile or at least one dedicated persona (`SOUL.md`) per large project.
    - Drop a short project‑specific `SOUL.md` into that profile describing stack and directory layout, e.g., Astro/Tailwind project with path hints.[^3]
- **“One agent per function”** (Workspace / Mission Control): orchestrator + specialized sub‑agents (research, dev, ops), each a profile, orchestrated via Kanban and crons.[^9][^4]

Both can be combined in your OS: e.g., `myku-dev`, `ai-docs-dev`, `client-dev`, plus a `research` and `infra-ops` profile.

### Hacks / unsupported profile usage

The ecosystem implicitly warns against:[^10][^11][^4]

- **One profile per tiny task or per branch** – this explodes state and defeats the “learning loop”; advanced users recommend “one agent, one job” but not “one agent per ticket”.[^10][^4]
- **Per‑repo profiles with near‑identical configs** – better handled via `SOUL.md` + project manifests and tags in a smaller set of profiles.[^3][^4]

Your Packet 02 menu (“one profile per project vs per client vs hybrid”) fits best with:

- Official: “profiles are separate homes”[^2][^6]
- Recommended: **hybrid** – a small number of role/sector profiles that serve many repos/clients, rather than a profile for every repo.[^4][^10]

***

## 2. Project \& Repo Workflow Strategy

### Official \& maintainer‑aligned layout

Hermes doesn’t dictate repo layout, but all examples assume **project trees live outside `~/.hermes`**, and Hermes accesses them via file tools.[^2][^5][^3]

On your WSL backend, a maintainable layout is:

```text
`$WSL_USER_HOME/
  .hermes/                 # all profiles and agent state
    profiles/
      coder/
      research/
      myku-dev/
  projects/
    personal/
      dotfiles/
      experiments/
    products/
      myku/
      ai-docs/
    clients/
      acme-inc/
        api-service/
        landing-page/
```

- Hermes profiles live entirely under `~/.hermes/profiles/...`.[^6][^5][^2]
- Repos are normal Git trees under `~/projects/...`.
- Profiles “know” which repos they primarily work on via `SOUL.md` and habits, not via being physically inside the repo.[^3]


### Community best practice for many projects

Real‑world workflow write‑ups show patterns like:[^9][^4][^3]

- **One agent per major project or function**:
    - A dev uses a dedicated agent for each big project, dropping a concise `SOUL.md` describing the tech stack and directories (e.g., `src/data/blog`, `src/components`) so the agent plans correctly.[^3]
- **New sessions per task**:
    - Start a clean Hermes session when switching from “feature work” to “review” to avoid context drift; don’t reuse the same long conversation for unrelated tasks.[^3]

Applied to your Packet 02 goals:

- For **personal**: one `personal-dev` profile, multiple repos.
- For **products** (MyKu, AI Docs): either a module per product in a `product-dev` profile or separate `myku-dev` and `ai-docs-dev` profiles if they’re large and long‑lived.
- For **clients**: a `client-dev` profile, with per‑client isolation done via filesystem trees + vault folders + tags, not extra installs.[^10][^4]

***

## 3. Concrete Profile Taxonomy for Your Agentic OS

Given your WSL‑authoritative backend and many‑future‑projects assumption, a **Hermes‑native, maintainable** profile taxonomy looks like:

- `infra-ops` – environment bootstrap, Docker/WSL checks, backup scripts, monitoring.[^12][^9]
- `research` – pure research, documentation synthesis, MyKu film‑language R\&D.[^4][^3]
- `myku-dev` – MyKu code, shaders, 3D scenes, manifest management.
- `ai-docs-dev` – AI Docs pipeline, website prompts, doc generation.
- `client-dev` – Upwork/client repos; configured with stricter providers (local only where needed).[^10][^4]

Each is a profile:

```bash
hermes profile create infra-ops
hermes profile create research
hermes profile create myku-dev
hermes profile create ai-docs-dev
hermes profile create client-dev
```

Then configure each:

```bash
infra-ops setup        # provider & skills for ops
research setup
myku-dev setup
ai-docs-dev setup
client-dev setup
```

And tune per‑profile `SOUL.md` so each knows its job, stack, and primary directories.[^7][^2][^3]

***

## 4. Starter Agentic Loop for Local Engineering

### Official \& maintainer‑aligned building blocks

- **Profiles** for separation.[^6][^5][^2]
- **Skills** as reusable workflows; Hermes ships with 100+ bundled skills in `~/.hermes/skills/<skill-name>/SKILL.md`.[^13][^14]
- **Skills Hub / Skill Marketplace** as the official source of community skills and one‑command install.[^15][^16][^13]
- **Cron/jobs** in the gateway for scheduled tasks.[^17][^9]


### Community “real engineering loop”

A dev workflow write‑up (not marketing) describes an actual loop:[^3]

1. Ask Hermes to **inspect the repo** and build a file map.
2. Ask for an **implementation plan** with file list and steps.
3. Implement in editor, then send changes back for **review**.
4. Run tests/build, and have Hermes summarize failures.
5. Capture **learnings** into notes or wiki.

Nemanja’s guide parallels this: plan mode + Kanban + scheduled daily reports.[^9][^4]

### Concrete Hermes‑native loop in your WSL setup

For `myku-dev` profile, a repeatable loop could be:

1. **Inspect environment \& repo**

```bash
myku-dev chat
# Prompt: "Scan `$WSL_USER_HOME/projects/products/myku. 
# Build a markdown map of key directories and entrypoints. 
# Store it as `$WSL_USER_HOME/projects/products/myku/docs/REPO_MAP.md."
```

Use bundled file tools and possibly a repo‑mapping skill from the Skills Hub.[^14][^11][^13][^15]
2. **Plan**

```bash
# Prompt in same session: 
"Given REPO_MAP.md and this feature spec, write an implementation plan:
- file changes list
- steps
- risks.
Save to docs/PLAN-<timestamp>.md."
```


[^3]

3. **Implement**
    - You work in VSCode (WSL), following the plan.
    - Optionally use a dev‑oriented skill (e.g., from Matt Pocock’s skills repo) for code suggestions.[^13][^15][^4]
4. **Validate**

```bash
# Back in myku-dev chat:
"Here is the git diff: ... 
Review only for correctness + shader performance, ignore style. 
Suggest test cases."
```

This matches the “explicit constraints for code review” guidance.[^3]
5. **Capture learnings \& evolve skills**
    - Ask Hermes: “Summarize what we learned from this change. Append to docs/LEARNINGS.md.”[^3]
    - If a pattern repeats, turn it into a skill: create `~/.hermes/profiles/myku-dev/skills/myku_scene_scaffold/SKILL.md` describing inputs/steps, then call it when needed.[^11][^14][^13]
6. **Automate**
    - Add a cron job in `myku-dev` profile to generate a daily status note or run a repo‑health check.
    - This matches the Cron + daily report patterns in workspace and webhook walkthroughs.[^12][^17][^9][^4]

This loop is fully Hermes‑native (profiles, skills, jobs) and lives in WSL; Desktop is just a UX surface to drive it.

***

## 5. First Skills to Build/Install (Local Agentic OS)

### Official/bundled skill foundation

The Skills Hub article: ~100+ bundled skills in categories like **software-development, devops, mlops, research, automation, information-processing**, all installed under `~/.hermes/skills/<skill-name>/`.[^14][^13]

You can treat these as primitives and add just a few custom ones tailored to your stack.

### Recommended starter set for your use case

1. **Repo mapper** – builds `REPO_MAP.md` per project (use an existing mapping/analyzer skill or build your own).[^15][^13][^3]
2. **Implementation planner** – given spec + repo map, outputs a plan with file list and steps.[^4][^3]
3. **Code reviewer** – constrained review (correctness/perf only), tuned for MyKu tech stack.[^3]
4. **Env auditor** – checks WSL, Docker, GPU, Hermes gateway health, and logs results.[^9][^10]
5. **Daily report** – cron‑driven skill that summarizes commits, open tasks, Kanban board, and recent Hermes sessions.[^12][^9][^4]
6. **Vault sync** – writes key summaries into Obsidian/Open‑Brain vault and pulls back notes for context.[^18][^15][^10]
7. **Client safety checker** – ensures providers and skills are scoped correctly (local vs cloud) for client repos.[^10][^4]

All of these can be expressed as SKILL.md workflows and live in `~/.hermes/skills/` or per‑profile `skills/` folders.[^11][^13][^14]

***

## 6. Local vs Global: What Belongs in Profiles vs Shared

Using your Packet 02 questions (“what parts profile‑local vs globally shared”):

**Profile‑local (per role/agent):**[^7][^5][^2][^6]

- `config.yaml` – models, providers, toolsets per role (e.g., `client-dev` using local only).
- `.env` – keys/tokens for that role.
- `SOUL.md` – role + project focus.
- Role‑specific skills (e.g., `myku_scene_scaffold` under `myku-dev`).

**Global/shared (Hermes home or shared folders):**[^13][^15][^14][^10]

- Generic skills that are safe across projects (repo mapping, markdown wiki builder, generic web research).
- Memory providers (OpenViking / Honcho) configured at the main Hermes level, but with per‑profile scoping in prompts.[^19][^20][^9]
- Obsidian vaults and notes (outside `.hermes`, shared via file tools).[^18][^10]

This keeps sensitive or strongly‑typed behavior local to a profile while sharing genuinely reusable primitives.

***

## 7. Safety Model for Client Work and GitHub

From Nemanja’s and other best‑practice pieces:[^12][^4][^10]

- **Don’t** spin up separate Hermes installs per client; **do** isolate via:
    - Filesystem (`~/clients/<client>/...`).
    - Profile (`client-dev` with its own `.env`, config, SOUL).[^5][^4]
    - Provider choices (local models only, cloud disabled or strictly limited).[^21][^22][^10]
- **Serialize file‑writing tasks** – concurrency controls are still maturing; avoid parallel file‑modifying tasks in the same repo.[^3]
- **Keep Git operations under your manual control** – Hermes can propose diffs, commit messages, and PR descriptions; you run `git commit/push` yourself.[^12][^3]

That gives you a robust safety envelope while still letting Hermes automate significant parts of the workflow.

***

## 8. Highest‑Signal Customization Routes for Your OS

The strongest routes that line up with Packet 02’s goals and your WSL architecture:

- **Profiles + Workspace** – small, meaningful profile set (`infra-ops`, `research`, `myku-dev`, `ai-docs-dev`, `client-dev`) running on one WSL backend.[^1][^2][^6][^5][^9]
- **Skills Hub + agentskills.io** – treat skills as the main extension point; use the official hub/marketplace and a small number of hand‑rolled SKILL.md workflows.[^16][^15][^14][^11][^13]
- **Kanban + crons** – use Hermes’ Kanban and scheduled jobs as the backbone of your agentic loop (plan, implement, validate, daily reports), coordinated by an orchestrator profile.[^23][^24][^9][^4][^12]
- **Obsidian + OpenViking/Honcho** – hybrid memory: human‑curated vault + external memory provider backing Hermes’ long‑term recall.[^20][^25][^19][^18][^9][^10]

These are all Hermes‑native or maintainer‑endorsed, widely used by advanced users, and avoid hacky patterns like per‑repo profiles or embedding Hermes state into project trees.

<div align="center">⁂</div>

[^1]: 02-project-workflow-profiles-and-agentic-loop.md

[^2]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/profiles.md

[^3]: https://chenguangliang.com/en/posts/blog122_hermes-agent-dev-workflow/

[^4]: https://www.youtube.com/watch?v=NvakBZyc1Sg

[^5]: https://hermes-agent.nousresearch.com/docs/user-guide/multi-profile-gateways

[^6]: https://hermes.ai.vn/docs/user-guide/profiles/

[^7]: https://hermesagent.org.cn/docs/user-guide/profiles

[^8]: https://hermes-agent.nousresearch.com/docs/reference/profile-commands/

[^9]: https://aisuccesslabjuliangoldie.com/blog/hermes-agent-workspace/

[^10]: https://dreamsaicanbuy.com/blog/hermes-agent-tips

[^11]: https://www.reddit.com/r/hermesagent/comments/1snwkog/master_thread_skills_hub_custom_skill_development/

[^12]: https://www.youtube.com/watch?v=WNYe5mD4fY8

[^13]: https://aiskill.market/blog/hermes-skills-hub-publishing-community-skills

[^14]: https://www.youtube.com/watch?v=T_AVEOuul0M

[^15]: https://hermes-ai.net/skills/

[^16]: https://hermes-agent.ai/features/skill-marketplace

[^17]: https://www.youtube.com/watch?v=3k3ve358jBo

[^18]: https://www.youtube.com/watch?v=6QLzDqB5YKU

[^19]: https://www.glukhov.org/ai-systems/memory/agent-memory-providers/

[^20]: https://hermes.ai.vn/docs/user-guide/features/memory-providers/

[^21]: https://hermes-agent.org

[^22]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/integrations/providers.md

[^23]: https://hermes-agent.nousresearch.com/docs/user-guide/features/kanban

[^24]: https://www.reddit.com/r/hermesagent/comments/1t2sqjj/hermes_agent_just_added_real_multiagent/

[^25]: https://docs.openviking.ai/en/agent-integrations/05-hermes


