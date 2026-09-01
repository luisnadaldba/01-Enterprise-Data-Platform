/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 05-Process-CDC-Window-And-Checkpoint.sql
    Version       : 1.0.2
    Target        : AtlasCommerce
    Consumer      : AtlasEngineering.CDCConsumption.V1
    Purpose       : Read one bounded CDC window for both V1 capture instances
                    and persist checkpoints only after successful processing.
    Rerunnable    : Yes
    Destructive   : No
    Changes State : Yes - advances consumer checkpoints after successful read

    v1.0.2 contract correction
    --------------------------------------------------------------------------
    The official cdc.fn_cdc_get_all_changes_* functions expose exactly:

        __$start_lsn
        __$seqval
        __$operation
        __$update_mask
        + captured source columns

    They do NOT expose:
        __$end_lsn
        __$command_id

    Those columns belong to the physical CDC change tables and are not part of
    the official all-changes consumer function contract.

    IMPORTANT
    --------------------------------------------------------------------------
    This laboratory script validates checkpoint semantics. It does not yet load
    CDC rows into a downstream Bronze/Silver target.

    Boundary rule:
      first read:
          FROM = sys.fn_cdc_get_min_lsn(capture_instance)

      continuation:
          FROM = sys.fn_cdc_increment_lsn(last_processed_lsn)

      every execution:
          TO = one shared sys.fn_cdc_get_max_lsn() snapshot

    Checkpoint rule:
      The checkpoint stores the successfully completed TO boundary, not FROM.

    Safety rule:
      Both capture-instance checkpoints are advanced in one SQL transaction.
      If any validation/read fails, neither checkpoint is advanced.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @ConsumerName nvarchar(128) = N'AtlasEngineering.CDCConsumption.V1',
    @TransactionCapture sysname = N'sales_Transaction',
    @ItemCapture sysname = N'sales_TransactionItem',
    @TransactionCheckpoint binary(10),
    @ItemCheckpoint binary(10),
    @TransactionMinLsn binary(10),
    @ItemMinLsn binary(10),
    @TransactionFromLsn binary(10),
    @ItemFromLsn binary(10),
    @ToLsn binary(10),
    @TransactionRows bigint = 0,
    @ItemRows bigint = 0,
    @TransactionVersion bigint,
    @ItemVersion bigint;

PRINT N'';
PRINT N'ATLAS ENGINEERING - PROCESS CDC WINDOW AND CHECKPOINT';
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
    THROW 51400, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;

IF OBJECT_ID(N'control.CDCConsumerCheckpoint', N'U') IS NULL
    THROW 51401, N'control.CDCConsumerCheckpoint does not exist. Run script 04 first.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
    THROW 51402, N'CDC all-changes function for sales_Transaction does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF') IS NULL
    THROW 51403, N'CDC all-changes function for sales_TransactionItem does not exist.', 1;

IF
(
    SELECT COUNT(*)
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN (@TransactionCapture, @ItemCapture)
) <> 2
    THROW 51404, N'Exactly two V1 checkpoint rows are required.', 1;

PRINT N'[✓] Database-level CDC is enabled.';
PRINT N'[✓] Checkpoint structure exists.';
PRINT N'[✓] Both CDC read functions exist.';
PRINT N'[✓] Both V1 checkpoint rows exist.';

PRINT N'';
PRINT N'[2] RESOLVE CHECKPOINT AND CDC BOUNDARIES';
PRINT N'------------------------------------------------------------';

SELECT
    @TransactionCheckpoint = last_processed_lsn,
    @TransactionVersion = checkpoint_version
FROM control.CDCConsumerCheckpoint
WHERE consumer_name = @ConsumerName
  AND capture_instance = @TransactionCapture;

SELECT
    @ItemCheckpoint = last_processed_lsn,
    @ItemVersion = checkpoint_version
