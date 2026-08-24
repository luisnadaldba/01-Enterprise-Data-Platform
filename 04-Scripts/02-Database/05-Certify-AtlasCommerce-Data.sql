/*==============================================================================
    ATLAS COMMERCE - DATA CERTIFICATION
==============================================================================

    Script   : 05-Certify-AtlasCommerce-Data.sql
    Version  : 1.0.0
    Database : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Performs the final certification of the AtlasCommerce sample-data state
    after data deployment.

    Certification Scope
    --------------------------------------------------------------------------
    - Referential integrity
    - Sales integrity
    - Inventory integrity
    - Payment integrity
    - Shipping integrity
    - Temporal integrity
    - Cross-domain reconciliation

    Certification Behavior
    --------------------------------------------------------------------------
    - Does not modify data.
    - Does not repair inconsistent data.
    - Stops immediately when a certification rule fails.
    - Reports the failing rule through THROW.
    - Completes with PASS only when all certification rules succeed.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @CertificationStartedAt datetime2(3) = SYSDATETIME();
DECLARE @CertificationEndedAt   datetime2(3);
DECLARE @ElapsedMilliseconds     bigint;

DECLARE @SampleDataCutoff datetime2(0) = '2026-08-24T12:45:00';


PRINT N'';
PRINT N'==============================================================================';
PRINT N' ATLAS COMMERCE - DATA CERTIFICATION';
PRINT N'==============================================================================';
PRINT N' Script   : 05-Certify-AtlasCommerce-Data.sql';
PRINT N' Version  : 1.0.0';
PRINT N' Database : AtlasCommerce';
PRINT N' Started  : '
    + CONVERT(nvarchar(23), @CertificationStartedAt, 121);
PRINT N'==============================================================================';
PRINT N'';


/*==============================================================================
    DATABASE CONTEXT
==============================================================================*/

IF DB_NAME() <> N'AtlasCommerce'
BEGIN

    ;THROW 51500,
        N'Incorrect database context. Expected database: AtlasCommerce.',
        1;

END;


/*==============================================================================
    01 - REFERENTIAL INTEGRITY
==============================================================================*/

PRINT N'    ● REFERENTIAL INTEGRITY';
PRINT N'';


IF EXISTS
(
    SELECT 1
    FROM sys.foreign_keys AS FK
    WHERE FK.is_ms_shipped = 0
      AND
      (
          FK.is_disabled = 1
          OR FK.is_not_trusted = 1
      )
)
BEGIN

    ;THROW 51501,
        N'Data certification failed: one or more FOREIGN KEY constraints are disabled or not trusted.',
        1;

END;


PRINT N'        [PASS] Foreign keys enabled and trusted';


/*==============================================================================
    02 - SALES
==============================================================================*/

PRINT N'';
PRINT N'    ● SALES';
PRINT N'';


