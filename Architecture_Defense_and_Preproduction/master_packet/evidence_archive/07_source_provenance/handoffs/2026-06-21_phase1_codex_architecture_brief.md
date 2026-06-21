# Phase 1 — Architecture Defense Brief for Codex Review
**Date:** 2026-06-21
**From:** Claude (Cowork)
**To:** Codex (Architecture Defense / Lane F review)
**Re:** Hermes profile isolation discovery — approval requested before Phase 1 launch

---

## Context

NightSchool requires an isolated Hermes desktop instance separate from operator's primary Hermes install. The Phase 1 decision (confirmed by operator) is Option A: Electron-style profile separation using the same binary with isolated state directories — not a second pip/npm/venv install.

This brief summarizes the discovery findings and asks Codex to:
1. Review and approve (or flag) the isolation architecture
2. Confirm the Lane F tripwires are sufficient
3. Approve the launch script before first execution

---

## Discovery Summary

### Hermes Install Surface (read-only inspection, no mutations)

| Item | Value |
|---|---|
| Exe path | `$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe` |
| Internal version | `0.15.1` (package.json inside app.asar); installer label: `0.5.6` |
| App framework | Electron + Chromium (confirmed: `LICENSE.electron.txt`, Chromium HTML, standard Electron binary layout) |
| App entry point | `electron/main.cjs` (inside `resources/app.asar`) |
| Inspection method | Extracted `main.cjs`, `backend-env.cjs`, `bootstrap-runner.cjs` from `app.asar` via Python struct parsing — read-only |

---

## Isolation Mechanism — Two Env Vars (source-confirmed)

### Lever 1: `HERMES_DESKTOP_USER_DATA_DIR`

**Source:** `electron/main.cjs` lines 112–116 (from app.asar):
```javascript
const USER_DATA_OVERRIDE = process.env.HERMES_DESKTOP_USER_DATA_DIR
if (USER_DATA_OVERRIDE) {
  const resolvedUserData = path.resolve(USER_DATA_OVERRIDE)
  fs.mkdirSync(resolvedUserData, { recursive: true })
  app.setPath('userData', resolvedUserData)
}
```

**Effect:** Calls Electron's `app.setPath('userData', ...)` — the canonical Electron API for redirecting all user data. This runs **before** any other app code reads config paths. Every subsequent `app.getPath('userData')` call in the app returns the overridden path.

**Files affected (all move to the new path):**
- `connection.json` — which endpoint the desktop connects to
- `active-profile.json` — which Hermes backend profile is launched
- `native-theme.json`
- `translucency.json`
- Chromium session, cookies, cache, Local Storage

**Without this var:** writes to `$APPDATA_ROAMING_ROOT\Hermes\` (primary — must not be touched)
**With this var:** writes to `$APPDATA_ROAMING_ROOT\Hermes-NightSchool\` (NightSchool-only)

---

### Lever 2: `HERMES_HOME`

**Source:** `electron/bootstrap-runner.cjs` (multiple callsites):
```javascript
HERMES_HOME: hermesHome || process.env.HERMES_HOME || ''
```

**Effect:** Passed to all bootstrap/install stages (PowerShell and bash). Controls where the Hermes Python agent backend, its venv, profiles directory, logs, and bootstrap cache are rooted.

**Without this var:** defaults to `$USER_HOME\.hermes\` (shared primary backend — must not be touched)
**With this var:** roots at `$USER_HOME\.hermes-nightschool\`

---

## Proposed NightSchool Launch Configuration

| Variable | NightSchool value | Primary value (must not match) |
|---|---|---|
| `HERMES_DESKTOP_USER_DATA_DIR` | `$APPDATA_ROAMING_ROOT\Hermes-NightSchool` | `$APPDATA_ROAMING_ROOT\Hermes` |
| `HERMES_HOME` | `$USER_HOME\.hermes-nightschool` | `$USER_HOME\.hermes` |
| Exe | `$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe` | same binary — shared read-only |

---

## Launch Script

**Path:** `Prototype_workingFiles\scripts\launch_hermes_nightschool.ps1`

```powershell
$env:HERMES_DESKTOP_USER_DATA_DIR = "`$APPDATA_ROAMING_ROOT\Hermes-NightSchool"
$env:HERMES_HOME                   = "`$USER_HOME\.hermes-nightschool"

$HERMES_EXE = "`$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe"

# Lane F pre-launch guard
$PRIMARY_USERDATA = "`$APPDATA_ROAMING_ROOT\Hermes"
$PRIMARY_HOME     = "`$USER_HOME\.hermes"

if ($env:HERMES_DESKTOP_USER_DATA_DIR -eq $PRIMARY_USERDATA) {
    Write-Error "[LANE F] BLOCKED: userData points to primary Hermes!"
    exit 1
}
if ($env:HERMES_HOME -eq $PRIMARY_HOME) {
    Write-Error "[LANE F] BLOCKED: HERMES_HOME points to primary backend!"
    exit 1
}

