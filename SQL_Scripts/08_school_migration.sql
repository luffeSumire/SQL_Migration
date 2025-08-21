-- ========================================
-- 學校資料遷移腳本 (School Migration Script)
-- ========================================
-- 此腳本用於將舊系統的學校資料遷移到新系統中
-- 包含學校基本資料、認證狀態、環境教育路徑等資訊的轉換

USE Ecocampus_PreProduction;

DECLARE @MigrationStartTime DATETIME2 = SYSDATETIME();
PRINT '========================================';
PRINT '學校資料遷移腳本開始執行';
PRINT '執行時間: ' + CONVERT(VARCHAR, @MigrationStartTime, 120);
PRINT '========================================';

-- ========================================
-- 第一部分：清除目標資料表中的相關資料
-- ========================================
-- 注意：由於外鍵約束，必須按照正確的順序清除資料
-- 先清除依賴表，再清除主表

PRINT '步驟 0: 清除 Schools 相關資料表...';

-- 清空accounts表中的schoolid欄位（避免外鍵約束問題）
UPDATE [Ecocampus_PreProduction].[dbo].[Accounts] SET SchoolId = NULL WHERE SchoolId IS NOT NULL
PRINT '✓ 已清空 Accounts.SchoolId 筆數: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- 清除所有依賴Schools表的資料表（按依賴順序）
DELETE FROM [Ecocampus_PreProduction].[dbo].[CampusSubmissions]            -- 校園申請資料
PRINT ' - 已刪除 CampusSubmissions: ' + CAST(@@ROWCOUNT AS VARCHAR);
DELETE FROM [Ecocampus_PreProduction].[dbo].[SchoolStatistics]             -- 學校統計資料
PRINT ' - 已刪除 SchoolStatistics: ' + CAST(@@ROWCOUNT AS VARCHAR);
DELETE FROM [Ecocampus_PreProduction].[dbo].[SchoolPrincipals]             -- 學校校長資料
PRINT ' - 已刪除 SchoolPrincipals: ' + CAST(@@ROWCOUNT AS VARCHAR);
DELETE FROM [Ecocampus_PreProduction].[dbo].[SchoolEnvironmentalPathStatuses]  -- 學校環境路徑狀態
PRINT ' - 已刪除 SchoolEnvironmentalPathStatuses: ' + CAST(@@ROWCOUNT AS VARCHAR);
DELETE FROM [Ecocampus_PreProduction].[dbo].[SchoolContacts]               -- 學校聯絡人資料
PRINT ' - 已刪除 SchoolContacts: ' + CAST(@@ROWCOUNT AS VARCHAR);
DELETE FROM [Ecocampus_PreProduction].[dbo].[SchoolContents]               -- 學校多語系內容
PRINT ' - 已刪除 SchoolContents: ' + CAST(@@ROWCOUNT AS VARCHAR);
DELETE FROM [Ecocampus_PreProduction].[dbo].[Certifications]               -- 認證資料
PRINT ' - 已刪除 Certifications: ' + CAST(@@ROWCOUNT AS VARCHAR);
DELETE FROM [Ecocampus_PreProduction].[dbo].[Schools]                      -- 學校主表（最後清除）
PRINT ' - 已刪除 Schools: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- ========================================
-- 第二部分：建立臨時資料表和對照表
-- ========================================

-- 清除並重建學校資料臨時表
DROP TABLE #SchoolData 
GO

-- 建立學校主要資料的臨時表，用於存放從舊系統提取的學校資訊
CREATE TABLE #SchoolData (
    [OriginalSchoolId] BIGINT,               -- 原系統學校ID
    [SchoolTypeName] NVARCHAR(50),           -- 學校類型名稱
    [SchoolCode] NVARCHAR(50),               -- 學校代碼
    [SchoolName] NVARCHAR(200),              -- 學校中文名稱
    [SchoolEnName] NVARCHAR(200),            -- 學校英文名稱
	[SchoolIntroduction] NVARCHAR(MAX),      -- 學校介紹
    [CityOriginalId] BIGINT,                 -- 原縣市ID
    [CityName] NVARCHAR(50),                 -- 縣市名稱
    [AreaOriginalId] BIGINT,                 -- 原區域ID
    [AreaName] NVARCHAR(50),                 -- 區域名稱
    [CertLevel] TINYINT,                     -- 認證等級
    [CertPassDateTime] DATETIME,             -- 認證通過日期
    [CertReviewDateTime] DATETIME,           -- 認證審核日期
    [CertReturnDateTime] DATETIME,           -- 認證退件日期
	[CertSupplementationDateTime] DATETIME,  -- 認證補件日期
	[CertAddType] VARCHAR(20),               -- 認證新增類型
	[CertReviewText] NVARCHAR(20),           -- 認證審核狀態文字
	[CertIsDelete] BIT,                      -- 認證是否刪除
    [HasTrafficPath] BIT,                    -- 是否有交通教育路徑
    [HasEnergyPath] BIT,                     -- 是否有能源教育路徑
    [HasWaterPath] BIT,                      -- 是否有水資源教育路徑
    [HasWeatherPath] BIT,                    -- 是否有氣候教育路徑
    [HasSchoolHabitatPath] BIT,              -- 是否有校園棲地路徑
    [HasWastePath] BIT,                      -- 是否有廢棄物教育路徑
    [HasHealthLifePath] BIT,                 -- 是否有健康生活路徑
    [HasHealthSchoolPath] BIT,               -- 是否有健康校園路徑
    [HasBiologicalPath] BIT,                 -- 是否有生物多樣性路徑
    [HasFoodPath] BIT,                       -- 是否有綠色飲食路徑
    [HasForestPath] BIT,                     -- 是否有森林教育路徑
    [HasSeaProtectionPath] BIT,              -- 是否有海洋教育路徑
	[IsExchangeSchool] BIT,                  -- 是否為交換學校
	[IsInternalTest] BIT,                    -- 是否為內部測試學校
	[IsDeleted] BIT,                         -- 是否刪除 (is_del)
	[IsUse] BIT,                             -- 是否使用 (is_use)
	[LogoFileName] NVARCHAR(255)             -- 校徽檔案名稱
)

