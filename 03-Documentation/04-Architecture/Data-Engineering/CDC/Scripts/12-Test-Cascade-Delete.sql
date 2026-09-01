/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 12-Test-Cascade-Delete.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Validate CDC behavior when one explicit parent DELETE on
                    sales.Transaction cascades to two sales.TransactionItem rows
    Rerunnable    : Controlled
    Destructive   : Yes - deletes the controlled parent and its two child rows
    Changes State : Yes

    Prerequisite dataset
    --------------------------------------------------------------------------
    Created by:
        11-Test-Cross-Table-Transaction.sql

    Expected logical dataset:
        1 sales.Transaction
        2 sales.TransactionItem

    Controlled signature:
        Business Event Time : 2026-09-01 10:00:00
        Parent Gross        : 150.00
        Parent Discount     : 15.00
        Parent Status       : PENDING
        Parent Channel      : ONLINE

        Child ProductVariant 1:
            Quantity        : 1
            Unit Price      : 100.00
            Unit Discount   : 10.00

        Child ProductVariant 2:
            Quantity        : 1
            Unit Price      : 50.00
            Unit Discount   : 5.00

    Operation under test
    --------------------------------------------------------------------------
    The script issues exactly ONE explicit source DML statement:

        DELETE sales.Transaction

    It does NOT explicitly delete sales.TransactionItem rows.

    The foreign key FK_TRNIT_TRN must be configured with ON DELETE CASCADE.

    Expected CDC representation
    --------------------------------------------------------------------------
    sales.Transaction:
        1 DELETE
        __$operation = 1

    sales.TransactionItem:
        2 DELETEs
        __$operation = 1

    All three CDC DELETE rows must share:
        __$start_lsn

    Expected command ordering:
        __$command_id = 1, 2, 3

    Expected masks:
        0x01FF for all three DELETE rows

    Evidence boundary
    --------------------------------------------------------------------------
    This validates SQL Server source-side behavior:
    one explicit parent DELETE, relational cascade, and CDC representation.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @BusinessEventTime      datetime2(0)    = '2026-09-01T10:00:00',
    @PendingStatusId        tinyint,
    @OnlineChannelId        tinyint,
    @TransactionId          bigint,
    @TransactionItemId1     bigint,
    @TransactionItemId2     bigint,
    @ParentRows             int,
    @ChildRows              int,
    @ParentDeleteCdcRows    int,
    @ChildDeleteCdcRows     int,
    @PollAttempt            int = 0,
    @MaxPollAttempts        int = 30,
    @SharedStartLsn         binary(10),
    @ExpectedMask           varbinary(128) = 0x01FF;

PRINT N'';
PRINT N'ATLAS ENGINEERING - CDC CASCADE DELETE TEST';
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
    THROW 51180, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = N'sales_Transaction'
      AND source_object_id = OBJECT_ID(N'sales.[Transaction]')
)
BEGIN
    THROW 51181, N'Expected capture instance sales_Transaction was not found.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = N'sales_TransactionItem'
      AND source_object_id = OBJECT_ID(N'sales.TransactionItem')
)
BEGIN
    THROW 51182, N'Expected capture instance sales_TransactionItem was not found.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE parent_object_id = OBJECT_ID(N'sales.TransactionItem')
      AND referenced_object_id = OBJECT_ID(N'sales.[Transaction]')
      AND name = N'FK_TRNIT_TRN'
      AND delete_referential_action_desc = N'CASCADE'
)
BEGIN
    THROW 51183, N'FK_TRNIT_TRN with ON DELETE CASCADE was not found.', 1;
END;

SELECT @PendingStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'PENDING';

SELECT @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = 'ONLINE';

IF @PendingStatusId IS NULL
BEGIN
    THROW 51184, N'Status PENDING was not found.', 1;
END;

IF @OnlineChannelId IS NULL
BEGIN
    THROW 51185, N'Channel ONLINE was not found.', 1;
END;

PRINT N'[✓] Both CDC capture instances exist.';
PRINT N'[✓] FK_TRNIT_TRN uses ON DELETE CASCADE.';
PRINT N'[✓] Status PENDING resolved.';
PRINT N'[✓] Channel ONLINE resolved.';

PRINT N'';
PRINT N'[2] CONTROLLED DATASET RESOLUTION';
PRINT N'------------------------------------------------------------';

SELECT @ParentRows = COUNT(*)
FROM sales.[Transaction]
WHERE TRN_transaction_at = @BusinessEventTime
  AND TRN_CST_id IS NULL
  AND TRN_TRNST_id = @PendingStatusId
  AND TRN_TRNCH_id = @OnlineChannelId
  AND TRN_gross_amount = 150.00
  AND TRN_discount_amount = 15.00;

IF @ParentRows > 1
BEGIN
    THROW 51186, N'More than one parent row matches the controlled cascade-delete signature.', 1;
