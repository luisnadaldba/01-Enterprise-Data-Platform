/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : customer.CustomerDocument
    Type        : Customer / Sample Data
    Prefix      : CSTCD
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the customer documents used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only customer documents that do not already exist.
    - Existing customer documents are preserved without modification.
    - No automatic UPDATE is performed.
    - DTP_name + CSTCD_value are used to identify an existing document.
    - Customer dependencies are resolved by customer type, name and birth date.
    - CustomerDocumentType dependencies are resolved by document type name.
    - Source data is validated for duplicate document identifiers.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● customer.CustomerDocument';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @CSTCD_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @CSTCD_rows_added     int;
DECLARE @CSTCD_rows_processed int;

DECLARE @CSTCD_source TABLE
(
    CSTCT_code      varchar(30)   NOT NULL,
    CST_name        nvarchar(200) NOT NULL,
    CST_birth_date  date          NULL,

    DTP_name        nvarchar(100) NOT NULL,
    CSTCD_value     varchar(30)   NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @CSTCD_source
(
    CSTCT_code,
    CST_name,
    CST_birth_date,
    DTP_name,
    CSTCD_value
)
VALUES
    (
        'INDIVIDUAL',
        N'Amanda Ribeiro',
        '1992-04-18',
        N'CPF',
        '11111111111'
    ),
    (
        'INDIVIDUAL',
        N'Beatriz Martins',
        '1987-09-03',
        N'CPF',
        '22222222222'
    ),
    (
        'INDIVIDUAL',
        N'Carolina Almeida',
        '1995-01-27',
        N'CPF',
        '33333333333'
    ),
    (
        'INDIVIDUAL',
        N'Fernanda Oliveira',
        '1990-11-12',
        N'CPF',
        '44444444444'
    ),
    (
        'INDIVIDUAL',
        N'Juliana Costa',
        '1984-06-21',
        N'CPF',
        '55555555555'
    ),
    (
        'INDIVIDUAL',
        N'Larissa Fernandes',
        '1998-02-08',
        N'CPF',
        '66666666666'
    ),
    (
        'INDIVIDUAL',
        N'Mariana Souza',
        '1993-07-15',
        N'CPF',
        '77777777777'
    ),
    (
        'INDIVIDUAL',
        N'Patrícia Rodrigues',
        '1989-12-05',
        N'CPF',
        '88888888888'
    ),

    (
        'COMPANY',
        N'Essenza Cosméticos',
        NULL,
        N'CNPJ',
        '11111111111111'
    ),
    (
        'COMPANY',
        N'Lumina Beauty Store',
        NULL,
        N'CNPJ',
        '22222222222222'
    );


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT
        S.DTP_name,
        S.CSTCD_value
    FROM @CSTCD_source AS S
    GROUP BY
        S.DTP_name,
        S.CSTCD_value
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50540,
        N'customer.CustomerDocument source data contains duplicate document identifiers.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTCD_source AS S
    WHERE LEN(LTRIM(RTRIM(S.CSTCD_value))) = 0
)
BEGIN

    ;THROW 50541,
        N'customer.CustomerDocument source data contains an empty document value.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @CSTCD_source AS S

    LEFT JOIN customer.CustomerType AS T
        ON T.CSTCT_code = S.CSTCT_code

    LEFT JOIN customer.Customer AS C
        ON  C.CST_CSTCT_id = T.CSTCT_id
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

    WHERE C.CST_id IS NULL
)
BEGIN

    ;THROW 50542,
        N'customer.CustomerDocument data deployment requires all referenced Customer records.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTCD_source AS S

    LEFT JOIN customer.CustomerDocumentType AS D
        ON D.DTP_name = S.DTP_name

    WHERE D.DTP_id IS NULL
)
BEGIN

    ;THROW 50543,
        N'customer.CustomerDocument data deployment requires all referenced CustomerDocumentType records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @CSTCD_rows_processed = COUNT(*)
FROM @CSTCD_source;


INSERT INTO customer.CustomerDocument
(
    CSTCD_CST_id,
    CSTCD_DTP_id,
    CSTCD_value,
    CSTCD_created_at,
    CSTCD_updated_at
)
SELECT
    C.CST_id,
    D.DTP_id,
    S.CSTCD_value,
    @CSTCD_data_timestamp,
    @CSTCD_data_timestamp
FROM @CSTCD_source AS S

INNER JOIN customer.CustomerType AS T
    ON T.CSTCT_code = S.CSTCT_code

INNER JOIN customer.Customer AS C
    ON  C.CST_CSTCT_id = T.CSTCT_id
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

INNER JOIN customer.CustomerDocumentType AS D
    ON D.DTP_name = S.DTP_name

WHERE NOT EXISTS
(
    SELECT 1
    FROM customer.CustomerDocument AS CD
    WHERE CD.CSTCD_DTP_id = D.DTP_id
      AND CD.CSTCD_value = S.CSTCD_value
);


SET @CSTCD_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @CSTCD_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @CSTCD_rows_processed - @CSTCD_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @CSTCD_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';