/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : reference.City
    Type        : Reference / Sample Data
    Prefix      : CTY
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the Brazilian cities used by the AtlasCommerce sample data.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Inserts only cities that do not already exist.
    - Existing cities are preserved without modification.
    - No automatic UPDATE is performed.
    - CTY_ADV_id + CTY_name are used to identify an existing city.
    - Administrative Division dependencies are resolved by state code.
    - Cities are grouped by Administrative Division.
    - Within each state, the capital is listed first and remaining cities
      are listed alphabetically.
    - Data is deployed using grouped set-based operations.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● reference.City';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @CTY_data_timestamp      datetime2(0) = SYSDATETIME();
DECLARE @CTY_ADV_id              tinyint;
DECLARE @CTY_rows_added_total     int = 0;
DECLARE @CTY_rows_processed_total int = 0;

DECLARE @CTY_source TABLE
(
    CTY_name nvarchar(150) NOT NULL PRIMARY KEY
);


/*==============================================================================
    ACRE
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'AC';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50420,
        N'reference.City data deployment requires Administrative Division AC.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Rio Branco'),
    (N'Cruzeiro do Sul');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    ALAGOAS
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'AL';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50421,
        N'reference.City data deployment requires Administrative Division AL.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Maceió'),
    (N'Arapiraca');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    AMAPÁ
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'AP';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50422,
        N'reference.City data deployment requires Administrative Division AP.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Macapá'),
    (N'Santana');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    AMAZONAS
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'AM';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50423,
        N'reference.City data deployment requires Administrative Division AM.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Manaus'),
    (N'Parintins');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    BAHIA
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'BA';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50424,
        N'reference.City data deployment requires Administrative Division BA.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Salvador'),
    (N'Feira de Santana'),
    (N'Vitória da Conquista');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    CEARÁ
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'CE';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50425,
        N'reference.City data deployment requires Administrative Division CE.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Fortaleza'),
    (N'Juazeiro do Norte'),
    (N'Sobral');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    DISTRITO FEDERAL
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'DF';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50426,
        N'reference.City data deployment requires Administrative Division DF.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Brasília');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    ESPÍRITO SANTO
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'ES';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50427,
        N'reference.City data deployment requires Administrative Division ES.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Vitória'),
    (N'Serra'),
    (N'Vila Velha');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    GOIÁS
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'GO';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50428,
        N'reference.City data deployment requires Administrative Division GO.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Goiânia'),
    (N'Anápolis'),
    (N'Aparecida de Goiânia');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    MARANHÃO
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'MA';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50429,
        N'reference.City data deployment requires Administrative Division MA.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'São Luís'),
    (N'Imperatriz');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    MATO GROSSO
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'MT';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50430,
        N'reference.City data deployment requires Administrative Division MT.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Cuiabá'),
    (N'Rondonópolis');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    MATO GROSSO DO SUL
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'MS';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50431,
        N'reference.City data deployment requires Administrative Division MS.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Campo Grande'),
    (N'Dourados');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    MINAS GERAIS
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'MG';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50432,
        N'reference.City data deployment requires Administrative Division MG.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Belo Horizonte'),
    (N'Contagem'),
    (N'Divinópolis'),
    (N'Juiz de Fora'),
    (N'Pouso Alegre'),
    (N'Uberlândia');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    PARÁ
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'PA';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50433,
        N'reference.City data deployment requires Administrative Division PA.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Belém'),
    (N'Ananindeua'),
    (N'Santarém');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    PARAÍBA
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'PB';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50434,
        N'reference.City data deployment requires Administrative Division PB.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'João Pessoa'),
    (N'Campina Grande'),
    (N'Patos');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    PARANÁ
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'PR';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50435,
        N'reference.City data deployment requires Administrative Division PR.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Curitiba'),
    (N'Cascavel'),
    (N'Londrina'),
    (N'Maringá');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    PERNAMBUCO
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'PE';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50436,
        N'reference.City data deployment requires Administrative Division PE.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Recife'),
    (N'Caruaru'),
    (N'Jaboatão dos Guararapes'),
    (N'Olinda');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    PIAUÍ
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'PI';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50437,
        N'reference.City data deployment requires Administrative Division PI.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Teresina'),
    (N'Parnaíba');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    RIO DE JANEIRO
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'RJ';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50438,
        N'reference.City data deployment requires Administrative Division RJ.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Rio de Janeiro'),
    (N'Duque de Caxias'),
    (N'Niterói'),
    (N'Petrópolis'),
    (N'São Gonçalo');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    RIO GRANDE DO NORTE
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'RN';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50439,
        N'reference.City data deployment requires Administrative Division RN.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Natal'),
    (N'Mossoró'),
    (N'Parnamirim');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    RIO GRANDE DO SUL
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'RS';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50440,
        N'reference.City data deployment requires Administrative Division RS.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Porto Alegre'),
    (N'Canoas'),
    (N'Caxias do Sul'),
    (N'Pelotas');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    RONDÔNIA
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'RO';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50441,
        N'reference.City data deployment requires Administrative Division RO.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Porto Velho'),
    (N'Ji-Paraná');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    RORAIMA
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'RR';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50442,
        N'reference.City data deployment requires Administrative Division RR.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Boa Vista');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    SANTA CATARINA
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'SC';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50443,
        N'reference.City data deployment requires Administrative Division SC.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Florianópolis'),
    (N'Blumenau'),
    (N'Joinville');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    SÃO PAULO
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'SP';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50444,
        N'reference.City data deployment requires Administrative Division SP.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'São Paulo'),
    (N'Campinas'),
    (N'Guarulhos'),
    (N'Peruíbe'),
    (N'Ribeirão Preto'),
    (N'Santos'),
    (N'São José dos Campos');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    SERGIPE
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'SE';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50445,
        N'reference.City data deployment requires Administrative Division SE.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Aracaju'),
    (N'Nossa Senhora do Socorro');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    TOCANTINS
==============================================================================*/

SET @CTY_ADV_id = NULL;

SELECT
    @CTY_ADV_id = ADV_id
FROM reference.AdministrativeDivision
WHERE ADV_code = 'TO';

IF @CTY_ADV_id IS NULL
BEGIN

    ;THROW 50446,
        N'reference.City data deployment requires Administrative Division TO.',
        1;

END;

DELETE FROM @CTY_source;

INSERT INTO @CTY_source
(
    CTY_name
)
VALUES
    (N'Palmas'),
    (N'Araguaína');

SELECT
    @CTY_rows_processed_total =
        @CTY_rows_processed_total + COUNT(*)
FROM @CTY_source;

INSERT INTO reference.City
(
    CTY_ADV_id,
    CTY_name,
    CTY_created_at,
    CTY_updated_at
)
SELECT
    @CTY_ADV_id,
    S.CTY_name,
    @CTY_data_timestamp,
    @CTY_data_timestamp
FROM @CTY_source AS S
WHERE NOT EXISTS
(
    SELECT 1
    FROM reference.City AS C
    WHERE C.CTY_ADV_id = @CTY_ADV_id
      AND C.CTY_name = S.CTY_name
);

SET @CTY_rows_added_total =
    @CTY_rows_added_total + @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @CTY_rows_added_total);

PRINT N'        [•] Rows already existing            : '
    + CONVERT
    (
        nvarchar(20),
        @CTY_rows_processed_total - @CTY_rows_added_total
    );

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @CTY_rows_processed_total);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';