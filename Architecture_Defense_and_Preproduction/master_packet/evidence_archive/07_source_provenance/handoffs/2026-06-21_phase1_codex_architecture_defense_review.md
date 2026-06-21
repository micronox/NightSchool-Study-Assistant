# Phase 1 — Codex Architecture Defense Review
**Date:** 2026-06-21  
**From:** Codex  
**To:** Claude / Lane F / PRD update pass  
**Status:** Drafted for review

---

## Executive Decision

**Do not approve the current Phase 1 launch plan as written.**

**Approve a revised Phase 1A path instead:**

1. Use `HERMES_DESKTOP_USER_DATA_DIR` for NightSchool desktop-state isolation.
2. Use `HERMES_HOME` for NightSchool config/log/profile isolation.
3. Reuse the existing Hermes agent code root with:
   - `HERMES_DESKTOP_HERMES_ROOT=C:\Users\larry\.hermes\hermes-agent`
4. Require the primary Hermes desktop to be fully closed before NightSchool launch.
5. Do **not** let NightSchool perform a fresh first-launch bootstrap into `C:\Users\larry\.hermes-nightschool\` yet.

This keeps the binary shared, keeps writable NightSchool state separate, and avoids the installer path that currently mutates user-scoped environment settings.

---

## Hard Blockers Found

### 1. Two simultaneous Hermes desktop instances are not supported

`electron/main.cjs` takes a single-instance lock:

- `app.requestSingleInstanceLock()`
- if the second instance fails the lock, it quits immediately

**Architectural impact:** NightSchool cannot be treated as a second concurrently-running Hermes desktop lane. It must be a **sequential alternate profile lane**.

**Phase 1 rule:** primary Hermes must be closed before NightSchool is launched.

---

### 2. Fresh bootstrap into `.hermes-nightschool` is not isolated enough

The desktop bootstrap runner executes the installer manifest stage-by-stage. The installer includes a `path` stage that persists user-level environment changes:

- user PATH writes
- user-scoped `HERMES_HOME` write

Relevant install behavior observed in `scripts/install.ps1`:

- writes user PATH
- writes user `HERMES_HOME`
- persists additional PATH/Git settings in earlier prereq stages

**Architectural impact:** a clean bootstrap under `C:\Users\larry\.hermes-nightschool` would not remain Lane F-clean. It can rewrite Larry's user-level Hermes defaults.

**Phase 1 rule:** do not allow the NightSchool lane to trigger first-launch bootstrap until this installer path is deliberately neutralized or replaced.

---

### 3. The current port assumption is stale

The current desktop local-backend path does **not** use a fixed local port from `connection.json`.

Observed behavior in `electron/main.cjs`:

- local backend is started with `dashboard --host 127.0.0.1 --port 0`
- the OS assigns an ephemeral port
- the desktop waits for `HERMES_DASHBOARD_READY port=<N>`
- the desktop then connects to that runtime-assigned port

**Architectural impact:** `connection.json` is still important, but in current desktop behavior it acts as a local-vs-remote configuration layer, not the authoritative source of a fixed local port like `9119`.

**Phase 1 rule:** do not use “set NightSchool to port 8100 instead of 9119” as the main local-isolation mechanism.

---

## Revised Approved Phase 1 Shape

### Approved interpretation

NightSchool Phase 1 should now mean:

- one shared `Hermes.exe` binary
- one shared existing Hermes agent code root
- separate NightSchool desktop `userData`
- separate NightSchool `HERMES_HOME`
- no simultaneous primary + NightSchool desktop sessions
- no NightSchool bootstrap-driven clone/install yet

### Approved isolation values

| Variable | Approved NightSchool value | Notes |
|---|---|---|
| `HERMES_DESKTOP_USER_DATA_DIR` | `C:\Users\larry\AppData\Roaming\Hermes-NightSchool` | Separate Electron state |
| `HERMES_HOME` | `C:\Users\larry\.hermes-nightschool` | Separate NightSchool data/log/config root |
| `HERMES_DESKTOP_HERMES_ROOT` | `C:\Users\larry\.hermes\hermes-agent` | Reuse existing agent code/venv, avoid bootstrap |
| `Hermes.exe` | `C:\Users\larry\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe` | Shared binary |

### Explicit non-goals for this phase

- no second concurrent Hermes desktop
- no fresh NightSchool agent clone
- no NightSchool installer bootstrap
- no update/uninstall actions from the NightSchool lane

---

## Q1–Q5 Answers

### Q1 — Port conflict

**Answer:** the current local desktop path uses an ephemeral port, not a fixed `9119` bind.

`9119` still appears in the primary `connection.json`, but that is best understood as the saved connection mode/config record, not proof that the current local desktop backend is hard-bound there in the present codepath.

**Decision:** port conflict is **not** the main blocker for local NightSchool launch. The singleton lock and unsafe bootstrap path are the real blockers.

---

### Q2 — Will `HERMES_HOME` isolation work end-to-end?

**Answer:** not safely if NightSchool is allowed to perform the normal first-launch bootstrap.

Bootstrap/install currently writes:

- under `HERMES_HOME`
- under `%TEMP%`
- user PATH
- user `HERMES_HOME`
- other user-scoped environment helpers

It also performs network fetches for:

- install scripts
- Git/PortableGit
- Node
- repo download/clone
- Python/package provisioning

**Decision:** `HERMES_HOME` isolation is fine as a runtime boundary, but **not yet sufficient as a fresh-bootstrap boundary**.

---

### Q3 — Can NightSchool reuse the existing agent install?

**Answer:** yes, and this is the safest near-term unblock.

The desktop supports an explicit backend code-root override:

- `HERMES_DESKTOP_HERMES_ROOT`

That lets NightSchool:

- keep separate `userData`
- keep separate `HERMES_HOME`
- reuse the existing agent code/venv
- avoid the unsafe bootstrap path

**Decision:** this should be the preferred Phase 1A launch design.

---

### Q4 — Two simultaneous Hermes instances

**Answer:** not supported for the desktop app.

Reason:

- single-instance lock in `main.cjs`

`safeStorage` is not the primary blocker here. The more important fact is that the second desktop process will not stay alive as a separate interactive lane.

**Decision:** NightSchool desktop lane must be sequential, not concurrent.

---

### Q5 — Are the current Lane F tripwires sufficient?

**Answer:** no. They need expansion.

Add these required Lane F tripwires:

1. Primary Hermes desktop process must be closed before NightSchool launch.
2. NightSchool must not perform fresh first-launch bootstrap under `.hermes-nightschool`.
3. NightSchool must explicitly pin `HERMES_DESKTOP_HERMES_ROOT` to the existing shared agent code root during Phase 1A.
4. NightSchool must not use update/uninstall flows while sharing the agent code root.
5. User-scoped `HERMES_HOME` and user PATH must remain unchanged after NightSchool validation launch.
6. NightSchool environment must not inherit `HERMES_DESKTOP_REMOTE_URL` or `HERMES_DESKTOP_REMOTE_TOKEN`.
7. NightSchool `userData` path must remain distinct from primary Hermes `userData`.

---

## Launch Script Approval Status

### Current script

**Not approved** as-is.

Why:

- allows a path that can trigger unsafe bootstrap
- does not block when primary Hermes is already running
- does not pin shared-code reuse explicitly

### Approved replacement strategy

Use the draft launcher at:

[2026-06-21-launch-hermes-nightschool-safe-reuse.ps1](C:/Users/larry/Documents/Troubleshoot/handoff/2026-06-21-launch-hermes-nightschool-safe-reuse.ps1)

This draft:

- blocks if primary Hermes is still running
- pins separate `userData`
- pins separate `HERMES_HOME`
- pins `HERMES_DESKTOP_HERMES_ROOT` to the existing agent checkout
- clears remote override env vars
- avoids the bootstrap-first design assumption

---

## Proposed Phase 1 PRD Redlines For Claude

### Replace the current Phase 1 launch interpretation with this

**Phase 1A — Sequential NightSchool Hermes lane (approved path)**

- NightSchool Phase 1 uses the existing Hermes desktop binary and the existing Hermes agent code root.
- Isolation is achieved by:
  - `HERMES_DESKTOP_USER_DATA_DIR`
  - `HERMES_HOME`
  - `HERMES_DESKTOP_HERMES_ROOT`
- The NightSchool desktop lane is sequential only. Primary Hermes must be closed before launch.
- Fresh first-launch bootstrap under `C:\Users\larry\.hermes-nightschool\` is deferred because the current installer persists user-level environment changes and is not yet Lane F-clean.
- Update/uninstall flows are forbidden while Phase 1A shares the primary agent code root.

### Replace the old fixed-port assumption with this

- Current desktop local backend launch uses an ephemeral OS-assigned port (`--port 0`), not a fixed `9119` bind in the active local codepath.
- `connection.json` remains part of connection mode/config state, but is not the primary mechanism for local port isolation in Phase 1A.

### Add these Phase 1 verification cards

1. Validate NightSchool launcher blocks when primary Hermes is open.
2. Launch NightSchool with isolated `userData` and isolated `HERMES_HOME` while reusing the shared agent code root.
3. Confirm `C:\Users\larry\AppData\Roaming\Hermes-NightSchool\connection.json` is created or updated without mutating primary Hermes `connection.json`.
4. Confirm user PATH and user-scoped `HERMES_HOME` remain unchanged after launch.
5. Confirm NightSchool log/config/session writes land under `C:\Users\larry\.hermes-nightschool\`.
6. Record a Lane F note that update/uninstall actions are forbidden in the shared-code Phase 1A lane.

---

## Go / No-Go

### No-go

- current launch script as written
- simultaneous primary + NightSchool Hermes desktops
- fresh NightSchool bootstrap into a new `.hermes-nightschool` root

### Go

- revised sequential NightSchool lane
- shared binary
- shared existing agent code root
- isolated `userData`
- isolated `HERMES_HOME`
- explicit Lane F guardrails

