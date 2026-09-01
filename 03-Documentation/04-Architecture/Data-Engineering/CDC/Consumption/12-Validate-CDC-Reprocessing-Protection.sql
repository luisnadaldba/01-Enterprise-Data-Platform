/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 12-Validate-CDC-Reprocessing-Protection.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Consumer      : AtlasEngineering.CDCConsumption.V1
    Purpose       : Validate checkpoint-based reprocessing protection by
                    consuming one new controlled event, persisting the completed
                    window, then proving a normal restart does not return that
                    acknowledged event again. Also validates that a stale
                    checkpoint writer cannot overwrite newer progress.
    Rerunnable    : Controlled - each successful execution creates one new
                    sales.Transaction test row
    Destructive   : No
    Changes State : Yes - inserts one controlled source row and advances both
                    consumer checkpoints after successful processing

    Validation Contract
    --------------------------------------------------------------------------
    1. Resolve the aligned persisted V1 checkpoints.
    2. Create one new controlled Event E after the persisted checkpoint.
    3. Wait until Event E is available through SQL Server CDC.
    4. Read one bounded continuation window and prove Event E appears exactly
       once.
    5. Advance both capture-instance checkpoints atomically to the completed TO
       boundary.
    6. Restart from:
           fn_cdc_increment_lsn(new_checkpoint)
       and prove Event E does not reappear.
    7. Attempt a stale checkpoint write using the old checkpoint/version and
       prove the optimistic concurrency guard rejects it.

    Scope
    --------------------------------------------------------------------------
    This validates checkpoint-level reprocessing protection.

    It does NOT claim end-to-end exactly-once delivery to a downstream target.
    Exactly-once effects at Bronze/Silver require an idempotent downstream write
    contract, which is outside this laboratory script.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @ConsumerName nvarchar(128) = N'AtlasEngineering.CDCConsumption.V1',
    @TransactionCapture sysname = N'sales_Transaction',
    @ItemCapture sysname = N'sales_TransactionItem',

    @TransactionCheckpointBefore binary(10),
    @ItemCheckpointBefore binary(10),
    @TransactionVersionBefore bigint,
    @ItemVersionBefore bigint,

    @TransactionMinLsn binary(10),
    @ItemMinLsn binary(10),
    @TransactionFromLsn binary(10),
    @ItemFromLsn binary(10),

    @PendingStatusId tinyint,
    @OnlineChannelId tinyint,

    @EventEId bigint,
    @EventETransactionAt datetime2(0),
    @EventEStartLsn binary(10),

    @ToLsn binary(10),
    @RestartFromLsn binary(10),
    @RestartToLsn binary(10),

    @EventERowsFirstRead bigint = 0,
    @EventERowsRestart bigint = 0,
    @TransactionRows bigint = 0,
    @ItemRows bigint = 0,

    @Poll int = 0,
    @MaxPoll int = 30,
    @StaleUpdateRows int = 0;

PRINT N'';
PRINT N'ATLAS ENGINEERING - VALIDATE CDC REPROCESSING PROTECTION';
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
    THROW 52100, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;

IF OBJECT_ID(N'control.CDCConsumerCheckpoint', N'U') IS NULL
    THROW 52101, N'control.CDCConsumerCheckpoint does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
    THROW 52102, N'sales_Transaction all-changes function does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF') IS NULL
    THROW 52103, N'sales_TransactionItem all-changes function does not exist.', 1;

SELECT
    @TransactionCheckpointBefore = last_processed_lsn,
    @TransactionVersionBefore = checkpoint_version
FROM control.CDCConsumerCheckpoint
WHERE consumer_name = @ConsumerName
  AND capture_instance = @TransactionCapture;

SELECT
    @ItemCheckpointBefore = last_processed_lsn,
    @ItemVersionBefore = checkpoint_version
FROM control.CDCConsumerCheckpoint
WHERE consumer_name = @ConsumerName
  AND capture_instance = @ItemCapture;

IF @TransactionCheckpointBefore IS NULL OR @ItemCheckpointBefore IS NULL
    THROW 52104, N'Both V1 checkpoints must contain persisted progress.', 1;

IF @TransactionCheckpointBefore <> @ItemCheckpointBefore
    THROW 52105, N'V1 capture-instance checkpoints are not aligned.', 1;

SET @TransactionMinLsn = sys.fn_cdc_get_min_lsn(@TransactionCapture);
SET @ItemMinLsn = sys.fn_cdc_get_min_lsn(@ItemCapture);

IF @TransactionCheckpointBefore < @TransactionMinLsn
    THROW 52106, N'sales_Transaction checkpoint is older than min_available_lsn.', 1;

IF @ItemCheckpointBefore < @ItemMinLsn
    THROW 52107, N'sales_TransactionItem checkpoint is older than min_available_lsn.', 1;

SELECT TOP (1)
    @PendingStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE UPPER(TRNST_name) = N'PENDING';

IF @PendingStatusId IS NULL
    THROW 52108, N'Status PENDING could not be resolved.', 1;