/*------------------------------------------------------------------------------
    EVERY TRANSACTION REQUIRES AT LEAST ONE ITEM
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM sales.[Transaction] AS T

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM sales.TransactionItem AS I
        WHERE I.TRNIT_TRN_id = T.TRN_id
          AND I.TRNIT_transaction_at = T.TRN_transaction_at
    )
)
BEGIN

    ;THROW 51502,
        N'Data certification failed: one or more Transactions do not contain TransactionItems.',
        1;

END;


/*------------------------------------------------------------------------------
    TRANSACTION TOTALS
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT
        T.TRN_id,
        T.TRN_transaction_at

    FROM sales.[Transaction] AS T

    INNER JOIN sales.TransactionItem AS I
        ON  I.TRNIT_TRN_id = T.TRN_id
        AND I.TRNIT_transaction_at = T.TRN_transaction_at

    GROUP BY
        T.TRN_id,
        T.TRN_transaction_at,
        T.TRN_gross_amount,
        T.TRN_discount_amount

    HAVING
        T.TRN_gross_amount
        <>
        SUM
        (
            CONVERT
            (
                decimal(19,2),
                I.TRNIT_quantity * I.TRNIT_unit_price
            )
        )

        OR

        T.TRN_discount_amount
        <>
        SUM
        (
            CONVERT
            (
                decimal(19,2),
                I.TRNIT_quantity * I.TRNIT_unit_discount
            )
        )
)
BEGIN

    ;THROW 51503,
        N'Data certification failed: Transaction monetary values do not reconcile with TransactionItem.',
        1;

END;


/*------------------------------------------------------------------------------
    ONLINE CUSTOMER
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM sales.[Transaction] AS T

    INNER JOIN sales.TransactionChannel AS C
        ON C.TRNCH_id = T.TRN_TRNCH_id

    WHERE C.TRNCH_code = 'ONLINE'
      AND T.TRN_CST_id IS NULL
)
BEGIN

    ;THROW 51504,
        N'Data certification failed: an ONLINE Transaction does not have an identified Customer.',
        1;

END;


/*------------------------------------------------------------------------------
    SAMPLE-DATA CUTOFF
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM sales.[Transaction] AS T
    WHERE T.TRN_transaction_at > @SampleDataCutoff
)
BEGIN

    ;THROW 51505,
        N'Data certification failed: a Transaction exists after the fixed sample-data cutoff.',
        1;

END;


PRINT N'        [PASS] Transaction / TransactionItem integrity';
PRINT N'        [PASS] Transaction monetary reconciliation';
PRINT N'        [PASS] ONLINE customer rule';
PRINT N'        [PASS] Transaction temporal boundary';


/*==============================================================================
    03 - INVENTORY
==============================================================================*/

PRINT N'';
PRINT N'    ● INVENTORY';
PRINT N'';


/*------------------------------------------------------------------------------
    RESERVED QUANTITY CANNOT EXCEED ON-HAND
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM inventory.Inventory AS I
    WHERE I.INV_quantity_reserved > I.INV_quantity_on_hand
)
BEGIN

    ;THROW 51506,
        N'Data certification failed: reserved inventory exceeds on-hand inventory.',
        1;

END;


/*------------------------------------------------------------------------------
    ACTIVE RESERVATIONS MUST RECONCILE WITH INVENTORY
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM inventory.Inventory AS I

    LEFT JOIN
    (
        SELECT
            R.INVRE_PRDVA_id,
            SUM(R.INVRE_quantity) AS ActiveReservedQuantity

        FROM inventory.InventoryReservation AS R

        INNER JOIN inventory.InventoryReservationStatus AS S
            ON S.INVRS_id = R.INVRE_INVRS_id

        WHERE S.INVRS_name = 'ACTIVE'

        GROUP BY
            R.INVRE_PRDVA_id

    ) AS R
        ON R.INVRE_PRDVA_id = I.INV_PRDVA_id

    WHERE I.INV_quantity_reserved
          <>
          COALESCE(R.ActiveReservedQuantity, 0)
)
BEGIN

    ;THROW 51507,
        N'Data certification failed: ACTIVE reservation quantities do not reconcile with Inventory.',
        1;

END;


/*------------------------------------------------------------------------------
    MOVEMENTS MUST RECONCILE WITH ON-HAND
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM inventory.Inventory AS I

    LEFT JOIN
    (
        SELECT
            M.INVMV_PRDVA_id,
            SUM(M.INVMV_quantity) AS MovementBalance

        FROM inventory.InventoryMovement AS M

        GROUP BY
            M.INVMV_PRDVA_id

    ) AS M
        ON M.INVMV_PRDVA_id = I.INV_PRDVA_id

    WHERE I.INV_quantity_on_hand
          <>
          COALESCE(M.MovementBalance, 0)
)
BEGIN

    ;THROW 51508,
        N'Data certification failed: InventoryMovement balance does not reconcile with Inventory.',
        1;

END;


/*------------------------------------------------------------------------------
    RESERVATION PRODUCT VARIANT MUST MATCH TRANSACTION ITEM
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM inventory.InventoryReservation AS R

    INNER JOIN sales.TransactionItem AS I
        ON  I.TRNIT_id = R.INVRE_TRNIT_id
        AND I.TRNIT_transaction_at = R.INVRE_TRNIT_transaction_at

    WHERE R.INVRE_PRDVA_id <> I.TRNIT_PRDVA_id
)
BEGIN

    ;THROW 51509,
        N'Data certification failed: InventoryReservation ProductVariant does not match TransactionItem.',
        1;

END;


/*------------------------------------------------------------------------------
    MOVEMENT PRODUCT VARIANT MUST MATCH TRANSACTION ITEM
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM inventory.InventoryMovement AS M

    INNER JOIN sales.TransactionItem AS I
        ON  I.TRNIT_id = M.INVMV_TRNIT_id
        AND I.TRNIT_transaction_at = M.INVMV_TRNIT_transaction_at

    WHERE M.INVMV_PRDVA_id <> I.TRNIT_PRDVA_id
)
BEGIN

    ;THROW 51510,
        N'Data certification failed: InventoryMovement ProductVariant does not match TransactionItem.',
        1;

END;


/*------------------------------------------------------------------------------
    INVENTORY TEMPORAL BOUNDARY
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM inventory.InventoryReservation AS R

    WHERE R.INVRE_reserved_at > @SampleDataCutoff
       OR R.INVRE_closed_at > @SampleDataCutoff
)
BEGIN

    ;THROW 51511,
        N'Data certification failed: InventoryReservation event exists after the fixed sample-data cutoff.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM inventory.InventoryMovement AS M
    WHERE M.INVMV_movement_at > @SampleDataCutoff
)
BEGIN

    ;THROW 51512,
        N'Data certification failed: InventoryMovement exists after the fixed sample-data cutoff.',
        1;

END;


PRINT N'        [PASS] Inventory reservation reconciliation';
PRINT N'        [PASS] Inventory movement reconciliation';
PRINT N'        [PASS] Inventory ProductVariant consistency';
PRINT N'        [PASS] Inventory temporal boundary';


/*==============================================================================
    04 - PAYMENT
==============================================================================*/

