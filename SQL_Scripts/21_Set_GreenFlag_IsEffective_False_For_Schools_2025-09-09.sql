/*
Script 21: Set IsEffective = 0 (invalidate) Green Flag related certifications for specified schools.
Target Schools: 431,237,423,242,426
Green Flag certification family codes: GREEN_FLAG, GREEN_FLAG_R1, GREEN_FLAG_R2, GREEN_FLAG_R3
Safety:
 - Runs inside an explicit transaction
 - Writes audit trail to a temp table result set for review after update
 - Idempotent: only updates rows currently IsEffective = 1
*/

SET NOCOUNT ON;
BEGIN TRANSACTION;

BEGIN TRY
    DECLARE @TargetSchoolIds TABLE (SchoolId INT PRIMARY KEY);
    INSERT INTO @TargetSchoolIds (SchoolId)
    VALUES (431),(237),(423),(242),(426);

    -- Capture target certification type ids for Green Flag family
    ;WITH GreenFlagTypes AS (
        SELECT Id
        FROM dbo.CertificationTypes
        WHERE CertificationCode IN ('GREEN_FLAG','GREEN_FLAG_R1','GREEN_FLAG_R2','GREEN_FLAG_R3')
    )
    -- Preview affected rows
    SELECT c.CertificationId, c.SchoolId, c.Level AS CertificationTypeId, ct.CertificationCode,
           c.IsEffective AS Before_IsEffective, c.ApprovedDate
    INTO #AffectedBefore
    FROM dbo.Certifications c
    INNER JOIN GreenFlagTypes gft ON c.Level = gft.Id
    INNER JOIN dbo.CertificationTypes ct ON ct.Id = c.Level
    INNER JOIN @TargetSchoolIds t ON t.SchoolId = c.SchoolId
    WHERE c.IsEffective = 1;

    -- Perform update
    UPDATE c
        SET IsEffective = 0
    FROM dbo.Certifications c
    INNER JOIN #AffectedBefore ab ON ab.CertificationId = c.CertificationId;

    -- Show after state
    SELECT ab.*, c.IsEffective AS After_IsEffective
    FROM #AffectedBefore ab
    INNER JOIN dbo.Certifications c ON c.CertificationId = ab.CertificationId;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR('[Script21] Failed: %s', 16, 1, @ErrMsg);
END CATCH;
GO
