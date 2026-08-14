    /*==============================================================================
        ATLAS COMMERCE - CATALOG.PRODUCTVARIANT
    ==============================================================================

        Object      : catalog.ProductVariant
        Type        : Dependent Catalog Table
        Prefix      : PRDVA
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the sellable variants associated with products in the
        Atlas Commerce catalog.

        Design Principles
        --------------------------------------------------------------------------
        - Represent each sellable variant as a dependent entity of Product.
        - Associate each ProductVariant with one controlled Product.
        - Keep SKU at the sellable variant level.
        - Allow barcode to remain optional when it is not available.
        - Keep current price outside ProductVariant.
        - Keep inventory outside ProductVariant.
        - Store catalog master data in FG_CORE.
        - Do not partition catalog master tables.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Deploy uniqueness rules in the dedicated Unique Constraints stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    catalog.ProductVariant';
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

        ;THROW 50280,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NULL
    BEGIN

        CREATE TABLE catalog.ProductVariant
        (
            PRDVA_id          int             IDENTITY(1,1) NOT NULL,

            PRDVA_PRD_id      int             NOT NULL,

            PRDVA_sku         nvarchar(100)   NOT NULL,
            PRDVA_barcode     nvarchar(50)    NULL,

            PRDVA_is_active   bit             NOT NULL,

            PRDVA_created_at  datetime2(0)    NOT NULL,
            PRDVA_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_PRDVA
                PRIMARY KEY CLUSTERED
                (
                    PRDVA_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : catalog.ProductVariant';
        PRINT N'            Prefix                          : PRDVA';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PRDVA_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : catalog.ProductVariant';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PRDVA_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'catalog.ProductVariant')
            AND c.name = N'PRDVA_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PRDVA_id';

            ;THROW 50281,
                N'Column PRDVA_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PRDVA_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PRDVA
        --------------------------------------------------------------------------*/

        DECLARE @PRDVA_ActualPrimaryKeyName sysname;


        SELECT
            @PRDVA_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND kc.type = N'PK';


        IF @PRDVA_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PRDVA';

            ;THROW 50282,
                N'Primary key for catalog.ProductVariant does not exist.',
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
                    OBJECT_ID(N'catalog.ProductVariant')

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
                    AND c.name = N'PRDVA_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PRDVA_ActualPrimaryKeyName;

            ;THROW 50283,
                N'Primary key does not match the expected clustered definition PRDVA_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PRDVA_ActualPrimaryKeyName <> N'PK_PRDVA'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PRDVA';
            PRINT N'                Actual                       : '
                + @PRDVA_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PRDVA';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVA_PRD_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_PRD_id') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariant
                ADD PRDVA_PRD_id int NULL;

            PRINT N'            [+] Column added                  : PRDVA_PRD_id';
            PRINT N'            [!] Pending action                : Backfill PRDVA_PRD_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_PRD_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVA_PRD_id';

            ;THROW 50284,
                N'Column PRDVA_PRD_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_PRD_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDVA_PRD_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVA_PRD_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVA_sku
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_sku') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariant
                ADD PRDVA_sku nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : PRDVA_sku';
            PRINT N'            [!] Pending action                : Backfill PRDVA_sku before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_sku'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVA_sku';

            ;THROW 50285,
                N'Column PRDVA_sku does not match the expected data type nvarchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_sku'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDVA_sku';
            PRINT N'            [!] Expected final definition     : nvarchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVA_sku';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVA_barcode
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_barcode') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariant
                ADD PRDVA_barcode nvarchar(50) NULL;

            PRINT N'            [+] Column added                  : PRDVA_barcode';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_barcode'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 100
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVA_barcode';

            ;THROW 50286,
                N'Column PRDVA_barcode does not match the expected definition nvarchar(50) NULL.',
                1;

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVA_barcode';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVA_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_is_active') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariant
                ADD PRDVA_is_active bit NULL;

            PRINT N'            [+] Column added                  : PRDVA_is_active';
            PRINT N'            [!] Pending action                : Backfill PRDVA_is_active before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_is_active'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVA_is_active';

            ;THROW 50287,
                N'Column PRDVA_is_active does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_is_active'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDVA_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVA_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVA_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_created_at') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariant
                ADD PRDVA_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PRDVA_created_at';
            PRINT N'            [!] Pending action                : Backfill PRDVA_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVA_created_at';

            ;THROW 50288,
                N'Column PRDVA_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDVA_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVA_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDVA_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_updated_at') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariant
                ADD PRDVA_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PRDVA_updated_at';
            PRINT N'            [!] Pending action                : Backfill PRDVA_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDVA_updated_at';

            ;THROW 50289,
                N'Column PRDVA_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

            AND c.name = N'PRDVA_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDVA_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDVA_updated_at';

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
                OBJECT_ID(N'catalog.ProductVariant')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : catalog.ProductVariant';

        ;THROW 50290,
            N'catalog.ProductVariant is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : catalog.ProductVariant';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';