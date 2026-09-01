/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 09-Test-CDC-Update.sql
    Version       : 1.0.1
    Target        : AtlasCommerce
    Purpose       : Execute and validate a controlled CDC UPDATE test for
                    sales.Transaction
    Rerunnable    : Controlled
    Destructive   : No
    Changes State : Yes - updates the controlled source row when necessary

    Controlled transition
    --------------------------------------------------------------------------
    PENDING -> CONFIRMED

    Controlled source-row signature
    --------------------------------------------------------------------------
    Business Event Time : 2026-09-01 09:35:00
    Channel             : ONLINE
    Customer            : NULL
    Gross Amount        : 100.00
    Discount Amount     : 10.00

    Expected CDC representation
    --------------------------------------------------------------------------
    BEFORE image:
        __$operation = 3

    AFTER image:
        __$operation = 4

    Both rows must share:
        __$start_lsn
        __$seqval
        __$command_id = 1

    Expected update mask:
        0x0108

    Historical reference
    --------------------------------------------------------------------------
    The original M01.13 laboratory test validated the same transition
    PENDING -> CONFIRMED and produced the CDC pair operations 3/4 with
    update mask 0x0108.

    Important
    --------------------------------------------------------------------------
    CDC capture is asynchronous.

    Rerun behavior:
    - if the controlled row is still PENDING, this script performs the UPDATE;
    - if it is already CONFIRMED, the script does not update it again and
      validates the existing CDC UPDATE pair;
    - any other source status causes THROW.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @CaptureInstance       sysname       = N'sales_Transaction',
    @BusinessEventTime     datetime2(0)  = '2026-09-01T09:35:00',
    @GrossAmount           decimal(19,2) = 100.00,
    @DiscountAmount        decimal(19,2) = 10.00,
    @ExpectedMask          varbinary(128)= 0x0108,
    @PendingStatusId       tinyint,
    @ConfirmedStatusId     tinyint,
    @OnlineChannelId       tinyint,
    @TransactionId         bigint,
    @CurrentStatusId       tinyint,
    @MatchingSourceRows    int,
    @ImmediatePairRows     int,
    @MatchingPairRows      int,
    @PollAttempt           int = 0,
    @MaxPollAttempts       int = 30;

PRINT N'';
PRINT N'ATLAS ENGINEERING - CONTROLLED CDC UPDATE TEST';
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
    ;THROW 51120, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.change_tables
    WHERE capture_instance = @CaptureInstance
      AND source_object_id = OBJECT_ID(N'sales.[Transaction]')
)
BEGIN
    ;THROW 51121, N'Expected capture instance sales_Transaction was not found.', 1;
END;

SELECT @PendingStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'PENDING';

SELECT @ConfirmedStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'CONFIRMED';

SELECT @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = 'ONLINE';

IF @PendingStatusId IS NULL
BEGIN
    THROW 51122, N'Status PENDING was not found.', 1;
END;

IF @ConfirmedStatusId IS NULL
BEGIN
    THROW 51123, N'Status CONFIRMED was not found.', 1;
END;

IF @OnlineChannelId IS NULL
BEGIN
    THROW 51124, N'Channel ONLINE was not found.', 1;
END;

PRINT N'[✓] Database-level CDC is enabled.';
PRINT N'[✓] Capture instance sales_Transaction exists.';
PRINT N'[✓] Status PENDING resolved.';
PRINT N'[✓] Status CONFIRMED resolved.';
PRINT N'[✓] Channel ONLINE resolved.';

PRINT N'';
PRINT N'[2] CONTROLLED SOURCE ROW';
PRINT N'------------------------------------------------------------';

SELECT @MatchingSourceRows = COUNT(*)
FROM sales.[Transaction]
WHERE TRN_transaction_at = @BusinessEventTime
  AND TRN_CST_id IS NULL
  AND TRN_TRNCH_id = @OnlineChannelId
  AND TRN_gross_amount = @GrossAmount
  AND TRN_discount_amount = @DiscountAmount
  AND TRN_TRNST_id IN (@PendingStatusId, @ConfirmedStatusId);

IF @MatchingSourceRows = 0
BEGIN
    ;THROW 51125, N'Controlled source row was not found. Execute 08-Test-CDC-Insert.sql first.', 1;
END;

IF @MatchingSourceRows > 1
BEGIN
    ;THROW 51126, N'More than one source row matches the controlled UPDATE signature. Manual review is required.', 1;
END;

SELECT
    @TransactionId = TRN_id,
    @CurrentStatusId = TRN_TRNST_id
