# Hermes Hardening Runbook

- Date: 2026-06-21
- Purpose: protect the working Hermes install and avoid cross-contaminating it with other Python projects

## Current Safe State

- Hermes backup created:
  - `C:\Users\larry\hermes-backup-2026-06-21-010944.zip`
- Hermes status snapshot:
  - Project: `C:\Users\larry\.hermes\hermes-agent`
  - Python: `3.11.15`
  - Model: `anthropic/claude-opus-4.6`
  - Provider: `OpenRouter`
  - Gateway: running
  - Telegram: configured
  - WhatsApp: configured

## Paths To Protect

- Hermes home:
  - `C:\Users\larry\.hermes`
- Hermes repo:
  - `C:\Users\larry\.hermes\hermes-agent`
- Hermes Python:
  - `C:\Users\larry\.hermes\hermes-agent\venv\Scripts\python.exe`
- Hermes CLI:
  - `C:\Users\larry\.hermes\hermes-agent\venv\Scripts\hermes.exe`
- Hermes-managed uv:
  - `C:\Users\larry\.hermes\bin\uv.exe`
- uv-managed base Python:
  - `C:\Users\larry\AppData\Roaming\uv\python\cpython-3.11-windows-x86_64-none\python.exe`

## Working Rule

Never install unrelated tools into the Hermes environment.

If a repo is not Hermes, it gets its own local `.venv`.

## Why The SkillSpector Install Went Sideways

- The README command used Bash syntax:
  - `source .venv/bin/activate`
- That is valid in Bash/WSL/Linux/macOS.
- It is not the correct activation command for Windows PowerShell.
- If pasted into PowerShell, `cd` works, then activation fails, and follow-up commands can run in the wrong shell context.

## Safe Install Pattern For Future Python Repos

Use this in Windows PowerShell:

```powershell
cd <repo-folder>
uv venv .venv
.\.venv\Scripts\Activate.ps1
```

Then install the project inside that repo's own environment.

If the project says to use `make`, only do that after the repo-local `.venv` is active.

## Bash vs PowerShell Activation

PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

Bash / WSL:

```bash
source .venv/bin/activate
```

## SkillSpector Notes

- Repo location:
  - `L:\WSL\SkillSpector\skillspector`
- The repo currently looks like source code only.
- No repo-local `.venv` was found there during inspection.
- SkillSpector requires Python `>=3.12,<3.15`.
- Hermes is on Python `3.11.15`.
- Conclusion:
  - SkillSpector should be installed later in its own isolated Python 3.12+ environment.
  - Do not try to install SkillSpector into Hermes.

## If Hermes Ever Needs Restore

```powershell
hermes import C:\Users\larry\hermes-backup-2026-06-21-010944.zip
```

## Next Safety Rule

Before pasting install steps from a README:

1. Check whether the commands are for Bash or PowerShell.
2. Check the required Python version.
3. Create a repo-local `.venv`.
4. Never run project install commands from inside the Hermes repo.
