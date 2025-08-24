-- =============================================
-- 認證系統完整遷移腳本 (最終版)
-- 來源: custom_question, custom_certification, custom_certification_answer, 
--       custom_certification_answer_record, custom_certification_step_record
-- 目標: Questions, Certifications, CertificationAnswers, CertificationStepRecords
-- Date: 2025-08-15
-- =============================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
USE EcoCampus_PreProduction;

-- 確保 IsRenewed 欄位支援舊系統 -1~1 值域
-- 先刪除預設值約束，再修改欄位類型
DECLARE @ConstraintName NVARCHAR(256);
SELECT @ConstraintName = name 
FROM sys.default_constraints 
WHERE parent_object_id = OBJECT_ID('Questions') 
  AND parent_column_id = (SELECT column_id FROM sys.columns WHERE object_id = OBJECT_ID('Questions') AND name = 'IsRenewed');

IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE Questions DROP CONSTRAINT [' + @ConstraintName + ']');
    PRINT '✓ 已刪除 IsRenewed 預設值約束: ' + @ConstraintName;
END

ALTER TABLE Questions ALTER COLUMN IsRenewed INT;
PRINT '✓ IsRenewed 欄位已修改為 INT 類型，支援 -1~1 值域';

PRINT '========================================';
PRINT '認證系統遷移腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- =============================================
-- STEP 0: 清空認證系統相關資料表
-- =============================================
PRINT '=== 清空認證系統相關資料表 ===';

DELETE FROM CertificationStepRecords;
DELETE FROM CertificationAnswers;
DELETE FROM Certifications;
DELETE FROM Questions;

-- 重置自增欄位
DBCC CHECKIDENT ('Questions', RESEED, 0);
DBCC CHECKIDENT ('Certifications', RESEED, 0);
DBCC CHECKIDENT ('CertificationAnswers', RESEED, 0);
DBCC CHECKIDENT ('CertificationStepRecords', RESEED, 0);

PRINT '✓ 認證系統相關資料表已清空';

-- =============================================
-- STEP 0.5: 建立認證等級對照表
-- =============================================
PRINT '=== 建立認證等級對照表 ===';

-- 清除並重建認證等級對照表
IF OBJECT_ID('tempdb..#CertificationLevelMapping') IS NOT NULL DROP TABLE #CertificationLevelMapping;

-- 建立認證等級對照表，用於轉換舊系統level為新系統CertificationTypeId
CREATE TABLE #CertificationLevelMapping (
    [OldLevel] INT,                          -- 舊系統認證等級
    [NewCertificationTypeId] INT,           -- 新系統認證類型ID
    [Description] NVARCHAR(50)              -- 說明
);

-- 插入認證等級對照資料
INSERT INTO #CertificationLevelMapping ([OldLevel], [NewCertificationTypeId], [Description]) VALUES 
(1, 6, N'銅牌'),                          -- 1: 銅牌 -> CertificationTypeId = 6
(2, 5, N'銀牌'),                          -- 2: 銀牌 -> CertificationTypeId = 5
(3, 1, N'綠旗'),                          -- 3: 綠旗 -> CertificationTypeId = 1
(4, 2, N'綠旗R1'),                        -- 4: 綠旗R1 -> CertificationTypeId = 2
(5, 3, N'綠旗R2'),                        -- 5: 綠旗R2 -> CertificationTypeId = 3
(6, 4, N'綠旗R3');                        -- 6: 綠旗R3 -> CertificationTypeId = 4

PRINT '✓ 認證等級對照表建立完成';

-- =============================================
-- STEP 1: 遷移 Questions 表資料
-- =============================================
PRINT '=== 開始遷移 Questions 表 ===';

-- STEP 1.1: 插入父問題
PRINT '步驟 1.1: 插入父問題...';
SET IDENTITY_INSERT Questions ON;

