/*
腳本名稱: 08_1_envpath_migration.sql
目的:
  1. 為 [SchoolEnvironmentalPathStatuses] 新增 Level 欄位 (存放認證等級，而非舊系統 level_sid)
  2. 重新遷移 舊系統學校環境教育路徑「歷程」資料，保留每一次認證等級所對應的環境路徑。

資料來源 (舊系統):
  custom_member (學校帳號)
  custom_certification (認證資料，需 review='通過')
  custom_member_level (認證等級對應，可能有重複，取 sid 較大的那筆；需 effectiveness=1)
  custom_member_path (環境路徑布林欄位，依等級 level_sid 關聯)

遷移規則:
  - [Level] 填入 custom_certification.level (認證等級)；不是 custom_member_level.sid
  - 同一 certification_sid 若 custom_member_level 有多筆，取 sid 最大 (最新) 那筆
  - 只遷移 custom_member_path 中值為 1 的環境路徑 (表示有參與/遵循)
  - 每個(學校, 認證等級, 路徑) 產生一筆歷程記錄 (IsCompliant=1)
  - 清除原有 [SchoolEnvironmentalPathStatuses] 內全部資料後重建 (若需保留原資料，請在執行前備份或移除刪除語句)

注意:
  - 此腳本假設目標資料庫為 [EcoCampus_PreProduction3]，若環境不同請搜尋/取代資料庫名稱。
  - 如需保留現有資料請註解刪除語句。
*/
SET NOCOUNT ON;

PRINT 'Step 1: 檢查並新增 SchoolEnvironmentalPathStatuses.Level 欄位...';
IF NOT EXISTS (
    SELECT 1 FROM [EcoCampus_PreProduction3].sys.columns 
    WHERE name = 'Level' 
      AND object_id = OBJECT_ID('[EcoCampus_PreProduction3].[dbo].[SchoolEnvironmentalPathStatuses]')
)
BEGIN
    ALTER TABLE [EcoCampus_PreProduction3].[dbo].[SchoolEnvironmentalPathStatuses]
        ADD [Level] TINYINT NULL; -- 認證等級 (對應 Certifications.Level)
    PRINT ' - 已新增 Level 欄位';
END
ELSE
BEGIN
    PRINT ' - Level 欄位已存在，略過新增';
END
GO

PRINT 'Step 1-1: 調整索引 (清除舊索引, 稍後重建唯一索引)...';
-- 移除舊唯一索引 (若存在)
IF EXISTS (
    SELECT 1 FROM [EcoCampus_PreProduction3].sys.indexes 
    WHERE name = 'UQ_SchoolEnvironmentalPathStatus_School_Path_Level' 
      AND object_id = OBJECT_ID('[EcoCampus_PreProduction3].[dbo].[SchoolEnvironmentalPathStatuses]'))
BEGIN
    DROP INDEX [UQ_SchoolEnvironmentalPathStatus_School_Path_Level] ON [EcoCampus_PreProduction3].[dbo].[SchoolEnvironmentalPathStatuses];
    PRINT ' - 已刪除唯一索引 UQ_SchoolEnvironmentalPathStatus_School_Path_Level';
END
IF EXISTS (
    SELECT 1 FROM [EcoCampus_PreProduction3].sys.indexes 
    WHERE name = 'UQ_SchoolEnvironmentalPathStatus_School_Path' 
      AND object_id = OBJECT_ID('[EcoCampus_PreProduction3].[dbo].[SchoolEnvironmentalPathStatuses]'))
BEGIN
    DROP INDEX [UQ_SchoolEnvironmentalPathStatus_School_Path] ON [EcoCampus_PreProduction3].[dbo].[SchoolEnvironmentalPathStatuses];
    PRINT ' - 已刪除唯一索引 UQ_SchoolEnvironmentalPathStatus_School_Path';
END
-- 先不建立索引，待資料插入後建立唯一索引
GO

PRINT 'Step 2: 重新遷移 環境教育路徑歷程資料 (清除舊資料)...';
DELETE FROM [EcoCampus_PreProduction3].[dbo].[SchoolEnvironmentalPathStatuses];
PRINT ' - 已刪除原有資料筆數: ' + CAST(@@ROWCOUNT AS VARCHAR(20));
GO

