-- =====================================================
-- EcoCampus 遷移結果驗證腳本
-- 功能: 驗證遷移後的資料完整性和正確性
-- 執行環境: Ecocampus_PreProduction (測試環境)
-- 建立日期: 2025-08-01
-- =====================================================

-- 設定目標環境 (測試環境)
USE Ecocampus_PreProduction;
GO

PRINT '開始驗證遷移結果...'
PRINT '目標資料庫: ' + DB_NAME()
PRINT '==============================================='

-- 1. 驗證 FAQ 遷移結果
PRINT '1. 驗證 FAQ 遷移結果'
PRINT '-------------------'

DECLARE @FaqCount INT, @FaqContentCount INT
SELECT @FaqCount = COUNT(*) FROM Faqs
SELECT @FaqContentCount = COUNT(*) FROM FaqContents

PRINT 'FAQ 主表記錄數: ' + CAST(@FaqCount AS VARCHAR(10)) + ' (預期: 41)'
PRINT 'FAQ 內容記錄數: ' + CAST(@FaqContentCount AS VARCHAR(10)) + ' (預期: 82, 中英文各41)'

IF @FaqCount = 41 AND @FaqContentCount = 82
    PRINT '✓ FAQ 遷移驗證通過'
ELSE
    PRINT '❌ FAQ 遷移驗證失敗'

PRINT ''

-- 2. 驗證 Downloads 遷移結果  
PRINT '2. 驗證 Downloads 遷移結果'
PRINT '------------------------'

DECLARE @DownloadCount INT, @DownloadContentCount INT, @DownloadAttachCount INT
SELECT @DownloadCount = COUNT(*) FROM Downloads
SELECT @DownloadContentCount = COUNT(*) FROM DownloadContents
SELECT @DownloadAttachCount = COUNT(*) FROM DownloadAttachments

PRINT 'Downloads 主表記錄數: ' + CAST(@DownloadCount AS VARCHAR(10)) + ' (預期: 34)'
PRINT 'Downloads 內容記錄數: ' + CAST(@DownloadContentCount AS VARCHAR(10)) + ' (預期: 68, 中英文各34)'
PRINT 'Downloads 附件記錄數: ' + CAST(@DownloadAttachCount AS VARCHAR(10)) + ' (預期: 94)'

IF @DownloadCount = 34 AND @DownloadContentCount = 68 AND @DownloadAttachCount = 94
    PRINT '✓ Downloads 遷移驗證通過'
ELSE
    PRINT '❌ Downloads 遷移驗證失敗'

PRINT ''

-- 3. 驗證 Articles 遷移結果
PRINT '3. 驗證 Articles 遷移結果'
PRINT '------------------------'

DECLARE @ArticleCount INT, @ArticleContentCount INT
SELECT @ArticleCount = COUNT(*) FROM Articles
SELECT @ArticleContentCount = COUNT(*) FROM ArticleContents

PRINT 'Articles 主表記錄數: ' + CAST(@ArticleCount AS VARCHAR(10)) + ' (預期: ~1425)'
PRINT 'Articles 內容記錄數: ' + CAST(@ArticleContentCount AS VARCHAR(10)) + ' (預期: ~2850, 中英文各1425)'

IF @ArticleCount >= 1400 AND @ArticleContentCount >= 2800
    PRINT '✓ Articles 遷移驗證通過'
ELSE
    PRINT '❌ Articles 遷移驗證失敗'

PRINT ''

-- 4. 詳細資料抽樣檢查
PRINT '4. 資料抽樣檢查'
PRINT '---------------'

PRINT 'FAQ 範例資料:'
SELECT TOP 2 Id, IsEnabled, CreatedAt FROM Faqs ORDER BY Id
SELECT TOP 2 FaqId, LanguageCode, Question, Answer FROM FaqContents ORDER BY FaqId

PRINT ''
PRINT 'Downloads 範例資料:'
SELECT TOP 2 Id, IsEnabled, CreatedAt FROM Downloads ORDER BY Id
SELECT TOP 2 DownloadId, LanguageCode, Title FROM DownloadContents ORDER BY DownloadId

PRINT ''
PRINT 'Articles 範例資料:'
SELECT TOP 2 Id, IsEnabled, CreatedAt FROM Articles ORDER BY Id
SELECT TOP 2 ArticleId, LanguageCode, Title FROM ArticleContents ORDER BY ArticleId

PRINT '==============================================='
PRINT '遷移結果驗證完成!'
PRINT ''
PRINT '如果所有項目都顯示 ✓ 則遷移成功'
PRINT '如果有項目顯示 ❌ 請檢查遷移腳本並重新執行'
GO