-- =============================================
-- Author: GitHub Copilot
-- Description: Add IsVisible column to VideoTranslations table
-- Date: 2025-10-03
-- =============================================

-- Add IsVisible column to VideoTranslations table
ALTER TABLE [dbo].[VideoTranslations] ADD [IsVisible] BIT NOT NULL DEFAULT (1) WITH VALUES;

-- Add extended property for documentation
EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'是否顯示此語系版本的影片內容',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'VideoTranslations',
    @level2type = N'COLUMN',
    @level2name = N'IsVisible';
