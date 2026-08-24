/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : catalog.ProductAttribute
    Type        : Catalog / Sample Data
    Prefix      : PAT
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the product attributes used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only product attributes that do not already exist.
    - Existing product attributes are preserved without modification.
    - No automatic UPDATE is performed.
    - PAT_name is used to identify an existing product attribute.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● catalog.ProductAttribute';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @PAT_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @PAT_rows_added     int;
DECLARE @PAT_rows_processed int;

DECLARE @PAT_source TABLE
(
    PAT_name      nvarchar(100) NOT NULL PRIMARY KEY,
    PAT_is_active bit           NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @PAT_source
(
    PAT_name,
    PAT_is_active
)
VALUES
    (N'COLOR',  1),
    (N'SHADE',  1),
    (N'SIZE',   1),
    (N'VOLUME', 1);


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @PAT_rows_processed = COUNT(*)
FROM @PAT_source;


INSERT INTO catalog.ProductAttribute
(
    PAT_name,
    PAT_is_active,
    PAT_created_at,
    PAT_updated_at
)
SELECT
    S.PAT_name,
    S.PAT_is_active,
    @PAT_data_timestamp,
    @PAT_data_timestamp
FROM @PAT_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.ProductAttribute AS P
    WHERE P.PAT_name = S.PAT_name
);


SET @PAT_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @PAT_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @PAT_rows_processed - @PAT_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @PAT_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';