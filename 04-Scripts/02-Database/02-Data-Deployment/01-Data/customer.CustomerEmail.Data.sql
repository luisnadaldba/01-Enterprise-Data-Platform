/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : customer.CustomerEmail
    Type        : Customer / Sample Data
    Prefix      : CSTEM
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the customer email addresses used by the AtlasCommerce sample
    data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only customer email addresses that do not already exist.
    - Existing customer email addresses are preserved without modification.
    - No automatic UPDATE is performed.
    - CSTEM_CST_id + CSTEM_email are used to identify an existing email.
    - Customer dependencies are resolved by customer type, name and birth date.
    - Source data is validated for duplicate customer-email relationships.
    - Source data is validated to prevent more than one active primary email
      for the same customer.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● customer.CustomerEmail';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @CSTEM_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @CSTEM_rows_added     int;
DECLARE @CSTEM_rows_processed int;

DECLARE @CSTEM_source TABLE
(
    CSTCT_code       varchar(30)   NOT NULL,
    CST_name         nvarchar(200) NOT NULL,
    CST_birth_date   date          NULL,

    CSTEM_email      varchar(254)  NOT NULL,
    CSTEM_is_primary bit           NOT NULL,
    CSTEM_is_active  bit           NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @CSTEM_source
(
    CSTCT_code,
    CST_name,
    CST_birth_date,
    CSTEM_email,
    CSTEM_is_primary,
    CSTEM_is_active
)
VALUES
    (
        'INDIVIDUAL',
        N'Amanda Ribeiro',
        '1992-04-18',
        'amanda.ribeiro@example.com.br',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Beatriz Martins',
        '1987-09-03',
        'beatriz.martins@example.com.br',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Carolina Almeida',
        '1995-01-27',
        'carolina.almeida@example.com.br',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Fernanda Oliveira',
        '1990-11-12',
        'fernanda.oliveira@example.com.br',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Juliana Costa',
        '1984-06-21',
        'juliana.costa@example.com.br',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Larissa Fernandes',
        '1998-02-08',
        'larissa.fernandes@example.com.br',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Mariana Souza',
        '1993-07-15',
        'mariana.souza@example.com.br',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Patrícia Rodrigues',
        '1989-12-05',
        'patricia.rodrigues@example.com.br',
        1,
        1
    ),

    (
        'COMPANY',
        N'Essenza Cosméticos',
        NULL,
        'contato.essenza@example.com.br',
        1,
        1
    ),
    (
        'COMPANY',
        N'Lumina Beauty Store',
        NULL,
        'contato.lumina@example.com.br',
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
        S.CSTEM_email
    FROM @CSTEM_source AS S
    GROUP BY
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date,
        S.CSTEM_email
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50550,
        N'customer.CustomerEmail source data contains duplicate customer-email relationships.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTEM_source AS S
    WHERE LEN(LTRIM(RTRIM(S.CSTEM_email))) = 0
)
BEGIN

    ;THROW 50551,
        N'customer.CustomerEmail source data contains an empty email address.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTEM_source AS S
    WHERE S.CSTEM_email NOT LIKE '%_@_%._%'
)
BEGIN

    ;THROW 50552,
        N'customer.CustomerEmail source data contains an invalid email address format.',
        1;

END;


IF EXISTS
(
    SELECT
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date
    FROM @CSTEM_source AS S
    WHERE S.CSTEM_is_primary = 1
      AND S.CSTEM_is_active = 1
    GROUP BY
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50553,
        N'customer.CustomerEmail source data contains multiple active primary emails for the same customer.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTEM_source AS S
    WHERE S.CSTEM_is_primary = 1
      AND S.CSTEM_is_active = 0
)
BEGIN

    ;THROW 50554,
        N'customer.CustomerEmail source data contains an inactive primary email.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @CSTEM_source AS S

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

    ;THROW 50555,
        N'customer.CustomerEmail data deployment requires all referenced Customer records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @CSTEM_rows_processed = COUNT(*)
FROM @CSTEM_source;


INSERT INTO customer.CustomerEmail
(
    CSTEM_CST_id,
    CSTEM_email,
    CSTEM_is_primary,
    CSTEM_is_active,
    CSTEM_created_at,
    CSTEM_updated_at
)
SELECT
    C.CST_id,
    S.CSTEM_email,
    S.CSTEM_is_primary,
    S.CSTEM_is_active,
    @CSTEM_data_timestamp,
    @CSTEM_data_timestamp
FROM @CSTEM_source AS S

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

WHERE NOT EXISTS
(
    SELECT 1
    FROM customer.CustomerEmail AS E
    WHERE E.CSTEM_CST_id = C.CST_id
      AND E.CSTEM_email = S.CSTEM_email
);


SET @CSTEM_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @CSTEM_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @CSTEM_rows_processed - @CSTEM_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @CSTEM_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';