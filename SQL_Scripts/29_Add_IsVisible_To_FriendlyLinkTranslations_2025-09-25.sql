-- =============================================
-- Migration: Add IsVisible To FriendlyLinkTranslations
-- Date: 2025-09-25
-- Description: Add IsVisible column to FriendlyLinkTranslations table for per-language visibility control
-- =============================================

-- Add IsVisible column with default value of 1 (visible)
ALTER TABLE [dbo].[FriendlyLinkTranslations]
ADD [IsVisible] BIT NOT NULL DEFAULT (1) WITH VALUES
GO

-- Add comment to the column
EXEC sp_addextendedproperty
@name = N'MS_Description',
@value = N'是否顯示此語系內容 (1=顯示, 0=隱藏)',
@level0type = N'SCHEMA', @level0name = 'dbo',
@level1type = N'TABLE',  @level1name = 'FriendlyLinkTranslations',
@level2type = N'COLUMN', @level2name = 'IsVisible'
GO

PRINT 'Successfully added IsVisible column to FriendlyLinkTranslations table'
GO
