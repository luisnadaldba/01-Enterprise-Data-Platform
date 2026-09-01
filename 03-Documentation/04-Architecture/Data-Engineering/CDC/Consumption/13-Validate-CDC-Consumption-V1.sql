/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 13-Validate-CDC-Consumption-V1-v1.0.1.sql
    Version       : 1.0.1
    Target        : AtlasCommerce
    Consumer      : AtlasEngineering.CDCConsumption.V1
    Purpose       : Perform the final consolidated read-only validation of the
                    SQL Server CDC Consumption V1 contract for AtlasCommerce.sales.
    Rerunnable    : Yes
    Destructive   : No
    Changes State : No - validation only; no source, CDC configuration or
                    consumer checkpoint state is modified

    Validation Contract
    --------------------------------------------------------------------------
    This script does NOT repeat the destructive laboratory scenarios already
    validated by Scripts 01-12.

    It consolidates the persistent invariants that must remain true before
    CDC Consumption V1 is considered operationally ready:

    1. AtlasCommerce is ONLINE with database-level CDC enabled.
    2. Both expected capture instances exist.
    3. Capture-instance configuration matches the V1 source contract:
           supports_net_changes = 0
           sales_Transaction     -> PK_TRN
           sales_TransactionItem -> PK_TRNIT
    4. Both capture instances expose exactly 9 captured source columns.
    5. Both official all-changes functions exist.
    6. CDC capture/cleanup jobs match the Atlas Engineering baseline.
    7. Cleanup retention remains 21600 minutes (15 days), threshold 4999.
    8. sys.dm_cdc_errors reports no current CDC errors.
    9. The two V1 consumer checkpoints exist, are initialized and aligned.
   10. Checkpoints are still inside the currently available CDC retention range.
   11. Checkpoint versions are aligned.
   12. A normal restart boundary can be derived with fn_cdc_increment_lsn().
   13. Any currently pending continuation window can be inspected read-only
       without advancing checkpoints.

    Scope Boundary
    --------------------------------------------------------------------------
    PASS here means the SQL Server source-side CDC consumption contract and
    checkpoint state are internally consistent.

    It does NOT claim:
        - Bronze/Silver persistence is implemented;
        - downstream idempotency is implemented;
        - end-to-end exactly-once delivery exists.

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
    @CurrentMaxLsn binary(10),

    @TransactionRestartFrom binary(10),
    @ItemRestartFrom binary(10),

    @TransactionPendingRows bigint = 0,
    @ItemPendingRows bigint = 0;

PRINT N'';
PRINT N'ATLAS ENGINEERING - VALIDATE CDC CONSUMPTION V1';
PRINT N'============================================================';
PRINT N'';

PRINT N'[1] DATABASE CDC STATE';
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
    THROW 52200, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

SELECT
    name AS database_name,
    state_desc,
    is_cdc_enabled
FROM sys.databases
WHERE database_id = DB_ID();

PRINT N'[✓] AtlasCommerce is ONLINE and database-level CDC is enabled.';

PRINT N'';
PRINT N'[2] CAPTURE INSTANCE CONFIGURATION';
PRINT N'------------------------------------------------------------';

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @TransactionCapture
      AND source_object_id = OBJECT_ID(N'sales.[Transaction]')
      AND supports_net_changes = 0
      AND index_name = N'PK_TRN'
)
BEGIN
    THROW 52201, N'sales_Transaction capture-instance configuration is invalid.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @ItemCapture
      AND source_object_id = OBJECT_ID(N'sales.TransactionItem')
      AND supports_net_changes = 0
      AND index_name = N'PK_TRNIT'
)
BEGIN
    THROW 52202, N'sales_TransactionItem capture-instance configuration is invalid.', 1;
END;

SELECT
    capture_instance,
    OBJECT_SCHEMA_NAME(source_object_id) AS source_schema,
    OBJECT_NAME(source_object_id) AS source_table,
    start_lsn,
    supports_net_changes,
    index_name,
    create_date
FROM cdc.change_tables
WHERE capture_instance IN (@TransactionCapture, @ItemCapture)
ORDER BY capture_instance;

PRINT N'[✓] Both capture instances match the V1 configuration contract.';

PRINT N'';
PRINT N'[3] CAPTURED COLUMN CONTRACT';
PRINT N'------------------------------------------------------------';

IF
(
    SELECT COUNT(*)
    FROM cdc.captured_columns AS cc
    INNER JOIN cdc.change_tables AS ct
        ON ct.object_id = cc.object_id
    WHERE ct.capture_instance = @TransactionCapture
) <> 9
BEGIN
    THROW 52203, N'sales_Transaction must expose exactly 9 captured source columns.', 1;
