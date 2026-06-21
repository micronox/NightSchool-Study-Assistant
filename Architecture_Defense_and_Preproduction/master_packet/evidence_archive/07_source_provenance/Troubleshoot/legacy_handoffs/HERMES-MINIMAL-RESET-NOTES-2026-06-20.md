## Hermes Minimal Reset Notes

- Date: 2026-06-20
- Goal: re-establish Hermes without changing the current local runtime shape

### Confirmed State

- Hermes desktop connection mode is `local`
- Hermes dashboard port `9119` is live
- Hermes desktop can boot a local backend
- Current failure is credential/provider state, not total startup failure

### What We Should Preserve

- Do not reroute Hermes desktop back to remote mode
- Do not redesign ports
- Do not do a broad reinstall first
- Do not flatten dashboard, desktop, and gateway into one surface

### Minimal Reset Path

1. Re-establish provider auth cleanly
2. Re-establish Telegram gateway setup
3. Validate desktop, dashboard, and gateway behavior
4. Only then decide whether any startup automation is needed

### Known Config Paths

- `C:\Users\larry\.hermes\config.yaml`
- `C:\Users\larry\.hermes\.env`
- `C:\Users\larry\AppData\Roaming\Hermes\connection.json`
- `C:\Users\larry\.hermes\auth.json`

### Important Current Finding

- The expected API key variables are not currently present in the active Hermes `.env` files we checked, so auth should be re-established through Hermes setup/auth flow rather than by trusting prior text-file edits.
