# NightSchool Study Assistant Naming Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Distinguish the NightSchool Study Assistant software from Larry's Wednesday-night NightSchool class and add a concise system overview to the Gauntlet postmortem index.

**Architecture:** Update only the reader-facing cover and index Markdown. Preserve archived evidence, filenames, folder names, and quoted source text so provenance remains accurate.

**Tech Stack:** Markdown, PowerShell/Ripgrep verification.

---

### Task 1: Standardize reader-facing naming

**Files:**
- Modify: `README_START_HERE.md`
- Modify: `00_cover_letter/draft_cover_note.md`
- Modify: `00_cover_letter/executive_summary.md`
- Modify: `00_cover_letter/timeline.md`
- Modify: `00_cover_letter/lessons_learned.md`
- Modify: `index/README.md`
- Modify: `index/artifact_manifest.md`
- Modify: `index/source_map.md`
- Modify: `index/verification_notes.md`

- [ ] Replace narrative uses of the software name with `NightSchool Study Assistant`.
- [ ] Preserve literal filenames and archive paths containing `NightSchool` or `nightschool`.
- [ ] Add a naming note that `NightSchool class` means Larry's Wednesday-night class, while `NightSchool Study Assistant` means the software.

### Task 2: Add the project overview

**Files:**
- Modify: `index/README.md`

- [ ] Explain that the software is a mission-control system forked from Hermes to complete NightSchool class tasks.
- [ ] Describe Bill as Telegram orchestrator and Vault, Scholar, Quiz Master, Planner, and Dev as Discord specialists.
- [ ] Describe the PDF-to-storage-to-notes-to-study-materials-to-deadlines workflow.
- [ ] Describe Mission Control and the ADR/specification/decision-log process for PRD execution.

### Task 3: Verify terminology and provenance

**Files:**
- Verify: all reader-facing Markdown listed in Task 1.

- [ ] Run a case-insensitive `nightschool` scan across the reader-facing files.
- [ ] Confirm every narrative reference uses the full software name or the explicit class label.
- [ ] Confirm archive paths and filenames were not renamed.
