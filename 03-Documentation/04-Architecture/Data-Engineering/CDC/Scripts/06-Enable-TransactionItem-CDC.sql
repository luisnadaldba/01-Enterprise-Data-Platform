/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 06-Enable-TransactionItem-CDC.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Enable, configure and validate SQL Server CDC for
                    sales.TransactionItem
    Rerunnable    : Yes
    Destructive   : No

    Expected configuration
    --------------------------------------------------------------------------
    Source Schema        : sales
    Source Table         : TransactionItem
    Capture Instance     : sales_TransactionItem
    Supports Net Changes : 0
    Expected PK          : PK_TRNIT
    Captured Columns     : 9
    Cleanup Retention    : 21600 minutes (15 days)
    Cleanup Threshold    : 4999

    Expected CDC objects
    --------------------------------------------------------------------------
    cdc.sales_TransactionItem_CT
    cdc.fn_cdc_get_all_changes_sales_TransactionItem

    The net-changes function must NOT exist because supports_net_changes = 0.

    Important
    --------------------------------------------------------------------------
    This script is rerunnable.

    If the expected capture instance already exists, the script does not create
    a second one. It validates the existing configuration instead.

    CDC cleanup retention is treated as part of the Atlas Engineering V1 CDC
    operational baseline and is therefore enforced here as well.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @SourceSchema        sysname = N'sales',
    @SourceTable         sysname = N'TransactionItem',
    @CaptureInstance     sysname = N'sales_TransactionItem',
    @ExpectedIndexName   sysname = N'PK_TRNIT',
    @ExpectedColumns     int = 9,
    @SourceObjectId      int = OBJECT_ID(N'sales.TransactionItem'),
    @DatabaseId          int = DB_ID(),
    @TargetRetention     int = 21600,
    @TargetThreshold     int = 4999,
    @CurrentRetention    int,
    @CurrentThreshold    int,
    @CapturedColumnCount int;

PRINT N'';
PRINT N'ATLAS ENGINEERING - ENABLE sales.TransactionItem CDC';
PRINT N'============================================================';
PRINT N'';

PRINT N'[1] DATABASE CDC VALIDATION';
PRINT N'------------------------------------------------------------';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE database_id = @DatabaseId
      AND state_desc = N'ONLINE'
      AND is_cdc_enabled = 1
)
BEGIN
    ;THROW 51060, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

PRINT N'[✓] AtlasCommerce is ONLINE and database-level CDC is enabled.';

PRINT N'';
PRINT N'[2] SOURCE TABLE VALIDATION';
PRINT N'------------------------------------------------------------';

IF @SourceObjectId IS NULL
BEGIN
    ;THROW 51061, N'sales.TransactionItem was not found.', 1;
END;

SELECT
    s.name AS source_schema,
    t.name AS source_table,
    t.is_tracked_by_cdc
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
WHERE t.object_id = @SourceObjectId;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE object_id = @SourceObjectId
      AND name = @ExpectedIndexName
      AND is_primary_key = 1
)
BEGIN
    ;THROW 51062, N'Expected primary key PK_TRNIT was not found on sales.TransactionItem.', 1;
END;

PRINT N'[✓] sales.TransactionItem exists.';
PRINT N'[✓] Primary key PK_TRNIT exists.';

PRINT N'';
PRINT N'[3] ENABLE TABLE-LEVEL CDC';
PRINT N'------------------------------------------------------------';

IF EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @CaptureInstance
      AND source_object_id = @SourceObjectId
)
BEGIN
    PRINT N'[•] Capture instance sales_TransactionItem already exists. No change required.';
END
ELSE
BEGIN
    IF EXISTS
    (
        SELECT 1
        FROM cdc.change_tables
        WHERE source_object_id = @SourceObjectId
    )
    BEGIN
        ;THROW 51063, N'sales.TransactionItem is already tracked by a different CDC capture instance.', 1;
    END;

    PRINT N'[+] Enabling CDC for sales.TransactionItem...';

    EXEC sys.sp_cdc_enable_table
        @source_schema        = @SourceSchema,
        @source_name          = @SourceTable,
        @role_name            = NULL,
        @capture_instance     = @CaptureInstance,
        @supports_net_changes = 0;

    PRINT N'[+] CDC enabled for sales.TransactionItem.';
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
    ct.index_name,
    ct.filegroup_name,
    ct.create_date,
    ct.partition_switch
