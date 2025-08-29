-- =============================================
-- 13_2 認證系統 ReviewStatus 補丁腳本
-- 說明: 針對已完成的 13 認證系統資料遷移後，依新規則重新對應 Certifications.ReviewStatus
-- 新規則 (來源欄位: EcoCampus_Maria3.dbo.custom_certification.review):
--   '審核中'   -> 0
--   '通過'     -> 1
--   '退件'     -> 2
--   '補件'     -> 3
--   '尚未送審' -> 4
-- 兼容舊值: '待審核' 視同 '審核中'; '退件中' 視同 '退件'
-- 僅更新實際需要變更的記錄，並寫入 UpdatedTime, UpdatedUserId
-- 日期: 2025-08-26
-- =============================================
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

USE EcoCampus_PreProduction;
GO

PRINT '========================================';
PRINT '13_2 ReviewStatus 補丁開始';
PRINT '開始時間: ' + CONVERT(varchar, SYSDATETIME(), 120);
PRINT '========================================';

-- 驗證來源資料表存在
IF NOT EXISTS (SELECT 1 FROM EcoCampus_Maria3.sys.objects WHERE name = 'custom_certification')
BEGIN
    RAISERROR(N'來源資料表 EcoCampus_Maria3.dbo.custom_certification 不存在，終止執行',16,1);
    RETURN;
END;

-- 建立臨時表紀錄更新前分佈
IF OBJECT_ID('tempdb..#BeforeDist') IS NOT NULL DROP TABLE #BeforeDist;
SELECT ReviewStatus, Cnt = COUNT(*)
INTO #BeforeDist
FROM Certifications
GROUP BY ReviewStatus;

PRINT '更新前 ReviewStatus 分佈:';
SELECT * FROM #BeforeDist ORDER BY ReviewStatus;

-- 建立新的狀態計算 (不直接更新，先比對變更)
IF OBJECT_ID('tempdb..#NewStatus') IS NOT NULL DROP TABLE #NewStatus;
SELECT 
    c.CertificationId,
    OldStatus = c.ReviewStatus,
    NewStatus = CASE cc.review
        WHEN N'審核中'   THEN 0
        WHEN N'通過'     THEN 1
        WHEN N'退件'     THEN 2
        WHEN N'補件'     THEN 3
        WHEN N'尚未審核' THEN 4
        ELSE c.ReviewStatus  -- 未知值: 維持原狀
    END
INTO #NewStatus
FROM Certifications c
JOIN EcoCampus_Maria3.dbo.custom_certification cc ON cc.sid = c.CertificationId;

-- 找出需要更新的記錄
IF OBJECT_ID('tempdb..#ToUpdate') IS NOT NULL DROP TABLE #ToUpdate;
SELECT ns.CertificationId, ns.OldStatus, ns.NewStatus
INTO #ToUpdate
FROM #NewStatus ns
WHERE ns.NewStatus <> ns.OldStatus;

DECLARE @UpdateCount INT = (SELECT COUNT(*) FROM #ToUpdate);
PRINT '需更新記錄數: ' + CAST(@UpdateCount AS varchar(20));

BEGIN TRY
    BEGIN TRAN;

    UPDATE c
    SET c.ReviewStatus = tu.NewStatus
    --   ,c.UpdatedTime = SYSDATETIME(),
    --   ,c.UpdatedUserId = 1
    FROM Certifications c
    JOIN #ToUpdate tu ON tu.CertificationId = c.CertificationId;

    PRINT '已更新記錄數: ' + CAST(@@ROWCOUNT AS varchar(20));

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    DECLARE @ErrMsg nvarchar(4000) = ERROR_MESSAGE();
    DECLARE @ErrLine int = ERROR_LINE();
    RAISERROR(N'補丁失敗 (Line %d): %s',16,1,@ErrLine,@ErrMsg);
    RETURN;
END CATCH;

-- 更新後分佈
IF OBJECT_ID('tempdb..#AfterDist') IS NOT NULL DROP TABLE #AfterDist;
SELECT ReviewStatus, Cnt = COUNT(*)
INTO #AfterDist
FROM Certifications
GROUP BY ReviewStatus;

PRINT '更新後 ReviewStatus 分佈:';
SELECT * FROM #AfterDist ORDER BY ReviewStatus;

-- 顯示變更明細(前 50 筆)
PRINT '狀態變更前 50 筆 (CertificationId, OldStatus -> NewStatus):';
SELECT TOP 50 * FROM #ToUpdate ORDER BY CertificationId;

PRINT '========================================';
PRINT '13_2 ReviewStatus 補丁完成';
PRINT '完成時間: ' + CONVERT(varchar, SYSDATETIME(), 120);
PRINT '========================================';
GO