Start-Process -FilePath $HERMES_EXE -NoNewWindow
```

---

## Open Architecture Questions for Codex Review

### Q1 — Port conflict: can two Hermes instances share port 9119?

The primary Hermes desktop binds a local API on port 9119. If NightSchool launches a second Hermes instance while primary is running, does the NightSchool instance:
- (a) Also try to bind 9119 and fail/error?
- (b) Try to bind 9119 and silently succeed if primary is not running?
- (c) Read its port from `connection.json` (which we control via `HERMES_DESKTOP_USER_DATA_DIR`)?

**Claude's working hypothesis:** The port is configurable via `connection.json` in the userData dir. Since `HERMES_DESKTOP_USER_DATA_DIR` redirects that file, NightSchool's `connection.json` can point to a different port (e.g. 8100) so the two instances never conflict. But this needs Codex confirmation — if the port is hardcoded in the binary or env var, the approach changes.

**Request:** Codex to inspect `connection-config.cjs` and `backend-ready.cjs` from the asar to determine where the port is resolved from and whether `connection.json` is authoritative.

---

### Q2 — Backend bootstrap: will `HERMES_HOME` isolation work end-to-end?

On first NightSchool launch, the app will run its bootstrap sequence (Phase 1D in the app's own phasing) to install the Hermes Python agent into `HERMES_HOME`. This calls `install.ps1` stages.

**Concern:** If the bootstrap process at `~/.hermes-nightschool` re-downloads/clones the hermes-agent repo and compiles native deps, this could:
- Take significant time (first launch)
- Require network access (GitHub clone)
- Write to paths outside `~/.hermes-nightschool` (e.g. temp dirs, global npm) — which would be a Lane F violation

**Request:** Codex to inspect `bootstrap-runner.cjs` install stages to determine:
- What exactly gets written on first launch into `HERMES_HOME`
- Whether any writes go outside `HERMES_HOME` during bootstrap
- Whether there's a way to skip bootstrap if the agent binary already exists (i.e., can NightSchool reuse the existing `~/.hermes/hermes-agent/` rather than re-cloning everything?)

---

### Q3 — `HERMES_HOME` path reuse: can NightSchool point to the existing agent install?

The existing agent code is already at `$USER_HOME\.hermes\hermes-agent\`. The isolation we need is for *config and profiles*, not necessarily for the agent *code*.

**Alternative design:** Set `HERMES_HOME=`$USER_HOME\.hermes-nightschool` for profile/config isolation, but find a way to tell the bootstrap to reuse the existing agent binary at `~/.hermes/hermes-agent/` rather than re-cloning. This would make the first NightSchool launch much faster and avoid unnecessary network activity.

**Request:** Codex to assess whether this is possible and safe, or whether full `HERMES_HOME` isolation (including a second agent install) is the cleaner path.

---

### Q4 — Two simultaneous Hermes instances: is this supported?

The app checks `IS_WINDOWS`, has port binding, and uses `safeStorage` (Electron's credential store). Running two instances simultaneously raises questions:

- Does Electron's single-instance lock (`app.requestSingleInstanceLock()`) prevent a second instance? If so, NightSchool cannot run while primary is open.
- Does `safeStorage` operate per-userData (in which case our isolation is complete) or is it per-user/machine?
- Any other global-scope resource that two instances would contend over?

**Request:** Codex to grep `main.cjs` for `requestSingleInstanceLock`, `safeStorage`, and any other global resource acquisition.

---

### Q5 — Lane F completeness: are these tripwires sufficient?

Current Lane F tripwires in `isolation_manifest.md`:
1. NightSchool `HERMES_DESKTOP_USER_DATA_DIR` ≠ `$APPDATA_ROAMING_ROOT\Hermes\`
2. NightSchool `HERMES_HOME` ≠ `$USER_HOME\.hermes\`
3. NightSchool `connection.json` must not reference port 9119

**Request:** Codex to assess whether these three tripwires are sufficient or whether additional checks are needed (e.g., checking that `safeStorage` is isolated, that no temp files cross-contaminate, that the startup script doesn't inherit any env vars from the primary Hermes session).

---

## Requested Output from Codex

1. **Approve / flag** the overall isolation architecture (two env vars, shared binary)
2. **Answer Q1–Q5** above (or flag which ones need further inspection)
3. **Redlines on the launch script** if anything needs to change before first execution
4. **Approval to proceed** to first NightSchool Hermes launch, or a list of blockers that must be resolved first

This is a pre-launch gate. Claude will not instruct operator to run the launch script until Codex approves or provides alternative instructions.

---

## Files Codex Should Read for Review

All in `Prototype_workingFiles\`:
- `isolation_manifest.md` — full isolation boundary spec
- `PRD\NightSchool_PRD_and_Execution_System.md` — §9 Phase 1 cards (now updated with discovery)
- `handoffs\2026-06-21_phase1_hermes_discovery.md` — detailed discovery note
- `scripts\launch_hermes_nightschool.ps1` — the script awaiting approval

Hermes source (read-only, for Codex inspection):
- `$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\resources\app.asar`
- Key files inside: `electron/main.cjs`, `electron/connection-config.cjs`, `electron/backend-ready.cjs`, `electron/bootstrap-runner.cjs`


