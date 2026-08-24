/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : catalog.ProductVariant
    Type        : Catalog / Sample Data
    Prefix      : PRDVA
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the sellable product variants used by the AtlasCommerce sample
    data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only product variants that do not already exist.
    - Existing product variants are preserved without modification.
    - No automatic UPDATE is performed.
    - PRDVA_sku is used to identify an existing product variant.
    - Product dependencies are resolved by brand name and product name.
    - Barcode remains optional and is not populated without a concrete
      external identification requirement.
    - Source data is validated for duplicate SKU values.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● catalog.ProductVariant';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @PRDVA_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @PRDVA_rows_added     int;
DECLARE @PRDVA_rows_processed int;

DECLARE @PRDVA_source TABLE
(
    BRD_name         nvarchar(150) NOT NULL,
    PRD_name         nvarchar(200) NOT NULL,
    PRDVA_sku        nvarchar(100) NOT NULL,
    PRDVA_barcode    nvarchar(50)  NULL,
    PRDVA_is_active  bit           NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @PRDVA_source
(
    BRD_name,
    PRD_name,
    PRDVA_sku,
    PRDVA_barcode,
    PRDVA_is_active
)
VALUES
    (N'Aurora Beauty', N'Blush',      N'AB-BLUSH-001',      NULL, 1),
    (N'Aurora Beauty', N'Blush',      N'AB-BLUSH-002',      NULL, 1),
    (N'Aurora Beauty', N'Eyeshadow',  N'AB-EYESHADOW-001',  NULL, 1),
    (N'Aurora Beauty', N'Eyeshadow',  N'AB-EYESHADOW-002',  NULL, 1),
    (N'Aurora Beauty', N'Lipstick',   N'AB-LIPSTICK-001',   NULL, 1),
    (N'Aurora Beauty', N'Lipstick',   N'AB-LIPSTICK-002',   NULL, 1),
    (N'Aurora Beauty', N'Mascara',    N'AB-MASCARA-001',    NULL, 1),

    (N'Bellavie',      N'Blush',      N'BV-BLUSH-001',      NULL, 1),
    (N'Bellavie',      N'Blush',      N'BV-BLUSH-002',      NULL, 1),
    (N'Bellavie',      N'Foundation', N'BV-FOUNDATION-001', NULL, 1),
    (N'Bellavie',      N'Lipstick',   N'BV-LIPSTICK-001',   NULL, 1),
    (N'Bellavie',      N'Lipstick',   N'BV-LIPSTICK-002',   NULL, 1),

    (N'Veluna',        N'Eyeliner',   N'VL-EYELINER-001',   NULL, 1),
    (N'Veluna',        N'Eyeshadow',  N'VL-EYESHADOW-001',  NULL, 1),
    (N'Veluna',        N'Eyeshadow',  N'VL-EYESHADOW-002',  NULL, 1),
    (N'Veluna',        N'Mascara',    N'VL-MASCARA-001',    NULL, 1);


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT
        S.PRDVA_sku
    FROM @PRDVA_source AS S
    GROUP BY
        S.PRDVA_sku
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50500,
        N'catalog.ProductVariant source data contains duplicate SKU values.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PRDVA_source AS S
    WHERE LEN(LTRIM(RTRIM(S.PRDVA_sku))) = 0
)
BEGIN

    ;THROW 50501,
        N'catalog.ProductVariant source data contains an empty SKU.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @PRDVA_source AS S

    LEFT JOIN catalog.Brand AS B
        ON B.BRD_name = S.BRD_name

    LEFT JOIN catalog.Product AS P
        ON  P.PRD_BRD_id = B.BRD_id
        AND P.PRD_name = S.PRD_name

    WHERE P.PRD_id IS NULL
)
BEGIN

    ;THROW 50502,
        N'catalog.ProductVariant data deployment requires all referenced Product records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @PRDVA_rows_processed = COUNT(*)
FROM @PRDVA_source;


INSERT INTO catalog.ProductVariant
(
    PRDVA_PRD_id,
    PRDVA_sku,
    PRDVA_barcode,
    PRDVA_is_active,
    PRDVA_created_at,
    PRDVA_updated_at
)
SELECT
    P.PRD_id,
    S.PRDVA_sku,
    S.PRDVA_barcode,
    S.PRDVA_is_active,
    @PRDVA_data_timestamp,
    @PRDVA_data_timestamp
FROM @PRDVA_source AS S

INNER JOIN catalog.Brand AS B
    ON B.BRD_name = S.BRD_name

INNER JOIN catalog.Product AS P
    ON  P.PRD_BRD_id = B.BRD_id
    AND P.PRD_name = S.PRD_name

WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.ProductVariant AS V
    WHERE V.PRDVA_sku = S.PRDVA_sku
);


SET @PRDVA_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @PRDVA_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @PRDVA_rows_processed - @PRDVA_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @PRDVA_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';