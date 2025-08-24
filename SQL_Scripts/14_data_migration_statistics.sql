-- ========================================
-- 資料遷移統計腳本 (Data Migration Statistics)
-- 用途: 統計所有遷移腳本的來源與目標資料量，提供完整的遷移狀況報告
-- 來源: EcoCampus_Maria3 (舊系統)
-- 目標: EcoCampus_PreProduction (新系統)
-- 建立日期: 2025-08-21
-- 版本: v1.0 - 完整統計版本
-- ========================================

-- ========================================
-- 環境設定區 (依環境調整以下設定)
-- ========================================
-- 目標資料庫設定 (請依環境修改)
-- 測試環境: EcoCampus_PreProduction
-- 正式環境: Ecocampus (或其他正式環境名稱)
USE EcoCampus_PreProduction;

-- 來源資料庫設定 (通常固定為舊系統)
DECLARE @SourceDB NVARCHAR(100) = 'EcoCampus_Maria3';
-- ========================================
GO

PRINT '========================================';
PRINT '資料遷移統計腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- ========================================
-- 1. 來源資料統計區 (EcoCampus_Maria3)
-- ========================================
PRINT '';
PRINT '========================================';
PRINT '1️⃣ 來源資料統計 (EcoCampus_Maria3)';
PRINT '========================================';

-- 1.1 檔案系統相關
PRINT '';
PRINT '【檔案系統相關】';
SELECT 
    'sys_files_store' as 資料表名稱,
    COUNT(*) as 總筆數,
    COUNT(CASE WHEN file_path LIKE 'admin/%' THEN 1 END) as admin路徑筆數,
    COUNT(CASE WHEN file_path NOT LIKE 'admin/%' THEN 1 END) as 其他路徑筆數
FROM [EcoCampus_Maria3].[dbo].[sys_files_store];

-- 1.2 文章系統相關
PRINT '';
PRINT '【文章系統相關】';
SELECT 
    'custom_article 總計' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_article]
UNION ALL
SELECT 
    'custom_article (type=fqa)' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_article] 
WHERE type = 'fqa'
UNION ALL
SELECT 
    'custom_article (type=file_dl)' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_article] 
WHERE type = 'file_dl'
UNION ALL
SELECT 
    'custom_article (type=news)' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_article] 
WHERE type = 'news'
UNION ALL
SELECT 
    'custom_article (type=related)' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_article] 
WHERE type = 'related'
UNION ALL
SELECT 
    'custom_article (type=video)' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_article] 
WHERE type = 'video'
ORDER BY 分類;

-- 1.3 新聞系統相關
PRINT '';
PRINT '【新聞系統相關】';
SELECT 
    'custom_news 總計' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_news]
UNION ALL
SELECT 
    'custom_news (type=release)' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_news]
WHERE type = 'release'
UNION ALL
SELECT 
    'custom_article_file_link' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_article_file_link];

-- 1.4 社會資源相關
PRINT '';
PRINT '【社會資源相關】';
SELECT 
    'custom_social_agency' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_social_agency]
UNION ALL
SELECT 
    'custom_social_agency_to_tag' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_social_agency_to_tag]
UNION ALL
SELECT 
    'custom_tag' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_tag];

-- 1.5 綠旗相關
PRINT '';
PRINT '【綠旗相關】';
SELECT 
    'custom_flagarea' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_flagarea]
UNION ALL
SELECT 
    'custom_flagarea_data' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_flagarea_data];

-- 1.6 學校系統相關
PRINT '';
PRINT '【學校系統相關】';
SELECT 
    'custom_member 總計' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_member]
UNION ALL
SELECT 
    'custom_member (學校)' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_member]
WHERE member_role = 'school'
UNION ALL
SELECT 
    'custom_member (非學校)' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_member]
WHERE member_role != 'school' OR member_role IS NULL
UNION ALL
SELECT 
    'custom_school_principal' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_school_principal]
UNION ALL
SELECT 
    'custom_school_statistics' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_school_statistics]
UNION ALL
SELECT 
    'custom_contact' as 分類,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_contact];

-- 1.7 後台帳號權限相關
PRINT '';
PRINT '【後台帳號權限相關】';
SELECT 
    'sys_account' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[sys_account]
