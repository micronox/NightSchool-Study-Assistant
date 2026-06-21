# Lite Handoff — NightSchool / Hermes

- Date: 2026-06-21
- Time: 07:26:52 America/Chicago
- Purpose: fast reset-ready handoff for a new chat

## Current stable facts

- Hermes local desktop/runtime is working again.
- Confirmed local lane:
  - provider: `Custom endpoint`
  - model alias: `qwen3.6:latest`
- Later NightSchool Phase 0 evidence observed the concrete installed model as:
  - `qwen3.6:35b-a3b`
- Best interpretation:
  - alias = `qwen3.6:latest`
  - resolved local model = `qwen3.6:35b-a3b`

- CUDA/local inference is healthy:
  - Windows + WSL GPU both detected
  - compiled CUDA smoke test passed
  - Ollama inference used GPU successfully

## NightSchool project state

- WSL project path verified:
  - `/mnt/l/WSL_Projects_Folder/Nightschool_Study/Prototype_workingFiles`
- WSL toolchain setup completed:
  - `pyenv` working
  - Python `3.11.9`
  - `nvm` working
  - Node `22.23.0`
  - npm `10.9.8`

- Carry-forward caveat:
  - any non-interactive shell automation using Node must explicitly source `nvm` first

- Claude reported:
  - pre-architecture-defense pass: closed
  - Phase 0: closed

## NightSchool routing policy

- Default frontier lane:
  - `Nemotron 3 Super 120b A12b:Free`
- Frontier escalation lane:
  - `Nemotron 3 Ultra 550b A55b:Free`
- Local fallback/mechanical lane:
  - `qwen3.6` via Ollama

- Important:
  - do not let future notes drift back to local-Qwen-first just because local Qwen works

## Plugin/install audit state

- Headroom:
  - native Windows blocked
  - WSL path conditionally viable
  - vetting doc exists under `L:\WSL_Projects_Folder\Architecture_Defense\headroom_install_vetting.md`

- Ponytail:
  - Claude Code: verified active
  - Codex CLI: staged / marketplace registered / live verification still pending
  - do not overstate Codex as fully verified yet

## Main open architectural question

NightSchool Phase 1 hit the real fork:

- Hermes is a Windows Electron desktop app, not something to pip-install into a venv
- "isolated NightSchool Hermes install" should be interpreted as:
  - preferred: a second Hermes desktop/profile lane with separate config/state if supported

Recommended next move:

1. Have Claude do a narrow recon of Hermes desktop profile/userData separation support.
2. If Hermes supports profile separation:
   - create NightSchool as a second isolated desktop/profile lane
3. If not:
   - stop before mutating the live primary Hermes profile
   - propose safest fallback

## Recommended next action

Resume with:
- Claude on Phase 1 recon for Hermes desktop/profile isolation
- no manual Codex Ponytail hack unless urgently needed
- Headroom still deferred until intentionally opened in WSL

## Detailed log

For full continuity, see:
- [2026-06-21-072652-nightschool-hermes-tooling-full-context.md](C:/Users/larry/Documents/Troubleshoot/full_context/2026-06-21-072652-nightschool-hermes-tooling-full-context.md)

