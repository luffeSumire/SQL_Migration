-- =============================================
-- 修復 Certifications.CreatedUserId 資料
-- 說明: 原本遷移時因使用者資料尚未完全就緒，將 CreatedUserId 統一設為 1 (系統管理員)
--       本腳本將根據 Certification 所屬學校 (SchoolId)
--       將 CreatedUserId 更新為該學校的第一個使用者 (AccountId 最小者)
--       若該學校無任何使用者，則維持原值 (1)
-- 策略: 取 Accounts 表中相同 SchoolId 且 AccountId 最小的使用者
-- Date: 2026-01-08
-- =============================================

USE EcoCampus_PreProduction;
GO

PRINT '========================================';
PRINT '開始修復 Certifications.CreatedUserId';
PRINT '執行時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- 1. 執行前檢查
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Certifications')
BEGIN
    PRINT '❌ 錯誤: 表 Certifications 不存在';
    RETURN;
END

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Accounts')
BEGIN
    PRINT '❌ 錯誤: 表 Accounts 不存在';
    RETURN;
END

-- 2. 建立更新前的統計
DECLARE @TotalCertifications INT;
DECLARE @DefaultAdminCount INT;

SELECT @TotalCertifications = COUNT(*) FROM Certifications;
SELECT @DefaultAdminCount = COUNT(*) FROM Certifications WHERE CreatedUserId = 1;

PRINT '總認證數: ' + CAST(@TotalCertifications AS VARCHAR);
PRINT '目前為預設管理員(ID=1)數: ' + CAST(@DefaultAdminCount AS VARCHAR);

-- 3. 執行更新
BEGIN TRY
    BEGIN TRANSACTION;

    -- 使用 UPDATE FROM 語法搭配 CROSS APPLY 找尋學校的第一個使用者
    -- CROSS APPLY 會過濾掉找不到對應使用者的記錄，這些記錄將保持原值 (1)
    UPDATE C
    SET CreatedUserId = SchoolUser.AccountId
    FROM Certifications C
    CROSS APPLY (
        -- 找出同學校且 ID 最小的使用者
        SELECT TOP 1 A.AccountId
        FROM Accounts A
        WHERE A.SchoolId = C.SchoolId
          AND A.SchoolId IS NOT NULL
        ORDER BY A.AccountId ASC
    ) SchoolUser
    WHERE C.CreatedUserId = 1; -- 僅更新尚未修復(ID=1)的記錄

    DECLARE @UpdatedCount INT = @@ROWCOUNT;

    COMMIT TRANSACTION;

    PRINT '✓ Certifications.CreatedUserId 修復完成';
    PRINT '  更新筆數: ' + CAST(@UpdatedCount AS VARCHAR);

    -- 4. 驗證更新後的狀況
    DECLARE @RemainingAdminCount INT;
    SELECT @RemainingAdminCount = COUNT(*) FROM Certifications WHERE CreatedUserId = 1;
    
    PRINT '  剩餘維持預設管理員(ID=1)數: ' + CAST(@RemainingAdminCount AS VARCHAR);
    IF @RemainingAdminCount > 0
        PRINT '  (這些記錄是因對應學校在 Accounts 表中無使用者)';

    -- 顯示更新範例 (前 10 筆已更新的資料)
    PRINT '--- 更新範例 (前 10 筆) ---';
    SELECT TOP 10
        C.CertificationId,
        S.SchoolCode,
        SC.Name AS SchoolName,
        'CreatedUserId: ' + CAST(C.CreatedUserId AS VARCHAR) + ' (' + ISNULL(A.Username, 'Unknown') + ')' AS UserInfo
    FROM Certifications C
    LEFT JOIN Schools S ON C.SchoolId = S.Id
    LEFT JOIN SchoolContents SC ON S.Id = SC.SchoolId AND SC.LocaleCode = 'zh-TW'
    LEFT JOIN Accounts A ON C.CreatedUserId = A.AccountId
    WHERE C.CreatedUserId != 1 -- 排除系統管理員
    ORDER BY C.CertificationId;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT '❌ 發生錯誤: ' + ERROR_MESSAGE();
END CATCH;
