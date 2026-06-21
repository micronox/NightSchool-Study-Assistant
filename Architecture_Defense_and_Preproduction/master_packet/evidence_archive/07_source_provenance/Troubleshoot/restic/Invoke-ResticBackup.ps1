param(
    [Parameter(Mandatory = $true)]
    [string]$RepositoryPath,

    [string]$PasswordFile,

    [switch]$InitializeIfMissing,

    [string[]]$Sources = @(
        '`$USER_HOME',
        'L:\'
    )
)

$ErrorActionPreference = 'Stop'

function Get-ResticCommand {
    $cmd = Get-Command restic -ErrorAction SilentlyContinue
    if (-not $cmd) {
        throw "restic is not installed or not on PATH. Install restic first, then rerun this script."
    }

    return $cmd.Source
}

function Invoke-Restic {
    param(
        [string[]]$Arguments
    )

    $restic = Get-ResticCommand
    & $restic @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "restic failed with exit code $LASTEXITCODE"
    }
}

function Test-ResticRepositoryInitialized {
    param(
        [string]$Path
    )

    return Test-Path -LiteralPath (Join-Path $Path 'config')
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$excludeFile = Join-Path $scriptDir 'restic-excludes.txt'

if (-not (Test-Path -LiteralPath $excludeFile)) {
    throw "Exclude file not found: $excludeFile"
}

foreach ($source in $Sources) {
    if (-not (Test-Path -LiteralPath $source)) {
        throw "Backup source does not exist: $source"
    }
}

if (-not (Test-Path -LiteralPath $RepositoryPath)) {
    New-Item -ItemType Directory -Path $RepositoryPath -Force | Out-Null
}

$env:RESTIC_REPOSITORY = $RepositoryPath

if ($PasswordFile) {
    if (-not (Test-Path -LiteralPath $PasswordFile)) {
        throw "Password file does not exist: $PasswordFile"
    }

    $env:RESTIC_PASSWORD_FILE = $PasswordFile
} else {
    Remove-Item Env:RESTIC_PASSWORD_FILE -ErrorAction SilentlyContinue
}

if ($InitializeIfMissing -and -not (Test-ResticRepositoryInitialized -Path $RepositoryPath)) {
    Write-Host "Initializing restic repository at $RepositoryPath..." -ForegroundColor Cyan
    Invoke-Restic -Arguments @('init')
}

$timestamp = Get-Date -Format 'yyyy-MM-dd-HHmmss'
$hostTag = "host:$env:COMPUTERNAME"
$backupArgs = @(
    'backup'
    '--exclude-file', $excludeFile
    '--tag', 'scope:operator'
    '--tag', 'scope:l-drive'
    '--tag', $hostTag
    '--tag', "run:$timestamp"
)

$backupArgs += $Sources

Write-Host "Starting restic backup..." -ForegroundColor Cyan
Write-Host "Repository: $RepositoryPath"
Write-Host "Sources: $($Sources -join ', ')"
Invoke-Restic -Arguments $backupArgs

Write-Host ""
Write-Host "Current snapshots:" -ForegroundColor Cyan
Invoke-Restic -Arguments @('snapshots')

