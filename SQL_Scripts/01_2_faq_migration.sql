-- ========================================
-- FAQ 重製遷移腳本 v01_2  (顯式雙語對應 + 孤兒資料處理)
-- 來源: EcoCampus_Maria3.dbo.custom_article (type='fqa')
-- 舊系統結構: 一筆語系一筆主檔 (無主 / 子語系分離)
-- 新系統結構: Faqs (主表) + FaqContents (語系內容)
-- 需求重點:
--   1. 以提供的顯式 zh_tw / en 對應表建立雙語 FAQ (穩定、決定性，不再依 ROW_NUMBER 猜測)
--   2. 未出現在對應表中的舊系統資料視為「孤兒」(單語) -> 仍建立獨立 FAQ，只有單一語系內容
--   3. 可重複執行：先清空再塞入，顯式指定 FaqId，確保與 mapping 一致
--   4. 保留標籤(tag_sid) 對應規則: 3→4, 29→1, 28→2, 26→3, 2→5, 其他→5
--   5. PublishDate 取中文來源(若有) 否則英文來源；無則以 SYSDATETIME()
-- 建立日期: 2025-08-29
-- ========================================

-- ========================================
-- 環境設定 (請視環境調整)
-- ========================================
USE EcoCampus_PreProduction;
GO

PRINT '========================================';
PRINT 'FAQ v01_2 遷移腳本開始';
PRINT '執行時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

SET NOCOUNT ON;

-- ========================================
-- 0. 清空相關資料表
-- ========================================
PRINT '步驟 0: 清空 FAQ 相關資料表...';

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FaqContents')
    ALTER TABLE FaqContents NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Faqs')
    ALTER TABLE Faqs NOCHECK CONSTRAINT ALL;

DELETE FROM FaqContents;
DELETE FROM Faqs;

IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Faqs'))
    DBCC CHECKIDENT ('Faqs', RESEED, 0);

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FaqContents')
    ALTER TABLE FaqContents WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Faqs')
    ALTER TABLE Faqs WITH CHECK CHECK CONSTRAINT ALL;

PRINT '✓ 已清空 Faqs / FaqContents';
PRINT '----------------------------------------';

-- ========================================
-- 1. 建立顯式對應表 (雙語對應)
-- ========================================
PRINT '步驟 1: 建立雙語對應暫存表...';

IF OBJECT_ID('tempdb..#FaqMapping') IS NOT NULL DROP TABLE #FaqMapping;
CREATE TABLE #FaqMapping (
    NewFaqId INT NOT NULL,
    ZhSid INT NULL,
    EnSid INT NULL
);

INSERT INTO #FaqMapping (NewFaqId, ZhSid, EnSid)
VALUES
 (1, 609, 732),
 (2, 610, 731),
 (3, 611, 730),
 (4, 612, 729),
 (5, 613, 728),
 (6, 614, 727),
 (7, 615, 726),
 (8, 616, 725),
 (9, 617, 724),
 (10, 618, 723),
 (11, 619, 722),
 (12, 620, 721),
 (13, 621, 720),
 (14, 622, 719),
 (15, 623, 718),
 (16, 624, 717),
 (17, 625, 716),
 (18, 626, 715),
 (19, 627, 714),
 (20, 628, 713),
 (21, 629, 712),
 (22, 630, 711),
 (23, 631, 710),
 (24, 632, 709),
 (25, 633, 708),
 (26, 634, 707),
 (27, 635, 706),
 (28, 636, 705),
 (29, 637, 704),
 (30, 638, 703),
 (31, 639, 702),
 (32, 640, 701),
 (33, 641, 700),
 (34, 642, 699),
 (35, 643, 698),
 (36, 644, 697),
 (37, 645, 696),
 (38, 646, 695),
 (39, 647, 694);