-- 清除並重建審核狀態對照表
DROP TABLE #ReviewStatusMapping
GO

-- 建立審核狀態對照表，用於轉換審核狀態文字為數字代碼
CREATE TABLE #ReviewStatusMapping (
	[Status] INT,                           -- 狀態代碼
	[Text] NVARCHAR(10)                     -- 狀態文字
)

-- 插入審核狀態對照資料
INSERT INTO #ReviewStatusMapping ([Status], [Text]) VALUES 
(0, '審核中'),                           -- 0: 審核中
(1, '通過'),                             -- 1: 通過
(2, '退件'),                             -- 2: 退件
(3, '補件'),                             -- 3: 補件
(4, '尚未審核')                          -- 4: 尚未審核

-- 清除並重建環境教育路徑對照表
DROP TABLE #EnviromentMapping
GO

-- 建立環境教育路徑對照表，用於轉換路徑名稱為ID
CREATE TABLE #EnviromentMapping (
	[EnvId] INT,                            -- 環境路徑ID
	[Text] NVARCHAR(50)                     -- 路徑欄位名稱
)

-- 插入環境教育路徑對照資料
INSERT INTO #EnviromentMapping ([EnvId], [Text]) VALUES 
(1, 'HasTrafficPath'),                   -- 1: 交通教育路徑
(2, 'HasEnergyPath'),                    -- 2: 能源教育路徑
(3, 'HasWaterPath'),                     -- 3: 水資源教育路徑
(4, 'HasWeatherPath'),                   -- 4: 氣候教育路徑
(5, 'HasSchoolHabitatPath'),             -- 5: 校園棲地路徑
(6, 'HasWastePath'),                     -- 6: 廢棄物教育路徑
(7, 'HasHealthLifePath'),                -- 7: 健康生活路徑
(8, 'HasHealthSchoolPath'),              -- 8: 健康校園路徑
(9, 'HasBiologicalPath'),                -- 9: 生物多樣性路徑
(10, 'HasFoodPath'),                     -- 10: 綠色飲食路徑
(11, 'HasForestPath'),                   -- 11: 森林教育路徑
(12, 'HasSeaProtectionPath')             -- 12: 海洋教育路徑


-- 清除並重建學校類型對照表
DROP TABLE #SchoolTypeMapping
GO

-- 建立學校類型對照表，用於轉換學校類型名稱為ID
CREATE TABLE #SchoolTypeMapping (
	[Type] INT,                             -- 學校類型ID
	[Text] NVARCHAR(50)                     -- 學校類型文字
)

-- 插入學校類型對照資料
INSERT INTO #SchoolTypeMapping ([Type], [Text]) VALUES 
(1, ''),                                 -- 1: 一般學校（空字串）
(1, 'general'),                          -- 1: 一般學校
(2, 'remote'),                           -- 2: 偏遠學校
(3, 'particularly'),                     -- 3: 特殊學校
(4, 'extremely_biased')                  -- 4: 極偏遠學校

-- 清除並重建認證等級對照表
DROP TABLE #CertificationLevelMapping
GO

-- 建立認證等級對照表，用於轉換舊系統level為新系統CertificationTypeId
CREATE TABLE #CertificationLevelMapping (
	[OldLevel] INT,                          -- 舊系統認證等級
	[NewCertificationTypeId] INT,           -- 新系統認證類型ID
	[Description] NVARCHAR(50)              -- 說明
)

-- 插入認證等級對照資料
INSERT INTO #CertificationLevelMapping ([OldLevel], [NewCertificationTypeId], [Description]) VALUES 
(1, 6, '銅牌'),                          -- 1: 銅牌 -> CertificationTypeId = 6
(2, 5, '銀牌'),                          -- 2: 銀牌 -> CertificationTypeId = 5
(3, 1, '綠旗'),                          -- 3: 綠旗 -> CertificationTypeId = 1
(4, 2, '綠旗R1'),                        -- 4: 綠旗R1 -> CertificationTypeId = 2
(5, 3, '綠旗R2'),                        -- 5: 綠旗R2 -> CertificationTypeId = 3
(6, 4, '綠旗R3')                         -- 6: 綠旗R3 -> CertificationTypeId = 4

-- 初始化統計變數（放在最後一個 GO 之後，避免批次重置）
DECLARE 
	@SchoolsInserted INT = 0,
	@SchoolContentsInserted INT = 0,
	@CertificationsInserted INT = 0,
	@EnvPathStatusesInserted INT = 0;

