# Hermes Full Context Snapshot

- Date: 2026-06-21
- Time: 04:12:07 America/Chicago
- Purpose: durable full-context snapshot after Hermes local/fallback cleanup and upgrade-proposal refinement

## What Was Fixed In This Pass

### 1. Hermes local Qwen lane

We verified that Hermes can now use local Ollama correctly:

- Hermes config points at `http://127.0.0.1:11434/v1`
- primary model is `qwen3.6:latest`
- provider is `custom`
- direct Ollama inference worked
- `hermes -z "Reply with exactly LOCAL_OK"` also worked

### 2. Hermes desktop sticky model contamination

We confirmed the old roaming desktop local storage still contained stale state for:

- `hermes.desktop.composer.model = qwen3.6:35b-a3b`
- `custom::qwen3.6:35b-a3b`

We then repaired this cleanly by:

- preserving existing backups
- moving the stale `Local Storage` folder aside
- launching the packaged Hermes desktop app
- letting it recreate a fresh local storage database

Result:

- the fresh desktop store no longer contained the stale `35b-a3b` state

### 3. Nous Portal and fallback

We completed live Hermes Portal auth and verified:

- `hermes portal status` shows logged in
- Hermes fallback chain is now:
  - `anthropic/claude-sonnet-4.6` via `nous`

This preserves local Ollama as the primary lane while giving Hermes a cloud backup path.

## Current Live State

- Primary model: `qwen3.6:latest`
- Primary provider: `custom`
- Primary endpoint: `http://127.0.0.1:11434/v1`
- Portal auth: active
- Fallback chain: one Nous entry
- Packaged Hermes desktop app: launchable from
  - `C:\Users\larry\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe`

## Proposal / Architect State

We also reconciled the June 19 infrastructure proposal against the live system and saved:

- [HERMES-MODEL-INFRA-UPGRADE-REFINED-2026-06-21.md](C:/Users/larry/Documents/Troubleshoot/HERMES-MODEL-INFRA-UPGRADE-REFINED-2026-06-21.md)

The important conclusion is:

- the stabilization intent of Track A is already achieved in practice
- the remaining work is benchmark and routing policy, not emergency repair
- Tracks B and C remain optional future expansion work

## New Workspace Rules

Added durable rule file:

- [TROUBLESHOOT-OPERATING-RULES.md](C:/Users/larry/Documents/Troubleshoot/TROUBLESHOOT-OPERATING-RULES.md)

New rules established:

- exported notes should include both date and timecode
- concise reset-ready documents should live in `handoff`
- broader state captures should live in `full_context`

## Preserved Recovery Artifacts

- Local storage backup:
  - `C:\Users\larry\Documents\Troubleshoot\backups\hermes-localstorage-20260621-032620`
- Config backup:
  - `C:\Users\larry\Documents\Troubleshoot\backups\hermes-config-fallback-20260621-portal.yaml`
- Rotated stale desktop store:
  - `C:\Users\larry\AppData\Roaming\Hermes\Local Storage.preclean-20260621-035340`

## Suggested Next Work Package

The clean next phase is:

### Benchmark and Routing Baseline

Measure:

- local Hermes latency
- direct Ollama latency
- cloud fallback latency
- whether current local inference is already sufficient for Hermes-on-Hermes work

Then decide:

- whether any extra CUDA/runtime tuning is worth doing
- whether Track B is needed
- whether Track C should become a real architecture project

## Reference Set

- [2026-06-21-041207-hermes-current-handoff.md](C:/Users/larry/Documents/Troubleshoot/handoff/2026-06-21-041207-hermes-current-handoff.md)
- [HERMES-MODEL-INFRA-UPGRADE-REFINED-2026-06-21.md](C:/Users/larry/Documents/Troubleshoot/HERMES-MODEL-INFRA-UPGRADE-REFINED-2026-06-21.md)
- [HERMES-HARDENING-RUNBOOK-2026-06-21.md](C:/Users/larry/Documents/Troubleshoot/HERMES-HARDENING-RUNBOOK-2026-06-21.md)
- [CODEX-CHANGELOG-2026-06-21-HERMES-QWEN-LOCAL-NOUS-BACKUP-PENDING.md](C:/Users/larry/Documents/Troubleshoot/CODEX-CHANGELOG-2026-06-21-HERMES-QWEN-LOCAL-NOUS-BACKUP-PENDING.md)
