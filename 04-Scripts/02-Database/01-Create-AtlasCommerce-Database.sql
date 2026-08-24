/******************************************************************************
 Project      : Atlas Commerce
 Repository   : Atlas Engineering / Enterprise Data Platform
 Script       : 01-Create-AtlasCommerce-Database.sql
 Purpose      : Create, configure, and validate the AtlasCommerce database.
 Target       : SQL Server 2025
 Database     : master / AtlasCommerce
 Version      : 1.0.0
 Rerunnable   : Yes

 Description
 ------------------------------------------------------------------------------
 This script creates and configures the AtlasCommerce database used by the
 Enterprise Data Platform project.

 The script is designed to be rerunnable and must validate the current
 environment before applying changes.

 Database creation is intentionally separated from:
   - Database object deployment (DDL)
   - Reference and sample data deployment (DML)
   - Security configuration
   - Maintenance configuration

 Execution Status
 ------------------------------------------------------------------------------
 [+] Created                  Object or configuration was created.
 [•] Validated                Object exists and is already compliant.
 [~] Changed                  Existing configuration was modified.
 [-] Removed                  Object or configuration was removed.
 [!] Warning                  Manual review or attention is required.
 [X] Error                    Execution failed and rollback/error handling
                              was triggered.

 Design Principles
 ------------------------------------------------------------------------------
 - Safe rerun / idempotent execution
 - Explicit validation before modification
 - Detailed execution output
 - Fixed-size file growth rather than percentage growth
 - AUTO_SHRINK always disabled
 - Configuration decisions documented in the repository
 - Database creation separated from DDL and DML deployment
 - Production-oriented architecture using a demonstration-scale dataset
******************************************************************************/

/* ============================================================================
   00 - Execution Context and Safety
   ============================================================================ */

USE [master];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

/* ============================================================================
   01 - Deployment Metadata
   ============================================================================ */

DECLARE @DatabaseName   sysname       = N'AtlasCommerce';
DECLARE @ScriptName     nvarchar(128) = N'01-Create-AtlasCommerce-Database.sql';
DECLARE @ScriptVersion  varchar(20)   = '1.0.0';
DECLARE @StartTime      datetime2(0)  = SYSDATETIME();

PRINT N'==============================================================================';
PRINT N' ATLAS COMMERCE - DATABASE DEPLOYMENT';
PRINT N'==============================================================================';
PRINT N'';
PRINT N' Script Version  : ' + @ScriptVersion;
PRINT N' Script Name     : ' + @ScriptName;
PRINT N' Started At      : ' + CONVERT(nvarchar(19), @StartTime, 120);
PRINT N' Server          : ' + CONVERT(nvarchar(128), SERVERPROPERTY('MachineName'));
PRINT N' Instance        : ' + COALESCE(
                                    CONVERT(nvarchar(128), SERVERPROPERTY('InstanceName')),
                                    N'MSSQLSERVER'
                                );
PRINT N' Executed By     : ' + ORIGINAL_LOGIN();
PRINT N' Target Database : ' + @DatabaseName;
PRINT N'==============================================================================';
PRINT N'';

/* ============================================================================
   02 - Pre-Deployment Validation
   ============================================================================ */

PRINT N'';
PRINT N' PRE-DEPLOYMENT VALIDATION';
PRINT N'------------------------------------------------------------------------------';

DECLARE @ProductVersion nvarchar(128) =
    CONVERT(nvarchar(128), SERVERPROPERTY('ProductVersion'));

DECLARE @ProductLevel nvarchar(128) =
    CONVERT(nvarchar(128), SERVERPROPERTY('ProductLevel'));

DECLARE @Edition nvarchar(128) =
    CONVERT(nvarchar(128), SERVERPROPERTY('Edition'));

DECLARE @EngineEdition int =
    CONVERT(int, SERVERPROPERTY('EngineEdition'));

DECLARE @MajorVersion int =
    TRY_CONVERT(int, PARSENAME(@ProductVersion, 4));

IF @MajorVersion IS NULL
BEGIN
    PRINT N'[X] Unable to determine SQL Server major version.';
    THROW 50001, 'Unable to determine SQL Server major version.', 1;
END;

IF @MajorVersion <> 17
BEGIN
    PRINT N'[X] Unsupported SQL Server version: ' + @ProductVersion;
    PRINT N'    Required major version: 17 (SQL Server 2025).';

    THROW 50002, 'This deployment requires SQL Server 2025.', 1;
