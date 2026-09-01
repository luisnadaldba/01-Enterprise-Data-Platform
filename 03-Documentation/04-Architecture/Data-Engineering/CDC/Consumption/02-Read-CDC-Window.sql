/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 02-Read-CDC-Window.sql
    Version       : 1.0.1
    Target        : AtlasCommerce
    Purpose       : Execute the first controlled read of the currently available
                    CDC window through the official all-changes functions
    Rerunnable    : Yes
    Destructive   : No
    Changes State : No

    Scope
    --------------------------------------------------------------------------
    Reads both capture instances:

        sales_Transaction
        sales_TransactionItem

    using the generated CDC table-valued functions:

        cdc.fn_cdc_get_all_changes_sales_Transaction
        cdc.fn_cdc_get_all_changes_sales_TransactionItem

    No checkpoint is created or advanced.

    Boundary policy for this inspection
    --------------------------------------------------------------------------
    FROM = sys.fn_cdc_get_min_lsn(capture_instance)
    TO   = sys.fn_cdc_get_max_lsn()

    The CDC functions use a closed interval for these endpoints. This script
    intentionally does NOT define the future checkpoint continuation policy.
    That policy will be validated separately before persistence is introduced.

    v1.0.1 correction
    --------------------------------------------------------------------------
    The generated fn_cdc_get_all_changes_* functions expose:
        __$start_lsn
        __$seqval
        __$operation
        __$update_mask
        captured source columns

    They do not expose __$end_lsn or __$command_id. Those columns belong to
    the physical CDC change table and must not be assumed to be part of the
    official all-changes function contract.

    Row filter option
    --------------------------------------------------------------------------
    'all update old'

    This exposes both UPDATE images:
        __$operation = 3  -> before image
        __$operation = 4  -> after image

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @TransactionCaptureInstance     sysname = N'sales_Transaction',
    @TransactionItemCaptureInstance sysname = N'sales_TransactionItem',
    @TransactionFromLsn             binary(10),
    @TransactionItemFromLsn         binary(10),
    @ToLsn                          binary(10);

PRINT N'';
PRINT N'ATLAS ENGINEERING - READ CURRENT CDC WINDOW';
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
    THROW 51250, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
BEGIN
    THROW 51251, N'All-changes function for sales_Transaction was not found.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF') IS NULL
BEGIN
    THROW 51252, N'All-changes function for sales_TransactionItem was not found.', 1;
END;

PRINT N'[✓] Database-level CDC is enabled.';
PRINT N'[✓] Both all-changes CDC functions exist.';

PRINT N'';
PRINT N'[2] RESOLVE READ BOUNDARIES';
PRINT N'------------------------------------------------------------';

SET @TransactionFromLsn =
    sys.fn_cdc_get_min_lsn(@TransactionCaptureInstance);

SET @TransactionItemFromLsn =
    sys.fn_cdc_get_min_lsn(@TransactionItemCaptureInstance);

SET @ToLsn =
    sys.fn_cdc_get_max_lsn();

IF @TransactionFromLsn IS NULL
    THROW 51253, N'Unable to resolve minimum LSN for sales_Transaction.', 1;

IF @TransactionItemFromLsn IS NULL
    THROW 51254, N'Unable to resolve minimum LSN for sales_TransactionItem.', 1;

IF @ToLsn IS NULL
    THROW 51255, N'Unable to resolve current maximum CDC LSN.', 1;

IF @TransactionFromLsn > @ToLsn
    THROW 51256, N'sales_Transaction read boundary is invalid: FROM LSN is greater than TO LSN.', 1;

IF @TransactionItemFromLsn > @ToLsn
    THROW 51257, N'sales_TransactionItem read boundary is invalid: FROM LSN is greater than TO LSN.', 1;

SELECT
    @TransactionCaptureInstance AS capture_instance,
    @TransactionFromLsn         AS from_lsn,
    sys.fn_cdc_map_lsn_to_time(@TransactionFromLsn) AS from_lsn_time,
    @ToLsn                      AS to_lsn,
    sys.fn_cdc_map_lsn_to_time(@ToLsn) AS to_lsn_time
