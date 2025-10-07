-- =============================================
-- Author: GitHub Copilot
-- Description: Add IsVisible column to HomeBannerContents table
-- Date: 2025-10-03
-- =============================================

-- Add IsVisible column to HomeBannerContents table
ALTER TABLE [dbo].[HomeBannerContents] ADD [IsVisible] BIT NOT NULL DEFAULT (1) WITH VALUES;

-- Add extended property for documentation
EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'是否顯示此語系版本的橫幅內容',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'HomeBannerContents',
    @level2type = N'COLUMN',
    @level2name = N'IsVisible';
