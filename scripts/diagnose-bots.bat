@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM   Diagnostic Tool for OpenClaw Bots (Main + Zeabur)
REM ============================================================

echo.
echo ============================================
echo   OpenClaw Bots - Diagnostic Report
echo ============================================
echo.

echo [1] Checking Node.js Installation
echo ======================================
"C:\Program Files\nodejs\node.exe" --version || echo [ERROR] Node.js not found
echo.

echo [2] Checking Project Build Status
echo ======================================
if exist "dist\entry.js" (
    echo [OK] Project is built (dist\entry.js exists)
) else (
    echo [ERROR] Project not built - run 'pnpm build'
)
echo.

echo [3] Checking Node.js Gateway Processes
echo =======================================
tasklist /V /FI "IMAGENAME eq node.exe" 2>NUL | find "node.exe" && echo [OK] Node.js processes found || echo [ERROR] No Node.js processes running
echo.

echo [4] Testing Gateway Ports
echo =========================
echo Testing Port 18789 (Main Bot - Claude Haiku 4.5):
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://127.0.0.1:18789' -TimeoutSec 2 -ErrorAction SilentlyContinue; Write-Host '  [OK] Port 18789 is responding (' $response.StatusCode ')' } catch { Write-Host '  [ERROR] Port 18789 not responding' }"

echo Testing Port 18791 (Zeabur Bot - DeepSeek V3.2):
powershell -Command "try { $response = Invoke-WebRequest -Uri 'http://127.0.0.1:18791' -TimeoutSec 2 -ErrorAction SilentlyContinue; Write-Host '  [OK] Port 18791 is responding (' $response.StatusCode ')' } catch { Write-Host '  [ERROR] Port 18791 not responding' }"
echo.

echo [5] Checking State Directories
echo ===============================
if exist "%USERPROFILE%\.openclaw" (
    echo [OK] Main state directory exists: %USERPROFILE%\.openclaw
) else (
    echo [WARNING] Main state directory not found
)
echo.

if exist "%USERPROFILE%\.openclaw-third" (
    echo [OK] Zeabur state directory exists: %USERPROFILE%\.openclaw-third
) else (
    echo [WARNING] Zeabur state directory not found
)
echo.

echo [6] Checking Configuration Files
echo =================================
echo .env file:
if exist ".env" (
    echo [OK] .env exists
) else (
    echo [ERROR] .env not found
)
echo.

echo [7] Checking Zeabur Bot Config
echo =============================
set ZEABUR_CONFIG=%USERPROFILE%\.openclaw-third\openclaw.json
if exist "!ZEABUR_CONFIG!" (
    echo [OK] Zeabur config found: !ZEABUR_CONFIG!
) else (
    echo [WARNING] Zeabur config not found
)
echo.

echo ============================================
echo   Diagnostic Report Complete
echo ============================================
echo.
echo NEXT STEPS:
echo  1. If ports aren't responding, the gateways may still be initializing
echo  2. Wait 30-60 seconds after starting, then run this diagnostic again
echo  3. Check Windows Event Viewer for any error logs
echo.

pause
