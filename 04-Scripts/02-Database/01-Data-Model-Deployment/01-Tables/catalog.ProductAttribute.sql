    /*==============================================================================
        ATLAS COMMERCE - CATALOG.PRODUCTATTRIBUTE
    ==============================================================================

        Object      : catalog.ProductAttribute
        Type        : Master / Domain Table
        Prefix      : PAT
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled set of reusable product attributes used to
        describe characteristics of products and their sellable variants.

        Design Principles
        --------------------------------------------------------------------------
        - Maintain product attributes independently from individual products.
        - Allow the same attribute definition to be reused across multiple products.
        - Keep attribute values outside the ProductAttribute entity.
        - Preserve inactive attributes instead of deleting historical definitions.
        - Avoid redundant business codes when the attribute name is sufficient.
        - Store catalog master data in FG_CORE.
        - Do not partition low-volume catalog master tables.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    catalog.ProductAttribute';
    PRINT N'    ------------------------------------------------------------';


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

        ;THROW 50210,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductAttribute', N'U') IS NULL
    BEGIN

        CREATE TABLE catalog.ProductAttribute
        (
            PAT_id          int             IDENTITY(1,1) NOT NULL,

            PAT_name        nvarchar(100)   NOT NULL,

            PAT_is_active   bit             NOT NULL,

            PAT_created_at  datetime2(0)    NOT NULL,
            PAT_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_PAT
                PRIMARY KEY CLUSTERED
                (
                    PAT_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : catalog.ProductAttribute';
        PRINT N'            Prefix                          : PAT';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PAT_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : catalog.ProductAttribute';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PAT_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttribute')
            AND c.name = N'PAT_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PAT_id';

            ;THROW 50211,
                N'Column PAT_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PAT_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PAT
        --------------------------------------------------------------------------*/

        DECLARE @PAT_ActualPrimaryKeyName sysname;


        SELECT
            @PAT_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'catalog.ProductAttribute')

        AND kc.type = N'PK';


        IF @PAT_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PAT';

            ;THROW 50212,
                N'Primary key for catalog.ProductAttribute does not exist.',
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
                    OBJECT_ID(N'catalog.ProductAttribute')

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
                AND c.name = N'PAT_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PAT_ActualPrimaryKeyName;

            ;THROW 50213,
                N'Primary key does not match the expected clustered definition PAT_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PAT_ActualPrimaryKeyName <> N'PK_PAT'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PAT';
            PRINT N'                Actual                       : '
                + @PAT_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PAT';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAT_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductAttribute', N'PAT_name') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductAttribute
                ADD PAT_name nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : PAT_name';
            PRINT N'            [!] Pending action                : Backfill PAT_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttribute')

            AND c.name = N'PAT_name'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAT_name';

            ;THROW 50214,
                N'Column PAT_name does not match the expected data type nvarchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttribute')

            AND c.name = N'PAT_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAT_name';
            PRINT N'            [!] Expected final definition     : nvarchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAT_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAT_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductAttribute', N'PAT_is_active') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductAttribute
                ADD PAT_is_active bit NULL;

            PRINT N'            [+] Column added                  : PAT_is_active';
            PRINT N'            [!] Pending action                : Backfill PAT_is_active before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttribute')

            AND c.name = N'PAT_is_active'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAT_is_active';

            ;THROW 50215,
                N'Column PAT_is_active does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttribute')

            AND c.name = N'PAT_is_active'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAT_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAT_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAT_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductAttribute', N'PAT_created_at') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductAttribute
                ADD PAT_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAT_created_at';
            PRINT N'            [!] Pending action                : Backfill PAT_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttribute')

            AND c.name = N'PAT_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAT_created_at';

            ;THROW 50216,
                N'Column PAT_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttribute')

            AND c.name = N'PAT_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAT_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAT_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAT_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductAttribute', N'PAT_updated_at') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductAttribute
                ADD PAT_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAT_updated_at';
            PRINT N'            [!] Pending action                : Backfill PAT_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttribute')

            AND c.name = N'PAT_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAT_updated_at';

            ;THROW 50217,
                N'Column PAT_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttribute')

            AND c.name = N'PAT_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAT_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAT_updated_at';

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
                OBJECT_ID(N'catalog.ProductAttribute')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : catalog.ProductAttribute';

        ;THROW 50218,
            N'catalog.ProductAttribute is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : catalog.ProductAttribute';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';