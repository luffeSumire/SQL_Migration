-- ========================================
-- Articles 完整遷移腳本 (統一版本)
-- 來源: EcoCampus_Maria3.custom_news, custom_article (type='news'), custom_article_file_link
-- 目標: Articles, ArticleContents, ArticleAttachments
-- 建立日期: 2025-07-29
-- 版本: v1.0 - 完整統一版本
-- ========================================

-- ========================================
-- 環境設定區 (依環境調整以下設定)
-- ========================================
-- 目標資料庫設定 (請依環境修改)
-- 測試環境: Ecocampus_PreProduction
-- 正式環境: Ecocampus (或其他正式環境名稱)
-- ========================================
-- 資料庫連線設定 (請依環境修改)
-- ========================================
USE Ecocampus_PreProduction;

-- 來源資料庫設定 (通常固定為舊系統)
-- DECLARE @SourceDB NVARCHAR(100) = 'EcoCampus_Maria3';
-- ========================================
GO

-- 開始交易以確保資料完整性
BEGIN TRANSACTION ArticlesMigration;

-- 錯誤處理設定
SET XACT_ABORT ON;
SET NOCOUNT ON;

PRINT '========================================';
PRINT 'Articles 遷移腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- ========================================
-- 1. 插入 Articles 主表資料 (from custom_news)
-- ========================================
PRINT '步驟 1: 遷移 custom_news 到 Articles 主表...';

