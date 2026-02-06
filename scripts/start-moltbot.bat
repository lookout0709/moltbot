@echo off
cd /d "C:\Users\looko\Desktop\mymolt\moltbot-main"

REM Load .env file
for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
    set "%%a=%%b"
)

REM Start gateway (config already exists)
"C:\Program Files\nodejs\node.exe" dist\entry.js gateway
