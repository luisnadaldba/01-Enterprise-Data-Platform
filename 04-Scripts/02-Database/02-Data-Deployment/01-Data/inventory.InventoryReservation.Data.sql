/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : inventory.InventoryReservation
    Type        : Inventory / Sample Data
    Prefix      : INVRE
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the inventory reservation lifecycle used by the AtlasCommerce
    sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only inventory reservations that do not already exist.
    - Existing inventory reservations are preserved without modification.
    - No automatic UPDATE is performed.
    - Each TransactionItem can have at most one InventoryReservation.
    - TransactionItem dependencies are resolved using the complete
      TransactionItem key.
    - ProductVariant is inherited directly from the referenced TransactionItem.
    - InventoryReservationStatus dependencies are resolved by controlled
      status name.
    - ACTIVE reservations use the same deterministic selection used to derive
      Inventory.INV_quantity_reserved.
    - Historical reservations are generated deterministically using CONSUMED,
      RELEASED and EXPIRED lifecycle states.
    - ACTIVE reservations remain open.
    - Closed reservations always contain a closing timestamp.
    - EXPIRED reservations close at or after their expiration timestamp.
    - Source data is validated against the current Inventory reserved balance.
    - Data is deployed using a generated set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● inventory.InventoryReservation';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @INVRE_rows_added     int;
DECLARE @INVRE_rows_processed int;

DECLARE @INVRE_max_transaction_at datetime2(0);

DECLARE @INVRE_INVRS_active_id   tinyint;
DECLARE @INVRE_INVRS_consumed_id tinyint;
DECLARE @INVRE_INVRS_released_id tinyint;
DECLARE @INVRE_INVRS_expired_id  tinyint;


/*==============================================================================
    DEPENDENCY RESOLUTION
==============================================================================*/

SELECT
    @INVRE_max_transaction_at = MAX(TRN_transaction_at)
FROM sales.[Transaction];


IF @INVRE_max_transaction_at IS NULL
BEGIN

    ;THROW 50620,
        N'inventory.InventoryReservation data deployment requires Transaction records.',
        1;

END;


SELECT
    @INVRE_INVRS_active_id = INVRS_id
FROM inventory.InventoryReservationStatus
WHERE INVRS_name = N'ACTIVE';


SELECT
    @INVRE_INVRS_consumed_id = INVRS_id
FROM inventory.InventoryReservationStatus
WHERE INVRS_name = N'CONSUMED';


SELECT
    @INVRE_INVRS_released_id = INVRS_id
FROM inventory.InventoryReservationStatus
WHERE INVRS_name = N'RELEASED';


SELECT
    @INVRE_INVRS_expired_id = INVRS_id
FROM inventory.InventoryReservationStatus
WHERE INVRS_name = N'EXPIRED';


IF @INVRE_INVRS_active_id IS NULL
OR @INVRE_INVRS_consumed_id IS NULL
OR @INVRE_INVRS_released_id IS NULL
OR @INVRE_INVRS_expired_id IS NULL
BEGIN

    ;THROW 50621,
        N'inventory.InventoryReservation data deployment requires all controlled InventoryReservationStatus records.',
        1;

END;


/*==============================================================================
    SOURCE DATA
==============================================================================*/

DECLARE @INVRE_source TABLE
(
    INVRE_TRNIT_id              bigint       NOT NULL,
    INVRE_TRNIT_transaction_at  datetime2(0) NOT NULL,
    INVRE_PRDVA_id              int          NOT NULL,
    INVRE_INVRS_id              tinyint      NOT NULL,
    INVRE_quantity              int          NOT NULL,
    INVRE_reserved_at           datetime2(0) NOT NULL,
    INVRE_expires_at            datetime2(0) NOT NULL,
    INVRE_closed_at             datetime2(0) NULL,
    INVRE_created_at            datetime2(0) NOT NULL,
    INVRE_updated_at            datetime2(0) NOT NULL
);


