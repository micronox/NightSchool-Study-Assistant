# Bucket 1: Mandatory Stack Path — Enhanced Audit

> **Compared against:** `steps/01-mandatory-stack-path.md` (small thinking model output)
> **Audit date:** 2026-06-18
> **Auditor:** Claude Sonnet 4.6 (full context synthesis across all 10 research files)

---

## A. What the Small Model Got Right

The small model's plan is structurally sound and well-sourced. Its non-negotiables are
confirmed by official Hermes v0.16 docs, the maintainer-aligned GitHub issue #31144, and
the `hermes_perplexity_research.md` technical spec:

- WSL as the authoritative Hermes backend: **confirmed official pattern**
- Windows Desktop as client surface only: **confirmed maintainer-endorsed**
- `~/.hermes` as the canonical state root: **confirmed by installer defaults and env_loader code**
- Three-layer memory model (built-in / Obsidian / external provider): **confirmed by community + official docs**
- Profile-based role separation rather than per-repo installs: **confirmed official pattern**
- Skills as the reusable workflow layer: **confirmed official Skills Hub model**

The step ordering (lock backend → define profiles → seed memory → first skill pack → learning
loop → client isolation → Git discipline) is sensible and broadly correct.

---

## B. Gaps, Under-Specifications, and Corrections

### B1. Profile creation mechanics were missing
The small model listed profile names (`infra-ops`, `research`, etc.) but did not describe
how profiles are actually created or what their internal layout looks like. This is a
first-class Hermes concept with CLI mechanics that should be spelled out.

### B2. Memory layer was underspecified
The plan mentions "one external semantic memory backend" but does not name a concrete
decision path between Honcho and OpenViking, nor does it describe what goes in each layer.
The research files (Perplex_3, Perplex_1 Packet 04 section) are far more prescriptive.

### B3. Skill pack was described, not specified
The small model listed skill names but provided no file layout, invocation pattern, or
example structure. The official skill model has a clear directory and SKILL.md convention
that must be followed.

### B4. The learning loop was conceptual, not mechanical
"Hermes learns by doing" is correct in spirit but the research reveals a concrete loop
built from skills + Kanban + cron jobs — these are specific Hermes primitives that need
to be wired, not just described.

### B5. Client isolation was undersized
The small model's Step 6 is brief. The Perplex_4 packet contains a full isolation model
covering profile-level `.env` scoping, provider selection per profile, filesystem trees,
vault subtrees, and Git identity — all of which should be part of the mandatory path.

---

## C. Complete Description

The Mandatory Stack Path establishes the minimum viable Hermes OS — the floor below which
nothing else works. It has three layers of concern:

**Runtime authority:** WSL2 Ubuntu-24.04 is the only authoritative Hermes backend. The
Windows Hermes Desktop is a thin Electron client that connects to the WSL gateway over
HTTP/WebSocket on port 9119. All config, skills, memory, sessions, jobs, and provider
wiring live in `/home/larry/.hermes`. The Desktop's `%APPDATA%\Hermes\connection.json`
is disposable client metadata, not runtime authority.

**Profile architecture:** Hermes profiles are separate homes under `~/.hermes/profiles/<name>`,
each with its own `.env`, `config.yaml`, `SOUL.md`, memory, skills, sessions, and cron jobs.
They separate roles and safety boundaries, not individual repos. The minimum viable set is:
`infra-ops`, `research`, `myku-dev`, `ai-docs-dev`, `client-dev`.

