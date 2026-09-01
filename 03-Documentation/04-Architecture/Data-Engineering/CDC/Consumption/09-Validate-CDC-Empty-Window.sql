/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 09-Validate-CDC-Empty-Window.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Consumer      : AtlasEngineering.CDCConsumption.V1
    Purpose       : Validate consumer behavior when no new captured changes are
                    available after the persisted checkpoint.
    Rerunnable    : Yes - performs no source DML and only advances checkpoints
                    when an empty CDC window with a newer TO boundary exists
    Destructive   : No
    Changes State : Conditional - may advance both consumer checkpoints
                    atomically across an empty successfully processed window

    Validation Contract
    --------------------------------------------------------------------------
    1. Resolve the persisted checkpoints for both capture instances.
    2. Require the two V1 checkpoints to be aligned.
    3. Compute:
           FROM = fn_cdc_increment_lsn(last_processed_lsn)
           TO   = fn_cdc_get_max_lsn()
    4. Handle two valid no-change states:

       A. FROM > TO
          No newer CDC boundary exists.
          The consumer performs no read and does not advance checkpoints.

       B. FROM <= TO and both capture-instance reads return 0 rows
          A newer CDC boundary exists, but neither source table changed.
          The empty window is considered successfully processed and both
          checkpoints advance atomically to TO.

    5. If either capture instance returns rows, stop without advancing any
       checkpoint because this is not an empty-window test.

    Consumer Rule
    --------------------------------------------------------------------------
    Zero rows does not mean failed processing.

    If a valid newer CDC boundary was successfully inspected and no captured
    changes exist for the consumer, advancing the checkpoint to TO is valid.

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

    @TransactionRows bigint = 0,
    @ItemRows bigint = 0,

    @CheckpointAdvanced bit = 0;

PRINT N'';
PRINT N'ATLAS ENGINEERING - VALIDATE CDC EMPTY WINDOW';
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
    THROW 51800, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF OBJECT_ID(N'control.CDCConsumerCheckpoint', N'U') IS NULL
BEGIN
    THROW 51801, N'control.CDCConsumerCheckpoint does not exist.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
BEGIN
    THROW 51802, N'CDC all-changes function for sales_Transaction does not exist.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF') IS NULL
BEGIN
    THROW 51803, N'CDC all-changes function for sales_TransactionItem does not exist.', 1;
END;

IF
(
    SELECT COUNT(*)
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN
      (
          @TransactionCapture,
          @ItemCapture
      )
) <> 2
BEGIN
    THROW 51804, N'Exactly two V1 checkpoint rows are required.', 1;
END;

PRINT N'[✓] Database-level CDC is enabled.';
PRINT N'[✓] Checkpoint structure exists.';
PRINT N'[✓] Both CDC all-changes functions exist.';
PRINT N'[✓] Both V1 checkpoint rows exist.';

PRINT N'';
PRINT N'[2] RESOLVE CHECKPOINT STATE';
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

IF @TransactionCheckpoint IS NULL
   OR @ItemCheckpoint IS NULL
BEGIN
    THROW 51805, N'Both V1 checkpoints must already contain persisted progress.', 1;
END;

IF @TransactionCheckpoint <> @ItemCheckpoint
BEGIN
    THROW 51806, N'V1 capture-instance checkpoints are not aligned.', 1;
END;

SET @TransactionMinLsn = sys.fn_cdc_get_min_lsn(@TransactionCapture);
SET @ItemMinLsn = sys.fn_cdc_get_min_lsn(@ItemCapture);

IF @TransactionCheckpoint < @TransactionMinLsn
BEGIN
    THROW 51807, N'sales_Transaction checkpoint is older than min_available_lsn.', 1;
END;

IF @ItemCheckpoint < @ItemMinLsn
BEGIN
    THROW 51808, N'sales_TransactionItem checkpoint is older than min_available_lsn.', 1;
END;

SELECT
    @TransactionCapture AS capture_instance,
    @TransactionCheckpoint AS checkpoint_before,
    @TransactionVersion AS checkpoint_version_before,
    @TransactionMinLsn AS min_available_lsn

UNION ALL

SELECT
    @ItemCapture,
    @ItemCheckpoint,
    @ItemVersion,
    @ItemMinLsn;

PRINT N'[✓] Persisted checkpoints exist and are aligned.';
PRINT N'[✓] Both checkpoints are still within CDC retention.';

PRINT N'';
PRINT N'[3] RESOLVE EMPTY-WINDOW BOUNDARIES';
PRINT N'------------------------------------------------------------';

SET @TransactionFromLsn =
    sys.fn_cdc_increment_lsn(@TransactionCheckpoint);

SET @ItemFromLsn =
    sys.fn_cdc_increment_lsn(@ItemCheckpoint);

SET @ToLsn =
    sys.fn_cdc_get_max_lsn();

IF @ToLsn IS NULL
   OR @ToLsn = 0x00000000000000000000
BEGIN
    THROW 51809, N'Unable to resolve a valid current maximum CDC LSN.', 1;
END;

SELECT
    @TransactionCapture AS capture_instance,
    @TransactionFromLsn AS from_lsn,
    @ToLsn AS to_lsn

UNION ALL

SELECT
    @ItemCapture,
    @ItemFromLsn,
    @ToLsn;

PRINT N'[✓] Continuation FROM boundaries and current TO boundary resolved.';

PRINT N'';
PRINT N'[4] EMPTY-WINDOW READ';
PRINT N'------------------------------------------------------------';

IF @TransactionFromLsn > @ToLsn
   AND @ItemFromLsn > @ToLsn
