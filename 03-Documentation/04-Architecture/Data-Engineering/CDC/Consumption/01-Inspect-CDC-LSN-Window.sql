/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 01-Inspect-CDC-LSN-Window.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Inspect the currently available CDC LSN window for the
                    sales.Transaction and sales.TransactionItem capture instances
    Rerunnable    : Yes
    Destructive   : No
    Changes State : No

    Consumption Phase
    --------------------------------------------------------------------------
    This is the first CDC consumption script.

    It does NOT consume or mutate CDC state.

    It establishes the read boundaries that a future consumer must understand:

        minimum available LSN per capture instance
        current database maximum LSN
        mapped transaction times when available
        empty-window vs non-empty-window state

    Important distinction
    --------------------------------------------------------------------------
    Capture-instance start_lsn is metadata about when capture began.

    A consumer checkpoint is a separate concern and must be maintained by the
    consumer itself.

    This script does not create or persist a checkpoint.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @TransactionCaptureInstance     sysname   = N'sales_Transaction',
    @TransactionItemCaptureInstance sysname   = N'sales_TransactionItem',
    @TransactionMinLsn              binary(10),
    @TransactionItemMinLsn          binary(10),
    @DatabaseMaxLsn                 binary(10);

PRINT N'';
PRINT N'ATLAS ENGINEERING - INSPECT CDC LSN WINDOW';
PRINT N'============================================================';
PRINT N'';

PRINT N'[1] PRECONDITION VALIDATION';
PRINT N'------------------------------------------------------------';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE database_id = DB_ID()
      AND state_desc = N'ONLINE'
      AND is_cdc_enabled = 1
)
BEGIN
    THROW 51240, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @TransactionCaptureInstance
      AND source_object_id = OBJECT_ID(N'sales.[Transaction]')
)
BEGIN
    THROW 51241, N'Capture instance sales_Transaction was not found.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @TransactionItemCaptureInstance
      AND source_object_id = OBJECT_ID(N'sales.TransactionItem')
)
BEGIN
    THROW 51242, N'Capture instance sales_TransactionItem was not found.', 1;
END;

PRINT N'[✓] Database-level CDC is enabled.';
PRINT N'[✓] sales_Transaction capture instance exists.';
PRINT N'[✓] sales_TransactionItem capture instance exists.';

PRINT N'';
PRINT N'[2] CAPTURE INSTANCE METADATA';
PRINT N'------------------------------------------------------------';

SELECT
    ct.capture_instance,
    OBJECT_SCHEMA_NAME(ct.source_object_id) AS source_schema,
    OBJECT_NAME(ct.source_object_id)        AS source_table,
    ct.start_lsn,
    sys.fn_cdc_map_lsn_to_time(ct.start_lsn) AS start_lsn_time,
    ct.supports_net_changes,
    ct.index_name,
    ct.create_date
FROM cdc.change_tables AS ct
WHERE ct.capture_instance IN
(
    @TransactionCaptureInstance,
    @TransactionItemCaptureInstance
)
ORDER BY ct.capture_instance;

PRINT N'';
PRINT N'[3] CURRENT AVAILABLE LSN BOUNDARIES';
PRINT N'------------------------------------------------------------';

SET @TransactionMinLsn =
    sys.fn_cdc_get_min_lsn(@TransactionCaptureInstance);

SET @TransactionItemMinLsn =
    sys.fn_cdc_get_min_lsn(@TransactionItemCaptureInstance);

SET @DatabaseMaxLsn =
    sys.fn_cdc_get_max_lsn();

SELECT
    @TransactionCaptureInstance AS capture_instance,
    @TransactionMinLsn          AS min_available_lsn,
    sys.fn_cdc_map_lsn_to_time(@TransactionMinLsn) AS min_available_lsn_time,
    @DatabaseMaxLsn             AS current_max_lsn,
    sys.fn_cdc_map_lsn_to_time(@DatabaseMaxLsn) AS current_max_lsn_time

