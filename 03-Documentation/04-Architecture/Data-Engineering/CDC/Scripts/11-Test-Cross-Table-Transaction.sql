/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 11-Test-Cross-Table-Transaction.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Execute and validate one controlled SQL transaction that
                    inserts one sales.Transaction row and two related
                    sales.TransactionItem rows across two CDC capture instances
    Rerunnable    : Controlled
    Destructive   : No
    Changes State : Yes - inserts one parent and two child rows when necessary

    Controlled transaction
    --------------------------------------------------------------------------
    Command 1:
        INSERT sales.Transaction

        Status          : PENDING
        Channel         : ONLINE
        Gross Amount    : 150.00
        Discount Amount : 15.00

    Command 2:
        INSERT sales.TransactionItem

        Product Variant : 1
        Quantity        : 1
        Unit Price      : 100.00
        Unit Discount   : 10.00

    Command 3:
        INSERT sales.TransactionItem

        Product Variant : 2
        Quantity        : 1
        Unit Price      : 50.00
        Unit Discount   : 5.00

    Expected CDC representation
    --------------------------------------------------------------------------
    sales.Transaction:
        1 INSERT
        __$operation   = 2
        __$update_mask = 0x01FF
        __$command_id  = 1

    sales.TransactionItem:
        2 INSERTs
        __$operation   = 2
        __$update_mask = 0x01FF
        __$command_id  = 2 and 3

    All three CDC rows must share the same:
        __$start_lsn

    Historical reference
    --------------------------------------------------------------------------
    M01.17B validated this same logical workload:

        Parent:
            Gross = 150
            Discount = 15

        Child 1:
            ProductVariant = 1
            Quantity = 1
            Price = 100
            Discount = 10

        Child 2:
            ProductVariant = 2
            Quantity = 1
            Price = 50
            Discount = 5

    The original execution produced:
        TRN_id   = 6308
        TRNIT_id = 13770
        TRNIT_id = 13771

    These identity values are NOT hard-coded here.

    Evidence boundary
    --------------------------------------------------------------------------
    This script proves source-side SQL Server CDC correlation only.

    A shared __$start_lsn across capture instances proves that SQL Server CDC
    exposes enough metadata to correlate source changes from the same SQL
    transaction.

    It does NOT prove that any future downstream consumer will deliver these
    records atomically as one indivisible package.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @BusinessEventTime      datetime2(0)   = '2026-09-01T10:00:00',
    @PendingStatusId        tinyint,
    @OnlineChannelId        tinyint,
    @TransactionId          bigint,
    @TransactionItemId1     bigint,
    @TransactionItemId2     bigint,
    @MatchingParentRows     int,
    @MatchingChildRows      int,
    @ParentCdcRows          int,
    @ChildCdcRows           int,
    @PollAttempt            int = 0,
    @MaxPollAttempts        int = 30,
    @SharedStartLsn         binary(10),
    @ParentMask             varbinary(128) = 0x01FF,
    @ChildMask              varbinary(128) = 0x01FF;

PRINT N'';
PRINT N'ATLAS ENGINEERING - CROSS-TABLE CDC TRANSACTION TEST';
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
    THROW 51160, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = N'sales_Transaction'
      AND source_object_id = OBJECT_ID(N'sales.[Transaction]')
)
BEGIN
    THROW 51161, N'Expected capture instance sales_Transaction was not found.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = N'sales_TransactionItem'
      AND source_object_id = OBJECT_ID(N'sales.TransactionItem')
)
BEGIN
    THROW 51162, N'Expected capture instance sales_TransactionItem was not found.', 1;
END;

SELECT @PendingStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'PENDING';

SELECT @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = 'ONLINE';

IF @PendingStatusId IS NULL
BEGIN
    THROW 51163, N'Status PENDING was not found.', 1;
END;

IF @OnlineChannelId IS NULL
BEGIN
    THROW 51164, N'Channel ONLINE was not found.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM catalog.ProductVariant
    WHERE PRDVA_id = 1
)
BEGIN
    THROW 51165, N'catalog.ProductVariant PRDVA_id = 1 was not found.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM catalog.ProductVariant
    WHERE PRDVA_id = 2
)
BEGIN
    THROW 51166, N'catalog.ProductVariant PRDVA_id = 2 was not found.', 1;
