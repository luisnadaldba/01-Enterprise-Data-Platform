/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 06-Validate-CDC-Restart-Continuation.sql
    Version       : 1.0.1
    Target        : AtlasCommerce
    Consumer      : AtlasEngineering.CDCConsumption.V1
    Purpose       : Validate restart/continuation from a persisted checkpoint,
                    prove previously processed events are not returned again,
                    then create and consume one new controlled event.
    Rerunnable    : Controlled - each successful execution creates one new
                    sales.Transaction test row
    Destructive   : No
    Changes State : Yes - inserts one controlled source row and advances
                    both consumer checkpoints after successful processing

    Test sequence
    --------------------------------------------------------------------------
    Phase A - restart from persisted checkpoint
        FROM = fn_cdc_increment_lsn(last_processed_lsn)
        TO   = current max LSN

        Previously processed Event A and Event B must NOT reappear.

        If FROM > TO, there is no new CDC boundary to read. This is treated
        as a valid empty continuation state and no checkpoint is advanced.

    Phase B - create one new controlled Event C
        Insert one sales.Transaction row after the persisted checkpoint.
        Wait for CDC capture.
        Resolve a new TO boundary.
        Read again from increment_lsn(last_processed_lsn).

        Expected:
            Event A = 0 rows
            Event B = 0 rows
            Event C = exactly 1 INSERT row

        Only after successful validation:
            advance BOTH capture-instance checkpoints atomically to the new TO.

    Official CDC function contract used
    --------------------------------------------------------------------------
        __$start_lsn
        __$seqval
        __$operation
        __$update_mask
        + captured source columns

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
    @RestartFromTransaction binary(10),
    @RestartFromItem binary(10),
    @RestartToLsn binary(10),

    @PendingStatusId tinyint,
    @OnlineChannelId tinyint,

    @EventATime datetime2(0) = '2026-09-01T10:30:00',
    @EventBTime datetime2(0) = '2026-09-01T10:31:00',
    @EventCTransactionAt datetime2(3),
    @EventCId bigint,

    @EventAGross decimal(19,2) = 210.00,
    @EventADiscount decimal(19,2) = 21.00,
    @EventBGross decimal(19,2) = 220.00,
    @EventBDiscount decimal(19,2) = 22.00,
    @EventCGross decimal(19,2) = 230.00,
    @EventCDiscount decimal(19,2) = 23.00,

    @RestartEventACount bigint = 0,
    @RestartEventBCount bigint = 0,

    @EventCStartLsn binary(10),
    @FinalToLsn binary(10),
    @FinalFromTransaction binary(10),
    @FinalFromItem binary(10),

    @FinalEventACount bigint = 0,
    @FinalEventBCount bigint = 0,
    @FinalEventCCount bigint = 0,
    @FinalTransactionRows bigint = 0,
    @FinalItemRows bigint = 0,

    @PollAttempt int = 0,
    @MaxPollAttempts int = 30;

PRINT N'';
PRINT N'ATLAS ENGINEERING - VALIDATE CDC RESTART CONTINUATION';
PRINT N'============================================================';
PRINT N'';

PRINT N'[1] PRECONDITION VALIDATION';
PRINT N'------------------------------------------------------------';

IF OBJECT_ID(N'control.CDCConsumerCheckpoint', N'U') IS NULL
    THROW 51500, N'control.CDCConsumerCheckpoint does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
    THROW 51501, N'CDC all-changes function for sales_Transaction does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF') IS NULL
    THROW 51502, N'CDC all-changes function for sales_TransactionItem does not exist.', 1;

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
    THROW 51503, N'Both V1 checkpoints must already contain persisted progress. Run script 05 first.', 1;

IF @TransactionCheckpoint <> @ItemCheckpoint
    THROW 51504, N'V1 checkpoints are not aligned. Manual review is required before restart validation.', 1;

SELECT @PendingStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'PENDING';

SELECT @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = 'ONLINE';

IF @PendingStatusId IS NULL
    THROW 51505, N'Status PENDING was not found.', 1;

IF @OnlineChannelId IS NULL
    THROW 51506, N'Channel ONLINE was not found.', 1;

SET @TransactionMinLsn = sys.fn_cdc_get_min_lsn(@TransactionCapture);
SET @ItemMinLsn = sys.fn_cdc_get_min_lsn(@ItemCapture);

IF @TransactionCheckpoint < @TransactionMinLsn
    THROW 51507, N'sales_Transaction checkpoint is older than CDC retention.', 1;

IF @ItemCheckpoint < @ItemMinLsn
    THROW 51508, N'sales_TransactionItem checkpoint is older than CDC retention.', 1;

