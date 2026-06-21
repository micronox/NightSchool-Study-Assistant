# Hermes Current Handoff

- Date: 2026-06-21
- Time: 04:12:07 America/Chicago
- Purpose: concise reset-ready handoff after local-model cleanup, portal auth, fallback setup, and proposal refinement

## Current Verified State

- Hermes local primary works
- Primary model: `qwen3.6:latest`
- Primary provider: `custom`
- Primary endpoint: `http://127.0.0.1:11434/v1`
- `hermes -z "Reply with exactly LOCAL_OK"` returned `LOCAL_OK`
- Nous Portal is logged in
- Hermes fallback chain is configured:
  - `anthropic/claude-sonnet-4.6` via `nous`

## Desktop State

- The stale Hermes desktop local storage was rotated out
- Fresh desktop local storage was rebuilt by the packaged Hermes desktop app
- The stale `qwen3.6:35b-a3b` sticky desktop model state is gone
- Preserved stale desktop store:
  - `C:\Users\larry\AppData\Roaming\Hermes\Local Storage.preclean-20260621-035340`

## Proposal State

- Refined proposal saved:
  - [HERMES-MODEL-INFRA-UPGRADE-REFINED-2026-06-21.md](C:/Users/larry/Documents/Troubleshoot/HERMES-MODEL-INFRA-UPGRADE-REFINED-2026-06-21.md)
- Current interpretation:
  - Track A is functionally achieved in practice
  - performance tuning is still unmeasured
  - Track B and Track C should stay deferred until benchmarks are run

## Organizational Rule Added

- New logging rule:
  - exported notes and handoffs should include both date and timecode in filenames
- New folder structure:
  - `C:\Users\larry\Documents\Troubleshoot\handoff`
  - `C:\Users\larry\Documents\Troubleshoot\full_context`

## Recommended Next Step

Run the benchmark-and-routing baseline described in the refined proposal:

- measure local Hermes latency
- measure direct Ollama latency
- measure cloud fallback latency
- decide whether current Hermes is already fast enough or whether further CUDA/runtime work is justified

## Key References

- [TROUBLESHOOT-OPERATING-RULES.md](C:/Users/larry/Documents/Troubleshoot/TROUBLESHOOT-OPERATING-RULES.md)
- [HERMES-MODEL-INFRA-UPGRADE-REFINED-2026-06-21.md](C:/Users/larry/Documents/Troubleshoot/HERMES-MODEL-INFRA-UPGRADE-REFINED-2026-06-21.md)
- [HERMES-HARDENING-RUNBOOK-2026-06-21.md](C:/Users/larry/Documents/Troubleshoot/HERMES-HARDENING-RUNBOOK-2026-06-21.md)
- [CODEX-CHANGELOG-2026-06-21-HERMES-QWEN-LOCAL-NOUS-BACKUP-PENDING.md](C:/Users/larry/Documents/Troubleshoot/CODEX-CHANGELOG-2026-06-21-HERMES-QWEN-LOCAL-NOUS-BACKUP-PENDING.md)
