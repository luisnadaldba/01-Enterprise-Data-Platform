/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 08-Test-CDC-Insert.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Execute and validate a controlled CDC INSERT test for
                    sales.Transaction
    Rerunnable    : Controlled
    Destructive   : No
    Changes State : Yes - inserts one controlled source row when necessary

    Test model
    --------------------------------------------------------------------------
    Status               : PENDING
    Channel              : ONLINE
    Customer             : NULL
    Gross Amount         : 100.00
    Discount Amount      : 10.00
    Business Event Time  : 2026-09-01 09:35:00

    Expected CDC representation
    --------------------------------------------------------------------------
    __$operation   = 2
    __$update_mask = 0x01FF
    __$command_id  = 1

    Historical reference
    --------------------------------------------------------------------------
    The original M01.12 laboratory test produced TRN_id = 6307 with the same
    business values (PENDING / ONLINE / 100.00 / 10.00).

    This reconstruction intentionally does NOT hard-code TRN_id = 6307 because
    TRN_id is an IDENTITY value and the current database state has advanced.

    Important
    --------------------------------------------------------------------------
    CDC capture is asynchronous.

    This script records:
    1. the committed source row;
    2. the immediate CDC observation;
    3. a bounded polling period of up to 30 seconds;
    4. the captured CDC INSERT row;
    5. the mapped CDC transaction time.

    Rerun behavior:
    - if the exact controlled source row does not exist, it is inserted;
    - if exactly one matching source row already exists, it is reused;
    - if more than one matching row exists, the script stops with THROW.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @CaptureInstance       sysname      = N'sales_Transaction',
    @BusinessEventTime     datetime2(0) = '2026-09-01T09:35:00',
    @GrossAmount           decimal(19,2) = 100.00,
    @DiscountAmount        decimal(19,2) = 10.00,
    @PendingStatusId       tinyint,
    @OnlineChannelId       tinyint,
    @TransactionId         bigint,
    @MatchingSourceRows    int,
    @ImmediateCdcRows      int,
    @MatchingCdcRows       int,
    @PollAttempt           int = 0,
    @MaxPollAttempts       int = 30,
    @ExpectedMask          varbinary(128) = 0x01FF;

PRINT N'';
PRINT N'ATLAS ENGINEERING - CONTROLLED CDC INSERT TEST';
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
    ;THROW 51100, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @CaptureInstance
      AND source_object_id = OBJECT_ID(N'sales.[Transaction]')
)
BEGIN
    ;THROW 51101, N'Expected capture instance sales_Transaction was not found.', 1;
END;

SELECT @PendingStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'PENDING';

IF @PendingStatusId IS NULL
BEGIN
    ;THROW 51102, N'Controlled status PENDING was not found.', 1;
END;

SELECT @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = 'ONLINE';

IF @OnlineChannelId IS NULL
BEGIN
    ;THROW 51103, N'Controlled channel ONLINE was not found.', 1;
END;

PRINT N'[✓] Database-level CDC is enabled.';
PRINT N'[✓] Capture instance sales_Transaction exists.';
PRINT N'[✓] Status PENDING resolved.';
PRINT N'[✓] Channel ONLINE resolved.';

PRINT N'';
PRINT N'[2] CONTROLLED SOURCE ROW';
PRINT N'------------------------------------------------------------';

SELECT @MatchingSourceRows = COUNT(*)
FROM sales.[Transaction]
WHERE TRN_transaction_at = @BusinessEventTime
  AND TRN_CST_id IS NULL
  AND TRN_TRNST_id = @PendingStatusId
  AND TRN_TRNCH_id = @OnlineChannelId
  AND TRN_gross_amount = @GrossAmount
  AND TRN_discount_amount = @DiscountAmount;

IF @MatchingSourceRows > 1
BEGIN
    ;THROW 51104, N'More than one source row matches the controlled INSERT signature. Manual review is required.', 1;
END;

IF @MatchingSourceRows = 0
BEGIN
    DECLARE @InsertedTransaction TABLE
    (
        TRN_id bigint NOT NULL
    );

    PRINT N'[+] Inserting controlled sales.Transaction row...';

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
        INTO @InsertedTransaction (TRN_id)
    VALUES
    (
        NULL,
        @PendingStatusId,
        @OnlineChannelId,
        @BusinessEventTime,
        @GrossAmount,
        @DiscountAmount
    );

    SELECT @TransactionId = TRN_id
    FROM @InsertedTransaction;

    PRINT N'[+] Controlled INSERT committed.';
