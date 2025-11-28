-- =============================================
-- Author: AI Assistant
-- Description: Move CitizenDigitalNumber from MemberProfiles to Accounts
-- Date: 2025-11-26
-- =============================================

-- Step 1: Add CitizenDigitalNumber column to Accounts table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Accounts]') AND name = 'CitizenDigitalNumber')
BEGIN
    ALTER TABLE [dbo].[Accounts] ADD [CitizenDigitalNumber] NVARCHAR(MAX) NULL;
    
    EXEC sp_addextendedproperty
        @name = N'MS_Description',
        @value = N'自然人憑證號碼',
        @level0type = N'SCHEMA',
        @level0name = N'dbo',
        @level1type = N'TABLE',
        @level1name = N'Accounts',
        @level2type = N'COLUMN',
        @level2name = N'CitizenDigitalNumber';
        
    PRINT 'Column [CitizenDigitalNumber] added to [Accounts] table.';
END
GO

-- Step 2: Migrate data from MemberProfiles to Accounts
-- We take the MAX(CitizenDigitalNumber) for each AccountId to handle potential duplicates across locales (though they should be identical)
UPDATE a
SET a.CitizenDigitalNumber = mp.CitizenDigitalNumber
FROM [dbo].[Accounts] a
JOIN (
    SELECT AccountId, MAX(CitizenDigitalNumber) as CitizenDigitalNumber
    FROM [dbo].[MemberProfiles]
    WHERE CitizenDigitalNumber IS NOT NULL
    GROUP BY AccountId
) mp ON a.AccountId = mp.AccountId;

PRINT 'Data migrated from [MemberProfiles] to [Accounts].';
GO

-- Step 3: Drop CitizenDigitalNumber column from MemberProfiles table
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[MemberProfiles]') AND name = 'CitizenDigitalNumber')
BEGIN
    ALTER TABLE [dbo].[MemberProfiles] DROP COLUMN [CitizenDigitalNumber];
    PRINT 'Column [CitizenDigitalNumber] dropped from [MemberProfiles] table.';
END
GO
