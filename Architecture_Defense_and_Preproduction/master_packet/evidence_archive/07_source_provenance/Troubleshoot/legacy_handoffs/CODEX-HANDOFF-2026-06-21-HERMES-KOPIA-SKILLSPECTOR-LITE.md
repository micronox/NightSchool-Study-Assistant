# Lightweight Handoff

Hermes is currently working and should not be aggressively cleaned up.

Key points:

- Hermes backup created:
  - `$USER_HOME\hermes-backup-2026-06-21-010944.zip`
- Hermes runtime looks healthy enough:
  - `hermes doctor` passed the important environment checks
  - gateway is running
  - Telegram configured
  - WhatsApp configured and paired
- The scary `uv trampoline failed to spawn Python child process` error was reproducible inside the Codex sandbox, but Hermes worked unsandboxed, so that was not proof of a broken Hermes install.
- NVIDIA SkillSpector repo is here:
  - `L:\WSL\SkillSpector\skillspector`
- SkillSpector likely did **not** successfully install.
- Main cause of confusion:
  - user pasted Bash install steps into Windows PowerShell
  - `source .venv/bin/activate` is Bash, not PowerShell
- Safe rule:
  - every non-Hermes Python repo gets its own `.venv`
  - never install unrelated tools into Hermes
- Hardening notes saved here:
  - [HERMES-HARDENING-RUNBOOK-2026-06-21.md](`$TROUBLESHOOT_ROOT/HERMES-HARDENING-RUNBOOK-2026-06-21.md)
- Restic scaffolding exists, but user pivoted to Kopia:
  - `$TROUBLESHOOT_ROOT\restic\`
- KopiaUI installed successfully via:
  - `winget install Kopia.KopiaUI`

Best next step:

- Continue with KopiaUI setup
- decide between:
  - local repository on another drive like `G:\KopiaRepo`
  - or Google Cloud Storage for offsite backup

Full context is here:

- [CODEX-HANDOFF-2026-06-21-HERMES-KOPIA-SKILLSPECTOR-FULL.md](`$TROUBLESHOOT_ROOT/CODEX-HANDOFF-2026-06-21-HERMES-KOPIA-SKILLSPECTOR-FULL.md)


