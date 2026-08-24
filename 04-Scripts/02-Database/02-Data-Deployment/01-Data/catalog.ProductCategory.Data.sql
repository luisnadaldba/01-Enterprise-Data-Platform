/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : catalog.ProductCategory
    Type        : Catalog / Sample Data
    Prefix      : PRDCT
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the relationships between products and catalog categories used
    by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only product-category relationships that do not already exist.
    - Existing product-category relationships are preserved without modification.
    - No automatic UPDATE is performed.
    - PRDCT_PRD_id + PRDCT_CTG_id identify an existing relationship.
    - Product dependencies are resolved by brand name and product name.
    - Category dependencies are resolved by category name.
    - Products are associated with their specific child category.
    - Parent category relationships are derived from the category hierarchy
      and are not redundantly persisted.
    - Source data is validated for duplicate relationships before deployment.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● catalog.ProductCategory';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @PRDCT_rows_added     int;
DECLARE @PRDCT_rows_processed int;

DECLARE @PRDCT_source TABLE
(
    BRD_name nvarchar(150) NOT NULL,
    PRD_name nvarchar(200) NOT NULL,
    CTG_name nvarchar(150) NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @PRDCT_source
(
    BRD_name,
    PRD_name,
    CTG_name
)
VALUES
    (N'Aurora Beauty', N'Blush',      N'Face'),
    (N'Aurora Beauty', N'Eyeshadow',  N'Eyes'),
    (N'Aurora Beauty', N'Lipstick',   N'Lips'),
    (N'Aurora Beauty', N'Mascara',    N'Eyes'),

    (N'Bellavie',      N'Blush',      N'Face'),
    (N'Bellavie',      N'Foundation', N'Face'),
    (N'Bellavie',      N'Lipstick',   N'Lips'),

    (N'Veluna',        N'Eyeliner',   N'Eyes'),
    (N'Veluna',        N'Eyeshadow',  N'Eyes'),
    (N'Veluna',        N'Mascara',    N'Eyes');


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT
        S.BRD_name,
        S.PRD_name,
        S.CTG_name
    FROM @PRDCT_source AS S
    GROUP BY
        S.BRD_name,
        S.PRD_name,
        S.CTG_name
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50479,
        N'catalog.ProductCategory source data contains duplicate relationships.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @PRDCT_source AS S

    LEFT JOIN catalog.Brand AS B
        ON B.BRD_name = S.BRD_name

    LEFT JOIN catalog.Product AS P
        ON  P.PRD_BRD_id = B.BRD_id
        AND P.PRD_name = S.PRD_name

    WHERE P.PRD_id IS NULL
)
BEGIN

    ;THROW 50480,
        N'catalog.ProductCategory data deployment requires all referenced Product records.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @PRDCT_source AS S

    LEFT JOIN catalog.Category AS C
        ON C.CTG_name = S.CTG_name

    WHERE C.CTG_id IS NULL
)
BEGIN

    ;THROW 50481,
        N'catalog.ProductCategory data deployment requires all referenced Category records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @PRDCT_rows_processed = COUNT(*)
FROM @PRDCT_source;


INSERT INTO catalog.ProductCategory
(
    PRDCT_PRD_id,
    PRDCT_CTG_id
)
SELECT
    P.PRD_id,
    C.CTG_id
FROM @PRDCT_source AS S

INNER JOIN catalog.Brand AS B
    ON B.BRD_name = S.BRD_name

INNER JOIN catalog.Product AS P
    ON  P.PRD_BRD_id = B.BRD_id
    AND P.PRD_name = S.PRD_name

INNER JOIN catalog.Category AS C
    ON C.CTG_name = S.CTG_name

WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.ProductCategory AS PC
    WHERE PC.PRDCT_PRD_id = P.PRD_id
      AND PC.PRDCT_CTG_id = C.CTG_id
);


SET @PRDCT_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @PRDCT_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @PRDCT_rows_processed - @PRDCT_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @PRDCT_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';