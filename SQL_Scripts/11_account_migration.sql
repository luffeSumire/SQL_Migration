-- =============================================
-- Account Migration Script
-- From: custom_member (EcoCampus_Maria3) 
-- To: Accounts + MemberProfiles (EcoCampus)
-- Date: 2025-08-08
-- =============================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

USE EcoCampus_PreProduction;
GO

-- =============================================
-- STEP 1: 清空目標表資料 (完全重新執行策略)
-- =============================================
PRINT '=== 清空 Accounts 和 MemberProfiles 表資料 ===';

-- 注意: 這個腳本假設測試環境的 Accounts 表目前為空或者可以強制清空
-- 如果執行失敗，需要手動清空相關的引用表

-- 先嘗試刪除 MemberProfiles (有外鍵依賴)
DELETE FROM MemberProfiles;

-- 不清空 account_permission_group 表，保持現有資料
-- DELETE FROM account_permission_group WHERE AccountId != 1;

-- 嘗試清空 Accounts 表，但保護系統帳號 ID=1
BEGIN TRY
    DELETE FROM Accounts WHERE AccountId != 1;
    PRINT 'Accounts 表已清空 (保護系統帳號 ID=1)';
END TRY
BEGIN CATCH
    PRINT 'ERROR: 無法清空 Accounts 表，存在外鍵約束衝突';
    PRINT '請手動清空或檢查引用 Accounts 的表';
    PRINT ERROR_MESSAGE();
    -- 繼續執行，不中止腳本
END CATCH

PRINT '清空完成';
GO

-- =============================================
-- STEP 2: 遷移 Accounts 表資料
-- =============================================
PRINT '=== 開始遷移 Accounts 表 ===';

-- 啟用 IDENTITY_INSERT 以插入明確的 AccountId 值
SET IDENTITY_INSERT Accounts ON;