END;

IF @ParentRows = 1
BEGIN
    SELECT @TransactionId = TRN_id
    FROM sales.[Transaction]
    WHERE TRN_transaction_at = @BusinessEventTime
      AND TRN_CST_id IS NULL
      AND TRN_TRNST_id = @PendingStatusId
      AND TRN_TRNCH_id = @OnlineChannelId
      AND TRN_gross_amount = 150.00
      AND TRN_discount_amount = 15.00;

    SELECT @ChildRows = COUNT(*)
    FROM sales.TransactionItem
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime;

    IF @ChildRows <> 2
    BEGIN
        THROW 51187, N'Expected exactly two child rows before the cascade DELETE.', 1;
    END;

    SELECT @TransactionItemId1 = TRNIT_id
    FROM sales.TransactionItem
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
      AND TRNIT_PRDVA_id = 1
      AND TRNIT_quantity = 1
      AND TRNIT_unit_price = 100.00
      AND TRNIT_unit_discount = 10.00;

    SELECT @TransactionItemId2 = TRNIT_id
    FROM sales.TransactionItem
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
      AND TRNIT_PRDVA_id = 2
      AND TRNIT_quantity = 1
      AND TRNIT_unit_price = 50.00
      AND TRNIT_unit_discount = 5.00;

    IF @TransactionItemId1 IS NULL OR @TransactionItemId2 IS NULL
    BEGIN
        THROW 51188, N'The two child rows do not match the controlled dataset created by script 11.', 1;
    END;

    PRINT N'[✓] Controlled parent and two child rows resolved.';
    PRINT N'    TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);
    PRINT N'    TRNIT_id #1 = ' + CONVERT(nvarchar(30), @TransactionItemId1);
    PRINT N'    TRNIT_id #2 = ' + CONVERT(nvarchar(30), @TransactionItemId2);
END
ELSE
BEGIN
    PRINT N'[•] Controlled parent is already absent.';
    PRINT N'[•] Attempting to reuse existing CDC cascade-delete evidence.';

    SELECT TOP (1)
        @TransactionId = ct.TRN_id,
        @SharedStartLsn = ct.__$start_lsn
    FROM cdc.sales_Transaction_CT AS ct
    WHERE ct.TRN_transaction_at = @BusinessEventTime
      AND ct.TRN_CST_id IS NULL
      AND ct.TRN_TRNST_id = @PendingStatusId
      AND ct.TRN_TRNCH_id = @OnlineChannelId
      AND ct.TRN_gross_amount = 150.00
      AND ct.TRN_discount_amount = 15.00
      AND ct.__$operation = 1
    ORDER BY ct.__$start_lsn DESC;

    IF @TransactionId IS NULL OR @SharedStartLsn IS NULL
    BEGIN
        THROW 51189, N'Controlled source dataset is absent and no matching parent CDC DELETE evidence was found. Execute script 11 first.', 1;
    END;

    SELECT @TransactionItemId1 = TRNIT_id
    FROM cdc.sales_TransactionItem_CT
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
      AND TRNIT_PRDVA_id = 1
      AND __$operation = 1
      AND __$start_lsn = @SharedStartLsn;

    SELECT @TransactionItemId2 = TRNIT_id
    FROM cdc.sales_TransactionItem_CT
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
      AND TRNIT_PRDVA_id = 2
      AND __$operation = 1
      AND __$start_lsn = @SharedStartLsn;

    IF @TransactionItemId1 IS NULL OR @TransactionItemId2 IS NULL
    BEGIN
        THROW 51190, N'Existing parent DELETE was found, but matching child cascade DELETE evidence is incomplete.', 1;
    END;

    PRINT N'[✓] Existing cascade-delete CDC evidence resolved.';
    PRINT N'    TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);
    PRINT N'    TRNIT_id #1 = ' + CONVERT(nvarchar(30), @TransactionItemId1);
    PRINT N'    TRNIT_id #2 = ' + CONVERT(nvarchar(30), @TransactionItemId2);
END;

PRINT N'';
PRINT N'[3] SOURCE STATE BEFORE DELETE';
PRINT N'------------------------------------------------------------';

IF @ParentRows = 1
BEGIN
    SELECT
        TRN_id,
        TRN_transaction_at,
        TRN_TRNST_id,
        TRN_TRNCH_id,
        TRN_gross_amount,
        TRN_discount_amount
    FROM sales.[Transaction]
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime;

    SELECT
        TRNIT_id,
        TRNIT_transaction_at,
        TRNIT_TRN_id,
        TRNIT_PRDVA_id,
        TRNIT_quantity,
        TRNIT_unit_price,
        TRNIT_unit_discount
    FROM sales.TransactionItem
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
    ORDER BY TRNIT_id;

    PRINT N'[✓] One parent and two children exist before DELETE.';
