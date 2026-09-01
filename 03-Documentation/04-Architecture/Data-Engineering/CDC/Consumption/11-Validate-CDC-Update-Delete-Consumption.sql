/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 11-Validate-CDC-Update-Delete-Consumption-v1.0.1.sql
    Version       : 1.0.1
    Target        : AtlasCommerce
    Consumer      : AtlasEngineering.CDCConsumption.V1
    Purpose       : Validate consumer-side INSERT, UPDATE before/after and
                    DELETE semantics for one controlled sales.Transaction row,
                    then advance both consumer checkpoints atomically.
    Rerunnable    : Controlled - each successful execution creates, updates
                    and deletes one new sales.Transaction test row
    Destructive   : Controlled - deletes only the source row created by this
                    execution
    Changes State : Yes - creates/updates/deletes one controlled source row
                    and advances both consumer checkpoints after validation

    Validation Contract
    --------------------------------------------------------------------------
    1. Start from the aligned persisted V1 checkpoints.
    2. Create one controlled PENDING sales.Transaction row.
    3. Update that row from PENDING to CONFIRMED.
    4. Delete that same controlled row.
    5. Wait until CDC exposes the complete lifecycle.
    6. Read the bounded window through the official all-changes function using
       the "all update old" row-filter option.
    7. Prove the controlled lifecycle is represented exactly as:
           - INSERT        = operation 2;
           - UPDATE before = operation 3;
           - UPDATE after  = operation 4;
           - DELETE        = operation 1.
    8. Prove the UPDATE before/after pair shares start_lsn and seqval.
    9. Prove the expected update masks:
           - INSERT = 0x01FF;
           - UPDATE = 0x0108;
           - DELETE = 0x01FF.
   10. Advance both capture-instance checkpoints atomically only after every
       validation succeeds.

    Deterministic Update Timestamp
    --------------------------------------------------------------------------
    TRN_updated_at is advanced by exactly one second during the controlled
    UPDATE. This guarantees that both TRN_TRNST_id and TRN_updated_at change
    physically, making the expected UPDATE mask 0x0108 deterministic.

    Important
    --------------------------------------------------------------------------
    - This validates consumer interpretation, not only Change Table anatomy.
    - No Bronze/Silver target is written by this laboratory script.
    - The controlled source row is absent after successful execution.
    - No pre-existing business row is updated or deleted.
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
    @ConfirmedStatusId tinyint,
    @OnlineChannelId tinyint,

    @TransactionId bigint,
    @TransactionAt datetime2(0),

    @Poll int = 0,
    @MaxPoll int = 30,
    @LifecycleRows bigint;

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
PRINT N'ATLAS ENGINEERING - VALIDATE CDC UPDATE / DELETE CONSUMPTION';
PRINT N'============================================================';

PRINT N'';
PRINT N'[1] PRECONDITION VALIDATION';
PRINT N'------------------------------------------------------------';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE name = DB_NAME()
      AND state_desc = N'ONLINE'
      AND is_cdc_enabled = 1
)
    THROW 52001, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;

IF OBJECT_ID(N'control.CDCConsumerCheckpoint', N'U') IS NULL
    THROW 52002, N'control.CDCConsumerCheckpoint does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
    THROW 52003, N'sales_Transaction all-changes function does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF') IS NULL
    THROW 52004, N'sales_TransactionItem all-changes function does not exist.', 1;

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
    THROW 52005, N'Both V1 persisted checkpoints must be initialized.', 1;

IF @TransactionCheckpoint <> @ItemCheckpoint
    THROW 52006, N'V1 capture-instance checkpoints are not aligned.', 1;

SET @TransactionMinLsn = sys.fn_cdc_get_min_lsn(@TransactionCapture);
SET @ItemMinLsn = sys.fn_cdc_get_min_lsn(@ItemCapture);

IF @TransactionCheckpoint < @TransactionMinLsn
    THROW 52007, N'sales_Transaction checkpoint is older than min_available_lsn.', 1;

