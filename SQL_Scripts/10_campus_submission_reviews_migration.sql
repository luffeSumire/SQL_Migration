-- ========================================
-- 校園投稿審核歷程遷移腳本
-- 來源: EcoCampus_Maria3.custom_release_en_tw (review, release_opinion, reviewdate, passdate)
-- 目標: EcoCampus_PreProduction.CampusSubmissionReviews
-- 建立日期: 2025-08-06
-- 版本: v1.0 - 審核歷程完整遷移
-- ========================================

USE Ecocampus_PreProduction;

-- 設定 SQL 執行選項
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;

-- 記錄開始時間用於後續篩選
DECLARE @MigrationStartTime DATETIME2 = SYSDATETIME();
PRINT '========================================';
PRINT '校園投稿審核歷程遷移腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, @MigrationStartTime, 120);
PRINT '========================================';

PRINT '========================================';
PRINT '校園投稿審核歷程遷移腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, @MigrationStartTime, 120);
PRINT '========================================';

-- ========================================
-- 0. 清空 CampusSubmissionReviews 資料表
-- ========================================
PRINT '步驟 0: 清空 CampusSubmissionReviews 資料表...';

-- 停用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CampusSubmissionReviews')
    ALTER TABLE CampusSubmissionReviews NOCHECK CONSTRAINT ALL;

-- 清空資料
DELETE FROM CampusSubmissionReviews;

-- 重新啟用外鍵約束檢查
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CampusSubmissionReviews')
    ALTER TABLE CampusSubmissionReviews WITH CHECK CHECK CONSTRAINT ALL;

-- 重置自增欄位
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('CampusSubmissionReviews'))
    DBCC CHECKIDENT ('CampusSubmissionReviews', RESEED, 0);

PRINT '✓ CampusSubmissionReviews 資料表已清空';

-- ========================================
-- 1. 遷移審核歷程資料
-- ========================================
PRINT '步驟 1: 遷移校園投稿審核歷程...';

-- 建立審核狀態對應邏輯
INSERT INTO CampusSubmissionReviews (
    CampusSubmissionId,
    ReviewStatus,
    ReviewComment, 
    ReviewDate,
    ApprovedDate,
    ReviewerId,
    CreatedTime,
    CreatedUserId,
    UpdatedTime,
    UpdatedUserId,
    Status,
    SortOrder
)
SELECT 
    cs.CampusSubmissionId,
    -- 審核狀態對應：
    -- 舊系統 '審核通過' -> 新系統 1 (Approved)
    -- 舊系統 '審核失敗' -> 新系統 2 (Rejected) 
    -- 舊系統 '審核中' -> 新系統 0 (Pending)
    -- 舊系統 '尚未送審' -> 新系統 0 (Pending)
    CASE 
        WHEN cret.review LIKE N'%通過%' THEN 1  -- 審核通過
        WHEN cret.review LIKE N'%失敗%' THEN 2  -- 審核失敗
        WHEN cret.review LIKE N'%審核中%' THEN 0  -- 審核中
        WHEN cret.review LIKE N'%尚未送審%' THEN 0  -- 尚未送審
        ELSE 0  -- 預設為待審核
    END as ReviewStatus,
    COALESCE(cret.release_opinion, N'') as ReviewComment,
    -- ReviewDate: 送審日期 (reviewdate) 或 更新日期 (updatedate)
    CASE 
        WHEN cret.reviewdate IS NOT NULL AND ISNUMERIC(cret.reviewdate) = 1 AND CAST(cret.reviewdate AS BIGINT) > 0
        THEN DATEADD(SECOND, CAST(cret.reviewdate AS BIGINT), '1970-01-01')
        WHEN cret.updatedate IS NOT NULL AND ISNUMERIC(cret.updatedate) = 1 AND CAST(cret.updatedate AS BIGINT) > 0
        THEN DATEADD(SECOND, CAST(cret.updatedate AS BIGINT), '1970-01-01')
        ELSE @MigrationStartTime
    END as ReviewDate,
    -- ApprovedDate: 只有審核通過才有通過日期
    CASE 
        WHEN cret.review LIKE N'%通過%' 
             AND cret.passdate IS NOT NULL AND ISNUMERIC(cret.passdate) = 1 AND CAST(cret.passdate AS BIGINT) > 0
        THEN DATEADD(SECOND, CAST(cret.passdate AS BIGINT), '1970-01-01')
        ELSE NULL
    END as ApprovedDate,
    1 as ReviewerId, -- TODO: 需要建立審核者對應，目前設為預設管理員
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId,
    @MigrationStartTime as UpdatedTime, 
    1 as UpdatedUserId,
    1 as Status, -- 啟用狀態
    ROW_NUMBER() OVER (PARTITION BY cs.CampusSubmissionId ORDER BY cret.sid) as SortOrder
