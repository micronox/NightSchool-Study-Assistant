# Timeline: June 19-21, 2026

This timeline is best read as a weekend case write-up rather than a one-day build log. Friday, June 19, 2026 was effectively the branch point: work began in an exploratory mode, pivoted repeatedly as constraints surfaced, and only reached stable technical footing on Sunday, June 21, 2026 after rollback boundaries and architecture constraints were clear.

Times below are used only when encoded in a source filename. Untimed entries follow the documented phase sequence rather than implying unsupported clock precision.

- **Friday, June 19** — Work effectively branched into a protected recovery and architecture-defense lane. The goal was not yet to ship; it was to discover what shape of implementation would actually be safe.
- **Saturday, June 20** — The problem unfolded through troubleshooting, handoffs, environment review, and constraint discovery. The original idea of quickly pushing forward gave way to a more careful model as hidden dependencies and state risks became clearer.
- **Sunday, June 21 (early)** — Kopia and the supporting Lane F backup logic created the first trustworthy rollback boundary, making it practical to treat the work as a protected local branch rather than a loose sequence of experiments.
- **03:17:58** — ADR-001 proposed a dual-instance Hermes isolation design and explicitly held acceptance behind Codex review.
- **Phase 0** — WSL access, the primary Hermes baseline, Ollama reachability, available ports, dependency records, and cleanup were verified. Phase 0 passed with one PRD model-name correction noted.
- **Phase 1 discovery** — Read-only source inspection identified `HERMES_DESKTOP_USER_DATA_DIR` and `HERMES_HOME` as isolation controls. The discovery note proposed a separate profile design but left launch validation as future work.
- **07:59:47** — Codex architecture defense rejected the original plan as written. It found the desktop single-instance lock, unsafe user-scoped writes in fresh bootstrap, and the stale fixed-port assumption; it approved a revised sequential Phase 1A path.
- **08:10:00** — The Kopia review addendum answered the open policy, restore-scope, and CLI questions and approved the design with operational redlines.
- **08:54:34** — The architecture-defense handoff consolidated the stable constraints and recorded the safe-launch preparation state.
- **09:10:53** — A parallel payload split independent planning work into Discord architecture and Phase 1A review while preserving the rule that an actual Hermes desktop launch remains sequential.
- **09:35:07** — The Gauntlet AI packet brief was issued, defining the evidence-first postmortem and the intended NightSchool Study Assistant-to-`myLearningSidekick` bridge.

## State at packet cutoff

Verified: toolchain baseline, rollback footing, Phase 0, Hermes source findings, architecture redlines, and the revised Phase 1A design.

Prepared but not proven complete in the curated archive: the first controlled NightSchool Study Assistant Hermes launch, post-launch isolation checks, full Kopia policy implementation, and later Study Assistant product phases.
