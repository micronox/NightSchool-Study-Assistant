# NightSchool — Cowork Handoff Debrief
## Lane F Execution Kickoff: First Disk-Access Session

**Prepared by:** Claude (chat/planning layer)
**For:** Claude Cowork (local execution + Lane F audit layer)
**Date:** 2026-06-21
**Purpose:** Hand the NightSchool PRD to a session with real local filesystem access, kick off Phase 0, and establish the audit/handoff loop back to this planning layer going forward.

---

## 1. Where to place this file

Save this debrief inside the Prototype working directory, in a new `handoffs/` subfolder — **not** loose in the project root, and never in `App_Final_Deliverable`:

```
L:\WSL_Projects_Folder\Nightschool_Study\
└── Prototype_workingFiles\
    └── handoffs\
        ├── 2026-06-21_cowork_kickoff_debrief.md   ← this file
        └── (future phase status notes land here too)
```

**Why `handoffs/` and not the root:** this is the same note-chain mechanism from the PRD's Context Management section (§3.2) — every phase produces a timestamped note that the *next* session reads instead of replaying history. Keeping them in one subfolder means any future session (Cowork, Claude Code, Codex, or this chat) can be pointed at one place to reconstruct where the project stands, without you having to re-explain it each time.

Also save the current PRD itself into the project, if it isn't already there:

```
L:\WSL_Projects_Folder\Nightschool_Study\
└── Prototype_workingFiles\
    └── PRD\
        └── NightSchool_PRD_and_Execution_System_v2.md
```

Cowork will update this file in place as decisions get made (see §4). Treat `PRD/` as the living source of truth and `handoffs/` as the dated log of what happened in each session — same split as a design doc vs. a changelog.

---

## 2. What to literally say to Cowork

Paste this as your opening message to the Cowork session. It's written to give Cowork everything it needs without you re-explaining the project verbally:

```
You are taking over Lane F (Architecture Defense) and general execution
duties for a local project called NightSchool, building a multi-agent
Hermes study companion. I've been planning this in a separate chat
session that does not have filesystem access — you do, and that's why
you're being looped in now.

Read these two files first, in this order:
1. L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\PRD\NightSchool_PRD_and_Execution_System_v2.md
2. L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\handoffs\2026-06-21_cowork_kickoff_debrief.md

Your job right now is Phase 0 only, exactly as scoped in the PRD's
§9 Phase 0 section. Do not proceed past Phase 0 without producing
a verification note with real evidence (actual command output, actual
file paths confirmed to exist) — no claims of "done" without proof,
per the PRD's Verification Standard (§10).

Specifically for this session:
1. Confirm the WSL mount path for L:\WSL_Projects_Folder\Nightschool_Study\
   — run the actual command, paste the actual output, don't assume /mnt/l/.
2. Locate and document my primary/worker Hermes install's exact root path,
   config location, and venv/node scope — this is the baseline Lane F will
   diff future NightSchool state against to catch any drift or
   cross-contamination. Do not modify anything in that install — read-only
   inspection only.
3. Confirm Ollama is reachable locally and that qwen3.6 (or qwen3.6:27b /
   qwen3.6:35b-a3b, whichever I have pulled) is present and responds to a
   basic test call.
4. Audit current local port usage and propose a port range for NightSchool
   that doesn't collide with anything already running.
5. Create the Lane F skeleton: an isolation manifest file and an empty
   DEPENDENCIES.md inside Prototype_workingFiles, ready to be populated
   in later phases.
6. Write a timestamped Phase 0 verification note into the handoffs/ folder,
   following the same format as this debrief, with an explicit evidence
   section for each of the five items above.

If anything is ambiguous, unclear, or looks like it would touch my primary
Hermes install, STOP and report back to me rather than guessing or
proceeding. This mirrors the decision-gate discipline already defined in
the PRD.

When Phase 0 is genuinely complete with evidence, back up the current PRD
master file into PRD\_backups\ (copy it BEFORE you edit it, named
YYYY-MM-DD_vN_short-reason.md), then update the master PRD file directly:
mark Phase 0's checklist items as done, fill in any of the PRD's Open
Questions that this session resolved (e.g., the WSL mount path, the
Ollama/Qwen3.6 confirmation), and add a row to the Revision Log table at
the top of the file. Leave Phase 1 exactly as scoped for the next
session — don't start Phase 1 work in this same session unless I
explicitly tell you to.
```

