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

-- 檢查前置條件：確認 Schools 表已存在且有資料
DECLARE @SchoolCount INT = (SELECT COUNT(*) FROM Schools);
IF @SchoolCount = 0
BEGIN
    PRINT '❌ 錯誤：Schools 表沒有資料，請先執行 08_school_migration.sql';
    PRINT '校園投稿遷移需要依賴 Schools 表進行 SchoolId 對應';
    RETURN;
END
PRINT '✓ 前置檢查通過：Schools 表包含 ' + CAST(@SchoolCount AS VARCHAR) + ' 筆學校資料';

-- ========================================
-- 初始化：新增銅牌勳章類型 (用於存放銅牌的校園投稿)
-- ========================================
PRINT '初始化：新增銅牌勳章類型...';

-- 檢查是否已存在銅牌勳章類型
IF NOT EXISTS (SELECT 1 FROM BadgeTypes WHERE BadgeCode = N'bronze_badge')
BEGIN
    INSERT INTO BadgeTypes (BadgeCode, LabelZhTw, LabelEn, SortOrder, IsActive)
    VALUES (N'bronze_badge', N'銅牌學校', N'Bronze Medal School', 3, 0);
    PRINT '✓ 銅牌勳章類型已新增 (IsActive = 0)';
END
ELSE
BEGIN
    PRINT '✓ 銅牌勳章類型已存在，跳過新增';
END

-- ========================================
-- 建立認證等級到BadgeType的映射表
-- ========================================
-- 創建臨時映射表
IF OBJECT_ID('tempdb..#LevelToBadgeMapping') IS NOT NULL DROP TABLE #LevelToBadgeMapping;
CREATE TABLE #LevelToBadgeMapping (
    OldLevel INT,           -- 舊系統認證等級
    BadgeTypeId INT,        -- 新系統BadgeType ID
    Description NVARCHAR(50)
);

-- 取得銅牌勳章的ID
DECLARE @BronzeBadgeId INT = (SELECT Id FROM BadgeTypes WHERE BadgeCode = N'bronze_badge');

-- 插入映射資料 (根據08腳本的邏輯，銅牌現在對應到銅牌勳章)
INSERT INTO #LevelToBadgeMapping (OldLevel, BadgeTypeId, Description) VALUES 
(1, @BronzeBadgeId, '銅牌 -> 銅牌勳章'),     -- 銅牌對應銅牌勳章
(2, 2, '銀牌 -> 銀牌徽章'),     -- 銀牌對應銀牌徽章  
(3, 1, '綠旗 -> 綠旗徽章'),     -- 綠旗對應綠旗徽章
(4, 1, '綠旗R1 -> 綠旗徽章'),   -- 綠旗R1對應綠旗徽章
(5, 1, '綠旗R2 -> 綠旗徽章'),   -- 綠旗R2對應綠旗徽章
(6, 1, '綠旗R3 -> 綠旗徽章');   -- 綠旗R3對應綠旗徽章

PRINT '✓ 認證等級到BadgeType映射表建立完成';

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
    -- 根據投稿時間當下學校的最高認證等級決定BadgeType
    COALESCE(badge_mapping.BadgeTypeId, 2) as BadgeType, -- 找不到認證則預設為銀牌徽章(ID=2)
    CASE WHEN cn.is_home = 1 THEN 1 ELSE 0 END as FeaturedStatus,
    @MigrationStartTime as CreatedTime,
    -- TODO: member_sid 對應問題 - 目前先設為 1，需要後續建立 member_sid 對應表
    1 as CreatedUserId, -- cn.member_sid, 
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId, -- cn.member_sid,
    CASE WHEN cn.is_show = 1 THEN 1 ELSE 0 END as Status,
    COALESCE(cn.sequence, 0) as SortOrder,
    -- 透過 member_sid 對應到學校ID，使用與11.5腳本相同的邏輯
    COALESCE(s.Id, 1) as SchoolId -- 若找不到對應學校則預設為1
