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

-- ========================================
-- 2. Insert VideoTranslations (Traditional Chinese)
-- ========================================
PRINT '步驟 2a: 遷移 VideoTranslations (中文版)...';
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
    'zh-TW' AS LocaleCode,  -- Always Traditional Chinese for first insert
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

PRINT '✓ VideoTranslations (中文版) 遷移完成';
GO

-- ========================================
-- 3. Insert VideoTranslations (English)
-- ========================================
PRINT '步驟 2b: 遷移 VideoTranslations (英文版)...';
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
    'en' AS LocaleCode,  -- Always English for second insert
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
    LTRIM(RTRIM(src.title)) AS Title,  -- Use same title for now
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

PRINT '✓ VideoTranslations (英文版) 遷移完成';
GO

-- ========================================
-- 4. Verification Queries
-- ========================================
PRINT 'Migration completed. Verification results:';
PRINT '=====================================';

PRINT 'Total Videos migrated:';
SELECT COUNT(*) AS VideoCount FROM Videos;

PRINT 'Total VideoTranslations migrated:';
SELECT COUNT(*) AS VideoTranslationCount FROM VideoTranslations;

PRINT 'Dual language validation (should be Videos x2):';
SELECT 
    'Expected VideoTranslations' as CheckType,
    (SELECT COUNT(*) FROM Videos) * 2 as ExpectedCount,
    (SELECT COUNT(*) FROM VideoTranslations) as ActualCount,
    CASE 
        WHEN (SELECT COUNT(*) FROM Videos) * 2 = (SELECT COUNT(*) FROM VideoTranslations)
        THEN '✓ 成功'
        ELSE '✗ 失敗'
    END as ValidationResult;

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
GROUP BY LocaleCode
ORDER BY LocaleCode;

PRINT 'Dual language coverage check:';
SELECT 
    v.VideoId,
    COUNT(vt.VideoTranslationId) as TranslationCount,
    STRING_AGG(vt.LocaleCode, ', ') as AvailableLocales
FROM Videos v
LEFT JOIN VideoTranslations vt ON v.VideoId = vt.VideoId
GROUP BY v.VideoId
HAVING COUNT(vt.VideoTranslationId) != 2
ORDER BY v.VideoId;

PRINT 'Sample migrated videos with dual language:';
SELECT TOP 5
    v.VideoId,
    v.CreatedTime,
    v.Status,
    vt_zh.Title as ChineseTitle,
    vt_en.Title as EnglishTitle,
    LEFT(vt_zh.Url, 50) + '...' AS UrlPreview
FROM Videos v
INNER JOIN VideoTranslations vt_zh ON v.VideoId = vt_zh.VideoId AND vt_zh.LocaleCode = 'zh-TW'
INNER JOIN VideoTranslations vt_en ON v.VideoId = vt_en.VideoId AND vt_en.LocaleCode = 'en'
ORDER BY v.CreatedTime DESC;

GO