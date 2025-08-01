-- =====================================================
-- EcoCampus 目標資料庫清理腳本
-- 功能: 清理目標資料庫中的遷移資料，準備重新執行遷移
-- 執行環境: Ecocampus_PreProduction (測試環境)
-- 建立日期: 2025-08-01
-- =====================================================

-- 設定目標環境 (測試環境)
USE Ecocampus_PreProduction;
GO

PRINT '開始清理目標資料庫...'
PRINT '目標資料庫: ' + DB_NAME()
PRINT '==============================================='

-- 停用外鍵約束檢查 (僅針對主資料表，不涉及標籤表)
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ArticleAttachments')
    ALTER TABLE ArticleAttachments NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ArticleContents')
    ALTER TABLE ArticleContents NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Articles')
    ALTER TABLE Articles NOCHECK CONSTRAINT ALL;

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DownloadAttachments')
    ALTER TABLE DownloadAttachments NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DownloadContents')
    ALTER TABLE DownloadContents NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Downloads')
    ALTER TABLE Downloads NOCHECK CONSTRAINT ALL;

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FaqContents')
    ALTER TABLE FaqContents NOCHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Faqs')
    ALTER TABLE Faqs NOCHECK CONSTRAINT ALL;
GO

-- 1. 清理 Articles 相關資料 (完全保留所有標籤相關表)
PRINT '清理 Articles 相關資料...'
DELETE FROM ArticleAttachments;
-- 不刪除 ArticleTags - 保留標籤關聯
DELETE FROM ArticleContents;
DELETE FROM Articles;
PRINT '✓ Articles 相關資料已清理 (保留所有標籤資料)'

-- 2. 清理 Downloads 相關資料 (完全保留所有標籤相關表)
PRINT '清理 Downloads 相關資料...'
DELETE FROM DownloadAttachments;
-- 不刪除 DownloadTags - 保留標籤關聯
DELETE FROM DownloadContents;
DELETE FROM Downloads;
PRINT '✓ Downloads 相關資料已清理 (保留所有標籤資料)'

-- 3. 清理 FAQ 相關資料 (完全保留所有標籤相關表)
PRINT '清理 FAQ 相關資料...'
-- 不刪除 FaqTags - 保留標籤關聯
DELETE FROM FaqContents;
DELETE FROM Faqs;
PRINT '✓ FAQ 相關資料已清理 (保留所有標籤資料)'

-- 重新啟用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ArticleAttachments')
    ALTER TABLE ArticleAttachments WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ArticleContents')
    ALTER TABLE ArticleContents WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Articles')
    ALTER TABLE Articles WITH CHECK CHECK CONSTRAINT ALL;

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DownloadAttachments')
    ALTER TABLE DownloadAttachments WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'DownloadContents')
    ALTER TABLE DownloadContents WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Downloads')
    ALTER TABLE Downloads WITH CHECK CHECK CONSTRAINT ALL;

IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FaqContents')
    ALTER TABLE FaqContents WITH CHECK CHECK CONSTRAINT ALL;
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Faqs')
    ALTER TABLE Faqs WITH CHECK CHECK CONSTRAINT ALL;
GO

-- 重置自增欄位 (如果有的話)
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Articles'))
    DBCC CHECKIDENT ('Articles', RESEED, 0);

IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Downloads'))
    DBCC CHECKIDENT ('Downloads', RESEED, 0);

IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Faqs'))
    DBCC CHECKIDENT ('Faqs', RESEED, 0);

PRINT '==============================================='
PRINT '目標資料庫清理完成!'
PRINT '現在可以重新執行遷移腳本。'
GO