/*
		目的：因先前遷移以中文遞補英文內容，現改為偵測「中英文標題相同」的情況，
			  將英文（'en'）內容的 IsVisible 設為 0（關閉顯示）。

		規則：
		      - 條件：同一筆 CampusSubmissionId 下，英文（LocaleCode = 'en'）的 Title
			      與對應中文（LocaleCode LIKE 'zh%'）的 Title 完全相同（區分大小寫依資料庫排序規則）
		      - 符合以上條件者，將英文的 IsVisible 設為 0

		安全性：
			- 先檢查資料表是否已有 IsVisible 欄位，若無則停止並提示
			- 提供乾跑（Dry Run）查詢（已註解），可先預覽受影響的資料

		建議執行順序：
			1. 先執行新增欄位腳本：26_Add_IsVisible_To_CampusSubmissionContents_2025-09-22.sql
			2. 再執行本腳本
*/

SET NOCOUNT ON;

IF NOT EXISTS (
		SELECT 1
		FROM sys.columns c
		JOIN sys.objects o ON o.object_id = c.object_id AND o.type = 'U'
		WHERE o.name = 'CampusSubmissionContents' AND c.name = 'IsVisible'
)
BEGIN
		RAISERROR(N'[CampusSubmissionContents] 尚未新增 [IsVisible] 欄位，請先執行新增欄位腳本。', 16, 1);
		RETURN;
END

-- 乾跑（預覽受影響資料）：取消下列註解可先查詢
-- SELECT en.Id AS EnId, en.CampusSubmissionId, en.Title AS EnTitle, zh.Title AS ZhTitle, en.IsVisible
-- FROM dbo.CampusSubmissionContents AS en WITH (NOLOCK)
-- JOIN dbo.CampusSubmissionContents AS zh WITH (NOLOCK)
--   ON zh.CampusSubmissionId = en.CampusSubmissionId
--  AND zh.LocaleCode LIKE 'zh%'
-- WHERE en.LocaleCode = 'en'
--   AND en.Title = zh.Title;

DECLARE @Affected INT = 0;

UPDATE en
SET en.IsVisible = 0
FROM dbo.CampusSubmissionContents AS en
JOIN dbo.CampusSubmissionContents AS zh
	ON zh.CampusSubmissionId = en.CampusSubmissionId
 AND zh.LocaleCode LIKE 'zh%'
WHERE en.LocaleCode = 'en'
	AND en.Title = zh.Title;

SET @Affected = @@ROWCOUNT;

PRINT CONCAT(N'已將「中英文標題相同」之英文內容設為不顯示（IsVisible = 0），筆數：', @Affected);

