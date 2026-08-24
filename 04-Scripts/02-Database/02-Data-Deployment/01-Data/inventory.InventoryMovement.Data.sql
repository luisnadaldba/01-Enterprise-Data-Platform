/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : inventory.InventoryMovement
    Type        : Inventory / Sample Data
    Prefix      : INVMV
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the historical physical inventory movements used by the
    AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only inventory movements that do not already exist.
    - Existing inventory movements are preserved without modification.
    - No automatic UPDATE is performed.
    - Movement reasons are resolved from the controlled
      InventoryMovementReason domain.
    - SALE movements are generated from CONFIRMED and COMPLETED
      TransactionItems.
    - A small deterministic subset of COMPLETED sales generates compensating
      CUSTOMER_RETURN movements.
    - A small number of non-commercial inventory events are generated for
      damage, loss, discovery and inventory adjustment scenarios.
    - PURCHASE_RECEIPT movements establish the opening physical inventory
      required for the generated history.
    - Positive quantities represent physical inventory entries.
    - Negative quantities represent physical inventory exits.
    - Commercial movements preserve the complete TransactionItem reference.
    - Non-commercial movements do not reference TransactionItem.
    - The complete generated movement history reconciles exactly to the
      current Inventory.INV_quantity_on_hand for every ProductVariant.
    - Source data is validated before deployment.
    - Data is deployed using generated set-based operations.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● inventory.InventoryMovement';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @INVMV_rows_added     int;
DECLARE @INVMV_rows_processed int;

DECLARE @INVMV_start_date date = '2025-01-01';
DECLARE @INVMV_end_date   date;

DECLARE @INVMV_INVMR_purchase_receipt_id         smallint;
DECLARE @INVMV_INVMR_sale_id                     smallint;
DECLARE @INVMV_INVMR_customer_return_id          smallint;
DECLARE @INVMV_INVMR_damaged_in_transit_id       smallint;
DECLARE @INVMV_INVMR_damaged_internal_id         smallint;
DECLARE @INVMV_INVMR_loss_in_transit_id          smallint;
DECLARE @INVMV_INVMR_loss_internal_id            smallint;
DECLARE @INVMV_INVMR_found_internal_id           smallint;
DECLARE @INVMV_INVMR_inventory_adjustment_in_id  smallint;
DECLARE @INVMV_INVMR_inventory_adjustment_out_id smallint;


/*==============================================================================
    DEPENDENCY RESOLUTION
==============================================================================*/

SELECT
    @INVMV_end_date =
        CONVERT(date, MAX(TRN_transaction_at))
FROM sales.[Transaction];


IF @INVMV_end_date IS NULL
BEGIN

    ;THROW 50640,
        N'inventory.InventoryMovement data deployment requires Transaction records.',
        1;

END;


SELECT
    @INVMV_INVMR_purchase_receipt_id = INVMR_id
FROM inventory.InventoryMovementReason
WHERE INVMR_name = N'PURCHASE_RECEIPT';


SELECT
    @INVMV_INVMR_sale_id = INVMR_id
FROM inventory.InventoryMovementReason
WHERE INVMR_name = N'SALE';


SELECT
    @INVMV_INVMR_customer_return_id = INVMR_id
FROM inventory.InventoryMovementReason
WHERE INVMR_name = N'CUSTOMER_RETURN';


SELECT
    @INVMV_INVMR_damaged_in_transit_id = INVMR_id
FROM inventory.InventoryMovementReason
WHERE INVMR_name = N'DAMAGED_IN_TRANSIT';


SELECT
    @INVMV_INVMR_damaged_internal_id = INVMR_id
FROM inventory.InventoryMovementReason
WHERE INVMR_name = N'DAMAGED_INTERNAL';


SELECT
    @INVMV_INVMR_loss_in_transit_id = INVMR_id
FROM inventory.InventoryMovementReason
WHERE INVMR_name = N'LOSS_IN_TRANSIT';


SELECT
    @INVMV_INVMR_loss_internal_id = INVMR_id
FROM inventory.InventoryMovementReason
WHERE INVMR_name = N'LOSS_INTERNAL';


SELECT
    @INVMV_INVMR_found_internal_id = INVMR_id
FROM inventory.InventoryMovementReason
WHERE INVMR_name = N'FOUND_INTERNAL';


SELECT
    @INVMV_INVMR_inventory_adjustment_in_id = INVMR_id
