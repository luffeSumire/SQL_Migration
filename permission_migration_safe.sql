-- ==========================================
-- 權限系統資料遷移腳本 (安全版 - 不刪除現有資料)
-- 參考 11_account_migration 模式，使用 MERGE 更新
-- From: EcoCampus_Maria3 To: EcoCampus_PreProduction  
-- ==========================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

USE EcoCampus_PreProduction;
GO

-- ==========================================
-- STEP 1: 遷移權限群組 (使用 MERGE 避免衝突)
-- ==========================================
PRINT '=== 開始遷移權限群組 (使用 MERGE) ===';

-- 啟用 IDENTITY_INSERT
SET IDENTITY_INSERT permission_group ON;

-- 使用 MERGE 語句處理已存在的記錄
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
WHEN MATCHED AND target.sid != 3 THEN  -- 只更新非系統管理員群組
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

-- 關閉 IDENTITY_INSERT
SET IDENTITY_INSERT permission_group OFF;

PRINT '權限群組遷移完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';
GO

-- ==========================================
-- STEP 2: 遷移帳號權限群組對應 (只處理已存在的帳號)
-- ==========================================
PRINT '=== 開始遷移帳號權限群組對應 (使用 MERGE) ===';

-- 使用 MERGE 處理帳號權限群組對應
MERGE account_permission_group AS target
USING (
    SELECT DISTINCT
        sag.target_sid as accountSid,
        sag.group_sid as groupSid, 
        GETDATE() as createTime,
        1 as createUser,
        GETDATE() as updateTime,
        1 as updateUser,
        1 as dataStatus
    FROM [EcoCampus_Maria3].[dbo].[sys_account_groups] sag
    INNER JOIN Accounts a ON a.AccountId = sag.target_sid  -- 確保帳號存在於新系統
    INNER JOIN permission_group pg ON pg.sid = sag.group_sid  -- 確保群組存在
    WHERE sag.type = 'P'  -- 只處理人員類型
      AND sag.target_sid IS NOT NULL
      AND sag.group_sid IS NOT NULL
) AS source
ON target.accountSid = source.accountSid AND target.groupSid = source.groupSid
WHEN NOT MATCHED THEN
    INSERT (accountSid, groupSid, createTime, createUser, updateTime, updateUser, dataStatus)
    VALUES (source.accountSid, source.groupSid, source.createTime, source.createUser, 
            source.updateTime, source.updateUser, source.dataStatus);

PRINT '帳號權限群組對應遷移完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';
GO

-- ==========================================
-- STEP 3: 建立權限群組對應 (基於舊系統規則)
-- ==========================================
PRINT '=== 開始建立權限群組對應 (使用 MERGE) ===';

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

-- 使用 MERGE 處理權限群組對應 (更新現有或新增)
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
    INNER JOIN permission_group pg ON pg.sid = sgr.groups_sid  -- 確保群組存在
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

-- 清理暫存表
DROP TABLE #UrlMapping;

PRINT '權限群組對應建立完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';
GO

-- ==========================================
-- STEP 4: 資料驗證和統計
-- ==========================================
PRINT '=== 開始資料驗證 ===';

-- 統計權限群組
DECLARE @GroupCount INT = (SELECT COUNT(*) FROM permission_group);
PRINT '權限群組總數: ' + CAST(@GroupCount AS VARCHAR(10));

-- 統計帳號權限群組對應
DECLARE @AccountGroupCount INT = (SELECT COUNT(*) FROM account_permission_group);
PRINT '帳號權限群組對應總數: ' + CAST(@AccountGroupCount AS VARCHAR(10));

-- 統計權限群組對應
DECLARE @PermissionMapCount INT = (SELECT COUNT(*) FROM permission_group_map);
PRINT '權限群組對應總數: ' + CAST(@PermissionMapCount AS VARCHAR(10));

-- 顯示各群組的權限統計
PRINT '=== 各群組權限統計 ===';
SELECT 
    pg.sid as 群組ID,
    pg.name as 群組名稱,
    COUNT(pgm.permissionSid) as 權限總數,
    SUM(CAST(pgm.allow AS INT)) as 允許權限數
FROM permission_group pg
LEFT JOIN permission_group_map pgm ON pgm.groupSid = pg.sid
GROUP BY pg.sid, pg.name
ORDER BY pg.sid;

-- 顯示帳號群組分布
PRINT '=== 帳號群組分布 ===';
SELECT 
    pg.name as 群組名稱,
    COUNT(apg.accountSid) as 帳號數量
FROM permission_group pg
LEFT JOIN account_permission_group apg ON apg.groupSid = pg.sid
GROUP BY pg.sid, pg.name
ORDER BY pg.sid;

-- 顯示最終遷移對比
PRINT '=== 遷移對比統計 ===';
SELECT 
    '舊系統群組數' as 項目, 
    (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[sys_groups]) as 數量
UNION ALL
SELECT 
    '新系統群組數' as 項目,
    (SELECT COUNT(*) FROM permission_group) as 數量
UNION ALL  
SELECT 
    '舊系統帳號群組對應' as 項目,
    (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[sys_account_groups] WHERE type = 'P') as 數量
UNION ALL
SELECT 
    '新系統帳號群組對應' as 項目,
    (SELECT COUNT(*) FROM account_permission_group) as 數量
UNION ALL
SELECT 
    '舊系統群組規則對應' as 項目,
    (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[sys_groups_rule]) as 數量
UNION ALL
SELECT 
    '新系統權限群組對應' as 項目,
    (SELECT COUNT(*) FROM permission_group_map) as 數量;

PRINT '=== 權限系統遷移腳本執行完成 ===';
GO