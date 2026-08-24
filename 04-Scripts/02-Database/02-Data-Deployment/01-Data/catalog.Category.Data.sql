/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : catalog.Category
    Type        : Catalog / Sample Data
    Prefix      : CTG
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the hierarchical categories used by the AtlasCommerce sample
    data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only categories that do not already exist.
    - Existing categories are preserved without modification.
    - No automatic UPDATE is performed.
    - CTG_CTG_id + CTG_name are used to identify an existing category.
    - Root categories are deployed before their child categories.
    - Parent category dependencies are resolved by category name.
    - Data is deployed using grouped set-based operations.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● catalog.Category';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @CTG_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @CTG_rows_added     int = 0;
DECLARE @CTG_rows_processed int = 0;

DECLARE @CTG_parent_id smallint;

DECLARE @CTG_source TABLE
(
    CTG_name nvarchar(150) NOT NULL PRIMARY KEY
);


/*==============================================================================
    ROOT CATEGORIES
==============================================================================*/

DELETE FROM @CTG_source;

INSERT INTO @CTG_source
(
    CTG_name
)
VALUES
    (N'Makeup');


SELECT
    @CTG_rows_processed =
        @CTG_rows_processed + COUNT(*)
FROM @CTG_source;


INSERT INTO catalog.Category
(
    CTG_CTG_id,
    CTG_name,
    CTG_is_active,
    CTG_created_at,
    CTG_updated_at
)
SELECT
    NULL,
    S.CTG_name,
    1,
    @CTG_data_timestamp,
    @CTG_data_timestamp
FROM @CTG_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.Category AS C
    WHERE C.CTG_CTG_id IS NULL
      AND C.CTG_name = S.CTG_name
);


SET @CTG_rows_added =
    @CTG_rows_added + @@ROWCOUNT;


/*==============================================================================
    MAKEUP
==============================================================================*/

SET @CTG_parent_id = NULL;

SELECT
    @CTG_parent_id = CTG_id
FROM catalog.Category
WHERE CTG_CTG_id IS NULL
  AND CTG_name = N'Makeup';


IF @CTG_parent_id IS NULL
BEGIN

    ;THROW 50450,
        N'catalog.Category data deployment requires root category Makeup.',
        1;

END;


DELETE FROM @CTG_source;

INSERT INTO @CTG_source
(
    CTG_name
)
VALUES
    (N'Eyes'),
    (N'Face'),
    (N'Lips');


SELECT
    @CTG_rows_processed =
        @CTG_rows_processed + COUNT(*)
FROM @CTG_source;


INSERT INTO catalog.Category
(
    CTG_CTG_id,
    CTG_name,
    CTG_is_active,
    CTG_created_at,
    CTG_updated_at
)
SELECT
    @CTG_parent_id,
    S.CTG_name,
    1,
    @CTG_data_timestamp,
    @CTG_data_timestamp
FROM @CTG_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.Category AS C
    WHERE C.CTG_CTG_id = @CTG_parent_id
      AND C.CTG_name = S.CTG_name
);


SET @CTG_rows_added =
    @CTG_rows_added + @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @CTG_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @CTG_rows_processed - @CTG_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @CTG_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';