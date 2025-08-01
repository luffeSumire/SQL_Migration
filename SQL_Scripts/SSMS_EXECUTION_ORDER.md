# SSMS 執行順序指南

## 📋 在 SQL Server Management Studio (SSMS) 中執行遷移腳本

### 🔧 環境設定
1. 連線到 SQL Server: `VM-MSSQL-2022`
2. 使用帳號: `ecocampus` / 密碼: `42949337`
3. 確認目標資料庫: `Ecocampus_PreProduction` (測試) 或 `Ecocampus` (正式)

### 📝 執行順序

請在 SSMS 中**依序**開啟並執行以下腳本：

#### 1. 清理目標資料庫
```
檔案: 00_clean_target_data.sql
說明: 清理目標資料庫 (保留標籤定義表)
```

#### 2. FAQ 遷移
```
檔案: 01_faq_migration.sql  
說明: 遷移 FAQ 資料 (41筆記錄)
預期: Faqs(41) + FaqContents(82)
```

#### 3. Downloads 遷移
```  
檔案: 02_downloads_migration.sql
說明: 遷移 Downloads 資料 (34筆記錄 + 94個附件)
預期: Downloads(34) + DownloadContents(68) + DownloadAttachments(94)
```

#### 4. Articles 遷移
```
檔案: 03_articles_migration.sql
說明: 遷移 Articles 資料 (~1,425筆記錄)  
預期: Articles(~1425) + ArticleContents(~2850)
```

#### 5. 驗證結果
```
檔案: test_migration.sql
說明: 驗證遷移結果正確性
預期: 所有項目顯示 ✓ 通過
```

### ⚠️ 重要提醒

1. **逐一執行**: 請依序執行，不要一次執行多個腳本
2. **檢查錯誤**: 每個腳本執行完成後檢查是否有錯誤訊息
3. **環境確認**: 執行前確認腳本中的 `USE` 語句指向正確的資料庫
4. **保留定義表**: 清理腳本不會刪除標籤定義表，僅清理遷移資料
5. **可重複執行**: 如果失敗，可重新執行清理腳本後重試

### 🎯 執行結果確認

每個腳本執行完成後，應該看到類似訊息：
```
✓ [模組名稱] 遷移完成
遷移記錄數: XXX 筆
```

最終驗證腳本應顯示：
```
✓ FAQ 遷移驗證通過
✓ Downloads 遷移驗證通過  
✓ Articles 遷移驗證通過
```

### 🔄 重新執行流程

如需重新執行：
1. 執行 `00_clean_target_data.sql` 清理資料
2. 重新依序執行遷移腳本
3. 執行驗證腳本確認結果

---

*適用於 SSMS 執行環境*