-- ========================================
-- Downloads 完整遷移腳本 (統一版本)
-- 來源: EcoCampus_Maria3.custom_article (type='file_dl'), custom_article_file_link
-- 目標: Downloads, DownloadContents, DownloadAttachments
-- 建立日期: 2025-07-29
-- 版本: v1.0 - 完整統一版本
-- ========================================

-- ========================================
-- 環境設定區 (依環境調整以下設定)
-- ========================================
-- 目標資料庫設定 (請依環境修改)
-- 測試環境: EcoCampus_PreProduction
-- 正式環境: Ecocampus (或其他正式環境名稱)
USE EcoCampus_PreProduction;

-- 來源資料庫設定 (通常固定為舊系統)
-- DECLARE @SourceDB NVARCHAR(100) = 'EcoCampus_Maria3';
-- ========================================
GO

PRINT '========================================';
PRINT 'Downloads 遷移腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- ========================================
-- 0. 清空 Downloads 相關資料表
-- ========================================
PRINT '步驟 0: 清空 Downloads 相關資料表...';

-- 停用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DownloadAttachments')
    ALTER TABLE DownloadAttachments NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DownloadContents')
    ALTER TABLE DownloadContents NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Downloads')
    ALTER TABLE Downloads NOCHECK CONSTRAINT ALL;

-- 清空資料 (從子表到主表的順序)
DELETE FROM DownloadAttachments;
DELETE FROM DownloadContents;
DELETE FROM Downloads;

-- 重新啟用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DownloadAttachments')
    ALTER TABLE DownloadAttachments WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DownloadContents')
    ALTER TABLE DownloadContents WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Downloads')
    ALTER TABLE Downloads WITH CHECK CHECK CONSTRAINT ALL;

-- 重置自增欄位
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Downloads'))
    DBCC CHECKIDENT ('Downloads', RESEED, 0);

PRINT '✓ Downloads 相關資料表已清空';
GO

-- ========================================
-- 1. 插入 Downloads 主表資料
-- ========================================
PRINT '步驟 1: 遷移 Downloads 主表資料...';

