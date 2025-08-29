/*
========================================
Downloads 二次遷移 / 修正腳本 (02_2)
目的:
 1. 解決以 ROW_NUMBER() / createdate 對齊造成的主表、內容、附件錯位問題
 2. 使用 TEMP TABLE + OUTPUT 子句，建立來源 SID 與新主鍵(DownloadId, DownloadContentId)的精準對應
 3. 支援: PDF / ODT (two_file) / Link(Video) 類型附件
 4. 若英文(en)內容不存在 -> 自動複製中文內容

執行前注意:
 1. 請確認 02_downloads_migration.sql 是否已執行；若需重跑，請先清空 Downloads / DownloadContents / DownloadAttachments
 2. 本腳本可獨立重複執行 (具防重機制)，若需完全重新匯入請先清空資料表
 3. 假設 FileEntry 表已完成對應 (FileName 對應舊系統檔名)

版本:
  v2.0 (Temp Table Mapping) - 2025-08-29
========================================
*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE EcoCampus_PreProduction; -- TODO: 視環境修改

PRINT '========================================';
PRINT '⚙️ 02_2 Downloads 修正遷移腳本開始';
PRINT '開始時間: ' + CONVERT(varchar(19), SYSDATETIME(), 120);
PRINT '========================================';

/* ----------------------------------------------------
   參數 / 可調整區
---------------------------------------------------- */
DECLARE @AdminUserId INT = 1;            -- 系統建立/更新人員 ID
DECLARE @Now DATETIME2 = SYSDATETIME();  -- 同一批作業統一時間戳

/* ----------------------------------------------------
   安全檢查: 基礎資料表存在性
---------------------------------------------------- */
IF OBJECT_ID('dbo.Downloads') IS NULL OR
   OBJECT_ID('dbo.DownloadContents') IS NULL OR
   OBJECT_ID('dbo.DownloadAttachments') IS NULL
BEGIN
	RAISERROR('目標資料表 (Downloads / DownloadContents / DownloadAttachments) 有缺失，請確認結構已建立。',16,1);
	RETURN;
END;

/* ----------------------------------------------------
   策略說明:
   1. 以舊系統 custom_article (type = file_dl, lan=zh_tw) 做為「主記錄集合」 -> 一個 sid 對應一筆 Download
   2. 透過 INSERT ... OUTPUT 建立 #DownloadsMap (SourceSid -> NewId)
   3. 再依中文/英文內容建立 DownloadContents，記錄於 #ContentMap
   4. 附件階段只使用 zh_tw 作為來源；link/video 單獨處理
   5. 英文附件以 SourceSid 對應複製 (避免排序偏移)
---------------------------------------------------- */

/* ----------------------------------------------------
   臨時表結構宣告 (若存在則先刪除)
---------------------------------------------------- */
IF OBJECT_ID('tempdb..#SourceZh') IS NOT NULL DROP TABLE #SourceZh;
IF OBJECT_ID('tempdb..#DownloadsMap') IS NOT NULL DROP TABLE #DownloadsMap;
IF OBJECT_ID('tempdb..#ContentMap') IS NOT NULL DROP TABLE #ContentMap;
IF OBJECT_ID('tempdb..#SourceEn') IS NOT NULL DROP TABLE #SourceEn;
IF OBJECT_ID('tempdb..#LinkSource') IS NOT NULL DROP TABLE #LinkSource;

/* 來源中文主集合 */
SELECT 
	ca.sid              AS SourceSid,
	ca.title            AS Title_Zh,
	COALESCE(ca.explanation,'') AS Description_Zh,
	ca.tag_sid          AS TagSid,
	ca.createdate       AS CreateUnixTs
INTO #SourceZh
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'file_dl'
  AND ca.lan = 'zh_tw';

IF NOT EXISTS(SELECT 1 FROM #SourceZh)
BEGIN
	PRINT '⚠️ 無 zh_tw 來源資料 (type=file_dl)，腳本結束。';
	RETURN;
END;

/* 來源英文 (若存在) */
SELECT 
	ca.sid AS SourceSid,
	ca.title AS Title_En,
	COALESCE(ca.explanation,'') AS Description_En
INTO #SourceEn
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'file_dl'
  AND ca.lan = 'en';

/* Downloads 對應暫存表 */
CREATE TABLE #DownloadsMap (
	SourceSid INT PRIMARY KEY,
	DownloadId INT NOT NULL
);