SELECT TOP (1)
    @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_name = N'Online transaction';

IF @OnlineChannelId IS NULL
    THROW 52109, N'Channel Online transaction could not be resolved.', 1;

PRINT N'[✓] Persisted checkpoints exist and are aligned.';
PRINT N'[✓] Existing checkpoints are within CDC retention.';
PRINT N'[✓] Status PENDING and channel Online transaction resolved.';

PRINT N'';
PRINT N'[2] RESOLVE CONTINUATION BOUNDARIES';
PRINT N'------------------------------------------------------------';

SET @TransactionFromLsn =
    sys.fn_cdc_increment_lsn(@TransactionCheckpointBefore);

SET @ItemFromLsn =
    sys.fn_cdc_increment_lsn(@ItemCheckpointBefore);

SELECT
    @TransactionCapture AS capture_instance,
    @TransactionCheckpointBefore AS checkpoint_before,
    @TransactionVersionBefore AS checkpoint_version_before,
    @TransactionFromLsn AS from_lsn
UNION ALL
SELECT
    @ItemCapture,
    @ItemCheckpointBefore,
    @ItemVersionBefore,
    @ItemFromLsn;

PRINT N'[✓] Continuation FROM boundaries resolved from the persisted checkpoint.';

PRINT N'';
PRINT N'[3] CREATE CONTROLLED EVENT E';
PRINT N'------------------------------------------------------------';

SET @EventETransactionAt = CONVERT(datetime2(0), SYSDATETIME());

DECLARE @InsertedEventE TABLE
(
    TRN_id bigint NOT NULL,
    TRN_transaction_at datetime2(0) NOT NULL
);

INSERT INTO sales.[Transaction]
(
    TRN_CST_id,
    TRN_TRNST_id,
    TRN_TRNCH_id,
    TRN_transaction_at,
    TRN_gross_amount,
    TRN_discount_amount
)
OUTPUT
    inserted.TRN_id,
    inserted.TRN_transaction_at
INTO @InsertedEventE
(
    TRN_id,
    TRN_transaction_at
)
VALUES
(
    NULL,
    @PendingStatusId,
    @OnlineChannelId,
    @EventETransactionAt,
    320.00,
    32.00
);

SELECT
    @EventEId = TRN_id,
    @EventETransactionAt = TRN_transaction_at
FROM @InsertedEventE;

IF @EventEId IS NULL
    THROW 52110, N'Controlled Event E could not be created.', 1;

PRINT N'[+] Event E inserted after the persisted checkpoint.';
PRINT N'    Event E TRN_id = ' + CONVERT(nvarchar(30), @EventEId);

PRINT N'';
PRINT N'[4] WAIT FOR EVENT E CDC CAPTURE';
PRINT N'------------------------------------------------------------';

WHILE @Poll < @MaxPoll
BEGIN
    SET @ToLsn = sys.fn_cdc_get_max_lsn();

    IF @TransactionFromLsn <= @ToLsn
    BEGIN
        SELECT TOP (1)
            @EventEStartLsn = __$start_lsn
        FROM cdc.fn_cdc_get_all_changes_sales_Transaction
        (
            @TransactionFromLsn,
            @ToLsn,
            N'all update old'
        )
        WHERE TRN_id = @EventEId
          AND TRN_transaction_at = @EventETransactionAt
          AND __$operation = 2
        ORDER BY __$start_lsn;
    END;

    IF @EventEStartLsn IS NOT NULL
        BREAK;

    SET @Poll += 1;
    WAITFOR DELAY '00:00:01';
END;

IF @EventEStartLsn IS NULL
    THROW 52111, N'Event E was not captured by CDC within 30 seconds.', 1;

SET @ToLsn = sys.fn_cdc_get_max_lsn();

PRINT N'[✓] Event E CDC row is available.';
PRINT N'[✓] Shared TO boundary resolved after Event E capture.';

PRINT N'';
PRINT N'[5] FIRST READ - EVENT E MUST APPEAR ONCE';
PRINT N'------------------------------------------------------------';

SELECT @EventERowsFirstRead = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @TransactionFromLsn,
    @ToLsn,
    N'all update old'
)
WHERE TRN_id = @EventEId
  AND __$operation = 2;

IF @EventERowsFirstRead <> 1
    THROW 52112, N'Event E must appear exactly once before checkpoint acknowledgement.', 1;

SELECT
    __$start_lsn,
    __$seqval,
    __$operation,
    __$update_mask,
    sys.fn_cdc_map_lsn_to_time(__$start_lsn) AS cdc_transaction_time,
    TRN_id,
    TRN_transaction_at,
    TRN_TRNST_id,
    TRN_TRNCH_id,
    TRN_gross_amount,
    TRN_discount_amount
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @TransactionFromLsn,
    @ToLsn,
    N'all update old'
)
WHERE TRN_id = @EventEId
ORDER BY __$start_lsn, __$seqval, __$operation;

SELECT @TransactionRows = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @TransactionFromLsn,
    @ToLsn,
    N'all update old'
);

