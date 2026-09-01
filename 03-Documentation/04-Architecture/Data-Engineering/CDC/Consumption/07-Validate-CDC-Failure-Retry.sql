/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 07-Validate-CDC-Failure-Retry-v1.0.3.sql
    Version       : 1.0.3
    Target        : AtlasCommerce
    Consumer      : AtlasEngineering.CDCConsumption.V1
    Purpose       : Validate failure/retry semantics from a persisted
                    checkpoint, prove that failed processing does not advance
                    the checkpoint, then retry and consume the same controlled
                    event exactly once.
    Rerunnable    : Controlled - reuses Event D when it already exists;
                    otherwise creates one new sales.Transaction test row
    Destructive   : No
    Changes State : Yes - may insert one controlled source row and advances
                    both consumer checkpoints only after successful retry

    Validation Contract
    --------------------------------------------------------------------------
    1. Resolve the persisted checkpoints for both capture instances.
    2. Create or reuse controlled Event D.
    3. Wait until Event D is available through SQL Server CDC.
    4. Read Event D from the current continuation window.
    5. Simulate a processing failure before checkpoint persistence.
    6. Prove that neither checkpoint advanced after the failed attempt.
    7. Retry from the unchanged persisted checkpoint.
    8. Prove Event D is replayed exactly once.
    9. Advance both capture-instance checkpoints atomically only after the
       successful retry.

    Important
    --------------------------------------------------------------------------
    The simulated processing failure is intentional and handled by this script.
    No downstream Bronze/Silver write is performed.

==============================================================================*/

USE AtlasCommerce;
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE
    @ConsumerName nvarchar(200) = N'AtlasEngineering.CDCConsumption.V1',
    @TransactionCapture sysname = N'sales_Transaction',
    @ItemCapture sysname = N'sales_TransactionItem',
    @PendingStatusId tinyint,
    @OnlineChannelId tinyint,

    @CheckpointBefore binary(10),
    @ItemCheckpointBefore binary(10),
    @TransactionVersionBefore bigint,
    @ItemVersionBefore bigint,

    @FromTransaction binary(10),
    @FromItem binary(10),
    @FailureToLsn binary(10),
    @RetryToLsn binary(10),

    @EventDId bigint,
    @EventDTransactionAt datetime2(0),
    @EventDGross decimal(19,4) = 240.00,
    @EventDDiscount decimal(19,4) = 24.00,
    @EventDStartLsn binary(10),

    @FailureEventDRows int = 0,
    @RetryEventDRows int = 0,
    @ItemRows int = 0,
    @PollingAttempts int = 0,
    @FailureWasSimulated bit = 0;

PRINT N' ';
PRINT N'ATLAS ENGINEERING - VALIDATE CDC FAILURE / RETRY CHECKPOINT SEMANTICS';
PRINT N'============================================================';
PRINT N' ';

PRINT N'[1] PRECONDITION VALIDATION';
PRINT N'------------------------------------------------------------';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE database_id = DB_ID()
      AND is_cdc_enabled = 1
)
    THROW 51600, N'Database-level CDC is not enabled.', 1;

IF OBJECT_ID(N'control.CDCConsumerCheckpoint', N'U') IS NULL
    THROW 51601, N'control.CDCConsumerCheckpoint does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
    THROW 51602, N'sales_Transaction all-changes function does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF') IS NULL
    THROW 51603, N'sales_TransactionItem all-changes function does not exist.', 1;

SELECT @PendingStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = N'PENDING';

SELECT @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = N'ONLINE';

IF @PendingStatusId IS NULL
    THROW 51604, N'Status PENDING could not be resolved.', 1;

IF @OnlineChannelId IS NULL
    THROW 51605, N'Channel ONLINE could not be resolved.', 1;

SELECT
    @CheckpointBefore = last_processed_lsn,
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

IF @CheckpointBefore IS NULL OR @ItemCheckpointBefore IS NULL
    THROW 51606, N'Both checkpoints must already contain a successfully processed LSN.', 1;

IF @CheckpointBefore <> @ItemCheckpointBefore
    THROW 51607, N'Capture-instance checkpoints are not aligned before the test.', 1;

IF @CheckpointBefore < sys.fn_cdc_get_min_lsn(@TransactionCapture)
   OR @ItemCheckpointBefore < sys.fn_cdc_get_min_lsn(@ItemCapture)
    THROW 51608, N'Existing checkpoint is behind CDC retention.', 1;