UNION ALL
SELECT
    @TransactionItemCaptureInstance,
    @TransactionItemFromLsn,
    sys.fn_cdc_map_lsn_to_time(@TransactionItemFromLsn),
    @ToLsn,
    sys.fn_cdc_map_lsn_to_time(@ToLsn);

PRINT N'[✓] Read boundaries resolved.';
PRINT N'[•] Current inspection uses each capture instance minimum LSN through the same current maximum LSN.';

PRINT N'';
PRINT N'[3] READ sales.Transaction';
PRINT N'------------------------------------------------------------';

SELECT
    c.__$start_lsn,
    c.__$seqval,
    c.__$operation,
    c.__$update_mask,
    sys.fn_cdc_map_lsn_to_time(c.__$start_lsn) AS cdc_transaction_time,
    c.TRN_id,
    c.TRN_transaction_at,
    c.TRN_CST_id,
    c.TRN_TRNST_id,
    c.TRN_TRNCH_id,
    c.TRN_gross_amount,
    c.TRN_discount_amount,
    c.TRN_created_at,
    c.TRN_updated_at
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @TransactionFromLsn,
    @ToLsn,
    N'all update old'
) AS c
ORDER BY
    c.__$start_lsn,
    c.__$seqval,
    c.__$operation;

DECLARE @TransactionRows bigint;

SELECT @TransactionRows = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @TransactionFromLsn,
    @ToLsn,
    N'all update old'
);

SELECT @TransactionRows AS transaction_rows_returned;

IF @TransactionRows = 0
    PRINT N'[✓] sales.Transaction read completed successfully and returned 0 rows.';
ELSE
    PRINT N'[✓] sales.Transaction read completed successfully and returned captured changes.';

PRINT N'';
PRINT N'[4] READ sales.TransactionItem';
PRINT N'------------------------------------------------------------';

SELECT
    c.__$start_lsn,
    c.__$seqval,
    c.__$operation,
    c.__$update_mask,
    sys.fn_cdc_map_lsn_to_time(c.__$start_lsn) AS cdc_transaction_time,
    c.TRNIT_id,
    c.TRNIT_transaction_at,
    c.TRNIT_TRN_id,
    c.TRNIT_PRDVA_id,
    c.TRNIT_quantity,
    c.TRNIT_unit_price,
    c.TRNIT_unit_discount,
    c.TRNIT_created_at,
    c.TRNIT_updated_at
FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
(
    @TransactionItemFromLsn,
    @ToLsn,
    N'all update old'
) AS c
ORDER BY
    c.__$start_lsn,
    c.__$seqval,
    c.__$operation;

DECLARE @TransactionItemRows bigint;

SELECT @TransactionItemRows = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
(
    @TransactionItemFromLsn,
    @ToLsn,
    N'all update old'
);

SELECT @TransactionItemRows AS transaction_item_rows_returned;

IF @TransactionItemRows = 0
    PRINT N'[✓] sales.TransactionItem read completed successfully and returned 0 rows.';
ELSE
    PRINT N'[✓] sales.TransactionItem read completed successfully and returned captured changes.';

PRINT N'';
PRINT N'[5] WINDOW SUMMARY';
PRINT N'------------------------------------------------------------';

SELECT
    N'sales_Transaction' AS capture_instance,
    @TransactionFromLsn AS from_lsn,
    @ToLsn AS to_lsn,
    @TransactionRows AS rows_returned
UNION ALL
SELECT
    N'sales_TransactionItem',
    @TransactionItemFromLsn,
    @ToLsn,
    @TransactionItemRows;

PRINT N'[✓] Both capture instances were queried through their official all-changes functions.';
PRINT N'[•] The read did not create or advance a consumer checkpoint.';
PRINT N'[•] No continuation boundary has been persisted yet.';

PRINT N'';
PRINT N'[6] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] Controlled CDC window read completed successfully.';
PRINT N'[✓] Row filter option = all update old.';
PRINT N'[✓] Script made no persistent data or CDC configuration changes.';
PRINT N'[✓] Ready to validate incremental continuation semantics.';
PRINT N'';
