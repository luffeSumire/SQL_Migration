-- =============================================
-- 後台管理帳號與權限系統完整遷移腳本
-- From: sys_account, sys_groups, sys_account_groups (EcoCampus_Maria3)
-- To: Accounts, permission_group, account_permission_group (EcoCampus_PreProduction)
-- Date: 2025-08-08
-- =============================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

USE EcoCampus_PreProduction;
GO

-- =============================================
-- STEP 1: 遷移後台管理帳號 (sys_account → Accounts)
-- =============================================
PRINT '=== 開始遷移後台管理帳號 ===';

-- 使用 MERGE 處理後台帳號遷移，避免與現有帳號衝突
MERGE Accounts AS target
USING (
    SELECT 
        -- 後台帳號使用負數 ID 以避免與前台帳號衝突
        -(sa.sid) AS AccountId,  
        NULL AS SchoolId,
        sa.account AS Username,
        sa.password AS password,
        sa.password_salt AS PasswordSalt,
        sa.email AS email,
        sa.tel AS Telephone,
        sa.phone AS phone,
        TRY_CONVERT(datetime2, sa.birthday) AS birthday,
        NULL AS CityId,  -- 需要進一步對應
        NULL AS AreaId,  -- 需要進一步對應
        sa.post_code AS PostCode,
        sa.address AS address,
        TRY_CONVERT(datetime2, sa.dutydate) AS DutyDate,
        TRY_CONVERT(datetime2, sa.departuredate) AS DepartureDate,
        sa.contact_name AS ContactName,
        sa.contact_phone AS ContactPhone,
        sa.contact_relationship AS ContactRelationship,
        -- 處理個人照片檔案關聯
        CASE 
            WHEN sa.picinfo IS NOT NULL AND sa.picinfo != '' 
            THEN (SELECT TOP 1 fe.Id FROM FileEntry fe WHERE fe.FileName = sa.picinfo)
            ELSE NULL 
        END AS ProfilePhotoFileId,
        ISNULL(sa.sequence, 0) AS SortOrder,
        COALESCE(sa.lan, 'zh-TW') AS Language,
        NULL AS CreatedUserId,
        NULL AS UpdatedUserId,
        -- 後台帳號通常都是系統管理員
        1 AS IsSystemAdmin,
        0 AS IsSchoolPartner,
        0 AS IsEpaUser, 
        0 AS IsGuidanceTeam,
        NULL AS GuidanceTagId,
        NULL AS CountyId,
        NULL AS GovernmentUnitId,
        -- 時間戳轉換
        CASE 
            WHEN sa.createdate IS NOT NULL AND sa.createdate > 0 
            THEN DATEADD(second, sa.createdate, '1970-01-01 00:00:00')
            ELSE GETDATE()
        END AS CreatedTime,
        CASE 
            WHEN sa.updatedate IS NOT NULL AND sa.updatedate > 0 
            THEN DATEADD(second, sa.updatedate, '1970-01-01 00:00:00')
            ELSE GETDATE()
        END AS UpdatedTime,
        CASE WHEN sa.isuse = 1 THEN 1 ELSE 0 END AS Status,
        NULL AS DeletedTime,
        NULL AS DeletedUserId,
        1 AS ReviewStatus  -- 後台帳號預設為已審核
    FROM [EcoCampus_Maria3].[dbo].[sys_account] sa
    WHERE sa.sid IS NOT NULL 
      AND sa.account IS NOT NULL 
      AND sa.account != ''
) AS source
ON target.AccountId = source.AccountId
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

PRINT '後台管理帳號遷移完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';
GO

-- =============================================
-- STEP 2: 遷移權限群組 (sys_groups → permission_group)
-- =============================================
PRINT '=== 開始遷移權限群組 ===';

-- 啟用 IDENTITY_INSERT
SET IDENTITY_INSERT permission_group ON;

MERGE permission_group AS target
USING (
    SELECT 
        sg.sid,
        'GROUP_' + CAST(sg.sid AS VARCHAR(100)) as groupCode,
        sg.cname as name,
        ISNULL(sg.remark, '') as remark,
        ISNULL(sg.sequence, 0) as sequence,
        GETDATE() as createTime,
        1 as createUser,
        GETDATE() as updateTime, 
        1 as updateUser,
        1 as dataStatus
    FROM [EcoCampus_Maria3].[dbo].[sys_groups] sg
    WHERE sg.sid IS NOT NULL
) AS source
ON target.sid = source.sid
WHEN MATCHED AND target.sid != 3 THEN  -- 保護系統管理員群組
    UPDATE SET
        name = source.name,
        remark = source.remark,
        sequence = source.sequence,
        updateTime = source.updateTime,
        updateUser = source.updateUser
WHEN NOT MATCHED THEN
    INSERT (sid, groupCode, name, remark, sequence, createTime, createUser, updateTime, updateUser, dataStatus)
    VALUES (source.sid, source.groupCode, source.name, source.remark, source.sequence, 
            source.createTime, source.createUser, source.updateTime, source.updateUser, source.dataStatus);

