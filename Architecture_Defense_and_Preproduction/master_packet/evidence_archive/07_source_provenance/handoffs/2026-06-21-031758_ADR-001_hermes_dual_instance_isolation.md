# ADR-001: Hermes Dual-Instance Isolation — Shared Binary, Env-Var Profile Separation

**Status:** Proposed — awaiting Codex review (Q1–Q5 must be answered before Accepted)
**Date:** 2026-06-21
**Deciders:** operator (owner), Codex (Lane F architecture review)
**Authored by:** Claude (Cowork)
**Linked brief:** `handoffs/2026-06-21_phase1_codex_architecture_brief.md`

---

## Context

NightSchool requires a second Hermes Desktop instance that is fully isolated from the primary (worker) Hermes install. The primary install is read-only for NightSchool purposes (Lane F standing rule). Hermes is an Electron desktop app (`Hermes.exe`) with a Python agent backend. The question is: how do we run a NightSchool-scoped Hermes profile without installing a second binary and without touching the primary install's state?

### Forces in play

- Primary Hermes must not be mutated — Lane F enforces this as a hard rule.
- A full re-install (second binary) would be slow, require a full bootstrap/clone cycle, consume significant disk, and risk version drift between the two installs.
- Electron's architecture supports multiple concurrent instances with separate user-data directories. This is the standard Electron multi-profile pattern.
- Source inspection of `app.asar` confirmed two first-class env-var hooks that redirect both the GUI config root and the Python backend root. These are documented APIs in the app's own code, not undocumented hacks.
- The single-instance lock (`app.requestSingleInstanceLock()`) is an open question that is a binary blocker for concurrent operation (Q4).

---

## Decision

**Option A — shared binary, isolated state via env vars** is the selected approach, contingent on Codex confirming Q4 (no single-instance lock, or lock is per-userData).

Two environment variables are set before launching `Hermes.exe`:

| Env var | NightSchool value | Controls |
|---|---|---|
| `HERMES_DESKTOP_USER_DATA_DIR` | `$APPDATA_ROAMING_ROOT\Hermes-NightSchool` | Electron `userData` path — connection.json, active-profile.json, all GUI state |
| `HERMES_HOME` | `$USER_HOME\.hermes-nightschool` | Python agent backend root — venv, profiles, logs, bootstrap cache |

The existing binary at `$USER_HOME\.hermes\hermes-agent\apps\desktop\release\win-unpacked\Hermes.exe` is reused (read-only). The launch script (`scripts/launch_hermes_nightschool.ps1`) sets both vars and includes a Lane F pre-launch guard that hard-blocks if either var matches the primary paths.

---

## Options Considered

### Option A: Shared binary + env-var profile separation (SELECTED)

| Dimension | Assessment |
|-----------|------------|
| Complexity | Low — two env vars set in a PowerShell launcher |
| Install footprint | Minimal — no second binary, no re-clone of agent repo (if Q3 is resolvable) |
| Isolation fidelity | High — `HERMES_DESKTOP_USER_DATA_DIR` calls `app.setPath('userData', ...)` before any other app code runs; `HERMES_HOME` is threaded to all bootstrap/install stages |
| Source confidence | High — both vars source-confirmed in `electron/main.cjs` and `bootstrap-runner.cjs` via asar extraction |
| Lane F compatibility | High — primary paths never written to; Lane F tripwires catch drift |
| Concurrent operation | UNKNOWN (Q4 — single-instance lock) |

