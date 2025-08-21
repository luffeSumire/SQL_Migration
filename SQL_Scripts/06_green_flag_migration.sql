-- ========================================
-- Green Flag Articles Migration Script (Simplified)
-- Source: EcoCampus_Maria3.custom_flagarea, custom_flagarea_data
-- Target: GreenFlagArticles, GreenFlagArticleContents, GreenFlagArticleAttachments
-- Created: 2025-08-05
-- ========================================

USE EcoCampus_PreProduction;
GO

PRINT '========================================';
PRINT 'Green Flag Articles Migration Script Started (Simplified)';
PRINT 'Execution Time: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- ========================================
-- 0. 清空 GreenFlagArticles 相關資料表
-- ========================================
PRINT '步驟 0: 清空 GreenFlagArticles 相關資料表...';

-- 停用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'GreenFlagArticleAttachments')
    ALTER TABLE GreenFlagArticleAttachments NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'GreenFlagArticleContents')
    ALTER TABLE GreenFlagArticleContents NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'GreenFlagArticles')
    ALTER TABLE GreenFlagArticles NOCHECK CONSTRAINT ALL;

-- 清空資料 (從子表到主表的順序)
DELETE FROM GreenFlagArticleAttachments;
DELETE FROM GreenFlagArticleContents;
DELETE FROM GreenFlagArticles;

-- 重新啟用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'GreenFlagArticleAttachments')
    ALTER TABLE GreenFlagArticleAttachments WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'GreenFlagArticleContents')
    ALTER TABLE GreenFlagArticleContents WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'GreenFlagArticles')
    ALTER TABLE GreenFlagArticles WITH CHECK CHECK CONSTRAINT ALL;

-- 重置自增欄位
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('GreenFlagArticles'))
    DBCC CHECKIDENT ('GreenFlagArticles', RESEED, 0);

PRINT '✓ GreenFlagArticles 相關資料表已清空';
GO

-- ========================================
-- 1. Insert GreenFlagArticles Main Table Data
-- ========================================
PRINT 'Step 1: Migrating GreenFlagArticles main table data...';

SET IDENTITY_INSERT GreenFlagArticles ON;

INSERT INTO GreenFlagArticles (
    GreenFlagArticleId,
    PublishDate,
    CreatedTime,
    CreatedUserId,
    Status,
    SortOrder
)
SELECT 
    cfa.sid as GreenFlagArticleId,
    CASE 
        WHEN cfa.createdate IS NOT NULL AND cfa.createdate > 0 
        THEN DATEADD(SECOND, cfa.createdate, '1970-01-01')
        ELSE SYSDATETIME()
    END as PublishDate,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    CASE 
        WHEN cfa.status = 1 THEN 1
        ELSE 0
    END as Status,
    0 as SortOrder
FROM EcoCampus_Maria3.dbo.custom_flagarea cfa
ORDER BY cfa.sid;

SET IDENTITY_INSERT GreenFlagArticles OFF;

PRINT 'GreenFlagArticles insertion completed, total records: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));
GO

-- ========================================
-- 2. Insert GreenFlagArticleContents Multi-language Content
-- ========================================
PRINT 'Step 2: Migrating GreenFlagArticleContents multilingual content...';

INSERT INTO GreenFlagArticleContents (
    GreenFlagArticleId,
    LocaleCode,
    Title,
    SchoolName,
    TextContent,
    BannerFileId,
    CreatedTime,
    CreatedUserId
)
SELECT 
    cfa.sid as GreenFlagArticleId,
    'zh-TW' as LocaleCode,
    cfa.title as Title,
    cfa.school as SchoolName,
    -- Simple concatenation of content fields
    ISNULL(cfa.intro, '') + 
    CASE WHEN cfa.feature IS NOT NULL AND cfa.feature != '' 
         THEN CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + cfa.feature 
         ELSE '' END +
    CASE WHEN cfa.course IS NOT NULL AND cfa.course != '' 
         THEN CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + cfa.course 
         ELSE '' END +
    CASE WHEN cfa.declaration IS NOT NULL AND cfa.declaration != '' 
         THEN CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + cfa.declaration
         ELSE '' END as TextContent,
    CASE 
        WHEN cfa.image IS NOT NULL AND cfa.image != ''
        THEN (SELECT TOP 1 fe.Id FROM FileEntry fe WHERE fe.FileName = cfa.image)
        ELSE NULL 
    END as BannerFileId,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId
FROM EcoCampus_Maria3.dbo.custom_flagarea cfa
WHERE cfa.title IS NOT NULL AND cfa.title != ''
ORDER BY cfa.sid;

PRINT 'GreenFlagArticleContents insertion completed, total records: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));
GO

-- ========================================
-- 2.1. Insert English Language Content (Same Content as Chinese)
-- ========================================
PRINT 'Step 2.1: Migrating GreenFlagArticleContents English content (duplicating Chinese content)...';

