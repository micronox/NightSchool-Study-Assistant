# Troubleshoot Operating Rules

- Updated: 2026-06-21 04:12:07 America/Chicago

## Logging Rule

When exporting notes, logs, changelogs, handoffs, or full-context summaries:

- include both the date and a timecode in the filename
- include both the date and a timecode inside the document header when practical

Preferred filename pattern:

- `YYYY-MM-DD-HHMMSS-short-title.md`

Example:

- `2026-06-21-041207-hermes-handoff.md`

## Folder Rule

Under `$TROUBLESHOOT_ROOT`:

- `handoff` is for concise reset-ready handoffs
- `full_context` is for richer notes, changelogs, and broader context captures

## Cleanup Direction

Daily cleanup and organization should eventually be automated with a Hermes cron job, but that automation is intentionally deferred for now.


