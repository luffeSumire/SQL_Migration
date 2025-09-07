-- Add IsVisible per-locale visibility flag to ArticleContents
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE Name = N'IsVisible' AND Object_ID = Object_ID(N'dbo.ArticleContents')
)
BEGIN
    ALTER TABLE dbo.ArticleContents
    ADD IsVisible bit NOT NULL CONSTRAINT DF_ArticleContents_IsVisible DEFAULT(1);
END
