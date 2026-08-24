/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : reference.ContactType
    Type        : Reference / Sample Data
    Prefix      : CTP
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the contact types used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only contact types that do not already exist.
    - Existing contact types are preserved without modification.
    - No automatic UPDATE is performed.
    - CTP_name is used to identify an existing contact type.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● reference.ContactType';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @CTP_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @CTP_rows_added     int;
DECLARE @CTP_rows_processed int;

DECLARE @CTP_source TABLE
(
    CTP_name nvarchar(50) NOT NULL PRIMARY KEY
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @CTP_source
(
    CTP_name
)
VALUES
    (N'MOBILE'),
    (N'PHONE');


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @CTP_rows_processed = COUNT(*)
FROM @CTP_source;


INSERT INTO reference.ContactType
(
    CTP_name,
    CTP_created_at,
    CTP_updated_at
)
SELECT
    S.CTP_name,
    @CTP_data_timestamp,
    @CTP_data_timestamp
FROM @CTP_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.ContactType AS C
    WHERE C.CTP_name = S.CTP_name
);


SET @CTP_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @CTP_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @CTP_rows_processed - @CTP_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @CTP_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';