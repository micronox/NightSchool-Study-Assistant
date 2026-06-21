# NightSchool — Isolation Architecture System Design
**Date:** 2026-06-21
**Author:** Claude (Cowork)
**Status:** Draft — pending Codex Q1–Q5 answers for final ratification
**ADR:** `handoffs/2026-06-21_ADR-001_hermes_dual_instance_isolation.md`

---

## 1. System Overview

NightSchool runs a second Hermes Desktop profile alongside (or alternating with) the primary Hermes install. The two instances share a single binary but have fully isolated state roots, controlled by two environment variables set at launch time. No second binary is installed. No primary Hermes files are written.

```
┌─────────────────────────────────────────────────────────────┐
│                     operator's Workstation                      │
│                                                             │
│  ┌─────────────────────────┐  ┌──────────────────────────┐  │
│  │   Primary Hermes        │  │   NightSchool Hermes      │  │
│  │   (existing install)    │  │   (Phase 1 target)        │  │
│  │                         │  │                           │  │
│  │  userData:              │  │  userData:                │  │
│  │  Roaming\Hermes\        │  │  Roaming\Hermes-NS\       │  │
│  │                         │  │                           │  │
│  │  HERMES_HOME:           │  │  HERMES_HOME:             │  │
│  │  .hermes\               │  │  .hermes-nightschool\     │  │
│  │                         │  │                           │  │
│  │  Port: 9119             │  │  Port: 8100 (target)      │  │
│  └─────────────────────────┘  └──────────────────────────┘  │
│            ↑                              ↑                   │
│            └──────────┬───────────────────┘                  │
│                       │ shared (read-only)                    │
│              ┌────────┴────────┐                             │
│              │   Hermes.exe    │                             │
│              │  (one binary)   │                             │
│              └─────────────────┘                             │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Ollama  localhost:11434  qwen3.6:35b-a3b           │   │
│  │  (shared — reachable from both profiles)            │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Nous API  (Nemotron Super/Ultra — primary lane)     │   │
│  │  Key stored as env var only — never in files         │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Component Map

### 2.1 Shared components (read-only for NightSchool)

| Component | Path | NightSchool access |
|---|---|---|
| Hermes.exe binary | `$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe` | Read-only (launch only) |
| app.asar | `.../release/win-unpacked/resources/app.asar` | Read-only (inspection only) |
| Ollama endpoint | `localhost:11434` | Read (API calls) |

### 2.2 NightSchool-owned components (fully isolated)

| Component | Path | Created by |
|---|---|---|
| Electron userData root | `$APPDATA_ROAMING_ROOT\Hermes-NightSchool\` | Hermes.exe on first launch (via `HERMES_DESKTOP_USER_DATA_DIR`) |
| connection.json | `Hermes-NightSchool\connection.json` | Hermes.exe on first launch |
| active-profile.json | `Hermes-NightSchool\active-profile.json` | Hermes.exe on first launch |
| Chromium session/cache | `Hermes-NightSchool\[chromium dirs]` | Hermes.exe on first launch |
| Backend agent root | `$USER_HOME\.hermes-nightschool\` | Bootstrap runner on first launch (via `HERMES_HOME`) |
| Python venv | `.hermes-nightschool\[venv dir]` | Bootstrap runner on first launch |
| Backend profiles | `.hermes-nightschool\profiles\` | Bootstrap runner / agent on first launch |
| Backend logs | `.hermes-nightschool\logs\` | Agent at runtime |

### 2.3 NightSchool Prototype artifacts (build-time)

| Artifact | Path | Purpose |
|---|---|---|
| Launch script | `Prototype_workingFiles\scripts\launch_hermes_nightschool.ps1` | Sets env vars, runs Lane F guard, launches exe |
| Isolation manifest | `Prototype_workingFiles\isolation_manifest.md` | Lane F boundary record |
| PRD | `Prototype_workingFiles\PRD\NightSchool_PRD_and_Execution_System.md` | Master spec |
| ADR-001 | `Prototype_workingFiles\handoffs\2026-06-21_ADR-001_hermes_dual_instance_isolation.md` | Architecture decision record |
| This document | `Prototype_workingFiles\handoffs\2026-06-21_system_design_nightschool_isolation.md` | System design |

---

## 3. Isolation Mechanism — Data Flow

### 3.1 Launch sequence

```
operator runs:
launch_hermes_nightschool.ps1
        │
        ├─ [Lane F guard] check HERMES_DESKTOP_USER_DATA_DIR ≠ primary userData path
        │                 check HERMES_HOME ≠ primary backend root
        │                 → if either matches primary → HARD BLOCK, exit 1
        │
        ├─ set env: HERMES_DESKTOP_USER_DATA_DIR = C:\...\Hermes-NightSchool
        ├─ set env: HERMES_HOME = $USER_HOME\.hermes-nightschool
        │
        └─ Start-Process Hermes.exe
                │
                └─ electron/main.cjs runs
                        │
                        ├─ reads HERMES_DESKTOP_USER_DATA_DIR
                        ├─ calls app.setPath('userData', 'C:\...\Hermes-NightSchool')
                        │   → ALL subsequent app.getPath('userData') calls return NightSchool path
                        │   → connection.json, active-profile.json, Chromium session
                        │     all write to Hermes-NightSchool\ (never to Hermes\)
                        │
                        └─ bootstrap-runner.cjs runs
                                │
                                ├─ reads HERMES_HOME (or hermesHome var)
                                ├─ passes HERMES_HOME to all install/agent stages
                                │
                                └─ on first launch: bootstrap sequence
                                        → writes Python agent, venv, profiles
                                          into .hermes-nightschool\ only
                                        → [Q2: does anything write outside this root?]
