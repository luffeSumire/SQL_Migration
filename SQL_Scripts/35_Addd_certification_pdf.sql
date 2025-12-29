-- =============================================
-- 補齊 Certifications.PdfFileId 資料
-- 說明: 修正 Certifications 表中 PdfFileId 欄位的資料遷移邏輯
--       舊系統 custom_certification.pdf_file 格式為 "id__hash"
--       需要提取 hash 部分對應 FileEntry.FileHash
-- Date: 2025-12-16
-- =============================================

USE EcoCampus_PreProduction;
GO

PRINT '========================================';
PRINT '開始修正 Certifications.PdfFileId';
PRINT '執行時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- 檢查 FileEntry 是否有 FileHash 欄位 (理論上 00_fileentry_migration.sql 已經建立)
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'FileEntry' AND COLUMN_NAME = 'FileHash')
BEGIN
    PRINT '⚠️ 警告: FileEntry 表缺少 FileHash 欄位，無法執行對應。請先執行 00_fileentry_migration.sql';
    RETURN;
END

-- 執行更新
-- 邏輯:
-- 1. 透過 CertificationId 對應舊系統 custom_certification.sid
-- 2. 解析 custom_certification.pdf_file 取得 hash (底線後面的字串)
-- 3. 透過 hash 對應 FileEntry.FileHash 取得 FileEntry.Id
-- 4. 更新 Certifications.PdfFileId

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE C
    SET PdfFileId = F.Id
    FROM Certifications C
    INNER JOIN EcoCampus_Maria3.dbo.custom_certification cc ON C.CertificationId = cc.sid
    CROSS APPLY (
        -- 提取 hash: 找到 '__' 的位置，取其後面的字串
        -- 範例: 8728572__7fb4e2f4fa5b17927cabab33baeaa112 -> 7fb4e2f4fa5b17927cabab33baeaa112
        SELECT CASE 
            WHEN CHARINDEX('__', cc.pdf_file) > 0 
            THEN SUBSTRING(cc.pdf_file, CHARINDEX('__', cc.pdf_file) + 2, LEN(cc.pdf_file))
            ELSE cc.pdf_file -- 如果沒有底線，嘗試直接用整個字串匹配
        END AS ExtractedHash
    ) AS HashData
    INNER JOIN FileEntry F ON F.FileHash = HashData.ExtractedHash
    WHERE cc.pdf_file IS NOT NULL 
      AND cc.pdf_file != ''
      AND (C.PdfFileId IS NULL OR C.PdfFileId != F.Id); -- 僅更新需要更新的記錄

    DECLARE @UpdatedCount INT = @@ROWCOUNT;

    COMMIT TRANSACTION;

    PRINT '✓ Certifications.PdfFileId 修正完成';
    PRINT '  更新筆數: ' + CAST(@UpdatedCount AS VARCHAR(10));

    -- 驗證檢查 (顯示前 5 筆更新結果)
    PRINT '--- 驗證範例 (前 5 筆) ---';
    SELECT TOP 5
        C.CertificationId, 
        cc.pdf_file AS OldPdfFile, 
        F.FileHash AS MatchedHash, 
        C.PdfFileId AS NewFileId
    FROM Certifications C
    INNER JOIN EcoCampus_Maria3.dbo.custom_certification cc ON C.CertificationId = cc.sid
    INNER JOIN FileEntry F ON C.PdfFileId = F.Id
    WHERE cc.pdf_file IS NOT NULL AND cc.pdf_file != '';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT '❌ 發生錯誤: ' + ERROR_MESSAGE();
END CATCH;
