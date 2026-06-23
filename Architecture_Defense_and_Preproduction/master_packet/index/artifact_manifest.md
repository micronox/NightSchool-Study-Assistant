# Artifact Manifest

Paths are relative to this `index/` folder.

## Reader-facing documents

- [../00_cover_letter/draft_cover_note.md](../00_cover_letter/draft_cover_note.md) — Larry-facing draft email; deliberately avoids claiming product completion.
- [../00_cover_letter/executive_summary.md](../00_cover_letter/executive_summary.md) — concise verified-outcome and current-state summary.
- [../00_cover_letter/timeline.md](../00_cover_letter/timeline.md) — phase sequence with only filename-backed clock times.
- [../00_cover_letter/lessons_learned.md](../00_cover_letter/lessons_learned.md) — operating lessons and next proof milestone.
- [README.md](README.md) — packet navigation.
- [source_map.md](source_map.md) — claim-to-artifact mapping with evidence-strength labels.
- [verification_notes.md](verification_notes.md) — corrections, evidence gaps, and remaining handoff checks.

## Curated evidence

### Pitch and project framing

- [../evidence_archive/01_pitch_origin/2026-06-21_cowork_kickoff_debrief.md](../evidence_archive/01_pitch_origin/2026-06-21_cowork_kickoff_debrief.md) — kickoff handoff and decision-gate expectations.
- [../evidence_archive/01_pitch_origin/NightSchool_PRD_and_Execution_System.md](../evidence_archive/01_pitch_origin/NightSchool_PRD_and_Execution_System.md) — NightSchool Study Assistant operating plan; despite this filename and folder name, it is not the original `myLearningSidekick` application.

### Recovery and audit

- [../evidence_archive/02_recovery_and_audit/2026-06-21_toolchain_verification.md](../evidence_archive/02_recovery_and_audit/2026-06-21_toolchain_verification.md) — pinned runtime verification and pre-pass status.
- [../evidence_archive/02_recovery_and_audit/2026-06-21_phase0_verification.md](../evidence_archive/02_recovery_and_audit/2026-06-21_phase0_verification.md) — WSL, Hermes baseline, Ollama, ports, and Phase 0 gate evidence.
- [../evidence_archive/02_recovery_and_audit/2026-06-21_phase1_hermes_discovery.md](../evidence_archive/02_recovery_and_audit/2026-06-21_phase1_hermes_discovery.md) — read-only discovery of Hermes isolation controls.
- [../evidence_archive/02_recovery_and_audit/2026-06-21_phase1_codex_architecture_brief.md](../evidence_archive/02_recovery_and_audit/2026-06-21_phase1_codex_architecture_brief.md) — questions submitted for independent review.
- [../evidence_archive/02_recovery_and_audit/2026-06-21_phase1_codex_architecture_defense_review.md](../evidence_archive/02_recovery_and_audit/2026-06-21_phase1_codex_architecture_defense_review.md) — copy of the independent review retained in the recovery sequence.

### Architecture defense

- [../evidence_archive/03_architecture_defense/2026-06-21-031758_ADR-001_hermes_dual_instance_isolation.md](../evidence_archive/03_architecture_defense/2026-06-21-031758_ADR-001_hermes_dual_instance_isolation.md) — original proposed ADR, useful because its unresolved state is explicit.
- [../evidence_archive/03_architecture_defense/2026-06-21-075947_phase1_codex_architecture_defense_review.md](../evidence_archive/03_architecture_defense/2026-06-21-075947_phase1_codex_architecture_defense_review.md) — decisive redlines and revised Phase 1A approval.
- [../evidence_archive/03_architecture_defense/2026-06-21-085434-architecture-defense-lite-handoff.md](../evidence_archive/03_architecture_defense/2026-06-21-085434-architecture-defense-lite-handoff.md) — compact stable-facts handoff.
- [../evidence_archive/03_architecture_defense/2026-06-21-085434-architecture-defense-full-context.md](../evidence_archive/03_architecture_defense/2026-06-21-085434-architecture-defense-full-context.md) — full continuity and routing context.

### NightSchool Study Assistant scope

- [../evidence_archive/04_nightschool_scope/NightSchool_PRD_and_Execution_System.md](../evidence_archive/04_nightschool_scope/NightSchool_PRD_and_Execution_System.md) — phased Study Assistant PRD, gates, and completion cards.
- [../evidence_archive/04_nightschool_scope/isolation_manifest.md](../evidence_archive/04_nightschool_scope/isolation_manifest.md) — boundary and drift-control record.
- [../evidence_archive/04_nightschool_scope/DEPENDENCIES.md](../evidence_archive/04_nightschool_scope/DEPENDENCIES.md) — dependency ownership and verification ledger.
- [../evidence_archive/04_nightschool_scope/2026-06-21_PRD_review.md](../evidence_archive/04_nightschool_scope/2026-06-21_PRD_review.md) — scope corrections and open-question review.

### Validation checkpoints

- [../evidence_archive/05_validation_checkpoints/2026-06-21-032213_phase1A_execution_spec.md](../evidence_archive/05_validation_checkpoints/2026-06-21-032213_phase1A_execution_spec.md) — controlled launch specification.
- [../evidence_archive/05_validation_checkpoints/2026-06-21_phase1A_larry_instructions.md](../evidence_archive/05_validation_checkpoints/2026-06-21_phase1A_larry_instructions.md) — operator steps and stop conditions; instructions are not proof they were executed.

### Supporting briefs

- [../evidence_archive/06_supporting_briefs/2026-06-21_kopia_lane_f_spec.md](../evidence_archive/06_supporting_briefs/2026-06-21_kopia_lane_f_spec.md) — backup/restore design before implementation.
- [../evidence_archive/06_supporting_briefs/2026-06-21-081000-kopia-lane-f-codex-answers.md](../evidence_archive/06_supporting_briefs/2026-06-21-081000-kopia-lane-f-codex-answers.md) — independent answers and operational redlines.
- [../evidence_archive/06_supporting_briefs/2026-06-21-091053_hermes_parallel_payload.md](../evidence_archive/06_supporting_briefs/2026-06-21-091053_hermes_parallel_payload.md) — multi-lane work split and guardrails.

## Raw provenance

[../evidence_archive/07_source_provenance/](../evidence_archive/07_source_provenance/) preserves copied source trees from the NightSchool Study Assistant handoffs/PRD, HermesAudit, and Troubleshoot roots. It is included for traceability rather than as the recommended reading path. Because it contains binaries, backups, and local-state artifacts, Larry should review it for necessity and disclosure risk before sending the whole folder externally.
