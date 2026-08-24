/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : catalog.ProductAttributeValue
    Type        : Catalog / Sample Data
    Prefix      : PATVL
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the controlled product attribute values used by the
    AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only product attribute values that do not already exist.
    - Existing product attribute values are preserved without modification.
    - No automatic UPDATE is performed.
    - PATVL_PAT_id + PATVL_value are used to identify an existing value.
    - ProductAttribute dependencies are resolved by attribute name.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● catalog.ProductAttributeValue';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @PATVL_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @PATVL_rows_added     int;
DECLARE @PATVL_rows_processed int;

DECLARE @PATVL_source TABLE
(
    PAT_name        nvarchar(100) NOT NULL,
    PATVL_value     nvarchar(100) NOT NULL,
    PATVL_is_active bit           NOT NULL,

    PRIMARY KEY
    (
        PAT_name,
        PATVL_value
    )
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @PATVL_source
(
    PAT_name,
    PATVL_value,
    PATVL_is_active
)
VALUES
    (N'COLOR', N'BLACK',  1),
    (N'COLOR', N'PINK',  1),
    (N'COLOR', N'RED',    1),
    (N'SIZE',  N'MEDIUM', 1),
    (N'SIZE',  N'SMALL',  1);


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @PATVL_source AS S

    LEFT JOIN catalog.ProductAttribute AS A
        ON A.PAT_name = S.PAT_name

    WHERE A.PAT_id IS NULL
)
BEGIN

    ;THROW 50470,
        N'catalog.ProductAttributeValue data deployment requires all referenced ProductAttribute records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @PATVL_rows_processed = COUNT(*)
FROM @PATVL_source;


INSERT INTO catalog.ProductAttributeValue
(
    PATVL_PAT_id,
    PATVL_value,
    PATVL_is_active,
    PATVL_created_at,
    PATVL_updated_at
)
SELECT
    A.PAT_id,
    S.PATVL_value,
    S.PATVL_is_active,
    @PATVL_data_timestamp,
    @PATVL_data_timestamp
FROM @PATVL_source AS S

INNER JOIN catalog.ProductAttribute AS A
    ON A.PAT_name = S.PAT_name

WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.ProductAttributeValue AS V
    WHERE V.PATVL_PAT_id = A.PAT_id
      AND V.PATVL_value = S.PATVL_value
);


SET @PATVL_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @PATVL_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @PATVL_rows_processed - @PATVL_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @PATVL_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';