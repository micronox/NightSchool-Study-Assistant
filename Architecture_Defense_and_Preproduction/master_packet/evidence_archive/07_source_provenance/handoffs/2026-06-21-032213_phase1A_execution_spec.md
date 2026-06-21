# Phase 1A — NightSchool Hermes Sequential Lane: Execution Spec
**Date:** 2026-06-21
**Author:** Claude (Cowork)
**Status:** APPROVED FOR EXECUTION — Codex review complete
**Codex review:** `handoffs/2026-06-21_phase1A_codex_review_response.md`
**ADR:** `handoffs/2026-06-21_ADR-001_hermes_dual_instance_isolation.md`
**Larry's instructions:** `handoffs/2026-06-21_phase1A_larry_instructions.md`

---

## What Changed from Phase 1 (v6 PRD)

The original Phase 1 plan had three errors Codex caught:

1. **Concurrent operation assumed** — Hermes uses `app.requestSingleInstanceLock()`. Two desktops cannot run at once. NightSchool is a *sequential* alternate lane, not a parallel one.
2. **Bootstrap not Lane F-clean** — `install.ps1` writes to user PATH and user-scoped `HERMES_HOME`. A first-launch bootstrap from NightSchool would mutate Larry's primary environment. Deferred.
3. **Port 9119 assumption wrong** — current desktop uses ephemeral port (`--port 0`), not a fixed 9119 bind. Port config via `connection.json` is not the isolation mechanism.

**Phase 1 is now renamed Phase 1A.** "Phase 1B" will cover the controlled bootstrap path once the installer mutation issue is understood and neutralized.

---

## Phase 1A Definition

