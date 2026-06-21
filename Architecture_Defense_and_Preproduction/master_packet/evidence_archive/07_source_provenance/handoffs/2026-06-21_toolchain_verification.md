# Toolchain Verification Note
**Date:** 2026-06-21  
**Verified by:** Codex (independent check of operator's WSL environment)  
**Status:** PASS — toolchain ready, pre-architecture-defense pass fully closed

---

## Evidence

| Tool | Expected | Actual | Result |
|---|---|---|---|
| pyenv | 2.7.2 | 2.7.2 | ✓ PASS |
| Python (via `.python-version` pin) | 3.11.9 | 3.11.9 | ✓ PASS |
| nvm | 0.40.3 | 0.40.3 | ✓ PASS |
| Node (via `.nvmrc` pin, `nightschool` alias) | 22.23.0 | v22.23.0 | ✓ PASS |
| npm | 10.9.8 | 10.9.8 | ✓ PASS |

Version pins active and reading correctly from `Prototype_workingFiles/.python-version` and `Prototype_workingFiles/.nvmrc`.

---

## Outstanding Manual Step

- [ ] **Delete `.tools/` directory** from `Prototype_workingFiles` using your WSL terminal:
  ```bash
  cd /mnt/l/WSL_Projects_Folder/Nightschool_Study/Prototype_workingFiles
  rm -rf .tools/
  ```
  This is a failed pyenv clone artifact from the Cowork sandbox (NTFS lock file permissions prevent the sandbox from deleting it). Your WSL terminal can remove it directly.

---

## Non-Interactive Shell Sourcing (Lane F flag target)

`nvm` loads via shell startup — interactive terminals work automatically. Any script or automation that runs in a non-interactive shell and needs Node must include this preamble:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm use  # reads .nvmrc
```

Lane F should flag any automation script in the build that calls `node` or `npm` without this block. This applies to any Hermes agent hooks, Phase 4 dashboard startup scripts, or Phase 6 automation triggers.

---

## Pre-Architecture-Defense Pass: CLOSED

All items from the pre-pass are now resolved:

| Item | Status |
|---|---|
| PRD filename corrected | ✓ Done |
| PRD v4 with frontier-first routing policy (5 explicit rules) | ✓ Done |
| Ollama + qwen3.6:latest confirmed as fallback/local lane | ✓ Done |
| Nemotron Super as primary, Ultra as escalation | ✓ Done |
| Architecture_Defense folder classified | ✓ Done |
| Phase 0/1 scope realigned | ✓ Done |
| pyenv installed, Python 3.11.9 pinned and verified | ✓ Done |
| nvm 0.40.3 installed, Node 22.23.0 pinned and verified | ✓ Done |
| DEPENDENCIES.md created and populated | ✓ Done |
| isolation_manifest.md created with drift check + routing audit log | ✓ Done |
| setup_pyenv.sh and setup_nvm.sh scripts written | ✓ Done |
| `.tools/` cleanup documented (manual step pending) | Pending — operator's WSL terminal |

---

## What Phase 0 Execution Inherits

The Phase 0 session reads:
1. `PRD/NightSchool_PRD_and_Execution_System.md` — §1, §9 Phase 0 cards, §10
2. `handoffs/2026-06-21_cowork_kickoff_debrief.md` — §5 evidence template

Phase 0 arrives with:
- Version managers and runtime pins already verified
- DEPENDENCIES.md and isolation_manifest.md already scaffolded (Phase 0 fills in the primary Hermes baseline section)
- Model routing policy explicit in the PRD
- All pre-pass decisions resolved

Phase 0 remaining work: WSL mount path confirmation, primary Hermes baseline (read-only), Ollama reachability check, port audit, Lane F skeleton completion, `.tools/` cleanup, verification note.

