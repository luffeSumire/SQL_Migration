/*
Script 22: Fix CampusSubmissions SchoolId Offset Issue
Description: 修復校園投稿與校園主鍵偏移問題
Date: 2025-09-14
Author: System Migration
Target: 重新建立正確的 SchoolId 對應關聯

Issue:
- 校園投稿遷移後，部分 CampusSubmissions 的 SchoolId 對應不正確
- 原因是後續腳本對 Schools 表進行了修改，導致主鍵偏移

Solution:
- 重新建立 CampusSubmissions 與 Schools 的正確關聯
- 使用原始 custom_news.member_sid → custom_member.code → Schools.SchoolCode 的對應邏輯
- 保留所有現有的 CampusSubmissionId，只更新 SchoolId
*/

SET NOCOUNT ON;
USE EcoCampus_PreProduction;
GO

PRINT '========================================';
PRINT 'Script 22: 修復校園投稿 SchoolId 偏移問題';
PRINT '執行時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

BEGIN TRANSACTION;
BEGIN TRY

-- ========================================
-- 步驟 1: 建立修復前的備份記錄
-- ========================================
PRINT '步驟 1: 建立修復前的狀態記錄...';

-- 記錄修復前的 SchoolId 分布情況
SELECT
    '修復前 SchoolId 分布' as 統計項目,
    SchoolId,
    COUNT(*) as 投稿數量
INTO #BeforeFixStats
FROM CampusSubmissions
GROUP BY SchoolId
ORDER BY SchoolId;

-- 顯示修復前統計
SELECT * FROM #BeforeFixStats;

-- ========================================
-- 步驟 2: 建立原始資料對應表
-- ========================================
PRINT '步驟 2: 建立原始資料對應關聯...';

-- 建立校園投稿與原始 custom_news 的對應關係
IF OBJECT_ID('tempdb..#CampusSubmissionMapping') IS NOT NULL
    DROP TABLE #CampusSubmissionMapping;

CREATE TABLE #CampusSubmissionMapping (
    CampusSubmissionId INT,
    OriginalNewsId INT,
    OriginalMemberSid INT,
    OriginalSchoolCode NVARCHAR(50),
    CorrectedSchoolCode NVARCHAR(50),
    NewSchoolId INT,
    SubmissionDate DATETIME
);

-- 建立對應關係 (使用與09腳本相同的 ROW_NUMBER 邏輯)
INSERT INTO #CampusSubmissionMapping (
    CampusSubmissionId,
    OriginalNewsId,
    OriginalMemberSid,
    OriginalSchoolCode,
    CorrectedSchoolCode,
    SubmissionDate
)
SELECT
    cs.CampusSubmissionId,
    cn.sid as OriginalNewsId,
    cn.member_sid as OriginalMemberSid,
    cm.code as OriginalSchoolCode,
    -- 使用與08、11.5腳本相同的修正邏輯
    CASE
        WHEN cm.sid = 812 THEN '193665'  -- 市立大崗國小 (手動修正)
        WHEN cm.sid = 603 THEN '034639'  -- 私立惠明盲校 (手動修正)
        WHEN cm.sid = 796 THEN '061F01'  -- 臺中市北屯區廍子國民小學 (手動修正)
        ELSE cm.code
    END as CorrectedSchoolCode,
    cs.SubmissionDate
FROM CampusSubmissions cs
INNER JOIN (
    -- 使用與09腳本完全相同的排序邏輯
    SELECT
        cn.sid,
        cn.member_sid,
        ROW_NUMBER() OVER (ORDER BY COALESCE(cn.createdate, 0), cn.sid) as RowNum
    FROM EcoCampus_Maria3.dbo.custom_news cn
    WHERE cn.lan = 'zh_tw' AND cn.type = 'release'
) cn ON cs.CampusSubmissionId = cn.RowNum
-- 關聯 custom_member 取得學校代碼
LEFT JOIN EcoCampus_Maria3.dbo.custom_member cm ON cn.member_sid = cm.sid AND cm.member_role = 'school';

