# Phase 1A — What Larry Does Next
**Date:** 2026-06-21
**Written by:** Claude, based on Codex Phase 1 review

---

## The Situation

Codex reviewed the Phase 1 plan. Three things changed:

1. **Primary Hermes must be closed before launching NightSchool.** Hermes uses a single-instance lock — two copies can't run at the same time. NightSchool is a *sequential* alternate, not something that runs alongside primary.

2. **A new launch script replaces the old one.** The old `launch_hermes_nightschool.ps1` was not approved because it could trigger Hermes's installer, which writes to your user-level environment (PATH, HERMES_HOME). The new script (`launch_hermes_nightschool_safe_reuse.ps1`) avoids that by reusing the existing Hermes agent code instead of bootstrapping from scratch.

3. **Port 8100 is no longer the isolation mechanism.** Hermes's local backend uses an OS-assigned port at runtime, not a fixed one from `connection.json`. The isolation comes entirely from the two directory paths (which the new script sets correctly).

**Bottom line:** you can proceed. The approved script is ready. Here's exactly what to do.

---

## Step-by-Step Instructions

### Step 1 — Open a fresh PowerShell and do a quick pre-flight check

Open a new PowerShell window. Run these two commands and tell Claude what they output:

```powershell
echo $env:HERMES_HOME
echo $env:HERMES_DESKTOP_USER_DATA_DIR
```

**Expected:** both should return blank/nothing. If either returns a path, stop and tell Claude before continuing.

---

### Step 2 — Close primary Hermes completely

Close your primary Hermes desktop window. Then verify it's actually gone:

```powershell
Get-Process -Name "Hermes" -ErrorAction SilentlyContinue
```

**Expected:** no output (empty). If it still shows a process, wait a moment and try again. Don't proceed until Hermes is fully closed.

---

### Step 3 — Run the approved launch script

In the same PowerShell window, run:

```powershell
cd L:\WSL_Projects_Folder\Nightschool_Study\Prototype_workingFiles\scripts
.\launch_hermes_nightschool_safe_reuse.ps1
```

**What you'll see:** the script prints its path config, does its Lane F checks, creates some directories, then launches Hermes and prints a post-launch checklist.

**If you see `[LANE F] BLOCKED`:** stop and paste the full output to Claude.
**If Hermes opens:** good — you'll see it on screen as a fresh/blank Hermes instance.

---

### Step 4 — Do NOT do these things in the NightSchool Hermes window

Once the NightSchool Hermes window is open:
- **Do not click any update button.** The update flow would write into the shared agent code directory.
- **Do not run any uninstall flow.**
- Otherwise you can interact with it normally to see what the fresh profile looks like.

---

### Step 5 — Paste the script output to Claude

Copy and paste the full PowerShell output from Step 3 to Claude. Claude will then read the new `connection.json` and directory state to verify the isolation is clean (the Lane F post-launch checks).

---

### Step 6 — Open a new PowerShell and run the env checks

After launch, open a **new** PowerShell window (separate from the one you ran the script in — this is important to avoid inheriting the per-process env vars):

```powershell
echo $env:HERMES_HOME
[System.Environment]::GetEnvironmentVariable("HERMES_HOME", "User")
```

**Expected:** both should be empty or your original primary value (`C:\Users\larry\.hermes`). If either shows `.hermes-nightschool`, that's a Lane F flag — tell Claude immediately.

---

## What Happens After This

Once the post-launch checks pass, Claude will:
- Verify both `connection.json` files (NightSchool's and primary's)
- Verify the new `.hermes-nightschool\` directory contents
- Write the Phase 1A Lane F note and status document
- Tell you what's next (Phase 1B scope — controlled bootstrap design)

---

## If Something Goes Wrong

**If the script blocks:** the output will say exactly why (`BLOCKED: Hermes is already running`, or a path mismatch). Paste the output to Claude.

**If Hermes opens but behaves strangely:** close it, paste any error messages to Claude, and don't do anything else in the window.

**Rollback is simple:** if anything looks wrong, just close the NightSchool Hermes window. You can then delete two folders to get back to a clean state:
- `C:\Users\larry\AppData\Roaming\Hermes-NightSchool\`
- `C:\Users\larry\.hermes-nightschool\`

Your primary Hermes is completely untouched either way.
