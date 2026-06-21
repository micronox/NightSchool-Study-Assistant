param(
    [switch]$Repair
)

$ErrorActionPreference = "Stop"

function Write-Status {
    param(
        [string]$Label,
        [string]$State,
        [string]$Detail = ""
    )

    $line = "{0,-22} {1,-10}" -f $Label, $State
    if ($Detail) {
        $line += " " + $Detail
    }
    Write-Output $line
}

function Get-TaskInfo {
    param([string]$TaskName)

    try {
        return Get-ScheduledTask -TaskName $TaskName -ErrorAction Stop
    } catch {
        return $null
    }
}

function Ensure-TaskRunning {
    param([string]$TaskName)

    $task = Get-TaskInfo -TaskName $TaskName
    if (-not $task) {
        return @{ Found = $false; State = "missing"; Detail = "" }
    }

    $state = [string]$task.State
    if ($Repair -and $state -ne "Running") {
        try {
            Start-ScheduledTask -TaskName $TaskName -ErrorAction Stop
            Start-Sleep -Seconds 2
            $task = Get-TaskInfo -TaskName $TaskName
            $state = [string]$task.State
        } catch {
            return @{ Found = $true; State = "error"; Detail = $_.Exception.Message }
        }
    }

    return @{ Found = $true; State = $state; Detail = "" }
}

$gateway = Ensure-TaskRunning -TaskName "Hermes_Gateway"
$wslDash = Ensure-TaskRunning -TaskName "WSLDashboardTask"

if (-not $gateway.Found) {
    Write-Status "Hermes Gateway Task" "MISSING"
} else {
    Write-Status "Hermes Gateway Task" $gateway.State.ToUpper() $gateway.Detail
}

if (-not $wslDash.Found) {
    Write-Status "WSLDashboard Task" "MISSING"
} else {
    Write-Status "WSLDashboard Task" $wslDash.State.ToUpper() $wslDash.Detail
}

$connectionPath = "`$APPDATA_ROAMING_ROOT\Hermes\connection.json"
if (Test-Path -LiteralPath $connectionPath) {
    try {
        $connection = Get-Content -LiteralPath $connectionPath -Raw | ConvertFrom-Json
        Write-Status "Desktop Mode" $connection.mode.ToUpper()
    } catch {
        Write-Status "Desktop Mode" "ERROR" $_.Exception.Message
    }
} else {
    Write-Status "Desktop Mode" "MISSING" $connectionPath
}

$gatewayStatePath = "`$USER_HOME\.hermes\gateway_state.json"
if (Test-Path -LiteralPath $gatewayStatePath) {
    try {
        $gatewayState = Get-Content -LiteralPath $gatewayStatePath -Raw | ConvertFrom-Json
        $platforms = @()
        if ($gatewayState.platforms.telegram) {
            $platforms += "telegram=" + $gatewayState.platforms.telegram.state
        }
        if ($gatewayState.platforms.whatsapp) {
            $platforms += "whatsapp=" + $gatewayState.platforms.whatsapp.state
        }
        Write-Status "Gateway State" $gatewayState.gateway_state.ToUpper() ($platforms -join ", ")
    } catch {
        Write-Status "Gateway State" "ERROR" $_.Exception.Message
    }
}

try {
    $port9119 = Get-NetTCPConnection -LocalPort 9119 -State Listen -ErrorAction Stop
    if ($port9119) {
        Write-Status "Dashboard Port 9119" "LISTENING"
    }
} catch {
    Write-Status "Dashboard Port 9119" "DOWN"
}

$ollamaProc = Get-Process | Where-Object { $_.ProcessName -like "*ollama*" } | Select-Object -First 1
if ($ollamaProc) {
    Write-Status "Ollama Process" "RUNNING" $ollamaProc.ProcessName
} else {
    Write-Status "Ollama Process" "DOWN"
}

Write-Output ""
if ($Repair) {
    Write-Output "Repair mode attempted to start any missing Scheduled Tasks."
} else {
    Write-Output "Tip: run with -Repair to start Hermes/WSLDashboard tasks if they are not running."
}