PRINT 'Step 2-1: 建立暫存對照 (環境路徑欄位名稱 -> 新系統 EnvironmentalPathId)...';
IF OBJECT_ID('tempdb..#EnvPathMapping') IS NOT NULL DROP TABLE #EnvPathMapping;
CREATE TABLE #EnvPathMapping (
    EnvId INT PRIMARY KEY,
    ColumnName SYSNAME NOT NULL
);
INSERT INTO #EnvPathMapping (EnvId, ColumnName) VALUES
 (1,  'traffic'),      -- 交通 (TRANSPORTATION)
 (2,  'energy'),       -- 能源 (ENERGY)
 (3,  'water'),        -- 水資源 (WATER)
 (4,  'weather'),      -- 氣候 / 氣候變遷 (CLIMATE_CHANGE)
 (5,  'habitat'),      -- 校園棲地 (對應原 HasSchoolHabitatPath)
 (6,  'consume'),      -- 廢棄物 / 消耗 (WASTE / CONSUMPTION)
 (7,  'life'),         -- 健康生活 (HEALTH LIFE)
 (8,  'school'),       -- 健康校園 (HEALTH SCHOOL)
 (9,  'biological'),   -- 生物多樣性 (BIODIVERSITY)
 (10, 'food'),         -- 綠色飲食 (FOOD)
 (11, 'forest'),       -- 森林教育 (FOREST)
 (12, 'protection');   -- 水體/海洋保護 (SEA PROTECTION)
PRINT ' - 已建立 #EnvPathMapping';
GO

PRINT 'Step 2-2: 建立暫存去重後的 custom_member_level (取同 certification_sid sid 最大)...';
IF OBJECT_ID('tempdb..#LatestMemberLevel') IS NOT NULL DROP TABLE #LatestMemberLevel;
SELECT * INTO #LatestMemberLevel
FROM (
    SELECT cml.*, ROW_NUMBER() OVER (PARTITION BY cml.certification_sid ORDER BY cml.sid DESC) AS rn
    FROM [EcoCampus_Maria3].[dbo].[custom_member_level] cml
    WHERE cml.effectiveness = 1
) X
WHERE rn = 1;
CREATE INDEX IX_LatestMemberLevel_CertSid ON #LatestMemberLevel(certification_sid);
PRINT ' - 已建立 #LatestMemberLevel';
GO

PRINT 'Step 2-3: 轉換並插入資料 (僅保留每組 SchoolId,Level,EnvironmentalPathId 之最新一筆)...';

DECLARE @Inserted INT = 0;

