-- ========================================
-- News 雙語遷移重作（Script 24）
-- 說明：
-- - 新系統在 ArticleContents 加入欄位 IsVisible（Script 17 已建立，預設 1）
-- - 依舊系統策略：
--     * 中文文章：zh-TW 顯示=1，en 顯示=0
--     * 英文文章：en 顯示=1，zh-TW 顯示=0
-- - 本腳本會將 custom_news 以及 custom_article(type='news') 的「中文」與「英文」資料各自遷移成獨立 Article，
--   並為每篇 Article 建立兩個語系內容（主語系 IsVisible=1；另一語系 IsVisible=0）。
--   這樣可同時保留兩語系文章（互不覆蓋），也可於新系統決定顯示語系。
-- 來源：EcoCampus_Maria3.custom_news, custom_article (type='news'), custom_article_file_link, custom_bookmark(+type)
-- 目標：EcoCampus_PreProduction.Articles, ArticleContents, ArticleAttachments
-- 建立日期：2025-09-14
-- ========================================

SET NOCOUNT ON;
USE EcoCampus_PreProduction;

DECLARE @MigrationStartTime DATETIME2 = SYSDATETIME();

PRINT '========================================';
PRINT 'Script 24 - News 雙語遷移重作開始';
PRINT '開始時間: ' + CONVERT(VARCHAR, @MigrationStartTime, 120);
PRINT '========================================';

-- 安全檢查：IsVisible 欄位（若前置腳本 17 未跑過，這裡補上）
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE Name = N'IsVisible' AND Object_ID = Object_ID(N'dbo.ArticleContents')
)
BEGIN
    ALTER TABLE dbo.ArticleContents
    ADD IsVisible bit NOT NULL CONSTRAINT DF_ArticleContents_IsVisible DEFAULT(1);
END;