INSERT INTO #SchoolData
SELECT
    CM.[sid],
    CM.[area_attributes],
    ISNULL(CM.[code], ''),               -- 學校代碼（NULL值用空字串替換） 
    ISNULL(CM.[member_cname], ''),       -- 學校中文名稱（NULL值用空字串替換） 
    ISNULL(CM.[member_cname_en], ''),    -- 學校英文名稱（NULL值用空字串替換） 
	ISNULL(CM.[member_Introduction], ''), -- 學校介紹（NULL值用空字串替換）
    CM.[city_sid], 
    SC1.[area_name] AS [CityName], 
    CM.[area_sid],
    SC2.[area_name] AS [AreaName], 
    CC.[level],
    CC.[passdate], 
    CC.[reviewdate], 
    CC.[returndate], 
	CC.[additionaldate],
	CC.[add_type],
	CC.[review], 
	CC.[is_del], 
    CMP.[traffic] AS [HasTrafficPath], 
    CMP.[energy] AS [HasEnergyPath], 
    CMP.[water] AS [HasWaterPath], 
    CMP.[weather] AS [HasWeatherPath], 
    CMP.[habitat] AS [HasSchoolHabitatPath], 
    CMP.[consume] AS [HasWastePath], 
    CMP.[life] AS [HasHealthLifePath], 
    CMP.[school] AS [HasHealthSchoolPath], 
    CMP.[biological] AS [HasBiologicalPath], 
    CMP.[food] AS [HasFoodPath], 
    CMP.[forest] AS [HasForestPath], 
    CMP.[protection] AS [HasSeaProtectionPath], 
	CM.[member_exchange], 
	CM.[is_internal],
	CM.[is_del],
	CM.[isuse],
	CM.[member_photo]
FROM [EcoCampus_Maria3].[dbo].[custom_member] CM
LEFT JOIN [EcoCampus_Maria3].[dbo].[sys_cityarea] SC1 ON
    SC1.[sid] = CM.[city_sid]
LEFT JOIN [EcoCampus_Maria3].[dbo].[sys_cityarea] SC2 ON
    SC2.[sid] = CM.[area_sid]
LEFT JOIN [EcoCampus_Maria3].[dbo].[custom_certification] CC ON 
    CC.[member_sid] = CM.[sid]
LEFT JOIN [EcoCampus_Maria3].[dbo].[custom_member_path] CMP ON
    CMP.[member_sid] = CM.[sid]
WHERE 
	CM.[member_role] = 'school' 
	AND CM.sid not in  (732)

-- 修正特定學校的學校代碼（為解決資料不一致的問題）
UPDATE #SchoolData SET SchoolCode = '193665' WHERE OriginalSchoolId = 812 -- 修正市立大崗國小的學校代碼
UPDATE #SchoolData SET SchoolCode = '034639' WHERE OriginalSchoolId = 603 -- 修正私立惠明盲校的學校代碼
UPDATE #SchoolData SET SchoolCode = '061F01' WHERE OriginalSchoolId = 796 -- 修正臺中市北屯區廍子國民小學的學校代碼

-- ========================================
-- 第四部分：遷移學校主表資料
-- ========================================

-- 將處理好的學校資料插入新系統的Schools表中
INSERT INTO Schools(
    SchoolCode,                          -- 學校代碼
    CountyId,                            -- 縣市ID
    DistrictId,                          -- 區域ID
    SchoolTypeId,                        -- 學校類型ID
    IsExchangeSchool,                    -- 是否為交換學校
    IsInternalTest,                      -- 是否為內部測試學校
    SortOrder,                           -- 排序順序
    CreatedTime,                         -- 建立時間
    CreatedUserId,                       -- 建立者ID
    Status                               -- 狀態
)
SELECT 
    G.[SchoolCode],                      -- 學校代碼
    CT.[CountyId],                       -- 縣市ID（從翻譯表取得）
    1 AS DistrictId,                     -- 區域ID（目前固定為1）
    STM.[Type] AS [SchoolTypeId],        -- 學校類型ID（從對照表取得）
    ISNULL(G.[IsExchangeSchool], 0),     -- 是否為交換學校（預設為0）
    G.[IsInternalTest],                  -- 是否為內部測試學校
    0 AS SortOrder,                      -- 排序順序（預設為0）
    SYSUTCDATETIME() AS CreatedTime,     -- 建立時間（目前時間）
    1 AS CreatedUserId,                  -- 建立者ID（預設為1）
    CASE 
        WHEN G.[IsDeleted] = 1 OR G.[IsInternalTest] = 1 THEN 0  -- 軟刪除：is_del=1 或 is_internal=1
        WHEN G.[IsUse] = 1 THEN 1        -- 啟用：is_use=1
        ELSE 2                           -- 停用：其他情況
    END AS Status
FROM (
	-- 將學校資料去重，只取唯一的學校資料
	SELECT 
		[OriginalSchoolId],              -- 原學校ID
		[SchoolCode],                    -- 學校代碼
		[CityName],                      -- 城市名稱
		[SchoolTypeName],                -- 學校類型名稱
		[IsExchangeSchool],              -- 是否為交換學校
		[IsInternalTest],                -- 是否為內部測試學校
		[IsDeleted],                     -- 是否刪除
		[IsUse]                          -- 是否使用
	FROM #SchoolData
	GROUP BY 
		[OriginalSchoolId], 
		[SchoolCode], 
		[CityName],
		[SchoolTypeName], 
		[IsExchangeSchool], 
		[IsInternalTest],
		[IsDeleted],
		[IsUse]
) G
LEFT JOIN [CountyTranslations] CT ON REPLACE(CT.[Name],'台' , '臺') = G.[CityName]  -- 關聯縣市翻譯表（處理台灣、臺灣的字體差异）
LEFT JOIN #SchoolTypeMapping STM ON STM.[Text] = G.[SchoolTypeName]                  -- 關聯學校類型對照表
LEFT JOIN [Schools] S ON S.[SchoolCode] = G.[SchoolCode]                             -- 檢查是否已存在
WHERE 
	S.[Id] IS NULL                   -- 只插入不存在的學校

