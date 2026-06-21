# External Share Guide

This packet now has two intended forms:

1. The full working packet in the repository root, which preserves provenance and internal review context.
2. `external_share_candidate/`, which is the recommended starting package for first-pass external review.

## Recommended package for External Review

Send `external_share_candidate/` first. It contains:

- `00_cover_letter/`
- `index/`
- `evidence_archive/01_pitch_origin/`
- `evidence_archive/02_recovery_and_audit/`
- `evidence_archive/03_architecture_defense/`
- `evidence_archive/04_nightschool_scope/`
- `evidence_archive/05_validation_checkpoints/`
- `evidence_archive/06_supporting_briefs/`
- a recipient-facing `README_START_HERE.md`

It intentionally excludes `evidence_archive/07_source_provenance/`, which is valuable for internal traceability but heavy for first-pass external review.

## Why the split exists

The curated packet tells the story in 28 files. The raw provenance folder currently contains 348 files plus many nested directories, including binaries, backups, local-state artifacts, and machine-specific operational paths. That provenance may still be useful later, but it is not the cleanest first handoff.

## Owner actions before sending

1. Personalize `00_cover_letter/draft_cover_note.md` in Larry's voice.
2. Decide whether the recipient needs the original Gauntlet or `myLearningSidekick` pitch as independent continuity evidence.
3. Leave the 450 GB recovery claim out unless a disk-audit artifact is added.
4. Leave post-launch claims out until the Phase 1A operational checks have actually passed.
5. Share the full root packet only if the recipient explicitly needs deeper provenance.

## Suggested send order

1. Cover note
2. Executive summary
3. Timeline
4. Lessons learned
5. Source map
6. Supporting evidence folders as needed

## If deeper proof is requested

Only then consider sharing selected materials from `07_source_provenance/`, after a necessity and disclosure review of the exact subfolders involved.
