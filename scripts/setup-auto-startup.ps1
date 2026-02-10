# ============================================================
# Setup Auto-Start and Auto-Stop for OpenClaw Bots
# This script configures Windows Task Scheduler to:
# 1. Start both bots on user logon (so env vars are available)
# 2. Stop both bots on user logoff
#
# USAGE: Run as Administrator
#   powershell -ExecutionPolicy Bypass -File setup-auto-startup.ps1
# ============================================================

param(
    [switch]$Remove = $false
)

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    exit 1
}

$ProjectRoot = "C:\Users\looko\Desktop\mymolt\moltbot-main"
$StartVbsScript = "$ProjectRoot\scripts\start-both-bots-background.vbs"
$StartBatchScript = "$ProjectRoot\scripts\start-both-bots.bat"
$StopScript = "$ProjectRoot\scripts\stop-both-bots.bat"
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "OpenClaw Bots - Auto-Startup Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[INFO] Current User: $CurrentUser" -ForegroundColor Green

# Verify scripts exist
$missingScripts = @()
if (-not (Test-Path $StartVbsScript)) { $missingScripts += "VBS: $StartVbsScript" }
if (-not (Test-Path $StartBatchScript)) { $missingScripts += "Batch: $StartBatchScript" }
if (-not (Test-Path $StopScript)) { $missingScripts += "Stop: $StopScript" }

if ($missingScripts.Count -gt 0) {
    Write-Host "ERROR: Missing scripts:" -ForegroundColor Red
    foreach ($s in $missingScripts) {
        Write-Host "  - $s" -ForegroundColor Red
    }
    exit 1
}

Write-Host "[OK] All scripts found" -ForegroundColor Green
Write-Host ""

if ($Remove) {
    Write-Host "[INFO] Removing scheduled tasks..." -ForegroundColor Yellow
    Write-Host ""

    try {
        Unregister-ScheduledTask -TaskName "OpenClawBotsStartup" -Confirm:$false -ErrorAction SilentlyContinue
        Write-Host "[OK] Removed startup task" -ForegroundColor Green
    } catch {
        Write-Host "[WARNING] Could not remove startup task: $_" -ForegroundColor Yellow
    }

    try {
        Unregister-ScheduledTask -TaskName "OpenClawBotsShutdown" -Confirm:$false -ErrorAction SilentlyContinue
        Write-Host "[OK] Removed shutdown task" -ForegroundColor Green
    } catch {
        Write-Host "[WARNING] Could not remove shutdown task: $_" -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "[OK] Auto-startup removed successfully!" -ForegroundColor Green
    exit 0
}

# === CREATE STARTUP TASK ===
Write-Host "[STEP 1] Creating Startup Task..." -ForegroundColor Cyan
Write-Host ""

try {
    # Use wscript to run the VBS launcher (hidden window)
    $action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$StartVbsScript`""

    # Trigger on user logon (not AtStartup with SYSTEM) so user env vars are available
    $trigger = New-ScheduledTaskTrigger -AtLogon -User $CurrentUser

    # Run as current user (not SYSTEM) to access user env, .env file, and home directory
    $principal = New-ScheduledTaskPrincipal -UserId $CurrentUser -LogonType Interactive -RunLevel Limited

    $settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -StartWhenAvailable `
        -ExecutionTimeLimit (New-TimeSpan -Hours 0)

    # Add a 30-second delay to ensure network is ready
    $trigger.Delay = "PT30S"

    Register-ScheduledTask -TaskName "OpenClawBotsStartup" `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Settings $settings `
        -Description "Start both OpenClaw bots (Main Claude + Zeabur DeepSeek) on user logon" `
        -Force | Out-Null

    Write-Host "[OK] Startup task created successfully" -ForegroundColor Green
    Write-Host "     Task Name: OpenClawBotsStartup" -ForegroundColor Green
    Write-Host "     Trigger: At user logon ($CurrentUser)" -ForegroundColor Green
    Write-Host "     Delay: 30 seconds (wait for network)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "[ERROR] Failed to create startup task: $_" -ForegroundColor Red
    exit 1
}

# === CREATE SHUTDOWN TASK ===
Write-Host "[STEP 2] Creating Shutdown Task..." -ForegroundColor Cyan
Write-Host ""

try {
    $action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$StopScript`""

    # Use event-based trigger for shutdown/logoff
    # Event ID 7002 = User Logoff notification from Winlogon
    $CIMTriggerClass = Get-CimClass -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler
    $trigger = New-CimInstance -CimClass $CIMTriggerClass -ClientOnly
    $trigger.Subscription = @"
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[Provider[@Name='Microsoft-Windows-Winlogon'] and EventID=7002]]</Select>
  </Query>
</QueryList>
"@
    $trigger.Enabled = $true

    $principal = New-ScheduledTaskPrincipal -UserId $CurrentUser -LogonType Interactive -RunLevel Limited

    $settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries

    Register-ScheduledTask -TaskName "OpenClawBotsShutdown" `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Settings $settings `
        -Description "Stop both OpenClaw bots on user logoff/shutdown" `
        -Force | Out-Null

    Write-Host "[OK] Shutdown task created successfully" -ForegroundColor Green
    Write-Host "     Task Name: OpenClawBotsShutdown" -ForegroundColor Green
    Write-Host "     Trigger: On user logoff (Event ID 7002)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "[WARNING] Could not create event-based shutdown task: $_" -ForegroundColor Yellow
    Write-Host "[INFO] Bots will be stopped when you close their windows or run stop-both-bots.bat" -ForegroundColor Yellow
    Write-Host ""
}

# === DISPLAY SUMMARY ===
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Both bots will start automatically when $CurrentUser logs in" -ForegroundColor Green
Write-Host "Both bots will stop automatically on logoff/shutdown" -ForegroundColor Green
Write-Host ""
Write-Host "To verify:" -ForegroundColor Yellow
Write-Host "  1. Open Task Scheduler (taskschd.msc)" -ForegroundColor Yellow
Write-Host "  2. Look for 'OpenClawBotsStartup' and 'OpenClawBotsShutdown'" -ForegroundColor Yellow
Write-Host ""
Write-Host "To test startup now:" -ForegroundColor Yellow
Write-Host "  schtasks /run /tn OpenClawBotsStartup" -ForegroundColor Yellow
Write-Host ""
Write-Host "To remove auto-startup:" -ForegroundColor Yellow
Write-Host "  powershell -ExecutionPolicy Bypass -File setup-auto-startup.ps1 -Remove" -ForegroundColor Yellow
Write-Host ""

exit 0