END;

PRINT N'[✓] Both CDC capture instances exist.';
PRINT N'[✓] Status PENDING resolved.';
PRINT N'[✓] Channel ONLINE resolved.';
PRINT N'[✓] ProductVariant 1 exists.';
PRINT N'[✓] ProductVariant 2 exists.';

PRINT N'';
PRINT N'[2] CONTROLLED DATASET RESOLUTION';
PRINT N'------------------------------------------------------------';

SELECT @MatchingParentRows = COUNT(*)
FROM sales.[Transaction]
WHERE TRN_transaction_at = @BusinessEventTime
  AND TRN_CST_id IS NULL
  AND TRN_TRNST_id = @PendingStatusId
  AND TRN_TRNCH_id = @OnlineChannelId
  AND TRN_gross_amount = 150.00
  AND TRN_discount_amount = 15.00;

IF @MatchingParentRows > 1
BEGIN
    THROW 51167, N'More than one parent row matches the controlled cross-table signature.', 1;
END;

IF @MatchingParentRows = 1
BEGIN
    SELECT @TransactionId = TRN_id
    FROM sales.[Transaction]
    WHERE TRN_transaction_at = @BusinessEventTime
      AND TRN_CST_id IS NULL
      AND TRN_TRNST_id = @PendingStatusId
      AND TRN_TRNCH_id = @OnlineChannelId
      AND TRN_gross_amount = 150.00
      AND TRN_discount_amount = 15.00;

    SELECT @MatchingChildRows = COUNT(*)
    FROM sales.TransactionItem
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime;

    IF @MatchingChildRows <> 2
    BEGIN
        THROW 51168, N'Controlled parent already exists but does not have exactly two child rows.', 1;
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
        THROW 51169, N'Existing child rows do not match the controlled cross-table workload.', 1;
    END;

    PRINT N'[•] Controlled parent and two child rows already exist.';
    PRINT N'[•] No new source INSERT is required. Existing CDC evidence will be validated.';
END
ELSE
BEGIN
    DECLARE @InsertedParent TABLE
    (
        TRN_id bigint NOT NULL
    );

    DECLARE @InsertedChild1 TABLE
    (
        TRNIT_id bigint NOT NULL
    );

    DECLARE @InsertedChild2 TABLE
    (
        TRNIT_id bigint NOT NULL
    );

    PRINT N'[+] Starting one SQL transaction with three INSERT commands...';

    BEGIN TRY
        BEGIN TRANSACTION;

        ------------------------------------------------------------
        -- COMMAND 1 - PARENT INSERT
        ------------------------------------------------------------

        INSERT INTO sales.[Transaction]
        (
            TRN_CST_id,
            TRN_TRNST_id,
            TRN_TRNCH_id,
            TRN_transaction_at,
            TRN_gross_amount,
            TRN_discount_amount
        )
        OUTPUT inserted.TRN_id
            INTO @InsertedParent (TRN_id)
        VALUES
        (
            NULL,
            @PendingStatusId,
            @OnlineChannelId,
            @BusinessEventTime,
            150.00,
            15.00
        );

        SELECT @TransactionId = TRN_id
        FROM @InsertedParent;

        ------------------------------------------------------------
        -- COMMAND 2 - FIRST CHILD INSERT
        ------------------------------------------------------------

        INSERT INTO sales.TransactionItem
        (
            TRNIT_transaction_at,
            TRNIT_TRN_id,
            TRNIT_PRDVA_id,
            TRNIT_quantity,
            TRNIT_unit_price,
            TRNIT_unit_discount
        )
        OUTPUT inserted.TRNIT_id
            INTO @InsertedChild1 (TRNIT_id)
        VALUES
        (
            @BusinessEventTime,
            @TransactionId,
            1,
            1,
            100.00,
            10.00
        );

        SELECT @TransactionItemId1 = TRNIT_id
        FROM @InsertedChild1;

        ------------------------------------------------------------
        -- COMMAND 3 - SECOND CHILD INSERT
        ------------------------------------------------------------

        INSERT INTO sales.TransactionItem
        (
            TRNIT_transaction_at,
            TRNIT_TRN_id,
            TRNIT_PRDVA_id,
            TRNIT_quantity,
            TRNIT_unit_price,
            TRNIT_unit_discount
        )
        OUTPUT inserted.TRNIT_id
            INTO @InsertedChild2 (TRNIT_id)
        VALUES
        (
            @BusinessEventTime,
            @TransactionId,
            2,
            1,
            50.00,
            5.00
        );

        SELECT @TransactionItemId2 = TRNIT_id
        FROM @InsertedChild2;

        COMMIT TRANSACTION;

        PRINT N'[+] Cross-table SQL transaction committed.';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;