END
ELSE
BEGIN
    SELECT @TransactionId = TRN_id
    FROM sales.[Transaction]
    WHERE TRN_transaction_at = @BusinessEventTime
      AND TRN_CST_id IS NULL
      AND TRN_TRNST_id = @PendingStatusId
      AND TRN_TRNCH_id = @OnlineChannelId
      AND TRN_gross_amount = @GrossAmount
      AND TRN_discount_amount = @DiscountAmount;

    PRINT N'[•] Exact controlled source row already exists. Reusing it.';
END;

IF @TransactionId IS NULL
BEGIN
    ;THROW 51105, N'Unable to resolve the controlled TRN_id.', 1;
END;

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

PRINT N'[✓] Controlled source row resolved.';
PRINT N'    TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);

PRINT N'';
PRINT N'[3] IMMEDIATE CDC OBSERVATION';
PRINT N'------------------------------------------------------------';

SELECT @ImmediateCdcRows = COUNT(*)
FROM cdc.sales_Transaction_CT
WHERE TRN_id = @TransactionId
  AND TRN_transaction_at = @BusinessEventTime
  AND __$operation = 2;

SELECT @ImmediateCdcRows AS immediate_matching_cdc_rows;

IF @ImmediateCdcRows = 0
BEGIN
    PRINT N'[•] CDC INSERT row is not available immediately after source COMMIT.';
    PRINT N'[•] This is valid because CDC capture is asynchronous.';
END
ELSE
BEGIN
    PRINT N'[•] CDC INSERT row was already available at the immediate observation.';
    PRINT N'[•] Asynchronous capture does not guarantee a visible delay on every execution.';
END;

PRINT N'';
PRINT N'[4] BOUNDED CDC CAPTURE WAIT';
PRINT N'------------------------------------------------------------';

SET @MatchingCdcRows = @ImmediateCdcRows;

WHILE @MatchingCdcRows = 0
  AND @PollAttempt < @MaxPollAttempts
BEGIN
    SET @PollAttempt += 1;

    WAITFOR DELAY '00:00:01';

    SELECT @MatchingCdcRows = COUNT(*)
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation = 2;
END;

SELECT
    @PollAttempt      AS polling_attempts,
    @MatchingCdcRows AS matching_cdc_rows;

IF @MatchingCdcRows = 0
BEGIN
    ;THROW 51106, N'CDC INSERT row was not captured within the 30-second validation window.', 1;
END;

IF @MatchingCdcRows <> 1
BEGIN
    ;THROW 51107, N'Expected exactly one CDC INSERT row for the controlled transaction.', 1;
END;

PRINT N'[✓] Controlled INSERT became available in CDC.';

PRINT N'';
PRINT N'[5] CDC INSERT REPRESENTATION';
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
  AND ct.__$operation = 2;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation = 2
      AND __$update_mask = @ExpectedMask
)
BEGIN
    ;THROW 51108, N'CDC INSERT update mask differs from expected 0x01FF.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation = 2
      AND __$command_id = 1
)
BEGIN
    ;THROW 51109, N'CDC INSERT command_id differs from expected value 1.', 1;
END;

PRINT N'[✓] __$operation = 2 (INSERT).';
PRINT N'[✓] __$update_mask = 0x01FF.';
PRINT N'[✓] __$command_id = 1.';

PRINT N'';
PRINT N'[6] SOURCE TIME VS CDC TRANSACTION TIME';
PRINT N'------------------------------------------------------------';

SELECT
    @BusinessEventTime AS business_event_time,
    sys.fn_cdc_map_lsn_to_time(ct.__$start_lsn) AS cdc_transaction_time
FROM cdc.sales_Transaction_CT AS ct
WHERE ct.TRN_id = @TransactionId
  AND ct.TRN_transaction_at = @BusinessEventTime
  AND ct.__$operation = 2;

PRINT N'[✓] Business-event time and CDC transaction time are exposed separately.';

PRINT N'';
PRINT N'[7] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] Controlled CDC INSERT test completed successfully.';
PRINT N'[✓] Source TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);
PRINT N'[✓] Status = PENDING.';
PRINT N'[✓] Channel = ONLINE.';
PRINT N'[✓] Gross Amount = 100.00.';
PRINT N'[✓] Discount Amount = 10.00.';
PRINT N'[✓] CDC operation = INSERT (2).';
PRINT N'[✓] CDC update mask = 0x01FF.';
PRINT N'[✓] CDC command_id = 1.';
PRINT N'';
