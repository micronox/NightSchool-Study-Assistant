# Codex Changelog: Hermes, Kopia, and Command Center

- Date: 2026-06-21
- Purpose: full archive of work completed in this chat so a later agent can recover context quickly without relying on thread memory

## Executive Summary

Three major tracks were handled:

1. A local Kopia repository was created on `E:\KopiaRepo`
2. Hermes was hardened without disturbing the working install
3. A lightweight startup verification/recovery flow was created and wired into Windows login plus a desktop command-center folder

The next likely task is:

- get local Hermes working again with local models

## Kopia Work

### Repository decision

- Chose local repository first, not cloud
- Selected:
  - `E:\KopiaRepo`

### Snapshot roots created

- `L:\`
- `C:\Users\larry`

### `L:\` excludes established

- `System Volume Information/`
- `$RECYCLE.BIN/`
- `AI_vault/HuggingFace_Hub/`

### `C:\Users\larry` backup strategy

Goal was not a normal personal-files backup. Goal was:

- keep weird/important under-user-profile app state
- avoid ordinary Windows user content
- avoid giant caches/models/device mirrors/reinstallable program payloads

### `C:\Users\larry` exclude list evolved to include

- `Desktop/`
- `Documents/`
- `Downloads/`
- `Music/`
- `Pictures/`
- `Videos/`
- `Saved Games/`
- `Searches/`
- `Favorites/`
- `Contacts/`
- `AppData/Local/Temp/`
- `AppData/Local/pip/Cache/`
- `.cache/`
- `.thumbnails/`
- `.ollama/models/`
- `AppData/Local/wsl/`
- `AppData/Local/UnrealEngine/`
- `AppData/Local/Packages/`
- `AppData/Local/Google/`
- `AppData/Local/Microsoft/`
- `AppData/Local/npm-cache/`
- `AppData/Local/NVIDIA Corporation/`
- `AppData/Local/Perplexity/`
- `AppData/Local/Ace/`
- `AppData/Local/Wondershare/`
- `AppData/Local/NVIDIA/`
- `AppData/Local/da-desktop-updater/`
- `CrossDevice/`
- `OneDrive/`
- `AppData/Local/Programs/`
- `AppData/Roaming/sh.voicebox.app/`
- `AppData/Roaming/vowen/`
- `AppData/Local/puccinialin/`

### Important discovery during backup tuning

The major accidental underliers were:

- `CrossDevice/` at about `202 GB`
- `OneDrive/` at about `22 GB`
- `.ollama` at about `56 GB`
- `AppData\Local\wsl` at about `45.5 GB`

The biggest unexpected surprise was:

- Kopia was traversing `CrossDevice/Pixel 9 Pro XL/...` and backing up WhatsApp/DCIM phone media through Windows device mirroring

Excluding `CrossDevice/` fixed that.

### `AppData\Local\Programs` review

It was inspected directly and judged safe to exclude for now.

Largest folders there were mostly reinstallable binaries:

- Ollama
- Python
- Microsoft VS Code
- Antigravity
- Antigravity IDE
- Opera Air
- Bitwarden
- signal-desktop
- Otter
- KopiaUI
- Linear
- Zed
- Canva
- Notion
- Obsidian
- Perplexity

Conclusion:

- excluding `AppData/Local/Programs/` is fine for now
- add back later only if rebuild convenience matters more than repo size

### Current Kopia status

- `L:\` snapshot was healthy around `31.6 GB`
- `C:\Users\larry` was reduced from chaotic `80 GB+` partial/canceled runs to about `46 GB`
- some remaining errors were normal locked-file issues such as:
  - `.codex\tmp\...lock`
  - `AppData\Local\Comms\UnistoreDB\...`

Suggested optional future excludes for noise reduction:

- `.codex/tmp/`
- `AppData/Local/Comms/`

## Hermes State Before Hardening

From prior validated handoff and live checks:

- Hermes install should be treated as working, not catastrophically broken
- Known sandbox-only symptom still reproduced:
  - `uv trampoline failed to spawn Python child process`
  - inside Codex sandbox only
- Unsandboxed Hermes commands worked

Live verified state during this chat:

- `hermes status` worked unsandboxed
- provider:
  - OpenRouter
- model:
  - `anthropic/claude-opus-4.6`
- terminal backend:
  - `local`
- Telegram:
  - configured
- WhatsApp:
  - configured
- gateway:
  - running
- desktop connection mode:
  - `local`

## Hermes Hardening Completed

### Backups created before changes

Created timestamped backups of:

- `C:\Users\larry\.hermes\config.yaml`
- `C:\Users\larry\.hermes\.env`

Timestamp used:

- `20260621-025847`

### Config migration

Ran:

```powershell
hermes doctor --fix
```

Result:

- config migrated cleanly from `v0` to `v30`

### Post-migration notes

New schema/defaults were seeded, including:

- curator defaults
- auxiliary curator defaults
- modern config versioning
- security defaults such as:
  - `security.redact_secrets: true`
  - `security.tirith_enabled: true`

### WhatsApp hardening

Before:

```text
WHATSAPP_ALLOWED_USERS=*
```

After:

```text
WHATSAPP_ALLOWED_USERS=19704203617
```

This locks WhatsApp to the user's primary number:

- `970-420-3617`

Stored in digits-only E.164-like format with country code:

- `19704203617`

### Remaining Hermes warnings after hardening

Not treated as urgent blockers:

- WhatsApp bridge npm vulnerabilities
- ui-tui workspace npm advisory
- missing optional auth/API providers
- skills hub not initialized

### Important live Hermes note

Gateway state later showed:

- Telegram: `connected`
- WhatsApp: `retrying`
- error message:
  - `whatsapp connect timed out after 30s`

This looked like runtime connectivity/state, not install corruption.

## Hermes Alias Cleanup

`hermes doctor` reported orphan alias launchers.

Inspection showed real profiles now are only:

- `codex-worker`
- `commander`

Stale launcher `.bat` files were found in:

- `C:\Users\larry\.local\bin`

Removed:

- `api-designer.bat`
- `apollo.bat`
- `backend-engineer.bat`
- `bridge.bat`
- `builder.bat`
- `data-analyst.bat`
- `devops-engineer.bat`
- `frontend-engineer.bat`
- `researcher.bat`
- `reviewer.bat`
- `security-auditor.bat`

Left intact:

- `codex-worker.bat`
- `commander.bat`

## Startup / Command Center Work

### Existing startup state discovered

Scheduled Tasks already existed:

- `Hermes_Gateway`
- `Hermes_Gateway_apollo`
- `Hermes_Gateway_commander`
- `WSLDashboardTask`

Startup-folder items already included many unrelated apps plus:

- `Ollama.lnk`

Conclusion:

- do not add another giant startup launcher
- better to add a verify/recover script that cooperates with the existing tasks

### Scripts created

Created:

- [Verify-Hermes-Startup.ps1](C:/Users/larry/Documents/Troubleshoot/Verify-Hermes-Startup.ps1)
- [Verify-Hermes-Startup.cmd](C:/Users/larry/Documents/Troubleshoot/Verify-Hermes-Startup.cmd)

Behavior:

- checks Hermes Gateway Scheduled Task
- checks WSLDashboard Scheduled Task
- checks Hermes desktop connection mode
- checks Hermes gateway state JSON
- checks port `9119`
- checks Ollama process
- supports `-Repair` to start tasks if needed

### Verified script output

Observed:

- Hermes Gateway Task: `RUNNING`
- WSLDashboard Task: `READY`
- Desktop Mode: `LOCAL`
- Gateway State: `RUNNING telegram=connected, whatsapp=retrying`
- Dashboard Port `9119`: `LISTENING`
- Ollama Process: `RUNNING`

### Autorun at Windows login

Created Startup shortcut:

- `C:\Users\larry\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Hermes Startup Verify.lnk`

It runs:

- PowerShell hidden
- [Verify-Hermes-Startup.ps1](C:/Users/larry/Documents/Troubleshoot/Verify-Hermes-Startup.ps1)
- with `-Repair`

### Command center folder

User created:

- `C:\Users\larry\Desktop\WorldFoundryInk_CommandCenter`

Created shortcuts there:

- [Hermes Startup Check.lnk](C:/Users/larry/Desktop/WorldFoundryInk_CommandCenter/Hermes%20Startup%20Check.lnk)
- [Hermes Startup Repair.lnk](C:/Users/larry/Desktop/WorldFoundryInk_CommandCenter/Hermes%20Startup%20Repair.lnk)

Intent:

- real scripts live in their proper locations
- command center folder holds clean launcher shortcuts
- this is a temporary lightweight command station

## Known Files Produced In This Chat

- [CODEX-CHANGELOG-2026-06-21-HERMES-KOPIA-COMMANDCENTER-FULL.md](C:/Users/larry/Documents/Troubleshoot/CODEX-CHANGELOG-2026-06-21-HERMES-KOPIA-COMMANDCENTER-FULL.md)
- [Verify-Hermes-Startup.ps1](C:/Users/larry/Documents/Troubleshoot/Verify-Hermes-Startup.ps1)
- [Verify-Hermes-Startup.cmd](C:/Users/larry/Documents/Troubleshoot/Verify-Hermes-Startup.cmd)

Also created shortcuts:

- `C:\Users\larry\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Hermes Startup Verify.lnk`
- `C:\Users\larry\Desktop\WorldFoundryInk_CommandCenter\Hermes Startup Check.lnk`
- `C:\Users\larry\Desktop\WorldFoundryInk_CommandCenter\Hermes Startup Repair.lnk`

## Best Next Step

Open a fresh chat focused on:

- getting local Hermes working again with local models

Suggested first checks in the next chat:

1. Verify which local-model path is desired:
   - Ollama local models
   - WSL-hosted local inference
   - both
2. Check whether Hermes can currently target a local model/provider without disturbing OpenRouter fallback
3. Compare current running local services:
   - Ollama
   - dashboard on `9119`
   - gateway
   - any WSL-hosted model/runtime components
4. Preserve current working remote/OpenRouter path while enabling a local-model lane

## Guardrails For Next Agent

Do not:

- treat the sandbox `uv trampoline` error as proof Hermes is broken
- reinstall Hermes first
- destroy the current OpenRouter-working configuration
- widen WhatsApp allowlist again
- create a second competing startup stack unless there is a clear need

Do:

- assume Hermes is basically working
- preserve:
  - `C:\Users\larry\.hermes`
  - `C:\Users\larry\AppData\Roaming\Hermes\connection.json`
  - current Scheduled Tasks
- use unsandboxed checks for Hermes commands if sandbox still throws `uv trampoline` permission errors
- focus the next session specifically on restoring/validating local-model Hermes behavior