INSERT INTO Articles (PublishDate, TagCode, FeaturedStatus, Author, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
SELECT 
    -- 處理發布日期 (優先使用 startdate，否則使用 createdate)
    CASE 
        WHEN cn.startdate IS NOT NULL AND cn.startdate != '' AND ISDATE(cn.startdate) = 1 
        THEN CAST(cn.startdate AS DATETIME2)
        ELSE DATEADD(SECOND, cn.createdate, '1970-01-01')
    END as PublishDate,
    
    -- Tag 對應規則 (custom_news.type 對應到新系統 ArticleTags)
    CASE 
        WHEN cn.type = 'certification' THEN '1'     -- 認證
        WHEN cn.type = 'activity' THEN '3'          -- 活動
        WHEN cn.type = 'international' THEN '4'     -- 國際
        WHEN cn.type = 'release' THEN '2'           -- 校園
        WHEN cn.type = 'other' THEN '5'             -- 其他
        ELSE '5'                                    -- 預設為其他
    END as TagCode,
    
    CASE WHEN cn.is_home = 1 THEN 1 ELSE 0 END as FeaturedStatus,  -- 首頁顯示
    COALESCE(cn.createuser, 'system') as Author,                    -- 作者
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,                 -- 預設管理員 ID
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId,                 -- 預設管理員 ID
    CASE WHEN cn.is_show = 1 THEN 1 ELSE 0 END as Status,         -- 顯示狀態
    COALESCE(cn.sequence, 0) as SortOrder                          -- 排序
FROM EcoCampus_Maria3.dbo.custom_news cn
WHERE cn.lan = 'zh_tw'                 -- 只處理中文版，避免重複
ORDER BY cn.createdate;

DECLARE @NewsCount INT = @@ROWCOUNT;
PRINT '✓ custom_news 遷移完成: ' + CAST(@NewsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 2. 插入 Articles 主表資料 (from custom_article type='news')
-- ========================================
PRINT '步驟 2: 遷移 custom_article (news) 到 Articles 主表...';

INSERT INTO Articles (PublishDate, TagCode, FeaturedStatus, Author, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
SELECT 
    -- 處理發布日期
    CASE 
        WHEN ca.startdate IS NOT NULL AND ca.startdate != '' AND ISDATE(ca.startdate) = 1 
        THEN CAST(ca.startdate AS DATETIME2)
        ELSE DATEADD(SECOND, ca.createdate, '1970-01-01')
    END as PublishDate,
    
    '2' as TagCode,                     -- 所有 custom_article news 都歸類為校園新聞
    CASE WHEN ca.is_home = 1 THEN 1 ELSE 0 END as FeaturedStatus,
    COALESCE(ca.createuser, 'system') as Author,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId,
    CASE WHEN ca.is_show = 1 THEN 1 ELSE 0 END as Status,
    COALESCE(ca.sequence, 0) as SortOrder
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'news' 
  AND ca.lan = 'zh_tw'                 -- 只處理中文版
ORDER BY ca.createdate;

DECLARE @ArticleNewsCount INT = @@ROWCOUNT;
PRINT '✓ custom_article (news) 遷移完成: ' + CAST(@ArticleNewsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 3. 插入 ArticleContents 內容資料 (custom_news 中文版)
-- ========================================
PRINT '步驟 3: 遷移 custom_news ArticleContents 中文內容...';

WITH SourceData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY createdate) as rn,
        sid, title, COALESCE(explanation, '') as explanation,
        COALESCE(link, '') as link_info
    FROM EcoCampus_Maria3.dbo.custom_news 
    WHERE lan = 'zh_tw'
),
TargetData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ArticleId DESC) as rn,
        ArticleId 
    FROM Articles 
    WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())
        AND ArticleId <= (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw') + 
                         (SELECT ISNULL(MAX(ArticleId), 0) FROM Articles WHERE CreatedTime <= DATEADD(MINUTE, -10, SYSDATETIME()))
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    t.ArticleId,
    'zh-TW' as LocaleCode,
    s.title,
    -- 結合 explanation 和 link 資訊組成 HTML 內容
    CASE 
        WHEN s.explanation != '' AND s.link_info != '' 
        THEN '<p>' + s.explanation + '</p><p><a href="' + s.link_info + '" target="_blank">相關連結</a></p>'
        WHEN s.explanation != '' 
        THEN '<p>' + s.explanation + '</p>'
        WHEN s.link_info != '' 
        THEN '<p><a href="' + s.link_info + '" target="_blank">相關連結</a></p>'
        ELSE '<p></p>'
    END as CmsHtml,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId
FROM SourceData s 
INNER JOIN TargetData t ON s.rn = t.rn;

DECLARE @NewsContentsZhCount INT = @@ROWCOUNT;
PRINT '✓ custom_news ArticleContents 中文版遷移完成: ' + CAST(@NewsContentsZhCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 4. 插入 ArticleContents 內容資料 (custom_article news 中文版)
-- ========================================
PRINT '步驟 4: 遷移 custom_article (news) ArticleContents 中文內容...';

WITH SourceData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY createdate) as rn,
        sid, title, COALESCE(explanation, '') as explanation,
        COALESCE(link, '') as link_info
    FROM EcoCampus_Maria3.dbo.custom_article 
    WHERE type = 'news' AND lan = 'zh_tw'
),
TargetData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ArticleId DESC) as rn,
        ArticleId 
    FROM Articles 
    WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())
        AND ArticleId > (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw') + 
                        (SELECT ISNULL(MAX(ArticleId), 0) FROM Articles WHERE CreatedTime <= DATEADD(MINUTE, -10, SYSDATETIME()))
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    t.ArticleId,
    'zh-TW' as LocaleCode,
    s.title,
    CASE 
        WHEN s.explanation != '' AND s.link_info != '' 
        THEN '<p>' + s.explanation + '</p><p><a href="' + s.link_info + '" target="_blank">相關連結</a></p>'
        WHEN s.explanation != '' 
        THEN '<p>' + s.explanation + '</p>'
        WHEN s.link_info != '' 
        THEN '<p><a href="' + s.link_info + '" target="_blank">相關連結</a></p>'
        ELSE '<p></p>'
    END as CmsHtml,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId
FROM SourceData s 
INNER JOIN TargetData t ON s.rn = t.rn;

DECLARE @ArticleContentsZhCount INT = @@ROWCOUNT;
PRINT '✓ custom_article (news) ArticleContents 中文版遷移完成: ' + CAST(@ArticleContentsZhCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 5. 插入 ArticleContents 內容資料 (英文版)
-- ========================================
PRINT '步驟 5: 遷移 ArticleContents 英文內容...';

INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    ArticleId,
    'en' as LocaleCode,
    Title,  -- 複製中文內容到英文版
    CmsHtml,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId
FROM ArticleContents 
WHERE LocaleCode = 'zh-TW'
  AND CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME());

DECLARE @ContentsEnCount INT = @@ROWCOUNT;
PRINT '✓ ArticleContents 英文版遷移完成: ' + CAST(@ContentsEnCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 6. 插入 ArticleAttachments 附件資料 (custom_news)
-- ========================================
PRINT '步驟 6: 遷移 custom_news 檔案附件...';

WITH SourceData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY cn.createdate) as rn,
        cn.sid, afl.fileinfo, afl.sequence, afl.title,
        COALESCE(afl.link_url, '') as link_url
    FROM EcoCampus_Maria3.dbo.custom_news cn
    INNER JOIN EcoCampus_Maria3.dbo.custom_article_file_link afl ON cn.sid = afl.table_sid 
        AND afl.table_name = 'custom_news'
    WHERE cn.lan = 'zh_tw' AND (afl.fileinfo IS NOT NULL OR afl.link_url IS NOT NULL)
),
TargetData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ac.ArticleContentId) as rn,
        ac.ArticleContentId 
    FROM ArticleContents ac 
    WHERE ac.CreatedTime > DATEADD(MINUTE, -15, SYSDATETIME()) 
        AND ac.LocaleCode = 'zh-TW'
        AND ac.ArticleId <= (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw') + 
                            (SELECT ISNULL(MAX(ArticleId), 0) FROM Articles WHERE CreatedTime <= DATEADD(MINUTE, -15, SYSDATETIME()))
)
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    t.ArticleContentId,
    CASE 
        WHEN s.fileinfo IS NOT NULL THEN fe.Id
        ELSE NULL
    END as FileEntryId,
    CASE 
        WHEN s.fileinfo IS NOT NULL THEN 'file'
        WHEN s.link_url IS NOT NULL THEN 'link'
        ELSE 'other'
    END as ContentTypeCode,
    COALESCE(s.sequence, 0) as SortOrder,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId
FROM SourceData s 
INNER JOIN TargetData t ON s.rn = t.rn
LEFT JOIN [dbo].[FileEntry] fe ON fe.FileName = s.fileinfo
WHERE s.fileinfo IS NOT NULL OR s.link_url IS NOT NULL;

DECLARE @NewsAttachmentsCount INT = @@ROWCOUNT;
PRINT '✓ custom_news 檔案附件遷移完成: ' + CAST(@NewsAttachmentsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 7. 插入 ArticleAttachments 附件資料 (custom_article news)
-- ========================================
PRINT '步驟 7: 遷移 custom_article (news) 檔案附件...';

WITH SourceData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ca.createdate) as rn,
        ca.sid, afl.fileinfo, afl.sequence, afl.title,
        COALESCE(afl.link_url, '') as link_url
    FROM EcoCampus_Maria3.dbo.custom_article ca
    INNER JOIN EcoCampus_Maria3.dbo.custom_article_file_link afl ON ca.sid = afl.table_sid 
        AND afl.table_name = 'custom_article'
    WHERE ca.type = 'news' AND ca.lan = 'zh_tw' AND (afl.fileinfo IS NOT NULL OR afl.link_url IS NOT NULL)
),
TargetData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ac.ArticleContentId) as rn,
        ac.ArticleContentId 
    FROM ArticleContents ac 
    WHERE ac.CreatedTime > DATEADD(MINUTE, -15, SYSDATETIME()) 
        AND ac.LocaleCode = 'zh-TW'
        AND ac.ArticleId > (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw') + 
                           (SELECT ISNULL(MAX(ArticleId), 0) FROM Articles WHERE CreatedTime <= DATEADD(MINUTE, -15, SYSDATETIME()))
)
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    t.ArticleContentId,
    CASE 
        WHEN s.fileinfo IS NOT NULL THEN fe.Id
        ELSE NULL
    END as FileEntryId,
    CASE 
        WHEN s.fileinfo IS NOT NULL THEN 'file'
        WHEN s.link_url IS NOT NULL THEN 'link'
        ELSE 'other'
    END as ContentTypeCode,
    COALESCE(s.sequence, 0) as SortOrder,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId
FROM SourceData s 
INNER JOIN TargetData t ON s.rn = t.rn
LEFT JOIN [dbo].[FileEntry] fe ON fe.FileName = s.fileinfo
WHERE s.fileinfo IS NOT NULL OR s.link_url IS NOT NULL;

