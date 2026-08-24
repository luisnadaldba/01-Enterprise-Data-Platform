    /*==============================================================================
        ATLAS COMMERCE - CATALOG.PRODUCTIMAGE
    ==============================================================================

        Object      : catalog.ProductImage
        Type        : Child Table
        Prefix      : PRDIM
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains references and presentation metadata for images associated
        with products in the Atlas Commerce catalog.

        Design Principles
        --------------------------------------------------------------------------
        - Associate each image with one Product.
        - Store only the external image path or object reference in the database.
        - Keep binary image content outside the relational database.
        - Allow multiple images for the same Product.
        - Preserve explicit presentation order for product images.
        - Allow one image to be identified as the primary image of a Product.
        - Preserve inactive image records for historical integrity.
        - Store catalog operational data in FG_CORE.
        - Do not partition catalog operational tables.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy check constraints in the dedicated Checks stage.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Deploy additional indexes in the dedicated Indexes stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● catalog.ProductImage';
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

    IF OBJECT_ID(N'catalog.ProductImage', N'U') IS NULL
    BEGIN

        CREATE TABLE catalog.ProductImage
        (
            PRDIM_id             int             IDENTITY(1,1) NOT NULL,

            PRDIM_PRD_id         int             NOT NULL,

            PRDIM_path           nvarchar(1000)  NOT NULL,

            PRDIM_display_order  smallint        NOT NULL,

            PRDIM_is_primary     bit             NOT NULL,

            PRDIM_is_active      bit             NOT NULL,

            PRDIM_created_at     datetime2(0)    NOT NULL,
            PRDIM_updated_at     datetime2(0)    NOT NULL,

            CONSTRAINT PK_PRDIM
                PRIMARY KEY CLUSTERED
                (
                    PRDIM_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : catalog.ProductImage';
        PRINT N'            Prefix                          : PRDIM';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PRDIM_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : catalog.ProductImage';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PRDIM_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PRDIM_id';

            ;THROW 50171,
                N'Column PRDIM_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PRDIM_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PRDIM
        --------------------------------------------------------------------------*/

        DECLARE @PRDIM_ActualPrimaryKeyName sysname;


        SELECT
            @PRDIM_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND kc.type = N'PK';


        IF @PRDIM_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PRDIM';

            ;THROW 50172,
                N'Primary key for catalog.ProductImage does not exist.',
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
                    OBJECT_ID(N'catalog.ProductImage')

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
                AND c.name = N'PRDIM_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PRDIM_ActualPrimaryKeyName;

            ;THROW 50173,
                N'Primary key does not match the expected clustered definition PRDIM_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PRDIM_ActualPrimaryKeyName <> N'PK_PRDIM'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PRDIM';
            PRINT N'                Actual                       : '
                + @PRDIM_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PRDIM';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDIM_PRD_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductImage', N'PRDIM_PRD_id') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductImage
                ADD PRDIM_PRD_id int NULL;

            PRINT N'            [+] Column added                  : PRDIM_PRD_id';
            PRINT N'            [!] Pending action                : Backfill PRDIM_PRD_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_PRD_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDIM_PRD_id';

            ;THROW 50174,
                N'Column PRDIM_PRD_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_PRD_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDIM_PRD_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDIM_PRD_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDIM_path
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductImage', N'PRDIM_path') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductImage
                ADD PRDIM_path nvarchar(1000) NULL;

            PRINT N'            [+] Column added                  : PRDIM_path';
            PRINT N'            [!] Pending action                : Backfill PRDIM_path before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_path'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 2000
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDIM_path';

            ;THROW 50175,
                N'Column PRDIM_path does not match the expected data type nvarchar(1000).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_path'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDIM_path';
            PRINT N'            [!] Expected final definition     : nvarchar(1000) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDIM_path';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDIM_display_order
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductImage', N'PRDIM_display_order') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductImage
                ADD PRDIM_display_order smallint NULL;

            PRINT N'            [+] Column added                  : PRDIM_display_order';
            PRINT N'            [!] Pending action                : Backfill PRDIM_display_order before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_display_order'
            AND TYPE_NAME(c.user_type_id) = N'smallint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDIM_display_order';

            ;THROW 50176,
                N'Column PRDIM_display_order does not match the expected data type smallint.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_display_order'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDIM_display_order';
            PRINT N'            [!] Expected final definition     : smallint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDIM_display_order';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDIM_is_primary
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductImage', N'PRDIM_is_primary') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductImage
                ADD PRDIM_is_primary bit NULL;

            PRINT N'            [+] Column added                  : PRDIM_is_primary';
            PRINT N'            [!] Pending action                : Backfill PRDIM_is_primary before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_is_primary'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDIM_is_primary';

            ;THROW 50177,
                N'Column PRDIM_is_primary does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_is_primary'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDIM_is_primary';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDIM_is_primary';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDIM_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductImage', N'PRDIM_is_active') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductImage
                ADD PRDIM_is_active bit NULL;

            PRINT N'            [+] Column added                  : PRDIM_is_active';
            PRINT N'            [!] Pending action                : Backfill PRDIM_is_active before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_is_active'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDIM_is_active';

            ;THROW 50178,
                N'Column PRDIM_is_active does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_is_active'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDIM_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDIM_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDIM_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductImage', N'PRDIM_created_at') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductImage
                ADD PRDIM_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PRDIM_created_at';
            PRINT N'            [!] Pending action                : Backfill PRDIM_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDIM_created_at';

            ;THROW 50179,
                N'Column PRDIM_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDIM_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDIM_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDIM_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductImage', N'PRDIM_updated_at') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductImage
                ADD PRDIM_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PRDIM_updated_at';
            PRINT N'            [!] Pending action                : Backfill PRDIM_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDIM_updated_at';

            ;THROW 50180,
                N'Column PRDIM_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductImage')

            AND c.name = N'PRDIM_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDIM_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDIM_updated_at';

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
                OBJECT_ID(N'catalog.ProductImage')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : catalog.ProductImage';

        ;THROW 50181,
            N'catalog.ProductImage is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : catalog.ProductImage';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';