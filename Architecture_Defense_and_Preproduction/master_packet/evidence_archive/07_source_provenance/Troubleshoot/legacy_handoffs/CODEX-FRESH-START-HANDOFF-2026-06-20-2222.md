# Codex Fresh Start Handoff

- Date: 2026-06-20
- Time: 22:22 America/Chicago
- Purpose: short restart handoff for a fresh Codex chat in this troubleshooting
  directory

## Primary Resume Goal

Resume Hermes troubleshooting without losing the distinction between:

- Hermes launched through WSL / CLI / dashboard
- the native Hermes desktop app
- the future forked desktop-product direction

Do not flatten these into one surface.

## Most Important Current Facts

### 1. `9119` matters

`9119` is the Hermes dashboard port, confirmed from:

```powershell
hermes --help
```

Relevant command:

```powershell
hermes dashboard
```

This starts the web UI dashboard on:

- `http://127.0.0.1:9119`

### 2. After reboot, the missing piece was likely the dashboard launch

Running:

```powershell
hermes dashboard
```

successfully brought `9119` back.

Terminal reported:

- `HERMES_DASHBOARD_READY port=9119`
- `Hermes Web UI -> http://127.0.0.1:9119`

Interpretation:

- the working pre-restart shape likely depended on `hermes dashboard`
- startup/autolaunch likely had not yet been formalized

### 3. Hermes desktop had been pinned to a bad mode earlier

Earlier troubleshooting found:

- `C:\Users\larry\AppData\Roaming\Hermes\connection.json`

had Hermes desktop pinned to:

- `"mode": "remote"`

pointing at:

- `http://localhost:9119`

That caused an expired remote-gateway boot failure.

That file was changed so top-level mode became:

- `"mode": "local"`

Backup:

- `C:\Users\larry\AppData\Roaming\Hermes\connection.json.bak-20260620-2136`

### 4. Dashboard recovery is not the same as messaging recovery

After `9119` came back, the dashboard UI was reachable, but the dashboard also
showed:

- `Gateway Status: Off`

This means:

- dashboard/web UI can be up
- messaging gateway can still be off

Keep those as separate diagnostic tracks.

### 5. Session/history state is inconsistent across surfaces

Observed symptoms:

- `user not found`
- `target user message is no longer in session history`

Interpretation:

- likely surface/session/history mismatch
- not necessarily a broken install

### 6. The real investigation is architectural

The user specifically wants to understand the difference between:

- Hermes pushed through WSL / CLI / dashboard
- the desktop app being considered for a fork

Because of that, avoid broad resets that would muddy the distinction.

## What Not To Do First

Do not immediately:

- rerun full `hermes setup`
- redesign ports
- do broad re-auth blindly
- trust old broken sessions/checkpoints as primary evidence

Reason:

- the user is trying to recover and study the original runtime shape, not
  merely make Hermes generically usable

## Recommended Fresh-Chat Starting Point

1. Treat `9119` as re-established.
2. Treat the old/broken sessions as contaminated evidence.
3. Test with fresh sessions first.
4. Compare behavior between:
   - WSL/CLI-launched dashboard on `9119`
   - native Hermes desktop app
5. Determine which surface is authoritative for runtime and session state.
6. Only after that, decide what should autostart.

## Likely Next Phase

The likely next practical work is:

- identify exact launch chain for the intended pre-restart shape
- confirm whether `hermes dashboard` alone is the key startup item
- decide whether `hermes gateway` belongs in startup separately
- document the startup order before automating it with `.ps1`, `.bat`, or a
  scheduled task

## Important Reference Files

Longer recovery note:

- [HERMES-REPRO-RE-ESTABLISH-NOTES-2026-06-20-2215.md](C:/Users/larry/Documents/Troubleshoot/HERMES-REPRO-RE-ESTABLISH-NOTES-2026-06-20-2215.md)

Earlier handoff:

- [CODEX-HANDOFF-2026-06-20-HERMES-RESTART.md](C:/Users/larry/Documents/Troubleshoot/CODEX-HANDOFF-2026-06-20-HERMES-RESTART.md)

Broader rebuild context:

- [NORTHSTAR-REBUILD-HANDOFF-2026-06-17.md](C:/Users/larry/Documents/Troubleshoot/NORTHSTAR-REBUILD-HANDOFF-2026-06-17.md)
- [NORTHSTAR-STACK-RESEARCH-BRIEF-2026-06-11.md](C:/Users/larry/Documents/Troubleshoot/NORTHSTAR-STACK-RESEARCH-BRIEF-2026-06-11.md)

## Bottom Line

Fresh Codex should begin from this assumption:

- the key post-reboot recovery was restoring the dashboard surface on `9119`
- the current unresolved issue is the mismatch between dashboard/runtime state,
  desktop-app state, and messaging/session history
- the user wants surgical understanding first, automation second
