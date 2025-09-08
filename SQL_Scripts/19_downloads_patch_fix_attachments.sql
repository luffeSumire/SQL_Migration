/*
========================================
19. Downloads 附件修正補丁 (接續 02 / 02_2 之後)

目的:
 1) 修正主表底下的附件內容不等於舊資料的狀況 (與舊系統 custom_article_file_link 對齊)
 2) 將附件內容 Title 補齊 (優先使用舊系統檔案/連結標題, 再以檔名 / 文章標題回填)

設計重點:
 - 不依賴 02_2 的暫存映射表, 透過 (PublishDate + TagCode + zh-TW Title) 重建 SourceSid -> Download/Content 對應
 - 以 MERGE 方式對齊 zh-TW 的附件 (PDF/ODT/link), 並將結果同步到英文(en)
 - 預設非破壞性 (不刪除多餘附件), 可切換嚴格模式進行刪除

參數:
 - @TargetDB: 目標資料庫 (請視環境調整)
 - @AdminUserId: 系統操作人員 ID
 - @StrictSync: 嚴格同步 (1=刪除不在舊資料中的附件；0=僅新增/更新, 不刪除)

需求資料:
 - 來源: EcoCampus_Maria3.dbo.custom_article / custom_article_file_link
 - 目標: Downloads / DownloadContents / DownloadAttachments / FileEntry

安全性:
 - 具體對齊條件限制在本批次涵蓋的 DownloadContent 範圍內
 - 若找不到對應 FileEntry (FileName 對應不到), 將跳過該檔案附件的插入並列於統計中

版本:
  v1.0 - 2025-09-08
========================================
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

-- 請依環境調整
USE EcoCampus_PreProduction;  -- TODO: 正式環境請改為 Ecocampus

DECLARE @AdminUserId INT = 1;
DECLARE @Now DATETIME2 = SYSDATETIME();
DECLARE @StrictSync BIT = 0;  -- 0: 只新增/更新, 不刪除 ； 1: 嚴格同步 (刪除多餘項)

PRINT '========================================';
PRINT '⚙️ 19. Downloads 附件修正補丁開始';
PRINT '開始時間: ' + CONVERT(varchar(19), @Now, 120);
PRINT '嚴格同步(刪除多餘附件): ' + CAST(@StrictSync AS varchar(10));
PRINT '========================================';

/* ----------------------------------------------------
   來源文章 (zh_tw) + 對應 TagCode / PublishDate
---------------------------------------------------- */
IF OBJECT_ID('tempdb..#SourceZh') IS NOT NULL DROP TABLE #SourceZh;
SELECT 
    ca.sid              AS SourceSid,
    ca.title            AS Title_Zh,
    COALESCE(ca.explanation,'') AS Description_Zh,
    ca.tag_sid          AS TagSid,
    ca.createdate       AS CreateUnixTs,
    DATEADD(SECOND, ca.createdate, '1970-01-01') AS PublishDate,
    CASE 
        WHEN ca.tag_sid = 4  THEN 'checklist'
        WHEN ca.tag_sid = 20 THEN 'e_handbook'
        WHEN ca.tag_sid = 22 THEN 'award_ceremony'
        WHEN ca.tag_sid = 30 THEN 'workshop'
        WHEN ca.tag_sid = 31 THEN 'briefing'
        WHEN ca.tag_sid = 43 THEN 'featured_videos'
        WHEN ca.tag_sid = 54 THEN 'social_resources'
        ELSE 'other'
    END AS TagCode
INTO #SourceZh
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'file_dl'
  AND ca.lan  = 'zh_tw';