PRINT N'[✓] Persisted checkpoints exist and are aligned.';
PRINT N'[✓] Existing checkpoints are still within CDC retention.';
PRINT N'[✓] Status PENDING and channel ONLINE resolved.';

PRINT N'';
PRINT N'[2] RESTART BOUNDARY RESOLUTION';
PRINT N'------------------------------------------------------------';

SET @RestartFromTransaction = sys.fn_cdc_increment_lsn(@TransactionCheckpoint);
SET @RestartFromItem = sys.fn_cdc_increment_lsn(@ItemCheckpoint);
SET @RestartToLsn = sys.fn_cdc_get_max_lsn();

SELECT
    @TransactionCheckpoint AS checkpoint_before,
    @RestartFromTransaction AS restart_from_transaction,
    @RestartFromItem AS restart_from_transaction_item,
    @RestartToLsn AS restart_to_lsn,
    @TransactionVersion AS transaction_checkpoint_version,
    @ItemVersion AS item_checkpoint_version;

PRINT N'[✓] Restart FROM boundaries use fn_cdc_increment_lsn(checkpoint).';

PRINT N'';
PRINT N'[3] RESTART READ - PROVE OLD EVENTS DO NOT REAPPEAR';
PRINT N'------------------------------------------------------------';

IF @RestartFromTransaction <= @RestartToLsn
BEGIN
    SELECT
        c.__$start_lsn,
        c.__$seqval,
        c.__$operation,
        c.__$update_mask,
        c.TRN_id,
        c.TRN_transaction_at,
        c.TRN_gross_amount,
        c.TRN_discount_amount
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        @RestartFromTransaction,
        @RestartToLsn,
        N'all update old'
    ) AS c
    ORDER BY c.__$start_lsn, c.__$seqval, c.__$operation;

    SELECT @RestartEventACount = COUNT_BIG(*)
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        @RestartFromTransaction,
        @RestartToLsn,
        N'all update old'
    ) AS c
    WHERE c.TRN_transaction_at = @EventATime
      AND c.TRN_gross_amount = @EventAGross
      AND c.TRN_discount_amount = @EventADiscount;

    SELECT @RestartEventBCount = COUNT_BIG(*)
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        @RestartFromTransaction,
        @RestartToLsn,
        N'all update old'
    ) AS c
    WHERE c.TRN_transaction_at = @EventBTime
      AND c.TRN_gross_amount = @EventBGross
      AND c.TRN_discount_amount = @EventBDiscount;
END
ELSE
BEGIN
    PRINT N'[•] Restart FROM is greater than current MAX LSN.';
    PRINT N'[•] No new CDC boundary exists yet; restart window is logically empty.';
END;

IF @RestartEventACount <> 0
    THROW 51509, N'Previously processed Event A reappeared after restart.', 1;

IF @RestartEventBCount <> 0
    THROW 51510, N'Previously processed Event B reappeared after restart.', 1;

PRINT N'[✓] Event A did not reappear.';
PRINT N'[✓] Event B did not reappear.';
PRINT N'[✓] Persisted checkpoint continuation prevents boundary duplication.';

PRINT N'';
PRINT N'[4] CREATE OR REUSE CONTROLLED EVENT C';
PRINT N'------------------------------------------------------------';

DECLARE @ExistingEventCCount int;

SELECT @ExistingEventCCount = COUNT(*)
FROM sales.[Transaction]
WHERE TRN_CST_id IS NULL
  AND TRN_TRNST_id = @PendingStatusId
  AND TRN_TRNCH_id = @OnlineChannelId
  AND TRN_gross_amount = @EventCGross
  AND TRN_discount_amount = @EventCDiscount;

IF @ExistingEventCCount > 1
    THROW 51511, N'More than one source row matches the controlled Event C signature. Manual review is required.', 1;

IF @ExistingEventCCount = 1
BEGIN
    SELECT
        @EventCId = TRN_id,
        @EventCTransactionAt = TRN_transaction_at
    FROM sales.[Transaction]
    WHERE TRN_CST_id IS NULL
      AND TRN_TRNST_id = @PendingStatusId
      AND TRN_TRNCH_id = @OnlineChannelId
      AND TRN_gross_amount = @EventCGross
      AND TRN_discount_amount = @EventCDiscount;

    PRINT N'[•] Controlled Event C already exists from a previous execution.';
    PRINT N'[•] Reusing the persisted source row instead of inserting another event.';
