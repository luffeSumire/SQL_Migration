DROP TABLE #SchoolData 
GO

CREATE TABLE #SchoolData (
    [OriginalSchoolId] BIGINT,
    [SchoolTypeName] NVARCHAR(50),
    [SchoolCode] NVARCHAR(50), 
    [SchoolName] NVARCHAR(200), 
    [SchoolEnName] NVARCHAR(200), 
	[SchoolIntroduction] NVARCHAR(MAX),
    [CityOriginalId] BIGINT, 
    [CityName] NVARCHAR(50), 
    [AreaOriginalId] BIGINT,
    [AreaName] NVARCHAR(50), 
    [CertLevel] TINYINT,
    [CertPassDateTime] DATETIME, 
    [CertReviewDateTime] DATETIME, 
    [CertReturnDateTime] DATETIME, 
	[CertSupplementationDateTime] DATETIME, 
	[CertAddType] VARCHAR(20),
	[CertReviewText] NVARCHAR(20), 
	[CertIsDelete] BIT,
    [HasTrafficPath] BIT, 
    [HasEnergyPath] BIT, 
    [HasWaterPath] BIT, 
    [HasWeatherPath] BIT, 
    [HasSchoolHabitatPath] BIT, 
    [HasWastePath] BIT, 
    [HasHealthLifePath] BIT, 
    [HasHealthSchoolPath] BIT, 
    [HasBiologicalPath] BIT, 
    [HasFoodPath] BIT, 
    [HasForestPath] BIT, 
    [HasSeaProtectionPath] BIT, 
	[IsExchangeSchool] BIT, 
	[IsInternalTest] BIT
)

DROP TABLE #ReviewStatusMapping
GO

CREATE TABLE #ReviewStatusMapping (
	[Status] INT, 
	[Text] NVARCHAR(10)
)

INSERT INTO #ReviewStatusMapping ([Status], [Text]) VALUES 
(0, '審核中'), 
(1, '通過'), 
(2, '退件'),
(3, '補件'), 
(4, '尚未審核')

DROP TABLE #EnviromentMapping
GO

CREATE TABLE #EnviromentMapping (
	[EnvId] INT, 
	[Text] NVARCHAR(50)
)

INSERT INTO #EnviromentMapping ([EnvId], [Text]) VALUES 
(1, 'HasTrafficPath'), 
(2, 'HasEnergyPath'), 
(3, 'HasWaterPath'),
(4, 'HasWeatherPath'), 
(5, 'HasSchoolHabitatPath'),
(6, 'HasWastePath'), 
(7, 'HasHealthLifePath'), 
(8, 'HasHealthSchoolPath'), 
(9, 'HasBiologicalPath'), 
(10, 'HasFoodPath'), 
(11, 'HasForestPath'), 
(12, 'HasSeaProtectionPath')


DROP TABLE #SchoolTypeMapping
GO

CREATE TABLE #SchoolTypeMapping (
	[Type] INT, 
	[Text] NVARCHAR(50)
)

INSERT INTO #SchoolTypeMapping ([Type], [Text]) VALUES 
(1, ''), 
(1, 'general'), 
(2, 'remote'),
(3, 'particularly'), 
(4, 'extremely_biased')

INSERT INTO #SchoolData
SELECT
    CM.[sid],
    CM.[area_attributes],
    CM.[code], 
    CM.[member_cname], 
    CM.[member_cname_en], 
	CM.[member_Introduction],
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
	CM.[is_internal]
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
	CM.[member_role] = 'school' AND
	CM.[member_passdate] IS NOT NULL

UPDATE #SchoolData SET SchoolCode = '193665' WHERE OriginalSchoolId = 812 --市立大崗國小
UPDATE #SchoolData SET SchoolCode = '034639' WHERE OriginalSchoolId = 603 --私立惠明盲校
UPDATE #SchoolData SET SchoolCode = '061F01' WHERE OriginalSchoolId = 796 --臺中市北屯區廍子國民小學

INSERT INTO Schools(
    SchoolCode,
    CountyId,
    DistrictId,
    SchoolTypeId,
    IsExchangeSchool,
    IsInternalTest,
    SortOrder,
    CreatedTime,
    CreatedUserId,
    Status
)
SELECT 
    G.[SchoolCode],
    CT.[CountyId], 
    1 AS DistrictId,         -- Default for now
    STM.[Type] AS [SchoolTypeId],       -- Default type
    ISNULL(G.[IsExchangeSchool], 0),   -- Default (can be updated later)
    G.[IsInternalTest],     -- Default
    0 AS SortOrder,          -- Default
    SYSUTCDATETIME() AS CreatedTime,
    1 AS CreatedUserId,
    1 AS Status
