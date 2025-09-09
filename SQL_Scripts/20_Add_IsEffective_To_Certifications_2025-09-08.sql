/*
Add IsEffective bit column to Certifications to track current validity of a certification.
- Default to 1 (effective)
- Backfill existing rows to 1
- Add index to support common queries (SchoolId + ReviewStatus + Status + IsEffective)
*/

IF COL_LENGTH('dbo.Certifications', 'IsEffective') IS NULL
BEGIN
    ALTER TABLE dbo.Certifications ADD IsEffective BIT NOT NULL CONSTRAINT DF_Certifications_IsEffective DEFAULT(1);
END
GO

/* Ensure all existing records are set to effective initially */
UPDATE dbo.Certifications SET IsEffective = 1 WHERE IsEffective IS NULL;
GO

/* Optional: filtered or composite index to speed up lookups */
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = 'IX_Certifications_School_Review_Status_Effective' AND object_id = OBJECT_ID('dbo.Certifications')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Certifications_School_Review_Status_Effective
    ON dbo.Certifications (SchoolId, ReviewStatus, Status, IsEffective)
    INCLUDE (CertificationId, ApprovedDate, Level, CreatedTime);
END
GO