INSERT INTO Questions (
    QuestionId, Title, ParentQuestionId, StepNumber, IsRenewed,
    CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status,
    DeletedTime, DeletedUserId, SortOrder, QuestionTemplate
)
SELECT 
    cq.sid AS QuestionId,
    COALESCE(cq.title, '') AS Title,
    NULL AS ParentQuestionId,
    cq.step AS StepNumber,
    cq.is_renew_temp AS IsRenewed,
    CASE 
        WHEN cq.createdate IS NOT NULL AND cq.createdate > 0 
        THEN DATEADD(second, cq.createdate, '1970-01-01 00:00:00')
        ELSE GETDATE()
    END AS CreatedTime,
    1 AS CreatedUserId,
    CASE 
        WHEN cq.updatedate IS NOT NULL AND cq.updatedate > 0 
        THEN DATEADD(second, cq.updatedate, '1970-01-01 00:00:00')
        ELSE NULL
    END AS UpdatedTime,
    CASE WHEN cq.updatedate IS NOT NULL AND cq.updatedate > 0 THEN 1 ELSE NULL END AS UpdatedUserId,
    CASE WHEN cq.is_use = 1 THEN 1 ELSE 0 END AS Status,
    NULL AS DeletedTime,
    NULL AS DeletedUserId,
    COALESCE(cq.sequence, 0) AS SortOrder,
    cq.question_tpl AS QuestionTemplate
FROM EcoCampus_Maria3.dbo.custom_question cq
WHERE cq.sid IS NOT NULL
    AND (cq.parent_sid = 0 OR cq.parent_sid IS NULL)
ORDER BY cq.sid;

DECLARE @ParentCount INT = @@ROWCOUNT;
PRINT '✓ 父問題插入完成: ' + CAST(@ParentCount AS VARCHAR(10)) + ' 筆';

-- STEP 1.2: 插入子問題
PRINT '步驟 1.2: 插入子問題...';

INSERT INTO Questions (
    QuestionId, Title, ParentQuestionId, StepNumber, IsRenewed,
    CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status,
    DeletedTime, DeletedUserId, SortOrder, QuestionTemplate
)
SELECT 
    cq.sid AS QuestionId,
    COALESCE(cq.title, '') AS Title,
    cq.parent_sid AS ParentQuestionId,
    cq.step AS StepNumber,
    cq.is_renew_temp AS IsRenewed,
    CASE 
        WHEN cq.createdate IS NOT NULL AND cq.createdate > 0 
        THEN DATEADD(second, cq.createdate, '1970-01-01 00:00:00')
        ELSE GETDATE()
    END AS CreatedTime,
    1 AS CreatedUserId,
    CASE 
        WHEN cq.updatedate IS NOT NULL AND cq.updatedate > 0 
        THEN DATEADD(second, cq.updatedate, '1970-01-01 00:00:00')
        ELSE NULL
    END AS UpdatedTime,
    CASE WHEN cq.updatedate IS NOT NULL AND cq.updatedate > 0 THEN 1 ELSE NULL END AS UpdatedUserId,
    CASE WHEN cq.is_use = 1 THEN 1 ELSE 0 END AS Status,
    NULL AS DeletedTime,
    NULL AS DeletedUserId,
    COALESCE(cq.sequence, 0) AS SortOrder,
    cq.question_tpl AS QuestionTemplate
FROM EcoCampus_Maria3.dbo.custom_question cq
WHERE cq.sid IS NOT NULL
    AND cq.parent_sid > 0
    AND EXISTS (SELECT 1 FROM Questions q WHERE q.QuestionId = cq.parent_sid)
ORDER BY cq.sid;

DECLARE @ChildCount INT = @@ROWCOUNT;
SET IDENTITY_INSERT Questions OFF;

PRINT '✓ 子問題插入完成: ' + CAST(@ChildCount AS VARCHAR(10)) + ' 筆';
PRINT '✓ Questions 表遷移完成: ' + CAST(@ParentCount + @ChildCount AS VARCHAR(10)) + ' 筆記錄';

-- =============================================
-- STEP 2: 遷移 Certifications 表資料
-- =============================================
PRINT '=== 開始遷移 Certifications 表 ===';

SET IDENTITY_INSERT Certifications ON;

