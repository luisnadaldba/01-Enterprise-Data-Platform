/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : Reset-CDC-Test-Baseline.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Remove laboratory CDC capture instances so a clean CDC
                    baseline can be recreated before consumption development
    Rerunnable    : Yes
    Destructive   : Yes - removes CDC capture instances and their history
    Changes State : Yes

    Scope
    --------------------------------------------------------------------------
    This script disables TABLE-LEVEL CDC only for:

        sales.Transaction
        sales.TransactionItem

    It intentionally keeps DATABASE-LEVEL CDC enabled.

    Consequence
    --------------------------------------------------------------------------
    Disabling the capture instances removes their CDC change tables and
    associated captured history.

    This is intentional.

    The source tables and their current business data are NOT deleted.

    Intended use
    --------------------------------------------------------------------------
    Run only after the CDC behavior tests have been completed and evidence has
    been recorded.

    Then rebuild the clean baseline with:

        03-Enable-Transaction-CDC.sql
        06-Enable-TransactionItem-CDC.sql
        04-Validate-CDC-Jobs-And-Retention.sql
        05-Validate-Transaction-CDC.sql
        07-Validate-TransactionItem-CDC.sql

    Expected final state
    --------------------------------------------------------------------------
    Database-level CDC              : ENABLED
    sales.Transaction CDC           : DISABLED
    sales.TransactionItem CDC       : DISABLED
    sales_Transaction capture       : ABSENT
    sales_TransactionItem capture   : ABSENT

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @TransactionObjectId     int = OBJECT_ID(N'sales.[Transaction]'),
    @TransactionItemObjectId int = OBJECT_ID(N'sales.TransactionItem');

PRINT N'';
PRINT N'ATLAS ENGINEERING - RESET CDC TEST BASELINE';
PRINT N'============================================================';
PRINT N'';

PRINT N'[1] DATABASE-LEVEL CDC VALIDATION';
PRINT N'------------------------------------------------------------';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE database_id = DB_ID()
      AND state_desc = N'ONLINE'
)
BEGIN
    THROW 51220, N'AtlasCommerce must be ONLINE.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE database_id = DB_ID()
      AND is_cdc_enabled = 1
)
BEGIN
    THROW 51221, N'Database-level CDC is not enabled. This reset is intended to preserve database-level CDC.', 1;
END;

PRINT N'[✓] AtlasCommerce is ONLINE.';
PRINT N'[✓] Database-level CDC is enabled and will be preserved.';

PRINT N'';
PRINT N'[2] SOURCE TABLE VALIDATION';
PRINT N'------------------------------------------------------------';

IF @TransactionObjectId IS NULL
BEGIN
    THROW 51222, N'sales.Transaction was not found.', 1;
END;

IF @TransactionItemObjectId IS NULL
BEGIN
    THROW 51223, N'sales.TransactionItem was not found.', 1;
END;

SELECT
    s.name AS source_schema,
    t.name AS source_table,
    t.is_tracked_by_cdc
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
WHERE t.object_id IN
(
    @TransactionObjectId,
    @TransactionItemObjectId
)
ORDER BY t.name;

PRINT N'[✓] Both source tables exist.';

PRINT N'';
PRINT N'[3] CURRENT CAPTURE INSTANCES';
PRINT N'------------------------------------------------------------';

SELECT
    ct.capture_instance,
    OBJECT_SCHEMA_NAME(ct.source_object_id) AS source_schema,
    OBJECT_NAME(ct.source_object_id)        AS source_table,
    ct.start_lsn,
    ct.supports_net_changes,
    ct.index_name,
    ct.create_date
FROM cdc.change_tables AS ct
WHERE ct.source_object_id IN
(
    @TransactionObjectId,
    @TransactionItemObjectId
)
ORDER BY ct.capture_instance;

PRINT N'';
PRINT N'[4] CURRENT CDC HISTORY COUNTS';
PRINT N'------------------------------------------------------------';

IF OBJECT_ID(N'cdc.sales_Transaction_CT', N'U') IS NOT NULL
BEGIN
    DECLARE @TransactionCdcRows bigint;

    SELECT @TransactionCdcRows = COUNT_BIG(*)
    FROM cdc.sales_Transaction_CT;

    SELECT
        N'cdc.sales_Transaction_CT' AS change_table,
        @TransactionCdcRows        AS current_rows;
END
ELSE
BEGIN
    SELECT
        N'cdc.sales_Transaction_CT' AS change_table,
        CAST(NULL AS bigint)        AS current_rows;

    PRINT N'[•] cdc.sales_Transaction_CT is already absent.';
END;

IF OBJECT_ID(N'cdc.sales_TransactionItem_CT', N'U') IS NOT NULL
BEGIN
    DECLARE @TransactionItemCdcRows bigint;

    SELECT @TransactionItemCdcRows = COUNT_BIG(*)
    FROM cdc.sales_TransactionItem_CT;

    SELECT
        N'cdc.sales_TransactionItem_CT' AS change_table,
        @TransactionItemCdcRows        AS current_rows;
END
ELSE
BEGIN
    SELECT
        N'cdc.sales_TransactionItem_CT' AS change_table,
        CAST(NULL AS bigint)            AS current_rows;

    PRINT N'[•] cdc.sales_TransactionItem_CT is already absent.';
