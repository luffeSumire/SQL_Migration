/*
  Add permissions (R/C/U/D) and menu item for the new Admin page: /maintenance/eco-schools
  - Safe to re-run (idempotent): checks for existence before insert
  - Optionally grants the new permissions to a target permission group via @groupCode

  Run on: Admin database (Ecocampus_*). Review @groupCode before executing.
*/

SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRAN;

    DECLARE @now datetime2(7) = SYSDATETIME();
    DECLARE @route varchar(200) = '/maintenance/eco-schools';
    DECLARE @actions TABLE (action char(1) PRIMARY KEY);
    INSERT INTO @actions(action) VALUES ('R'),('C'),('U'),('D');

    /* Insert permissions if missing */
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

    /* Ensure ALL groups have these permissions mapped as disabled (allow = 0) by default */
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

    /* Optionally elevate one group to enabled (allow = 1) */
    DECLARE @groupCode varchar(100) = NULL; -- e.g. 'ADMIN' or your target group code; set to NULL to skip granting
    IF @groupCode IS NOT NULL
    BEGIN
        DECLARE @groupSid bigint = (
            SELECT TOP(1) g.sid FROM dbo.permission_group g WHERE g.groupCode = @groupCode AND g.dataStatus = 1
        );

        IF @groupSid IS NOT NULL
        BEGIN
            /* Upsert allow=1 for the target group */
            MERGE dbo.permission_group_map AS tgt
            USING (
                SELECT @groupSid AS groupSid, p.sid AS permissionSid
                FROM dbo.[permission] p
                WHERE p.[route] = @route AND p.[action] IN (SELECT action FROM @actions)
            ) AS src
            ON (tgt.groupSid = src.groupSid AND tgt.permissionSid = src.permissionSid)
            WHEN MATCHED THEN
                UPDATE SET allow = 1, updateTime = @now, updateUser = 1
            WHEN NOT MATCHED THEN
                INSERT ([groupSid],[permissionSid],[allow],[createTime],[createUser],[updateTime],[updateUser],[dataStatus])
                VALUES (src.groupSid, src.permissionSid, 1, @now, 1, @now, 1, 1);
        END
    END

    /* Insert Sidebar menu item if missing */
    DECLARE @menuLink varchar(255) = '/maintenance/eco-schools';
    DECLARE @menuTitle nvarchar(100) = N'生態校園';
    DECLARE @menuIcon varchar(100) = 'IconSchool';
    DECLARE @menuSort int = 120;  -- adjust as needed

    DECLARE @parentId varchar(36);
    -- Try to find a parent category if it exists (optional)
    SELECT TOP(1) @parentId = mi.id
    FROM dbo.MenuItems mi
    WHERE mi.title = N'基本資料維護' OR mi.link LIKE '/maintenance%'
    ORDER BY CASE WHEN mi.title = N'基本資料維護' THEN 0 ELSE 1 END, mi.sort_order;

    IF NOT EXISTS (SELECT 1 FROM dbo.MenuItems WITH (UPDLOCK, HOLDLOCK) WHERE [link] = @menuLink)
    BEGIN
        INSERT INTO dbo.MenuItems ([id],[title],[link],[icon],[parent_id],[sort_order],[status])
        VALUES (CONVERT(varchar(36), NEWID()), @menuTitle, @menuLink, @menuIcon, @parentId, @menuSort, 1);
    END

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRAN;
    DECLARE @err nvarchar(4000) = ERROR_MESSAGE();
    RAISERROR(N'[Add_EcoSchools] Failed: %s', 16, 1, @err);
END CATCH;
