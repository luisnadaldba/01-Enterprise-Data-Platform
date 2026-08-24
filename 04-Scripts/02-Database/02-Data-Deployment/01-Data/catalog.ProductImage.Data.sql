/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : catalog.ProductImage
    Type        : Catalog / Sample Data
    Prefix      : PRDIM
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the product image references used by the AtlasCommerce sample
    data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only product image references that do not already exist.
    - Existing product image references are preserved without modification.
    - No automatic UPDATE is performed.
    - PRDIM_PRD_id + PRDIM_path are used to identify an existing image.
    - Product dependencies are resolved by brand name and product name.
    - Source data is validated for duplicate image references.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● catalog.ProductImage';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @PRDIM_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @PRDIM_rows_added     int;
DECLARE @PRDIM_rows_processed int;

DECLARE @PRDIM_source TABLE
(
    BRD_name             nvarchar(150)  NOT NULL,
    PRD_name             nvarchar(200)  NOT NULL,
    PRDIM_path           nvarchar(1000) NOT NULL,
    PRDIM_display_order  smallint       NOT NULL,
    PRDIM_is_primary     bit            NOT NULL,
    PRDIM_is_active      bit            NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @PRDIM_source
(
    BRD_name,
    PRD_name,
    PRDIM_path,
    PRDIM_display_order,
    PRDIM_is_primary,
    PRDIM_is_active
)
VALUES
    (
        N'Aurora Beauty',
        N'Blush',
        N'/catalog/aurora-beauty/blush/main.webp',
        1,
        1,
        1
    ),
    (
        N'Aurora Beauty',
        N'Eyeshadow',
        N'/catalog/aurora-beauty/eyeshadow/main.webp',
        1,
        1,
        1
    ),
    (
        N'Aurora Beauty',
        N'Lipstick',
        N'/catalog/aurora-beauty/lipstick/main.webp',
        1,
        1,
        1
    ),
    (
        N'Aurora Beauty',
        N'Mascara',
        N'/catalog/aurora-beauty/mascara/main.webp',
        1,
        1,
        1
    ),

    (
        N'Bellavie',
        N'Blush',
        N'/catalog/bellavie/blush/main.webp',
        1,
        1,
        1
    ),
    (
        N'Bellavie',
        N'Foundation',
        N'/catalog/bellavie/foundation/main.webp',
        1,
        1,
        1
    ),
    (
        N'Bellavie',
        N'Lipstick',
        N'/catalog/bellavie/lipstick/main.webp',
        1,
        1,
        1
    ),

    (
        N'Veluna',
        N'Eyeliner',
        N'/catalog/veluna/eyeliner/main.webp',
        1,
        1,
        1
    ),
    (
        N'Veluna',
        N'Eyeshadow',
        N'/catalog/veluna/eyeshadow/main.webp',
        1,
        1,
        1
    ),
    (
        N'Veluna',
        N'Mascara',
        N'/catalog/veluna/mascara/main.webp',
        1,
        1,
        1
    );


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT
        S.BRD_name,
        S.PRD_name,
        S.PRDIM_path
    FROM @PRDIM_source AS S
    GROUP BY
        S.BRD_name,
        S.PRD_name,
        S.PRDIM_path
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50490,
        N'catalog.ProductImage source data contains duplicate image references.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PRDIM_source AS S
    WHERE S.PRDIM_display_order < 1
)
BEGIN

    ;THROW 50491,
        N'catalog.ProductImage source data contains an invalid display order.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PRDIM_source AS S
    WHERE LEN(LTRIM(RTRIM(S.PRDIM_path))) = 0
)
BEGIN

    ;THROW 50492,
        N'catalog.ProductImage source data contains an empty image path.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PRDIM_source AS S
    WHERE S.PRDIM_is_primary = 1
      AND S.PRDIM_is_active = 0
)
BEGIN

    ;THROW 50493,
        N'catalog.ProductImage source data contains an inactive primary image.',
        1;

END;


IF EXISTS
(
    SELECT
        S.BRD_name,
        S.PRD_name
    FROM @PRDIM_source AS S
    WHERE S.PRDIM_is_primary = 1
    GROUP BY
        S.BRD_name,
        S.PRD_name
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50494,
        N'catalog.ProductImage source data contains multiple primary images for the same product.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @PRDIM_source AS S

    LEFT JOIN catalog.Brand AS B
        ON B.BRD_name = S.BRD_name

    LEFT JOIN catalog.Product AS P
        ON  P.PRD_BRD_id = B.BRD_id
        AND P.PRD_name = S.PRD_name

    WHERE P.PRD_id IS NULL
)
BEGIN

    ;THROW 50495,
        N'catalog.ProductImage data deployment requires all referenced Product records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @PRDIM_rows_processed = COUNT(*)
FROM @PRDIM_source;


INSERT INTO catalog.ProductImage
(
    PRDIM_PRD_id,
    PRDIM_path,
    PRDIM_display_order,
    PRDIM_is_primary,
    PRDIM_is_active,
    PRDIM_created_at,
    PRDIM_updated_at
)
SELECT
    P.PRD_id,
    S.PRDIM_path,
    S.PRDIM_display_order,
    S.PRDIM_is_primary,
    S.PRDIM_is_active,
    @PRDIM_data_timestamp,
    @PRDIM_data_timestamp
FROM @PRDIM_source AS S

INNER JOIN catalog.Brand AS B
    ON B.BRD_name = S.BRD_name

INNER JOIN catalog.Product AS P
    ON  P.PRD_BRD_id = B.BRD_id
    AND P.PRD_name = S.PRD_name

WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.ProductImage AS I
    WHERE I.PRDIM_PRD_id = P.PRD_id
      AND I.PRDIM_path = S.PRDIM_path
);


SET @PRDIM_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @PRDIM_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @PRDIM_rows_processed - @PRDIM_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @PRDIM_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';