END;

PRINT N'';
PRINT N'[5] DISABLE CDC - sales.TransactionItem';
PRINT N'------------------------------------------------------------';

IF EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = N'sales_TransactionItem'
      AND source_object_id = @TransactionItemObjectId
)
BEGIN
    PRINT N'[+] Removing capture instance sales_TransactionItem...';

    EXEC sys.sp_cdc_disable_table
        @source_schema    = N'sales',
        @source_name      = N'TransactionItem',
        @capture_instance = N'sales_TransactionItem';

    PRINT N'[+] Capture instance sales_TransactionItem removed.';
END
ELSE IF EXISTS
(
    SELECT 1
    FROM sys.tables
    WHERE object_id = @TransactionItemObjectId
      AND is_tracked_by_cdc = 1
)
BEGIN
    PRINT N'[+] sales.TransactionItem is CDC-tracked under another capture instance.';
    PRINT N'[+] Removing all capture instances for sales.TransactionItem...';

    EXEC sys.sp_cdc_disable_table
        @source_schema    = N'sales',
        @source_name      = N'TransactionItem',
        @capture_instance = N'all';

    PRINT N'[+] All capture instances for sales.TransactionItem removed.';
END
ELSE
BEGIN
    PRINT N'[•] sales.TransactionItem is already CDC-disabled.';
END;

PRINT N'';
PRINT N'[6] DISABLE CDC - sales.Transaction';
PRINT N'------------------------------------------------------------';

IF EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = N'sales_Transaction'
      AND source_object_id = @TransactionObjectId
)
BEGIN
    PRINT N'[+] Removing capture instance sales_Transaction...';

    EXEC sys.sp_cdc_disable_table
        @source_schema    = N'sales',
        @source_name      = N'Transaction',
        @capture_instance = N'sales_Transaction';

    PRINT N'[+] Capture instance sales_Transaction removed.';
END
ELSE IF EXISTS
(
    SELECT 1
    FROM sys.tables
    WHERE object_id = @TransactionObjectId
      AND is_tracked_by_cdc = 1
)
BEGIN
    PRINT N'[+] sales.Transaction is CDC-tracked under another capture instance.';
    PRINT N'[+] Removing all capture instances for sales.Transaction...';

    EXEC sys.sp_cdc_disable_table
        @source_schema    = N'sales',
        @source_name      = N'Transaction',
        @capture_instance = N'all';

    PRINT N'[+] All capture instances for sales.Transaction removed.';
END
ELSE
BEGIN
    PRINT N'[•] sales.Transaction is already CDC-disabled.';
END;

PRINT N'';
PRINT N'[7] FINAL TABLE-LEVEL CDC VALIDATION';
PRINT N'------------------------------------------------------------';

SELECT
    s.name AS source_schema,
    t.name AS source_table,
    t.is_tracked_by_cdc
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
WHERE t.object_id IN
(
    @TransactionObjectId,
    @TransactionItemObjectId
)
ORDER BY t.name;

IF EXISTS
(
    SELECT 1
    FROM sys.tables
    WHERE object_id IN
    (
        @TransactionObjectId,
        @TransactionItemObjectId
    )
      AND is_tracked_by_cdc = 1
)
BEGIN
    THROW 51224, N'One or more source tables are still tracked by CDC after reset.', 1;
END;

PRINT N'[✓] sales.Transaction is CDC-disabled.';
PRINT N'[✓] sales.TransactionItem is CDC-disabled.';

PRINT N'';
PRINT N'[8] FINAL CAPTURE INSTANCE VALIDATION';
PRINT N'------------------------------------------------------------';

SELECT
    ct.capture_instance,
    OBJECT_SCHEMA_NAME(ct.source_object_id) AS source_schema,
    OBJECT_NAME(ct.source_object_id)        AS source_table
FROM cdc.change_tables AS ct
WHERE ct.source_object_id IN
(
    @TransactionObjectId,
    @TransactionItemObjectId
);

IF EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE source_object_id IN
    (
        @TransactionObjectId,
        @TransactionItemObjectId
    )
)
BEGIN
    THROW 51225, N'One or more CDC capture instances still exist after reset.', 1;
END;

PRINT N'[✓] No capture instances remain for either source table.';

PRINT N'';
PRINT N'[9] DATABASE-LEVEL CDC PRESERVATION';
PRINT N'------------------------------------------------------------';

SELECT
    name AS database_name,
    state_desc,
    is_cdc_enabled
FROM sys.databases
WHERE database_id = DB_ID();

IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE database_id = DB_ID()
      AND state_desc = N'ONLINE'
      AND is_cdc_enabled = 1
)
BEGIN
    THROW 51226, N'Database-level CDC was not preserved as expected.', 1;
END;

PRINT N'[✓] Database-level CDC remains enabled.';

PRINT N'';
PRINT N'[10] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC laboratory history reset completed successfully.';
PRINT N'[✓] Source business tables were preserved.';
PRINT N'[✓] Table-level CDC was removed from sales.Transaction.';
PRINT N'[✓] Table-level CDC was removed from sales.TransactionItem.';
PRINT N'[✓] Database-level CDC remains enabled.';
PRINT N'[✓] Ready to recreate a clean CDC baseline.';
PRINT N'';