FROM sales.[Transaction]
WHERE TRN_transaction_at = @BusinessEventTime
  AND TRN_CST_id IS NULL
  AND TRN_TRNCH_id = @OnlineChannelId
  AND TRN_gross_amount = @GrossAmount
  AND TRN_discount_amount = @DiscountAmount
  AND TRN_TRNST_id IN (@PendingStatusId, @ConfirmedStatusId);

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
PRINT N'[3] CONTROLLED UPDATE';
PRINT N'------------------------------------------------------------';

IF @CurrentStatusId = @PendingStatusId
BEGIN
    PRINT N'[+] Updating controlled transaction from PENDING to CONFIRMED...';

    UPDATE sales.[Transaction]
    SET
        TRN_TRNST_id = @ConfirmedStatusId,
        TRN_updated_at = SYSUTCDATETIME()
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND TRN_TRNST_id = @PendingStatusId;

    IF @@ROWCOUNT <> 1
    BEGIN
        ;THROW 51127, N'Controlled UPDATE did not affect exactly one source row.', 1;
    END;

    PRINT N'[+] Controlled UPDATE committed.';
END
ELSE IF @CurrentStatusId = @ConfirmedStatusId
BEGIN
    PRINT N'[•] Controlled source row is already CONFIRMED.';
    PRINT N'[•] No source UPDATE required. Existing CDC pair will be validated.';
END
ELSE
BEGIN
    ;THROW 51128, N'Controlled source row is in an unexpected status.', 1;
END;

SELECT
    TRN_id,
    TRN_transaction_at,
    TRN_TRNST_id,
    TRN_updated_at
FROM sales.[Transaction]
WHERE TRN_id = @TransactionId
  AND TRN_transaction_at = @BusinessEventTime;

PRINT N'';
PRINT N'[4] IMMEDIATE CDC OBSERVATION';
PRINT N'------------------------------------------------------------';

;WITH UpdatePairs AS
(
    SELECT
        __$start_lsn,
        __$seqval,
        __$command_id
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation IN (3,4)
    GROUP BY
        __$start_lsn,
        __$seqval,
        __$command_id
    HAVING COUNT(*) = 2
       AND SUM(CASE WHEN __$operation = 3 THEN 1 ELSE 0 END) = 1
       AND SUM(CASE WHEN __$operation = 4 THEN 1 ELSE 0 END) = 1
)
SELECT @ImmediatePairRows = COUNT(*)
FROM UpdatePairs;

SELECT @ImmediatePairRows AS immediate_matching_update_pairs;

IF @ImmediatePairRows = 0
BEGIN
    PRINT N'[•] CDC UPDATE pair is not available immediately after source COMMIT.';
    PRINT N'[•] This is valid because CDC capture is asynchronous.';
END
ELSE
BEGIN
    PRINT N'[•] CDC UPDATE pair was already available at the immediate observation.';
END;

PRINT N'';
PRINT N'[5] BOUNDED CDC CAPTURE WAIT';
PRINT N'------------------------------------------------------------';

SET @MatchingPairRows = @ImmediatePairRows;

WHILE @MatchingPairRows = 0
  AND @PollAttempt < @MaxPollAttempts
BEGIN
    SET @PollAttempt += 1;

    WAITFOR DELAY '00:00:01';

    ;WITH UpdatePairs AS
    (
        SELECT
            __$start_lsn,
            __$seqval,
            __$command_id
        FROM cdc.sales_Transaction_CT
        WHERE TRN_id = @TransactionId
          AND TRN_transaction_at = @BusinessEventTime
          AND __$operation IN (3,4)
        GROUP BY
            __$start_lsn,
            __$seqval,
            __$command_id
        HAVING COUNT(*) = 2
           AND SUM(CASE WHEN __$operation = 3 THEN 1 ELSE 0 END) = 1
           AND SUM(CASE WHEN __$operation = 4 THEN 1 ELSE 0 END) = 1
    )
    SELECT @MatchingPairRows = COUNT(*)
    FROM UpdatePairs;
END;

SELECT
    @PollAttempt      AS polling_attempts,
    @MatchingPairRows AS matching_update_pairs;

IF @MatchingPairRows = 0
BEGIN
    ;THROW 51129, N'CDC UPDATE pair was not captured within the 30-second validation window.', 1;
END;

IF @MatchingPairRows <> 1
BEGIN
    ;THROW 51130, N'Expected exactly one CDC UPDATE pair for the controlled transition.', 1;
END;

PRINT N'[✓] Controlled UPDATE pair became available in CDC.';

