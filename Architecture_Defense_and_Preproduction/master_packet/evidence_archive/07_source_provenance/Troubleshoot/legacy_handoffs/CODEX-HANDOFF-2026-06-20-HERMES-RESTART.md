# Codex Handoff 2026-06-20 Hermes Restart

- Date: 2026-06-20
- Author: Codex
- Purpose: resume the post-rebuild local-machine troubleshooting thread after a
  Windows restart without requiring the user to restate prior context

## Context We Can Reliably Recover

The user reported that:

- WSL had already been reformatted and rebuilt
- Hermes had already been reinstalled
- the local AI stack had been working before the Windows restart
- after reboot, the concern was that startup/autostart state may not have been
  preserved

This handoff does not reconstruct the full prior session, but it captures the
  exact local state observed and the fix applied in this pass.

Related existing handoff:

- [NORTHSTAR-REBUILD-HANDOFF-2026-06-17.md](`$TROUBLESHOOT_ROOT/NORTHSTAR-REBUILD-HANDOFF-2026-06-17.md)

## What The User Saw

From the screenshots provided at the start of this pass:

- Hermes desktop opened to:
  - "Hermes couldn't start"
  - "Your remote gateway session has expired. Open Settings -> Gateway and click
    'Sign in' again."
- WSL Dashboard showed:
  - `Ubuntu-24.04` running
- WSL terminal screenshots suggested:
  - GPU passthrough / NVIDIA visibility was present
  - WSL networking adapters existed

Interpretation:

- this did not initially look like a broken WSL boot
- this looked like a Hermes desktop gateway-selection problem first

## Root Cause Confirmed In This Pass

Hermes desktop was not failing because WSL or the local stack was absent.

It was repeatedly choosing a persisted remote gateway mode with expired OAuth
state.

Evidence gathered:

- Hermes desktop processes were running
- `$USER_HOME\.hermes\logs\desktop.log` repeatedly showed:
  - `Desktop boot failed: Your remote gateway session has expired. Open Settings → Gateway and click "Sign in" again.`
- The persisted desktop connection file was:
  - `$APPDATA_ROAMING_ROOT\Hermes\connection.json`
- Its contents before the fix were:

```json
{
  "mode": "remote",
  "remote": {
    "url": "http://localhost:9119",
    "authMode": "oauth"
  },
  "profiles": {}
}
```

Important conclusion:

- the desktop app was pinned to `remote` mode
- the configured remote target was `http://localhost:9119`
- the OAuth session for that remote mode had expired
- desktop boot was failing before it ever fell back to the local path

## Exact Fix Applied

The file below was updated:

- `$APPDATA_ROAMING_ROOT\Hermes\connection.json`

Backup created:

- `$APPDATA_ROAMING_ROOT\Hermes\connection.json.bak-20260620-2136`

Current contents after the fix:

```json
{
  "mode": "local",
  "remote": {
    "url": "http://localhost:9119",
    "authMode": "oauth"
  },
  "profiles": {}
}
```

Only the top-level `mode` was changed from `remote` to `local`.

## Additional Observations From This Pass

- `$USER_HOME\.hermes\config.yaml` exists and is substantial
- `$USER_HOME\.hermes\auth.json` exists
- `$USER_HOME\.hermes\logs\desktop.log` was the most useful current log
- no normal user Startup entry for Hermes was found in the places checked
- Hermes appeared to be launching, but launching into the wrong connection mode

The practical result is:

- "autostart missing" was not the first blocker
- "wrong persisted connection mode after reboot" was the first blocker

## What The Next Agent Should Do

1. Ask the user whether Hermes was retried/reopened after the local-mode change.
2. Verify whether Hermes now boots into the local stack successfully.
3. If Hermes still fails, inspect the next failure after local-mode selection,
   not the old expired-remote symptom.
4. If Hermes does boot, continue with the user's original concern:
   - determine which parts of the rebuilt stack should auto-start at Windows
     login
   - identify whether Hermes, WSL services, model servers, or supporting tools
     need Startup entries, scheduled tasks, or service wrappers
5. Preserve the distinction between:
   - desktop connection mode
   - Hermes runtime health
   - WSL distro boot state
   - model server autostart

## Recommended Immediate Check Sequence

If continuing manually:

1. Open Hermes.
2. Click `Retry`, or fully close and reopen Hermes once.
3. Confirm whether the expired remote-gateway message is gone.
4. If the message is gone, inventory what local services are actually expected
   to auto-start after login.
5. Only after that, build or repair Windows autostart.

## Short Version

The most important discovery from this pass is:

- the machine did not first fail on WSL startup
- Hermes desktop was pinned to a stale remote OAuth gateway mode
- switching `$APPDATA_ROAMING_ROOT\Hermes\connection.json` from
  `"mode": "remote"` to `"mode": "local"` was the key fix applied

This is the place to resume from.


