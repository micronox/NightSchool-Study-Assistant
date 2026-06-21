# Source Map: Claims to Artifacts

| Claim | Evidence | Strength / limitation |
|---|---|---|
| The NightSchool Study Assistant toolchain and Phase 0 baseline were verified | `02_recovery_and_audit/2026-06-21_toolchain_verification.md`; `02_recovery_and_audit/2026-06-21_phase0_verification.md` | Strong. Direct commands, versions, paths, and results are recorded. |
| Hermes exposes state-isolation controls | `02_recovery_and_audit/2026-06-21_phase1_hermes_discovery.md` | Strong for source discovery; the note itself does not prove a successful isolated launch. |
| The original isolation plan contained unsafe assumptions | `03_architecture_defense/2026-06-21-075947_phase1_codex_architecture_defense_review.md` | Strong. Source-level findings identify the singleton lock, bootstrap writes, and ephemeral-port behavior. |
| A revised sequential Phase 1A design was approved | `03_architecture_defense/2026-06-21-075947_phase1_codex_architecture_defense_review.md`; `03_architecture_defense/2026-06-21-085434-architecture-defense-lite-handoff.md`; `05_validation_checkpoints/2026-06-21-032213_phase1A_execution_spec.md` | Strong for design approval and guardrails; execution remained a next step. |
| The NightSchool Study Assistant is deliberately scoped and gated | `04_nightschool_scope/NightSchool_PRD_and_Execution_System.md`; `04_nightschool_scope/isolation_manifest.md`; `04_nightschool_scope/DEPENDENCIES.md` | Strong for planned scope, ownership, dependencies, and gates. Later unchecked cards are not completed work. |
| Backup and restore concerns received independent review | `06_supporting_briefs/2026-06-21_kopia_lane_f_spec.md`; `06_supporting_briefs/2026-06-21-081000-kopia-lane-f-codex-answers.md` | Strong for reviewed design; the spec's implementation and final sign-off steps are not proven complete here. |
| Work was routed across multiple tools with context-conscious handoffs | `06_supporting_briefs/2026-06-21-091053_hermes_parallel_payload.md`; `03_architecture_defense/2026-06-21-085434-architecture-defense-full-context.md`; `04_nightschool_scope/NightSchool_PRD_and_Execution_System.md` | Moderate. Supports cost-aware routing and context reduction, not a quantified financial-savings claim. |
| The NightSchool Study Assistant is intended to de-risk `myLearningSidekick` | `07_source_provenance/handoffs/2026-06-21-093507_hermes_lane3_gauntlet_postmortem_payload.md` | Stated strategic intent only. The curated archive does not independently document the original `myLearningSidekick` pitch or downstream technical mapping. |
| The prior environment was approximately 450 GB with duplicate PopOS/code sprawl | Packet brief only | Unverified in the curated archive. Keep out of reader-facing factual claims unless a disk inventory/audit is added. |

## Evidence status vocabulary

- **Verified:** direct inspection or command evidence is recorded.
- **Approved:** a design passed review but may not have been executed.
- **Planned:** a specification, checklist, or unchecked PRD card describes future work.
- **Stated intent:** a strategic relationship is asserted but not independently evidenced in this archive.