END;

IF
(
    SELECT COUNT(*)
    FROM cdc.captured_columns AS cc
    INNER JOIN cdc.change_tables AS ct
        ON ct.object_id = cc.object_id
    WHERE ct.capture_instance = @ItemCapture
) <> 9
BEGIN
    THROW 52204, N'sales_TransactionItem must expose exactly 9 captured source columns.', 1;
END;

SELECT
    ct.capture_instance,
    COUNT(*) AS captured_columns
FROM cdc.captured_columns AS cc
INNER JOIN cdc.change_tables AS ct
    ON ct.object_id = cc.object_id
WHERE ct.capture_instance IN (@TransactionCapture, @ItemCapture)
GROUP BY ct.capture_instance
ORDER BY ct.capture_instance;

PRINT N'[✓] Both capture instances expose exactly 9 captured source columns.';

PRINT N'';
PRINT N'[4] OFFICIAL CDC READ FUNCTIONS';
PRINT N'------------------------------------------------------------';

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
    THROW 52205, N'sales_Transaction all-changes function does not exist.', 1;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF') IS NULL
    THROW 52206, N'sales_TransactionItem all-changes function does not exist.', 1;

SELECT
    OBJECT_SCHEMA_NAME(object_id) AS object_schema,
    name AS object_name,
    type_desc
FROM sys.objects
WHERE object_id IN
(
    OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF'),
    OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_TransactionItem', N'IF')
)
ORDER BY name;

PRINT N'[✓] Both official all-changes functions exist.';

PRINT N'';
PRINT N'[5] CDC JOB CONFIGURATION';
PRINT N'------------------------------------------------------------';

DECLARE @CaptureJobs TABLE
(
    job_id uniqueidentifier NULL,
    job_type nvarchar(20) NULL,
    job_name sysname NULL,
    maxtrans int NULL,
    maxscans int NULL,
    continuous bit NULL,
    pollinginterval bigint NULL,
    retention bigint NULL,
    threshold bigint NULL
);

INSERT INTO @CaptureJobs
EXEC sys.sp_cdc_help_jobs;

IF NOT EXISTS
(
    SELECT 1
    FROM @CaptureJobs
    WHERE job_type = N'capture'
      AND maxtrans = 10000
      AND maxscans = 10
      AND continuous = 1
      AND pollinginterval = 5
)
BEGIN
    THROW 52207, N'CDC capture job configuration does not match the Atlas Engineering baseline.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM @CaptureJobs
    WHERE job_type = N'cleanup'
      AND retention = 21600
      AND threshold = 4999
)
BEGIN
    THROW 52208, N'CDC cleanup job configuration does not match retention=21600 / threshold=4999.', 1;
END;

SELECT *
FROM @CaptureJobs
ORDER BY job_type;

PRINT N'[✓] Capture job matches maxtrans=10000, maxscans=10, continuous=1, pollinginterval=5.';
PRINT N'[✓] Cleanup retention = 21600 minutes (15 days).';
PRINT N'[✓] Cleanup threshold = 4999.';

PRINT N'';
PRINT N'[6] CDC ERROR INSPECTION';
PRINT N'------------------------------------------------------------';

SELECT
    session_id,
    phase_number,
    error_number,
    error_severity,
    error_state,
    error_message,
    start_lsn,
    begin_lsn,
    sequence_value,
    entry_time
FROM sys.dm_cdc_errors
ORDER BY entry_time DESC;

IF EXISTS (SELECT 1 FROM sys.dm_cdc_errors)
BEGIN
    THROW 52209, N'sys.dm_cdc_errors currently contains CDC errors. Review required.', 1;
END;

PRINT N'[✓] No CDC errors are currently reported by sys.dm_cdc_errors.';

PRINT N'';
PRINT N'[7] CONSUMER CHECKPOINT CONTRACT';
PRINT N'------------------------------------------------------------';

IF OBJECT_ID(N'control.CDCConsumerCheckpoint', N'U') IS NULL
    THROW 52210, N'control.CDCConsumerCheckpoint does not exist.', 1;

IF
(
    SELECT COUNT(*)
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN (@TransactionCapture, @ItemCapture)
) <> 2
BEGIN
    THROW 52211, N'Exactly two V1 checkpoint rows are required.', 1;
END;

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
    THROW 52212, N'Both V1 checkpoints must contain persisted progress.', 1;

IF @TransactionCheckpoint <> @ItemCheckpoint
    THROW 52213, N'V1 capture-instance checkpoints are not aligned.', 1;

IF @TransactionVersion <> @ItemVersion
    THROW 52214, N'V1 checkpoint versions are not aligned.', 1;

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
ORDER BY capture_instance;