FROM inventory.InventoryMovementReason
WHERE INVMR_name = N'INVENTORY_ADJUSTMENT_IN';


SELECT
    @INVMV_INVMR_inventory_adjustment_out_id = INVMR_id
FROM inventory.InventoryMovementReason
WHERE INVMR_name = N'INVENTORY_ADJUSTMENT_OUT';


IF @INVMV_INVMR_purchase_receipt_id IS NULL
OR @INVMV_INVMR_sale_id IS NULL
OR @INVMV_INVMR_customer_return_id IS NULL
OR @INVMV_INVMR_damaged_in_transit_id IS NULL
OR @INVMV_INVMR_damaged_internal_id IS NULL
OR @INVMV_INVMR_loss_in_transit_id IS NULL
OR @INVMV_INVMR_loss_internal_id IS NULL
OR @INVMV_INVMR_found_internal_id IS NULL
OR @INVMV_INVMR_inventory_adjustment_in_id IS NULL
OR @INVMV_INVMR_inventory_adjustment_out_id IS NULL
BEGIN

    ;THROW 50641,
        N'inventory.InventoryMovement data deployment requires all controlled InventoryMovementReason records.',
        1;

END;


/*==============================================================================
    PRODUCT VARIANT SOURCE
==============================================================================*/

DECLARE @INVMV_variants TABLE
(
    VariantNumber int           NOT NULL PRIMARY KEY,
    PRDVA_id      int           NOT NULL UNIQUE,
    PRDVA_sku     nvarchar(100) NOT NULL
);


INSERT INTO @INVMV_variants
(
    VariantNumber,
    PRDVA_id,
    PRDVA_sku
)
SELECT
    ROW_NUMBER() OVER
    (
        ORDER BY
            V.PRDVA_sku,
            V.PRDVA_id
    ),
    V.PRDVA_id,
    V.PRDVA_sku
FROM catalog.ProductVariant AS V

INNER JOIN inventory.Inventory AS I
    ON I.INV_PRDVA_id = V.PRDVA_id

WHERE V.PRDVA_is_active = 1;


/*==============================================================================
    SOURCE DATA
==============================================================================*/

DECLARE @INVMV_source TABLE
(
    INVMV_PRDVA_id              int          NOT NULL,
    INVMV_INVMR_id              smallint     NOT NULL,

    INVMV_TRNIT_id              bigint       NULL,
    INVMV_TRNIT_transaction_at  datetime2(0) NULL,

    INVMV_quantity              int          NOT NULL,
    INVMV_movement_at           datetime2(0) NOT NULL,

    INVMV_created_at            datetime2(0) NOT NULL,
    INVMV_updated_at            datetime2(0) NOT NULL
);


/*==============================================================================
    SALE MOVEMENTS
==============================================================================*/

INSERT INTO @INVMV_source
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    I.TRNIT_PRDVA_id,
    @INVMV_INVMR_sale_id,

    I.TRNIT_id,
    I.TRNIT_transaction_at,

    -I.TRNIT_quantity,

    DATEADD
    (
        MINUTE,
        15,
        I.TRNIT_transaction_at
    ),

    DATEADD
    (
        MINUTE,
        15,
        I.TRNIT_transaction_at
    ),

    DATEADD
    (
        MINUTE,
        15,
        I.TRNIT_transaction_at
    )

FROM sales.TransactionItem AS I

INNER JOIN sales.[Transaction] AS T
    ON  T.TRN_id = I.TRNIT_TRN_id
    AND T.TRN_transaction_at = I.TRNIT_transaction_at

INNER JOIN sales.TransactionStatus AS S
    ON S.TRNST_id = T.TRN_TRNST_id

WHERE S.TRNST_code IN
(
    'CONFIRMED',
    'COMPLETED'
);


/*==============================================================================
    CUSTOMER RETURN MOVEMENTS
==============================================================================*/

INSERT INTO @INVMV_source
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    I.TRNIT_PRDVA_id,
    @INVMV_INVMR_customer_return_id,

    I.TRNIT_id,
    I.TRNIT_transaction_at,

    I.TRNIT_quantity,

    DATEADD
    (
        DAY,
        7,
        I.TRNIT_transaction_at
    ),

    DATEADD
    (
        DAY,
        7,
        I.TRNIT_transaction_at
    ),

    DATEADD
    (
        DAY,
        7,
        I.TRNIT_transaction_at
    )