END;

PRINT N'[•] SQL Server version validated : ' + @ProductVersion;
PRINT N'[•] Product level validated      : ' + @ProductLevel;
PRINT N'    Edition detected             : ' + @Edition;

DECLARE @CanCreateDatabase int =
    HAS_PERMS_BY_NAME(NULL, NULL, 'CREATE ANY DATABASE');

IF ISNULL(@CanCreateDatabase, 0) <> 1
BEGIN
    PRINT N'[X] Required permission not available: CREATE ANY DATABASE.';
    THROW 50003, 'CREATE ANY DATABASE permission is required for this deployment.', 1;
END;

PRINT N'[•] Permission validated         : CREATE ANY DATABASE';

DECLARE @DatabaseId int =
    DB_ID(@DatabaseName);

DECLARE @DatabaseState nvarchar(60);

IF @DatabaseId IS NULL
BEGIN
    PRINT N'    Database detected             : Not found';
    PRINT N'    Deployment action             : Creation required';
END
ELSE
BEGIN
    SELECT @DatabaseState = [state_desc]
    FROM sys.databases
    WHERE database_id = @DatabaseId;

    IF @DatabaseState <> N'ONLINE'
    BEGIN
        PRINT N'[X] Database state validation failed.';
        PRINT N'    Database                       : ' + @DatabaseName;
        PRINT N'    Current state                  : ' + COALESCE(@DatabaseState, N'UNKNOWN');
        PRINT N'    Required state                 : ONLINE';

        THROW 50004, 'Existing database is not ONLINE. Deployment aborted.', 1;
    END;

    PRINT N'[•] Database existence validated : ' + @DatabaseName;
    PRINT N'[•] Database state validated     : ONLINE';
END;

/* ============================================================================
   03 - Database Storage Configuration
   ============================================================================ */

DECLARE @DataPath nvarchar(260) =
    N'C:\Projects\Atlas Engineering\01-Enterprise-Data-Platform\02-Database\Data\';

DECLARE @LogPath nvarchar(260) =
    N'C:\Projects\Atlas Engineering\01-Enterprise-Data-Platform\02-Database\Log\';

DECLARE @PrimaryInitialSizeMB int = 128;
DECLARE @PrimaryMaxSizeMB     int = 512;

DECLARE @DataInitialSizeMB    int = 256;
DECLARE @DataMaxSizeMB        int = 1536;

DECLARE @LogInitialSizeMB     int = 256;
DECLARE @LogMaxSizeMB         int = 2048;

DECLARE @FileGrowthMB         int = 128;

PRINT N'';
PRINT N' DATABASE STORAGE CONFIGURATION';
PRINT N'------------------------------------------------------------------------------';
PRINT N'    Data path                    : ' + @DataPath;
PRINT N'    Log path                     : ' + @LogPath;
PRINT N'    File growth                  : ' + CONVERT(nvarchar(20), @FileGrowthMB) + N' MB';
PRINT N'    Base database storage budget : Approximately 4 GB maximum';

DECLARE @DataPathExists int;
DECLARE @LogPathExists  int;

SELECT @DataPathExists = file_is_a_directory
FROM sys.dm_os_file_exists(@DataPath);

SELECT @LogPathExists = file_is_a_directory
FROM sys.dm_os_file_exists(@LogPath);

IF ISNULL(@DataPathExists, 0) <> 1
BEGIN
    PRINT N'[X] Data path validation failed.';
    PRINT N'    Path                           : ' + @DataPath;

    THROW 50005, 'SQL Server cannot access the configured data directory.', 1;
END;

PRINT N'[•] Data path validated          : Accessible';

IF ISNULL(@LogPathExists, 0) <> 1
BEGIN
    PRINT N'[X] Log path validation failed.';
    PRINT N'    Path                           : ' + @LogPath;

    THROW 50006, 'SQL Server cannot access the configured log directory.', 1;
END;

PRINT N'[•] Log path validated           : Accessible';


/* ============================================================================
   04 - Database Creation
   ============================================================================ */

PRINT N'';
PRINT N' DATABASE CREATION';
PRINT N'------------------------------------------------------------------------------';
PRINT N'    PRIMARY                       : AtlasCommerce.mdf';
PRINT N'    FG_CORE                       : AtlasCommerce_Core.ndf';
PRINT N'    LOG                           : AtlasCommerce_log.ldf';

