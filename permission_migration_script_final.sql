-- ==========================================
-- 權限系統資料遷移腳本 (最終版)
-- 從 EcoCampus_Maria3 遷移到 EcoCampus_PreProduction  
-- ==========================================

USE EcoCampus_PreProduction
GO

-- ==========================================
-- 第一階段：清理現有資料
-- ==========================================
PRINT '開始清理現有權限資料...'

-- 清理權限群組對應
DELETE FROM permission_group_map
PRINT '已清理 permission_group_map 表'

-- 清理帳號權限群組對應  
DELETE FROM account_permission_group
PRINT '已清理 account_permission_group 表'

-- 清理權限群組 (保留 sid=3 的系統管理員群組)
DELETE FROM permission_group WHERE sid != 3
PRINT '已清理 permission_group 表 (保留系統管理員群組)'

PRINT '資料清理完成'
GO

-- ==========================================
-- 第二階段：遷移權限群組
-- ==========================================
PRINT '開始遷移權限群組...'

-- 啟用 IDENTITY_INSERT
SET IDENTITY_INSERT permission_group ON

INSERT INTO permission_group (
    sid, groupCode, name, remark, sequence,
    createTime, createUser, updateTime, updateUser, dataStatus
)
SELECT 
    sg.sid,
    'GROUP_' + CAST(sg.sid AS VARCHAR(100)) as groupCode,  -- 避免重複的 groupCode
    sg.cname as name,
    ISNULL(sg.remark, '') as remark,
    ISNULL(sg.sequence, 0) as sequence,
    GETDATE() as createTime,
    1 as createUser,
    GETDATE() as updateTime, 
    1 as updateUser,
    1 as dataStatus
FROM [EcoCampus_Maria3].[dbo].[sys_groups] sg
WHERE sg.sid != 3  -- 排除已存在的系統管理員群組

-- 關閉 IDENTITY_INSERT
SET IDENTITY_INSERT permission_group OFF

PRINT '權限群組遷移完成'
GO

-- ==========================================
-- 第三階段：遷移帳號權限群組對應
-- ==========================================
PRINT '開始遷移帳號權限群組對應...'

INSERT INTO account_permission_group (
    accountSid, groupSid,
    createTime, createUser, updateTime, updateUser, dataStatus
)
SELECT DISTINCT
    sag.target_sid as accountSid,
    sag.group_sid as groupSid, 
    GETDATE() as createTime,
    1 as createUser,
    GETDATE() as updateTime,
    1 as updateUser,
    1 as dataStatus
FROM [EcoCampus_Maria3].[dbo].[sys_account_groups] sag
INNER JOIN permission_group pg ON pg.sid = sag.group_sid  -- 確保群組存在
WHERE sag.type = 'P'  -- 只遷移人員類型 (P)
  AND sag.target_sid IS NOT NULL
  AND sag.group_sid IS NOT NULL

PRINT '帳號權限群組對應遷移完成'
GO

-- ==========================================
-- 第四階段：建立 URL 對應表並遷移權限群組對應
-- ==========================================
PRINT '開始遷移權限群組對應...'

-- 建立 URL 對應暫存表
CREATE TABLE #UrlMapping (
    old_url NVARCHAR(200),
    new_route NVARCHAR(200),
    rule_name NVARCHAR(50)
)

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
('sys/groups_manage', '/permissions/groups', '權限群組')

-- 插入權限群組對應 (根據舊系統的 CRUD 權限展開)
INSERT INTO permission_group_map (
    groupSid, permissionSid, allow,
    createTime, createUser, updateTime, updateUser, dataStatus
)
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

-- 清理暫存表
DROP TABLE #UrlMapping

PRINT '權限群組對應遷移完成'
GO

-- ==========================================
-- 第五階段：驗證結果
-- ==========================================
PRINT '開始驗證遷移結果...'

PRINT '=== 遷移結果統計 ==='
SELECT '權限群組總數' as 項目, COUNT(*) as 數量 FROM permission_group
UNION ALL
SELECT '帳號權限群組對應總數', COUNT(*) FROM account_permission_group  
UNION ALL
SELECT '權限群組對應總數', COUNT(*) FROM permission_group_map
UNION ALL
SELECT '權限總數', COUNT(*) FROM permission

PRINT '=== 權限群組清單 ==='
SELECT sid, groupCode, name, remark FROM permission_group ORDER BY sid

PRINT '=== 帳號權限群組對應清單 ==='  
SELECT TOP 10 accountSid, groupSid FROM account_permission_group ORDER BY accountSid, groupSid

PRINT '=== 權限群組對應統計 (每個群組的權限數量) ==='
SELECT groupSid, COUNT(*) as 權限數量, SUM(CAST(allow AS INT)) as 允許數量
FROM permission_group_map 
GROUP BY groupSid 
ORDER BY groupSid

PRINT '驗證完成'
GO

PRINT '==========================================' 
PRINT '權限系統資料遷移腳本執行完成！'
PRINT '=========================================='