INSERT INTO Certifications (
    CertificationId, SchoolId, Level, ReviewStatus, ReviewDate, ApprovedDate,
    RejectedDate, SupplementationDate, CertificateId, RewardHistory, PdfFileId,
    AddType, CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, Status,
    DeletedTime, DeletedUserId, SortOrder
)
SELECT 
    cc.sid AS CertificationId,
    s.Id AS SchoolId,
    CLM.NewCertificationTypeId AS Level,
    CASE cc.review
        WHEN N'通過' THEN 1
        WHEN N'待審核' THEN 0
        WHEN N'未通過' THEN 2
        WHEN N'退件中' THEN 3
        WHEN N'尚未送審' THEN 0
        ELSE 0
    END AS ReviewStatus,
    CASE WHEN cc.reviewdate IS NOT NULL AND cc.reviewdate != '' 
        THEN TRY_CONVERT(datetime2, cc.reviewdate) ELSE NULL END AS ReviewDate,
    CASE WHEN cc.passdate IS NOT NULL AND cc.passdate != '' 
        THEN TRY_CONVERT(datetime2, cc.passdate) ELSE NULL END AS ApprovedDate,
    CASE WHEN cc.returndate IS NOT NULL AND cc.returndate != '' 
        THEN TRY_CONVERT(datetime2, cc.returndate) ELSE NULL END AS RejectedDate,
    CASE WHEN cc.additionaldate IS NOT NULL AND cc.additionaldate != '' 
        THEN TRY_CONVERT(datetime2, cc.additionaldate) ELSE NULL END AS SupplementationDate,
    cc.certificate_sid AS CertificateId,
    cc.rewardhistory AS RewardHistory,
    CASE WHEN cc.pdf_file IS NOT NULL AND cc.pdf_file != '' 
        THEN (SELECT TOP 1 fe.Id FROM FileEntry fe WHERE fe.FileName = cc.pdf_file)
        ELSE NULL END AS PdfFileId,
    CASE 
        WHEN cc.add_type = 'backend' THEN 'Backend'
        WHEN cc.add_type = 'front' THEN 'Frontend'
        ELSE 'Backend'
    END AS AddType,
    CASE WHEN cc.createdate IS NOT NULL AND cc.createdate > 0 
        THEN DATEADD(second, cc.createdate, '1970-01-01 00:00:00')
        ELSE GETDATE() END AS CreatedTime,
    1 AS CreatedUserId,
    CASE WHEN cc.updatedate IS NOT NULL AND cc.updatedate > 0 
        THEN DATEADD(second, cc.updatedate, '1970-01-01 00:00:00')
        ELSE NULL END AS UpdatedTime,
    CASE WHEN cc.updatedate IS NOT NULL AND cc.updatedate > 0 THEN 1 ELSE NULL END AS UpdatedUserId,
    CASE WHEN cc.is_del = 1 THEN 0 ELSE 1 END AS Status,
    CASE WHEN cc.is_del = 1 THEN GETDATE() ELSE NULL END AS DeletedTime,
    CASE WHEN cc.is_del = 1 THEN 1 ELSE NULL END AS DeletedUserId,
    COALESCE(cc.sequence, 0) AS SortOrder
FROM EcoCampus_Maria3.dbo.custom_certification cc
INNER JOIN EcoCampus_Maria3.dbo.custom_member cm ON cc.member_sid = cm.sid
INNER JOIN Schools s ON s.SchoolCode = CASE 
    WHEN cm.sid = 812 THEN N'193665'
    WHEN cm.sid = 603 THEN N'034639'
    WHEN cm.sid = 796 THEN N'061F01'
    ELSE cm.code 
END
LEFT JOIN #CertificationLevelMapping CLM ON CLM.OldLevel = cc.level
WHERE cc.sid IS NOT NULL AND cm.member_role = 'school'
    AND CLM.NewCertificationTypeId IS NOT NULL
ORDER BY cc.sid;

DECLARE @CertCount INT = @@ROWCOUNT;
SET IDENTITY_INSERT Certifications OFF;

PRINT '✓ Certifications 表遷移完成: ' + CAST(@CertCount AS VARCHAR(10)) + ' 筆記錄';

