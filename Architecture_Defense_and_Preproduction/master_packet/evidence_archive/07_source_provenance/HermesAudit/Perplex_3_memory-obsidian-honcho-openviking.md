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

Now I want you to take that lens and apply it to the 03-memory-obsidian-honcho-openviking.md

Short answer: treat Hermes’ built‑in memory as the **global spine** for identity and coarse project summaries, Obsidian/Open‑Brain as the **human‑first knowledge base**, and exactly **one external provider** (Honcho *or* OpenViking) as the **semantic long‑term database**—configured in WSL, scoped per profile, and never coupled to Windows Desktop state or individual repos.[^1][^2][^3][^4][^5]

Below is Packet 03 through that lens.

***

## 1. What Hermes Built‑In Memory Is Actually For

**Official Hermes‑supported pattern**

Docs describe built‑in memory as a small, file‑based layer (e.g., `MEMORY.md`, `USER.md` / `SOUL.md`) used for:[^2][^3][^6][^7]

- Identity and preferences (who you are, style, rough constraints).
- Stable profile/agent persona (what this profile is for, high‑level habits).
- High‑level session and project summaries, not full knowledge bases.

Strengths:

- Simple, local‑first, and versionable (plain text in `~/.hermes` per profile).[^3][^6][^2]
- Works without any external service—ideal baseline for your WSL‑only stack.[^8][^1]

Limits:

- No vector search or rich schema; not meant to store every code fact or long history.[^2][^3]
- Can get noisy if you dump raw notes or massive walls of text into it; advanced users keep it tight.[^5]

**Maintainer‑endorsed practice:** keep built‑in memory **small, curated, and identity‑centric**, and use external providers for large semantic recall.[^4][^3][^2]

***

## 2. Honcho \& OpenViking as External Providers

### Honcho

**Official/maintainer‑aligned**

- Hermes memory docs list Honcho as a first‑class external memory provider, marketed as a “richer, self‑hostable” long‑term memory path.[^3][^2]
- Intended use: persistent semantic store of facts and events across agents/profiles, with filtering and aggregation; positioned as robust/production for self‑hosted setups.[^4][^2]

Use cases:

- Long‑term autobiographical and project memory (what worked, what failed, decisions taken).
- Cross‑profile recall when multiple agents share the same Honcho backend (e.g., `research` + `myku-dev`).[^2][^3]


### OpenViking / Viking

**Official plugin**

- Hermes has an `openviking` memory provider plugin; OpenViking docs show a dedicated “Hermes Agent” integration with `memory.provider: openviking` and specific tools (`viking_remember`, `viking_recall`, etc.).[^9][^10][^2]

**Intended use**

- Open‑source context DB for agents: high‑volume embeddings + metadata; designed for multi‑agent context search, not just notes.[^10][^9]

**Maturity**

- Docs and integrations position OpenViking as **mature enough for real deployments** but still evolving quickly; it’s in the “supported / active development” category, not experimental toy status.[^9][^3][^2]
- For a power‑user WSL stack like yours, it’s reasonable if you accept a bit more infra overhead (service + data migrations later).

***

## 3. Obsidian/Open‑Brain: Community Patterns

**Community patterns around Hermes + Obsidian**

Mission‑Control and Agent‑OS walkthroughs show Obsidian used mainly as:[^11][^12][^13][^4]

- A **structured knowledge base** (project docs, SOPs, research).
- A **human‑readable long‑term memory layer** that agents read/write via tools, often treated like an “LLM wiki.”
- A **workbench** where humans clean up/curate what agents produce (summaries, architecture notes, client briefs).

Best‑practice folder/tag patterns when paired with Hermes:

- Top‑level by domain, then project, then type:[^13][^5][^4]

