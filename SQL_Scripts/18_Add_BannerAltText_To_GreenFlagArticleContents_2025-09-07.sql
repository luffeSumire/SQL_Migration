-- Purpose: Add BannerAltText column to support banner alt text for GreenFlag article contents
-- Notes: Run on Admin and Client databases that host GreenFlagArticleContents

BEGIN TRY
    BEGIN TRANSACTION;

    IF COL_LENGTH('dbo.GreenFlagArticleContents', 'BannerAltText') IS NULL
    BEGIN
        ALTER TABLE [dbo].[GreenFlagArticleContents]
        ADD [BannerAltText] NVARCHAR(200) NULL;
    END

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR('Failed to add BannerAltText to GreenFlagArticleContents: %s', 16, 1, @ErrMsg);
END CATCH;

-- Rollback (manual):
-- ALTER TABLE [dbo].[GreenFlagArticleContents] DROP COLUMN [BannerAltText];