FROM EcoCampus_Maria3.dbo.custom_news cn
-- 關聯 custom_member 取得學校代碼
LEFT JOIN EcoCampus_Maria3.dbo.custom_member cm ON cn.member_sid = cm.sid AND cm.member_role = 'school'
-- 關聯 Schools 表取得新系統的學校ID (使用與08腳本相同的修正邏輯)
LEFT JOIN EcoCampus_PreProduction.dbo.Schools s ON s.SchoolCode = CASE 
    WHEN cm.sid = 812 THEN '193665'  -- 市立大崗國小 (手動修正)
    WHEN cm.sid = 603 THEN '034639'  -- 私立惠明盲校 (手動修正) 
    WHEN cm.sid = 796 THEN '061F01'  -- 臺中市北屯區廍子國民小學 (手動修正)
    ELSE cm.code
END
-- 關聯投稿時間當下學校的最高認證等級
LEFT JOIN (
    SELECT 
        cn_for_cert.sid as news_sid,
        cn_for_cert.member_sid,
        MAX(cc.level) as highest_level_at_submission
    FROM EcoCampus_Maria3.dbo.custom_news cn_for_cert
    INNER JOIN EcoCampus_Maria3.dbo.custom_certification cc ON cn_for_cert.member_sid = cc.member_sid
    WHERE cn_for_cert.type = N'release' 
      AND cn_for_cert.lan = N'zh_tw'
      AND cc.review = N'通過'
      AND cc.passdate IS NOT NULL 
      AND cc.passdate != ''
      -- 認證通過時間必須在投稿時間之前或同時
      AND TRY_CONVERT(datetime, cc.passdate) <= CASE 
          WHEN cn_for_cert.createdate IS NOT NULL AND cn_for_cert.createdate > 0 
          THEN DATEADD(SECOND, cn_for_cert.createdate, '1970-01-01')
          ELSE CONVERT(datetime, cn_for_cert.startdate + ' 00:00:00')
      END
    GROUP BY cn_for_cert.sid, cn_for_cert.member_sid
) cert_at_submission ON cert_at_submission.news_sid = cn.sid
-- 關聯BadgeType映射表
LEFT JOIN #LevelToBadgeMapping badge_mapping ON badge_mapping.OldLevel = cert_at_submission.highest_level_at_submission
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

DECLARE @AttachmentsZhCount INT = @@ROWCOUNT;
PRINT '✓ 中文附件插入完成: ' + CAST(@AttachmentsZhCount AS VARCHAR) + ' 筆記錄';

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

