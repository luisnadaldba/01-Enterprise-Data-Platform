    /*==============================================================================
        ATLAS COMMERCE - CATALOG.PRODUCT
    ==============================================================================

        Object      : catalog.Product
        Type        : Master Table
        Prefix      : PRD
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the commercial identity of products available in the
        Atlas Commerce catalog.

        Design Principles
        --------------------------------------------------------------------------
        - Represent the commercial identity of a product independently from its
        sellable variants.
        - Associate each Product with one controlled Brand.
        - Keep Product lifecycle independent from Product Variant lifecycle.
        - Keep current price outside Product.
        - Keep inventory outside Product.
        - Keep variable characteristics outside Product.
        - Store catalog master data in FG_CORE.
        - Do not partition catalog master tables.
        - Deploy foreign key constraints in the dedicated FK stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● catalog.Product';
    PRINT N'';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.filegroups
        WHERE name = N'FG_CORE'
    )
    BEGIN

        ;THROW 50170,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.Product', N'U') IS NULL
    BEGIN

        CREATE TABLE catalog.Product
        (
            PRD_id          int             IDENTITY(1,1) NOT NULL,

            PRD_BRD_id      smallint        NOT NULL,

            PRD_name        nvarchar(200)   NOT NULL,

            PRD_is_active   bit             NOT NULL,

            PRD_created_at  datetime2(0)    NOT NULL,
            PRD_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_PRD
                PRIMARY KEY CLUSTERED
                (
                    PRD_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : catalog.Product';
        PRINT N'            Prefix                          : PRD';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PRD_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : catalog.Product';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PRD_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'catalog.Product')
            AND c.name = N'PRD_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PRD_id';

            ;THROW 50171,
                N'Column PRD_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PRD_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PRD
        --------------------------------------------------------------------------*/

        DECLARE @PRD_ActualPrimaryKeyName sysname;


        SELECT
            @PRD_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'catalog.Product')

        AND kc.type = N'PK';


        IF @PRD_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PRD';

            ;THROW 50172,
                N'Primary key for catalog.Product does not exist.',
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
                    OBJECT_ID(N'catalog.Product')

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
                AND c.name = N'PRD_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PRD_ActualPrimaryKeyName;

            ;THROW 50173,
                N'Primary key does not match the expected clustered definition PRD_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PRD_ActualPrimaryKeyName <> N'PK_PRD'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PRD';
            PRINT N'                Actual                       : '
                + @PRD_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PRD';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRD_BRD_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.Product', N'PRD_BRD_id') IS NULL
        BEGIN

            ALTER TABLE catalog.Product
                ADD PRD_BRD_id smallint NULL;

            PRINT N'            [+] Column added                  : PRD_BRD_id';
            PRINT N'            [!] Pending action                : Backfill PRD_BRD_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Product')

            AND c.name = N'PRD_BRD_id'
            AND TYPE_NAME(c.user_type_id) = N'smallint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRD_BRD_id';

            ;THROW 50174,
                N'Column PRD_BRD_id does not match the expected data type smallint.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Product')

            AND c.name = N'PRD_BRD_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRD_BRD_id';
            PRINT N'            [!] Expected final definition     : smallint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRD_BRD_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRD_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.Product', N'PRD_name') IS NULL
        BEGIN

            ALTER TABLE catalog.Product
                ADD PRD_name nvarchar(200) NULL;

            PRINT N'            [+] Column added                  : PRD_name';
            PRINT N'            [!] Pending action                : Backfill PRD_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Product')

            AND c.name = N'PRD_name'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 400
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRD_name';

            ;THROW 50175,
                N'Column PRD_name does not match the expected data type nvarchar(200).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Product')

            AND c.name = N'PRD_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRD_name';
            PRINT N'            [!] Expected final definition     : nvarchar(200) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRD_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRD_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.Product', N'PRD_is_active') IS NULL
        BEGIN

            ALTER TABLE catalog.Product
                ADD PRD_is_active bit NULL;

            PRINT N'            [+] Column added                  : PRD_is_active';
            PRINT N'            [!] Pending action                : Backfill PRD_is_active before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Product')

            AND c.name = N'PRD_is_active'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRD_is_active';

            ;THROW 50176,
                N'Column PRD_is_active does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Product')

            AND c.name = N'PRD_is_active'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRD_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRD_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRD_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.Product', N'PRD_created_at') IS NULL
        BEGIN

            ALTER TABLE catalog.Product
                ADD PRD_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PRD_created_at';
            PRINT N'            [!] Pending action                : Backfill PRD_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Product')

            AND c.name = N'PRD_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRD_created_at';

            ;THROW 50177,
                N'Column PRD_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Product')

            AND c.name = N'PRD_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRD_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRD_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRD_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.Product', N'PRD_updated_at') IS NULL
        BEGIN

            ALTER TABLE catalog.Product
                ADD PRD_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PRD_updated_at';
            PRINT N'            [!] Pending action                : Backfill PRD_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Product')

            AND c.name = N'PRD_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRD_updated_at';

            ;THROW 50178,
                N'Column PRD_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Product')

            AND c.name = N'PRD_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRD_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRD_updated_at';

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
                OBJECT_ID(N'catalog.Product')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : catalog.Product';

        ;THROW 50179,
            N'catalog.Product is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : catalog.Product';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';