DECLARE @PrimaryFile nvarchar(520) =
    @DataPath + N'AtlasCommerce.mdf';

DECLARE @CoreFile nvarchar(520) =
    @DataPath + N'AtlasCommerce_Core.ndf';

DECLARE @LogFile nvarchar(520) =
    @LogPath + N'AtlasCommerce_log.ldf';

DECLARE @ExistingPhysicalFiles int = 0;

IF @DatabaseId IS NULL
BEGIN
    SELECT @ExistingPhysicalFiles =
          ISNULL((SELECT file_exists FROM sys.dm_os_file_exists(@PrimaryFile)), 0)
        + ISNULL((SELECT file_exists FROM sys.dm_os_file_exists(@CoreFile)), 0)
        + ISNULL((SELECT file_exists FROM sys.dm_os_file_exists(@LogFile)), 0);

    IF @ExistingPhysicalFiles > 0
    BEGIN
        PRINT N'[X] Physical file validation failed.';
        PRINT N'    Database                       : Not found';
        PRINT N'    Existing target files          : '
            + CONVERT(nvarchar(10), @ExistingPhysicalFiles);
        PRINT N'    Required condition             : No target files may already exist';

        THROW 50007,
            'One or more target database files already exist. Deployment aborted.',
            1;
    END;

    PRINT N'[•] Physical file targets validated : Available';
END
ELSE
BEGIN
    PRINT N'    Physical file target check    : Skipped; existing database will be validated separately';
END;

IF @DatabaseId IS NULL
BEGIN
    DECLARE @Sql nvarchar(max);

SET @Sql =
    N'CREATE DATABASE ' + QUOTENAME(@DatabaseName) + N'
    ON PRIMARY
    (
        NAME = N''AtlasCommerce'',
        FILENAME = N''' + REPLACE(@PrimaryFile, '''', '''''') + N''',
        SIZE = ' + CONVERT(nvarchar(20), @PrimaryInitialSizeMB) + N'MB,
        MAXSIZE = ' + CONVERT(nvarchar(20), @PrimaryMaxSizeMB) + N'MB,
        FILEGROWTH = ' + CONVERT(nvarchar(20), @FileGrowthMB) + N'MB
    ),

    FILEGROUP [FG_CORE]
    (
        NAME = N''AtlasCommerce_Core'',
        FILENAME = N''' + REPLACE(@CoreFile, '''', '''''') + N''',
        SIZE = ' + CONVERT(nvarchar(20), @DataInitialSizeMB) + N'MB,
        MAXSIZE = ' + CONVERT(nvarchar(20), @DataMaxSizeMB) + N'MB,
        FILEGROWTH = ' + CONVERT(nvarchar(20), @FileGrowthMB) + N'MB
    )

    LOG ON
    (
        NAME = N''AtlasCommerce_log'',
        FILENAME = N''' + REPLACE(@LogFile, '''', '''''') + N''',
        SIZE = ' + CONVERT(nvarchar(20), @LogInitialSizeMB) + N'MB,
        MAXSIZE = ' + CONVERT(nvarchar(20), @LogMaxSizeMB) + N'MB,
        FILEGROWTH = ' + CONVERT(nvarchar(20), @FileGrowthMB) + N'MB
    );';

EXEC sys.sp_executesql @Sql;

IF DB_ID(@DatabaseName) IS NULL
BEGIN
    PRINT N'[X] Database creation validation failed.';
    THROW 50008, 'Database creation command completed but the database was not detected.', 1;
END;

PRINT N'[+] Database created              : ' + @DatabaseName;

END
ELSE
BEGIN
    PRINT N'[•] Database creation             : Already exists';
END;

/* ============================================================================
   05 - Existing Database Structure Validation
   ============================================================================ */

PRINT N'';
PRINT N' EXISTING DATABASE STRUCTURE VALIDATION';
PRINT N'------------------------------------------------------------------------------';

DECLARE @ValidationSql nvarchar(max);