FROM sales.TransactionItem AS I

INNER JOIN sales.[Transaction] AS T
    ON  T.TRN_id = I.TRNIT_TRN_id
    AND T.TRN_transaction_at = I.TRNIT_transaction_at

INNER JOIN sales.TransactionStatus AS S
    ON S.TRNST_id = T.TRN_TRNST_id

WHERE S.TRNST_code = 'COMPLETED'

AND I.TRNIT_transaction_at <
        DATEADD
        (
            DAY,
            -7,
            DATEADD
            (
                DAY,
                1,
                CONVERT(datetime2(0), @INVMV_end_date)
            )
        )

AND
    ABS
    (
        CONVERT
        (
            bigint,
            CHECKSUM
            (
                I.TRNIT_id,
                I.TRNIT_transaction_at,
                701
            )
        )
    ) % 100 < 2;


/*==============================================================================
    DAMAGED IN TRANSIT
==============================================================================*/

INSERT INTO @INVMV_source
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    V.PRDVA_id,
    @INVMV_INVMR_damaged_in_transit_id,
    NULL,
    NULL,
    -1,

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 45, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 45, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 45, @INVMV_start_date)
        )
    )

FROM @INVMV_variants AS V

WHERE V.VariantNumber IN
(
    2,
    9
);


/*==============================================================================
    DAMAGED INTERNAL
==============================================================================*/

INSERT INTO @INVMV_source
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    V.PRDVA_id,
    @INVMV_INVMR_damaged_internal_id,
    NULL,
    NULL,
    -1,

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 90, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 90, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 90, @INVMV_start_date)
        )
    )

FROM @INVMV_variants AS V

WHERE V.VariantNumber IN
(
    4,
    12
);


/*==============================================================================
    LOSS IN TRANSIT
==============================================================================*/

INSERT INTO @INVMV_source
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    V.PRDVA_id,
    @INVMV_INVMR_loss_in_transit_id,
    NULL,
    NULL,
    -1,

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 135, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 135, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 135, @INVMV_start_date)
        )
    )

FROM @INVMV_variants AS V

WHERE V.VariantNumber IN
(
    6,
    14
);


/*==============================================================================
    LOSS INTERNAL
==============================================================================*/

INSERT INTO @INVMV_source
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    V.PRDVA_id,
    @INVMV_INVMR_loss_internal_id,
    NULL,
    NULL,
    -1,

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 180, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 180, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 180, @INVMV_start_date)
        )
    )

FROM @INVMV_variants AS V

WHERE V.VariantNumber IN
(
    8,
    16
);


/*==============================================================================
    FOUND INTERNAL
==============================================================================*/

INSERT INTO @INVMV_source
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    V.PRDVA_id,
    @INVMV_INVMR_found_internal_id,
    NULL,
    NULL,
    1,

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 225, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 225, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 225, @INVMV_start_date)
        )
    )

FROM @INVMV_variants AS V

WHERE V.VariantNumber IN
(
    3,
    11
);


/*==============================================================================
    INVENTORY ADJUSTMENT IN
==============================================================================*/

INSERT INTO @INVMV_source
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    V.PRDVA_id,
    @INVMV_INVMR_inventory_adjustment_in_id,
    NULL,
    NULL,
    2,

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 270, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 270, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 270, @INVMV_start_date)
        )
    )

FROM @INVMV_variants AS V

WHERE V.VariantNumber IN
(
    5,
    13
);


/*==============================================================================
    INVENTORY ADJUSTMENT OUT
==============================================================================*/

INSERT INTO @INVMV_source
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    V.PRDVA_id,
    @INVMV_INVMR_inventory_adjustment_out_id,
    NULL,
    NULL,
    -1,

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 315, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 315, @INVMV_start_date)
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            DATEADD(DAY, 315, @INVMV_start_date)
        )
    )

FROM @INVMV_variants AS V

WHERE V.VariantNumber IN
(
    7,
    15
);


/*==============================================================================
    PURCHASE RECEIPT
==============================================================================*/

