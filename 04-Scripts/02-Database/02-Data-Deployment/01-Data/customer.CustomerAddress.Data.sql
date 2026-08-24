/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : customer.CustomerAddress
    Type        : Customer / Sample Data
    Prefix      : CSTAD
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the customer address relationships used by the AtlasCommerce
    sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only customer address relationships that do not already exist.
    - Existing customer address relationships are preserved without modification.
    - No automatic UPDATE is performed.
    - Customer + Address + street number + complement are used to identify an
      existing sample customer address relationship.
    - Customer dependencies are resolved by customer type, name and birth date.
    - Address dependencies are resolved by Administrative Division code, city,
      postal code and street.
    - Street number and complement values are synthetic.
    - Source data is validated for duplicate customer-address relationships.
    - Source data is validated to prevent more than one active primary address
      for the same customer.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● customer.CustomerAddress';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @CSTAD_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @CSTAD_rows_added     int;
DECLARE @CSTAD_rows_processed int;

DECLARE @CSTAD_source TABLE
(
    CSTCT_code          varchar(30)   NOT NULL,
    CST_name            nvarchar(200) NOT NULL,
    CST_birth_date      date          NULL,

    ADV_code            char(2)       NOT NULL,
    CTY_name            nvarchar(150) NOT NULL,
    ADR_postal_code     varchar(8)    NOT NULL,
    ADR_street          nvarchar(200) NOT NULL,

    CSTAD_number        nvarchar(20)  NOT NULL,
    CSTAD_complement    nvarchar(100) NULL,
    CSTAD_is_primary    bit           NOT NULL,
    CSTAD_is_active     bit           NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @CSTAD_source
(
    CSTCT_code,
    CST_name,
    CST_birth_date,

    ADV_code,
    CTY_name,
    ADR_postal_code,
    ADR_street,

    CSTAD_number,
    CSTAD_complement,
    CSTAD_is_primary,
    CSTAD_is_active
)
VALUES
    (
        'INDIVIDUAL',
        N'Amanda Ribeiro',
        '1992-04-18',

        'MG',
        N'Pouso Alegre',
        '37550001',
        N'Rua Farid Abou Medeiros',

        N'125',
        N'Apartment 12',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Beatriz Martins',
        '1987-09-03',

        'SP',
        N'São Paulo',
        '01001000',
        N'Alameda Mestre Atlas',

        N'840',
        N'Apartment 31',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Carolina Almeida',
        '1995-01-27',

        'RJ',
        N'Rio de Janeiro',
        '20000001',
        N'Alameda dos Pernetas',

        N'214',
        N'Apartment 7',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Fernanda Oliveira',
        '1990-11-12',

        'MG',
        N'Belo Horizonte',
        '30000001',
        N'Avenida Presidente Kennedy',

        N'1550',
        N'Apartment 42',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Juliana Costa',
        '1984-06-21',

        'PR',
        N'Curitiba',
        '80000001',
        N'Alameda Espírito Santo',

        N'390',
        N'Apartment 18',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Larissa Fernandes',
        '1998-02-08',

        'RS',
        N'Porto Alegre',
        '90000001',
        N'Alameda Oito',

        N'77',
        NULL,
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Mariana Souza',
        '1993-07-15',

        'DF',
        N'Brasília',
        '70040000',
        N'Avenida Vinte Um de Abril',

        N'510',
        N'Apartment 26',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Patrícia Rodrigues',
        '1989-12-05',

        'BA',
        N'Salvador',
        '40000001',
        N'Rua Direta do Papagaio',

        N'305',
        NULL,
        1,
        1
    ),

    (
        'COMPANY',
        N'Essenza Cosméticos',
        NULL,

        'SP',
        N'Campinas',
        '13000001',
        N'Alameda Pasteur',

        N'1800',
        N'Suite 10',
        1,
        1
    ),
    (
        'COMPANY',
        N'Lumina Beauty Store',
        NULL,

        'SP',
        N'Santos',
        '11000000',
        N'Avenida João Silvestre',

        N'950',
        N'Suite 5',
        1,
        1
    );


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date,
        S.ADV_code,
        S.CTY_name,
        S.ADR_postal_code,
        S.ADR_street,
        S.CSTAD_number,
        S.CSTAD_complement
    FROM @CSTAD_source AS S
    GROUP BY
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date,
        S.ADV_code,
        S.CTY_name,
        S.ADR_postal_code,
        S.ADR_street,
        S.CSTAD_number,
        S.CSTAD_complement
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50580,
        N'customer.CustomerAddress source data contains duplicate customer-address relationships.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTAD_source AS S
    WHERE LEN(LTRIM(RTRIM(S.CSTAD_number))) = 0
)
BEGIN

    ;THROW 50581,
        N'customer.CustomerAddress source data contains an empty street number.',
        1;

