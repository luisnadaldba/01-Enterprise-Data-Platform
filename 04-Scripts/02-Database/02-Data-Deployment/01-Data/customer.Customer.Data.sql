/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : customer.Customer
    Type        : Customer / Sample Data
    Prefix      : CST
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the registered customers used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only customers that do not already exist.
    - Existing customers are preserved without modification.
    - No automatic UPDATE is performed.
    - CustomerType + customer name + birth date are used to identify an
      existing sample customer.
    - CustomerType dependencies are resolved by controlled customer type code.
    - Birth date is populated only for individual customers when applicable.
    - Source data is validated for duplicate customer definitions.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● customer.Customer';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @CST_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @CST_rows_added     int;
DECLARE @CST_rows_processed int;

DECLARE @CST_source TABLE
(
    CSTCT_code      varchar(30)   NOT NULL,
    CST_name        nvarchar(200) NOT NULL,
    CST_birth_date  date          NULL,
    CST_is_active   bit           NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @CST_source
(
    CSTCT_code,
    CST_name,
    CST_birth_date,
    CST_is_active
)
VALUES
    ('INDIVIDUAL', N'Amanda Ribeiro',       '1992-04-18', 1),
    ('INDIVIDUAL', N'Beatriz Martins',      '1987-09-03', 1),
    ('INDIVIDUAL', N'Carolina Almeida',     '1995-01-27', 1),
    ('INDIVIDUAL', N'Fernanda Oliveira',    '1990-11-12', 1),
    ('INDIVIDUAL', N'Juliana Costa',        '1984-06-21', 1),
    ('INDIVIDUAL', N'Larissa Fernandes',    '1998-02-08', 1),
    ('INDIVIDUAL', N'Mariana Souza',        '1993-07-15', 1),
    ('INDIVIDUAL', N'Patrícia Rodrigues',   '1989-12-05', 1),

    ('COMPANY',    N'Essenza Cosméticos',   NULL,         1),
    ('COMPANY',    N'Lumina Beauty Store',  NULL,         1);


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date
    FROM @CST_source AS S
    GROUP BY
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50530,
        N'customer.Customer source data contains duplicate customer definitions.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CST_source AS S
    WHERE S.CSTCT_code = 'COMPANY'
      AND S.CST_birth_date IS NOT NULL
)
BEGIN

    ;THROW 50531,
        N'customer.Customer source data contains a birth date for a company customer.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CST_source AS S
    WHERE LEN(LTRIM(RTRIM(S.CST_name))) = 0
)
BEGIN

    ;THROW 50532,
        N'customer.Customer source data contains an empty customer name.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @CST_source AS S

    LEFT JOIN customer.CustomerType AS T
        ON T.CSTCT_code = S.CSTCT_code

    WHERE T.CSTCT_id IS NULL
)
BEGIN

    ;THROW 50533,
        N'customer.Customer data deployment requires all referenced CustomerType records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @CST_rows_processed = COUNT(*)
FROM @CST_source;


INSERT INTO customer.Customer
(
    CST_CSTCT_id,
    CST_name,
    CST_birth_date,
    CST_is_active,
    CST_created_at,
    CST_updated_at
)
SELECT
    T.CSTCT_id,
    S.CST_name,
    S.CST_birth_date,
    S.CST_is_active,
    @CST_data_timestamp,
    @CST_data_timestamp
FROM @CST_source AS S

INNER JOIN customer.CustomerType AS T
    ON T.CSTCT_code = S.CSTCT_code

WHERE NOT EXISTS
(
    SELECT 1
    FROM customer.Customer AS C
    WHERE C.CST_CSTCT_id = T.CSTCT_id
      AND C.CST_name = S.CST_name
      AND
      (
            C.CST_birth_date = S.CST_birth_date

            OR
            (
                C.CST_birth_date IS NULL
                AND S.CST_birth_date IS NULL
            )
      )
);


SET @CST_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @CST_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @CST_rows_processed - @CST_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @CST_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';