-- 使用 MERGE 語句處理已存在的記錄
MERGE Accounts AS target
USING (
    SELECT 
        -- 如果來源ID=1，改為使用其他可用ID，避免與系統帳號衝突
        CASE WHEN cm.sid = 1 THEN (SELECT MAX(sid) + 1 FROM EcoCampus_Maria3.dbo.custom_member) ELSE cm.sid END AS AccountId,
        NULL AS SchoolId,  -- SchoolId將在11.5_update_school_accounts_schoolid.sql中設定
        cm.account AS Username,
        cm.password AS password,
        cm.password_salt AS PasswordSalt,
        cm.member_email AS email,
        cm.member_tel AS Telephone,
        cm.member_phone AS phone,
        NULL AS birthday,  -- custom_member 沒有生日欄位
        -- 處理 CityId，暫時設為 NULL（需要進一步分析對應關係）
        NULL AS CityId,  -- cm.city_sid 值與新系統不匹配
        NULL AS AreaId,  -- cm.area_sid 值與新系統不匹配
        NULL AS PostCode,  -- custom_member 沒有郵遞區號
        cm.member_address AS address,
        NULL AS DutyDate,  -- custom_member 沒有到職日期
        NULL AS DepartureDate,  -- custom_member 沒有離職日期
        NULL AS ContactName,  -- custom_member 沒有聯絡人姓名
        NULL AS ContactPhone,  -- custom_member 沒有聯絡人電話
        NULL AS ContactRelationship,  -- custom_member 沒有聯絡人關係
        -- 處理個人照片檔案關聯
        CASE 
            WHEN cm.member_photo IS NOT NULL AND cm.member_photo != '' 
            THEN (SELECT TOP 1 fe.Id FROM FileEntry fe WHERE fe.FileName = cm.member_photo)
            ELSE NULL 
        END AS ProfilePhotoFileId,
        cm.sequence AS SortOrder,
        COALESCE(cm.lan, 'zh-TW') AS Language,  -- 預設語言為繁體中文
        NULL AS CreatedUserId,  -- 舊系統沒有創建者ID
        NULL AS UpdatedUserId,  -- 舊系統沒有更新者ID
        -- 系統管理員權限 (待確認規則)
        0 AS IsSystemAdmin,  
        -- 學校夥伴權限
        CASE WHEN cm.member_role = 'school' THEN 1 ELSE 0 END AS IsSchoolPartner,
        -- EPA 使用者權限  
        CASE WHEN cm.member_role = 'epa' THEN 1 ELSE 0 END AS IsEpaUser,
        -- 輔導團隊權限
        CASE WHEN cm.member_role = 'tutor' THEN 1 ELSE 0 END AS IsGuidanceTeam,
        -- 處理 GuidanceTagId 外鍵約束，只保留存在的值
        CASE 
            WHEN cm.tag_sid IS NOT NULL AND EXISTS (SELECT 1 FROM GuidanceTags gt WHERE gt.GuidanceTagId = cm.tag_sid)
            THEN cm.tag_sid
            ELSE NULL
        END AS GuidanceTagId,
        NULL AS CountyId,  -- 需要進一步分析縣市對應關係
        NULL AS GovernmentUnitId,  -- 需要進一步分析政府單位對應關係
        -- 時間戳轉換 (Unix timestamp to datetime2)
        CASE 
            WHEN cm.createdate IS NOT NULL AND cm.createdate > 0 
            THEN DATEADD(second, cm.createdate, '1970-01-01 00:00:00')
            ELSE GETDATE()
        END AS CreatedTime,
        CASE 
            WHEN cm.updatedate IS NOT NULL AND cm.updatedate > 0 
            THEN DATEADD(second, cm.updatedate, '1970-01-01 00:00:00')
            ELSE GETDATE()
        END AS UpdatedTime,
        -- 狀態判斷邏輯 (基於 isuse 欄位決定帳號啟用狀態)
        CASE 
            WHEN cm.isuse = 1 THEN 1  -- 啟用 (基於原系統的 isuse 狀態)
            ELSE 0  -- 停用
        END AS Status,
        -- 軟刪除相關欄位
        CASE WHEN cm.is_del = 1 THEN GETDATE() ELSE NULL END AS DeletedTime,
        NULL AS DeletedUserId,  -- 舊系統沒有刪除者ID
        -- 審核狀態編碼
        CASE 
            WHEN cm.register_review = '已通過' THEN 1  -- 已審核通過
            WHEN cm.register_review = '待審核' THEN 0  -- 待審核  
            WHEN cm.register_review = '未通過' THEN 0  -- 審核未通過
            ELSE 0  -- 預設待審核
        END AS ReviewStatus
    FROM EcoCampus_Maria3.dbo.custom_member cm
    WHERE cm.sid IS NOT NULL  -- 確保有主鍵值
        AND cm.account IS NOT NULL  -- 確保有帳號
        AND cm.account != ''  -- 排除空白帳號
) AS source
ON target.AccountId = source.AccountId
WHEN MATCHED THEN
    UPDATE SET
        SchoolId = source.SchoolId,
        Username = source.Username,
        password = source.password,
        PasswordSalt = source.PasswordSalt,
        email = source.email,
        Telephone = source.Telephone,
        phone = source.phone,
        birthday = source.birthday,
        CityId = source.CityId,
        AreaId = source.AreaId,
        PostCode = source.PostCode,
        address = source.address,
        DutyDate = source.DutyDate,
        DepartureDate = source.DepartureDate,
        ContactName = source.ContactName,
        ContactPhone = source.ContactPhone,
        ContactRelationship = source.ContactRelationship,
        ProfilePhotoFileId = source.ProfilePhotoFileId,
        SortOrder = source.SortOrder,
        Language = source.Language,
        CreatedUserId = source.CreatedUserId,
        UpdatedUserId = source.UpdatedUserId,
        IsSystemAdmin = source.IsSystemAdmin,
        IsSchoolPartner = source.IsSchoolPartner,
        IsEpaUser = source.IsEpaUser,
        IsGuidanceTeam = source.IsGuidanceTeam,
        GuidanceTagId = source.GuidanceTagId,
        CountyId = source.CountyId,
        GovernmentUnitId = source.GovernmentUnitId,
        UpdatedTime = source.UpdatedTime,
        Status = source.Status,
        DeletedTime = source.DeletedTime,
        DeletedUserId = source.DeletedUserId,
        ReviewStatus = source.ReviewStatus
