# Hermes AI Stack Technical Spec

Date context: June 18, 2026
Source basis: `L:\WSL\hermes-specs` plus the validated Segment F handoff state

## 1. Objective

Build a dual-lane Hermes AI environment where:

- `WSL2 Ubuntu-24.04` is the authoritative backend and execution lane
- `Windows Hermes Desktop` is the preferred GUI/operator lane
- `Local Ollama` is the primary model provider
- `OpenRouter` is the auxiliary provider for capabilities the local lane does not fully cover
- Large model artifacts remain on host storage under `L:\AI_Vault`, not buried inside WSL rootfs

The design goal is not “run everything natively on Windows.” The design goal is “use Windows for UX, WSL for compute, tools, state, and provider authority.”

------

## 2. High-Level Architecture

```
User
  ->
Windows Hermes Desktop (.exe)
  ->
Remote attachment to Hermes backend hosted in WSL
  ->
Hermes runtime in ~/.hermes/hermes-agent
  ->
Hermes config/state in ~/.hermes
  ->
Primary provider: Ollama API in WSL
  ->
Model artifacts persisted on L:\AI_Vault\Ollama_Models

Auxiliary path:
Hermes backend
  ->
OpenRouter
```

### Lane ownership

#### Lane 1: WSL Compute Core

Authoritative for:

- Hermes CLI/backend runtime
- Hermes config
- Hermes skills/memory
- provider wiring
- tool execution
- shell access
- Docker access
- GPU-adjacent workflows

#### Lane 2: Windows Desktop UI

Preferred for:

- Hermes Desktop `.exe`
- visual chat/session UX
- session browsing
- operator convenience
- remote attachment to WSL backend if supported

#### Shared Asset Lane

Host-backed persistent storage:

- `L:\AI_Vault\Ollama_Models`
- `L:\AI_Vault\HuggingFace_Hub`

------

## 3. Platform / Infra Baseline

## Host

- Windows workstation
- GPU: `NVIDIA RTX PRO 6000 Blackwell Workstation Edition`

## Linux runtime

- `WSL2`
- distro: `Ubuntu-24.04`

## Container/runtime layer

- native `docker-ce`
- `nvidia-container-toolkit`

## Running service layer

Verified earlier in the pack:

- `ollama-engine` on `:11434`
- `open-webui` on `:3000`
- `portainer` on `:9000`

## Python / experimentation lane

- workspace: `~/projects/blackwell-wsl`
- `uv` initialized
- `torch 2.7.1+cu128` verified
- CUDA tensor execution confirmed in WSL

Important separation rule:

- `~/projects/blackwell-wsl` is not Hermes home
- Hermes must live under `~/.hermes`

------

## 4. Hermes Runtime Buildout

## Canonical install target

- Hermes runtime/code: `/home/larry/.hermes/hermes-agent`
- Hermes state root: `/home/larry/.hermes`

Expected state subpaths:

- `/home/larry/.hermes/.env`
- `/home/larry/.hermes/skills`
- `/home/larry/.hermes/memory`

## Backend authority rules

Locked architecture decisions:

- WSL is the source of truth for Hermes backend behavior
- Windows Desktop is not the source of truth for provider config
- Desktop validation cannot redefine backend ownership
- Hermes must not be installed into `~/projects/blackwell-wsl`

## Verified install state

Segment B was previously completed and verified:

- Hermes is installed under `/home/larry/.hermes/hermes-agent`
- `hermes` is on `PATH` inside WSL
- `hermes --version` works
- `hermes doctor` runs successfully with warnings only
- `~/.hermes` layout exists with expected install/state paths

------

## 5. Model / Provider Framework

## Primary provider strategy

Primary provider is `local Ollama in WSL`.

### Active Hermes model/provider config

Validated in the handoffs:

- provider profile: `custom`
- base URL: `http://127.0.0.1:11434/v1`
- default model: `qwen3.6:35b-a3b`

Equivalent config intent:

```
CUSTOM_API_KEY=ollama
CUSTOM_BASE_URL=http://127.0.0.1:11434/v1
CUSTOM_MODEL=qwen3.6:35b-a3b
```

Important interpretation:

- This endpoint is WSL-local loopback
- It is not a Windows LAN-host bridge endpoint
- That means Hermes backend already sees the provider from inside WSL without needing the “Windows host IP workaround” seen in some videos/tutorials

## Primary model

Day-one production local model:

- `qwen3.6:35b-a3b`

## Secondary local model

Planned but deferred:

- one `Gemma 4` model after Qwen is stable

## Auxiliary provider

Required auxiliary provider:

- `OpenRouter`

Reason:

- Hermes auxiliary features such as vision or web summarization may need a secondary provider path beyond the local Ollama lane

## Verified auxiliary state

Segment D was previously completed and verified:

- `OPENROUTER_API_KEY` stored in `/home/larry/.hermes/.env`
- `hermes config show` recognized OpenRouter key presence
- OpenRouter validation returned `ok`
- auxiliary one-shot inference succeeded

------

## 6. Context Window / Throughput Configuration

## Original design intent

The initial spec proposed context tiers:

- Tier 1: `32K` interactive default
- Tier 2: `64K` extended repo/document tier
- Tier 3: larger only after profiling proves value

## Actual validated runtime result

Segment E changed the practical conclusion:

- Hermes rejected `32K`
- model context window `32,768` was below Hermes minimum `64,000`
- `64K` was configured and verified successfully

### Final current context posture

- operational context length: `65536`
- preferred default from evidence: `64K`

## Throughput evidence currently available

The pack contains one hard timing datum:

- `64K` one-shot verification succeeded
- timing: `real 1m16.478s`
- `user 0m1.223s`
- `sys 0m0.160s`

## What this means technically

This is not enough to claim a complete throughput benchmark suite. It does mean:

- the stack is operational at `64K`
- the backend/provider path is stable enough for long-context inference
- latency at `64K` is materially higher and should be treated as a real cost
- no validated benchmark matrix yet exists for:
  - tokens/sec
  - prompt eval vs generation split
  - concurrency
  - sustained multi-session load
  - GPU memory pressure under different prompt sizes

## Honest throughput status

Current state is “functional throughput verified,” not “fully benchmarked throughput characterized.”

------

## 7. Storage Layout

## Host-backed persistent storage

- `L:\AI_Vault\Ollama_Models`
- `L:\AI_Vault\HuggingFace_Hub`

## Storage rule

Large artifacts should remain on host-backed vault storage and not silently accumulate in the WSL root filesystem.

## State separation

### WSL state

Authoritative Hermes backend state lives in:

- `/home/larry/.hermes`

### Windows Desktop state

Hermes Desktop still appears to keep Windows client/app state under normal Windows app-data paths such as `%APPDATA%` / `%LOCALAPPDATA%`.

This is distinct from backend authority.

Implication:

- moving or disturbing the Windows app-data folder may reset Desktop client state
- it does not redefine or migrate the WSL Hermes backend
- it can reset connection metadata, UI history, or local session chrome without touching WSL runtime authority

------

## 8. Tooling Surface

Hermes in this architecture is expected to act across:

- files
- shell commands
- scripts
- Docker-related workflows
- browser-capable or auxiliary workflows where configured

Because WSL is authoritative, the important tool semantics are:

- backend-executed tools should resolve against WSL paths and environment
- provider wiring should be governed from WSL config
- Desktop is expected to function as a client to that backend, not a separate authority plane

Validated evidence from Segment F already showed tool output referencing WSL paths such as:

- `/home/larry/.hermes/config.yaml`

That is strong evidence the active tool lane was genuinely hitting WSL-side state.

------

## 9. Desktop / Remote-Backend Buildout

## Goal

Use Windows Hermes Desktop as the preferred UI while keeping WSL as backend authority.

## What has been proven

From Segment F handoff state:

- `hermes desktop --help` exists in WSL and describes Desktop as an Electron app
- local Hermes source/docs confirmed remote backend support exists
- a WSL-hosted `hermes dashboard` was started and was reachable from Windows
- Windows Hermes Desktop installer was downloaded from the official Hermes site
- installer metadata validated:
  - signed by `Nous Research`
  - product name `Hermes`
- Windows Hermes Desktop installed and launched successfully
- Desktop version shown in UI: `v0.16.0`

## Proven remote linkage evidence

Desktop connection state persisted as remote in Windows-side config:

- `%APPDATA%\Hermes\connection.json`
- showed:
  - `"mode": "remote"`
  - `"remote": { "url": "http://localhost:9119", "authMode": "oauth" }`

Session-level linkage was also proven:

- prompts entered in Desktop appeared in `http://localhost:9119/sessions`
- assistant responses appeared in the same dashboard session
- tool activity from the Desktop session appeared in the same dashboard session
- tool output included WSL paths

## WSL dashboard command used during validation

```
wsl --distribution Ubuntu-24.04 --exec bash -lc "export HERMES_DASHBOARD_BASIC_AUTH_USERNAME=desktop; export HERMES_DASHBOARD_BASIC_AUTH_PASSWORD=[REDACTED]; export HERMES_DASHBOARD_BASIC_AUTH_SECRET=[REDACTED]; hermes dashboard --host 0.0.0.0 --port 9119 --no-open --skip-build"
```

## Remote backend API evidence

`/api/status` returned evidence including:

- `auth_required: true`
- `auth_providers: ["basic"]`
- `version: "0.16.0"`

## Interpretation

The Desktop app and WSL backend were not merely coexisting. They were operationally interconnected at the session and tool layers.

------

## 10. Current Desktop Caveats

This is where the stack is not yet fully closed out.

## Caveat 1: Windows-local helper processes

Even after remote sign-in, Windows process inspection still showed local Windows Hermes-related helper/dashboard processes, for example:

- `python.exe -m hermes_cli.main dashboard --no-open --host 127.0.0.1 --port 0`

Open question:

- are these harmless UI/helper/bootstrap processes
- or do they indicate mixed local/remote backend behavior

## Caveat 2: File browsing semantics

Desktop still appeared Windows-user-rooted in parts of the UI:

- file browsing prominently showed the Windows user home
- this leaves file semantics ambiguous

Open question:

- is Desktop file access Windows-first
- WSL-first
- or mixed depending on feature path

## Segment F disposition

Because of the two caveats above, the final label for Desktop validation has not yet been locked.

Current candidate labels:

- `supported with caveats`
- `partial`

------

## 11. Current Maturity By Layer

## Platform maturity

Strong

- WSL, Docker, GPU, CUDA, and Python baseline validated
- Ollama engine healthy
- host vault strategy established

## Hermes backend maturity

Strong

- installed in canonical location
- CLI functional
- doctor functional
- config/state lanes defined and working

## Provider maturity

Strong

- local Ollama path working
- Qwen working
- OpenRouter auxiliary path working

## Context / throughput maturity

Moderate

- `64K` works and is adopted
- one real timing datapoint exists
- no full benchmark suite yet

## Desktop maturity

Moderate / unresolved

- remote interconnection to WSL is proven
- helper-process and file-semantic questions remain
- final support label not yet closed

------

## 12. Segment History / Execution Status

## Segment A: Pre-install reconciliation

Completed and verified.

Covered:

- WSL command stability
- Docker/Ollama health
- vault visibility
- CUDA shell persistence

## Segment B: Hermes backend install

Completed and verified.

Covered:

- install in canonical WSL location
- CLI availability
- `~/.hermes` layout

## Segment C: Provider and model wiring

Completed and verified.

Covered:

- local Ollama wiring
- `qwen3.6:35b-a3b`
- Hermes local inference success

## Segment D: Auxiliary provider

Completed and verified.

Covered:

- OpenRouter key storage
- OpenRouter validation
- auxiliary inference success

## Segment E: Context and performance tiers

Completed and verified.

Covered:

- `32K` rejected by Hermes minimum requirement
- `64K` configured and validated
- `64K` chosen as operational default

## Segment F: Desktop validation

In progress / mostly proven but not fully closed.

Covered:

- Desktop install
- remote attachment state
- session linkage
- tool linkage
- WSL-backed execution evidence

Still open:

- local helper-process interpretation
- file browsing semantics
- final support label

------

## 13. Risks and Constraints

## WSL stability risk

Earlier work observed some intermittent WSL launch/registration flakiness. This remains an environmental risk unless repeatedly reconfirmed cleanly.

## Storage-location reconciliation risk

The full WSL backing-store/migration story was not considered fully polished. This does not block operation, but it does block calling the platform fully tidied.

## Desktop bridge risk

Desktop-to-WSL support is now much stronger than assumed at the beginning, but the final production-quality support label is still pending caveat resolution.

## Client-state risk on Windows

Windows Hermes Desktop appears to maintain client-side app state in Windows app-data locations. Manual relocation of those folders can:

- reset Desktop connection state
- reset session/sidebar state
- create ambiguity about what the Desktop app treats as its local profile

That does not necessarily damage WSL backend state, but it can disrupt the Windows UI lane.

------

## 14. What the Stack Is Right Now

As of June 18, 2026, the stack is best described as:

“A WSL-authoritative Hermes backend running against local Ollama with Qwen 3.6 at 64K context, plus OpenRouter auxiliary support, with Windows Hermes Desktop proven to interconnect remotely to the WSL backend at the session/tool level, but with unresolved caveats around Windows-local helper processes and file browsing semantics.”

Shorter version:

- backend authority: WSL
- primary model lane: local Ollama + Qwen 3.6
- auxiliary lane: OpenRouter
- context tier: 64K
- desktop status: interconnected, not yet perfectly characterized

------

## 15. Questions for Perplexity / Hermes Research

You can paste these directly after the spec if you want Perplexity to target the unresolved areas:

1. In Hermes Desktop `v0.16.0`, when connected in remote mode to a dashboard/backend, are local Windows `python.exe` helper/dashboard processes expected as part of normal client behavior?

2. In Hermes Desktop remote mode, what are the official file semantics: Windows-local only, backend-remote only, or mixed?

3. Does Hermes Desktop remote mode treat file browsing separately from tool execution context?

4. Is `%APPDATA%\Hermes\connection.json` the canonical remote-connection persistence file on Windows?

5. Is the remote Desktop architecture officially considered production-supported, beta, or partial in `v0.16.0`?

6. When Hermes backend uses `CUSTOM_BASE_URL=http://127.0.0.1:11434/v1` inside WSL, is any Windows-host bridge step needed for Desktop remote mode, or is that entirely backend-local?

7. What Windows directories does Hermes Desktop officially use for:

   - settings
   - cache
   - sessions
   - logs
   - connection state

8. Is it supported to relocate Hermes Desktop app-data/state out of `%APPDATA%` / `%LOCALAPPDATA%`, and if so, how?

   __________________________

   In a different research task:  I want these questions answered from the initial research

    I'd like you to make a plan and a indepth research into github/famous youtubers/people that are building Agentic OS through hermes / on where is the best location for the desktop app

   1) how i can work with future projects and workflow
   2) How do i buildout this desktop work flow
   3) now that we've vetted tools and are working pure open source, everything is free.  I want you to teach me and buildout a hermes agentic loop to help build out its local environment with its tools and start creating skills with them. 
   4) plug-in its memory system.  I will bring back the open-brain|Obsidean vault but I want you to also look at something called Viking memory for hermes
   5) If I were to start doing side work on upWork and committing work to other peoples Githubs, how does that work.
   6) What steps are there to build an agentic OS ontop of Hermes
   7) What are the top github / youtube customization routes for the tech stack we have