PRINT N'';
PRINT N'[3] SOURCE STATE';
PRINT N'------------------------------------------------------------';

SELECT
    TRN_id,
    TRN_transaction_at,
    TRN_TRNST_id,
    TRN_TRNCH_id,
    TRN_gross_amount,
    TRN_discount_amount,
    TRN_created_at,
    TRN_updated_at
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
    TRNIT_unit_discount,
    TRNIT_created_at,
    TRNIT_updated_at
FROM sales.TransactionItem
WHERE TRNIT_TRN_id = @TransactionId
  AND TRNIT_transaction_at = @BusinessEventTime
ORDER BY TRNIT_id;

IF
(
    SELECT COUNT(*)
    FROM sales.TransactionItem
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
) <> 2
BEGIN
    THROW 51170, N'Expected exactly two controlled child rows after commit.', 1;
END;

PRINT N'[✓] Source parent exists.';
PRINT N'[✓] Exactly two source child rows exist.';
PRINT N'    TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);
PRINT N'    TRNIT_id #1 = ' + CONVERT(nvarchar(30), @TransactionItemId1);
PRINT N'    TRNIT_id #2 = ' + CONVERT(nvarchar(30), @TransactionItemId2);

PRINT N'';
PRINT N'[4] IMMEDIATE CDC OBSERVATION';
PRINT N'------------------------------------------------------------';

SELECT @ParentCdcRows = COUNT(*)
FROM cdc.sales_Transaction_CT
WHERE TRN_id = @TransactionId
  AND TRN_transaction_at = @BusinessEventTime
  AND __$operation = 2;

SELECT @ChildCdcRows = COUNT(*)
FROM cdc.sales_TransactionItem_CT
WHERE TRNIT_TRN_id = @TransactionId
  AND TRNIT_transaction_at = @BusinessEventTime
  AND __$operation = 2;

SELECT
    @ParentCdcRows AS immediate_parent_cdc_rows,
    @ChildCdcRows  AS immediate_child_cdc_rows;

IF @ParentCdcRows = 0 OR @ChildCdcRows < 2
BEGIN
    PRINT N'[•] Complete cross-table CDC evidence is not yet available.';
    PRINT N'[•] This is valid because CDC capture is asynchronous.';
END
ELSE
BEGIN
    PRINT N'[•] Complete cross-table CDC evidence was already available immediately.';
END;

PRINT N'';
PRINT N'[5] BOUNDED CDC CAPTURE WAIT';
PRINT N'------------------------------------------------------------';

WHILE (@ParentCdcRows <> 1 OR @ChildCdcRows <> 2)
  AND @PollAttempt < @MaxPollAttempts
BEGIN
    SET @PollAttempt += 1;

    WAITFOR DELAY '00:00:01';

    SELECT @ParentCdcRows = COUNT(*)
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation = 2;

    SELECT @ChildCdcRows = COUNT(*)
    FROM cdc.sales_TransactionItem_CT
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
      AND __$operation = 2;
END;

SELECT
    @PollAttempt   AS polling_attempts,
    @ParentCdcRows AS parent_cdc_rows,
    @ChildCdcRows  AS child_cdc_rows;

IF @ParentCdcRows <> 1
BEGIN
    THROW 51171, N'Expected exactly one parent CDC INSERT row within the 30-second window.', 1;
END;

IF @ChildCdcRows <> 2
BEGIN
    THROW 51172, N'Expected exactly two child CDC INSERT rows within the 30-second window.', 1;
END;

PRINT N'[✓] One parent CDC INSERT and two child CDC INSERTs are available.';

PRINT N'';
PRINT N'[6] CROSS-TABLE CDC EVIDENCE';
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
  AND ct.__$operation = 2

UNION ALL

