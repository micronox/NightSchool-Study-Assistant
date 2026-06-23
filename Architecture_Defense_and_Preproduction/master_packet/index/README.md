# Gauntlet AI Postmortem Packet

This packet documents the June 21 foundation-recovery and architecture-defense work that established the NightSchool Study Assistant as a controlled first slice. It distinguishes verified outcomes from approved designs and planned next steps. The Study Assistant is intended to de-risk the later `myLearningSidekick` rollout; that downstream relationship is strategic intent, not yet an executed result.

## Naming Note

**NightSchool Study Assistant** refers to the software system described in this packet. **NightSchool class** refers to Larry's Wednesday-night class. The Study Assistant exists to help complete and manage work for that class; the two names should not be used interchangeably.

## Project Overview & Demo

The NightSchool Study Assistant is a Mission Control system forked from Hermes and adapted to complete NightSchool class tasks. It turns course materials into coordinated research, study, planning, and development work while keeping the workflow visible and reviewable.

### System Architecture

The system uses six coordinated agents:

- **Bill** — the top-level orchestrator on Telegram. Bill receives requests, routes work, and coordinates the specialist agents.
- **Vault** — stores and organizes source materials and durable project knowledge.
- **Scholar** — converts source material into structured Markdown notes and research outputs.
- **Quiz Master** — creates quizzes, flashcards, review prompts, and other study materials.
- **Planner** — extracts deadlines, assignments, and scheduling requirements.
- **Dev** — handles technical implementation, automation, and supporting development work.

The five specialist agents operate through dedicated Discord channels, while Bill provides the primary orchestration layer on Telegram.

### Core Workflow

Uploading a PDF initiates a coordinated workflow: Vault stores and classifies the document; Scholar produces structured Markdown notes; Quiz Master turns those notes into study materials; and Planner identifies deadlines and adds the relevant work to the schedule. Dev supports any automation or implementation required by the workflow.

### Mission Control

A central web dashboard tracks agent activity, task status, logs, research, and planning from one interface. Mission Control makes the multi-agent workflow observable: Larry can see what was requested, which agent owns it, what evidence was produced, and what remains blocked or incomplete.

### PRD Execution and Architecture Governance

Product Requirement Documents are executed through an evidence-backed architecture process. Architecture Decision Records capture consequential technical choices; specification sheets define the approved implementation shape; and decision logs preserve why a direction was accepted, revised, or rejected. Work advances through explicit validation gates so implementation remains traceable to the PRD rather than drifting from it.

## Structure

- [00_cover_letter/](../00_cover_letter/) – Draft cover note, executive summary, timeline, and lessons learned for quick consumption.
- [evidence_archive/](../evidence_archive/) – Themed folders containing copied markdown proof and supporting artifacts.
- [index/](./) – This folder, containing navigational and reference documents.

## How to Read

1. Start with the [executive summary](../00_cover_letter/executive_summary.md) for a high-level overview.
2. Review the [timeline](../00_cover_letter/timeline.md) for chronological reconstruction.
3. Examine the [lessons learned](../00_cover_letter/lessons_learned.md) for insights on architecture defense, validation, scoped builds, and cost-aware tooling.
4. Dive into the [evidence_archive](../evidence_archive/) to verify claims:
   - [01_pitch_origin](../evidence_archive/01_pitch_origin/) – Original intent and pitch.
   - [02_recovery_and_audit](../evidence_archive/02_recovery_and_audit/) – Audit, recovery, and toolchain verification.
   - [03_architecture_defense](../evidence_archive/03_architecture_defense/) – Architecture defense artifacts, ADRs, architecture reviews.
   - [04_nightschool_scope](../evidence_archive/04_nightschool_scope/) – NightSchool Study Assistant PRD, scope, dependencies, and isolation manifest. The folder name is preserved for provenance.
   - [05_validation_checkpoints](../evidence_archive/05_validation_checkpoints/) – Phase 0, Phase 1A validation, execution specs.
   - [06_supporting_briefs](../evidence_archive/06_supporting_briefs/) – Kopia Lane F spec, Hermes parallel payload, etc.
   - [07_source_provenance](../evidence_archive/07_source_provenance/) – Raw source folders and files for provenance tracking.
5. Use the [artifact manifest](artifact_manifest.md) and [source map](source_map.md) to trace claims to specific artifacts.
6. Read [verification notes](verification_notes.md) for evidence gaps and pre-handoff review items.

## Notes

- This packet emphasizes show-don't-tell: claims are backed by copied markdown and knowledge artifacts.
- Raw source paths are preserved in the provenance folder for auditability.
- The narrative focuses on systems judgment, recovery discipline, and architecture maturity without claiming that planned launch or product phases were already completed.