UNION ALL
SELECT 
    'sys_groups' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[sys_groups]
UNION ALL
SELECT 
    'sys_account_groups' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[sys_account_groups]
UNION ALL
SELECT 
    'sys_groups_rule' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[sys_groups_rule]
UNION ALL
SELECT 
    'sys_rule' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[sys_rule];

-- 1.8 認證系統相關
PRINT '';
PRINT '【認證系統相關】';
SELECT 
    'custom_question' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_question]
UNION ALL
SELECT 
    'custom_certification' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_certification]
UNION ALL
SELECT 
    'custom_certification_answer' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_certification_answer]
UNION ALL
SELECT 
    'custom_certification_answer_record' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_certification_answer_record]
UNION ALL
SELECT 
    'custom_certification_step_record' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_certification_step_record];

-- 1.9 校園投稿相關
PRINT '';
PRINT '【校園投稿相關】';
SELECT 
    'custom_release_en_tw' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_release_en_tw]
UNION ALL
SELECT 
    'custom_release_photo' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[custom_release_photo];

-- 1.10 其他系統表
PRINT '';
PRINT '【其他系統表】';
SELECT 
    'sys_cityarea' as 資料表,
    COUNT(*) as 筆數
FROM [EcoCampus_Maria3].[dbo].[sys_cityarea];

-- ========================================
-- 2. 目標資料統計區 (EcoCampus_PreProduction)
-- ========================================
PRINT '';
PRINT '========================================';
PRINT '2️⃣ 目標資料統計 (EcoCampus_PreProduction)';
PRINT '========================================';

-- 2.1 檔案系統
PRINT '';
PRINT '【檔案系統】';
SELECT 
    'FileEntry' as 資料表,
    COUNT(*) as 筆數,
    COUNT(CASE WHEN Path LIKE '/uploads/%' THEN 1 END) as uploads路徑筆數
FROM FileEntry;

-- 2.2 環境路徑
PRINT '';
PRINT '【環境路徑】';
SELECT 
    'EnvironmentalPaths' as 資料表,
    COUNT(*) as 筆數
FROM EnvironmentalPaths
UNION ALL
SELECT 
    'EnvironmentalPathTranslations' as 資料表,
    COUNT(*) as 筆數
FROM EnvironmentalPathTranslations;

-- 2.3 FAQ系統
PRINT '';
PRINT '【FAQ系統】';
SELECT 
    'Faqs' as 資料表,
    COUNT(*) as 筆數
FROM Faqs
UNION ALL
SELECT 
    'FaqContents' as 資料表,
    COUNT(*) as 筆數
FROM FaqContents;

-- 2.4 下載系統
PRINT '';
PRINT '【下載系統】';
SELECT 
    'Downloads' as 資料表,
    COUNT(*) as 筆數
FROM Downloads
UNION ALL
SELECT 
    'DownloadContents' as 資料表,
    COUNT(*) as 筆數
FROM DownloadContents
UNION ALL
SELECT 
    'DownloadAttachments' as 資料表,
    COUNT(*) as 筆數
FROM DownloadAttachments;

-- 2.5 文章/新聞系統
PRINT '';
PRINT '【文章/新聞系統】';
SELECT 
    'Articles' as 資料表,
    COUNT(*) as 筆數
FROM Articles
UNION ALL
SELECT 
    'ArticleContents' as 資料表,
    COUNT(*) as 筆數
FROM ArticleContents
UNION ALL
SELECT 
    'ArticleAttachments' as 資料表,
    COUNT(*) as 筆數
FROM ArticleAttachments;

-- 2.6 友善連結
PRINT '';
PRINT '【友善連結】';
SELECT 
    'FriendlyLinks' as 資料表,
    COUNT(*) as 筆數
FROM FriendlyLinks
UNION ALL
SELECT 
    'FriendlyLinkTranslations' as 資料表,
    COUNT(*) as 筆數
FROM FriendlyLinkTranslations;

-- 2.7 社會資源
PRINT '';
PRINT '【社會資源】';
SELECT 
    'SocialAgencies' as 資料表,
    COUNT(*) as 筆數
FROM SocialAgencies
UNION ALL
SELECT 
    'SocialAgencyContents' as 資料表,
    COUNT(*) as 筆數