END
ELSE
BEGIN
    PRINT N'[•] Source rows were already deleted on a previous execution.';
END;

PRINT N'';
PRINT N'[4] EXPLICIT PARENT DELETE';
PRINT N'------------------------------------------------------------';

IF @ParentRows = 1
BEGIN
    PRINT N'[+] Executing exactly one explicit DELETE against sales.Transaction...';

    DELETE FROM sales.[Transaction]
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND TRN_TRNST_id = @PendingStatusId
      AND TRN_TRNCH_id = @OnlineChannelId
      AND TRN_gross_amount = 150.00
      AND TRN_discount_amount = 15.00;

    IF @@ROWCOUNT <> 1
    BEGIN
        THROW 51191, N'Explicit parent DELETE did not affect exactly one row.', 1;
    END;

    PRINT N'[+] Parent DELETE committed.';
    PRINT N'[+] No explicit DELETE was issued against sales.TransactionItem.';
END
ELSE
BEGIN
    PRINT N'[•] Parent was already deleted. No new source DELETE required.';
END;

PRINT N'';
PRINT N'[5] SOURCE CASCADE VALIDATION';
PRINT N'------------------------------------------------------------';

IF EXISTS
(
    SELECT 1
    FROM sales.[Transaction]
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
)
BEGIN
    THROW 51192, N'Parent row still exists after DELETE.', 1;
END;

IF EXISTS
(
    SELECT 1
    FROM sales.TransactionItem
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
)
BEGIN
    THROW 51193, N'Child rows still exist after parent DELETE; cascade behavior failed.', 1;
END;

PRINT N'[✓] Parent row is absent.';
PRINT N'[✓] Both child rows are absent.';
PRINT N'[✓] ON DELETE CASCADE removed the children.';

PRINT N'';
PRINT N'[6] IMMEDIATE CDC OBSERVATION';
PRINT N'------------------------------------------------------------';

SELECT @ParentDeleteCdcRows = COUNT(*)
FROM cdc.sales_Transaction_CT
WHERE TRN_id = @TransactionId
  AND TRN_transaction_at = @BusinessEventTime
  AND __$operation = 1;

SELECT @ChildDeleteCdcRows = COUNT(*)
FROM cdc.sales_TransactionItem_CT
WHERE TRNIT_TRN_id = @TransactionId
  AND TRNIT_transaction_at = @BusinessEventTime
  AND __$operation = 1;

SELECT
    @ParentDeleteCdcRows AS immediate_parent_delete_cdc_rows,
    @ChildDeleteCdcRows  AS immediate_child_delete_cdc_rows;

IF @ParentDeleteCdcRows = 0 OR @ChildDeleteCdcRows < 2
BEGIN
    PRINT N'[•] Complete cascade DELETE CDC evidence is not yet available.';
    PRINT N'[•] This is valid because CDC capture is asynchronous.';
END
ELSE
BEGIN
    PRINT N'[•] Complete cascade DELETE CDC evidence was already available immediately.';
END;

PRINT N'';
PRINT N'[7] BOUNDED CDC CAPTURE WAIT';
PRINT N'------------------------------------------------------------';

WHILE (@ParentDeleteCdcRows <> 1 OR @ChildDeleteCdcRows <> 2)
  AND @PollAttempt < @MaxPollAttempts
BEGIN
    SET @PollAttempt += 1;

    WAITFOR DELAY '00:00:01';

    SELECT @ParentDeleteCdcRows = COUNT(*)
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation = 1;

    SELECT @ChildDeleteCdcRows = COUNT(*)
    FROM cdc.sales_TransactionItem_CT
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
      AND __$operation = 1;
END;

SELECT
    @PollAttempt         AS polling_attempts,
    @ParentDeleteCdcRows AS parent_delete_cdc_rows,
    @ChildDeleteCdcRows  AS child_delete_cdc_rows;

IF @ParentDeleteCdcRows <> 1
BEGIN
    THROW 51194, N'Expected exactly one parent CDC DELETE row within the 30-second window.', 1;
END;

IF @ChildDeleteCdcRows <> 2
BEGIN
    THROW 51195, N'Expected exactly two child CDC DELETE rows within the 30-second window.', 1;
END;

PRINT N'[✓] One parent CDC DELETE and two child CDC DELETEs are available.';

PRINT N'';
PRINT N'[8] CASCADE DELETE CDC EVIDENCE';
PRINT N'------------------------------------------------------------';

SELECT
    N'sales.Transaction' AS source_table,
    ct.__$start_lsn,
    ct.__$seqval,
    ct.__$operation,
    ct.__$update_mask,
    ct.__$command_id,
    sys.fn_cdc_map_lsn_to_time(ct.__$start_lsn) AS cdc_transaction_time,
    ct.TRN_id AS source_id,
    CAST(NULL AS int) AS product_variant_id
