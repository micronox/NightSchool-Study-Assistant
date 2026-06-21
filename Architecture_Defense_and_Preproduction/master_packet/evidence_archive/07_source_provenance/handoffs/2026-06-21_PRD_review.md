# NightSchool PRD Review
**Date:** 2026-06-21  
**Reviewer:** Claude (Cowork)  
**Scope:** Full review of PRD v2 + handoff debrief, grounded in actual disk state  
**Purpose:** Identify gaps, inconsistencies, open decisions, and stall risks before Phase 0 executes

---

## Disk State Summary (what actually exists right now)

```
`$PROJECTS_ROOT\
├── Architecture_Defense\          ← previous session's headroom/ponytail work
│   ├── files.zip
│   ├── headroom_install_vetting.md
│   └── preinstall_backups\
│       ├── codex_2026-06-21T15:05Z\prefixinstall\   (Codex snapshot)
│       └── ponytail_installs\2026-06-21T15:10Z\codex\
└── Nightschool_Study\
    ├── App_Final_Deliverable\      ← empty, correct
    └── Prototype_workingFiles\
        ├── PRD\
        │   ├── NightSchool_PRD_and_Execution_System.md   ← FIXED (was _v2.md)
        │   └── _backups\
        │       └── 2026-06-21_v2_pre-review-rename.md
        └── handoffs\
            ├── 2026-06-21_cowork_kickoff_debrief.md
            └── 2026-06-21_PRD_review.md  (this file)
