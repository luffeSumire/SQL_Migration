/*
========================================
16_visit_stats_migration.sql
目的:
  匯入/初始化 舊系統 FAQ 與 Downloads 的 hits (瀏覽次數) 並寫入新系統彙總表 VisitPathStat，
  以及提供『總瀏覽人次 / 其他自定路徑』的手動可調整模板。

包含三部分:
  (1) 總瀏覽人次 / 其他手動路徑 (僅模板, 供人工調整)
  (2) FAQ 瀏覽次數 -> /faq/{FaqId}
  (3) Downloads 瀏覽次數 -> /downloads/{DownloadId}

重要說明:
  A. 新系統目前未永久存 SourceSid 對應 (舊系統 sid)。FAQ 可透過「原本遷移腳本#FaqMapping + Orphan 規則」重建對應; Downloads 因為插入時未指定順序 (無 ORDER BY) 身份值可能不保證重現，建議建立『手動映射』。
  B. 若已在正式環境執行過遷移並允許覆寫，建議於執行前備份 VisitPathStat。
  C. 本腳本採「覆寫」策略 (SET)；如需改成累加 (加總原本 TotalCount + hits)，請參考註解版本。

可重複執行: SAFE 模式 (使用 MERGE)。
========================================
*/

USE EcoCampus_PreProduction;  -- TODO: 視環境調整
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT '========================================';
PRINT '🚀 16 VisitPathStat 遷移初始化開始';
PRINT '開始時間: ' + CONVERT(varchar(19), SYSDATETIME(), 120);
PRINT '========================================';

BEGIN TRAN;  -- 若確認結果正確再 COMMIT

/* ----------------------------------------------------
 前置清理: 重新匯入前刪除既有的 FAQ / Downloads 對應路徑統計 (不影響其他手動路徑)
 可重複執行；若要全清空 VisitPathStat 請改為 TRUNCATE / DELETE *。
---------------------------------------------------- */
IF OBJECT_ID('dbo.VisitPathStat','U') IS NOT NULL
BEGIN
    DELETE FROM dbo.VisitPathStat WHERE Pathname LIKE '/faq/%' OR Pathname LIKE '/downloads/%';
    PRINT '✓ 已清理既有 /faq/* 與 /downloads/* 統計資料';
END

/* ----------------------------------------------------
 (1) 手動路由模板 (可自行調整 / 刪除 / 新增)
     例如: 全站統計顯示用、自訂聚合頁面等。
     Path 命名建議: 不與實際內容衝突。以下範例預設不直接出現在前端路由。
---------------------------------------------------- */
IF OBJECT_ID('tempdb..#ManualRoutes') IS NOT NULL DROP TABLE #ManualRoutes;
CREATE TABLE #ManualRoutes (
    Pathname NVARCHAR(300) NOT NULL PRIMARY KEY, -- 減少臨時表 PK 長度避免 900 bytes 警告
    TotalCount BIGINT NOT NULL,
    Note NVARCHAR(200) NULL
);

INSERT INTO #ManualRoutes (Pathname, TotalCount, Note) VALUES
  ('/',        100000, N'全站總瀏覽人次 (可人工調整)');

-- 若 VisitPathStat 尚未建立，這裡嘗試建立 (避免測試環境尚未同步模型時腳本失敗)
IF OBJECT_ID('dbo.VisitPathStat','U') IS NULL
BEGIN
    PRINT '⚠️ 目標表 VisitPathStat 不存在，嘗試建立暫時結構 (請後續以正式 Migration 同步)';
    CREATE TABLE dbo.VisitPathStat (
        VisitPathStatId BIGINT IDENTITY(1,1) PRIMARY KEY,
        Pathname NVARCHAR(500) NOT NULL,
        TotalCount BIGINT NOT NULL CONSTRAINT DF_VisitPathStat_TotalCount DEFAULT(0),
        UpdateTime DATETIME2(0) NOT NULL CONSTRAINT DF_VisitPathStat_UpdateTime DEFAULT (SYSUTCDATETIME())
    );
    CREATE NONCLUSTERED INDEX IX_VisitPathStat_Pathname ON dbo.VisitPathStat(Pathname);
END

