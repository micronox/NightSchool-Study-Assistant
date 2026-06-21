# NightSchool — DEPENDENCIES.md
# Lane F tracks this file. Every new dependency added to Prototype_workingFiles
# gets a row here BEFORE it's used. No silent installs.
# Format: | Name | Version | Purpose | Install scope | Added by | Date |

## Version Managers

| Name | Version | Purpose | Install scope | Added by | Date |
|---|---|---|---|---|---|
| pyenv | 2.7.2 | Python version management — pins Python 3.11.9 for NightSchool isolated env | WSL home (`~/.pyenv`) — NOT inside Prototype_workingFiles, NOT in primary Hermes env | Claude (Cowork) | 2026-06-21 |
| pyenv-virtualenv | latest (plugin) | venv creation/activation via pyenv | `~/.pyenv/plugins/pyenv-virtualenv` | Claude (Cowork) | 2026-06-21 |
| nvm | 0.40.3 | Node version management — pins Node 22.23.0 for NightSchool isolated env | WSL home (`~/.nvm`) — NOT inside Prototype_workingFiles, NOT in primary Hermes env | Claude (Cowork) | 2026-06-21 |

## External Tools

| Name | Version | Purpose | Install scope | Added by | Date |
|---|---|---|---|---|---|
| Kopia CLI | 0.23.1 | Lane F snapshot evidence, pre-launch primary Hermes baselines, NightSchool runtime rollback points | Windows local install at `$APPDATA_LOCAL_ROOT\Programs\KopiaUI\resources\server\kopia.exe`; repository at `$KOPIA_REPO` | operator + Codex review | 2026-06-21 |

**Verification status (2026-06-21, confirmed by Codex):**
- `pyenv --version` → `pyenv 2.7.2` ✓
- `python --version` (via pyenv, `.python-version` pin) → `Python 3.11.9` ✓
- `nvm --version` → `0.40.3` ✓
- `node --version` (via nvm, `.nvmrc` pin) → `v22.23.0` ✓
- `npm --version` → `10.9.8` ✓

## Pinned Runtime Versions

| Runtime | Pinned version | Pin file | Verified | Notes |
|---|---|---|---|---|
| Python | 3.11.9 | `.python-version` | ✓ 2026-06-21 | pyenv reads this automatically when you cd into Prototype_workingFiles |
| Node | 22.23.0 (LTS "jod") | `.nvmrc` | ✓ 2026-06-21 | nvm reads this automatically on `nvm use`; nvm alias `nightschool` points here |

**Non-interactive shell note (important for automation):** `nvm` is loaded via shell startup (`.bashrc`/`.zshrc`). Scripts that run in non-interactive shells (cron, systemd, CI) will not have nvm in PATH automatically. Any script that needs Node must explicitly source nvm before use:
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm use  # picks up .nvmrc
```
Add this preamble to any automation scripts that invoke Node. Lane F should flag any script that calls `node` or `npm` directly without this sourcing block.

## Python Packages
*(populated in Phase 1 as packages are installed into the NightSchool venv)*

| Package | Version | Purpose | Added by | Date |
|---|---|---|---|---|
| — | — | — | — | — |

## Node Packages
*(populated in Phase 1 as packages are installed)*

| Package | Version | Purpose | Added by | Date |
|---|---|---|---|---|
| — | — | — | — | — |

## Cleanup Required (Phase 0 task)

| Item | Action | Reason |
|---|---|---|
| `Prototype_workingFiles/.tools/` | Delete this entire directory from your WSL terminal: `rm -rf .tools/` | Artifact of a failed pyenv clone attempt in the Cowork sandbox (NTFS lock file restriction). Run this from your WSL terminal where you have proper permissions. Verify gone before proceeding. |

## System Dependencies
*(populated as apt/system-level installs are made)*

| Package | Version | Purpose | Added by | Date |
|---|---|---|---|---|
| build-essential | system | Python compilation prerequisites for pyenv | Phase 0 setup script | 2026-06-21 |
| libssl-dev, zlib1g-dev, etc. | system | Python build deps | Phase 0 setup script | 2026-06-21 |

---
*Lane F policy: run a diff of this file at the start of every session that touches packages. 
Any package present in the environment but not listed here is a Lane F flag.*


