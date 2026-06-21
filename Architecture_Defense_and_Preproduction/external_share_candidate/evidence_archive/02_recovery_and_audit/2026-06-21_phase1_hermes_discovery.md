# Phase 1 — Hermes Profile Separation Discovery Note
**Date:** 2026-06-21
**Session:** Claude (Cowork) + Desktop Commander
**Lane:** F (Architecture Defense) + A (Infra)
**Status:** COMPLETE — full isolation mechanism identified, no mutations made

---

## Summary

Hermes Desktop supports **native, first-class profile isolation** via two environment variables. No hacks, no Squirrel reinstalls, no forked binaries required. The isolation design is already in the app's source.

---

## Discovery Method

1. Parsed Windows `.lnk` shortcuts to locate real exe path (not in Program Files)
2. Inspected Hermes exe binary strings → confirmed `user-data-dir` Chromium flag present
3. Extracted `electron/main.cjs` from `app.asar` → found `HERMES_DESKTOP_USER_DATA_DIR` env var handling
4. Extracted `electron/backend-env.cjs` and `electron/bootstrap-runner.cjs` → found `HERMES_HOME` env var handling

All inspection read-only. No files modified.

---

## Key Finding: Two Isolation Levers

### Lever 1 — `HERMES_DESKTOP_USER_DATA_DIR` (Electron userData path)

**Source: `electron/main.cjs` lines 112–116:**
```javascript
const USER_DATA_OVERRIDE = process.env.HERMES_DESKTOP_USER_DATA_DIR
if (USER_DATA_OVERRIDE) {
  const resolvedUserData = path.resolve(USER_DATA_OVERRIDE)
  fs.mkdirSync(resolvedUserData, { recursive: true })
  app.setPath('userData', resolvedUserData)
}
```

**Effect:** Redirects ALL Electron userData files to the specified path. This includes:
- `connection.json` (which remote/local endpoint the desktop connects to)
- `active-profile.json` (which Hermes backend profile is launched)
- `native-theme.json`
- `translucency.json`
- All Chromium session data, cookies, cache

**Without this env var:** defaults to `C:\Users\larry\AppData\Roaming\Hermes\` (primary profile — must not be touched by NightSchool)

**With this env var:** NightSchool gets its own `connection.json` pointing to its own endpoint/config, completely separate from the primary.

---

### Lever 2 — `HERMES_HOME` (backend agent data root)

**Source: `electron/bootstrap-runner.cjs`:**
```javascript
HERMES_HOME: hermesHome || process.env.HERMES_HOME || ''
```

**Effect:** Controls where the Hermes Python agent backend installs, its venv, profiles, logs, and bootstrap cache live. Defaults to `~/.hermes` (which is `C:\Users\larry\.hermes\` — where the current install lives).

**Without this env var:** backend data goes to `~/.hermes` (shared with primary Hermes)
**With this env var:** NightSchool backend agent gets its own isolated root

---

## Recommended NightSchool Launch Configuration

### Windows-side paths:
| Variable | Value | Purpose |
|---|---|---|
| `HERMES_DESKTOP_USER_DATA_DIR` | `C:\Users\larry\AppData\Roaming\Hermes-NightSchool\` | Electron GUI config isolation |
| `HERMES_HOME` | `C:\Users\larry\.hermes-nightschool\` | Backend agent data isolation |

### Actual Hermes.exe location:
```
C:\Users\larry\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe
```

### NightSchool launch command (Windows):
```powershell
$env:HERMES_DESKTOP_USER_DATA_DIR = "C:\Users\larry\AppData\Roaming\Hermes-NightSchool"
$env:HERMES_HOME = "C:\Users\larry\.hermes-nightschool"
& "C:\Users\larry\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe"
```

Or as a `.bat` / `.ps1` launcher script checked into `Prototype_workingFiles\scripts\`.

---

## Lane F Isolation Verification

| Check | Primary (must not touch) | NightSchool (isolated) |
|---|---|---|
| Electron userData | `C:\Users\larry\AppData\Roaming\Hermes\` | `C:\Users\larry\AppData\Roaming\Hermes-NightSchool\` |
| Backend agent root | `C:\Users\larry\.hermes\` | `C:\Users\larry\.hermes-nightschool\` |
| connection.json | Primary: `localhost:9119` | NightSchool: its own port (8100-range) |
| Exe binary | shared — same binary, different env | ← same exe, different env vars |

**No path overlap.** The exe is shared (read-only binary) but all writable state is fully separated.

---

## Internal App Version Note

- Setup installer label: `hermes-desktop-0.5.6-setup.exe`
- `package.json` inside app.asar: `version: 0.15.1`, `productName: Hermes`
- These represent two different versioning schemes (installer vs. internal). Both refer to the same running app. Use `0.5.6` as the external reference (matches Phase 0 baseline).

---

## Next Steps (Phase 1 Cards)

1. **Create NightSchool Hermes launch script** — PowerShell `.ps1` that sets both env vars and launches `Hermes.exe`. Save to `Prototype_workingFiles\scripts\launch_hermes_nightschool.ps1`.
2. **Create `Hermes-NightSchool\` userData directory** — empty, ready for first launch to populate `connection.json`.
3. **Confirm `connection.json` is written separately** — after first NightSchool Hermes launch, verify `C:\Users\larry\AppData\Roaming\Hermes-NightSchool\connection.json` exists and primary `Hermes\connection.json` is unchanged.
4. **Configure NightSchool `connection.json`** — set endpoint to NightSchool's port (8100-range) rather than 9119.
5. **Lane F drift check** — confirm no overlap between NightSchool userData path and primary.

---

## Decision Gate

- [x] Hermes supports native profile isolation via env var (confirmed from source)
- [x] `HERMES_DESKTOP_USER_DATA_DIR` controls all GUI config including `connection.json`
- [x] `HERMES_HOME` controls backend agent data root
- [x] No mutation of primary profile required or performed
- [x] Isolation paths documented and non-overlapping

**SAFE TO PROCEED to Phase 1 install cards.**
