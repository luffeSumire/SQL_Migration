-- =============================================
-- Migration: Add IsVisible Column to FaqContents
-- Date: 2025-09-25
-- Description: Adds IsVisible BIT column to FaqContents table for per-language visibility control
-- =============================================

-- Add IsVisible column with default value 1 (visible)
ALTER TABLE FaqContents
ADD IsVisible BIT NOT NULL DEFAULT(1) WITH VALUES;

-- Add comment for documentation
EXEC sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'控制該語系內容是否可見，1=可見，0=隱藏',
    @level0type = N'Schema', @level0name = 'dbo',
    @level1type = N'Table',  @level1name = 'FaqContents',
    @level2type = N'Column', @level2name = 'IsVisible';

PRINT 'Successfully added IsVisible column to FaqContents table.';