FROM control.CDCConsumerCheckpoint
WHERE consumer_name = @ConsumerName
  AND capture_instance = @ItemCapture;

SET @TransactionMinLsn = sys.fn_cdc_get_min_lsn(@TransactionCapture);
SET @ItemMinLsn = sys.fn_cdc_get_min_lsn(@ItemCapture);
SET @ToLsn = sys.fn_cdc_get_max_lsn();

IF @TransactionMinLsn IS NULL OR @TransactionMinLsn = 0x00000000000000000000
    THROW 51405, N'Could not resolve a valid minimum LSN for sales_Transaction.', 1;

IF @ItemMinLsn IS NULL OR @ItemMinLsn = 0x00000000000000000000
    THROW 51406, N'Could not resolve a valid minimum LSN for sales_TransactionItem.', 1;

IF @ToLsn IS NULL OR @ToLsn = 0x00000000000000000000
    THROW 51407, N'Could not resolve a valid current maximum CDC LSN.', 1;

-- Detect retention/checkpoint loss before calculating continuation.
IF @TransactionCheckpoint IS NOT NULL
   AND @TransactionCheckpoint < @TransactionMinLsn
    THROW 51408, N'sales_Transaction checkpoint is older than the minimum available CDC LSN. Recovery/backfill decision required.', 1;

IF @ItemCheckpoint IS NOT NULL
   AND @ItemCheckpoint < @ItemMinLsn
    THROW 51409, N'sales_TransactionItem checkpoint is older than the minimum available CDC LSN. Recovery/backfill decision required.', 1;

SET @TransactionFromLsn =
    CASE
        WHEN @TransactionCheckpoint IS NULL THEN @TransactionMinLsn
        ELSE sys.fn_cdc_increment_lsn(@TransactionCheckpoint)
    END;

SET @ItemFromLsn =
    CASE
        WHEN @ItemCheckpoint IS NULL THEN @ItemMinLsn
        ELSE sys.fn_cdc_increment_lsn(@ItemCheckpoint)
    END;

SELECT
    capture_instance,
    checkpoint_before,
    checkpoint_version_before,
    min_available_lsn,
    from_lsn,
    @ToLsn AS to_lsn
FROM
(
    SELECT
        @TransactionCapture AS capture_instance,
        @TransactionCheckpoint AS checkpoint_before,
        @TransactionVersion AS checkpoint_version_before,
        @TransactionMinLsn AS min_available_lsn,
        @TransactionFromLsn AS from_lsn
    UNION ALL
    SELECT
        @ItemCapture,
        @ItemCheckpoint,
        @ItemVersion,
        @ItemMinLsn,
        @ItemFromLsn
) AS boundaries
ORDER BY capture_instance;

PRINT N'[✓] One shared TO LSN snapshot resolved.';
PRINT N'[✓] First-read/continuation FROM boundaries resolved.';
PRINT N'[✓] Existing checkpoints are not behind CDC retention.';

PRINT N'';
PRINT N'[3] READ sales.Transaction WINDOW';
PRINT N'------------------------------------------------------------';

DECLARE @TransactionChanges TABLE
(
    __$start_lsn binary(10) NOT NULL,
    __$seqval binary(10) NOT NULL,
    __$operation int NOT NULL,
    __$update_mask varbinary(128) NULL,
    TRN_id bigint NULL,
    TRN_transaction_at datetime2 NULL,
    TRN_CST_id int NULL,
    TRN_TRNST_id tinyint NULL,
    TRN_TRNCH_id tinyint NULL,
    TRN_gross_amount decimal(19,4) NULL,
    TRN_discount_amount decimal(19,4) NULL,
    TRN_created_at datetime2 NULL,
    TRN_updated_at datetime2 NULL
);