PRINT N'';
PRINT N'    ● PAYMENT';
PRINT N'';


/*------------------------------------------------------------------------------
    SUCCESSFUL PAYMENTS MUST RECONCILE WITH TRANSACTION
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT
        T.TRN_id,
        T.TRN_transaction_at

    FROM sales.[Transaction] AS T

    INNER JOIN sales.TransactionStatus AS TS
        ON TS.TRNST_id = T.TRN_TRNST_id

    LEFT JOIN payment.Payment AS P
        ON  P.PAY_TRN_id = T.TRN_id
        AND P.PAY_transaction_at = T.TRN_transaction_at

    LEFT JOIN payment.PaymentStatus AS PS
        ON PS.PAYST_id = P.PAY_PAYST_id

    WHERE TS.TRNST_code IN
    (
        'CONFIRMED',
        'COMPLETED'
    )

    GROUP BY
        T.TRN_id,
        T.TRN_transaction_at,
        T.TRN_gross_amount,
        T.TRN_discount_amount

    HAVING
        COALESCE
        (
            SUM
            (
                CASE
                    WHEN PS.PAYST_name IN
                    (
                        'APPROVED',
                        'PARTIALLY_REFUNDED',
                        'REFUNDED'
                    )
                        THEN P.PAY_amount
                    ELSE 0.00
                END
            ),
            0.00
        )
        <>
        CONVERT
        (
            decimal(19,2),
            T.TRN_gross_amount
            - T.TRN_discount_amount
        )
)
BEGIN

    ;THROW 51513,
        N'Data certification failed: successful Payment amount does not reconcile with Transaction.',
        1;

END;


/*------------------------------------------------------------------------------
    REFUNDED PAYMENT MUST RECONCILE EXACTLY
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM payment.Payment AS P

    INNER JOIN payment.PaymentStatus AS PS
        ON PS.PAYST_id = P.PAY_PAYST_id

    LEFT JOIN
    (
        SELECT
            R.PAYRF_PAY_id,
            SUM(R.PAYRF_amount) AS RefundedAmount

        FROM payment.PaymentRefund AS R

        GROUP BY
            R.PAYRF_PAY_id

    ) AS R
        ON R.PAYRF_PAY_id = P.PAY_id

    WHERE PS.PAYST_name = 'REFUNDED'
      AND COALESCE(R.RefundedAmount, 0.00) <> P.PAY_amount
)
BEGIN

    ;THROW 51514,
        N'Data certification failed: REFUNDED Payment does not reconcile with PaymentRefund.',
        1;

END;


/*------------------------------------------------------------------------------
    PARTIALLY REFUNDED PAYMENT
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM payment.Payment AS P

    INNER JOIN payment.PaymentStatus AS PS
        ON PS.PAYST_id = P.PAY_PAYST_id

    LEFT JOIN
    (
        SELECT
            R.PAYRF_PAY_id,
            SUM(R.PAYRF_amount) AS RefundedAmount

        FROM payment.PaymentRefund AS R

        GROUP BY
            R.PAYRF_PAY_id

    ) AS R
        ON R.PAYRF_PAY_id = P.PAY_id

    WHERE PS.PAYST_name = 'PARTIALLY_REFUNDED'

      AND
      (
          COALESCE(R.RefundedAmount, 0.00) <= 0.00
          OR COALESCE(R.RefundedAmount, 0.00) >= P.PAY_amount
      )
)
BEGIN

    ;THROW 51515,
        N'Data certification failed: PARTIALLY_REFUNDED Payment does not reconcile with PaymentRefund.',
        1;

END;


/*------------------------------------------------------------------------------
    NON-REFUNDED STATUS MUST NOT HAVE REFUND EVENTS
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM payment.Payment AS P

    INNER JOIN payment.PaymentStatus AS PS
        ON PS.PAYST_id = P.PAY_PAYST_id

    WHERE PS.PAYST_name NOT IN
    (
        'PARTIALLY_REFUNDED',
        'REFUNDED'
    )

    AND EXISTS
    (
        SELECT 1
        FROM payment.PaymentRefund AS R
        WHERE R.PAYRF_PAY_id = P.PAY_id
    )
)
BEGIN

    ;THROW 51516,
        N'Data certification failed: PaymentRefund exists for a Payment without a refunded status.',
        1;

END;


/*------------------------------------------------------------------------------
    REFUND CANNOT EXCEED PAYMENT
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM payment.Payment AS P

    INNER JOIN
    (
        SELECT
            R.PAYRF_PAY_id,
            SUM(R.PAYRF_amount) AS RefundedAmount

        FROM payment.PaymentRefund AS R

        GROUP BY
            R.PAYRF_PAY_id

    ) AS R
        ON R.PAYRF_PAY_id = P.PAY_id

    WHERE R.RefundedAmount > P.PAY_amount
)
BEGIN

    ;THROW 51517,
        N'Data certification failed: cumulative PaymentRefund amount exceeds Payment amount.',
        1;

END;


/*------------------------------------------------------------------------------
    PAYMENT TEMPORAL INTEGRITY
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM payment.Payment AS P

    WHERE P.PAY_attempted_at > @SampleDataCutoff
       OR P.PAY_approved_at > @SampleDataCutoff
       OR P.PAY_cancelled_at > @SampleDataCutoff
)
BEGIN

    ;THROW 51518,
        N'Data certification failed: Payment event exists after the fixed sample-data cutoff.',
        1;

END;


IF EXISTS
(
    SELECT 1

    FROM payment.PaymentRefund AS R

    INNER JOIN payment.Payment AS P
        ON P.PAY_id = R.PAYRF_PAY_id

    WHERE R.PAYRF_refunded_at < P.PAY_attempted_at

       OR
       (
           P.PAY_approved_at IS NULL
           OR R.PAYRF_refunded_at < P.PAY_approved_at
       )

       OR R.PAYRF_refunded_at > @SampleDataCutoff
)
BEGIN

    ;THROW 51519,
        N'Data certification failed: PaymentRefund temporal integrity violation detected.',
        1;

END;


PRINT N'        [PASS] Payment / Transaction reconciliation';
PRINT N'        [PASS] Payment / refund reconciliation';
PRINT N'        [PASS] Payment / refund status consistency';
PRINT N'        [PASS] Payment temporal boundary';


/*==============================================================================
    05 - SHIPPING
==============================================================================*/

