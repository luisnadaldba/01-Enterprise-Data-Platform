/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : payment.PaymentRefund
    Type        : Payment / Sample Data
    Prefix      : PAYRF
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the financial refund events associated with AtlasCommerce sample
    payments.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only refund events that do not already exist.
    - Existing refund events are preserved without modification.
    - No automatic UPDATE is performed.
    - Refunds are generated only for Payments whose current status is
      PARTIALLY_REFUNDED or REFUNDED.
    - PARTIALLY_REFUNDED Payments receive a cumulative refund greater than zero
      and lower than the original Payment amount.
    - REFUNDED Payments reconcile exactly to the original Payment amount.
    - Some REFUNDED Payments are represented by multiple refund events to
      preserve incremental financial history.
    - PaymentRefundReason dependencies are resolved by controlled reason name.
    - Refund timestamps always occur after the related payment approval.
    - Cumulative refund amount never exceeds the original Payment amount.
    - Source data is validated before deployment.
    - Data is deployed using generated set-based operations.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● payment.PaymentRefund';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @PAYRF_rows_added     int;
DECLARE @PAYRF_rows_processed int;

DECLARE @PAYRF_data_end datetime2(0) = '2026-08-24T12:45:00';

DECLARE @PAYRF_PAYST_partially_refunded_id tinyint;
DECLARE @PAYRF_PAYST_refunded_id           tinyint;

DECLARE @PAYRF_PAYRR_customer_return_id    tinyint;
DECLARE @PAYRF_PAYRR_duplicate_charge_id   tinyint;
DECLARE @PAYRF_PAYRR_fraud_id              tinyint;
DECLARE @PAYRF_PAYRR_operational_error_id  tinyint;
DECLARE @PAYRF_PAYRR_order_cancellation_id tinyint;


/*==============================================================================
    DEPENDENCY RESOLUTION
==============================================================================*/

SELECT
    @PAYRF_PAYST_partially_refunded_id = PAYST_id
FROM payment.PaymentStatus
WHERE PAYST_name = N'PARTIALLY_REFUNDED';


SELECT
    @PAYRF_PAYST_refunded_id = PAYST_id
FROM payment.PaymentStatus
WHERE PAYST_name = N'REFUNDED';


IF @PAYRF_PAYST_partially_refunded_id IS NULL
OR @PAYRF_PAYST_refunded_id IS NULL
BEGIN

    ;THROW 50690,
        N'payment.PaymentRefund data deployment requires PARTIALLY_REFUNDED and REFUNDED PaymentStatus records.',
        1;

END;


SELECT
    @PAYRF_PAYRR_customer_return_id = PAYRR_id
FROM payment.PaymentRefundReason
WHERE PAYRR_name = N'CUSTOMER_RETURN';


SELECT
    @PAYRF_PAYRR_duplicate_charge_id = PAYRR_id
FROM payment.PaymentRefundReason
WHERE PAYRR_name = N'DUPLICATE_CHARGE';


SELECT
    @PAYRF_PAYRR_fraud_id = PAYRR_id
FROM payment.PaymentRefundReason
WHERE PAYRR_name = N'FRAUD';


SELECT
    @PAYRF_PAYRR_operational_error_id = PAYRR_id
FROM payment.PaymentRefundReason
WHERE PAYRR_name = N'OPERATIONAL_ERROR';


SELECT
    @PAYRF_PAYRR_order_cancellation_id = PAYRR_id
FROM payment.PaymentRefundReason
WHERE PAYRR_name = N'ORDER_CANCELLATION';


IF @PAYRF_PAYRR_customer_return_id IS NULL
OR @PAYRF_PAYRR_duplicate_charge_id IS NULL
OR @PAYRF_PAYRR_fraud_id IS NULL
OR @PAYRF_PAYRR_operational_error_id IS NULL
OR @PAYRF_PAYRR_order_cancellation_id IS NULL
BEGIN

    ;THROW 50691,
        N'payment.PaymentRefund data deployment requires all controlled PaymentRefundReason records.',
        1;

END;


/*==============================================================================
    PAYMENT BASIS
==============================================================================*/