INSERT INTO Downloads (PublishDate, TagCode, ExternalLink, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
SELECT 
    DATEADD(SECOND, ca.createdate, '1970-01-01') as PublishDate,  -- Unix timestamp 轉換
    -- Tag 對應規則 (根據來源的 tag_sid 對應到新系統)
    CASE 
        WHEN ca.tag_sid = 4 THEN 'checklist'
        WHEN ca.tag_sid = 20 THEN 'e_handbook'
        WHEN ca.tag_sid = 22 THEN 'award_ceremony'
        WHEN ca.tag_sid = 30 THEN 'workshop'
        WHEN ca.tag_sid = 31 THEN 'briefing'
        WHEN ca.tag_sid = 43 THEN 'featured_videos'
        WHEN ca.tag_sid = 54 THEN 'social_resources'
        ELSE 'other'

    END as TagCode,
    '#' as ExternalLink,                -- 預設外部連結
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,                 -- 預設管理員 ID
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId,                 -- 預設管理員 ID
    1 as Status,                        -- 啟用狀態
    0 as SortOrder                      -- 預設排序
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'file_dl'
  AND ca.lan = 'zh_tw'                 -- 只處理中文版，避免重複
ORDER BY ca.createdate;

DECLARE @DownloadsCount INT = @@ROWCOUNT;
PRINT '✓ Downloads 主表遷移完成: ' + CAST(@DownloadsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 2. 插入 DownloadContents 內容資料 (中文版)
-- ========================================
PRINT '步驟 2: 遷移 DownloadContents 中文內容...';

WITH SourceData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY createdate) as rn,
        sid, title, COALESCE(explanation, '') as explanation 
    FROM EcoCampus_Maria3.dbo.custom_article 
    WHERE type = 'file_dl' AND lan = 'zh_tw'
),
TargetData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY DownloadId DESC) as rn,
        DownloadId 
    FROM Downloads 
    WHERE CreatedTime > DATEADD(MINUTE, -5, SYSDATETIME())
)
INSERT INTO DownloadContents (DownloadId, LocaleCode, Title, Description, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    t.DownloadId,
    'zh-TW' as LocaleCode,
    s.title,
    s.explanation,
    NULL as BannerFileId,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId
FROM SourceData s 
INNER JOIN TargetData t ON s.rn = t.rn;

DECLARE @ContentsZhCount INT = @@ROWCOUNT;
PRINT '✓ DownloadContents 中文版遷移完成: ' + CAST(@ContentsZhCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 3. 插入 DownloadContents 內容資料 (英文版)
-- ========================================
PRINT '步驟 3: 遷移 DownloadContents 英文內容...';

INSERT INTO DownloadContents (DownloadId, LocaleCode, Title, Description, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    DownloadId,
    'en' as LocaleCode,
    Title,  -- 複製中文內容到英文版
    Description,
    BannerFileId,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId
FROM DownloadContents 
WHERE LocaleCode = 'zh-TW'
  AND CreatedTime > DATEADD(MINUTE, -5, SYSDATETIME());

DECLARE @ContentsEnCount INT = @@ROWCOUNT;
PRINT '✓ DownloadContents 英文版遷移完成: ' + CAST(@ContentsEnCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 4. 插入 DownloadAttachments 附件資料 (PDF)
-- ========================================
PRINT '步驟 4: 遷移 PDF 檔案附件...';

WITH SourceData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ca.createdate) as rn,
        ca.sid, afl.fileinfo, afl.sequence 
    FROM EcoCampus_Maria3.dbo.custom_article ca
    INNER JOIN EcoCampus_Maria3.dbo.custom_article_file_link afl ON ca.sid = afl.table_sid
    WHERE ca.type = 'file_dl' AND ca.lan = 'zh_tw' AND afl.fileinfo IS NOT NULL
),
TargetData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY dc.DownloadContentId) as rn,
        dc.DownloadContentId 
    FROM DownloadContents dc 
    WHERE dc.CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME()) AND dc.LocaleCode = 'zh-TW'
)
INSERT INTO DownloadAttachments (DownloadContentId, FileEntryId, ContentTypeCode, Title, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder)
SELECT 
    t.DownloadContentId,
    fe.Id as FileEntryId,
    'file' as ContentTypeCode,
    LEFT(fe.OriginalFileName, 100) as Title,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId,
    s.sequence as SortOrder
FROM SourceData s 
INNER JOIN TargetData t ON s.rn = t.rn
INNER JOIN [dbo].[FileEntry] fe ON fe.FileName = s.fileinfo;

DECLARE @AttachmentsPdfCount INT = @@ROWCOUNT;
PRINT '✓ PDF 檔案附件遷移完成: ' + CAST(@AttachmentsPdfCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 5. 插入 DownloadAttachments 附件資料 (ODT)
-- ========================================
PRINT '步驟 5: 遷移 ODT 檔案附件...';

WITH SourceData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ca.createdate) as rn,
        ca.sid, afl.fileinfo_odt, afl.sequence 
    FROM EcoCampus_Maria3.dbo.custom_article ca
    INNER JOIN EcoCampus_Maria3.dbo.custom_article_file_link afl ON ca.sid = afl.table_sid
    WHERE ca.type = 'file_dl' AND ca.lan = 'zh_tw' 
      AND afl.type = 'two_file' AND afl.fileinfo_odt IS NOT NULL
),
TargetData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY dc.DownloadContentId) as rn,
        dc.DownloadContentId 
    FROM DownloadContents dc 
    WHERE dc.CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME()) AND dc.LocaleCode = 'zh-TW'
)
INSERT INTO DownloadAttachments (DownloadContentId, FileEntryId, ContentTypeCode, Title, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder)
SELECT 
    t.DownloadContentId,
    fe.Id as FileEntryId,
    'file' as ContentTypeCode,
    LEFT(fe.OriginalFileName, 100) as Title,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId,
    s.sequence + 1 as SortOrder  -- ODT 檔案排序稍後