WHEN NOT MATCHED THEN
    INSERT (AccountId, SchoolId, Username, password, PasswordSalt, email, Telephone, phone, birthday,
            CityId, AreaId, PostCode, address, DutyDate, DepartureDate, ContactName, ContactPhone, 
            ContactRelationship, ProfilePhotoFileId, SortOrder, Language, CreatedUserId, UpdatedUserId,
            IsSystemAdmin, IsSchoolPartner, IsEpaUser, IsGuidanceTeam, GuidanceTagId, CountyId, 
            GovernmentUnitId, CreatedTime, UpdatedTime, Status, DeletedTime, DeletedUserId, ReviewStatus)
    VALUES (source.AccountId, source.SchoolId, source.Username, source.password, source.PasswordSalt, 
            source.email, source.Telephone, source.phone, source.birthday, source.CityId, source.AreaId,
            source.PostCode, source.address, source.DutyDate, source.DepartureDate, source.ContactName,
            source.ContactPhone, source.ContactRelationship, source.ProfilePhotoFileId, source.SortOrder,
            source.Language, source.CreatedUserId, source.UpdatedUserId, source.IsSystemAdmin,
            source.IsSchoolPartner, source.IsEpaUser, source.IsGuidanceTeam, source.GuidanceTagId,
            source.CountyId, source.GovernmentUnitId, source.CreatedTime, source.UpdatedTime, 
            source.Status, source.DeletedTime, source.DeletedUserId, source.ReviewStatus);

-- 關閉 IDENTITY_INSERT
SET IDENTITY_INSERT Accounts OFF;

PRINT '=== Accounts 表遷移完成 ===';
PRINT 'MERGE 操作影響筆數: ' + CAST(@@ROWCOUNT AS VARCHAR(10));
GO

-- =============================================
-- STEP 3: 遷移 MemberProfiles 表資料 (多語系支援)
-- =============================================
PRINT '=== 開始遷移 MemberProfiles 表 ===';

-- 先清空 MemberProfiles 表
DELETE FROM MemberProfiles;

