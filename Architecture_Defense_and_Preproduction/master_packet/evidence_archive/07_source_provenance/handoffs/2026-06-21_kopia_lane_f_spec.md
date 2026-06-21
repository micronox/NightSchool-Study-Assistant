# Kopia Backup — Lane F Architecture Spec
# For Codex vetting. Do not implement until Codex approves.
**Date:** 2026-06-21
**Author:** Claude (Cowork)
**Status:** DRAFT v3 — CK-Q3 and CK-Q4 answered by Larry; remaining questions (CK-Q1, CK-Q2, CK-Q5) for Codex
**Context:** NightSchool Phase 1A complete. Kopia v0.23.1 installed locally.
**Repository:** `E:\KopiaRepo` (confirmed by Larry 2026-06-21)
**NAS migration:** deferred — `E:\KopiaRepo` is the working repository for the full build.

---

## Problem Statement

Kopia is currently configured with two snapshot sources:

| Source | Size | Last snapshot | Schedule |
|---|---|---|---|
| `C:\Users\larry` | 46 GB ⚠ | 5 hours ago | None configured |
| `L:\` | 32.3 GB | 1 hour ago | Every ~12 hours |

This creates two Lane F risks:

**Risk 1 — `C:\Users\larry` snapshot contains primary Hermes state.**
`C:\Users\larry\AppData\Roaming\Hermes\` and `C:\Users\larry\.hermes\` both live under `C:\Users\larry`. A snapshot of this root captures the primary Hermes profile, connection config, backend venv, and all agent state. If a NightSchool session ever writes into `Hermes-NightSchool\` or `.hermes-nightschool\` (also under `C:\Users\larry`), those paths are in the same snapshot tree — meaning the backup does not distinguish between primary-Hermes writes and NightSchool writes. A restore from this snapshot could silently overwrite primary Hermes state with NightSchool-era state.

**Risk 2 — `C:\Users\larry` snapshot has no policy and is 5 hours stale.**
The warning flag (⚠) in the UI suggests a policy/schedule issue. Without a defined retention policy, this snapshot may accumulate unbounded or get pruned unpredictably. More importantly: no Lane F boundaries are enforced at the snapshot level.

**Risk 3 — `L:\` snapshot includes NightSchool build artifacts alongside other L:\ content.**
`L:\WSL_Projects_Folder\Nightschool_Study\` is under `L:\`. The current broad `L:\` snapshot captures everything on the drive, with no per-project boundary or tag. When NightSchool is eventually delivered and the hierarchy is rebuilt, this single-root snapshot will be insufficient.

---

## Design Principles

1. **Snapshot boundaries must mirror Lane F path boundaries.** The same no-touch zones that Lane F enforces at runtime must be enforced at the backup level. Primary Hermes paths must never appear in a NightSchool-tagged snapshot as writable targets.

2. **Split by ownership, not just by drive.** The current split (`C:\Users\larry` vs `L:\`) is a filesystem split, not an ownership split. The right split is: Primary Hermes state | NightSchool build artifacts | Everything else.

3. **Exclusions are defensive, inclusions are affirmative.** Snapshot policies should affirmatively include only what they own. Exclude everything outside the ownership boundary rather than relying on the other snapshot to catch it.

4. **No cross-contamination on restore.** The restore path must be as clean as the backup path. Codex should assess whether Kopia's restore-by-path mechanics guarantee this given the proposed policy split.

5. **Local-first, NAS-deferred.** All policies below target the local Kopia repository. When NAS is added, the policy structure carries forward — it's the same policy set pointed at a different (or additional) repository target.

---

## Confirmed Physical Architecture

**Repository:** `E:\KopiaRepo` (confirmed 2026-06-21)

Three-drive layout — each drive has a single, non-overlapping role:

```
C:\                          ← OS, user profile, primary Hermes, NightSchool runtime state
  Users\larry\
    AppData\Roaming\Hermes\          ← primary Hermes userData (snapshot source: Policy C1)
    AppData\Roaming\Hermes-NightSchool\  ← NightSchool userData (snapshot source: Policy B1)
    .hermes\                         ← primary Hermes backend (snapshot source: Policy C2)
    .hermes-nightschool\             ← NightSchool backend (snapshot source: Policy B2)

