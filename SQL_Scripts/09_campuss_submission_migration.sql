-- ========================================
-- 校園投稿遷移腳本 (最終版)
-- 來源: EcoCampus_Maria3.custom_news (type='release'), custom_release_en_tw, custom_release_photo
-- 目標: EcoCampus_PreProduction.CampusSubmissions, CampusSubmissionContents, CampusSubmissionAttachments
-- 建立日期: 2025-08-06
-- 版本: v1.0 - 完整遷移腳本
-- ========================================

USE Ecocampus_PreProduction;

-- 記錄開始時間用於後續篩選
DECLARE @MigrationStartTime DATETIME2 = SYSDATETIME();

PRINT '========================================';
PRINT '校園投稿遷移腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, @MigrationStartTime, 120);
PRINT '========================================';

-- ========================================
-- 0. 清空 CampusSubmissions 相關資料表
-- ========================================
PRINT '步驟 0: 清空 CampusSubmissions 相關資料表...';

-- 停用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CampusSubmissionAttachments')
    ALTER TABLE CampusSubmissionAttachments NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CampusSubmissionContents')
    ALTER TABLE CampusSubmissionContents NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CampusSubmissions')
    ALTER TABLE CampusSubmissions NOCHECK CONSTRAINT ALL;

-- 清空資料 (從子表到主表的順序)
DELETE FROM CampusSubmissionAttachments;
DELETE FROM CampusSubmissionContents;
DELETE FROM CampusSubmissions;

-- 重新啟用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CampusSubmissionAttachments')
    ALTER TABLE CampusSubmissionAttachments WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CampusSubmissionContents')
    ALTER TABLE CampusSubmissionContents WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CampusSubmissions')
    ALTER TABLE CampusSubmissions WITH CHECK CHECK CONSTRAINT ALL;

-- 重置自增欄位
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('CampusSubmissions'))
    DBCC CHECKIDENT ('CampusSubmissions', RESEED, 0);

PRINT '✓ CampusSubmissions 相關資料表已清空';

-- ========================================
-- 1. 插入 CampusSubmissions 主表資料 (來源: custom_news type='release')
-- ========================================
PRINT '步驟 1: 遷移 custom_news (type=''release'') 到 CampusSubmissions...';

INSERT INTO CampusSubmissions (
    SubmissionDate, 
    BadgeType, 
    FeaturedStatus, 
    CreatedTime, 
    CreatedUserId,  -- 注意：member_sid 在系統上可能不齊全，暫時設為 1，需要後續 mapping
    UpdatedTime, 
    UpdatedUserId, 
    Status, 
    SortOrder,
    SchoolId
)
SELECT 
    CASE 
        WHEN cn.startdate IS NOT NULL AND cn.startdate != '' AND ISDATE(cn.startdate) = 1
        THEN CONVERT(DATETIME, cn.startdate + ' 00:00:00')
        WHEN cn.createdate IS NOT NULL AND cn.createdate > 0
        THEN DATEADD(SECOND, cn.createdate, '1970-01-01')
        ELSE '2015-01-01'
    END as SubmissionDate,
    1 as BadgeType, -- 預設徽章類型
    CASE WHEN cn.is_home = 1 THEN 1 ELSE 0 END as FeaturedStatus,
    @MigrationStartTime as CreatedTime,
    -- TODO: member_sid 對應問題 - 目前先設為 1，需要後續建立 member_sid 對應表
    1 as CreatedUserId, -- cn.member_sid, 
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId, -- cn.member_sid,
    CASE WHEN cn.is_show = 1 THEN 1 ELSE 0 END as Status,
    COALESCE(cn.sequence, 0) as SortOrder,
    1 as SchoolId -- 暫時設為預設值 1，後續需建立學校對應關係
FROM EcoCampus_Maria3.dbo.custom_news cn
WHERE cn.lan = 'zh_tw'
  AND cn.type = 'release'  -- 只處理校園投稿
ORDER BY COALESCE(cn.createdate, 0), cn.sid;

