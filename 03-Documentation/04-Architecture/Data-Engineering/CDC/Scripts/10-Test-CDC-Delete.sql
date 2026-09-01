/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 10-Test-CDC-Delete.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Execute and validate a controlled CDC DELETE test for
                    sales.Transaction
    Rerunnable    : Controlled
    Destructive   : Yes - deletes the controlled source row when necessary
    Changes State : Yes

    Controlled source-row signature
    --------------------------------------------------------------------------
    Business Event Time : 2026-09-01 09:35:00
    Channel             : ONLINE
    Customer            : NULL
    Gross Amount        : 100.00
    Discount Amount     : 10.00
    Expected Status     : CONFIRMED before DELETE

    Expected CDC representation
    --------------------------------------------------------------------------
    __$operation   = 1
    __$update_mask = 0x01FF
    __$command_id  = 1

    Historical reference
    --------------------------------------------------------------------------
    The original M01.15 laboratory test validated a DELETE on the same logical
    test transaction after the PENDING -> CONFIRMED UPDATE.

    Important
    --------------------------------------------------------------------------
    CDC capture is asynchronous.

    Rerun behavior:
    - if the controlled source row exists in CONFIRMED status, this script
      deletes it and validates the CDC DELETE row;
    - if the source row no longer exists, the script reuses the existing CDC
      DELETE evidence;
    - if the source row exists in any unexpected status, the script stops.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @CaptureInstance       sysname        = N'sales_Transaction',
    @BusinessEventTime     datetime2(0)   = '2026-09-01T09:35:00',
    @GrossAmount           decimal(19,2)  = 100.00,
    @DiscountAmount        decimal(19,2)  = 10.00,
    @ExpectedMask          varbinary(128) = 0x01FF,
    @ConfirmedStatusId     tinyint,
    @OnlineChannelId       tinyint,
    @TransactionId         bigint,
    @CurrentStatusId       tinyint,
    @MatchingSourceRows    int,
    @ImmediateDeleteRows   int,
    @MatchingDeleteRows    int,
    @PollAttempt           int = 0,
    @MaxPollAttempts       int = 30;

PRINT N'';
PRINT N'ATLAS ENGINEERING - CONTROLLED CDC DELETE TEST';
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
    THROW 51140, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @CaptureInstance
      AND source_object_id = OBJECT_ID(N'sales.[Transaction]')
)
BEGIN
    THROW 51141, N'Expected capture instance sales_Transaction was not found.', 1;
END;

SELECT @ConfirmedStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'CONFIRMED';

SELECT @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = 'ONLINE';

IF @ConfirmedStatusId IS NULL
BEGIN
    THROW 51142, N'Status CONFIRMED was not found.', 1;
END;

IF @OnlineChannelId IS NULL
BEGIN
    THROW 51143, N'Channel ONLINE was not found.', 1;
END;

PRINT N'[✓] Database-level CDC is enabled.';
PRINT N'[✓] Capture instance sales_Transaction exists.';
PRINT N'[✓] Status CONFIRMED resolved.';
PRINT N'[✓] Channel ONLINE resolved.';

PRINT N'';
PRINT N'[2] CONTROLLED SOURCE ROW RESOLUTION';
PRINT N'------------------------------------------------------------';

SELECT @MatchingSourceRows = COUNT(*)
FROM sales.[Transaction]
WHERE TRN_transaction_at = @BusinessEventTime
  AND TRN_CST_id IS NULL
  AND TRN_TRNCH_id = @OnlineChannelId
  AND TRN_gross_amount = @GrossAmount
  AND TRN_discount_amount = @DiscountAmount;

IF @MatchingSourceRows > 1
BEGIN
    THROW 51144, N'More than one source row matches the controlled DELETE signature. Manual review is required.', 1;
END;