L:\                          ← WSL projects, NightSchool build artifacts
  WSL_Projects_Folder\
    Nightschool_Study\               ← NightSchool build root (snapshot source: Policy A)

E:\                          ← Kopia repository ONLY — never a snapshot source
  KopiaRepo\                         ← all snapshot data, dedup blocks, manifests live here
```

**Key property:** `E:\KopiaRepo` is on a separate physical drive from both source drives (`C:\` and `L:\`). A drive failure on `C:\` or `L:\` does not destroy the repository. A repository issue on `E:\` does not corrupt live source data. This is the correct physical isolation for a local-first backup architecture.

**NAS migration path:** when the NAS is added, `E:\KopiaRepo` becomes a secondary repository or is replaced by a remote Kopia repository target. The policy set (A through E) is identical — only the repository connection string changes.

---

## Proposed Policy Architecture

### Policy A — NightSchool Build Artifacts
**What it protects:** everything Claude and Codex write during the NightSchool build.

| Field | Value |
|---|---|
| Snapshot root | `L:\WSL_Projects_Folder\Nightschool_Study\` |
| Policy name | `nightschool-build` |
| Schedule | Every 2 hours during active build sessions; daily otherwise |
| Retention | Keep: 24 hourly, 7 daily, 4 weekly |
| Includes | `Prototype_workingFiles\` (all subdirs) |
| Includes | `App_Final_Deliverable\` (after first promotion) |
| Excludes | None needed — this root is entirely NightSchool-owned |
| Lane F role | Primary version control for NightSchool build artifacts |
| Notes | This is the snapshot that replaces "edit history" during the build. Every PRD version, every handoff note, every script draft is recoverable from here. |

**Why not `L:\` root?** Too broad. When the NAS migration happens and the hierarchy is rebuilt, a `L:\` snapshot will include unrelated content. Starting narrow now means the policy is already correct for the final architecture.

---

### Policy B — NightSchool Runtime State
**What it protects:** the NightSchool Hermes profile and backend home that Phase 1A creates.

| Field | Value |
|---|---|
| Snapshot root | `C:\Users\larry\AppData\Roaming\Hermes-NightSchool\` |
| Policy name | `nightschool-hermes-userdata` |
| Schedule | After each NightSchool session (manual trigger or on session-close hook) |
| Retention | Keep: 10 snapshots (rolling) |
| Includes | All — this dir is entirely NightSchool-owned |
| Excludes | Nothing (the dir is isolated by Phase 1A design) |
| Lane F role | Snapshot of NightSchool connection config, GUI state, Chromium session |
| Notes | Enables roll-back if a NightSchool session corrupts its own connection.json without touching primary. |

| Field | Value |
|---|---|
| Snapshot root | `C:\Users\larry\.hermes-nightschool\` |
| Policy name | `nightschool-hermes-home` |
| Schedule | After each NightSchool session |
| Retention | Keep: 10 snapshots (rolling) |
| Includes | All — this dir is entirely NightSchool-owned |
| Excludes | Nothing |
| Lane F role | Snapshot of NightSchool backend data, logs, sessions, memories |
| Notes | This is the state that grows once Phase 1B (controlled bootstrap) runs. Before Phase 1B, this dir contains only logs/sessions/memories created by the safe-reuse launcher. |

---

### Policy C — Primary Hermes Baseline (read-only reference snapshot)
**What it protects:** the primary Hermes install as a Lane F baseline — a point-in-time reference that Lane F can diff against to detect drift.

| Field | Value |
|---|---|
| Snapshot root | `C:\Users\larry\AppData\Roaming\Hermes\` |
| Policy name | `primary-hermes-userdata-baseline` |
| Schedule | Manual only — triggered at the start of each NightSchool session, before anything else runs |
| Retention | Keep: last 30 snapshots (rolling) — these are the Lane F evidence chain |
| Includes | All |
| Excludes | Nothing |
| Lane F role | Provides the "before" state for every session's drift check. If primary Hermes\connection.json changes between sessions, this snapshot chain proves it and timestamps when. |
| Notes | This is a **reference snapshot, not a restore target.** It exists so Lane F has evidence, not so primary Hermes can be restored from NightSchool's backup tool. Do not use this policy's snapshots as the authoritative primary Hermes backup — that's a separate concern outside NightSchool scope. |

| Field | Value |
|---|---|
| Snapshot root | `C:\Users\larry\.hermes\` |
| Policy name | `primary-hermes-home-baseline` |
| Schedule | Manual only — same cadence as above |
| Retention | Keep: last 30 snapshots (rolling) |
| Includes | All |
| Excludes | Nothing |
| Lane F role | Baseline snapshot of primary backend root for drift detection |
| Notes | Same read-only reference purpose. Not the authoritative backup of primary Hermes. |

---

### Policy D — What to do with the current `C:\Users\larry` broad snapshot

**Recommendation:** retire it as a NightSchool policy. Keep it if Larry uses it for general user-profile backup purposes unrelated to NightSchool. But it must not be the mechanism for any NightSchool Lane F check, because its scope is too broad to distinguish primary Hermes state from NightSchool state.

**If retained for general backup purposes:**
- Add explicit exclusions to prevent it from being confused with NightSchool policies:
  - Exclude `AppData\Roaming\Hermes-NightSchool\` (covered by Policy B)
  - Exclude `.hermes-nightschool\` (covered by Policy B)
- Add a policy and schedule (the ⚠ warning suggests neither is currently set)
- Do not use it as a Lane F evidence source

**If retired:**
- Replace with Policies B and C above for the NightSchool-relevant paths
- General `C:\Users\larry` backup is out of NightSchool scope — Larry's call whether to keep it

---

### Policy E — `L:\` broad snapshot

**Recommendation:** keep for now as a safety net, but narrow it after the NightSchool build completes.

**Current state:** snapshots `L:\` every ~12 hours. This is fine as a safety net during the build — it catches everything on the drive. However:
- It duplicates what Policy A will cover for `Nightschool_Study\`
- When the NAS migration happens, this broad policy will need restructuring anyway

**Action for now:** no change to the `L:\` policy. Policy A runs alongside it. After delivery and NAS migration, retire the broad `L:\` policy and replace with per-project narrow policies.

---

## Lane F Integration — Kopia as a Defense Layer

### New Lane F tripwire: T8

Add to `isolation_manifest.md`:

> **T8 — Kopia snapshot boundaries must mirror Lane F path boundaries.**
> NightSchool Kopia policies (A and B) must not include `C:\Users\larry\AppData\Roaming\Hermes\` or `C:\Users\larry\.hermes\` in their snapshot roots or via parent-directory inclusion.
> Primary baseline policies (C) are read-only reference snapshots — they must not be used as restore targets during a NightSchool session.
> Verified at: policy creation time + after any Kopia policy change.

### New session ritual: pre-launch snapshot

Before running `launch_hermes_nightschool_safe_reuse.ps1`, the recommended sequence becomes:

```
1. Trigger Policy C snapshots (primary-hermes-userdata-baseline + primary-hermes-home-baseline)
   → establishes "before" state for this session's Lane F drift check