PRINT N'[✓] Persisted checkpoints exist and are aligned.';
PRINT N'[✓] Existing checkpoints are within CDC retention.';
PRINT N'[✓] Status PENDING and channel ONLINE resolved.';
PRINT N' ';

PRINT N'[2] CREATE OR REUSE CONTROLLED EVENT D';
PRINT N'------------------------------------------------------------';

DECLARE @ExistingEventDCount int;

SELECT @ExistingEventDCount = COUNT(*)
FROM sales.[Transaction]
WHERE TRN_CST_id IS NULL
  AND TRN_TRNST_id = @PendingStatusId
  AND TRN_TRNCH_id = @OnlineChannelId
  AND TRN_gross_amount = @EventDGross
  AND TRN_discount_amount = @EventDDiscount;

IF @ExistingEventDCount > 1
    THROW 51609, N'More than one source row matches Event D signature.', 1;

IF @ExistingEventDCount = 1
BEGIN
    SELECT
        @EventDId = TRN_id,
        @EventDTransactionAt = TRN_transaction_at
    FROM sales.[Transaction]
    WHERE TRN_CST_id IS NULL
      AND TRN_TRNST_id = @PendingStatusId
      AND TRN_TRNCH_id = @OnlineChannelId
      AND TRN_gross_amount = @EventDGross
      AND TRN_discount_amount = @EventDDiscount;

    PRINT N'[•] Controlled Event D already exists. Reusing persisted source row.';
END
ELSE
BEGIN
    SET @EventDTransactionAt = CONVERT(datetime2(0), SYSDATETIME());

    DECLARE @InsertedEventD TABLE
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
    OUTPUT inserted.TRN_id, inserted.TRN_transaction_at
    INTO @InsertedEventD(TRN_id, TRN_transaction_at)
    VALUES
    (
        NULL,
        @PendingStatusId,
        @OnlineChannelId,
        @EventDTransactionAt,
        @EventDGross,
        @EventDDiscount
    );

    SELECT
        @EventDId = TRN_id,
        @EventDTransactionAt = TRN_transaction_at
    FROM @InsertedEventD;

    PRINT N'[+] Event D inserted after the persisted checkpoint.';
END;

IF @EventDId IS NULL
    THROW 51610, N'Event D source row could not be resolved.', 1;

SELECT
    TRN_id,
    TRN_transaction_at,
    TRN_TRNST_id,
    TRN_TRNCH_id,
    TRN_gross_amount,
    TRN_discount_amount
FROM sales.[Transaction]
WHERE TRN_id = @EventDId;

PRINT N'[✓] Event D source row resolved.';
PRINT N'    Event D TRN_id = ' + CONVERT(nvarchar(30), @EventDId);
PRINT N' ';

PRINT N'[3] WAIT FOR EVENT D CDC CAPTURE';
PRINT N'------------------------------------------------------------';

WHILE @PollingAttempts < 30
BEGIN
    SET @FailureToLsn = sys.fn_cdc_get_max_lsn();

    SELECT @EventDStartLsn = MIN(__$start_lsn)
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        sys.fn_cdc_increment_lsn(@CheckpointBefore),
        @FailureToLsn,
        N'all update old'
    )
    WHERE TRN_id = @EventDId
      AND __$operation = 2;

    IF @EventDStartLsn IS NOT NULL
        BREAK;

    SET @PollingAttempts += 1;
    WAITFOR DELAY '00:00:01';
END;

IF @EventDStartLsn IS NULL
    THROW 51611, N'Event D was not captured by CDC within 30 seconds.', 1;

PRINT N'[✓] Event D CDC row is available.';
PRINT N' ';

PRINT N'[4] FAILURE WINDOW READ';
PRINT N'------------------------------------------------------------';

SET @FromTransaction = sys.fn_cdc_increment_lsn(@CheckpointBefore);
SET @FromItem = sys.fn_cdc_increment_lsn(@ItemCheckpointBefore);
SET @FailureToLsn = sys.fn_cdc_get_max_lsn();

IF @FromTransaction > @FailureToLsn OR @FromItem > @FailureToLsn
    THROW 51612, N'Failure-window FROM boundary is greater than TO boundary.', 1;

DECLARE @FailureTransactionWindow TABLE
(
    start_lsn binary(10) NOT NULL,
    seqval binary(10) NOT NULL,
    operation int NOT NULL,
    update_mask varbinary(128) NULL,
    TRN_id bigint NULL,
    TRN_transaction_at datetime2 NULL,
    TRN_gross_amount decimal(19,4) NULL,
    TRN_discount_amount decimal(19,4) NULL
);

