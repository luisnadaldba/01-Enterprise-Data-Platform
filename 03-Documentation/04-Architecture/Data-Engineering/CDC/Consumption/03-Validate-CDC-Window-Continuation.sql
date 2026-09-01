/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC CONSUMPTION
==============================================================================

    Script Name   : 03-Validate-CDC-Window-Continuation.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Prove incremental CDC window continuation semantics using
                    sys.fn_cdc_increment_lsn()
    Rerunnable    : Controlled
    Destructive   : No
    Changes State : Yes - creates two controlled sales.Transaction rows

    Test objective
    --------------------------------------------------------------------------
    Prove that CDC all-changes functions use closed LSN intervals and that a
    consumer must advance the next FROM boundary with:

        sys.fn_cdc_increment_lsn(previous_to_lsn)

    rather than reusing the previous TO LSN directly.

    Controlled sequence
    --------------------------------------------------------------------------
    1. Create/reuse Event A.
    2. Resolve Event A CDC start_lsn = Boundary B.
    3. Read Window N ending at B.
    4. Create/reuse Event B.
    5. Resolve Event B CDC start_lsn = Boundary C.
    6. Read overlapping window [B, C].
       Expected: Event A + Event B.
    7. Read continuation window [increment_lsn(B), C].
       Expected: Event B only.

    Expected conclusion
    --------------------------------------------------------------------------
    Reusing B as the next FROM boundary duplicates Event A because the
    CDC all-changes read interval is closed on both ends.

    Using increment_lsn(B) excludes the already-processed boundary B while
    preserving the next available LSN position.

    Important
    --------------------------------------------------------------------------
    No persistent consumer checkpoint is created by this script.

    The two controlled source rows are intentionally preserved so subsequent
    CDC consumption tests can reuse the same evidence. They can be removed
    later as part of a deliberate consumption-test baseline reset.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @CaptureInstance      sysname        = N'sales_Transaction',
    @PendingStatusId      tinyint,
    @OnlineChannelId      tinyint,

    @EventATime           datetime2(0)   = '2026-09-01T10:30:00',
    @EventBTime           datetime2(0)   = '2026-09-01T10:31:00',

    @EventAGross          decimal(19,2)  = 210.00,
    @EventADiscount       decimal(19,2)  = 21.00,
    @EventBGross          decimal(19,2)  = 220.00,
    @EventBDiscount       decimal(19,2)  = 22.00,

    @EventAId             bigint,
    @EventBId             bigint,

    @EventAStartLsn       binary(10),
    @EventBStartLsn       binary(10),
    @NextFromLsn          binary(10),

    @CurrentMaxLsn        binary(10),
    @PollAttempt          int = 0,
    @MaxPollAttempts      int = 30,

    @WindowNEventACount   bigint,
    @OverlapEventACount   bigint,
    @OverlapEventBCount   bigint,
    @ContinuationACount   bigint,
    @ContinuationBCount   bigint;

PRINT N'';
PRINT N'ATLAS ENGINEERING - VALIDATE CDC WINDOW CONTINUATION';
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
    THROW 51270, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

IF OBJECT_ID(N'cdc.fn_cdc_get_all_changes_sales_Transaction', N'IF') IS NULL
BEGIN
    THROW 51271, N'All-changes function for sales_Transaction was not found.', 1;
END;

SELECT @PendingStatusId = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'PENDING';

SELECT @OnlineChannelId = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = 'ONLINE';

IF @PendingStatusId IS NULL
BEGIN
    THROW 51272, N'Status PENDING was not found.', 1;
END;

IF @OnlineChannelId IS NULL
BEGIN
    THROW 51273, N'Channel ONLINE was not found.', 1;
END;

PRINT N'[✓] CDC read function exists.';
PRINT N'[✓] Status PENDING resolved.';
PRINT N'[✓] Channel ONLINE resolved.';

PRINT N'';
PRINT N'[2] CREATE OR REUSE EVENT A';
PRINT N'------------------------------------------------------------';

IF
(
    SELECT COUNT(*)
    FROM sales.[Transaction]
    WHERE TRN_transaction_at = @EventATime
      AND TRN_CST_id IS NULL
      AND TRN_TRNST_id = @PendingStatusId
      AND TRN_TRNCH_id = @OnlineChannelId
      AND TRN_gross_amount = @EventAGross
      AND TRN_discount_amount = @EventADiscount
) > 1
BEGIN
    THROW 51274, N'More than one source row matches Event A.', 1;