FROM CampusSubmissions cs
INNER JOIN (
    -- 建立 CampusSubmissionId 與舊系統 news.sid 的對應關係
    SELECT 
        cn.sid,
        ROW_NUMBER() OVER (ORDER BY cn.createdate, cn.sid) as RowNum
    FROM EcoCampus_Maria3.dbo.custom_news cn
    WHERE cn.lan = 'zh_tw' AND cn.type = 'release'
) cn_mapping ON cs.CampusSubmissionId = cn_mapping.RowNum
INNER JOIN EcoCampus_Maria3.dbo.custom_release_en_tw cret ON cn_mapping.sid = cret.release_tw_sid
-- 移除嚴格的時間限制，處理所有現有的校園投稿
  AND cret.review IS NOT NULL;  -- 確保有審核狀態

DECLARE @ReviewCount INT = @@ROWCOUNT;
PRINT '✓ 校園投稿審核歷程遷移完成: ' + CAST(@ReviewCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 2. 為沒有審核記錄的投稿建立預設審核狀態
-- ========================================
PRINT '步驟 2: 為沒有審核記錄的投稿建立預設審核狀態...';

-- 為沒有審核記錄的投稿新增預設狀態（基於 is_show 欄位判斷）
INSERT INTO CampusSubmissionReviews (
    CampusSubmissionId,
    ReviewStatus,
    ReviewComment,
    ReviewDate, 
    ApprovedDate,
    ReviewerId,
    CreatedTime,
    CreatedUserId,
    UpdatedTime,
    UpdatedUserId,
    Status,
    SortOrder
)
SELECT 
    cs.CampusSubmissionId,
    -- 根據 custom_news.is_show 判斷審核狀態
    CASE WHEN cn.is_show = 1 THEN 1 ELSE 0 END as ReviewStatus, -- 1=通過, 0=待審核
    N'系統遷移：根據原始顯示狀態自動設定' as ReviewComment,
    @MigrationStartTime as ReviewDate,
    CASE WHEN cn.is_show = 1 THEN @MigrationStartTime ELSE NULL END as ApprovedDate,
    1 as ReviewerId,
    @MigrationStartTime as CreatedTime,
    1 as CreatedUserId,
    @MigrationStartTime as UpdatedTime,
    1 as UpdatedUserId,
    1 as Status,
    1 as SortOrder
FROM CampusSubmissions cs
INNER JOIN (
    SELECT 
        cn.sid,
        cn.is_show,
        ROW_NUMBER() OVER (ORDER BY cn.createdate, cn.sid) as RowNum
    FROM EcoCampus_Maria3.dbo.custom_news cn
    WHERE cn.lan = 'zh_tw' AND cn.type = 'release'
) cn ON cs.CampusSubmissionId = cn.RowNum
-- 處理所有現有的校園投稿
WHERE NOT EXISTS (
      SELECT 1 FROM CampusSubmissionReviews csr 
      WHERE csr.CampusSubmissionId = cs.CampusSubmissionId
        AND csr.CreatedTime = @MigrationStartTime
  );

DECLARE @DefaultReviewCount INT = @@ROWCOUNT;
PRINT '✓ 預設審核狀態建立完成: ' + CAST(@DefaultReviewCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 3. 遷移結果統計和驗證
-- ========================================
PRINT '========================================';
PRINT '審核歷程遷移結果統計:';
PRINT '========================================';

-- 統計各種審核狀態的數量
SELECT 
    '校園投稿審核歷程統計' as [遷移項目],
    (SELECT COUNT(*) FROM CampusSubmissionReviews WHERE CreatedTime = @MigrationStartTime) as [總審核記錄],
    (SELECT COUNT(*) FROM CampusSubmissionReviews WHERE ReviewStatus = 0 AND CreatedTime = @MigrationStartTime) as [待審核],
    (SELECT COUNT(*) FROM CampusSubmissionReviews WHERE ReviewStatus = 1 AND CreatedTime = @MigrationStartTime) as [審核通過],
    (SELECT COUNT(*) FROM CampusSubmissionReviews WHERE ReviewStatus = 2 AND CreatedTime = @MigrationStartTime) as [審核失敗];

-- 顯示審核狀態分佈詳情
PRINT '審核狀態分佈詳情:';
SELECT 
    CASE ReviewStatus
        WHEN 0 THEN N'待審核 (Pending)'
        WHEN 1 THEN N'審核通過 (Approved)'  
        WHEN 2 THEN N'審核失敗 (Rejected)'
        ELSE N'未知狀態'
    END as [審核狀態],
    COUNT(*) as [記錄數量],
    COUNT(CASE WHEN ApprovedDate IS NOT NULL THEN 1 END) as [有通過日期數量]
FROM CampusSubmissionReviews 
WHERE CreatedTime = @MigrationStartTime
GROUP BY ReviewStatus
ORDER BY ReviewStatus;

-- ========================================
-- 4. 顯示遷移結果範例
-- ========================================
PRINT '審核歷程遷移結果範例 (前5筆):';

SELECT TOP 5
    csr.CampusSubmissionReviewId as [審核ID],
    cs.CampusSubmissionId as [投稿ID],
    CASE csr.ReviewStatus
        WHEN 0 THEN N'待審核'
        WHEN 1 THEN N'審核通過'  
        WHEN 2 THEN N'審核失敗'
        ELSE N'未知'
    END as [審核狀態],
    LEFT(COALESCE(csr.ReviewComment, ''), 30) + '...' as [審核意見],
    csr.ReviewDate as [審核日期],
    csr.ApprovedDate as [通過日期]
FROM CampusSubmissionReviews csr
INNER JOIN CampusSubmissions cs ON csr.CampusSubmissionId = cs.CampusSubmissionId
WHERE csr.CreatedTime = @MigrationStartTime
ORDER BY csr.CampusSubmissionReviewId;

-- ========================================
-- 5. 重要提醒和後續工作
-- ========================================
PRINT '========================================';
PRINT '⚠️  重要提醒:';
PRINT '1. ReviewerId 對應問題：目前所有審核者都設為 1（預設管理員）';
PRINT '   需要根據實際審核者資訊建立對應關係';
PRINT '2. 審核狀態對應：';
PRINT '   - 0: 待審核 (包含 "審核中" 和 "尚未送審")';
PRINT '   - 1: 審核通過';
PRINT '   - 2: 審核失敗';
PRINT '3. 日期轉換：Unix timestamp 已轉換為 datetime2 格式';
PRINT '4. 部分投稿可能沒有 custom_release_en_tw 記錄，已建立預設審核狀態';
PRINT '========================================';

-- ========================================
-- 6. 完成訊息
-- ========================================
PRINT '========================================';
PRINT '✅ 校園投稿審核歷程遷移腳本執行完成！';
PRINT '遷移統計:';
PRINT '- 審核記錄遷移: ' + CAST(@ReviewCount AS VARCHAR) + ' 筆';
PRINT '- 預設狀態建立: ' + CAST(@DefaultReviewCount AS VARCHAR) + ' 筆';
PRINT '- 總審核記錄: ' + CAST(@ReviewCount + @DefaultReviewCount AS VARCHAR) + ' 筆';
PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';