SET @SchoolsInserted = @@ROWCOUNT;
PRINT '✓ Schools 插入完成: ' + CAST(@SchoolsInserted AS VARCHAR) + ' 筆';

-- ========================================
-- 第五部分：遷移學校多語系內容資料
-- ========================================

-- 將學校的中英文名稱和介紹插入SchoolContents表
INSERT INTO [Ecocampus_PreProduction].[dbo].[SchoolContents] (
    SchoolId,                            -- 學校ID
    LocaleCode,                          -- 語系代碼（zh-TW或en）
    Name,                                -- 學校名稱
    LogoFileId,                          -- 校徽檔案ID
    CreatedUserId,                       -- 建立者ID
    UpdatedUserId,                       -- 更新者ID
	Introduction                         -- 學校介紹
)
SELECT 
	D.[SchoolId],                        -- 學校ID
	D.[LocaleCode],                      -- 語系代碼
	D.[SchoolNewName],                   -- 學校名稱
	D.[LogoFileId],                      -- 校徽檔案ID
	D.[CreatedUserId],                   -- 建立者ID
	D.[UpdatedUserId],                   -- 更新者ID
    D.[SchoolIntroduction]               -- 學校介紹
FROM 
(
	-- 將中英文名稱轉換為不同的語系記錄
	SELECT 
		S.[Id] AS [SchoolId],                -- 新系統學校ID
		CASE 
			WHEN UPV.[SchoolLanguageType] = 'SchoolName' THEN 'zh-TW'  -- 中文名稱設為繁體中文
			ELSE 'en'                                                 -- 英文名稱設為英文
		END AS [LocaleCode],
		UPV.[SchoolNewName],                 -- 轉換後的學校名稱
		UPV.[SchoolIntroduction],            -- 學校介紹
		-- Map LogoFileName to FileEntry.Id using FileName
		(SELECT fe.Id FROM Ecocampus_PreProduction.dbo.FileEntry fe 
		 WHERE fe.FileName = G2.[LogoFileName] 
		 AND G2.[LogoFileName] IS NOT NULL 
		 AND G2.[LogoFileName] != '') AS [LogoFileId], -- 校徽檔案ID
		1 AS [CreatedUserId],                -- 建立者ID（預設為1）
		1 AS [UpdatedUserId]                 -- 更新者ID（預設為1）
	FROM (
		SELECT 
			G1.[SchoolCode], 
			SD2.[SchoolName], 
			SD2.[SchoolEnName], 
			SD2.[SchoolIntroduction],
			SD2.[LogoFileName]
		FROM (
			SELECT 
				MAX([OriginalSchoolId]) AS [LatestOriginalSchoolId], 
				[SchoolCode]
			FROM #SchoolData
			GROUP BY 
				[SchoolCode]
		) G1
		LEFT JOIN (
			SELECT 
				[OriginalSchoolId], 
				[SchoolName], 
				[SchoolEnName], 
				[SchoolIntroduction],
				[LogoFileName] 
			FROM #SchoolData 
			GROUP BY 
				[OriginalSchoolId], 
				[SchoolName], 
				[SchoolEnName], 
				[SchoolIntroduction],
				[LogoFileName]
			) SD2 ON
			SD2.[OriginalSchoolId] = G1.[LatestOriginalSchoolId]
	) G2
	UNPIVOT                              -- 使用UNPIVOT將中英文名稱轉為多筆記錄
	(
		[SchoolNewName] FOR [SchoolLanguageType] IN (G2.[SchoolName], G2.[SchoolEnName])  -- 將SchoolName和SchoolEnName欄位轉為多筆記錄
	) UPV
	LEFT JOIN [Schools] S ON
		S.[SchoolCode] = UPV.[SchoolCode]
) D
LEFT JOIN [SchoolContents] SC ON
	SC.[SchoolId] = D.[SchoolId] AND SC.[LocaleCode] = D.[LocaleCode]
WHERE 
	D.[SchoolId] IS NOT NULL AND
	SC.[SchoolId] IS NULL

SET @SchoolContentsInserted = @@ROWCOUNT;
PRINT '✓ SchoolContents 插入完成: ' + CAST(@SchoolContentsInserted AS VARCHAR) + ' 筆';

-- ========================================
-- 第六部分：遷移認證資料
-- ========================================

