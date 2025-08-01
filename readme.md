# EcoCampus 資料遷移腳本指南

## 📋 總覽

本專案包含從舊系統 (EcoCampus_Maria3) 遷移到新系統的完整 SQL 腳本集合。

### 🗂️ 專案結構
```
SQL_Migration/
├── readme.md                           📖 總體指南 (本檔案)
├── process_guideline.md               📋 流程指引
└── SQL_Scripts/
    ├── faq_migration_script.sql       ✅ FAQ 遷移腳本
    ├── downloads_complete_migration.sql ✅ Downloads 遷移腳本
    └── articles_complete_migration.sql ✅ Articles (News) 遷移腳本
```

---

## 🔄 遷移單元狀態

| 單元 | 狀態 | 腳本檔案 | 記錄數 | 完成度 |
|------|------|----------|--------|--------|
| **FAQ** | ✅ 完成 | `faq_migration_script.sql` | 41筆 | 100% |
| **Downloads** | ✅ 完成 | `downloads_complete_migration.sql` | 34筆 | 100% |
| **Articles (News)** | ✅ 完成 | `articles_complete_migration.sql` | ~1,425筆 | 100% |
| **About** | 🔄 待開發 | - | - | 0% |
| **Execute** | 🔄 待開發 | - | - | 0% |

---

## 🛠️ 環境設定

### 資料庫環境
- **伺服器**: VM-MSSQL-2022
- **使用者**: ecocampus
- **密碼**: 42949337
- **來源資料庫**: EcoCampus_Maria3 (舊系統)
- **目標資料庫**: 
  - 測試環境: `Ecocampus_PreProduction`
  - 正式環境: `Ecocampus`

### 連線字串格式
```
Server=VM-MSSQL-2022;Database={DatabaseName};User ID=ecocampus;Password=42949337;TrustServerCertificate=True;
```

---

## 📋 遷移流程標準

### 1. 開發階段
1. **分析來源表結構** - 使用 `EXEC sp_columns 'table_name'`
2. **查詢樣本資料** - 使用 `SELECT TOP 10 * FROM table`
3. **分析目標表結構** - 確認新系統表格設計
4. **設計欄位對應** - 建立新舊欄位映射關係
5. **撰寫遷移腳本** - 實作 SQL 遷移邏輯

### 2. 測試階段
1. **測試環境執行** - 在 `Ecocampus_PreProduction` 測試
2. **資料驗證** - 確認遷移結果正確性
3. **效能評估** - 檢查執行時間和資源使用

### 3. 部署階段
1. **環境設定調整** - 修改目標資料庫名稱
2. **正式環境執行** - 在正式環境執行腳本
3. **結果確認** - 驗證正式環境遷移結果

---

## 🎯 已完成單元詳細說明

### FAQ 單元遷移

#### 📁 檔案: `faq_migration_script.sql`

#### 🗂️ 資料對應
| 來源表 | 目標表 | 說明 |
|--------|--------|------|
| `custom_article` (type='fqa') | `Faqs` | FAQ 主表 |
| `custom_article.title` | `FaqContents.Question` | 問題內容 |
| `custom_article.explanation` | `FaqContents.Answer` | 答案內容 |

#### 📊 遷移結果
- ✅ **Faqs 主表**: 41筆記錄
- ✅ **FaqContents 中文**: 41筆記錄
- ✅ **FaqContents 英文**: 41筆記錄 (複製中文)
- ✅ **標籤對應**: 自動映射到新系統標籤

#### 🚀 執行方式
```bash
sqlcmd -S VM-MSSQL-2022 -U ecocampus -P 42949337 -i "faq_migration_script.sql"
```

---

### Downloads 單元遷移

#### 📁 檔案: `downloads_complete_migration.sql`

#### 🗂️ 資料對應
| 來源表 | 目標表 | 說明 |
|--------|--------|------|
| `custom_article` (type='file_dl') | `Downloads` | 下載主表 |
| `custom_article.title` | `DownloadContents.Title` | 下載標題 |
| `custom_article.explanation` | `DownloadContents.Description` | 下載描述 |
| `custom_article_file_link.fileinfo` | `DownloadAttachments` | PDF 檔案附件 |
| `custom_article_file_link.fileinfo_odt` | `DownloadAttachments` | ODT 檔案附件 |

#### 🔗 檔案對應機制
```sql
FileEntry.FileName (舊檔名) → FileEntry.Id (新GUID)
```

#### 📊 遷移結果
- ✅ **Downloads 主表**: 34筆記錄
- ✅ **DownloadContents 中文**: 34筆記錄
- ✅ **DownloadContents 英文**: 34筆記錄
- ✅ **DownloadAttachments**: 94筆檔案附件
  - PDF 檔案: 63個
  - ODT 檔案: 31個

#### 🏷️ 標籤對應
| 舊系統 tag_sid | 新系統 TagCode | 說明 |
|----------------|----------------|------|
| 4 | checklist | 檢核清單 |
| 20 | briefing | 說明會 |
| 22 | award_ceremony | 頒獎典禮 |
| 30 | workshop | 工作坊/研習 |
| 31 | briefing | 說明會/簡報 |
| 其他 | social_resources | 社會資源 |