INSERT INTO GreenFlagArticleContents (
    GreenFlagArticleId,
    LocaleCode,
    Title,
    SchoolName,
    TextContent,
    BannerFileId,
    CreatedTime,
    CreatedUserId
)
SELECT 
    cfa.sid as GreenFlagArticleId,
    'en' as LocaleCode,
    cfa.title as Title,
    cfa.school as SchoolName,
    -- Simple concatenation of content fields
    ISNULL(cfa.intro, '') + 
    CASE WHEN cfa.feature IS NOT NULL AND cfa.feature != '' 
         THEN CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + cfa.feature 
         ELSE '' END +
    CASE WHEN cfa.course IS NOT NULL AND cfa.course != '' 
         THEN CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + cfa.course 
         ELSE '' END +
    CASE WHEN cfa.declaration IS NOT NULL AND cfa.declaration != '' 
         THEN CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + cfa.declaration
         ELSE '' END as TextContent,
    CASE 
        WHEN cfa.image IS NOT NULL AND cfa.image != ''
        THEN (SELECT TOP 1 fe.Id FROM FileEntry fe WHERE fe.FileName = cfa.image)
        ELSE NULL 
    END as BannerFileId,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId
FROM EcoCampus_Maria3.dbo.custom_flagarea cfa
WHERE cfa.title IS NOT NULL AND cfa.title != ''
ORDER BY cfa.sid;

PRINT 'GreenFlagArticleContents English content insertion completed, total records: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));
GO

-- ========================================
-- 3. Insert GreenFlagArticleAttachments
-- ========================================
PRINT 'Step 3: Migrating GreenFlagArticleAttachments...';

INSERT INTO GreenFlagArticleAttachments (
    GreenFlagArticleContentId,
    FileEntryId,
    ContentTypeCode,
    SortOrder,
    Title,
    AltUrl,
    CreatedTime,
    CreatedUserId
)
SELECT 
    gfac.GreenFlagArticleContentId,
    CASE 
        WHEN cfad.link IS NOT NULL AND cfad.link != '' AND cfad.type IN ('feature', 'course')
        THEN (SELECT TOP 1 fe.Id FROM FileEntry fe WHERE fe.FileName = cfad.link)
        ELSE NULL 
    END as FileEntryId,
    CASE 
        WHEN cfad.type = 'feature' THEN 'image'
        WHEN cfad.type = 'course' THEN 'image'
        WHEN cfad.type = 'video' THEN 'video'
        WHEN cfad.type = 'link' THEN 'link'
        ELSE 'other'
    END as ContentTypeCode,
    cfad.sequence as SortOrder,
    cfad.title as Title,
    CASE 
        WHEN cfad.type = 'link' THEN cfad.link
        WHEN cfad.type = 'video' AND CHARINDEX('https://', cfad.content) > 0 
        THEN SUBSTRING(cfad.content, 
                      CHARINDEX('https://', cfad.content),
                      CHARINDEX('"', cfad.content, CHARINDEX('https://', cfad.content)) - CHARINDEX('https://', cfad.content))
        ELSE NULL
    END as AltUrl,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId
FROM EcoCampus_Maria3.dbo.custom_flagarea_data cfad
INNER JOIN GreenFlagArticleContents gfac ON cfad.flag_sid = gfac.GreenFlagArticleId
WHERE cfad.title IS NOT NULL AND cfad.title != ''
  AND (
      (cfad.type IN ('feature', 'course') AND cfad.link IS NOT NULL AND cfad.link != '')
      OR
      (cfad.type = 'video' AND cfad.content IS NOT NULL AND cfad.content != '')
      OR
      (cfad.type = 'link' AND cfad.link IS NOT NULL AND cfad.link != '')
  )
ORDER BY cfad.flag_sid, cfad.sequence;

PRINT 'GreenFlagArticleAttachments insertion completed, total records: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));
GO

-- ========================================
-- Migration Result Verification
-- ========================================
PRINT '========================================';
PRINT 'Migration completed, executing result verification...';
PRINT '========================================';

SELECT 'GreenFlagArticles' as TableName, COUNT(*) as RecordCount FROM GreenFlagArticles
UNION ALL
SELECT 'GreenFlagArticleContents', COUNT(*) FROM GreenFlagArticleContents  
UNION ALL
SELECT 'GreenFlagArticleAttachments', COUNT(*) FROM GreenFlagArticleAttachments;

SELECT 
    gfa.GreenFlagArticleId,
    gfa.Status,
    gfac.Title,
    gfac.SchoolName,
    gfac.LocaleCode,
    COUNT(gfaa.GreenFlagArticleAttachmentId) as AttachmentCount
FROM GreenFlagArticles gfa
LEFT JOIN GreenFlagArticleContents gfac ON gfa.GreenFlagArticleId = gfac.GreenFlagArticleId
LEFT JOIN GreenFlagArticleAttachments gfaa ON gfac.GreenFlagArticleContentId = gfaa.GreenFlagArticleContentId
GROUP BY gfa.GreenFlagArticleId, gfa.Status, gfac.Title, gfac.SchoolName, gfac.LocaleCode
ORDER BY gfa.GreenFlagArticleId;

PRINT '========================================';
PRINT 'Green Flag Articles Migration Completed (Simplified)!';
PRINT 'Completion Time: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';