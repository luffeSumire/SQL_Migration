BEGIN TRANSACTION;

------------------------------------------------------------
-- 1️⃣ 清空主檔與翻譯檔
------------------------------------------------------------
DELETE FROM EnvironmentalPathTranslations;
DELETE FROM EnvironmentalPaths;

------------------------------------------------------------
-- 2️⃣ 重建主檔 (EnvironmentalPaths)
------------------------------------------------------------
SET IDENTITY_INSERT EnvironmentalPaths ON;

INSERT INTO EnvironmentalPaths (Id, PathCode, CategoryCode, SortOrder, IsActive, CreatedTime, CreatedUserId, Status)
VALUES
(1,  'traffic',         'ENVIRONMENT',  1, 1, GETDATE(), 1, 1), -- Transportation
(2,  'energy',          'ENVIRONMENT',  2, 1, GETDATE(), 1, 1), -- Energy
(3,  'water',           'ENVIRONMENT',  3, 1, GETDATE(), 1, 1), -- Water
(4,  'climateChange',   'ENVIRONMENT',  4, 1, GETDATE(), 1, 1), -- Climate Change
(5,  'schoolHabitat',   'ENVIRONMENT',  5, 1, GETDATE(), 1, 1), -- School Habitat
(6,  'waste',           'ENVIRONMENT',  6, 1, GETDATE(), 1, 1), -- Waste and Consumption
(7,  'healthyLiving',   'ENVIRONMENT',  7, 1, GETDATE(), 1, 1), -- Healthy Living
(8,  'healthyCampus',   'ENVIRONMENT',  8, 1, GETDATE(), 1, 1), -- Healthy Campus
(9,  'biodiversity',    'ENVIRONMENT',  9, 1, GETDATE(), 1, 1), -- Biodiversity
(10, 'sustainableFood', 'ENVIRONMENT', 10, 1, GETDATE(), 1, 1), -- Sustainable Food
(11, 'forest',          'ENVIRONMENT', 11, 1, GETDATE(), 1, 1), -- Forest
(12, 'wetlands',        'ENVIRONMENT', 12, 1, GETDATE(), 1, 1); -- Watershed, Ocean, Wetlands

SET IDENTITY_INSERT EnvironmentalPaths OFF;

------------------------------------------------------------
-- 3️⃣ 重建翻譯檔 (EnvironmentalPathTranslations)
------------------------------------------------------------
SET IDENTITY_INSERT EnvironmentalPathTranslations ON;

-- zh-TW (ID 與主檔對齊)
INSERT INTO EnvironmentalPathTranslations (EnvironmentalPathTranslationId, EnvironmentalPathId, LocaleCode, IsDefault, Name, Description, CreatedTime, CreatedUserId)
VALUES
(1,  1,  'zh-TW', 1, N'交通',           N'交通環境改善行動',             GETDATE(), 1),
(2,  2,  'zh-TW', 1, N'能源',           N'能源節約保護行動',             GETDATE(), 1),
(3,  3,  'zh-TW', 1, N'水',             N'水資源保護行動',               GETDATE(), 1),
(4,  4,  'zh-TW', 1, N'氣候變遷',       N'氣候變遷因應行動',             GETDATE(), 1),
(5,  5,  'zh-TW', 1, N'學校棲地',       N'學校棲地保育行動',             GETDATE(), 1),
(6,  6,  'zh-TW', 1, N'消耗與廢棄物',   N'消耗與廢棄物減量行動',         GETDATE(), 1),
(7,  7,  'zh-TW', 1, N'健康生活',       N'健康生活促進行動',             GETDATE(), 1),
(8,  8,  'zh-TW', 1, N'健康校園',       N'健康校園促進行動',             GETDATE(), 1),
(9,  9,  'zh-TW', 1, N'生物多樣性',     N'生物多樣性保育行動',           GETDATE(), 1),
(10, 10, 'zh-TW', 1, N'永續食物',       N'永續食物消費行動',             GETDATE(), 1),
(11, 11, 'zh-TW', 1, N'森林',           N'森林保護行動',                 GETDATE(), 1),
(12, 12, 'zh-TW', 1, N'流域、海洋、濕地',N'流域、海洋與濕地保護行動',     GETDATE(), 1);

-- en (ID = 主檔 ID + 12)
INSERT INTO EnvironmentalPathTranslations (EnvironmentalPathTranslationId, EnvironmentalPathId, LocaleCode, IsDefault, Name, Description, CreatedTime, CreatedUserId)
VALUES
(13,  1, 'en', 0, 'Transportation',             'Sustainable Transportation Initiatives',         GETDATE(), 1),
(14,  2, 'en', 0, 'Energy',                     'Energy Conservation Actions',                    GETDATE(), 1),
(15,  3, 'en', 0, 'Water',                      'Water Resource Protection',                      GETDATE(), 1),
(16,  4, 'en', 0, 'Climate Change',             'Climate Change Adaptation',                      GETDATE(), 1),
(17,  5, 'en', 0, 'School Habitat',             'School Habitat Conservation Actions',            GETDATE(), 1),
(18,  6, 'en', 0, 'Waste and Consumption',      'Waste and Consumption Reduction Actions',        GETDATE(), 1),
(19,  7, 'en', 0, 'Healthy Living',             'Healthy Living Promotion Actions',               GETDATE(), 1),
(20,  8, 'en', 0, 'Healthy Campus',             'Healthy Campus Promotion Actions',               GETDATE(), 1),
(21,  9, 'en', 0, 'Biodiversity',               'Biodiversity Conservation',                      GETDATE(), 1),
(22, 10, 'en', 0, 'Sustainable Food',           'Sustainable Food Consumption Actions',           GETDATE(), 1),
(23, 11, 'en', 0, 'Forest',                     'Forest Conservation Actions',                     GETDATE(), 1),
(24, 12, 'en', 0, 'Watershed, Ocean, Wetlands', 'Watershed, Ocean and Wetlands Conservation Actions', GETDATE(), 1);

SET IDENTITY_INSERT EnvironmentalPathTranslations OFF;

COMMIT;

select * from EnvironmentalPaths;
select * from EnvironmentalPathTranslations;