END
ELSE
BEGIN
    -- Match the source column precision before INSERT.
    SET @EventCTransactionAt = CONVERT(datetime2(0), SYSUTCDATETIME());

    DECLARE @InsertedEventC TABLE
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
    INTO @InsertedEventC
    (
        TRN_id,
        TRN_transaction_at
    )
    VALUES
    (
        NULL,
        @PendingStatusId,
        @OnlineChannelId,
        @EventCTransactionAt,
        @EventCGross,
        @EventCDiscount
    );

    SELECT
        @EventCId = TRN_id,
        @EventCTransactionAt = TRN_transaction_at
    FROM @InsertedEventC;

    PRINT N'[+] Event C inserted after the persisted checkpoint.';
END;

IF @EventCId IS NULL OR @EventCTransactionAt IS NULL
    THROW 51512, N'Controlled Event C could not be resolved.', 1;

SELECT
    TRN_id,
    TRN_transaction_at,
    TRN_TRNST_id,
    TRN_TRNCH_id,
    TRN_gross_amount,
    TRN_discount_amount
FROM sales.[Transaction]
WHERE TRN_id = @EventCId;

PRINT N'[✓] Event C source row resolved.';
PRINT N'    Event C TRN_id = ' + CONVERT(nvarchar(30), @EventCId);
PRINT N'    Persisted TRN_transaction_at = '
    + CONVERT(nvarchar(30), @EventCTransactionAt, 126);

PRINT N'';
PRINT N'[5] WAIT FOR EVENT C CDC CAPTURE';
PRINT N'------------------------------------------------------------';

SET @PollAttempt = 0;
SET @EventCStartLsn = NULL;

WHILE @EventCStartLsn IS NULL
  AND @PollAttempt < @MaxPollAttempts
BEGIN
    SET @PollAttempt += 1;
    SET @FinalToLsn = sys.fn_cdc_get_max_lsn();

    IF @RestartFromTransaction <= @FinalToLsn
    BEGIN
        SELECT TOP (1)
            @EventCStartLsn = c.__$start_lsn
        FROM cdc.fn_cdc_get_all_changes_sales_Transaction
        (
            @RestartFromTransaction,
            @FinalToLsn,
            N'all update old'
        ) AS c
        WHERE c.TRN_id = @EventCId
          AND c.TRN_transaction_at = @EventCTransactionAt
          AND c.__$operation = 2
        ORDER BY c.__$start_lsn;
    END;

    IF @EventCStartLsn IS NULL
        WAITFOR DELAY '00:00:01';
END;

IF @EventCStartLsn IS NULL
    THROW 51513, N'Event C was not captured by CDC within 30 seconds.', 1;

SET @FinalToLsn = sys.fn_cdc_get_max_lsn();
SET @FinalFromTransaction = sys.fn_cdc_increment_lsn(@TransactionCheckpoint);
SET @FinalFromItem = sys.fn_cdc_increment_lsn(@ItemCheckpoint);

SELECT
    @EventCStartLsn AS event_c_start_lsn,
    sys.fn_cdc_map_lsn_to_time(@EventCStartLsn) AS event_c_cdc_time,
    @FinalFromTransaction AS final_from_transaction,
    @FinalFromItem AS final_from_transaction_item,
    @FinalToLsn AS final_to_lsn,
    @PollAttempt AS polling_attempts;

PRINT N'[✓] Event C CDC row is available.';
PRINT N'[✓] Final read boundary resolved after Event C capture.';

PRINT N'';
PRINT N'[6] FINAL CONTINUATION READ';
PRINT N'------------------------------------------------------------';

IF @FinalFromTransaction > @FinalToLsn
    THROW 51514, N'Final sales_Transaction FROM boundary is greater than TO boundary.', 1;

SELECT
    c.__$start_lsn,
    c.__$seqval,
    c.__$operation,
    c.__$update_mask,
    sys.fn_cdc_map_lsn_to_time(c.__$start_lsn) AS cdc_transaction_time,
    c.TRN_id,
    c.TRN_transaction_at,
    c.TRN_gross_amount,
    c.TRN_discount_amount
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @FinalFromTransaction,
    @FinalToLsn,
    N'all update old'
) AS c
ORDER BY c.__$start_lsn, c.__$seqval, c.__$operation;

SELECT @FinalTransactionRows = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @FinalFromTransaction,
    @FinalToLsn,
    N'all update old'
);

SELECT @FinalEventACount = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @FinalFromTransaction,
    @FinalToLsn,
    N'all update old'
) AS c
WHERE c.TRN_transaction_at = @EventATime
  AND c.TRN_gross_amount = @EventAGross
  AND c.TRN_discount_amount = @EventADiscount;

