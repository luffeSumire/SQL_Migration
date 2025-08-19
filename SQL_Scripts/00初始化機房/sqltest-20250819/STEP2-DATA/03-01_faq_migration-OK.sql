-- ========================================
-- FAQ 完整遷移腳本 (穩定版本)
-- 來源: EcoCampus_Maria3.custom_article (type='fqa')
-- 目標: Faqs, FaqContents
-- 建立日期: 2025-08-05
-- ========================================

-- ========================================
-- 環境設定區 (依環境調整以下設定)
-- ========================================
-- 目標資料庫設定 (請依環境修改)
-- 測試環境: Ecocampus
-- 正式環境: Ecocampus (或其他正式環境名稱)
USE Ecocampus;

-- 來源資料庫設定 (通常固定為舊系統)
-- DECLARE @SourceDB NVARCHAR(100) = 'EcoCampus_Maria3';
-- ========================================
GO

PRINT '========================================';
PRINT 'FAQ 遷移腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- ========================================
-- 0. 清空 FAQ 相關資料表
-- ========================================
PRINT '步驟 0: 清空 FAQ 相關資料表...';

-- 停用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FaqContents')
    ALTER TABLE FaqContents NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Faqs')
    ALTER TABLE Faqs NOCHECK CONSTRAINT ALL;

-- 清空資料 (從子表到主表的順序)
DELETE FROM FaqContents;
DELETE FROM Faqs;

-- 重新啟用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FaqContents')
    ALTER TABLE FaqContents WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Faqs')
    ALTER TABLE Faqs WITH CHECK CHECK CONSTRAINT ALL;

-- 重置自增欄位
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Faqs'))
    DBCC CHECKIDENT ('Faqs', RESEED, 0);

PRINT '✓ FAQ 相關資料表已清空';
GO

-- ========================================
-- 1. 插入 Faqs 主表資料
-- ========================================
PRINT '步驟 1: 遷移 Faqs 主表資料...';

INSERT INTO Faqs (TagId, Author, PublishDate, CreatedTime, CreatedUserId, Status, SortOrder)
SELECT 
    -- Tag 對應規則 (根據來源的 tag_sid 對應到新系統)
    CASE 
        WHEN ca.tag_sid = 3 THEN 4    -- 系統操作
        WHEN ca.tag_sid = 29 THEN 1   -- 計畫實施  
        WHEN ca.tag_sid = 28 THEN 2   -- 認證標準
        WHEN ca.tag_sid = 26 THEN 3   -- 成果文件
        WHEN ca.tag_sid = 2 THEN 5    -- 其他
        ELSE 5                        -- 預設為其他
    END as TagId,
    '管理員' as Author,                -- 預設作者
    DATEADD(SECOND, ca.createdate, '1970-01-01') as PublishDate,  -- Unix timestamp 轉換
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId,               -- 預設管理員 ID
    1 as Status,                      -- 啟用狀態
    0 as SortOrder                    -- 預設排序
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'fqa'
  AND ca.lan = 'zh_tw'               -- 只處理中文版，避免重複
ORDER BY ca.createdate;

DECLARE @FaqsCount INT = @@ROWCOUNT;
PRINT '✓ Faqs 主表遷移完成: ' + CAST(@FaqsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 2. 插入 FaqContents 內容資料 (中文版)
-- ========================================
PRINT '步驟 2: 遷移 FaqContents 中文內容...';

WITH SourceData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY createdate) as rn,
        sid, title, COALESCE(explanation, '') as explanation 
    FROM EcoCampus_Maria3.dbo.custom_article 
    WHERE type = 'fqa' AND lan = 'zh_tw'
),
TargetData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY FaqId DESC) as rn,
        FaqId 
    FROM Faqs 
    WHERE CreatedTime > DATEADD(MINUTE, -5, SYSDATETIME())
)
INSERT INTO FaqContents (FaqId, LocaleCode, Question, Answer, CreatedTime, CreatedUserId)
SELECT 
    t.FaqId,
    'zh-TW' as LocaleCode,
    s.title,
    s.explanation,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId
FROM SourceData s 
INNER JOIN TargetData t ON s.rn = t.rn;

DECLARE @ContentsZhCount INT = @@ROWCOUNT;
PRINT '✓ FaqContents 中文版遷移完成: ' + CAST(@ContentsZhCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 3. 插入 FaqContents 內容資料 (英文版)
-- ========================================
PRINT '步驟 3: 遷移 FaqContents 英文內容...';

INSERT INTO FaqContents (FaqId, LocaleCode, Question, Answer, CreatedTime, CreatedUserId)
SELECT 
    FaqId,
    'en' as LocaleCode,
    Question,  -- 複製中文內容到英文版
    Answer,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId
FROM FaqContents 
WHERE LocaleCode = 'zh-TW'
  AND CreatedTime > DATEADD(MINUTE, -5, SYSDATETIME());

DECLARE @ContentsEnCount INT = @@ROWCOUNT;
PRINT '✓ FaqContents 英文版遷移完成: ' + CAST(@ContentsEnCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 4. 遷移結果統計和驗證
-- ========================================
PRINT '========================================';
PRINT '遷移結果統計:';
PRINT '========================================';

SELECT 
    'FAQ遷移完成統計' as [遷移項目],
    (SELECT COUNT(*) FROM Faqs WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())) as [Faqs主表],
    (SELECT COUNT(*) FROM FaqContents WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME()) AND LocaleCode = 'zh-TW') as [中文內容],
    (SELECT COUNT(*) FROM FaqContents WHERE CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME()) AND LocaleCode = 'en') as [英文內容];

-- ========================================
-- 5. 顯示遷移結果範例
-- ========================================
PRINT '遷移結果範例 (前5筆):';

SELECT TOP 5
    f.FaqId as [FAQ ID],
    ft.FaqTagCode as [標籤代碼],
    ftc.FaqTagName as [標籤名稱],
    fc.Question as [問題],
    LEFT(fc.Answer, 30) + '...' as [答案預覽],
    fc.LocaleCode as [語言]
FROM Faqs f
INNER JOIN FaqTags ft ON f.TagId = ft.FaqTagId
INNER JOIN FaqTagContents ftc ON ft.FaqTagId = ftc.FaqTagId AND ftc.LocaleCode = 'zh-TW'
INNER JOIN FaqContents fc ON f.FaqId = fc.FaqId
WHERE f.CreatedTime > DATEADD(MINUTE, -10, SYSDATETIME())
ORDER BY f.FaqId, fc.LocaleCode;

-- ========================================
-- 6. 資料對應驗證範例
-- ========================================
PRINT '資料對應驗證範例:';

SELECT TOP 5
    '原始資料對應' as [驗證項目],
    ca.sid as [原始SID],
    ca.title as [原始問題],
    LEFT(COALESCE(ca.explanation, ''), 30) + '...' as [原始答案預覽],
    ca.tag_sid as [原始標籤ID],
    ca.createdate as [原始建立時間]
FROM EcoCampus_Maria3.dbo.custom_article ca
WHERE ca.type = 'fqa' AND ca.lan = 'zh_tw'
ORDER BY ca.createdate;

-- ========================================
-- 7. 完成訊息
-- ========================================
PRINT '========================================';
PRINT '✅ FAQ 遷移腳本執行完成！';
PRINT '遷移說明:';
PRINT '- 來源: custom_article (type=''fqa'')';
PRINT '- 標籤對應: 3→4, 29→1, 28→2, 26→3, 2→5';
PRINT '- 支援中英文雙語版本';
PRINT '- 使用穩定的CTE對應機制';
PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

GO