```text
Vault/
  Personal/
    Preferences/
    Journal/
  Products/
    MyKu/
      Architecture/
      Scenes/
      Pipelines/
    AI-Docs/
      Architecture/
      Prompts/
  Clients/
    <ClientName>/
      Briefs/
      Engagements/
      Deliverables/
  Library/
    Techniques/
    Film-Language/
    Reusable-Procedures/
```

- Tags for lifecycle and use:
    - `#decision`, `#risk`, `#architecture`, `#client`, `#procedure`, `#learning`.[^5][^13]

**Maintainer vs community**

- Hermes itself doesn’t “bless” Obsidian, but official tips and popular long‑form guides show Obsidian (or similar markdown vaults) as a recommended human/agent knowledge bridge.[^4][^5]

**Best role:** human‑curated but **agent‑assisted and agent‑updated** in specific files (summaries, status reports), with you as editor of record.[^13][^5][^4]

***

## 4. Recommended Layered Memory Architecture (Concrete Policy)

For your WSL‑authoritative stack and agentic OS goal, a clean layered design is:

### Layer 1 — Built‑in Hermes memory (per profile, in `~/.hermes`)

**What goes here:**[^1][^3][^2]

- Identity and preferences (tone, safety constraints, personal “OS rules”).
- Role and scope definitions per profile (`myku-dev`, `research`, `client-dev`).
- Very short, curated “operational summaries” of major projects (1–2 paragraphs each).

Example layout (per profile):

```text
~/.hermes/profiles/myku-dev/
  SOUL.md         # role, stack, directory hints
  MEMORY.md       # key preferences & cross-session facts
  USER.md         # optional user persona details
```


### Layer 2 — Obsidian/Open‑Brain vault (shared, human‑first)

**What goes here:**[^1][^5][^13][^4]

- Project history (chronology, milestones, retrospectives).
- Architecture notes and diagrams (MyKu scene grammar, film‑language ontology).
- Client notes and reusable procedures.
- Self‑improvement observations, patterns, and design decisions.

Integration patterns:

- Mount `L:\Vaults\...` into WSL and point Hermes file tools/skills at it.[^8][^1]
- Use Hermes skills to:
    - Append daily summaries (`*_DAILY.md`) per project.
    - Update `Architecture/` and `Procedures/` notes with new patterns.
- Keep humans in the loop: Hermes drafts; you refine/approve.


### Layer 3 — External memory provider (Honcho *or* OpenViking, not both initially)

**What goes where:**[^3][^2][^4]

- Semantic embeddings and retrieval of:
    - Project facts and events.
    - Extracted snippets from Obsidian \& sessions.
    - Cross‑project heuristics (e.g., your preferred shader patterns).

Policy:

- Pick **one** provider to start; configure it under WSL Hermes (`memory.provider: honcho` *or* `openviking`), not per repo or on Windows Desktop.[^8][^2][^3]
- Scope memory usage by profile via prompts (e.g., `client-dev` reads from only selected namespaces).


### Recommended stack for you (from comparison list in Packet 03)

- **Phase 1:** Hermes built‑in + Obsidian.
- **Phase 2:** Hermes built‑in + Obsidian + **one** external provider (OpenViking *or* Honcho).
- **Phase 3 (maybe):** Evaluate both providers in separate test profiles; only use both in production if you have a very specific reason and namespace discipline.

***

## 5. Start‑Simple → Grow‑Later Path

### Phase 1 – Built‑in + Obsidian only

- Configure per‑profile `SOUL.md` and tight `MEMORY.md`.[^6][^7]
- Stand up an Obsidian vault with the folder/tag scheme above.
- Build a few skills that:
    - Write session summaries into project `Log/` or `Journal/` notes.
    - Append “learnings” to `Library/Reusable-Procedures/`.[^14][^4]

This is low‑complexity, fully local‑first, and already very useful for your agentic OS.

### Phase 2 – Add **one** external memory provider

- If you want turnkey and “officially championed” by Hermes docs, enable **Honcho**.[^2][^3][^4]
- If you want deep, open‑source graph/context DB, enable **OpenViking** with its Hermes integration.[^10][^9][^2]

