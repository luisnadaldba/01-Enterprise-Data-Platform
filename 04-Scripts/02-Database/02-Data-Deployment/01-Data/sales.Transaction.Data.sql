/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : sales.Transaction
    Type        : Sales / Sample Data
    Prefix      : TRN
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the commercial transactions used by the AtlasCommerce sample
    data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Generates a deterministic transaction history from 2025-01-01 through
      the fixed sample-data cutoff 2026-08-24 12:45:00.
    - Generates between 1 and 20 transactions per day using a deterministic
      non-uniform distribution.
    - Transactions generated on the cutoff date never occur after the fixed
      sample-data cutoff timestamp.
    - COMPLETED is generated only for Transactions old enough to have completed
      the downstream fulfillment lifecycle.
    - Produces 6,306 expected transaction rows for the configured date range.
    - Inserts only transactions that do not already exist.
    - Existing transactions are preserved without modification.
    - No automatic UPDATE is performed.
    - TransactionChannel dependencies are resolved by controlled channel code.
    - TransactionStatus dependencies are resolved by controlled status code.
    - ONLINE transactions always reference an identified Customer.
    - STORE transactions may represent anonymous customers.
    - Gross and discount amounts are generated deterministically.
    - Source data is validated before deployment.
    - Data is deployed using a generated set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● sales.Transaction';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @TRN_start_date date         = '2025-01-01';
DECLARE @TRN_data_end   datetime2(0) = '2026-08-24T12:45:00';
DECLARE @TRN_end_date   date         = CONVERT(date, @TRN_data_end);

DECLARE @TRN_rows_added      int;
DECLARE @TRN_rows_processed  int;

DECLARE @TRN_TRNCH_online_id tinyint;
DECLARE @TRN_TRNCH_store_id  tinyint;

DECLARE @TRN_TRNST_pending_id   tinyint;
DECLARE @TRN_TRNST_confirmed_id tinyint;
DECLARE @TRN_TRNST_completed_id tinyint;
DECLARE @TRN_TRNST_cancelled_id tinyint;
DECLARE @TRN_TRNST_failed_id    tinyint;

DECLARE @TRN_customer_count int;


/*==============================================================================
    DEPENDENCY RESOLUTION
==============================================================================*/

SELECT
    @TRN_TRNCH_online_id = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = 'ONLINE';


SELECT
    @TRN_TRNCH_store_id = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = 'STORE';


SELECT
    @TRN_TRNST_pending_id = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'PENDING';


SELECT
    @TRN_TRNST_confirmed_id = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'CONFIRMED';


SELECT
    @TRN_TRNST_completed_id = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'COMPLETED';


SELECT
    @TRN_TRNST_cancelled_id = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'CANCELLED';


SELECT
    @TRN_TRNST_failed_id = TRNST_id
FROM sales.TransactionStatus
WHERE TRNST_code = 'FAILED';


IF @TRN_TRNCH_online_id IS NULL
OR @TRN_TRNCH_store_id IS NULL
BEGIN

    ;THROW 50590,
        N'sales.Transaction data deployment requires ONLINE and STORE TransactionChannel records.',
        1;

END;


IF @TRN_TRNST_pending_id IS NULL
OR @TRN_TRNST_confirmed_id IS NULL
OR @TRN_TRNST_completed_id IS NULL
OR @TRN_TRNST_cancelled_id IS NULL
OR @TRN_TRNST_failed_id IS NULL
BEGIN

    ;THROW 50591,
        N'sales.Transaction data deployment requires all controlled TransactionStatus records.',
        1;

END;


/*==============================================================================
    CUSTOMER SOURCE
==============================================================================*/

DECLARE @TRN_customers TABLE
(
    CustomerNumber int NOT NULL PRIMARY KEY,
    CST_id         int NOT NULL UNIQUE
);


INSERT INTO @TRN_customers
(
    CustomerNumber,
    CST_id
)
SELECT
    ROW_NUMBER() OVER
    (
        ORDER BY
            C.CST_name,
            C.CST_birth_date,
            C.CST_id
    ),
    C.CST_id
FROM customer.Customer AS C
WHERE C.CST_is_active = 1;


SELECT
    @TRN_customer_count = COUNT(*)
FROM @TRN_customers;


IF @TRN_customer_count = 0
BEGIN

    ;THROW 50592,
        N'sales.Transaction data deployment requires at least one active Customer for ONLINE transactions.',
        1;

END;


/*==============================================================================
    GENERATION SUPPORT
==============================================================================*/

DECLARE @TRN_slots TABLE
(
    SlotNumber tinyint NOT NULL PRIMARY KEY
);


