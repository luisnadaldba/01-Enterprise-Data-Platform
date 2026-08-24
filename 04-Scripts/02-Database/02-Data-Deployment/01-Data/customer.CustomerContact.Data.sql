/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : customer.CustomerContact
    Type        : Customer / Sample Data
    Prefix      : CSTCN
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the telephone contacts used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only customer contacts that do not already exist.
    - Existing customer contacts are preserved without modification.
    - No automatic UPDATE is performed.
    - CSTCN_CST_id + CSTCN_CTP_id + CSTCN_value are used to identify an
      existing contact.
    - Customer dependencies are resolved by customer type, name and birth date.
    - ContactType dependencies are resolved by controlled contact type name.
    - Telephone values are stored without presentation formatting.
    - Brazilian area codes are real; subscriber numbers are synthetic.
    - Source data is validated for duplicate customer-contact relationships.
    - Source data is validated to prevent more than one active primary contact
      for the same customer.
    - Data is deployed using a grouped set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● customer.CustomerContact';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @CSTCN_data_timestamp datetime2(0) = SYSDATETIME();
DECLARE @CSTCN_rows_added     int;
DECLARE @CSTCN_rows_processed int;

DECLARE @CSTCN_source TABLE
(
    CSTCT_code       varchar(30)   NOT NULL,
    CST_name         nvarchar(200) NOT NULL,
    CST_birth_date   date          NULL,

    CTP_name         nvarchar(50)  NOT NULL,
    CSTCN_value      varchar(20)   NOT NULL,
    CSTCN_is_primary bit           NOT NULL,
    CSTCN_is_active  bit           NOT NULL
);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

INSERT INTO @CSTCN_source
(
    CSTCT_code,
    CST_name,
    CST_birth_date,
    CTP_name,
    CSTCN_value,
    CSTCN_is_primary,
    CSTCN_is_active
)
VALUES
    (
        'INDIVIDUAL',
        N'Amanda Ribeiro',
        '1992-04-18',
        N'MOBILE',
        '35900000001',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Beatriz Martins',
        '1987-09-03',
        N'MOBILE',
        '11900000002',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Carolina Almeida',
        '1995-01-27',
        N'MOBILE',
        '21900000003',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Fernanda Oliveira',
        '1990-11-12',
        N'MOBILE',
        '31900000004',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Juliana Costa',
        '1984-06-21',
        N'MOBILE',
        '41900000005',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Larissa Fernandes',
        '1998-02-08',
        N'MOBILE',
        '51900000006',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Mariana Souza',
        '1993-07-15',
        N'MOBILE',
        '61900000007',
        1,
        1
    ),
    (
        'INDIVIDUAL',
        N'Patrícia Rodrigues',
        '1989-12-05',
        N'MOBILE',
        '71900000008',
        1,
        1
    ),

    (
        'COMPANY',
        N'Essenza Cosméticos',
        NULL,
        N'PHONE',
        '3530000001',
        1,
        1
    ),
    (
        'COMPANY',
        N'Lumina Beauty Store',
        NULL,
        N'PHONE',
        '1130000002',
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
        S.CTP_name,
        S.CSTCN_value
    FROM @CSTCN_source AS S
    GROUP BY
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date,
        S.CTP_name,
        S.CSTCN_value
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50560,
        N'customer.CustomerContact source data contains duplicate customer-contact relationships.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTCN_source AS S
    WHERE LEN(LTRIM(RTRIM(S.CSTCN_value))) = 0
)
BEGIN

    ;THROW 50561,
        N'customer.CustomerContact source data contains an empty telephone value.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTCN_source AS S
    WHERE S.CSTCN_value LIKE '%[^0-9]%'
)
BEGIN

    ;THROW 50562,
        N'customer.CustomerContact source data contains a telephone value with non-numeric characters.',
        1;

END;


IF EXISTS
(
    SELECT
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date
    FROM @CSTCN_source AS S
    WHERE S.CSTCN_is_primary = 1
      AND S.CSTCN_is_active = 1
    GROUP BY
        S.CSTCT_code,
        S.CST_name,
        S.CST_birth_date
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50563,
        N'customer.CustomerContact source data contains multiple active primary contacts for the same customer.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTCN_source AS S
    WHERE S.CSTCN_is_primary = 1
      AND S.CSTCN_is_active = 0
)
BEGIN

    ;THROW 50564,
        N'customer.CustomerContact source data contains an inactive primary contact.',
        1;

END;


/*==============================================================================
    DEPENDENCY VALIDATION
==============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM @CSTCN_source AS S

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

    ;THROW 50565,
        N'customer.CustomerContact data deployment requires all referenced Customer records.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @CSTCN_source AS S

    LEFT JOIN reference.ContactType AS T
        ON T.CTP_name = S.CTP_name

    WHERE T.CTP_id IS NULL
)
BEGIN

    ;THROW 50566,
        N'customer.CustomerContact data deployment requires all referenced ContactType records.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

SELECT
    @CSTCN_rows_processed = COUNT(*)
FROM @CSTCN_source;


INSERT INTO customer.CustomerContact
(
    CSTCN_CST_id,
    CSTCN_CTP_id,
    CSTCN_value,
    CSTCN_is_primary,
    CSTCN_is_active,
    CSTCN_created_at,
    CSTCN_updated_at
)
SELECT
    C.CST_id,
    T.CTP_id,
    S.CSTCN_value,
    S.CSTCN_is_primary,
    S.CSTCN_is_active,
    @CSTCN_data_timestamp,
    @CSTCN_data_timestamp
FROM @CSTCN_source AS S

INNER JOIN customer.CustomerType AS CT
    ON CT.CSTCT_code = S.CSTCT_code

INNER JOIN customer.Customer AS C
    ON  C.CST_CSTCT_id = CT.CSTCT_id
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

INNER JOIN reference.ContactType AS T
    ON T.CTP_name = S.CTP_name

WHERE NOT EXISTS
(
    SELECT 1
    FROM customer.CustomerContact AS CC
    WHERE CC.CSTCN_CST_id = C.CST_id
      AND CC.CSTCN_CTP_id = T.CTP_id
      AND CC.CSTCN_value = S.CSTCN_value
);


SET @CSTCN_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @CSTCN_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @CSTCN_rows_processed - @CSTCN_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @CSTCN_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';