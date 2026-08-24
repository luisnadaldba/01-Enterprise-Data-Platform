/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : payment.Payment
    Type        : Payment / Sample Data
    Prefix      : PAY
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the financial payment history associated with the AtlasCommerce
    sample transactions.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Generates deterministic Payment records from existing Transactions.
    - Preserves the complete Transaction key using TRN_id + transaction_at.
    - Generates one principal payment operation for every Transaction.
    - Generates a declined payment attempt before the successful payment for
      a deterministic subset of Transactions.
    - Generates split payments for a small deterministic subset of STORE
      Transactions.
    - Split payments use two different payment methods and reconcile exactly
      to the commercial amount due.
    - Payment amount represents the amount associated with each individual
      financial operation.
    - CREDIT_CARD payments may contain installment information.
    - Installment count remains NULL when installments do not apply.
    - Approved, cancelled and attempted timestamps preserve their distinct
      financial-event meanings.
    - A small subset of successful historical payments is classified as
      PARTIALLY_REFUNDED or REFUNDED for subsequent PaymentRefund deployment.
    - Existing Payment records are preserved without modification.
    - No automatic UPDATE is performed.
    - Source data is validated before deployment.
    - Data is deployed using generated set-based operations.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● payment.Payment';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @PAY_rows_added     int;
DECLARE @PAY_rows_processed int;

DECLARE @PAY_data_end datetime2(0) = '2026-08-24T12:45:00';

DECLARE @PAY_PAYME_pix_id         tinyint;
DECLARE @PAY_PAYME_credit_card_id tinyint;
DECLARE @PAY_PAYME_debit_card_id  tinyint;
DECLARE @PAY_PAYME_cash_id        tinyint;

DECLARE @PAY_PAYST_pending_id            tinyint;
DECLARE @PAY_PAYST_approved_id           tinyint;
DECLARE @PAY_PAYST_declined_id           tinyint;
DECLARE @PAY_PAYST_cancelled_id          tinyint;
DECLARE @PAY_PAYST_partially_refunded_id tinyint;
DECLARE @PAY_PAYST_refunded_id           tinyint;

DECLARE @PAY_TRNCH_store_id tinyint;


/*==============================================================================
    DEPENDENCY RESOLUTION
==============================================================================*/

SELECT
    @PAY_PAYME_pix_id = PAYME_id
FROM payment.PaymentMethod
WHERE PAYME_name = N'PIX';


SELECT
    @PAY_PAYME_credit_card_id = PAYME_id
FROM payment.PaymentMethod
WHERE PAYME_name = N'CREDIT_CARD';


SELECT
    @PAY_PAYME_debit_card_id = PAYME_id
FROM payment.PaymentMethod
WHERE PAYME_name = N'DEBIT_CARD';


SELECT
    @PAY_PAYME_cash_id = PAYME_id
FROM payment.PaymentMethod
WHERE PAYME_name = N'CASH';


IF @PAY_PAYME_pix_id IS NULL
OR @PAY_PAYME_credit_card_id IS NULL
OR @PAY_PAYME_debit_card_id IS NULL
OR @PAY_PAYME_cash_id IS NULL
BEGIN

    ;THROW 50670,
        N'payment.Payment data deployment requires all controlled PaymentMethod records.',
        1;

END;


SELECT
    @PAY_PAYST_pending_id = PAYST_id
FROM payment.PaymentStatus
WHERE PAYST_name = N'PENDING';


SELECT
    @PAY_PAYST_approved_id = PAYST_id
FROM payment.PaymentStatus
WHERE PAYST_name = N'APPROVED';


SELECT
    @PAY_PAYST_declined_id = PAYST_id
FROM payment.PaymentStatus
WHERE PAYST_name = N'DECLINED';


SELECT
    @PAY_PAYST_cancelled_id = PAYST_id
FROM payment.PaymentStatus
WHERE PAYST_name = N'CANCELLED';


SELECT
    @PAY_PAYST_partially_refunded_id = PAYST_id
FROM payment.PaymentStatus
WHERE PAYST_name = N'PARTIALLY_REFUNDED';