SELECT
    N'sales.TransactionItem' AS source_table,
    ct.__$start_lsn,
    ct.__$seqval,
    ct.__$operation,
    ct.__$update_mask,
    ct.__$command_id,
    sys.fn_cdc_map_lsn_to_time(ct.__$start_lsn) AS cdc_transaction_time,
    ct.TRNIT_id AS source_id,
    ct.TRNIT_PRDVA_id AS product_variant_id
FROM cdc.sales_TransactionItem_CT AS ct
WHERE ct.TRNIT_TRN_id = @TransactionId
  AND ct.TRNIT_transaction_at = @BusinessEventTime
  AND ct.__$operation = 2

ORDER BY __$command_id;

SELECT @SharedStartLsn = __$start_lsn
FROM cdc.sales_Transaction_CT
WHERE TRN_id = @TransactionId
  AND TRN_transaction_at = @BusinessEventTime
  AND __$operation = 2;

PRINT N'';
PRINT N'[7] TRANSACTION CORRELATION VALIDATION';
PRINT N'------------------------------------------------------------';

IF @SharedStartLsn IS NULL
BEGIN
    THROW 51173, N'Unable to resolve the parent CDC start_lsn.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation = 2
      AND __$update_mask = @ParentMask
      AND __$command_id = 1
      AND __$start_lsn = @SharedStartLsn
)
BEGIN
    THROW 51174, N'Parent CDC INSERT does not match operation 2, mask 0x01FF, command_id 1, and the shared start_lsn.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.sales_TransactionItem_CT
    WHERE TRNIT_id = @TransactionItemId1
      AND TRNIT_transaction_at = @BusinessEventTime
      AND TRNIT_TRN_id = @TransactionId
      AND TRNIT_PRDVA_id = 1
      AND __$operation = 2
      AND __$update_mask = @ChildMask
      AND __$command_id = 2
      AND __$start_lsn = @SharedStartLsn
)
BEGIN
    THROW 51175, N'First child CDC INSERT does not match command_id 2 and the shared transaction LSN.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.sales_TransactionItem_CT
    WHERE TRNIT_id = @TransactionItemId2
      AND TRNIT_transaction_at = @BusinessEventTime
      AND TRNIT_TRN_id = @TransactionId
      AND TRNIT_PRDVA_id = 2
      AND __$operation = 2
      AND __$update_mask = @ChildMask
      AND __$command_id = 3
      AND __$start_lsn = @SharedStartLsn
)
BEGIN
    THROW 51176, N'Second child CDC INSERT does not match command_id 3 and the shared transaction LSN.', 1;
END;

IF
(
    SELECT COUNT(*)
    FROM
    (
        SELECT __$start_lsn
        FROM cdc.sales_Transaction_CT
        WHERE TRN_id = @TransactionId
          AND TRN_transaction_at = @BusinessEventTime
          AND __$operation = 2

        UNION

        SELECT __$start_lsn
        FROM cdc.sales_TransactionItem_CT
        WHERE TRNIT_TRN_id = @TransactionId
          AND TRNIT_transaction_at = @BusinessEventTime
          AND __$operation = 2
    ) AS lsn_set
) <> 1
BEGIN
    THROW 51177, N'Cross-table CDC rows do not share exactly one transaction start_lsn.', 1;
END;

PRINT N'[✓] Parent and child CDC rows share one __$start_lsn.';
PRINT N'[✓] Parent command_id = 1.';
PRINT N'[✓] First child command_id = 2.';
PRINT N'[✓] Second child command_id = 3.';
PRINT N'[✓] All three rows use __$operation = 2.';
PRINT N'[✓] All three rows use __$update_mask = 0x01FF.';

PRINT N'';
PRINT N'[8] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] Controlled cross-table CDC transaction test completed successfully.';
PRINT N'[✓] One SQL transaction produced three source INSERT commands.';
PRINT N'[✓] CDC correlation across sales_Transaction and sales_TransactionItem was validated.';
PRINT N'[✓] Shared __$start_lsn confirmed across both capture instances.';
PRINT N'[✓] Command ordering 1 -> 2 -> 3 confirmed.';
PRINT N'[✓] Evidence is limited to source-side SQL Server CDC correlation.';
PRINT N'';