BEGIN
    PRINT N'[•] No newer CDC boundary exists after the persisted checkpoint.';
    PRINT N'[•] FROM is greater than TO for both capture instances.';
    PRINT N'[✓] Logical empty continuation state validated.';
    PRINT N'[✓] No checkpoint advance is required.';
END
ELSE
BEGIN
    IF @TransactionFromLsn > @ToLsn
       OR @ItemFromLsn > @ToLsn
    BEGIN
        THROW 51810, N'Capture-instance continuation boundaries are inconsistent.', 1;
    END;

    SELECT @TransactionRows = COUNT_BIG(*)
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        @TransactionFromLsn,
        @ToLsn,
        N'all update old'
    );

    SELECT @ItemRows = COUNT_BIG(*)
    FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
    (
        @ItemFromLsn,
        @ToLsn,
        N'all update old'
    );

    SELECT
        @TransactionCapture AS capture_instance,
        @TransactionRows AS rows_returned,
        @TransactionFromLsn AS from_lsn,
        @ToLsn AS to_lsn

    UNION ALL

    SELECT
        @ItemCapture,
        @ItemRows,
        @ItemFromLsn,
        @ToLsn;

    IF @TransactionRows <> 0
       OR @ItemRows <> 0
    BEGIN
        THROW 51811, N'Current continuation window is not empty. No checkpoint was advanced by this validation.', 1;
    END;

    PRINT N'[✓] sales.Transaction returned 0 rows.';
    PRINT N'[✓] sales.TransactionItem returned 0 rows.';
    PRINT N'[✓] A newer empty CDC window was successfully processed.';

    PRINT N'';
    PRINT N'[5] ATOMIC EMPTY-WINDOW CHECKPOINT ADVANCE';
    PRINT N'------------------------------------------------------------';

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE control.CDCConsumerCheckpoint
        SET
            last_processed_lsn = @ToLsn,
            last_processed_at = SYSUTCDATETIME(),
            last_window_rows = 0,
            checkpoint_version = checkpoint_version + 1,
            updated_at = SYSUTCDATETIME()
        WHERE consumer_name = @ConsumerName
          AND capture_instance = @TransactionCapture
          AND last_processed_lsn = @TransactionCheckpoint
          AND checkpoint_version = @TransactionVersion;

        IF @@ROWCOUNT <> 1
        BEGIN
            THROW 51812, N'sales_Transaction checkpoint changed concurrently.', 1;
        END;

        UPDATE control.CDCConsumerCheckpoint
        SET
            last_processed_lsn = @ToLsn,
            last_processed_at = SYSUTCDATETIME(),
            last_window_rows = 0,
            checkpoint_version = checkpoint_version + 1,
            updated_at = SYSUTCDATETIME()
        WHERE consumer_name = @ConsumerName
          AND capture_instance = @ItemCapture
          AND last_processed_lsn = @ItemCheckpoint
          AND checkpoint_version = @ItemVersion;

        IF @@ROWCOUNT <> 1
        BEGIN
            THROW 51813, N'sales_TransactionItem checkpoint changed concurrently.', 1;
        END;

        COMMIT TRANSACTION;

        SET @CheckpointAdvanced = 1;

        PRINT N'[+] Empty window acknowledged successfully.';
        PRINT N'[+] Both checkpoints advanced atomically to TO.';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;

        THROW;
    END CATCH;
END;

PRINT N'';
PRINT N'[6] FINAL CHECKPOINT STATE';
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
  AND capture_instance IN
  (
      @TransactionCapture,
      @ItemCapture
  )
ORDER BY capture_instance;

IF @CheckpointAdvanced = 1
BEGIN
    IF
    (
        SELECT COUNT(*)
        FROM control.CDCConsumerCheckpoint
        WHERE consumer_name = @ConsumerName
          AND capture_instance IN
          (
              @TransactionCapture,
              @ItemCapture
          )
          AND last_processed_lsn = @ToLsn
          AND last_window_rows = 0
    ) <> 2
    BEGIN
        THROW 51814, N'Final empty-window checkpoint validation failed.', 1;
    END;

    PRINT N'[✓] Both checkpoints equal the successfully processed empty-window TO boundary.';
    PRINT N'[✓] last_window_rows = 0 for both capture instances.';
END
ELSE
BEGIN
    IF EXISTS
    (
        SELECT 1
        FROM control.CDCConsumerCheckpoint
        WHERE consumer_name = @ConsumerName
          AND capture_instance = @TransactionCapture
          AND
          (
              last_processed_lsn <> @TransactionCheckpoint
              OR checkpoint_version <> @TransactionVersion
          )
    )
    BEGIN
        THROW 51815, N'sales_Transaction checkpoint changed unexpectedly.', 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM control.CDCConsumerCheckpoint
        WHERE consumer_name = @ConsumerName
          AND capture_instance = @ItemCapture
          AND
          (
              last_processed_lsn <> @ItemCheckpoint
              OR checkpoint_version <> @ItemVersion
          )
    )
    BEGIN
        THROW 51816, N'sales_TransactionItem checkpoint changed unexpectedly.', 1;
    END;

    PRINT N'[✓] Checkpoints remained unchanged because no newer CDC boundary existed.';
END;

PRINT N'';
PRINT N'[7] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC empty-window semantics validated successfully.';

IF @CheckpointAdvanced = 1
BEGIN
    PRINT N'[✓] A newer window containing 0 captured rows was acknowledged.';
    PRINT N'[✓] Zero-row processing advanced both checkpoints atomically.';
END
ELSE
BEGIN
    PRINT N'[✓] No newer CDC boundary existed, so no checkpoint advance occurred.';
END;

PRINT N'[✓] No source data was modified by this script.';
PRINT N'';
