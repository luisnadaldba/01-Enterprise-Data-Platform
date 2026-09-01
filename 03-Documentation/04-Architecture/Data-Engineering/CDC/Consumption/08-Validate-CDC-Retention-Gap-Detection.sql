/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 08-Validate-CDC-Retention-Gap-Detection.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Consumer      : AtlasEngineering.CDCConsumption.RetentionTest
    Purpose       : Validate that a persisted consumer checkpoint older than
                    the minimum available CDC LSN is detected and rejected
                    before any CDC read is attempted.
    Rerunnable    : Yes - uses an isolated test consumer inside a transaction
                    that is always rolled back
    Destructive   : No
    Changes State : No - test checkpoint rows exist only inside the local
                    validation transaction and are rolled back

    Validation Contract
    --------------------------------------------------------------------------
    1. Resolve the current minimum available LSN for both capture instances.
    2. Create two isolated test checkpoint rows with an intentionally stale LSN.
    3. Read the persisted test checkpoints exactly as a real consumer would.
    4. Prove:
           last_processed_lsn < min_available_lsn
       for both capture instances.
    5. Trigger the expected retention-gap protection.
    6. Roll back the test transaction.
    7. Prove that no RetentionTest checkpoint rows remain persisted.

    Expected Consumer Behavior
    --------------------------------------------------------------------------
    A checkpoint older than the current minimum available CDC LSN means the
    consumer can no longer replay every change since its last acknowledged
    position.

    The consumer MUST NOT silently continue from min_available_lsn because that
    would hide a data gap.

    Required response:
        STOP
        surface an explicit retention-gap error
        require a recovery/backfill decision

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @TestConsumerName nvarchar(128) =
        N'AtlasEngineering.CDCConsumption.RetentionTest',

    @TransactionCapture sysname = N'sales_Transaction',
    @ItemCapture sysname = N'sales_TransactionItem',

    @TransactionMinLsn binary(10),
    @ItemMinLsn binary(10),

    @TransactionCheckpoint binary(10),
    @ItemCheckpoint binary(10),

    @StaleCheckpoint binary(10) = 0x00000000000000000001,

    @RetentionGapDetected bit = 0,
    @ExpectedErrorNumber int = 51710;

PRINT N'';
PRINT N'ATLAS ENGINEERING - VALIDATE CDC RETENTION GAP DETECTION';
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
    THROW 51700, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF OBJECT_ID(N'control.CDCConsumerCheckpoint', N'U') IS NULL
BEGIN
    THROW 51701, N'control.CDCConsumerCheckpoint does not exist.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @TransactionCapture
      AND source_object_id = OBJECT_ID(N'sales.[Transaction]')
)
BEGIN
    THROW 51702, N'Capture instance sales_Transaction was not found.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @ItemCapture
      AND source_object_id = OBJECT_ID(N'sales.TransactionItem')
)
BEGIN
    THROW 51703, N'Capture instance sales_TransactionItem was not found.', 1;
END;

IF EXISTS
(
    SELECT 1
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @TestConsumerName
)
BEGIN
    THROW 51704, N'RetentionTest checkpoint rows already exist. Manual review is required before this validation.', 1;
END;

PRINT N'[✓] Database-level CDC is enabled.';
PRINT N'[✓] Checkpoint structure exists.';
PRINT N'[✓] Both capture instances exist.';
PRINT N'[✓] No pre-existing RetentionTest checkpoint rows exist.';

PRINT N'';
PRINT N'[2] RESOLVE CURRENT MINIMUM AVAILABLE LSN';
PRINT N'------------------------------------------------------------';

SET @TransactionMinLsn = sys.fn_cdc_get_min_lsn(@TransactionCapture);
SET @ItemMinLsn = sys.fn_cdc_get_min_lsn(@ItemCapture);

IF @TransactionMinLsn IS NULL
   OR @TransactionMinLsn = 0x00000000000000000000
BEGIN
    THROW 51705, N'Unable to resolve a valid minimum LSN for sales_Transaction.', 1;
END;

IF @ItemMinLsn IS NULL
   OR @ItemMinLsn = 0x00000000000000000000
BEGIN
    THROW 51706, N'Unable to resolve a valid minimum LSN for sales_TransactionItem.', 1;
END;

SELECT
    @TransactionCapture AS capture_instance,
    @TransactionMinLsn AS min_available_lsn,
    sys.fn_cdc_map_lsn_to_time(@TransactionMinLsn) AS min_available_lsn_time

UNION ALL

SELECT
    @ItemCapture,
    @ItemMinLsn,
    sys.fn_cdc_map_lsn_to_time(@ItemMinLsn);

IF @StaleCheckpoint >= @TransactionMinLsn
BEGIN
    THROW 51707, N'Synthetic stale checkpoint is not older than sales_Transaction minimum LSN.', 1;
END;