/* 修改後規則:
   - 只保留每個 (SchoolId, Level, EnvironmentalPathId) 最新一筆 (以 custom_member_level.sid 最大判定)
   - 仍插入 12 條路徑, IsCompliant = 原布林值 (無資料=0)
*/
WITH RawData AS (
    SELECT 
        S.Id AS SchoolId,
        M.EnvId AS EnvironmentalPathId,
        CAST(TRY_CONVERT(TINYINT, CC.level) AS TINYINT) AS [Level],
        CML.sid AS MemberLevelSid,
        CASE 
            WHEN TRY_CONVERT(INT, 
                CASE M.EnvId
                    WHEN 1 THEN CMP.traffic
                    WHEN 2 THEN CMP.energy
                    WHEN 3 THEN CMP.water
                    WHEN 4 THEN CMP.weather
                    WHEN 5 THEN CMP.habitat
                    WHEN 6 THEN CMP.consume
                    WHEN 7 THEN CMP.life
                    WHEN 8 THEN CMP.school
                    WHEN 9 THEN CMP.biological
                    WHEN 10 THEN CMP.food
                    WHEN 11 THEN CMP.forest
                    WHEN 12 THEN CMP.protection
                END
            ) = 1 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AS IsCompliant,
        COALESCE(
            CASE 
                WHEN TRY_CONVERT(BIGINT, CMP.createdate) IS NOT NULL AND TRY_CONVERT(BIGINT, CMP.createdate) > 0 
                    THEN DATEADD(SECOND, TRY_CONVERT(BIGINT, CMP.createdate), '1970-01-01 00:00:00') 
            END,
            CASE 
                WHEN TRY_CONVERT(BIGINT, CML.createdate) IS NOT NULL AND TRY_CONVERT(BIGINT, CML.createdate) > 0 
                    THEN DATEADD(SECOND, TRY_CONVERT(BIGINT, CML.createdate), '1970-01-01 00:00:00') 
            END,
            CASE 
                WHEN TRY_CONVERT(BIGINT, CC.passdate) IS NOT NULL AND TRY_CONVERT(BIGINT, CC.passdate) > 0 
                    THEN DATEADD(SECOND, TRY_CONVERT(BIGINT, CC.passdate), '1970-01-01 00:00:00') 
            END,
            SYSUTCDATETIME()
        ) AS CreatedTime
    FROM [EcoCampus_Maria3].[dbo].[custom_member] CM
    INNER JOIN [EcoCampus_Maria3].[dbo].[custom_certification] CC
        ON CC.member_sid = CM.sid AND CC.review = '通過'
    INNER JOIN #LatestMemberLevel CML
        ON CML.certification_sid = CC.sid
    INNER JOIN [EcoCampus_Maria3].[dbo].[custom_member_path] CMP
        ON CMP.level_sid = CML.sid
    INNER JOIN #EnvPathMapping M ON 1=1
    INNER JOIN [EcoCampus_PreProduction3].[dbo].[Schools] S 
        ON S.SchoolCode = (
            CASE 
                WHEN CM.sid = 812 THEN '193665'
                WHEN CM.sid = 603 THEN '034639'
                WHEN CM.sid = 796 THEN '061F01'
                ELSE CM.code
            END
        )
    WHERE CM.member_role = 'school'
      AND TRY_CONVERT(TINYINT, CC.level) IS NOT NULL
), Ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY SchoolId, [Level], EnvironmentalPathId ORDER BY MemberLevelSid DESC, CreatedTime DESC) AS rn
    FROM RawData
)
INSERT INTO [EcoCampus_PreProduction3].[dbo].[SchoolEnvironmentalPathStatuses]
(
    SchoolId,
    EnvironmentalPathId,
    IsCompliant,
    CreatedTime,
    CreatedUserId,
    Status,
    [Level]
)
SELECT 
    SchoolId,
    EnvironmentalPathId,
    IsCompliant,
    CreatedTime,
    1 AS CreatedUserId,
    1 AS Status,
    [Level]
FROM Ranked
WHERE rn = 1;  -- 只取最新一筆

SET @Inserted = @@ROWCOUNT;
PRINT ' - 已插入歷程筆數: ' + CAST(@Inserted AS VARCHAR(20));
GO

PRINT 'Step 2-4: 清理暫存表...';
DROP TABLE IF EXISTS #EnvPathMapping;
DROP TABLE IF EXISTS #LatestMemberLevel;
PRINT ' - 暫存表已清理';
GO

PRINT 'Step 3: 建立唯一索引 (SchoolId,Level,EnvironmentalPathId)...';
IF NOT EXISTS (
        SELECT 1 FROM [EcoCampus_PreProduction3].sys.indexes 
        WHERE name = 'UQ_SchoolEnvironmentalPathStatus_School_Level_Path' 
            AND object_id = OBJECT_ID('[EcoCampus_PreProduction3].[dbo].[SchoolEnvironmentalPathStatuses]'))
BEGIN
        CREATE UNIQUE INDEX UQ_SchoolEnvironmentalPathStatus_School_Level_Path
            ON [EcoCampus_PreProduction3].[dbo].[SchoolEnvironmentalPathStatuses] (SchoolId, [Level], EnvironmentalPathId);
        PRINT ' - 已建立唯一索引 UQ_SchoolEnvironmentalPathStatus_School_Level_Path';
END
ELSE
BEGIN
        PRINT ' - 唯一索引已存在';
END
GO

PRINT '完成: 08_1_envpath_migration.sql 執行結束';
GO