INSERT INTO @TRN_slots
(
    SlotNumber
)
VALUES
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10),
    (11),
    (12),
    (13),
    (14),
    (15),
    (16),
    (17),
    (18),
    (19),
    (20);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

DECLARE @TRN_source TABLE
(
    TRN_transaction_at  datetime2(0)  NOT NULL PRIMARY KEY,
    TRN_CST_id          int           NULL,
    TRN_TRNST_id        tinyint       NOT NULL,
    TRN_TRNCH_id        tinyint       NOT NULL,
    TRN_gross_amount    decimal(19,2) NOT NULL,
    TRN_discount_amount decimal(19,2) NOT NULL,
    TRN_created_at      datetime2(0)  NOT NULL,
    TRN_updated_at      datetime2(0)  NOT NULL
);


;WITH DateSource AS
(
    SELECT
        0 AS DayNumber,
        @TRN_start_date AS TransactionDate

    UNION ALL

    SELECT
        D.DayNumber + 1,
        DATEADD(DAY, 1, D.TransactionDate)
    FROM DateSource AS D
    WHERE D.TransactionDate < @TRN_end_date
),
GeneratedSource AS
(
    SELECT
        D.DayNumber,
        D.TransactionDate,
        S.SlotNumber,

        DATEADD
        (
            SECOND,
            28800
                + (
                    (
                        D.DayNumber * 811
                        + CONVERT(int, S.SlotNumber) * 2531
                    ) % 50400
                ),
            CONVERT(datetime2(0), D.TransactionDate)
        ) AS TransactionAt,

        (
            D.DayNumber * 7
            + CONVERT(int, S.SlotNumber) * 11
        ) % 100 AS ChannelBucket,

        (
            D.DayNumber * 13
            + CONVERT(int, S.SlotNumber) * 17
        ) % 100 AS StatusBucket,

        (
            D.DayNumber * 19
            + CONVERT(int, S.SlotNumber) * 23
        ) % 100 AS AnonymousBucket,

        1
            + (
                (
                    D.DayNumber * 29
                    + CONVERT(int, S.SlotNumber) * 31
                ) % @TRN_customer_count
            ) AS CustomerNumber,

        CONVERT
        (
            decimal(19,2),
            29.90
                + (
                    (
                        D.DayNumber * 131
                        + CONVERT(int, S.SlotNumber) * 97
                    ) % 471
                )
        ) AS GrossAmount,

        (
            D.DayNumber * 37
            + CONVERT(int, S.SlotNumber) * 41
        ) % 100 AS DiscountBucket,

        (
            D.DayNumber * 43
            + CONVERT(int, S.SlotNumber) * 47
        ) % 16 AS DiscountPercentBucket

    FROM DateSource AS D

    INNER JOIN @TRN_slots AS S
        ON S.SlotNumber <=
            1 + ((D.DayNumber * 17 + 11) % 20)
),
ResolvedSource AS
(
    SELECT
        G.DayNumber,
        G.TransactionDate,
        G.TransactionAt,
        G.StatusBucket,
        G.AnonymousBucket,
        G.CustomerNumber,
        G.GrossAmount,
        G.DiscountBucket,
        G.DiscountPercentBucket,

        CASE
            WHEN G.ChannelBucket < 45
                THEN @TRN_TRNCH_online_id
            ELSE @TRN_TRNCH_store_id
        END AS TRNCH_id

    FROM GeneratedSource AS G
    WHERE G.TransactionAt <= @TRN_data_end
)
INSERT INTO @TRN_source
(
    TRN_transaction_at,
    TRN_CST_id,
    TRN_TRNST_id,
    TRN_TRNCH_id,
    TRN_gross_amount,
    TRN_discount_amount,
    TRN_created_at,
    TRN_updated_at
)
SELECT
    R.TransactionAt,

    CASE
        WHEN R.TRNCH_id = @TRN_TRNCH_online_id
            THEN C.CST_id

        WHEN R.AnonymousBucket < 35
            THEN NULL

        ELSE C.CST_id
    END,

    CASE
        /*----------------------------------------------------------------------
            RECENT TRANSACTIONS

            Transactions from the last seven days are intentionally kept out
            of COMPLETED so downstream shipping cannot appear delivered in the
            future relative to the fixed sample-data cutoff.
        ----------------------------------------------------------------------*/

        WHEN R.TransactionAt >
                DATEADD
                (
                    DAY,
                    -7,
                    @TRN_data_end
                )
        THEN
            CASE
                WHEN R.StatusBucket < 25
                    THEN @TRN_TRNST_pending_id
                WHEN R.StatusBucket < 90
                    THEN @TRN_TRNST_confirmed_id
                WHEN R.StatusBucket < 95
                    THEN @TRN_TRNST_cancelled_id
                ELSE @TRN_TRNST_failed_id
            END

        /*----------------------------------------------------------------------
            HISTORICAL TRANSACTIONS
        ----------------------------------------------------------------------*/

        ELSE
            CASE
                WHEN R.StatusBucket < 90
                    THEN @TRN_TRNST_completed_id
                WHEN R.StatusBucket < 96
                    THEN @TRN_TRNST_cancelled_id
                WHEN R.StatusBucket < 99
                    THEN @TRN_TRNST_failed_id
                ELSE @TRN_TRNST_confirmed_id
            END
    END,

    R.TRNCH_id,

    R.GrossAmount,

    CASE
        WHEN R.DiscountBucket < 65
            THEN CONVERT(decimal(19,2), 0.00)

        ELSE
            CONVERT
            (
                decimal(19,2),
                ROUND
                (
                    R.GrossAmount
                        * (
                            5.0 + R.DiscountPercentBucket
                          )
                        / 100.0,
                    2
                )
            )
    END,

    R.TransactionAt,
    R.TransactionAt

