@echo off
REM ============================================================
REM   Setup Auto-Start for OpenClaw Bots (Administrator Wrapper)
REM   This script runs the PowerShell setup script with proper permissions
REM ============================================================

setlocal enabledelayedexpansion

REM Check for /remove parameter
if "%1"=="/remove" (
    powershell -ExecutionPolicy Bypass -File "%~dp0setup-auto-startup.ps1" -Remove
) else (
    powershell -ExecutionPolicy Bypass -File "%~dp0setup-auto-startup.ps1"
)

pause
