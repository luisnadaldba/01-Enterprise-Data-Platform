/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 10-Validate-CDC-Cross-Table-Consumption-v1.0.1.sql
    Version       : 1.0.1
    Target        : AtlasCommerce
    Consumer      : AtlasEngineering.CDCConsumption.V1
    Purpose       : Validate cross-table CDC consumption for one controlled SQL
                    transaction containing one sales.Transaction INSERT and two
                    sales.TransactionItem INSERTs, then advance both consumer
                    checkpoints atomically after successful processing.
    Rerunnable    : Controlled - each successful execution creates one parent
                    and two child source rows for consumption validation
    Destructive   : No
    Changes State : Yes - inserts controlled source rows and advances both
                    consumer checkpoints after successful processing

    Validation Contract
    --------------------------------------------------------------------------
    1. Start from the aligned persisted V1 checkpoints.
    2. Insert one parent and two children inside ONE SQL transaction.
    3. Wait until CDC exposes all three controlled INSERT events.
    4. Resolve one shared TO boundary after capture.
    5. Read both capture instances through their official all-changes functions.
    6. Prove:
           - parent event is returned exactly once;
           - two child events are returned exactly once;
           - all three controlled rows share one __$start_lsn;
           - all three are INSERT operations;
           - no controlled event exists outside the requested read windows.
    7. Advance both capture-instance checkpoints atomically only after all
       validations succeed.

    Important
    --------------------------------------------------------------------------
    - This validates consumer-side cross-table correlation and checkpointing.
    - No Bronze/Silver target is written by this laboratory script.
    - Controlled source rows are preserved for later tests.
    - Checkpoints are not advanced if any validation fails.

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
    @TransactionVersion bigint,
    @ItemVersion bigint,

    @TransactionMinLsn binary(10),
    @ItemMinLsn binary(10),

    @TransactionFromLsn binary(10),
    @ItemFromLsn binary(10),
    @ToLsn binary(10),

    @PendingStatusId tinyint,
    @OnlineChannelId tinyint,

    @TransactionId bigint,
    @TransactionAt datetime2(0),
    @ItemId1 bigint,
    @ItemId2 bigint,

    @ParentStartLsn binary(10),
    @ChildStartLsn1 binary(10),
    @ChildStartLsn2 binary(10),

    @ParentControlledRows bigint,
    @ChildControlledRows bigint,

    @Poll int = 0,
    @MaxPoll int = 30;

