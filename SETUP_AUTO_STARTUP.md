# 🤖 OpenClaw 機器人自動啟動設置指南

本文檔說明如何設置兩個 OpenClaw 機器人（主要機器人 + 本地 Ollama 機器人）在系統啟動時自動運行，並在關機時自動停止。

## 📋 設置概述

此設置將配置 Windows 任務計劃程式，使得：

- ✅ **系統啟動時**：自動啟動主要機器人（使用 Claude Haiku）和本地機器人（使用 Ollama）
- ✅ **系統關機/用戶登出時**：自動停止兩個機器人

## 🚀 快速開始

### 第一步：驗證前置條件

確保您已經：

1. ✓ 安裝了 Node.js（版本 22+）
2. ✓ 安裝了 Ollama（用於本地機器人）
3. ✓ 已運行過 `pnpm install` 並構建了項目（`pnpm build`）
4. ✓ 配置好了 `.env` 文件（包含 Anthropic API 金鑰等）

### 第二步：執行設置腳本

**⚠️ 重要：需要以管理員身份運行**

#### 方式 1：使用 CMD 啟動器（推薦）

```bash
# 在命令提示符中運行（以管理員身份）
scripts\setup-auto-startup.cmd
```

#### 方式 2：使用 PowerShell（直接運行）

```powershell
# 在 PowerShell 中運行（以管理員身份）
powershell -ExecutionPolicy Bypass -File scripts\setup-auto-startup.ps1
```

### 第三步：驗證設置

1. 打開 **任務計劃程式**（Task Scheduler）
2. 查找以下兩個任務：
   - `OpenClawBotsStartup` - 在系統啟動時運行
   - `OpenClawBotsShutdown` - 在用戶登出/系統關機時運行

## 📂 所涉及的文件

| 文件                             | 用途     | 描述                                            |
| -------------------------------- | -------- | ----------------------------------------------- |
| `scripts/start-both-bots.bat`    | 啟動腳本 | 啟動兩個 OpenClaw 網關（主機器人 + 本地機器人） |
| `scripts/stop-both-bots.bat`     | 停止腳本 | 停止兩個 OpenClaw 網關                          |
| `scripts/setup-auto-startup.ps1` | 設置腳本 | PowerShell 腳本，用於配置 Windows 任務計劃程式  |
| `scripts/setup-auto-startup.cmd` | 啟動器   | CMD 啟動器，以管理員身份運行 PowerShell 腳本    |

## 🔧 手動測試

您可以在無需等待系統啟動的情況下測試這些腳本：

### 啟動兩個機器人

```bash
scripts\start-both-bots.bat
```

### 停止兩個機器人

```bash
scripts\stop-both-bots.bat
```

## 🗑️ 移除自動啟動

如果您想禁用自動啟動功能，請以管理員身份運行：

```bash
# 方式 1：使用 CMD 啟動器
scripts\setup-auto-startup.cmd /remove

# 方式 2：使用 PowerShell
powershell -ExecutionPolicy Bypass -File scripts\setup-auto-startup.ps1 -Remove
```

這將從 Windows 任務計劃程式中移除兩個計劃任務。

## 📊 兩個機器人的詳細信息

### 機器人 1：主要機器人（Anthropic API）

- **模型**：Claude Haiku 4.5
- **Provider**：Anthropic API
- **配置**：使用 `.env` 文件中的 `ANTHROPIC_API_KEY`
- **端口**：默認端口（通常是 18789）
- **狀態目錄**：`~/.openclaw`

### 機器人 2：本地機器人（Ollama）

- **模型**：Llama 3.2-3B（通過 Ollama）
- **Provider**：Ollama（本地）
- **配置**：獨立的狀態目錄
- **端口**：18790
- **狀態目錄**：`~/.openclaw-local`
- **依賴**：Ollama 必須在 http://127.0.0.1:11434

## ⚙️ 疑難排解

### 問題 1：權限被拒絕

**症狀**：看到 "Access Denied" 或"拒絕訪問"錯誤

**解決方案**：

- 確保使用**管理員身份**運行腳本
- 右鍵點擊命令提示符，選擇"以管理員身份運行"

### 問題 2：Ollama 未啟動

**症狀**：本地機器人無法啟動

**解決方案**：