SELECT
    @PAY_PAYST_refunded_id = PAYST_id
FROM payment.PaymentStatus
WHERE PAYST_name = N'REFUNDED';


IF @PAY_PAYST_pending_id IS NULL
OR @PAY_PAYST_approved_id IS NULL
OR @PAY_PAYST_declined_id IS NULL
OR @PAY_PAYST_cancelled_id IS NULL
OR @PAY_PAYST_partially_refunded_id IS NULL
OR @PAY_PAYST_refunded_id IS NULL
BEGIN

    ;THROW 50671,
        N'payment.Payment data deployment requires all controlled PaymentStatus records.',
        1;

END;


SELECT
    @PAY_TRNCH_store_id = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = N'STORE';


IF @PAY_TRNCH_store_id IS NULL
BEGIN

    ;THROW 50672,
        N'payment.Payment data deployment requires TransactionChannel STORE.',
        1;

END;


/*==============================================================================
    PAYMENT BASIS
==============================================================================*/

DECLARE @PAY_basis TABLE
(
    PAY_TRN_id             bigint        NOT NULL,
    PAY_transaction_at     datetime2(0)  NOT NULL,
    PAY_TRNCH_id           tinyint       NOT NULL,
    PAY_TRNST_code         varchar(30)   NOT NULL,
    PAY_amount_due         decimal(19,2) NOT NULL,
    PAY_principal_method_id tinyint      NOT NULL,
    PAY_is_split_payment   bit           NOT NULL,
    PAY_has_declined_attempt bit         NOT NULL,
    PAY_refund_bucket      int           NOT NULL,
    PAY_installment_bucket int           NOT NULL,

    PRIMARY KEY
    (
        PAY_TRN_id,
        PAY_transaction_at
    )
);


INSERT INTO @PAY_basis
(
    PAY_TRN_id,
    PAY_transaction_at,
    PAY_TRNCH_id,
    PAY_TRNST_code,
    PAY_amount_due,
    PAY_principal_method_id,
    PAY_is_split_payment,
    PAY_has_declined_attempt,
    PAY_refund_bucket,
    PAY_installment_bucket
)
SELECT
    T.TRN_id,
    T.TRN_transaction_at,
    T.TRN_TRNCH_id,
    TS.TRNST_code,

    CONVERT
    (
        decimal(19,2),
        T.TRN_gross_amount - T.TRN_discount_amount
    ),

    CASE
        WHEN X.MethodBucket < 35
            THEN @PAY_PAYME_pix_id

        WHEN X.MethodBucket < 65
            THEN @PAY_PAYME_credit_card_id

        WHEN X.MethodBucket < 85
            THEN @PAY_PAYME_debit_card_id

        ELSE @PAY_PAYME_cash_id
    END,

    CASE
        WHEN T.TRN_TRNCH_id = @PAY_TRNCH_store_id
         AND X.SplitBucket < 6
         AND TS.TRNST_code IN
             (
                 'CONFIRMED',
                 'COMPLETED'
             )
            THEN 1
        ELSE 0
    END,

    CASE
        WHEN X.AttemptBucket < 8
         AND TS.TRNST_code IN
             (
                 'CONFIRMED',
                 'COMPLETED'
             )
            THEN 1
        ELSE 0
    END,

    X.RefundBucket,
    X.InstallmentBucket

FROM sales.[Transaction] AS T

INNER JOIN sales.TransactionStatus AS TS
    ON TS.TRNST_id = T.TRN_TRNST_id

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
                    T.TRN_id,
                    T.TRN_transaction_at,
                    101
                )
            )
        ) % 100 AS MethodBucket,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    T.TRN_id,
                    T.TRN_transaction_at,
                    211
                )
            )
        ) % 100 AS AttemptBucket,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    T.TRN_id,
                    T.TRN_transaction_at,
                    307
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
                    T.TRN_id,
                    T.TRN_transaction_at,
                    401
                )
            )
        ) % 100 AS RefundBucket,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    T.TRN_id,
                    T.TRN_transaction_at,
                    503
                )
            )
        ) % 4 AS InstallmentBucket
) AS X;