-- 更新 NewSchoolId
UPDATE csm
SET NewSchoolId = COALESCE(s.Id, 1)  -- 找不到對應學校則預設為第一個有效學校ID
FROM #CampusSubmissionMapping csm
LEFT JOIN Schools s ON s.SchoolCode = csm.CorrectedSchoolCode;

DECLARE @MappingCount INT = (SELECT COUNT(*) FROM #CampusSubmissionMapping);
PRINT '✓ 對應關係建立完成，共 ' + CAST(@MappingCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 步驟 3: 顯示修復預覽
-- ========================================
PRINT '步驟 3: 修復預覽...';

-- 顯示需要修復的記錄統計
SELECT
    '需要修復的記錄統計' as 統計項目,
    COUNT(*) as 總記錄數,
    COUNT(CASE WHEN cs.SchoolId != csm.NewSchoolId THEN 1 END) as 需要修復數量,
    COUNT(CASE WHEN cs.SchoolId = csm.NewSchoolId THEN 1 END) as 已正確數量,
    COUNT(CASE WHEN csm.NewSchoolId = 1 THEN 1 END) as 使用預設學校數量
FROM CampusSubmissions cs
INNER JOIN #CampusSubmissionMapping csm ON cs.CampusSubmissionId = csm.CampusSubmissionId;

-- 顯示修復範例 (前10筆需要修復的記錄)
PRINT '修復範例 (前10筆需要修復的記錄):';
SELECT TOP 10
    cs.CampusSubmissionId as [投稿ID],
    cs.SchoolId as [當前SchoolId],
    csm.NewSchoolId as [修復後SchoolId],
    sc_old.Name as [當前學校名稱],
    sc_new.Name as [修復後學校名稱],
    csm.OriginalSchoolCode as [原始學校代碼],
    csm.CorrectedSchoolCode as [修正後學校代碼],
    cs.SubmissionDate as [投稿日期]
FROM CampusSubmissions cs
INNER JOIN #CampusSubmissionMapping csm ON cs.CampusSubmissionId = csm.CampusSubmissionId
LEFT JOIN Schools s_old ON cs.SchoolId = s_old.Id
LEFT JOIN SchoolContents sc_old ON s_old.Id = sc_old.SchoolId AND sc_old.LocaleCode = 'zh-TW'
LEFT JOIN Schools s_new ON csm.NewSchoolId = s_new.Id
LEFT JOIN SchoolContents sc_new ON s_new.Id = sc_new.SchoolId AND sc_new.LocaleCode = 'zh-TW'
WHERE cs.SchoolId != csm.NewSchoolId
ORDER BY cs.CampusSubmissionId;

-- ========================================
-- 步驟 4: 執行修復
-- ========================================
PRINT '步驟 4: 執行 SchoolId 修復...';

-- 更新 CampusSubmissions 的 SchoolId
UPDATE cs
SET
    SchoolId = csm.NewSchoolId,
    UpdatedTime = SYSDATETIME(),
    UpdatedUserId = 1  -- 系統自動修復
FROM CampusSubmissions cs
INNER JOIN #CampusSubmissionMapping csm ON cs.CampusSubmissionId = csm.CampusSubmissionId
WHERE cs.SchoolId != csm.NewSchoolId;

DECLARE @UpdatedCount INT = @@ROWCOUNT;
PRINT '✓ 已修復 CampusSubmissions.SchoolId: ' + CAST(@UpdatedCount AS VARCHAR) + ' 筆記錄';

-- ========================================
-- 步驟 5: 修復結果驗證
-- ========================================
PRINT '步驟 5: 修復結果驗證...';

-- 記錄修復後的 SchoolId 分布情況
SELECT
    '修復後 SchoolId 分布' as 統計項目,
    SchoolId,
    COUNT(*) as 投稿數量
INTO #AfterFixStats
FROM CampusSubmissions
GROUP BY SchoolId
ORDER BY SchoolId;

-- 對比修復前後的變化
PRINT '修復前後 SchoolId 分布對比:';
SELECT
    COALESCE(b.SchoolId, a.SchoolId) as SchoolId,
    COALESCE(b.投稿數量, 0) as 修復前數量,
    COALESCE(a.投稿數量, 0) as 修復後數量,
    COALESCE(a.投稿數量, 0) - COALESCE(b.投稿數量, 0) as 變化量
FROM #AfterFixStats a
FULL OUTER JOIN #BeforeFixStats b ON a.SchoolId = b.SchoolId
ORDER BY COALESCE(b.SchoolId, a.SchoolId);

-- 驗證修復結果範例
PRINT '修復結果驗證 (前5筆):';
SELECT TOP 5
    cs.CampusSubmissionId as [投稿ID],
    cs.SchoolId as [SchoolId],
    sc.Name as [學校名稱],
    csc.Title as [投稿標題],
    cs.SubmissionDate as [投稿日期],
    CASE
        WHEN csm.OriginalSchoolCode = s.SchoolCode THEN '✓ 正確'
        WHEN csm.CorrectedSchoolCode = s.SchoolCode THEN '✓ 已修正'
        ELSE '⚠ 需檢查'
    END as [對應狀態]
FROM CampusSubmissions cs
INNER JOIN #CampusSubmissionMapping csm ON cs.CampusSubmissionId = csm.CampusSubmissionId
LEFT JOIN Schools s ON cs.SchoolId = s.Id
LEFT JOIN SchoolContents sc ON s.Id = sc.SchoolId AND sc.LocaleCode = 'zh-TW'
LEFT JOIN CampusSubmissionContents csc ON cs.CampusSubmissionId = csc.CampusSubmissionId AND csc.LocaleCode = 'zh-TW'
ORDER BY cs.CampusSubmissionId;

-- ========================================
-- 步驟 6: 最終統計報告
-- ========================================
PRINT '========================================';
PRINT '修復完成統計報告:';

DECLARE @TotalSubmissions INT = (SELECT COUNT(*) FROM CampusSubmissions);
DECLARE @DefaultSchoolCount INT = (SELECT COUNT(*) FROM CampusSubmissions WHERE SchoolId = 1);
DECLARE @MappedSchoolCount INT = (SELECT COUNT(*) FROM CampusSubmissions WHERE SchoolId > 1);

PRINT '- 總校園投稿數: ' + CAST(@TotalSubmissions AS VARCHAR);
PRINT '- 本次修復數量: ' + CAST(@UpdatedCount AS VARCHAR);
PRINT '- 使用預設學校(ID=1): ' + CAST(@DefaultSchoolCount AS VARCHAR);
PRINT '- 成功對應到具體學校: ' + CAST(@MappedSchoolCount AS VARCHAR);

-- 檢查是否還有異常情況
DECLARE @AnomalousCount INT = (
    SELECT COUNT(*)
    FROM CampusSubmissions cs
    LEFT JOIN Schools s ON cs.SchoolId = s.Id
    WHERE s.Id IS NULL
);

IF @AnomalousCount > 0
BEGIN
    PRINT '⚠️ 發現異常: ' + CAST(@AnomalousCount AS VARCHAR) + ' 筆投稿的 SchoolId 在 Schools 表中不存在';
END
ELSE
BEGIN
    PRINT '✅ 所有投稿的 SchoolId 都能正確對應到 Schools 表';
END

PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- 清理臨時表
DROP TABLE #BeforeFixStats;
DROP TABLE #AfterFixStats;
DROP TABLE #CampusSubmissionMapping;

COMMIT TRANSACTION;
PRINT '✅ Script 22: 校園投稿 SchoolId 偏移修復完成！';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrLine INT = ERROR_LINE();

    PRINT '❌ Script 22 執行失敗:';
    PRINT '錯誤訊息: ' + @ErrMsg;
    PRINT '錯誤行號: ' + CAST(@ErrLine AS VARCHAR);

    -- 清理可能存在的臨時表
    IF OBJECT_ID('tempdb..#BeforeFixStats') IS NOT NULL DROP TABLE #BeforeFixStats;
    IF OBJECT_ID('tempdb..#AfterFixStats') IS NOT NULL DROP TABLE #AfterFixStats;
    IF OBJECT_ID('tempdb..#CampusSubmissionMapping') IS NOT NULL DROP TABLE #CampusSubmissionMapping;

    RAISERROR('[Script 22] 校園投稿 SchoolId 修復失敗: %s', 16, 1, @ErrMsg);
END CATCH;
GO