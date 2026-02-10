# ============================================================
#   Start Both OpenClaw Bots (Main Claude + Zeabur DeepSeek)
#   PowerShell launcher for reliable environment isolation
# ============================================================

$ProjectRoot = "C:\Users\looko\Desktop\mymolt\moltbot-main"
$EnvFile = Join-Path $ProjectRoot ".env"

Set-Location $ProjectRoot

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Starting Both OpenClaw Bots" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# === STEP 0: Verify prerequisites ===
Write-Host "[Step 0] Verifying prerequisites..." -ForegroundColor Yellow

if (-not (Test-Path (Join-Path $ProjectRoot "dist\entry.js"))) {
    Write-Host "[ERROR] Project not built! Run 'pnpm build'" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Project is built" -ForegroundColor Green

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Node.js not found in PATH" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Node.js found" -ForegroundColor Green
Write-Host ""

# === STEP 1: Load .env for main bot ===
Write-Host "[Step 1] Loading .env for main bot..." -ForegroundColor Yellow
if (Test-Path $EnvFile) {
    Get-Content $EnvFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#")) {
            $eqIdx = $line.IndexOf("=")
            if ($eqIdx -gt 0) {
                $key = $line.Substring(0, $eqIdx).Trim()
                $val = $line.Substring($eqIdx + 1).Trim()
                [Environment]::SetEnvironmentVariable($key, $val, "Process")
            }
        }
    }
    Write-Host "[OK] .env loaded" -ForegroundColor Green
} else {
    Write-Host "[WARNING] .env not found" -ForegroundColor Yellow
}
Write-Host ""

# === STEP 2: Start Main Bot (Anthropic Claude) ===
Write-Host "[Step 2] Starting Main Bot (Anthropic API, port 18789)..." -ForegroundColor Yellow

$mainProc = Start-Process -FilePath "node" `
    -ArgumentList "--disable-warning=ExperimentalWarning","dist\entry.js","gateway" `
    -WorkingDirectory $ProjectRoot `
    -WindowStyle Hidden `
    -PassThru

Write-Host "[OK] Main bot started (PID: $($mainProc.Id))" -ForegroundColor Green

# Wait for main bot to initialize
Start-Sleep -Seconds 5
Write-Host ""

# === STEP 3: Start Zeabur Bot (DeepSeek V3.2) ===
Write-Host "[Step 3] Starting Zeabur Bot (DeepSeek V3.2, port 18791)..." -ForegroundColor Yellow

$env:OPENCLAW_STATE_DIR = "C:\Users\looko\.openclaw-third"
$env:AGENT_MODEL = "deepseek-v3.2"
$env:TELEGRAM_BOT_TOKEN = "8560148064:AAExBc-VjVNwtGV4m4U6I8HbFlS4FDW2dag"
# Clear any Ollama env vars
Remove-Item Env:\OLLAMA_API_KEY -ErrorAction SilentlyContinue
Remove-Item Env:\OLLAMA_HOST -ErrorAction SilentlyContinue

$zeaburProc = Start-Process -FilePath "node" `
    -ArgumentList "--disable-warning=ExperimentalWarning","dist\entry.js","gateway","--port","18791" `
    -WorkingDirectory $ProjectRoot `
    -WindowStyle Hidden `
    -PassThru

Write-Host "[OK] Zeabur bot started (PID: $($zeaburProc.Id))" -ForegroundColor Green
Write-Host ""

# === STARTUP COMPLETE ===
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  All Bots Started Successfully!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Main Bot:   PID=$($mainProc.Id)  Port=18789  Model=Claude Haiku 4.5" -ForegroundColor White
Write-Host "  Zeabur Bot: PID=$($zeaburProc.Id)  Port=18791  Model=DeepSeek V3.2 (Zeabur)" -ForegroundColor White
Write-Host ""
Write-Host "  To stop: scripts\stop-both-bots.bat" -ForegroundColor Yellow
Write-Host ""
