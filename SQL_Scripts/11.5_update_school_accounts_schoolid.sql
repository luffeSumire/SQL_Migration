-- =============================================
-- 更新學校夥伴帳戶的SchoolId關聯
-- 執行順序: 在 11_account_migration.sql 之後執行
-- 功能: 為IsSchoolPartner=1的使用者設定正確的SchoolId
-- Date: 2025-08-09
-- =============================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

USE EcoCampus_PreProduction;
GO

-- =============================================
-- 更新學校夥伴帳戶的SchoolId
-- =============================================
PRINT '=== 開始更新學校夥伴帳戶的SchoolId ===';

DECLARE @UpdatedCount INT = 0;

-- 更新IsSchoolPartner=1使用者的SchoolId
UPDATE a
SET SchoolId = s.Id
FROM Accounts a
INNER JOIN (
    SELECT 
        CASE WHEN cm.sid = 1 THEN (SELECT MAX(sid) + 1 FROM EcoCampus_Maria3.dbo.custom_member) ELSE cm.sid END AS AccountId,
        cm.code AS SchoolCode
    FROM EcoCampus_Maria3.dbo.custom_member cm
    WHERE cm.member_role = 'school'
      AND cm.code IS NOT NULL
      AND cm.code != ''
) cm_mapping ON a.AccountId = cm_mapping.AccountId
INNER JOIN Schools s ON s.SchoolCode = cm_mapping.SchoolCode
WHERE a.IsSchoolPartner = 1
  AND a.SchoolId IS NULL;

SET @UpdatedCount = @@ROWCOUNT;
PRINT '✓ 已更新學校夥伴帳戶的SchoolId: ' + CAST(@UpdatedCount AS VARCHAR) + ' 筆';

-- =============================================
-- 驗證更新結果
-- =============================================
PRINT '=== 驗證更新結果 ===';

-- 統計IsSchoolPartner使用者的SchoolId設定情況
SELECT 
    '學校夥伴帳戶SchoolId統計' as 統計項目,
    COUNT(*) as 總數,
    COUNT(SchoolId) as 已設定SchoolId數量,
    COUNT(*) - COUNT(SchoolId) as 未設定SchoolId數量
FROM Accounts 
WHERE IsSchoolPartner = 1;

-- 顯示更新結果範例
PRINT '更新結果範例 (前5筆):';
SELECT TOP 5
    a.AccountId,
    a.Username,
    a.SchoolId,
    s.SchoolCode,
    sc.Name as SchoolName
FROM Accounts a
LEFT JOIN Schools s ON a.SchoolId = s.Id
LEFT JOIN SchoolContents sc ON s.Id = sc.SchoolId AND sc.LocaleCode = 'zh-TW'
WHERE a.IsSchoolPartner = 1
  AND a.SchoolId IS NOT NULL
ORDER BY a.AccountId;

-- 檢查仍未設定SchoolId的帳戶
DECLARE @UnlinkedCount INT = (
    SELECT COUNT(*) 
    FROM Accounts 
    WHERE IsSchoolPartner = 1 AND SchoolId IS NULL
);

IF @UnlinkedCount > 0
BEGIN
    PRINT '⚠️ 仍有 ' + CAST(@UnlinkedCount AS VARCHAR) + ' 個學校夥伴帳戶未設定SchoolId';
    PRINT '可能原因:';
    PRINT '1. custom_member.code為空或NULL';
    PRINT '2. Schools表中找不到對應的SchoolCode';
    PRINT '3. 資料不一致問題';
    
    -- 顯示未能關聯的帳戶詳情
    PRINT '未能關聯的帳戶範例 (前5筆):';
    SELECT TOP 5
        a.AccountId,
        a.Username,
        cm.code as OriginalSchoolCode,
        cm.member_cname as OriginalSchoolName
    FROM Accounts a
    LEFT JOIN (
        SELECT 
            CASE WHEN cm.sid = 1 THEN (SELECT MAX(sid) + 1 FROM EcoCampus_Maria3.dbo.custom_member) ELSE cm.sid END AS AccountId,
            cm.code,
            cm.member_cname
        FROM EcoCampus_Maria3.dbo.custom_member cm
        WHERE cm.member_role = 'school'
    ) cm ON a.AccountId = cm.AccountId
    WHERE a.IsSchoolPartner = 1 
      AND a.SchoolId IS NULL
    ORDER BY a.AccountId;
END
ELSE
BEGIN
    PRINT '✅ 所有學校夥伴帳戶的SchoolId都已正確設定！';
END

PRINT '=== 學校夥伴帳戶SchoolId更新完成 ===';
GO