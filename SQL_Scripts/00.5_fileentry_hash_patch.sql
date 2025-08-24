-- ========================================
-- FileEntry Hash 補丁腳本
-- 來源: EcoCampus_Maria3.dbo.sys_files_store
-- 目標: EcoCampus_PreProduction2.dbo.FileEntry
-- 說明: 為已存在的 FileEntry 記錄補上 FileHash 欄位和數值
--       適用於已經執行過舊版 00 腳本但缺少 hash 的環境
-- ========================================

USE EcoCampus_PreProduction2;
GO

DECLARE @StartTime DATETIME2 = SYSDATETIME();
PRINT '========================================';
PRINT 'FileEntry Hash 補丁腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, @StartTime, 120);
PRINT '========================================';

-- ========================================
-- 1. 確保 FileHash 欄位存在
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

-- ========================================
-- 2. 統計現有資料狀況
-- ========================================
DECLARE @TotalRecords INT = (SELECT COUNT(*) FROM FileEntry);
DECLARE @RecordsWithHash INT = (SELECT COUNT(*) FROM FileEntry WHERE FileHash IS NOT NULL);
DECLARE @RecordsNeedUpdate INT = (SELECT COUNT(*) FROM FileEntry WHERE FileHash IS NULL);

PRINT '========================================';
PRINT '現有資料狀況統計:';
PRINT '- 總記錄數: ' + CAST(@TotalRecords AS VARCHAR);
PRINT '- 已有 Hash 值: ' + CAST(@RecordsWithHash AS VARCHAR);
PRINT '- 需要補丁: ' + CAST(@RecordsNeedUpdate AS VARCHAR);
PRINT '========================================';

-- ========================================
-- 3. 更新缺少 Hash 的記錄
-- ========================================
DECLARE @UpdatedRecords INT = 0;

IF @RecordsNeedUpdate > 0
BEGIN
    PRINT '步驟 1: 開始更新缺少 Hash 的記錄...';
    
    UPDATE fe
    SET FileHash = s.file_hash
    FROM EcoCampus_PreProduction2.dbo.FileEntry fe
    INNER JOIN EcoCampus_Maria3.dbo.sys_files_store s ON fe.FileName = s.name
    WHERE fe.FileHash IS NULL
      AND s.file_hash IS NOT NULL;
    
    SET @UpdatedRecords = @@ROWCOUNT;
    PRINT '✓ 已更新記錄數: ' + CAST(@UpdatedRecords AS VARCHAR);
END
ELSE
BEGIN
    PRINT '📋 所有記錄都已有 Hash 值，無需更新。';
END

-- ========================================
-- 4. 處理找不到對應 Hash 的記錄
-- ========================================
DECLARE @OrphanRecords INT = (
    SELECT COUNT(*)
    FROM EcoCampus_PreProduction2.dbo.FileEntry fe
    WHERE fe.FileHash IS NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM EcoCampus_Maria3.dbo.sys_files_store s 
          WHERE s.name = fe.FileName AND s.file_hash IS NOT NULL
      )
);

IF @OrphanRecords > 0
BEGIN
    PRINT '⚠️ 注意: ' + CAST(@OrphanRecords AS VARCHAR) + ' 筆記錄在來源系統找不到對應的 Hash 值';
    
    -- 顯示前 5 筆找不到 Hash 的記錄
    PRINT '找不到 Hash 的檔案範例:';
    SELECT TOP 5 FileName
    FROM EcoCampus_PreProduction2.dbo.FileEntry fe
    WHERE fe.FileHash IS NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM EcoCampus_Maria3.dbo.sys_files_store s 
          WHERE s.name = fe.FileName AND s.file_hash IS NOT NULL
      )
    ORDER BY FileName;
END

-- ========================================
-- 5. 最終統計結果
-- ========================================
DECLARE @FinalTotalRecords INT = (SELECT COUNT(*) FROM FileEntry);
DECLARE @FinalRecordsWithHash INT = (SELECT COUNT(*) FROM FileEntry WHERE FileHash IS NOT NULL);
DECLARE @FinalRecordsWithoutHash INT = (SELECT COUNT(*) FROM FileEntry WHERE FileHash IS NULL);

PRINT '========================================';
PRINT '補丁完成統計:';
PRINT '- 總記錄數: ' + CAST(@FinalTotalRecords AS VARCHAR);
PRINT '- 有 Hash 值: ' + CAST(@FinalRecordsWithHash AS VARCHAR) + ' (' + 
      CAST(CAST(@FinalRecordsWithHash * 100.0 / @FinalTotalRecords AS DECIMAL(5,2)) AS VARCHAR) + '%)';
PRINT '- 無 Hash 值: ' + CAST(@FinalRecordsWithoutHash AS VARCHAR) + ' (' + 
      CAST(CAST(@FinalRecordsWithoutHash * 100.0 / @FinalTotalRecords AS DECIMAL(5,2)) AS VARCHAR) + '%)';
PRINT '- 本次更新: ' + CAST(@UpdatedRecords AS VARCHAR) + ' 筆記錄';
PRINT '';

-- 顯示更新範例
IF @UpdatedRecords > 0
BEGIN
    PRINT 'Hash 更新範例:';
    SELECT TOP 3 
        fe.FileName as [檔案名稱],
        fe.FileHash as [Hash值]
    FROM EcoCampus_PreProduction2.dbo.FileEntry fe
    INNER JOIN EcoCampus_Maria3.dbo.sys_files_store s ON fe.FileName = s.name
    WHERE fe.FileHash IS NOT NULL
    ORDER BY fe.FileName;
END

PRINT '';
PRINT '完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';