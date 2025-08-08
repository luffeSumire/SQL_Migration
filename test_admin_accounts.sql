USE EcoCampus_PreProduction;

-- 測試後台帳號遷移
PRINT '測試後台帳號遷移...';

-- 檢查來源資料
SELECT 'source_sys_account' as type, COUNT(*) as count FROM [EcoCampus_Maria3].[dbo].[sys_account];

-- 手動插入一個測試帳號
INSERT INTO Accounts (
    AccountId, Username, password, PasswordSalt, email, IsSystemAdmin, 
    CreatedTime, UpdatedTime, Status, ReviewStatus
) 
SELECT TOP 1
    -(sa.sid) AS AccountId,
    sa.account AS Username,
    sa.password,
    sa.password_salt AS PasswordSalt,
    sa.email,
    1 AS IsSystemAdmin,
    GETDATE() AS CreatedTime,
    GETDATE() AS UpdatedTime,
    1 AS Status,
    1 AS ReviewStatus
FROM [EcoCampus_Maria3].[dbo].[sys_account] sa
WHERE sa.sid = 1 
  AND NOT EXISTS (SELECT 1 FROM Accounts WHERE AccountId = -(sa.sid));

-- 檢查結果
SELECT AccountId, Username, IsSystemAdmin FROM Accounts WHERE AccountId < 0;