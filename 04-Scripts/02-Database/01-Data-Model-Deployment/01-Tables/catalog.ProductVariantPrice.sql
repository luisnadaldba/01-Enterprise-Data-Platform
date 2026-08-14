    /*==============================================================================
        ATLAS COMMERCE - CATALOG.PRODUCTVARIANTPRICE
    ==============================================================================

        Object      : catalog.ProductVariantPrice
        Type        : Dependent Catalog Table
        Prefix      : PRDVP
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the price history and temporal validity of sellable product
        variants in the Atlas Commerce catalog.

        Design Principles
        --------------------------------------------------------------------------
        - Associate each price record with one controlled ProductVariant.
        - Preserve historical prices instead of overwriting prior values.
        - Store monetary values using decimal(19,2).
        - Represent temporal validity using valid_from and optional valid_to.
        - Treat valid_to as an exclusive upper boundary.
        - Allow NULL valid_to to represent an open-ended price period.
        - Do not use is_active because temporal validity determines applicability.
        - Do not use updated_at because historical price records should not behave
        like ordinary mutable master-data rows.
        - Store catalog operational data in FG_CORE.
        - Do not partition catalog operational tables.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy check constraints in the dedicated Checks stage.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Deploy additional temporal integrity rules in their dedicated stages.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    catalog.ProductVariantPrice';
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

        ;THROW 50470,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariantPrice', N'U') IS NULL
    BEGIN

        CREATE TABLE catalog.ProductVariantPrice
        (
            PRDVP_id          bigint          IDENTITY(1,1) NOT NULL,

            PRDVP_PRDVA_id    int             NOT NULL,

            PRDVP_price       decimal(19,2)   NOT NULL,

            PRDVP_valid_from  datetime2(0)    NOT NULL,
            PRDVP_valid_to    datetime2(0)    NULL,

            PRDVP_created_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_PRDVP
                PRIMARY KEY CLUSTERED
                (
                    PRDVP_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : catalog.ProductVariantPrice';
        PRINT N'            Prefix                          : PRDVP';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PRDVP_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : catalog.ProductVariantPrice';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PRDVP_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND c.name = N'PRDVP_id'
            AND TYPE_NAME(c.user_type_id) = N'bigint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PRDVP_id';

            ;THROW 50471,
                N'Column PRDVP_id does not match the expected definition bigint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PRDVP_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PRDVP
        --------------------------------------------------------------------------*/

        DECLARE @PRDVP_ActualPrimaryKeyName sysname;


        SELECT
            @PRDVP_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND kc.type = N'PK';


        IF @PRDVP_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PRDVP';

            ;THROW 50472,
                N'Primary key for catalog.ProductVariantPrice does not exist.',
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
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND kc.type = N'PK'

            AND i.type = 1
            AND i.is_unique = 1

            AND
            (
                SELECT COUNT(*)

                FROM sys.index_columns AS ic

                WHERE ic.object_id =
                        kc.parent_object_id

                AND ic.index_id =
                        kc.unique_index_id

                AND ic.key_ordinal > 0
            ) = 1

            AND EXISTS
            (
                SELECT 1

                FROM sys.index_columns AS ic

                INNER JOIN sys.columns AS c
                    ON  c.object_id = ic.object_id
                    AND c.column_id = ic.column_id

                WHERE ic.object_id =
                        kc.parent_object_id

                AND ic.index_id =
                        kc.unique_index_id

                AND ic.key_ordinal = 1

                AND c.name =
                        N'PRDVP_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PRDVP_ActualPrimaryKeyName;

            ;THROW 50473,
                N'Primary key does not match the expected clustered definition PRDVP_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PRDVP_ActualPrimaryKeyName <>
                N'PK_PRDVP'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';

            PRINT N'                Expected                     : PK_PRDVP';

            PRINT N'                Actual                       : '
                + @PRDVP_ActualPrimaryKeyName;

            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PRDVP';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVP_PRDVA_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'catalog.ProductVariantPrice',
            N'PRDVP_PRDVA_id'
        ) IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariantPrice
                ADD PRDVP_PRDVA_id int NULL;

            PRINT N'            [+] Column added                  : PRDVP_PRDVA_id';

            PRINT N'            [!] Pending action                : Backfill PRDVP_PRDVA_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND c.name =
                    N'PRDVP_PRDVA_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVP_PRDVA_id';

            ;THROW 50474,
                N'Column PRDVP_PRDVA_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND c.name =
                    N'PRDVP_PRDVA_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDVP_PRDVA_id';

            PRINT N'            [!] Expected final definition     : int NOT NULL';

            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVP_PRDVA_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVP_price
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'catalog.ProductVariantPrice',
            N'PRDVP_price'
        ) IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariantPrice
                ADD PRDVP_price decimal(19,2) NULL;

            PRINT N'            [+] Column added                  : PRDVP_price';

            PRINT N'            [!] Pending action                : Backfill PRDVP_price before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND c.name =
                    N'PRDVP_price'

            AND TYPE_NAME(c.user_type_id) =
                    N'decimal'

            AND c.precision = 19

            AND c.scale = 2
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVP_price';

            ;THROW 50475,
                N'Column PRDVP_price does not match the expected data type decimal(19,2).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND c.name =
                    N'PRDVP_price'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDVP_price';

            PRINT N'            [!] Expected final definition     : decimal(19,2) NOT NULL';

            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVP_price';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVP_valid_from
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'catalog.ProductVariantPrice',
            N'PRDVP_valid_from'
        ) IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariantPrice
                ADD PRDVP_valid_from datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PRDVP_valid_from';

            PRINT N'            [!] Pending action                : Backfill PRDVP_valid_from before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND c.name =
                    N'PRDVP_valid_from'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVP_valid_from';

            ;THROW 50476,
                N'Column PRDVP_valid_from does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND c.name =
                    N'PRDVP_valid_from'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDVP_valid_from';

            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';

            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVP_valid_from';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVP_valid_to
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'catalog.ProductVariantPrice',
            N'PRDVP_valid_to'
        ) IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariantPrice
                ADD PRDVP_valid_to datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PRDVP_valid_to';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND c.name =
                    N'PRDVP_valid_to'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVP_valid_to';

            ;THROW 50477,
                N'Column PRDVP_valid_to does not match the expected definition datetime2(0) NULL.',
                1;

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVP_valid_to';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVP_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'catalog.ProductVariantPrice',
            N'PRDVP_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariantPrice
                ADD PRDVP_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PRDVP_created_at';

            PRINT N'            [!] Pending action                : Backfill PRDVP_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND c.name =
                    N'PRDVP_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVP_created_at';

            ;THROW 50478,
                N'Column PRDVP_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')

            AND c.name =
                    N'PRDVP_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDVP_created_at';

            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';

            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVP_created_at';

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
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : catalog.ProductVariantPrice';

        ;THROW 50479,
            N'catalog.ProductVariantPrice is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : catalog.ProductVariantPrice';

        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';