IF @ItemCheckpoint < @ItemMinLsn
    THROW 52008, N'sales_TransactionItem checkpoint is older than min_available_lsn.', 1;

SELECT TOP (1)
    @PendingStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE UPPER(TRNST_name) = N'PENDING';

IF @PendingStatusId IS NULL
    THROW 52009, N'Status PENDING could not be resolved.', 1;

SELECT TOP (1)
    @ConfirmedStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE UPPER(TRNST_name) = N'CONFIRMED';

IF @ConfirmedStatusId IS NULL
    THROW 52010, N'Status CONFIRMED could not be resolved.', 1;

SELECT TOP (1)
    @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_name = N'Online transaction';

IF @OnlineChannelId IS NULL
    THROW 52011, N'Channel Online transaction could not be resolved.', 1;

PRINT N'[✓] Persisted checkpoints exist and are aligned.';
PRINT N'[✓] Existing checkpoints are within CDC retention.';
PRINT N'[✓] Status PENDING and CONFIRMED resolved.';
PRINT N'[✓] Channel Online transaction resolved.';

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
PRINT N'[3] CREATE CONTROLLED INSERT';
PRINT N'------------------------------------------------------------';

SET @TransactionAt = CONVERT(datetime2(0), SYSDATETIME());

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
    310.00,
    31.00,
    SYSDATETIME(),
    SYSDATETIME()
);

SET @TransactionId = CONVERT(bigint, SCOPE_IDENTITY());

IF @TransactionId IS NULL
    THROW 52012, N'Controlled Transaction identity could not be resolved.', 1;

PRINT N'[+] Controlled PENDING transaction inserted.';
PRINT N'    TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);

PRINT N'';
PRINT N'[4] CONTROLLED UPDATE';
PRINT N'------------------------------------------------------------';

UPDATE sales.[Transaction]
SET
    TRN_TRNST_id = @ConfirmedStatusId,
    TRN_updated_at = DATEADD(SECOND, 1, TRN_updated_at)
WHERE TRN_id = @TransactionId;

IF @@ROWCOUNT <> 1
    THROW 52013, N'Controlled Transaction UPDATE did not affect exactly one row.', 1;

PRINT N'[+] Controlled transaction updated from PENDING to CONFIRMED.';

PRINT N'';
PRINT N'[5] CONTROLLED DELETE';
PRINT N'------------------------------------------------------------';

DELETE FROM sales.[Transaction]
WHERE TRN_id = @TransactionId;

IF @@ROWCOUNT <> 1
    THROW 52014, N'Controlled Transaction DELETE did not affect exactly one row.', 1;

IF EXISTS (SELECT 1 FROM sales.[Transaction] WHERE TRN_id = @TransactionId)
    THROW 52015, N'Controlled source row still exists after DELETE.', 1;

PRINT N'[+] Controlled transaction deleted.';
PRINT N'[✓] Controlled source row is absent after DELETE.';

PRINT N'';
PRINT N'[6] WAIT FOR COMPLETE CDC LIFECYCLE';
PRINT N'------------------------------------------------------------';

WHILE @Poll < @MaxPoll
BEGIN
    SET @ToLsn = sys.fn_cdc_get_max_lsn();

    IF @ToLsn >= @TransactionFromLsn
    BEGIN
        SELECT
            @LifecycleRows = COUNT_BIG(*)
        FROM cdc.fn_cdc_get_all_changes_sales_Transaction
        (
            @TransactionFromLsn,
            @ToLsn,
            N'all update old'
        )
        WHERE TRN_id = @TransactionId;

        IF @LifecycleRows = 4
           AND EXISTS
               (
                   SELECT 1
                   FROM cdc.fn_cdc_get_all_changes_sales_Transaction
                   (
                       @TransactionFromLsn,
                       @ToLsn,
                       N'all update old'
                   )
                   WHERE TRN_id = @TransactionId
                     AND __$operation = 1
               )
            BREAK;
    END;

    SET @Poll += 1;
    WAITFOR DELAY '00:00:01';
END;