DECLARE @AttachmentsEnCount INT = @@ROWCOUNT;
DECLARE @AttachmentsCount INT = @AttachmentsZhCount + @AttachmentsEnCount;
PRINT '✓ 英文附件插入完成: ' + CAST(@AttachmentsEnCount AS VARCHAR) + ' 筆記錄';
PRINT '✓ CampusSubmissionAttachments 總計: ' + CAST(@AttachmentsCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 5. 遷移結果統計和驗證
-- ========================================
PRINT '========================================';
PRINT '遷移結果統計:';
PRINT '========================================';

-- 校園投稿 SchoolId 對應統計
DECLARE @MappedSchools INT = (SELECT COUNT(*) FROM CampusSubmissions WHERE CreatedTime = @MigrationStartTime AND SchoolId > 1);
DECLARE @DefaultSchools INT = (SELECT COUNT(*) FROM CampusSubmissions WHERE CreatedTime = @MigrationStartTime AND SchoolId = 1);
PRINT 'SchoolId 對應統計:';
PRINT '- 成功對應到學校: ' + CAST(@MappedSchools AS VARCHAR) + ' 筆';
PRINT '- 使用預設值(SchoolId=1): ' + CAST(@DefaultSchools AS VARCHAR) + ' 筆';

-- BadgeType 對應統計
DECLARE @GreenFlagBadges INT = (SELECT COUNT(*) FROM CampusSubmissions WHERE CreatedTime = @MigrationStartTime AND BadgeType = 1);
DECLARE @SilverBadges INT = (SELECT COUNT(*) FROM CampusSubmissions WHERE CreatedTime = @MigrationStartTime AND BadgeType = 2);
DECLARE @BronzeBadges INT = (SELECT COUNT(*) FROM CampusSubmissions WHERE CreatedTime = @MigrationStartTime AND BadgeType = @BronzeBadgeId);
PRINT 'BadgeType 分佈統計:';
PRINT '- 綠旗徽章(ID=1): ' + CAST(@GreenFlagBadges AS VARCHAR) + ' 筆';
PRINT '- 銀牌徽章(ID=2): ' + CAST(@SilverBadges AS VARCHAR) + ' 筆';
PRINT '- 銅牌勳章(ID=' + CAST(@BronzeBadgeId AS VARCHAR) + '): ' + CAST(@BronzeBadges AS VARCHAR) + ' 筆';

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
    cs.SchoolId as [學校ID],
    COALESCE(sc.Name, '未知學校') as [學校名稱],
    cs.BadgeType as [徽章類型],
    CASE cs.BadgeType 
        WHEN 1 THEN '綠旗徽章'
        WHEN 2 THEN '銀牌徽章'
        WHEN @BronzeBadgeId THEN '銅牌勳章'
        ELSE '未知徽章'
    END as [徽章名稱],
    cs.SubmissionDate as [投稿日期],
    csc.Title as [標題],
    LEFT(COALESCE(csc.Description, ''), 20) + '...' as [內容預覽],
    cs.Status as [狀態]
FROM CampusSubmissions cs
INNER JOIN CampusSubmissionContents csc ON cs.CampusSubmissionId = csc.CampusSubmissionId
LEFT JOIN Schools s ON cs.SchoolId = s.Id
LEFT JOIN SchoolContents sc ON s.Id = sc.SchoolId AND sc.LocaleCode = 'zh-TW'
WHERE cs.CreatedTime = @MigrationStartTime
  AND csc.LocaleCode = 'zh-TW'  -- 只顯示中文版本避免重複
ORDER BY cs.CampusSubmissionId;

-- ========================================
-- 7. 重要提醒和後續工作
-- ========================================
PRINT '========================================';
PRINT '⚠️  重要提醒:';
PRINT '1. member_sid 對應問題：目前所有 CreatedUserId/UpdatedUserId 都設為 1';
PRINT '   需要建立 custom_news.member_sid → 新系統 UserId 的對應表';
PRINT '2. SchoolId 對應：已透過 member_sid → custom_member.code → Schools.SchoolCode 建立關聯';
PRINT '   未能對應的投稿項目會使用預設值 SchoolId=1';
PRINT '3. BadgeType 對應：已根據投稿時間當下學校的最高認證等級設定徽章類型';
PRINT '   - 綠旗等級(3-6) → 綠旗徽章(BadgeType=1)';
PRINT '   - 銅牌等級(1) → 銅牌勳章(BadgeType=' + CAST(@BronzeBadgeId AS VARCHAR) + ', IsActive=0)';
PRINT '   - 銀牌等級(2) → 銀牌徽章(BadgeType=2)';
PRINT '   - 無認證或找不到認證 → 預設銀牌徽章(BadgeType=2)';
PRINT '4. FileEntry 對應：部分照片可能找不到對應的 FileEntry 記錄';
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
PRINT '- 成功對應學校: ' + CAST(@MappedSchools AS VARCHAR) + ' 筆';
PRINT '- 使用預設學校: ' + CAST(@DefaultSchools AS VARCHAR) + ' 筆';
PRINT '- 綠旗徽章: ' + CAST(@GreenFlagBadges AS VARCHAR) + ' 筆';
PRINT '- 銀牌徽章: ' + CAST(@SilverBadges AS VARCHAR) + ' 筆';
PRINT '- 銅牌勳章: ' + CAST(@BronzeBadges AS VARCHAR) + ' 筆';
PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';