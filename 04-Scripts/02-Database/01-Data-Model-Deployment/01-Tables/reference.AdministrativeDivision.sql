    /*==============================================================================
        ATLAS COMMERCE - REFERENCE.ADMINISTRATIVEDIVISION
    ==============================================================================

        Object      : reference.AdministrativeDivision
        Type        : Reference Table
        Prefix      : ADV
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled Brazilian administrative divisions used by
        Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Represent Brazilian administrative divisions independently from cities.
        - Associate each Administrative Division with one controlled Country.
        - Store the official two-character state abbreviation.
        - Keep city-specific information outside Administrative Division.
        - Store reference data in FG_CORE.
        - Do not partition reference tables.
        - Deploy foreign key constraints in the dedicated FK stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    reference.AdministrativeDivision';
    PRINT N'    ------------------------------------------------------------';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.schemas
        WHERE name = N'reference'
    )
    BEGIN

        ;THROW 50250,
            N'Required schema reference does not exist.',
            1;

    END;


    PRINT N'        [✓] Schema dependency validated     : reference';


    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.filegroups
        WHERE name = N'FG_CORE'
    )
    BEGIN

        ;THROW 50251,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'reference.AdministrativeDivision', N'U') IS NULL
    BEGIN

        CREATE TABLE reference.AdministrativeDivision
        (
            ADV_id          tinyint         IDENTITY(1,1) NOT NULL,

            ADV_CTR_id      tinyint         NOT NULL,

            ADV_code        char(2)         NOT NULL,
            ADV_name        nvarchar(100)   NOT NULL,

            ADV_created_at  datetime2(0)    NOT NULL,
            ADV_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_ADV
                PRIMARY KEY CLUSTERED
                (
                    ADV_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : reference.AdministrativeDivision';
        PRINT N'            Prefix                          : ADV';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : ADV_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : reference.AdministrativeDivision';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: ADV_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : ADV_id';

            ;THROW 50252,
                N'Column ADV_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : ADV_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_ADV
        --------------------------------------------------------------------------*/

        DECLARE @ADV_ActualPrimaryKeyName sysname;


        SELECT
            @ADV_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND kc.type = N'PK';


        IF @ADV_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_ADV';

            ;THROW 50253,
                N'Primary key for reference.AdministrativeDivision does not exist.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY DEFINITION
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.key_constraints AS kc

            INNER JOIN sys.indexes AS i
                ON  i.object_id = kc.parent_object_id
                AND i.index_id = kc.unique_index_id

            WHERE kc.parent_object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND kc.type = N'PK'

            AND i.type = 1
            AND i.is_unique = 1

            AND
            (
                SELECT COUNT(*)

                FROM sys.index_columns AS ic

                WHERE ic.object_id = kc.parent_object_id
                AND ic.index_id = kc.unique_index_id
                AND ic.key_ordinal > 0
            ) = 1

            AND EXISTS
            (
                SELECT 1

                FROM sys.index_columns AS ic

                INNER JOIN sys.columns AS c
                    ON  c.object_id = ic.object_id
                    AND c.column_id = ic.column_id

                WHERE ic.object_id = kc.parent_object_id
                AND ic.index_id = kc.unique_index_id
                AND ic.key_ordinal = 1
                AND c.name = N'ADV_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @ADV_ActualPrimaryKeyName;

            ;THROW 50254,
                N'Primary key does not match the expected clustered definition ADV_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @ADV_ActualPrimaryKeyName <> N'PK_ADV'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_ADV';
            PRINT N'                Actual                       : '
                + @ADV_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_ADV';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: ADV_CTR_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.AdministrativeDivision',
            N'ADV_CTR_id'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.AdministrativeDivision
                ADD ADV_CTR_id tinyint NULL;

            PRINT N'            [+] Column added                  : ADV_CTR_id';
            PRINT N'            [!] Pending action                : Backfill ADV_CTR_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_CTR_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : ADV_CTR_id';

            ;THROW 50255,
                N'Column ADV_CTR_id does not match the expected data type tinyint.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_CTR_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : ADV_CTR_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : ADV_CTR_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: ADV_code
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.AdministrativeDivision',
            N'ADV_code'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.AdministrativeDivision
                ADD ADV_code char(2) NULL;

            PRINT N'            [+] Column added                  : ADV_code';
            PRINT N'            [!] Pending action                : Backfill ADV_code before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_code'
            AND TYPE_NAME(c.user_type_id) = N'char'
            AND c.max_length = 2
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : ADV_code';

            ;THROW 50256,
                N'Column ADV_code does not match the expected data type char(2).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_code'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : ADV_code';
            PRINT N'            [!] Expected final definition     : char(2) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : ADV_code';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: ADV_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.AdministrativeDivision',
            N'ADV_name'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.AdministrativeDivision
                ADD ADV_name nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : ADV_name';
            PRINT N'            [!] Pending action                : Backfill ADV_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_name'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : ADV_name';

            ;THROW 50257,
                N'Column ADV_name does not match the expected data type nvarchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : ADV_name';
            PRINT N'            [!] Expected final definition     : nvarchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : ADV_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: ADV_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.AdministrativeDivision',
            N'ADV_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.AdministrativeDivision
                ADD ADV_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : ADV_created_at';
            PRINT N'            [!] Pending action                : Backfill ADV_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : ADV_created_at';

            ;THROW 50258,
                N'Column ADV_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : ADV_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : ADV_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: ADV_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.AdministrativeDivision',
            N'ADV_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.AdministrativeDivision
                ADD ADV_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : ADV_updated_at';
            PRINT N'            [!] Pending action                : Backfill ADV_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : ADV_updated_at';

            ;THROW 50259,
                N'Column ADV_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

            AND c.name = N'ADV_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : ADV_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : ADV_updated_at';

        END;

    END;


    /*==============================================================================
        STORAGE STRUCTURE VALIDATION
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        INNER JOIN sys.key_constraints AS kc
            ON  kc.parent_object_id = i.object_id
            AND kc.unique_index_id = i.index_id
            AND kc.type = N'PK'

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : reference.AdministrativeDivision';

        ;THROW 50260,
            N'reference.AdministrativeDivision is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : reference.AdministrativeDivision';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';