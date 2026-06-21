# Pre-Architecture-Defense Pass Closeout
**Date:** 2026-06-21  
**Session:** Claude (Cowork) + Codex (counter-review)  
**Status:** CLOSED — Phase 0 execution is next

---

## What This Pass Was

A joint Claude/Codex review of the PRD before any Phase 0 execution began. Goal: catch every inconsistency, unresolved decision, and scope misalignment that would cause a session to stall mid-task.

---

## What Was Resolved

### Decisions answered (from Larry via Codex)

| Question | Answer |
|---|---|
| Primary Hermes install — greenfield or existing? | Existing. Lives outside `L:\WSL_Projects_Folder\`. Phase 0 locates it via read-only inspection; do not assume its location. |
| Local inference runtime | **Confirmed: Ollama → qwen3.6:latest.** Operationally verified in the primary Hermes environment. |
| Frontier routing | **Nemotron 3 Super 120b A12b:Free** as frontier default; **Nemotron 3 Ultra 550b A55b:Free** as escalation-only. Both via Nous subscription. |
| `Architecture_Defense\` folder | Adjacent planning/audit context — in scope for reference, out of scope as build root. Agents do not write here. |

### PRD changes applied (v3)

| Change | Where |
|---|---|
| PRD filename corrected (removed `_v2` suffix) | File renamed; backup at `PRD/_backups/2026-06-21_v2_pre-review-rename.md` |
| `_backups\` folder created | `PRD/_backups/` |
| `handoffs\` folder creation added to Phase 0 cards | §9 Phase 0 |
| §1 directory diagram updated to show `Architecture_Defense\` with classification | §1 |
| §5 GPU+Model Routing fully rewritten — Ollama/Nemotron tiers, per-agent table updated | §5 |
| Before Phase 0 prereqs corrected — removed items that are Phase 0 deliverables, not user prereqs | §6 |
| Before Phase 1 prereqs — removed vague "decide GPU runtime" item (now resolved) | §6 |
| Phase 0 cards rewritten — Ollama check added, primary Hermes wording clarified as external+read-only, evidence note reference added, "all required Phase 0 items" wording | §9 |
| Phase 1 cards rewritten — inference card now confirms from NightSchool install, not a re-discovery; per-agent routing confirmation added | §9 |
| Open Question on GPU runtime closed | §7 |
| Remaining open question on per-agent escalation thresholds moved to Phase 1 | §7 |
| Problem statement, Goals, P0 requirements, P1 nice-to-have updated with confirmed stack | §7 |
| Immediate Next Action updated — only one user item outstanding | §11 |
| Revision Log row added for v3 | Revision Log |

---

## One Remaining User Decision (non-blocker for most of Phase 0)

**Python/Node version manager for NightSchool isolated env** — pyenv/venv, nvm, or other? Specified in §6 Before Phase 0. Phase 0 can run cards 1, 3, 4, 5, 6, 7 without this answer. Card 2 (primary Hermes baseline) may inform the decision. Only the isolated install creation in Phase 1 is hard-blocked on this.

---

## What Is Still Open (genuine open questions, not blockers for Phase 0)

- Discord existing agent work — migrate to master server or keep separate? (Phase 2 consideration)
- GitHub repo — existing or new, public or private? (Phase 7 consideration)
- Per-agent escalation thresholds — which agents escalate to Nemotron Super vs. stay local? (Phase 1 deliverable, after Qwen performance is observed)

---

## Phase 0 Execution State

All Phase 0 cards are fully specified and agent-executable. Reading list for the Phase 0 session:

1. `PRD/NightSchool_PRD_and_Execution_System.md` — §1 (dir architecture), §9 Phase 0 cards, §10 verification standard
2. `handoffs/2026-06-21_cowork_kickoff_debrief.md` — §5 evidence note template

That is the complete context contract for Phase 0. No other files need to be read.

---

## Audit trail for this pass

| File | Action |
|---|---|
| `PRD/NightSchool_PRD_and_Execution_System.md` | Updated to v3 (multiple edits applied this session) |
| `PRD/_backups/2026-06-21_v2_pre-review-rename.md` | Backup of pre-edit state |
| `handoffs/2026-06-21_PRD_review.md` | Claude Cowork review notes |
| `handoffs/2026-06-21_pre-defense-pass-closeout.md` | This file |
