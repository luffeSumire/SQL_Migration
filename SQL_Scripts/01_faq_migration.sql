-- ========================================
-- FAQ 資料遷移腳本
-- 來源: EcoCampus_Maria3.custom_article (type='fqa')
-- 目標: EcoCampus_PreProduction.Faqs, FaqContents
-- 建立日期: 2025-07-29
-- ========================================

USE Ecocampus_PreProduction;
GO

-- 1. 插入 Faqs 主表資料
-- 根據來源資料的 tag_sid 對應到新系統的現有 TagId
INSERT INTO Faqs (TagId, Author, PublishDate, CreatedTime, CreatedUserId, Status, SortOrder)
SELECT 
    -- Tag 對應規則 (根據來源的 tag_sid 對應到新系統)
    CASE 
        WHEN ca.tag_sid = 3 THEN 4    -- 系統操作
        WHEN ca.tag_sid = 29 THEN 1   -- 計畫實施  
        WHEN ca.tag_sid = 28 THEN 2   -- 認證標準
        WHEN ca.tag_sid = 26 THEN 3   -- 成果文件
        WHEN ca.tag_sid = 2 THEN 5   -- 其他
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

-- 2. 插入 FaqContents 內容資料 (中文版)
INSERT INTO FaqContents (FaqId, LocaleCode, Question, Answer, CreatedTime, CreatedUserId)
SELECT 
    f.FaqId,
    'zh-TW' as LocaleCode,
    ca.title as Question,
    ca.explanation as Answer,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId
FROM EcoCampus_Maria3.dbo.custom_article ca
INNER JOIN (
    -- 取得剛插入的 FAQ ID 對應關係
    SELECT 
        ROW_NUMBER() OVER (ORDER BY ca2.createdate) as RowNum,
        f2.FaqId
    FROM EcoCampus_Maria3.dbo.custom_article ca2
    INNER JOIN Faqs f2 ON f2.FaqId > (
        SELECT ISNULL(MAX(FaqId), 0) 
        FROM Faqs 
        WHERE CreatedTime < DATEADD(MINUTE, -1, SYSDATETIME())
    )
    WHERE ca2.type = 'fqa' AND ca2.lan = 'zh_tw'
) f ON f.RowNum = ROW_NUMBER() OVER (ORDER BY ca.createdate)
WHERE ca.type = 'fqa' 
  AND ca.lan = 'zh_tw';

-- 3. 插入 FaqContents 內容資料 (英文版，複製中文內容)
INSERT INTO FaqContents (FaqId, LocaleCode, Question, Answer, CreatedTime, CreatedUserId)
SELECT 
    fc.FaqId,
    'en' as LocaleCode,
    fc.Question,  -- 根據需求，直接複製中文內容到英文版
    fc.Answer,
    SYSDATETIME() as CreatedTime,
    1 as CreatedUserId
FROM FaqContents fc
WHERE fc.LocaleCode = 'zh-TW'
  AND fc.CreatedTime > DATEADD(MINUTE, -1, SYSDATETIME());

-- 4. 驗證遷移結果
SELECT 
    '遷移完成統計' as Info,
    (SELECT COUNT(*) FROM Faqs WHERE CreatedTime > DATEADD(MINUTE, -1, SYSDATETIME())) as '新增FAQ數量',
    (SELECT COUNT(*) FROM FaqContents WHERE CreatedTime > DATEADD(MINUTE, -1, SYSDATETIME()) AND LocaleCode = 'zh-TW') as '中文內容數量',
    (SELECT COUNT(*) FROM FaqContents WHERE CreatedTime > DATEADD(MINUTE, -1, SYSDATETIME()) AND LocaleCode = 'en') as '英文內容數量';

-- 5. 顯示遷移結果範例
SELECT TOP 5
    f.FaqId,
    ft.FaqTagCode,
    ftc.FaqTagName,
    fc.Question,
    LEFT(fc.Answer, 50) + '...' as Answer_Preview,
    fc.LocaleCode
FROM Faqs f
INNER JOIN FaqTags ft ON f.TagId = ft.FaqTagId
INNER JOIN FaqTagContents ftc ON ft.FaqTagId = ftc.FaqTagId AND ftc.LocaleCode = 'zh-TW'
INNER JOIN FaqContents fc ON f.FaqId = fc.FaqId
WHERE f.CreatedTime > DATEADD(MINUTE, -1, SYSDATETIME())
ORDER BY f.FaqId, fc.LocaleCode;

GO