FROM (
	SELECT 
		[OriginalSchoolId], 
		[SchoolCode], 
		[CityName],
		[SchoolTypeName], 
		[IsExchangeSchool], 
		[IsInternalTest]
	FROM #SchoolData
	GROUP BY 
		[OriginalSchoolId], 
		[SchoolCode], 
		[CityName],
		[SchoolTypeName], 
		[IsExchangeSchool], 
		[IsInternalTest]
) G
LEFT JOIN [CountyTranslations] CT ON REPLACE(CT.[Name],'台' , '臺') = G.[CityName]
LEFT JOIN #SchoolTypeMapping STM ON STM.[Text] = G.[SchoolTypeName]
LEFT JOIN [Schools] S ON S.[SchoolCode] = G.[SchoolCode]
WHERE 
	S.[Id] IS NULL

INSERT INTO [Ecocampus_PreProduction].[dbo].[SchoolContents] (
    SchoolId,
    LocaleCode,
    Name,
    CreatedUserId,
    UpdatedUserId,
	Introduction
)
SELECT 
	D.[SchoolId], 
	D.[LocaleCode], 
	D.[SchoolNewName], 
	D.[CreatedUserId], 
	D.[UpdatedUserId],
    D.[SchoolIntroduction]
FROM 
(
	SELECT 
		S.[Id] AS [SchoolId], 
		CASE 
			WHEN UPV.[SchoolLanguageType] = 'SchoolName' THEN 'zh-TW'
			ELSE 'en'
		END AS [LocaleCode],
		UPV.[SchoolNewName],
		UPV.[SchoolIntroduction], 
		1 AS [CreatedUserId], 
		1 AS [UpdatedUserId]
	FROM (
		SELECT 
			[OriginalSchoolId], 
			[SchoolCode], 
			[SchoolName], 
			[SchoolEnName],
			[SchoolIntroduction]
		FROM #SchoolData
		GROUP BY 
			[OriginalSchoolId], [SchoolCode], [SchoolName], [SchoolEnName], [SchoolIntroduction]
	) G
	UNPIVOT 
	(
		[SchoolNewName] FOR [SchoolLanguageType] IN ([SchoolName], [SchoolEnName])
	) UPV
	LEFT JOIN [Schools] S ON
		S.[SchoolCode] = UPV.[SchoolCode]
) D
LEFT JOIN [SchoolContents] SC ON
	SC.[SchoolId] = D.[SchoolId] AND SC.[LocaleCode] = D.[LocaleCode]
WHERE 
	D.[SchoolId] IS NOT NULL AND
	SC.[SchoolId] IS NULL

INSERT INTO [Ecocampus_PreProduction].[dbo].[Certifications]
(
	[SchoolId], 
	[Level], 
	[ReviewStatus], 
	[ReviewDate], 
	[ApprovedDate], 
	[RejectedDate], 
	[SupplementationDate], 
	[AddType], 
	[CreatedUserId], 
	[Status]
)
SELECT * FROM (
SELECT 
    S.[Id] AS [SchoolId],
    SD.[CertLevel],
	RSM.[Status] AS [ReviewStatus],  
    SD.CertReviewDateTime,
    SD.CertPassDateTime,
    SD.CertReturnDateTime,
    SD.CertSupplementationDateTime,
    CASE 
		WHEN SD.CertAddType = 'front' THEN 
			'Frontend' 
		ELSE 
			'Backend'
	END AS [CertAddType],
    1 AS CreatedUserId, 
	(SD.[CertIsDelete] + 1) % 2 AS [Status]
FROM #SchoolData SD
INNER JOIN [Ecocampus_PreProduction].[dbo].[Schools] S ON 
	S.SchoolCode = SD.SchoolCode
LEFT JOIN #ReviewStatusMapping RSM ON 
	RSM.[Text] = SD.[CertReviewText]
LEFT JOIN [Ecocampus_PreProduction].[dbo].[Certifications] SC ON 
	SC.SchoolId = S.Id AND
	SC.[Level] = SD.[CertLevel] AND
	SC.[ReviewStatus] = RSM.[Status]
WHERE 
	S.[Id] IS NOT NULL AND
	SD.[CertLevel] IS NOT NULL AND
	SC.[CertificationId] IS NULL
GROUP BY 
    S.[Id],
    SD.[CertLevel],
	RSM.[Status],  
    SD.CertReviewDateTime,
    SD.CertPassDateTime,
    SD.CertReturnDateTime,
    SD.CertSupplementationDateTime,
    SD.CertAddType,
	SD.[CertIsDelete]
) G