;WITH MovementBalance AS
(
    SELECT
        S.INVMV_PRDVA_id,
        SUM(S.INVMV_quantity) AS GeneratedMovementBalance

    FROM @INVMV_source AS S

    GROUP BY
        S.INVMV_PRDVA_id
)
INSERT INTO @INVMV_source
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    I.INV_PRDVA_id,
    @INVMV_INVMR_purchase_receipt_id,

    NULL,
    NULL,

    I.INV_quantity_on_hand
        - COALESCE
          (
              B.GeneratedMovementBalance,
              0
          ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            @INVMV_start_date
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            @INVMV_start_date
        )
    ),

    DATEADD
    (
        SECOND,
        V.VariantNumber,
        CONVERT
        (
            datetime2(0),
            @INVMV_start_date
        )
    )

FROM inventory.Inventory AS I

INNER JOIN @INVMV_variants AS V
    ON V.PRDVA_id = I.INV_PRDVA_id

LEFT JOIN MovementBalance AS B
    ON B.INVMV_PRDVA_id = I.INV_PRDVA_id;


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

SELECT
    @INVMV_rows_processed = COUNT(*)
FROM @INVMV_source;


IF @INVMV_rows_processed = 0
BEGIN

    ;THROW 50642,
        N'inventory.InventoryMovement source data did not generate any rows.',
        1;

END;


