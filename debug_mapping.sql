USE EcoCampus_PreProduction;

-- 檢查 URL 映射是否有問題
CREATE TABLE #UrlMapping (
    old_url NVARCHAR(200),
    new_route NVARCHAR(200),
    rule_name NVARCHAR(50)
);

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

-- 檢查匹配的規則數量
SELECT 'matching_rules' as type, COUNT(*) as count
FROM [EcoCampus_Maria3].[dbo].[sys_groups_rule] sgr
INNER JOIN [EcoCampus_Maria3].[dbo].[sys_rule] sr ON sr.sid = sgr.rule_sid
INNER JOIN #UrlMapping um ON um.old_url = sr.url
WHERE sgr.groups_sid IS NOT NULL
  AND sgr.rule_sid IS NOT NULL
  AND sr.rule_name IS NOT NULL
  AND sr.url IS NOT NULL;

-- 檢查按群組分布的匹配規則
SELECT sgr.groups_sid, COUNT(*) as matching_rules
FROM [EcoCampus_Maria3].[dbo].[sys_groups_rule] sgr
INNER JOIN [EcoCampus_Maria3].[dbo].[sys_rule] sr ON sr.sid = sgr.rule_sid
INNER JOIN #UrlMapping um ON um.old_url = sr.url
WHERE sgr.groups_sid IS NOT NULL
  AND sgr.rule_sid IS NOT NULL
  AND sr.rule_name IS NOT NULL
  AND sr.url IS NOT NULL
GROUP BY sgr.groups_sid
ORDER BY sgr.groups_sid;

-- 檢查未匹配的規則 (前10筆)
SELECT TOP 10 sr.sid, sr.rule_name, sr.url
FROM [EcoCampus_Maria3].[dbo].[sys_rule] sr
LEFT JOIN #UrlMapping um ON um.old_url = sr.url
WHERE um.old_url IS NULL
  AND sr.url IS NOT NULL
ORDER BY sr.sid;

DROP TABLE #UrlMapping;