PRINT N'';
PRINT N'    ● SHIPPING';
PRINT N'';


/*------------------------------------------------------------------------------
    ONLINE MUST HAVE EXACTLY ONE SHIPMENT
    STORE MUST HAVE ZERO SHIPMENTS
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT
        T.TRN_id,
        T.TRN_transaction_at

    FROM sales.[Transaction] AS T

    INNER JOIN sales.TransactionChannel AS C
        ON C.TRNCH_id = T.TRN_TRNCH_id

    LEFT JOIN shipping.Shipment AS S
        ON  S.SHP_TRN_id = T.TRN_id
        AND S.SHP_transaction_at = T.TRN_transaction_at

    GROUP BY
        T.TRN_id,
        T.TRN_transaction_at,
        C.TRNCH_code

    HAVING
        (
            C.TRNCH_code = 'ONLINE'
            AND COUNT(S.SHP_id) <> 1
        )

        OR

        (
            C.TRNCH_code = 'STORE'
            AND COUNT(S.SHP_id) <> 0
        )
)
BEGIN

    ;THROW 51520,
        N'Data certification failed: Transaction / Shipment channel rule violation detected.',
        1;

END;


/*------------------------------------------------------------------------------
    SHIPMENT ADDRESS OWNERSHIP
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM shipping.Shipment AS S

    INNER JOIN sales.[Transaction] AS T
        ON  T.TRN_id = S.SHP_TRN_id
        AND T.TRN_transaction_at = S.SHP_transaction_at

    INNER JOIN customer.CustomerAddress AS A
        ON A.CSTAD_id = S.SHP_CSTAD_id

    WHERE T.TRN_CST_id IS NULL
       OR A.CSTAD_CST_id <> T.TRN_CST_id
)
BEGIN

    ;THROW 51521,
        N'Data certification failed: Shipment address does not belong to Transaction Customer.',
        1;

END;


/*------------------------------------------------------------------------------
    SHIPMENT TEMPORAL INTEGRITY
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM shipping.Shipment AS S

    WHERE
        (
            S.SHP_posted_at IS NOT NULL
            AND S.SHP_posted_at < S.SHP_transaction_at
        )

        OR

        (
            S.SHP_delivered_at IS NOT NULL
            AND
            (
                S.SHP_posted_at IS NULL
                OR S.SHP_delivered_at < S.SHP_posted_at
            )
        )

        OR S.SHP_posted_at > @SampleDataCutoff
        OR S.SHP_delivered_at > @SampleDataCutoff
)
BEGIN

    ;THROW 51522,
        N'Data certification failed: Shipment temporal integrity violation detected.',
        1;

END;


PRINT N'        [PASS] Transaction / Shipment channel integrity';
PRINT N'        [PASS] Shipment address ownership';
PRINT N'        [PASS] Shipment temporal integrity';


/*==============================================================================
    06 - FINAL CERTIFICATION
==============================================================================*/

