# Codex Changelog: Hermes Local Qwen Repair + Nous Backup Pending

- Date: 2026-06-21
- Purpose: preserve exact progress/state before context exhaustion

## Summary

This session moved Hermes away from the broken `custom + OpenRouter + invalid Qwen model id` state and into a new local-Qwen primary configuration.

What is verified:

- Hermes root config now points at local Ollama:
  - `model.base_url: http://127.0.0.1:11434/v1`
  - `model.default: qwen3.6:latest`
  - `model.provider: custom`
- `hermes status` now reports:
  - Model: `qwen3.6:latest`
  - Provider: `Custom endpoint`
- Ollama inventory was verified earlier in this chat:
  - `qwen3.6:latest`
  - `qwen3-coder:30b`
  - `gemma4:26b`
- A safety backup of Hermes desktop local storage was created at:
  - `C:\Users\larry\Documents\Troubleshoot\backups\hermes-localstorage-20260621-032620`

What is not yet verified:

- End-to-end Hermes inference through local Qwen
- Hermes desktop localStorage stale sticky model state cleanup
- Nous Portal fallback provider setup

## Root Cause That Was Confirmed

The broken “Qwen backend” was actually two separate issues:

1. Hermes desktop sticky UI state had persisted:
   - `hermes.desktop.composer.provider = custom`
   - `hermes.desktop.composer.model = qwen3.6:35b-a3b`
2. Hermes root config still had:
   - `base_url = https://openrouter.ai/api/v1`

That meant Hermes was trying to send a local-style model string to OpenRouter.

Confirmed evidence from logs:

- provider: `custom`
- endpoint: `https://openrouter.ai/api/v1`
- model: `qwen3.6:35b-a3b`
- error: `HTTP 400: qwen3.6:35b-a3b is not a valid model ID`

## Exact Actions Completed

### 1. Read approved upgrade context

The user re-supplied the approved upgrade proposal and confirmed desired order:

1. fix Qwen backend
2. set Nous Hermes package as backup

### 2. Verified live local model inventory

Unsandboxed checks confirmed Ollama was healthy and exposed:

- `qwen3.6:latest`
- `qwen3-coder:30b`
- `gemma4:26b`

### 3. Switched Hermes root config to local primary

Executed:

- `hermes config set model.base_url http://127.0.0.1:11434/v1`
- `hermes config set model.default qwen3.6:latest`
- `hermes config set model.provider custom`

Result in `C:\Users\larry\.hermes\config.yaml`:

```yaml
model:
  base_url: http://127.0.0.1:11434/v1
  default: qwen3.6:latest
  provider: custom
```

### 4. Backed up Hermes desktop local storage

Backed up:

- `C:\Users\larry\AppData\Roaming\Hermes\Local Storage`

To:

- `C:\Users\larry\Documents\Troubleshoot\backups\hermes-localstorage-20260621-032620`

### 5. Stopped Hermes desktop processes

Only the packaged Hermes desktop processes were stopped so the locked local storage could be worked on safely.

At the end of this chat:

- Hermes desktop packaged app processes are not running
- Hermes gateway/manual process is still running

### 6. Attempted desktop sticky-state repair

Created probe/repair files in the workspace:

- `C:\Users\larry\Documents\Troubleshoot\qwen-localstorage-probe.html`
- `C:\Users\larry\Documents\Troubleshoot\qwen-localstorage-repair.html`

Intent:

- rewrite the sticky desktop keys from invalid `qwen3.6:35b-a3b` to `qwen3.6:latest`
- keep provider as `custom`
- move preset key from:
  - `custom::qwen3.6:35b-a3b`
  - to `custom::qwen3.6:latest`

But this repair is NOT verified as successful.

## What Failed / Remains Uncertain

### A. Local storage rewrite is still unresolved

Searches of:

- `C:\Users\larry\AppData\Roaming\Hermes\Local Storage\leveldb`

still showed stale entries like:

- `hermes.desktop.composer.model = qwen3.6:35b-a3b`
- `custom::qwen3.6:35b-a3b`

Important nuance:

- LevelDB grep can show stale historical records, not necessarily the final live key
- however, there is no fresh positive verification yet that the final current desktop key was rewritten

So the desktop sticky-state cleanup should be treated as incomplete/unverified.

### B. End-to-end local inference did not verify yet

Executed:

- `hermes -z "Reply with exactly LOCAL_OK"`

Result:

- timed out after about 64 seconds

This does NOT prove the local lane is broken.

It may mean:

- model cold-load latency
- heavy first local load
- local inference slower than timeout budget

Also note:

- `ollama ps` at the end returned no loaded model
- that suggests the local model may not have finished loading during the timed test

### C. Nous backup is not configured yet

Verified:

- `hermes portal status` shows `Auth: not logged in`
- `hermes auth list` shows no Nous credential

Therefore:

- Nous cannot honestly be called a working backup yet

## Current Verified State At Stop Point

### Hermes root config

- provider: `custom`
- model: `qwen3.6:latest`
- base_url: `http://127.0.0.1:11434/v1`

### Hermes status

- model: `qwen3.6:latest`
- provider: `Custom endpoint`
- gateway: running
- Telegram: configured
- WhatsApp: configured

### Hermes desktop

- packaged Hermes desktop processes: stopped
- sticky localStorage cleanup: pending verification

### Ollama

- installed models verified
- no model loaded at the exact final `ollama ps` snapshot

### Errors tail

Recent `errors.log` tail was only repeated WhatsApp reconnect timeout warnings, not new Qwen-specific failures.

## Best Next Actions In New Chat

1. Re-open or launch Hermes desktop only after deciding how to finish sticky-state cleanup.
2. Verify local Qwen directly with Ollama first:
   - e.g. direct Ollama API or `ollama run qwen3.6:latest`
3. Then retry Hermes local inference with a longer timeout.
4. Verify whether the desktop still comes up with stale `qwen3.6:35b-a3b` or now follows the new local config.
5. Log into Nous Portal:
   - `hermes portal`
6. After successful login, add Nous as Hermes fallback provider:
   - via `hermes fallback add`
7. Only claim success after:
   - local Qwen inference verified
   - desktop sticky state verified
   - Nous fallback authenticated and configured

## Guardrails

Do not:

- treat the 64s `hermes -z` timeout as proof the new local lane is dead
- assume the desktop sticky key is fixed without fresh verification
- claim Nous backup works before `hermes portal` auth is real

Do:

- preserve the local storage backup
- preserve the current local-Qwen root config unless deliberately rolling back
- verify local Ollama response directly before debugging Hermes further