DECLARE @MaxMappedId INT = (SELECT MAX(NewFaqId) FROM #FaqMapping);

PRINT '✓ 已建立雙語對應，共 ' + CAST(@MaxMappedId AS VARCHAR) + ' 筆';
PRINT '----------------------------------------';

-- ========================================
-- 2. 準備來源資料 (含必要欄位) & 建立索引暫存 (效能考量)
-- ========================================
PRINT '步驟 2: 準備來源資料快取...';

IF OBJECT_ID('tempdb..#Src') IS NOT NULL DROP TABLE #Src;
SELECT 
    ca.sid,
    ca.title,
    COALESCE(ca.explanation, '') AS explanation,
    ca.tag_sid,
    ca.createdate,          -- Unix seconds
    ca.lan
INTO #Src
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'fqa';

-- 索引 (臨時)
CREATE CLUSTERED INDEX IX_Src_sid ON #Src (sid);
CREATE NONCLUSTERED INDEX IX_Src_lan ON #Src (lan, sid);

PRINT '✓ 來源資料快取完成 (含索引)';
PRINT '----------------------------------------';

-- ========================================
-- 3. 插入 Faqs (雙語 + 孤兒) - 顯式指定 FaqId 確保可重現
-- ========================================
PRINT '步驟 3: 插入 Faqs 主表...';

SET IDENTITY_INSERT Faqs ON;

-- 3.1 雙語 FAQ (來自對應表)
INSERT INTO Faqs (FaqId, TagId, Author, PublishDate, CreatedTime, CreatedUserId, Status, SortOrder)
SELECT 
    fm.NewFaqId AS FaqId,
    CASE 
        WHEN COALESCE(sz.tag_sid, se.tag_sid) = 3 THEN 4
        WHEN COALESCE(sz.tag_sid, se.tag_sid) = 29 THEN 1
        WHEN COALESCE(sz.tag_sid, se.tag_sid) = 28 THEN 2
        WHEN COALESCE(sz.tag_sid, se.tag_sid) = 26 THEN 3
        WHEN COALESCE(sz.tag_sid, se.tag_sid) = 2 THEN 5
        ELSE 5
    END AS TagId,
    '管理員' AS Author,
    COALESCE(DATEADD(SECOND, sz.createdate, '1970-01-01'), DATEADD(SECOND, se.createdate, '1970-01-01'), SYSDATETIME()) AS PublishDate,
    SYSDATETIME() AS CreatedTime,
    1 AS CreatedUserId,
    1 AS Status,
    0 AS SortOrder
FROM #FaqMapping fm
LEFT JOIN #Src sz ON sz.sid = fm.ZhSid
LEFT JOIN #Src se ON se.sid = fm.EnSid;

DECLARE @InsertedBilingual INT = @@ROWCOUNT;

-- 3.2 孤兒資料 (未出現在 mapping 的 zh_tw / en 任一語系即為單語 FAQ)
IF OBJECT_ID('tempdb..#Orphans') IS NOT NULL DROP TABLE #Orphans;
WITH AllMapped AS (
    SELECT ZhSid AS sid FROM #FaqMapping WHERE ZhSid IS NOT NULL
    UNION
    SELECT EnSid FROM #FaqMapping WHERE EnSid IS NOT NULL
), OrphanSrc AS (
    SELECT s.* FROM #Src s
    LEFT JOIN AllMapped m ON s.sid = m.sid
    WHERE m.sid IS NULL -- 未被映射
), Numbered AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY createdate, sid) AS rn,
        *
    FROM OrphanSrc
)
SELECT 
    (@MaxMappedId + rn) AS NewFaqId,
    sid,
    lan,
    tag_sid,
    createdate,
    title,
    explanation
INTO #Orphans
FROM Numbered;