SELECT @FinalEventBCount = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @FinalFromTransaction,
    @FinalToLsn,
    N'all update old'
) AS c
WHERE c.TRN_transaction_at = @EventBTime
  AND c.TRN_gross_amount = @EventBGross
  AND c.TRN_discount_amount = @EventBDiscount;

SELECT @FinalEventCCount = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @FinalFromTransaction,
    @FinalToLsn,
    N'all update old'
) AS c
WHERE c.TRN_id = @EventCId
  AND c.TRN_transaction_at = @EventCTransactionAt
  AND c.__$operation = 2;

IF @FinalFromItem <= @FinalToLsn
BEGIN
    SELECT
        c.__$start_lsn,
        c.__$seqval,
        c.__$operation,
        c.__$update_mask,
        c.TRNIT_id,
        c.TRNIT_transaction_at,
        c.TRNIT_TRN_id,
        c.TRNIT_PRDVA_id
    FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
    (
        @FinalFromItem,
        @FinalToLsn,
        N'all update old'
    ) AS c
    ORDER BY c.__$start_lsn, c.__$seqval, c.__$operation;

    SELECT @FinalItemRows = COUNT_BIG(*)
    FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
    (
        @FinalFromItem,
        @FinalToLsn,
        N'all update old'
    );
END;

IF @FinalEventACount <> 0
    THROW 51515, N'Event A reappeared in the post-checkpoint continuation window.', 1;

IF @FinalEventBCount <> 0
    THROW 51516, N'Event B reappeared in the post-checkpoint continuation window.', 1;

IF @FinalEventCCount <> 1
    THROW 51517, N'Event C must appear exactly once in the continuation window.', 1;

PRINT N'[✓] Event A = 0 rows.';
PRINT N'[✓] Event B = 0 rows.';
PRINT N'[✓] Event C = exactly 1 INSERT row.';
PRINT N'[✓] Restart + continuation semantics validated with a new event.';

PRINT N'';
PRINT N'[7] ATOMIC CHECKPOINT ADVANCE';
PRINT N'------------------------------------------------------------';

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE control.CDCConsumerCheckpoint
    SET
        last_processed_lsn = @FinalToLsn,
        last_processed_at = SYSUTCDATETIME(),
        last_window_rows = @FinalTransactionRows,
        checkpoint_version = checkpoint_version + 1,
        updated_at = SYSUTCDATETIME()
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @TransactionCapture
      AND checkpoint_version = @TransactionVersion
      AND last_processed_lsn = @TransactionCheckpoint;

    IF @@ROWCOUNT <> 1
        THROW 51518, N'sales_Transaction checkpoint changed concurrently.', 1;

    UPDATE control.CDCConsumerCheckpoint
    SET
        last_processed_lsn = @FinalToLsn,
        last_processed_at = SYSUTCDATETIME(),
        last_window_rows = @FinalItemRows,
        checkpoint_version = checkpoint_version + 1,
        updated_at = SYSUTCDATETIME()
    WHERE consumer_name = @ConsumerName
      AND capture_instance = @ItemCapture
      AND checkpoint_version = @ItemVersion
      AND last_processed_lsn = @ItemCheckpoint;

    IF @@ROWCOUNT <> 1
        THROW 51519, N'sales_TransactionItem checkpoint changed concurrently.', 1;

    COMMIT TRANSACTION;

    PRINT N'[+] Both checkpoints advanced atomically.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;

PRINT N'';
PRINT N'[8] FINAL CHECKPOINT STATE';
PRINT N'------------------------------------------------------------';

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

IF EXISTS
(
    SELECT 1
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN (@TransactionCapture, @ItemCapture)
      AND last_processed_lsn <> @FinalToLsn
)
    THROW 51520, N'Final checkpoint validation failed.', 1;

PRINT N'[✓] Both checkpoints equal the completed final TO LSN.';

PRINT N'';
PRINT N'[9] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC restart/continuation validation completed successfully.';
PRINT N'[✓] Previously processed Event A did not reappear.';
PRINT N'[✓] Previously processed Event B did not reappear.';
PRINT N'[✓] New Event C was consumed exactly once.';
PRINT N'[✓] sales.Transaction rows processed in final window = '
    + CONVERT(nvarchar(30), @FinalTransactionRows) + N'.';
PRINT N'[✓] sales.TransactionItem rows processed in final window = '
    + CONVERT(nvarchar(30), @FinalItemRows) + N'.';
PRINT N'[✓] Both checkpoints advanced atomically only after successful validation.';
PRINT N'';
