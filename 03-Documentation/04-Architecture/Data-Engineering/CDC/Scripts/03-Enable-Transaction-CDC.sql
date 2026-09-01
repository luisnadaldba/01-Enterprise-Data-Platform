/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 03-Enable-Transaction-CDC.sql
    Version       : 1.1.0
    Target        : AtlasCommerce.sales.Transaction
    Purpose       : Enable, configure and validate SQL Server CDC for sales.Transaction
    Rerunnable    : Yes
    Destructive   : No

    Reconstruction Status
    --------------------------------------------------------------------------
    Consolidated/reconstructed from the approved Atlas Engineering CDC
    implementation evidence for sales.Transaction enablement (M01.10).

    Approved configuration
    --------------------------------------------------------------------------
    Source Schema        : sales
    Source Table         : Transaction
    Role Name            : NULL
    Supports Net Changes : 0
    Expected PK          : PK_TRN
    Expected Instance    : sales_Transaction
    Cleanup Retention    : 21600 minutes (15 days)
    Cleanup Threshold    : 4999

    Historical laboratory evidence
    --------------------------------------------------------------------------
    Initial observed Start LSN:
        0x0000002D0000A1390060

    The Start LSN above is historical evidence only. This script does not
    require a future execution to reproduce that value.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE @SourceSchema       sysname = N'sales';
DECLARE @SourceTable        sysname = N'Transaction';
DECLARE @CaptureInstance    sysname = N'sales_Transaction';
DECLARE @TargetRetention    int = 21600;
DECLARE @TargetThreshold    int = 4999;
DECLARE @CurrentRetention   int;
DECLARE @CurrentThreshold   int;
DECLARE @DatabaseId         int = DB_ID();

PRINT N'';
PRINT N'ATLAS ENGINEERING - ENABLE CDC FOR sales.Transaction';
PRINT N'============================================================';
PRINT N'';

PRINT N'[1] DEPENDENCY VALIDATION';
PRINT N'------------------------------------------------------------';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE name = DB_NAME()
      AND is_cdc_enabled = 1
)
BEGIN
    ;THROW 51020, N'Database-level CDC must be enabled before table-level CDC.', 1;
END;

IF OBJECT_ID(N'sales.[Transaction]', N'U') IS NULL
BEGIN
    ;THROW 51021, N'Required source table sales.Transaction does not exist.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.key_constraints AS kc
    WHERE kc.parent_object_id = OBJECT_ID(N'sales.[Transaction]')
      AND kc.type = N'PK'
      AND kc.name = N'PK_TRN'
)
BEGIN
    ;THROW 51022, N'Expected primary key PK_TRN was not found on sales.Transaction.', 1;
END;

PRINT N'[✓] Database CDC enabled.';
PRINT N'[✓] Source table present.';
PRINT N'[✓] Expected primary key PK_TRN present.';

PRINT N'';
PRINT N'[2] PRE-ENABLE STATE';
PRINT N'------------------------------------------------------------';

SELECT
    s.name             AS source_schema,
    t.name             AS source_table,
    t.is_tracked_by_cdc
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
WHERE t.object_id = OBJECT_ID(N'sales.[Transaction]');

PRINT N'';
PRINT N'[3] ENABLE TABLE CDC';
PRINT N'------------------------------------------------------------';

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @CaptureInstance
)
BEGIN
    EXEC sys.sp_cdc_enable_table
        @source_schema        = @SourceSchema,
        @source_name          = @SourceTable,
        @role_name            = NULL,
        @supports_net_changes = 0;

    PRINT N'[+] CDC enabled for sales.Transaction.';
END
ELSE
BEGIN
    PRINT N'[•] Capture instance sales_Transaction already exists. No change required.';
END;

PRINT N'';
PRINT N'[4] CAPTURE INSTANCE VALIDATION';
PRINT N'------------------------------------------------------------';

SELECT
    ct.capture_instance,
    OBJECT_SCHEMA_NAME(ct.source_object_id) AS source_schema,
    OBJECT_NAME(ct.source_object_id)        AS source_table,
    ct.start_lsn,
    ct.supports_net_changes,
    ct.index_name
FROM cdc.change_tables AS ct
WHERE ct.capture_instance = @CaptureInstance;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables AS ct
    WHERE ct.capture_instance = @CaptureInstance
      AND ct.source_object_id = OBJECT_ID(N'sales.[Transaction]')
      AND ct.supports_net_changes = 0
)
BEGIN
    ;THROW 51023, N'sales.Transaction CDC capture instance validation failed.', 1;
END;

PRINT N'';
PRINT N'[5] CONFIGURE CDC CLEANUP RETENTION';
PRINT N'------------------------------------------------------------';

SELECT
    @CurrentRetention = cj.retention,
    @CurrentThreshold = cj.threshold