IF @LifecycleRows <> 4
    THROW 52016, N'Complete controlled CDC lifecycle was not captured within 30 seconds.', 1;

SET @ToLsn = sys.fn_cdc_get_max_lsn();

PRINT N'[✓] Complete INSERT / UPDATE before / UPDATE after / DELETE lifecycle is available.';
PRINT N'[✓] Shared TO boundary resolved after complete capture.';
PRINT N'    Polling attempts = ' + CONVERT(nvarchar(10), @Poll + 1);

PRINT N'';
PRINT N'[7] READ BOTH CAPTURE-INSTANCE WINDOWS';
PRINT N'------------------------------------------------------------';

INSERT INTO @TransactionWindow
(
    start_lsn,
    seqval,
    operation,
    update_mask,
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

INSERT INTO @ItemWindow
(
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

SELECT
    start_lsn,
    seqval,
    operation,
    update_mask,
    sys.fn_cdc_map_lsn_to_time(start_lsn) AS cdc_transaction_time,
    TRN_id,
    TRN_transaction_at,
    TRN_TRNST_id,
    TRN_TRNCH_id,
    TRN_gross_amount,
    TRN_discount_amount,
    TRN_created_at,
    TRN_updated_at
FROM @TransactionWindow
WHERE TRN_id = @TransactionId
ORDER BY start_lsn, seqval, operation;

PRINT N'[✓] Both bounded CDC windows materialized successfully.';

PRINT N'';
PRINT N'[8] CONTROLLED LIFECYCLE VALIDATION';
PRINT N'------------------------------------------------------------';

IF (SELECT COUNT_BIG(*) FROM @TransactionWindow WHERE TRN_id = @TransactionId) <> 4
    THROW 52017, N'Controlled lifecycle did not return exactly four CDC rows.', 1;

IF (SELECT COUNT_BIG(*) FROM @TransactionWindow WHERE TRN_id = @TransactionId AND operation = 2) <> 1
    THROW 52018, N'Controlled INSERT was not returned exactly once.', 1;

IF (SELECT COUNT_BIG(*) FROM @TransactionWindow WHERE TRN_id = @TransactionId AND operation = 3) <> 1
    THROW 52019, N'Controlled UPDATE before image was not returned exactly once.', 1;

IF (SELECT COUNT_BIG(*) FROM @TransactionWindow WHERE TRN_id = @TransactionId AND operation = 4) <> 1
    THROW 52020, N'Controlled UPDATE after image was not returned exactly once.', 1;

IF (SELECT COUNT_BIG(*) FROM @TransactionWindow WHERE TRN_id = @TransactionId AND operation = 1) <> 1
    THROW 52021, N'Controlled DELETE was not returned exactly once.', 1;

IF EXISTS
(
    SELECT 1
    FROM @TransactionWindow
    WHERE TRN_id = @TransactionId
      AND operation IN (2, 1)
      AND update_mask <> 0x01FF
)
    THROW 52022, N'Controlled INSERT/DELETE update mask is not 0x01FF.', 1;

IF EXISTS
(
    SELECT 1
    FROM @TransactionWindow
    WHERE TRN_id = @TransactionId
      AND operation IN (3, 4)
      AND update_mask <> 0x0108
)
    THROW 52023, N'Controlled UPDATE pair update mask is not 0x0108.', 1;

DECLARE
    @UpdateBeforeStartLsn binary(10),
    @UpdateAfterStartLsn binary(10),
    @UpdateBeforeSeqval binary(10),
    @UpdateAfterSeqval binary(10),
    @BeforeStatus tinyint,
    @AfterStatus tinyint,
    @DeleteStatus tinyint;

SELECT
    @UpdateBeforeStartLsn = start_lsn,
    @UpdateBeforeSeqval = seqval,
    @BeforeStatus = TRN_TRNST_id
FROM @TransactionWindow
WHERE TRN_id = @TransactionId
  AND operation = 3;

SELECT
    @UpdateAfterStartLsn = start_lsn,
    @UpdateAfterSeqval = seqval,
    @AfterStatus = TRN_TRNST_id
FROM @TransactionWindow
WHERE TRN_id = @TransactionId
  AND operation = 4;

SELECT
    @DeleteStatus = TRN_TRNST_id
FROM @TransactionWindow
WHERE TRN_id = @TransactionId
  AND operation = 1;

IF @UpdateBeforeStartLsn <> @UpdateAfterStartLsn
    THROW 52024, N'UPDATE before/after images do not share start_lsn.', 1;

IF @UpdateBeforeSeqval <> @UpdateAfterSeqval
    THROW 52025, N'UPDATE before/after images do not share seqval.', 1;

IF @BeforeStatus <> @PendingStatusId OR @AfterStatus <> @ConfirmedStatusId
    THROW 52026, N'UPDATE pair does not represent PENDING -> CONFIRMED.', 1;

IF @DeleteStatus <> @ConfirmedStatusId
    THROW 52027, N'DELETE image does not preserve the final CONFIRMED state.', 1;

PRINT N'[✓] INSERT operation = 2 exactly once.';
PRINT N'[✓] UPDATE before image = operation 3 exactly once.';
PRINT N'[✓] UPDATE after image = operation 4 exactly once.';
PRINT N'[✓] DELETE operation = 1 exactly once.';
PRINT N'[✓] UPDATE before/after images share start_lsn and seqval.';
PRINT N'[✓] Status transition = PENDING -> CONFIRMED.';
PRINT N'[✓] DELETE preserves the final CONFIRMED source image.';
PRINT N'[✓] INSERT/DELETE mask = 0x01FF; UPDATE mask = 0x0108.';

PRINT N'';
PRINT N'[9] WINDOW SUMMARY';
PRINT N'------------------------------------------------------------';

DECLARE
    @TransactionRows bigint = (SELECT COUNT_BIG(*) FROM @TransactionWindow),
    @ItemRows bigint = (SELECT COUNT_BIG(*) FROM @ItemWindow);

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

PRINT N'[•] Checkpoint row counts represent all CDC rows in the completed window.';
PRINT N'[•] sales.TransactionItem is advanced through the same shared TO boundary.';

PRINT N'';
PRINT N'[10] ATOMIC CHECKPOINT COMMIT';
PRINT N'------------------------------------------------------------';

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
        THROW 52028, N'sales_Transaction checkpoint changed concurrently.', 1;

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
        THROW 52029, N'sales_TransactionItem checkpoint changed concurrently.', 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

PRINT N'[+] Both capture-instance checkpoints committed atomically.';

PRINT N'';
PRINT N'[11] FINAL CHECKPOINT VALIDATION';
PRINT N'------------------------------------------------------------';

IF
(
    SELECT COUNT_BIG(*)
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN (@TransactionCapture, @ItemCapture)
      AND last_processed_lsn = @ToLsn
) <> 2
    THROW 52030, N'Final checkpoints do not both equal the completed TO boundary.', 1;

SELECT
    consumer_name,
    capture_instance,
    last_processed_lsn,
    last_window_rows,
    checkpoint_version,
    last_processed_at,
    updated_at
FROM control.CDCConsumerCheckpoint
WHERE consumer_name = @ConsumerName
  AND capture_instance IN (@TransactionCapture, @ItemCapture)
ORDER BY capture_instance;

PRINT N'[✓] Both checkpoints equal the completed shared TO boundary.';

PRINT N'';
PRINT N'[12] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC UPDATE / DELETE consumption semantics validated successfully.';
PRINT N'[✓] Controlled INSERT was consumed exactly once.';
PRINT N'[✓] Controlled UPDATE before/after images were consumed exactly once each.';
PRINT N'[✓] Controlled DELETE was consumed exactly once.';
PRINT N'[✓] UPDATE transition PENDING -> CONFIRMED was preserved.';
PRINT N'[✓] Expected CDC update masks were validated.';
PRINT N'[✓] Controlled source row is absent after the completed lifecycle.';
PRINT N'[✓] Both capture-instance checkpoints advanced atomically after validation.';
PRINT N'';
