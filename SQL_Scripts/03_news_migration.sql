-- ========================================
-- News 文章遷移腳本 (最終版)
-- 來源: EcoCampus_Maria3.custom_news, custom_article (type='news'), custom_article_file_link
-- 目標: EcoCampus_PreProduction.Articles, ArticleContents, ArticleAttachments
-- 建立日期: 2025-08-04
-- 版本: Final - 修正所有問題的單一腳本
-- ========================================

USE EcoCampus_PreProduction;

-- 記錄開始時間用於後續篩選
DECLARE @MigrationStartTime DATETIME2 = SYSDATETIME();

PRINT '========================================';
PRINT 'News 文章遷移腳本最終版開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, @MigrationStartTime, 120);
PRINT '========================================';

-- ========================================
-- 0. 清空 Articles 相關資料表
-- ========================================
PRINT '步驟 0: 清空 Articles 相關資料表...';

-- 停用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ArticleAttachments')
    ALTER TABLE ArticleAttachments NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ArticleContents')
    ALTER TABLE ArticleContents NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Articles')
    ALTER TABLE Articles NOCHECK CONSTRAINT ALL;

-- 清空資料 (從子表到主表的順序)
DELETE FROM ArticleAttachments;
DELETE FROM ArticleContents;
DELETE FROM Articles;

-- 重新啟用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ArticleAttachments')
    ALTER TABLE ArticleAttachments WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ArticleContents')
    ALTER TABLE ArticleContents WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Articles')
    ALTER TABLE Articles WITH CHECK CHECK CONSTRAINT ALL;

-- 重置自增欄位
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Articles'))
    DBCC CHECKIDENT ('Articles', RESEED, 0);

PRINT '✓ Articles 相關資料表已清空';

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
        WHEN cn.type = 'certification' THEN '1'
        WHEN cn.type = 'activity' THEN '3'
        WHEN cn.type = 'international' THEN '4'
        WHEN cn.type = 'other' THEN '5'
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
  AND cn.type != 'release'  -- 排除校園投稿
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
    CASE 
        WHEN ca.tag_sid = 1 THEN '1'
        WHEN ca.tag_sid = 7 THEN '2'
        WHEN ca.tag_sid = 13 THEN '3'
        ELSE 'other'
    END as TagCode,
    CASE WHEN ca.is_home = 1 THEN 1 ELSE 0 END as FeaturedStatus,
    N'管理員' as Author,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId,
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId,
    2 as Status,
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