INSERT INTO @FailureTransactionWindow
(
    start_lsn, seqval, operation, update_mask,
    TRN_id, TRN_transaction_at, TRN_gross_amount, TRN_discount_amount
)
SELECT
    __$start_lsn,
    __$seqval,
    __$operation,
    __$update_mask,
    TRN_id,
    TRN_transaction_at,
    TRN_gross_amount,
    TRN_discount_amount
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @FromTransaction,
    @FailureToLsn,
    N'all update old'
);

SELECT @FailureEventDRows = COUNT(*)
FROM @FailureTransactionWindow
WHERE TRN_id = @EventDId
  AND operation = 2;

IF @FailureEventDRows <> 1
    THROW 51613, N'Failure window must contain Event D exactly once.', 1;

SELECT *
FROM @FailureTransactionWindow
WHERE TRN_id = @EventDId;

PRINT N'[✓] Failure window contains Event D exactly once.';
PRINT N' ';

PRINT N'[5] SIMULATED PROCESSING FAILURE';
PRINT N'------------------------------------------------------------';

BEGIN TRY
    BEGIN TRANSACTION;

    /*
      In a real pipeline, downstream processing would happen here.
      The THROW deliberately simulates a processing failure BEFORE
      checkpoint persistence.
    */
    THROW 51614, N'ATLAS_SIMULATED_PROCESSING_FAILURE', 1;

    -- Intentionally unreachable.
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    IF ERROR_NUMBER() <> 51614
        THROW;

    SET @FailureWasSimulated = 1;
    PRINT N'[!] Controlled processing failure simulated.';
    PRINT N'[✓] Processing transaction rolled back.';
END CATCH;

IF @FailureWasSimulated <> 1
    THROW 51615, N'Controlled processing failure was not observed.', 1;

PRINT N' ';

PRINT N'[6] PROVE CHECKPOINT DID NOT ADVANCE';
PRINT N'------------------------------------------------------------';

IF EXISTS
(
    SELECT 1
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @TransactionCapture
      AND
      (
          last_processed_lsn <> @CheckpointBefore
          OR checkpoint_version <> @TransactionVersionBefore
      )
)
    THROW 51616, N'sales_Transaction checkpoint advanced despite processing failure.', 1;

IF EXISTS
(
    SELECT 1
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @ItemCapture
      AND
      (
          last_processed_lsn <> @ItemCheckpointBefore
          OR checkpoint_version <> @ItemVersionBefore
      )
)
    THROW 51617, N'sales_TransactionItem checkpoint advanced despite processing failure.', 1;

PRINT N'[✓] sales.Transaction checkpoint remained unchanged.';
PRINT N'[✓] sales.TransactionItem checkpoint remained unchanged.';
PRINT N'[✓] Failed processing did not acknowledge the CDC window.';
PRINT N' ';

PRINT N'[7] RETRY FROM SAME CHECKPOINT';
PRINT N'------------------------------------------------------------';

-- Deliberately recompute FROM from the unchanged persisted checkpoint.
SELECT @CheckpointBefore = last_processed_lsn
FROM control.CDCConsumerCheckpoint
WHERE consumer_name = @ConsumerName
  AND capture_instance = @TransactionCapture;

SELECT @ItemCheckpointBefore = last_processed_lsn
FROM control.CDCConsumerCheckpoint
WHERE consumer_name = @ConsumerName
  AND capture_instance = @ItemCapture;

SET @FromTransaction = sys.fn_cdc_increment_lsn(@CheckpointBefore);
SET @FromItem = sys.fn_cdc_increment_lsn(@ItemCheckpointBefore);
SET @RetryToLsn = sys.fn_cdc_get_max_lsn();

DECLARE @RetryTransactionWindow TABLE
(
    start_lsn binary(10) NOT NULL,
    seqval binary(10) NOT NULL,
    operation int NOT NULL,
    update_mask varbinary(128) NULL,
    TRN_id bigint NULL,
    TRN_transaction_at datetime2 NULL,
    TRN_gross_amount decimal(19,4) NULL,
    TRN_discount_amount decimal(19,4) NULL
);

INSERT INTO @RetryTransactionWindow
(
    start_lsn, seqval, operation, update_mask,
    TRN_id, TRN_transaction_at, TRN_gross_amount, TRN_discount_amount
)
SELECT
    __$start_lsn,
    __$seqval,
    __$operation,
    __$update_mask,
    TRN_id,
    TRN_transaction_at,
    TRN_gross_amount,
    TRN_discount_amount
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @FromTransaction,
    @RetryToLsn,
    N'all update old'
);

