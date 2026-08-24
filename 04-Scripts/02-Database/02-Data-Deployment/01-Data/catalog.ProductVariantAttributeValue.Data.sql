/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : catalog.ProductVariantAttributeValue
    Type        : Catalog / Sample Data
    Prefix      : PRDAV
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the relationships between product variants and controlled
    product attribute values used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only variant-attribute-value relationships that do not already exist.
    - Existing relationships are preserved without modification.
    - No automatic UPDATE is performed.
    - PRDAV_PRDVA_id + PRDAV_PATVL_id identify an existing relationship.
    - ProductVariant dependencies are resolved by SKU.
    - ProductAttributeValue dependencies are resolved by attribute name and value.
    - Source data is validated for duplicate relationships.
    - Source data is validated to prevent more than one value of the same
      attribute from being assigned to the same variant.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● catalog.ProductVariantAttributeValue';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @PRDAV_rows_added     int;
DECLARE @PRDAV_rows_processed int;

DECLARE @PRDAV_source TABLE
(
    PRDVA_sku    nvarchar(100) NOT NULL,
    PAT_name     nvarchar(100) NOT NULL,
    PATVL_value  nvarchar(100) NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @PRDAV_source
(
    PRDVA_sku,
    PAT_name,
    PATVL_value
)
VALUES
    (N'AB-BLUSH-001',      N'COLOR', N'PINK'),
    (N'AB-BLUSH-001',      N'SIZE',  N'SMALL'),
    (N'AB-BLUSH-002',      N'COLOR', N'RED'),
    (N'AB-BLUSH-002',      N'SIZE',  N'MEDIUM'),

    (N'AB-EYESHADOW-001',  N'COLOR', N'PINK'),
    (N'AB-EYESHADOW-001',  N'SIZE',  N'SMALL'),
    (N'AB-EYESHADOW-002',  N'COLOR', N'BLACK'),
    (N'AB-EYESHADOW-002',  N'SIZE',  N'MEDIUM'),

    (N'AB-LIPSTICK-001',   N'COLOR', N'PINK'),
    (N'AB-LIPSTICK-001',   N'SIZE',  N'SMALL'),
    (N'AB-LIPSTICK-002',   N'COLOR', N'RED'),
    (N'AB-LIPSTICK-002',   N'SIZE',  N'MEDIUM'),

    (N'AB-MASCARA-001',    N'COLOR', N'BLACK'),
    (N'AB-MASCARA-001',    N'SIZE',  N'MEDIUM'),

    (N'BV-BLUSH-001',      N'COLOR', N'PINK'),
    (N'BV-BLUSH-001',      N'SIZE',  N'SMALL'),
    (N'BV-BLUSH-002',      N'COLOR', N'RED'),
    (N'BV-BLUSH-002',      N'SIZE',  N'MEDIUM'),

    (N'BV-FOUNDATION-001', N'COLOR', N'PINK'),
    (N'BV-FOUNDATION-001', N'SIZE',  N'MEDIUM'),

    (N'BV-LIPSTICK-001',   N'COLOR', N'PINK'),
    (N'BV-LIPSTICK-001',   N'SIZE',  N'SMALL'),
    (N'BV-LIPSTICK-002',   N'COLOR', N'RED'),
    (N'BV-LIPSTICK-002',   N'SIZE',  N'MEDIUM'),

    (N'VL-EYELINER-001',   N'COLOR', N'BLACK'),
    (N'VL-EYELINER-001',   N'SIZE',  N'SMALL'),

    (N'VL-EYESHADOW-001',  N'COLOR', N'PINK'),
    (N'VL-EYESHADOW-001',  N'SIZE',  N'SMALL'),
    (N'VL-EYESHADOW-002',  N'COLOR', N'BLACK'),
    (N'VL-EYESHADOW-002',  N'SIZE',  N'MEDIUM'),

    (N'VL-MASCARA-001',    N'COLOR', N'BLACK'),
    (N'VL-MASCARA-001',    N'SIZE',  N'MEDIUM');


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT
        S.PRDVA_sku,
        S.PAT_name,
        S.PATVL_value
    FROM @PRDAV_source AS S
    GROUP BY
        S.PRDVA_sku,
        S.PAT_name,
        S.PATVL_value
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50510,
        N'catalog.ProductVariantAttributeValue source data contains duplicate relationships.',
        1;

END;


IF EXISTS
(
    SELECT
        S.PRDVA_sku,
        S.PAT_name
    FROM @PRDAV_source AS S
    GROUP BY
        S.PRDVA_sku,
        S.PAT_name
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50511,
        N'catalog.ProductVariantAttributeValue source data contains multiple values for the same attribute and product variant.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @PRDAV_source AS S

    LEFT JOIN catalog.ProductVariant AS V
        ON V.PRDVA_sku = S.PRDVA_sku

    WHERE V.PRDVA_id IS NULL
)
BEGIN

    ;THROW 50512,
        N'catalog.ProductVariantAttributeValue data deployment requires all referenced ProductVariant records.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PRDAV_source AS S

    LEFT JOIN catalog.ProductAttribute AS A
        ON A.PAT_name = S.PAT_name

    LEFT JOIN catalog.ProductAttributeValue AS AV
        ON  AV.PATVL_PAT_id = A.PAT_id
        AND AV.PATVL_value = S.PATVL_value

    WHERE AV.PATVL_id IS NULL
)
BEGIN

    ;THROW 50513,
        N'catalog.ProductVariantAttributeValue data deployment requires all referenced ProductAttributeValue records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @PRDAV_rows_processed = COUNT(*)
FROM @PRDAV_source;


INSERT INTO catalog.ProductVariantAttributeValue
(
    PRDAV_PRDVA_id,
    PRDAV_PATVL_id
)
SELECT
    V.PRDVA_id,
    AV.PATVL_id
FROM @PRDAV_source AS S

INNER JOIN catalog.ProductVariant AS V
    ON V.PRDVA_sku = S.PRDVA_sku

INNER JOIN catalog.ProductAttribute AS A
    ON A.PAT_name = S.PAT_name

INNER JOIN catalog.ProductAttributeValue AS AV
    ON  AV.PATVL_PAT_id = A.PAT_id
    AND AV.PATVL_value = S.PATVL_value

WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.ProductVariantAttributeValue AS VA
    WHERE VA.PRDAV_PRDVA_id = V.PRDVA_id
      AND VA.PRDAV_PATVL_id = AV.PATVL_id
);


SET @PRDAV_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @PRDAV_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @PRDAV_rows_processed - @PRDAV_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @PRDAV_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';