END;

SELECT @EventAId = TRN_id
FROM sales.[Transaction]
WHERE TRN_transaction_at = @EventATime
  AND TRN_CST_id IS NULL
  AND TRN_TRNST_id = @PendingStatusId
  AND TRN_TRNCH_id = @OnlineChannelId
  AND TRN_gross_amount = @EventAGross
  AND TRN_discount_amount = @EventADiscount;

IF @EventAId IS NULL
BEGIN
    DECLARE @InsertedA TABLE (TRN_id bigint NOT NULL);

    INSERT INTO sales.[Transaction]
    (
        TRN_CST_id,
        TRN_TRNST_id,
        TRN_TRNCH_id,
        TRN_transaction_at,
        TRN_gross_amount,
        TRN_discount_amount
    )
    OUTPUT inserted.TRN_id INTO @InsertedA(TRN_id)
    VALUES
    (
        NULL,
        @PendingStatusId,
        @OnlineChannelId,
        @EventATime,
        @EventAGross,
        @EventADiscount
    );

    SELECT @EventAId = TRN_id
    FROM @InsertedA;

    PRINT N'[+] Event A inserted.';
END
ELSE
BEGIN
    PRINT N'[•] Event A already exists. Reusing source row.';
END;

PRINT N'    Event A TRN_id = ' + CONVERT(nvarchar(30), @EventAId);

PRINT N'';
PRINT N'[3] WAIT FOR EVENT A CDC CAPTURE';
PRINT N'------------------------------------------------------------';

SET @PollAttempt = 0;
SET @EventAStartLsn = NULL;

WHILE @EventAStartLsn IS NULL
  AND @PollAttempt < @MaxPollAttempts
BEGIN
    SET @PollAttempt += 1;

    SET @CurrentMaxLsn = sys.fn_cdc_get_max_lsn();

    SELECT TOP (1)
        @EventAStartLsn = c.__$start_lsn
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        sys.fn_cdc_get_min_lsn(@CaptureInstance),
        @CurrentMaxLsn,
        N'all update old'
    ) AS c
    WHERE c.TRN_id = @EventAId
      AND c.TRN_transaction_at = @EventATime
      AND c.__$operation = 2
    ORDER BY c.__$start_lsn;

    IF @EventAStartLsn IS NULL
        WAITFOR DELAY '00:00:01';
END;

IF @EventAStartLsn IS NULL
BEGIN
    THROW 51275, N'Event A was not captured by CDC within 30 seconds.', 1;
END;

SELECT
    @EventAStartLsn AS event_a_start_lsn,
    sys.fn_cdc_map_lsn_to_time(@EventAStartLsn) AS event_a_cdc_time,
    @PollAttempt AS polling_attempts;

PRINT N'[✓] Event A CDC boundary resolved.';

PRINT N'';
PRINT N'[4] WINDOW N - CLOSED INTERVAL ENDING AT EVENT A';
PRINT N'------------------------------------------------------------';

DECLARE @WindowNFromLsn binary(10) =
    sys.fn_cdc_get_min_lsn(@CaptureInstance);

SELECT
    c.__$start_lsn,
    c.__$seqval,
    c.__$operation,
    c.__$update_mask,
    sys.fn_cdc_map_lsn_to_time(c.__$start_lsn) AS cdc_transaction_time,
    c.TRN_id,
    c.TRN_transaction_at,
    c.TRN_gross_amount,
    c.TRN_discount_amount
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @WindowNFromLsn,
    @EventAStartLsn,
    N'all update old'
) AS c
WHERE c.TRN_id = @EventAId
ORDER BY c.__$start_lsn, c.__$seqval, c.__$operation;

SELECT @WindowNEventACount = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @WindowNFromLsn,
    @EventAStartLsn,
    N'all update old'
) AS c
WHERE c.TRN_id = @EventAId
  AND c.__$operation = 2;

IF @WindowNEventACount <> 1
BEGIN
    THROW 51276, N'Window N must contain exactly one Event A INSERT.', 1;
END;

PRINT N'[✓] Window N contains Event A exactly once.';
PRINT N'[✓] Window N TO boundary = Event A start_lsn.';

PRINT N'';
PRINT N'[5] CREATE OR REUSE EVENT B';
PRINT N'------------------------------------------------------------';

