# Northstar Rebuild Handoff

- Date: 2026-06-17
- Author: Northstar
- Purpose: one-file handoff for backing up the current stack, preserving the
  useful architecture and knowledge assets, and rebuilding the system from
  scratch on a clean base

## Bottom Line

Yes, you can rebuild from scratch now.

The most important lesson from the investigation is:

- the conceptual architecture was better than the runtime implementation
- the rebuild should preserve the authority model, lane model, and memory model
- the rebuild should not preserve the old control-plane state as live truth

The current stack should be treated as:

- evidence source
- backup source
- migration source
- not the new runtime base

## What I Can Hand Off

You already have four strong handoff layers on disk:

### 1. Research and incident narrative

- [NORTHSTAR-STACK-RESEARCH-BRIEF-2026-06-11.md](C:/Users/larry/Documents/Troubleshoot/NORTHSTAR-STACK-RESEARCH-BRIEF-2026-06-11.md)
- `C:\Users\larry\Documents\Troubleshoot\checkins\`
  - currently `40` timestamped check-ins

These capture:

- architecture intent
- observed failures
- control-plane drift
- Telegram/OpenRouter/MCP instability
- GPU and runtime observations
- the later Commander Telegram retry loop and recovery

### 2. Rebuild scaffold

- `L:\AI-Stack\`

Key files:

- `L:\AI-Stack\README.md`
- `L:\AI-Stack\governance\CURRENT-STATE.md`
- `L:\AI-Stack\governance\NETWORK-LEDGER.md`
- `L:\AI-Stack\governance\registry\authority-model.json`
- `L:\AI-Stack\governance\registry\lane-registry.json`
- `L:\AI-Stack\governance\diagrams\current-state.mmd`
- `L:\AI-Stack\governance\diagrams\target-state.mmd`
- `L:\AI-Stack\control-plane\profiles\commander.json`
- `L:\AI-Stack\control-plane\profiles\apollo.json`
- `L:\AI-Stack\inference\manifests\local-lanes.json`
- `L:\AI-Stack\memory-plane\contracts\memory-classes.json`
- `L:\AI-Stack\memory-plane\contracts\retrieval-contract.json`
- `L:\AI-Stack\mission-control\contracts\snapshot.schema.json`
- `L:\AI-Stack\ops\runbooks\CUTOVER-STAGES.md`
- `L:\AI-Stack\ops\scripts\inventory-stack.ps1`
- `L:\AI-Stack\ops\scripts\cleanup-hermes-stale-state.ps1`
- `L:\AI-Stack\ops\scripts\backup-legacy-state.ps1`
- `L:\AI-Stack\ops\scripts\test-lane-health.ps1`

### 3. Clean external inference runbook

- [LLAMACPP-EXTERNAL-LANE-RUNBOOK-2026-06-11.md](C:/Users/larry/Documents/Troubleshoot/LLAMACPP-EXTERNAL-LANE-RUNBOOK-2026-06-11.md)

This is the cleanest path for standing up an isolated workhorse lane outside
the old Onyx/WSL tangle.

### 4. The actual data sources you need to preserve

These are the real folders to back up before formatting anything.

## What To Back Up

### Highest priority knowledge and doctrine

Back these up first:

- `L:\Apollo-Brain\`
  - especially:
    - `L:\Apollo-Brain\OB1`
    - `L:\Apollo-Brain\Vaults`
- `L:\WSL\Onyx\`
  - especially:
    - `agent-registry`
    - `captain-decisions`
    - `changelists`
    - `MemoryRecall`
    - `Requests`
    - `PORT-MAP.md`

These are the most important long-term assets.

### Rebuild scaffold and investigation artifacts

Back up:

- `L:\AI-Stack\`
- `C:\Users\larry\Documents\Troubleshoot\`
  - especially:
    - `NORTHSTAR-STACK-RESEARCH-BRIEF-2026-06-11.md`
    - `LLAMACPP-EXTERNAL-LANE-RUNBOOK-2026-06-11.md`
    - `checkins\`

### Hermes runtime evidence and profile state

Back up:

- `C:\Users\larry\.hermes\hermes-agent\`
- `C:\Users\larry\.hermes\profiles\`

Especially preserve:

- `C:\Users\larry\.hermes\profiles\commander\`
- `C:\Users\larry\.hermes\profiles\apollo\`
- `C:\Users\larry\.hermes\profiles\bridge\`

Useful evidence inside those:

- `config.yaml`
- `gateway_state.json`
- `gateway.pid`
- `gateway.lock`
- `channel_directory.json`
- `gateway-stderr.log`
- `desktop\sessions.json`
- `cron\jobs.json`
- memory and workspace files

These should be archived as evidence, not reused directly as live runtime state.

### Jarvis and related project code

Back up:

- `L:\Jarvis\`
- `L:\WSL\Command_Line_Reference\`
- `L:\WSL\runtime\`
- `L:\WSL\observability\`

Jarvis specifically:

- `L:\Jarvis\dashboard\`
- `L:\Jarvis\src\`
- `L:\Jarvis\docs\`
- `L:\Jarvis\DATA\`

### Projects to quarantine, not trust

Back up, but do not reuse as clean live roots:

- `L:\WSL\site-studio\`
- old generated or recursive project trees beneath it

This folder had confirmed recursive self-copy contamination.

## What The Final Architecture Should Preserve

### Governance model

Keep this exactly in spirit:

- `Northstar`
  - final authority
  - validation
  - truth owner
- `Commander`
  - machine authority
  - local assistant operations
  - local runtime control
- `Apollo`
  - canon and doctrine authority
  - promotion into truth
- `Terran`
  - research and planning
- `Zion`
  - audit and validation
- `Anvil`
  - worker lane
- `Hermes`
  - runtime and automation layer
- `Jarvis`
  - mission control and visibility

### Memory model

Keep:

- shared operational memory
- Commander memory
- Apollo memory
- promotion queue

Promotion ladder:

- `Evidence`
- `Recommended`
- `Canon`

### Lane model

Keep:

- one local assistant lane
- one implementation/worker lane
- one embeddings lane
- one mission control surface
- one observability surface

Do not let names, profiles, lanes, and runtime owners blur together again.

## What Broke In The Old Stack

These were the most important failures:

- duplicate gateway/control-plane ownership
- stale state files claiming healthy runtime after failures
- Telegram token/ownership ambiguity
- Commander absorbing routing and operational gravity
- Apollo staying conceptually clean but operationally sidelined
- recursive `site-studio` contamination
- browser/session reuse and context bloat
- drift between docs, ports, runtime, and actual machine state
- mixed Docker/WSL/local control-plane modes with no single authority

The rebuild should be designed specifically to prevent those failures.

## Exact Data Sources For Repro / Incident Memory

If you want the most valuable forensic evidence, take copies of these:

### Research / incident docs

- `C:\Users\larry\Documents\Troubleshoot\checkins\`
- `C:\Users\larry\Documents\Troubleshoot\NORTHSTAR-STACK-RESEARCH-BRIEF-2026-06-11.md`
- `F:\TempFiles\AI-Stack-Peer-Review-Terran.md`

### Commander / Apollo runtime state

- `C:\Users\larry\.hermes\profiles\commander\gateway_state.json`
- `C:\Users\larry\.hermes\profiles\commander\channel_directory.json`
- `C:\Users\larry\.hermes\profiles\commander\config.yaml`
- `C:\Users\larry\.hermes\profiles\commander\gateway-stderr.log`
- `C:\Users\larry\.hermes\profiles\commander\desktop\sessions.json`
- `C:\Users\larry\.hermes\profiles\apollo\gateway_state.json`
- `C:\Users\larry\.hermes\profiles\apollo\channel_directory.json`
- `C:\Users\larry\.hermes\profiles\apollo\config.yaml`

### Project and platform evidence

- `L:\WSL\site-studio\`
- `L:\WSL\Command_Line_Reference\`
- `L:\WSL\Onyx\PORT-MAP.md`
- `L:\Jarvis\`

## Rebuild Strategy

Use a clean-room rebuild.

That means:

1. back up useful data
2. archive evidence
3. format / wipe the broken live stack
4. rebuild from a new controlled root
5. migrate only selected assets back in

Do not attempt to revive the old stack in place as your main path.

## Recommended New Root Layout

Use:

```text
L:\AI-Stack
|-- governance
|-- control-plane
|-- inference
|-- memory-plane
|-- mission-control
|-- observability
`-- ops
```

