/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 04-Create-CDC-Consumer-Checkpoint.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Create the persistent consumer checkpoint structure without
                    advancing any CDC processing position
    Rerunnable    : Yes
    Destructive   : No
    Changes State : Yes - creates control schema/table and seeds checkpoint rows

    Design introduced by this script
    --------------------------------------------------------------------------
    Schema:
        control

    Table:
        control.CDCConsumerCheckpoint

    Checkpoint identity:
        consumer_name + capture_instance

    Why the checkpoint is consumer-specific
    --------------------------------------------------------------------------
    CDC retention tells SQL Server what source change history remains available.

    A checkpoint answers a different question:

        How far has THIS consumer processed successfully?

    Different downstream consumers may advance independently, therefore the
    checkpoint key includes consumer_name.

    Initial state
    --------------------------------------------------------------------------
    Two checkpoint rows are created for the current V1 laboratory consumer:

        sales_Transaction
        sales_TransactionItem

    last_processed_lsn is intentionally NULL.

    NULL means:
        this consumer has not yet persisted a successfully processed CDC window.

    This script intentionally does NOT initialize the checkpoint to:
        capture instance start_lsn
        minimum available LSN
        current maximum LSN

    Advancing the checkpoint without successful processing would manufacture
    progress that did not actually occur.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @ConsumerName nvarchar(128) = N'AtlasEngineering.CDCConsumption.V1';

PRINT N'';
PRINT N'ATLAS ENGINEERING - CREATE CDC CONSUMER CHECKPOINT';
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
    THROW 51300, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = N'sales_Transaction'
      AND source_object_id = OBJECT_ID(N'sales.[Transaction]')
)
BEGIN
    THROW 51301, N'Capture instance sales_Transaction was not found.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = N'sales_TransactionItem'
      AND source_object_id = OBJECT_ID(N'sales.TransactionItem')
)
BEGIN
    THROW 51302, N'Capture instance sales_TransactionItem was not found.', 1;
END;

PRINT N'[✓] Database-level CDC is enabled.';
PRINT N'[✓] Both capture instances exist.';

PRINT N'';
PRINT N'[2] CREATE CONTROL SCHEMA';
PRINT N'------------------------------------------------------------';

IF SCHEMA_ID(N'control') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA [control] AUTHORIZATION [dbo];');
    PRINT N'[+] Schema control created.';
END
ELSE
BEGIN
    PRINT N'[•] Schema control already exists. No change required.';
END;

PRINT N'';
PRINT N'[3] CREATE CHECKPOINT TABLE';
PRINT N'------------------------------------------------------------';

IF OBJECT_ID(N'control.CDCConsumerCheckpoint', N'U') IS NULL
BEGIN
    CREATE TABLE control.CDCConsumerCheckpoint
    (
        consumer_name       nvarchar(128) NOT NULL,
        capture_instance    sysname       NOT NULL,
        last_processed_lsn  binary(10)    NULL,
        last_processed_at   datetime2(3)  NULL,
        last_window_rows    bigint        NULL,
        checkpoint_version  bigint        NOT NULL
            CONSTRAINT DF_CDCConsumerCheckpoint_checkpoint_version
            DEFAULT (0),
        created_at          datetime2(3)  NOT NULL
            CONSTRAINT DF_CDCConsumerCheckpoint_created_at
            DEFAULT (SYSUTCDATETIME()),
        updated_at          datetime2(3)  NOT NULL
            CONSTRAINT DF_CDCConsumerCheckpoint_updated_at
            DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_CDCConsumerCheckpoint
            PRIMARY KEY CLUSTERED
            (
                consumer_name,
                capture_instance
            ),

        CONSTRAINT CK_CDCConsumerCheckpoint_last_window_rows
            CHECK (last_window_rows IS NULL OR last_window_rows >= 0),

        CONSTRAINT CK_CDCConsumerCheckpoint_version
            CHECK (checkpoint_version >= 0)
    );

    PRINT N'[+] Table control.CDCConsumerCheckpoint created.';
END
ELSE
BEGIN
    PRINT N'[•] Table control.CDCConsumerCheckpoint already exists. No change required.';
END;

PRINT N'';
PRINT N'[4] STRUCTURE VALIDATION';
PRINT N'------------------------------------------------------------';

IF COL_LENGTH(N'control.CDCConsumerCheckpoint', N'consumer_name') IS NULL
    THROW 51303, N'Column consumer_name is missing from control.CDCConsumerCheckpoint.', 1;

IF COL_LENGTH(N'control.CDCConsumerCheckpoint', N'capture_instance') IS NULL
    THROW 51304, N'Column capture_instance is missing from control.CDCConsumerCheckpoint.', 1;

IF COL_LENGTH(N'control.CDCConsumerCheckpoint', N'last_processed_lsn') IS NULL
    THROW 51305, N'Column last_processed_lsn is missing from control.CDCConsumerCheckpoint.', 1;