FROM cdc.sales_Transaction_CT AS ct
WHERE ct.TRN_id = @TransactionId
  AND ct.TRN_transaction_at = @BusinessEventTime
  AND ct.__$operation = 1

UNION ALL

SELECT
    N'sales.TransactionItem',
    ct.__$start_lsn,
    ct.__$seqval,
    ct.__$operation,
    ct.__$update_mask,
    ct.__$command_id,
    sys.fn_cdc_map_lsn_to_time(ct.__$start_lsn),
    ct.TRNIT_id,
    ct.TRNIT_PRDVA_id
FROM cdc.sales_TransactionItem_CT AS ct
WHERE ct.TRNIT_TRN_id = @TransactionId
  AND ct.TRNIT_transaction_at = @BusinessEventTime
  AND ct.__$operation = 1

ORDER BY __$command_id;

SELECT @SharedStartLsn = __$start_lsn
FROM cdc.sales_Transaction_CT
WHERE TRN_id = @TransactionId
  AND TRN_transaction_at = @BusinessEventTime
  AND __$operation = 1;

PRINT N'';
PRINT N'[9] CDC CORRELATION VALIDATION';
PRINT N'------------------------------------------------------------';

IF @SharedStartLsn IS NULL
BEGIN
    THROW 51196, N'Unable to resolve the parent DELETE start_lsn.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation = 1
      AND __$update_mask = @ExpectedMask
      AND __$start_lsn = @SharedStartLsn
)
BEGIN
    THROW 51197, N'Parent CDC DELETE does not match the expected operation, mask, and shared start_lsn.', 1;
END;

IF
(
    SELECT COUNT(*)
    FROM cdc.sales_TransactionItem_CT
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
      AND __$operation = 1
      AND __$update_mask = @ExpectedMask
      AND __$start_lsn = @SharedStartLsn
) <> 2
BEGIN
    THROW 51198, N'Expected exactly two child CDC DELETEs with the shared start_lsn and mask 0x01FF.', 1;
END;

IF
(
    SELECT COUNT(DISTINCT __$command_id)
    FROM
    (
        SELECT __$command_id
        FROM cdc.sales_Transaction_CT
        WHERE TRN_id = @TransactionId
          AND TRN_transaction_at = @BusinessEventTime
          AND __$operation = 1
          AND __$start_lsn = @SharedStartLsn

        UNION ALL

        SELECT __$command_id
        FROM cdc.sales_TransactionItem_CT
        WHERE TRNIT_TRN_id = @TransactionId
          AND TRNIT_transaction_at = @BusinessEventTime
          AND __$operation = 1
          AND __$start_lsn = @SharedStartLsn
    ) AS command_set
) <> 3
BEGIN
    THROW 51199, N'Expected three distinct CDC command_id values for the cascade DELETE transaction.', 1;
END;

IF
(
    SELECT
        CASE
            WHEN COUNT(*) = 3
             AND COUNT(DISTINCT __$command_id) = 3
             AND MIN(__$command_id) = 1
             AND MAX(__$command_id) = 3
            THEN 1
            ELSE 0
        END
    FROM
    (
        SELECT __$command_id
        FROM cdc.sales_Transaction_CT
        WHERE TRN_id = @TransactionId
          AND TRN_transaction_at = @BusinessEventTime
          AND __$operation = 1
          AND __$start_lsn = @SharedStartLsn

        UNION ALL

        SELECT __$command_id
        FROM cdc.sales_TransactionItem_CT
        WHERE TRNIT_TRN_id = @TransactionId
          AND TRNIT_transaction_at = @BusinessEventTime
          AND __$operation = 1
          AND __$start_lsn = @SharedStartLsn
    ) AS commands
) <> 1
BEGIN
    THROW 51200, N'Cascade DELETE command_id values are not the expected contiguous range 1 through 3.', 1;
END;

PRINT N'[✓] Parent and child DELETE rows share one __$start_lsn.';
PRINT N'[✓] Three distinct command_id values were captured.';
PRINT N'[✓] command_id range = 1 through 3.';
PRINT N'[✓] All three CDC rows use __$operation = 1.';
PRINT N'[✓] All three CDC rows use __$update_mask = 0x01FF.';

PRINT N'';
PRINT N'[10] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] Controlled CDC cascade DELETE test completed successfully.';
PRINT N'[✓] Exactly one explicit DELETE was issued against sales.Transaction.';
PRINT N'[✓] Two sales.TransactionItem rows were removed by ON DELETE CASCADE.';
PRINT N'[✓] CDC captured one parent DELETE and two child DELETEs.';
PRINT N'[✓] All three CDC DELETE rows share one transaction start_lsn.';
PRINT N'[✓] Evidence is limited to SQL Server source-side cascade and CDC behavior.';
PRINT N'';
