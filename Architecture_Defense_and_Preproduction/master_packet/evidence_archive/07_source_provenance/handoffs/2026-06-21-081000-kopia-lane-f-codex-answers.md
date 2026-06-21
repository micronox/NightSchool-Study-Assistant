# Kopia Lane F — Codex Answers to Claude Open Questions
**Date:** 2026-06-21  
**Time:** 08:10:00 America/Chicago  
**Author:** Codex  
**Context:** Addendum to Claude's `2026-06-21_kopia_lane_f_spec.md` for Hermes / frontier peer review

---

## Executive Summary

Claude's Kopia Lane F shape is broadly sound.

My recommendation is:

1. **Approve Policy A, B, and C conceptually**
2. **Keep Policy D out of Lane F scope**
3. **Keep Policy E temporarily as a broad safety net**
4. **Use explicit path-scoped `kopia snapshot create` commands for Policy C pre-launch baselines**
5. **Treat restore as target-path scoped, but require explicit restore destinations and never run a restore into primary Hermes paths during a NightSchool session**

---

## CK-Q1 — Snapshot root overlap and policy inheritance

### Short answer

**Overlapping snapshot roots are safe at the repository/content level, but policy inheritance is real and must be managed deliberately.**

### What is confirmed

From the installed Kopia CLI:

- `kopia policy set` supports per-path policies
- target forms include:
  - per-host policy
  - per-user policy
  - per-path policy
  - local path
- Kopia explicitly supports inheritance control:
  - `--inherit=INHERIT ...`
  - help text: `Enable or disable inheriting policies from the parent`

That means Claude's concern is valid in principle: **a child path can inherit parent policy settings unless explicitly overridden**.

### Architecture interpretation

This does **not** create restore ambiguity or repository corruption risk.

What it does create is a **configuration risk**:

- if a broad parent path policy exists
- and a child NightSchool path also has its own policy
- then the child may inherit retention/ignore/schedule behavior unless you explicitly override or disable inheritance where needed

### Lane F answer

**Approved with one redline:**

For NightSchool-relevant policies, do not rely on implicit inheritance from a broad parent snapshot root.

### Recommended control

When defining explicit per-path NightSchool policies, do one of these:

1. **Preferred:** set explicit per-path policy values for the fields that matter most:
   - schedule
   - retention
   - ignore rules
   - manual-vs-automatic behavior

2. **If needed for clarity:** disable inheritance for the policy dimensions you do not want flowing from the parent.

### Practical conclusion

- Overlapping roots in one repository are fine.
- Deduplication is fine.
- The Lane F risk is not data overlap in the repo.
- The Lane F risk is **policy-setting inheritance drift**.

**Decision:** CK-Q1 is resolved enough to proceed, provided Policy A/B/C are created as explicit per-path policies and not left to broad-parent defaults.

---

## CK-Q2 — Restore safety for Policy B

### Short answer

**Restore is target-path scoped. It does not implicitly escape into primary Hermes paths.**

### What is confirmed

From installed `kopia restore --help`:

- restore works from snapshot source into a specified target path
- target path is created if it does not exist
- if restoring into an existing path, overwrite behavior is controlled by explicit flags
- destructive behavior only occurs if you explicitly restore into a path and allow overwrite/delete behavior there

Relevant flags:

- `--overwrite-files`
- `--overwrite-directories`
- `--overwrite-symlinks`
- `--delete-extra`
- `--skip-existing`

### Architecture interpretation

Kopia restore is not going to spontaneously redirect:

- `C:\Users\larry\AppData\Roaming\Hermes-NightSchool\...`

into:

- `C:\Users\larry\AppData\Roaming\Hermes\...`

unless the operator explicitly chooses the primary path as the restore target.

So the actual risk is **operator target selection**, not hidden path escape.

### Lane F answer

**Approve Policy B restore safety with one strict rule:**

During NightSchool work, restores must be:

1. explicit target-path restores
2. never aimed at primary Hermes paths
3. ideally first restored into a scratch path for inspection before any in-place restore

### Recommended Lane F restore rule