DECLARE @OrphanCount INT = (SELECT COUNT(*) FROM #Orphans);

IF @OrphanCount > 0
BEGIN
    INSERT INTO Faqs (FaqId, TagId, Author, PublishDate, CreatedTime, CreatedUserId, Status, SortOrder)
    SELECT 
        o.NewFaqId,
        CASE 
            WHEN o.tag_sid = 3 THEN 4
            WHEN o.tag_sid = 29 THEN 1
            WHEN o.tag_sid = 28 THEN 2
            WHEN o.tag_sid = 26 THEN 3
            WHEN o.tag_sid = 2 THEN 5
            ELSE 5
        END AS TagId,
        '管理員' AS Author,
        DATEADD(SECOND, o.createdate, '1970-01-01') AS PublishDate,
        SYSDATETIME() AS CreatedTime,
        1 AS CreatedUserId,
        1 AS Status,
        0 AS SortOrder
    FROM #Orphans o;
END

SET IDENTITY_INSERT Faqs OFF;

DECLARE @InsertedOrphan INT = @OrphanCount; -- 因為一 orphan 1 FAQ
DECLARE @TotalFaqs INT = @InsertedBilingual + @InsertedOrphan;

PRINT '✓ Faqs 插入完成：雙語=' + CAST(@InsertedBilingual AS VARCHAR) + '，孤兒=' + CAST(@InsertedOrphan AS VARCHAR) + '，總計=' + CAST(@TotalFaqs AS VARCHAR);
PRINT '----------------------------------------';

-- ========================================
-- 4. 插入 FaqContents
-- ========================================
PRINT '步驟 4: 插入 FaqContents 語系內容...';

-- 4.1 雙語 FAQ 中文內容
INSERT INTO FaqContents (FaqId, LocaleCode, Question, Answer, CreatedTime, CreatedUserId)
SELECT 
    fm.NewFaqId,
    'zh-TW',
    sz.title,
    sz.explanation,
    SYSDATETIME(),
    1
FROM #FaqMapping fm
INNER JOIN #Src sz ON sz.sid = fm.ZhSid;
DECLARE @CntZh INT = @@ROWCOUNT;

-- 4.2 雙語 FAQ 英文內容
INSERT INTO FaqContents (FaqId, LocaleCode, Question, Answer, CreatedTime, CreatedUserId)
SELECT 
    fm.NewFaqId,
    'en',
    se.title,
    se.explanation,
    SYSDATETIME(),
    1
FROM #FaqMapping fm
INNER JOIN #Src se ON se.sid = fm.EnSid;
DECLARE @CntEn INT = @@ROWCOUNT;

-- 4.3 孤兒 FAQ 單語內容
INSERT INTO FaqContents (FaqId, LocaleCode, Question, Answer, CreatedTime, CreatedUserId)
SELECT 
    o.NewFaqId,
    CASE WHEN o.lan = 'zh_tw' THEN 'zh-TW' ELSE 'en' END,
    o.title,
    o.explanation,
    SYSDATETIME(),
    1
FROM #Orphans o;
DECLARE @CntOrphan INT = @@ROWCOUNT;

-- 4.4 指定需複製英文內容的單語 FAQ (來源只有 zh_tw, 需求: 同主檔下生成 en，內容複製中文)
-- 說明: 以下列表中的 sid 若僅有 zh_tw 版本，將額外新增一筆 en 語系內容 (問題 / 答案相同)
IF OBJECT_ID('tempdb..#ForceDupEn') IS NOT NULL DROP TABLE #ForceDupEn;
CREATE TABLE #ForceDupEn (sid INT PRIMARY KEY);
INSERT INTO #ForceDupEn (sid) VALUES (772),(771);  -- 可依需求調整/擴充

DECLARE @CntForceTarget INT = (SELECT COUNT(*) FROM #ForceDupEn);

INSERT INTO FaqContents (FaqId, LocaleCode, Question, Answer, CreatedTime, CreatedUserId)
SELECT 
    o.NewFaqId,
    'en' AS LocaleCode,
    o.title,
    o.explanation,
    SYSDATETIME(),
    1
FROM #Orphans o
INNER JOIN #ForceDupEn f ON f.sid = o.sid
LEFT JOIN FaqContents fc ON fc.FaqId = o.NewFaqId AND fc.LocaleCode = 'en'
WHERE o.lan = 'zh_tw' AND fc.FaqContentId IS NULL;  -- 避免重複 (理論上每次重跑已清空)

DECLARE @CntForcedEn INT = @@ROWCOUNT;

IF @CntForceTarget > 0
    PRINT '✓ 強制複製英文內容: 目標=' + CAST(@CntForceTarget AS VARCHAR) + '，實際新增=' + CAST(@CntForcedEn AS VARCHAR);
ELSE
    PRINT '✓ 強制複製英文內容: 無設定目標';

DECLARE @TotalContents INT = @CntZh + @CntEn + @CntOrphan;

PRINT '✓ FaqContents 插入完成：中文=' + CAST(@CntZh AS VARCHAR) + '，英文=' + CAST(@CntEn AS VARCHAR) + '，孤兒單語=' + CAST(@CntOrphan AS VARCHAR) + '，總計=' + CAST(@TotalContents AS VARCHAR);
PRINT '----------------------------------------';

-- ========================================
-- 5. 統計與驗證
-- ========================================
PRINT '步驟 5: 統計與驗證...';

SELECT 
    'FAQ遷移統計' AS [項目],
    @InsertedBilingual AS [雙語FAQ數],
    @InsertedOrphan AS [孤兒FAQ數],
    @TotalFaqs AS [Faqs總數],
    @CntZh AS [中文內容數],
    @CntEn AS [英文內容數],
    @CntOrphan AS [孤兒單語內容數],
    @TotalContents AS [內容總數];

-- 孤兒語系分佈
SELECT '孤兒語系分佈' AS [項目], lan AS [來源語系], COUNT(*) AS [筆數]
FROM #Orphans GROUP BY lan;

-- 範例前 5 筆 FAQ (含語系)
SELECT TOP 5
    f.FaqId,
    ftc.FaqTagName AS 標籤名稱,
    c.LocaleCode,
    c.Question,
    LEFT(c.Answer, 40) + CASE WHEN LEN(c.Answer) > 40 THEN '...' ELSE '' END AS 答案預覽
FROM Faqs f
LEFT JOIN FaqContents c ON f.FaqId = c.FaqId
LEFT JOIN FaqTags ft ON f.TagId = ft.FaqTagId
LEFT JOIN FaqTagContents ftc ON ft.FaqTagId = ftc.FaqTagId AND ftc.LocaleCode = 'zh-TW'
ORDER BY f.FaqId, c.LocaleCode;

-- 驗證：任一 Faq 是否缺少內容
SELECT f.FaqId, COUNT(c.FaqContentId) AS ContentCount
FROM Faqs f
LEFT JOIN FaqContents c ON f.FaqId = c.FaqId
GROUP BY f.FaqId
HAVING COUNT(c.FaqContentId) = 0;

PRINT '----------------------------------------';

-- ========================================
-- 6. 清理暫存資源 (可保留供除錯，只在最後階段釋放)
-- ========================================
PRINT '步驟 6: 清理暫存表...';
DROP TABLE IF EXISTS #FaqMapping;
DROP TABLE IF EXISTS #Src;
DROP TABLE IF EXISTS #Orphans;
PRINT '✓ 暫存表已清理';

-- ========================================
-- 7. 完成訊息
-- ========================================
PRINT '========================================';
PRINT '✅ FAQ v01_2 遷移完成';
PRINT '- 雙語對應採顯式表，不依序列推測';
PRINT '- 孤兒資料已個別建立單語 FAQ';
PRINT '- 可安全重複執行 (會先清空再建立)';
PRINT '完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

SET NOCOUNT OFF;
GO

-- 使用說明簡述:
-- 1. 調整 USE 目標資料庫。
-- 2. 若 mapping 需增加/修正，直接調整 #FaqMapping INSERT 區塊。
-- 3. 孤兒策略: 任何不在 mapping (zh_tw/en) 的 sid 會被視為獨立 FAQ；若未來需嘗試配對，可先補 mapping 再執行。
-- 4. 若需保留既有資料而僅補遺失語系，請拆除「清空」區段並改寫為差異插入。此版本偏重全量重建。