IF
(
    SELECT COUNT(*)
    FROM sales.[Transaction]
    WHERE TRN_transaction_at = @EventBTime
      AND TRN_CST_id IS NULL
      AND TRN_TRNST_id = @PendingStatusId
      AND TRN_TRNCH_id = @OnlineChannelId
      AND TRN_gross_amount = @EventBGross
      AND TRN_discount_amount = @EventBDiscount
) > 1
BEGIN
    THROW 51277, N'More than one source row matches Event B.', 1;
END;

SELECT @EventBId = TRN_id
FROM sales.[Transaction]
WHERE TRN_transaction_at = @EventBTime
  AND TRN_CST_id IS NULL
  AND TRN_TRNST_id = @PendingStatusId
  AND TRN_TRNCH_id = @OnlineChannelId
  AND TRN_gross_amount = @EventBGross
  AND TRN_discount_amount = @EventBDiscount;

IF @EventBId IS NULL
BEGIN
    DECLARE @InsertedB TABLE (TRN_id bigint NOT NULL);

    INSERT INTO sales.[Transaction]
    (
        TRN_CST_id,
        TRN_TRNST_id,
        TRN_TRNCH_id,
        TRN_transaction_at,
        TRN_gross_amount,
        TRN_discount_amount
    )
    OUTPUT inserted.TRN_id INTO @InsertedB(TRN_id)
    VALUES
    (
        NULL,
        @PendingStatusId,
        @OnlineChannelId,
        @EventBTime,
        @EventBGross,
        @EventBDiscount
    );

    SELECT @EventBId = TRN_id
    FROM @InsertedB;

    PRINT N'[+] Event B inserted.';
END
ELSE
BEGIN
    PRINT N'[•] Event B already exists. Reusing source row.';
END;

PRINT N'    Event B TRN_id = ' + CONVERT(nvarchar(30), @EventBId);

PRINT N'';
PRINT N'[6] WAIT FOR EVENT B CDC CAPTURE';
PRINT N'------------------------------------------------------------';

SET @PollAttempt = 0;
SET @EventBStartLsn = NULL;

WHILE @EventBStartLsn IS NULL
  AND @PollAttempt < @MaxPollAttempts
BEGIN
    SET @PollAttempt += 1;

    SET @CurrentMaxLsn = sys.fn_cdc_get_max_lsn();

    SELECT TOP (1)
        @EventBStartLsn = c.__$start_lsn
    FROM cdc.fn_cdc_get_all_changes_sales_Transaction
    (
        sys.fn_cdc_get_min_lsn(@CaptureInstance),
        @CurrentMaxLsn,
        N'all update old'
    ) AS c
    WHERE c.TRN_id = @EventBId
      AND c.TRN_transaction_at = @EventBTime
      AND c.__$operation = 2
    ORDER BY c.__$start_lsn;

    IF @EventBStartLsn IS NULL
        WAITFOR DELAY '00:00:01';
END;

IF @EventBStartLsn IS NULL
BEGIN
    THROW 51278, N'Event B was not captured by CDC within 30 seconds.', 1;
END;

IF @EventBStartLsn <= @EventAStartLsn
BEGIN
    THROW 51279, N'Event B start_lsn must be greater than Event A start_lsn.', 1;
END;

SELECT
    @EventBStartLsn AS event_b_start_lsn,
    sys.fn_cdc_map_lsn_to_time(@EventBStartLsn) AS event_b_cdc_time,
    @PollAttempt AS polling_attempts;

PRINT N'[✓] Event B CDC boundary resolved.';
PRINT N'[✓] Event B LSN is greater than Event A LSN.';

PRINT N'';
PRINT N'[7] OVERLAPPING WINDOW [B, C]';
PRINT N'------------------------------------------------------------';

SELECT
    c.__$start_lsn,
    c.__$seqval,
    c.__$operation,
    c.__$update_mask,
    c.TRN_id,
    c.TRN_transaction_at,
    c.TRN_gross_amount,
    c.TRN_discount_amount
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @EventAStartLsn,
    @EventBStartLsn,
    N'all update old'
) AS c
WHERE c.TRN_id IN (@EventAId, @EventBId)
ORDER BY c.__$start_lsn, c.__$seqval, c.__$operation;

SELECT @OverlapEventACount = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @EventAStartLsn,
    @EventBStartLsn,
    N'all update old'
) AS c
WHERE c.TRN_id = @EventAId
  AND c.__$operation = 2;