DECLARE @TransactionWindow TABLE
(
    start_lsn binary(10) NOT NULL,
    seqval binary(10) NOT NULL,
    operation int NOT NULL,
    update_mask varbinary(128) NULL,
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

DECLARE @ItemWindow TABLE
(
    start_lsn binary(10) NOT NULL,
    seqval binary(10) NOT NULL,
    operation int NOT NULL,
    update_mask varbinary(128) NULL,
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

PRINT N'';
PRINT N'ATLAS ENGINEERING - VALIDATE CDC CROSS-TABLE CONSUMPTION';
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
    THROW 51900, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;

IF OBJECT_ID(N'control.CDCConsumerCheckpoint', N'U') IS NULL
    THROW 51901, N'control.CDCConsumerCheckpoint does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
    THROW 51902, N'CDC all-changes function for sales_Transaction does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF') IS NULL
    THROW 51903, N'CDC all-changes function for sales_TransactionItem does not exist.', 1;

IF
(
    SELECT COUNT(*)
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN (@TransactionCapture, @ItemCapture)
) <> 2
    THROW 51904, N'Exactly two V1 checkpoint rows are required.', 1;

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

IF @TransactionCheckpoint IS NULL OR @ItemCheckpoint IS NULL
    THROW 51905, N'Both V1 checkpoints must contain persisted progress.', 1;

IF @TransactionCheckpoint <> @ItemCheckpoint
    THROW 51906, N'V1 capture-instance checkpoints are not aligned.', 1;

SET @TransactionMinLsn = sys.fn_cdc_get_min_lsn(@TransactionCapture);
SET @ItemMinLsn = sys.fn_cdc_get_min_lsn(@ItemCapture);

IF @TransactionCheckpoint < @TransactionMinLsn
    THROW 51907, N'sales_Transaction checkpoint is older than min_available_lsn.', 1;

IF @ItemCheckpoint < @ItemMinLsn
    THROW 51908, N'sales_TransactionItem checkpoint is older than min_available_lsn.', 1;

SELECT TOP (1)
    @PendingStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE UPPER(TRNST_name) = N'PENDING';

IF @PendingStatusId IS NULL
    THROW 51909, N'Status PENDING could not be resolved.', 1;

SELECT TOP (1)
    @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_name = N'Online transaction';

IF @OnlineChannelId IS NULL
    THROW 51910, N'Channel ONLINE could not be resolved.', 1;

IF NOT EXISTS (SELECT 1 FROM catalog.ProductVariant WHERE PRDVA_id = 1)
    THROW 51911, N'ProductVariant 1 does not exist.', 1;

IF NOT EXISTS (SELECT 1 FROM catalog.ProductVariant WHERE PRDVA_id = 2)
    THROW 51912, N'ProductVariant 2 does not exist.', 1;

PRINT N'[✓] Persisted checkpoints exist and are aligned.';
PRINT N'[✓] Existing checkpoints are within CDC retention.';
PRINT N'[✓] Status PENDING and channel ONLINE resolved.';
PRINT N'[✓] ProductVariant 1 and ProductVariant 2 exist.';

PRINT N'';
PRINT N'[2] RESOLVE CONTINUATION BOUNDARIES';
PRINT N'------------------------------------------------------------';

SET @TransactionFromLsn = sys.fn_cdc_increment_lsn(@TransactionCheckpoint);
SET @ItemFromLsn = sys.fn_cdc_increment_lsn(@ItemCheckpoint);

SELECT
    @TransactionCapture AS capture_instance,
    @TransactionCheckpoint AS checkpoint_before,
    @TransactionVersion AS checkpoint_version_before,
    @TransactionFromLsn AS from_lsn

UNION ALL

SELECT
    @ItemCapture,
    @ItemCheckpoint,
    @ItemVersion,
    @ItemFromLsn;

PRINT N'[✓] Both continuation FROM boundaries resolved from persisted checkpoints.';

PRINT N'';
PRINT N'[3] CREATE CONTROLLED CROSS-TABLE SOURCE TRANSACTION';
PRINT N'------------------------------------------------------------';

SET @TransactionAt = CONVERT(datetime2(0), SYSDATETIME());

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO sales.[Transaction]
    (
        TRN_transaction_at,
        TRN_CST_id,
        TRN_TRNST_id,
        TRN_TRNCH_id,
        TRN_gross_amount,
        TRN_discount_amount,
        TRN_created_at,
        TRN_updated_at
    )
    VALUES
    (
        @TransactionAt,
        NULL,
        @PendingStatusId,
        @OnlineChannelId,
        300.00,
        30.00,
        SYSDATETIME(),
        SYSDATETIME()
    );

    SET @TransactionId = CONVERT(bigint, SCOPE_IDENTITY());

    INSERT INTO sales.TransactionItem
    (
        TRNIT_transaction_at,
        TRNIT_TRN_id,
        TRNIT_PRDVA_id,
        TRNIT_quantity,
        TRNIT_unit_price,
        TRNIT_unit_discount,
        TRNIT_created_at,
        TRNIT_updated_at
    )
    VALUES
    (
        @TransactionAt,
        @TransactionId,
        1,
        1,
        200.00,
        20.00,
        SYSDATETIME(),
        SYSDATETIME()
    );

    SET @ItemId1 = CONVERT(bigint, SCOPE_IDENTITY());

    INSERT INTO sales.TransactionItem
    (
        TRNIT_transaction_at,
        TRNIT_TRN_id,
        TRNIT_PRDVA_id,
        TRNIT_quantity,
        TRNIT_unit_price,
        TRNIT_unit_discount,
        TRNIT_created_at,
        TRNIT_updated_at
    )
    VALUES
    (
        @TransactionAt,
        @TransactionId,
        2,
        1,
        100.00,
        10.00,
        SYSDATETIME(),
        SYSDATETIME()
    );

    SET @ItemId2 = CONVERT(bigint, SCOPE_IDENTITY());

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

PRINT N'[+] One SQL transaction committed with one parent and two child INSERTs.';
PRINT N'    TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);
PRINT N'    TRNIT_id #1 = ' + CONVERT(nvarchar(30), @ItemId1);
PRINT N'    TRNIT_id #2 = ' + CONVERT(nvarchar(30), @ItemId2);

PRINT N'';
PRINT N'[4] WAIT FOR COMPLETE CDC CAPTURE';
PRINT N'------------------------------------------------------------';

WHILE @Poll < @MaxPoll
BEGIN
    SET @ParentStartLsn = NULL;
    SET @ChildStartLsn1 = NULL;
    SET @ChildStartLsn2 = NULL;

    SELECT TOP (1)
        @ParentStartLsn = __$start_lsn
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        sys.fn_cdc_get_min_lsn(@TransactionCapture),
        sys.fn_cdc_get_max_lsn(),
        N'all update old'
    )
    WHERE TRN_id = @TransactionId
      AND __$operation = 2;

    SELECT
        @ChildStartLsn1 = MAX(CASE WHEN TRNIT_id = @ItemId1 THEN __$start_lsn END),
        @ChildStartLsn2 = MAX(CASE WHEN TRNIT_id = @ItemId2 THEN __$start_lsn END)
    FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
    (
        sys.fn_cdc_get_min_lsn(@ItemCapture),
        sys.fn_cdc_get_max_lsn(),
        N'all update old'
    )
    WHERE TRNIT_id IN (@ItemId1, @ItemId2)
      AND __$operation = 2;

    IF @ParentStartLsn IS NOT NULL
       AND @ChildStartLsn1 IS NOT NULL
       AND @ChildStartLsn2 IS NOT NULL
        BREAK;

    SET @Poll += 1;
    WAITFOR DELAY '00:00:01';