-- 插入中文版本的 MemberProfiles
INSERT INTO MemberProfiles (
    AccountId,
    LocaleCode,
    CitizenDigitalNumber,
    captcha,
    code,
    MemberName,
    MemberAddress,
    MemberTelephone,
    MemberPhone,
    MemberEmail,
    JobId,
    JobName,
    PlaceId,
    PlaceName,
    MemberIntroduction,
    MemberPhotoFileId,
    MemberRole,
    MemberExchange,
    MemberUrl,
    TagId,
    isuse,
    IsDeleted,
    IsInternal,
    AreaAttributes,
    UpdatePasswordTime,
    MemberPassTime,
    RegisterReview,
    UseMemberRecordId,
    ReviewMemberRecordId,
    CreateDateTimestamp,
    CreateUserName,
    CreateIp,
    UpdateDateTimestamp,
    UpdateUserName,
    UpdateIp,
    CreatedTime,
    CreatedUserId,
    UpdatedTime,
    UpdatedUserId
)
SELECT 
    CASE WHEN cm.sid = 1 THEN (SELECT MAX(sid) + 1 FROM EcoCampus_Maria3.dbo.custom_member) ELSE cm.sid END AS AccountId,  -- 關聯到 Accounts 表，避免與系統帳號衝突
    'zh-TW' AS LocaleCode,  -- 中文版本
    cm.citizen_digital_number AS CitizenDigitalNumber,
    cm.captcha AS captcha,
    cm.code AS code,
    cm.member_cname AS MemberName,  -- 中文姓名
    cm.member_address AS MemberAddress,  -- 中文地址
    cm.member_tel AS MemberTelephone,
    cm.member_phone AS MemberPhone,
    cm.member_email AS MemberEmail,
    cm.job_sid AS JobId,
    cm.job_cname AS JobName,
    cm.place_sid AS PlaceId,
    cm.place_cname AS PlaceName,
    cm.member_Introduction AS MemberIntroduction,  -- 中文介紹
    cm.member_photo AS MemberPhotoFileId,  -- 需要進一步處理檔案ID對應
    cm.member_role AS MemberRole,
    cm.member_exchange AS MemberExchange,
    cm.member_url AS MemberUrl,
    -- 處理 TagId 外鍵約束，只保留存在的值
    CASE 
        WHEN cm.tag_sid IS NOT NULL AND EXISTS (SELECT 1 FROM GuidanceTags gt WHERE gt.GuidanceTagId = cm.tag_sid)
        THEN cm.tag_sid
        ELSE NULL
    END AS TagId,
    cm.isuse AS isuse,
    cm.is_del AS IsDeleted,
    cm.is_internal AS IsInternal,
    cm.area_attributes AS AreaAttributes,
    cm.update_password_date_new AS UpdatePasswordTime,
    -- 會員通過時間轉換
    CASE 
        WHEN cm.member_passdate IS NOT NULL AND cm.member_passdate != ''
        THEN TRY_CONVERT(datetime2, cm.member_passdate)
        ELSE NULL
    END AS MemberPassTime,
    cm.register_review AS RegisterReview,
    cm.use_member_record_sid AS UseMemberRecordId,
    cm.review_member_record_sid AS ReviewMemberRecordId,
    cm.createdate AS CreateDateTimestamp,
    cm.createuser AS CreateUserName,
    cm.createip AS CreateIp,
    cm.updatedate AS UpdateDateTimestamp,
    cm.updateuser AS UpdateUserName,
    cm.updateip AS UpdateIp,
    -- CreatedTime 和 UpdatedTime 轉換
    CASE 
        WHEN cm.createdate IS NOT NULL AND cm.createdate > 0 
        THEN DATEADD(second, cm.createdate, '1970-01-01 00:00:00')
        ELSE GETDATE()
    END AS CreatedTime,
    NULL AS CreatedUserId,  -- 舊系統沒有創建者ID
    CASE 
        WHEN cm.updatedate IS NOT NULL AND cm.updatedate > 0 
        THEN DATEADD(second, cm.updatedate, '1970-01-01 00:00:00')
        ELSE GETDATE()
    END AS UpdatedTime,
    NULL AS UpdatedUserId   -- 舊系統沒有更新者ID
FROM EcoCampus_Maria3.dbo.custom_member cm
WHERE cm.sid IS NOT NULL  -- 確保有主鍵值
    AND EXISTS (SELECT 1 FROM Accounts a WHERE a.AccountId = CASE WHEN cm.sid = 1 THEN (SELECT MAX(sid) + 1 FROM EcoCampus_Maria3.dbo.custom_member) ELSE cm.sid END)  -- 確保 Account 已存在
ORDER BY cm.sid;

PRINT '中文版 MemberProfiles 遷移完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';