-- 將學校認證資料插入Certifications表
INSERT INTO [Ecocampus_PreProduction].[dbo].[Certifications]
(
	[SchoolId],                          -- 學校ID
	[Level],               -- 認證類型ID（改為Level對應新系統的CertificationTypeId）
	[ReviewStatus],                      -- 審核狀態
	[ReviewDate],                        -- 審核日期
	[ApprovedDate],                      -- 通過日期
	[RejectedDate],                      -- 拒絕日期
	[SupplementationDate],               -- 補件日期
	[AddType],                           -- 新增類型
	[CreatedUserId],                     -- 建立者ID
	[Status]                            -- 狀態
)
SELECT * FROM (
SELECT 
    S.[Id] AS [SchoolId],                -- 學校ID
    CLM.[NewCertificationTypeId],        -- 認證類型ID（從對照表轉換）
	RSM.[Status] AS [ReviewStatus],      -- 審核狀態（從對照表轉換）
    SD.CertReviewDateTime,               -- 審核日期
    SD.CertPassDateTime,                 -- 通過日期
    SD.CertReturnDateTime,               -- 退件日期
    SD.CertSupplementationDateTime,      -- 補件日期
    CASE 
		WHEN SD.CertAddType = 'front' THEN 
			'Frontend'                   -- 前台新增
		ELSE 
			'Backend'                    -- 後台新增
	END AS [CertAddType],
    1 AS CreatedUserId,                  -- 建立者ID（預設為1）
	(SD.[CertIsDelete] + 1) % 2 AS [Status]  -- 狀態（將是否刪除轉換為啟用/停用）
FROM #SchoolData SD                      -- 從學校資料臨時表取得資料
INNER JOIN [Ecocampus_PreProduction].[dbo].[Schools] S ON  -- 關聯新系統學校表
	S.SchoolCode = SD.SchoolCode
LEFT JOIN #CertificationLevelMapping CLM ON  -- 關聯認證等級對照表
	CLM.[OldLevel] = SD.[CertLevel]
LEFT JOIN #ReviewStatusMapping RSM ON    -- 關聯審核狀態對照表
	RSM.[Text] = SD.[CertReviewText]
LEFT JOIN [Ecocampus_PreProduction].[dbo].[Certifications] SC ON  -- 檢查是否已存在相同認證
	SC.SchoolId = S.Id AND
	SC.LEVEL = CLM.[NewCertificationTypeId] AND
	SC.[ReviewStatus] = RSM.[Status]
WHERE 
	S.[Id] IS NOT NULL AND               -- 學校必須存在
	SD.[CertLevel] IS NOT NULL AND       -- 認證等級不為空
	CLM.[NewCertificationTypeId] IS NOT NULL AND  -- 認證類型ID對照成功
	SC.[CertificationId] IS NULL         -- 只插入不存在的認證資料
GROUP BY 
    S.[Id],
    CLM.[NewCertificationTypeId],
	RSM.[Status],  
    SD.CertReviewDateTime,
    SD.CertPassDateTime,
    SD.CertReturnDateTime,
    SD.CertSupplementationDateTime,
    SD.CertAddType,
	SD.[CertIsDelete]
) G

SET @CertificationsInserted = @@ROWCOUNT;
PRINT '✓ Certifications 插入完成: ' + CAST(@CertificationsInserted AS VARCHAR) + ' 筆';

-- ========================================
-- 第七部分：遷移環境教育路徑狀態資料
-- ========================================

-- 將學校的環境教育路徑遵循狀態插入SchoolEnvironmentalPathStatuses表
INSERT INTO [Ecocampus_PreProduction].[dbo].[SchoolEnvironmentalPathStatuses]
(
	[SchoolId],                          -- 學校ID
	[EnvironmentalPathId],               -- 環境路徑ID
	[IsCompliant],                       -- 是否遵循
	[CreatedUserId],                     -- 建立者ID
	[Status]                            -- 狀態
)
SELECT 
	S.Id AS SchoolId,                    -- 學校ID
    EM.EnvId AS EnvironmentalPathId,     -- 環境路徑ID
    MAX(CASE 
        WHEN E.[HasPath] IS NULL THEN 0  -- 若為空則設為不遵循
        ELSE E.[HasPath]                 -- 否則使用原始值
    END) AS [IsCompliant],
    1 AS [CreatedUserId],                -- 建立者ID（預設為1）
    1 AS [Status]                        -- 狀態（預設為啟用）
FROM 
(
	SELECT 
		[SchoolCode], 
        [PathName], 
        [HasPath]
	FROM (
		SELECT 
			[SchoolCode], 
			[HasTrafficPath],
			[HasEnergyPath],
			[HasWaterPath],
			[HasWeatherPath],
			[HasSchoolHabitatPath],
			[HasWastePath],
			[HasHealthLifePath],
			[HasHealthSchoolPath],
			[HasBiologicalPath],
			[HasFoodPath],
			[HasForestPath],
			[HasSeaProtectionPath]
		FROM #SchoolData
	) G
	UNPIVOT                              -- 使用UNPIVOT將多個路徑欄位轉為多筆記錄
	(
		[HasPath] FOR [PathName] IN (        -- 將路徑欄位轉為路徑名稱和狀態
			[HasTrafficPath],            -- 交通教育路徑
			[HasEnergyPath],             -- 能源教育路徑
			[HasWaterPath],              -- 水資源教育路徑
			[HasWeatherPath],            -- 氣候教育路徑
			[HasSchoolHabitatPath],      -- 校園棲地路徑
			[HasWastePath],              -- 廢棄物教育路徑
			[HasHealthLifePath],         -- 健康生活路徑
			[HasHealthSchoolPath],       -- 健康校園路徑
			[HasBiologicalPath],         -- 生物多樣性路徑
			[HasFoodPath],               -- 綠色飲食路徑
			[HasForestPath],             -- 森林教育路徑
			[HasSeaProtectionPath]       -- 海洋教育路徑
		)
	) UPV
) E
INNER JOIN [Ecocampus_PreProduction].[dbo].[Schools] S       -- 關聯新系統學校表
	ON S.SchoolCode = E.SchoolCode
LEFT JOIN #EnviromentMapping EM                             -- 關聯環境路徑對照表
	ON EM.[Text] = E.[PathName]
