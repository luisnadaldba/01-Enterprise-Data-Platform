    /*==============================================================================
        ATLAS COMMERCE - REFERENCE.CITY
    ==============================================================================

        Object      : reference.City
        Type        : Reference Table
        Prefix      : CTY
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled Brazilian cities used by Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Represent each City independently from physical address information.
        - Associate each City with one controlled Administrative Division.
        - Derive Country through Administrative Division.
        - Keep address-specific information outside City.
        - Store reference data in FG_CORE.
        - Do not partition reference tables.
        - Deploy foreign key constraints in the dedicated FK stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    reference.City';
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

        ;THROW 50230,
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

        ;THROW 50231,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'reference.City', N'U') IS NULL
    BEGIN

        CREATE TABLE reference.City
        (
            CTY_id          int             IDENTITY(1,1) NOT NULL,

            CTY_ADV_id      tinyint         NOT NULL,

            CTY_name        nvarchar(150)   NOT NULL,

            CTY_created_at  datetime2(0)    NOT NULL,
            CTY_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_CTY
                PRIMARY KEY CLUSTERED
                (
                    CTY_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : reference.City';
        PRINT N'            Prefix                          : CTY';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : CTY_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : reference.City';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: CTY_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'reference.City')
            AND c.name = N'CTY_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : CTY_id';

            ;THROW 50232,
                N'Column CTY_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : CTY_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_CTY
        --------------------------------------------------------------------------*/

        DECLARE @CTY_ActualPrimaryKeyName sysname;


        SELECT
            @CTY_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'reference.City')

        AND kc.type = N'PK';


        IF @CTY_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_CTY';

            ;THROW 50233,
                N'Primary key for reference.City does not exist.',
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
                    OBJECT_ID(N'reference.City')

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
                AND c.name = N'CTY_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @CTY_ActualPrimaryKeyName;

            ;THROW 50234,
                N'Primary key does not match the expected clustered definition CTY_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @CTY_ActualPrimaryKeyName <> N'PK_CTY'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_CTY';
            PRINT N'                Actual                       : '
                + @CTY_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_CTY';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CTY_ADV_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.City', N'CTY_ADV_id') IS NULL
        BEGIN

            ALTER TABLE reference.City
                ADD CTY_ADV_id tinyint NULL;

            PRINT N'            [+] Column added                  : CTY_ADV_id';
            PRINT N'            [!] Pending action                : Backfill CTY_ADV_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.City')

            AND c.name = N'CTY_ADV_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CTY_ADV_id';

            ;THROW 50235,
                N'Column CTY_ADV_id does not match the expected data type tinyint.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.City')

            AND c.name = N'CTY_ADV_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CTY_ADV_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CTY_ADV_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CTY_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.City', N'CTY_name') IS NULL
        BEGIN

            ALTER TABLE reference.City
                ADD CTY_name nvarchar(150) NULL;

            PRINT N'            [+] Column added                  : CTY_name';
            PRINT N'            [!] Pending action                : Backfill CTY_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.City')

            AND c.name = N'CTY_name'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 300
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CTY_name';

            ;THROW 50236,
                N'Column CTY_name does not match the expected data type nvarchar(150).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.City')

            AND c.name = N'CTY_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CTY_name';
            PRINT N'            [!] Expected final definition     : nvarchar(150) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CTY_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CTY_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.City', N'CTY_created_at') IS NULL
        BEGIN

            ALTER TABLE reference.City
                ADD CTY_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CTY_created_at';
            PRINT N'            [!] Pending action                : Backfill CTY_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.City')

            AND c.name = N'CTY_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CTY_created_at';

            ;THROW 50237,
                N'Column CTY_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.City')

            AND c.name = N'CTY_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CTY_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CTY_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CTY_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.City', N'CTY_updated_at') IS NULL
        BEGIN

            ALTER TABLE reference.City
                ADD CTY_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CTY_updated_at';
            PRINT N'            [!] Pending action                : Backfill CTY_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.City')

            AND c.name = N'CTY_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CTY_updated_at';

            ;THROW 50238,
                N'Column CTY_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.City')

            AND c.name = N'CTY_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CTY_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CTY_updated_at';

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
                OBJECT_ID(N'reference.City')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : reference.City';

        ;THROW 50239,
            N'reference.City is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : reference.City';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';