SET IDENTITY_INSERT permission_group OFF;
PRINT '權限群組遷移完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';
GO

-- =============================================
-- STEP 3: 遷移帳號權限群組對應
-- =============================================
PRINT '=== 開始遷移帳號權限群組對應 ===';

-- 處理前台會員帳號的群組對應 (type='P')
MERGE account_permission_group AS target
USING (
    SELECT DISTINCT
        sag.target_sid as accountSid,  -- 對應到前台帳號
        sag.group_sid as groupSid, 
        GETDATE() as createTime,
        1 as createUser,
        GETDATE() as updateTime,
        1 as updateUser,
        1 as dataStatus
    FROM [EcoCampus_Maria3].[dbo].[sys_account_groups] sag
    INNER JOIN Accounts a ON a.AccountId = sag.target_sid  -- 確保帳號存在
    INNER JOIN permission_group pg ON pg.sid = sag.group_sid  -- 確保群組存在
    WHERE sag.type = 'P'  -- 前台會員類型
      AND sag.target_sid IS NOT NULL
      AND sag.group_sid IS NOT NULL
) AS source
ON target.accountSid = source.accountSid AND target.groupSid = source.groupSid
WHEN NOT MATCHED THEN
    INSERT (accountSid, groupSid, createTime, createUser, updateTime, updateUser, dataStatus)
    VALUES (source.accountSid, source.groupSid, source.createTime, source.createUser, 
            source.updateTime, source.updateUser, source.dataStatus);

PRINT '前台帳號群組對應遷移完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';

-- 處理後台管理帳號的群組對應 (直接依據 sys_account.groups_sid)
MERGE account_permission_group AS target
USING (
    SELECT DISTINCT
        -(sa.sid) as accountSid,  -- 對應到後台帳號 (負數 ID)
        sa.groups_sid as groupSid, 
        GETDATE() as createTime,
        1 as createUser,
        GETDATE() as updateTime,
        1 as updateUser,
        1 as dataStatus
    FROM [EcoCampus_Maria3].[dbo].[sys_account] sa
    INNER JOIN Accounts a ON a.AccountId = -(sa.sid)  -- 確保後台帳號存在
    INNER JOIN permission_group pg ON pg.sid = sa.groups_sid  -- 確保群組存在
    WHERE sa.sid IS NOT NULL
      AND sa.groups_sid IS NOT NULL
) AS source
ON target.accountSid = source.accountSid AND target.groupSid = source.groupSid
WHEN NOT MATCHED THEN
    INSERT (accountSid, groupSid, createTime, createUser, updateTime, updateUser, dataStatus)
    VALUES (source.accountSid, source.groupSid, source.createTime, source.createUser, 
            source.updateTime, source.updateUser, source.dataStatus);

PRINT '後台帳號群組對應遷移完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';
GO

-- =============================================
-- STEP 4: 建立權限群組對應 (sys_groups_rule → permission_group_map)
-- =============================================
PRINT '=== 開始建立權限群組對應 ===';

-- 建立 URL 對應暫存表
CREATE TABLE #UrlMapping (
    old_url NVARCHAR(200),
    new_route NVARCHAR(200),
    rule_name NVARCHAR(50)
);

-- 插入對應關係 (根據 permission_map.md)
INSERT INTO #UrlMapping (old_url, new_route, rule_name) VALUES
('sys/seo_manage', '/system/seo', 'SEO優化'),
('sys/account_manage', '/permissions/users', '人員列表'),
('custom/upload_record', '/system/upload-records', '上傳檔案紀錄'),
('sys/company_manage', '/system/company', '公司資訊'),
('simple_crud/9', '/pages/friendly-links', '友善連結'),
('simple_crud/12', '/categories/friendly-links', '友善連結分類'),
('custom/member_manage/school', '/data-reviews/schools', '生態學校'),
('custom/member_manage/page_member_info_review/school', '/maintenance/schools', '生態學校'),
('simple_crud/20', '/account-reviews/schools', '生態學校帳號審核'),
('sys/language_data_manage', '/system/languages', '多語系'),
('custom/release_manage/review_list', '/submissions/list', '投稿列表'),
('simple_crud/26', '/categories/social-resources', '社會資源分類'),
('custom/social_agency', '/pages/social-agencies', '社會資源機構'),
('simple_crud/2', '/pages/home-featured-videos', '首頁-精選影片'),
('simple_crud/2', '/pages/home-banners', '橫幅輪播'),
('custom/release_manage', '/pages/campus-submissions', '校園投稿'),
('custom/certification_manage/certification/return', '/certifications/returned', '退件列表'),
('simple_crud/4', '/pages/execution-methods', '執行方式'),
('simple_crud/15', '/categories/execution-methods', '執行方式分類'),
('simple_crud/6', '/pages/faq', '常見問題'),
('simple_crud/11', '/categories/faq', '常見問題分類'),
('sys/groups_account_manage', '/permissions/authorizations', '授權維護'),
('custom/certification_manage/certification/pass', '/certifications/approved', '通過列表'),
('simple_crud/1', '/pages/latest-news', '最新消息'),
('custom/login_record', '/system/login-records', '登入登出紀錄'),
('custom/certification_manage/certification/additional_documents', '/certifications/additional-documents', '補件列表'),
('custom/flagarea', '/pages/green-flag', '綠旗專區'),
('custom/member_manage/tutor', '/maintenance/tutors', '輔導人員'),
('custom/member_manage/page_member_info_review/tutor', '/data-reviews/tutors', '輔導人員'),
('simple_crud/22', '/account-reviews/tutors', '輔導人員帳號審核'),
('custom/certification_manage/certification/review', '/certifications/review', '審核中列表'),
('custom/member_login_record', '/system/school-login-records', '學校登入登出紀錄'),
('custom/school_import_manage', '/school-imports/summary', '學校總表'),
('custom/home_set_manage', '/pages/school-intro-certification', '學校簡介/認證介紹'),
('custom/member_manage/page_member_info_review/epa', '/data-reviews/governments', '縣市政府'),
('custom/member_manage/epa', '/maintenance/governments', '縣市政府'),
('simple_crud/21', '/account-reviews/governments', '縣市政府帳號審核'),
('simple_crud/8', '/pages/file-downloads', '檔案下載'),
('simple_crud/13', '/categories/file-downloads', '檔案下載分類'),
('sys/company_job_title_manage', '/system/job-titles', '職稱維護'),
('simple_crud/24', '/certificates/versions', '證書版本列表'),
('sys/groups_manage', '/permissions/groups', '權限群組');