UNION ALL

SELECT
    @TransactionItemCaptureInstance,
    @TransactionItemMinLsn,
    sys.fn_cdc_map_lsn_to_time(@TransactionItemMinLsn),
    @DatabaseMaxLsn,
    sys.fn_cdc_map_lsn_to_time(@DatabaseMaxLsn);

IF @TransactionMinLsn IS NULL
BEGIN
    THROW 51243, N'Unable to resolve minimum LSN for sales_Transaction.', 1;
END;

IF @TransactionItemMinLsn IS NULL
BEGIN
    THROW 51244, N'Unable to resolve minimum LSN for sales_TransactionItem.', 1;
END;

IF @DatabaseMaxLsn IS NULL
BEGIN
    THROW 51245, N'Unable to resolve current CDC maximum LSN.', 1;
END;

PRINT N'[✓] Minimum available LSN resolved for both capture instances.';
PRINT N'[✓] Current database maximum LSN resolved.';

PRINT N'';
PRINT N'[4] WINDOW ORDER VALIDATION';
PRINT N'------------------------------------------------------------';

IF @TransactionMinLsn > @DatabaseMaxLsn
BEGIN
    THROW 51246, N'sales_Transaction minimum LSN is greater than the current maximum LSN.', 1;
END;

IF @TransactionItemMinLsn > @DatabaseMaxLsn
BEGIN
    THROW 51247, N'sales_TransactionItem minimum LSN is greater than the current maximum LSN.', 1;
END;

PRINT N'[✓] Both minimum LSN values are within the current CDC range.';

PRINT N'';
PRINT N'[5] CHANGE TABLE STATE';
PRINT N'------------------------------------------------------------';

DECLARE
    @TransactionRows     bigint,
    @TransactionItemRows bigint;

SELECT @TransactionRows = COUNT_BIG(*)
FROM cdc.sales_Transaction_CT;

SELECT @TransactionItemRows = COUNT_BIG(*)
FROM cdc.sales_TransactionItem_CT;

SELECT
    N'sales_Transaction' AS capture_instance,
    @TransactionRows     AS change_table_rows,
    CASE WHEN @TransactionRows = 0 THEN N'EMPTY' ELSE N'NON-EMPTY' END AS window_state

UNION ALL

SELECT
    N'sales_TransactionItem',
    @TransactionItemRows,
    CASE WHEN @TransactionItemRows = 0 THEN N'EMPTY' ELSE N'NON-EMPTY' END;

IF @TransactionRows = 0
    PRINT N'[•] sales_Transaction change table is currently empty.';
ELSE
    PRINT N'[•] sales_Transaction change table currently contains captured changes.';

IF @TransactionItemRows = 0
    PRINT N'[•] sales_TransactionItem change table is currently empty.';
ELSE
    PRINT N'[•] sales_TransactionItem change table currently contains captured changes.';

PRINT N'';
PRINT N'[6] CONSUMER WINDOW INTERPRETATION';
PRINT N'------------------------------------------------------------';

SELECT
    N'sales_Transaction' AS capture_instance,
    @TransactionMinLsn   AS from_lsn_candidate,
    @DatabaseMaxLsn      AS to_lsn_candidate,
    @TransactionRows     AS currently_materialized_change_rows

UNION ALL

SELECT
    N'sales_TransactionItem',
    @TransactionItemMinLsn,
    @DatabaseMaxLsn,
    @TransactionItemRows;

PRINT N'[✓] Candidate CDC read boundaries were inspected.';
PRINT N'[•] No consumer checkpoint was created or advanced.';
PRINT N'[•] Capture-instance start_lsn and consumer checkpoint are separate concepts.';

PRINT N'';
PRINT N'[7] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC LSN window inspection completed successfully.';
PRINT N'[✓] Script executed read-only.';
PRINT N'[✓] Ready to define the first incremental CDC read contract.';
PRINT N'';
