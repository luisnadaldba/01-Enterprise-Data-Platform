/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : shipping.Shipment
    Type        : Shipping / Sample Data
    Prefix      : SHP
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the fulfillment records associated with AtlasCommerce ONLINE
    sample transactions.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Generates one Shipment for every ONLINE Transaction.
    - STORE Transactions represent immediate pickup and do not generate
      Shipment records.
    - Existing Shipments are preserved without modification.
    - No automatic UPDATE is performed.
    - SHP_TRN_id + SHP_transaction_at identify the originating Transaction.
    - CustomerAddress dependencies are resolved from the identified Customer.
    - The active primary CustomerAddress is used as the sample delivery
      destination.
    - ShipmentMethod dependencies are resolved from the controlled PAC and
      SEDEX values.
    - ShipmentStatus dependencies are resolved from the controlled shipment
      lifecycle values.
    - Shipping amount is generated independently from the merchandise
      Transaction amount.
    - Some shipments receive free shipping.
    - Delivery estimates are generated according to the selected shipment
      method.
    - Tracking codes are synthetic and are generated only when the logistics
      lifecycle has progressed beyond PENDING.
    - Posted and delivered timestamps preserve valid temporal ordering.
    - Source data is validated before deployment.
    - Data is deployed using a generated set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● shipping.Shipment';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @SHP_rows_added     int;
DECLARE @SHP_rows_processed int;

DECLARE @SHP_TRNCH_online_id tinyint;

DECLARE @SHP_SHPMT_pac_id   tinyint;
DECLARE @SHP_SHPMT_sedex_id tinyint;

DECLARE @SHP_SHPST_pending_id   tinyint;
DECLARE @SHP_SHPST_posted_id    tinyint;
DECLARE @SHP_SHPST_delivered_id tinyint;
DECLARE @SHP_SHPST_cancelled_id tinyint;
DECLARE @SHP_SHPST_returned_id  tinyint;


/*==============================================================================
    DEPENDENCY RESOLUTION
==============================================================================*/

SELECT
    @SHP_TRNCH_online_id = TRNCH_id
FROM sales.TransactionChannel
WHERE TRNCH_code = 'ONLINE';


IF @SHP_TRNCH_online_id IS NULL
BEGIN

    ;THROW 50710,
        N'shipping.Shipment data deployment requires TransactionChannel ONLINE.',
        1;

END;


SELECT
    @SHP_SHPMT_pac_id = SHPMT_id
FROM shipping.ShipmentMethod
WHERE SHPMT_name = 'PAC';


SELECT
    @SHP_SHPMT_sedex_id = SHPMT_id
FROM shipping.ShipmentMethod
WHERE SHPMT_name = 'SEDEX';


IF @SHP_SHPMT_pac_id IS NULL
OR @SHP_SHPMT_sedex_id IS NULL
BEGIN

    ;THROW 50711,
        N'shipping.Shipment data deployment requires PAC and SEDEX ShipmentMethod records.',
        1;

END;


SELECT
    @SHP_SHPST_pending_id = SHPST_id
FROM shipping.ShipmentStatus
WHERE SHPST_name = 'PENDING';


SELECT
    @SHP_SHPST_posted_id = SHPST_id
FROM shipping.ShipmentStatus
WHERE SHPST_name = 'POSTED';


SELECT
    @SHP_SHPST_delivered_id = SHPST_id
FROM shipping.ShipmentStatus
WHERE SHPST_name = 'DELIVERED';


SELECT
    @SHP_SHPST_cancelled_id = SHPST_id
FROM shipping.ShipmentStatus
WHERE SHPST_name = 'CANCELLED';


SELECT
    @SHP_SHPST_returned_id = SHPST_id
FROM shipping.ShipmentStatus
WHERE SHPST_name = 'RETURNED';


IF @SHP_SHPST_pending_id IS NULL
OR @SHP_SHPST_posted_id IS NULL
OR @SHP_SHPST_delivered_id IS NULL
OR @SHP_SHPST_cancelled_id IS NULL
OR @SHP_SHPST_returned_id IS NULL
BEGIN

    ;THROW 50712,
        N'shipping.Shipment data deployment requires all controlled ShipmentStatus records.',
        1;

END;