-- 遷移 custom_news 的中文內容（從 bookmark 系統獲取富文本內容）
WITH BookmarkContent AS (
    -- 取得每個新聞的 bookmark 內容（簡化版本）
    SELECT 
        b.table_sid as news_sid,
        MAX(bt.content) as aggregated_content
    FROM EcoCampus_Maria3.dbo.custom_bookmark b
    INNER JOIN EcoCampus_Maria3.dbo.custom_bookmark_type bt ON b.sid = bt.bookmark_sid
    WHERE b.table_cname = 'custom_news'
    GROUP BY b.table_sid
),
NewsMapping AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY COALESCE(cn.createdate, 0), cn.sid) as RowNum,
        cn.sid,
        cn.title,
        cn.type,
        cn.photo,
        CASE 
            WHEN bc.aggregated_content IS NOT NULL AND bc.aggregated_content != '' 
            THEN bc.aggregated_content
            WHEN cn.explanation IS NOT NULL AND cn.explanation != ''
            THEN cn.explanation
            ELSE N'<p>' + cn.title + '</p>'
        END as content
    FROM EcoCampus_Maria3.dbo.custom_news cn
    LEFT JOIN BookmarkContent bc ON cn.sid = bc.news_sid
    WHERE cn.lan = 'zh_tw' 
      AND cn.type != 'release'  -- 排除校園投稿
),
ArticleMapping AS (
    SELECT 
        ArticleId,
        ROW_NUMBER() OVER (ORDER BY ArticleId) as RowNum
    FROM (
        SELECT ArticleId, ROW_NUMBER() OVER (ORDER BY ArticleId) as rn
        FROM Articles 
        WHERE CreatedTime = @MigrationStartTime
    ) ranked_articles
    WHERE rn <= (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw' AND type != 'release')
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    am.ArticleId,
    'zh-TW' as LocaleCode,
    COALESCE(nm.title, N'無標題') as Title,
    nm.content as CmsHtml,
    CASE 
        WHEN nm.photo IS NOT NULL AND nm.photo != '' 
        THEN (
            SELECT fe.Id 
            FROM EcoCampus_PreProduction.dbo.FileEntry fe 
            INNER JOIN EcoCampus_Maria3.dbo.sys_files_store ss 
                ON fe.FileName = ss.name
            WHERE nm.photo = CONCAT(ss.size, '__', ss.file_hash)
        )
        ELSE NULL
    END as BannerFileId,
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
        photo,
        COALESCE(explanation, N'<p>' + title + '</p>', N'<p>暫無內容</p>') as content
    FROM EcoCampus_Maria3.dbo.custom_article 
    WHERE type = 'news' AND lan = 'zh_tw'
),
ArticleMapping2 AS (
    SELECT 
        ArticleId,
        ROW_NUMBER() OVER (ORDER BY ArticleId) as RowNum
    FROM (
        SELECT ArticleId, ROW_NUMBER() OVER (ORDER BY ArticleId) as rn
        FROM Articles 
        WHERE CreatedTime = @MigrationStartTime
    ) ranked_articles
    WHERE rn > (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw' AND type != 'release')
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    am.ArticleId,
    'zh-TW' as LocaleCode,
    COALESCE(anm.title, N'無標題') as Title,
    anm.content as CmsHtml,
    CASE 
        WHEN anm.photo IS NOT NULL AND anm.photo != '' 
        THEN (
            SELECT fe.Id 
            FROM EcoCampus_PreProduction.dbo.FileEntry fe 
            INNER JOIN EcoCampus_Maria3.dbo.sys_files_store ss 
                ON fe.FileName = ss.name
            WHERE anm.photo = CONCAT(ss.size, '__', ss.file_hash)
        )
        ELSE NULL
    END as BannerFileId,
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

-- 遷移英文內容（英文版通常使用相同的 bookmark 內容或 explanation）
WITH BookmarkContentEn AS (
    -- 取得每個新聞的 bookmark 內容（英文版，簡化版本）
    SELECT 
        b.table_sid as news_sid,
        MAX(bt.content) as aggregated_content
    FROM EcoCampus_Maria3.dbo.custom_bookmark b
    INNER JOIN EcoCampus_Maria3.dbo.custom_bookmark_type bt ON b.sid = bt.bookmark_sid
    WHERE b.table_cname = 'custom_news'
    GROUP BY b.table_sid
),
NewsEnData AS (
    SELECT 
        cn.sid,
        cn.title,
        cn.type,
        cn.photo,
        ROW_NUMBER() OVER (ORDER BY COALESCE(cn.createdate, 0), cn.sid) as SourceRowNum,
        CASE 
            WHEN bc.aggregated_content IS NOT NULL AND bc.aggregated_content != '' 
            THEN bc.aggregated_content
            WHEN cn.explanation IS NOT NULL AND cn.explanation != ''
            THEN cn.explanation
            ELSE N'<p>' + cn.title + '</p>'
        END as content
    FROM EcoCampus_Maria3.dbo.custom_news cn
    LEFT JOIN BookmarkContentEn bc ON cn.sid = bc.news_sid
    WHERE cn.lan = 'zh_tw' 
      AND cn.type != 'release'  -- 排除校園投稿
),
ArticleEnMapping AS (
    SELECT 
        ArticleId,
        ROW_NUMBER() OVER (ORDER BY ArticleId) as TargetRowNum
    FROM Articles 
    WHERE CreatedTime = @MigrationStartTime
      AND ArticleId <= (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw' AND type != 'release')
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    aem.ArticleId,
    'en' as LocaleCode,
    ned.title as Title,
    ned.content as CmsHtml,
    CASE 
        WHEN ned.photo IS NOT NULL AND ned.photo != '' 
        THEN (
            SELECT fe.Id 
            FROM EcoCampus_PreProduction.dbo.FileEntry fe 
            INNER JOIN EcoCampus_Maria3.dbo.sys_files_store ss 
                ON fe.FileName = ss.name
            WHERE ned.photo = CONCAT(ss.size, '__', ss.file_hash)
        )
        ELSE NULL
    END as BannerFileId,
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

-- 遷移附件：使用更簡單的對應方式
-- 先創建一個臨時表來建立 sid 到 ArticleId 的對應
-- 為 custom_news 創建對應關係
CREATE TABLE #NewsMapping (
    OriginalSid INT,
    ArticleId INT,
    SourceRowNum INT,
    TargetRowNum INT
);

-- 先插入來源資料的行號
WITH SourceData AS (
    SELECT 
        cn.sid as OriginalSid,
        ROW_NUMBER() OVER (ORDER BY COALESCE(cn.createdate, 0), cn.sid) as SourceRowNum
    FROM EcoCampus_Maria3.dbo.custom_news cn
    WHERE cn.lan = 'zh_tw' 
      AND cn.type != 'release'  -- 排除校園投稿
),
TargetData AS (
    SELECT 
        ArticleId,
        ROW_NUMBER() OVER (ORDER BY ArticleId) as TargetRowNum
    FROM (
        SELECT ArticleId, ROW_NUMBER() OVER (ORDER BY ArticleId) as rn
        FROM Articles 
        WHERE CreatedTime = @MigrationStartTime
    ) ranked_articles
    WHERE rn <= (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw' AND type != 'release')
)
INSERT INTO #NewsMapping (OriginalSid, ArticleId, SourceRowNum, TargetRowNum)
SELECT 
    s.OriginalSid,
    t.ArticleId,
    s.SourceRowNum,
    t.TargetRowNum
FROM SourceData s
INNER JOIN TargetData t ON s.SourceRowNum = t.TargetRowNum;

-- 遷移 custom_news 附件
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, LinkName, LinkUrl, CreatedTime, CreatedUserId)
SELECT 
    ac.ArticleContentId,
    CASE 
        WHEN cafl.type = 'file' AND cafl.fileinfo IS NOT NULL 
        THEN fe.Id
        ELSE NULL
    END as FileEntryId,
    CASE cafl.type
        WHEN 'file' THEN 'file'
        WHEN 'link' THEN 'link'
        ELSE 'document'
    END as ContentTypeCode,
    ROW_NUMBER() OVER (PARTITION BY ac.ArticleContentId ORDER BY cafl.sid) as SortOrder,
    CASE WHEN cafl.type = 'link' THEN cafl.title ELSE NULL END as LinkName,
    CASE WHEN cafl.type = 'link' THEN cafl.link_url ELSE NULL END as LinkUrl,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId
FROM EcoCampus_Maria3.dbo.custom_article_file_link cafl
INNER JOIN #NewsMapping nm ON cafl.table_sid = nm.OriginalSid
INNER JOIN ArticleContents ac ON nm.ArticleId = ac.ArticleId AND ac.LocaleCode = 'zh-TW'
LEFT JOIN EcoCampus_PreProduction.dbo.FileEntry fe ON cafl.fileinfo = fe.FileName
WHERE cafl.table_name = 'custom_news';

-- 為 custom_news 英文版複製附件記錄
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, LinkName, LinkUrl, CreatedTime, CreatedUserId)
SELECT 
    ac_en.ArticleContentId,
    aa.FileEntryId,
    aa.ContentTypeCode,
    aa.SortOrder,
    aa.LinkName,
    aa.LinkUrl,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId
FROM ArticleAttachments aa
INNER JOIN ArticleContents ac_zh ON aa.ArticleContentId = ac_zh.ArticleContentId
INNER JOIN ArticleContents ac_en ON ac_zh.ArticleId = ac_en.ArticleId 
WHERE ac_zh.LocaleCode = 'zh-TW' 
  AND ac_en.LocaleCode = 'en'
  AND aa.CreatedTime = @MigrationStartTime
  AND ac_zh.ArticleId <= (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw' AND type != 'release');

DROP TABLE #NewsMapping;

-- 為 custom_article (type='news') 創建對應關係
CREATE TABLE #ArticleMapping (
    OriginalSid INT,
    ArticleId INT,
    SourceRowNum INT,
    TargetRowNum INT
);

-- 先插入來源資料的行號
WITH SourceData AS (
    SELECT 
        ca.sid as OriginalSid,
        ROW_NUMBER() OVER (ORDER BY COALESCE(ca.createdate, 0), ca.sid) as SourceRowNum
    FROM EcoCampus_Maria3.dbo.custom_article ca
    WHERE ca.type = 'news' AND ca.lan = 'zh_tw'
),
TargetData AS (
    SELECT 
        ArticleId,
        ROW_NUMBER() OVER (ORDER BY ArticleId) as TargetRowNum
    FROM (
        SELECT ArticleId, ROW_NUMBER() OVER (ORDER BY ArticleId) as rn
        FROM Articles 
        WHERE CreatedTime = @MigrationStartTime
    ) ranked_articles
    WHERE rn > (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw' AND type != 'release')
)
INSERT INTO #ArticleMapping (OriginalSid, ArticleId, SourceRowNum, TargetRowNum)
SELECT 
    s.OriginalSid,
    t.ArticleId,
    s.SourceRowNum,
    t.TargetRowNum
FROM SourceData s
INNER JOIN TargetData t ON s.SourceRowNum = t.TargetRowNum;

-- 遷移 custom_article 附件
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, LinkName, LinkUrl, CreatedTime, CreatedUserId)
SELECT 
    ac.ArticleContentId,
    CASE 
        WHEN cafl.type = 'file' AND cafl.fileinfo IS NOT NULL 
        THEN fe.Id
        ELSE NULL
    END as FileEntryId,
    CASE cafl.type
        WHEN 'file' THEN 'document'
        WHEN 'link' THEN 'link'
        ELSE 'document'
    END as ContentTypeCode,
    ROW_NUMBER() OVER (PARTITION BY ac.ArticleContentId ORDER BY cafl.sid) as SortOrder,
    CASE WHEN cafl.type = 'link' THEN cafl.title ELSE NULL END as LinkName,
    CASE WHEN cafl.type = 'link' THEN cafl.link_url ELSE NULL END as LinkUrl,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId
FROM EcoCampus_Maria3.dbo.custom_article_file_link cafl
INNER JOIN #ArticleMapping am ON cafl.table_sid = am.OriginalSid
INNER JOIN ArticleContents ac ON am.ArticleId = ac.ArticleId AND ac.LocaleCode = 'zh-TW'
LEFT JOIN EcoCampus_PreProduction.dbo.FileEntry fe ON cafl.fileinfo = fe.FileName
WHERE cafl.table_name = 'custom_article';

-- 為 custom_article 英文版複製附件記錄
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, LinkName, LinkUrl, CreatedTime, CreatedUserId)
SELECT 
    ac_en.ArticleContentId,
    aa.FileEntryId,
    aa.ContentTypeCode,
    aa.SortOrder,
    aa.LinkName,
    aa.LinkUrl,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId
FROM ArticleAttachments aa
INNER JOIN ArticleContents ac_zh ON aa.ArticleContentId = ac_zh.ArticleContentId
INNER JOIN ArticleContents ac_en ON ac_zh.ArticleId = ac_en.ArticleId 
WHERE ac_zh.LocaleCode = 'zh-TW' 
  AND ac_en.LocaleCode = 'en'
  AND aa.CreatedTime = @MigrationStartTime
  AND ac_zh.ArticleId > (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_news WHERE lan = 'zh_tw' AND type != 'release');

DROP TABLE #ArticleMapping;

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