FROM SocialAgencyContents
UNION ALL
SELECT 
    'SocialAgencyTagMappings' as 資料表,
    COUNT(*) as 筆數
FROM SocialAgencyTagMappings;

-- 2.8 綠旗文章
PRINT '';
PRINT '【綠旗文章】';
SELECT 
    'GreenFlagArticles' as 資料表,
    COUNT(*) as 筆數
FROM GreenFlagArticles
UNION ALL
SELECT 
    'GreenFlagArticleContents' as 資料表,
    COUNT(*) as 筆數
FROM GreenFlagArticleContents
UNION ALL
SELECT 
    'GreenFlagArticleAttachments' as 資料表,
    COUNT(*) as 筆數
FROM GreenFlagArticleAttachments;

-- 2.9 影片系統
PRINT '';
PRINT '【影片系統】';
SELECT 
    'Videos' as 資料表,
    COUNT(*) as 筆數
FROM Videos
UNION ALL
SELECT 
    'VideoTranslations' as 資料表,
    COUNT(*) as 筆數
FROM VideoTranslations;

-- 2.10 學校系統
PRINT '';
PRINT '【學校系統】';
SELECT 
    'Schools' as 資料表,
    COUNT(*) as 筆數
FROM Schools
UNION ALL
SELECT 
    'SchoolContents' as 資料表,
    COUNT(*) as 筆數
FROM SchoolContents
UNION ALL
SELECT 
    'SchoolPrincipals' as 資料表,
    COUNT(*) as 筆數
FROM SchoolPrincipals
UNION ALL
SELECT 
    'SchoolStatistics' as 資料表,
    COUNT(*) as 筆數
FROM SchoolStatistics
UNION ALL
SELECT 
    'SchoolContacts' as 資料表,
    COUNT(*) as 筆數
FROM SchoolContacts
UNION ALL
SELECT 
    'SchoolEnvironmentalPathStatuses' as 資料表,
    COUNT(*) as 筆數
FROM SchoolEnvironmentalPathStatuses;

-- 2.11 校園投稿系統
PRINT '';
PRINT '【校園投稿系統】';
SELECT 
    'CampusSubmissions' as 資料表,
    COUNT(*) as 筆數
FROM CampusSubmissions
UNION ALL
SELECT 
    'CampusSubmissionContents' as 資料表,
    COUNT(*) as 筆數
FROM CampusSubmissionContents
UNION ALL
SELECT 
    'CampusSubmissionAttachments' as 資料表,
    COUNT(*) as 筆數
FROM CampusSubmissionAttachments
UNION ALL
SELECT 
    'CampusSubmissionReviews' as 資料表,
    COUNT(*) as 筆數
FROM CampusSubmissionReviews
UNION ALL
SELECT 
    'BadgeTypes' as 資料表,
    COUNT(*) as 筆數
FROM BadgeTypes;

-- 2.12 帳號系統
PRINT '';
PRINT '【帳號系統】';
SELECT 
    'Accounts' as 資料表,
    COUNT(*) as 筆數
FROM Accounts
UNION ALL
SELECT 
    'MemberProfiles' as 資料表,
    COUNT(*) as 筆數
FROM MemberProfiles;

-- 2.13 權限系統
PRINT '';
PRINT '【權限系統】';
SELECT 
    'permission_group' as 資料表,
    COUNT(*) as 筆數
FROM permission_group
UNION ALL
SELECT 
    'account_permission_group' as 資料表,
    COUNT(*) as 筆數
FROM account_permission_group
UNION ALL
SELECT 
    'permission_group_map' as 資料表,
    COUNT(*) as 筆數
FROM permission_group_map
UNION ALL
SELECT 
    'permission' as 資料表,
    COUNT(*) as 筆數
FROM permission;

-- 2.14 認證系統
PRINT '';
PRINT '【認證系統】';
SELECT 
    'Questions' as 資料表,
    COUNT(*) as 筆數
FROM Questions
UNION ALL
SELECT 
    'Certifications' as 資料表,
    COUNT(*) as 筆數
FROM Certifications
UNION ALL
SELECT 
    'CertificationAnswers' as 資料表,
    COUNT(*) as 筆數