/*==============================================================================
    ONLINE TRANSACTION VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1

    FROM sales.[Transaction] AS T

    WHERE T.TRN_TRNCH_id = @SHP_TRNCH_online_id
      AND T.TRN_CST_id IS NULL
)
BEGIN

    ;THROW 50713,
        N'shipping.Shipment data deployment found an ONLINE Transaction without an identified Customer.',
        1;

END;


/*------------------------------------------------------------------------------
    EVERY ONLINE CUSTOMER MUST HAVE EXACTLY ONE ACTIVE PRIMARY ADDRESS
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT
        T.TRN_id,
        T.TRN_transaction_at

    FROM sales.[Transaction] AS T

    LEFT JOIN customer.CustomerAddress AS CA
        ON  CA.CSTAD_CST_id = T.TRN_CST_id
        AND CA.CSTAD_is_primary = 1
        AND CA.CSTAD_is_active = 1

    WHERE T.TRN_TRNCH_id = @SHP_TRNCH_online_id

    GROUP BY
        T.TRN_id,
        T.TRN_transaction_at

    HAVING COUNT(CA.CSTAD_id) <> 1
)
BEGIN

    ;THROW 50714,
        N'shipping.Shipment data deployment requires exactly one active primary CustomerAddress for every ONLINE Transaction.',
        1;

END;


/*==============================================================================
    SHIPMENT BASIS
==============================================================================*/

DECLARE @SHP_basis TABLE
(
    SHP_TRN_id          bigint       NOT NULL,
    SHP_transaction_at  datetime2(0) NOT NULL,
    SHP_CSTAD_id        int          NOT NULL,

    SHP_TRNST_code      varchar(30)  NOT NULL,

    SHP_SHPMT_id        tinyint      NOT NULL,

    SHP_method_name     varchar(30)  NOT NULL,

    SHP_status_bucket   int          NOT NULL,
    SHP_shipping_bucket int          NOT NULL,

    PRIMARY KEY
    (
        SHP_TRN_id,
        SHP_transaction_at
    )
);


INSERT INTO @SHP_basis
(
    SHP_TRN_id,
    SHP_transaction_at,
    SHP_CSTAD_id,
    SHP_TRNST_code,
    SHP_SHPMT_id,
    SHP_method_name,
    SHP_status_bucket,
    SHP_shipping_bucket
)
SELECT
    T.TRN_id,
    T.TRN_transaction_at,
    CA.CSTAD_id,
    TS.TRNST_code,

    CASE
        WHEN X.MethodBucket < 65
            THEN @SHP_SHPMT_pac_id

        ELSE @SHP_SHPMT_sedex_id
    END,

    CASE
        WHEN X.MethodBucket < 65
            THEN 'PAC'

        ELSE 'SEDEX'
    END,

    X.StatusBucket,
    X.ShippingBucket

FROM sales.[Transaction] AS T

INNER JOIN sales.TransactionStatus AS TS
    ON TS.TRNST_id = T.TRN_TRNST_id

INNER JOIN customer.CustomerAddress AS CA
    ON  CA.CSTAD_CST_id = T.TRN_CST_id
    AND CA.CSTAD_is_primary = 1
    AND CA.CSTAD_is_active = 1

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
                    1103
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
                    1201
                )
            )
        ) % 100 AS StatusBucket,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    T.TRN_id,
                    T.TRN_transaction_at,
                    1301
                )
            )
        ) % 100 AS ShippingBucket

) AS X

WHERE T.TRN_TRNCH_id = @SHP_TRNCH_online_id;


/*==============================================================================
    SOURCE DATA
==============================================================================*/

DECLARE @SHP_source TABLE
(
    SHP_TRN_id                  bigint        NOT NULL,
    SHP_transaction_at          datetime2(0)  NOT NULL,

    SHP_CSTAD_id                int           NOT NULL,
    SHP_SHPMT_id                tinyint       NOT NULL,
    SHP_SHPST_id                tinyint       NOT NULL,

    SHP_shipping_amount         decimal(19,2) NOT NULL,
    SHP_estimated_delivery_date date          NOT NULL,

    SHP_tracking_code           varchar(30)   NULL,

    SHP_posted_at               datetime2(0)  NULL,
    SHP_delivered_at            datetime2(0)  NULL,

    SHP_created_at              datetime2(0)  NOT NULL,
    SHP_updated_at              datetime2(0)  NOT NULL,

    PRIMARY KEY
    (
        SHP_TRN_id,
        SHP_transaction_at
    )
);


/*==============================================================================
    GENERATED SHIPMENTS
==============================================================================*/