Use:

```text
L:\Apollo-Brain
|-- OB1
`-- Vaults
```

Use a separate runtime root for the clean external workhorse:

```text
R:\Hermes-Forge
|-- docs
|-- hermes
|-- llama.cpp
|-- logs
|-- models
`-- scratch
```

## Step-By-Step Rebuild Plan

### Phase 0: Freeze and copy

1. Copy `L:\Apollo-Brain\` in full.
2. Copy `L:\WSL\Onyx\` in full.
3. Copy `L:\AI-Stack\` in full.
4. Copy `C:\Users\larry\Documents\Troubleshoot\` in full.
5. Copy `C:\Users\larry\.hermes\profiles\` in full.
6. Copy `C:\Users\larry\.hermes\hermes-agent\` in full.
7. Copy `L:\Jarvis\` in full.
8. Copy `L:\WSL\Command_Line_Reference\` in full.
9. Copy `L:\WSL\site-studio\` as evidence only.

### Phase 1: Wipe and establish clean roots

1. Format the stack volume if that is your chosen path.
2. Recreate:
   - `L:\AI-Stack`
   - `L:\Apollo-Brain`
   - `R:\Hermes-Forge`
3. Restore only the clean handoff files and doctrine files first.

### Phase 2: Build the inference foundation first

1. Stand up the external `llama.cpp` lane from:
   - [LLAMACPP-EXTERNAL-LANE-RUNBOOK-2026-06-11.md](C:/Users/larry/Documents/Troubleshoot/LLAMACPP-EXTERNAL-LANE-RUNBOOK-2026-06-11.md)
2. Use one fresh port:
   - `8012`
3. Use one fresh model family:
   - `DeepSeek v4`
   - or `Qwen`
4. Keep it off:
   - Docker
   - Telegram
   - old Hermes profiles
   - old Onyx runtime state

### Phase 3: Rebuild Hermes as a clean local control plane

1. Install a fresh Hermes runtime outside the old state tree.
2. Create fresh profiles only:
   - `commander-clean`
   - `apollo-clean`
   - later `terran-clean`
3. Do not copy old profile directories into the new live runtime.
4. Import only selected config ideas, not raw runtime state.
5. Give each profile:
   - explicit owner
   - explicit port
   - explicit token ownership
   - explicit memory scope

### Phase 4: Rebuild governance and memory

1. Restore `Onyx` doctrine into `L:\AI-Stack\governance`.
2. Restore `Apollo-Brain` as the main knowledge substrate.
3. Rebuild the retrieval layer using:
   - `memory-classes.json`
   - `retrieval-contract.json`
4. Do not inject the whole vault into prompts.
5. Use local embeddings and scoped recall.

### Phase 5: Rebuild observability and mission control

1. Rebuild Prometheus/Grafana cleanly.
2. Rebuild Jarvis only after lane registry and health checks are authoritative.
3. Make Jarvis read from the registry and live health checks.
4. Do not let Jarvis become a truth store.

### Phase 6: Reintroduce Telegram and remote edges last

1. Add Telegram only after:
   - Commander is stable
   - Apollo is stable
   - token ownership is explicit
2. One bot token, one owner.
3. Keep Mercury/VPS detached until the single-machine version is clean.
4. Reintroduce remote nodes one at a time:
   - secondary machine
   - Sparks
   - VPSs

## Rebuild Order Recommendation

Best order:

1. `Apollo-Brain` backup
2. `Onyx` backup
3. `AI-Stack` scaffold backup
4. `Hermes` evidence backup
5. format / wipe
6. external `llama.cpp` lane
7. fresh Hermes runtime
8. Commander clean profile
9. Apollo clean profile
10. retrieval / embeddings
11. observability
12. Jarvis
13. Telegram
14. remote federation

## Ports To Reserve In The New Build

Avoid reusing the old drifted ports as defaults unless you intentionally assign
them.

Suggested clean assignments:

- `8012`
  - external `llama.cpp` assistant/workhorse lane
- `8013`
  - optional second inference lane
- `11435`
  - optional second clean Ollama lane if needed later
- `9102`
  - optional metrics for external lane

Treat old ports as legacy unless deliberately remapped:

- `3000`
- `3001`
- `3006`
- `3210`
- `8089`
- `8092`
- `8642`
- `8643`
- `8644`
- `8645`
- `8646`
- `9090`
- `9119`
- `11434`

## What Not To Reuse Directly

Do not copy these straight into the new live runtime:

- old `gateway_state.json`
- old `gateway.pid`
- old `gateway.lock`
- old `channel_directory.json`
- old `processes.json`
- old `desktop\sessions.json`
- recursive `site-studio` project trees
- old scheduled-task state as runtime truth

These are evidence, not trusted configuration.

## Recommended First Build Goal

Your first successful rebuild milestone should be very small:

- one fresh local inference lane
- one fresh Hermes Commander profile
- zero Telegram
- zero Docker dependency
- zero reused runtime state
- healthy prompt/response loop

Only after that should you add:

- Apollo
- retrieval
- Jarvis
- Telegram
- remote nodes

## If You Want The Cleanest Handoff Bundle

Copy these into one backup folder before formatting:

- `C:\Users\larry\Documents\Troubleshoot\`
- `L:\AI-Stack\`
- `L:\Apollo-Brain\`
- `L:\WSL\Onyx\`
- `L:\WSL\Command_Line_Reference\`
- `L:\Jarvis\`
- `C:\Users\larry\.hermes\profiles\`
- `C:\Users\larry\.hermes\hermes-agent\`
- `F:\TempFiles\AI-Stack-Peer-Review-Terran.md`

That set gives you:

- architecture
- doctrine
- memory vaults
- runtime evidence
- investigation notes
- rebuild scaffold

## Final Recommendation

Rebuild from scratch, but do not rebuild blind.

You already have enough preserved architecture and incident evidence to do this
cleanly if you:

- keep the authority model
- keep the memory model
- keep the lane model
- discard the old live control-plane state
- start with one clean inference lane and one clean local profile

If you want, I can next produce:

1. a shorter “backup checklist” version of this,
2. a literal folder-by-folder copy checklist,
3. or a phase-by-phase rebuild operator runbook with commands.
