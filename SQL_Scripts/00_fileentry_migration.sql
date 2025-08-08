-- ========================================
-- FileEntry 初始資料匯入腳本（新增：執行前清除）
-- 來源: EcoCampus_Maria3.dbo.sys_files_store
-- 目標: EcoCampus_PreProduction.dbo.FileEntry
-- 說明: 先嘗試清除將要匯入的同名記錄（若被外鍵引用則跳過），
--       再以「僅插入不存在的」方式補齊，避免重複。
-- ========================================

USE EcoCampus_PreProduction;
GO

DECLARE @StartTime DATETIME2 = SYSDATETIME();
PRINT '========================================';
PRINT 'FileEntry 匯入腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, @StartTime, 120);
PRINT '========================================';

-- ========================================
-- 0. 執行前清除（僅刪除將要匯入且未被引用或允許刪除的記錄）
--    若因為外鍵引用造成刪除失敗，將跳過刪除並改為只做補齊插入。
-- ========================================
BEGIN TRY
    PRINT '步驟 0: 清除既有同名 FileEntry 記錄（來源集合）...';
    DELETE fe
    FROM EcoCampus_PreProduction.dbo.FileEntry fe
    WHERE fe.FileName IN (
        SELECT name FROM EcoCampus_Maria3.dbo.sys_files_store
    );
    PRINT '✓ 已刪除筆數: ' + CAST(@@ROWCOUNT AS VARCHAR);
END TRY
BEGIN CATCH
    PRINT '⚠️ 清除失敗，可能因外鍵引用存在。將跳過刪除，僅插入缺少的記錄。';
END CATCH;

-- ========================================
-- 1. 匯入 FileEntry（僅插入不存在的）
-- ========================================
DECLARE @Inserted INT = 0;

INSERT INTO EcoCampus_PreProduction.dbo.FileEntry
    (Id, Type, Path, OriginalFileName, OriginalExtension, FileName, Extension)
SELECT
    NEWID() AS Id,
    N'File' AS Type,
    '/uploads/' + s.file_path AS Path,
    s.name AS OriginalFileName,
    s.file_ext AS OriginalExtension,
    s.name AS FileName,
    s.file_ext AS Extension
FROM EcoCampus_Maria3.dbo.sys_files_store s
WHERE NOT EXISTS (
    SELECT 1
    FROM EcoCampus_PreProduction.dbo.FileEntry fe
    WHERE fe.FileName = s.name
);

SET @Inserted = @@ROWCOUNT;

PRINT '========================================';
PRINT '匯入完成統計:';
PRINT '- 新增筆數: ' + CAST(@Inserted AS VARCHAR);
PRINT '完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';