;MERGE VisitPathStat AS tgt
USING (SELECT Pathname, TotalCount FROM #ManualRoutes) AS src
   ON tgt.Pathname = src.Pathname
WHEN MATCHED THEN UPDATE SET 
    tgt.TotalCount = src.TotalCount,
    tgt.UpdateTime = SYSUTCDATETIME()
WHEN NOT MATCHED THEN INSERT (Pathname, TotalCount)
    VALUES (src.Pathname, src.TotalCount);

PRINT '✓ (1) 手動模板路徑已初始化 (可稍後人工 UPDATE)';

/* ----------------------------------------------------
 (2) FAQ 瀏覽次數匯入
 來源: EcoCampus_Maria3.dbo.custom_article (type='fqa')
 欄位: hits (假設存在)
 映射: 需重建 #FaqMapping 與孤兒規則 (與 01_2 遷移腳本保持一致)
 注意: 若 01_2 遷移腳本有調整, 必須同步修改此區塊的對應表。
---------------------------------------------------- */
IF OBJECT_ID('tempdb..#FaqMapping') IS NOT NULL DROP TABLE #FaqMapping;
CREATE TABLE #FaqMapping (
    NewFaqId INT NOT NULL,
    ZhSid INT NULL,
    EnSid INT NULL,
    PRIMARY KEY (NewFaqId)
);

-- TODO: 與 01_2_faq_migration.sql 的映射保持同步 (以下為範例 / 複製原始對應)
INSERT INTO #FaqMapping (NewFaqId, ZhSid, EnSid)
VALUES
 (1, 609, 732),(2, 610, 731),(3, 611, 730),(4, 612, 729),(5, 613, 728),(6, 614, 727),(7, 615, 726),(8, 616, 725),(9, 617, 724),(10, 618, 723),
 (11, 619, 722),(12, 620, 721),(13, 621, 720),(14, 622, 719),(15, 623, 718),(16, 624, 717),(17, 625, 716),(18, 626, 715),(19, 627, 714),(20, 628, 713),
 (21, 629, 712),(22, 630, 711),(23, 631, 710),(24, 632, 709),(25, 633, 708),(26, 634, 707),(27, 635, 706),(28, 636, 705),(29, 637, 704),(30, 638, 703),
 (31, 639, 702),(32, 640, 701),(33, 641, 700),(34, 642, 699),(35, 643, 698),(36, 644, 697),(37, 645, 696),(38, 646, 695),(39, 647, 694);

