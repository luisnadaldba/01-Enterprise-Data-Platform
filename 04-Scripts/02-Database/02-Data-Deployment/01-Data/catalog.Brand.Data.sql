/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : catalog.Brand
    Type        : Catalog / Sample Data
    Prefix      : BRD
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the commercial brands used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only brands that do not already exist.
    - Existing brands are preserved without modification.
    - No automatic UPDATE is performed.
    - BRD_name is used to identify an existing brand.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● catalog.Brand';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @BRD_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @BRD_rows_added     int;
DECLARE @BRD_rows_processed int;

DECLARE @BRD_source TABLE
(
    BRD_name nvarchar(150) NOT NULL PRIMARY KEY
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @BRD_source
(
    BRD_name
)
VALUES
    (N'Aurora Beauty'),
    (N'Bellavie'),
    (N'Veluna');


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @BRD_rows_processed = COUNT(*)
FROM @BRD_source;


INSERT INTO catalog.Brand
(
    BRD_name,
    BRD_is_active,
    BRD_created_at,
    BRD_updated_at
)
SELECT
    S.BRD_name,
    1,
    @BRD_data_timestamp,
    @BRD_data_timestamp
FROM @BRD_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM catalog.Brand AS B
    WHERE B.BRD_name = S.BRD_name
);


SET @BRD_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @BRD_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @BRD_rows_processed - @BRD_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @BRD_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';