END;

IF @ParentStartLsn IS NULL
   OR @ChildStartLsn1 IS NULL
   OR @ChildStartLsn2 IS NULL
    THROW 51913, N'Complete controlled cross-table transaction was not captured by CDC within 30 seconds.', 1;

IF @ParentStartLsn <> @ChildStartLsn1
   OR @ParentStartLsn <> @ChildStartLsn2
    THROW 51914, N'Controlled parent and child CDC rows do not share one start_lsn.', 1;

SET @ToLsn = sys.fn_cdc_get_max_lsn();

IF @ToLsn IS NULL OR @ToLsn = 0x00000000000000000000
    THROW 51915, N'Unable to resolve a valid final TO LSN.', 1;

PRINT N'[✓] Parent and both child CDC INSERT rows are available.';
PRINT N'[✓] All three controlled events share one start_lsn.';
PRINT N'[✓] Shared TO boundary resolved after complete capture.';

PRINT N'';
PRINT N'[5] READ BOTH CAPTURE-INSTANCE WINDOWS';
PRINT N'------------------------------------------------------------';

INSERT INTO @TransactionWindow
(
    start_lsn, seqval, operation, update_mask,
    TRN_id, TRN_transaction_at, TRN_CST_id, TRN_TRNST_id, TRN_TRNCH_id,
    TRN_gross_amount, TRN_discount_amount, TRN_created_at, TRN_updated_at
)
SELECT
    __$start_lsn, __$seqval, __$operation, __$update_mask,
    TRN_id, TRN_transaction_at, TRN_CST_id, TRN_TRNST_id, TRN_TRNCH_id,
    TRN_gross_amount, TRN_discount_amount, TRN_created_at, TRN_updated_at
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @TransactionFromLsn,
    @ToLsn,
    N'all update old'
);

INSERT INTO @ItemWindow
(
    start_lsn, seqval, operation, update_mask,
    TRNIT_id, TRNIT_transaction_at, TRNIT_TRN_id, TRNIT_PRDVA_id,
    TRNIT_quantity, TRNIT_unit_price, TRNIT_unit_discount,
    TRNIT_created_at, TRNIT_updated_at
)
SELECT
    __$start_lsn, __$seqval, __$operation, __$update_mask,
    TRNIT_id, TRNIT_transaction_at, TRNIT_TRN_id, TRNIT_PRDVA_id,
    TRNIT_quantity, TRNIT_unit_price, TRNIT_unit_discount,
    TRNIT_created_at, TRNIT_updated_at
FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
(
    @ItemFromLsn,
    @ToLsn,
    N'all update old'
);

SELECT
    start_lsn,
    seqval,
    operation,
    update_mask,
    TRN_id,
    TRN_transaction_at,
    TRN_gross_amount,
    TRN_discount_amount
FROM @TransactionWindow
ORDER BY start_lsn, seqval;

SELECT
    start_lsn,
    seqval,
    operation,
    update_mask,
    TRNIT_id,
    TRNIT_transaction_at,
    TRNIT_TRN_id,
    TRNIT_PRDVA_id,
    TRNIT_quantity,
    TRNIT_unit_price,
    TRNIT_unit_discount
FROM @ItemWindow
ORDER BY start_lsn, seqval;

PRINT N'[✓] Both bounded CDC windows materialized successfully.';

PRINT N'';
PRINT N'[6] CONTROLLED EVENT VALIDATION';
PRINT N'------------------------------------------------------------';

SELECT @ParentControlledRows = COUNT_BIG(*)
FROM @TransactionWindow
WHERE TRN_id = @TransactionId
  AND operation = 2;

