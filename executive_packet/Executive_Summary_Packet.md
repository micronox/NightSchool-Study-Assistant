# NightSchool Study Assistant

## Technical Architecture Defense and Preproduction Brief

June 19-21, 2026  
Prepared by Larry  

Repository:  
[micronox/NightSchool-Study-Assistant](https://github.com/micronox/NightSchool-Study-Assistant)

---

## 1. Executive Summary

From Friday, June 19, 2026 through Sunday, June 21, 2026, work repeatedly switched and pivoted as the actual shape of the problem became clearer. What started as a push toward implementation became a weekend of technical discovery, environment hardening, and architecture correction.

By Sunday morning, the work finally had enough footing to behave like a protected branch instead of a loose series of experiments: the operating baseline was documented, the unsafe architecture path had been rejected, and Kopia provided a practical local rollback boundary before the next real lane.

The work produced six technically meaningful outcomes:

- Python, Node, npm, WSL access, Ollama, and project pins were verified.
- The primary Hermes installation was baselined read-only, with writable state, connection behavior, and install layout documented.
- Source inspection identified Hermes's supported isolation controls, including `HERMES_DESKTOP_USER_DATA_DIR` and `HERMES_HOME`.
- Independent architecture review rejected the original isolation plan on technical grounds.
- A safer sequential Phase 1A design was approved for controlled validation.
- Kopia established the first practical local rollback safety layer before the next execution step.

The NightSchool Study Assistant now functions as the first controlled proving ground for a stricter operating model: scoped requirements, architecture review before mutation, explicit backup boundaries, timestamped handoffs, and evidence attached to completion claims.

What this packet proves is the foundation and the operating method. It does not claim that the first controlled launch, later build phases, or downstream product rollout are already complete.

---

## 2. Technical Findings and Decision Pivot

The weekend began with a plausible but unverified assumption: that the NightSchool Study Assistant could safely run as a separately isolated Hermes lane without threatening the primary Hermes installation.

That assumption did not survive source-level review.

The architecture-defense pass found three consequential technical problems in the original plan:

1. Hermes Desktop is effectively single-instance, so a concurrent dual-desktop strategy was not safe.
2. A fresh secondary bootstrap could persist user-scoped environment changes, creating contamination risk outside the intended lane.
3. The fixed-port assumption was stale and did not match the active local backend path.

Those findings materially changed the execution plan. Instead of pursuing a concurrent isolation strategy, the work moved to a sequential Phase 1A model with explicit constraints. That plan only became operationally credible once Kopia and Lane F backup boundaries created a trustworthy rollback point.

- close the primary Hermes desktop before launch
- isolate NightSchool state into separate Electron `userData` and backend roots
- reuse the existing Hermes code root rather than permitting a fresh bootstrap
- validate that primary connection state and user-scoped environment remain unchanged after NightSchool activity

The approved shared-code isolation path centered on three specific controls:

- `HERMES_DESKTOP_USER_DATA_DIR`
- `HERMES_HOME`
- `HERMES_DESKTOP_HERMES_ROOT`

The value of the weekend was not speed. The value was working the problem until the team understood the safe shape of the lane well enough to proceed without corrupting the baseline.

---

## 3. Verified Outcomes and Evidence Boundary

### Verified in the packet

- toolchain baseline
- rollback footing via Kopia/Lane F
- Phase 0 completion
- Hermes source findings
- architecture-defense redlines
- approved sequential Phase 1A design

### Prepared but not yet proven complete

- first controlled NightSchool Study Assistant Hermes launch
- post-launch isolation checks
- full Kopia policy implementation
- later NightSchool Study Assistant build phases
- downstream `myLearningSidekick` rollout

### Evidence status vocabulary

- **Verified** means direct inspection or command evidence is recorded.
- **Approved** means a design passed review but was not yet demonstrated in operation.
- **Planned** means a specification or checklist describes future work.
- **Stated intent** means a strategic relationship is asserted but not independently proven in the packet.

The packet deliberately keeps those categories separate. That makes the archive more technically credible because it distinguishes validated behavior from reviewed design and from downstream intent.

---

## 4. System Architecture and Governance Model

The NightSchool Study Assistant is a Mission Control system forked from Hermes and adapted to support work for the NightSchool class.

At a high level, the system coordinates six roles:

- **Bill** as the top-level orchestrator on Telegram
- **Vault** for source storage and durable project knowledge
- **Scholar** for structured notes and research output
- **Quiz Master** for quizzes, flashcards, and study material
- **Planner** for assignments, deadlines, and schedule extraction
- **Dev** for technical implementation and automation support

The core workflow is straightforward:

1. A source document, such as a PDF, is ingested.
2. Vault stores and classifies it.
3. Scholar converts it into structured notes.
4. Quiz Master generates study material.
5. Planner extracts deadlines and action items.
6. Dev supports any implementation or automation required by the lane.

The architecture matters because the product is not just a chat surface. It is intended as a visible, governable workflow where requests, outputs, lane ownership, and validation steps can be reviewed from a central Mission Control layer.

Just as importantly, the execution model around the product has matured. Architecture Decision Records, validation gates, dependency ledgers, backup boundaries, and timestamped handoffs are now part of the delivery process rather than after-the-fact cleanup.

Technically, the packet establishes four important governance patterns:

- read-only inspection before mutation
- architecture review before implementation
- path-scoped isolation rather than assumption-based isolation
- explicit evidence attachment to every consequential claim

---

## 5. Immediate Technical Next Step

The strongest lesson from this work is that architecture defense is not separate from execution. It is part of execution.

The NightSchool Study Assistant is now the bounded environment where the team can prove:

- project isolation
- dependency discipline
- evidence-backed validation
- backup and restore boundaries
- multi-tool handoff quality

That creates a safer bridge into future product work. The intended strategy is that practices proven here can later be promoted into broader rollout work, including `myLearningSidekick`, without carrying forward unvalidated assumptions.

### Required operational proof

The next credibility milestone is operational, not narrative:

- perform the controlled Phase 1A launch
- confirm NightSchool writes only to its isolated paths
- confirm primary Hermes state remains unchanged
- confirm the prescribed backup checks behave as designed

Until those checks pass, the technically correct public claim is:

The foundation was verified, the unsafe plan was rejected, and the safer plan was approved, but the first controlled launch was still pending at packet cutoff.

### Recommended follow-up reading

1. [Architecture_Defense_and_Preproduction/external_share_candidate/README_START_HERE.md](../Architecture_Defense_and_Preproduction/external_share_candidate/README_START_HERE.md)
2. [Architecture_Defense_and_Preproduction/external_share_candidate/00_cover_letter/executive_summary.md](../Architecture_Defense_and_Preproduction/external_share_candidate/00_cover_letter/executive_summary.md)
3. [Architecture_Defense_and_Preproduction/external_share_candidate/00_cover_letter/timeline.md](../Architecture_Defense_and_Preproduction/external_share_candidate/00_cover_letter/timeline.md)
4. [Architecture_Defense_and_Preproduction/external_share_candidate/index/source_map.md](../Architecture_Defense_and_Preproduction/external_share_candidate/index/source_map.md)

### Canonical reference

Full supporting materials and source packet:

[https://github.com/micronox/NightSchool-Study-Assistant](https://github.com/micronox/NightSchool-Study-Assistant)
