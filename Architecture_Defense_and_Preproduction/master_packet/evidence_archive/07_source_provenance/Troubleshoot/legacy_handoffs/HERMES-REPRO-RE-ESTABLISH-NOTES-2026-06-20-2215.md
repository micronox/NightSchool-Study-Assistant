# Hermes Repro Re-establish Notes

- Date: 2026-06-20
- Time: 22:15 America/Chicago
- Author: Codex
- Purpose: capture the current repro/recovery state for Hermes so the process
  can be reviewed later in a post-mortem

## Summary

After a Windows restart, Hermes no longer appeared to come back in the same
working shape that had existed during the Qwen + Hermes development cycle.

The immediate goal was not to redesign the stack or reconfigure Hermes from
scratch. The goal was to re-establish the previously working runtime shape as
faithfully as possible, understand which surface was responsible for that
shape, and avoid crossing wires between:

- Hermes launched through WSL / CLI / dashboard
- the native Hermes desktop app
- the future forked desktop product direction

## What Happened

The user had previously:

- reformatted and rebuilt the WSL environment
- reinstalled Hermes
- restored a working local AI stack
- been using Hermes while developing toward a different desktop-product shape

After restarting Windows, Hermes no longer appeared to resume the same way.

Observed symptoms included:

- Hermes desktop initially showing a remote gateway expiry failure
- `http://localhost:9119` not resolving at first
- uncertainty about whether startup/autolaunch steps had ever been formally
  written
- the desktop app and the WSL/CLI-backed Hermes surfaces appearing mismatched
- intermittent errors such as:
  - `user not found`
  - `target user message is no longer in session history`

## What We Diagnosed

### 1. The original failure was not primarily WSL being down

WSL appeared available, and the earlier failure state pointed more strongly to
Hermes booting into the wrong connection mode than to a dead distro.

### 2. Hermes desktop had been pinned to the wrong mode

The Hermes desktop connection config in:

- `C:\Users\larry\AppData\Roaming\Hermes\connection.json`

had been set to:

- `"mode": "remote"`

with a remote target pointing at:

- `http://localhost:9119`

That caused Hermes desktop to try to boot through an expired remote-style
gateway session instead of a local path.

That mode was changed back to local during troubleshooting so the desktop would
stop failing immediately on the expired remote-gateway path.

### 3. Port `9119` was identified as the Hermes dashboard surface

By checking the Hermes CLI help text, we confirmed:

- `hermes dashboard` starts the web UI dashboard
- the dashboard uses port `9119`

This was an important correction in understanding. `9119` was not just an
mystery forwarded port. It was a first-class Hermes dashboard surface.

### 4. The missing post-reboot piece was likely launch-chain related

Running:

```powershell
hermes dashboard
```

re-established the dashboard shape, and the terminal reported:

- `HERMES_DASHBOARD_READY port=9119`
- `Hermes Web UI -> http://127.0.0.1:9119`

That strongly suggests the reboot problem was at least partly caused by the
dashboard process simply not being relaunched automatically.

### 5. Dashboard recovery and messaging state are separate concerns

Once `9119` came back, the dashboard UI became reachable again, but the UI also
showed:

- `Gateway Status: Off`

This indicates:

- dashboard/web UI can be alive
- core Hermes runtime can be partially alive
- messaging gateway can still be off

So `9119` recovery and messaging recovery must be treated as separate tracks.

### 6. Desktop app and WSL/CLI-backed dashboard appear to have a state mismatch

By the end of this pass, the main issue had shifted away from "Hermes will not
start" toward:

- which surface is authoritative
- whether the desktop app and WSL/CLI dashboard are sharing the same runtime
  state cleanly
- whether stale session/checkpoint history is creating misleading errors

The `user not found` and `target user message is no longer in session history`
errors point more toward session/history or surface coupling problems than a
simple broken install.

## Why We Are Diagnosing It This Way

We are being intentionally conservative.

The user is not trying to perform a generic Hermes setup from scratch. The user
is trying to preserve and understand a very specific shape that mattered during
development:

- Hermes operating through WSL / CLI / dashboard
- a desktop surface being explored as the basis for a forked product
- Qwen working inside that shape

Because of that, broad actions such as:

- rerunning full Hermes setup
- redesigning the port layout
- changing multiple configs at once
- reauthing everything blindly

could destroy the distinction we are trying to study.

The current approach is therefore:

1. restore the previously working surface first
2. isolate the runtime layers
3. identify which surface owns which state
4. avoid treating all Hermes surfaces as interchangeable
5. only automate startup after the intended shape is clearly identified

This approach is important for a later post-mortem because it preserves cause
and effect instead of flattening everything into one "reinstall/fix" event.

## Current Understanding Of The Surfaces

### Surface A: WSL / CLI / dashboard

This is the Hermes shape launched explicitly through command line, especially:

```powershell
hermes dashboard
```

This surface:

- brings back `9119`
- exposes the dashboard UI
- appears closest to the pre-restart product-facing shape

### Surface B: Native desktop app

This is a separate shell with overlapping branding and capabilities, but it may
not be attached to exactly the same live runtime/session/history state as the
CLI-launched dashboard.

This distinction is a core part of the current investigation.

### Surface C: Messaging gateway

This is not the same thing as the dashboard itself.

Messaging being off does not prove the dashboard is broken, and messaging errors
such as `user not found` should not automatically be treated as proof that the
dashboard path is wrong.

## Why We Are Not Rerunning Full Setup Yet

At this stage, rerunning full setup would likely hide the very thing we are
trying to understand:

- the difference between the WSL/CLI-backed Hermes runtime
- and the native desktop app surface being considered for a fork

Until that boundary is clear, full setup and wide re-auth are more likely to
muddy the historical shape than to clarify it.

## Steps Moving Forward

### Immediate steps

1. Treat `9119` as successfully re-established.
2. Keep the terminal session that launched `hermes dashboard` open while
   validating behavior.
3. Avoid relying on old broken sessions or checkpoint restore paths for primary
   diagnosis.
4. Prefer fresh-session testing over stale-session testing.

### Diagnostic steps

1. Compare behavior between:
   - the WSL/CLI-launched dashboard on `9119`
   - the native desktop app
2. Determine whether both surfaces:
   - share the same session store
   - share the same runtime
   - or only partially overlap
3. Treat `user not found` and checkpoint-history errors as likely evidence of
   surface/state mismatch unless disproven.

### Stability steps

1. Once the intended surface is confirmed, document the exact launch chain that
   reproduces it.
2. Only after that, decide what should autostart on boot.
3. Most likely candidates for startup automation:
   - `hermes dashboard`
   - optionally `hermes gateway` if messaging is actually required in the
     desired product shape

### Post-recovery steps

1. Write down the exact startup order.
2. Convert that order into:
   - a `.ps1`
   - optionally a thin `.bat`
   - or a scheduled startup action later
3. Preserve the distinction between:
   - dashboard recovery
   - messaging recovery
   - session/history cleanup
   - desktop-fork product work

## Bottom Line

The key insight from this troubleshooting pass is that the system should not be
treated as "one Hermes."

There are multiple meaningful layers:

- the CLI/WSL/dashboard runtime on `9119`
- the separate desktop shell
- the messaging gateway
- the session/history/checkpoint layer

The goal is not merely to make Hermes respond again. The goal is to recover the
correct development shape, understand its boundaries, and only then automate or
refactor it.
