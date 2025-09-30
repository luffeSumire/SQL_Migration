-- =============================================
-- Author:      GitHub Copilot
-- Create date: 2025-09-26
-- Description: Add IsVisible column to DownloadContents table for per-language visibility control
-- =============================================

-- Add IsVisible column to DownloadContents table
ALTER TABLE [dbo].[DownloadContents]
ADD [IsVisible] BIT NOT NULL DEFAULT(1) WITH VALUES;

-- Add extended property for documentation
EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'是否顯示此語系內容 (1=顯示, 0=隱藏)',
    @level0type = N'SCHEMA', @level0name = 'dbo',
    @level1type = N'TABLE',  @level1name = 'DownloadContents',
    @level2type = N'COLUMN', @level2name = 'IsVisible';