-- =============================================
-- STEP 3: 遷移 CertificationAnswers 表資料
-- =============================================
PRINT '=== 開始遷移 CertificationAnswers 表 ===';

SET IDENTITY_INSERT CertificationAnswers ON;

INSERT INTO CertificationAnswers (
    CertificationAnswerId, CertificationId, QuestionId, AnswerText, AnswerStatus,
    SubmittedDate, ReviewedDate, ReviewedUserId, CreatedTime, CreatedUserId,
    UpdatedTime, UpdatedUserId, SortOrder
)
SELECT 
    ca.sid AS CertificationAnswerId,
    ca.certification_sid AS CertificationId,
    ca.question_sid AS QuestionId,
    COALESCE((SELECT TOP 1 car.answer_json 
              FROM EcoCampus_Maria3.dbo.custom_certification_answer_record car 
              WHERE car.certification_answer_sid = ca.sid 
              ORDER BY car.sid DESC), '') AS AnswerText,
    CASE 
        WHEN EXISTS (SELECT 1 FROM EcoCampus_Maria3.dbo.custom_certification_answer_record car2 
                    WHERE car2.certification_answer_sid = ca.sid AND car2.status = N'已審核') THEN 2
        WHEN EXISTS (SELECT 1 FROM EcoCampus_Maria3.dbo.custom_certification_answer_record car2 
                    WHERE car2.certification_answer_sid = ca.sid) THEN 1
        ELSE 0
    END AS AnswerStatus,
    CASE WHEN ca.createdate IS NOT NULL AND ca.createdate > 0 
        THEN DATEADD(second, ca.createdate, '1970-01-01 00:00:00')
        ELSE NULL END AS SubmittedDate,
    CASE WHEN EXISTS (SELECT 1 FROM EcoCampus_Maria3.dbo.custom_certification_answer_record car3 
                     WHERE car3.certification_answer_sid = ca.sid AND car3.status = N'已審核')
        THEN (SELECT TOP 1 DATEADD(second, car3.updatedate, '1970-01-01 00:00:00')
              FROM EcoCampus_Maria3.dbo.custom_certification_answer_record car3 
              WHERE car3.certification_answer_sid = ca.sid AND car3.status = N'已審核' AND car3.updatedate > 0
              ORDER BY car3.sid DESC)
        ELSE NULL END AS ReviewedDate,
    CASE WHEN EXISTS (SELECT 1 FROM EcoCampus_Maria3.dbo.custom_certification_answer_record car4 
                     WHERE car4.certification_answer_sid = ca.sid AND car4.status = N'已審核')
        THEN 1 ELSE NULL END AS ReviewedUserId,
    CASE WHEN ca.createdate IS NOT NULL AND ca.createdate > 0 
        THEN DATEADD(second, ca.createdate, '1970-01-01 00:00:00')
        ELSE GETDATE() END AS CreatedTime,
    1 AS CreatedUserId,
    CASE WHEN ca.updatedate IS NOT NULL AND ca.updatedate > 0 
        THEN DATEADD(second, ca.updatedate, '1970-01-01 00:00:00')
        ELSE NULL END AS UpdatedTime,
    CASE WHEN ca.updatedate IS NOT NULL AND ca.updatedate > 0 THEN 1 ELSE NULL END AS UpdatedUserId,
    COALESCE(ca.sequence, 0) AS SortOrder
FROM EcoCampus_Maria3.dbo.custom_certification_answer ca
WHERE ca.sid IS NOT NULL
    AND ca.certification_sid IS NOT NULL
    AND ca.question_sid IS NOT NULL
    AND EXISTS (SELECT 1 FROM Certifications c WHERE c.CertificationId = ca.certification_sid)
    AND EXISTS (SELECT 1 FROM Questions q WHERE q.QuestionId = ca.question_sid)
ORDER BY ca.sid;

DECLARE @AnswerCount INT = @@ROWCOUNT;
SET IDENTITY_INSERT CertificationAnswers OFF;

PRINT '✓ CertificationAnswers 表遷移完成: ' + CAST(@AnswerCount AS VARCHAR(10)) + ' 筆記錄';