IF @MatchingSourceRows = 1
BEGIN
    SELECT
        @TransactionId = TRN_id,
        @CurrentStatusId = TRN_TRNST_id
    FROM sales.[Transaction]
    WHERE TRN_transaction_at = @BusinessEventTime
      AND TRN_CST_id IS NULL
      AND TRN_TRNCH_id = @OnlineChannelId
      AND TRN_gross_amount = @GrossAmount
      AND TRN_discount_amount = @DiscountAmount;

    SELECT
        TRN_id,
        TRN_transaction_at,
        TRN_CST_id,
        TRN_TRNST_id,
        TRN_TRNCH_id,
        TRN_gross_amount,
        TRN_discount_amount,
        TRN_created_at,
        TRN_updated_at
    FROM sales.[Transaction]
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime;

    IF @CurrentStatusId <> @ConfirmedStatusId
    BEGIN
        THROW 51145, N'Controlled source row exists but is not in CONFIRMED status.', 1;
    END;

    PRINT N'[✓] Controlled source row resolved.';
    PRINT N'    TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);
END
ELSE
BEGIN
    PRINT N'[•] Controlled source row no longer exists.';
    PRINT N'[•] Attempting to reuse existing CDC DELETE evidence.';

    SELECT TOP (1)
        @TransactionId = ct.TRN_id
    FROM cdc.sales_Transaction_CT AS ct
    WHERE ct.TRN_transaction_at = @BusinessEventTime
      AND ct.TRN_CST_id IS NULL
      AND ct.TRN_TRNST_id = @ConfirmedStatusId
      AND ct.TRN_TRNCH_id = @OnlineChannelId
      AND ct.TRN_gross_amount = @GrossAmount
      AND ct.TRN_discount_amount = @DiscountAmount
      AND ct.__$operation = 1
    ORDER BY ct.__$start_lsn DESC;

    IF @TransactionId IS NULL
    BEGIN
        THROW 51146, N'Controlled source row is absent and no matching CDC DELETE evidence was found. Execute scripts 08 and 09 first.', 1;
    END;

    PRINT N'[✓] Existing CDC DELETE evidence resolved.';
    PRINT N'    TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);
END;

PRINT N'';
PRINT N'[3] CHILD-ROW SAFETY CHECK';
PRINT N'------------------------------------------------------------';

IF EXISTS
(
    SELECT 1
    FROM sales.TransactionItem
    WHERE TRNIT_TRN_id = @TransactionId
      AND TRNIT_transaction_at = @BusinessEventTime
)
BEGIN
    THROW 51147, N'Controlled Transaction has TransactionItem child rows. This isolated DELETE test must not trigger cascade behavior.', 1;
END;

PRINT N'[✓] No TransactionItem child rows exist for the controlled transaction.';
PRINT N'[✓] This test will validate an isolated parent DELETE only.';

PRINT N'';
PRINT N'[4] CONTROLLED DELETE';
PRINT N'------------------------------------------------------------';

IF @MatchingSourceRows = 1
BEGIN
    PRINT N'[+] Deleting controlled sales.Transaction row...';

    DELETE FROM sales.[Transaction]
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND TRN_TRNST_id = @ConfirmedStatusId
      AND TRN_TRNCH_id = @OnlineChannelId
      AND TRN_gross_amount = @GrossAmount
      AND TRN_discount_amount = @DiscountAmount;

    IF @@ROWCOUNT <> 1
    BEGIN
        THROW 51148, N'Controlled DELETE did not affect exactly one source row.', 1;
    END;

    PRINT N'[+] Controlled DELETE committed.';
END
ELSE
BEGIN
    PRINT N'[•] Source row was already deleted. No source change required.';
END;

IF EXISTS
(
    SELECT 1
    FROM sales.[Transaction]
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
)
BEGIN
    THROW 51149, N'Controlled source row still exists after DELETE.', 1;
END;

PRINT N'[✓] Controlled source row is absent from sales.Transaction.';

PRINT N'';
PRINT N'[5] IMMEDIATE CDC OBSERVATION';
PRINT N'------------------------------------------------------------';

SELECT @ImmediateDeleteRows = COUNT(*)
FROM cdc.sales_Transaction_CT
WHERE TRN_id = @TransactionId
  AND TRN_transaction_at = @BusinessEventTime
  AND __$operation = 1;

SELECT @ImmediateDeleteRows AS immediate_matching_delete_rows;

IF @ImmediateDeleteRows = 0
BEGIN
    PRINT N'[•] CDC DELETE row is not available immediately after source COMMIT.';
    PRINT N'[•] This is valid because CDC capture is asynchronous.';