LEFT JOIN [Ecocampus_PreProduction].[dbo].[SchoolEnvironmentalPathStatuses] SEPS  -- 檢查是否已存在
	ON SEPS.SchoolId = S.Id AND SEPS.EnvironmentalPathId = EM.EnvId
WHERE 
    SEPS.SchoolId IS NULL                                   -- 只插入不存在的記錄
GROUP BY 
	S.Id, EM.EnvId                                          -- 按學校ID和環境路徑ID分組

SET @EnvPathStatusesInserted = @@ROWCOUNT;
PRINT '✓ SchoolEnvironmentalPathStatuses 插入完成: ' + CAST(@EnvPathStatusesInserted AS VARCHAR) + ' 筆';

-- ========================================
-- 第八部分：遷移校長資料
-- ========================================

PRINT '步驟 8: 遷移校長資料到 SchoolPrincipals 表...';

DECLARE @PrincipalsInserted INT = 0;

-- 啟用 IDENTITY_INSERT 以插入明確的 Id 值
SET IDENTITY_INSERT [Ecocampus_PreProduction].[dbo].[SchoolPrincipals] ON;

-- 將校長資料插入SchoolPrincipals表
INSERT INTO [Ecocampus_PreProduction].[dbo].[SchoolPrincipals]
(
    [Id],                                -- 使用原系統的ID
    [SchoolId],                          -- 學校ID
    [PrincipalName],                     -- 校長姓名
    [PrincipalPhone],                    -- 校長電話
    [PrincipalMobile],                   -- 校長手機
    [PrincipalEmail],                    -- 校長Email
    [CreatedTime],                       -- 建立時間
    [CreatedUserId],                     -- 建立者ID
    [UpdatedTime],                       -- 更新時間
    [UpdatedUserId],                     -- 更新者ID
    [Status]                            -- 狀態
)
SELECT 
    csp.sid AS Id,                       -- 使用原系統ID
    s.Id AS SchoolId,                    -- 關聯到Schools表的ID
    COALESCE(csp.principal_cname, '') AS PrincipalName, -- 校長中文姓名（優先）或英文姓名
    csp.principal_tel AS PrincipalPhone, -- 校長電話
    csp.principal_phone AS PrincipalMobile, -- 校長手機
    csp.principal_email AS PrincipalEmail, -- 校長Email
    -- 時間戳轉換 (Unix timestamp to datetime2)
    CASE 
        WHEN csp.createdate IS NOT NULL AND csp.createdate > 0 
        THEN DATEADD(second, csp.createdate, '1970-01-01 00:00:00')
        ELSE SYSUTCDATETIME()
    END AS CreatedTime,
    1 AS CreatedUserId,                  -- 建立者ID（預設為1）
    CASE 
        WHEN csp.updatedate IS NOT NULL AND csp.updatedate > 0 
        THEN DATEADD(second, csp.updatedate, '1970-01-01 00:00:00')
        ELSE SYSUTCDATETIME()
    END AS UpdatedTime,
    1 AS UpdatedUserId,                  -- 更新者ID（預設為1）
    1 AS Status                          -- 狀態（預設啟用）
FROM [EcoCampus_Maria3].[dbo].[custom_school_principal] csp
INNER JOIN [EcoCampus_Maria3].[dbo].[custom_member] cm ON csp.member_sid = cm.sid
INNER JOIN [Ecocampus_PreProduction].[dbo].[Schools] s ON s.SchoolCode = CASE 
    WHEN cm.sid = 812 THEN '193665'      -- 特殊對應規則：市立大崗國小
    WHEN cm.sid = 603 THEN '034639'      -- 特殊對應規則：私立惠明盲校
    WHEN cm.sid = 796 THEN '061F01'      -- 特殊對應規則：臺中市北屯區廍子國民小學
    ELSE cm.code 
END
LEFT JOIN [Ecocampus_PreProduction].[dbo].[SchoolPrincipals] existing_sp ON existing_sp.Id = csp.sid
WHERE csp.sid IS NOT NULL
    AND cm.member_role = 'school'        -- 確保是學校類型
    AND csp.principal_cname IS NOT NULL  -- 確保有校長姓名
    AND LTRIM(RTRIM(csp.principal_cname)) != N''
    AND existing_sp.Id IS NULL;          -- 避免重複插入

SET @PrincipalsInserted = @@ROWCOUNT;

-- 關閉 IDENTITY_INSERT
SET IDENTITY_INSERT [Ecocampus_PreProduction].[dbo].[SchoolPrincipals] OFF;

PRINT '✓ SchoolPrincipals 插入完成: ' + CAST(@PrincipalsInserted AS VARCHAR) + ' 筆';

-- ========================================
-- 第九部分：遷移學校統計資料
-- ========================================

PRINT '步驟 9: 遷移學校統計資料到 SchoolStatistics 表...';

DECLARE @StatisticsInserted INT = 0;

-- 啟用 IDENTITY_INSERT 以插入明確的 Id 值
SET IDENTITY_INSERT [Ecocampus_PreProduction].[dbo].[SchoolStatistics] ON;