/*==============================================================================
    SOURCE DATA
==============================================================================*/

DECLARE @PAY_source TABLE
(
    PAY_TRN_id            bigint        NOT NULL,
    PAY_transaction_at    datetime2(0)  NOT NULL,

    PAY_PAYME_id          tinyint       NOT NULL,
    PAY_PAYST_id          tinyint       NOT NULL,

    PAY_amount            decimal(19,2) NOT NULL,
    PAY_installment_count tinyint       NULL,

    PAY_attempted_at      datetime2(0)  NOT NULL,
    PAY_approved_at       datetime2(0)  NULL,
    PAY_cancelled_at      datetime2(0)  NULL,

    PAY_created_at        datetime2(0)  NOT NULL,
    PAY_updated_at        datetime2(0)  NOT NULL
);


/*==============================================================================
    DECLINED ATTEMPTS
==============================================================================*/

INSERT INTO @PAY_source
(
    PAY_TRN_id,
    PAY_transaction_at,
    PAY_PAYME_id,
    PAY_PAYST_id,
    PAY_amount,
    PAY_installment_count,
    PAY_attempted_at,
    PAY_approved_at,
    PAY_cancelled_at,
    PAY_created_at,
    PAY_updated_at
)
SELECT
    B.PAY_TRN_id,
    B.PAY_transaction_at,
    @PAY_PAYME_credit_card_id,
    @PAY_PAYST_declined_id,
    B.PAY_amount_due,

    CASE
        WHEN B.PAY_amount_due >= 100.00
            THEN CONVERT
                 (
                     tinyint,
                     2 + B.PAY_installment_bucket
                 )
        ELSE NULL
    END,

    DATEADD
    (
        SECOND,
        30,
        B.PAY_transaction_at
    ),

    NULL,
    NULL,

    DATEADD
    (
        SECOND,
        30,
        B.PAY_transaction_at
    ),

    DATEADD
    (
        SECOND,
        30,
        B.PAY_transaction_at
    )

FROM @PAY_basis AS B

WHERE B.PAY_has_declined_attempt = 1;


/*==============================================================================
    PRINCIPAL PAYMENTS - NON-SPLIT
==============================================================================*/

INSERT INTO @PAY_source
(
    PAY_TRN_id,
    PAY_transaction_at,
    PAY_PAYME_id,
    PAY_PAYST_id,
    PAY_amount,
    PAY_installment_count,
    PAY_attempted_at,
    PAY_approved_at,
    PAY_cancelled_at,
    PAY_created_at,
    PAY_updated_at
)
SELECT
    B.PAY_TRN_id,
    B.PAY_transaction_at,
    B.PAY_principal_method_id,

    CASE
        WHEN B.PAY_TRNST_code = 'PENDING'
            THEN @PAY_PAYST_pending_id

        WHEN B.PAY_TRNST_code = 'CANCELLED'
            THEN @PAY_PAYST_cancelled_id

        WHEN B.PAY_TRNST_code = 'FAILED'
            THEN @PAY_PAYST_declined_id

        WHEN B.PAY_TRNST_code IN
             (
                 'CONFIRMED',
                 'COMPLETED'
             )
         AND B.PAY_transaction_at <= DATEADD(DAY, -9, @PAY_data_end)
         AND B.PAY_refund_bucket < 2
            THEN @PAY_PAYST_refunded_id

        WHEN B.PAY_TRNST_code IN
             (
                 'CONFIRMED',
                 'COMPLETED'
             )
         AND B.PAY_transaction_at <= DATEADD(DAY, -9, @PAY_data_end)
         AND B.PAY_refund_bucket < 5
            THEN @PAY_PAYST_partially_refunded_id

        ELSE @PAY_PAYST_approved_id
    END,

    B.PAY_amount_due,

    CASE
        WHEN B.PAY_principal_method_id = @PAY_PAYME_credit_card_id
         AND B.PAY_amount_due >= 100.00
            THEN CONVERT
                 (
                     tinyint,
                     2 + B.PAY_installment_bucket
                 )
        ELSE NULL
    END,

    DATEADD
    (
        SECOND,
        CASE
            WHEN B.PAY_has_declined_attempt = 1
                THEN 120
            ELSE 30
        END,
        B.PAY_transaction_at
    ),

    CASE
        WHEN B.PAY_TRNST_code IN
             (
                 'CONFIRMED',
                 'COMPLETED'
             )
            THEN DATEADD
                 (
                     SECOND,
                     CASE
                         WHEN B.PAY_has_declined_attempt = 1
                             THEN 150
                         ELSE 60
                     END,
                     B.PAY_transaction_at
                 )
        ELSE NULL
    END,

    CASE
        WHEN B.PAY_TRNST_code = 'CANCELLED'
            THEN DATEADD
                 (
                     SECOND,
                     90,
                     B.PAY_transaction_at
                 )
        ELSE NULL
    END,

    DATEADD
    (
        SECOND,
        CASE
            WHEN B.PAY_has_declined_attempt = 1
                THEN 120
            ELSE 30
        END,
        B.PAY_transaction_at
    ),

    CASE
        WHEN B.PAY_TRNST_code IN
             (
                 'CONFIRMED',
                 'COMPLETED'
             )
            THEN DATEADD
                 (
                     SECOND,
                     CASE
                         WHEN B.PAY_has_declined_attempt = 1
                             THEN 150
                         ELSE 60
                     END,
                     B.PAY_transaction_at
                 )

        WHEN B.PAY_TRNST_code = 'CANCELLED'
            THEN DATEADD
                 (
                     SECOND,
                     90,
                     B.PAY_transaction_at
                 )

        ELSE DATEADD
             (
                 SECOND,
                 CASE
                     WHEN B.PAY_has_declined_attempt = 1
                         THEN 120
                     ELSE 30
                 END,
                 B.PAY_transaction_at
             )
    END