DECLARE @PAYRF_basis TABLE
(
    PAY_id          bigint        NOT NULL PRIMARY KEY,
    PAY_PAYST_id    tinyint       NOT NULL,
    PAY_amount      decimal(19,2) NOT NULL,
    PAY_attempted_at datetime2(0) NOT NULL,
    PAY_approved_at datetime2(0)  NOT NULL,
    PAYRR_id        tinyint       NOT NULL,
    SplitBucket     int           NOT NULL,
    RefundAmount    decimal(19,2) NOT NULL
);


INSERT INTO @PAYRF_basis
(
    PAY_id,
    PAY_PAYST_id,
    PAY_amount,
    PAY_attempted_at,
    PAY_approved_at,
    PAYRR_id,
    SplitBucket,
    RefundAmount
)
SELECT
    P.PAY_id,
    P.PAY_PAYST_id,
    P.PAY_amount,
    P.PAY_attempted_at,
    P.PAY_approved_at,

    CASE
        WHEN X.ReasonBucket < 45
            THEN @PAYRF_PAYRR_customer_return_id

        WHEN X.ReasonBucket < 65
            THEN @PAYRF_PAYRR_order_cancellation_id

        WHEN X.ReasonBucket < 80
            THEN @PAYRF_PAYRR_duplicate_charge_id

        WHEN X.ReasonBucket < 95
            THEN @PAYRF_PAYRR_operational_error_id

        ELSE @PAYRF_PAYRR_fraud_id
    END,

    X.SplitBucket,

    CONVERT
    (
        decimal(19,2),
        CASE
            WHEN P.PAY_PAYST_id =
                    @PAYRF_PAYST_partially_refunded_id
            THEN
                ROUND
                (
                    P.PAY_amount
                        *
                        (
                            20.0
                            + X.PartialPercentBucket
                        )
                        / 100.0,
                    2
                )
            ELSE P.PAY_amount
        END
    )

FROM payment.Payment AS P

CROSS APPLY
(
    SELECT
        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    P.PAY_id,
                    P.PAY_attempted_at,
                    701
                )
            )
        ) % 100 AS ReasonBucket,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    P.PAY_id,
                    P.PAY_attempted_at,
                    809
                )
            )
        ) % 100 AS SplitBucket,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    P.PAY_id,
                    P.PAY_attempted_at,
                    907
                )
            )
        ) % 31 AS PartialPercentBucket
) AS X

WHERE P.PAY_PAYST_id IN
(
    @PAYRF_PAYST_partially_refunded_id,
    @PAYRF_PAYST_refunded_id
)
AND P.PAY_approved_at IS NOT NULL;


/*==============================================================================
    SOURCE DATA
==============================================================================*/

DECLARE @PAYRF_source TABLE
(
    PAYRF_PAY_id       bigint        NOT NULL,
    PAYRF_PAYRR_id     tinyint       NOT NULL,
    PAYRF_event_number tinyint       NOT NULL,
    PAYRF_amount       decimal(19,2) NOT NULL,
    PAYRF_refunded_at  datetime2(0)  NOT NULL,
    PAYRF_created_at   datetime2(0)  NOT NULL,
    PAYRF_updated_at   datetime2(0)  NOT NULL
);


/*==============================================================================
    PARTIAL REFUNDS
==============================================================================*/

INSERT INTO @PAYRF_source
(
    PAYRF_PAY_id,
    PAYRF_PAYRR_id,
    PAYRF_event_number,
    PAYRF_amount,
    PAYRF_refunded_at,
    PAYRF_created_at,
    PAYRF_updated_at
)
SELECT
    B.PAY_id,
    B.PAYRR_id,
    1,
    B.RefundAmount,
    DATEADD(DAY, 7, B.PAY_approved_at),
    DATEADD(DAY, 7, B.PAY_approved_at),
    DATEADD(DAY, 7, B.PAY_approved_at)

FROM @PAYRF_basis AS B

WHERE B.PAY_PAYST_id =
        @PAYRF_PAYST_partially_refunded_id;


/*==============================================================================
    FULL REFUNDS - SINGLE EVENT
==============================================================================*/

INSERT INTO @PAYRF_source
(
    PAYRF_PAY_id,
    PAYRF_PAYRR_id,
    PAYRF_event_number,
    PAYRF_amount,
    PAYRF_refunded_at,
    PAYRF_created_at,
    PAYRF_updated_at
)
SELECT
    B.PAY_id,
    B.PAYRR_id,
    1,
    B.PAY_amount,
    DATEADD(DAY, 7, B.PAY_approved_at),
    DATEADD(DAY, 7, B.PAY_approved_at),
    DATEADD(DAY, 7, B.PAY_approved_at)

