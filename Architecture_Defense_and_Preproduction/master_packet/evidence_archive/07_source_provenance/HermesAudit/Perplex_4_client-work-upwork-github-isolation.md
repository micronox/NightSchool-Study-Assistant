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

Now I want you to take that lens and apply it to the 04-client-work-upwork-github-isolation.md which is attached

You can treat Packet 04 as: “How do I make Hermes a power tool for client work without ever leaking a client’s context, secrets, or repo into anything else?” The ecosystem is fairly consistent: one WSL backend, a small set of well‑scoped profiles, strong filesystem and Git discipline, and memory split between global preferences and per‑client facts.[^1][^2][^3][^4]

Below is that lens applied directly to client work, Upwork, and GitHub isolation.

***

## 1. High‑Level Operating Model for Multi‑Client Work

**Official Hermes‑supported pattern**

- Hermes supports **profiles** as fully separate homes (config, `.env`, memory, skills, sessions) under `~/.hermes/profiles/<name>` on Unix.[^2][^5][^6]
- Multi‑gateway docs show multiple profiles (e.g., `coder`, `personal-bot`) running on one machine, each with its own gateway and tokens.[^5][^6]

**Maintainer‑endorsed practice**

- Guides and talks emphasize **one runtime per machine** (WSL in your case), with multiple profiles and gateways for roles or channels, not per‑repo installs.[^3][^6][^2][^5]
- Hermes is intended to be **self‑hosted and local‑first**, with clear provider config per profile (e.g., local models only for sensitive work).[^4][^7][^8]

**Community patterns**

- Advanced users working across many projects run **one `client-dev` or `work-dev` profile** and use folder structure + vaults + tags to separate clients, rather than a separate Hermes install per client.[^9][^3][^4]
- Some very high‑sensitivity setups use a **dedicated profile per particularly sensitive client**, but still under one `~/.hermes` tree.[^3][^4]

**Hacks / unsupported workarounds**

- Per‑repo Hermes installs and per‑repo homes (`HERMES_HOME` inside a repo) are considered brittle and are not documented; they complicate upgrades and risk state leakage when repos are zipped or shared.[^10][^11][^4]

**Applied to your stack:** best model is **one WSL Hermes backend**, multiple profiles (`infra-ops`, `research`, `myku-dev`, `ai-docs-dev`, `client-dev`), plus *optionally* extra profiles for top‑tier clients, with Windows Desktop as a thin remote UI only.[^6][^12][^13][^14][^15][^2]

***

## 2. Profile Strategy for Clients

### Official semantics of profiles

A profile has its own home and is invoked by name, e.g.:[^16][^2][^5]

```bash
hermes profile create client-dev      # creates ~/.hermes/profiles/client-dev
client-dev setup                      # configure provider/model
client-dev chat                       # client-safe agent REPL
```

Inside:

```text
~/.hermes/profiles/client-dev/
  .env
  config.yaml
  SOUL.md
  MEMORY.md
  skills/
  sessions/
```


### Recommended profile strategy (Packet 04)

**Official + maintainer‑aligned:**

- **One profile per domain of work**, not per repo:
    - `client-dev` – all freelance/Upwork/client repos.
    - Optionally `client-<big-customer>` for a very large or regulated client.[^2][^5][^6][^3]

**Community practice vs hacks:**

- **One profile per client** is acceptable if you have a handful of long‑term clients; more than 5–10 becomes unwieldy.[^4][^3]
- **One profile per repo** is a hack: too much overhead, makes skills/memory hard to reuse, and is not how profiles are documented.[^2][^4]

For your scenario (“5 Upwork clients and 3 personal repos in the same week”):

- Use `client-dev` for all client repos; personal/product work uses `myku-dev`, `ai-docs-dev`, and `personal-dev`.
- If a client becomes long‑term or sensitive enough, promote them to `client-acme` with its own profile and `.env`.

***

## 3. What Must Be Isolated per Client vs What Can Be Shared

### Must‑isolate items

From docs and advanced‑user guidance:[^5][^6][^3][^4][^2]

- `.env` / provider keys
    - Each profile has its own `.env`; for `client-dev`, configure **local providers only** for sensitive code, and avoid global OpenAI/OpenRouter keys unless contracts allow.[^7][^8][^4]
- Memory of client business context
    - Client‑specific facts should live in either:
        - Profile‑local memory (e.g. `client-dev/MEMORY.md` trimmed to non‑identifying summaries).
        - Client folders in your Obsidian vault.[^11][^17][^18][^19][^4]
- Notes / docs
    - Keep a `Clients/<Name>/` subtree in your Obsidian/Open‑Brain vault; optionally add minimal profile‑local notes for fast recall.[^17][^19][^4]
- Allowed tools
    - Configure `client-dev` profile’s skills and toolsets so only vetted tools (local file operations, local LLMs, safe HTTP targets) are enabled.[^20][^4][^2]


### Safely sharable across clients

