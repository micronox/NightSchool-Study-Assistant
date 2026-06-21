# Lightweight Handoff

Hermes has been partially moved from broken `custom/OpenRouter/invalid-Qwen` state to a new local-Qwen primary lane, but the job is not fully finished.

## What was completed

- Confirmed root cause:
  - Hermes desktop sticky state had `custom + qwen3.6:35b-a3b`
  - Hermes config still pointed `custom` at OpenRouter
- Verified Ollama installed models:
  - `qwen3.6:latest`
  - `qwen3-coder:30b`
  - `gemma4:26b`
- Switched Hermes root config to local Ollama:
  - `model.base_url: http://127.0.0.1:11434/v1`
  - `model.default: qwen3.6:latest`
  - `model.provider: custom`
- Verified `hermes status` now shows:
  - model: `qwen3.6:latest`
  - provider: `Custom endpoint`
- Backed up Hermes desktop local storage to:
  - `$TROUBLESHOOT_ROOT\backups\hermes-localstorage-20260621-032620`
- Stopped Hermes desktop packaged app processes

## Important unresolved items

- Hermes desktop sticky localStorage cleanup is NOT verified complete
- `hermes -z "Reply with exactly LOCAL_OK"` timed out after ~64s
- `ollama ps` was empty at the final snapshot
- Nous Portal backup is NOT configured because:
  - `hermes portal status` = not logged in

## Current verified state

- Hermes root config:
  - local custom endpoint
  - `qwen3.6:latest`
- Hermes gateway:
  - still running
- Hermes desktop:
  - stopped

## Best next step

In the new chat:

1. Verify local Ollama Qwen directly first
2. Re-test Hermes local inference with a longer timeout
3. Verify whether desktop still sticks to `qwen3.6:35b-a3b`
4. Run `hermes portal`
5. Add Nous as fallback only after real Portal auth succeeds

## Files produced for this handoff

- `$TROUBLESHOOT_ROOT\CODEX-CHANGELOG-2026-06-21-HERMES-QWEN-LOCAL-NOUS-BACKUP-PENDING.md`
- `$TROUBLESHOOT_ROOT\CODEX-HANDOFF-2026-06-21-HERMES-QWEN-LOCAL-LITE.md`