---

## 3. What Cowork should produce by the end of this session

A genuine Phase 0 close requires all of the following to exist as real files, not just chat output:

| Deliverable | Location | Format |
|---|---|---|
| Phase 0 verification note | `Prototype_workingFiles\handoffs\` | Timestamped `.md`, evidence per item (see §5 template below) |
| Isolation manifest | `Prototype_workingFiles\` | New file, records primary-install baseline paths for future drift checks |
| `DEPENDENCIES.md` | `Prototype_workingFiles\` | Empty/skeleton, ready for Phase 1+ |
| Updated PRD | `Prototype_workingFiles\PRD\` | Same file, edited in place — Phase 0 checklist ticked, relevant Open Questions resolved |

---

## 4. How Cowork should update the PRD (so it stays one source of truth, with version history intact)

- **Edit the existing master PRD file directly** rather than creating a second copy — version drift between "the PRD I'm reading" and "the PRD Cowork edited" defeats the whole point of the note-chain system.
- **Before editing, back it up first.** Copy the current master (`PRD\NightSchool_PRD_and_Execution_System.md`) into `PRD\_backups\` as `YYYY-MM-DD_vN_short-reason.md` (e.g., `2026-06-21_v2_phase0-complete.md`) — copy the *pre-edit* version, then make changes to the master. Never back up after editing.
- Add a row to the Revision Log table at the top of the master file for every backup created: date, version tag, who changed it, what changed, which backup file.
- When an Open Question from the PRD's PRD section gets answered (e.g., GPU-local inference runtime is now confirmed as Ollama + Qwen3.6), Cowork should:
  - Remove it from Open Questions.
  - Update the GPU + Model Routing section to reflect the actual confirmed setup, replacing "proposed, confirm in Phase 1" language with the real configuration.
- When a Phase 0 checklist item closes, check it off in the Build Phases section directly in the master PRD, not just in the handoff note — the PRD's checklist is the at-a-glance status; the handoff note is the detailed evidence trail behind it.
- Cowork should **not** alter the PRD's structure, scope, or decisions outside what this session's work actually resolved — it's updating status, not re-architecting the plan. If Cowork thinks something in the PRD is wrong or needs to change, that's a flag for you and me to discuss back in this chat, not a silent edit.
- **One backup per session/phase close, not per individual edit** — if Cowork makes several small edits in one sitting, one backup at the start of the session covers all of them. A new backup is only needed if a new session opens the file again later.

---

## 5. Evidence note template (for Cowork to follow)

Have Cowork use this shape for the Phase 0 verification note so the format is consistent across every future phase note too:

```markdown
# Phase 0 Verification Note
Date: [timestamp]
Session: Cowork
Lane: F (Architecture Defense) + A (Infra)

## 1. WSL mount path
Command run: [exact command]
Output: [exact output]
Confirmed path: [result]

## 2. Primary Hermes install baseline
Install root: [path]
Config root: [path]
Venv/node scope: [path]
Method used to confirm: [command/inspection method]
Read-only confirmed — no modifications made: [yes/no]

## 3. Ollama + Qwen3.6 reachability
Ollama endpoint check: [command + output]
Model(s) present: [list from `ollama list`]
Test call result: [pass/fail + output snippet]

## 4. Port audit
Ports currently in use: [list]
Proposed NightSchool range: [range]

## 5. Lane F skeleton
Isolation manifest created at: [path]
DEPENDENCIES.md created at: [path]

## Decision gate status
[ ] Phase 0 evidence complete — safe to proceed to Phase 1
[ ] Blocked — reason: [...]
```

---

## 6. After this session: how the loop closes

Bring the resulting Phase 0 verification note back into this chat (paste it, or describe what Cowork reported) so I can:
- Confirm it actually satisfies the PRD's Phase 0 acceptance criteria.
- Flag anything that looks incomplete or like it needs a second pass before Phase 1 opens.
- Help you write the next Cowork kickoff message for Phase 1, now informed by what Phase 0 actually found (e.g., the real WSL path, the real port range) instead of the placeholders in the current PRD draft.

This is the audit role you asked for: Cowork executes with real disk access, I review the evidence it produces against the spec before the next phase is greenlit. Neither of us is trusting the other's "done" claim blind.
