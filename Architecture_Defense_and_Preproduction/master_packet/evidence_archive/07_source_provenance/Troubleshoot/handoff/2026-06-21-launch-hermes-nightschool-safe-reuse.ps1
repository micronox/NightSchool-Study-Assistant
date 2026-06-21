# NightSchool Hermes launcher
# Approved Phase 1A draft:
# - separate desktop userData
# - separate NightSchool HERMES_HOME
# - reuse the existing Hermes agent code root
# - block if primary Hermes desktop is already running
# - avoid the fresh-bootstrap path

$ErrorActionPreference = "Stop"

$NightSchoolUserData = "C:\Users\larry\AppData\Roaming\Hermes-NightSchool"
$NightSchoolHome     = "C:\Users\larry\.hermes-nightschool"
$SharedHermesRoot    = "C:\Users\larry\.hermes\hermes-agent"
$HermesExe           = Join-Path $SharedHermesRoot "apps\desktop\release\win-unpacked\Hermes.exe"

$PrimaryUserData = "C:\Users\larry\AppData\Roaming\Hermes"
$PrimaryHome     = "C:\Users\larry\.hermes"

Write-Host "[NightSchool] Preparing sequential Hermes launch..."
Write-Host "  userData:   $NightSchoolUserData"
Write-Host "  home:       $NightSchoolHome"
Write-Host "  sharedRoot: $SharedHermesRoot"
Write-Host "  exe:        $HermesExe"

if (-not (Test-Path -LiteralPath $HermesExe)) {
    throw "[NightSchool] BLOCKED: Hermes.exe not found at $HermesExe"
}

if (-not (Test-Path -LiteralPath $SharedHermesRoot)) {
    throw "[NightSchool] BLOCKED: shared Hermes root not found at $SharedHermesRoot"
}

if ($NightSchoolUserData -eq $PrimaryUserData) {
    throw "[LANE F] BLOCKED: NightSchool userData matches primary Hermes userData."
}

if ($NightSchoolHome -eq $PrimaryHome) {
    throw "[LANE F] BLOCKED: NightSchool HERMES_HOME matches primary Hermes home."
}

$runningHermes = Get-Process -Name "Hermes" -ErrorAction SilentlyContinue
if ($runningHermes) {
    Write-Host ""
    Write-Host "[LANE F] BLOCKED: Hermes is already running."
    Write-Host "Close the primary Hermes desktop before launching the NightSchool lane."
    exit 1
}

New-Item -ItemType Directory -Force -Path $NightSchoolUserData | Out-Null
New-Item -ItemType Directory -Force -Path $NightSchoolHome | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $NightSchoolHome "logs") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $NightSchoolHome "sessions") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $NightSchoolHome "memories") | Out-Null

# Per-process env only. Do not persist anything user-wide here.
$env:HERMES_DESKTOP_USER_DATA_DIR = $NightSchoolUserData
$env:HERMES_HOME = $NightSchoolHome
$env:HERMES_DESKTOP_HERMES_ROOT = $SharedHermesRoot

# Avoid accidental inheritance of a remote override from some outer shell.
Remove-Item Env:HERMES_DESKTOP_REMOTE_URL -ErrorAction SilentlyContinue
Remove-Item Env:HERMES_DESKTOP_REMOTE_TOKEN -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "[NightSchool] Launching Hermes with isolated state and shared code root..."
Write-Host "[NightSchool] Important: do not use update/uninstall flows in this lane."

Start-Process -FilePath $HermesExe -WorkingDirectory (Split-Path -Parent $HermesExe)

Write-Host ""
Write-Host "[NightSchool] Launch started."
Write-Host "Post-launch checks:"
Write-Host "  1. Verify $NightSchoolUserData\\connection.json is NightSchool-scoped."
Write-Host "  2. Verify $PrimaryUserData\\connection.json is unchanged."
Write-Host "  3. Verify new logs/config land under $NightSchoolHome."
Write-Host "  4. Do not run updater/uninstall actions from this lane."