**Memory architecture:** Three independent layers serve three different purposes. Built-in
memory (`MEMORY.md`, `USER.md`, `SOUL.md` per profile) holds identity and coarse operating
rules — kept small and curated. Obsidian/Open-Brain vault (mounted from `L:\Vaults\` into
WSL) holds human-curated project knowledge, architecture decisions, and client SOPs. One
external provider (Honcho or OpenViking) handles semantic long-term recall across sessions.
Only one external provider is active at a time; OpenViking is the recommended first choice
for a power-user WSL stack because it has a dedicated Hermes integration and is fully
self-hosted.


---

## D. Implementation Plan

### Phase 1 — Backend Authority Lock (Day 1)

Confirm the WSL gateway is the single source of truth. This should already be done per the
technical spec, but verify it explicitly before building anything else on top.

Verify commands:
```bash
hermes --version
hermes doctor
hermes config show
# Confirm: provider = custom, base_url = http://127.0.0.1:11434/v1, model = qwen3.6:35b-a3b
# Confirm: OPENROUTER_API_KEY present
hermes dashboard --host 0.0.0.0 --port 9119 &
# Then open Hermes Desktop on Windows and confirm remote connection to http://localhost:9119
```

State check: `~/.hermes` must contain `.env`, `config.yaml`, `skills/`, `memory/`, `sessions/`.

### Phase 2 — Profile Set Definition (Day 1–2)

Create the five baseline profiles. Each profile gets its own config, SOUL.md, and provider
scoping. The `client-dev` profile is the most important to get right because it owns the
isolation boundary.

```bash
hermes profile create infra-ops
hermes profile create research
hermes profile create myku-dev
hermes profile create ai-docs-dev
hermes profile create client-dev

# Configure each:
infra-ops setup      # Ollama + OpenRouter, full tool access
research setup       # Ollama primary, OpenRouter for web summarization
myku-dev setup       # Ollama primary, full file/shader tools
ai-docs-dev setup    # Ollama + OpenRouter
client-dev setup     # LOCAL ONLY — Ollama only, no OpenRouter key in .env
```

Per-profile SOUL.md content should encode:
- What this profile is for
- Primary project directories
- Coding/output style preferences
- Safety rules (especially for `client-dev`)

### Phase 3 — Memory Stack Seeding (Day 2–3)

**Layer 1 (built-in):** Edit each profile's `MEMORY.md` and `SOUL.md` with identity and
operating rules. Keep each file under 200 lines. Content: your preferences, project summaries
in 1–2 paragraphs, safety constraints.

**Layer 2 (Obsidian vault):** Mount `L:\Vaults\` into WSL. Confirm Hermes file tools can
read and write vault `.md` files. Vault structure:
```
L:\Vaults\
  Personal/
  Products/
    MyKu/
    AI-Docs/
  Clients/
    <ClientName>/
  Library/
    Techniques/
    Film-Language/
```

**Layer 3 (OpenViking):** Deploy OpenViking as a local service in WSL. Configure:
```yaml
# ~/.hermes/config.yaml
memory:
  provider: openviking
  openviking:
    url: http://127.0.0.1:<openviking-port>
```
Test with: `hermes memory test` or a manual recall prompt.

### Phase 4 — First Skill Pack (Day 3–5)

Create the seven starter skills under the appropriate profile scope. Global skills go in
`~/.hermes/skills/`. Profile-scoped skills go in `~/.hermes/profiles/<name>/skills/`.

Priority order:
1. `repo-onboard` (global) — scans tree, writes REPO_MAP.md
2. `env-audit` (global) — checks `~/.hermes` layout, provider status, skill inventory
3. `daily-report` (global) — reads sessions + commits, writes DAILY.md to vault
4. `vault-sync` (global) — reconciles Hermes notes with Obsidian vault files
5. `client-safety-check` (client-dev profile) — pre-commit/push checklist
6. `impl-plan` (myku-dev, ai-docs-dev) — from spec to task breakdown
7. `diff-review` (global) — structured diff analysis with test gap detection

Each skill follows the official layout:
```
~/.hermes/skills/<skill-name>/
  SKILL.md      # description, steps, usage
  skill.yaml    # metadata, tool declarations
  scripts/      # supporting Python or shell scripts
```

### Phase 5 — Learning Loop Activation (Day 5–7)

Wire the learning loop using Hermes cron jobs:

```bash
# Nightly loop for each active profile
hermes job add --profile myku-dev --cron "0 2 * * *" \
  --task "run env-audit then daily-report then vault-sync"

hermes job add --profile client-dev --cron "0 3 * * *" \
  --task "run daily-report --scope clients"
```

The loop should: inspect current state → propose next actions → write output to vault →
feed that output into the next session's context.

### Phase 6 — Client Isolation Hardening (Day 5–6)

```bash
# client-dev profile .env should contain ONLY:
CUSTOM_API_KEY=ollama
CUSTOM_BASE_URL=http://127.0.0.1:11434/v1
CUSTOM_MODEL=qwen3.6:35b-a3b
# NO OPENROUTER_API_KEY here

# Filesystem isolation:
mkdir -p ~/projects/clients/<clientname>/<repo>

# Git identity per client:
git config user.name "Larry <contract identity>"
git config user.email "<client-appropriate email>"
# Set these locally per repo, not globally
```


---

## E. Design Spec Sheet

### Runtime Authority Model

| Component | Location | Role | Disposable? |
|-----------|----------|------|-------------|
| Hermes gateway | WSL `~/.hermes/hermes-agent` | Runtime authority | No |
| Config & state | WSL `~/.hermes/` | All persistent state | No |
| Ollama provider | WSL `127.0.0.1:11434` | Primary inference | No |
| OpenRouter | WSL `.env` (selected profiles) | Auxiliary inference | Yes |
| Hermes Desktop | Windows `%APPDATA%\Hermes\` | Thin client UI | Yes |
| Model artifacts | Windows `L:\AI_Vault\` | Large file storage | No |

### Profile Spec

| Profile | Provider | Tools | Obsidian Scope | Safety Level |
|---------|----------|-------|----------------|--------------|
| `infra-ops` | Ollama + OR | All | Personal/Infra | Low restriction |
| `research` | Ollama + OR | File, web, memory | Products/Library | Low restriction |
| `myku-dev` | Ollama primary | File, shader, git | Products/MyKu | Medium |
| `ai-docs-dev` | Ollama + OR | File, http, git | Products/AI-Docs | Medium |
| `client-dev` | Ollama ONLY | File, git (local) | Clients/ | High restriction |

### Memory Policy

| Layer | Location | Contents | Size Budget | Who edits |
|-------|----------|----------|-------------|-----------|
| Built-in | `~/.hermes/profiles/<p>/MEMORY.md` | Identity, prefs, project summaries | < 200 lines | Human + agent |
| Vault | `L:\Vaults\` mounted in WSL | Project docs, decisions, SOPs | Unlimited | Human primary |
| External | OpenViking service in WSL | Semantic recall, session facts | Unlimited | Agent primary |

### Skill Layout Standard

```
~/.hermes/skills/<skill-name>/
  SKILL.md          # Purpose, usage, step description (markdown)
  skill.yaml        # name, version, tools_required, profiles
  scripts/
    main.py or main.sh
    helpers/
```

`skill.yaml` minimum fields:
```yaml
name: repo-onboard
version: 0.1.0
description: Scans a repo and produces REPO_MAP.md
tools_required: [file_read, file_write, shell]
profiles: [global]
```

---

## F. Step-by-Step Implementation Checklist

- [ ] **F1.** Confirm `hermes --version` works inside WSL
- [ ] **F2.** Confirm `hermes dashboard --host 0.0.0.0 --port 9119` starts without error
- [ ] **F3.** Confirm Hermes Desktop on Windows connects in remote mode to `http://localhost:9119`
- [ ] **F4.** Confirm `~/.hermes` contains `.env`, `config.yaml`, `skills/`, `memory/`
- [ ] **F5.** Run `hermes config show` and verify provider = custom/Ollama, model = qwen3.6:35b-a3b
- [ ] **F6.** Confirm OpenRouter key present via `hermes config show` and validated
- [ ] **F7.** Create all five profiles: `infra-ops`, `research`, `myku-dev`, `ai-docs-dev`, `client-dev`
- [ ] **F8.** Run `<profile> setup` for each profile with correct provider settings
- [ ] **F9.** Write SOUL.md for each profile (role, directories, constraints)
- [ ] **F10.** Write MEMORY.md for each profile (project summaries, preferences)
- [ ] **F11.** Mount `L:\Vaults\` into WSL at a consistent path (e.g., `/mnt/l/Vaults`)
- [ ] **F12.** Confirm Hermes file tools can read from and write to a vault `.md` file
- [ ] **F13.** Deploy OpenViking as a local WSL service
- [ ] **F14.** Set `memory.provider: openviking` in `~/.hermes/config.yaml`
- [ ] **F15.** Test memory recall with a simple fact storage and retrieval prompt
- [ ] **F16.** Create `repo-onboard` skill with SKILL.md + skill.yaml + script
- [ ] **F17.** Create `env-audit` skill
- [ ] **F18.** Create `daily-report` skill
- [ ] **F19.** Create `vault-sync` skill
- [ ] **F20.** Create `client-safety-check` skill (scoped to `client-dev` profile)
- [ ] **F21.** Add nightly cron jobs for each active profile
- [ ] **F22.** Confirm `client-dev` profile `.env` has NO OpenRouter key
- [ ] **F23.** Set up `~/projects/clients/` tree in WSL
- [ ] **F24.** Set per-repo Git identity for at least one test client repo
- [ ] **F25.** Run a full end-to-end test: prompt in Desktop → executes skill in WSL → writes note to vault

---

## G. Divergences from Small Model Plan

| Small model said | Audit verdict | Correction |
|-----------------|---------------|------------|
| "one external semantic memory backend is enough" | Correct, but vague | Specify OpenViking as first choice; describe config |
| "profile names listed without creation steps" | Incomplete | Add `hermes profile create` CLI and SOUL.md spec |
| "skills listed without file layout" | Incomplete | Add canonical `skills/<name>/SKILL.md + skill.yaml` structure |
| "learning loop via doing" | Correct concept | Add concrete cron job wiring (`hermes job add`) |
| Step 6 client isolation was 4 lines | Underdeveloped | Add provider scoping, Git identity, vault subtree, filesystem tree |
| "Hermes Dreaming owns reasoning" | Correct framing | Clarify this is a profile + Kanban board pattern, not a separate runtime |

---

*Source cross-references: `hermes_perplexity_research.md` §4–6, `Perplex_1` §1.1–1.3,
`Perplex_2_project-workflow` §1–4, `Perplex_3_memory` §1–4, `Perplex_4_client-work` §1–4,
`Perplexity_Hermes-on-WSL` §2–7, `steps/01-mandatory-stack-path.md`*