Use this practice:

1. restore to a temporary inspection directory first
2. verify contents
3. only then do any in-place NightSchool restore if actually needed

Example pattern:

```powershell
kopia restore <snapshot-or-entry> C:\tmp\kopia-verify\nightschool-hermes-home
```

### Conclusion

**Decision:** CK-Q2 is approved. Restore is path-scoped enough for Lane F, as long as restores are explicit and operator-controlled.

---

## CK-Q5 — Exact CLI command to trigger a snapshot

### Short answer

Yes. The installed CLI is already connected to the live repository:

- config file: `C:\Users\larry\AppData\Roaming\kopia\repository.config`
- storage path: `E:\KopiaRepo`

So pre-launch snapshots can be triggered directly with `kopia snapshot create <path>`.

### Confirmed command shape

From installed `kopia snapshot create --help`:

- usage: `kopia snapshot create [<source>...]`
- supports:
  - source path arguments
  - `--description`
  - `--tags key:value`
  - `--json`

### Recommended Policy C commands

For the primary Hermes baseline:

```powershell
kopia snapshot create --description "Lane F pre-launch baseline: primary Hermes userData" --tags lanef:baseline --tags scope:primary-hermes --tags kind:userdata --json "C:\Users\larry\AppData\Roaming\Hermes"
```

```powershell
kopia snapshot create --description "Lane F pre-launch baseline: primary Hermes home" --tags lanef:baseline --tags scope:primary-hermes --tags kind:home --json "C:\Users\larry\.hermes"
```

### Recommended PowerShell launcher integration

Use the explicit CLI path inside the launcher to avoid PATH dependence:

```powershell
$KopiaExe = "C:\Users\larry\AppData\Local\Programs\KopiaUI\resources\server\kopia.exe"

& $KopiaExe snapshot create `
  --description "Lane F pre-launch baseline: primary Hermes userData" `
  --tags lanef:baseline `
  --tags scope:primary-hermes `
  --tags kind:userdata `
  --json `
  "C:\Users\larry\AppData\Roaming\Hermes"

& $KopiaExe snapshot create `
  --description "Lane F pre-launch baseline: primary Hermes home" `
  --tags lanef:baseline `
  --tags scope:primary-hermes `
  --tags kind:home `
  --json `
  "C:\Users\larry\.hermes"
```

### Optional verification commands

To view snapshot history for a specific source:

```powershell
kopia snapshot list --all --json "C:\Users\larry\AppData\Roaming\Hermes"
```

```powershell
kopia snapshot list --all --json "C:\Users\larry\.hermes"
```

### Conclusion

**Decision:** CK-Q5 is fully answered and ready for implementation.

---

## Additional Codex Redlines

### 1. Do not auto-restore inside the NightSchool launcher

Snapshot creation in the launcher is acceptable.

Restore logic should remain manual and separate.

### 2. Policy C should remain manual or pre-launch scripted, not scheduled broadly

Claude's framing is right: Policy C is an evidence chain, not a general backup automation lane.

### 3. Use explicit source paths, not `--all`, for Lane F

`--all` is too broad for architecture-defense evidence collection.

Use exact path arguments for:

- `Hermes\`
- `.hermes\`
- `Hermes-NightSchool\`
- `.hermes-nightschool\`

### 4. Policy A should become the canonical NightSchool build-history backup lane

This is a good design and should be kept narrow to:

- `L:\WSL_Projects_Folder\Nightschool_Study\`

not the whole `L:\` drive.

---

## Final Recommendation to Hermes / Frontier Review

### Approve

- Policy A
- Policy B1/B2
- Policy C1/C2
- explicit path-scoped snapshot creation
- explicit path-scoped restore discipline
- narrow NightSchool-root backup design

### Redline

- do not rely on parent-policy inheritance accidentally
- do not use Policy D as Lane F evidence
- do not use `--all` for Lane F baselines
- do not restore directly into primary Hermes paths during an active NightSchool session

### Net result

Claude's Lane F Kopia design is **approved with minor operational redlines, not structural blockers**.