------------------------------------------------------------
-- 1. 插入 Articles（custom_news：中文、英文各自獨立）
------------------------------------------------------------
PRINT '步驟 1: 插入 Articles（custom_news，中文）';
INSERT INTO Articles (PublishDate, TagCode, FeaturedStatus, Author, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
SELECT 
    CASE 
        WHEN cn.startdate IS NOT NULL AND cn.startdate <> '' AND ISDATE(cn.startdate) = 1 THEN CONVERT(DATETIME, cn.startdate + ' 00:00:00')
        WHEN cn.createdate IS NOT NULL AND cn.createdate > 0 THEN DATEADD(SECOND, cn.createdate, '1970-01-01')
        ELSE '2015-01-01'
    END AS PublishDate,
    CASE 
        WHEN cn.type = 'certification' THEN '1'
        WHEN cn.type = 'activity' THEN '3'
        WHEN cn.type = 'international' THEN '4'
        WHEN cn.type = 'other' THEN '5'
        ELSE 'other'
    END AS TagCode,
    CASE WHEN cn.is_home = 1 THEN 1 ELSE 0 END AS FeaturedStatus,
    N'系統遷移' AS Author,
    @MigrationStartTime AS CreatedTime,
    1 AS CreatedUserId,
    @MigrationStartTime AS UpdatedTime,
    1 AS UpdatedUserId,
    CASE WHEN cn.is_show = 1 THEN 1 ELSE 0 END AS Status,
    COALESCE(cn.sequence, 0) AS SortOrder
FROM EcoCampus_Maria3.dbo.custom_news cn
WHERE cn.lan = 'zh_tw' AND cn.type <> 'release'
ORDER BY COALESCE(cn.createdate, 0), cn.sid;
DECLARE @NewsZhCount INT = @@ROWCOUNT;

PRINT '步驟 1b: 插入 Articles（custom_news，英文）';
INSERT INTO Articles (PublishDate, TagCode, FeaturedStatus, Author, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
SELECT 
    CASE 
        WHEN cn.startdate IS NOT NULL AND cn.startdate <> '' AND ISDATE(cn.startdate) = 1 THEN CONVERT(DATETIME, cn.startdate + ' 00:00:00')
        WHEN cn.createdate IS NOT NULL AND cn.createdate > 0 THEN DATEADD(SECOND, cn.createdate, '1970-01-01')
        ELSE '2015-01-01'
    END AS PublishDate,
    CASE 
        WHEN cn.type = 'certification' THEN '1'
        WHEN cn.type = 'activity' THEN '3'
        WHEN cn.type = 'international' THEN '4'
        WHEN cn.type = 'other' THEN '5'
        ELSE 'other'
    END AS TagCode,
    CASE WHEN cn.is_home = 1 THEN 1 ELSE 0 END AS FeaturedStatus,
    N'系統遷移' AS Author,
    @MigrationStartTime AS CreatedTime,
    1 AS CreatedUserId,
    @MigrationStartTime AS UpdatedTime,
    1 AS UpdatedUserId,
    CASE WHEN cn.is_show = 1 THEN 1 ELSE 0 END AS Status,
    COALESCE(cn.sequence, 0) AS SortOrder
FROM EcoCampus_Maria3.dbo.custom_news cn
WHERE cn.lan = 'en' AND cn.type <> 'release'
ORDER BY COALESCE(cn.createdate, 0), cn.sid;
DECLARE @NewsEnCount INT = @@ROWCOUNT;

------------------------------------------------------------
-- 2. 插入 Articles（custom_article type='news'：中文、英文各自獨立）
------------------------------------------------------------
PRINT '步驟 2: 插入 Articles（custom_article(news)，中文）';
INSERT INTO Articles (PublishDate, TagCode, FeaturedStatus, Author, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
SELECT 
    CASE 
        WHEN ca.startdate IS NOT NULL AND ca.startdate <> '' AND ISDATE(ca.startdate) = 1 THEN CONVERT(DATETIME, ca.startdate + ' 00:00:00')
        WHEN ca.createdate IS NOT NULL AND ca.createdate > 0 THEN DATEADD(SECOND, ca.createdate, '1970-01-01')
        ELSE '2015-01-01'
    END AS PublishDate,
    CASE 
        WHEN ca.tag_sid = 1 THEN '1'
        WHEN ca.tag_sid = 7 THEN '2'
        WHEN ca.tag_sid = 13 THEN '3'
        ELSE 'other'
    END AS TagCode,
    CASE WHEN ca.is_home = 1 THEN 1 ELSE 0 END AS FeaturedStatus,
    N'系統遷移' AS Author,
    @MigrationStartTime AS CreatedTime,
    1 AS CreatedUserId,
    @MigrationStartTime AS UpdatedTime,
    1 AS UpdatedUserId,
    CASE WHEN ca.is_show = 1 THEN 1 ELSE 0 END AS Status,
    COALESCE(ca.sequence, 0) AS SortOrder
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'news' AND ca.lan = 'zh_tw'
ORDER BY COALESCE(ca.createdate, 0), ca.sid;
DECLARE @ArticleNewsZhCount INT = @@ROWCOUNT;

PRINT '步驟 2b: 插入 Articles（custom_article(news)，英文）';
INSERT INTO Articles (PublishDate, TagCode, FeaturedStatus, Author, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
SELECT 
    CASE 
        WHEN ca.startdate IS NOT NULL AND ca.startdate <> '' AND ISDATE(ca.startdate) = 1 THEN CONVERT(DATETIME, ca.startdate + ' 00:00:00')
        WHEN ca.createdate IS NOT NULL AND ca.createdate > 0 THEN DATEADD(SECOND, ca.createdate, '1970-01-01')
        ELSE '2015-01-01'
    END AS PublishDate,
    CASE 
        WHEN ca.tag_sid = 1 THEN '1'
        WHEN ca.tag_sid = 7 THEN '2'
        WHEN ca.tag_sid = 13 THEN '3'
        ELSE 'other'
    END AS TagCode,
    CASE WHEN ca.is_home = 1 THEN 1 ELSE 0 END AS FeaturedStatus,
    N'系統遷移' AS Author,
    @MigrationStartTime AS CreatedTime,
    1 AS CreatedUserId,
    @MigrationStartTime AS UpdatedTime,
    1 AS UpdatedUserId,
    2 AS Status,
    COALESCE(ca.sequence, 0) AS SortOrder
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'news' AND ca.lan = 'en'
ORDER BY COALESCE(ca.createdate, 0), ca.sid;
DECLARE @ArticleNewsEnCount INT = @@ROWCOUNT;

------------------------------------------------------------
-- 3. 建立 ArticleId 對應（依本次 CreatedTime 逐段對齊）
------------------------------------------------------------
-- 依插入順序：News-ZH -> News-EN -> ArtNews-ZH -> ArtNews-EN

CREATE TABLE #Map_News_Zh (SourceSid INT, SourceRowNum INT, ArticleId INT);
WITH Src AS (
    SELECT cn.sid AS SourceSid,
           ROW_NUMBER() OVER (ORDER BY COALESCE(cn.createdate, 0), cn.sid) AS SourceRowNum
    FROM EcoCampus_Maria3.dbo.custom_news cn
    WHERE cn.lan = 'zh_tw' AND cn.type <> 'release'
), Tgt AS (
    SELECT ArticleId, ROW_NUMBER() OVER (ORDER BY ArticleId) AS TargetRowNum
    FROM Articles WHERE CreatedTime = @MigrationStartTime
)
INSERT INTO #Map_News_Zh (SourceSid, SourceRowNum, ArticleId)
SELECT s.SourceSid, s.SourceRowNum, t.ArticleId
FROM Src s JOIN Tgt t ON s.SourceRowNum = t.TargetRowNum;

CREATE TABLE #Map_News_En (SourceSid INT, SourceRowNum INT, ArticleId INT);
WITH Src AS (
    SELECT cn.sid AS SourceSid,
           ROW_NUMBER() OVER (ORDER BY COALESCE(cn.createdate, 0), cn.sid) AS SourceRowNum
    FROM EcoCampus_Maria3.dbo.custom_news cn
    WHERE cn.lan = 'en' AND cn.type <> 'release'
), Tgt AS (
    SELECT ArticleId, ROW_NUMBER() OVER (ORDER BY ArticleId) AS TargetRowNum
    FROM Articles WHERE CreatedTime = @MigrationStartTime
)
INSERT INTO #Map_News_En (SourceSid, SourceRowNum, ArticleId)
SELECT s.SourceSid, s.SourceRowNum, t.ArticleId
FROM Src s JOIN Tgt t ON (s.SourceRowNum + (SELECT COUNT(*) FROM #Map_News_Zh)) = t.TargetRowNum;

CREATE TABLE #Map_ArtNews_Zh (SourceSid INT, SourceRowNum INT, ArticleId INT);
WITH Src AS (
    SELECT ca.sid AS SourceSid,
           ROW_NUMBER() OVER (ORDER BY COALESCE(ca.createdate, 0), ca.sid) AS SourceRowNum
    FROM EcoCampus_Maria3.dbo.custom_article ca
    WHERE ca.type = 'news' AND ca.lan = 'zh_tw'
), Tgt AS (
    SELECT ArticleId, ROW_NUMBER() OVER (ORDER BY ArticleId) AS TargetRowNum
    FROM Articles WHERE CreatedTime = @MigrationStartTime
)
INSERT INTO #Map_ArtNews_Zh (SourceSid, SourceRowNum, ArticleId)
SELECT s.SourceSid, s.SourceRowNum, t.ArticleId
FROM Src s JOIN Tgt t ON (s.SourceRowNum + (SELECT COUNT(*) FROM #Map_News_Zh) + (SELECT COUNT(*) FROM #Map_News_En)) = t.TargetRowNum;

CREATE TABLE #Map_ArtNews_En (SourceSid INT, SourceRowNum INT, ArticleId INT);
WITH Src AS (
    SELECT ca.sid AS SourceSid,
           ROW_NUMBER() OVER (ORDER BY COALESCE(ca.createdate, 0), ca.sid) AS SourceRowNum
    FROM EcoCampus_Maria3.dbo.custom_article ca
    WHERE ca.type = 'news' AND ca.lan = 'en'
), Tgt AS (
    SELECT ArticleId, ROW_NUMBER() OVER (ORDER BY ArticleId) AS TargetRowNum
    FROM Articles WHERE CreatedTime = @MigrationStartTime
)
INSERT INTO #Map_ArtNews_En (SourceSid, SourceRowNum, ArticleId)
SELECT s.SourceSid, s.SourceRowNum, t.ArticleId
FROM Src s JOIN Tgt t ON (
    s.SourceRowNum 
    + (SELECT COUNT(*) FROM #Map_News_Zh)
    + (SELECT COUNT(*) FROM #Map_News_En)
    + (SELECT COUNT(*) FROM #Map_ArtNews_Zh)
) = t.TargetRowNum;

------------------------------------------------------------
-- 4. 插入 ArticleContents：主語系與副語系（含 IsVisible）
------------------------------------------------------------
PRINT '步驟 4: 插入 ArticleContents（含 IsVisible）';

-- custom_news 中文：主=zh-TW(1)；副=en(0)
WITH BookmarkZh AS (
    SELECT b.table_sid AS news_sid, MAX(bt.content) AS aggregated_content
    FROM EcoCampus_Maria3.dbo.custom_bookmark b
    JOIN EcoCampus_Maria3.dbo.custom_bookmark_type bt ON b.sid = bt.bookmark_sid
    WHERE b.table_cname = 'custom_news'
    GROUP BY b.table_sid
), NewsZh AS (
    SELECT cn.sid, cn.title, cn.photo,
           CASE WHEN bz.aggregated_content IS NOT NULL AND bz.aggregated_content <> '' THEN bz.aggregated_content
                WHEN cn.explanation IS NOT NULL AND cn.explanation <> '' THEN cn.explanation
                ELSE N'<p>' + cn.title + '</p>' END AS content
    FROM EcoCampus_Maria3.dbo.custom_news cn
    LEFT JOIN BookmarkZh bz ON cn.sid = bz.news_sid
    WHERE cn.lan = 'zh_tw' AND cn.type <> 'release'
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, IsVisible)
SELECT m.ArticleId, 'zh-TW', COALESCE(n.title, N'未命名'), n.content,
       CASE WHEN n.photo IS NOT NULL AND n.photo <> '' THEN (
            SELECT fe.Id FROM EcoCampus_PreProduction.dbo.FileEntry fe 
            JOIN EcoCampus_Maria3.dbo.sys_files_store ss ON fe.FileName = ss.name
            WHERE n.photo = CONCAT(ss.size, '__', ss.file_hash)
       ) ELSE NULL END,
       @MigrationStartTime, 1, @MigrationStartTime, 1, 1
FROM #Map_News_Zh m JOIN NewsZh n ON m.SourceSid = n.sid;

-- custom_news 中文：建立英文副語系（隱藏）
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, IsVisible)
SELECT ac.ArticleId, 'en', ac.Title, ac.CmsHtml, ac.BannerFileId,
       @MigrationStartTime, 1, @MigrationStartTime, 1, 0
FROM ArticleContents ac JOIN #Map_News_Zh m ON ac.ArticleId = m.ArticleId
WHERE ac.LocaleCode = 'zh-TW' AND ac.CreatedTime = @MigrationStartTime;

-- custom_news 英文：主=en(1)；副=zh-TW(0)
WITH BookmarkEn AS (
    SELECT b.table_sid AS news_sid, MAX(bt.content) AS aggregated_content
    FROM EcoCampus_Maria3.dbo.custom_bookmark b
    JOIN EcoCampus_Maria3.dbo.custom_bookmark_type bt ON b.sid = bt.bookmark_sid
    WHERE b.table_cname = 'custom_news'
    GROUP BY b.table_sid
), NewsEn AS (
    SELECT cn.sid, cn.title, cn.photo,
           CASE WHEN be.aggregated_content IS NOT NULL AND be.aggregated_content <> '' THEN be.aggregated_content
                WHEN cn.explanation IS NOT NULL AND cn.explanation <> '' THEN cn.explanation
                ELSE N'<p>' + cn.title + '</p>' END AS content
    FROM EcoCampus_Maria3.dbo.custom_news cn
    LEFT JOIN BookmarkEn be ON cn.sid = be.news_sid
    WHERE cn.lan = 'en' AND cn.type <> 'release'
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, IsVisible)
SELECT m.ArticleId, 'en', COALESCE(n.title, N'Untitled'), n.content,
       CASE WHEN n.photo IS NOT NULL AND n.photo <> '' THEN (
            SELECT fe.Id FROM EcoCampus_PreProduction.dbo.FileEntry fe 
            JOIN EcoCampus_Maria3.dbo.sys_files_store ss ON fe.FileName = ss.name
            WHERE n.photo = CONCAT(ss.size, '__', ss.file_hash)
       ) ELSE NULL END,
       @MigrationStartTime, 1, @MigrationStartTime, 1, 1
FROM #Map_News_En m JOIN NewsEn n ON m.SourceSid = n.sid;

-- custom_news 英文：建立中文副語系（隱藏）
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, IsVisible)
SELECT ac.ArticleId, 'zh-TW', ac.Title, ac.CmsHtml, ac.BannerFileId,
       @MigrationStartTime, 1, @MigrationStartTime, 1, 0
FROM ArticleContents ac JOIN #Map_News_En m ON ac.ArticleId = m.ArticleId
WHERE ac.LocaleCode = 'en' AND ac.CreatedTime = @MigrationStartTime;

-- custom_article(news) 中文：主=zh-TW(1)；副=en(0)
WITH ArtZh AS (
    SELECT ca.sid, ca.title, ca.photo,
           COALESCE(ca.explanation, N'<p>' + ca.title + '</p>') AS content
    FROM EcoCampus_Maria3.dbo.custom_article ca
    WHERE ca.type = 'news' AND ca.lan = 'zh_tw'
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, IsVisible)
SELECT m.ArticleId, 'zh-TW', COALESCE(a.title, N'未命名'), a.content,
       CASE WHEN a.photo IS NOT NULL AND a.photo <> '' THEN (
            SELECT fe.Id FROM EcoCampus_PreProduction.dbo.FileEntry fe 
            JOIN EcoCampus_Maria3.dbo.sys_files_store ss ON fe.FileName = ss.name
            WHERE a.photo = CONCAT(ss.size, '__', ss.file_hash)
       ) ELSE NULL END,
       @MigrationStartTime, 1, @MigrationStartTime, 1, 1
FROM #Map_ArtNews_Zh m JOIN ArtZh a ON m.SourceSid = a.sid;

-- custom_article(news) 中文：英文副語系（隱藏）
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, IsVisible)
SELECT ac.ArticleId, 'en', ac.Title, ac.CmsHtml, ac.BannerFileId,
       @MigrationStartTime, 1, @MigrationStartTime, 1, 0
FROM ArticleContents ac JOIN #Map_ArtNews_Zh m ON ac.ArticleId = m.ArticleId
WHERE ac.LocaleCode = 'zh-TW' AND ac.CreatedTime = @MigrationStartTime;

-- custom_article(news) 英文：主=en(1)；副=zh-TW(0)
WITH ArtEn AS (
    SELECT ca.sid, ca.title, ca.photo,
           COALESCE(ca.explanation, N'<p>' + ca.title + '</p>') AS content
    FROM EcoCampus_Maria3.dbo.custom_article ca
    WHERE ca.type = 'news' AND ca.lan = 'en'
)
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, IsVisible)
SELECT m.ArticleId, 'en', COALESCE(a.title, N'Untitled'), a.content,
       CASE WHEN a.photo IS NOT NULL AND a.photo <> '' THEN (
            SELECT fe.Id FROM EcoCampus_PreProduction.dbo.FileEntry fe 
            JOIN EcoCampus_Maria3.dbo.sys_files_store ss ON fe.FileName = ss.name
            WHERE a.photo = CONCAT(ss.size, '__', ss.file_hash)
       ) ELSE NULL END,
       @MigrationStartTime, 1, @MigrationStartTime, 1, 1
FROM #Map_ArtNews_En m JOIN ArtEn a ON m.SourceSid = a.sid;

-- custom_article(news) 英文：中文副語系（隱藏）
INSERT INTO ArticleContents (ArticleId, LocaleCode, Title, CmsHtml, BannerFileId, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, IsVisible)
SELECT ac.ArticleId, 'zh-TW', ac.Title, ac.CmsHtml, ac.BannerFileId,
       @MigrationStartTime, 1, @MigrationStartTime, 1, 0
FROM ArticleContents ac JOIN #Map_ArtNews_En m ON ac.ArticleId = m.ArticleId
WHERE ac.LocaleCode = 'en' AND ac.CreatedTime = @MigrationStartTime;

------------------------------------------------------------
-- 5. 附件遷移（ArticleAttachments）
------------------------------------------------------------
PRINT '步驟 5: 遷移附件到主語系內容，並複製到副語系內容';

-- custom_news 中文主語系附件（掛到 zh-TW 主語系）
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, LinkName, LinkUrl, CreatedTime, CreatedUserId)
SELECT ac.ArticleContentId,
       CASE WHEN cafl.type = 'file' AND cafl.fileinfo IS NOT NULL THEN fe.Id ELSE NULL END,
       CASE cafl.type WHEN 'file' THEN 'document' WHEN 'link' THEN 'link' ELSE 'document' END,
       ROW_NUMBER() OVER (PARTITION BY ac.ArticleContentId ORDER BY cafl.sid),
       CASE WHEN cafl.type = 'link' THEN cafl.title ELSE NULL END,
       CASE WHEN cafl.type = 'link' THEN cafl.link_url ELSE NULL END,
       @MigrationStartTime, 1
FROM EcoCampus_Maria3.dbo.custom_article_file_link cafl
JOIN #Map_News_Zh m ON cafl.table_sid = m.SourceSid
JOIN ArticleContents ac ON ac.ArticleId = m.ArticleId AND ac.LocaleCode = 'zh-TW' AND ac.CreatedTime = @MigrationStartTime
LEFT JOIN EcoCampus_PreProduction.dbo.FileEntry fe ON cafl.fileinfo = fe.FileName
WHERE cafl.table_name = 'custom_news';

-- custom_news 英文主語系附件（掛到 en 主語系）
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, LinkName, LinkUrl, CreatedTime, CreatedUserId)
SELECT ac.ArticleContentId,
       CASE WHEN cafl.type = 'file' AND cafl.fileinfo IS NOT NULL THEN fe.Id ELSE NULL END,
       CASE cafl.type WHEN 'file' THEN 'document' WHEN 'link' THEN 'link' ELSE 'document' END,
       ROW_NUMBER() OVER (PARTITION BY ac.ArticleContentId ORDER BY cafl.sid),
       CASE WHEN cafl.type = 'link' THEN cafl.title ELSE NULL END,
       CASE WHEN cafl.type = 'link' THEN cafl.link_url ELSE NULL END,
       @MigrationStartTime, 1
FROM EcoCampus_Maria3.dbo.custom_article_file_link cafl
JOIN #Map_News_En m ON cafl.table_sid = m.SourceSid
JOIN ArticleContents ac ON ac.ArticleId = m.ArticleId AND ac.LocaleCode = 'en' AND ac.CreatedTime = @MigrationStartTime
LEFT JOIN EcoCampus_PreProduction.dbo.FileEntry fe ON cafl.fileinfo = fe.FileName
WHERE cafl.table_name = 'custom_news';

-- custom_article(news) 中文主語系附件（掛到 zh-TW 主語系）
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, LinkName, LinkUrl, CreatedTime, CreatedUserId)
SELECT ac.ArticleContentId,
       CASE WHEN cafl.type = 'file' AND cafl.fileinfo IS NOT NULL THEN fe.Id ELSE NULL END,
       CASE cafl.type WHEN 'file' THEN 'document' WHEN 'link' THEN 'link' ELSE 'document' END,
       ROW_NUMBER() OVER (PARTITION BY ac.ArticleContentId ORDER BY cafl.sid),
       CASE WHEN cafl.type = 'link' THEN cafl.title ELSE NULL END,
       CASE WHEN cafl.type = 'link' THEN cafl.link_url ELSE NULL END,
       @MigrationStartTime, 1
FROM EcoCampus_Maria3.dbo.custom_article_file_link cafl
JOIN #Map_ArtNews_Zh m ON cafl.table_sid = m.SourceSid
JOIN ArticleContents ac ON ac.ArticleId = m.ArticleId AND ac.LocaleCode = 'zh-TW' AND ac.CreatedTime = @MigrationStartTime
LEFT JOIN EcoCampus_PreProduction.dbo.FileEntry fe ON cafl.fileinfo = fe.FileName
WHERE cafl.table_name = 'custom_article';

-- custom_article(news) 英文主語系附件（掛到 en 主語系）
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, LinkName, LinkUrl, CreatedTime, CreatedUserId)
SELECT ac.ArticleContentId,
       CASE WHEN cafl.type = 'file' AND cafl.fileinfo IS NOT NULL THEN fe.Id ELSE NULL END,
       CASE cafl.type WHEN 'file' THEN 'document' WHEN 'link' THEN 'link' ELSE 'document' END,
       ROW_NUMBER() OVER (PARTITION BY ac.ArticleContentId ORDER BY cafl.sid),
       CASE WHEN cafl.type = 'link' THEN cafl.title ELSE NULL END,
       CASE WHEN cafl.type = 'link' THEN cafl.link_url ELSE NULL END,
       @MigrationStartTime, 1
FROM EcoCampus_Maria3.dbo.custom_article_file_link cafl
JOIN #Map_ArtNews_En m ON cafl.table_sid = m.SourceSid
JOIN ArticleContents ac ON ac.ArticleId = m.ArticleId AND ac.LocaleCode = 'en' AND ac.CreatedTime = @MigrationStartTime
LEFT JOIN EcoCampus_PreProduction.dbo.FileEntry fe ON cafl.fileinfo = fe.FileName
WHERE cafl.table_name = 'custom_article';

-- 將主語系附件複製到副語系內容（避免副語系缺附件）
INSERT INTO ArticleAttachments (ArticleContentId, FileEntryId, ContentTypeCode, SortOrder, LinkName, LinkUrl, CreatedTime, CreatedUserId)
SELECT ac_other.ArticleContentId, aa.FileEntryId, aa.ContentTypeCode, aa.SortOrder, aa.LinkName, aa.LinkUrl,
       @MigrationStartTime, 1
FROM ArticleAttachments aa
JOIN ArticleContents ac_primary ON aa.ArticleContentId = ac_primary.ArticleContentId AND ac_primary.CreatedTime = @MigrationStartTime AND ac_primary.IsVisible = 1
JOIN ArticleContents ac_other ON ac_other.ArticleId = ac_primary.ArticleId AND ac_other.LocaleCode <> ac_primary.LocaleCode AND ac_other.CreatedTime = @MigrationStartTime
WHERE aa.CreatedTime = @MigrationStartTime;

------------------------------------------------------------
-- 6. 統計與範例輸出
------------------------------------------------------------
PRINT '========================================';
PRINT '執行統計（Script 24）';
PRINT '========================================';

SELECT 
    (SELECT COUNT(*) FROM Articles WHERE CreatedTime = @MigrationStartTime) AS Articles_Inserted,
    (SELECT COUNT(*) FROM ArticleContents WHERE CreatedTime = @MigrationStartTime AND LocaleCode = 'zh-TW' AND IsVisible = 1) AS Zh_Visible,
    (SELECT COUNT(*) FROM ArticleContents WHERE CreatedTime = @MigrationStartTime AND LocaleCode = 'en' AND IsVisible = 1) AS En_Visible,
    (SELECT COUNT(*) FROM ArticleContents WHERE CreatedTime = @MigrationStartTime AND IsVisible = 0) AS Hidden_Contents,
    (SELECT COUNT(*) FROM ArticleAttachments WHERE CreatedTime = @MigrationStartTime) AS Attachments_Inserted;

PRINT '範例前 5 筆：';
SELECT TOP 5 a.ArticleId, a.TagCode, ac.LocaleCode, ac.IsVisible, ac.Title
FROM Articles a
JOIN ArticleContents ac ON a.ArticleId = ac.ArticleId
WHERE a.CreatedTime = @MigrationStartTime
ORDER BY a.ArticleId, ac.LocaleCode;

PRINT '========================================';
PRINT 'Script 24 - News 雙語遷移重作完成';
PRINT '完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- 清理暫存表
DROP TABLE IF EXISTS #Map_News_Zh;
DROP TABLE IF EXISTS #Map_News_En;
DROP TABLE IF EXISTS #Map_ArtNews_Zh;
DROP TABLE IF EXISTS #Map_ArtNews_En;

