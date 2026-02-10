@echo off
REM ============================================================
REM   Start Both OpenClaw Bots (Main + Local Ollama)
REM   Delegates to PowerShell for reliable env var handling
REM ============================================================

cd /d "C:\Users\looko\Desktop\mymolt\moltbot-main"

echo.
echo ============================================
echo   Starting Both OpenClaw Bots
echo ============================================
echo.

if not exist "dist\entry.js" (
    echo [ERROR] Project not built! Please run 'pnpm build'
    pause
    exit /b 1
)

powershell -ExecutionPolicy Bypass -File "C:\Users\looko\Desktop\mymolt\moltbot-main\scripts\start-both-bots.ps1"

exit /b %ERRORLEVEL%