-- 將學校統計資料插入SchoolStatistics表
INSERT INTO [Ecocampus_PreProduction].[dbo].[SchoolStatistics]
(
    [Id],                                -- 使用原系統的ID
    [SchoolId],                          -- 學校ID
    [StaffTotal],                        -- 教職員總數
    [Elementary1],                       -- 小一學生數
    [Elementary2],                       -- 小二學生數  
    [Elementary3],                       -- 小三學生數
    [Elementary4],                       -- 小四學生數
    [Elementary5],                       -- 小五學生數
    [Elementary6],                       -- 小六學生數
    [Middle7],                           -- 國一學生數
    [Middle8],                           -- 國二學生數
    [Middle9],                           -- 國三學生數
    [High10],                            -- 高一學生數
    [High11],                            -- 高二學生數
    [High12],                            -- 高三學生數
    [WriteDate],                         -- 填寫日期
    [CreatedTime],                       -- 建立時間
    [CreatedUserId],                     -- 建立者ID
    [UpdatedTime],                       -- 更新時間
    [UpdatedUserId],                     -- 更新者ID
    [Status]                            -- 狀態
)
SELECT 
    css.sid AS Id,                       -- 使用原系統ID
    s.Id AS SchoolId,                    -- 關聯到Schools表的ID
    css.staff_total AS StaffTotal,       -- 教職員總數
    css.elementary1 AS Elementary1,      -- 小一學生數
    css.elementary2 AS Elementary2,      -- 小二學生數
    css.elementary3 AS Elementary3,      -- 小三學生數
    css.elementary4 AS Elementary4,      -- 小四學生數
    css.elementary5 AS Elementary5,      -- 小五學生數
    css.elementary6 AS Elementary6,      -- 小六學生數
    css.middle7 AS Middle7,              -- 國一學生數
    css.middle8 AS Middle8,              -- 國二學生數
    css.middle9 AS Middle9,              -- 國三學生數
    css.hight10 AS High10,               -- 高一學生數（注意：來源表拼寫為hight10）
    css.hight11 AS High11,               -- 高二學生數（注意：來源表拼寫為hight11）
    css.hight12 AS High12,               -- 高三學生數（注意：來源表拼寫為hight12）
    -- 處理write_date字串轉換為DATE格式
    CASE 
        WHEN css.write_date IS NOT NULL AND css.write_date != '' AND LEN(css.write_date) >= 8
        THEN TRY_CONVERT(DATE, css.write_date)
        ELSE NULL
    END AS WriteDate,
    -- 時間戳轉換 (Unix timestamp to datetime2)
    CASE 
        WHEN css.createdate IS NOT NULL AND css.createdate > 0 
        THEN DATEADD(second, css.createdate, '1970-01-01 00:00:00')
        ELSE SYSUTCDATETIME()
    END AS CreatedTime,
    1 AS CreatedUserId,                  -- 建立者ID（預設為1）
    CASE 
        WHEN css.updatedate IS NOT NULL AND css.updatedate > 0 
        THEN DATEADD(second, css.updatedate, '1970-01-01 00:00:00')
        ELSE SYSUTCDATETIME()
    END AS UpdatedTime,
    1 AS UpdatedUserId,                  -- 更新者ID（預設為1）
    1 AS Status                          -- 狀態（預設啟用）
FROM [EcoCampus_Maria3].[dbo].[custom_school_statistics] css
INNER JOIN [EcoCampus_Maria3].[dbo].[custom_member] cm ON css.member_sid = cm.sid
INNER JOIN [Ecocampus_PreProduction].[dbo].[Schools] s ON s.SchoolCode = CASE 
    WHEN cm.sid = 812 THEN '193665'      -- 特殊對應規則：市立大崗國小
    WHEN cm.sid = 603 THEN '034639'      -- 特殊對應規則：私立惠明盲校
    WHEN cm.sid = 796 THEN '061F01'      -- 特殊對應規則：臺中市北屯區廍子國民小學
    ELSE cm.code 
END
LEFT JOIN [Ecocampus_PreProduction].[dbo].[SchoolStatistics] existing_ss ON existing_ss.Id = css.sid
WHERE css.sid IS NOT NULL
    AND cm.member_role = 'school'        -- 確保是學校類型
    AND existing_ss.Id IS NULL;          -- 避免重複插入

SET @StatisticsInserted = @@ROWCOUNT;

-- 關閉 IDENTITY_INSERT
SET IDENTITY_INSERT [Ecocampus_PreProduction].[dbo].[SchoolStatistics] OFF;

PRINT '✓ SchoolStatistics 插入完成: ' + CAST(@StatisticsInserted AS VARCHAR) + ' 筆';

-- ========================================
-- 第十部分：遷移學校聯絡人資料
-- ========================================

PRINT '步驟 10: 遷移學校聯絡人資料到 SchoolContacts 表...';

DECLARE @ContactsInserted INT = 0;

-- 啟用 IDENTITY_INSERT 以插入明確的 Id 值
SET IDENTITY_INSERT [Ecocampus_PreProduction].[dbo].[SchoolContacts] ON;