#### 🚀 執行方式
```bash
sqlcmd -S VM-MSSQL-2022 -U ecocampus -P 42949337 -i "downloads_complete_migration.sql"
```

---

### Articles (News) 單元遷移

#### 📁 檔案: `articles_complete_migration.sql`

#### 🗂️ 資料對應
| 來源表 | 目標表 | 說明 |
|--------|--------|------|
| `custom_news` (所有類型) | `Articles` | 新聞主表 |
| `custom_article` (type='news') | `Articles` | 文章類型新聞 |
| `custom_news.title` | `ArticleContents.Title` | 新聞標題 |
| `custom_news.explanation` | `ArticleContents.CmsHtml` | 新聞內容 |
| `custom_article_file_link` | `ArticleAttachments` | 檔案附件 |

#### 🏷️ 類型對應
| 來源系統 | 目標 TagCode | 說明 |
|----------|-------------|------|
| custom_news.certification | 1 | 認證 |
| custom_news.release | 2 | 校園 |  
| custom_news.activity | 3 | 活動 |
| custom_news.international | 4 | 國際 |
| custom_news.other | 5 | 其他 |
| custom_article.news | 2 | 校園 (統一歸類) |

#### 📊 遷移結果
- ✅ **Articles 主表**: ~1,425筆記錄
  - custom_news: 936筆
  - custom_article (news): 489筆
- ✅ **ArticleContents 中文**: ~1,425筆記錄
- ✅ **ArticleContents 英文**: ~1,425筆記錄
- ✅ **ArticleAttachments**: 視檔案附件數量而定

#### 🔗 特殊處理機制
- **多來源整合**: 同時處理 custom_news 和 custom_article 兩個來源表
- **內容組合**: 將 explanation 和 link 組合成 HTML 格式內容
- **檔案對應**: FileEntry.FileName → FileEntry.Id (GUID)
- **外部連結**: 支援 custom_article_file_link 的外部連結

#### 🚀 執行方式
```bash
sqlcmd -S VM-MSSQL-2022 -U ecocampus -P 42949337 -i "articles_complete_migration.sql"
```

---

## 🔧 環境適配指南

### 不同環境執行
每個腳本的環境設定區域都在檔案頂部，只需修改資料庫名稱：

```sql
-- 測試環境
USE Ecocampus_PreProduction;

-- 正式環境
USE Ecocampus;

-- 開發環境  
USE Ecocampus_Dev;
```

### 權限要求
- 來源資料庫 (EcoCampus_Maria3): 讀取權限
- 目標資料庫: 讀寫權限
- 系統表查詢權限 (sp_columns)

---

## ⚠️ 重要限制條件

1. **嚴禁 ALTER TABLE** - 不可修改任何資料庫結構
2. **嚴禁修改來源資料** - EcoCampus_Maria3 和 Ecocampus 只能讀取  
3. **只對測試環境操作** - 開發階段僅能對 Ecocampus_PreProduction 執行 INSERT/UPDATE/DELETE
4. **純 SQL 腳本輸出** - 產出必須是純 SQL 檔案
5. **自主 DB 互動** - 需自行透過 sqlcmd 與 SQL Server 互動

---

## 🎯 未來開發計畫

### 待開發單元

1. **About 單元** (type='about')  
   - 來源: `custom_article`
   - 目標: `AboutPages`, `AboutContents`

2. **Execute 單元** (type='execute')
   - 來源: `custom_article` 
   - 目標: `ExecuteSteps`, `ExecuteContents`

### 開發優先順序
1. About (關於我們) - 高優先級  
2. Execute (執行步驟) - 中優先級

---

## 🛠️ 開發工具和命令

### 常用查詢命令
```sql
-- 查詢表結構
EXEC sp_columns 'table_name'

-- 查詢樣本資料  
SELECT TOP 10 * FROM table_name

-- 檢查資料類型分布
SELECT DISTINCT type FROM custom_article

-- 統計記錄數量
SELECT COUNT(*) FROM table_name WHERE condition
```

### 腳本執行命令
```bash
# 執行腳本
sqlcmd -S VM-MSSQL-2022 -U ecocampus -P 42949337 -i "script_name.sql"

# 執行查詢
sqlcmd -S VM-MSSQL-2022 -U ecocampus -P 42949337 -d database_name -Q "SELECT query"
```

---

## 📊 額外遷移規則

1. **文章類型管理**: 舊系統的 `custom_article` 是多單元集合，透過 `type` 欄位控制
2. **多語系處理**: 忽略 `lan=en`，直接複製 `zh-tw` 內容到英文版本
3. **標籤系統**: 新系統標籤已預設，以新表的 tag id 做映射目標
4. **檔案系統**: 新系統使用 `FileEntry.Id` (GUID)，舊系統使用檔名
5. **標籤內容**: 舊系統的 `custom_tag` 包含標籤名稱內容

---

## 📞 支援與維護

### 問題回報
如遇到問題，請提供：
1. 執行的腳本名稱
2. 錯誤訊息截圖
3. 執行環境 (測試/正式)
4. 資料庫狀態

### 維護記錄
- 2025-07-29: 完成 FAQ 和 Downloads 單元遷移
- 2025-07-29: 完成 Articles (News) 單元遷移 - 整合 custom_news 和 custom_article 新聞內容
- 待續...

---

*最後更新: 2025-07-29*
