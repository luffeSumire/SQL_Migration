-- =============================================
-- 修正後台管理帳號遷移
-- =============================================

USE EcoCampus_PreProduction;
GO

PRINT '=== 開始遷移後台管理帳號 (修正版) ===';

-- 啟用 IDENTITY_INSERT
SET IDENTITY_INSERT Accounts ON;

-- 使用簡單的 INSERT，避免複雜的 MERGE
INSERT INTO Accounts (
    AccountId, Username, password, PasswordSalt, email, Telephone, phone, 
    PostCode, address, ProfilePhotoFileId, SortOrder, Language, 
    IsSystemAdmin, IsSchoolPartner, IsEpaUser, IsGuidanceTeam, 
    CreatedTime, UpdatedTime, Status, ReviewStatus
)
SELECT 
    -(sa.sid) AS AccountId,  -- 使用負數 ID
    sa.account AS Username,
    sa.password,
    sa.password_salt AS PasswordSalt,
    sa.email,
    sa.tel AS Telephone,
    sa.phone,
    sa.post_code AS PostCode,
    sa.address,
    -- 處理個人照片檔案關聯
    CASE 
        WHEN sa.picinfo IS NOT NULL AND sa.picinfo != '' 
        THEN (SELECT TOP 1 fe.Id FROM FileEntry fe WHERE fe.FileName = sa.picinfo)
        ELSE NULL 
    END AS ProfilePhotoFileId,
    ISNULL(sa.sequence, 0) AS SortOrder,
    COALESCE(sa.lan, 'zh-TW') AS Language,
    1 AS IsSystemAdmin,  -- 後台帳號都是管理員
    0 AS IsSchoolPartner,
    0 AS IsEpaUser,
    0 AS IsGuidanceTeam,
    -- 時間戳轉換
    CASE 
        WHEN sa.createdate IS NOT NULL AND sa.createdate > 0 
        THEN DATEADD(second, sa.createdate, '1970-01-01 00:00:00')
        ELSE GETDATE()
    END AS CreatedTime,
    CASE 
        WHEN sa.updatedate IS NOT NULL AND sa.updatedate > 0 
        THEN DATEADD(second, sa.updatedate, '1970-01-01 00:00:00')
        ELSE GETDATE()
    END AS UpdatedTime,
    CASE WHEN sa.isuse = 1 THEN 1 ELSE 0 END AS Status,
    1 AS ReviewStatus  -- 後台帳號預設為已審核
FROM [EcoCampus_Maria3].[dbo].[sys_account] sa
WHERE sa.sid IS NOT NULL 
  AND sa.account IS NOT NULL 
  AND sa.account != ''
  AND NOT EXISTS (SELECT 1 FROM Accounts WHERE AccountId = -(sa.sid));  -- 避免重複

-- 關閉 IDENTITY_INSERT
SET IDENTITY_INSERT Accounts OFF;

PRINT '後台管理帳號遷移完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';

-- 建立後台帳號的群組對應
INSERT INTO account_permission_group (
    accountSid, groupSid, createTime, createUser, updateTime, updateUser, dataStatus
)
SELECT DISTINCT
    -(sa.sid) as accountSid,
    sa.groups_sid as groupSid,
    GETDATE() as createTime,
    1 as createUser,
    GETDATE() as updateTime,
    1 as updateUser,
    1 as dataStatus
FROM [EcoCampus_Maria3].[dbo].[sys_account] sa
INNER JOIN permission_group pg ON pg.sid = sa.groups_sid
WHERE sa.sid IS NOT NULL
  AND sa.groups_sid IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM account_permission_group 
    WHERE accountSid = -(sa.sid) AND groupSid = sa.groups_sid
  );

PRINT '後台帳號群組對應完成: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' 筆';

-- 檢查結果
PRINT '=== 遷移結果 ===';
SELECT 
    '後台管理帳號' as 類型, 
    COUNT(*) as 數量 
FROM Accounts 
WHERE AccountId < 0;

SELECT 
    AccountId, Username, email, IsSystemAdmin 
FROM Accounts 
WHERE AccountId < 0 
ORDER BY AccountId;

GO