-- 插入英文版本的 MemberProfiles (僅當有英文資料時)
INSERT INTO MemberProfiles (
    AccountId,
    LocaleCode,
    CitizenDigitalNumber,
    captcha,
    code,
    MemberName,
    MemberAddress,
    MemberTelephone,
    MemberPhone,
    MemberEmail,
    JobId,
    JobName,
    PlaceId,
    PlaceName,
    MemberIntroduction,
    MemberPhotoFileId,
    MemberRole,
    MemberExchange,
    MemberUrl,
    TagId,
    isuse,
    IsDeleted,
    IsInternal,
    AreaAttributes,
    UpdatePasswordTime,
    MemberPassTime,
    RegisterReview,
    UseMemberRecordId,
    ReviewMemberRecordId,
    CreateDateTimestamp,
    CreateUserName,
    CreateIp,
    UpdateDateTimestamp,
    UpdateUserName,
    UpdateIp,
    CreatedTime,
    CreatedUserId,
    UpdatedTime,
    UpdatedUserId
)
SELECT 
    CASE WHEN cm.sid = 1 THEN (SELECT MAX(sid) + 1 FROM EcoCampus_Maria3.dbo.custom_member) ELSE cm.sid END AS AccountId,  -- 關聯到 Accounts 表，避免與系統帳號衝突
    'en' AS LocaleCode,   -- 英文版本
    cm.citizen_digital_number AS CitizenDigitalNumber,
    cm.captcha AS captcha,
    cm.code AS code,
    COALESCE(cm.member_cname_en, cm.member_cname) AS MemberName,  -- 英文姓名，沒有則用中文
    COALESCE(cm.member_address_en, cm.member_address) AS MemberAddress,  -- 英文地址，沒有則用中文
    cm.member_tel AS MemberTelephone,
    cm.member_phone AS MemberPhone,
    cm.member_email AS MemberEmail,
    cm.job_sid AS JobId,
    cm.job_cname AS JobName,  -- 英文職位名稱待處理
    cm.place_sid AS PlaceId,
    cm.place_cname AS PlaceName,  -- 英文地點名稱待處理
    COALESCE(cm.member_Introduction_en, cm.member_Introduction) AS MemberIntroduction,  -- 英文介紹，沒有則用中文
    cm.member_photo AS MemberPhotoFileId,
    cm.member_role AS MemberRole,
    cm.member_exchange AS MemberExchange,
    cm.member_url AS MemberUrl,
    -- 處理 TagId 外鍵約束，只保留存在的值
    CASE 
        WHEN cm.tag_sid IS NOT NULL AND EXISTS (SELECT 1 FROM GuidanceTags gt WHERE gt.GuidanceTagId = cm.tag_sid)
        THEN cm.tag_sid
        ELSE NULL
    END AS TagId,
    cm.isuse AS isuse,
    cm.is_del AS IsDeleted,
    cm.is_internal AS IsInternal,
    cm.area_attributes AS AreaAttributes,
    cm.update_password_date_new AS UpdatePasswordTime,
    -- 會員通過時間轉換
    CASE 
        WHEN cm.member_passdate IS NOT NULL AND cm.member_passdate != ''
        THEN TRY_CONVERT(datetime2, cm.member_passdate)
        ELSE NULL
    END AS MemberPassTime,
    cm.register_review AS RegisterReview,
    cm.use_member_record_sid AS UseMemberRecordId,
    cm.review_member_record_sid AS ReviewMemberRecordId,
    cm.createdate AS CreateDateTimestamp,
    cm.createuser AS CreateUserName,
    cm.createip AS CreateIp,
    cm.updatedate AS UpdateDateTimestamp,
    cm.updateuser AS UpdateUserName,
    cm.updateip AS UpdateIp,
    -- CreatedTime 和 UpdatedTime 轉換
    CASE 
        WHEN cm.createdate IS NOT NULL AND cm.createdate > 0 
        THEN DATEADD(second, cm.createdate, '1970-01-01 00:00:00')
        ELSE GETDATE()
    END AS CreatedTime,
    NULL AS CreatedUserId,  -- 舊系統沒有創建者ID
    CASE 
        WHEN cm.updatedate IS NOT NULL AND cm.updatedate > 0 
        THEN DATEADD(second, cm.updatedate, '1970-01-01 00:00:00')
        ELSE GETDATE()
    END AS UpdatedTime,
    NULL AS UpdatedUserId   -- 舊系統沒有更新者ID