FROM @PAY_basis AS B

WHERE B.PAY_is_split_payment = 0;


/*==============================================================================
    SPLIT PAYMENTS - CASH PORTION
==============================================================================*/

INSERT INTO @PAY_source
(
    PAY_TRN_id,
    PAY_transaction_at,
    PAY_PAYME_id,
    PAY_PAYST_id,
    PAY_amount,
    PAY_installment_count,
    PAY_attempted_at,
    PAY_approved_at,
    PAY_cancelled_at,
    PAY_created_at,
    PAY_updated_at
)
SELECT
    B.PAY_TRN_id,
    B.PAY_transaction_at,
    @PAY_PAYME_cash_id,
    @PAY_PAYST_approved_id,

    CONVERT
    (
        decimal(19,2),
        FLOOR(B.PAY_amount_due * 40.00) / 100.00
    ),

    NULL,

    DATEADD
    (
        SECOND,
        CASE
            WHEN B.PAY_has_declined_attempt = 1
                THEN 120
            ELSE 30
        END,
        B.PAY_transaction_at
    ),

    DATEADD
    (
        SECOND,
        CASE
            WHEN B.PAY_has_declined_attempt = 1
                THEN 150
            ELSE 60
        END,
        B.PAY_transaction_at
    ),

    NULL,

    DATEADD
    (
        SECOND,
        CASE
            WHEN B.PAY_has_declined_attempt = 1
                THEN 120
            ELSE 30
        END,
        B.PAY_transaction_at
    ),

    DATEADD
    (
        SECOND,
        CASE
            WHEN B.PAY_has_declined_attempt = 1
                THEN 150
            ELSE 60
        END,
        B.PAY_transaction_at
    )

FROM @PAY_basis AS B

WHERE B.PAY_is_split_payment = 1;


/*==============================================================================
    SPLIT PAYMENTS - CREDIT CARD PORTION
==============================================================================*/

