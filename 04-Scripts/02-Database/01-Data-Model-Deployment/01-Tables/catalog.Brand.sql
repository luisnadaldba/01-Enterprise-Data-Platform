    /*==============================================================================
        ATLAS COMMERCE - CATALOG.BRAND
    ==============================================================================

        Object      : catalog.Brand
        Type        : Master / Domain Table
        Prefix      : BRD
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the authoritative set of commercial brands used by products
        in the Atlas Commerce catalog.

        Design Principles
        --------------------------------------------------------------------------
        - Maintain brand identity independently from Product.
        - Prevent uncontrolled textual representations of commercial brands.
        - Preserve inactive brands instead of deleting historical definitions.
        - Keep Manufacturer and Supplier as separate business concepts.
        - Store catalog master data in FG_CORE.
        - Do not partition low-volume catalog master tables.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● catalog.Brand';
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

        ;THROW 50100,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.Brand', N'U') IS NULL
    BEGIN

        CREATE TABLE catalog.Brand
        (
            BRD_id          smallint        IDENTITY(1,1) NOT NULL,

            BRD_name        nvarchar(150)   NOT NULL,

            BRD_is_active   bit             NOT NULL,

            BRD_created_at  datetime2(0)    NOT NULL,
            BRD_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_BRD
                PRIMARY KEY CLUSTERED
                (
                    BRD_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : catalog.Brand';
        PRINT N'            Prefix                          : BRD';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : BRD_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : catalog.Brand';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: BRD_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'catalog.Brand')
            AND c.name = N'BRD_id'
            AND TYPE_NAME(c.user_type_id) = N'smallint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : BRD_id';

            ;THROW 50101,
                N'Column BRD_id does not match the expected definition smallint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : BRD_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_BRD
        --------------------------------------------------------------------------*/

        DECLARE @BRD_ActualPrimaryKeyName sysname;


        SELECT
            @BRD_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'catalog.Brand')

        AND kc.type = N'PK';


        IF @BRD_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_BRD';

            ;THROW 50102,
                N'Primary key for catalog.Brand does not exist.',
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
                    OBJECT_ID(N'catalog.Brand')

            AND kc.type = N'PK'

            -- Clustered and unique
            AND i.type = 1
            AND i.is_unique = 1

            -- Exactly one key column
            AND
            (
                SELECT COUNT(*)

                FROM sys.index_columns AS ic

                WHERE ic.object_id = kc.parent_object_id
                AND ic.index_id = kc.unique_index_id
                AND ic.key_ordinal > 0
            ) = 1

            -- Key column: BRD_id
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
                AND c.name = N'BRD_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @BRD_ActualPrimaryKeyName;

            ;THROW 50103,
                N'Primary key does not match the expected clustered definition BRD_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @BRD_ActualPrimaryKeyName <> N'PK_BRD'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_BRD';
            PRINT N'                Actual                       : '
                + @BRD_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_BRD';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: BRD_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.Brand', N'BRD_name') IS NULL
        BEGIN

            ALTER TABLE catalog.Brand
                ADD BRD_name nvarchar(150) NULL;

            PRINT N'            [+] Column added                  : BRD_name';
            PRINT N'            [!] Pending action                : Backfill BRD_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Brand')

            AND c.name = N'BRD_name'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 300
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : BRD_name';

            ;THROW 50104,
                N'Column BRD_name does not match the expected data type nvarchar(150).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Brand')

            AND c.name = N'BRD_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : BRD_name';
            PRINT N'            [!] Expected final definition     : nvarchar(150) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : BRD_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: BRD_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.Brand', N'BRD_is_active') IS NULL
        BEGIN

            ALTER TABLE catalog.Brand
                ADD BRD_is_active bit NULL;

            PRINT N'            [+] Column added                  : BRD_is_active';
            PRINT N'            [!] Pending action                : Backfill BRD_is_active before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Brand')

            AND c.name = N'BRD_is_active'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : BRD_is_active';

            ;THROW 50105,
                N'Column BRD_is_active does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Brand')

            AND c.name = N'BRD_is_active'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : BRD_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : BRD_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: BRD_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.Brand', N'BRD_created_at') IS NULL
        BEGIN

            ALTER TABLE catalog.Brand
                ADD BRD_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : BRD_created_at';
            PRINT N'            [!] Pending action                : Backfill BRD_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Brand')

            AND c.name = N'BRD_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : BRD_created_at';

            ;THROW 50106,
                N'Column BRD_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Brand')

            AND c.name = N'BRD_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : BRD_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : BRD_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: BRD_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.Brand', N'BRD_updated_at') IS NULL
        BEGIN

            ALTER TABLE catalog.Brand
                ADD BRD_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : BRD_updated_at';
            PRINT N'            [!] Pending action                : Backfill BRD_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Brand')

            AND c.name = N'BRD_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : BRD_updated_at';

            ;THROW 50107,
                N'Column BRD_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.Brand')

            AND c.name = N'BRD_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : BRD_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : BRD_updated_at';

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
                OBJECT_ID(N'catalog.Brand')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : catalog.Brand';

        ;THROW 50108,
            N'catalog.Brand is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : catalog.Brand';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';