**Pros:**
- Uses Electron's own profile-separation mechanism exactly as designed.
- No version drift — both profiles use the identical binary.
- Rollback is trivial: delete `Hermes-NightSchool\` and `.hermes-nightschool\`, nothing else changed.
- Minimal surface area for Lane F to audit.
- Launch script is the only NightSchool-specific artifact outside `Prototype_workingFiles`.

**Cons:**
- Concurrent operation (primary + NightSchool running simultaneously) is unconfirmed until Q4 is answered.
- First NightSchool launch triggers a bootstrap sequence into `HERMES_HOME` — duration and outside-write behavior unknown (Q2).
- Port 9119 conflict risk if port is hardcoded rather than driven by `connection.json` (Q1).
- `safeStorage` and any other global Electron resources may not be per-userData (Q5 partial).

---

### Option B: Full second binary install (NOT selected)

| Dimension | Assessment |
|-----------|------------|
| Complexity | High — full bootstrap/clone cycle |
| Install footprint | Large — duplicates agent repo, venv, all binaries |
| Isolation fidelity | High — complete physical separation |
| Source confidence | N/A — standard install path |
| Lane F compatibility | Medium — second install is fully independent, but version drift is a new risk |
| Concurrent operation | Unknown — single-instance lock may still apply if it's per-user, not per-binary |

**Pros:** Maximum physical separation; no shared binary risk.

**Cons:** Slower; larger disk footprint; version drift if primary updates; doesn't actually solve the single-instance lock question; more artifacts for Lane F to audit.

**Rejected because:** Option A is lower complexity with equivalent isolation fidelity. The env-var hooks are first-class, source-confirmed APIs. A full re-install does not resolve the single-instance lock question and creates new risks (version drift) without eliminating the open ones.

---

### Option C: Run NightSchool only when primary Hermes is closed (fallback if Q4 is blocking)

If `app.requestSingleInstanceLock()` is confirmed present and non-bypassable, concurrent operation is impossible. The design reduces to: NightSchool and primary Hermes are never open simultaneously — they share the binary and alternate. Option A's env-var isolation is still the right mechanism; the difference is the operational model, not the architecture.

**When this applies:** Q4 returns YES (single-instance lock present, per-user scope).

**Consequence for the PRD:** Phase 1 card "First NightSchool Hermes launch" must include a verification step: confirm primary is closed before running the launch script. The Lane F drift check at launch time should verify primary is not running.

---

## Open Questions (Codex must answer before ADR moves to Accepted)

These map directly to Q1–Q5 in the Codex brief. ADR cannot be accepted until all are resolved.

| # | Question | Blocking? | Impact if YES | Impact if NO |
|---|---|---|---|---|
| Q4 | Does `main.cjs` call `app.requestSingleInstanceLock()`? | **BINARY BLOCKER** | Concurrent operation impossible → fall to Option C operational model | Option A proceeds as designed |
| Q1 | Is port 9119 sourced from `connection.json` (userData-controlled) or hardcoded? | High | NightSchool cannot run alongside primary on same machine unless port is configurable | Configure NightSchool `connection.json` to 8100-range port — no issue |
| Q2 | Does bootstrap on first `HERMES_HOME` write outside `HERMES_HOME`? | High | Lane F violation; must identify and contain before launch | Option A first launch is clean |
| Q3 | Can NightSchool reuse `~/.hermes/hermes-agent/` agent binary, skipping re-bootstrap? | Medium | First launch is slower, more network, more disk | Faster first launch path available |
| Q5 | Are the three Lane F tripwires sufficient? Any `safeStorage` or global resource contention? | Medium | Additional tripwires needed before launch | Manifest is complete |

---

## Trade-off Analysis

**Complexity vs. isolation fidelity:** Option A achieves isolation fidelity equivalent to Option B at a fraction of the complexity. The env-var hooks are the right tool precisely because Electron was designed for multi-profile use. The only meaningful uncertainty is whether the app's single-instance lock (Q4) prevents concurrent operation — and if it does, Option C's operational model handles it without changing the isolation architecture.

**Shared binary risk:** Both profiles run identical code. This is a feature, not a risk — version drift (the main risk of Option B) is impossible. If Hermes auto-updates, both profiles update together; the Lane F drift check should verify binary hash parity after any update.

**Bootstrap footprint:** Q2 and Q3 together determine whether first NightSchool launch triggers a full agent re-clone or can reuse the existing agent binary. If re-clone is required, the first launch has a one-time cost (network, disk, time) but is not an architectural problem — it's an operational note for operator.

**Port isolation:** Q1 is architecturally clean if `connection.json` is authoritative for port selection (the working hypothesis). If port is hardcoded, the design needs a different approach for concurrent operation but Option C still works for alternating operation.

---

## Consequences

**What becomes easier:**
- Rollback is a directory delete — `Hermes-NightSchool\` and `.hermes-nightschool\` only.
- Lane F audit surface is minimal — two paths, one launch script.
- No version management complexity — single binary serves both profiles.
- Phase 1 completion unlocks all subsequent NightSchool phases (messaging, personas, dashboard).

**What becomes harder:**
- If Q4 is YES: concurrent operation with primary Hermes requires user discipline (close primary before launching NightSchool). Cannot be enforced by the launch script alone — the script would need to check whether the primary process is running and warn/block.
- First launch bootstrap behavior (Q2) must be observed and documented before Phase 1 can be marked complete — cannot pre-certify it clean without Codex confirmation.
- If `safeStorage` is per-machine rather than per-userData (Q5), credential isolation is incomplete and may require a different storage approach for NightSchool API keys.

**What we'll need to revisit:**
- After first NightSchool launch: verify `connection.json` was written to `Hermes-NightSchool\` (not primary).
- After bootstrap completes: inventory everything written under `.hermes-nightschool\` and confirm no outside writes.
- After any Hermes binary update: re-verify env-var hooks are still present in the new `main.cjs`.

---

## Lane F Tripwires (current — subject to Q5 expansion)

| Tripwire | Check | Failure action |
|---|---|---|
| userData path | `HERMES_DESKTOP_USER_DATA_DIR` ≠ `$APPDATA_ROAMING_ROOT\Hermes` | Hard block in launch script |
| Backend root | `HERMES_HOME` ≠ `$USER_HOME\.hermes` | Hard block in launch script |
| Port isolation | NightSchool `connection.json` must not reference port 9119 | Phase 1 card verification step |
| Primary unchanged | `Hermes\connection.json` unchanged after NightSchool launch | Lane F post-launch drift check |

*Q5 may add additional tripwires (safeStorage, temp dir contamination, env var inheritance from primary session).*

---

## Action Items

1. [ ] **[Codex]** Answer Q4 — grep `main.cjs` for `requestSingleInstanceLock`. This is the binary blocker.
2. [ ] **[Codex]** Answer Q1 — inspect `connection-config.cjs` and `backend-ready.cjs` for port resolution.
3. [ ] **[Codex]** Answer Q2 — inspect bootstrap stages for writes outside `HERMES_HOME`.
4. [ ] **[Codex]** Answer Q3 — assess whether agent binary reuse is possible.
5. [ ] **[Codex]** Answer Q5 — grep for `safeStorage`, assess tripwire completeness.
6. [ ] **[Codex]** Approve or redline `launch_hermes_nightschool.ps1`.
7. [ ] **[Claude]** Translate Codex answers into step-by-step instructions for operator.
8. [ ] **[operator]** Run launch script per translated instructions (only after Codex approves).
9. [ ] Update ADR status to **Accepted** once Q1–Q5 are answered and launch script is approved.
10. [ ] Append post-launch evidence (connection.json paths, bootstrap inventory) to ADR as an addendum.