DECLARE @CampusSubmissionCount INT = @@ROWCOUNT;
PRINT '✓ custom_news (type=''release'') → CampusSubmissions 遷移完成: ' + CAST(@CampusSubmissionCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 2. 插入 CampusSubmissionContents 內容資料 (中文版)
-- ========================================
PRINT '步驟 2: 遷移 CampusSubmissionContents 中文內容...';

-- 直接插入中文內容，不使用複雜的 CTE
INSERT INTO CampusSubmissionContents (
    CampusSubmissionId, 
    LocaleCode, 
    IsDefault,
    Title, 
    Description, 
    CreatedTime, 
    CreatedUserId, 
    UpdatedTime, 
    UpdatedUserId
)
SELECT 
    cs.CampusSubmissionId,
    'zh-TW' as LocaleCode,
    1 as IsDefault, -- 中文版設為預設
    COALESCE(cn.title, N'無標題') as Title,
    COALESCE(cret.release_tw_content, N'<p>暫無內容</p>') as Description,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId, -- TODO: member_sid mapping
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId  -- TODO: member_sid mapping
FROM CampusSubmissions cs
INNER JOIN (
    SELECT 
        cn.sid,
        cn.title,
        ROW_NUMBER() OVER (ORDER BY cn.createdate, cn.sid) as RowNum
    FROM EcoCampus_Maria3.dbo.custom_news cn
    WHERE cn.lan = 'zh_tw' AND cn.type = 'release'
) cn ON cs.CampusSubmissionId = cn.RowNum
LEFT JOIN EcoCampus_Maria3.dbo.custom_release_en_tw cret ON cn.sid = cret.release_tw_sid
WHERE cs.CreatedTime >= DATEADD(SECOND, -5, @MigrationStartTime);

DECLARE @ContentsZhCount INT = @@ROWCOUNT;
PRINT '✓ CampusSubmissionContents 中文版遷移完成: ' + CAST(@ContentsZhCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 3. 插入 CampusSubmissionContents 內容資料 (英文版)
-- ========================================
PRINT '步驟 3: 遷移 CampusSubmissionContents 英文內容...';

-- 直接插入英文內容
INSERT INTO CampusSubmissionContents (
    CampusSubmissionId, 
    LocaleCode, 
    IsDefault,
    Title, 
    Description, 
    CreatedTime, 
    CreatedUserId, 
    UpdatedTime, 
    UpdatedUserId
)
SELECT 
    cs.CampusSubmissionId,
    'en' as LocaleCode,
    0 as IsDefault, -- 英文版非預設
    COALESCE(cn.title, N'No Title') as Title,
    CASE 
        WHEN cret.release_en_content IS NOT NULL AND cret.release_en_content != ''
        THEN cret.release_en_content
        ELSE COALESCE(cret.release_tw_content, N'<p>No Content Available</p>')
    END as Description,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId, -- TODO: member_sid mapping
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId  -- TODO: member_sid mapping
FROM CampusSubmissions cs
INNER JOIN (
    SELECT 
        cn.sid,
        cn.title,
        ROW_NUMBER() OVER (ORDER BY cn.createdate, cn.sid) as RowNum
    FROM EcoCampus_Maria3.dbo.custom_news cn
    WHERE cn.lan = 'zh_tw' AND cn.type = 'release'
) cn ON cs.CampusSubmissionId = cn.RowNum
LEFT JOIN EcoCampus_Maria3.dbo.custom_release_en_tw cret ON cn.sid = cret.release_tw_sid
WHERE cs.CreatedTime >= DATEADD(SECOND, -5, @MigrationStartTime);

DECLARE @ContentsEnCount INT = @@ROWCOUNT;
PRINT '✓ CampusSubmissionContents 英文版遷移完成: ' + CAST(@ContentsEnCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 4. 遷移附件資料 (CampusSubmissionAttachments)
-- ========================================
PRINT '步驟 4: 遷移校園投稿照片附件...';

-- 直接插入附件，使用 sys_files_store 來建立正確的 FileEntry 對應
INSERT INTO CampusSubmissionAttachments (
    CampusSubmissionContentId,
    FileEntryId,
    ContentTypeCode,
    SortOrder,
    Title,
    CreatedTime,
    CreatedUserId,
    UpdatedTime,
    UpdatedUserId
)
SELECT 
    csc.CampusSubmissionContentId,
    CASE 
        WHEN crp.photo IS NOT NULL AND crp.photo != '' AND sfs.name IS NOT NULL
        THEN (
            -- FileEntry 直接使用原始檔名對應
            SELECT fe.Id 
            FROM EcoCampus_PreProduction.dbo.FileEntry fe 
            WHERE fe.FileName = sfs.name
        )
        ELSE NULL
    END as FileEntryId,
    'image' as ContentTypeCode,
    ROW_NUMBER() OVER (PARTITION BY csc.CampusSubmissionContentId ORDER BY crp.sequence, crp.sid) as SortOrder,
    COALESCE(crp.description, N'校園投稿照片') as Title,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId, -- TODO: member_sid mapping
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId  -- TODO: member_sid mapping
FROM CampusSubmissionContents csc
INNER JOIN CampusSubmissions cs ON csc.CampusSubmissionId = cs.CampusSubmissionId
INNER JOIN (
    SELECT 
        cn.sid,
        ROW_NUMBER() OVER (ORDER BY cn.createdate, cn.sid) as RowNum
    FROM EcoCampus_Maria3.dbo.custom_news cn
    WHERE cn.lan = 'zh_tw' AND cn.type = 'release'
) cn ON cs.CampusSubmissionId = cn.RowNum
INNER JOIN EcoCampus_Maria3.dbo.custom_release_photo crp ON cn.sid = crp.release_sid
-- 關聯 sys_files_store 來獲取檔案的 size 和 file_hash
INNER JOIN EcoCampus_Maria3.dbo.sys_files_store sfs ON crp.photo = sfs.name
WHERE csc.LocaleCode = 'zh-TW'
  AND crp.photo IS NOT NULL AND crp.photo != '';

-- 為英文版複製附件記錄
INSERT INTO CampusSubmissionAttachments (
    CampusSubmissionContentId,
    FileEntryId,
    ContentTypeCode,
    SortOrder,
    Title,
    CreatedTime,
    CreatedUserId,
    UpdatedTime,
    UpdatedUserId
)
SELECT 
    csc_en.CampusSubmissionContentId,
    csa.FileEntryId,
    csa.ContentTypeCode,
    csa.SortOrder,
    csa.Title,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId,
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId
FROM CampusSubmissionAttachments csa
INNER JOIN CampusSubmissionContents csc_zh ON csa.CampusSubmissionContentId = csc_zh.CampusSubmissionContentId
INNER JOIN CampusSubmissionContents csc_en ON csc_zh.CampusSubmissionId = csc_en.CampusSubmissionId 
WHERE csc_zh.LocaleCode = 'zh-TW' 
  AND csc_en.LocaleCode = 'en'
  AND csa.CreatedTime = @MigrationStartTime;

DECLARE @AttachmentsCount INT = @@ROWCOUNT;
PRINT '✓ CampusSubmissionAttachments 遷移完成: ' + CAST(@AttachmentsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 5. 遷移結果統計和驗證
-- ========================================
PRINT '========================================';
PRINT '遷移結果統計:';
PRINT '========================================';

SELECT 
    '校園投稿遷移完成統計' as [遷移項目],
    (SELECT COUNT(*) FROM CampusSubmissions WHERE CreatedTime = @MigrationStartTime) as [CampusSubmissions主表],
    (SELECT COUNT(*) FROM CampusSubmissionContents WHERE CreatedTime = @MigrationStartTime AND LocaleCode = 'zh-TW') as [中文內容],
    (SELECT COUNT(*) FROM CampusSubmissionContents WHERE CreatedTime = @MigrationStartTime AND LocaleCode = 'en') as [英文內容],
    (SELECT COUNT(*) FROM CampusSubmissionAttachments WHERE CreatedTime = @MigrationStartTime) as [照片附件];

-- ========================================
-- 6. 顯示遷移結果範例
-- ========================================
PRINT '遷移結果範例 (前5筆):';

SELECT TOP 5
    cs.CampusSubmissionId as [投稿ID],
    cs.SubmissionDate as [投稿日期],
    csc.Title as [標題],
    LEFT(COALESCE(csc.Description, ''), 50) + '...' as [內容預覽],
    csc.LocaleCode as [語言],
    cs.Status as [狀態]
FROM CampusSubmissions cs
INNER JOIN CampusSubmissionContents csc ON cs.CampusSubmissionId = csc.CampusSubmissionId
WHERE cs.CreatedTime = @MigrationStartTime
ORDER BY cs.CampusSubmissionId, csc.LocaleCode;

-- ========================================
-- 7. 重要提醒和後續工作
-- ========================================
PRINT '========================================';
PRINT '⚠️  重要提醒:';
PRINT '1. member_sid 對應問題：目前所有 CreatedUserId/UpdatedUserId 都設為 1';
PRINT '   需要建立 custom_news.member_sid → 新系統 UserId 的對應表';
PRINT '2. SchoolId 對應問題：目前都設為預設值 1 (Schools.Id=1)';
PRINT '   需要根據 member_sid 或其他欄位建立學校對應關係';
PRINT '3. FileEntry 對應：部分照片可能找不到對應的 FileEntry 記錄';
PRINT '   請檢查 FileEntry 表是否包含所有 custom_release_photo.photo 檔案';
PRINT '========================================';

-- ========================================
-- 8. 完成訊息
-- ========================================
PRINT '✅ 校園投稿遷移腳本執行完成！';
PRINT '遷移統計:';
PRINT '- 校園投稿主表: ' + CAST(@CampusSubmissionCount AS VARCHAR) + ' 筆';
PRINT '- 中文內容: ' + CAST(@ContentsZhCount AS VARCHAR) + ' 筆';
PRINT '- 英文內容: ' + CAST(@ContentsEnCount AS VARCHAR) + ' 筆';
PRINT '- 照片附件: ' + CAST(@AttachmentsCount AS VARCHAR) + ' 筆';
PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';