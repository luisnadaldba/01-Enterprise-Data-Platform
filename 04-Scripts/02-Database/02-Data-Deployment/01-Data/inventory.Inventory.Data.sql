/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : inventory.Inventory
    Type        : Inventory / Sample Data
    Prefix      : INV
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the current inventory position used by the AtlasCommerce sample
    data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts one current inventory balance per active ProductVariant.
    - Existing inventory balances are preserved without modification.
    - No automatic UPDATE is performed.
    - INV_PRDVA_id is used to identify an existing inventory balance.
    - ProductVariant dependencies are resolved by SKU.
    - Quantity on hand is generated deterministically for each ProductVariant.
    - Quantity reserved is derived from a deterministic subset of recent
      PENDING TransactionItems.
    - Reserved quantity never exceeds quantity on hand.
    - Available quantity remains derived as quantity on hand minus quantity
      reserved and is not persisted redundantly.
    - Source data is validated before deployment.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● inventory.Inventory';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @INV_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @INV_rows_added     int;
DECLARE @INV_rows_processed int;

DECLARE @INV_source TABLE
(
    PRDVA_sku             nvarchar(100) NOT NULL PRIMARY KEY,
    INV_quantity_on_hand  int           NOT NULL,
    INV_quantity_reserved int           NOT NULL
);


/*==============================================================================
    ACTIVE RESERVATION BASIS
==============================================================================*/

DECLARE @INV_active_reservation_basis TABLE
(
    TRNIT_id             bigint       NOT NULL,
    TRNIT_transaction_at datetime2(0) NOT NULL,
    TRNIT_PRDVA_id       int          NOT NULL,
    TRNIT_quantity       int          NOT NULL,

    PRIMARY KEY
    (
        TRNIT_id,
        TRNIT_transaction_at
    )
);


INSERT INTO @INV_active_reservation_basis
(
    TRNIT_id,
    TRNIT_transaction_at,
    TRNIT_PRDVA_id,
    TRNIT_quantity
)
SELECT
    I.TRNIT_id,
    I.TRNIT_transaction_at,
    I.TRNIT_PRDVA_id,
    I.TRNIT_quantity
FROM sales.TransactionItem AS I

INNER JOIN sales.[Transaction] AS T
    ON  T.TRN_id = I.TRNIT_TRN_id
    AND T.TRN_transaction_at = I.TRNIT_transaction_at

INNER JOIN sales.TransactionStatus AS S
    ON S.TRNST_id = T.TRN_TRNST_id

WHERE S.TRNST_code = 'PENDING'
  AND T.TRN_transaction_at >=
        DATEADD
        (
            DAY,
            -7,
            (
                SELECT MAX(TRN_transaction_at)
                FROM sales.[Transaction]
            )
        )
  AND ABS
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
      ) % 100 < 40;


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @INV_source
(
    PRDVA_sku,
    INV_quantity_on_hand,
    INV_quantity_reserved
)
SELECT
    V.PRDVA_sku,

    80
        +
        CONVERT
        (
            int,
            ABS
            (
                CONVERT
                (
                    bigint,
                    CHECKSUM
                    (
                        V.PRDVA_id,
                        V.PRDVA_sku,
                        401
                    )
                )
            ) % 171
        )
        AS INV_quantity_on_hand,

    COALESCE
    (
        R.QuantityReserved,
        0
    )
        AS INV_quantity_reserved

FROM catalog.ProductVariant AS V

LEFT JOIN
(
    SELECT
        B.TRNIT_PRDVA_id,
        SUM(B.TRNIT_quantity) AS QuantityReserved

    FROM @INV_active_reservation_basis AS B

    GROUP BY
        B.TRNIT_PRDVA_id
) AS R
    ON R.TRNIT_PRDVA_id = V.PRDVA_id

WHERE V.PRDVA_is_active = 1;


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @INV_source AS S
    WHERE S.INV_quantity_on_hand < 0
)
BEGIN

    ;THROW 50610,
        N'inventory.Inventory source data contains a negative quantity on hand.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @INV_source AS S
    WHERE S.INV_quantity_reserved < 0
       OR S.INV_quantity_reserved > S.INV_quantity_on_hand
)
BEGIN

    ;THROW 50611,
        N'inventory.Inventory source data contains an invalid reserved quantity.',
        1;

END;


IF EXISTS
(
    SELECT
        S.PRDVA_sku
    FROM @INV_source AS S
    GROUP BY
        S.PRDVA_sku
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50612,
        N'inventory.Inventory source data contains duplicate ProductVariant definitions.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @INV_source AS S

    LEFT JOIN catalog.ProductVariant AS V
        ON V.PRDVA_sku = S.PRDVA_sku

    WHERE V.PRDVA_id IS NULL
)
BEGIN

    ;THROW 50613,
        N'inventory.Inventory data deployment requires all referenced ProductVariant records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @INV_rows_processed = COUNT(*)
FROM @INV_source;


INSERT INTO inventory.Inventory
(
    INV_PRDVA_id,
    INV_quantity_on_hand,
    INV_quantity_reserved,
    INV_created_at,
    INV_updated_at
)
SELECT
    V.PRDVA_id,
    S.INV_quantity_on_hand,
    S.INV_quantity_reserved,
    @INV_data_timestamp,
    @INV_data_timestamp

FROM @INV_source AS S

INNER JOIN catalog.ProductVariant AS V
    ON V.PRDVA_sku = S.PRDVA_sku

WHERE NOT EXISTS
(
    SELECT 1
    FROM inventory.Inventory AS I
    WHERE I.INV_PRDVA_id = V.PRDVA_id
);


SET @INV_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @INV_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @INV_rows_processed - @INV_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @INV_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';