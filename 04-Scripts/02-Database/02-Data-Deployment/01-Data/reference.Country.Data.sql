/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : reference.Country
    Type        : Reference / Sample Data
    Prefix      : CTR
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the countries used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only countries that do not already exist.
    - Existing countries are preserved without modification.
    - No automatic UPDATE is performed.
    - CTR_name is used to identify an existing country.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● reference.Country';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @CTR_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @CTR_rows_added     int;
DECLARE @CTR_rows_processed int;

DECLARE @CTR_source TABLE
(
    CTR_name nvarchar(100) NOT NULL PRIMARY KEY
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @CTR_source
(
    CTR_name
)
VALUES
    (N'Brazil');


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @CTR_rows_processed = COUNT(*)
FROM @CTR_source;


INSERT INTO reference.Country
(
    CTR_name,
    CTR_created_at,
    CTR_updated_at
)
SELECT
    S.CTR_name,
    @CTR_data_timestamp,
    @CTR_data_timestamp
FROM @CTR_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.Country AS C
    WHERE C.CTR_name = S.CTR_name
);


SET @CTR_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @CTR_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @CTR_rows_processed - @CTR_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @CTR_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';