IF NOT EXISTS (SELECT 1 FROM #SourceZh)
BEGIN
    PRINT '⚠️ 無 zh_tw 來源資料 (type=file_dl)，腳本結束。';
    RETURN;
END;

/* ----------------------------------------------------
   建立 SourceSid -> Download / zh/en 內容對應
   以 (PublishDate + TagCode + zh-TW Title) 做唯一對齊
---------------------------------------------------- */
IF OBJECT_ID('tempdb..#Map') IS NOT NULL DROP TABLE #Map;
SELECT 
    s.SourceSid,
    d.DownloadId,
    dc_zh.DownloadContentId AS DownloadContentId_Zh,
    dc_en.DownloadContentId AS DownloadContentId_En
INTO #Map
FROM #SourceZh s
JOIN Downloads d 
  ON d.PublishDate = s.PublishDate
 AND d.TagCode     = s.TagCode
JOIN DownloadContents dc_zh 
  ON dc_zh.DownloadId = d.DownloadId 
 AND dc_zh.LocaleCode = 'zh-TW' 
 AND dc_zh.Title      = LEFT(s.Title_Zh, 500)
LEFT JOIN DownloadContents dc_en 
  ON dc_en.DownloadId = d.DownloadId 
 AND dc_en.LocaleCode = 'en';

IF NOT EXISTS (SELECT 1 FROM #Map)
BEGIN
    RAISERROR('對應不到任何 Download / DownloadContents，請確認 02/02_2 已正確執行。',16,1);
    RETURN;
END;

/* ----------------------------------------------------
   準備 zh-TW 預期附件清單 (#ExpectedZh)
   - PDF: afl.fileinfo -> FileEntry.FileName
   - ODT: afl.fileinfo_odt (type='two_file')
   - Link: afl.type='link' + afl.link_url
   Title 規則:
     file: COALESCE(NULLIF(afl.title,''), fe.OriginalFileName)
     link: COALESCE(NULLIF(afl.title,''), LEFT(s.Title_Zh,100), CONCAT('Link-', afl.sequence))
---------------------------------------------------- */
IF OBJECT_ID('tempdb..#ExpectedZh') IS NOT NULL DROP TABLE #ExpectedZh;
CREATE TABLE #ExpectedZh (
    DownloadContentId INT NOT NULL,
    ContentTypeCode   NVARCHAR(50) NOT NULL,
    FileEntryId       UNIQUEIDENTIFIER NULL,
    LinkUrl           NVARCHAR(2000) NULL,
    Title             NVARCHAR(100) NOT NULL,
    SortOrder         INT NOT NULL
);

-- PDF (fileinfo)
INSERT INTO #ExpectedZh (DownloadContentId, ContentTypeCode, FileEntryId, LinkUrl, Title, SortOrder)
SELECT 
    m.DownloadContentId_Zh,
    'file',
    fe.Id,
    NULL,
    LEFT(COALESCE(NULLIF(afl.title,''), fe.OriginalFileName), 100),
    COALESCE(afl.sequence,0)
FROM EcoCampus_Maria3.dbo.custom_article_file_link afl
JOIN EcoCampus_Maria3.dbo.custom_article ca ON afl.table_sid = ca.sid AND ca.type='file_dl' AND ca.lan='zh_tw'
JOIN #SourceZh s ON s.SourceSid = ca.sid
JOIN #Map m      ON m.SourceSid = s.SourceSid
JOIN dbo.FileEntry fe ON fe.FileName = afl.fileinfo
WHERE afl.fileinfo IS NOT NULL;

-- ODT (two_file -> fileinfo_odt)
INSERT INTO #ExpectedZh (DownloadContentId, ContentTypeCode, FileEntryId, LinkUrl, Title, SortOrder)
SELECT 
    m.DownloadContentId_Zh,
    'file',
    fe.Id,
    NULL,
    LEFT(COALESCE(NULLIF(afl.title,''), fe.OriginalFileName), 100),
    COALESCE(afl.sequence,0) + 1
FROM EcoCampus_Maria3.dbo.custom_article_file_link afl
JOIN EcoCampus_Maria3.dbo.custom_article ca ON afl.table_sid = ca.sid AND ca.type='file_dl' AND ca.lan='zh_tw'
JOIN #SourceZh s ON s.SourceSid = ca.sid
JOIN #Map m      ON m.SourceSid = s.SourceSid
JOIN dbo.FileEntry fe ON fe.FileName = afl.fileinfo_odt
WHERE afl.type = 'two_file' AND afl.fileinfo_odt IS NOT NULL;

-- Link (type=link)
INSERT INTO #ExpectedZh (DownloadContentId, ContentTypeCode, FileEntryId, LinkUrl, Title, SortOrder)
SELECT 
    m.DownloadContentId_Zh,
    'video',
    NULL,
    afl.link_url,
    LEFT(COALESCE(NULLIF(afl.title,''), s.Title_Zh, CONCAT('Link-', COALESCE(afl.sequence,0))), 100),
    COALESCE(afl.sequence,0) + 50
FROM EcoCampus_Maria3.dbo.custom_article_file_link afl
JOIN EcoCampus_Maria3.dbo.custom_article ca ON afl.table_sid = ca.sid AND ca.type='file_dl' AND ca.lan='zh_tw'
JOIN #SourceZh s ON s.SourceSid = ca.sid
JOIN #Map m      ON m.SourceSid = s.SourceSid
WHERE afl.type = 'link' AND afl.link_url IS NOT NULL;

DECLARE @ExpZh INT = (SELECT COUNT(*) FROM #ExpectedZh);
PRINT CONCAT('✓ 預期 zh-TW 附件數: ', @ExpZh);

-- 將預期 zh-TW 附件依鍵去重，避免 MERGE 多重比對
IF OBJECT_ID('tempdb..#ExpectedZh_Dedup') IS NOT NULL DROP TABLE #ExpectedZh_Dedup;
SELECT 
    DownloadContentId,
    ContentTypeCode,
    FileEntryId,
    LinkUrl,
    MIN(Title)     AS Title,
    MIN(SortOrder) AS SortOrder,
    COUNT(*)       AS DupCount
INTO #ExpectedZh_Dedup
FROM #ExpectedZh
GROUP BY DownloadContentId, ContentTypeCode, FileEntryId, LinkUrl;

DECLARE @ZhDupKeys INT = (SELECT COUNT(*) FROM #ExpectedZh_Dedup WHERE DupCount > 1);
IF @ZhDupKeys > 0 PRINT CONCAT('⚠️ zh-TW 預期附件鍵出現重複: ', @ZhDupKeys, ' 組 (已自動去重)');

/* ----------------------------------------------------
   統計: 找不到對應 FileEntry 的來源 (以利檢查)
---------------------------------------------------- */
IF OBJECT_ID('tempdb..#MissingFileEntry') IS NOT NULL DROP TABLE #MissingFileEntry;
SELECT DISTINCT 
    ca.sid AS SourceSid,
    COALESCE(afl.fileinfo, afl.fileinfo_odt) AS SourceFileName,
    afl.type,
    COALESCE(afl.sequence,0) AS sequence
INTO #MissingFileEntry
FROM EcoCampus_Maria3.dbo.custom_article_file_link afl
JOIN EcoCampus_Maria3.dbo.custom_article ca ON afl.table_sid = ca.sid AND ca.type='file_dl' AND ca.lan='zh_tw'
LEFT JOIN dbo.FileEntry fe ON fe.FileName IN (afl.fileinfo, afl.fileinfo_odt)
WHERE ((afl.fileinfo IS NOT NULL OR (afl.type='two_file' AND afl.fileinfo_odt IS NOT NULL)) AND fe.Id IS NULL);

/* ----------------------------------------------------
   MERGE -> 同步 zh-TW 下載附件到預期清單
   比對鍵: (DownloadContentId, ContentTypeCode, FileEntryId, LinkUrl)
   - Matched: 更新 Title / SortOrder / Updated*
   - Not Matched By Target: 新增
   - Not Matched By Source: (選擇性) 刪除 (@StrictSync=1 時)
---------------------------------------------------- */
BEGIN TRAN;

-- 建立暫存以統計 MERGE 結果
IF OBJECT_ID('tempdb..#TmpZhActions') IS NOT NULL DROP TABLE #TmpZhActions;
CREATE TABLE #TmpZhActions (MergeAction nvarchar(10));

MERGE DownloadAttachments AS tgt
USING (
    SELECT DownloadContentId, ContentTypeCode, FileEntryId, LinkUrl, Title, SortOrder FROM #ExpectedZh_Dedup
) AS src
ON  tgt.DownloadContentId = src.DownloadContentId
AND tgt.ContentTypeCode   = src.ContentTypeCode
AND ISNULL(tgt.FileEntryId, '00000000-0000-0000-0000-000000000000') = ISNULL(src.FileEntryId, '00000000-0000-0000-0000-000000000000')
AND ISNULL(tgt.LinkUrl,'') = ISNULL(src.LinkUrl,'')
WHEN MATCHED THEN
    UPDATE SET 
        tgt.Title        = src.Title,
        tgt.SortOrder    = src.SortOrder,
        tgt.UpdatedTime  = @Now,
        tgt.UpdatedUserId= @AdminUserId
WHEN NOT MATCHED BY TARGET THEN
    INSERT (DownloadContentId, FileEntryId, ContentTypeCode, Title, LinkUrl, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder)
    VALUES (src.DownloadContentId, src.FileEntryId, src.ContentTypeCode, src.Title, src.LinkUrl, @Now, @AdminUserId, @Now, @AdminUserId, src.SortOrder)
OUTPUT $action INTO #TmpZhActions;

DECLARE @ZhInserted INT = (SELECT COUNT(*) FROM #TmpZhActions WHERE MergeAction = 'INSERT');
DECLARE @ZhUpdated  INT = (SELECT COUNT(*) FROM #TmpZhActions WHERE MergeAction = 'UPDATE');
PRINT CONCAT('✓ zh-TW 附件: 新增 ', @ZhInserted, ' 筆、更新 ', @ZhUpdated, ' 筆');

-- 嚴格同步: 刪除 zh-TW 多餘的附件 (不在 #ExpectedZh 中)
IF @StrictSync = 1
BEGIN
    DELETE tgt
    FROM DownloadAttachments tgt
    JOIN #Map m ON m.DownloadContentId_Zh = tgt.DownloadContentId
    LEFT JOIN #ExpectedZh_Dedup src
      ON  tgt.DownloadContentId = src.DownloadContentId
      AND tgt.ContentTypeCode   = src.ContentTypeCode
      AND ISNULL(tgt.FileEntryId,'00000000-0000-0000-0000-000000000000') = ISNULL(src.FileEntryId,'00000000-0000-0000-0000-000000000000')
      AND ISNULL(tgt.LinkUrl,'') = ISNULL(src.LinkUrl,'')
    WHERE src.DownloadContentId IS NULL;  -- 不在預期清單
    PRINT '✓ 嚴格同步: 已刪除 zh-TW 多餘附件';
END

/* ----------------------------------------------------
   準備 en 預期附件 (#ExpectedEn): 複製 zh 結果到英文內容
---------------------------------------------------- */
IF OBJECT_ID('tempdb..#ExpectedEn') IS NOT NULL DROP TABLE #ExpectedEn;
CREATE TABLE #ExpectedEn (
    DownloadContentId INT NOT NULL,
    ContentTypeCode   NVARCHAR(50) NOT NULL,
    FileEntryId       UNIQUEIDENTIFIER NULL,
    LinkUrl           NVARCHAR(2000) NULL,
    Title             NVARCHAR(100) NOT NULL,
    SortOrder         INT NOT NULL
);

INSERT INTO #ExpectedEn (DownloadContentId, ContentTypeCode, FileEntryId, LinkUrl, Title, SortOrder)
SELECT 
    m.DownloadContentId_En,
    da.ContentTypeCode,
    da.FileEntryId,
    da.LinkUrl,
    da.Title,  -- 標題直接複製 (若需英文翻譯可後續更新)
    da.SortOrder
FROM #Map m
JOIN DownloadAttachments da ON da.DownloadContentId = m.DownloadContentId_Zh;

-- 僅覆蓋存在英文內容者
DELETE FROM #ExpectedEn WHERE DownloadContentId IS NULL;

-- 英文同樣依鍵去重
IF OBJECT_ID('tempdb..#ExpectedEn_Dedup') IS NOT NULL DROP TABLE #ExpectedEn_Dedup;
SELECT 
    DownloadContentId,
    ContentTypeCode,
    FileEntryId,
    LinkUrl,
    MIN(Title)     AS Title,
    MIN(SortOrder) AS SortOrder,
    COUNT(*)       AS DupCount
INTO #ExpectedEn_Dedup
FROM #ExpectedEn
GROUP BY DownloadContentId, ContentTypeCode, FileEntryId, LinkUrl;

DECLARE @EnDupKeys INT = (SELECT COUNT(*) FROM #ExpectedEn_Dedup WHERE DupCount > 1);
IF @EnDupKeys > 0 PRINT CONCAT('⚠️ en 預期附件鍵出現重複: ', @EnDupKeys, ' 組 (已自動去重)');

-- 同步到英文內容
IF OBJECT_ID('tempdb..#TmpEnActions') IS NOT NULL DROP TABLE #TmpEnActions;
CREATE TABLE #TmpEnActions (MergeAction nvarchar(10));

MERGE DownloadAttachments AS tgt
USING (
    SELECT DownloadContentId, ContentTypeCode, FileEntryId, LinkUrl, Title, SortOrder FROM #ExpectedEn_Dedup
) AS src
ON  tgt.DownloadContentId = src.DownloadContentId
AND tgt.ContentTypeCode   = src.ContentTypeCode
AND ISNULL(tgt.FileEntryId, '00000000-0000-0000-0000-000000000000') = ISNULL(src.FileEntryId, '00000000-0000-0000-0000-000000000000')
AND ISNULL(tgt.LinkUrl,'') = ISNULL(src.LinkUrl,'')
WHEN MATCHED THEN
    UPDATE SET 
        tgt.Title        = src.Title,
        tgt.SortOrder    = src.SortOrder,
        tgt.UpdatedTime  = @Now,
        tgt.UpdatedUserId= @AdminUserId
WHEN NOT MATCHED BY TARGET THEN
    INSERT (DownloadContentId, FileEntryId, ContentTypeCode, Title, LinkUrl, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder)
    VALUES (src.DownloadContentId, src.FileEntryId, src.ContentTypeCode, src.Title, src.LinkUrl, @Now, @AdminUserId, @Now, @AdminUserId, src.SortOrder)
OUTPUT $action INTO #TmpEnActions;

DECLARE @EnInserted INT = (SELECT COUNT(*) FROM #TmpEnActions WHERE MergeAction = 'INSERT');
DECLARE @EnUpdated  INT = (SELECT COUNT(*) FROM #TmpEnActions WHERE MergeAction = 'UPDATE');
PRINT CONCAT('✓ en 附件: 新增 ', @EnInserted, ' 筆、更新 ', @EnUpdated, ' 筆');

-- 嚴格同步: 刪除 en 多餘附件
IF @StrictSync = 1
BEGIN
    DELETE tgt
    FROM DownloadAttachments tgt
    JOIN #Map m ON m.DownloadContentId_En = tgt.DownloadContentId
    LEFT JOIN #ExpectedEn_Dedup src
      ON  tgt.DownloadContentId = src.DownloadContentId
      AND tgt.ContentTypeCode   = src.ContentTypeCode
      AND ISNULL(tgt.FileEntryId,'00000000-0000-0000-0000-000000000000') = ISNULL(src.FileEntryId,'00000000-0000-0000-0000-000000000000')
      AND ISNULL(tgt.LinkUrl,'') = ISNULL(src.LinkUrl,'')
    WHERE src.DownloadContentId IS NULL;
    PRINT '✓ 嚴格同步: 已刪除 en 多餘附件';
END

COMMIT TRAN;

/* ----------------------------------------------------
   額外: 針對仍為空或空白的 Title 再補齊 (保險機制)
---------------------------------------------------- */
;WITH CTE_Att AS (
    SELECT da.DownloadAttachmentId, da.DownloadContentId, da.ContentTypeCode, da.Title, da.FileEntryId, da.LinkUrl, dc.Title AS ContentTitle
    FROM DownloadAttachments da
    JOIN DownloadContents dc ON da.DownloadContentId = dc.DownloadContentId
)
UPDATE CTE_Att
SET Title = LEFT(COALESCE(NULLIF(Title,''), ContentTitle, '附件'), 100)
WHERE (Title IS NULL OR LTRIM(RTRIM(Title)) = '');

/* ----------------------------------------------------
   統計 / 驗證
---------------------------------------------------- */
PRINT '========================================';
PRINT '結果統計:';
SELECT '來源文章數 (zh_tw)' AS Item, COUNT(*) AS Cnt FROM #SourceZh
UNION ALL SELECT '成功映射 Download/Content 數', COUNT(*) FROM #Map
UNION ALL SELECT '預期 zh 附件數', COUNT(*) FROM #ExpectedZh
UNION ALL SELECT '無對應 FileEntry 檔案數', COUNT(*) FROM #MissingFileEntry;

PRINT '缺失 FileEntry 示例 (前 10 筆):';
SELECT TOP 10 * FROM #MissingFileEntry ORDER BY SourceSid, sequence;

PRINT 'zh-TW 前 5 筆附件 (排序預覽):';
SELECT TOP 5 d.DownloadId, dc.DownloadContentId, dc.Title, da.DownloadAttachmentId, da.ContentTypeCode, da.FileEntryId, da.LinkUrl, da.SortOrder
FROM DownloadAttachments da
JOIN DownloadContents dc ON da.DownloadContentId = dc.DownloadContentId AND dc.LocaleCode='zh-TW'
JOIN Downloads d ON dc.DownloadId = d.DownloadId
ORDER BY d.DownloadId, da.SortOrder;

PRINT '✅ 19. Downloads 附件修正補丁完成';
PRINT '完成時間: ' + CONVERT(varchar(19), SYSDATETIME(), 120);
PRINT '========================================';
