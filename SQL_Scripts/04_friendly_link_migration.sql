-- ========================================
-- FriendlyLink 完整遷移腳本
-- 來源: EcoCampus_Maria3.custom_article (type='related')
-- 目標: FriendlyLinks, FriendlyLinkTranslations
-- 建立日期: 2025-08-05
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
PRINT 'FriendlyLink 遷移腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- ========================================
-- 0. 清空 FriendlyLinks 相關資料表
-- ========================================
PRINT '步驟 0: 清空 FriendlyLinks 相關資料表...';

-- 停用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FriendlyLinkTranslations')
    ALTER TABLE FriendlyLinkTranslations NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FriendlyLinks')
    ALTER TABLE FriendlyLinks NOCHECK CONSTRAINT ALL;

-- 清空資料 (從子表到主表的順序)
DELETE FROM FriendlyLinkTranslations;
DELETE FROM FriendlyLinks;

-- 重新啟用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FriendlyLinkTranslations')
    ALTER TABLE FriendlyLinkTranslations WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FriendlyLinks')
    ALTER TABLE FriendlyLinks WITH CHECK CHECK CONSTRAINT ALL;

-- 重置自增欄位
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('FriendlyLinks'))
    DBCC CHECKIDENT ('FriendlyLinks', RESEED, 0);

PRINT '✓ FriendlyLinks 相關資料表已清空';
GO

-- ========================================
-- 1. 插入 FriendlyLinks 主表資料
-- ========================================
PRINT '步驟 1: 遷移 FriendlyLinks 主表資料...';

INSERT INTO FriendlyLinks (FriendlyLinkTagId, IsActive, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status, SortOrder)
SELECT 
    -- Tag 對應規則 (根據來源的 tag_sid 對應到新系統)
    -- 注意：目標表的類型不可覆蓋，固定為 domestic(1) 和 international(2)
    CASE 
        WHEN ca.tag_sid = 6 THEN 2    -- 國外友善連結 (修正對應)
        WHEN ca.tag_sid = 5 THEN 1    -- 國內友善連結 (修正對應)
        ELSE 1                        -- 預設為國內友善連結
    END as FriendlyLinkTagId,
    1 as IsActive,                    -- 啟用狀態
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,               -- 預設管理員 ID
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId,               -- 預設管理員 ID
    1 as Status,                      -- 啟用狀態
    0 as SortOrder                    -- 預設排序
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'related'
  AND ca.lan = 'zh_tw'               -- 只處理中文版，避免重複
ORDER BY ca.createdate;

DECLARE @FriendlyLinksCount INT = @@ROWCOUNT;
PRINT '✓ FriendlyLinks 主表遷移完成: ' + CAST(@FriendlyLinksCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 2. 插入 FriendlyLinkTranslations 內容資料 (中文版)
-- ========================================
PRINT '步驟 2: 遷移 FriendlyLinkTranslations 中文內容...';

WITH SourceData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY createdate) as rn,
        sid, title, COALESCE(link, '') as link 
    FROM EcoCampus_Maria3.dbo.custom_article 
    WHERE type = 'related' AND lan = 'zh_tw'
),
TargetData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY FriendlyLinkId DESC) as rn,
        FriendlyLinkId 
    FROM FriendlyLinks 
    WHERE CreatedTime > DATEADD(MINUTE, -5, SYSDATETIME())
)
INSERT INTO FriendlyLinkTranslations (FriendlyLinkId, LocaleCode, IsDefault, Title, Url, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    t.FriendlyLinkId,
    'zh-TW' as LocaleCode,
    1 as IsDefault,                   -- 中文版為預設
    s.title,
    s.link,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId
FROM SourceData s 
INNER JOIN TargetData t ON s.rn = t.rn;

DECLARE @TranslationsZhCount INT = @@ROWCOUNT;
PRINT '✓ FriendlyLinkTranslations 中文版遷移完成: ' + CAST(@TranslationsZhCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 3. 插入 FriendlyLinkTranslations 內容資料 (英文版)
-- ========================================
PRINT '步驟 3: 遷移 FriendlyLinkTranslations 英文內容...';

-- 查找是否有對應的英文版資料
WITH SourceDataEn AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ca_zh.createdate) as rn,
        ca_zh.sid as zh_sid,
        COALESCE(ca_en.title, ca_zh.title) as title,
        COALESCE(ca_en.link, ca_zh.link) as link
    FROM EcoCampus_Maria3.dbo.custom_article ca_zh
    LEFT JOIN EcoCampus_Maria3.dbo.custom_article ca_en 
        ON ca_zh.title = ca_en.title 
        AND ca_en.type = 'related' 
        AND ca_en.lan = 'en'
    WHERE ca_zh.type = 'related' AND ca_zh.lan = 'zh_tw'
),
TargetData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY FriendlyLinkId DESC) as rn,
        FriendlyLinkId 
    FROM FriendlyLinks 
    WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())
)
INSERT INTO FriendlyLinkTranslations (FriendlyLinkId, LocaleCode, IsDefault, Title, Url, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId)
SELECT 
    t.FriendlyLinkId,
    'en' as LocaleCode,
    0 as IsDefault,                   -- 英文版非預設
    s.title,
    s.link,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,
    SYSDATETIME() as UpdatedTime,
    1 as UpdatedUserId