2. Run Card 1A-0 (env var pre-flight check)
3. Run Card 1A-1 (close primary Hermes)
4. Run the launch script
5. Post-launch: trigger Policy B snapshots (after NightSchool session ends)
   → establishes "after" state for NightSchool runtime artifacts
6. Run Lane F drift check: diff primary Hermes paths against Policy C "before" snapshot
```

This makes the Lane F drift check **evidence-backed by snapshot timestamps**, not just by reading current files. If primary Hermes state ever mutates during a NightSchool session, the snapshot chain proves it.

---

## Open Questions for Codex

*CK-Q3 (⚠ warning) and CK-Q4 (repository location) answered by Larry. See detail sections below and Confirmed Physical Architecture above. Three questions remain for Codex: CK-Q1, CK-Q2, CK-Q5.*

### CK-Q1 — Snapshot root overlap: does Kopia handle overlapping roots safely?

Policy C snapshots `C:\Users\larry\AppData\Roaming\Hermes\`. The existing broad snapshot snapshots `C:\Users\larry\`. If both policies run against the same local repository, Kopia will deduplicate content at the block level — but does having an overlapping root cause any policy conflict, restore ambiguity, or unexpected include/exclude inheritance?

**Request:** Codex to confirm whether Kopia's policy inheritance model causes any child-path policy to inherit parent-path policy settings, and whether this creates any Lane F risk.

---

### CK-Q2 — Policy B restore safety: can a NightSchool snapshot restore touch primary Hermes paths?

If Policy B (`nightschool-hermes-userdata`) is restored via `kopia restore` into `C:\Users\larry\AppData\Roaming\Hermes-NightSchool\`, does Kopia's restore path have any mechanism that could accidentally write to `C:\Users\larry\AppData\Roaming\Hermes\`?

**Request:** Codex to confirm restore is path-scoped and cannot escape the snapshot root. If there are any Kopia restore flags or behaviors that could cause path confusion (e.g., `--override-username`, `--override-hostname`), flag them.

---

### CK-Q3 — The `C:\Users\larry` ⚠ warning ✓ ANSWERED

**Answer (Larry, 2026-06-21):** 475 file-lock errors. All errors are open-file LOCK files held by running applications at snapshot time:

- `AppData\Local\EpicGamesLauncher\Saved\webcache_4430\LOCK` — Epic Games Launcher webcache
- `AppData\Local\EpicGamesLauncher\Saved\webcache_4430\Local Storage\leveldb\LOCK`
- `AppData\Local\EpicGamesLauncher\Saved\webcache_4430\Service Worker\Database\LOCK`
- `AppData\Local\Riot Games\Riot Client\Crashes\Riot Client\[uuid].run.lock`
- (475 total — all same pattern: process-locked files that Kopia cannot read while the owning process holds them)

**Analysis:** this is **not a Lane F issue**. This is a standard Kopia behavior when snapshotting a live user profile while game clients (Epic, Riot) are running. Kopia skips locked files and counts them as errors. The snapshot itself completed — it just couldn't read those specific lock files, which is expected and harmless. Lock files are not data that needs to be backed up.

**Resolution — two options, both valid. Codex to confirm preference:**

**Option CK-Q3a (recommended): add exclusions to Policy D to skip known lock-file paths.**

Add these exclusions to the `C:\Users\larry` policy:
```
AppData/Local/EpicGamesLauncher/Saved/webcache_*/
AppData/Local/Riot Games/Riot Client/Crashes/
AppData/Local/Riot Games/Riot Client/Logs/
```
This eliminates the 475 errors without losing any meaningful backup data. Lock files and crash dumps are not restore-worthy content.

**Option CK-Q3b: accept the errors as noise.** The `C:\Users\larry` snapshot is kept for general user-profile backup (out of NightSchool scope). 475 lock-file errors are cosmetic — the snapshot is functionally complete. Leave the policy as-is and treat the ⚠ as expected behaviour when game clients are running.

**Impact on NightSchool Lane F:** none either way. The `C:\Users\larry` broad snapshot is Policy D — out of NightSchool scope. Its errors do not affect Policies A, B, or C.

**No action needed on CK-Q3 before NightSchool policies are created.** Flagging for Codex to choose Option a or b as a housekeeping decision.

---

### CK-Q4 — Kopia repository location ✓ ANSWERED

**Answer (Larry, 2026-06-21):** `E:\KopiaRepo`

**Analysis:** This is an excellent layout. Three drives, three roles:

| Drive | Role | Kopia relationship |
|---|---|---|
| `C:\` | OS + user profile + primary Hermes install | **Snapshot source only** — never the repository |
| `L:\` | NightSchool build artifacts, WSL projects | **Snapshot source only** |
| `E:\` | Kopia repository (`E:\KopiaRepo`) | **Repository only** — never a snapshot source |

This means a failure or corruption event on `C:\` or `L:\` does not affect the repository, and a repository integrity issue on `E:\` does not affect the live source data. The drive separation is the right physical isolation architecture.

**Headroom:** `E:\` holds the repository independently of `C:\` and `L:\`. No risk of Policy A or Policy C snapshots filling the OS drive. Codex should confirm `E:\` has sufficient free space for the projected snapshot volume (estimated: Policy A ~5–10GB deduplicated over the build; Policy C ~2–4GB per primary Hermes baseline rolling window of 30 snapshots).

**No action needed on CK-Q4.** Removing from Codex question list.

---

### CK-Q5 — Schedule mechanics: can Kopia trigger a snapshot from a PowerShell script?

The proposed pre-launch ritual (step 1: trigger Policy C snapshots before launch) assumes a CLI or scripted trigger. Kopia has a CLI (`kopia snapshot create`) but it needs to target the right policy/source.

**Request:** Codex to confirm the exact `kopia` CLI command to trigger a snapshot of a specific source path against the configured repository, for inclusion in the updated launch script or a companion pre-launch script.

If the command is straightforward, it could be added to `launch_hermes_nightschool_safe_reuse.ps1` as a pre-launch step — snapshot primary Hermes before every NightSchool launch, automatically.

---

## Implementation Sequence (after Codex approval)

These are the steps, in order, once Codex vets and approves this spec. Nothing below runs until that approval.

*CK-Q3 and CK-Q4 are pre-answered. CK-Q5 (CLI command) is needed before step 7. CK-Q1 and CK-Q2 are needed before step 9 (final Lane F sign-off). Steps 2–6 can proceed in parallel with Codex reviewing CK-Q1/Q2/Q5.*

1. **Codex approves this spec** — specifically CK-Q1, CK-Q2, CK-Q5, and chooses CK-Q3 Option a or b.
2. **Create Policy C** (primary Hermes baseline snapshots: `Hermes\` and `.hermes\`) — manual trigger only, reference snapshots. Do this first so the Lane F evidence chain starts before any NightSchool work proceeds.
3. **Trigger Policy C manually** — first baseline snapshot. Timestamps the primary Hermes state as of today.
4. **Create Policy A** (`L:\WSL_Projects_Folder\Nightschool_Study\`) — NightSchool build artifacts. Schedule: every 2 hours active / daily idle.
5. **Create Policy B1** (`C:\Users\larry\AppData\Roaming\Hermes-NightSchool\`) and **Policy B2** (`.hermes-nightschool\`) — NightSchool runtime state. Dirs may not exist yet on first policy creation; Kopia will snapshot them once Phase 1A creates them.
6. **Update `isolation_manifest.md`** — add T8 tripwire, Kopia policy table, and `E:\KopiaRepo` as confirmed repository.
7. **Update `launch_hermes_nightschool_safe_reuse.ps1`** — add pre-launch Policy C snapshot trigger using CK-Q5 CLI answer. Makes baseline snapshot automatic on every NightSchool session open.
8. **Address Policy D** (`C:\Users\larry` broad snapshot) — apply Option CK-Q3a exclusions (Epic/Riot lock paths) if Codex selects a. No NightSchool action needed either way.
9. **Final Lane F sign-off** — confirm all policies in place, first Policy A and B snapshots clean, T8 tripwire verified. Write Phase 1A Kopia verification card.
10. **NAS migration** — deferred. When NAS is available: add as a second Kopia repository target, replicate existing policy set, retire or keep `E:\KopiaRepo` as local cache.

---

## Files This Spec Updates (after Codex approval)

| File | Change |
|---|---|
| `isolation_manifest.md` | Add T8 tripwire, Kopia policy table |
| `launch_hermes_nightschool_safe_reuse.ps1` | Add pre-launch Policy C snapshot trigger |
| `PRD/NightSchool_PRD_and_Execution_System.md` | Add Kopia as Lane F sub-component in §2.3 |
| `DEPENDENCIES.md` | Add Kopia v0.23.1 entry |

---

## Summary Table

| Policy | Root | Purpose | Schedule | Lane F role |
|---|---|---|---|---|
| A — nightschool-build | `L:\WSL_Projects_Folder\Nightschool_Study\` | NightSchool build artifacts | Every 2h active / daily | Primary VCS for build |
| B1 — nightschool-hermes-userdata | `C:\...\Hermes-NightSchool\` | NightSchool Electron state | Post-session | Roll-back NightSchool GUI state |
| B2 — nightschool-hermes-home | `C:\Users\larry\.hermes-nightschool\` | NightSchool backend state | Post-session | Roll-back NightSchool agent state |
| C1 — primary-hermes-userdata-baseline | `C:\...\Hermes\` | Primary Hermes reference | Pre-launch (manual) | Lane F drift evidence chain |
| C2 — primary-hermes-home-baseline | `C:\Users\larry\.hermes\` | Primary backend reference | Pre-launch (manual) | Lane F drift evidence chain |
| D — `C:\Users\larry` broad | `C:\Users\larry` | General user backup | TBD | Out of NightSchool scope — retire or add exclusions |
| E — `L:\` broad | `L:\` | Safety net during build | Every ~12h (existing) | Keep as-is; retire after NAS migration |