```

### 3.2 Runtime data flow (post-bootstrap)

```
NightSchool Hermes.exe
        │
        ├─ GUI state ────────────────→ Hermes-NightSchool\
        │                               connection.json (endpoint: localhost:8100 target)
        │                               active-profile.json
        │
        ├─ Backend API calls ─────────→ .hermes-nightschool\
        │                               Python agent (own venv)
        │                               profiles\
        │                               logs\
        │
        ├─ Ollama calls ─────────────→ localhost:11434 (shared — read-only from Ollama's POV)
        │
        └─ Nous API calls ───────────→ api.nous.ai (Nemotron Super/Ultra)
                                        key via env var only
```

---

## 4. Port Boundary Map

| Service | Port | Owner | NightSchool access |
|---|---|---|---|
| Primary Hermes backend | 9119 | Primary install | **FORBIDDEN** — NightSchool must not bind or connect to 9119 |
| NightSchool Hermes backend | 8100 (target) | NightSchool | Write (own endpoint in connection.json) |
| Ollama | 11434 | Shared (local) | Read (API calls for qwen3.6:35b-a3b) |
| Node/dev server (Phase 4) | 8101–8199 | NightSchool | Write (dashboard and agent services) |
| Primary Node/npm services | 3000, 9000 | Primary | **No-touch** |

**Port 9119 isolation is a Lane F tripwire.** If NightSchool's `connection.json` ever shows `localhost:9119` as the endpoint, that is a cross-contamination flag — it means NightSchool would talk to the primary Hermes backend instead of its own.

*[Q1 open: whether 9119 is hardcoded in the binary or sourced from connection.json. If hardcoded, the NightSchool backend port cannot be configured and concurrent operation would require primary to be closed.]*

---

## 5. Path Boundary Map

### No-touch zone (Lane F hard enforces)

```
`$APPDATA_ROAMING_ROOT\Hermes\          ← primary userData — NEVER WRITTEN
`$USER_HOME\.hermes\                          ← primary backend root — NEVER WRITTEN
`$APPDATA_LOCAL_ROOT\hermes-desktop-updater\  ← updater — NEVER WRITTEN
```

### NightSchool write zone (fully owned)

```
`$APPDATA_ROAMING_ROOT\Hermes-NightSchool\   ← NightSchool userData
`$USER_HOME\.hermes-nightschool\                  ← NightSchool backend root
`$PROJECTS_ROOT\Nightschool_Study\Prototype_workingFiles\  ← build artifacts
```

### Shared read-only

```
`$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe
`$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\resources\app.asar
```

---

## 6. Bootstrap Sequence (first launch)

*Full behavior pending Codex Q2 and Q3 answers. This is the working model.*

```
First launch of NightSchool Hermes:

1. Hermes.exe reads HERMES_DESKTOP_USER_DATA_DIR
   → creates C:\...\Hermes-NightSchool\ if not exists
   → writes initial connection.json (mode=local, endpoint=TBD)
   → writes active-profile.json

2. Hermes.exe reads HERMES_HOME
   → bootstrap-runner.cjs runs install stages
   → stages write Python agent, venv, profiles into .hermes-nightschool\

   [Q2: do any stages write outside .hermes-nightschool\?]
   [Q3: can we tell bootstrap to skip re-clone and reuse existing .hermes/hermes-agent/ ?]

3. App starts normally against NightSchool-scoped paths
   → GUI connects to backend on the port in NightSchool's connection.json

Phase 1 card "First NightSchool Hermes launch" must:
  - Record which files were written (inventory .hermes-nightschool\ after bootstrap)
  - Verify C:\...\Hermes-NightSchool\connection.json was created
  - Verify C:\...\Hermes\connection.json is UNCHANGED (Lane F post-launch drift check)
  - Verify no files written to .hermes\ (primary backend root)
```

---

## 7. Concurrent vs. Alternating Operation

*Determined by Q4 — single-instance lock.*

### If Q4 = NO (no single-instance lock)

Both Hermes instances can run simultaneously:

```
Primary Hermes (port 9119) ─── runs in background (untouched)
NightSchool Hermes (port 8100) ─── launched via launch script
Both use the same Hermes.exe binary
State fully isolated by env vars
```

### If Q4 = YES (single-instance lock present, per-user scope)

Only one Hermes instance can run per Windows user session. Operational model becomes:

```
Primary Hermes closed by operator
  ↓
launch_hermes_nightschool.ps1 runs
  ↓ (launch script should check if Hermes.exe is already running → warn/block)
NightSchool Hermes starts
  ↓
operator does NightSchool work
  ↓
NightSchool Hermes closed
  ↓
Primary Hermes re-opened normally
```

**Lane F addition if Q4 = YES:** Launch script must detect whether any Hermes.exe process is running before launch (via `Get-Process`) and warn operator if so. Cannot hard-block (user may want to force it) but must surface the risk.

---

## 8. Lane F Tripwires — Complete List

*Current confirmed tripwires. Q5 may expand this list.*

| # | Tripwire | When checked | Failure action |
|---|---|---|---|
| T1 | `HERMES_DESKTOP_USER_DATA_DIR` ≠ `$APPDATA_ROAMING_ROOT\Hermes` | Launch script (pre-launch) | Hard block, exit 1 |
| T2 | `HERMES_HOME` ≠ `$USER_HOME\.hermes` | Launch script (pre-launch) | Hard block, exit 1 |
| T3 | NightSchool `connection.json` endpoint ≠ `localhost:9119` | Phase 1 card verification | Flag, document, do not proceed to Phase 2 |
| T4 | Primary `Hermes\connection.json` unchanged after NightSchool launch | Phase 1 drift check | Flag, investigate before Phase 2 |
| T5 | No files written to `$USER_HOME\.hermes\` during bootstrap | Phase 1 bootstrap inventory | Flag as Lane F violation |
| T6 | No files written to `$APPDATA_ROAMING_ROOT\Hermes\` during launch | Phase 1 post-launch check | Flag as Lane F violation |

*T7+: pending Q5 answer from Codex (safeStorage, env var inheritance, temp dir contamination).*

---

## 9. Non-Functional Requirements

| Requirement | Target | Notes |
|---|---|---|
| Primary Hermes zero-touch | 0 writes to primary paths | Lane F enforces; verified by drift check |
| Rollback time | < 2 minutes | Delete `Hermes-NightSchool\` and `.hermes-nightschool\` — nothing else changed |
| First launch time | Unknown | Depends on Q2/Q3 (bootstrap scope) — one-time cost |
| Port conflict risk | Zero | T3 tripwire ensures NightSchool never claims port 9119 |
| API key exposure | Zero | Nous key in env var only; never written to any file |
| Lane F audit surface | Minimal | Two paths + one launch script + two new dirs = entire NightSchool footprint |

---

## 10. Open Risks (pre-Codex review)

| Risk | Severity | Mitigation | Open item |
|---|---|---|---|
| Single-instance lock prevents concurrent operation | High | Fall to alternating-operation model (Option C) — isolation architecture unchanged | Q4 |
| Port 9119 hardcoded in binary | High | Alternating operation model; NightSchool backend binds different port | Q1 |
| Bootstrap writes outside HERMES_HOME | High | Must identify and contain before Phase 1 can close | Q2 |
| safeStorage not per-userData | Medium | NightSchool API keys stored as env vars only (already the plan) — not in safeStorage | Q5 |
| Agent binary re-clone on first launch | Low | One-time cost; document in Phase 1 status note | Q3 |
| Hermes binary auto-update changes env-var behavior | Low | Post-update: re-inspect main.cjs for env-var hooks | Ongoing Lane F check |

---

## 11. Revision Notes

This document should be updated after:
- Codex answers Q1–Q5 (fill in the [Q#] gaps above)
- First NightSchool launch completes (add bootstrap inventory as §12 addendum)
- Phase 1 drift check completes (update T4–T6 with evidence)


