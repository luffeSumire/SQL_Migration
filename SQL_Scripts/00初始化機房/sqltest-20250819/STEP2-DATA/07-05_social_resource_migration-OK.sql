-- ========================================
-- Social Resource Migration Script (Fixed and Tested)
-- Source: EcoCampus_Maria3.custom_social_agency, custom_social_agency_to_tag, custom_tag
-- Target: SocialAgencies, SocialAgencyContents, SocialAgencyTagMappings
-- Created: 2025-08-05
-- Last Updated: 2025-08-05 (Fixed IDENTITY_INSERT and UNIQUE KEY issues)
-- ========================================

-- ========================================
-- Environment Configuration
-- ========================================
-- Target Database (modify for different environments)
-- Test Environment: Ecocampus
-- Production Environment: Ecocampus (or other production database name)
USE Ecocampus;

-- Source Database (usually fixed as legacy system)
-- DECLARE @SourceDB NVARCHAR(100) = 'EcoCampus_Maria3';
-- ========================================
GO

PRINT '========================================';
PRINT 'Social Resource Migration Script Started';
PRINT 'Execution Time: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- ========================================
-- 0. 清空 SocialAgencies 相關資料表
-- ========================================
PRINT '步驟 0: 清空 SocialAgencies 相關資料表...';

-- 停用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SocialAgencyTagMappings')
    ALTER TABLE SocialAgencyTagMappings NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SocialAgencyContents')
    ALTER TABLE SocialAgencyContents NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SocialAgencies')
    ALTER TABLE SocialAgencies NOCHECK CONSTRAINT ALL;

-- 清空資料 (從子表到主表的順序)
DELETE FROM SocialAgencyTagMappings;
DELETE FROM SocialAgencyContents;
DELETE FROM SocialAgencies;

-- 重新啟用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SocialAgencyTagMappings')
    ALTER TABLE SocialAgencyTagMappings WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SocialAgencyContents')
    ALTER TABLE SocialAgencyContents WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SocialAgencies')
    ALTER TABLE SocialAgencies WITH CHECK CHECK CONSTRAINT ALL;

-- 重置自增欄位
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('SocialAgencies'))
    DBCC CHECKIDENT ('SocialAgencies', RESEED, 0);

PRINT '✓ SocialAgencies 相關資料表已清空';
GO

-- ========================================
-- 1. Insert SocialAgencies Main Table Data
-- ========================================
PRINT 'Step 1: Migrating SocialAgencies main table data...';

-- Enable identity insert to preserve original IDs
SET IDENTITY_INSERT SocialAgencies ON;

INSERT INTO SocialAgencies (
    SocialAgencyId, 
    IsActive, 
    SortOrder, 
    Status, 
    ContactPerson, 
    ContactPhone, 
    ContactEmail, 
    ContactWebsite, 
    CreatedTime, 
    CreatedUserId
)
SELECT 
    csa.sid as SocialAgencyId,
    1 as IsActive,                        -- Default active
    0 as SortOrder,                       -- Default sort order
    1 as Status,                          -- Active status
    -- Parse ContactPerson from contact_info
    CASE 
        WHEN CHARINDEX(N'聯絡人：', csa.contact_info) > 0 
        THEN LTRIM(RTRIM(SUBSTRING(csa.contact_info, 
                      CHARINDEX(N'聯絡人：', csa.contact_info) + 4, 
                      CHARINDEX(CHAR(13) + CHAR(10), csa.contact_info, CHARINDEX(N'聯絡人：', csa.contact_info)) - CHARINDEX(N'聯絡人：', csa.contact_info) - 4)))
        ELSE NULL 
    END as ContactPerson,
    -- Parse ContactPhone from contact_info
    CASE 
        WHEN CHARINDEX(N'電話：', csa.contact_info) > 0 
        THEN LTRIM(RTRIM(SUBSTRING(csa.contact_info, 
                      CHARINDEX(N'電話：', csa.contact_info) + 3, 
                      CHARINDEX(CHAR(13) + CHAR(10), csa.contact_info, CHARINDEX(N'電話：', csa.contact_info)) - CHARINDEX(N'電話：', csa.contact_info) - 3)))
        ELSE NULL 
    END as ContactPhone,
    -- Parse ContactEmail from contact_info
    CASE 
        WHEN CHARINDEX(N'信箱：', csa.contact_info) > 0 
        THEN LTRIM(RTRIM(SUBSTRING(csa.contact_info, 
                      CHARINDEX(N'信箱：', csa.contact_info) + 3, 
                      CHARINDEX(CHAR(13) + CHAR(10), csa.contact_info, CHARINDEX(N'信箱：', csa.contact_info)) - CHARINDEX(N'信箱：', csa.contact_info) - 3)))
        ELSE NULL 
    END as ContactEmail,
    -- Parse ContactWebsite from contact_info (look for https or http)
    CASE 
        WHEN CHARINDEX('https://', csa.contact_info) > 0 
        THEN LTRIM(RTRIM(SUBSTRING(csa.contact_info, 
                      CHARINDEX('https://', csa.contact_info),
                      LEN(csa.contact_info))))
        WHEN CHARINDEX('http://', csa.contact_info) > 0 
        THEN LTRIM(RTRIM(SUBSTRING(csa.contact_info, 
                      CHARINDEX('http://', csa.contact_info),
                      LEN(csa.contact_info))))
        ELSE NULL 
    END as ContactWebsite,
    CASE 
        WHEN csa.createdate IS NOT NULL AND csa.createdate > 0 
        THEN DATEADD(SECOND, csa.createdate, '1970-01-01')
        ELSE SYSDATETIME()
    END as CreatedTime,
    1 as CreatedUserId                    -- Default admin ID