-- =============================================
-- STEP 4: 遷移 CertificationStepRecords 表資料 (從 custom_certification_step_record)
-- =============================================
PRINT '=== 開始遷移 CertificationStepRecords 表 ===';

SET IDENTITY_INSERT CertificationStepRecords ON;

INSERT INTO CertificationStepRecords (
    CertificationStepRecordId, CertificationId, StepNumber, StepOpinion,
    CreatedTime, CreatedUserId, UpdatedTime, UpdatedUserId, SortOrder
)
SELECT 
    csr.sid AS CertificationStepRecordId,
    csr.certification_sid AS CertificationId,
    COALESCE(csr.step, 0) AS StepNumber,
    csr.step_opinion AS StepOpinion,
    CASE WHEN csr.createdate IS NOT NULL AND csr.createdate > 0 
        THEN DATEADD(second, csr.createdate, '1970-01-01 00:00:00')
        ELSE GETDATE() END AS CreatedTime,
    1 AS CreatedUserId,
    CASE WHEN csr.updatedate IS NOT NULL AND csr.updatedate > 0 
        THEN DATEADD(second, csr.updatedate, '1970-01-01 00:00:00')
        ELSE NULL END AS UpdatedTime,
    CASE WHEN csr.updatedate IS NOT NULL AND csr.updatedate > 0 THEN 1 ELSE NULL END AS UpdatedUserId,
    COALESCE(csr.sequence, 0) AS SortOrder
FROM EcoCampus_Maria3.dbo.custom_certification_step_record csr
WHERE csr.sid IS NOT NULL
    AND csr.certification_sid IS NOT NULL
    AND csr.step_opinion IS NOT NULL
    -- 確保關聯的認證存在
    AND EXISTS (SELECT 1 FROM Certifications c WHERE c.CertificationId = csr.certification_sid)
ORDER BY csr.sid;

DECLARE @StepCount INT = @@ROWCOUNT;
SET IDENTITY_INSERT CertificationStepRecords OFF;

PRINT '✓ CertificationStepRecords 表遷移完成: ' + CAST(@StepCount AS VARCHAR(10)) + ' 筆記錄';

-- =============================================
-- STEP 5: 最終統計和驗證
-- =============================================
PRINT '========================================';
PRINT '遷移結果統計:';

DECLARE @QTotal INT, @CTotal INT, @ATotal INT, @STotal INT;
SELECT @QTotal = COUNT(*) FROM Questions;
SELECT @CTotal = COUNT(*) FROM Certifications;
SELECT @ATotal = COUNT(*) FROM CertificationAnswers;
SELECT @STotal = COUNT(*) FROM CertificationStepRecords;

PRINT 'Questions: ' + CAST(@QTotal AS VARCHAR(10)) + ' 筆';
PRINT 'Certifications: ' + CAST(@CTotal AS VARCHAR(10)) + ' 筆';
PRINT 'CertificationAnswers: ' + CAST(@ATotal AS VARCHAR(10)) + ' 筆';
PRINT 'CertificationStepRecords: ' + CAST(@STotal AS VARCHAR(10)) + ' 筆';

-- 驗證外鍵關聯完整性
DECLARE @OrphanAnswers INT, @OrphanStepRecords INT;
SELECT @OrphanAnswers = COUNT(*) 
FROM CertificationAnswers ca 
LEFT JOIN Certifications c ON ca.CertificationId = c.CertificationId 
LEFT JOIN Questions q ON ca.QuestionId = q.QuestionId
WHERE c.CertificationId IS NULL OR q.QuestionId IS NULL;

SELECT @OrphanStepRecords = COUNT(*) 
FROM CertificationStepRecords csr 
LEFT JOIN Certifications c ON csr.CertificationId = c.CertificationId 
WHERE c.CertificationId IS NULL;

PRINT '孤立的 CertificationAnswers 記錄: ' + CAST(@OrphanAnswers AS VARCHAR(10));
PRINT '孤立的 CertificationStepRecords 記錄: ' + CAST(@OrphanStepRecords AS VARCHAR(10));

PRINT '========================================';
PRINT '✅ 認證系統遷移腳本執行完成！';
PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';