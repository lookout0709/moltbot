$env:OPENCLAW_STATE_DIR = "C:\Users\looko\.openclaw-third"
$env:TELEGRAM_BOT_TOKEN = "8560148064:AAExBc-VjVNwtGV4m4U6I8HbFlS4FDW2dag"
$env:AGENT_MODEL = "deepseek-v3.2"
Set-Location "C:\Users\looko\Desktop\mymolt\moltbot-main"
node dist/entry.js gateway --port 18791