SET @ValidationSql =
    N'USE ' + QUOTENAME(@DatabaseName) + N';

    DECLARE @MissingFilegroups int;

    SELECT @MissingFilegroups = COUNT(*)
    FROM
    (
        VALUES
            (N''PRIMARY''),
            (N''FG_CORE'')
    ) AS Expected(FilegroupName)
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM sys.filegroups AS FG
        WHERE FG.name = Expected.FilegroupName
    );

    IF @MissingFilegroups > 0
    BEGIN
        PRINT N''[X] Filegroup validation failed.'';
        PRINT N''    Missing filegroups               : ''
            + CONVERT(nvarchar(10), @MissingFilegroups);

        THROW 50009,
            ''One or more required filegroups are missing.'',
            1;
    END;

    PRINT N''[•] Filegroup structure validated     : PRIMARY, FG_CORE'';';

EXEC sys.sp_executesql @ValidationSql;

SET @ValidationSql =
    N'USE ' + QUOTENAME(@DatabaseName) + N';

    DECLARE @InvalidFiles int;

    SELECT @InvalidFiles = COUNT(*)
    FROM
    (
        VALUES
            (N''AtlasCommerce'',      N''ROWS'', N''PRIMARY''),
            (N''AtlasCommerce_Core'', N''ROWS'', N''FG_CORE''),
            (N''AtlasCommerce_log'',  N''LOG'',  NULL)
    ) AS Expected(LogicalName, FileType, FilegroupName)
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM sys.database_files AS DF
        LEFT JOIN sys.filegroups AS FG
            ON DF.data_space_id = FG.data_space_id
        WHERE DF.name = Expected.LogicalName
          AND DF.type_desc = Expected.FileType
          AND
          (
              (Expected.FileType = N''LOG'' AND DF.data_space_id = 0)
              OR
              (Expected.FileType = N''ROWS'' AND FG.name = Expected.FilegroupName)
          )
    );

    IF @InvalidFiles > 0
    BEGIN
        PRINT N''[X] Logical file structure validation failed.'';
        PRINT N''    Missing or mismatched files       : ''
            + CONVERT(nvarchar(10), @InvalidFiles);

        THROW 50010,
            ''One or more database files are missing or assigned incorrectly.'',
            1;
    END;

    PRINT N''[•] Logical file structure validated  : 3 files correctly assigned'';';

EXEC sys.sp_executesql @ValidationSql;

SET @ValidationSql =
    N'USE ' + QUOTENAME(@DatabaseName) + N';

    DECLARE @InvalidPhysicalPaths int;

    SELECT @InvalidPhysicalPaths = COUNT(*)
    FROM
    (
        VALUES
            (N''AtlasCommerce'',      N''' + REPLACE(@PrimaryFile, '''', '''''') + N'''),
            (N''AtlasCommerce_Core'', N''' + REPLACE(@CoreFile,    '''', '''''') + N'''),
            (N''AtlasCommerce_log'',  N''' + REPLACE(@LogFile,     '''', '''''') + N''')
    ) AS Expected(LogicalName, PhysicalName)
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM sys.database_files AS DF
        WHERE DF.name = Expected.LogicalName
          AND DF.physical_name = Expected.PhysicalName
    );

    IF @InvalidPhysicalPaths > 0
    BEGIN
        PRINT N''[X] Physical path validation failed.'';
        PRINT N''    Missing or mismatched paths       : ''
            + CONVERT(nvarchar(10), @InvalidPhysicalPaths);

        THROW 50011,
            ''One or more database files are located at an unexpected physical path.'',
            1;
    END;

    PRINT N''[•] Physical file paths validated     : 3 files correctly located'';';

EXEC sys.sp_executesql @ValidationSql;

SET @ValidationSql =
    N'USE ' + QUOTENAME(@DatabaseName) + N';

    DECLARE @InvalidFileSettings int;

    SELECT @InvalidFileSettings = COUNT(*)
    FROM
    (
        VALUES
            (N''AtlasCommerce'',      ' + CONVERT(nvarchar(20), @PrimaryMaxSizeMB)       + N', ' + CONVERT(nvarchar(20), @FileGrowthMB) + N'),
            (N''AtlasCommerce_Core'', ' + CONVERT(nvarchar(20), @DataMaxSizeMB)          + N', ' + CONVERT(nvarchar(20), @FileGrowthMB) + N'),
            (N''AtlasCommerce_log'',  ' + CONVERT(nvarchar(20), @LogMaxSizeMB)           + N', ' + CONVERT(nvarchar(20), @FileGrowthMB) + N')
    ) AS Expected(LogicalName, MaxSizeMB, GrowthMB)
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM sys.database_files AS DF
        WHERE DF.name = Expected.LogicalName
          AND DF.max_size / 128 = Expected.MaxSizeMB
          AND DF.is_percent_growth = 0
          AND DF.growth / 128 = Expected.GrowthMB
    );

    IF @InvalidFileSettings > 0
    BEGIN
        PRINT N''[X] File growth configuration validation failed.'';
        PRINT N''    Missing or mismatched settings    : ''
            + CONVERT(nvarchar(10), @InvalidFileSettings);

        THROW 50012,
            ''One or more database files have unexpected MAXSIZE or FILEGROWTH settings.'',
            1;
    END;

    PRINT N''[•] File growth settings validated    : MAXSIZE and FILEGROWTH compliant'';';

