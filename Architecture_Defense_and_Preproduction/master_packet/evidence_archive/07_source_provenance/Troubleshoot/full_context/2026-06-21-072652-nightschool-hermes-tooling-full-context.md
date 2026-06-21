# Full Context Log — NightSchool / Hermes / Tooling

- Date: 2026-06-21
- Timecode: 07:26:52 America/Chicago
- Purpose: detailed continuity log covering Hermes local-model recovery, CUDA vetting, NightSchool PRD review, WSL toolchain setup, and plugin/install audit state

## 1. Hermes local-model lane

### Confirmed current Hermes state

- Hermes desktop/runtime is working.
- Hermes main model was successfully brought back to a local custom-endpoint lane.
- Confirmed working local lane:
  - provider: `Custom endpoint`
  - model: `qwen3.6:latest`
- Hermes chat UI later self-reported:
  - "I'm running qwen3.6:latest via a custom endpoint."
- A local model check against Ollama's OpenAI-compatible endpoint returned:
  - `qwen3.6:latest`
  - `qwen3-coder:30b`
  - `gemma4:26b`
- `hermes status` confirmed:
  - Model: `qwen3.6:latest`
  - Provider: `Custom endpoint`
- Nous Portal auth is active as well.

### Important nuance

- A later Phase 0 note from Claude reported the installed/resolved Ollama model as:
  - `qwen3.6:35b-a3b`
- Best interpretation:
  - `qwen3.6:latest` is the configured alias
  - `qwen3.6:35b-a3b` is the resolved concrete model observed on disk/runtime
- Future notes should preserve both if possible:
  - configured alias
  - resolved concrete model

### Model-picker debugging outcome

- Initial Hermes UI was surfacing remote Qwen/Nous/OpenRouter entries rather than the local custom lane.
- Root config was correct, but the desktop provider registration was incomplete.
- Fix path:
  - Settings -> Model
  - choose `Custom endpoint`
  - point to `http://127.0.0.1:11434/v1`
  - select `qwen3.6:latest`
  - apply and restart
- After that, the desktop UI reflected the custom endpoint correctly.

## 2. CUDA / local inference vetting

### Verified

- Windows `nvidia-smi` sees the RTX PRO 6000 Blackwell card.
- WSL `nvidia-smi` sees the same GPU.
- CUDA toolkit present in WSL:
  - `nvcc` installed
  - CUDA 13.3 toolchain reported
- A compiled CUDA smoke test ran successfully against the GPU.
- Ollama live inference showed:
  - `qwen3.6:latest`
  - processor: `100% GPU`
- During live model inference, `nvidia-smi` showed high GPU memory/power/utilization consistent with real inference.

### Interpretation

- CUDA is not merely installed; it is operational.
- Ollama local inference is genuinely GPU-backed.
- No CUDA reinstall was justified based on observed evidence.

### Saved note

- Prior related artifact:
  - [2026-06-21-042300-cuda-vet-and-blueprint-review.md](C:/Users/larry/Documents/Troubleshoot/full_context/2026-06-21-042300-cuda-vet-and-blueprint-review.md)

## 3. Architecture blueprint / Nimbalyst / Headroom / Ponytail

### Nimbalyst

- Nimbalyst was identified as a visual operator/workspace layer rather than a replacement for runtime routing/backends.
- Recommended interpretation:
  - Hermes / agent-native / ponytail / Ollama = execution/runtime plane
  - Nimbalyst = operator/control/visual workspace plane
- It was explicitly noted that the older master blueprint was incomplete without Nimbalyst.

### Headroom

- Headroom was not installed.
- A dedicated vetting document was produced under:
  - `L:\WSL_Projects_Folder\Architecture_Defense\headroom_install_vetting.md`
- Review conclusion from saved evidence:
  - native Windows path should be treated as blocked for now
  - WSL path is conditionally viable
- Suggested wording correction for future notes:
  - "native Windows blocked; WSL installation path conditionally viable"

### Ponytail

- Claude Code:
  - verified active
  - evidence reportedly via `claude plugin list`
- Codex CLI:
  - marketplace registered
  - plugin files staged/copied
  - live runtime activation still not fully verified
- Safe wording:
  - Claude Code: verified active
  - Codex CLI: staged / pending live verification

### Review note on saved artifact paths

- The preinstall note and backup artifacts do exist in `L:\WSL_Projects_Folder\Architecture_Defense\...`
- But the saved filenames use a Windows-safe substituted colon glyph in timestamps rather than a literal `:`
- Future notes should prefer a filesystem-safe timestamp format like:
  - `YYYY-MM-DDTHHMMZ`
  - or `YYYY-MM-DD-HHMMSS`

## 4. NightSchool PRD / Architecture Defense review

### Main review findings

These were flagged as the important PRD/debrief corrections:

1. Canonical PRD filename needed normalization.
2. Phase 0 and Phase 1 scope were inconsistent between the PRD and kickoff debrief.
3. "Before Phase 0" user prerequisites conflicted with items the cowork session was meant to discover in Phase 0.
4. Backup/update instructions mixed PRD filenames.
5. Evidence-note instructions had a counting mismatch.

### Claude follow-up questions and resolved answers

#### Primary Hermes install baseline

- Not a greenfield AI environment.
- Primary/worker Hermes baseline exists externally.
- It should not be assumed to live inside the NightSchool project tree.
- Phase 0 should document the actual external baseline read-only.

#### Ollama + Qwen3.6 local stack