-- 將學校聯絡人資料插入SchoolContacts表
INSERT INTO [Ecocampus_PreProduction].[dbo].[SchoolContacts]
(
    [Id],                                -- 使用原系統的ID
    [SchoolId],                          -- 學校ID
    [ContactName],                       -- 聯絡人姓名
    [JobTitle],                          -- 職稱
    [ContactPhone],                      -- 聯絡電話
    [ContactMobile],                     -- 聯絡手機
    [ContactEmail],                      -- 聯絡Email
    [SortOrder],                         -- 排序順序
    [CreatedTime],                       -- 建立時間
    [CreatedUserId],                     -- 建立者ID
    [UpdatedTime],                       -- 更新時間
    [UpdatedUserId],                     -- 更新者ID
    [Status]                            -- 狀態
)
SELECT 
    cc.sid AS Id,                        -- 使用原系統ID
    s.Id AS SchoolId,                    -- 關聯到Schools表的ID
    COALESCE(cc.contact_cname, '') AS ContactName, -- 聯絡人中文姓名（優先）或英文姓名
    cc.contact_job_cname AS JobTitle,    -- 職稱
    cc.contact_tel AS ContactPhone,      -- 聯絡電話
    cc.contact_phone AS ContactMobile,   -- 聯絡手機
    cc.contact_email AS ContactEmail,    -- 聯絡Email
    COALESCE(cc.sequence, 0) AS SortOrder, -- 排序順序（預設為0）
    -- 時間戳轉換 (Unix timestamp to datetime2)
    CASE 
        WHEN cc.createdate IS NOT NULL AND cc.createdate > 0 
        THEN DATEADD(second, cc.createdate, '1970-01-01 00:00:00')
        ELSE SYSUTCDATETIME()
    END AS CreatedTime,
    1 AS CreatedUserId,                  -- 建立者ID（預設為1）
    CASE 
        WHEN cc.updatedate IS NOT NULL AND cc.updatedate > 0 
        THEN DATEADD(second, cc.updatedate, '1970-01-01 00:00:00')
        ELSE SYSUTCDATETIME()
    END AS UpdatedTime,
    1 AS UpdatedUserId,                  -- 更新者ID（預設為1）
    1 AS Status                          -- 狀態（預設啟用）
FROM [EcoCampus_Maria3].[dbo].[custom_contact] cc
INNER JOIN [EcoCampus_Maria3].[dbo].[custom_member] cm ON cc.member_sid = cm.sid
INNER JOIN [Ecocampus_PreProduction].[dbo].[Schools] s ON s.SchoolCode = CASE 
    WHEN cm.sid = 812 THEN '193665'      -- 特殊對應規則：市立大崗國小
    WHEN cm.sid = 603 THEN '034639'      -- 特殊對應規則：私立惠明盲校
    WHEN cm.sid = 796 THEN '061F01'      -- 特殊對應規則：臺中市北屯區廍子國民小學
    ELSE cm.code 
END
LEFT JOIN [Ecocampus_PreProduction].[dbo].[SchoolContacts] existing_sc ON existing_sc.Id = cc.sid
WHERE cc.sid IS NOT NULL
    AND cm.member_role = 'school'        -- 確保是學校類型
    AND cc.contact_cname IS NOT NULL     -- 確保有聯絡人姓名
    AND LTRIM(RTRIM(cc.contact_cname)) != N''
    AND existing_sc.Id IS NULL;          -- 避免重複插入

SET @ContactsInserted = @@ROWCOUNT;

-- 關閉 IDENTITY_INSERT
SET IDENTITY_INSERT [Ecocampus_PreProduction].[dbo].[SchoolContacts] OFF;

PRINT '✓ SchoolContacts 插入完成: ' + CAST(@ContactsInserted AS VARCHAR) + ' 筆';

-- ========================================
-- 遷移結果統計與範例輸出
-- ========================================
PRINT '========================================';
PRINT '學校資料遷移結果統計:';
PRINT ' - Schools: ' + CAST(@SchoolsInserted AS VARCHAR) + ' 筆';
PRINT ' - SchoolContents: ' + CAST(@SchoolContentsInserted AS VARCHAR) + ' 筆';
PRINT ' - Certifications: ' + CAST(@CertificationsInserted AS VARCHAR) + ' 筆';
PRINT ' - SchoolEnvironmentalPathStatuses: ' + CAST(@EnvPathStatusesInserted AS VARCHAR) + ' 筆';
PRINT ' - SchoolPrincipals: ' + CAST(@PrincipalsInserted AS VARCHAR) + ' 筆';
PRINT ' - SchoolStatistics: ' + CAST(@StatisticsInserted AS VARCHAR) + ' 筆';
PRINT ' - SchoolContacts: ' + CAST(@ContactsInserted AS VARCHAR) + ' 筆';

PRINT '遷移結果範例 (前5筆):';
SELECT TOP 5 
	s.Id as SchoolId,
	s.SchoolCode,
	s.Status,
	sc.LocaleCode,
	sc.Name as SchoolName
FROM Schools s
LEFT JOIN SchoolContents sc ON s.Id = sc.SchoolId AND sc.LocaleCode IN ('zh-TW','en')
ORDER BY s.Id, sc.LocaleCode;

PRINT '✅ 學校資料遷移腳本執行完成！';
PRINT '執行完成時間: ' + CONVERT(VARCHAR, SYSDATETIME(), 120);
PRINT '========================================';

-- ========================================
-- 學校資料遷移腳本執行完成
-- ========================================
-- 此腳本已完成以下工作：
-- 1. 清除目標資料表中的相關資料
-- 2. 遷移學校基本資料到Schools表
-- 3. 遷移學校多語系內容到SchoolContents表  
-- 4. 遷移學校認證資料到Certifications表
-- 5. 遷移學校環境教育路徑狀態到SchoolEnvironmentalPathStatuses表
-- 6. 遷移學校校長資料到SchoolPrincipals表
-- 7. 遷移學校統計資料到SchoolStatistics表  
-- 8. 遷移學校聯絡人資料到SchoolContacts表

-- ✓ FIXED: Added LogoFileId mapping from custom_member.member_photo -> FileEntry.Id