```

**Key finding: No Hermes install exists on disk.** The PRD's Phase 0 task of "document primary Hermes install path" cannot execute until Hermes is installed somewhere — or until you clarify whether your "primary/worker Hermes" lives outside this folder (e.g., under your Windows user profile or a different drive). Phase 0 Item 2 is currently unresolvable from disk inspection alone.

---

## Fixes Already Applied This Session

| Issue | Fix |
|---|---|
| PRD master file named `NightSchool_PRD_and_Execution_System_v2.md` — violates §24 rule (no version numbers in master filename) | Renamed to `NightSchool_PRD_and_Execution_System.md`. Backup saved to `PRD/_backups/2026-06-21_v2_pre-review-rename.md`. |
| `_backups\` folder didn't exist | Created at `PRD/_backups/` |

The Revision Log in the master PRD needs a new row added for this rename — noted in the action items below.

---

## Issues Found

### 1. BLOCKER — "Primary Hermes install" doesn't exist on the mounted drive

**Where:** PRD §1, §2.1, Phase 0 card 2; Handoff debrief §2 items 2 and 3  
**Problem:** Phase 0 requires baselining the primary/worker Hermes install for drift-check purposes. No Hermes install exists anywhere under `$PROJECTS_ROOT\`. Either:
  - (a) Your primary Hermes lives somewhere else entirely (different drive, Windows user profile, WSL home directory), or
  - (b) Hermes hasn't been installed yet at all, and this is a greenfield build

If (b), the Phase 0 "primary install baseline" card changes shape entirely — instead of documenting an existing install to diff against, Lane F just records "no prior install — NightSchool IS the first install" and moves on. That's fine, but the PRD currently assumes (a) and the handoff debrief's Phase 0 script assumes it too.

**Decision needed from you:** Does a primary/worker Hermes install exist, and if so where? Answer determines whether Phase 0 item 2 is "locate and document" or "record as baseline-zero."

---

### 2. BLOCKER — Ollama/Qwen3.6 confirmation is mentioned in the handoff but not in the PRD

**Where:** Handoff debrief §2 (Phase 0 item 3); PRD §5 GPU + Model Routing  
**Problem:** The handoff debrief (written by the previous chat session) says Ollama + Qwen3.6 is confirmed as the local inference stack and instructs Phase 0 to verify it. But the PRD's §5 still reads "proposed, confirm in Phase 1" and has an Open Question about the GPU-local runtime. These are now out of sync.

**If Ollama + Qwen3.6 is genuinely confirmed** (you told the previous session this), then:
- §5's routing table should be updated to say Ollama (not "proposed")
- The Open Question "GPU-local inference runtime choice" should be closed and removed
- The Phase 1 card "Confirm GPU-local inference runtime is reachable" should say "Confirm Ollama + Qwen3.6 is reachable" rather than leaving it open

**Decision needed from you:** Confirm Ollama + Qwen3.6 is the chosen stack so the PRD can be updated to close that Open Question.

---

### 3. INCONSISTENCY — PRD master filename referenced differently across documents

**Where:** PRD §0 file location note, handoff debrief §1 and §4  
**Problem:** 
- PRD §0 says the master file is at `Prototype_workingFiles\PRD\NightSchool_PRD_and_Execution_System.md` (correct, no version)
- Handoff debrief §1 says to save it as `NightSchool_PRD_and_Execution_System_v2.md` (version suffix — incorrect)
- Handoff debrief §4 references `PRD\NightSchool_PRD_and_Execution_System.md` (correct)

The rename fix this session resolved this on disk. The handoff debrief itself still contains the wrong name in §1 — minor, since it's a historical note, but worth knowing.

---

### 4. GAP — `Architecture_Defense\` folder relationship to NightSchool is undefined

**Where:** Disk, not addressed in PRD  
**Problem:** There's a sibling folder `Architecture_Defense\` at the same level as `Nightschool_Study\`, containing Codex pre-install backups and a vetting document (`headroom_install_vetting.md`). The PRD doesn't mention this folder at all. Questions that need answering before Phase 0 closes:
- Is `Architecture_Defense\` part of the NightSchool project, or a separate prior-work folder?
- Should Lane F's isolation manifest track it, or treat it as out-of-scope?
- Does `headroom_install_vetting.md` contain baseline info relevant to the drift check?

**Decision needed from you:** What is `Architecture_Defense\` — NightSchool infra, prior separate project, or something else?

---

### 5. GAP — No `handoffs\` folder creation was specified in Phase 0 cards

**Where:** PRD §9 Phase 0 checklist  
**Problem:** The Phase 0 cards don't include creating the `handoffs\` folder. The handoff debrief instructs creating it, but that instruction isn't in the PRD's own Phase 0 checklist. The folder exists now (created by the previous session), but the PRD checklist is incomplete — any agent reading only the PRD would miss creating it.

**Recommended fix:** Add a card to Phase 0: "Create `handoffs\` subfolder inside `Prototype_workingFiles\`."

---

### 6. MINOR — Revision Log needs updating for this session's changes

**Where:** PRD master file, Revision Log table  
**Problem:** The rename this session performed (v2 filename → clean master filename) plus the creation of `_backups\` is a meaningful checkpoint. A row should be added to the Revision Log.

**Recommended addition:**
| 2026-06-21 | v3 | Claude (Cowork) | PRD filename corrected (removed _v2 suffix per §24 rule); _backups folder created; PRD review note written to handoffs/ | `_backups/2026-06-21_v2_pre-review-rename.md` |

---

### 7. MINOR — Phase 0 card 5 says "write Phase 0 verification note" but doesn't specify format or location

**Where:** PRD §9 Phase 0, card 5  
**Problem:** The handoff debrief provides an evidence-note template (§5), but the PRD itself doesn't reference it. An agent reading only the PRD would produce an unformatted or inconsistent note.

**Recommended fix:** Add to Phase 0 card 5: "Use the evidence template in `handoffs/2026-06-21_cowork_kickoff_debrief.md` §5 for format. Save to `handoffs/` with naming convention `YYYY-MM-DD_phase0_verification.md`."

---

### 8. MINOR — "v3 (pending)" Revision Log row references "Cowork" for Phase 0 execution, but work started in chat

**Where:** PRD Revision Log  
**Problem:** The pre-existing "v3 (pending)" row says "Cowork — Phase 0 execution." Some Phase 0 prep (PRD location, handoffs folder, handoff debrief) was done in the prior chat session, not Cowork. When v3 is finalized, the log entry should reflect both sessions contributed.

---

## Open Questions Status

From PRD §7 Open Questions — here's current status:

| Question | Status |
|---|---|
| GPU-local inference runtime choice | **Tentatively resolved** (Ollama + Qwen3.6 per handoff debrief), but **not yet reflected in the PRD** — needs your confirmation + PRD update |
| Discord existing agent work — migrate or keep separate? | Open, not a Phase 0 blocker |
| GitHub repo — existing or new, public or private? | Open, not a Phase 0 blocker (Phase 7 item) |

---

## Decisions Needed From You (before Phase 0 can fully execute)

1. **Primary Hermes install location** — Does one exist? Where? Or is this a greenfield build with no prior install to baseline against?
2. **Ollama + Qwen3.6 confirmation** — Is this the confirmed local inference stack? (Unblocks closing the Open Question and updating §5.)
3. **`Architecture_Defense\` folder scope** — Part of NightSchool, separate project, or ignore?

---

## Recommended PRD Edits (in priority order)

These should be made to the master PRD once you've answered the decisions above:

1. Update Revision Log with a v3 row for this session's work
2. Close the GPU-local inference Open Question in §7; update §5 routing table to say "Ollama + Qwen3.6" explicitly
3. Update Phase 0 checklist: add `handoffs\` folder creation card; add evidence-note format reference to the verification note card
4. Clarify Phase 0 card 2 based on whether a primary Hermes install exists
5. (Optional) Note the `Architecture_Defense\` folder's relationship in §1 directory architecture

---

## What's Ready to Proceed

Despite the gaps above, the following is solid and unblocked:

- Folder structure on disk matches the PRD spec ✓
- PRD filename is now correct ✓
- `_backups\` folder exists ✓
- `handoffs\` folder exists ✓
- Phase 0 cards 1, 3, 4, 5 (WSL mount confirmation, port audit, Lane F skeleton, verification note) can execute without your answers above
- Phase 0 card 2 (primary Hermes baseline) needs your answer on whether a prior install exists

WSL mount path is confirmed as `/mnt/l/` equivalent — the folder is accessible at the paths shown in disk state summary above.