- 檢查 Ollama 是否已安裝：`ollama --version`
- 手動啟動 Ollama：`ollama serve`
- 確保 llama3.2-local 模型已創建：`ollama list`

### 問題 3：任務沒有執行

**症狀**：系統啟動後機器人沒有自動啟動

**解決方案**：

- 檢查 Node.js 路徑是否正確（應該是 `C:\Program Files\nodejs\node.exe`）
- 檢查項目路徑是否正確
- 在任務計劃程式中檢查任務的"最後執行結果"以獲取詳細錯誤信息

### 問題 4：無法訪問機器人

**症狀**：啟動後無法連接到機器人

**解決方案**：

- 等待 30 秒讓 Ollama 初始化
- 檢查防火牆設置，確保允許 Node.js 進程
- 手動運行 `scripts\start-both-bots.bat` 進行測試

## 🔍 日誌位置

根據您的設置，日誌通常位於：

- 任務計劃程式日誌：`%SystemRoot%\System32\winevt\Logs\`
- OpenClaw 日誌：取決於 `.openclaw` 配置
- Ollama 日誌：`%APPDATA%\Ollama\`

## 📝 進階配置

### 修改網關端口

如果您想使用不同的端口，編輯 `scripts/start-both-bots.bat`：

```batch
REM 更改此行中的端口號
start "OpenClaw Bot 2 - Local" /B "C:\Program Files\nodejs\node.exe" dist\entry.js gateway --port 18790
```

### 添加額外的環境變量

編輯 `scripts/start-both-bots.bat` 中的環境變量部分：

```batch
set YOUR_VARIABLE=value
```

## ✅ 驗證檢查清單

設置完成後，驗證以下事項：

- [ ] 任務計劃程式中存在 `OpenClawBotsStartup` 任務
- [ ] 任務計劃程式中存在 `OpenClawBotsShutdown` 任務
- [ ] 兩個任務都設置為"SYSTEM"用戶運行
- [ ] 兩個任務都設置為"以最高權限運行"
- [ ] 手動測試啟動腳本成功運行
- [ ] 手動測試停止腳本成功運行

## 🆘 需要幫助？

### 快速診斷工具

運行診斷腳本以檢查所有設置：

```bash
scripts\diagnose-bots.bat
```

這個腳本將檢查：

- ✅ Node.js 安裝
- ✅ 項目構建狀態
- ✅ Ollama 進程和 API
- ✅ 網關端口響應
- ✅ 狀態目錄
- ✅ 配置文件

### 常見問題診斷

**問題：本地機器人無法回應**

原因和解決方案：

1. **端口未響應**
   - 等待 30-60 秒讓網關初始化
   - 運行 `scripts\diagnose-bots.bat` 檢查狀態
   - 檢查是否有防火牆阻止

2. **Ollama 未啟動**

   ```bash
   tasklist | find "ollama"
   # 如果沒有輸出，手動啟動 Ollama
   start "" "C:\Users\looko\AppData\Local\Programs\Ollama\ollama.exe"
   ```

3. **項目未構建**

   ```bash
   pnpm build
   ```

4. **環境變量未正確設置**
   - 檢查 `.env` 文件是否存在
   - 確保 `AGENT_MODEL` 已設置

### 手動測試端口

```bash
# 測試主機器人（通常在18789）
curl http://127.0.0.1:18789

# 測試本地機器人（在18790）
curl http://127.0.0.1:18790

# 測試 Ollama 服務
curl http://127.0.0.1:11434/api/tags
```

### 查看實時日誌

1. 在啟動腳本中創建的 cmd 窗口會顯示實時日誌
2. 窗口標題會標明是哪個機器人：
   - "OpenClaw Main Bot" - 主機器人
   - "OpenClaw Local Bot" - 本地機器人

### 如果需要檢查：

1. **Node.js 路徑**：`where node`
2. **項目構建**：`pnpm build`
3. **Ollama 狀態**：`tasklist | find "ollama"`
4. **任務計劃程式事件日誌**：`eventvwr.msc`

## 📚 相關文檔

- 項目主 README：[README.md](./README.md)
- OpenClaw 官方文檔：https://docs.openclaw.ai/
- Ollama 官方網站：https://ollama.ai/

---

**最後更新**：2026-02-09
**版本**：1.0
