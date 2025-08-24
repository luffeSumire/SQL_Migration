-- ========================================
-- FileEntry 初始資料匯入腳本（新增：執行前清除）
-- 來源: EcoCampus_Maria3.dbo.sys_files_store
-- 目標: EcoCampus_PreProduction.dbo.FileEntry
-- 說明: 先嘗試清除將要匯入的同名記錄（若被外鍵引用則跳過），
--       再以「僅插入不存在的」方式補齊，避免重複。
-- ========================================

USE EcoCampus_PreProduction;
GO

-- ========================================
-- 確保 FileHash 欄位存在
-- ========================================
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'FileEntry' AND COLUMN_NAME = 'FileHash'
)
BEGIN
    ALTER TABLE FileEntry ADD FileHash NCHAR(32) NULL;
    PRINT '✓ FileHash 欄位已新增至 FileEntry 表';
END
ELSE
BEGIN
    PRINT '✓ FileHash 欄位已存在於 FileEntry 表';
END
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
    (Id, Type, Path, OriginalFileName, OriginalExtension, FileName, Extension, FileHash)
SELECT
    NEWID() AS Id,
    N'File' AS Type,
    -- 統一處理路徑格式：移除 'admin/' 前綴，保留 SUBSTRING 語法便於部署時調整
    CASE 
        WHEN s.file_path LIKE 'admin/%' THEN '/uploads/' + SUBSTRING(s.file_path, 7, LEN(s.file_path)) -- 移除 'admin/' 前綴 (7 = LEN('admin/') + 1)
        ELSE '/uploads/' + s.file_path -- 保持原樣，以防有其他格式
    END AS Path,
    s.name AS OriginalFileName,
    s.file_ext AS OriginalExtension,
    s.name AS FileName,
    s.file_ext AS Extension,
    s.file_hash AS FileHash
FROM EcoCampus_Maria3.dbo.sys_files_store s
WHERE NOT EXISTS (
    SELECT 1
    FROM EcoCampus_PreProduction.dbo.FileEntry fe
    WHERE fe.FileName = s.name
);

SET @Inserted = @@ROWCOUNT;

-- ========================================
-- 2. 路徑處理統計
-- ========================================
DECLARE @AdminPathCount INT = (
    SELECT COUNT(*) 
    FROM EcoCampus_PreProduction.dbo.FileEntry fe
    INNER JOIN EcoCampus_Maria3.dbo.sys_files_store s ON fe.FileName = s.name
    WHERE s.file_path LIKE 'admin/%'
);

DECLARE @OtherPathCount INT = (
    SELECT COUNT(*) 
    FROM EcoCampus_PreProduction.dbo.FileEntry fe
    INNER JOIN EcoCampus_Maria3.dbo.sys_files_store s ON fe.FileName = s.name
    WHERE s.file_path NOT LIKE 'admin/%'
);

PRINT '========================================';
PRINT '匯入完成統計:';
PRINT '- 新增筆數: ' + CAST(@Inserted AS VARCHAR);
PRINT '';
PRINT '路徑格式處理統計:';
PRINT '- admin/ 開頭路徑: ' + CAST(@AdminPathCount AS VARCHAR) + ' 筆 → 移除 admin/ 前綴';
PRINT '- 其他路徑: ' + CAST(@OtherPathCount AS VARCHAR) + ' 筆 → 保持原樣';
PRINT '';

-- 顯示路徑轉換範例
IF @AdminPathCount > 0
BEGIN
    PRINT '路徑轉換範例:';
    
    -- admin/ 開頭路徑範例
    SELECT TOP 3 
        s.file_path as [原路徑],
        fe.Path as [新路徑]
    FROM EcoCampus_PreProduction.dbo.FileEntry fe
    INNER JOIN EcoCampus_Maria3.dbo.sys_files_store s ON fe.FileName = s.name
    WHERE s.file_path LIKE 'admin/%'
    ORDER BY s.name;
END

PRINT '';
PRINT '完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';