Use it for:

- Cross‑session recall of project facts.
- “What did we decide about X last month?” queries.
- Feeding richer context into Hermes before planning tasks.


### Phase 3 – Advanced tuning

- Add per‑profile memory scoping (e.g., separate Honcho/OpenViking namespaces for `myku`, `ai-docs`, `clients`).[^3][^2]
- Add scheduled “memory hygiene” jobs: agents that prune stale entries and write curated summaries back into Obsidian.[^5][^4]

***

## 6. Anti‑Patterns \& Safety Warnings

From docs and advanced‑user tips:[^15][^16][^5][^2][^3]

- **Anti‑pattern:** dumping entire repos, logs, and transcripts into built‑in memory.
    - Fix: store raw detail in Obsidian or external memory; keep built‑in memory small.
- **Anti‑pattern:** enabling multiple external providers simultaneously without clear separation.
    - Fix: start with one; if you later add another, use separate profiles/namespaces.
- **Anti‑pattern:** letting agents fully auto‑edit the vault.
    - Fix: restrict agent writes to specific note types (`*_SUMMARY.md`, `DAILY.md`), with you reviewing architecture and procedures.
- **Anti‑pattern:** using external providers for sensitive client code without scoping.
    - Fix: for `client-dev` profile, default to local models + local providers; if you use Honcho/OpenViking, isolate by project and follow client NDAs.

***

## 7. Honcho vs OpenViking: When to Enable What

**Honcho** – recommended when:[^4][^2][^3]

- You want a **supported, “default” external memory** that Hermes docs and community frequently reference.
- You prefer a simpler deployment and are okay with a more opaque backend.

**OpenViking** – recommended when:[^9][^10][^2]

- You want an **open, inspectable context DB**, especially if you may later plug in other agents or analytic tools.
- You’re comfortable running one more service in WSL and managing its storage.

**Concrete recommendation for you:**

- Start Phase 1 (built‑in + Obsidian) immediately.
- In Phase 2, **pilot OpenViking** in a dedicated `research` or `myku-dev` profile first (since your stack is already very OSS‑centric), while keeping Honcho off.
- Only add Honcho later if a clear use‑case emerges that OpenViking doesn’t cover—otherwise you avoid double complexity and unclear semantics.

This keeps your memory system aligned with Hermes’ official provider model, leverages high‑signal community patterns around Obsidian, and stays safe for multi‑project and client work in a WSL‑authoritative, Windows‑desktop‑client architecture.[^13][^1][^5][^8][^2][^3][^4]

<div align="center">⁂</div>

[^1]: 03-memory-obsidian-honcho-openviking.md

[^2]: https://www.glukhov.org/ai-systems/memory/agent-memory-providers/

[^3]: https://hermes.ai.vn/docs/user-guide/features/memory-providers/

[^4]: https://aisuccesslabjuliangoldie.com/blog/hermes-agent-workspace/

[^5]: https://dreamsaicanbuy.com/blog/hermes-agent-tips

[^6]: https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/profiles.md

[^7]: https://hermes.ai.vn/docs/user-guide/profiles/

[^8]: hermes_perplexity_research.md

[^9]: https://docs.openviking.ai/en/agent-integrations/05-hermes

[^10]: https://docs.openviking.ai/zh/agent-integrations/05-hermes

[^11]: https://www.youtube.com/watch?v=dMEuVbSr7AQ

[^12]: https://www.youtube.com/watch?v=P3BJl_V_UZ8

[^13]: https://www.youtube.com/watch?v=6QLzDqB5YKU

[^14]: https://chenguangliang.com/en/posts/blog122_hermes-agent-dev-workflow/

[^15]: https://www.youtube.com/watch?v=NvakBZyc1Sg

[^16]: https://www.reddit.com/r/hermesagent/comments/1snwkog/master_thread_skills_hub_custom_skill_development/