PRINT N'[✓] Exactly two initialized V1 checkpoint rows exist.';
PRINT N'[✓] Both capture-instance checkpoints are aligned.';
PRINT N'[✓] Both checkpoint versions are aligned.';

PRINT N'';
PRINT N'[8] RETENTION SAFETY';
PRINT N'------------------------------------------------------------';

SET @TransactionMinLsn = sys.fn_cdc_get_min_lsn(@TransactionCapture);
SET @ItemMinLsn = sys.fn_cdc_get_min_lsn(@ItemCapture);
SET @CurrentMaxLsn = sys.fn_cdc_get_max_lsn();

IF @TransactionMinLsn IS NULL OR @ItemMinLsn IS NULL OR @CurrentMaxLsn IS NULL
    THROW 52215, N'Unable to resolve current CDC LSN boundaries.', 1;

IF @TransactionCheckpoint < @TransactionMinLsn
    THROW 52216, N'sales_Transaction checkpoint is older than min_available_lsn.', 1;

IF @ItemCheckpoint < @ItemMinLsn
    THROW 52217, N'sales_TransactionItem checkpoint is older than min_available_lsn.', 1;

SELECT
    @TransactionCapture AS capture_instance,
    @TransactionMinLsn AS min_available_lsn,
    @TransactionCheckpoint AS persisted_checkpoint,
    @CurrentMaxLsn AS current_max_lsn
UNION ALL
SELECT
    @ItemCapture,
    @ItemMinLsn,
    @ItemCheckpoint AS checkpoint_lsn,
    @CurrentMaxLsn;

PRINT N'[✓] Both checkpoints are still inside the available CDC retention range.';

PRINT N'';
PRINT N'[9] RESTART BOUNDARY VALIDATION';
PRINT N'------------------------------------------------------------';

SET @TransactionRestartFrom = sys.fn_cdc_increment_lsn(@TransactionCheckpoint);
SET @ItemRestartFrom = sys.fn_cdc_increment_lsn(@ItemCheckpoint);

IF @TransactionRestartFrom IS NULL OR @ItemRestartFrom IS NULL
    THROW 52218, N'Unable to derive restart FROM boundaries.', 1;

SELECT
    @TransactionCapture AS capture_instance,
    @TransactionCheckpoint AS checkpoint_lsn,
    @TransactionRestartFrom AS restart_from_lsn,
    @CurrentMaxLsn AS current_max_lsn
UNION ALL
SELECT
    @ItemCapture,
    @ItemCheckpoint,
    @ItemRestartFrom,
    @CurrentMaxLsn;

PRINT N'[✓] Restart FROM boundaries derive from fn_cdc_increment_lsn(checkpoint).';

PRINT N'';
PRINT N'[10] READ-ONLY PENDING WINDOW INSPECTION';
PRINT N'------------------------------------------------------------';

IF @TransactionRestartFrom <= @CurrentMaxLsn
BEGIN
    SELECT @TransactionPendingRows = COUNT_BIG(*)
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        @TransactionRestartFrom,
        @CurrentMaxLsn,
        N'all update old'
    );
END;

IF @ItemRestartFrom <= @CurrentMaxLsn
BEGIN
    SELECT @ItemPendingRows = COUNT_BIG(*)
    FROM cdc.fn_cdc_get_all_changes_sales_TransactionItem
    (
        @ItemRestartFrom,
        @CurrentMaxLsn,
        N'all update old'
    );
END;

SELECT
    @TransactionCapture AS capture_instance,
    @TransactionRestartFrom AS from_lsn,
    @CurrentMaxLsn AS to_lsn,
    @TransactionPendingRows AS pending_rows
UNION ALL
SELECT
    @ItemCapture,
    @ItemRestartFrom,
    @CurrentMaxLsn,
    @ItemPendingRows;

PRINT N'[✓] Current continuation state inspected through official CDC functions.';
PRINT N'[✓] No checkpoint was advanced by this validation.';

PRINT N'';
PRINT N'[11] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC Consumption V1 final validation completed successfully.';
PRINT N'[✓] Source CDC configuration is valid.';
PRINT N'[✓] CDC jobs and retention match the Atlas Engineering baseline.';
PRINT N'[✓] No current CDC errors were detected.';
PRINT N'[✓] Consumer checkpoints are initialized, aligned and retention-safe.';
PRINT N'[✓] Restart boundaries are derivable from persisted checkpoints.';
PRINT N'[✓] Current pending window was inspected read-only.';
PRINT N'[✓] This script made no persistent changes.';
PRINT N'[•] Bronze/Silver persistence and downstream exactly-once semantics remain outside this validation scope.';
PRINT N'';