;WITH ReservationBasis AS
(
    SELECT
        I.TRNIT_id,
        I.TRNIT_transaction_at,
        I.TRNIT_PRDVA_id,
        I.TRNIT_quantity,

        S.TRNST_code,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    I.TRNIT_id,
                    I.TRNIT_transaction_at,
                    307
                )
            )
        ) % 100 AS ActiveBucket,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    I.TRNIT_id,
                    I.TRNIT_transaction_at,
                    503
                )
            )
        ) % 100 AS HistoricalBucket,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    I.TRNIT_id,
                    I.TRNIT_transaction_at,
                    601
                )
            )
        ) % 100 AS LifecycleBucket

    FROM sales.TransactionItem AS I

    INNER JOIN sales.[Transaction] AS T
        ON  T.TRN_id = I.TRNIT_TRN_id
        AND T.TRN_transaction_at = I.TRNIT_transaction_at

    INNER JOIN sales.TransactionStatus AS S
        ON S.TRNST_id = T.TRN_TRNST_id
),
LifecycleSource AS
(
    SELECT
        B.TRNIT_id,
        B.TRNIT_transaction_at,
        B.TRNIT_PRDVA_id,
        B.TRNIT_quantity,

        CASE

            /*--------------------------------------------------------------
                ACTIVE
                Must remain identical to the selection used by Inventory.
            --------------------------------------------------------------*/

            WHEN B.TRNST_code = 'PENDING'
             AND B.TRNIT_transaction_at >=
                    DATEADD
                    (
                        DAY,
                        -7,
                        @INVRE_max_transaction_at
                    )
             AND B.ActiveBucket < 40
                THEN N'ACTIVE'


            /*--------------------------------------------------------------
                HISTORICAL CONSUMED
            --------------------------------------------------------------*/

            WHEN B.TRNIT_transaction_at <
                    DATEADD
                    (
                        DAY,
                        -7,
                        @INVRE_max_transaction_at
                    )
             AND B.HistoricalBucket < 30
             AND B.TRNST_code IN
                    (
                        'CONFIRMED',
                        'COMPLETED'
                    )
                THEN N'CONSUMED'


            /*--------------------------------------------------------------
                HISTORICAL RELEASED / EXPIRED
            --------------------------------------------------------------*/

            WHEN B.TRNIT_transaction_at <
                    DATEADD
                    (
                        DAY,
                        -7,
                        @INVRE_max_transaction_at
                    )
             AND B.HistoricalBucket < 30
             AND B.TRNST_code IN
                    (
                        'CANCELLED',
                        'FAILED'
                    )
             AND B.LifecycleBucket < 50
                THEN N'RELEASED'


            WHEN B.TRNIT_transaction_at <
                    DATEADD
                    (
                        DAY,
                        -7,
                        @INVRE_max_transaction_at
                    )
             AND B.HistoricalBucket < 30
             AND B.TRNST_code IN
                    (
                        'CANCELLED',
                        'FAILED'
                    )
             AND B.LifecycleBucket >= 50
                THEN N'EXPIRED'

            ELSE NULL

        END AS ReservationStatus

    FROM ReservationBasis AS B
)
INSERT INTO @INVRE_source
(
    INVRE_TRNIT_id,
    INVRE_TRNIT_transaction_at,
    INVRE_PRDVA_id,
    INVRE_INVRS_id,
    INVRE_quantity,
    INVRE_reserved_at,
    INVRE_expires_at,
    INVRE_closed_at,
    INVRE_created_at,
    INVRE_updated_at
)
SELECT
    L.TRNIT_id,
    L.TRNIT_transaction_at,
    L.TRNIT_PRDVA_id,

    CASE L.ReservationStatus
        WHEN N'ACTIVE'
            THEN @INVRE_INVRS_active_id

        WHEN N'CONSUMED'
            THEN @INVRE_INVRS_consumed_id

        WHEN N'RELEASED'
            THEN @INVRE_INVRS_released_id

        WHEN N'EXPIRED'
            THEN @INVRE_INVRS_expired_id
    END,

    L.TRNIT_quantity,

    L.TRNIT_transaction_at,


    /*--------------------------------------------------------------------------
        EXPIRES AT
    --------------------------------------------------------------------------*/

    CASE
        WHEN L.ReservationStatus = N'ACTIVE'
        THEN
            DATEADD
            (
                DAY,
                8,
                L.TRNIT_transaction_at
            )

        ELSE
            DATEADD
            (
                HOUR,
                2,
                L.TRNIT_transaction_at
            )
    END,


    /*--------------------------------------------------------------------------
        CLOSED AT
    --------------------------------------------------------------------------*/

    CASE L.ReservationStatus

        WHEN N'ACTIVE'
            THEN NULL

        WHEN N'CONSUMED'
            THEN DATEADD
                 (
                     MINUTE,
                     15,
                     L.TRNIT_transaction_at
                 )

        WHEN N'RELEASED'
            THEN DATEADD
                 (
                     MINUTE,
                     30,
                     L.TRNIT_transaction_at
                 )

        WHEN N'EXPIRED'
            THEN DATEADD
                 (
                     MINUTE,
                     125,
                     L.TRNIT_transaction_at
                 )

    END,


    L.TRNIT_transaction_at,


    CASE
        WHEN L.ReservationStatus = N'ACTIVE'
            THEN L.TRNIT_transaction_at

        WHEN L.ReservationStatus = N'CONSUMED'
            THEN DATEADD
                 (
                     MINUTE,
                     15,
                     L.TRNIT_transaction_at
                 )

        WHEN L.ReservationStatus = N'RELEASED'
            THEN DATEADD
                 (
                     MINUTE,
                     30,
                     L.TRNIT_transaction_at
                 )

        WHEN L.ReservationStatus = N'EXPIRED'
            THEN DATEADD
                 (
                     MINUTE,
                     125,
                     L.TRNIT_transaction_at
                 )
    END

