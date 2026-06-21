# Lessons Learned

## 1. Architecture defense is part of execution

The first Hermes isolation design looked plausible, but source-level review found three consequential errors: the desktop cannot run as two concurrent instances, fresh bootstrap can persist user-level environment changes, and the fixed-port assumption did not match the active local backend path. Stopping at the gate prevented a clean-looking plan from becoming a state-contamination problem.

## 2. Separate verified facts from planned work

The packet contains successful verification notes, proposed ADRs, approved designs, run instructions, and future-phase checklists. Those are different evidence classes. A plan being approved is not the same as a launch passing its post-launch checks; the handoff should say which one it means.

## 3. A narrow first slice improves learning

The NightSchool Study Assistant gives the team a bounded place to test project isolation, dependency pins, handoff discipline, model routing, backup policy, and validation gates. The useful lesson is not that every downstream product question is already solved; it is that the operating method can be exercised before it is promoted into a larger product.

## 4. Validation should precede mutation

The strongest artifacts follow a consistent pattern: inspect read-only, record the baseline, ask explicit architecture questions, redline the plan, then authorize a constrained next step. That sequence made it possible to change direction without losing provenance.

## 5. Cost-aware routing needs precise language

The evidence shows work split across Claude, Codex, Hermes, local Ollama, and a free Nemotron route, with compact handoffs used to reduce repeated context. It supports a cost-aware multi-tool strategy. It does not contain a financial comparison proving a specific savings figure, so the packet should avoid unsupported price claims.

## 6. Handoffs are an engineering control

Timestamped notes, a PRD checklist, an isolation manifest, a dependency ledger, and a claim-to-source map let a later session resume without reconstructing the entire weekend from memory. That is especially valuable in multi-lane work, where context drift can otherwise erase the reason behind a safety constraint.

## 7. The next proof must be operational

The next credibility milestone is not another design document. It is the controlled Phase 1A launch plus evidence that the NightSchool Study Assistant writes only to its isolated paths, primary Hermes state and user environment remain unchanged, and the prescribed backup checks work.
