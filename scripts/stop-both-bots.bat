@echo off
setlocal enabledelayedexpansion

cd /d "C:\Users\looko\Desktop\mymolt\moltbot-main"

REM ============================================================
REM   Stop Both OpenClaw Bots
REM   Called during system shutdown
REM ============================================================

echo.
echo ============================================
echo   Stopping Both OpenClaw Bots
echo ============================================
echo.

REM Stop both gateway instances
echo [INFO] Stopping gateways...

REM Try to gracefully stop via CLI
"C:\Program Files\nodejs\node.exe" dist\entry.js gateway stop 2>nul

REM Wait a bit for graceful shutdown
timeout /t 2 /nobreak >nul

REM Force kill any remaining node processes (moltbot/openclaw)
echo [INFO] Ensuring all bot processes are stopped...
taskkill /FI "IMAGENAME eq node.exe" /F 2>nul

echo.
echo ============================================
echo   Both bots stopped successfully!
echo ============================================
echo.

exit /b 0
