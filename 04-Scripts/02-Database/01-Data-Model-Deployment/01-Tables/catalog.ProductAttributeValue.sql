    /*==============================================================================
        ATLAS COMMERCE - CATALOG.PRODUCTATTRIBUTEVALUE
    ==============================================================================

        Object      : catalog.ProductAttributeValue
        Type        : Master / Domain Table
        Prefix      : PATVL
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled set of values available for reusable product
        attributes.

        Design Principles
        --------------------------------------------------------------------------
        - Maintain attribute values as dependent entities of ProductAttribute.
        - Allow each ProductAttribute to define its own controlled set of values.
        - Prevent the same value from being duplicated within the same attribute.
        - Preserve inactive attribute values instead of deleting historical definitions.
        - Keep the relationship column in the table structure while deploying the
          foreign key constraint separately.
        - Store catalog master data in FG_CORE.
        - Do not partition low-volume catalog master tables.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    catalog.ProductAttributeValue';
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

    IF OBJECT_ID(N'catalog.ProductAttributeValue', N'U') IS NULL
    BEGIN

        CREATE TABLE catalog.ProductAttributeValue
        (
            PATVL_id          int             IDENTITY(1,1) NOT NULL,

            PATVL_PAT_id      int             NOT NULL,
            PATVL_value       nvarchar(100)   NOT NULL,

            PATVL_is_active   bit             NOT NULL,

            PATVL_created_at  datetime2(0)    NOT NULL,
            PATVL_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_PATVL
                PRIMARY KEY CLUSTERED
                (
                    PATVL_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : catalog.ProductAttributeValue';
        PRINT N'            Prefix                          : PATVL';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PATVL_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : catalog.ProductAttributeValue';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PATVL_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
            AND c.name = N'PATVL_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PATVL_id';

            ;THROW 50211,
                N'Column PATVL_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PATVL_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PATVL
        --------------------------------------------------------------------------*/

        DECLARE @PATVL_ActualPrimaryKeyName sysname;


        SELECT
            @PATVL_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'catalog.ProductAttributeValue')

        AND kc.type = N'PK';


        IF @PATVL_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PATVL';

            ;THROW 50212,
                N'Primary key for catalog.ProductAttributeValue does not exist.',
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
                    OBJECT_ID(N'catalog.ProductAttributeValue')

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
                AND c.name = N'PATVL_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PATVL_ActualPrimaryKeyName;

            ;THROW 50213,
                N'Primary key does not match the expected clustered definition PATVL_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PATVL_ActualPrimaryKeyName <> N'PK_PATVL'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PATVL';
            PRINT N'                Actual                       : '
                + @PATVL_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PATVL';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PATVL_PAT_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductAttributeValue', N'PATVL_PAT_id') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductAttributeValue
                ADD PATVL_PAT_id int NULL;

            PRINT N'            [+] Column added                  : PATVL_PAT_id';
            PRINT N'            [!] Pending action                : Backfill PATVL_PAT_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

            AND c.name = N'PATVL_PAT_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PATVL_PAT_id';

            ;THROW 50214,
                N'Column PATVL_PAT_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

            AND c.name = N'PATVL_PAT_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PATVL_PAT_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PATVL_PAT_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PATVL_value
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductAttributeValue', N'PATVL_value') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductAttributeValue
                ADD PATVL_value nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : PATVL_value';
            PRINT N'            [!] Pending action                : Backfill PATVL_value before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

            AND c.name = N'PATVL_value'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PATVL_value';

            ;THROW 50215,
                N'Column PATVL_value does not match the expected data type nvarchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

            AND c.name = N'PATVL_value'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PATVL_value';
            PRINT N'            [!] Expected final definition     : nvarchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PATVL_value';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PATVL_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductAttributeValue', N'PATVL_is_active') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductAttributeValue
                ADD PATVL_is_active bit NULL;

            PRINT N'            [+] Column added                  : PATVL_is_active';
            PRINT N'            [!] Pending action                : Backfill PATVL_is_active before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

            AND c.name = N'PATVL_is_active'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PATVL_is_active';

            ;THROW 50216,
                N'Column PATVL_is_active does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

            AND c.name = N'PATVL_is_active'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PATVL_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PATVL_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PATVL_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductAttributeValue', N'PATVL_created_at') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductAttributeValue
                ADD PATVL_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PATVL_created_at';
            PRINT N'            [!] Pending action                : Backfill PATVL_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

            AND c.name = N'PATVL_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PATVL_created_at';

            ;THROW 50217,
                N'Column PATVL_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

            AND c.name = N'PATVL_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PATVL_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PATVL_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PATVL_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'catalog.ProductAttributeValue', N'PATVL_updated_at') IS NULL
        BEGIN

            ALTER TABLE catalog.ProductAttributeValue
                ADD PATVL_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PATVL_updated_at';
            PRINT N'            [!] Pending action                : Backfill PATVL_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

            AND c.name = N'PATVL_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PATVL_updated_at';

            ;THROW 50218,
                N'Column PATVL_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

            AND c.name = N'PATVL_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PATVL_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PATVL_updated_at';

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
                OBJECT_ID(N'catalog.ProductAttributeValue')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : catalog.ProductAttributeValue';

        ;THROW 50218,
            N'catalog.ProductAttributeValue is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : catalog.ProductAttributeValue';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';