FROM LifecycleSource AS L

WHERE L.ReservationStatus IS NOT NULL;


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

SELECT
    @INVRE_rows_processed = COUNT(*)
FROM @INVRE_source;


IF @INVRE_rows_processed = 0
BEGIN

    ;THROW 50622,
        N'inventory.InventoryReservation source data did not generate any rows.',
        1;

END;


/*------------------------------------------------------------------------------
    ONE RESERVATION PER TRANSACTION ITEM
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT
        S.INVRE_TRNIT_id,
        S.INVRE_TRNIT_transaction_at
    FROM @INVRE_source AS S
    GROUP BY
        S.INVRE_TRNIT_id,
        S.INVRE_TRNIT_transaction_at
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50623,
        N'inventory.InventoryReservation source data contains multiple reservations for the same TransactionItem.',
        1;

END;


/*------------------------------------------------------------------------------
    QUANTITY
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVRE_source AS S
    WHERE S.INVRE_quantity <= 0
)
BEGIN

    ;THROW 50624,
        N'inventory.InventoryReservation source data contains an invalid reservation quantity.',
        1;

END;


/*------------------------------------------------------------------------------
    EXPIRATION
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVRE_source AS S
    WHERE S.INVRE_expires_at <= S.INVRE_reserved_at
)
BEGIN

    ;THROW 50625,
        N'inventory.InventoryReservation source data contains an invalid expiration timestamp.',
        1;

END;


/*------------------------------------------------------------------------------
    ACTIVE MUST REMAIN OPEN
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVRE_source AS S
    WHERE S.INVRE_INVRS_id = @INVRE_INVRS_active_id
      AND S.INVRE_closed_at IS NOT NULL
)
BEGIN

    ;THROW 50626,
        N'inventory.InventoryReservation source data contains a closed ACTIVE reservation.',
        1;

END;


/*------------------------------------------------------------------------------
    CLOSED STATUSES MUST HAVE CLOSED_AT
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVRE_source AS S
    WHERE S.INVRE_INVRS_id IN
          (
              @INVRE_INVRS_consumed_id,
              @INVRE_INVRS_released_id,
              @INVRE_INVRS_expired_id
          )
      AND S.INVRE_closed_at IS NULL
)
BEGIN

    ;THROW 50627,
        N'inventory.InventoryReservation source data contains a closed status without closed_at.',
        1;

END;


/*------------------------------------------------------------------------------
    CLOSED_AT CANNOT PRECEDE RESERVED_AT
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVRE_source AS S
    WHERE S.INVRE_closed_at IS NOT NULL
      AND S.INVRE_closed_at < S.INVRE_reserved_at
)
BEGIN

    ;THROW 50628,
        N'inventory.InventoryReservation source data contains a closing timestamp before reserved_at.',
        1;

END;


/*------------------------------------------------------------------------------
    EXPIRED MUST CLOSE AT OR AFTER EXPIRATION
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVRE_source AS S
    WHERE S.INVRE_INVRS_id = @INVRE_INVRS_expired_id
      AND S.INVRE_closed_at < S.INVRE_expires_at
)
BEGIN

    ;THROW 50629,
        N'inventory.InventoryReservation source data contains an EXPIRED reservation closed before expiration.',
        1;

END;


/*------------------------------------------------------------------------------
    PRODUCT VARIANT MUST MATCH TRANSACTION ITEM
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVRE_source AS S

    INNER JOIN sales.TransactionItem AS I
        ON  I.TRNIT_id = S.INVRE_TRNIT_id
        AND I.TRNIT_transaction_at = S.INVRE_TRNIT_transaction_at

    WHERE I.TRNIT_PRDVA_id <> S.INVRE_PRDVA_id
)
BEGIN

    ;THROW 50630,
        N'inventory.InventoryReservation source data contains a ProductVariant that does not match its TransactionItem.',
        1;

END;


/*==============================================================================
    INVENTORY RECONCILIATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM inventory.Inventory AS I

    INNER JOIN catalog.ProductVariant AS V
        ON V.PRDVA_id = I.INV_PRDVA_id

    LEFT JOIN
    (
        SELECT
            S.INVRE_PRDVA_id,
            SUM(S.INVRE_quantity) AS ReservedQuantity

        FROM @INVRE_source AS S

        WHERE S.INVRE_INVRS_id = @INVRE_INVRS_active_id

        GROUP BY
            S.INVRE_PRDVA_id
    ) AS R
        ON R.INVRE_PRDVA_id = I.INV_PRDVA_id

    WHERE I.INV_quantity_reserved <>
            COALESCE
            (
                R.ReservedQuantity,
                0
            )
)
BEGIN

    ;THROW 50631,
        N'inventory.InventoryReservation ACTIVE quantities do not reconcile with Inventory.INV_quantity_reserved.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

INSERT INTO inventory.InventoryReservation
(
    INVRE_TRNIT_id,
    INVRE_TRNIT_transaction_at,
    INVRE_PRDVA_id,
    INVRE_INVRS_id,
    INVRE_quantity,
    INVRE_reserved_at,
    INVRE_expires_at,
    INVRE_closed_at,
    INVRE_created_at,
    INVRE_updated_at
)
SELECT
    S.INVRE_TRNIT_id,
    S.INVRE_TRNIT_transaction_at,
    S.INVRE_PRDVA_id,
    S.INVRE_INVRS_id,
    S.INVRE_quantity,
    S.INVRE_reserved_at,
    S.INVRE_expires_at,
    S.INVRE_closed_at,
    S.INVRE_created_at,
    S.INVRE_updated_at
FROM @INVRE_source AS S

WHERE NOT EXISTS
(
    SELECT 1
    FROM inventory.InventoryReservation AS R
    WHERE R.INVRE_TRNIT_id = S.INVRE_TRNIT_id
      AND R.INVRE_TRNIT_transaction_at =
            S.INVRE_TRNIT_transaction_at
);


SET @INVRE_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @INVRE_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @INVRE_rows_processed - @INVRE_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @INVRE_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';