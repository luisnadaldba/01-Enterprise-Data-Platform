/* ============================================================================
   ATLAS COMMERCE
   Schema Deployment Script
   ============================================================================

   Script Name   : 02-Create-AtlasCommerce-Schema.sql
   Version       : 1.0.0
   Target        : AtlasCommerce
   Purpose       : Create and validate business domain schemas
   Rerunnable    : Yes

   Schemas:
       reference
       customer
       catalog
       sales
       inventory

   Deployment principles:
       - Safe to rerun
       - Validate before create
       - Never drop or replace schemas automatically
       - Abort on unexpected database state
       - Produce standardized deployment messages

   Status legend:
       [+] Created
       [•] Validated / already compliant
       [~] Changed
       [-] Removed
       [!] Warning / manual review
       [X] Error / rollback
   ============================================================================ */

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @ScriptVersion nvarchar(20)  = N'1.0.0';
DECLARE @ScriptName    sysname       = N'02-Create-AtlasCommerce-Schema.sql';
DECLARE @DatabaseName  sysname       = N'AtlasCommerce';
DECLARE @StartTime     datetime2(0)  = SYSDATETIME();

PRINT N'==============================================================================';
PRINT N' ATLAS COMMERCE - SCHEMA DEPLOYMENT';
PRINT N'==============================================================================';
PRINT N'';
PRINT N' Script Version   : ' + @ScriptVersion;
PRINT N' Script Name      : ' + @ScriptName;
PRINT N' Started At       : ' + CONVERT(nvarchar(19), @StartTime, 120);
PRINT N' Server           : ' + CONVERT(nvarchar(128), SERVERPROPERTY('MachineName'));
PRINT N' Instance         : ' + COALESCE(
    CONVERT(nvarchar(128), SERVERPROPERTY('InstanceName')),
    N'MSSQLSERVER'
);
PRINT N' Executed By      : ' + ORIGINAL_LOGIN();
PRINT N' Target Database  : ' + @DatabaseName;
PRINT N'==============================================================================';

PRINT N'';

PRINT N' PRE-DEPLOYMENT VALIDATION';
PRINT N'------------------------------------------------------------------------------';

IF DB_ID(@DatabaseName) IS NULL
BEGIN
    PRINT N'[X] Target database not found      : ' + @DatabaseName;
    THROW 50010, 'Target database does not exist. Run the database deployment script first.', 1;
END;

PRINT N'[•] Database existence validated       : ' + @DatabaseName;

DECLARE @DatabaseState  nvarchar(60);
DECLARE @Sql            nvarchar(max);
DECLARE @HasPermission  int;

SELECT @DatabaseState = state_desc
FROM sys.databases
WHERE name = @DatabaseName;

IF @DatabaseState <> N'ONLINE'
BEGIN
    PRINT N'[X] Database state invalid          : ' + COALESCE(@DatabaseState, N'UNKNOWN');

    THROW 50011,
        'Target database is not ONLINE. Manual review is required before deployment.',
        1;
END;

PRINT N'[•] Database state validated           : ONLINE';

SET @Sql = N'
USE ' + QUOTENAME(@DatabaseName) + N';

SELECT @PermissionResult =
    HAS_PERMS_BY_NAME(DB_NAME(), ''DATABASE'', ''CREATE SCHEMA'');
';

EXEC sys.sp_executesql
    @Sql,
    N'@PermissionResult int OUTPUT',
    @PermissionResult = @HasPermission OUTPUT;

IF ISNULL(@HasPermission, 0) <> 1
BEGIN
    PRINT N'[X] CREATE SCHEMA permission invalid : Not available';

    THROW 50012,
        'CREATE SCHEMA permission is required in the target database.',
        1;
END;

PRINT N'[•] CREATE SCHEMA permission validated : Available';

PRINT N'';

PRINT N' SCHEMA DEPLOYMENT';
PRINT N'------------------------------------------------------------------------------';

DROP TABLE IF EXISTS #MissingSchemas;
DROP TABLE IF EXISTS #ExpectedSchemas;

CREATE TABLE #ExpectedSchemas
(
    SchemaName sysname NOT NULL PRIMARY KEY
);

