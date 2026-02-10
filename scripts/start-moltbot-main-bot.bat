@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM   Start Main OpenClaw Bot (Anthropic API - Claude Haiku)
REM   Default Port
REM ============================================================

cd /d "C:\Users\looko\Desktop\mymolt\moltbot-main"

echo.
echo ============================================
echo   Starting Main OpenClaw Bot
echo   (Anthropic API + Claude Haiku)
echo ============================================
echo.

REM Load environment from .env
echo [Config] Loading environment from .env...
for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
    if not "%%a"=="" (
        set "%%a=%%b"
    )
)

echo   Model           : !AGENT_MODEL!
echo   Gateway Port    : Default (usually 18789)
echo.

echo [Step 1] Verifying Node.js and project build...
if not exist "dist\entry.js" (
    echo [ERROR] Project not built! Run 'pnpm build' first
    pause
    exit /b 1
)
echo [OK] Project is built

echo [Step 2] Starting OpenClaw Gateway...
echo.
echo [INFO] Gateway is starting... (this will run in foreground)
echo [INFO] Press Ctrl+C to stop the gateway
echo.

"C:\Program Files\nodejs\node.exe" dist\entry.js gateway

REM If we reach here, gateway stopped
echo.
echo [INFO] Gateway has stopped
pause
exit /b 0