--INSERT INTO [Ecocampus_PreProduction].[dbo].[SchoolEnvironmentalPathStatuses]
--(
--	[SchoolId],
--	[EnvironmentalPathId],
--	[IsCompliant],
--	[CreatedUserId],
--	[Status]
--)

--SELECT 
--	S.[Id] AS [SchoolId],
--    EM.[EnvId] AS [EnvironmentalPathId],
--    CASE 
--        WHEN E.[HasPath] IS NULL THEN 0
--        ELSE E.[HasPath]
--    END AS [IsCompliant],
--    1 AS [CreatedUserId],
--    1 AS [Status]
--FROM 
--(	SELECT 
--		[SchoolCode], 
--        [PathName], 
--        [HasPath]
--	FROM (
--		SELECT 
--			[SchoolCode], 
--			[HasTrafficPath],
--			[HasEnergyPath],
--			[HasWaterPath],
--			[HasWeatherPath],
--			[HasSchoolHabitatPath],
--			[HasWastePath],
--			[HasHealthLifePath],
--			[HasHealthSchoolPath],
--			[HasBiologicalPath],
--			[HasFoodPath],
--			[HasForestPath],
--			[HasSeaProtectionPath]
--		FROM #SchoolData
--		GROUP BY 
--			[SchoolCode], 
--			[HasTrafficPath],
--			[HasEnergyPath],
--			[HasWaterPath],
--			[HasWeatherPath],
--			[HasSchoolHabitatPath],
--			[HasWastePath],
--			[HasHealthLifePath],
--			[HasHealthSchoolPath],
--			[HasBiologicalPath],
--			[HasFoodPath],
--			[HasForestPath],
--			[HasSeaProtectionPath]
--	) G
--	UNPIVOT 
--	(
--		[HasPath] FOR [PathName] IN (
--			[HasTrafficPath],
--			[HasEnergyPath],
--			[HasWaterPath],
--			[HasWeatherPath],
--			[HasSchoolHabitatPath],
--			[HasWastePath],
--			[HasHealthLifePath],
--			[HasHealthSchoolPath],
--			[HasBiologicalPath],
--			[HasFoodPath],
--			[HasForestPath],
--			[HasSeaProtectionPath]
--		)
--	) UPV
--) E
--INNER JOIN [Ecocampus_PreProduction].[dbo].[Schools] S ON 
--    S.SchoolCode = E.SchoolCode
--LEFT JOIN #EnviromentMapping EM ON 
--	EM.[Text] = E.[PathName]
--LEFT JOIN [Ecocampus_PreProduction].[dbo].[SchoolEnvironmentalPathStatuses] SEPS ON
--    SEPS.SchoolId = S.Id AND
--    SEPS.EnvironmentalPathId = EM.EnvId
--WHERE 
--    SEPS.SchoolId IS NULL;

INSERT INTO [Ecocampus_PreProduction].[dbo].[SchoolEnvironmentalPathStatuses]
(
	[SchoolId],
	[EnvironmentalPathId],
	[IsCompliant],
	[CreatedUserId],
	[Status]
)
SELECT 
	S.Id AS SchoolId,
    EM.EnvId AS EnvironmentalPathId,
    MAX(CASE 
        WHEN E.[HasPath] IS NULL THEN 0
        ELSE E.[HasPath]
    END) AS [IsCompliant],
    1 AS [CreatedUserId],
    1 AS [Status]
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
	UNPIVOT 
	(
		[HasPath] FOR [PathName] IN (
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
		)
	) UPV
) E
INNER JOIN [Ecocampus_PreProduction].[dbo].[Schools] S 
	ON S.SchoolCode = E.SchoolCode
LEFT JOIN #EnviromentMapping EM 
	ON EM.[Text] = E.[PathName]
LEFT JOIN [Ecocampus_PreProduction].[dbo].[SchoolEnvironmentalPathStatuses] SEPS 
	ON SEPS.SchoolId = S.Id AND SEPS.EnvironmentalPathId = EM.EnvId
WHERE 
    SEPS.SchoolId IS NULL
GROUP BY 
	S.Id, EM.EnvId