FROM CertificationAnswers
UNION ALL
SELECT 
    'CertificationStepRecords' as 資料表,
    COUNT(*) as 筆數
FROM CertificationStepRecords
UNION ALL
SELECT 
    'CertificationTypes' as 資料表,
    COUNT(*) as 筆數
FROM CertificationTypes;

-- 2.15 其他系統表
PRINT '';
PRINT '【其他系統表】';
SELECT 
    'Counties' as 資料表,
    COUNT(*) as 筆數
FROM Counties
UNION ALL
SELECT 
    'CountyTranslations' as 資料表,
    COUNT(*) as 筆數
FROM CountyTranslations;

-- ========================================
-- 3. 對比分析區
-- ========================================
PRINT '';
PRINT '========================================';
PRINT '3️⃣ 遷移對比分析';
PRINT '========================================';

PRINT '';
PRINT '【主要遷移對應關係分析】';

-- 3.1 檔案系統對比
PRINT '';
PRINT '🔸 檔案系統遷移對比:';
SELECT 
    'FileEntry遷移' as 項目,
    (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[sys_files_store]) as 來源筆數,
    (SELECT COUNT(*) FROM FileEntry) as 目標筆數,
    CASE 
        WHEN (SELECT COUNT(*) FROM FileEntry) >= (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[sys_files_store]) 
        THEN '✓ 完成' 
        ELSE '⚠ 未完成' 
    END as 狀態;

-- 3.2 FAQ系統對比
PRINT '';
PRINT '🔸 FAQ系統遷移對比:';
SELECT 
    'FAQ遷移' as 項目,
    (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_article] WHERE type = 'fqa') as 來源筆數,
    (SELECT COUNT(*) FROM Faqs) as 目標筆數,
    CASE 
        WHEN (SELECT COUNT(*) FROM Faqs) >= (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_article] WHERE type = 'fqa') 
        THEN '✓ 完成' 
        ELSE '⚠ 未完成' 
    END as 狀態;

-- 3.3 下載系統對比
PRINT '';
PRINT '🔸 下載系統遷移對比:';
SELECT 
    'Downloads遷移' as 項目,
    (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_article] WHERE type = 'file_dl') as 來源筆數,
    (SELECT COUNT(*) FROM Downloads) as 目標筆數,
    CASE 
        WHEN (SELECT COUNT(*) FROM Downloads) >= (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_article] WHERE type = 'file_dl') 
        THEN '✓ 完成' 
        ELSE '⚠ 未完成' 
    END as 狀態;

-- 3.4 新聞系統對比
PRINT '';
PRINT '🔸 新聞系統遷移對比:';
SELECT 
    '新聞遷移' as 項目,
    ((SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_news]) + (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_article] WHERE type = 'news')) as 來源筆數,
    (SELECT COUNT(*) FROM Articles) as 目標筆數,
    CASE 
        WHEN (SELECT COUNT(*) FROM Articles) >= ((SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_news]) + (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_article] WHERE type = 'news'))
        THEN '✓ 完成' 
        ELSE '⚠ 未完成' 
    END as 狀態;

-- 3.5 影片系統對比
PRINT '';
PRINT '🔸 影片系統遷移對比:';
SELECT 
    'Video遷移' as 項目,
    (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_article] WHERE type = 'video') as 來源筆數,
    (SELECT COUNT(*) FROM Videos) as 目標筆數,
    CASE 
        WHEN (SELECT COUNT(*) FROM Videos) >= (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_article] WHERE type = 'video') 
        THEN '✓ 完成' 
        ELSE '⚠ 未完成' 
    END as 狀態;

-- 3.6 學校系統對比
PRINT '';
PRINT '🔸 學校系統遷移對比:';
SELECT 
    '學校遷移' as 項目,
    (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_member] WHERE member_role = 'school') as 來源筆數,
    (SELECT COUNT(*) FROM Schools) as 目標筆數,
    CASE 
        WHEN (SELECT COUNT(*) FROM Schools) >= (SELECT COUNT(*) FROM [EcoCampus_Maria3].[dbo].[custom_member] WHERE member_role = 'school') 
        THEN '✓ 完成' 
        ELSE '⚠ 未完成' 
    END as 狀態;

