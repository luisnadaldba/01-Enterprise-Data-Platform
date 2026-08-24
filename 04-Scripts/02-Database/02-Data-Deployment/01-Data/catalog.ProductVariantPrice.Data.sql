/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : catalog.ProductVariantPrice
    Type        : Catalog / Sample Data
    Prefix      : PRDVP
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the commercial prices associated with sellable product variants
    used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only product variant price periods that do not already exist.
    - Existing price periods are preserved without modification.
    - No automatic UPDATE is performed.
    - PRDVP_PRDVA_id + PRDVP_valid_from identify an existing price period.
    - ProductVariant dependencies are resolved by SKU.
    - Price values must be greater than zero.
    - Validity periods must have a valid temporal range.
    - Only one open-ended price period is allowed per ProductVariant.
    - Source data is validated for duplicate and overlapping price periods.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● catalog.ProductVariantPrice';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @PRDVP_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @PRDVP_rows_added     int;
DECLARE @PRDVP_rows_processed int;

DECLARE @PRDVP_source TABLE
(
    PRDVA_sku         nvarchar(100) NOT NULL,
    PRDVP_price       decimal(19,2) NOT NULL,
    PRDVP_valid_from  datetime2(0)  NOT NULL,
    PRDVP_valid_to    datetime2(0)  NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @PRDVP_source
(
    PRDVA_sku,
    PRDVP_price,
    PRDVP_valid_from,
    PRDVP_valid_to
)
VALUES
    (N'AB-BLUSH-001',      49.90, '2026-01-01T00:00:00', NULL),
    (N'AB-BLUSH-002',      54.90, '2026-01-01T00:00:00', NULL),

    (N'AB-EYESHADOW-001',  59.90, '2026-01-01T00:00:00', NULL),
    (N'AB-EYESHADOW-002',  64.90, '2026-01-01T00:00:00', NULL),

    (N'AB-LIPSTICK-001',   39.90, '2026-01-01T00:00:00', NULL),
    (N'AB-LIPSTICK-002',   44.90, '2026-01-01T00:00:00', NULL),

    (N'AB-MASCARA-001',    52.90, '2026-01-01T00:00:00', NULL),

    (N'BV-BLUSH-001',      47.90, '2026-01-01T00:00:00', NULL),
    (N'BV-BLUSH-002',      51.90, '2026-01-01T00:00:00', NULL),

    (N'BV-FOUNDATION-001', 69.90, '2026-01-01T00:00:00', NULL),

    (N'BV-LIPSTICK-001',   37.90, '2026-01-01T00:00:00', NULL),
    (N'BV-LIPSTICK-002',   42.90, '2026-01-01T00:00:00', NULL),

    (N'VL-EYELINER-001',   34.90, '2026-01-01T00:00:00', NULL),

    (N'VL-EYESHADOW-001',  57.90, '2026-01-01T00:00:00', NULL),
    (N'VL-EYESHADOW-002',  62.90, '2026-01-01T00:00:00', NULL),

    (N'VL-MASCARA-001',    49.90, '2026-01-01T00:00:00', NULL);


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT
        S.PRDVA_sku,
        S.PRDVP_valid_from
    FROM @PRDVP_source AS S
    GROUP BY
        S.PRDVA_sku,
        S.PRDVP_valid_from
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50520,
        N'catalog.ProductVariantPrice source data contains duplicate price periods.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PRDVP_source AS S
    WHERE S.PRDVP_price <= 0.00
)
BEGIN

    ;THROW 50521,
        N'catalog.ProductVariantPrice source data contains a price that is not greater than zero.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PRDVP_source AS S
    WHERE S.PRDVP_valid_to IS NOT NULL
      AND S.PRDVP_valid_to <= S.PRDVP_valid_from
)
BEGIN

    ;THROW 50522,
        N'catalog.ProductVariantPrice source data contains an invalid validity period.',
        1;

END;


IF EXISTS
(
    SELECT
        S.PRDVA_sku
    FROM @PRDVP_source AS S
    WHERE S.PRDVP_valid_to IS NULL
    GROUP BY
        S.PRDVA_sku
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50523,
        N'catalog.ProductVariantPrice source data contains multiple open-ended price periods for the same ProductVariant.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PRDVP_source AS A

    INNER JOIN @PRDVP_source AS B
        ON  B.PRDVA_sku = A.PRDVA_sku
        AND
        (
            B.PRDVP_valid_from > A.PRDVP_valid_from
            OR
            (
                B.PRDVP_valid_from = A.PRDVP_valid_from
                AND B.PRDVP_price > A.PRDVP_price
            )
        )

    WHERE
        (
            A.PRDVP_valid_to IS NULL
            OR B.PRDVP_valid_from < A.PRDVP_valid_to
        )
    AND
        (
            B.PRDVP_valid_to IS NULL
            OR A.PRDVP_valid_from < B.PRDVP_valid_to
        )
)
BEGIN

    ;THROW 50524,
        N'catalog.ProductVariantPrice source data contains overlapping price periods.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @PRDVP_source AS S

    LEFT JOIN catalog.ProductVariant AS V
        ON V.PRDVA_sku = S.PRDVA_sku

    WHERE V.PRDVA_id IS NULL
)
BEGIN

    ;THROW 50525,
        N'catalog.ProductVariantPrice data deployment requires all referenced ProductVariant records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @PRDVP_rows_processed = COUNT(*)
FROM @PRDVP_source;


INSERT INTO catalog.ProductVariantPrice
(
    PRDVP_PRDVA_id,
    PRDVP_price,
    PRDVP_valid_from,
    PRDVP_valid_to,
    PRDVP_created_at
)
SELECT
    V.PRDVA_id,
    S.PRDVP_price,
    S.PRDVP_valid_from,
    S.PRDVP_valid_to,
    @PRDVP_data_timestamp
FROM @PRDVP_source AS S

INNER JOIN catalog.ProductVariant AS V
    ON V.PRDVA_sku = S.PRDVA_sku

WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.ProductVariantPrice AS P
    WHERE P.PRDVP_PRDVA_id = V.PRDVA_id
      AND P.PRDVP_valid_from = S.PRDVP_valid_from
);


SET @PRDVP_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @PRDVP_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @PRDVP_rows_processed - @PRDVP_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @PRDVP_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';