- **Global coding preferences** (style, testing bias, “always add logging”) – these can live in built‑in memory or global `SOUL.md` fragments, as they don’t reveal client secrets.[^18][^11][^4]
- **Generic skills** – repo mapping, test writing helpers, doc generators that don’t embed client names into their metadata.[^21][^22][^23][^20]
- **Core workflows** – “plan → implement → review → summarize” loops are reusable; only the data they operate on needs to be isolated.[^9][^3]

***

## 4. Filesystem Layout for Repos \& Notes

### WSL repo layout (Hermes backend)

A Hermes‑aligned, multi‑client layout:[^1][^3][^4][^9]

```text
/home/larry/
  .hermes/
    profiles/
      client-dev/
      myku-dev/
      ai-docs-dev/
  projects/
    personal/
      myku/
      ai-docs/
      sandbox-rnd/
    clients/
      acme-inc/
        acme-api/
        acme-dashboard/
      globex/
        globex-landing/
      upwork-short-gigs/
        u1234-figma-exporter/
        u5678-data-cleaner/
```

- `client-dev` profile works only in `~/projects/clients/**`.
- Other profiles stay out of `clients/` by habit and by `SOUL.md` prompts.


### Obsidian/Open‑Brain vault layout

Integrate with your existing vault plan:[^19][^24][^17][^4]

```text
Vault/
  Personal/
  Products/
    MyKu/
    AI-Docs/
  Clients/
    Acme-Inc/
      Briefs/
      Architecture/
      Engagements/
    Globex/
      Briefs/
      Deliverables/
    Upwork-Short-Gigs/
      U1234/
      U5678/
  Library/
    Reusable-Procedures/
    Film-Language/
```

- Hermes skills in `client-dev` can read/write under `Clients/<Name>/` only.
- Personal/MyKu profiles keep their notes in `Products/` and `Personal/`.

***

## 5. Memory Segregation to Avoid Cross‑Client Bleed

From the memory research (Packet 03 + docs):[^24][^11][^17][^18][^4]

- **Built‑in memory**
    - Use it for *global* coding preferences and OS‑level rules, not per‑client secrets.
- **Obsidian vault**
    - Store client‑specific knowledge here; treat it as human‑first, agent‑assisted memory.
- **External providers (Honcho / OpenViking)**
    - If you use them, either:
        - Use a **client‑dev‑only namespace** (e.g., `viking_namespace=clients`) so other profiles don’t see it.
        - Or use separate providers per profile in advanced setups.

For the scenario: “Hermes should remember global coding preferences but not leak client business context”:[^1]

- Put preferences in `MEMORY.md` or `SOUL.md`.
- Put business details and domain knowledge in `Vault/Clients/<Name>/...` and, if needed, a provider namespace used only by `client-dev`.

***

## 6. Hermes‑Native Features That Help with Isolation

**Profiles \& multi‑gateway** – each profile has its own config, `.env`, skills, and gateway port.[^6][^5][^2]

- You can run:

```bash
client-dev gateway install && client-dev gateway start --port 9010
myku-dev gateway start --port 9011
```

Then point different Hermes Desktop workspaces at different ports if needed.

**Skills scoping \& Skill Hub** – skills are installed under `~/.hermes/skills` or per‑profile; you can choose to only enable certain skills for `client-dev`.[^22][^23][^20][^21]

**Kanban / workspace separation** – Hermes Kanban and Workspace let you maintain separate boards and workspaces per project/client, so tasks and runs stay visually separated, even if one profile serves multiple clients.[^25][^26][^24]

***

## 7. Scenarios from Packet 04

### 1) 5 Upwork clients + 3 personal repos in one week

- Profiles:
    - `client-dev` for all 5 clients.
    - `myku-dev`, `ai-docs-dev`, `personal-dev` for your own work.
- Layout \& notes:
    - Repos under `~/projects/clients/<client>/...` and `~/projects/personal/...`.
    - Vault under `Vault/Clients/<Name>/...` and `Vault/Products/...`.

This minimizes mistakes while keeping friction low.[^3][^4][^1]

### 2) Switch from company repo (work Git identity) to OSS repo

Hermes side:

- Switch profiles if needed (`client-dev` → `personal-dev`).
- Ensure the active profile’s `.env` and `SOUL.md` reflect the context.

Git side (outside Hermes):

- Use per‑repo Git config for `user.name`/`user.email`.
- Use SSH `Host` entries for different keys if needed.

Hermes doesn’t manage Git identity, but keeping Hermes profiles aligned with your current repo category helps avoid mis‑prompts.

### 3) Global coding preferences vs non‑leaking business context

- Global preferences → built‑in memory \& `SOUL.md`.
- Client business context → Obsidian `Clients/` + optional profile‑local memory/provider namespaces.


### 4) Reusable skills vs non‑reusable client data

- Global skills (repo mapper, test helper, doc writer) → shared skills dir, used by all profiles.[^20][^21][^22]
- Client data → notes and memory namespaces that only `client-dev` can see.

