# Phase 0 Verification Note
**Date:** 2026-06-21
**Session:** Claude (Cowork) + Desktop Commander (WSL execution)
**Lane:** F (Architecture Defense) + A (Infra)
**Status:** PASS — all required Phase 0 items complete

---

## 1. .tools/ cleanup
Command run: `rm -rf .tools/` (executed by operator in WSL terminal)
Confirmed via Desktop Commander list_directory: `.tools/` absent from Prototype_workingFiles ✓

---

## 2. WSL mount path
Command run: `mount | grep WSL_Projects`
Output:
```
L:\ on /mnt/l type 9p (rw,noatime,aname=drvfs;path=L:\;uid=1000;gid=1000;symlinkroot=/mnt/,cache=5,access=client,msize=65536,trans=fd,rfd=6,wfd=6)
```
**Confirmed WSL path:** `/mnt/l/WSL_Projects_Folder/Nightschool_Study/`
NightSchool Prototype_workingFiles accessible at: `/mnt/l/WSL_Projects_Folder/Nightschool_Study/Prototype_workingFiles/`

---

## 3. Primary Hermes install baseline (read-only)
Method: WSL filesystem inspection via Desktop Commander — no modifications made.

| Item | Value |
|---|---|
| App name | Hermes Desktop |
| Version | 0.5.6 (installer: `hermes-desktop-0.5.6-setup.exe`) |
| Config root | `$APPDATA_ROAMING_ROOT\Hermes\` |
| Connection file | `$APPDATA_ROAMING_ROOT\Hermes\connection.json` |
| Connection mode | `local` |
| Local endpoint | `http://localhost:9119` (auth: oauth) |
| Updater location | `$APPDATA_LOCAL_ROOT\hermes-desktop-updater\` |
| Setup cache | `$APPDATA_LOCAL_ROOT\com.nousresearch.hermes.setup\` |
| WSL PATH | Not in WSL PATH (Windows desktop app, not a WSL binary) |

**connection.json contents (verbatim):**
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

Read-only confirmed — no modifications made: ✓

**Lane F baseline recorded:** NightSchool must not write to `$APPDATA_ROAMING_ROOT\Hermes\` or share the port 9119 endpoint. Any NightSchool config that points to port 9119 is a cross-contamination flag.

---

## 4. Ollama + qwen3.6:35b-a3b reachability
Command: `curl -s http://localhost:11434/api/tags`

Models present:
```
qwen3.6:35b-a3b  (23.9 GB)
```

Test call:
```
POST http://localhost:11434/api/generate
{"model":"qwen3.6:35b-a3b","prompt":"Reply with only the word: ok","stream":false}
```
Response: `'ok'`
Done: `True`
Model confirmed: `qwen3.6:35b-a3b`

**Result: PASS** — Ollama live on `0.0.0.0:11434`, model responds correctly.

Note: The PRD and pre-pass notes refer to `qwen3.6:latest` — the actual pulled model is `qwen3.6:35b-a3b`. Update PRD references accordingly (see Phase 0 PRD update card below).

---

## 5. Port audit
Command: `ss -tlnp | grep LISTEN`

Currently bound:
| Port | Service |
|---|---|
| 53 | DNS (system) |
| 3000 | Occupied (unknown service) |
| 9000 | Occupied (unknown service) |
| 9119 | Primary Hermes local endpoint — **must not be used by NightSchool** |
| 11434 | Ollama — shared (NightSchool reads, does not own) |

**Proposed NightSchool port range: 8100–8199**
- 8100: NightSchool Mission Control dashboard (primary)
- 8101: Reserved (API/backend if split from frontend)
- 8102–8199: Reserved for future NightSchool services

Rationale: 8100–8199 is clear of all detected services, far from Ollama (11434), Hermes (9119), and the occupied 3000/9000. Standard dev tooling rarely lands here.

---

## 6. handoffs/ folder
Status: Already present from pre-pass setup. Confirmed in directory listing. ✓

---

## 7. Lane F skeleton
- `isolation_manifest.md`: Present at `Prototype_workingFiles/isolation_manifest.md` ✓
- `DEPENDENCIES.md`: Present at `Prototype_workingFiles/DEPENDENCIES.md` ✓
- Both populated with pre-pass scaffold; Phase 0 evidence sections updated below.

---

## Decision gate status
- [x] WSL mount path confirmed — `/mnt/l/`
- [x] Primary Hermes baseline documented — read-only, no modifications
- [x] Ollama + qwen3.6:35b-a3b confirmed live and responding
- [x] Port range proposed — 8100–8199 (no conflicts detected)
- [x] handoffs/ folder present
- [x] Lane F skeleton files present and populated
- [x] .tools/ cleanup confirmed

**Phase 0 evidence complete — SAFE TO PROCEED TO PHASE 1**

One PRD update required before Phase 1 opens: correct `qwen3.6:latest` references to `qwen3.6:35b-a3b` throughout.