FROM ResolvedSource AS R

INNER JOIN @TRN_customers AS C
    ON C.CustomerNumber = R.CustomerNumber

OPTION (MAXRECURSION 0);


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

SELECT
    @TRN_rows_processed = COUNT(*)
FROM @TRN_source;


IF @TRN_rows_processed < 5000
OR @TRN_rows_processed > 10000
BEGIN

    ;THROW 50593,
        N'sales.Transaction source data must contain between 5,000 and 10,000 transactions.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @TRN_source AS S
    WHERE S.TRN_transaction_at < CONVERT(datetime2(0), @TRN_start_date)
       OR S.TRN_transaction_at > @TRN_data_end
)
BEGIN

    ;THROW 50594,
        N'sales.Transaction source data contains a transaction outside the configured date range.',
        1;

END;


/*------------------------------------------------------------------------------
    RECENT TRANSACTIONS MUST NOT BE COMPLETED
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @TRN_source AS S
    WHERE S.TRN_transaction_at >
            DATEADD
            (
                DAY,
                -7,
                @TRN_data_end
            )
      AND S.TRN_TRNST_id = @TRN_TRNST_completed_id
)
BEGIN

    ;THROW 50595,
        N'sales.Transaction source data contains a recent Transaction incorrectly classified as COMPLETED.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @TRN_source AS S
    WHERE S.TRN_TRNCH_id = @TRN_TRNCH_online_id
      AND S.TRN_CST_id IS NULL
)
BEGIN

    ;THROW 50596,
        N'sales.Transaction source data contains an anonymous ONLINE transaction.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @TRN_source AS S
    WHERE S.TRN_gross_amount < 0.00
       OR S.TRN_discount_amount < 0.00
       OR S.TRN_discount_amount > S.TRN_gross_amount
)
BEGIN

    ;THROW 50597,
        N'sales.Transaction source data contains an invalid gross or discount amount.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

INSERT INTO sales.[Transaction]
(
    TRN_CST_id,
    TRN_transaction_at,
    TRN_TRNCH_id,
    TRN_TRNST_id,
    TRN_gross_amount,
    TRN_discount_amount,
    TRN_created_at,
    TRN_updated_at
)
SELECT
    S.TRN_CST_id,
    S.TRN_transaction_at,
    S.TRN_TRNCH_id,
    S.TRN_TRNST_id,
    S.TRN_gross_amount,
    S.TRN_discount_amount,
    S.TRN_created_at,
    S.TRN_updated_at
FROM @TRN_source AS S

WHERE NOT EXISTS
(
    SELECT 1
    FROM sales.[Transaction] AS T
    WHERE T.TRN_transaction_at = S.TRN_transaction_at
      AND
      (
            T.TRN_CST_id = S.TRN_CST_id

            OR
            (
                T.TRN_CST_id IS NULL
                AND S.TRN_CST_id IS NULL
            )
      )
      AND T.TRN_TRNCH_id = S.TRN_TRNCH_id
      AND T.TRN_TRNST_id = S.TRN_TRNST_id
      AND T.TRN_gross_amount = S.TRN_gross_amount
      AND T.TRN_discount_amount = S.TRN_discount_amount
);


SET @TRN_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @TRN_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @TRN_rows_processed - @TRN_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @TRN_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';