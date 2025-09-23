/*
    Purpose: Add per-language visibility control to CampusSubmissionContents
    - Adds [IsVisible] BIT NOT NULL with default 1
    - Backfills existing rows to 1
    - Idempotent: checks existence before altering

    Run order: after deploying API changes. Safe to run multiple times.
*/

IF NOT EXISTS (
    SELECT 1
    FROM sys.columns c
    JOIN sys.objects o ON o.object_id = c.object_id AND o.type = 'U'
    WHERE o.name = 'CampusSubmissionContents' AND c.name = 'IsVisible'
)
BEGIN
    PRINT 'Adding column [IsVisible] to [dbo].[CampusSubmissionContents]...';
    ALTER TABLE [dbo].[CampusSubmissionContents]
    ADD [IsVisible] BIT NOT NULL CONSTRAINT DF_CampusSubmissionContents_IsVisible DEFAULT (1) WITH VALUES;

    PRINT 'Column [IsVisible] added with default(1).';
END
ELSE
BEGIN
    PRINT 'Column [IsVisible] already exists. Skipping.';
END