SELECT @OverlapEventBCount = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @EventAStartLsn,
    @EventBStartLsn,
    N'all update old'
) AS c
WHERE c.TRN_id = @EventBId
  AND c.__$operation = 2;

IF @OverlapEventACount <> 1 OR @OverlapEventBCount <> 1
BEGIN
    THROW 51280, N'Overlapping window [B,C] must contain both Event A and Event B.', 1;
END;

PRINT N'[✓] Reusing previous TO LSN as the next FROM LSN returns Event A again.';
PRINT N'[✓] Closed interval behavior demonstrated.';

PRINT N'';
PRINT N'[8] CONTINUATION WINDOW [increment_lsn(B), C]';
PRINT N'------------------------------------------------------------';

SET @NextFromLsn = sys.fn_cdc_increment_lsn(@EventAStartLsn);

IF @NextFromLsn IS NULL
BEGIN
    THROW 51281, N'Unable to increment Event A start_lsn.', 1;
END;

IF @NextFromLsn <= @EventAStartLsn
BEGIN
    THROW 51282, N'increment_lsn(B) must be greater than B.', 1;
END;

IF @NextFromLsn > @EventBStartLsn
BEGIN
    THROW 51283, N'increment_lsn(B) advanced beyond Event B and would create a gap.', 1;
END;

SELECT
    @EventAStartLsn AS previous_to_lsn,
    @NextFromLsn AS next_from_lsn,
    @EventBStartLsn AS next_to_lsn;

SELECT
    c.__$start_lsn,
    c.__$seqval,
    c.__$operation,
    c.__$update_mask,
    c.TRN_id,
    c.TRN_transaction_at,
    c.TRN_gross_amount,
    c.TRN_discount_amount
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @NextFromLsn,
    @EventBStartLsn,
    N'all update old'
) AS c
WHERE c.TRN_id IN (@EventAId, @EventBId)
ORDER BY c.__$start_lsn, c.__$seqval, c.__$operation;

SELECT @ContinuationACount = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @NextFromLsn,
    @EventBStartLsn,
    N'all update old'
) AS c
WHERE c.TRN_id = @EventAId
  AND c.__$operation = 2;

SELECT @ContinuationBCount = COUNT_BIG(*)
FROM cdc.fn_cdc_get_all_changes_sales_Transaction
(
    @NextFromLsn,
    @EventBStartLsn,
    N'all update old'
) AS c
WHERE c.TRN_id = @EventBId
  AND c.__$operation = 2;

IF @ContinuationACount <> 0
BEGIN
    THROW 51284, N'Continuation window must not return Event A again.', 1;
END;

IF @ContinuationBCount <> 1
BEGIN
    THROW 51285, N'Continuation window must return Event B exactly once.', 1;
END;

PRINT N'[✓] Event A was excluded from the continuation window.';
PRINT N'[✓] Event B was returned exactly once.';
PRINT N'[✓] No gap was introduced between B and increment_lsn(B).';

PRINT N'';
PRINT N'[9] WINDOW SEMANTICS SUMMARY';
PRINT N'------------------------------------------------------------';

SELECT
    N'Window N' AS window_name,
    @WindowNFromLsn AS from_lsn,
    @EventAStartLsn AS to_lsn,
    @WindowNEventACount AS event_a_rows,
    CAST(0 AS bigint) AS event_b_rows

UNION ALL

SELECT
    N'Overlapping [B,C]',
    @EventAStartLsn,
    @EventBStartLsn,
    @OverlapEventACount,
    @OverlapEventBCount

UNION ALL

SELECT
    N'Continuation [increment(B),C]',
    @NextFromLsn,
    @EventBStartLsn,
    @ContinuationACount,
    @ContinuationBCount;

PRINT N'';
PRINT N'[10] FINAL RESULT';
PRINT N'------------------------------------------------------------';

PRINT N'[✓] CDC incremental continuation semantics validated successfully.';
PRINT N'[✓] CDC all-changes boundaries behave as a closed interval.';
PRINT N'[✓] Reusing previous TO LSN would duplicate the boundary event.';
PRINT N'[✓] fn_cdc_increment_lsn(previous_to_lsn) prevents that duplicate.';
PRINT N'[✓] Event B remained reachable; no gap was introduced.';
PRINT N'[•] No persistent consumer checkpoint was created.';
PRINT N'[•] Controlled Event A and Event B source rows were preserved for subsequent consumption tests.';
PRINT N'';