IF @TransactionFromLsn <= @ToLsn
BEGIN
    INSERT INTO @TransactionChanges
    (
        __$start_lsn,
        __$seqval,
        __$operation,
        __$update_mask,
        TRN_id,
        TRN_transaction_at,
        TRN_CST_id,
        TRN_TRNST_id,
        TRN_TRNCH_id,
        TRN_gross_amount,
        TRN_discount_amount,
        TRN_created_at,
        TRN_updated_at
    )
    SELECT
        __$start_lsn,
        __$seqval,
        __$operation,
        __$update_mask,
        TRN_id,
        TRN_transaction_at,
        TRN_CST_id,
        TRN_TRNST_id,
        TRN_TRNCH_id,
        TRN_gross_amount,
        TRN_discount_amount,
        TRN_created_at,
        TRN_updated_at
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        @TransactionFromLsn,
        @ToLsn,
        N'all update old'
    );

    SET @TransactionRows = @@ROWCOUNT;
END;

SELECT *
FROM @TransactionChanges
ORDER BY __$start_lsn, __$seqval, __$operation;

PRINT N'[✓] sales.Transaction window read completed.';

PRINT N'';
PRINT N'[4] READ sales.TransactionItem WINDOW';
PRINT N'------------------------------------------------------------';

DECLARE @ItemChanges TABLE
(
    __$start_lsn binary(10) NOT NULL,
    __$seqval binary(10) NOT NULL,
    __$operation int NOT NULL,
    __$update_mask varbinary(128) NULL,
    TRNIT_id bigint NULL,
    TRNIT_transaction_at datetime2 NULL,
    TRNIT_TRN_id bigint NULL,
    TRNIT_PRDVA_id int NULL,
    TRNIT_quantity int NULL,
    TRNIT_unit_price decimal(19,4) NULL,
    TRNIT_unit_discount decimal(19,4) NULL,
    TRNIT_created_at datetime2 NULL,
    TRNIT_updated_at datetime2 NULL
);

IF @ItemFromLsn <= @ToLsn
BEGIN
    INSERT INTO @ItemChanges
    (
        __$start_lsn,
        __$seqval,
        __$operation,
        __$update_mask,
        TRNIT_id,
        TRNIT_transaction_at,
        TRNIT_TRN_id,
        TRNIT_PRDVA_id,
        TRNIT_quantity,
        TRNIT_unit_price,
        TRNIT_unit_discount,
        TRNIT_created_at,
        TRNIT_updated_at
    )
    SELECT
        __$start_lsn,
        __$seqval,
        __$operation,
        __$update_mask,
        TRNIT_id,
        TRNIT_transaction_at,
        TRNIT_TRN_id,
        TRNIT_PRDVA_id,
        TRNIT_quantity,
        TRNIT_unit_price,
        TRNIT_unit_discount,
        TRNIT_created_at,
        TRNIT_updated_at
    FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
    (
        @ItemFromLsn,
        @ToLsn,
        N'all update old'
    );

    SET @ItemRows = @@ROWCOUNT;
END;

SELECT *
FROM @ItemChanges
ORDER BY __$start_lsn, __$seqval, __$operation;

PRINT N'[✓] sales.TransactionItem window read completed.';

PRINT N'';
PRINT N'[5] PROCESSING VALIDATION';
PRINT N'------------------------------------------------------------';

IF EXISTS
(
    SELECT 1 FROM @TransactionChanges
    WHERE __$start_lsn < @TransactionFromLsn
       OR __$start_lsn > @ToLsn
)
    THROW 51410, N'sales.Transaction returned a row outside the requested CDC window.', 1;

IF EXISTS
(
    SELECT 1 FROM @ItemChanges
    WHERE __$start_lsn < @ItemFromLsn
       OR __$start_lsn > @ToLsn
)
    THROW 51411, N'sales.TransactionItem returned a row outside the requested CDC window.', 1;

SELECT
    @TransactionCapture AS capture_instance,
    @TransactionRows AS rows_processed,
    @TransactionFromLsn AS from_lsn,
    @ToLsn AS to_lsn