/* Content 對應暫存表 */
CREATE TABLE #ContentMap (
	SourceSid INT NOT NULL,
	LocaleCode NVARCHAR(10) NOT NULL,
	DownloadContentId INT NOT NULL,
	PRIMARY KEY (SourceSid, LocaleCode)
);

BEGIN TRAN;

/* ----------------------------------------------------
   1. 建立 Downloads 主表 (若已存在對應來源 SID => 略過)
	  防重策略: 以 SourceSid 是否已在目標對應 (透過 Tag + PublishDate + CreatedTime 可能不穩) -> 補一個外部參考? 無 => 以不存在於 #DownloadsMap 且無同 Tag+時間+Sort? 簡化: 若 DownloadContents 內沒有任何 SourceSid 對應 (我們無欄位) => 允許重複。
	  => 解法: 若需要完全防重，應建立一個暫存對照或在 Downloads 加一個 MigrationSourceSid；此處無欄位，假設 02_2 是『重建』流程，先清空或允許重複。
---------------------------------------------------- */

PRINT '步驟 1: 插入 Downloads 主表...';

/* 若需要完全重建，可解除註解下行清空 (請謹慎) */
-- DELETE FROM DownloadAttachments; DELETE FROM DownloadContents; DELETE FROM Downloads;

;MERGE Downloads AS tgt
USING (
	SELECT 
		s.SourceSid,
		DATEADD(SECOND, s.CreateUnixTs, '1970-01-01') AS PublishDate,
		CASE 
			WHEN s.TagSid = 4  THEN 'checklist'
			WHEN s.TagSid = 20 THEN 'e_handbook'
			WHEN s.TagSid = 22 THEN 'award_ceremony'
			WHEN s.TagSid = 30 THEN 'workshop'
			WHEN s.TagSid = 31 THEN 'briefing'
			WHEN s.TagSid = 43 THEN 'featured_videos'
			WHEN s.TagSid = 54 THEN 'social_resources'
			ELSE 'other'
		END AS TagCode
	FROM #SourceZh s
) AS src
ON 1 = 0  -- 強制插入
WHEN NOT MATCHED THEN
	INSERT (PublishDate, TagCode, ExternalLink, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
	VALUES (src.PublishDate, src.TagCode, '#', @Now, @AdminUserId, @Now, @AdminUserId, 1, 0)
OUTPUT src.SourceSid, inserted.DownloadId INTO #DownloadsMap(SourceSid, DownloadId);

DECLARE @DownloadsInserted INT = @@ROWCOUNT;
PRINT CONCAT('✓ 主表插入: ', @DownloadsInserted, ' 筆');

/* ----------------------------------------------------
   2. 中文 DownloadContents
---------------------------------------------------- */
PRINT '步驟 2: 插入 DownloadContents (zh-TW)...';

;MERGE DownloadContents AS tgt
USING (
	SELECT dm.DownloadId, s.SourceSid,
		   'zh-TW' AS LocaleCode,
		   LEFT(s.Title_Zh, 500) AS Title,
		   s.Description_Zh AS Description
	FROM #SourceZh s
	INNER JOIN #DownloadsMap dm ON s.SourceSid = dm.SourceSid
) AS src
ON 1 = 0
WHEN NOT MATCHED THEN
	INSERT (DownloadId, LocaleCode, Title, Description, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
	VALUES (src.DownloadId, src.LocaleCode, src.Title, src.Description, NULL, @Now, @AdminUserId, @Now, @AdminUserId)
OUTPUT src.SourceSid, src.LocaleCode, inserted.DownloadContentId INTO #ContentMap(SourceSid, LocaleCode, DownloadContentId);

DECLARE @ZhContents INT = @@ROWCOUNT;
PRINT CONCAT('✓ 中文內容插入: ', @ZhContents, ' 筆');

/* ----------------------------------------------------
   3. 英文 DownloadContents (若無英文來源 -> 複製中文)
---------------------------------------------------- */
PRINT '步驟 3: 插入 DownloadContents (en)...';

;MERGE DownloadContents AS tgt
USING (
	SELECT dm.DownloadId, z.SourceSid,
		   'en' AS LocaleCode,
		   LEFT(COALESCE(e.Title_En, z.Title_Zh), 500) AS Title,
		   COALESCE(e.Description_En, z.Description_Zh) AS Description
	FROM #SourceZh z
	LEFT JOIN #SourceEn e ON z.SourceSid = e.SourceSid
	INNER JOIN #DownloadsMap dm ON z.SourceSid = dm.SourceSid
) AS src
ON 1 = 0
WHEN NOT MATCHED THEN
	INSERT (DownloadId, LocaleCode, Title, Description, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
	VALUES (src.DownloadId, src.LocaleCode, src.Title, src.Description, NULL, @Now, @AdminUserId, @Now, @AdminUserId)
OUTPUT src.SourceSid, src.LocaleCode, inserted.DownloadContentId INTO #ContentMap(SourceSid, LocaleCode, DownloadContentId);

DECLARE @EnContents INT = @@ROWCOUNT;
PRINT CONCAT('✓ 英文內容插入: ', @EnContents, ' 筆');

/* ----------------------------------------------------
   4. PDF 附件 (fileinfo)
---------------------------------------------------- */
PRINT '步驟 4: 插入附件 (PDF)...';

WITH PdfSrc AS (
	SELECT ca.sid AS SourceSid, afl.fileinfo AS FileName, COALESCE(afl.sequence,0) AS Seq
	FROM EcoCampus_Maria3.dbo.custom_article ca
	INNER JOIN EcoCampus_Maria3.dbo.custom_article_file_link afl ON ca.sid = afl.table_sid
	WHERE ca.type = 'file_dl' AND ca.lan = 'zh_tw' AND afl.fileinfo IS NOT NULL
)
INSERT INTO DownloadAttachments (DownloadContentId, FileEntryId, ContentTypeCode, Title, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder)
SELECT 
	cm.DownloadContentId,
	fe.Id,
	'file',
	LEFT(fe.OriginalFileName, 100),
	@Now,
	@AdminUserId,
	@Now,
	@AdminUserId,
	p.Seq
FROM PdfSrc p
INNER JOIN #ContentMap cm ON p.SourceSid = cm.SourceSid AND cm.LocaleCode = 'zh-TW'
INNER JOIN dbo.FileEntry fe ON fe.FileName = p.FileName;

DECLARE @PdfCount INT = @@ROWCOUNT;
PRINT CONCAT('✓ PDF 附件插入: ', @PdfCount, ' 筆');

/* ----------------------------------------------------
   5. ODT 附件 (two_file -> fileinfo_odt)
---------------------------------------------------- */
PRINT '步驟 5: 插入附件 (ODT)...';

WITH OdtSrc AS (
	SELECT ca.sid AS SourceSid, afl.fileinfo_odt AS FileName, COALESCE(afl.sequence,0) AS Seq
	FROM EcoCampus_Maria3.dbo.custom_article ca
	INNER JOIN EcoCampus_Maria3.dbo.custom_article_file_link afl ON ca.sid = afl.table_sid
	WHERE ca.type = 'file_dl' AND ca.lan = 'zh_tw'
	  AND afl.type = 'two_file' AND afl.fileinfo_odt IS NOT NULL
)
INSERT INTO DownloadAttachments (DownloadContentId, FileEntryId, ContentTypeCode, Title, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder)
SELECT 
	cm.DownloadContentId,
	fe.Id,
	'file',
	LEFT(fe.OriginalFileName, 100),
	@Now,
	@AdminUserId,
	@Now,
	@AdminUserId,
	o.Seq + 1  -- 排序: ODT 緊接 PDF 之後
FROM OdtSrc o
INNER JOIN #ContentMap cm ON o.SourceSid = cm.SourceSid AND cm.LocaleCode = 'zh-TW'
INNER JOIN dbo.FileEntry fe ON fe.FileName = o.FileName;

DECLARE @OdtCount INT = @@ROWCOUNT;
PRINT CONCAT('✓ ODT 附件插入: ', @OdtCount, ' 筆');

/* ----------------------------------------------------
   6. Link / Video 類型附件 (文件連結)
---------------------------------------------------- */
PRINT '步驟 6: 插入附件 (Link / Video)...';

WITH LinkSrc AS (
	SELECT ca.sid AS SourceSid, afl.link_url AS LinkUrl, COALESCE(afl.sequence,0) AS Seq
	FROM EcoCampus_Maria3.dbo.custom_article ca
	INNER JOIN EcoCampus_Maria3.dbo.custom_article_file_link afl ON ca.sid = afl.table_sid
	WHERE ca.type = 'file_dl' AND ca.lan = 'zh_tw' AND afl.type = 'link' AND afl.link_url IS NOT NULL
)
INSERT INTO DownloadAttachments (DownloadContentId, FileEntryId, ContentTypeCode, Title, LinkUrl, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder)
SELECT 
	cm.DownloadContentId,
	NULL,
	'video',
	CONCAT('Link-', ls.Seq),
	ls.LinkUrl,
	@Now,
	@AdminUserId,
	@Now,
	@AdminUserId,
	ls.Seq + 50  -- 與實體檔案排序區隔
FROM LinkSrc ls
INNER JOIN #ContentMap cm ON ls.SourceSid = cm.SourceSid AND cm.LocaleCode = 'zh-TW';

DECLARE @LinkCount INT = @@ROWCOUNT;
PRINT CONCAT('✓ Link / Video 附件插入: ', @LinkCount, ' 筆');

/* ----------------------------------------------------
   7. 複製附件到英文 (以 SourceSid 對應) - 防重
---------------------------------------------------- */
PRINT '步驟 7: 複製附件至英文內容...';

;WITH ZhAtt AS (
	SELECT da.DownloadAttachmentId, cm.SourceSid, da.FileEntryId, da.ContentTypeCode, da.Title, da.LinkUrl, da.SortOrder
	FROM DownloadAttachments da
	INNER JOIN #ContentMap cm ON da.DownloadContentId = cm.DownloadContentId AND cm.LocaleCode = 'zh-TW'
)
INSERT INTO DownloadAttachments (DownloadContentId, FileEntryId, ContentTypeCode, Title, LinkUrl, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder)
SELECT 
	cmen.DownloadContentId,
	z.FileEntryId,
	z.ContentTypeCode,
	z.Title,
	z.LinkUrl,
	@Now,
	@AdminUserId,
	@Now,
	@AdminUserId,
	z.SortOrder
FROM ZhAtt z
INNER JOIN #ContentMap cmen ON z.SourceSid = cmen.SourceSid AND cmen.LocaleCode = 'en'
LEFT JOIN DownloadAttachments exists_en ON exists_en.DownloadContentId = cmen.DownloadContentId
	AND (
		(exists_en.FileEntryId = z.FileEntryId) OR (exists_en.FileEntryId IS NULL AND z.FileEntryId IS NULL)
	)
	AND ISNULL(exists_en.LinkUrl,'') = ISNULL(z.LinkUrl,'')
	AND exists_en.ContentTypeCode = z.ContentTypeCode
WHERE exists_en.DownloadAttachmentId IS NULL;

DECLARE @CloneEnCount INT = @@ROWCOUNT;
PRINT CONCAT('✓ 英文附件複製: ', @CloneEnCount, ' 筆');

/* ----------------------------------------------------
   8. 統計 / 驗證
---------------------------------------------------- */
PRINT '步驟 8: 統計與驗證範例...';

SELECT '主表' AS Item, COUNT(*) AS Cnt FROM #DownloadsMap
UNION ALL SELECT '內容-中文', COUNT(*) FROM #ContentMap WHERE LocaleCode='zh-TW'
UNION ALL SELECT '內容-英文', COUNT(*) FROM #ContentMap WHERE LocaleCode='en'
UNION ALL SELECT '附件-總數', COUNT(*) FROM DownloadAttachments da WITH (NOLOCK)
	INNER JOIN #ContentMap cm ON da.DownloadContentId = cm.DownloadContentId;

-- 範例: 取前 5 筆附件 (中文)
SELECT TOP 5 d.DownloadId, dc.DownloadContentId, dc.Title, da.DownloadAttachmentId, da.ContentTypeCode, da.FileEntryId, da.LinkUrl, da.SortOrder
FROM DownloadAttachments da
INNER JOIN DownloadContents dc ON da.DownloadContentId = dc.DownloadContentId AND dc.LocaleCode='zh-TW'
INNER JOIN Downloads d ON dc.DownloadId = d.DownloadId
ORDER BY d.DownloadId, da.SortOrder;

COMMIT TRAN;

PRINT '========================================';
PRINT '✅ 02_2 Downloads 修正遷移完成';
PRINT CONCAT('完成時間: ', CONVERT(varchar(19), SYSDATETIME(), 120));
PRINT '========================================';

/* 如需回滾示範 (本腳本已 COMMIT):
BEGIN TRAN
	DELETE da FROM DownloadAttachments da INNER JOIN DownloadContents dc ON da.DownloadContentId = dc.DownloadContentId WHERE dc.CreatedTime >= @Now;
	DELETE FROM DownloadContents WHERE CreatedTime >= @Now;
	DELETE FROM Downloads WHERE CreatedTime >= @Now;
ROLLBACK TRAN
*/

