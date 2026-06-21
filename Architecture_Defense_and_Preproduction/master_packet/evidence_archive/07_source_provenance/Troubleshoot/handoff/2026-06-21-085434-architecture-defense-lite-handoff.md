# Lite Handoff — Architecture Defense / Context Shaping

- Date: 2026-06-21
- Time: 08:54:34 America/Chicago
- Purpose: reset-ready handoff for continuing NightSchool outside Troubleshoot

## Current stable facts

- Active project home is now:
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles`
- Architecture-defense logging should now live under:
  - `L:\WSL_Projects_Folder\Architecture_Defense`
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs`
- Timestamped filenames are now standard:
  - `YYYY-MM-DD-HHMMSS_<slug>`

## Hermes / Phase 1A state

- Approved shape is Phase 1A, not the original isolated-second-instance plan.
- Phase 1A means:
  - shared `Hermes.exe`
  - separate `HERMES_DESKTOP_USER_DATA_DIR`
  - separate `HERMES_HOME`
  - reuse existing Hermes agent code root through `HERMES_DESKTOP_HERMES_ROOT`
  - primary Hermes must be closed before NightSchool launch
  - no fresh bootstrap into `.hermes-nightschool`

## Main reasons

- Hermes desktop is single-instance.
- Fresh bootstrap is not Lane F-clean because it persists user PATH and user `HERMES_HOME`.
- Current local backend path uses ephemeral local ports, so fixed `9119` assumptions are stale.

## Kopia / Lane F state

- Repository is confirmed live at:
  - `E:\KopiaRepo`
- Kopia CLI path:
  - `C:\Users\larry\AppData\Local\Programs\KopiaUI\resources\server\kopia.exe`
- `kopia` has been added to user PATH and verified.
- Claude’s Kopia spec has Codex answers for CK-Q1, CK-Q2, and CK-Q5.

## Most important files

- Phase 1A architecture review:
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21-075947_phase1_codex_architecture_defense_review.md`
- Safe launcher draft:
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\scripts\2026-06-21-075947_launch_hermes_nightschool_safe_reuse.ps1`
- Claude Kopia spec:
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21_kopia_lane_f_spec.md`
- Codex Kopia answers:
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21-081000-kopia-lane-f-codex-answers.md`

## Recommended next action

- Start the new chat from `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles`
- Use Hermes with Nemotron Super to peer-review:
  - Claude’s Kopia spec
  - Codex’s Kopia answers
  - Codex’s Phase 1A architecture review
- Then update:
  - PRD
  - `isolation_manifest.md`
  - safe launcher script

## Full continuity

- See full context:
  - `2026-06-21-085434-architecture-defense-full-context.md`