FROM SourceDataEn s 
INNER JOIN TargetData t ON s.rn = t.rn;

DECLARE @TranslationsEnCount INT = @@ROWCOUNT;
PRINT '✓ FriendlyLinkTranslations 英文版遷移完成: ' + CAST(@TranslationsEnCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 4. 遷移結果統計和驗證
-- ========================================
PRINT '========================================';
PRINT '遷移結果統計:';
PRINT '========================================';

SELECT 
    '友善連結遷移完成統計' as [遷移項目],
    (SELECT COUNT(*) FROM FriendlyLinks WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())) as [FriendlyLinks主表],
    (SELECT COUNT(*) FROM FriendlyLinkTranslations WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME()) AND LocaleCode = 'zh-TW') as [中文內容],
    (SELECT COUNT(*) FROM FriendlyLinkTranslations WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME()) AND LocaleCode = 'en') as [英文內容];

-- ========================================
-- 5. 顯示遷移結果範例
-- ========================================
PRINT '遷移結果範例 (前5筆):';

SELECT TOP 5
    fl.FriendlyLinkId as [友善連結ID],
    fltt.Name as [標籤名稱],
    flt.Title as [標題],
    LEFT(flt.Url, 50) + '...' as [網址預覽],
    flt.LocaleCode as [語言],
    flt.IsDefault as [是否預設]
FROM FriendlyLinks fl
INNER JOIN FriendlyLinkTags flt_tag ON fl.FriendlyLinkTagId = flt_tag.FriendlyLinkTagId
INNER JOIN FriendlyLinkTagTranslations fltt ON flt_tag.FriendlyLinkTagId = fltt.FriendlyLinkTagId AND fltt.LocaleCode = 'zh-TW'
INNER JOIN FriendlyLinkTranslations flt ON fl.FriendlyLinkId = flt.FriendlyLinkId
WHERE fl.CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())
ORDER BY fl.FriendlyLinkId, flt.LocaleCode;

-- ========================================
-- 6. 資料對應驗證範例
-- ========================================
PRINT '資料對應驗證範例:';

SELECT TOP 5
    '原始資料對應' as [驗證項目],
    ca.sid as [原始SID],
    ca.title as [原始標題],
    LEFT(ca.link, 30) + '...' as [原始連結],
    ca.tag_sid as [原始標籤ID],
    ca.createdate as [原始建立時間]
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'related' AND ca.lan = 'zh_tw'
ORDER BY ca.createdate;

-- ========================================
-- 7. 完成訊息
-- ========================================
PRINT '========================================';
PRINT '✅ FriendlyLink 遷移腳本執行完成！';
PRINT '遷移說明:';
PRINT '- 來源: custom_article (type=''related'')';
PRINT '- 目標類型: tag_sid 5=國內(1), 6=國外(2)';
PRINT '- 支援中英文雙語版本';
PRINT '- 保持原始連結和標題';
PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

GO

-- ✓ FIXED: 國內國外對應已修正 (tag_sid 5->國內(1), tag_sid 6->國外(2))