END;


IF EXISTS
(
    SELECT
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date
    FROM @CSTAD_source AS S
    WHERE S.CSTAD_is_primary = 1
      AND S.CSTAD_is_active = 1
    GROUP BY
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50582,
        N'customer.CustomerAddress source data contains multiple active primary addresses for the same customer.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTAD_source AS S
    WHERE S.CSTAD_is_primary = 1
      AND S.CSTAD_is_active = 0
)
BEGIN

    ;THROW 50583,
        N'customer.CustomerAddress source data contains an inactive primary address.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @CSTAD_source AS S

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

    ;THROW 50584,
        N'customer.CustomerAddress data deployment requires all referenced Customer records.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTAD_source AS S

    LEFT JOIN reference.AdministrativeDivision AS D
        ON D.ADV_code = S.ADV_code

    LEFT JOIN reference.City AS C
        ON  C.CTY_ADV_id = D.ADV_id
        AND C.CTY_name = S.CTY_name

    LEFT JOIN reference.Address AS A
        ON  A.ADR_CTY_id = C.CTY_id
        AND A.ADR_postal_code = S.ADR_postal_code
        AND A.ADR_street = S.ADR_street

    WHERE A.ADR_id IS NULL
)
BEGIN

    ;THROW 50585,
        N'customer.CustomerAddress data deployment requires all referenced Address records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @CSTAD_rows_processed = COUNT(*)
FROM @CSTAD_source;


INSERT INTO customer.CustomerAddress
(
    CSTAD_CST_id,
    CSTAD_ADR_id,
    CSTAD_number,
    CSTAD_complement,
    CSTAD_is_primary,
    CSTAD_is_active,
    CSTAD_created_at,
    CSTAD_updated_at
)
SELECT
    C.CST_id,
    A.ADR_id,
    S.CSTAD_number,
    S.CSTAD_complement,
    S.CSTAD_is_primary,
    S.CSTAD_is_active,
    @CSTAD_data_timestamp,
    @CSTAD_data_timestamp
FROM @CSTAD_source AS S

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

INNER JOIN reference.AdministrativeDivision AS D
    ON D.ADV_code = S.ADV_code

INNER JOIN reference.City AS CTY
    ON  CTY.CTY_ADV_id = D.ADV_id
    AND CTY.CTY_name = S.CTY_name

INNER JOIN reference.Address AS A
    ON  A.ADR_CTY_id = CTY.CTY_id
    AND A.ADR_postal_code = S.ADR_postal_code
    AND A.ADR_street = S.ADR_street

WHERE NOT EXISTS
(
    SELECT 1
    FROM customer.CustomerAddress AS CA
    WHERE CA.CSTAD_CST_id = C.CST_id
      AND CA.CSTAD_ADR_id = A.ADR_id
      AND CA.CSTAD_number = S.CSTAD_number
      AND
      (
            CA.CSTAD_complement = S.CSTAD_complement

            OR
            (
                CA.CSTAD_complement IS NULL
                AND S.CSTAD_complement IS NULL
            )
      )
);


SET @CSTAD_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @CSTAD_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @CSTAD_rows_processed - @CSTAD_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @CSTAD_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';