UNION ALL
SELECT
    @ItemCapture,
    @ItemRows,
    @ItemFromLsn,
    @ToLsn;

PRINT N'[✓] Both bounded reads completed without error.';
PRINT N'[✓] Returned rows are within their requested boundaries.';
PRINT N'[•] Laboratory processing = successful bounded materialization in memory.';
PRINT N'[•] No downstream Bronze/Silver write is performed by this script.';

PRINT N'';
PRINT N'[6] ATOMIC CHECKPOINT COMMIT';
PRINT N'------------------------------------------------------------';

BEGIN TRY
    BEGIN TRANSACTION;

    -- Optimistic version checks protect against an unexpected concurrent
    -- execution of the same consumer.
    UPDATE control.CDCConsumerCheckpoint
    SET
        last_processed_lsn = @ToLsn,
        last_processed_at = SYSUTCDATETIME(),
        last_window_rows = @TransactionRows,
        checkpoint_version = checkpoint_version + 1,
        updated_at = SYSUTCDATETIME()
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @TransactionCapture
      AND checkpoint_version = @TransactionVersion
      AND
      (
          (last_processed_lsn = @TransactionCheckpoint)
          OR (last_processed_lsn IS NULL AND @TransactionCheckpoint IS NULL)
      );

    IF @@ROWCOUNT <> 1
        THROW 51412, N'sales_Transaction checkpoint changed concurrently. No checkpoint commit allowed.', 1;

    UPDATE control.CDCConsumerCheckpoint
    SET
        last_processed_lsn = @ToLsn,
        last_processed_at = SYSUTCDATETIME(),
        last_window_rows = @ItemRows,
        checkpoint_version = checkpoint_version + 1,
        updated_at = SYSUTCDATETIME()
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @ItemCapture
      AND checkpoint_version = @ItemVersion
      AND
      (
          (last_processed_lsn = @ItemCheckpoint)
          OR (last_processed_lsn IS NULL AND @ItemCheckpoint IS NULL)
      );

    IF @@ROWCOUNT <> 1
        THROW 51413, N'sales_TransactionItem checkpoint changed concurrently. No checkpoint commit allowed.', 1;

    COMMIT TRANSACTION;

    PRINT N'[+] Both checkpoints committed atomically.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;

PRINT N'';
PRINT N'[7] CHECKPOINT AFTER COMMIT';
PRINT N'------------------------------------------------------------';

SELECT
    consumer_name,
    capture_instance,
    last_processed_lsn,
    sys.fn_cdc_map_lsn_to_time(last_processed_lsn) AS last_processed_lsn_time,
    last_processed_at,
    last_window_rows,
    checkpoint_version,
    created_at,
    updated_at
FROM control.CDCConsumerCheckpoint
WHERE consumer_name = @ConsumerName
  AND capture_instance IN (@TransactionCapture, @ItemCapture)
ORDER BY capture_instance;

IF EXISTS
(
    SELECT 1
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN (@TransactionCapture, @ItemCapture)
      AND last_processed_lsn <> @ToLsn
)
    THROW 51414, N'Final checkpoint validation failed: both checkpoints must equal the completed TO LSN.', 1;

PRINT N'[✓] Both checkpoints equal the successfully completed TO LSN.';

PRINT N'';
PRINT N'[8] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC window processing and checkpoint persistence completed successfully.';
PRINT N'[✓] sales.Transaction rows processed = ' + CONVERT(nvarchar(30), @TransactionRows) + N'.';
PRINT N'[✓] sales.TransactionItem rows processed = ' + CONVERT(nvarchar(30), @ItemRows) + N'.';
PRINT N'[✓] Checkpoint stores the completed TO boundary.';
PRINT N'[✓] Both capture-instance checkpoints advanced atomically.';
PRINT N'[✓] Next execution will start at fn_cdc_increment_lsn(last_processed_lsn).';
PRINT N'';
