USE EcoCampus_PreProduction;

-- 檢查最小必要欄位
SELECT TOP 1 
    AccountId, SchoolId, Username, password, PasswordSalt, email, CreatedTime, UpdatedTime, Status, ReviewStatus
FROM Accounts 
WHERE AccountId = 1;

-- 嘗試插入最簡單的後台帳號
SET IDENTITY_INSERT Accounts ON;

INSERT INTO Accounts (
    AccountId, Username, CreatedTime, UpdatedTime, Status, ReviewStatus
) VALUES (
    -1, 'test_admin', GETDATE(), GETDATE(), 1, 1
);

SET IDENTITY_INSERT Accounts OFF;

-- 檢查結果
SELECT AccountId, Username FROM Accounts WHERE AccountId < 0;