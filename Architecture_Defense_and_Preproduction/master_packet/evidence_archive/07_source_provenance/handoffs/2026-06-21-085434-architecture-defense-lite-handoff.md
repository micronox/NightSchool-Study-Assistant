# Lite Handoff — Architecture Defense / Context Shaping

- Date: 2026-06-21
- Time: 08:54:34 America/Chicago
- Purpose: reset-ready handoff for continuing NightSchool outside Troubleshoot

## Current stable facts

- Active project home is now:
  - `$PROJECTS_ROOT\Nightschool_Study\Prototype_workingFiles`
- Architecture-defense logging should now live under:
  - `$PROJECTS_ROOT\Architecture_Defense`
  - `$PROJECTS_ROOT\Nightschool_Study\Prototype_workingFiles\handoffs`
- Timestamped filenames are now standard:
  - `YYYY-MM-DD-HHMMSS_<slug>`
- Discord shape is now approved:
  - one master guild: `WorldFoundryInk`
  - NightSchool lives inside it as a `[NightSchool]` category
  - category-level permission inheritance is the real isolation boundary
  - do not give the NightSchool bot Administrator
  - if posting fails, inspect category/channel overwrites before widening role scope

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
  - `$KOPIA_REPO`
- Kopia CLI path:
  - `$APPDATA_LOCAL_ROOT\Programs\KopiaUI\resources\server\kopia.exe`
- `kopia` has been added to user PATH and verified.
- Claude’s Kopia spec has Codex answers for CK-Q1, CK-Q2, and CK-Q5.

## Most important files

- Phase 1A architecture review:
  - `$PROJECTS_ROOT\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21-075947_phase1_codex_architecture_defense_review.md`
- Safe launcher draft:
  - `$PROJECTS_ROOT\Nightschool_Study\Prototype_workingFiles\scripts\2026-06-21-075947_launch_hermes_nightschool_safe_reuse.ps1`
- Claude Kopia spec:
  - `$PROJECTS_ROOT\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21_kopia_lane_f_spec.md`
- Codex Kopia answers:
  - `$PROJECTS_ROOT\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21-081000-kopia-lane-f-codex-answers.md`

## Recommended next action

- Run two Hermes lanes in parallel:
  - Lane 1: stand up `WorldFoundryInk` and shape the `[NightSchool]` category, channels, and scoped bot-role plan
  - Lane 2: continue Phase 1A review and safe-launch preparation from the NightSchool working directory
- Verification remains local:
  - Codex verifies the resulting guild shape against the brief
  - Codex verifies the resulting Phase 1A plan against Lane F constraints

## Suggested Hermes payload split

- Lane 1 — Discord guild architecture:
  - Create or refine the `WorldFoundryInk` master guild plan
  - Treat `[NightSchool]` as one category inside that guild, not a separate server
  - Preserve category-level segregation
  - Use a scoped NightSchool bot role, not Administrator
  - Produce a concrete setup checklist operator can execute
- Lane 2 — Phase 1A execution:
  - Review the safe-reuse launcher and current Phase 1A execution docs
  - Preserve the approved shared-code sequential lane shape
  - No simultaneous Hermes desktops
  - No fresh bootstrap into `.hermes-nightschool`
  - No fixed-port assumptions as the isolation mechanism

## Full continuity

- See full context:
  - `2026-06-21-085434-architecture-defense-full-context.md`


