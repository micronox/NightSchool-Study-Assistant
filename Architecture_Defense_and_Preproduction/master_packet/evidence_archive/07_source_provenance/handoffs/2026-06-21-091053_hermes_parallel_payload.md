# Hermes Parallel Payload — WorldFoundryInk + Phase 1A

- Date: 2026-06-21
- Time: 09:10:53 America/Chicago
- Purpose: compact payload for two parallel Hermes sessions that minimizes Codex usage while preserving Lane F guardrails

## Shared ground truth

- Active working root:
  - `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles`
- Approved Discord shape:
  - one master guild: `WorldFoundryInk`
  - NightSchool belongs inside it as a `[NightSchool]` category
  - category-level permission inheritance is the real segregation mechanism
  - do not give the NightSchool bot Administrator
  - if posting fails, inspect category/channel overwrites before widening role scope
- Approved Hermes shape:
  - Phase 1A is sequential, not concurrent
  - shared `Hermes.exe`
  - separate `HERMES_DESKTOP_USER_DATA_DIR`
  - separate `HERMES_HOME`
  - shared code root via `HERMES_DESKTOP_HERMES_ROOT`
  - no fresh bootstrap into `.hermes-nightschool`
  - no updater/uninstall actions from the shared-code lane

## Lane 1 — Discord / Guild architecture

### Goal

- Shape `WorldFoundryInk` as the umbrella company guild and make `[NightSchool]` the first project category under it.

### Required outputs

- A concrete channel/category layout for `WorldFoundryInk`
- A scoped permission model for the NightSchool bot
- A short Larry checklist for what to click in Discord and the Developer Portal
- A note on how Codex, Claude, Hermes, and future projects can each map to categories or roles later without breaking segregation

### Non-negotiables

- `[NightSchool]` is a category, not a separate server
- category-level permission inheritance is the main boundary
- no Administrator permission for the NightSchool bot
- if the bot cannot post, solve that at the category/channel overwrite layer

### Suggested minimum category layout

```text
WorldFoundryInk
  [NightSchool]
    #ns-vault
    #ns-scholar
    #ns-quizmaster
    #ns-planner
    #ns-dev
    #ns-controller
```

### Verification target for Codex

- The plan preserves one master guild plus category-per-project segregation
- The bot role is scoped only to the NightSchool category and avoids Administrator

## Lane 2 — Phase 1A execution review

### Goal

- Advance NightSchool Phase 1A safely from the current brief set without changing the approved architecture shape.

### Required outputs

- A validation pass on the safe-reuse launcher
- A concise runbook for the first controlled NightSchool launch
- A short list of exactly what Larry should verify after launch

### Non-negotiables

- no simultaneous primary + NightSchool Hermes desktop sessions
- no fresh bootstrap into `.hermes-nightschool`
- no fixed-port assumption as the isolation mechanism
- preserve `HERMES_DESKTOP_HERMES_ROOT = C:\Users\larry\.hermes\hermes-agent`
- primary Hermes must be closed before launch

### Key files

- `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\scripts\2026-06-21-075947_launch_hermes_nightschool_safe_reuse.ps1`
- `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21-032213_phase1A_execution_spec.md`
- `L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\isolation_manifest.md`

### Verification target for Codex

- The runbook keeps Phase 1A sequential and shared-code
- The checks focus on path isolation and unchanged primary state, not on forcing a custom fixed local port

## Best parallel split

- Hermes Session A:
  - own the `WorldFoundryInk` guild planning and setup checklist
- Hermes Session B:
  - own the Phase 1A launcher/runbook review

These are safe to run in parallel because one is Discord architecture and the other is NightSchool launch prep. The actual NightSchool desktop launch itself remains sequential and still requires the primary Hermes desktop to be closed.
