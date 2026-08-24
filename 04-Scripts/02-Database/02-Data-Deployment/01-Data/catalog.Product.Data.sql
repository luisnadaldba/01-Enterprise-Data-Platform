/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : catalog.Product
    Type        : Catalog / Sample Data
    Prefix      : PRD
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the commercial products used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only products that do not already exist.
    - Existing products are preserved without modification.
    - No automatic UPDATE is performed.
    - PRD_BRD_id + PRD_name are used to identify an existing product.
    - Brand dependencies are resolved by brand name.
    - Data is deployed using grouped set-based operations.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● catalog.Product';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @PRD_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @PRD_rows_added     int = 0;
DECLARE @PRD_rows_processed int = 0;

DECLARE @PRD_BRD_id smallint;

DECLARE @PRD_source TABLE
(
    PRD_name nvarchar(200) NOT NULL PRIMARY KEY
);


/*==============================================================================
    AURORA BEAUTY
==============================================================================*/

SET @PRD_BRD_id = NULL;

SELECT
    @PRD_BRD_id = BRD_id
FROM catalog.Brand
WHERE BRD_name = N'Aurora Beauty';


IF @PRD_BRD_id IS NULL
BEGIN

    ;THROW 50460,
        N'catalog.Product data deployment requires brand Aurora Beauty.',
        1;

END;


DELETE FROM @PRD_source;

INSERT INTO @PRD_source
(
    PRD_name
)
VALUES
    (N'Blush'),
    (N'Eyeshadow'),
    (N'Lipstick'),
    (N'Mascara');


SELECT
    @PRD_rows_processed =
        @PRD_rows_processed + COUNT(*)
FROM @PRD_source;


INSERT INTO catalog.Product
(
    PRD_BRD_id,
    PRD_name,
    PRD_is_active,
    PRD_created_at,
    PRD_updated_at
)
SELECT
    @PRD_BRD_id,
    S.PRD_name,
    1,
    @PRD_data_timestamp,
    @PRD_data_timestamp
FROM @PRD_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.Product AS P
    WHERE P.PRD_BRD_id = @PRD_BRD_id
      AND P.PRD_name = S.PRD_name
);


SET @PRD_rows_added =
    @PRD_rows_added + @@ROWCOUNT;


/*==============================================================================
    BELLAVIE
==============================================================================*/

SET @PRD_BRD_id = NULL;

SELECT
    @PRD_BRD_id = BRD_id
FROM catalog.Brand
WHERE BRD_name = N'Bellavie';


IF @PRD_BRD_id IS NULL
BEGIN

    ;THROW 50461,
        N'catalog.Product data deployment requires brand Bellavie.',
        1;

END;


DELETE FROM @PRD_source;

INSERT INTO @PRD_source
(
    PRD_name
)
VALUES
    (N'Blush'),
    (N'Foundation'),
    (N'Lipstick');


SELECT
    @PRD_rows_processed =
        @PRD_rows_processed + COUNT(*)
FROM @PRD_source;


INSERT INTO catalog.Product
(
    PRD_BRD_id,
    PRD_name,
    PRD_is_active,
    PRD_created_at,
    PRD_updated_at
)
SELECT
    @PRD_BRD_id,
    S.PRD_name,
    1,
    @PRD_data_timestamp,
    @PRD_data_timestamp
FROM @PRD_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.Product AS P
    WHERE P.PRD_BRD_id = @PRD_BRD_id
      AND P.PRD_name = S.PRD_name
);


SET @PRD_rows_added =
    @PRD_rows_added + @@ROWCOUNT;


/*==============================================================================
    VELUNA
==============================================================================*/

SET @PRD_BRD_id = NULL;

SELECT
    @PRD_BRD_id = BRD_id
FROM catalog.Brand
WHERE BRD_name = N'Veluna';


IF @PRD_BRD_id IS NULL
BEGIN

    ;THROW 50462,
        N'catalog.Product data deployment requires brand Veluna.',
        1;

END;


DELETE FROM @PRD_source;

INSERT INTO @PRD_source
(
    PRD_name
)
VALUES
    (N'Eyeliner'),
    (N'Eyeshadow'),
    (N'Mascara');


SELECT
    @PRD_rows_processed =
        @PRD_rows_processed + COUNT(*)
FROM @PRD_source;


INSERT INTO catalog.Product
(
    PRD_BRD_id,
    PRD_name,
    PRD_is_active,
    PRD_created_at,
    PRD_updated_at
)
SELECT
    @PRD_BRD_id,
    S.PRD_name,
    1,
    @PRD_data_timestamp,
    @PRD_data_timestamp
FROM @PRD_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.Product AS P
    WHERE P.PRD_BRD_id = @PRD_BRD_id
      AND P.PRD_name = S.PRD_name
);


SET @PRD_rows_added =
    @PRD_rows_added + @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @PRD_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @PRD_rows_processed - @PRD_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @PRD_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';