FROM EcoCampus_Maria3.dbo.custom_social_agency csa
ORDER BY csa.sid;

-- Disable identity insert after completion
SET IDENTITY_INSERT SocialAgencies OFF;

PRINT 'SocialAgencies insertion completed, total records: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));
GO

-- ========================================
-- 2. Insert SocialAgencyContents Multi-language Content
-- ========================================
PRINT 'Step 2: Migrating SocialAgencyContents multilingual content...';

INSERT INTO SocialAgencyContents (
    SocialAgencyId, 
    LocaleCode, 
    Title, 
    Introduction, 
    CreatedTime, 
    CreatedUserId
)
SELECT 
    csa.sid as SocialAgencyId,
    'zh-TW' as LocaleCode,
    csa.title as Title,
    csa.description as Introduction,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId
FROM EcoCampus_Maria3.dbo.custom_social_agency csa
WHERE csa.title IS NOT NULL AND csa.title != ''
ORDER BY csa.sid;

PRINT 'SocialAgencyContents insertion completed, total records: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));
GO

-- ========================================
-- 2.1. Insert English Language Content (Same Content as Chinese)
-- ========================================
PRINT 'Step 2.1: Migrating SocialAgencyContents English content (duplicating Chinese content)...';

INSERT INTO SocialAgencyContents (
    SocialAgencyId, 
    LocaleCode, 
    Title, 
    Introduction, 
    CreatedTime, 
    CreatedUserId
)
SELECT 
    csa.sid as SocialAgencyId,
    'en' as LocaleCode,
    csa.title as Title,
    csa.description as Introduction,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId
FROM EcoCampus_Maria3.dbo.custom_social_agency csa
WHERE csa.title IS NOT NULL AND csa.title != ''
ORDER BY csa.sid;

PRINT 'SocialAgencyContents English content insertion completed, total records: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));
GO

-- ========================================
-- 3. Insert SocialAgencyTagMappings Tag Associations (CORRECTED FOR MULTIPLE TAGS)
-- ========================================
PRINT 'Step 3: Migrating SocialAgencyTagMappings tag associations (handling multiple tags per agency)...';

-- Insert each tag as independent mapping (DO NOT use DISTINCT)
-- This ensures agencies with multiple tags get multiple mappings
INSERT INTO SocialAgencyTagMappings (
    SocialAgencyId, 
    SocialAgencyTagId, 
    CreatedTime, 
    CreatedUserId
)
SELECT 
    csat.social_agency_sid as SocialAgencyId,
    -- Map based on specific tag IDs from source data analysis
    CASE 
        -- tag 53: 硬體(含基礎設施(如綠能設備、節能設備等)) -> hardware_resources
        WHEN csat.tag_sid = 53 THEN 1 
        -- tag 46: 認證資源、設備 -> certification_funding (contains certification)
        WHEN csat.tag_sid = 46 THEN 3
        -- tag 47: 認證、師資、認證設備、人員 -> teaching_support (contains teaching staff)
        WHEN csat.tag_sid = 47 THEN 2
        -- tag 48: 其他 -> others
        WHEN csat.tag_sid = 48 THEN 4
        -- default to others
        ELSE 4
    END as SocialAgencyTagId,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId
FROM EcoCampus_Maria3.dbo.custom_social_agency_to_tag csat
INNER JOIN EcoCampus_Maria3.dbo.custom_tag ct ON csat.tag_sid = ct.sid
WHERE ct.type = 'resource'
  AND EXISTS (SELECT 1 FROM SocialAgencies sa WHERE sa.SocialAgencyId = csat.social_agency_sid)
ORDER BY csat.social_agency_sid, csat.tag_sid;

PRINT 'SocialAgencyTagMappings insertion completed, total records: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));
GO

-- ========================================
-- Migration Result Verification
-- ========================================
PRINT '========================================';
PRINT 'Migration completed, executing result verification...';
PRINT '========================================';

-- Statistics for each table
PRINT 'Table Data Statistics:';
SELECT 'SocialAgencies' as TableName, COUNT(*) as RecordCount FROM SocialAgencies
UNION ALL
SELECT 'SocialAgencyContents', COUNT(*) FROM SocialAgencyContents  
UNION ALL
SELECT 'SocialAgencyTagMappings', COUNT(*) FROM SocialAgencyTagMappings;

-- Data integrity verification
PRINT 'Data Integrity Check:';
SELECT 
    sa.SocialAgencyId,
    sa.Status,
    sac.Title,
    sac.LocaleCode,
    COUNT(satm.SocialAgencyTagId) as TagCount
FROM SocialAgencies sa
LEFT JOIN SocialAgencyContents sac ON sa.SocialAgencyId = sac.SocialAgencyId
LEFT JOIN SocialAgencyTagMappings satm ON sa.SocialAgencyId = satm.SocialAgencyId
GROUP BY sa.SocialAgencyId, sa.Status, sac.Title, sac.LocaleCode
ORDER BY sa.SocialAgencyId;

PRINT '========================================';
PRINT 'Social Resource Migration Completed!';
PRINT 'Completion Time: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';