PRINT N'';
PRINT N'[6] CDC UPDATE REPRESENTATION';
PRINT N'------------------------------------------------------------';

;WITH TargetPair AS
(
    SELECT TOP (1)
        __$start_lsn,
        __$seqval,
        __$command_id
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation IN (3,4)
    GROUP BY
        __$start_lsn,
        __$seqval,
        __$command_id
    HAVING COUNT(*) = 2
       AND SUM(CASE WHEN __$operation = 3 THEN 1 ELSE 0 END) = 1
       AND SUM(CASE WHEN __$operation = 4 THEN 1 ELSE 0 END) = 1
    ORDER BY __$start_lsn DESC
)
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
INNER JOIN TargetPair AS p
    ON p.__$start_lsn = ct.__$start_lsn
   AND p.__$seqval = ct.__$seqval
   AND p.__$command_id = ct.__$command_id
WHERE ct.__$operation IN (3,4)
ORDER BY ct.__$operation;

PRINT N'';
PRINT N'[7] UPDATE PAIR INVARIANTS';
PRINT N'------------------------------------------------------------';

;WITH TargetPair AS
(
    SELECT TOP (1)
        __$start_lsn,
        __$seqval,
        __$command_id
    FROM cdc.sales_Transaction_CT
    WHERE TRN_id = @TransactionId
      AND TRN_transaction_at = @BusinessEventTime
      AND __$operation IN (3,4)
    GROUP BY
        __$start_lsn,
        __$seqval,
        __$command_id
    HAVING COUNT(*) = 2
       AND SUM(CASE WHEN __$operation = 3 THEN 1 ELSE 0 END) = 1
       AND SUM(CASE WHEN __$operation = 4 THEN 1 ELSE 0 END) = 1
    ORDER BY __$start_lsn DESC
)
SELECT
    p.__$start_lsn,
    p.__$seqval,
    p.__$command_id,
    COUNT(*) AS pair_rows,
    MIN(ct.__$update_mask) AS min_update_mask,
    MAX(ct.__$update_mask) AS max_update_mask
FROM TargetPair AS p
INNER JOIN cdc.sales_Transaction_CT AS ct
    ON ct.__$start_lsn = p.__$start_lsn
   AND ct.__$seqval = p.__$seqval
   AND ct.__$command_id = p.__$command_id
WHERE ct.__$operation IN (3,4)
GROUP BY
    p.__$start_lsn,
    p.__$seqval,
    p.__$command_id;

IF NOT EXISTS
(
    SELECT 1
    FROM cdc.sales_Transaction_CT AS before_row
    INNER JOIN cdc.sales_Transaction_CT AS after_row
        ON after_row.__$start_lsn = before_row.__$start_lsn
       AND after_row.__$seqval = before_row.__$seqval
       AND after_row.__$command_id = before_row.__$command_id
       AND after_row.TRN_id = before_row.TRN_id
       AND after_row.TRN_transaction_at = before_row.TRN_transaction_at
    WHERE before_row.TRN_id = @TransactionId
      AND before_row.TRN_transaction_at = @BusinessEventTime
      AND before_row.__$operation = 3
      AND after_row.__$operation = 4
      AND before_row.__$command_id = 1
      AND before_row.__$update_mask = @ExpectedMask
      AND after_row.__$update_mask = @ExpectedMask
      AND before_row.TRN_TRNST_id = @PendingStatusId
      AND after_row.TRN_TRNST_id = @ConfirmedStatusId
)
BEGIN
    ;THROW 51131, N'CDC UPDATE pair does not match the expected PENDING -> CONFIRMED transition, command_id, or update mask.', 1;
END;

PRINT N'[✓] BEFORE image operation = 3.';
PRINT N'[✓] AFTER image operation = 4.';
PRINT N'[✓] Both images share start_lsn, seqval and command_id.';
PRINT N'[✓] __$command_id = 1.';
PRINT N'[✓] __$update_mask = 0x0108.';
PRINT N'[✓] Status transition = PENDING -> CONFIRMED.';

PRINT N'';
PRINT N'[8] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] Controlled CDC UPDATE test completed successfully.';
PRINT N'[✓] Source TRN_id = ' + CONVERT(nvarchar(30), @TransactionId);
PRINT N'[✓] Transition = PENDING -> CONFIRMED.';
PRINT N'[✓] CDC operations = 3 / 4.';
PRINT N'[✓] CDC update mask = 0x0108.';
PRINT N'[✓] CDC command_id = 1.';
PRINT N'';
