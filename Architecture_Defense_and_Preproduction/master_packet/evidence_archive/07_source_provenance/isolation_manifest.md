# NightSchool — Isolation Manifest
# Lane F reference document. Records the boundary between NightSchool and everything else.
# Updated whenever Phase 0 runs a drift check or a new session opens.
# Last updated: 2026-06-21 (pre-Phase-0 scaffold)

---

## NightSchool App Root

| Item | Path |
|---|---|
| Project root | `$PROJECTS_ROOT\Nightschool_Study\` |
| Working directory | `$PROJECTS_ROOT\Nightschool_Study\Prototype_workingFiles\` |
| Final deliverable | `$PROJECTS_ROOT\Nightschool_Study\App_Final_Deliverable\` |
| WSL mount path | **Confirmed:** `L:\ → /mnt/l` (type 9p). Full path: `/mnt/l/WSL_Projects_Folder/Nightschool_Study/` |
| NightSchool app port range | **8100–8199** (confirmed clear of all detected services) |

---

## Tool Install Locations (NightSchool-scoped)

| Tool | Install location | Notes |
|---|---|---|
| pyenv | `~/.pyenv` (WSL home) | **Verified ✓ 2026-06-21.** `pyenv 2.7.2`, `python 3.11.9` confirmed via `.python-version` pin. Isolated from Windows profile and primary Hermes. |
| nvm | `~/.nvm` (WSL home) | **Verified ✓ 2026-06-21.** `nvm 0.40.3`, `node v22.23.0`, `npm 10.9.8` confirmed via `.nvmrc` pin and `nightschool` alias. Non-interactive shells must source nvm explicitly — see DEPENDENCIES.md. |
| Python venv | *(Phase 1 creates this)* | Will be inside `Prototype_workingFiles/.venv/` — NOT in system Python, NOT in primary Hermes venv. |
| NightSchool Hermes launch script | `Prototype_workingFiles\scripts\2026-06-21-075947_launch_hermes_nightschool_safe_reuse.ps1` | PowerShell launcher for the approved sequential Phase 1A lane. Blocks concurrent primary Hermes use, pins isolated state dirs, reuses the shared Hermes code root. |

---

## Primary / Worker Hermes Baseline

*(Completed by Phase 0 — read-only inspection, no modifications made)*

| Item | Value |
|---|---|
| App | Hermes Desktop v0.5.6 (internal package version: 0.15.1) |
| Exe path | `$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe` |
| Config root (userData) | `$APPDATA_ROAMING_ROOT\Hermes\` |
| Connection file | `$APPDATA_ROAMING_ROOT\Hermes\connection.json` |
| Connection mode | `local` |
| Local endpoint | `http://localhost:9119` (authMode: oauth) |
| Backend agent root | `$USER_HOME\.hermes\` (default `HERMES_HOME`) |
| Updater | `$APPDATA_LOCAL_ROOT\hermes-desktop-updater\` |
| WSL presence | Not in WSL PATH — Windows desktop app only |
| Ollama model | `qwen3.6:35b-a3b` (23.9 GB) on `localhost:11434` |
| Inspection method | Read-only filesystem inspection + asar extraction via Desktop Commander |
| Confirmed no-touch | ✓ 2026-06-21 |

## NightSchool Hermes Profile (Phase 1A — sequential isolation target)

*(Established by Phase 1 review — paths defined for the approved sequential shared-code lane, not yet fully validated by first controlled launch)*

| Item | Value | Isolation mechanism |
|---|---|---|
| Exe binary | `$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe` | Shared binary (read-only) — isolation is via env vars, not separate binary |
| Electron userData (config root) | `$APPDATA_ROAMING_ROOT\Hermes-NightSchool\` | `HERMES_DESKTOP_USER_DATA_DIR` env var (set in launch script) |
| connection.json | `$APPDATA_ROAMING_ROOT\Hermes-NightSchool\connection.json` | Written by NightSchool Hermes on first launch |
| Backend agent root | `$USER_HOME\.hermes-nightschool\` | `HERMES_HOME` env var (set in launch script) |
| Shared agent code root | `$USER_HOME\.hermes\hermes-agent` | `HERMES_DESKTOP_HERMES_ROOT` env var pins NightSchool to the existing agent checkout |
| Launch script | `Prototype_workingFiles\scripts\2026-06-21-075947_launch_hermes_nightschool_safe_reuse.ps1` | Sets isolation env vars, blocks concurrent primary Hermes use, clears remote overrides, launches the shared exe |
| Launch mode | Sequential only | Hermes desktop is single-instance; primary Hermes must be closed before NightSchool launch |
| Bootstrap mode | Reuse-only in Phase 1A | Fresh `.hermes-nightschool` bootstrap is forbidden until the installer stops writing user-scoped env changes |

**Source confirmation:** `HERMES_DESKTOP_USER_DATA_DIR` is explicitly read in `electron/main.cjs` lines 112–116 of the asar. `HERMES_HOME` is threaded through `bootstrap-runner.cjs` to all install/agent stages. `HERMES_DESKTOP_HERMES_ROOT` provides the code-root override that keeps Phase 1A on the shared checkout. These are first-class mechanisms — not undocumented hacks.

**Lane F cross-contamination tripwires:**
- NightSchool must never write to `$APPDATA_ROAMING_ROOT\Hermes\` (primary userData)
- NightSchool must never write to `$USER_HOME\.hermes\` (primary backend root) — `HERMES_HOME` must be set before launch
- NightSchool must always set `HERMES_DESKTOP_HERMES_ROOT = $USER_HOME\.hermes\hermes-agent` during Phase 1A so the desktop never falls into a fresh bootstrap path
- Primary Hermes desktop must be fully closed before NightSchool launch; a concurrent second desktop instance is forbidden
- NightSchool must not invoke updater or uninstall flows while sharing the primary Hermes code root
- Lane F drift check: after first NightSchool launch, verify primary `connection.json` is unchanged and user-scoped PATH / `HERMES_HOME` were not mutated

## Kopia Lane F Boundary

| Item | Value |
|---|---|
| Repository | `$KOPIA_REPO` |
| CLI | `$APPDATA_LOCAL_ROOT\Programs\KopiaUI\resources\server\kopia.exe` |
| Policy A | `$PROJECTS_ROOT\Nightschool_Study\` — NightSchool build artifacts |
| Policy B1 | `$APPDATA_ROAMING_ROOT\Hermes-NightSchool\` — NightSchool userData |
| Policy B2 | `$USER_HOME\.hermes-nightschool\` — NightSchool backend state |
| Policy C1 | `$APPDATA_ROAMING_ROOT\Hermes\` — primary Hermes baseline |
| Policy C2 | `$USER_HOME\.hermes\` — primary Hermes home baseline |

**T8 — Kopia snapshot boundaries must mirror Lane F path boundaries.**
NightSchool Kopia policies must never include primary Hermes paths in their snapshot roots or through parent-path coverage. Policy C snapshots are evidence baselines only, not restore targets during an active NightSchool session.

**Phase 1A pre-launch evidence ritual:**
1. Trigger Policy C1 and C2 snapshots with explicit path-scoped `kopia snapshot create` commands.
2. Confirm primary Hermes is closed.
3. Launch NightSchool through the safe-reuse script.
4. After the session, snapshot Policy B1 and B2 if NightSchool state changed.

---

## Adjacent Folders (in scope for reference, out of scope for build writes)

| Folder | Classification | Notes |
|---|---|---|
| `$PROJECTS_ROOT\Architecture_Defense\` | Audit/reference context | Contains Codex pre-install snapshots and headroom vetting docs. Lane F may read for reference. Agents must not write here during NightSchool build. |

---

## Isolation Boundaries (Lane F enforces these)

1. **NightSchool agents write only inside `Prototype_workingFiles\`** — never directly into `App_Final_Deliverable\` or `Architecture_Defense\`.
2. **Promotion to `App_Final_Deliverable\` is controller-only**, gated by a Lane F review with fresh evidence.
3. **No global pip/npm installs** — all packages go into the NightSchool venv or local node_modules. Anything in system Python or system Node is out of scope.
4. **Primary Hermes install is read-only** — Lane F drift check diffs against this baseline every session. Any overlap between NightSchool config paths and primary Hermes paths is an immediate flag.
5. **No Nous/Nemotron API keys committed to files** — stored in env vars inside the isolated scope only. Never in any file that touches `App_Final_Deliverable\` or GitHub.

---

## Drift Check Log

*(Lane F appends an entry here at the start of every session block)*

| Date | Session | Result | Notes |
|---|---|---|---|
| 2026-06-21 | Pre-Phase-0 scaffold | N/A — baseline not yet established | Manifest created; Phase 0 completes the baseline section above |
| 2026-06-21 | Toolchain verification (Codex) | PASS — version managers confirmed | pyenv 2.7.2 / Python 3.11.9 / nvm 0.40.3 / Node 22.23.0 / npm 10.9.8 all verified against pins. Non-interactive shell sourcing requirement documented. |
| 2026-06-21 | Phase 0 (Claude Cowork + Desktop Commander) | PASS — full baseline established | WSL=/mnt/l confirmed; Hermes v0.5.6 baselined; Ollama+qwen3.6:35b-a3b PASS; ports 3000/9000/9119/11434 in use; NightSchool range 8100-8199 reserved; .tools/ cleanup confirmed |

---

## Model Routing Audit Log

*(Lane F records model lane used for major work each phase — flags drift if local Qwen is used where frontier was required)*

| Date | Phase | Work item | Model lane used | Flag? |
|---|---|---|---|---|
| — | — | — | — | — |


