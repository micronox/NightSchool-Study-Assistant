# Lightweight Handoff

Hermes is not currently in “broken reinstall” territory. Treat it as a working install that now needs its local-model lane restored or validated.

## What was completed

- Local Kopia repo created at:
  - `$KOPIA_REPO`
- `L:\` backup tuned and working
- `$USER_HOME` backup tuned down to a much leaner shape by excluding:
  - normal personal folders
  - `CrossDevice/`
  - `OneDrive/`
  - `.ollama/models/`
  - `AppData/Local/wsl/`
  - `AppData/Local/Programs/`
  - several large local/roaming app caches
- Hermes config backed up and migrated:
  - `v0 -> v30`
- WhatsApp allowlist hardened from `*` to:
  - `19704203617`
- Stale Hermes alias `.bat` launchers removed from:
  - `$USER_HOME\.local\bin`
- Startup verification script created:
  - [Verify-Hermes-Startup.ps1](`$TROUBLESHOOT_ROOT/Verify-Hermes-Startup.ps1)
- Autorun shortcut added at Windows login:
  - `Hermes Startup Verify.lnk`
- Manual command-center shortcuts created in:
  - `$DESKTOP_ROOT\WorldFoundryInk_CommandCenter`

## Current validated Hermes state

- `hermes status` works unsandboxed
- provider:
  - `OpenRouter`
- model:
  - `anthropic/claude-opus-4.6`
- terminal backend:
  - `local`
- desktop connection mode:
  - `local`
- dashboard port:
  - `9119` listening
- Hermes Gateway task:
  - running
- Ollama process:
  - running
- Telegram:
  - connected
- WhatsApp:
  - configured, but gateway state later showed retrying/timeouts

## Important caveat

Inside Codex sandbox, Hermes commands may still fail with:

```text
uv trampoline failed to spawn Python child process
Caused by: permission denied (os error 5)
```

That was already known and still appears to be a sandbox artifact, not proof of a damaged Hermes install.

## Best next task

Focus the new chat on:

- getting Hermes working again with local models

Likely first questions/checks:

1. Which local model path do we want?
   - Ollama
   - WSL-hosted runtime
   - both
2. Can Hermes use a local provider/model without breaking the existing OpenRouter path?
3. What exact “working again” behavior is missing right now?
   - model selection
   - chat responses
   - dashboard routing
   - gateway use of local models

## Guardrails

Do not:

- reinstall Hermes first
- trust the sandbox `uv trampoline` failure as real install damage
- undo the WhatsApp allowlist hardening
- flatten the current OpenRouter-working state while testing local models

Do:

- use unsandboxed Hermes checks if needed
- preserve the existing working config
- treat this as a targeted local-model restoration task, not a rebuild

## Full archive

For the full detailed archive/changelist, use:

- [CODEX-CHANGELOG-2026-06-21-HERMES-KOPIA-COMMANDCENTER-FULL.md](`$TROUBLESHOOT_ROOT/CODEX-CHANGELOG-2026-06-21-HERMES-KOPIA-COMMANDCENTER-FULL.md)


