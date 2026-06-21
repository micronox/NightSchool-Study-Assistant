# Phase 1A — Codex Architecture Review Response + PRD Redlines
**Date:** 2026-06-21
**From:** Codex
**Filed by:** Claude (Cowork) — copied from Codex upload, no modifications
**Original file:** `2026-06-21-075947_phase1_codex_architecture_defense_review.md`
**Status:** ACCEPTED — supersedes Phase 1 plan in PRD v6

---

## Executive Decision

**Do not approve the current Phase 1 launch plan as written.**

**Approve a revised Phase 1A path instead:**

1. Use `HERMES_DESKTOP_USER_DATA_DIR` for NightSchool desktop-state isolation.
2. Use `HERMES_HOME` for NightSchool config/log/profile isolation.
3. Reuse the existing Hermes agent code root with: `HERMES_DESKTOP_HERMES_ROOT=`$USER_HOME\.hermes\hermes-agent`
4. Require the primary Hermes desktop to be fully closed before NightSchool launch.
5. Do **not** let NightSchool perform a fresh first-launch bootstrap into `$USER_HOME\.hermes-nightschool\` yet.

---

## Hard Blockers Found

### 1. Two simultaneous Hermes desktop instances are not supported (Q4 = YES)

`electron/main.cjs` takes a single-instance lock (`app.requestSingleInstanceLock()`). Second instance quits immediately.

**Rule:** primary Hermes must be closed before NightSchool is launched.

### 2. Fresh bootstrap into `.hermes-nightschool` is not isolated enough (Q2 = NOT SAFE)

The installer (`scripts/install.ps1`) writes: user PATH, user-scoped `HERMES_HOME`, Git/PortableGit, Node, repo download/clone, Python packages. These are user-level mutations — a Lane F violation.

**Rule:** do not allow NightSchool to trigger first-launch bootstrap until this installer path is deliberately neutralized or replaced.

### 3. Port 9119 / fixed-port assumption is stale (Q1 — closed)

Current desktop uses ephemeral port (`--port 0`). OS assigns at runtime; app waits for `HERMES_DASHBOARD_READY port=<N>`. `connection.json` is connection mode config, not authoritative for local port selection.

**Rule:** do not use "set port to 8100 instead of 9119" as the isolation mechanism.

---

## Q1–Q5 Answers (summary)

| Q | Answer |
|---|---|
| Q1 — Port conflict | Ephemeral port, not fixed 9119. Port conflict is NOT the main blocker. |
| Q2 — Bootstrap isolation | NOT safe. Writes to user PATH and user HERMES_HOME. Defer bootstrap. |
| Q3 — Reuse existing agent binary | YES. Use `HERMES_DESKTOP_HERMES_ROOT` to reuse `~/.hermes/hermes-agent`. |
| Q4 — Single-instance lock | YES. Only one Hermes desktop at a time. Sequential operation required. |
| Q5 — Lane F tripwires sufficient | NO. Seven tripwires required (see below). |

---

## Approved Phase 1A Configuration

| Variable | Approved NightSchool value | Notes |
|---|---|---|
| `HERMES_DESKTOP_USER_DATA_DIR` | `$APPDATA_ROAMING_ROOT\Hermes-NightSchool` | Separate Electron state |
| `HERMES_HOME` | `$USER_HOME\.hermes-nightschool` | Separate NightSchool data/log/config root |
| `HERMES_DESKTOP_HERMES_ROOT` | `$USER_HOME\.hermes\hermes-agent` | Reuse existing agent code/venv — avoid bootstrap |
| `Hermes.exe` | `$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe` | Shared binary |

## Explicit Non-Goals for Phase 1A

- no second concurrent Hermes desktop
- no fresh NightSchool agent clone
- no NightSchool installer bootstrap
- no update/uninstall actions from the NightSchool lane

---

## Approved Launch Script

**Old script (`launch_hermes_nightschool.ps1`):** NOT approved.
**Approved replacement:** `scripts/launch_hermes_nightschool_safe_reuse.ps1`

The approved script:
- blocks if primary Hermes is running
- sets all three env vars per-process only (never user-wide)
- clears `HERMES_DESKTOP_REMOTE_URL` and `HERMES_DESKTOP_REMOTE_TOKEN`
- creates `Hermes-NightSchool\`, `.hermes-nightschool\logs\`, `sessions\`, `memories\`
- prints post-launch verification checklist

---

## Lane F Tripwires (expanded — Q5 answer)

| # | Tripwire |
|---|---|
| T1 | Primary Hermes desktop process must be closed before NightSchool launch |
| T2 | NightSchool must not perform fresh first-launch bootstrap under `.hermes-nightschool` |
| T3 | NightSchool must pin `HERMES_DESKTOP_HERMES_ROOT` to the existing shared agent code root |
| T4 | NightSchool must not use update/uninstall flows while sharing the agent code root |
| T5 | User-scoped `HERMES_HOME` and user PATH must remain unchanged after NightSchool launch |
| T6 | NightSchool environment must not inherit `HERMES_DESKTOP_REMOTE_URL` or `HERMES_DESKTOP_REMOTE_TOKEN` |
| T7 | NightSchool `userData` path must remain distinct from primary Hermes `userData` |

---

## Phase 1A Verification Cards (from Codex)

1. Validate NightSchool launcher blocks when primary Hermes is open.
2. Launch NightSchool with isolated userData and HERMES_HOME while reusing shared agent code root.
3. Confirm `Hermes-NightSchool\connection.json` is created without mutating primary `connection.json`.
4. Confirm user PATH and user-scoped `HERMES_HOME` remain unchanged after launch.
5. Confirm NightSchool log/config/session writes land under `.hermes-nightschool\`.
6. Record Lane F note: update/uninstall actions forbidden in shared-code Phase 1A lane.

---

## Go / No-Go

### No-go
- current launch script as written
- simultaneous primary + NightSchool Hermes desktops
- fresh NightSchool bootstrap into a new `.hermes-nightschool` root

### Go
- revised sequential NightSchool lane
- shared binary + shared existing agent code root
- isolated userData + isolated HERMES_HOME
- explicit Lane F guardrails (7 tripwires)