END
ELSE
BEGIN
    PRINT N'[•] CDC DELETE row was already available at the immediate observation.';
END;

PRINT N'';
PRINT N'[6] BOUNDED CDC CAPTURE WAIT';
PRINT N'------------------------------------------------------------';

SET @MatchingDeleteRows = @ImmediateDeleteRows;

WHILE @MatchingDeleteRows = 0
  AND @PollAttempt < @MaxPollAttempts
BEGIN
    SET @PollAttempt += 1;

    WAITFOR DELAY '00:00:01';

    SELECT @MatchingDeleteRows = COUNT(*)
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation = 1;
END;

SELECT
    @PollAttempt         AS polling_attempts,
    @MatchingDeleteRows AS matching_delete_rows;

IF @MatchingDeleteRows = 0
BEGIN
    THROW 51150, N'CDC DELETE row was not captured within the 30-second validation window.', 1;
END;

IF @MatchingDeleteRows <> 1
BEGIN
    THROW 51151, N'Expected exactly one CDC DELETE row for the controlled transaction.', 1;
END;

PRINT N'[✓] Controlled DELETE became available in CDC.';

PRINT N'';
PRINT N'[7] CDC DELETE REPRESENTATION';
PRINT N'------------------------------------------------------------';

SELECT
    ct.__$start_lsn,
    ct.__$end_lsn,
    ct.__$seqval,
    ct.__$operation,
    ct.__$update_mask,
    ct.__$command_id,
    sys.fn_cdc_map_lsn_to_time(ct.__$start_lsn) AS cdc_transaction_time,
    ct.TRN_id,
    ct.TRN_transaction_at,
    ct.TRN_CST_id,
    ct.TRN_TRNST_id,
    ct.TRN_TRNCH_id,
    ct.TRN_gross_amount,
    ct.TRN_discount_amount,
    ct.TRN_created_at,
    ct.TRN_updated_at
FROM cdc.sales_Transaction_CT AS ct
WHERE ct.TRN_id = @TransactionId
  AND ct.TRN_transaction_at = @BusinessEventTime
  AND ct.__$operation = 1;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation = 1
      AND __$update_mask = @ExpectedMask
)
BEGIN
    THROW 51152, N'CDC DELETE update mask differs from expected 0x01FF.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation = 1
      AND __$command_id = 1
      AND TRN_TRNST_id = @ConfirmedStatusId
)
BEGIN
    THROW 51153, N'CDC DELETE row does not preserve the expected CONFIRMED before-image or command_id = 1.', 1;
END;

PRINT N'[✓] __$operation = 1 (DELETE).';
PRINT N'[✓] __$update_mask = 0x01FF.';
PRINT N'[✓] __$command_id = 1.';
PRINT N'[✓] Deleted row preserves the CONFIRMED source image.';

PRINT N'';
PRINT N'[8] CONTROLLED TRANSACTION CDC HISTORY';
PRINT N'------------------------------------------------------------';

SELECT
    ct.__$start_lsn,
    ct.__$seqval,
    ct.__$operation,
    ct.__$update_mask,
    ct.__$command_id,
    sys.fn_cdc_map_lsn_to_time(ct.__$start_lsn) AS cdc_transaction_time,
    ct.TRN_id,
    ct.TRN_TRNST_id,
    ct.TRN_gross_amount,
    ct.TRN_discount_amount,
    ct.TRN_created_at,
    ct.TRN_updated_at
FROM cdc.sales_Transaction_CT AS ct
WHERE ct.TRN_id = @TransactionId
  AND ct.TRN_transaction_at = @BusinessEventTime
ORDER BY
    ct.__$start_lsn,
    ct.__$seqval,
    ct.__$operation;

PRINT N'';
PRINT N'[9] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] Controlled CDC DELETE test completed successfully.';
PRINT N'[✓] Source TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);
PRINT N'[✓] Source row no longer exists.';
PRINT N'[✓] CDC operation = DELETE (1).';
PRINT N'[✓] CDC update mask = 0x01FF.';
PRINT N'[✓] CDC command_id = 1.';
PRINT N'[✓] No TransactionItem cascade was involved in this test.';
PRINT N'';