INSERT INTO @PAY_source
(
    PAY_TRN_id,
    PAY_transaction_at,
    PAY_PAYME_id,
    PAY_PAYST_id,
    PAY_amount,
    PAY_installment_count,
    PAY_attempted_at,
    PAY_approved_at,
    PAY_cancelled_at,
    PAY_created_at,
    PAY_updated_at
)
SELECT
    B.PAY_TRN_id,
    B.PAY_transaction_at,
    @PAY_PAYME_credit_card_id,
    @PAY_PAYST_approved_id,

    B.PAY_amount_due
        -
        CONVERT
        (
            decimal(19,2),
            FLOOR(B.PAY_amount_due * 40.00) / 100.00
        ),

    CASE
        WHEN
            B.PAY_amount_due
                -
                CONVERT
                (
                    decimal(19,2),
                    FLOOR(B.PAY_amount_due * 40.00) / 100.00
                ) >= 100.00
            THEN CONVERT
                 (
                     tinyint,
                     2 + B.PAY_installment_bucket
                 )
        ELSE NULL
    END,

    DATEADD
    (
        SECOND,
        CASE
            WHEN B.PAY_has_declined_attempt = 1
                THEN 180
            ELSE 90
        END,
        B.PAY_transaction_at
    ),

    DATEADD
    (
        SECOND,
        CASE
            WHEN B.PAY_has_declined_attempt = 1
                THEN 210
            ELSE 120
        END,
        B.PAY_transaction_at
    ),

    NULL,

    DATEADD
    (
        SECOND,
        CASE
            WHEN B.PAY_has_declined_attempt = 1
                THEN 180
            ELSE 90
        END,
        B.PAY_transaction_at
    ),

    DATEADD
    (
        SECOND,
        CASE
            WHEN B.PAY_has_declined_attempt = 1
                THEN 210
            ELSE 120
        END,
        B.PAY_transaction_at
    )

FROM @PAY_basis AS B

WHERE B.PAY_is_split_payment = 1;


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

SELECT
    @PAY_rows_processed = COUNT(*)
FROM @PAY_source;


IF @PAY_rows_processed = 0
BEGIN

    ;THROW 50673,
        N'payment.Payment source data did not generate any rows.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAY_source AS S
    WHERE S.PAY_amount <= 0.00
)
BEGIN

    ;THROW 50674,
        N'payment.Payment source data contains an invalid payment amount.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAY_source AS S
    WHERE S.PAY_installment_count IS NOT NULL
      AND S.PAY_installment_count <= 1
)
BEGIN

    ;THROW 50675,
        N'payment.Payment source data contains an invalid installment count.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAY_source AS S
    WHERE S.PAY_installment_count IS NOT NULL
      AND S.PAY_PAYME_id <> @PAY_PAYME_credit_card_id
)
BEGIN

    ;THROW 50676,
        N'payment.Payment source data contains installment information for a non-credit-card payment.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAY_source AS S
    WHERE S.PAY_attempted_at < S.PAY_transaction_at
)
BEGIN

    ;THROW 50677,
        N'payment.Payment source data contains a payment attempt before its Transaction.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAY_source AS S
    WHERE S.PAY_approved_at IS NOT NULL
      AND S.PAY_approved_at < S.PAY_attempted_at
)
BEGIN

    ;THROW 50678,
        N'payment.Payment source data contains an approval before its payment attempt.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAY_source AS S
    WHERE S.PAY_cancelled_at IS NOT NULL
      AND S.PAY_cancelled_at < S.PAY_attempted_at
)
BEGIN

    ;THROW 50679,
        N'payment.Payment source data contains a cancellation before its payment attempt.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAY_source AS S
    WHERE S.PAY_PAYST_id IN
          (
              @PAY_PAYST_approved_id,
              @PAY_PAYST_partially_refunded_id,
              @PAY_PAYST_refunded_id
          )
      AND S.PAY_approved_at IS NULL
)
BEGIN

    ;THROW 50680,
        N'payment.Payment source data contains an approved financial state without approved_at.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAY_source AS S
    WHERE S.PAY_PAYST_id = @PAY_PAYST_cancelled_id
      AND S.PAY_cancelled_at IS NULL
)
BEGIN

    ;THROW 50681,
        N'payment.Payment source data contains a CANCELLED payment without cancelled_at.',
        1;

END;