INSERT INTO #ExpectedSchemas (SchemaName)
VALUES
    (N'reference'),
    (N'customer'),
    (N'catalog'),
    (N'sales'),
    (N'inventory');

DECLARE @SchemaName sysname;

DECLARE SchemaCursor CURSOR LOCAL FAST_FORWARD
FOR
    SELECT SchemaName
    FROM #ExpectedSchemas
    ORDER BY SchemaName;

OPEN SchemaCursor;

FETCH NEXT FROM SchemaCursor
INTO @SchemaName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Sql = N'
    USE ' + QUOTENAME(@DatabaseName) + N';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.schemas
        WHERE name = @TargetSchema
    )
    BEGIN
        DECLARE @CreateSchemaSql nvarchar(max);

        SET @CreateSchemaSql =
            N''CREATE SCHEMA '' + QUOTENAME(@TargetSchema) + N'';'';

        EXEC sys.sp_executesql @CreateSchemaSql;

        PRINT N''[+] Schema created                    : '' + @TargetSchema;
    END
    ELSE
    BEGIN
        PRINT N''[•] Schema already exists             : '' + @TargetSchema;
    END;
    ';

    EXEC sys.sp_executesql
        @Sql,
        N'@TargetSchema sysname',
        @TargetSchema = @SchemaName;

    FETCH NEXT FROM SchemaCursor
    INTO @SchemaName;
END;

CLOSE SchemaCursor;
DEALLOCATE SchemaCursor;

PRINT N'';
PRINT N' POST-DEPLOYMENT VALIDATION';
PRINT N'------------------------------------------------------------------------------';

DECLARE @ExpectedSchemaCount int;

SELECT @ExpectedSchemaCount = COUNT(*)
FROM #ExpectedSchemas;

PRINT N'[•] Expected schema count validated    : '
    + CONVERT(nvarchar(10), @ExpectedSchemaCount);

DECLARE @ActualSchemaCount int;

SET @Sql = N'
USE ' + QUOTENAME(@DatabaseName) + N';

SELECT @SchemaCount = COUNT(*)
FROM sys.schemas AS S
INNER JOIN #ExpectedSchemas AS E
    ON E.SchemaName = S.name;
';

EXEC sys.sp_executesql
    @Sql,
    N'@SchemaCount int OUTPUT',
    @SchemaCount = @ActualSchemaCount OUTPUT;

PRINT N'[•] Actual schema count validated      : '
    + CONVERT(nvarchar(10), @ActualSchemaCount);

CREATE TABLE #MissingSchemas
(
    SchemaName sysname NOT NULL PRIMARY KEY
);

SET @Sql = N'
USE ' + QUOTENAME(@DatabaseName) + N';

INSERT INTO #MissingSchemas (SchemaName)
SELECT E.SchemaName
FROM #ExpectedSchemas AS E
WHERE NOT EXISTS
(
    SELECT 1
    FROM sys.schemas AS S
    WHERE S.name = E.SchemaName
);
';

EXEC sys.sp_executesql @Sql;

DECLARE @MissingSchemaCount int;

SELECT @MissingSchemaCount = COUNT(*)
FROM #MissingSchemas;

PRINT N' Missing schema count                  : '
    + CONVERT(nvarchar(10), @MissingSchemaCount);

DECLARE @MissingSchemaName sysname;

DECLARE MissingSchemaCursor CURSOR LOCAL FAST_FORWARD
FOR
    SELECT SchemaName
    FROM #MissingSchemas
    ORDER BY SchemaName;

OPEN MissingSchemaCursor;

FETCH NEXT FROM MissingSchemaCursor
INTO @MissingSchemaName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT N'[X] Missing schema                     : ' + @MissingSchemaName;

    FETCH NEXT FROM MissingSchemaCursor
    INTO @MissingSchemaName;
END;

CLOSE MissingSchemaCursor;
DEALLOCATE MissingSchemaCursor;

IF @MissingSchemaCount > 0
BEGIN
    THROW 50013,
        'Post-deployment validation failed. One or more expected schemas are missing.',
        1;
END;

PRINT N'[•] Schema deployment validated        : SUCCESS';

DROP TABLE IF EXISTS #MissingSchemas;
DROP TABLE IF EXISTS #ExpectedSchemas;

