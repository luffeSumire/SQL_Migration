# EcoCampus SQL 遷移執行指南

## 📋 概述

本指南提供完整的 SQL 遷移腳本執行流程，確保資料從舊系統 (EcoCampus_Maria3) 正確遷移到新系統。

## 🗂️ 檔案結構

### 執行用檔案 (Production Ready)
```
00_clean_target_data.sql    # 清理目標資料庫
01_faq_migration.sql        # FAQ 遷移 (41筆記錄)
02_downloads_migration.sql  # Downloads 遷移 (34筆記錄 + 94個附件)
03_articles_migration.sql   # Articles 遷移 (~1,425筆記錄)
test_migration.sql          # 遷移結果驗證
run_migration.bat          # 自動執行腳本
```

### 原始檔案 (備份保留)
```
faq_migration_script.sql           # 原始 FAQ 腳本
downloads_complete_migration.sql   # 原始 Downloads 腳本  
articles_complete_migration.sql    # 原始 Articles 腳本
```

## 🚀 執行方式

### 方式 1: 自動執行 (推薦)
```bash
# 雙擊執行或在命令列執行
run_migration.bat
```

自動執行流程:
1. **[1/5]** 清理目標資料庫
2. **[2/5]** 執行 FAQ 遷移
3. **[3/5]** 執行 Downloads 遷移  
4. **[4/5]** 執行 Articles 遷移
5. **[5/5]** 驗證遷移結果

### 方式 2: 手動執行
```bash
# 設定連線參數
set SERVER=VM-MSSQL-2022
set USERNAME=ecocampus
set PASSWORD=42949337

# 逐一執行腳本
sqlcmd -S %SERVER% -U %USERNAME% -P %PASSWORD% -i "00_clean_target_data.sql"
sqlcmd -S %SERVER% -U %USERNAME% -P %PASSWORD% -i "01_faq_migration.sql"
sqlcmd -S %SERVER% -U %USERNAME% -P %PASSWORD% -i "02_downloads_migration.sql"
sqlcmd -S %SERVER% -U %USERNAME% -P %PASSWORD% -i "03_articles_migration.sql"
sqlcmd -S %SERVER% -U %USERNAME% -P %PASSWORD% -i "test_migration.sql"
```

## ⚠️ 執行前檢查

### 環境設定確認
每個遷移腳本檔案頂部都有環境設定，確認目標資料庫正確：

```sql
-- 測試環境
USE Ecocampus_PreProduction;

-- 正式環境 (上線時修改)
USE Ecocampus;
```

### 權限檢查
- ✅ 來源資料庫 (EcoCampus_Maria3): 讀取權限
- ✅ 目標資料庫: 讀寫權限
- ✅ sqlcmd 工具可用

## 📊 預期結果

### 遷移資料統計
- **FAQ**: 41筆記錄
  - Faqs: 41筆
  - FaqContents: 82筆 (中英文各41)
  
- **Downloads**: 34筆記錄 + 94個附件
  - Downloads: 34筆
  - DownloadContents: 68筆 (中英文各34)
  - DownloadAttachments: 94筆
  
- **Articles**: ~1,425筆記錄
  - Articles: ~1,425筆
  - ArticleContents: ~2,850筆 (中英文各1,425)

### 驗證標準
執行 `test_migration.sql` 後應看到：
```
✓ FAQ 遷移驗證通過
✓ Downloads 遷移驗證通過  
✓ Articles 遷移驗證通過
```

## 🔧 故障排除

### 常見問題
1. **連線失敗**: 檢查伺服器名稱、帳號密碼
2. **權限不足**: 確認帳號有目標資料庫讀寫權限
3. **資料不完整**: 重新執行清理腳本後再次遷移
4. **驗證失敗**: 檢查來源資料庫是否可連線

### 重新執行流程
如果遷移失敗，可以安全地重新執行：
1. 執行 `00_clean_target_data.sql` 清理資料
2. 重新執行遷移腳本
3. 執行驗證腳本確認結果

## 📝 注意事項

- ⚠️ **嚴禁修改資料庫結構** - 腳本僅執行 INSERT 操作
- ⚠️ **測試環境優先** - 先在測試環境驗證無誤
- ⚠️ **備份重要** - 執行前建議備份目標資料庫
- ⚠️ **單次執行** - 避免重複執行造成資料重複

## 🎯 執行完成後

1. 檢查各資料表記錄數是否符合預期
2. 抽樣檢查資料內容正確性
3. 測試新系統功能是否正常
4. 記錄執行結果和遇到的問題

---

*建立日期: 2025-08-01*  
*版本: v1.0*