FROM @PAYRF_basis AS B

WHERE B.PAY_PAYST_id =
        @PAYRF_PAYST_refunded_id

AND B.SplitBucket >= 25;


/*==============================================================================
    FULL REFUNDS - FIRST EVENT
==============================================================================*/

INSERT INTO @PAYRF_source
(
    PAYRF_PAY_id,
    PAYRF_PAYRR_id,
    PAYRF_event_number,
    PAYRF_amount,
    PAYRF_refunded_at,
    PAYRF_created_at,
    PAYRF_updated_at
)
SELECT
    B.PAY_id,
    B.PAYRR_id,
    1,

    CONVERT
    (
        decimal(19,2),
        FLOOR(B.PAY_amount * 40.00) / 100.00
    ),

    DATEADD(DAY, 5, B.PAY_approved_at),
    DATEADD(DAY, 5, B.PAY_approved_at),
    DATEADD(DAY, 5, B.PAY_approved_at)

FROM @PAYRF_basis AS B

WHERE B.PAY_PAYST_id =
        @PAYRF_PAYST_refunded_id

AND B.SplitBucket < 25;


/*==============================================================================
    FULL REFUNDS - SECOND EVENT
==============================================================================*/

INSERT INTO @PAYRF_source
(
    PAYRF_PAY_id,
    PAYRF_PAYRR_id,
    PAYRF_event_number,
    PAYRF_amount,
    PAYRF_refunded_at,
    PAYRF_created_at,
    PAYRF_updated_at
)
SELECT
    B.PAY_id,

    CASE
        WHEN B.SplitBucket < 8
            THEN @PAYRF_PAYRR_operational_error_id
        ELSE B.PAYRR_id
    END,

    2,

    B.PAY_amount
        -
        CONVERT
        (
            decimal(19,2),
            FLOOR(B.PAY_amount * 40.00) / 100.00
        ),

    DATEADD(DAY, 8, B.PAY_approved_at),
    DATEADD(DAY, 8, B.PAY_approved_at),
    DATEADD(DAY, 8, B.PAY_approved_at)

FROM @PAYRF_basis AS B

WHERE B.PAY_PAYST_id =
        @PAYRF_PAYST_refunded_id

AND B.SplitBucket < 25;


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

SELECT
    @PAYRF_rows_processed = COUNT(*)
FROM @PAYRF_source;


IF @PAYRF_rows_processed = 0
BEGIN

    ;THROW 50692,
        N'payment.PaymentRefund source data did not generate any rows.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAYRF_source AS S
    WHERE S.PAYRF_amount <= 0.00
)
BEGIN

    ;THROW 50693,
        N'payment.PaymentRefund source data contains an invalid refund amount.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAYRF_source AS S

    INNER JOIN payment.Payment AS P
        ON P.PAY_id = S.PAYRF_PAY_id

    WHERE S.PAYRF_refunded_at < P.PAY_attempted_at
)
BEGIN

    ;THROW 50694,
        N'payment.PaymentRefund source data contains a refund before its Payment attempt.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAYRF_source AS S

    INNER JOIN payment.Payment AS P
        ON P.PAY_id = S.PAYRF_PAY_id

    WHERE P.PAY_approved_at IS NULL
       OR S.PAYRF_refunded_at < P.PAY_approved_at
)
BEGIN

    ;THROW 50695,
        N'payment.PaymentRefund source data contains a refund before its Payment approval.',
        1;

END;