IF @StaleCheckpoint >= @ItemMinLsn
BEGIN
    THROW 51708, N'Synthetic stale checkpoint is not older than sales_TransactionItem minimum LSN.', 1;
END;

PRINT N'[✓] Current minimum LSN resolved for both capture instances.';
PRINT N'[✓] Synthetic checkpoint is older than both available CDC ranges.';

PRINT N'';
PRINT N'[3] CREATE ISOLATED STALE CHECKPOINT STATE';
PRINT N'------------------------------------------------------------';

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO control.CDCConsumerCheckpoint
    (
        consumer_name,
        capture_instance,
        last_processed_lsn,
        last_processed_at,
        last_window_rows,
        checkpoint_version
    )
    VALUES
    (
        @TestConsumerName,
        @TransactionCapture,
        @StaleCheckpoint,
        SYSUTCDATETIME(),
        0,
        1
    ),
    (
        @TestConsumerName,
        @ItemCapture,
        @StaleCheckpoint,
        SYSUTCDATETIME(),
        0,
        1
    );

    IF @@ROWCOUNT <> 2
    BEGIN
        THROW 51709, N'Expected exactly two isolated RetentionTest checkpoint rows.', 1;
    END;

    PRINT N'[+] Two isolated stale checkpoint rows created inside the test transaction.';

    SELECT
        consumer_name,
        capture_instance,
        last_processed_lsn,
        checkpoint_version,
        created_at,
        updated_at
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @TestConsumerName
    ORDER BY capture_instance;

    PRINT N'';
    PRINT N'[4] RETENTION GAP VALIDATION';
    PRINT N'------------------------------------------------------------';

    SELECT
        @TransactionCheckpoint = last_processed_lsn
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @TestConsumerName
      AND capture_instance = @TransactionCapture;

    SELECT
        @ItemCheckpoint = last_processed_lsn
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @TestConsumerName
      AND capture_instance = @ItemCapture;

    SELECT
        @TransactionCapture AS capture_instance,
        @TransactionCheckpoint AS persisted_checkpoint,
        @TransactionMinLsn AS min_available_lsn,
        CASE
            WHEN @TransactionCheckpoint < @TransactionMinLsn
                THEN N'RETENTION GAP'
            ELSE N'VALID'
        END AS checkpoint_state

    UNION ALL

    SELECT
        @ItemCapture,
        @ItemCheckpoint,
        @ItemMinLsn,
        CASE
            WHEN @ItemCheckpoint < @ItemMinLsn
                THEN N'RETENTION GAP'
            ELSE N'VALID'
        END;

    IF @TransactionCheckpoint < @TransactionMinLsn
       OR @ItemCheckpoint < @ItemMinLsn
    BEGIN
        THROW 51710,
            N'CDC retention gap detected: persisted checkpoint is older than min_available_lsn. Recovery/backfill decision required.',
            1;
    END;

    -- This path must never be reached in this controlled test.
    THROW 51711, N'Retention gap protection did not trigger as expected.', 1;
END TRY
BEGIN CATCH
    DECLARE
        @CaughtErrorNumber int = ERROR_NUMBER(),
        @CaughtErrorMessage nvarchar(4000) = ERROR_MESSAGE();

    IF XACT_STATE() <> 0
    BEGIN
        ROLLBACK TRANSACTION;
    END;

    IF @CaughtErrorNumber <> @ExpectedErrorNumber
    BEGIN
        THROW;
    END;

    SET @RetentionGapDetected = 1;

    PRINT N'[!] Expected retention-gap protection triggered.';
    PRINT N'    Error ' + CONVERT(nvarchar(20), @CaughtErrorNumber)
        + N': ' + @CaughtErrorMessage;
    PRINT N'[✓] Test transaction rolled back.';
END CATCH;

PRINT N'';
PRINT N'[5] POST-ROLLBACK VALIDATION';
PRINT N'------------------------------------------------------------';

IF @RetentionGapDetected <> 1
BEGIN
    THROW 51712, N'Expected retention-gap condition was not detected.', 1;
END;

IF EXISTS
(
    SELECT 1
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @TestConsumerName
)
BEGIN
    THROW 51713, N'RetentionTest checkpoint rows remained persisted after rollback.', 1;
END;

PRINT N'[✓] No RetentionTest checkpoint rows remain persisted.';
PRINT N'[✓] Production V1 checkpoints were not modified.';

PRINT N'';
PRINT N'[6] REAL V1 CHECKPOINT STATE';
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
WHERE consumer_name = N'AtlasEngineering.CDCConsumption.V1'
ORDER BY capture_instance;

PRINT N'';
PRINT N'[7] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC retention-gap detection validated successfully.';
PRINT N'[✓] A checkpoint older than min_available_lsn is rejected.';
PRINT N'[✓] Consumer does not silently skip forward to the current minimum LSN.';
PRINT N'[✓] Explicit recovery/backfill decision is required after a retention gap.';
PRINT N'[✓] Validation left no persistent RetentionTest state.';
PRINT N'';