***

## 8. Pre‑Work / Pre‑Commit Safety Checklist

Before starting client work:

- Select the correct **profile** (`client-dev` or specific client profile).
- Verify the **working directory** is under `~/projects/clients/<client>/...`.
- Check provider config (`client-dev config show`) to ensure only approved providers/models are enabled.[^4][^2]
- Confirm Hermes is not connected to external webhooks or outbound tools you don’t intend to use for this client.[^27]

Before commit/PR:

- Run tests/build locally.
- Use Hermes to **review the diff** only for correctness/security, not to add new external calls unless requested.[^27][^9]
- Double‑check Git identity in that repo (`git config user.email`) and remote URL.
- For sensitive clients, redact or avoid including internal identifiers in commit messages or PR descriptions that Hermes helps draft.

***

## 9. Onboarding Checklist for a New Client

1. **Filesystem \& Git**
    - Create `~/projects/clients/<ClientName>/...` and clone repos.
    - Configure per‑repo Git `user.name`/`user.email` and remotes.
2. **Vault**
    - Create `Vault/Clients/<ClientName>/Briefs`, `Architecture`, `Engagements`.
3. **Hermes profile config**
    - Ensure `client-dev` profile exists; if client is large, optionally create `client-<ClientName>`.
    - In `SOUL.md`, add a short description of the client domain and path patterns (without sensitive details).
4. **Provider \& tools**
    - Set providers to local‑first for this profile, minimize external calls.
    - Enable only safe skills (no arbitrary external webhooks unless needed).[^20][^27][^4]
5. **Initial context ingest**
    - Use Hermes to read the repo and client briefs, then generate a `REPO_MAP.md` and `CLIENT_OVERVIEW.md` into the vault.[^9][^3]

***

## 10. Anti‑Patterns to Avoid

- **Per‑repo profiles / installs** – too much fragmentation, not in docs, hard to upgrade and reason about.[^2][^4]
- **Mixing client code and Hermes home** – never put `HERMES_HOME` inside `~/projects/clients/...`.[^10][^11]
- **Letting one profile see all providers and memory** – don’t use a single “God profile” that mixes clients, products, and personal context.
- **Treating Obsidian as a dump** – uncontrolled auto‑writing will create memory pollution; keep Hermes writes confined to specific summary/log notes you can review.[^4]
- **Using the same external memory namespace for all clients** – if you enable a provider, use per‑profile or per‑client namespaces where contracts require isolation.[^11][^18]

If you follow this model—single WSL Hermes backend, carefully scoped profiles, clean repo/vault layout, and a conservative memory policy—you get a strong safety envelope for Upwork and client GitHub work, while still letting Hermes act as a serious local agentic OS for your full stack.

<div align="center">⁂</div>

[^1]: 04-client-work-upwork-github-isolation.md

[^2]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/profiles.md

[^3]: https://www.youtube.com/watch?v=NvakBZyc1Sg

[^4]: https://dreamsaicanbuy.com/blog/hermes-agent-tips

[^5]: https://hermes.ai.vn/docs/user-guide/profiles/

[^6]: https://hermes-agent.nousresearch.com/docs/user-guide/multi-profile-gateways

[^7]: https://hermes-agent.org

[^8]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/integrations/providers.md

[^9]: https://chenguangliang.com/en/posts/blog122_hermes-agent-dev-workflow/

[^10]: https://github.com/NousResearch/hermes-agent/issues/31144

[^11]: https://www.glukhov.org/ai-systems/memory/agent-memory-providers/

[^12]: hermes_perplexity_research.md

[^13]: 01-hermes-architecture-and-desktop-location.md

[^14]: https://agentwikis.com/wiki/hermes/wiki/summaries/release-v0.16.0.md

[^15]: https://hermesatlas.com/guide/install/

[^16]: https://hermes-agent.nousresearch.com/docs/reference/profile-commands/

[^17]: 03-memory-obsidian-honcho-openviking.md

[^18]: https://hermes.ai.vn/docs/user-guide/features/memory-providers/

[^19]: https://www.youtube.com/watch?v=6QLzDqB5YKU

[^20]: https://hermes-ai.net/skills/

[^21]: https://aiskill.market/blog/hermes-skills-hub-publishing-community-skills

[^22]: https://www.youtube.com/watch?v=T_AVEOuul0M

[^23]: https://www.reddit.com/r/hermesagent/comments/1snwkog/master_thread_skills_hub_custom_skill_development/

[^24]: https://aisuccesslabjuliangoldie.com/blog/hermes-agent-workspace/

[^25]: https://hermes-agent.nousresearch.com/docs/user-guide/features/kanban

[^26]: https://www.reddit.com/r/hermesagent/comments/1t2sqjj/hermes_agent_just_added_real_multiagent/

[^27]: https://www.youtube.com/watch?v=WNYe5mD4fY8