/*------------------------------------------------------------------------------
    SAMPLE DATA CUTOFF
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @PAYRF_source AS S
    WHERE S.PAYRF_refunded_at > @PAYRF_data_end
)
BEGIN

    ;THROW 50696,
        N'payment.PaymentRefund source data contains a refund after the fixed sample-data cutoff.',
        1;

END;


IF EXISTS
(
    SELECT
        S.PAYRF_PAY_id,
        S.PAYRF_event_number
    FROM @PAYRF_source AS S

    GROUP BY
        S.PAYRF_PAY_id,
        S.PAYRF_event_number

    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50697,
        N'payment.PaymentRefund source data contains duplicate refund events.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAYRF_source AS S

    LEFT JOIN payment.Payment AS P
        ON P.PAY_id = S.PAYRF_PAY_id

    WHERE P.PAY_id IS NULL
)
BEGIN

    ;THROW 50698,
        N'payment.PaymentRefund source data references a Payment that does not exist.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAYRF_source AS S

    LEFT JOIN payment.PaymentRefundReason AS R
        ON R.PAYRR_id = S.PAYRF_PAYRR_id

    WHERE R.PAYRR_id IS NULL
)
BEGIN

    ;THROW 50699,
        N'payment.PaymentRefund source data references a PaymentRefundReason that does not exist.',
        1;

END;


/*==============================================================================
    PARTIAL REFUND RECONCILIATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM payment.Payment AS P

    INNER JOIN
    (
        SELECT
            S.PAYRF_PAY_id,
            SUM(S.PAYRF_amount) AS RefundedAmount

        FROM @PAYRF_source AS S

        GROUP BY
            S.PAYRF_PAY_id
    ) AS R
        ON R.PAYRF_PAY_id = P.PAY_id

    WHERE P.PAY_PAYST_id =
            @PAYRF_PAYST_partially_refunded_id

      AND
      (
            R.RefundedAmount <= 0.00
            OR R.RefundedAmount >= P.PAY_amount
      )
)
BEGIN

    ;THROW 50700,
        N'payment.PaymentRefund PARTIALLY_REFUNDED totals are inconsistent with Payment amount.',
        1;

END;


/*==============================================================================
    FULL REFUND RECONCILIATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM payment.Payment AS P

    LEFT JOIN
    (
        SELECT
            S.PAYRF_PAY_id,
            SUM(S.PAYRF_amount) AS RefundedAmount

        FROM @PAYRF_source AS S

        GROUP BY
            S.PAYRF_PAY_id
    ) AS R
        ON R.PAYRF_PAY_id = P.PAY_id

    WHERE P.PAY_PAYST_id =
            @PAYRF_PAYST_refunded_id

      AND COALESCE(R.RefundedAmount, 0.00)
            <> P.PAY_amount
)
BEGIN

    ;THROW 50701,
        N'payment.PaymentRefund REFUNDED totals do not reconcile exactly with Payment amount.',
        1;

END;


/*==============================================================================
    CUMULATIVE REFUND LIMIT
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM payment.Payment AS P

    INNER JOIN
    (
        SELECT
            S.PAYRF_PAY_id,
            SUM(S.PAYRF_amount) AS RefundedAmount

        FROM @PAYRF_source AS S

        GROUP BY
            S.PAYRF_PAY_id
    ) AS R
        ON R.PAYRF_PAY_id = P.PAY_id

    WHERE R.RefundedAmount > P.PAY_amount
)
BEGIN

    ;THROW 50702,
        N'payment.PaymentRefund source data exceeds the original Payment amount.',
        1;

END;


/*==============================================================================
    STATUS COVERAGE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM payment.Payment AS P

    WHERE P.PAY_PAYST_id IN
          (
              @PAYRF_PAYST_partially_refunded_id,
              @PAYRF_PAYST_refunded_id
          )

      AND NOT EXISTS
          (
              SELECT 1
              FROM @PAYRF_source AS S
              WHERE S.PAYRF_PAY_id = P.PAY_id
          )
)
BEGIN

    ;THROW 50703,
        N'payment.PaymentRefund source data does not cover every refundable Payment.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

INSERT INTO payment.PaymentRefund
(
    PAYRF_PAY_id,
    PAYRF_PAYRR_id,
    PAYRF_amount,
    PAYRF_refunded_at,
    PAYRF_created_at,
    PAYRF_updated_at
)
SELECT
    S.PAYRF_PAY_id,
    S.PAYRF_PAYRR_id,
    S.PAYRF_amount,
    S.PAYRF_refunded_at,
    S.PAYRF_created_at,
    S.PAYRF_updated_at

FROM @PAYRF_source AS S

WHERE NOT EXISTS
(
    SELECT 1
    FROM payment.PaymentRefund AS R

    WHERE R.PAYRF_PAY_id = S.PAYRF_PAY_id
      AND R.PAYRF_PAYRR_id = S.PAYRF_PAYRR_id
      AND R.PAYRF_amount = S.PAYRF_amount
      AND R.PAYRF_refunded_at = S.PAYRF_refunded_at
);


SET @PAYRF_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @PAYRF_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT
      (
          nvarchar(20),
          @PAYRF_rows_processed - @PAYRF_rows_added
      );

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @PAYRF_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';