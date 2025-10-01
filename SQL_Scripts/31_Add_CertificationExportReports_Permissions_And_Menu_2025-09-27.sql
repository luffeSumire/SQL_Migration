/*
  為新的管理頁面添加權限(R/C/U/D)和菜單項目：/certifications/export-reports
  - 安全可重複執行（冪等）：插入前檢查是否存在
  - 可選通過@groupCode變數授予特定權限組權限

  執行於：管理資料庫 (Ecocampus_*)。執行前請檢查@groupCode。
*/

SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRAN;

    DECLARE @now datetime2(7) = SYSDATETIME();
    DECLARE @route varchar(200) = '/certifications/export-reports';
    DECLARE @actions TABLE (action char(1) PRIMARY KEY);
    INSERT INTO @actions(action) VALUES ('R'),('C'),('U'),('D');

    /* 如果權限不存在則插入權限 */
    DECLARE @isIdentity bit = CASE WHEN COLUMNPROPERTY(OBJECT_ID('dbo.permission'),'sid','IsIdentity') = 1 THEN 1 ELSE 0 END;

    DECLARE @act char(1);
    DECLARE cur CURSOR LOCAL FAST_FORWARD FOR SELECT action FROM @actions;
    OPEN cur;
    FETCH NEXT FROM cur INTO @act;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.[permission] WITH (UPDLOCK, HOLDLOCK) WHERE [route] = @route AND [action] = @act)
        BEGIN
            IF @isIdentity = 1
            BEGIN
                INSERT INTO dbo.[permission]
                    ([route],[action],[isDefault],[sequence],[createTime],[createUser],[updateTime],[updateUser],[dataStatus])
                VALUES
                    (@route,@act,0,0,@now,1,@now,1,1);
            END
            ELSE
            BEGIN
                INSERT INTO dbo.[permission]
                    ([sid],[route],[action],[isDefault],[sequence],[createTime],[createUser],[updateTime],[updateUser],[dataStatus])
                VALUES
                    ((SELECT ISNULL(MAX([sid]),0)+1 FROM dbo.[permission]), @route,@act,0,0,@now,1,@now,1,1);
            END
        END
        FETCH NEXT FROM cur INTO @act;
    END
    CLOSE cur; DEALLOCATE cur;

    /* 確保所有權限組預設都將這些權限映射為禁用狀態(allow = 0) */
    ;WITH Perms AS (
        SELECT p.sid
        FROM dbo.[permission] p
        WHERE p.[route] = @route AND p.[action] IN (SELECT action FROM @actions)
    )
    INSERT INTO dbo.permission_group_map ([groupSid],[permissionSid],[allow],[createTime],[createUser],[updateTime],[updateUser],[dataStatus])
    SELECT g.sid, pr.sid, 0, @now, 1, @now, 1, 1
    FROM dbo.permission_group g
    CROSS JOIN Perms pr
    WHERE g.dataStatus = 1
      AND NOT EXISTS (
            SELECT 1 FROM dbo.permission_group_map m
            WHERE m.groupSid = g.sid AND m.permissionSid = pr.sid
      );

    -- /* 可選將一個權限組提升為啟用狀態(allow = 1) */
    -- DECLARE @groupCode varchar(100) = NULL; -- 例如 'ADMIN' 或您的目標權限組代碼；設為NULL則跳過授予
    -- IF @groupCode IS NOT NULL
    -- BEGIN
    --     DECLARE @groupSid bigint = (
    --         SELECT TOP(1) g.sid FROM dbo.permission_group g WHERE g.groupCode = @groupCode AND g.dataStatus = 1
    --     );

    --     IF @groupSid IS NOT NULL
    --     BEGIN
    --         /* 為目標權限組Upsert allow=1 */
    --         MERGE dbo.permission_group_map AS tgt
    --         USING (
    --             SELECT @groupSid AS groupSid, p.sid AS permissionSid
    --             FROM dbo.[permission] p
    --             WHERE p.[route] = @route AND p.[action] IN (SELECT action FROM @actions)
    --         ) AS src
    --         ON (tgt.groupSid = src.groupSid AND tgt.permissionSid = src.permissionSid)
    --         WHEN MATCHED THEN
    --             UPDATE SET allow = 1, updateTime = @now, updateUser = 1
    --         WHEN NOT MATCHED THEN
    --             INSERT ([groupSid],[permissionSid],[allow],[createTime],[createUser],[updateTime],[updateUser],[dataStatus])
    --             VALUES (src.groupSid, src.permissionSid, 1, @now, 1, @now, 1, 1);
    --     END
    -- END

    -- /* 如果不存在則插入側邊欄菜單項目 */
    -- DECLARE @menuLink varchar(255) = '/certifications/export-reports';
    -- DECLARE @menuTitle nvarchar(100) = N'認證匯出報告';
    -- DECLARE @menuIcon varchar(100) = '';
    -- DECLARE @menuSort int = 50;  -- 根據需要調整

    -- DECLARE @parentId varchar(36);
    -- -- 嘗試查找父分類（如果存在）（可選）
    -- SELECT TOP(1) @parentId = mi.id
    -- FROM dbo.MenuItems mi
    -- WHERE mi.title = N'認證管理' OR mi.link LIKE '/certifications%'
    -- ORDER BY CASE WHEN mi.title = N'認證管理' THEN 0 ELSE 1 END, mi.sort_order;

    -- IF NOT EXISTS (SELECT 1 FROM dbo.MenuItems WITH (UPDLOCK, HOLDLOCK) WHERE [link] = @menuLink)
    -- BEGIN
    --     INSERT INTO dbo.MenuItems ([id],[title],[link],[icon],[parent_id],[sort_order],[status])
    --     VALUES (CONVERT(varchar(36), NEWID()), @menuTitle, @menuLink, @menuIcon, @parentId, @menuSort, 1);
    -- END

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    DECLARE @err nvarchar(4000) = ERROR_MESSAGE();
    RAISERROR(N'[Add_CertificationExportReports] 失敗: %s', 16, 1, @err);
END CATCH;