/*------------------------------------------------------------------------------
    SAMPLE DATA CUTOFF
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @PAY_source AS S
    WHERE S.PAY_attempted_at > @PAY_data_end
       OR S.PAY_approved_at > @PAY_data_end
       OR S.PAY_cancelled_at > @PAY_data_end
)
BEGIN

    ;THROW 50682,
        N'payment.Payment source data contains a financial event after the fixed sample-data cutoff.',
        1;

END;


IF EXISTS
(
    SELECT
        S.PAY_TRN_id,
        S.PAY_transaction_at,
        S.PAY_PAYME_id,
        S.PAY_attempted_at
    FROM @PAY_source AS S
    GROUP BY
        S.PAY_TRN_id,
        S.PAY_transaction_at,
        S.PAY_PAYME_id,
        S.PAY_attempted_at
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50683,
        N'payment.Payment source data contains duplicate payment operations.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PAY_source AS S

    LEFT JOIN sales.[Transaction] AS T
        ON  T.TRN_id = S.PAY_TRN_id
        AND T.TRN_transaction_at = S.PAY_transaction_at

    WHERE T.TRN_id IS NULL
)
BEGIN

    ;THROW 50684,
        N'payment.Payment source data references a Transaction that does not exist.',
        1;

END;


/*==============================================================================
    FINANCIAL RECONCILIATION
==============================================================================*/

IF EXISTS
(
    SELECT 1

    FROM sales.[Transaction] AS T

    INNER JOIN sales.TransactionStatus AS TS
        ON TS.TRNST_id = T.TRN_TRNST_id

    LEFT JOIN
    (
        SELECT
            S.PAY_TRN_id,
            S.PAY_transaction_at,

            SUM
            (
                CASE
                    WHEN S.PAY_PAYST_id IN
                         (
                             @PAY_PAYST_approved_id,
                             @PAY_PAYST_partially_refunded_id,
                             @PAY_PAYST_refunded_id
                         )
                        THEN S.PAY_amount
                    ELSE 0.00
                END
            ) AS SuccessfulAmount

        FROM @PAY_source AS S

        GROUP BY
            S.PAY_TRN_id,
            S.PAY_transaction_at
    ) AS P
        ON  P.PAY_TRN_id = T.TRN_id
        AND P.PAY_transaction_at = T.TRN_transaction_at

    WHERE TS.TRNST_code IN
          (
              'CONFIRMED',
              'COMPLETED'
          )

      AND COALESCE(P.SuccessfulAmount, 0.00)
            <>
            CONVERT
            (
                decimal(19,2),
                T.TRN_gross_amount
                    - T.TRN_discount_amount
            )
)
BEGIN

    ;THROW 50685,
        N'payment.Payment successful amounts do not reconcile with the commercial amount due for CONFIRMED or COMPLETED Transactions.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

INSERT INTO payment.Payment
(
    PAY_TRN_id,
    PAY_transaction_at,
    PAY_PAYME_id,
    PAY_PAYST_id,
    PAY_amount,
    PAY_installment_count,
    PAY_attempted_at,
    PAY_approved_at,
    PAY_cancelled_at,
    PAY_created_at,
    PAY_updated_at
)
SELECT
    S.PAY_TRN_id,
    S.PAY_transaction_at,
    S.PAY_PAYME_id,
    S.PAY_PAYST_id,
    S.PAY_amount,
    S.PAY_installment_count,
    S.PAY_attempted_at,
    S.PAY_approved_at,
    S.PAY_cancelled_at,
    S.PAY_created_at,
    S.PAY_updated_at

FROM @PAY_source AS S

WHERE NOT EXISTS
(
    SELECT 1
    FROM payment.Payment AS P

    WHERE P.PAY_TRN_id = S.PAY_TRN_id
      AND P.PAY_transaction_at = S.PAY_transaction_at
      AND P.PAY_PAYME_id = S.PAY_PAYME_id
      AND P.PAY_attempted_at = S.PAY_attempted_at
      AND P.PAY_amount = S.PAY_amount
);


SET @PAY_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @PAY_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT
      (
          nvarchar(20),
          @PAY_rows_processed - @PAY_rows_added
      );

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @PAY_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';