IF COL_LENGTH(N'control.CDCConsumerCheckpoint', N'last_processed_at') IS NULL
    THROW 51306, N'Column last_processed_at is missing from control.CDCConsumerCheckpoint.', 1;

IF COL_LENGTH(N'control.CDCConsumerCheckpoint', N'last_window_rows') IS NULL
    THROW 51307, N'Column last_window_rows is missing from control.CDCConsumerCheckpoint.', 1;

IF COL_LENGTH(N'control.CDCConsumerCheckpoint', N'checkpoint_version') IS NULL
    THROW 51308, N'Column checkpoint_version is missing from control.CDCConsumerCheckpoint.', 1;

IF COL_LENGTH(N'control.CDCConsumerCheckpoint', N'created_at') IS NULL
    THROW 51309, N'Column created_at is missing from control.CDCConsumerCheckpoint.', 1;

IF COL_LENGTH(N'control.CDCConsumerCheckpoint', N'updated_at') IS NULL
    THROW 51310, N'Column updated_at is missing from control.CDCConsumerCheckpoint.', 1;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.key_constraints
    WHERE parent_object_id = OBJECT_ID(N'control.CDCConsumerCheckpoint')
      AND type = N'PK'
      AND name = N'PK_CDCConsumerCheckpoint'
)
BEGIN
    THROW 51311, N'Expected primary key PK_CDCConsumerCheckpoint was not found.', 1;
END;

PRINT N'[✓] Checkpoint table structure validated.';
PRINT N'[✓] Composite checkpoint identity = consumer_name + capture_instance.';

PRINT N'';
PRINT N'[5] SEED CHECKPOINT ROWS';
PRINT N'------------------------------------------------------------';

IF NOT EXISTS
(
    SELECT 1
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance = N'sales_Transaction'
)
BEGIN
    INSERT INTO control.CDCConsumerCheckpoint
    (
        consumer_name,
        capture_instance
    )
    VALUES
    (
        @ConsumerName,
        N'sales_Transaction'
    );

    PRINT N'[+] Initial checkpoint row created for sales_Transaction.';
END
ELSE
BEGIN
    PRINT N'[•] Checkpoint row for sales_Transaction already exists.';
END;

IF NOT EXISTS
(
    SELECT 1
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance = N'sales_TransactionItem'
)
BEGIN
    INSERT INTO control.CDCConsumerCheckpoint
    (
        consumer_name,
        capture_instance
    )
    VALUES
    (
        @ConsumerName,
        N'sales_TransactionItem'
    );

    PRINT N'[+] Initial checkpoint row created for sales_TransactionItem.';
END
ELSE
BEGIN
    PRINT N'[•] Checkpoint row for sales_TransactionItem already exists.';
END;

PRINT N'';
PRINT N'[6] CHECKPOINT STATE';
PRINT N'------------------------------------------------------------';

SELECT
    cp.consumer_name,
    cp.capture_instance,
    cp.last_processed_lsn,
    sys.fn_cdc_map_lsn_to_time(cp.last_processed_lsn) AS last_processed_lsn_time,
    cp.last_processed_at,
    cp.last_window_rows,
    cp.checkpoint_version,
    cp.created_at,
    cp.updated_at,
    sys.fn_cdc_get_min_lsn(cp.capture_instance) AS min_available_lsn,
    sys.fn_cdc_get_max_lsn() AS current_max_lsn
FROM control.CDCConsumerCheckpoint AS cp
WHERE cp.consumer_name = @ConsumerName
ORDER BY cp.capture_instance;

IF
(
    SELECT COUNT(*)
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN
      (
          N'sales_Transaction',
          N'sales_TransactionItem'
      )
) <> 2
BEGIN
    THROW 51312, N'Expected exactly two checkpoint rows for the V1 CDC consumer.', 1;
END;

PRINT N'[✓] Exactly two V1 checkpoint rows exist.';

PRINT N'';
PRINT N'[7] INITIAL CHECKPOINT SEMANTICS';
PRINT N'------------------------------------------------------------';

IF EXISTS
(
    SELECT 1
    FROM control.CDCConsumerCheckpoint
    WHERE consumer_name = @ConsumerName
      AND capture_instance IN
      (
          N'sales_Transaction',
          N'sales_TransactionItem'
      )
      AND last_processed_lsn IS NOT NULL
)
BEGIN
    PRINT N'[•] One or more checkpoint rows already contain persisted progress from a previous execution.';
    PRINT N'[•] Existing progress was preserved; this script never rewinds or advances a checkpoint.';
END
ELSE
BEGIN
    PRINT N'[✓] Both checkpoint rows are initialized with last_processed_lsn = NULL.';
    PRINT N'[✓] NULL correctly represents: no successfully processed window persisted yet.';
END;

PRINT N'';
PRINT N'[8] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] Persistent CDC consumer checkpoint structure is ready.';
PRINT N'[✓] Checkpoints are consumer-specific and capture-instance-specific.';
PRINT N'[✓] No CDC read position was advanced by this script.';
PRINT N'[✓] Ready to process a window and persist checkpoint only after successful processing.';
PRINT N'';