DECLARE @ArticleAttachmentsCount INT = @@ROWCOUNT;
PRINT '✓ custom_article (news) 檔案附件遷移完成: ' + CAST(@ArticleAttachmentsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 8. 遷移結果統計和驗證
-- ========================================
PRINT '========================================';
PRINT '遷移結果統計:';
PRINT '========================================';

SELECT 
    '新聞文章遷移完成統計' as [遷移項目],
    (SELECT COUNT(*) FROM Articles WHERE CreatedTime > DATEADD(MINUTE, -15, SYSDATETIME())) as [Articles主表],
    (SELECT COUNT(*) FROM ArticleContents WHERE CreatedTime > DATEADD(MINUTE, -15, SYSDATETIME()) AND LocaleCode = 'zh-TW') as [中文內容],
    (SELECT COUNT(*) FROM ArticleContents WHERE CreatedTime > DATEADD(MINUTE, -15, SYSDATETIME()) AND LocaleCode = 'en') as [英文內容],
    (SELECT COUNT(*) FROM ArticleAttachments WHERE CreatedTime > DATEADD(MINUTE, -15, SYSDATETIME())) as [檔案附件];

-- ========================================
-- 9. 顯示遷移結果範例
-- ========================================
PRINT '遷移結果範例 (前10筆):';

SELECT TOP 10
    a.ArticleId as [文章ID],
    a.TagCode as [標籤代碼],
    att.Label as [標籤名稱],
    ac.Title as [標題],
    LEFT(COALESCE(ac.CmsHtml, ''), 50) + '...' as [內容預覽],
    ac.LocaleCode as [語言],
    a.FeaturedStatus as [首頁顯示],
    (SELECT COUNT(*) FROM ArticleAttachments aa 
     INNER JOIN ArticleContents ac2 ON aa.ArticleContentId = ac2.ArticleContentId 
     WHERE ac2.ArticleId = a.ArticleId) as [附件數量]
FROM Articles a
INNER JOIN ArticleTags at ON CAST(a.TagCode AS INT) = at.ArticleTagId
INNER JOIN ArticleTagTranslations att ON at.ArticleTagId = att.ArticleTagId AND att.LocaleCode = 'zh-TW'
INNER JOIN ArticleContents ac ON a.ArticleId = ac.ArticleId
WHERE a.CreatedTime > DATEADD(MINUTE, -15, SYSDATETIME())
ORDER BY a.ArticleId, ac.LocaleCode;

-- ========================================
-- 10. 檔案對應驗證範例
-- ========================================
PRINT '檔案對應驗證範例 (前5筆):';

SELECT TOP 5
    aa.ArticleAttachmentId as [附件ID],
    ac.Title as [文章標題],
    aa.ContentTypeCode as [附件類型],
    CASE 
        WHEN aa.FileEntryId IS NOT NULL THEN fe.FileName
        ELSE 'External Link'
    END as [檔案資訊],
    aa.FileEntryId as [檔案GUID],
    aa.SortOrder as [排序]
FROM ArticleAttachments aa
INNER JOIN ArticleContents ac ON aa.ArticleContentId = ac.ArticleContentId
LEFT JOIN [dbo].[FileEntry] fe ON aa.FileEntryId = fe.Id
WHERE aa.CreatedTime > DATEADD(MINUTE, -15, SYSDATETIME())
  AND ac.LocaleCode = 'zh-TW'
ORDER BY aa.ArticleAttachmentId;

-- ========================================
-- 11. 完成訊息
-- ========================================
PRINT '========================================';
PRINT '✅ Articles 遷移腳本執行完成！';
PRINT '遷移來源:';
PRINT '- custom_news (所有類型)';
PRINT '- custom_article (type=''news'')';
PRINT '- custom_article_file_link (檔案附件)';
PRINT '目標系統:';
PRINT '- Articles (主表)';
PRINT '- ArticleContents (多語系內容)';
PRINT '- ArticleAttachments (檔案與連結)';
PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- 提交交易
COMMIT TRANSACTION ArticlesMigration;
PRINT '交易已成功提交！';

GO