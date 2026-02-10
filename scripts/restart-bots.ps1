# Restart both bots
Write-Host "=== Stopping existing bots ===" -ForegroundColor Yellow

$nodes = Get-Process -Name node -ErrorAction SilentlyContinue
foreach ($n in $nodes) {
    $wmi = Get-CimInstance Win32_Process -Filter "ProcessId=$($n.Id)" -ErrorAction SilentlyContinue
    if ($wmi.CommandLine -match "entry\.js.*gateway") {
        Write-Host "  Stopping PID $($n.Id)" -ForegroundColor Red
        Stop-Process -Id $n.Id -Force
    }
}

Start-Sleep -Seconds 3

Write-Host ""
Write-Host "=== Starting both bots ===" -ForegroundColor Green

# Run the PowerShell launcher directly
& "C:\Users\looko\Desktop\mymolt\moltbot-main\scripts\start-both-bots.ps1"

Write-Host ""
Write-Host "Waiting 15 seconds for bots to fully initialize..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Check results
Write-Host ""
Write-Host "=== Final Status ===" -ForegroundColor Cyan
$nodes = Get-Process -Name node -ErrorAction SilentlyContinue
$found = 0
foreach ($n in $nodes) {
    $wmi = Get-CimInstance Win32_Process -Filter "ProcessId=$($n.Id)" -ErrorAction SilentlyContinue
    if ($wmi.CommandLine -match "entry\.js.*gateway") {
        $found++
        $conn = Get-NetTCPConnection -OwningProcess $n.Id -State Listen -ErrorAction SilentlyContinue
        $ports = ($conn | Select-Object -ExpandProperty LocalPort | Sort-Object -Unique) -join ","
        Write-Host "  Bot #$found PID=$($n.Id) ListenPorts=$ports" -ForegroundColor Green
    }
}

if ($found -lt 2) {
    Write-Host "  WARNING: Only $found bot(s) running (expected 2: Main + Zeabur)" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "  SUCCESS: $found bots running (Main + Zeabur)!" -ForegroundColor Green
}
