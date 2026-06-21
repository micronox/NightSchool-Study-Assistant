## Codex Handoff: Hermes Telegram / WhatsApp Setup

- Date: 2026-06-21
- Purpose: preserve the current working Hermes recovery state and the exact next step

### Current Known-Good State

- Hermes desktop app is working again on a cloud fallback path.
- Hermes dashboard at `http://127.0.0.1:9119` is working again.
- Both desktop and dashboard successfully replied in chat.
- The dashboard explicitly showed:
  - model: `anthropic/claude-sonnet-4.6`
  - provider: `openrouter`
- This means OpenRouter fallback is now functioning.

### Important Architecture Distinction

Keep these surfaces separate:

1. Hermes desktop app
2. Hermes dashboard / web UI on `9119`
3. Local custom-endpoint Qwen path
4. OpenRouter fallback path
5. Messaging gateway setup

Do not flatten them into one thing.

### Key Recovery Findings

#### 1. Earlier auth issue changed shape

We first saw `401 User not found` from OpenRouter.

Later, after correcting key placement and restarting desktop, OpenRouter-backed Sonnet began working again. That means:

- OpenRouter auth is now usable
- the previous rejected-key state is no longer the primary blocker

#### 2. Local Qwen failure is separate

The local/custom Qwen entry produced:

- `400`
- invalid model ID

This indicates a model-routing/custom-endpoint configuration issue, not a total Hermes failure.

Treat local Qwen repair as a separate follow-up after messaging works.

#### 3. Dashboard chat is not a shell

The user entered:

- `hermes gateway setup`

inside the dashboard chat UI.

That was interpreted as a model prompt, not as a shell command, and failed through the model path.

The correct place to run Hermes CLI commands is:

- a normal PowerShell window

### Files / Paths That Matter

- `$USER_HOME\.hermes\.env`
- `$USER_HOME\.hermes\config.yaml`
- `$APPDATA_ROAMING_ROOT\Hermes\connection.json`
- `$TROUBLESHOOT_ROOT\HERMES-MINIMAL-RESET-NOTES-2026-06-20.md`

### Connection / Config State

- Desktop connection mode had previously been forced back to `local`
- Do not reroute it back to remote mode
- Do not perform a broad reinstall or broad setup reset right now

### Messaging Setup Status

#### Telegram

- User says Telegram has already been set up with the BotFather token
- The next action was to continue gateway setup/testing from PowerShell

#### WhatsApp

User explored WhatsApp as a future secondary communication path.

Observed state:

- User has WhatsApp Business installed
- User also has Google Voice open
- In Hermes gateway setup, they selected:
  - `1. Separate bot number (Recommended)`
- The setup text explained options for a second number:
  - dual-SIM
  - Google Voice
  - prepaid SIM

Important guidance already given:

- Finish Telegram first before adding WhatsApp
- Then add WhatsApp as a separate secondary path
- Prefer a dedicated second number for WhatsApp Business
- Do not assume the Android/Google prompt alone proves Google Voice is fully usable for WhatsApp verification

### Exact Recommended Next Step

The next agent should continue from this point:

1. Keep OpenRouter/Sonnet fallback untouched because it is finally working
2. In the PowerShell window already being used for Hermes CLI, finish Telegram gateway setup
3. Run:
   - `hermes gateway run`
4. Have the user test the Telegram bot
5. Confirm Hermes replies through Telegram
6. Only after Telegram works, revisit WhatsApp Business as a second channel
7. Only after messaging is stable, repair the local Qwen custom-endpoint model entry

### What Not To Do Next

Do not:

- rerun broad `hermes setup` from scratch
- mix local Qwen repair into Telegram setup
- change the working OpenRouter/Sonnet fallback model path
- use the dashboard chat box as if it were a shell
- reintroduce remote-mode desktop routing

### Short Summary

Hermes is no longer “down.”

The cloud fallback path is working again in both desktop and dashboard. The immediate next win is to finish Telegram gateway setup and validate messaging from PowerShell. WhatsApp should be treated as a second-phase channel, and local Qwen custom-endpoint repair should stay separate from both.


