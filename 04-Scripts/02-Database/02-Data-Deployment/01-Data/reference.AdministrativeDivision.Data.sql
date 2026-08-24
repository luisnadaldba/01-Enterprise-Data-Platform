/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : reference.AdministrativeDivision
    Type        : Reference / Sample Data
    Prefix      : ADV
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the Brazilian administrative divisions used by the
    AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only administrative divisions that do not already exist.
    - Existing administrative divisions are preserved without modification.
    - No automatic UPDATE is performed.
    - ADV_CTR_id + ADV_code are used to identify an existing division.
    - Country dependency is resolved by country name.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● reference.AdministrativeDivision';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @ADV_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @ADV_rows_added     int;
DECLARE @ADV_rows_processed int;

DECLARE @ADV_source TABLE
(
    ADV_code char(2)       NOT NULL PRIMARY KEY,
    ADV_name nvarchar(100) NOT NULL
);


/*==============================================================================
    DEPENDENCY RESOLUTION
==============================================================================*/

DECLARE @ADV_CTR_id tinyint;

SELECT
    @ADV_CTR_id = CTR_id
FROM reference.Country
WHERE CTR_name = N'Brazil';

IF @ADV_CTR_id IS NULL
BEGIN

    ;THROW 50410,
        N'reference.AdministrativeDivision data deployment requires country Brazil.',
        1;

END;


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @ADV_source
(
    ADV_code,
    ADV_name
)
VALUES
    ('AC', N'Acre'),
    ('AL', N'Alagoas'),
    ('AP', N'Amapá'),
    ('AM', N'Amazonas'),
    ('BA', N'Bahia'),
    ('CE', N'Ceará'),
    ('DF', N'Distrito Federal'),
    ('ES', N'Espírito Santo'),
    ('GO', N'Goiás'),
    ('MA', N'Maranhão'),
    ('MT', N'Mato Grosso'),
    ('MS', N'Mato Grosso do Sul'),
    ('MG', N'Minas Gerais'),
    ('PA', N'Pará'),
    ('PB', N'Paraíba'),
    ('PR', N'Paraná'),
    ('PE', N'Pernambuco'),
    ('PI', N'Piauí'),
    ('RJ', N'Rio de Janeiro'),
    ('RN', N'Rio Grande do Norte'),
    ('RS', N'Rio Grande do Sul'),
    ('RO', N'Rondônia'),
    ('RR', N'Roraima'),
    ('SC', N'Santa Catarina'),
    ('SP', N'São Paulo'),
    ('SE', N'Sergipe'),
    ('TO', N'Tocantins');


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @ADV_rows_processed = COUNT(*)
FROM @ADV_source;


INSERT INTO reference.AdministrativeDivision
(
    ADV_CTR_id,
    ADV_code,
    ADV_name,
    ADV_created_at,
    ADV_updated_at
)
SELECT
    @ADV_CTR_id,
    S.ADV_code,
    S.ADV_name,
    @ADV_data_timestamp,
    @ADV_data_timestamp
FROM @ADV_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.AdministrativeDivision AS A
    WHERE A.ADV_CTR_id = @ADV_CTR_id
      AND A.ADV_code = S.ADV_code
);


SET @ADV_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @ADV_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @ADV_rows_processed - @ADV_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @ADV_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';