SELECT @ChildControlledRows = COUNT_BIG(*)
FROM @ItemWindow
WHERE TRNIT_id IN (@ItemId1, @ItemId2)
  AND TRNIT_TRN_id = @TransactionId
  AND operation = 2;

IF @ParentControlledRows <> 1
    THROW 51916, N'Controlled parent INSERT was not returned exactly once.', 1;

IF @ChildControlledRows <> 2
    THROW 51917, N'Controlled child INSERTs were not returned exactly twice.', 1;

IF EXISTS
(
    SELECT 1
    FROM @TransactionWindow
    WHERE TRN_id = @TransactionId
      AND
      (
          start_lsn <> @ParentStartLsn
          OR operation <> 2
      )
)
    THROW 51918, N'Controlled parent CDC representation is invalid.', 1;

IF EXISTS
(
    SELECT 1
    FROM @ItemWindow
    WHERE TRNIT_id IN (@ItemId1, @ItemId2)
      AND
      (
          start_lsn <> @ParentStartLsn
          OR operation <> 2
      )
)
    THROW 51919, N'Controlled child CDC representation is invalid.', 1;

PRINT N'[✓] Controlled parent INSERT returned exactly once.';
PRINT N'[✓] Controlled child INSERTs returned exactly twice.';
PRINT N'[✓] Consumer read preserved the shared transaction start_lsn.';
PRINT N'[✓] All controlled events are INSERT operations.';

PRINT N'';
PRINT N'[7] WINDOW SUMMARY';
PRINT N'------------------------------------------------------------';

SELECT
    @TransactionCapture AS capture_instance,
    COUNT_BIG(*) AS rows_processed,
    @TransactionFromLsn AS from_lsn,
    @ToLsn AS to_lsn
FROM @TransactionWindow

UNION ALL

SELECT
    @ItemCapture,
    COUNT_BIG(*),
    @ItemFromLsn,
    @ToLsn
FROM @ItemWindow;

PRINT N'[•] Checkpoint row counts represent all CDC rows in the completed window,';
PRINT N'    not only the three controlled events created by this script.';

PRINT N'';
PRINT N'[8] ATOMIC CHECKPOINT COMMIT';
PRINT N'------------------------------------------------------------';

DECLARE
    @TransactionRows bigint = (SELECT COUNT_BIG(*) FROM @TransactionWindow),
    @ItemRows bigint = (SELECT COUNT_BIG(*) FROM @ItemWindow);

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE control.CDCConsumerCheckpoint
    SET
        last_processed_lsn = @ToLsn,
        last_processed_at = SYSUTCDATETIME(),
        last_window_rows = @TransactionRows,
        checkpoint_version = checkpoint_version + 1,
        updated_at = SYSUTCDATETIME()
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @TransactionCapture
      AND last_processed_lsn = @TransactionCheckpoint
      AND checkpoint_version = @TransactionVersion;

    IF @@ROWCOUNT <> 1
        THROW 51920, N'sales_Transaction checkpoint changed concurrently.', 1;

    UPDATE control.CDCConsumerCheckpoint
    SET
        last_processed_lsn = @ToLsn,
        last_processed_at = SYSUTCDATETIME(),
        last_window_rows = @ItemRows,
        checkpoint_version = checkpoint_version + 1,
        updated_at = SYSUTCDATETIME()
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @ItemCapture
      AND last_processed_lsn = @ItemCheckpoint
      AND checkpoint_version = @ItemVersion;

    IF @@ROWCOUNT <> 1
        THROW 51921, N'sales_TransactionItem checkpoint changed concurrently.', 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

PRINT N'[+] Both capture-instance checkpoints committed atomically.';

PRINT N'';
PRINT N'[9] FINAL CHECKPOINT VALIDATION';
PRINT N'------------------------------------------------------------';

IF
(
    SELECT COUNT(*)
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN (@TransactionCapture, @ItemCapture)
      AND last_processed_lsn = @ToLsn
) <> 2
    THROW 51922, N'Final checkpoint alignment validation failed.', 1;

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

PRINT N'[✓] Both checkpoints equal the completed shared TO boundary.';

PRINT N'';
PRINT N'[10] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC cross-table consumption validated successfully.';
PRINT N'[✓] One controlled SQL transaction produced one parent and two child INSERTs.';
PRINT N'[✓] Parent event was consumed exactly once.';
PRINT N'[✓] Two child events were consumed exactly once each.';
PRINT N'[✓] Shared transaction start_lsn was preserved across capture instances.';
PRINT N'[✓] Both capture-instance checkpoints advanced atomically after validation.';
PRINT N'[•] Controlled source rows were preserved for subsequent tests.';
PRINT N'';
