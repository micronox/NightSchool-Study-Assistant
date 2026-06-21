# Lessons Learned

## Architecture defense matters

Source-level review found three consequential errors in the original plan: desktop single-instance behavior, unsafe user-scoped writes in fresh bootstrap, and stale fixed-port assumptions.

## Verified facts must stay separate from planned work

Successful verification notes, approved designs, run instructions, and future-phase checklists are different evidence classes and should not be blended.

## A narrow first slice improves learning

The NightSchool Study Assistant provides a bounded environment to prove isolation, dependency discipline, handoff quality, backup policy, and validation gates before carrying those practices into broader product work.

## The next proof is operational

The next credibility milestone is a controlled Phase 1A launch with evidence that isolated paths work as intended and the primary Hermes state remains unchanged.