-- ========================================
-- 4. 遷移完成度報告
-- ========================================
PRINT '';
PRINT '========================================';
PRINT '4️⃣ 遷移完成度總報告';
PRINT '========================================';

-- 統計各模組遷移狀況
DECLARE @TotalModules INT = 13;
DECLARE @CompletedModules INT = 0;

-- 檢查各模組完成狀況
IF (SELECT COUNT(*) FROM FileEntry) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM Faqs) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM Downloads) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM Articles) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM FriendlyLinks) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM SocialAgencies) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM GreenFlagArticles) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM Videos) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM Schools) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM CampusSubmissions) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM Accounts) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM permission_group) > 0 SET @CompletedModules = @CompletedModules + 1;
IF (SELECT COUNT(*) FROM Questions) > 0 SET @CompletedModules = @CompletedModules + 1;

PRINT '';
PRINT '🏆 整體遷移完成度: ' + CAST(@CompletedModules AS VARCHAR) + '/' + CAST(@TotalModules AS VARCHAR) + ' (' + CAST((@CompletedModules * 100 / @TotalModules) AS VARCHAR) + '%)';

PRINT '';
PRINT '📊 主要資料量統計:';
SELECT 
    '總來源資料表數' as 統計項目,
    (SELECT COUNT(DISTINCT TABLE_NAME) FROM [EcoCampus_Maria3].[INFORMATION_SCHEMA].[TABLES] WHERE TABLE_TYPE = 'BASE TABLE') as 數量
UNION ALL
SELECT 
    '總目標資料表數' as 統計項目,
    (SELECT COUNT(DISTINCT TABLE_NAME) FROM [INFORMATION_SCHEMA].[TABLES] WHERE TABLE_TYPE = 'BASE TABLE') as 數量
UNION ALL
SELECT 
    '已遷移模組數' as 統計項目,
    @CompletedModules as 數量
UNION ALL
SELECT 
    '總模組數' as 統計項目,
    @TotalModules as 數量;

-- ========================================
-- 5. 資料品質檢查
-- ========================================
PRINT '';
PRINT '========================================';
PRINT '5️⃣ 資料品質檢查報告';
PRINT '========================================';

PRINT '';
PRINT '【重要資料完整性檢查】';

-- 檢查學校對應關係
PRINT '';
PRINT '🔍 學校代碼對應檢查:';
SELECT 
    '可成功對應到新系統的學校數' as 檢查項目,
    COUNT(*) as 數量
FROM [EcoCampus_Maria3].[dbo].[custom_member] cm 
INNER JOIN Schools s ON s.SchoolCode = CASE 
    WHEN cm.sid = 812 THEN N'193665' 
    WHEN cm.sid = 603 THEN N'034639' 
    WHEN cm.sid = 796 THEN N'061F01' 
    ELSE cm.code 
END
WHERE cm.member_role = 'school'
UNION ALL
SELECT 
    '來源學校總數' as 檢查項目,
    COUNT(*) as 數量
FROM [EcoCampus_Maria3].[dbo].[custom_member] 
WHERE member_role = 'school';

-- 檢查檔案路徑轉換
PRINT '';
PRINT '🔍 檔案路徑轉換檢查:';
SELECT 
    'admin路徑轉換數量' as 檢查項目,
    COUNT(*) as 數量
FROM [EcoCampus_Maria3].[dbo].[sys_files_store] 
WHERE file_path LIKE 'admin/%'
UNION ALL
SELECT 
    '非admin路徑數量' as 檢查項目,
    COUNT(*) as 數量
FROM [EcoCampus_Maria3].[dbo].[sys_files_store] 
WHERE file_path NOT LIKE 'admin/%';

-- ========================================
-- 結束報告
-- ========================================
PRINT '';
PRINT '========================================';
PRINT '📋 統計腳本執行完成';
PRINT '完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '';
PRINT '💡 使用說明:';
PRINT '- 此腳本提供完整的遷移前後資料對比';
PRINT '- 建議在每次遷移前後執行以確認結果';
PRINT '- ✓ 表示該模組遷移完成';
PRINT '- ⚠ 表示該模組可能未完整遷移';
PRINT '========================================';

-- TODO : 校園投稿帶有連結附件 尚未進行遷移
-- TODO : 02_downloads 英文語系檔沒有附件 從缺