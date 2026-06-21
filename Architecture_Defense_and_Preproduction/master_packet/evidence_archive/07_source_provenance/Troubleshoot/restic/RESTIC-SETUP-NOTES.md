# Restic Setup Notes

## Goal

Versioned local backups for:

- `$USER_HOME`
- `L:\`

## What This Gives You

`restic` stores point-in-time snapshots. Each run creates a new snapshot, so you can restore older versions of files later.

Think of it as:

- backup history for documents and working files
- not a replacement for Git inside code repos

## Recommended Layout

Keep the backup repository on a drive that is not one of the source roots.

Good candidates from the current machine:

- `E:\`
- `F:\`
- `G:\`
- `K:\`

Avoid placing the restic repository inside:

- `$USER_HOME`
- `L:\`

because those are backup sources.

## Example Repository Path

```powershell
G:\Backups\restic-operator
```

## Password File

You can let restic prompt for a password, or keep one in a file.

Example:

```powershell
New-Item -ItemType Directory -Force -Path G:\Backups\Secrets | Out-Null
Set-Content -LiteralPath G:\Backups\Secrets\restic-operator-password.txt -Value 'choose-a-long-unique-passphrase'
```

## First-Time Initialize + Backup

```powershell
cd `$TROUBLESHOOT_ROOT\restic
.\Invoke-ResticBackup.ps1 `
  -RepositoryPath 'G:\Backups\restic-operator' `
  -PasswordFile 'G:\Backups\Secrets\restic-operator-password.txt' `
  -InitializeIfMissing
```

## Later Backup Runs

```powershell
cd `$TROUBLESHOOT_ROOT\restic
.\Invoke-ResticBackup.ps1 `
  -RepositoryPath 'G:\Backups\restic-operator' `
  -PasswordFile 'G:\Backups\Secrets\restic-operator-password.txt'
```

## Retention / Pruning

This keeps:

- last 10 snapshots
- 14 daily
- 8 weekly
- 12 monthly

```powershell
cd `$TROUBLESHOOT_ROOT\restic
.\Invoke-ResticRetention.ps1 `
  -RepositoryPath 'G:\Backups\restic-operator' `
  -PasswordFile 'G:\Backups\Secrets\restic-operator-password.txt'
```

## What The Exclude List Does

The backup includes your real files, but skips common temp and cache folders such as:

- `Temp`
- `node_modules`
- Python cache directories
- local virtual environments

That keeps the repository smaller and avoids wasting snapshots on disposable build artifacts.