DECLARE @MaxMappedFaqId INT = (SELECT MAX(NewFaqId) FROM #FaqMapping);

-- 來源 FAQ (含 hits)
IF OBJECT_ID('tempdb..#SrcFaq') IS NOT NULL DROP TABLE #SrcFaq;
SELECT 
  ca.sid,
  ca.lan,
  ca.hits
INTO #SrcFaq
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'fqa';

-- 孤兒 (未映射 sid)
IF OBJECT_ID('tempdb..#FaqOrphans') IS NOT NULL DROP TABLE #FaqOrphans;
WITH AllMapped AS (
    SELECT ZhSid AS sid FROM #FaqMapping WHERE ZhSid IS NOT NULL
    UNION ALL
    SELECT EnSid FROM #FaqMapping WHERE EnSid IS NOT NULL
)
SELECT s.sid, s.lan
INTO #FaqOrphans
FROM #SrcFaq s
LEFT JOIN AllMapped m ON s.sid = m.sid
WHERE m.sid IS NULL;

-- 孤兒重新編號對應 FaqId
IF OBJECT_ID('tempdb..#FaqOrphanIdMap') IS NOT NULL DROP TABLE #FaqOrphanIdMap;
WITH Numbered AS (
    SELECT ROW_NUMBER() OVER (ORDER BY s.sid) AS rn, s.sid
    FROM #FaqOrphans s
)
SELECT (@MaxMappedFaqId + rn) AS NewFaqId, sid INTO #FaqOrphanIdMap FROM Numbered;

-- 聚合 hits -> 每個新 FaqId
IF OBJECT_ID('tempdb..#FaqHits') IS NOT NULL DROP TABLE #FaqHits;
SELECT NewFaqId, SUM(HitsValue) AS TotalHits
INTO #FaqHits
FROM (
    -- 已映射 (雙語): 取 zh / en 兩筆 hits 加總
    SELECT fm.NewFaqId, sf.hits AS HitsValue
    FROM #FaqMapping fm
    LEFT JOIN #SrcFaq sf ON sf.sid = fm.ZhSid
    UNION ALL
    SELECT fm.NewFaqId, sf.hits
    FROM #FaqMapping fm
    LEFT JOIN #SrcFaq sf ON sf.sid = fm.EnSid
    UNION ALL
    -- 孤兒
    SELECT o.NewFaqId, sf.hits
    FROM #FaqOrphanIdMap o
    LEFT JOIN #SrcFaq sf ON sf.sid = o.sid
) AS x
GROUP BY NewFaqId;

-- FAQ -> VisitPathStat (/faq/{id})
;WITH Src AS (
    SELECT CONCAT('/faq/', fh.NewFaqId) AS Pathname, CAST(fh.TotalHits AS BIGINT) AS TotalCount
    FROM #FaqHits fh
)
MERGE VisitPathStat AS tgt
USING Src AS src
    ON tgt.Pathname = src.Pathname
WHEN MATCHED THEN UPDATE SET 
    tgt.TotalCount = src.TotalCount,  -- 覆寫
    tgt.UpdateTime = SYSUTCDATETIME()
WHEN NOT MATCHED THEN INSERT (Pathname, TotalCount)
    VALUES (src.Pathname, src.TotalCount);

PRINT '✓ (2) FAQ hits 已寫入 VisitPathStat';

/* ----------------------------------------------------
 (3) Downloads 瀏覽次數匯入 (自動對應版 - 無需人工映射)
 來源: EcoCampus_Maria3.dbo.custom_article (type='file_dl', lan='zh_tw') hits
 策略:
   A. 抽出舊系統中文主檔 (sid, title, createdate, hits)
   B. 抽出台現有新系統 Downloads + zh-TW DownloadContents (DownloadId, Title, PublishDate)
   C. 第一輪: Title 精確 (大小寫不區分) 唯一匹配
   D. 第二輪: 對剩餘未匹配資料依 (createdate 升冪, sid) 與 (PublishDate 升冪, DownloadId) 以 row_number 配對
   E. 聚合 hits -> /downloads/{DownloadId}
 風險: 若標題重複且時間排序對不上，可能少量錯配；執行後請人工抽樣驗證。
---------------------------------------------------- */
IF OBJECT_ID('tempdb..#DL_Source') IS NOT NULL DROP TABLE #DL_Source;
/*
    Downloads hits 正確來源 (依 02 / 02_2 遷移腳本欄位):
        custom_article (sid, type='file_dl', lan='zh_tw') 主檔
            -> custom_article_file_link (table_sid = custom_article.sid)
                 - fileinfo / fileinfo_odt 為舊系統檔名 (非 sid)
                 - type = 'two_file' 代表同時有 PDF + ODT
                 - type = 'link' / link_url 屬外部連結 (無下載檔案 hits)
        sys_files_store 保存單一實體檔案 hits (以檔名匹配)

    假設: sys_files_store.filename (或 file_name) = custom_article_file_link.fileinfo / fileinfo_odt
    若實際欄位不同請調整下方 @FileNameColumn 及 JOIN 條件。

    計算方式:
        - 蒐集每篇 article 的所有實際檔名 (PDF/ODT)，排除 link 類型
        - 去重後連到 sys_files_store 取 hits，加總為該篇下載總數
        - 若找不到對應檔案，記 0

    TODO: 若舊系統同一檔名重複掛載多篇文章，這裡按檔案實際 hits 直接加總；如需按『文章下附件實例數 * 單檔 hits』請移除 DISTINCT。
*/
DECLARE @FileNameColumn SYSNAME = 'filename';  -- 若 sys_files_store 實際欄位為 file_name / fname 等請修改

IF OBJECT_ID('tempdb..#DL_FileRefs') IS NOT NULL DROP TABLE #DL_FileRefs;
SELECT DISTINCT  -- 防止同檔在同文章被重複計數
        ca.sid      AS ArticleSid,
        COALESCE(afl.fileinfo, afl.fileinfo_odt) AS FileName
INTO #DL_FileRefs
FROM EcoCampus_Maria3.dbo.custom_article ca WITH (NOLOCK)
INNER JOIN EcoCampus_Maria3.dbo.custom_article_file_link afl WITH (NOLOCK) ON afl.table_sid = ca.sid
WHERE ca.type='file_dl'
    AND ca.lan='zh_tw'
    AND (afl.fileinfo IS NOT NULL OR afl.fileinfo_odt IS NOT NULL)
    AND (afl.type <> 'link' OR afl.type IS NULL);

-- 動態處理 sys_files_store 檔名欄位 (僅在需要改欄位時用到; 預設直接使用 fs.filename)
-- 若欄位不同，請直接改成 fs.<實際欄名>

SELECT 
        ca.sid        AS SourceSid,
        ca.title      AS SourceTitle,
        ISNULL(SUM(fs.hits),0) AS Hits,
        DATEADD(SECOND, ca.createdate, '1970-01-01') AS SourceCreateTime
INTO #DL_Source
FROM EcoCampus_Maria3.dbo.custom_article ca WITH (NOLOCK)
LEFT JOIN #DL_FileRefs fr ON fr.ArticleSid = ca.sid
LEFT JOIN EcoCampus_Maria3.dbo.sys_files_store fs WITH (NOLOCK)
             ON fs.name = fr.FileName   -- 若實際欄名不同請調整
WHERE ca.type='file_dl' AND ca.lan='zh_tw'
GROUP BY ca.sid, ca.title, ca.createdate;

IF NOT EXISTS (SELECT 1 FROM #DL_Source)
BEGIN
    PRINT '⚠️ (3) 無 downloads 來源資料，略過。';
END
ELSE
BEGIN
    IF OBJECT_ID('tempdb..#DL_Target') IS NOT NULL DROP TABLE #DL_Target;
    SELECT 
        d.DownloadId,
        dc.Title      AS TargetTitle,
        d.PublishDate AS TargetPublishDate
    INTO #DL_Target
    FROM Downloads d
    INNER JOIN DownloadContents dc ON d.DownloadId = dc.DownloadId AND dc.LocaleCode='zh-TW';

    /* 第一輪: Title 唯一精確匹配 (忽略大小寫) */
    IF OBJECT_ID('tempdb..#DL_Map') IS NOT NULL DROP TABLE #DL_Map;
    CREATE TABLE #DL_Map (SourceSid INT PRIMARY KEY, DownloadId INT NOT NULL, MatchType NVARCHAR(20) NOT NULL);

    ;WITH SrcUnique AS (
        SELECT SourceSid, SourceTitle
        FROM #DL_Source s
        WHERE s.SourceTitle IS NOT NULL AND s.SourceTitle<>''
          AND NOT EXISTS (
              SELECT 1 FROM #DL_Source s2 WHERE s2.SourceTitle = s.SourceTitle AND s2.SourceSid <> s.SourceSid
          )
    ), TgtUnique AS (
        SELECT DownloadId, TargetTitle
        FROM #DL_Target t
        WHERE t.TargetTitle IS NOT NULL AND t.TargetTitle<>''
          AND NOT EXISTS (
              SELECT 1 FROM #DL_Target t2 WHERE t2.TargetTitle = t.TargetTitle AND t2.DownloadId <> t.DownloadId
          )
    )
    INSERT INTO #DL_Map (SourceSid, DownloadId, MatchType)
    SELECT s.SourceSid, t.DownloadId, 'TITLE'
    FROM SrcUnique s
    INNER JOIN TgtUnique t ON UPPER(s.SourceTitle) = UPPER(t.TargetTitle);

    DECLARE @TitleMatched INT = @@ROWCOUNT;
    PRINT CONCAT('✓ Downloads 第一輪 Title 唯一匹配: ', @TitleMatched, ' 筆');

    /* 第二輪: 剩餘未匹配者以時間順序 row_number 對齊 */
    ;WITH SrcRemain AS (
        SELECT *, ROW_NUMBER() OVER (ORDER BY SourceCreateTime, SourceSid) AS rn
        FROM #DL_Source s
        WHERE NOT EXISTS (SELECT 1 FROM #DL_Map m WHERE m.SourceSid = s.SourceSid)
    ), TgtRemain AS (
        SELECT *, ROW_NUMBER() OVER (ORDER BY TargetPublishDate, DownloadId) AS rn
        FROM #DL_Target t
        WHERE NOT EXISTS (SELECT 1 FROM #DL_Map m WHERE m.DownloadId = t.DownloadId)
    )
    INSERT INTO #DL_Map (SourceSid, DownloadId, MatchType)
    SELECT s.SourceSid, t.DownloadId, 'SEQ'
    FROM SrcRemain s
    INNER JOIN TgtRemain t ON s.rn = t.rn;

    DECLARE @SeqMatched INT = @@ROWCOUNT;
    PRINT CONCAT('✓ Downloads 第二輪 時序匹配: ', @SeqMatched, ' 筆');

    /* 匹配覆蓋率 */
    DECLARE @TotalSrc INT = (SELECT COUNT(*) FROM #DL_Source);
    DECLARE @Mapped INT = (SELECT COUNT(*) FROM #DL_Map);
    PRINT CONCAT('✓ Downloads 匹配覆蓋率: ', @Mapped, '/', @TotalSrc, ' (', FORMAT(100.0 * @Mapped / NULLIF(@TotalSrc,0),'N2'), '%)');

    /* 聚合 hits -> DownloadId */
    ;WITH DownloadHits AS (
        SELECT m.DownloadId, SUM(s.Hits) AS TotalHits
        FROM #DL_Map m
        INNER JOIN #DL_Source s ON s.SourceSid = m.SourceSid
        GROUP BY m.DownloadId
    ), Src AS (
        SELECT CONCAT('/downloads/', dh.DownloadId) AS Pathname, CAST(dh.TotalHits AS BIGINT) AS TotalCount
        FROM DownloadHits dh
    )
    MERGE VisitPathStat AS tgt
    USING Src AS src
        ON tgt.Pathname = src.Pathname
    WHEN MATCHED THEN UPDATE SET
        tgt.TotalCount = src.TotalCount,
        tgt.UpdateTime = SYSUTCDATETIME()
    WHEN NOT MATCHED THEN INSERT (Pathname, TotalCount)
        VALUES (src.Pathname, src.TotalCount);

    PRINT '✓ (3) Downloads hits (自動對應) 已寫入 VisitPathStat';
END

/* ----------------------------------------------------
 (選擇性) 更新聚合總數 (若你想用 __faq_total__ / __downloads_total__ 作為聚合)
---------------------------------------------------- */
-- 示例: 將所有 /faq/{id} 加總後寫回 __faq_total__ (覆寫模式)
IF EXISTS (SELECT 1 FROM VisitPathStat WHERE Pathname LIKE '/faq/%')
BEGIN
    UPDATE v SET 
        v.TotalCount = agg.SumHits,
        v.UpdateTime = SYSUTCDATETIME()
    FROM VisitPathStat v
    INNER JOIN (
        SELECT SUM(TotalCount) AS SumHits FROM VisitPathStat WHERE Pathname LIKE '/faq/%'
    ) agg ON v.Pathname='__/faq_total__';
END

-- 示例: 將所有 /downloads/{id} 加總後寫回 __downloads_total__
IF EXISTS (SELECT 1 FROM VisitPathStat WHERE Pathname LIKE '/downloads/%')
BEGIN
    UPDATE v SET 
        v.TotalCount = agg.SumHits,
        v.UpdateTime = SYSUTCDATETIME()
    FROM VisitPathStat v
    INNER JOIN (
        SELECT SUM(TotalCount) AS SumHits FROM VisitPathStat WHERE Pathname LIKE '/downloads/%'
    ) agg ON v.Pathname='__/downloads_total__';
END

PRINT '========================================';
PRINT '✅ 16 VisitPathStat 遷移/初始化完成 (請檢查結果後 COMMIT)';
PRINT '完成時間: ' + CONVERT(varchar(19), SYSDATETIME(), 120);
PRINT '========================================';

-- 若檢查無誤取消下行註解以提交:
 COMMIT TRAN; RETURN;

-- 如需回滾 (未 COMMIT 狀態):
ROLLBACK TRAN;
PRINT '⚠️ 已 ROLLBACK (請編輯腳本解除 ROLLBACK 並使用 COMMIT)';

SET NOCOUNT OFF;
GO