FROM EcoCampus_Maria3.dbo.custom_member cm
WHERE cm.sid IS NOT NULL  -- 確保有主鍵值
    AND EXISTS (SELECT 1 FROM Accounts a WHERE a.AccountId = CASE WHEN cm.sid = 1 THEN (SELECT MAX(sid) + 1 FROM EcoCampus_Maria3.dbo.custom_member) ELSE cm.sid END)  -- 確保 Account 已存在
    -- 為所有帳號建立英文版本，沒有英文資料則用中文遞補
ORDER BY cm.sid;

PRINT '英文版 MemberProfiles 遷移完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';
PRINT '=== MemberProfiles 表總遷移完成 ===';

-- 統計多語系資料
SELECT 
    LocaleCode,
    COUNT(*) AS 記錄數量
FROM MemberProfiles
GROUP BY LocaleCode
ORDER BY LocaleCode;

GO

-- =============================================
-- STEP 4: 資料驗證和統計
-- =============================================
PRINT '=== 開始資料驗證 ===';

-- 驗證 Accounts 表資料
DECLARE @AccountsCount INT = (SELECT COUNT(*) FROM Accounts);
DECLARE @SourceCount INT = (SELECT COUNT(*) FROM EcoCampus_Maria3.dbo.custom_member WHERE sid IS NOT NULL AND account IS NOT NULL AND account != '');
PRINT 'Accounts 遷移筆數: ' + CAST(@AccountsCount AS VARCHAR(10));
PRINT '來源資料筆數: ' + CAST(@SourceCount AS VARCHAR(10));

-- 驗證 MemberProfiles 表資料  
DECLARE @ProfilesCount INT = (SELECT COUNT(*) FROM MemberProfiles);
PRINT 'MemberProfiles 遷移筆數: ' + CAST(@ProfilesCount AS VARCHAR(10));

-- 驗證外鍵關聯完整性
DECLARE @OrphanProfiles INT = (SELECT COUNT(*) FROM MemberProfiles mp LEFT JOIN Accounts a ON mp.AccountId = a.AccountId WHERE a.AccountId IS NULL);
PRINT '孤立的 MemberProfiles 記錄: ' + CAST(@OrphanProfiles AS VARCHAR(10));

-- 驗證權限角色分布
PRINT '=== 權限角色統計 ===';
SELECT 
    '學校夥伴' AS 角色, COUNT(*) AS 數量
FROM Accounts WHERE IsSchoolPartner = 1
UNION ALL
SELECT 
    'EPA使用者' AS 角色, COUNT(*) AS 數量  
FROM Accounts WHERE IsEpaUser = 1
UNION ALL
SELECT 
    '輔導團隊' AS 角色, COUNT(*) AS 數量
FROM Accounts WHERE IsGuidanceTeam = 1;

-- 驗證審核狀態分布
PRINT '=== 審核狀態統計 ===';
SELECT 
    CASE ReviewStatus
        WHEN 0 THEN '待審核'
        WHEN 1 THEN '已通過'  
        WHEN 2 THEN '未通過'
        ELSE '未知'
    END AS 審核狀態,
    COUNT(*) AS 數量
FROM Accounts
GROUP BY ReviewStatus
ORDER BY ReviewStatus;

-- 驗證啟用狀態分布
PRINT '=== 帳號狀態統計 ===';
SELECT 
    CASE Status
        WHEN 0 THEN '停用'
        WHEN 1 THEN '啟用'
        ELSE '未知' 
    END AS 帳號狀態,
    COUNT(*) AS 數量
FROM Accounts  
GROUP BY Status
ORDER BY Status;

PRINT '=== Account 遷移腳本執行完成 ===';
-- TODO sysadmin 的一些資訊 在新系統上 遺失了 