EXEC sys.sp_executesql @ValidationSql;

SET @ValidationSql =
    N'USE ' + QUOTENAME(@DatabaseName) + N';

    DECLARE @FilesBelowMinimumSize int;

    SELECT @FilesBelowMinimumSize = COUNT(*)
    FROM
    (
        VALUES
            (N''AtlasCommerce'',      ' + CONVERT(nvarchar(20), @PrimaryInitialSizeMB)       + N'),
            (N''AtlasCommerce_Core'', ' + CONVERT(nvarchar(20), @DataInitialSizeMB)          + N'),
            (N''AtlasCommerce_log'',  ' + CONVERT(nvarchar(20), @LogInitialSizeMB)           + N')
    ) AS Expected(LogicalName, MinimumSizeMB)
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM sys.database_files AS DF
        WHERE DF.name = Expected.LogicalName
          AND DF.size / 128 >= Expected.MinimumSizeMB
    );

    IF @FilesBelowMinimumSize > 0
    BEGIN
        PRINT N''[X] File size validation failed.'';
        PRINT N''    Files below minimum size          : ''
            + CONVERT(nvarchar(10), @FilesBelowMinimumSize);

        THROW 50013,
            ''One or more database files are smaller than the defined minimum size.'',
            1;
    END;

    PRINT N''[•] File size minimums validated      : All files at or above baseline'';';

EXEC sys.sp_executesql @ValidationSql;

/* ============================================================================
   06 - Database Options
   ============================================================================ */

PRINT N'';
PRINT N' DATABASE OPTIONS';
PRINT N'------------------------------------------------------------------------------';

DECLARE @AutoShrink bit;

SELECT @AutoShrink = is_auto_shrink_on
FROM sys.databases
WHERE name = @DatabaseName;

IF @AutoShrink = 1
BEGIN
    SET @Sql =
        N'ALTER DATABASE ' + QUOTENAME(@DatabaseName) + N'
          SET AUTO_SHRINK OFF;';

    EXEC sys.sp_executesql @Sql;

    SELECT @AutoShrink = is_auto_shrink_on
    FROM sys.databases
    WHERE name = @DatabaseName;

    IF @AutoShrink <> 0
    BEGIN
        PRINT N'[X] AUTO_SHRINK validation failed.';
        THROW 50014,
            'AUTO_SHRINK could not be configured as OFF.',
            1;
    END;

    PRINT N'[~] AUTO_SHRINK changed            : ON -> OFF';
END
ELSE
BEGIN
    PRINT N'[•] AUTO_SHRINK validated             : OFF';
END;

DECLARE @AutoUpdateStatistics bit;

SELECT @AutoUpdateStatistics = is_auto_update_stats_on
FROM sys.databases
WHERE name = @DatabaseName;

IF @AutoUpdateStatistics = 0
BEGIN
    SET @Sql =
        N'ALTER DATABASE ' + QUOTENAME(@DatabaseName) + N'
          SET AUTO_UPDATE_STATISTICS ON;';

    EXEC sys.sp_executesql @Sql;

    SELECT @AutoUpdateStatistics = is_auto_update_stats_on
    FROM sys.databases
    WHERE name = @DatabaseName;

    IF @AutoUpdateStatistics <> 1
    BEGIN
        PRINT N'[X] AUTO_UPDATE_STATISTICS validation failed.';
        THROW 50015,
            'AUTO_UPDATE_STATISTICS could not be configured as ON.',
            1;
    END;

    PRINT N'[~] AUTO_UPDATE_STATISTICS changed : OFF -> ON';
END
ELSE
BEGIN
    PRINT N'[•] AUTO_UPDATE_STATISTICS validated  : ON';
END;