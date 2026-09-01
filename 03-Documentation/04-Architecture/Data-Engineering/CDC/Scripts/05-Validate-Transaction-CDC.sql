/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 05-Validate-Transaction-CDC.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Validate CDC configuration for sales.Transaction
    Rerunnable    : Yes
    Destructive   : No
    Changes State : No

    Expected configuration
    --------------------------------------------------------------------------
    Source Schema        : sales
    Source Table         : Transaction
    Capture Instance     : sales_Transaction
    Supports Net Changes : 0
    Index Name           : PK_TRN
    Captured Columns     : 9

    Expected CDC objects
    --------------------------------------------------------------------------
    cdc.sales_Transaction_CT
    cdc.fn_cdc_get_all_changes_sales_Transaction

    The net-changes function must NOT exist because supports_net_changes = 0.

    Important
    --------------------------------------------------------------------------
    This script is validation-only.

    It does NOT:
    - enable or disable CDC;
    - change CDC configuration;
    - modify source data;
    - modify CDC Change Tables.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @SourceSchema       sysname = N'sales',
    @SourceTable        sysname = N'Transaction',
    @CaptureInstance    sysname = N'sales_Transaction',
    @ExpectedIndexName  sysname = N'PK_TRN',
    @ExpectedColumns    int = 9,
    @SourceObjectId     int = OBJECT_ID(N'sales.[Transaction]'),
    @ChangeTableObjectId int;

PRINT N'';
PRINT N'ATLAS ENGINEERING - VALIDATE sales.Transaction CDC';
PRINT N'============================================================';
PRINT N'';

PRINT N'[1] SOURCE TABLE VALIDATION';
PRINT N'------------------------------------------------------------';

IF @SourceObjectId IS NULL
BEGIN
    ;THROW 51050, N'sales.Transaction was not found.', 1;
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
    FROM sys.tables
    WHERE object_id = @SourceObjectId
      AND is_tracked_by_cdc = 1
)
BEGIN
    ;THROW 51051, N'sales.Transaction is not currently tracked by CDC.', 1;
END;

PRINT N'[✓] sales.Transaction is tracked by CDC.';

PRINT N'';
PRINT N'[2] CAPTURE INSTANCE VALIDATION';
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
    ;THROW 51052, N'Expected capture instance sales_Transaction was not found.', 1;
END;

IF EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @CaptureInstance
      AND supports_net_changes <> 0
)
BEGIN
    ;THROW 51053, N'sales_Transaction supports_net_changes must be 0.', 1;
END;

IF EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @CaptureInstance
      AND ISNULL(index_name, N'') <> @ExpectedIndexName
)
BEGIN
    ;THROW 51054, N'sales_Transaction index_name differs from expected PK_TRN.', 1;
END;

PRINT N'[✓] Capture instance sales_Transaction is valid.';
PRINT N'[✓] supports_net_changes = 0.';
PRINT N'[✓] index_name = PK_TRN.';

PRINT N'';
PRINT N'[3] CAPTURED COLUMNS';
PRINT N'------------------------------------------------------------';

SELECT
    cc.column_ordinal,
    cc.column_name,
    cc.column_type AS data_type,
    cc.column_type,
    cc.column_ordinal
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

IF @CapturedColumnCount <> @ExpectedColumns
BEGIN
    ;THROW 51055, N'Expected exactly 9 captured columns for sales.Transaction.', 1;
END;

PRINT N'[✓] Exactly 9 source columns are captured.';

PRINT N'';
PRINT N'[4] CDC OBJECT VALIDATION';
PRINT N'------------------------------------------------------------';

SET @ChangeTableObjectId = OBJECT_ID(N'cdc.sales_Transaction_CT');

SELECT
    OBJECT_SCHEMA_NAME(o.object_id) AS object_schema,
    o.name                          AS object_name,
    o.type_desc
FROM sys.objects AS o
WHERE o.object_id IN
(
    OBJECT_ID(N'cdc.sales_Transaction_CT'),
    OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction')
)
ORDER BY o.name;

IF @ChangeTableObjectId IS NULL
BEGIN
    ;THROW 51056, N'Expected CDC change table cdc.sales_Transaction_CT was not found.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
BEGIN
    ;THROW 51057, N'Expected all-changes function for sales_Transaction was not found.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_net_changes_sales_Transaction', N'IF') IS NOT NULL
BEGIN
    ;THROW 51058, N'Unexpected net-changes function exists for sales_Transaction.', 1;
END;

PRINT N'[✓] Change Table exists.';
PRINT N'[✓] All-changes function exists.';
PRINT N'[✓] Net-changes function does not exist, as expected.';

PRINT N'';
PRINT N'[5] CHANGE TABLE STRUCTURE';
PRINT N'------------------------------------------------------------';

SELECT
    c.column_id,
    c.name AS column_name,
    TYPE_NAME(c.user_type_id) AS data_type,
    c.max_length,
    c.precision,
    c.scale,
    c.is_nullable
FROM sys.columns AS c
WHERE c.object_id = @ChangeTableObjectId
ORDER BY c.column_id;

PRINT N'';
PRINT N'[6] CHANGE TABLE INDEXES';
PRINT N'------------------------------------------------------------';

SELECT
    i.name AS index_name,
    i.type_desc,
    i.is_unique,
    i.is_primary_key,
    STRING_AGG(c.name, N', ') WITHIN GROUP (ORDER BY ic.key_ordinal) AS key_columns
FROM sys.indexes AS i
INNER JOIN sys.index_columns AS ic
    ON ic.object_id = i.object_id
   AND ic.index_id = i.index_id
INNER JOIN sys.columns AS c
    ON c.object_id = ic.object_id
   AND c.column_id = ic.column_id
WHERE i.object_id = @ChangeTableObjectId
  AND ic.key_ordinal > 0
GROUP BY
    i.name,
    i.type_desc,
    i.is_unique,
    i.is_primary_key
ORDER BY i.name;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes AS i
    WHERE i.object_id = @ChangeTableObjectId
      AND i.is_unique = 1
      AND i.type = 1
)
BEGIN
    ;THROW 51059, N'Expected unique clustered index was not found on cdc.sales_Transaction_CT.', 1;
END;

PRINT N'[✓] Change Table unique clustered index exists.';

PRINT N'';
PRINT N'[7] CHANGE TABLE ROW COUNT';
PRINT N'------------------------------------------------------------';

DECLARE @ChangeTableRows bigint;

SELECT @ChangeTableRows = COUNT_BIG(*)
FROM cdc.sales_Transaction_CT;

SELECT @ChangeTableRows AS change_table_rows;

PRINT N'[✓] Change Table row count retrieved successfully.';

PRINT N'';
PRINT N'[8] FINAL VALIDATION';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] sales.Transaction CDC validation completed.';
PRINT N'[✓] Capture instance = sales_Transaction.';
PRINT N'[✓] Supports net changes = 0.';
PRINT N'[✓] Index = PK_TRN.';
PRINT N'[✓] Captured columns = 9.';
PRINT N'[✓] Expected CDC objects are present.';
PRINT N'[✓] This script made no configuration changes.';
PRINT N'';
