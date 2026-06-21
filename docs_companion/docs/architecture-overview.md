# Architecture Overview

The NightSchool Study Assistant is a Mission Control system forked from Hermes and adapted to complete NightSchool class tasks.

## System shape

The system uses six coordinated agents:

- **Bill** - the top-level orchestrator on Telegram.
- **Vault** - stores and organizes source materials and durable project knowledge.
- **Scholar** - converts source material into structured Markdown notes and research outputs.
- **Quiz Master** - creates quizzes, flashcards, review prompts, and study materials.
- **Planner** - extracts deadlines, assignments, and scheduling requirements.
- **Dev** - handles technical implementation, automation, and support work.

## Workflow

Uploading a PDF initiates a coordinated workflow:

1. Vault stores and classifies the source.
2. Scholar produces structured notes.
3. Quiz Master creates study materials.
4. Planner extracts deadlines and schedules work.
5. Dev supports any required automation or implementation.

## Governance

Mission Control is paired with an evidence-backed architecture process:

- Architecture Decision Records capture consequential technical choices.
- Specification sheets define the approved implementation shape.
- Decision logs preserve why a direction was accepted, revised, or rejected.
- Validation gates prevent implementation drift from the PRD.