FROM SourceData s 
INNER JOIN TargetData t ON s.rn = t.rn
INNER JOIN [dbo].[FileEntry] fe ON fe.FileName = s.fileinfo_odt;

DECLARE @AttachmentsOdtCount INT = @@ROWCOUNT;
PRINT '✓ ODT 檔案附件遷移完成: ' + CAST(@AttachmentsOdtCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 5.1 插入 DownloadAttachments (Link / Video 類型)
PRINT '步驟 5.1: 遷移 Link (video) 類型附件...';

-- 假設來源 link 類型資料存在於 custom_article_file_link 並以 type='link' 區分，URL 欄位為 link_url
-- 1. 僅針對 zh-TW 內容建立 (後續 5.2 再複製到英文)
-- 2. FileEntryId 對於外部連結 / 影片連結為 NULL (假設資料表允許 NULL)，以 LinkUrl 欄位保存實際 URL
-- 3. SortOrder: 為避免與 PDF/ODT 衝突，於原 sequence 基礎上加 50 (可按需求調整)
-- 4. 若需更嚴謹排序，可改為: 取得該 DownloadContent 現有最大 SortOrder 再加 1
WITH SourceLink AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ca.createdate) AS rn,
        ca.sid,
        ca.title,
        afl.link_url,
        COALESCE(afl.sequence, 0) AS sequence
    FROM EcoCampus_Maria3.dbo.custom_article ca
    INNER JOIN EcoCampus_Maria3.dbo.custom_article_file_link afl ON ca.sid = afl.table_sid
    WHERE ca.type = 'file_dl'
      AND ca.lan = 'zh_tw'
      AND afl.type = 'link'
      AND afl.link_url IS NOT NULL
), TargetZh AS (
    SELECT ROW_NUMBER() OVER (ORDER BY dc.DownloadContentId) AS rn, dc.DownloadContentId
    FROM DownloadContents dc
    WHERE dc.CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME()) AND dc.LocaleCode = 'zh-TW'
)
INSERT INTO DownloadAttachments (DownloadContentId, FileEntryId, ContentTypeCode, Title, LinkUrl, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder)
SELECT 
    t.DownloadContentId,
    NULL AS FileEntryId,
    'video' AS ContentTypeCode,
    LEFT(s.title, 100) AS Title,
    s.link_url AS LinkUrl,
    SYSDATETIME() AS CreatedTime,
    1 AS CreatedUserId,
    SYSDATETIME() AS UpdatedTime,
    1 AS UpdatedUserId,
    s.sequence + 50 AS SortOrder
FROM SourceLink s
INNER JOIN TargetZh t ON s.rn = t.rn;

