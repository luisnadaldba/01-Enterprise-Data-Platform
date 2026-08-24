/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : inventory.InventoryMovementNote
    Type        : Inventory / Sample Data
    Prefix      : INVMN
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the optional operational notes associated with selected
    inventory movements in the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only inventory movement notes that do not already exist.
    - Existing inventory movement notes are preserved without modification.
    - No automatic UPDATE is performed.
    - InventoryMovement dependencies are resolved by ProductVariant SKU and
      controlled InventoryMovementReason name.
    - Notes are added only to selected exceptional operational movements.
    - Routine SALE and PURCHASE_RECEIPT movements are not populated with
      unnecessary notes.
    - Note text provides operational context without replacing the structured
      InventoryMovementReason classification.
    - Source data is validated for duplicate note definitions.
    - Each source definition must resolve to exactly one InventoryMovement.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● inventory.InventoryMovementNote';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @INVMN_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @INVMN_rows_added     int;
DECLARE @INVMN_rows_processed int;

DECLARE @INVMN_source TABLE
(
    PRDVA_sku  nvarchar(100)  NOT NULL,
    INVMR_name nvarchar(100)  NOT NULL,
    INVMN_note nvarchar(1000) NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @INVMN_source
(
    PRDVA_sku,
    INVMR_name,
    INVMN_note
)
VALUES
    (
        N'AB-BLUSH-002',
        N'DAMAGED_IN_TRANSIT',
        N'Packaging damage identified during receiving inspection.'
    ),
    (
        N'BV-BLUSH-002',
        N'DAMAGED_IN_TRANSIT',
        N'External packaging showed visible impact damage during receiving.'
    ),

    (
        N'AB-EYESHADOW-002',
        N'DAMAGED_INTERNAL',
        N'Product damaged during internal handling.'
    ),
    (
        N'BV-LIPSTICK-002',
        N'DAMAGED_INTERNAL',
        N'Unit removed from available inventory after internal handling damage.'
    ),

    (
        N'AB-LIPSTICK-002',
        N'LOSS_IN_TRANSIT',
        N'Unit reported missing during inbound transportation reconciliation.'
    ),
    (
        N'VL-EYESHADOW-001',
        N'LOSS_IN_TRANSIT',
        N'Inbound shipment reconciliation identified one missing unit.'
    ),

    (
        N'BV-BLUSH-001',
        N'LOSS_INTERNAL',
        N'Physical count identified one unit missing from internal inventory.'
    ),
    (
        N'VL-MASCARA-001',
        N'LOSS_INTERNAL',
        N'Internal inventory reconciliation confirmed one missing unit.'
    ),

    (
        N'AB-EYESHADOW-001',
        N'FOUND_INTERNAL',
        N'Previously unaccounted unit located during storage area inspection.'
    ),
    (
        N'BV-LIPSTICK-001',
        N'FOUND_INTERNAL',
        N'Unit located during physical inventory organization.'
    ),

    (
        N'AB-LIPSTICK-001',
        N'INVENTORY_ADJUSTMENT_IN',
        N'Positive adjustment recorded after physical inventory reconciliation.'
    ),
    (
        N'VL-EYELINER-001',
        N'INVENTORY_ADJUSTMENT_IN',
        N'Physical count exceeded the recorded inventory balance.'
    ),

    (
        N'AB-MASCARA-001',
        N'INVENTORY_ADJUSTMENT_OUT',
        N'Negative adjustment recorded after physical inventory reconciliation.'
    ),
    (
        N'VL-EYESHADOW-002',
        N'INVENTORY_ADJUSTMENT_OUT',
        N'Recorded inventory balance exceeded the confirmed physical count.'
    );


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT
        S.PRDVA_sku,
        S.INVMR_name,
        S.INVMN_note
    FROM @INVMN_source AS S
    GROUP BY
        S.PRDVA_sku,
        S.INVMR_name,
        S.INVMN_note
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50660,
        N'inventory.InventoryMovementNote source data contains duplicate note definitions.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @INVMN_source AS S
    WHERE LEN(LTRIM(RTRIM(S.INVMN_note))) = 0
)
BEGIN

    ;THROW 50661,
        N'inventory.InventoryMovementNote source data contains an empty note.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @INVMN_source AS S

    LEFT JOIN catalog.ProductVariant AS V
        ON V.PRDVA_sku = S.PRDVA_sku

    WHERE V.PRDVA_id IS NULL
)
BEGIN

    ;THROW 50662,
        N'inventory.InventoryMovementNote data deployment requires all referenced ProductVariant records.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @INVMN_source AS S

    LEFT JOIN inventory.InventoryMovementReason AS R
        ON R.INVMR_name = S.INVMR_name

    WHERE R.INVMR_id IS NULL
)
BEGIN

    ;THROW 50663,
        N'inventory.InventoryMovementNote data deployment requires all referenced InventoryMovementReason records.',
        1;

END;


/*------------------------------------------------------------------------------
    EACH SOURCE DEFINITION MUST RESOLVE TO EXACTLY ONE MOVEMENT
------------------------------------------------------------------------------*/

IF EXISTS
(
    SELECT
        S.PRDVA_sku,
        S.INVMR_name

    FROM @INVMN_source AS S

    INNER JOIN catalog.ProductVariant AS V
        ON V.PRDVA_sku = S.PRDVA_sku

    INNER JOIN inventory.InventoryMovementReason AS R
        ON R.INVMR_name = S.INVMR_name

    LEFT JOIN inventory.InventoryMovement AS M
        ON  M.INVMV_PRDVA_id = V.PRDVA_id
        AND M.INVMV_INVMR_id = R.INVMR_id

    GROUP BY
        S.PRDVA_sku,
        S.INVMR_name

    HAVING COUNT(M.INVMV_id) <> 1
)
BEGIN

    ;THROW 50664,
        N'inventory.InventoryMovementNote source data does not resolve to exactly one InventoryMovement.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @INVMN_rows_processed = COUNT(*)
FROM @INVMN_source;


INSERT INTO inventory.InventoryMovementNote
(
    INVMN_INVMV_id,
    INVMN_note,
    INVMN_created_at,
    INVMN_updated_at
)
SELECT
    M.INVMV_id,
    S.INVMN_note,
    @INVMN_data_timestamp,
    @INVMN_data_timestamp

FROM @INVMN_source AS S

INNER JOIN catalog.ProductVariant AS V
    ON V.PRDVA_sku = S.PRDVA_sku

INNER JOIN inventory.InventoryMovementReason AS R
    ON R.INVMR_name = S.INVMR_name

INNER JOIN inventory.InventoryMovement AS M
    ON  M.INVMV_PRDVA_id = V.PRDVA_id
    AND M.INVMV_INVMR_id = R.INVMR_id

WHERE NOT EXISTS
(
    SELECT 1
    FROM inventory.InventoryMovementNote AS N
    WHERE N.INVMN_INVMV_id = M.INVMV_id
      AND N.INVMN_note = S.INVMN_note
);


SET @INVMN_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @INVMN_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT
      (
          nvarchar(20),
          @INVMN_rows_processed - @INVMN_rows_added
      );

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @INVMN_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';