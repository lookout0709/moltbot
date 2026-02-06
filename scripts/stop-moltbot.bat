@echo off
cd /d "C:\Users\looko\Desktop\mymolt\moltbot-main"
"C:\Program Files\nodejs\node.exe" dist\entry.js gateway stop
echo Moltbot gateway stopped.
pause