IF @ItemFromLsn <= @ToLsn
BEGIN
    SELECT @ItemRows = COUNT_BIG(*)
    FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
    (
        @ItemFromLsn,
        @ToLsn,
        N'all update old'
    );
END;

PRINT N'[✓] Event E was returned exactly once before acknowledgement.';

PRINT N'';
PRINT N'[6] ATOMIC CHECKPOINT ACKNOWLEDGEMENT';
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
      AND last_processed_lsn = @TransactionCheckpointBefore
      AND checkpoint_version = @TransactionVersionBefore;

    IF @@ROWCOUNT <> 1
        THROW 52113, N'sales_Transaction checkpoint changed concurrently.', 1;

    UPDATE control.CDCConsumerCheckpoint
    SET
        last_processed_lsn = @ToLsn,
        last_processed_at = SYSUTCDATETIME(),
        last_window_rows = @ItemRows,
        checkpoint_version = checkpoint_version + 1,
        updated_at = SYSUTCDATETIME()
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @ItemCapture
      AND last_processed_lsn = @ItemCheckpointBefore
      AND checkpoint_version = @ItemVersionBefore;

    IF @@ROWCOUNT <> 1
        THROW 52114, N'sales_TransactionItem checkpoint changed concurrently.', 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

PRINT N'[+] Event E window acknowledged successfully.';
PRINT N'[+] Both capture-instance checkpoints advanced atomically.';

PRINT N'';
PRINT N'[7] RESTART AFTER ACKNOWLEDGEMENT';
PRINT N'------------------------------------------------------------';

SET @RestartFromLsn = sys.fn_cdc_increment_lsn(@ToLsn);
SET @RestartToLsn = sys.fn_cdc_get_max_lsn();

IF @RestartFromLsn <= @RestartToLsn
BEGIN
    SELECT @EventERowsRestart = COUNT_BIG(*)
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        @RestartFromLsn,
        @RestartToLsn,
        N'all update old'
    )
    WHERE TRN_id = @EventEId;
END
ELSE
BEGIN
    SET @EventERowsRestart = 0;
    PRINT N'[•] No newer CDC boundary exists after the acknowledged checkpoint.';
END;

IF @EventERowsRestart <> 0
    THROW 52115, N'Event E reappeared during normal restart after acknowledgement.', 1;

PRINT N'[✓] Normal restart begins after the acknowledged TO boundary.';
PRINT N'[✓] Event E did not reappear after successful acknowledgement.';

PRINT N'';
PRINT N'[8] STALE CHECKPOINT WRITER PROTECTION';
PRINT N'------------------------------------------------------------';

BEGIN TRANSACTION;

UPDATE control.CDCConsumerCheckpoint
SET
    last_processed_lsn = @TransactionCheckpointBefore,
    last_processed_at = SYSUTCDATETIME(),
    checkpoint_version = checkpoint_version + 1,
    updated_at = SYSUTCDATETIME()
WHERE consumer_name = @ConsumerName
  AND capture_instance = @TransactionCapture
  AND last_processed_lsn = @TransactionCheckpointBefore
  AND checkpoint_version = @TransactionVersionBefore;

SET @StaleUpdateRows = @@ROWCOUNT;

ROLLBACK TRANSACTION;

IF @StaleUpdateRows <> 0
    THROW 52116, N'Stale checkpoint writer unexpectedly matched the current checkpoint row.', 1;

PRINT N'[✓] Stale checkpoint/version pair matched 0 rows.';
PRINT N'[✓] Older processing state cannot overwrite newer acknowledged progress.';

PRINT N'';
PRINT N'[9] FINAL CHECKPOINT STATE';
PRINT N'------------------------------------------------------------';

IF
(
    SELECT COUNT_BIG(*)
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN (@TransactionCapture, @ItemCapture)
      AND last_processed_lsn = @ToLsn
) <> 2
    THROW 52117, N'Final checkpoint alignment validation failed.', 1;

SELECT
    consumer_name,
    capture_instance,
    last_processed_lsn,
    sys.fn_cdc_map_lsn_to_time(last_processed_lsn) AS last_processed_lsn_time,
    last_window_rows,
    checkpoint_version,
    last_processed_at,
    updated_at
FROM control.CDCConsumerCheckpoint
WHERE consumer_name = @ConsumerName
  AND capture_instance IN (@TransactionCapture, @ItemCapture)
ORDER BY capture_instance;

PRINT N'[✓] Both checkpoints remain aligned at the acknowledged TO boundary.';

PRINT N'';
PRINT N'[10] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC checkpoint-based reprocessing protection validated successfully.';
PRINT N'[✓] Event E was consumed exactly once before acknowledgement.';
PRINT N'[✓] Event E did not reappear during normal checkpoint-based restart.';
PRINT N'[✓] Stale checkpoint writer was rejected by the optimistic concurrency guard.';
PRINT N'[✓] Both capture-instance checkpoints remain aligned.';
PRINT N'[•] This test does not claim downstream exactly-once delivery.';
PRINT N'[•] Controlled Event E source row was preserved for subsequent tests.';
PRINT N'';