INSERT INTO @SHP_source
(
    SHP_TRN_id,
    SHP_transaction_at,

    SHP_CSTAD_id,
    SHP_SHPMT_id,
    SHP_SHPST_id,

    SHP_shipping_amount,
    SHP_estimated_delivery_date,

    SHP_tracking_code,

    SHP_posted_at,
    SHP_delivered_at,

    SHP_created_at,
    SHP_updated_at
)
SELECT
    B.SHP_TRN_id,
    B.SHP_transaction_at,

    B.SHP_CSTAD_id,
    B.SHP_SHPMT_id,


    /*--------------------------------------------------------------------------
        SHIPMENT STATUS
    --------------------------------------------------------------------------*/

    CASE

        WHEN B.SHP_TRNST_code IN
             (
                 'CANCELLED',
                 'FAILED'
             )
            THEN @SHP_SHPST_cancelled_id


        WHEN B.SHP_TRNST_code = 'PENDING'
            THEN @SHP_SHPST_pending_id


        WHEN B.SHP_TRNST_code = 'CONFIRMED'
            THEN
                CASE
                    WHEN B.SHP_status_bucket < 20
                        THEN @SHP_SHPST_pending_id

                    ELSE @SHP_SHPST_posted_id
                END


        WHEN B.SHP_TRNST_code = 'COMPLETED'
            THEN
                CASE
                    WHEN B.SHP_status_bucket < 4
                        THEN @SHP_SHPST_returned_id

                    ELSE @SHP_SHPST_delivered_id
                END


        ELSE @SHP_SHPST_pending_id

    END,


    /*--------------------------------------------------------------------------
        SHIPPING AMOUNT

        Some shipments use a legitimate free-shipping commercial condition.
    --------------------------------------------------------------------------*/

    CASE
        WHEN B.SHP_shipping_bucket < 15
            THEN CONVERT(decimal(19,2), 0.00)

        WHEN B.SHP_method_name = 'PAC'
            THEN CONVERT(decimal(19,2), 14.90)

        ELSE CONVERT(decimal(19,2), 24.90)
    END,


    /*--------------------------------------------------------------------------
        ESTIMATED DELIVERY DATE
    --------------------------------------------------------------------------*/

    DATEADD
    (
        DAY,

        CASE
            WHEN B.SHP_method_name = 'PAC'
                THEN 7

            ELSE 3
        END,

        CONVERT(date, B.SHP_transaction_at)
    ),


    /*--------------------------------------------------------------------------
        TRACKING CODE
    --------------------------------------------------------------------------*/

    CASE

        WHEN B.SHP_TRNST_code IN
             (
                 'PENDING',
                 'CANCELLED',
                 'FAILED'
             )
            THEN NULL


        WHEN B.SHP_TRNST_code = 'CONFIRMED'
         AND B.SHP_status_bucket < 20
            THEN NULL


        ELSE
            'ATC'
            +
            RIGHT
            (
                REPLICATE('0', 12)
                + CONVERT
                  (
                      varchar(20),
                      B.SHP_TRN_id
                  ),
                12
            )

    END,


    /*--------------------------------------------------------------------------
        POSTED AT
    --------------------------------------------------------------------------*/

    CASE

        WHEN B.SHP_TRNST_code IN
             (
                 'PENDING',
                 'CANCELLED',
                 'FAILED'
             )
            THEN NULL


        WHEN B.SHP_TRNST_code = 'CONFIRMED'
         AND B.SHP_status_bucket < 20
            THEN NULL


        ELSE
            DATEADD
            (
                MINUTE,
                60,
                B.SHP_transaction_at
            )

    END,


    /*--------------------------------------------------------------------------
        DELIVERED AT

        RETURNED does not imply successful delivery in the current model.
    --------------------------------------------------------------------------*/

    CASE

        WHEN B.SHP_TRNST_code = 'COMPLETED'
         AND B.SHP_status_bucket >= 4
            THEN
                DATEADD
                (
                    HOUR,
                    CASE
                        WHEN B.SHP_method_name = 'PAC'
                            THEN 120

                        ELSE 48
                    END,
                    B.SHP_transaction_at
                )

        ELSE NULL

    END,


    /*--------------------------------------------------------------------------
        CREATED AT
    --------------------------------------------------------------------------*/

    DATEADD
    (
        MINUTE,
        5,
        B.SHP_transaction_at
    ),


    /*--------------------------------------------------------------------------
        UPDATED AT
    --------------------------------------------------------------------------*/

    CASE

        WHEN B.SHP_TRNST_code IN
             (
                 'CANCELLED',
                 'FAILED'
             )
            THEN
                DATEADD
                (
                    MINUTE,
                    30,
                    B.SHP_transaction_at
                )


        WHEN B.SHP_TRNST_code = 'PENDING'
            THEN
                DATEADD
                (
                    MINUTE,
                    5,
                    B.SHP_transaction_at
                )


        WHEN B.SHP_TRNST_code = 'CONFIRMED'
         AND B.SHP_status_bucket < 20
            THEN
                DATEADD
                (
                    MINUTE,
                    5,
                    B.SHP_transaction_at
                )


        WHEN B.SHP_TRNST_code = 'CONFIRMED'
            THEN
                DATEADD
                (
                    MINUTE,
                    60,
                    B.SHP_transaction_at
                )


        WHEN B.SHP_TRNST_code = 'COMPLETED'
         AND B.SHP_status_bucket < 4
            THEN
                DATEADD
                (
                    HOUR,
                    CASE
                        WHEN B.SHP_method_name = 'PAC'
                            THEN 144

                        ELSE 72
                    END,
                    B.SHP_transaction_at
                )


        ELSE
            DATEADD
            (
                HOUR,
                CASE
                    WHEN B.SHP_method_name = 'PAC'
                        THEN 120

                    ELSE 48
                END,
                B.SHP_transaction_at
            )

    END