SET @CertificationEndedAt = SYSDATETIME();

SET @ElapsedMilliseconds =
    DATEDIFF_BIG
    (
        MILLISECOND,
        @CertificationStartedAt,
        @CertificationEndedAt
    );


PRINT N'';
PRINT N'==============================================================================';
PRINT N' ATLASCOMMERCE DATA CERTIFICATION - PASS';
PRINT N'==============================================================================';
PRINT N'';

PRINT N'    Referential Integrity       : PASS';
PRINT N'    Sales Integrity             : PASS';
PRINT N'    Inventory Integrity         : PASS';
PRINT N'    Payment Integrity           : PASS';
PRINT N'    Shipping Integrity          : PASS';
PRINT N'    Temporal Integrity          : PASS';
PRINT N'    Cross-Domain Reconciliation : PASS';

PRINT N'';

PRINT N'    Sample Data Cutoff          : '
    + CONVERT(nvarchar(19), @SampleDataCutoff, 120);

PRINT N'    Elapsed                     : '
    + CONVERT(nvarchar(20), @ElapsedMilliseconds)
    + N' ms ('
    + CONVERT
      (
          nvarchar(30),
          CONVERT
          (
              decimal(18,3),
              @ElapsedMilliseconds / 1000.0
          )
      )
    + N' s)';

PRINT N'';

PRINT N'==============================================================================';
PRINT N' AtlasCommerce sample data is certified for downstream use.';
PRINT N'==============================================================================';