SELECT @RetryEventDRows = COUNT(*)
FROM @RetryTransactionWindow
WHERE TRN_id = @EventDId
  AND operation = 2;

IF @RetryEventDRows <> 1
    THROW 51618, N'Retry window must replay Event D exactly once.', 1;

SELECT *
FROM @RetryTransactionWindow
WHERE TRN_id = @EventDId;

PRINT N'[✓] Retry started from the unchanged checkpoint.';
PRINT N'[✓] Event D was replayed exactly once.';
PRINT N' ';

PRINT N'[8] SUCCESSFUL RETRY AND ATOMIC CHECKPOINT COMMIT';
PRINT N'------------------------------------------------------------';

-- Materialize the item window as part of the same successful bounded unit.
DECLARE @RetryItemWindow TABLE
(
    start_lsn binary(10) NOT NULL,
    seqval binary(10) NOT NULL,
    operation int NOT NULL,
    update_mask varbinary(128) NULL,
    TRNIT_id bigint NULL,
    TRNIT_transaction_at datetime2 NULL,
    TRNIT_TRN_id bigint NULL,
    TRNIT_PRDVA_id int NULL
);

INSERT INTO @RetryItemWindow
(
    start_lsn, seqval, operation, update_mask,
    TRNIT_id, TRNIT_transaction_at, TRNIT_TRN_id, TRNIT_PRDVA_id
)
SELECT
    __$start_lsn,
    __$seqval,
    __$operation,
    __$update_mask,
    TRNIT_id,
    TRNIT_transaction_at,
    TRNIT_TRN_id,
    TRNIT_PRDVA_id
FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
(
    @FromItem,
    @RetryToLsn,
    N'all update old'
);

SELECT @ItemRows = COUNT(*) FROM @RetryItemWindow;

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE control.CDCConsumerCheckpoint
    SET
        last_processed_lsn = @RetryToLsn,
        last_processed_at = SYSDATETIME(),
        last_window_rows = (SELECT COUNT(*) FROM @RetryTransactionWindow),
        checkpoint_version = checkpoint_version + 1,
        updated_at = SYSDATETIME()
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @TransactionCapture
      AND last_processed_lsn = @CheckpointBefore
      AND checkpoint_version = @TransactionVersionBefore;

    IF @@ROWCOUNT <> 1
        THROW 51619, N'sales_Transaction checkpoint changed concurrently.', 1;

    UPDATE control.CDCConsumerCheckpoint
    SET
        last_processed_lsn = @RetryToLsn,
        last_processed_at = SYSDATETIME(),
        last_window_rows = @ItemRows,
        checkpoint_version = checkpoint_version + 1,
        updated_at = SYSDATETIME()
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @ItemCapture
      AND last_processed_lsn = @ItemCheckpointBefore
      AND checkpoint_version = @ItemVersionBefore;

    IF @@ROWCOUNT <> 1
        THROW 51620, N'sales_TransactionItem checkpoint changed concurrently.', 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

PRINT N'[+] Successful retry completed.';
PRINT N'[+] Both checkpoints advanced atomically.';
PRINT N' ';

PRINT N'[9] FINAL CHECKPOINT VALIDATION';
PRINT N'------------------------------------------------------------';

IF
(
    SELECT COUNT(*)
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN (@TransactionCapture, @ItemCapture)
      AND last_processed_lsn = @RetryToLsn
) <> 2
    THROW 51621, N'Final checkpoints do not equal the successful retry TO LSN.', 1;

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

PRINT N'[✓] Both checkpoints equal the successful retry TO boundary.';
PRINT N' ';

PRINT N'[10] FINAL RESULT';
PRINT N'------------------------------------------------------------';
PRINT N'[✓] CDC failure/retry checkpoint semantics validated successfully.';
PRINT N'[✓] Event D was read before the simulated failure.';
PRINT N'[✓] Simulated processing failure did not advance either checkpoint.';
PRINT N'[✓] Retry restarted from the unchanged persisted checkpoint.';
PRINT N'[✓] Event D was replayed exactly once.';
PRINT N'[✓] Checkpoints advanced only after successful retry processing.';
PRINT N'[✓] Both capture-instance checkpoints advanced atomically.';
PRINT N'[•] Controlled Event D source row was preserved for subsequent tests.';
PRINT N' ';