FROM cdc.change_tables AS ct
WHERE ct.capture_instance = @CaptureInstance;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @CaptureInstance
      AND source_object_id = @SourceObjectId
)
BEGIN
    ;THROW 51064, N'Expected capture instance sales_TransactionItem was not found.', 1;
END;

IF EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @CaptureInstance
      AND supports_net_changes <> 0
)
BEGIN
    ;THROW 51065, N'sales_TransactionItem supports_net_changes must be 0.', 1;
END;

IF EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @CaptureInstance
      AND ISNULL(index_name, N'') <> @ExpectedIndexName
)
BEGIN
    ;THROW 51066, N'sales_TransactionItem index_name differs from expected PK_TRNIT.', 1;
END;

PRINT N'[✓] Capture instance sales_TransactionItem is valid.';
PRINT N'[✓] supports_net_changes = 0.';
PRINT N'[✓] index_name = PK_TRNIT.';

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
    ;THROW 51067, N'CDC cleanup job configuration was not found for AtlasCommerce.', 1;
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
    ;THROW 51068, N'CDC cleanup retention validation failed. Expected 21600 minutes.', 1;
END;

IF @CurrentThreshold <> @TargetThreshold
BEGIN
    ;THROW 51069, N'CDC cleanup threshold validation failed. Expected 4999.', 1;
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

SELECT
    @CapturedColumnCount = COUNT(*)
FROM cdc.captured_columns AS cc
INNER JOIN cdc.change_tables AS ct
    ON ct.object_id = cc.object_id
WHERE ct.capture_instance = @CaptureInstance;

IF @CapturedColumnCount <> @ExpectedColumns
BEGIN
    ;THROW 51070, N'Expected exactly 9 captured columns for sales.TransactionItem.', 1;
END;

PRINT N'[✓] Exactly 9 source columns are captured.';

PRINT N'';
PRINT N'[7] GENERATED CDC OBJECTS';
PRINT N'------------------------------------------------------------';

SELECT
    OBJECT_SCHEMA_NAME(o.object_id) AS object_schema,
    o.name                          AS object_name,
    o.type_desc
FROM sys.objects AS o
WHERE o.object_id IN
(
    OBJECT_ID(N'cdc.sales_TransactionItem_CT'),
    OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem')
)
ORDER BY o.name;

IF OBJECT_ID(N'cdc.sales_TransactionItem_CT', N'U') IS NULL
BEGIN
    ;THROW 51071, N'Expected change table cdc.sales_TransactionItem_CT was not found.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF') IS NULL
BEGIN
    ;THROW 51072, N'Expected all-changes CDC function for sales_TransactionItem was not found.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_net_changes_sales_TransactionItem', N'IF') IS NOT NULL
BEGIN
    ;THROW 51073, N'Unexpected net-changes function exists although supports_net_changes = 0.', 1;
END;

PRINT N'[✓] Change Table exists.';
PRINT N'[✓] All-changes function exists.';
PRINT N'[✓] Net-changes function does not exist, as expected.';

PRINT N'';
PRINT N'[8] CHANGE TABLE ROW COUNT';
PRINT N'------------------------------------------------------------';

DECLARE @ChangeTableRows bigint;

SELECT @ChangeTableRows = COUNT_BIG(*)
FROM cdc.sales_TransactionItem_CT;

SELECT @ChangeTableRows AS change_table_rows;

PRINT N'[✓] Change Table row count retrieved successfully.';

PRINT N'';
PRINT N'[9] FINAL VALIDATION';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] sales.TransactionItem CDC enablement validated.';
PRINT N'[✓] Capture instance = sales_TransactionItem.';
PRINT N'[✓] Supports net changes = 0.';
PRINT N'[✓] Index = PK_TRNIT.';
PRINT N'[✓] Captured columns = 9.';
PRINT N'[✓] CDC cleanup retention = 21600 minutes (15 days).';
PRINT N'[✓] CDC cleanup threshold = 4999.';
PRINT N'';