/*------------------------------------------------------------------------------
    ZERO QUANTITY
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVMV_source AS S
    WHERE S.INVMV_quantity = 0
)
BEGIN

    ;THROW 50643,
        N'inventory.InventoryMovement source data contains a zero-quantity movement.',
        1;

END;


/*------------------------------------------------------------------------------
    TRANSACTION ITEM REFERENCE PAIR
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVMV_source AS S

    WHERE
        (
            S.INVMV_TRNIT_id IS NULL
            AND S.INVMV_TRNIT_transaction_at IS NOT NULL
        )
       OR
        (
            S.INVMV_TRNIT_id IS NOT NULL
            AND S.INVMV_TRNIT_transaction_at IS NULL
        )
)
BEGIN

    ;THROW 50644,
        N'inventory.InventoryMovement source data contains an incomplete TransactionItem reference.',
        1;

END;


/*------------------------------------------------------------------------------
    MOVEMENT DIRECTION
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVMV_source AS S

    WHERE
        (
            S.INVMV_INVMR_id IN
            (
                @INVMV_INVMR_purchase_receipt_id,
                @INVMV_INVMR_customer_return_id,
                @INVMV_INVMR_found_internal_id,
                @INVMV_INVMR_inventory_adjustment_in_id
            )
            AND S.INVMV_quantity <= 0
        )

        OR

        (
            S.INVMV_INVMR_id IN
            (
                @INVMV_INVMR_sale_id,
                @INVMV_INVMR_damaged_in_transit_id,
                @INVMV_INVMR_damaged_internal_id,
                @INVMV_INVMR_loss_in_transit_id,
                @INVMV_INVMR_loss_internal_id,
                @INVMV_INVMR_inventory_adjustment_out_id
            )
            AND S.INVMV_quantity >= 0
        )
)
BEGIN

    ;THROW 50645,
        N'inventory.InventoryMovement source data contains a quantity sign inconsistent with its movement reason.',
        1;

END;


/*------------------------------------------------------------------------------
    COMMERCIAL REFERENCE REQUIREMENT
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVMV_source AS S

    WHERE S.INVMV_INVMR_id IN
          (
              @INVMV_INVMR_sale_id,
              @INVMV_INVMR_customer_return_id
          )

      AND
          (
              S.INVMV_TRNIT_id IS NULL
              OR S.INVMV_TRNIT_transaction_at IS NULL
          )
)
BEGIN

    ;THROW 50646,
        N'inventory.InventoryMovement commercial source data requires a complete TransactionItem reference.',
        1;

END;


/*------------------------------------------------------------------------------
    NON-COMMERCIAL REFERENCE REQUIREMENT
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVMV_source AS S

    WHERE S.INVMV_INVMR_id NOT IN
          (
              @INVMV_INVMR_sale_id,
              @INVMV_INVMR_customer_return_id
          )

      AND
          (
              S.INVMV_TRNIT_id IS NOT NULL
              OR S.INVMV_TRNIT_transaction_at IS NOT NULL
          )
)
BEGIN

    ;THROW 50647,
        N'inventory.InventoryMovement non-commercial source data contains an unexpected TransactionItem reference.',
        1;

END;


/*------------------------------------------------------------------------------
    TRANSACTION ITEM DEPENDENCY
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVMV_source AS S

    LEFT JOIN sales.TransactionItem AS I
        ON  I.TRNIT_id = S.INVMV_TRNIT_id
        AND I.TRNIT_transaction_at =
            S.INVMV_TRNIT_transaction_at

    WHERE S.INVMV_TRNIT_id IS NOT NULL
      AND I.TRNIT_id IS NULL
)
BEGIN

    ;THROW 50648,
        N'inventory.InventoryMovement source data references a TransactionItem that does not exist.',
        1;

END;


/*------------------------------------------------------------------------------
    PRODUCT VARIANT CONSISTENCY
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT 1
    FROM @INVMV_source AS S

    INNER JOIN sales.TransactionItem AS I
        ON  I.TRNIT_id = S.INVMV_TRNIT_id
        AND I.TRNIT_transaction_at =
            S.INVMV_TRNIT_transaction_at

    WHERE S.INVMV_TRNIT_id IS NOT NULL
      AND S.INVMV_PRDVA_id <> I.TRNIT_PRDVA_id
)
BEGIN

    ;THROW 50649,
        N'inventory.InventoryMovement source data contains a ProductVariant that does not match its TransactionItem.',
        1;

END;


/*------------------------------------------------------------------------------
    DUPLICATE SOURCE MOVEMENTS
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT
        S.INVMV_PRDVA_id,
        S.INVMV_INVMR_id,
        S.INVMV_TRNIT_id,
        S.INVMV_TRNIT_transaction_at,
        S.INVMV_quantity,
        S.INVMV_movement_at

    FROM @INVMV_source AS S

    GROUP BY
        S.INVMV_PRDVA_id,
        S.INVMV_INVMR_id,
        S.INVMV_TRNIT_id,
        S.INVMV_TRNIT_transaction_at,
        S.INVMV_quantity,
        S.INVMV_movement_at

    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50650,
        N'inventory.InventoryMovement source data contains duplicate movements.',
        1;

END;


/*==============================================================================
    INVENTORY RECONCILIATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM inventory.Inventory AS I

    LEFT JOIN
    (
        SELECT
            S.INVMV_PRDVA_id,
            SUM(S.INVMV_quantity) AS MovementBalance

        FROM @INVMV_source AS S

        GROUP BY
            S.INVMV_PRDVA_id
    ) AS M
        ON M.INVMV_PRDVA_id = I.INV_PRDVA_id

    WHERE COALESCE(M.MovementBalance, 0)
            <> I.INV_quantity_on_hand
)
BEGIN

    ;THROW 50651,
        N'inventory.InventoryMovement history does not reconcile with Inventory.INV_quantity_on_hand.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

INSERT INTO inventory.InventoryMovement
(
    INVMV_PRDVA_id,
    INVMV_INVMR_id,
    INVMV_TRNIT_id,
    INVMV_TRNIT_transaction_at,
    INVMV_quantity,
    INVMV_movement_at,
    INVMV_created_at,
    INVMV_updated_at
)
SELECT
    S.INVMV_PRDVA_id,
    S.INVMV_INVMR_id,
    S.INVMV_TRNIT_id,
    S.INVMV_TRNIT_transaction_at,
    S.INVMV_quantity,
    S.INVMV_movement_at,
    S.INVMV_created_at,
    S.INVMV_updated_at

FROM @INVMV_source AS S

WHERE NOT EXISTS
(
    SELECT 1
    FROM inventory.InventoryMovement AS M

    WHERE M.INVMV_PRDVA_id = S.INVMV_PRDVA_id
      AND M.INVMV_INVMR_id = S.INVMV_INVMR_id
      AND M.INVMV_quantity = S.INVMV_quantity
      AND M.INVMV_movement_at = S.INVMV_movement_at

      AND
      (
            M.INVMV_TRNIT_id = S.INVMV_TRNIT_id

            OR
            (
                M.INVMV_TRNIT_id IS NULL
                AND S.INVMV_TRNIT_id IS NULL
            )
      )

      AND
      (
            M.INVMV_TRNIT_transaction_at =
                S.INVMV_TRNIT_transaction_at

            OR
            (
                M.INVMV_TRNIT_transaction_at IS NULL
                AND S.INVMV_TRNIT_transaction_at IS NULL
            )
      )
);


SET @INVMV_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @INVMV_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT
      (
          nvarchar(20),
          @INVMV_rows_processed - @INVMV_rows_added
      );

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @INVMV_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';