-- 使用 MERGE 處理權限群組對應
MERGE permission_group_map AS target
USING (
    SELECT DISTINCT
        sgr.groups_sid as groupSid,
        p.sid as permissionSid,
        CASE 
            WHEN p.action = 'C' THEN ISNULL(sgr.c, 0)
            WHEN p.action = 'R' THEN ISNULL(sgr.r, 0)  
            WHEN p.action = 'U' THEN ISNULL(sgr.u, 0)
            WHEN p.action = 'D' THEN ISNULL(sgr.d, 0)
            ELSE 0
        END as allow,
        GETDATE() as createTime,
        1 as createUser,
        GETDATE() as updateTime,
        1 as updateUser,
        1 as dataStatus
    FROM [EcoCampus_Maria3].[dbo].[sys_groups_rule] sgr
    INNER JOIN [EcoCampus_Maria3].[dbo].[sys_rule] sr ON sr.sid = sgr.rule_sid
    INNER JOIN #UrlMapping um ON um.old_url = sr.url
    INNER JOIN permission p ON p.route = um.new_route
    INNER JOIN permission_group pg ON pg.sid = sgr.groups_sid
    WHERE sgr.groups_sid IS NOT NULL
      AND sgr.rule_sid IS NOT NULL
      AND sr.rule_name IS NOT NULL
      AND sr.url IS NOT NULL
) AS source
ON target.groupSid = source.groupSid AND target.permissionSid = source.permissionSid
WHEN MATCHED THEN
    UPDATE SET
        allow = source.allow,
        updateTime = source.updateTime,
        updateUser = source.updateUser
WHEN NOT MATCHED THEN
    INSERT (groupSid, permissionSid, allow, createTime, createUser, updateTime, updateUser, dataStatus)
    VALUES (source.groupSid, source.permissionSid, source.allow, source.createTime, 
            source.createUser, source.updateTime, source.updateUser, source.dataStatus);

DROP TABLE #UrlMapping;
PRINT '權限群組對應建立完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';
GO

-- =============================================
-- STEP 5: 資料驗證和統計
-- =============================================
PRINT '=== 資料驗證統計 ===';

SELECT '後台管理帳號' as 類型, COUNT(*) as 數量 FROM Accounts WHERE AccountId < 0
UNION ALL
SELECT '前台會員帳號' as 類型, COUNT(*) as 數量 FROM Accounts WHERE AccountId > 0
UNION ALL
SELECT '權限群組' as 類型, COUNT(*) as 數量 FROM permission_group
UNION ALL
SELECT '帳號群組對應' as 類型, COUNT(*) as 數量 FROM account_permission_group
UNION ALL
SELECT '權限群組對應' as 類型, COUNT(*) as 數量 FROM permission_group_map;

PRINT '=== 後台管理帳號清單 ===';
SELECT AccountId, Username, email, IsSystemAdmin 
FROM Accounts 
WHERE AccountId < 0 
ORDER BY AccountId;

PRINT '=== 各群組權限統計 ===';
SELECT 
    pg.sid as 群組ID,
    pg.name as 群組名稱,
    COUNT(pgm.permissionSid) as 權限總數,
    SUM(CAST(pgm.allow AS INT)) as 允許權限數,
    COUNT(apg.accountSid) as 帳號數量
FROM permission_group pg
LEFT JOIN permission_group_map pgm ON pgm.groupSid = pg.sid
LEFT JOIN account_permission_group apg ON apg.groupSid = pg.sid
GROUP BY pg.sid, pg.name
ORDER BY pg.sid;

PRINT '=== 後台管理帳號與權限系統遷移完成 ===';
GO