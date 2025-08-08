USE EcoCampus_PreProduction
GO

-- 為系統管理員群組 (sid=3) 設置完整權限
INSERT INTO permission_group_map (
    groupSid, permissionSid, allow,
    createTime, createUser, updateTime, updateUser, dataStatus
)
SELECT TOP 10
    3 as groupSid,
    p.sid as permissionSid,
    1 as allow,
    GETDATE() as createTime,
    1 as createUser,
    GETDATE() as updateTime,
    1 as updateUser,
    1 as dataStatus
FROM permission p
WHERE p.route NOT LIKE '%sample%'
ORDER BY p.sid

-- 檢查結果
SELECT COUNT(*) as total_mappings FROM permission_group_map
SELECT * FROM permission_group_map