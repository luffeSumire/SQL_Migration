/*
15_visit_path_stat_migration.sql
--------------------------------
目的: 建立可人工/批次調整的路徑瀏覽統計表 VisitPathStat。
用途: 舊系統匯總匯入 + 後台人工修正 + 與新系統 VisitLogs 合併。

差異 vs 舊設計:
  - 表名由 LegacyVisitStat 改為 VisitPathStat (語意通用，不侷限遷移)。
  - 欄位 ImportedTime 改為 UpdateTime，語意代表最後更新 (新增或調整)。
  - 欄位 TotalCount 表示可調整後的最終累計值。

結構:
  VisitPathStatId BIGINT IDENTITY 主鍵
  Pathname        NVARCHAR(500) 路徑
  TotalCount      BIGINT 累計可調整次數
  UpdateTime      DATETIME2(0) 最後更新時間 (UTC)

索引:
  IX_VisitPathStat_Pathname  非唯一 (允許後續若有需要多版本處理，可再約束為唯一；一般場景應只有一筆)。

後續可選強化:
  - 若確定一條 Path 僅一筆: 加 UNIQUE INDEX IX_VisitPathStat_Pathname UNIQUE(Pathname)
  - 加 CHECK (TotalCount >= 0)
  - 透過觸發器紀錄調整歷史 (建另一張 VisitPathStatHistory)
*/

SET NOCOUNT ON;
GO

IF OBJECT_ID(N'dbo.VisitPathStat', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.VisitPathStat
    (
        VisitPathStatId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Pathname        NVARCHAR(500) NOT NULL,
        TotalCount      BIGINT NOT NULL CONSTRAINT DF_VisitPathStat_TotalCount DEFAULT(0),
        UpdateTime      DATETIME2(0) NOT NULL CONSTRAINT DF_VisitPathStat_UpdateTime DEFAULT (SYSUTCDATETIME())
    );

    EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'路徑瀏覽統計主表 (可人工調整)',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE',  @level1name = 'VisitPathStat';

    EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'路徑 (對應前端/後端路由 Pathname)',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE',  @level1name = 'VisitPathStat',
        @level2type = N'COLUMN', @level2name = 'Pathname';

    EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'可調整後累計瀏覽次數',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE',  @level1name = 'VisitPathStat',
        @level2type = N'COLUMN', @level2name = 'TotalCount';

    EXEC sys.sp_addextendedproperty @name = N'MS_Description', @value = N'最後更新時間 (UTC)',
        @level0type = N'SCHEMA', @level0name = 'dbo',
        @level1type = N'TABLE',  @level1name = 'VisitPathStat',
        @level2type = N'COLUMN', @level2name = 'UpdateTime';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_VisitPathStat_Pathname' AND object_id = OBJECT_ID(N'dbo.VisitPathStat'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_VisitPathStat_Pathname ON dbo.VisitPathStat(Pathname);
END
GO

/*
-- (選擇性) 若要限制單一路徑僅一筆，可改為 UNIQUE：
-- CREATE UNIQUE INDEX UX_VisitPathStat_Pathname ON dbo.VisitPathStat(Pathname);

-- 初始化匯入 (來源舊系統表 OldAggregatedLog)：
INSERT INTO dbo.VisitPathStat (Pathname, TotalCount)
SELECT  o.Pathname, SUM(CAST(o.ViewCount AS BIGINT))
FROM    dbo.OldAggregatedLog o
GROUP BY o.Pathname;

-- 增量合併 (若來源是增量累加值)；假設 IncrementLog:
;WITH inc AS (
    SELECT Pathname, SUM(CAST(ViewCount AS BIGINT)) AS AddCount
    FROM dbo.OldAggregatedLog_Increment
    GROUP BY Pathname
)
MERGE dbo.VisitPathStat AS tgt
USING inc AS src
    ON tgt.Pathname = src.Pathname
WHEN MATCHED THEN UPDATE SET 
    tgt.TotalCount = tgt.TotalCount + src.AddCount,
    tgt.UpdateTime = SYSUTCDATETIME()
WHEN NOT MATCHED THEN INSERT (Pathname, TotalCount, UpdateTime)
    VALUES (src.Pathname, src.AddCount, SYSUTCDATETIME());

-- 人工調整：
-- UPDATE dbo.VisitPathStat SET TotalCount = 12345, UpdateTime = SYSUTCDATETIME() WHERE Pathname = '/faq/100';
*/

-- 驗證: SELECT TOP 20 * FROM dbo.VisitPathStat ORDER BY VisitPathStatId DESC;