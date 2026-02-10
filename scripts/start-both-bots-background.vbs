' ============================================================
' Start Both OpenClaw Bots in Background (VBScript)
' This script is used by Windows Task Scheduler to start both bots
' (Main Claude + Zeabur DeepSeek) without showing console windows
' ============================================================

Dim WshShell

Set WshShell = CreateObject("WScript.Shell")

' Change to project directory
WshShell.CurrentDirectory = "C:\Users\looko\Desktop\mymolt\moltbot-main"

' Start via PowerShell for reliable env var handling
WshShell.Run "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File ""C:\Users\looko\Desktop\mymolt\moltbot-main\scripts\start-both-bots.ps1""", 0, False

' Cleanup
Set WshShell = Nothing