DECLARE @AttachmentsLinkCount INT = @@ROWCOUNT;
PRINT '✓ Link / Video 類型附件遷移完成: ' + CAST(@AttachmentsLinkCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 5.2 複製附件到英文語系 (讓英文語系內容也擁有同一組附件)
-- 說明:
--  1. 英文語系目前的內容是由中文複製而來，但附件僅綁在 zh-TW 的 DownloadContentId 下
--  2. 新系統需求: 每個語系的 DownloadContent 需要各自擁有附件 (UI / API 讀取語系內容時可直接取到附件)
--  3. 作法: 以 DownloadId 對應 zh-TW 與 en 的 DownloadContent，複製附件記錄
--  4. 避免重複: 以 LEFT JOIN 判斷英文語系是否已存在相同 FileEntry 的附件
--  5. Title 直接複製 (若未來有英文翻譯，可再行更新)
PRINT '步驟 5.2: 複製附件到英文語系...';

-- 新增 LinkUrl 欄位一併複製 (PDF/ODT 為 NULL, link/video 會有值)
INSERT INTO DownloadAttachments (DownloadContentId, FileEntryId, ContentTypeCode, Title, LinkUrl, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder)
SELECT 
    dcen.DownloadContentId,
    da.FileEntryId,
    da.ContentTypeCode,
    da.Title,
    da.LinkUrl,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId,
    da.SortOrder
FROM DownloadAttachments da
INNER JOIN DownloadContents dczh ON da.DownloadContentId = dczh.DownloadContentId AND dczh.LocaleCode = 'zh-TW'
INNER JOIN DownloadContents dcen ON dczh.DownloadId = dcen.DownloadId AND dcen.LocaleCode = 'en'
LEFT JOIN DownloadAttachments da_en ON da_en.DownloadContentId = dcen.DownloadContentId AND da_en.FileEntryId = da.FileEntryId
WHERE da_en.DownloadAttachmentId IS NULL;  -- 避免重複執行時重複插入

DECLARE @AttachmentsEnCloneCount INT = @@ROWCOUNT;
PRINT '✓ 英文語系附件複製完成: ' + CAST(@AttachmentsEnCloneCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 6. 遷移結果統計和驗證
-- ========================================
PRINT '========================================';
PRINT '遷移結果統計:';
PRINT '========================================';

SELECT 
    '下載資源遷移完成統計' as [遷移項目],
    (SELECT COUNT(*) FROM Downloads WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())) as [Downloads主表],
    (SELECT COUNT(*) FROM DownloadContents WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME()) AND LocaleCode = 'zh-TW') as [中文內容],
    (SELECT COUNT(*) FROM DownloadContents WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME()) AND LocaleCode = 'en') as [英文內容],
    (SELECT COUNT(*) FROM DownloadAttachments WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())) as [檔案附件];

-- ========================================
-- 7. 顯示遷移結果範例
-- ========================================
PRINT '遷移結果範例 (前5筆):';

SELECT TOP 5
    d.DownloadId as [下載ID],
    d.TagCode as [標籤代碼],
    dtt.Label as [標籤名稱],
    dc.Title as [標題],
    LEFT(COALESCE(dc.Description, ''), 30) + '...' as [描述預覽],
    dc.LocaleCode as [語言],
    (SELECT COUNT(*) FROM DownloadAttachments da 
     INNER JOIN DownloadContents dc2 ON da.DownloadContentId = dc2.DownloadContentId 
     WHERE dc2.DownloadId = d.DownloadId) as [附件數量]
FROM Downloads d
INNER JOIN DownloadTags dt ON d.TagCode = dt.TagCode
INNER JOIN DownloadTagTranslations dtt ON dt.DownloadTagId = dtt.DownloadTagId AND dtt.LocaleCode = 'zh-TW'
INNER JOIN DownloadContents dc ON d.DownloadId = dc.DownloadId
WHERE d.CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())
ORDER BY d.DownloadId, dc.LocaleCode;

-- ========================================
-- 8. 檔案對應驗證範例
-- ========================================
PRINT '檔案對應驗證範例 (前5筆):';

SELECT TOP 5
    da.DownloadAttachmentId as [附件ID],
    dc.Title as [下載標題],
    da.ContentTypeCode as [檔案類型],
    fe.FileName as [舊檔名],
    da.FileEntryId as [新GUID],
    da.SortOrder as [排序]
FROM DownloadAttachments da
INNER JOIN DownloadContents dc ON da.DownloadContentId = dc.DownloadContentId
INNER JOIN [dbo].[FileEntry] fe ON da.FileEntryId = fe.Id
WHERE da.CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())
  AND dc.LocaleCode = 'zh-TW'
ORDER BY da.DownloadAttachmentId;

-- ========================================
-- 9. 完成訊息
-- ========================================
PRINT '========================================';
PRINT '✅ Downloads 遷移腳本執行完成！';
PRINT '檔案對應機制:';
PRINT '- 舊檔名 (FileEntry.FileName) → 新 GUID (FileEntry.Id)';
PRINT '- PDF 檔案: custom_article_file_link.fileinfo';
PRINT '- ODT 檔案: custom_article_file_link.fileinfo_odt';
PRINT '- 雙檔案系統支援完整';
PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

