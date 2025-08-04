### 三個資料庫實體
1. **EcoCampus_Maria3** - 舊結構 + 舊資料 (來源資料庫)
2. **EcoCampus** - 新結構 + 新資料
3. **EcoCampus_PreProduction** - 新結構 + 只保留類別資料 (測試環境)

### 連線字串資訊
- **伺服器**: VM-MSSQL-2022
- **使用者**: ecocampus
- **密碼**: 42949337
- **連線字串格式**: `Server=VM-MSSQL-2022;Database={DatabaseName};User ID=ecocampus;Password=42949337;TrustServerCertificate=True;`

### 專案結構
- **SourceDbContext** - 對應舊資料庫 (EcoCampus_Maria3) 的 EF Core 模型
- **TargetDbContext** - 對應新資料庫 (EcoCampus/EcoCampus_PreProduction) 的 EF Core 模型
- **Models/Source/** - 舊資料庫的實體模型 (通過 DB First scaffold 生成)
- **Models/Target/** - 新資料庫的實體模型 (通過 DB First scaffold 生成)

### 工作流程
1. **指定遷移來源與目標**
2. **讀取 SQL Server 資料表結構** - 分析 Source 和 Target 結構差異 (透過cmd 與 Sql-Server交互)
3. **讀取實體資料** - 從 EcoCampus_Maria3 和 EcoCampus 讀取實際資料 (透過cmd 與 Sql-Server交互)
4. **分析差異** - 理解模型結構和資料內容的前後變化
5. **產出 SQL 遷移腳本** - 生成純 SQL 檔案 (僅包含 INSERT/UPDATE/DELETE)
6. **執行與驗證** - 在 EcoCampus_PreProduction 執行腳本並驗證結果
7. **迭代完善** - 重複執行直到完美

### 重要限制條件
- **嚴禁 ALTER TABLE** - 不能修改任何資料庫的結構
- **嚴禁修改來源資料** - EcoCampus_Maria3 和 EcoCampus 的資料必須保持原樣，只能讀取
- **只對測試環境操作** - 僅能對 EcoCampus_PreProduction 執行 INSERT/UPDATE/DELETE 操作
- **純 SQL 腳本輸出** - 產出的腳本必須是純 SQL 檔案，不依賴 .NET 專案
- **自主DB交互** - 你可以自己跟SQL SERVER透過CMD交互，獲取所需的結構或是資料資訊，不要叫我幫你執行CMD指令

### 做法補充
- **透過CMD與SQL SERVER交互** -  

### 腳本除錯 Common Sense
1. **執行時錯誤處理** - 腳本執行如有錯誤，會顯示錯誤訊息，需要修正後重新執行
2. **完全重新執行策略** - 因為腳本會在不同環境多次執行，採用完全重新執行而非增量修復
3. **清空後重新執行** - 發現問題時先清空目標資料，修正腳本後重新執行
4. **變數作用域限制** - GO語句會重置變數作用域，避免跨GO使用變數
5. **CTE複雜度控制** - 複雜的CTE JOIN邏輯容易出錯，優先使用直接JOIN方式
6. **時間範圍設定** - 避免使用過短的時間範圍篩選，實際執行時間可能超出預期
7. **資料對應驗證** - 使用PublishDate等關鍵欄位進行精確對應，而非依賴ROW_NUMBER()

### 迭代完善流程
- 發現問題 → 分析根因 → 修正腳本 → 清空資料 → 重新執行 → 驗證結果
