-- ========================================
-- News 文章遷移腳本 (最終版)
-- 來源: EcoCampus_Maria3.custom_news, custom_article (type='news'), custom_article_file_link
-- 目標: EcoCampus_PreProduction.Articles, ArticleContents, ArticleAttachments
-- 建立日期: 2025-08-04
-- 版本: Final - 修正所有問題的單一腳本
-- ========================================

USE Ecocampus_PreProduction;

-- 記錄開始時間用於後續篩選
DECLARE @MigrationStartTime DATETIME2 = SYSDATETIME();

PRINT '========================================';
PRINT 'News 文章遷移腳本最終版開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, @MigrationStartTime, 120);
PRINT '========================================';

-- ========================================
-- 1. 插入 Articles 主表資料 (來源: custom_news)
-- ========================================
PRINT '步驟 1: 遷移 custom_news 到 Articles 主表...';

INSERT INTO Articles (PublishDate, TagCode, FeaturedStatus, Author, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
SELECT 
    CASE 
        WHEN cn.startdate IS NOT NULL AND cn.startdate != '' AND ISDATE(cn.startdate) = 1
        THEN CONVERT(DATETIME, cn.startdate + ' 00:00:00')
        WHEN cn.createdate IS NOT NULL AND cn.createdate > 0
        THEN DATEADD(SECOND, cn.createdate, '1970-01-01')
        ELSE '2015-01-01'
    END as PublishDate,
    CASE 
        WHEN cn.type = 'certification' THEN 'certification'
        WHEN cn.type = 'release' THEN 'campus_news' 
        WHEN cn.type = 'activity' THEN 'activity'
        WHEN cn.type = 'international' THEN 'international'
        WHEN cn.type = 'other' THEN 'other'
        ELSE 'other'
    END as TagCode,
    CASE WHEN cn.is_home = 1 THEN 1 ELSE 0 END as FeaturedStatus,
    N'管理員' as Author,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId,
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId,
    CASE WHEN cn.is_show = 1 THEN 1 ELSE 0 END as Status,
    COALESCE(cn.sequence, 0) as SortOrder
FROM EcoCampus_Maria3.dbo.custom_news cn
WHERE cn.lan = 'zh_tw'
ORDER BY COALESCE(cn.createdate, 0), cn.sid;

DECLARE @NewsCount INT = @@ROWCOUNT;
PRINT '✓ custom_news → Articles 遷移完成: ' + CAST(@NewsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 2. 插入 Articles 主表資料 (來源: custom_article type='news')
-- ========================================
PRINT '步驟 2: 遷移 custom_article (type=''news'') 到 Articles 主表...';

INSERT INTO Articles (PublishDate, TagCode, FeaturedStatus, Author, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
SELECT 
    CASE 
        WHEN ca.startdate IS NOT NULL AND ca.startdate != '' AND ISDATE(ca.startdate) = 1
        THEN CONVERT(DATETIME, ca.startdate + ' 00:00:00')
        WHEN ca.createdate IS NOT NULL AND ca.createdate > 0
        THEN DATEADD(SECOND, ca.createdate, '1970-01-01')
        ELSE '2015-01-01'
    END as PublishDate,
    'other' as TagCode,
    CASE WHEN ca.is_home = 1 THEN 1 ELSE 0 END as FeaturedStatus,
    N'管理員' as Author,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId,
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId,
    CASE WHEN ca.is_show = 1 THEN 1 ELSE 0 END as Status,
    COALESCE(ca.sequence, 0) as SortOrder
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'news'
  AND ca.lan = 'zh_tw'
ORDER BY COALESCE(ca.createdate, 0), ca.sid;

DECLARE @ArticleNewsCount INT = @@ROWCOUNT;
PRINT '✓ custom_article (news) → Articles 遷移完成: ' + CAST(@ArticleNewsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 3. 插入 ArticleContents 內容資料 (中文版)
-- ========================================
PRINT '步驟 3: 遷移 ArticleContents 中文內容...';

-- 遷移 custom_news 的中文內容（根據類型使用不同的內容來源）
WITH NewsMapping AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY COALESCE(cn.createdate, 0), cn.sid) as RowNum,
        cn.sid,
        cn.title,
        cn.type,
        CASE 
            WHEN cn.type = 'release' THEN COALESCE(cret.release_tw_content, N'<p>暫無內容</p>')
            ELSE COALESCE(cn.explanation, N'<p>' + cn.title + '</p>', N'<p>暫無內容</p>')
        END as content
    FROM EcoCampus_Maria3.dbo.custom_news cn
    LEFT JOIN EcoCampus_Maria3.dbo.custom_release_en_tw cret ON cn.sid = cret.release_tw_sid
    WHERE cn.lan = 'zh_tw'
),
ArticleMapping AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ArticleId) as RowNum,
        ArticleId
    FROM Articles 
    WHERE CreatedTime = @MigrationStartTime
      AND ArticleId <= (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw')
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    am.ArticleId,
    'zh-TW' as LocaleCode,
    COALESCE(nm.title, N'無標題') as Title,
    nm.content as CmsHtml,
    NULL as BannerFileId,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId,
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId
FROM ArticleMapping am
INNER JOIN NewsMapping nm ON am.RowNum = nm.RowNum;

-- 遷移 custom_article (type='news') 的中文內容
WITH ArticleNewsMapping AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY COALESCE(createdate, 0), sid) as RowNum,
        sid,
        title,
        COALESCE(explanation, N'<p>' + title + '</p>', N'<p>暫無內容</p>') as content
    FROM EcoCampus_Maria3.dbo.custom_article 
    WHERE type = 'news' AND lan = 'zh_tw'
),
ArticleMapping2 AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ArticleId) as RowNum,
        ArticleId
    FROM Articles 
    WHERE CreatedTime = @MigrationStartTime
      AND ArticleId > (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw')
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    am.ArticleId,
    'zh-TW' as LocaleCode,
    COALESCE(anm.title, N'無標題') as Title,
    anm.content as CmsHtml,
    NULL as BannerFileId,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId,
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId
FROM ArticleMapping2 am
INNER JOIN ArticleNewsMapping anm ON am.RowNum = anm.RowNum;

DECLARE @ContentsZhCount INT = @@ROWCOUNT;
PRINT '✓ ArticleContents 中文版遷移完成: ' + CAST(@ContentsZhCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 4. 插入 ArticleContents 內容資料 (英文版)
-- ========================================
PRINT '步驟 4: 遷移 ArticleContents 英文內容...';

-- 遷移英文內容（主要針對校園投稿 type='release'）
WITH NewsEnData AS (
    SELECT 
        cn.sid,
        cn.title,
        cn.type,
        ROW_NUMBER() OVER (ORDER BY COALESCE(cn.createdate, 0), cn.sid) as SourceRowNum,
        CASE 
            WHEN cn.type = 'release' AND cret.release_en_content IS NOT NULL 
            THEN cret.release_en_content
            ELSE N'<p>' + cn.title + '</p>'  -- 如果沒有英文內容，使用標題作為內容
        END as content
    FROM EcoCampus_Maria3.dbo.custom_news cn
    LEFT JOIN EcoCampus_Maria3.dbo.custom_release_en_tw cret ON cn.sid = cret.release_tw_sid
    WHERE cn.lan = 'zh_tw'
),
ArticleEnMapping AS (
    SELECT 
        ArticleId,
        ROW_NUMBER() OVER (ORDER BY ArticleId) as TargetRowNum
    FROM Articles 
    WHERE CreatedTime = @MigrationStartTime
      AND ArticleId <= (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw')
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    aem.ArticleId,
    'en' as LocaleCode,
    ned.title as Title,
    ned.content as CmsHtml,
    NULL as BannerFileId,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId,
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId
FROM ArticleEnMapping aem
INNER JOIN NewsEnData ned ON aem.TargetRowNum = ned.SourceRowNum;

-- 為 custom_article (type='news') 創建英文內容（複製中文內容）
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    ArticleId,
    'en' as LocaleCode,
    Title,
    CmsHtml,
    BannerFileId,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId,
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId
FROM ArticleContents 
WHERE LocaleCode = 'zh-TW'
  AND CreatedTime = @MigrationStartTime
  AND ArticleId > (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw');

DECLARE @ContentsEnCount INT = @@ROWCOUNT;
PRINT '✓ ArticleContents 英文版遷移完成: ' + CAST(@ContentsEnCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 5. 遷移附件資料 (ArticleAttachments)
-- ========================================
PRINT '步驟 5: 遷移附件資料...';

-- 遷移附件：使用CTE建立正確的對應關係
-- 首先為 custom_news 的附件創建對應關係
WITH NewsIdMapping AS (
    SELECT 
        cn.sid as OriginalSid,
        ROW_NUMBER() OVER (ORDER BY COALESCE(cn.createdate, 0), cn.sid) as SourceRowNum
    FROM EcoCampus_Maria3.dbo.custom_news cn
    WHERE cn.lan = 'zh_tw'
),
ArticleIdMapping AS (
    SELECT 
        ArticleId,
        ROW_NUMBER() OVER (ORDER BY ArticleId) as TargetRowNum
    FROM Articles 
    WHERE CreatedTime = @MigrationStartTime
      AND ArticleId <= (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw')
),
NewsToArticleMapping AS (
    SELECT 
        nim.OriginalSid,
        aim.ArticleId
    FROM NewsIdMapping nim
    INNER JOIN ArticleIdMapping aim ON nim.SourceRowNum = aim.TargetRowNum
)
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder)
SELECT 
    ac.ArticleContentId,
    CASE 
        WHEN cafl.type = 'file' AND cafl.fileinfo IS NOT NULL 
        THEN fe.Id  -- 使用 FileEntry 映射
        ELSE NULL
    END as FileEntryId,
    CASE cafl.type
        WHEN 'file' THEN 'document'
        WHEN 'link' THEN 'link'
        ELSE 'document'
    END as ContentTypeCode,
    ROW_NUMBER() OVER (PARTITION BY ac.ArticleContentId ORDER BY cafl.sid) as SortOrder
FROM EcoCampus_Maria3.dbo.custom_article_file_link cafl
INNER JOIN NewsToArticleMapping mapping ON cafl.table_sid = mapping.OriginalSid
INNER JOIN ArticleContents ac ON mapping.ArticleId = ac.ArticleId AND ac.LocaleCode = 'zh-TW'
LEFT JOIN EcoCampus_PreProduction.dbo.FileEntry fe ON cafl.fileinfo = fe.FileName
WHERE cafl.table_name = 'custom_news';

-- 為 custom_article (type='news') 的附件創建對應關係
WITH ArticleIdMapping AS (
    SELECT 
        ca.sid as OriginalSid,
        ROW_NUMBER() OVER (ORDER BY COALESCE(ca.createdate, 0), ca.sid) as SourceRowNum
    FROM EcoCampus_Maria3.dbo.custom_article ca
    WHERE ca.type = 'news' AND ca.lan = 'zh_tw'
),
TargetArticleMapping AS (
    SELECT 
        ArticleId,
        ROW_NUMBER() OVER (ORDER BY ArticleId) as TargetRowNum
    FROM Articles 
    WHERE CreatedTime = @MigrationStartTime
      AND ArticleId > (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw')
),
ArticleToArticleMapping AS (
    SELECT 
        aim.OriginalSid,
        tam.ArticleId
    FROM ArticleIdMapping aim
    INNER JOIN TargetArticleMapping tam ON aim.SourceRowNum = tam.TargetRowNum
)
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder)
SELECT 
    ac.ArticleContentId,
    CASE 
        WHEN cafl.type = 'file' AND cafl.fileinfo IS NOT NULL 
        THEN fe.Id  -- 使用 FileEntry 映射
        ELSE NULL
    END as FileEntryId,
    CASE cafl.type
        WHEN 'file' THEN 'document'
        WHEN 'link' THEN 'link'
        ELSE 'document'
    END as ContentTypeCode,
    ROW_NUMBER() OVER (PARTITION BY ac.ArticleContentId ORDER BY cafl.sid) as SortOrder
FROM EcoCampus_Maria3.dbo.custom_article_file_link cafl
INNER JOIN ArticleToArticleMapping mapping ON cafl.table_sid = mapping.OriginalSid
INNER JOIN ArticleContents ac ON mapping.ArticleId = ac.ArticleId AND ac.LocaleCode = 'zh-TW'
LEFT JOIN EcoCampus_PreProduction.dbo.FileEntry fe ON cafl.fileinfo = fe.FileName
WHERE cafl.table_name = 'custom_article';

DECLARE @AttachmentsCount INT = @@ROWCOUNT;
PRINT '✓ ArticleAttachments 遷移完成: ' + CAST(@AttachmentsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 6. 遷移結果統計和驗證
-- ========================================
PRINT '========================================';
PRINT '遷移結果統計:';
PRINT '========================================';

SELECT 
    '新聞文章遷移完成統計' as [遷移項目],
    (SELECT COUNT(*) FROM Articles WHERE CreatedTime = @MigrationStartTime) as [Articles主表],
    (SELECT COUNT(*) FROM ArticleContents WHERE CreatedTime = @MigrationStartTime AND LocaleCode = 'zh-TW') as [中文內容],
    (SELECT COUNT(*) FROM ArticleContents WHERE CreatedTime = @MigrationStartTime AND LocaleCode = 'en') as [英文內容],
    (SELECT COUNT(*) FROM ArticleAttachments WHERE CreatedTime = @MigrationStartTime) as [檔案附件];

-- ========================================
-- 6. 顯示遷移結果範例
-- ========================================
PRINT '遷移結果範例 (前5筆):';

SELECT TOP 5
    a.ArticleId as [文章ID],
    a.TagCode as [標籤代碼],
    ac.Title as [標題],
    LEFT(COALESCE(ac.CmsHtml, ''), 50) + '...' as [內容預覽],
    ac.LocaleCode as [語言],
    a.Status as [狀態]
FROM Articles a
INNER JOIN ArticleContents ac ON a.ArticleId = ac.ArticleId
WHERE a.CreatedTime = @MigrationStartTime
ORDER BY a.ArticleId, ac.LocaleCode;

-- ========================================
-- 7. 完成訊息
-- ========================================
PRINT '========================================';
PRINT '✅ News 文章遷移腳本執行完成！';
PRINT '遷移統計:';
PRINT '- custom_news: ' + CAST(@NewsCount AS VARCHAR) + ' 筆';
PRINT '- custom_article (news): ' + CAST(@ArticleNewsCount AS VARCHAR) + ' 筆';
PRINT '- 中文內容: ' + CAST(@ContentsZhCount AS VARCHAR) + ' 筆';
PRINT '- 英文內容: ' + CAST(@ContentsEnCount AS VARCHAR) + ' 筆';
PRINT '- 檔案附件: ' + CAST(@AttachmentsCount AS VARCHAR) + ' 筆';
PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';