FROM @SHP_basis AS B;


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

SELECT
    @SHP_rows_processed = COUNT(*)
FROM @SHP_source;


IF @SHP_rows_processed = 0
BEGIN

    ;THROW 50715,
        N'shipping.Shipment source data did not generate any rows.',
        1;

END;


/*------------------------------------------------------------------------------
    EXACTLY ONE SHIPMENT PER ONLINE TRANSACTION
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT
        S.SHP_TRN_id,
        S.SHP_transaction_at

    FROM @SHP_source AS S

    GROUP BY
        S.SHP_TRN_id,
        S.SHP_transaction_at

    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50716,
        N'shipping.Shipment source data contains multiple Shipments for the same Transaction.',
        1;

END;


/*------------------------------------------------------------------------------
    EVERY ONLINE TRANSACTION MUST BE REPRESENTED
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM sales.[Transaction] AS T

    WHERE T.TRN_TRNCH_id = @SHP_TRNCH_online_id

      AND NOT EXISTS
          (
              SELECT 1
              FROM @SHP_source AS S
              WHERE S.SHP_TRN_id = T.TRN_id
                AND S.SHP_transaction_at = T.TRN_transaction_at
          )
)
BEGIN

    ;THROW 50717,
        N'shipping.Shipment source data does not cover every ONLINE Transaction.',
        1;

END;


/*------------------------------------------------------------------------------
    STORE TRANSACTIONS MUST NOT BE REPRESENTED
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM @SHP_source AS S

    INNER JOIN sales.[Transaction] AS T
        ON  T.TRN_id = S.SHP_TRN_id
        AND T.TRN_transaction_at = S.SHP_transaction_at

    WHERE T.TRN_TRNCH_id <> @SHP_TRNCH_online_id
)
BEGIN

    ;THROW 50718,
        N'shipping.Shipment source data contains a Shipment for a non-ONLINE Transaction.',
        1;

END;


/*------------------------------------------------------------------------------
    TRANSACTION DEPENDENCY
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM @SHP_source AS S

    LEFT JOIN sales.[Transaction] AS T
        ON  T.TRN_id = S.SHP_TRN_id
        AND T.TRN_transaction_at = S.SHP_transaction_at

    WHERE T.TRN_id IS NULL
)
BEGIN

    ;THROW 50719,
        N'shipping.Shipment source data references a Transaction that does not exist.',
        1;

END;


/*------------------------------------------------------------------------------
    CUSTOMER ADDRESS DEPENDENCY AND OWNERSHIP
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1

    FROM @SHP_source AS S

    INNER JOIN sales.[Transaction] AS T
        ON  T.TRN_id = S.SHP_TRN_id
        AND T.TRN_transaction_at = S.SHP_transaction_at

    LEFT JOIN customer.CustomerAddress AS CA
        ON CA.CSTAD_id = S.SHP_CSTAD_id

    WHERE CA.CSTAD_id IS NULL
       OR CA.CSTAD_CST_id <> T.TRN_CST_id
)
BEGIN

    ;THROW 50720,
        N'shipping.Shipment source data contains a CustomerAddress that does not belong to the Transaction Customer.',
        1;

END;


/*------------------------------------------------------------------------------
    SHIPPING AMOUNT
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @SHP_source AS S
    WHERE S.SHP_shipping_amount < 0.00
)
BEGIN

    ;THROW 50721,
        N'shipping.Shipment source data contains a negative shipping amount.',
        1;

END;


/*------------------------------------------------------------------------------
    ESTIMATED DELIVERY DATE
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @SHP_source AS S

    WHERE S.SHP_estimated_delivery_date
            < CONVERT(date, S.SHP_transaction_at)
)
BEGIN

    ;THROW 50722,
        N'shipping.Shipment source data contains an estimated delivery date before the Transaction date.',
        1;

END;


/*------------------------------------------------------------------------------
    POSTED AT
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @SHP_source AS S

    WHERE S.SHP_posted_at IS NOT NULL
      AND S.SHP_posted_at < S.SHP_transaction_at
)
BEGIN

    ;THROW 50723,
        N'shipping.Shipment source data contains posted_at before the Transaction timestamp.',
        1;

END;


/*------------------------------------------------------------------------------
    DELIVERED AT
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @SHP_source AS S

    WHERE S.SHP_delivered_at IS NOT NULL

      AND
      (
          S.SHP_posted_at IS NULL
          OR S.SHP_delivered_at < S.SHP_posted_at
      )
)
BEGIN

    ;THROW 50724,
        N'shipping.Shipment source data contains an invalid delivered_at timestamp.',
        1;

END;


/*------------------------------------------------------------------------------
    PENDING STATUS
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @SHP_source AS S

    WHERE S.SHP_SHPST_id = @SHP_SHPST_pending_id

      AND
      (
          S.SHP_tracking_code IS NOT NULL
          OR S.SHP_posted_at IS NOT NULL
          OR S.SHP_delivered_at IS NOT NULL
      )
)
BEGIN

    ;THROW 50725,
        N'shipping.Shipment source data contains logistics events for a PENDING Shipment.',
        1;

END;


/*------------------------------------------------------------------------------
    POSTED STATUS
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @SHP_source AS S

    WHERE S.SHP_SHPST_id = @SHP_SHPST_posted_id

      AND
      (
          S.SHP_tracking_code IS NULL
          OR S.SHP_posted_at IS NULL
          OR S.SHP_delivered_at IS NOT NULL
      )
)
BEGIN

    ;THROW 50726,
        N'shipping.Shipment source data contains an invalid POSTED lifecycle state.',
        1;

END;


/*------------------------------------------------------------------------------
    DELIVERED STATUS
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @SHP_source AS S

    WHERE S.SHP_SHPST_id = @SHP_SHPST_delivered_id

      AND
      (
          S.SHP_tracking_code IS NULL
          OR S.SHP_posted_at IS NULL
          OR S.SHP_delivered_at IS NULL
      )
)
BEGIN

    ;THROW 50727,
        N'shipping.Shipment source data contains an invalid DELIVERED lifecycle state.',
        1;

END;


/*------------------------------------------------------------------------------
    RETURNED STATUS
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @SHP_source AS S

    WHERE S.SHP_SHPST_id = @SHP_SHPST_returned_id

      AND
      (
          S.SHP_tracking_code IS NULL
          OR S.SHP_posted_at IS NULL
      )
)
BEGIN

    ;THROW 50728,
        N'shipping.Shipment source data contains an invalid RETURNED lifecycle state.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

INSERT INTO shipping.Shipment
(
    SHP_TRN_id,
    SHP_transaction_at,

    SHP_CSTAD_id,
    SHP_SHPMT_id,
    SHP_SHPST_id,

    SHP_shipping_amount,
    SHP_estimated_delivery_date,

    SHP_tracking_code,

    SHP_posted_at,
    SHP_delivered_at,

    SHP_created_at,
    SHP_updated_at
)
SELECT
    S.SHP_TRN_id,
    S.SHP_transaction_at,

    S.SHP_CSTAD_id,
    S.SHP_SHPMT_id,
    S.SHP_SHPST_id,

    S.SHP_shipping_amount,
    S.SHP_estimated_delivery_date,

    S.SHP_tracking_code,

    S.SHP_posted_at,
    S.SHP_delivered_at,

    S.SHP_created_at,
    S.SHP_updated_at

FROM @SHP_source AS S

WHERE NOT EXISTS
(
    SELECT 1
    FROM shipping.Shipment AS H

    WHERE H.SHP_TRN_id = S.SHP_TRN_id
      AND H.SHP_transaction_at = S.SHP_transaction_at
);


SET @SHP_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @SHP_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT
      (
          nvarchar(20),
          @SHP_rows_processed - @SHP_rows_added
      );

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @SHP_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';