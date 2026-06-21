# Architecture Defense — Full Context

- Date: 2026-06-21
- Time: 08:54:34 America/Chicago
- Scope: NightSchool Phase 1A architecture defense, context shaping, Hermes isolation, and Kopia Lane F review
- Intended next home: `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs\`

## Current operating reality

- This work is no longer in troubleshooting mode.
- The correct project home for ongoing NightSchool work is:
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles`
- Architecture-defense artifacts should now be logged under:
  - `L:\WSL_Projects_Folder\Architecture_Defense\`
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs\`
- Timestamped filenames are now the standard:
  - `YYYY-MM-DD-HHMMSS_<slug>`
  - local time basis: America/Chicago / Austin, TX local time

## Claude availability / routing

- Claude is near or at session limits.
- User plans to use Hermes with `Nemotron 3 Super 120b A12b:Free` for peer review because it is already loaded and waiting.
- Claude is rewriting older notes to include full timestamps to reduce context loss.

## Hermes / NightSchool Phase 1A conclusions

- The original “second isolated Hermes desktop instance” plan is **not approved as written**.
- The approved near-term shape is **Phase 1A**:
  - shared `Hermes.exe` binary
  - separate `HERMES_DESKTOP_USER_DATA_DIR`
  - separate `HERMES_HOME`
  - reuse existing Hermes agent code root via `HERMES_DESKTOP_HERMES_ROOT`
  - sequential lane only, not simultaneous with primary Hermes
  - no fresh NightSchool bootstrap into `.hermes-nightschool` yet

## Why Phase 1A changed

- Hermes desktop uses Electron single-instance locking.
- A second live desktop process is not supported in the current code path.
- The bootstrap/install path is not Lane F-clean for a fresh NightSchool install because it persists user-scoped environment changes:
  - user PATH writes
  - user `HERMES_HOME` writes
- The desktop’s current local backend path uses an ephemeral local port (`--port 0`), so `9119` should not be treated as the core local-isolation mechanism.

## Approved Phase 1A runtime values

- `HERMES_DESKTOP_USER_DATA_DIR`
  - `C:\Users\larry\AppData\Roaming\Hermes-NightSchool`
- `HERMES_HOME`
  - `C:\Users\larry\.hermes-nightschool`
- `HERMES_DESKTOP_HERMES_ROOT`
  - `C:\Users\larry\.hermes\hermes-agent`
- shared binary
  - `C:\Users\larry\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe`

## Phase 1A non-negotiable guardrails

- Primary Hermes desktop must be closed before NightSchool launch.
- NightSchool must not trigger first-launch bootstrap into `.hermes-nightschool`.
- Update/uninstall flows must not be used from the shared-code Phase 1A lane.
- NightSchool restore or rollback actions must not target primary Hermes paths.

## Files created for Phase 1A review

- Codex architecture review:
  - `L:\WSL_Projects_Folder\Architecture_Defense\2026-06-21-075947_phase1_codex_architecture_defense_review.md`
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21-075947_phase1_codex_architecture_defense_review.md`
- Safe launcher draft:
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\scripts\2026-06-21-075947_launch_hermes_nightschool_safe_reuse.ps1`

## Safe launcher status

- Kopia is now on user PATH and verified.
- The launcher draft exists but has **not** yet been updated to auto-trigger Kopia baseline snapshots.
- The launcher should remain sequential and defensive.

## Kopia / Lane F conclusions

- Repository status is confirmed and connected:
  - repository path: `E:\KopiaRepo`
  - config file: `C:\Users\larry\AppData\Roaming\kopia\repository.config`
- Installed CLI path:
  - `C:\Users\larry\AppData\Local\Programs\KopiaUI\resources\server\kopia.exe`
- `kopia` is now on user PATH and resolves in shell.

## Claude Kopia spec reviewed

- Source spec:
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21_kopia_lane_f_spec.md`
- Codex addendum answering open questions:
  - `L:\WSL_Projects_Folder\Architecture_Defense\2026-06-21-081000-kopia-lane-f-codex-answers.md`
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21-081000-kopia-lane-f-codex-answers.md`

## Kopia answers resolved

### CK-Q1

- Overlapping roots are acceptable at the repository/content level.
- The real risk is policy inheritance from parent policies.
- NightSchool-related policies must be explicit per-path policies, not left to broad parent defaults.

### CK-Q2

- Restore is target-path scoped.
- Kopia will not silently “escape” from a NightSchool path into primary Hermes paths on its own.
- The real risk is operator-selected restore destination.
- Best practice:
  - restore to a scratch/inspection path first
  - only then restore in place if needed

### CK-Q5

- Pre-launch baseline snapshots can be triggered directly with explicit path-scoped CLI calls.
- Approved command pattern:

```powershell
& "C:\Users\larry\AppData\Local\Programs\KopiaUI\resources\server\kopia.exe" snapshot create --description "Lane F pre-launch baseline: primary Hermes userData" --tags lanef:baseline --tags scope:primary-hermes --tags kind:userdata --json "C:\Users\larry\AppData\Roaming\Hermes"

& "C:\Users\larry\AppData\Local\Programs\KopiaUI\resources\server\kopia.exe" snapshot create --description "Lane F pre-launch baseline: primary Hermes home" --tags lanef:baseline --tags scope:primary-hermes --tags kind:home --json "C:\Users\larry\.hermes"
```

## Recommended next move in new chat

1. Resume from `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles`.
2. Feed Hermes / Nemotron Super these files in order:
   - `2026-06-21_kopia_lane_f_spec.md`
   - `2026-06-21-081000-kopia-lane-f-codex-answers.md`
   - `2026-06-21-075947_phase1_codex_architecture_defense_review.md`
3. Have frontier peer-review:
   - Phase 1A Hermes isolation shape
   - Kopia Lane F shape
   - PRD / isolation manifest redlines
4. After frontier review:
   - update PRD
   - update `isolation_manifest.md`
   - update safe launcher with Kopia pre-launch snapshot triggers
   - keep all new logs in the project-side handoff and Architecture_Defense folders

## Context-shaping rules to carry forward

- Use timestamped filenames everywhere.
- Log architecture-defense artifacts in the project tree, not Troubleshoot.
- Keep Troubleshoot as historical provenance only.
- Treat NightSchool `Prototype_workingFiles` as the active continuity chain.
- Prefer explicit path-scoped automation over broad defaults.
- Continue frontier-first reasoning:
  - Nemotron Super default
  - Nemotron Ultra escalation
  - local/Qwen only as fallback or mechanical lane

## Final state at handoff

- Phase 1A architecture shape is substantially defined.
- Kopia Lane F shape is substantially defined.
- Kopia CLI is usable now.
- The next conversation should move onto `L:\...` and continue from the project-side handoff chain rather than Troubleshoot.

