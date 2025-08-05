-- =============================================
-- Video Migration Script
-- Source: custom_article (type='video') from EcoCampus_Maria3
-- Target: Videos and VideoTranslations tables in EcoCampus_PreProduction
-- =============================================

USE EcoCampus_PreProduction;
GO

PRINT '========================================';
PRINT 'Video Migration Script Started';
PRINT 'Execution Time: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- ========================================
-- 0. 清空 Videos 相關資料表
-- ========================================
PRINT '步驟 0: 清空 Videos 相關資料表...';

-- 停用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'VideoTranslations')
    ALTER TABLE VideoTranslations NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Videos')
    ALTER TABLE Videos NOCHECK CONSTRAINT ALL;

-- 清空資料 (從子表到主表的順序)
DELETE FROM VideoTranslations;
DELETE FROM Videos;

-- 重新啟用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'VideoTranslations')
    ALTER TABLE VideoTranslations WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Videos')
    ALTER TABLE Videos WITH CHECK CHECK CONSTRAINT ALL;

-- 重置自增欄位
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Videos'))
    DBCC CHECKIDENT ('Videos', RESEED, 0);
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('VideoTranslations'))
    DBCC CHECKIDENT ('VideoTranslations', RESEED, 0);

PRINT '✓ Videos 相關資料表已清空';
GO

-- ========================================
-- 1. Insert Videos (main records)
-- ========================================
PRINT '步驟 1: 遷移 Videos 主表資料...';
INSERT INTO Videos (
    CreatedTime,
    CreatedUserId,
    UpdatedTime,
    UpdatedUserId,
    Status,
    DeletedTime,
    DeletedUserId,
    SortOrder
)
SELECT 
    DATEADD(SECOND, src.createdate, '1970-01-01 00:00:00') AS CreatedTime,
    1 AS CreatedUserId,  -- Default system user
    CASE 
        WHEN src.updatedate IS NOT NULL AND src.updatedate > 0
        THEN DATEADD(SECOND, src.updatedate, '1970-01-01 00:00:00')
        ELSE DATEADD(SECOND, src.createdate, '1970-01-01 00:00:00')
    END AS UpdatedTime,
    1 AS UpdatedUserId,  -- Default system user
    CASE 
        WHEN src.is_show = 1 THEN 1  -- Active
        ELSE 2  -- Inactive
    END AS Status,
    NULL AS DeletedTime,
    NULL AS DeletedUserId,
    ISNULL(src.sequence, 0) AS SortOrder
FROM [EcoCampus_Maria3].[dbo].[custom_article] src
WHERE src.type = 'video'
    AND src.title IS NOT NULL
    AND LTRIM(RTRIM(src.title)) <> ''
ORDER BY src.createdate DESC;
GO

-- Insert VideoTranslations  
INSERT INTO VideoTranslations (
    VideoId,
    LocaleCode,
    Url,
    Title,
    CoverFileId,
    CreatedTime,
    CreatedUserId,
    UpdatedTime,
    UpdatedUserId
)
SELECT 
    v.VideoId,
    CASE 
        WHEN src.lan = 'zh_tw' THEN 'zh-TW'
        WHEN src.lan = 'en' THEN 'en'
        ELSE 'zh-TW'  -- Default to Traditional Chinese
    END AS LocaleCode,
    CASE 
        WHEN src.link IS NOT NULL AND LTRIM(RTRIM(src.link)) <> '' 
        THEN 
            CASE 
                -- Extract YouTube URL from iframe src attribute
                WHEN src.link LIKE '%src="%'
                THEN 
                    CASE
                        WHEN CHARINDEX('src="', src.link) > 0
                        THEN SUBSTRING(
                            src.link, 
                            CHARINDEX('src="', src.link) + 5,
                            CASE 
                                WHEN CHARINDEX('"', src.link, CHARINDEX('src="', src.link) + 5) > 0
                                THEN CHARINDEX('"', src.link, CHARINDEX('src="', src.link) + 5) - CHARINDEX('src="', src.link) - 5
                                ELSE 500
                            END
                        )
                        ELSE LTRIM(RTRIM(src.link))
                    END
                ELSE LTRIM(RTRIM(src.link))
            END
        ELSE ''
    END AS Url,
    LTRIM(RTRIM(src.title)) AS Title,
    CASE 
        WHEN src.photo IS NOT NULL AND LTRIM(RTRIM(src.photo)) <> ''
        THEN (
            SELECT fe.Id 
            FROM FileEntry fe 
            INNER JOIN [EcoCampus_Maria3].[dbo].[sys_files_store] ss 
                ON fe.FileName = ss.name
            WHERE src.photo = CONCAT(ss.size, '__', ss.file_hash)
        )
        ELSE NULL
    END AS CoverFileId,
    v.CreatedTime,
    1 AS CreatedUserId,  -- Default system user
    v.UpdatedTime,
    1 AS UpdatedUserId  -- Default system user
FROM [EcoCampus_Maria3].[dbo].[custom_article] src
INNER JOIN Videos v ON ABS(DATEDIFF(SECOND, v.CreatedTime, DATEADD(SECOND, src.createdate, '1970-01-01 00:00:00'))) <= 1
    AND v.SortOrder = ISNULL(src.sequence, 0)
WHERE src.type = 'video'
    AND src.title IS NOT NULL
    AND LTRIM(RTRIM(src.title)) <> '';
GO

-- Verification queries
PRINT 'Migration completed. Verification results:';
PRINT '=====================================';

PRINT 'Total Videos migrated:';
SELECT COUNT(*) AS VideoCount FROM Videos;

PRINT 'Total VideoTranslations migrated:';
SELECT COUNT(*) AS VideoTranslationCount FROM VideoTranslations;

PRINT 'Videos by status:';
SELECT 
    Status,
    COUNT(*) AS Count
FROM Videos
GROUP BY Status;

PRINT 'VideoTranslations by locale:';
SELECT 
    LocaleCode,
    COUNT(*) AS Count
FROM VideoTranslations
GROUP BY LocaleCode;

PRINT 'Sample migrated videos:';
SELECT TOP 5
    v.VideoId,
    v.CreatedTime,
    v.Status,
    vt.LocaleCode,
    vt.Title,
    LEFT(vt.Url, 100) + '...' AS UrlPreview
FROM Videos v
INNER JOIN VideoTranslations vt ON v.VideoId = vt.VideoId
ORDER BY v.CreatedTime DESC;

GO