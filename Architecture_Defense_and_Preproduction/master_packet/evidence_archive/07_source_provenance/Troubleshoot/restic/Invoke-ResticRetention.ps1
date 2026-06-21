param(
    [Parameter(Mandatory = $true)]
    [string]$RepositoryPath,

    [string]$PasswordFile,

    [int]$KeepLast = 10,
    [int]$KeepDaily = 14,
    [int]$KeepWeekly = 8,
    [int]$KeepMonthly = 12
)

$ErrorActionPreference = 'Stop'

$cmd = Get-Command restic -ErrorAction SilentlyContinue
if (-not $cmd) {
    throw "restic is not installed or not on PATH. Install restic first, then rerun this script."
}

if (-not (Test-Path -LiteralPath $RepositoryPath)) {
    throw "Repository path does not exist: $RepositoryPath"
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

$args = @(
    'forget',
    '--prune',
    '--keep-last', $KeepLast,
    '--keep-daily', $KeepDaily,
    '--keep-weekly', $KeepWeekly,
    '--keep-monthly', $KeepMonthly
)

& $cmd.Source @args
if ($LASTEXITCODE -ne 0) {
    throw "restic retention/prune failed with exit code $LASTEXITCODE"
}