- Confirmed answer: yes
- Local runtime choice should no longer be treated as speculative.

#### `Architecture_Defense` folder classification

- Treat as adjacent architecture/audit/reference context
- Not the NightSchool runtime root
- Relevant for planning and review, not the app workspace itself

### Model routing policy that should persist in PRD language

- Default frontier lane:
  - `Nemotron 3 Super 120b A12b:Free`
- Frontier escalation lane:
  - `Nemotron 3 Ultra 550b A55b:Free`
- Local fallback/mechanical lane:
  - `qwen3.6` via Ollama

### Key enforcement principle

- Do not let later agents silently drift back to local-Qwen-first wording just because Qwen is present and working.
- Frontier-first should remain the policy for higher-level planning/synthesis/controller work.

## 5. WSL toolchain setup for NightSchool

### Manual WSL actions completed by user

- WSL terminal launched successfully.
- Correct Linux path used:
  - `/mnt/l/WSL_Projects_Folder/Nightschool_Study/Prototype_workingFiles`
- Cleanup command completed successfully:
  - `rm -rf .tools/`

### Python toolchain

- `scripts/setup_pyenv.sh` was run.
- `pyenv` installed successfully.
- Python 3.11.9 compiled/installed successfully.
- Verified in reopened shell:
  - `pyenv --version` -> working
  - `python --version` -> `Python 3.11.9`

### Node toolchain

- `nvm` installed successfully.
- Project `.nvmrc` pinned version:
  - `22.23.0`
- Verified:
  - `nvm --version` -> `0.40.3`
  - `node --version` -> `v22.23.0`
  - `npm --version` -> `10.9.8`

### Important caveat carried forward

- Any non-interactive shell automation using Node must explicitly source `nvm` first before invoking Node/npm.

## 6. NightSchool Phase progression

### Pre-architecture-defense pass

- Claude later stated this pass was closed.
- Toolchain prep and routing-policy clarification were treated as resolved.

### Phase 0 close

Claude reported Phase 0 closed with evidence for:

- WSL mount:
  - `L:` -> `/mnt/l`
- Primary Hermes baseline:
  - desktop v0.5.6
  - config under roaming `Hermes`
  - local API / gateway surface at `localhost:9119`
- Ollama reachability and model:
  - `qwen3.6:35b-a3b`
  - localhost `11434`
- Port range reserved:
  - `8100–8199`
- Lane F skeleton populated:
  - `isolation_manifest.md`
  - `DEPENDENCIES.md`

### Phase 1 block and architecture fork

Claude correctly stopped before doing the wrong thing.

Important discovery:

- Hermes is a Windows Electron desktop app, not a pip package, npm package, or simple CLI/server to install into a Python venv.
- That means "isolated NightSchool Hermes install" was ambiguous and needed reinterpretation.

Recommended direction given back:

- Choose Option A:
  - a second Hermes desktop/profile lane
  - with separate NightSchool profile/config/state if supported
- Do not reinterpret Phase 1 as:
  - pip-install Hermes
  - npm-install Hermes
  - reuse primary profile blindly

### Phase 1 guidance provided

- Discover whether Hermes supports:
  - user-data/profile override
  - alternate roaming/appdata path
  - profile/channel separation
  - CLI flags or Electron-style profile isolation
- If supported:
  - create a NightSchool-specific isolated profile lane
- If not:
  - stop and propose the safest fallback before mutating the live primary profile

## 7. Current recommended decisions and policies

### For NightSchool model routing

- Primary frontier lane:
  - `Nemotron 3 Super 120b A12b:Free`
- Escalation frontier lane:
  - `Nemotron 3 Ultra 550b A55b:Free`
- Local fallback lane:
  - `qwen3.6` via Ollama

### For Codex Ponytail

- Do not force a hacky manual runtime activation right now unless Codex immediately needs Ponytail for this project.
- Preserve current state as pending live verification.

### For Hermes desktop / Mission Control style work

- Treat new desktop work as a separate dev lane from the stable live Hermes desktop.
- Prefer profile/userData separation over mutating the live stable profile.

## 8. Known contradictions / points to watch

1. `qwen3.6:latest` vs `qwen3.6:35b-a3b`
- Most likely alias vs resolved concrete installed model
- Should be documented together going forward

2. NightSchool Phase 1 wording
- Any remaining language that sounds like "install Hermes into a venv" should be corrected
- It should instead refer to an isolated desktop/profile lane if Hermes supports it

3. Ponytail status wording
- Codex should not be overclaimed as verified yet

4. Backup timestamps in Architecture_Defense
- Paths should use filesystem-safe timestamp formatting for future note reliability

## 9. Suggested next action if resuming this work

1. Continue with Claude on NightSchool Phase 1 only after the Hermes desktop/profile isolation question is converted into a concrete implementation path.
2. Have Claude perform a narrow recon of Hermes desktop profile/userData separation support.
3. Keep Codex Ponytail in pending status unless a safe native verification/install path emerges.
4. Keep Headroom deferred until WSL-only install/testing is intentionally opened.

## 10. Related artifacts

- [2026-06-21-041207-hermes-full-context.md](C:/Users/larry/Documents/Troubleshoot/full_context/2026-06-21-041207-hermes-full-context.md)
- [2026-06-21-042300-cuda-vet-and-blueprint-review.md](C:/Users/larry/Documents/Troubleshoot/full_context/2026-06-21-042300-cuda-vet-and-blueprint-review.md)