FROM msdb.dbo.cdc_jobs AS cj
WHERE cj.database_id = @DatabaseId
  AND cj.job_type = N'cleanup';

IF @CurrentRetention IS NULL
BEGIN
    ;THROW 51024, N'CDC cleanup job configuration was not found for AtlasCommerce.', 1;
END;

SELECT
    DB_NAME(cj.database_id) AS database_name,
    cj.job_type,
    sj.name                 AS job_name,
    cj.retention,
    cj.threshold
FROM msdb.dbo.cdc_jobs AS cj
LEFT JOIN msdb.dbo.sysjobs AS sj
    ON sj.job_id = cj.job_id
WHERE cj.database_id = @DatabaseId
  AND cj.job_type = N'cleanup';

IF @CurrentRetention = @TargetRetention
   AND @CurrentThreshold = @TargetThreshold
BEGIN
    PRINT N'[•] CDC cleanup retention is already 21600 minutes (15 days).';
    PRINT N'[•] CDC cleanup threshold is already 4999.';
    PRINT N'[•] No cleanup configuration change required.';
END
ELSE
BEGIN
    IF @CurrentRetention <> @TargetRetention
        PRINT N'[+] Updating CDC cleanup retention to 21600 minutes (15 days)...';

    IF @CurrentThreshold <> @TargetThreshold
        PRINT N'[+] Updating CDC cleanup threshold to 4999...';

    EXEC sys.sp_cdc_change_job
        @job_type = N'cleanup',
        @retention = @TargetRetention,
        @threshold = @TargetThreshold;

    PRINT N'[+] CDC cleanup configuration updated.';
END;

SELECT
    @CurrentRetention = cj.retention,
    @CurrentThreshold = cj.threshold
FROM msdb.dbo.cdc_jobs AS cj
WHERE cj.database_id = @DatabaseId
  AND cj.job_type = N'cleanup';

IF @CurrentRetention <> @TargetRetention
BEGIN
    ;THROW 51025, N'CDC cleanup retention validation failed. Expected 21600 minutes.', 1;
END;

IF @CurrentThreshold <> @TargetThreshold
BEGIN
    ;THROW 51026, N'CDC cleanup threshold validation failed. Expected 4999.', 1;
END;

PRINT N'[✓] CDC cleanup retention validated: 21600 minutes (15 days).';
PRINT N'[✓] CDC cleanup threshold validated: 4999.';

PRINT N'';
PRINT N'[6] CAPTURED COLUMNS';
PRINT N'------------------------------------------------------------';

SELECT
    cc.column_ordinal,
    cc.column_name,
    cc.column_type AS data_type
FROM cdc.captured_columns AS cc
INNER JOIN cdc.change_tables AS ct
    ON ct.object_id = cc.object_id
WHERE ct.capture_instance = @CaptureInstance
ORDER BY cc.column_ordinal;

DECLARE @CapturedColumnCount int;

SELECT
    @CapturedColumnCount = COUNT(*)
FROM cdc.captured_columns AS cc
INNER JOIN cdc.change_tables AS ct
    ON ct.object_id = cc.object_id
WHERE ct.capture_instance = @CaptureInstance;

IF @CapturedColumnCount <> 9
BEGIN
    ;THROW 51027, N'Expected 9 captured columns for sales.Transaction.', 1;
END;

PRINT N'';
PRINT N'[7] GENERATED CDC OBJECTS';
PRINT N'------------------------------------------------------------';

SELECT
    OBJECT_ID(N'cdc.sales_Transaction_CT', N'U') AS change_table_object_id,
    OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') AS all_changes_function_object_id,
    OBJECT_ID(N'cdc.fn_cdc_get_net_changes_sales_Transaction', N'IF') AS net_changes_function_object_id;

IF OBJECT_ID(N'cdc.sales_Transaction_CT', N'U') IS NULL
BEGIN
    ;THROW 51028, N'Expected change table cdc.sales_Transaction_CT was not found.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
BEGIN
    ;THROW 51029, N'Expected all-changes CDC function was not found.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_net_changes_sales_Transaction', N'IF') IS NOT NULL
BEGIN
    ;THROW 51030, N'Unexpected net-changes function exists although supports_net_changes = 0.', 1;
END;

PRINT N'';
PRINT N'[8] CHANGE TABLE ROW COUNT';
PRINT N'------------------------------------------------------------';

SELECT
    COUNT_BIG(*) AS change_rows
FROM cdc.sales_Transaction_CT;

PRINT N'';
PRINT N'[✓] sales.Transaction CDC enablement validated.';
PRINT N'[✓] CDC cleanup retention = 21600 minutes (15 days).';
PRINT N'[✓] CDC cleanup threshold = 4999.';
PRINT N'';