A sequential NightSchool Hermes lane using:
- shared `Hermes.exe` binary (read-only)
- shared existing agent code root (`~/.hermes/hermes-agent/`) via `HERMES_DESKTOP_HERMES_ROOT`
- isolated Electron userData (`Hermes-NightSchool\`) via `HERMES_DESKTOP_USER_DATA_DIR`
- isolated data/log/config root (`.hermes-nightschool\`) via `HERMES_HOME`
- no fresh bootstrap, no installer, no update/uninstall flows

---

## Cards

### Card 1A-0: Pre-launch Lane F drift check (Larry — before anything else)

**Context:** reads `isolation_manifest.md` only.
**Owner:** Larry (human-executable check)
**Acceptance criteria:**
- [ ] Open a new PowerShell window (not from within any Hermes session)
- [ ] Run: `echo $env:HERMES_HOME` — must be empty or `C:\Users\larry\.hermes` (the primary default). Must NOT be `C:\Users\larry\.hermes-nightschool`.
- [ ] Run: `echo $env:HERMES_DESKTOP_USER_DATA_DIR` — must be empty. If it has a value, that means a prior session leaked it user-wide — stop and tell Claude.
- [ ] Confirm primary Hermes is either running normally (you'll close it in Card 1A-1) or not running.

**Evidence field:** record result of each echo. PASS if both are empty or primary values.
**Rollback:** if either var is pre-set to a NightSchool value, something leaked user-wide — investigate before launching.

---

### Card 1A-1: Close primary Hermes (Larry — human action)

**Context:** none needed.
**Owner:** Larry
**Acceptance criteria:**
- [ ] Close the primary Hermes desktop window completely (not just minimize).
- [ ] Open Task Manager → confirm no `Hermes.exe` process is running.

**Evidence field:** screenshot of Task Manager with no Hermes process, or PowerShell: `Get-Process -Name "Hermes" -ErrorAction SilentlyContinue` returns nothing.
**Rollback:** n/a — just don't proceed until it's confirmed closed.

---

### Card 1A-2: Run the approved launch script

**Context:** `scripts/launch_hermes_nightschool_safe_reuse.ps1`
**Owner:** Larry (run) + Claude (verify output)
**Script:** `Prototype_workingFiles\scripts\launch_hermes_nightschool_safe_reuse.ps1`

**Pre-conditions:**
- Card 1A-1 complete (no Hermes process running)
- Script is the `_safe_reuse` version — NOT `launch_hermes_nightschool.ps1` (the old unapproved version)

**Steps:**
1. Open PowerShell as normal user (not Administrator)
2. `cd L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\scripts`
3. `.\launch_hermes_nightschool_safe_reuse.ps1`

**Expected output:**
```
[NightSchool] Preparing sequential Hermes launch (Phase 1A)...
  userData:   C:\Users\larry\AppData\Roaming\Hermes-NightSchool
  home:       C:\Users\larry\.hermes-nightschool
  sharedRoot: C:\Users\larry\.hermes\hermes-agent
  exe:        C:\Users\larry\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe

[NightSchool] Launching Hermes with isolated state and shared code root...
[NightSchool] IMPORTANT: do not use update/uninstall flows in this lane (Lane F T4).

[NightSchool] Launch started.
Post-launch verification checklist...
```

**Failure modes:**
- `[NightSchool] BLOCKED: Hermes is already running` → go back to Card 1A-1
- `[NightSchool] BLOCKED: Hermes.exe not found` → primary Hermes may have moved; check exe path
- Any throw/exception → paste full output to Claude before proceeding

**Evidence field:** full PowerShell output pasted into session notes.
**Rollback:** nothing has been written yet if the script blocked. If Hermes launched: close it, delete `Hermes-NightSchool\` and `.hermes-nightschool\`.

---

### Card 1A-3: Verify NightSchool userData created (Lane F post-launch check)

**Context:** needs post-launch file system state.
**Owner:** Claude (Desktop Commander reads)

**Checks:**
- [ ] `C:\Users\larry\AppData\Roaming\Hermes-NightSchool\connection.json` exists
- [ ] `C:\Users\larry\AppData\Roaming\Hermes-NightSchool\connection.json` is NightSchool-scoped and primary `Hermes\connection.json` remains the only known baseline file pinned to `localhost:9119`
- [ ] `C:\Users\larry\AppData\Roaming\Hermes\connection.json` is UNCHANGED (diff against Phase 0 baseline: `mode=local, endpoint=http://localhost:9119, authMode=oauth`)

**Evidence field:** content of both `connection.json` files.
**Rollback if primary connection.json changed:** immediate Lane F flag — stop, document, do not proceed.

---

### Card 1A-4: Verify user PATH and HERMES_HOME unchanged (Lane F T5)

**Context:** none.
**Owner:** Larry (human check in new shell)

**Steps:**
1. Open a **new** PowerShell window (separate from the one that ran the launch script — env must not be inherited)
2. Run: `echo $env:HERMES_HOME`
3. Run: `[System.Environment]::GetEnvironmentVariable("HERMES_HOME", "User")`

**Acceptance criteria:**
- [ ] Process-level `$env:HERMES_HOME` in the new shell is empty or `C:\Users\larry\.hermes` (never `.hermes-nightschool`)
- [ ] User-scoped `HERMES_HOME` is empty or unchanged from before Phase 1A
- [ ] `$env:PATH` does not contain any new NightSchool entries (spot-check for `nightschool` or `.hermes-nightschool` in PATH)

**Evidence field:** output of both commands.
**Rollback if user-scoped env was mutated:** critical Lane F violation — the bootstrap ran anyway. Stop, document everything, do not proceed to Card 1A-5.

---

### Card 1A-5: Verify NightSchool home dirs created correctly

**Context:** post-launch filesystem.
**Owner:** Claude (Desktop Commander reads)

**Checks:**
- [ ] `C:\Users\larry\.hermes-nightschool\` exists
- [ ] `C:\Users\larry\.hermes-nightschool\logs\` exists
- [ ] `C:\Users\larry\.hermes-nightschool\sessions\` exists
- [ ] `C:\Users\larry\.hermes-nightschool\memories\` exists
- [ ] `C:\Users\larry\.hermes\` directory: no new files written (mtime check on key dirs)

**Evidence field:** directory listing of `.hermes-nightschool\`.
**Rollback if .hermes\ was written to:** Lane F flag — investigate before Phase 1B.

---

### Card 1A-6: Lane F note — update/uninstall forbidden

**Context:** none.
**Owner:** Claude (write note to isolation manifest)

**Action:** Append to `isolation_manifest.md` Lane F drift check log:

```
| 2026-06-21 | Phase 1A launch | PASS (pending evidence) | Sequential lane established.
  HERMES_DESKTOP_HERMES_ROOT pins shared code root. Bootstrap deferred (Phase 1B).
  Update/uninstall flows FORBIDDEN in NightSchool lane while sharing agent code root. |
```

**Acceptance criteria:** entry appended, evidence fields filled in from Cards 1A-3 through 1A-5.

---

### Card 1A-7: Phase 1A status note

**Context:** evidence from all preceding cards.
**Owner:** Claude

**Action:** Write `handoffs/2026-06-21_phase1A_status.md` with:
- summary of what was done
- evidence from each card (connection.json paths, env var checks, dir listing)
- open items (Phase 1B bootstrap deferred — why)
- next phase readiness

**Acceptance criteria:** status note written, readable cold by Codex or a new Claude session.

---

## Lane F Tripwires (Phase 1A — all seven required)

| # | Tripwire | Checked in |
|---|---|---|
| T1 | Primary Hermes closed before launch | Card 1A-1 + launch script |
| T2 | No fresh bootstrap under `.hermes-nightschool` | Enforced by `HERMES_DESKTOP_HERMES_ROOT` (bypasses bootstrap) |
| T3 | `HERMES_DESKTOP_HERMES_ROOT` pinned to `~/.hermes/hermes-agent` | Launch script |
| T4 | No update/uninstall from NightSchool lane | Card 1A-6 note + ongoing discipline |
| T5 | User PATH + user HERMES_HOME unchanged after launch | Card 1A-4 |
| T6 | `HERMES_DESKTOP_REMOTE_URL/TOKEN` cleared | Launch script |
| T7 | NightSchool userData ≠ primary userData | Launch script + Card 1A-3 |

---

## What is Explicitly Deferred (Phase 1B, not yet scoped)

- **Fresh NightSchool bootstrap** — requires either: (a) a modified installer that does not write to user PATH/HERMES_HOME, or (b) a manual bootstrap that does only the parts needed (venv, profiles) without the full `install.ps1` chain. Codex must review the install stages before this can be designed.
- **Port configuration** — ephemeral port behavior means NightSchool backend port is OS-assigned at runtime. No action needed for Phase 1A; Phase 1B or later will configure if needed.
- **Concurrent operation** — blocked by single-instance lock. Alternating/sequential is the permanent model unless a future Hermes version changes this.

---

## Non-Goals for Phase 1A

- No Ollama reachability test (deferred to Phase 1B when NightSchool has its own backend context)
- No Nous API key configuration (Phase 1B)
- No per-agent routing confirmation (Phase 1B)
- No connection.json port reconfiguration (ephemeral port — not needed)

---

## Context Budget

This spec is self-contained. Cards 1A-0 through 1A-7 require only:
- This file
- `isolation_manifest.md` (for drift check baseline)
- `scripts/launch_hermes_nightschool_safe_reuse.ps1` (for execution)
- Phase 0 verification note (for connection.json baseline comparison)

No prior session history needed.
