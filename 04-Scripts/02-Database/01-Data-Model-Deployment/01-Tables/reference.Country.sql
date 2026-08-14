    /*==============================================================================
        ATLAS COMMERCE - REFERENCE.COUNTRY
    ==============================================================================

        Object      : reference.Country
        Type        : Reference Table
        Prefix      : CTR
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled countries used by Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Represent Country independently from administrative divisions.
        - Support the geographic hierarchy used by Atlas Commerce.
        - Keep administrative-division-specific information outside Country.
        - Keep the structure limited to the requirements of the national-address
        training scope.
        - Store reference data in FG_CORE.
        - Do not partition reference tables.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    reference.Country';
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

        ;THROW 50280,
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

        ;THROW 50281,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'reference.Country', N'U') IS NULL
    BEGIN

        CREATE TABLE reference.Country
        (
            CTR_id          tinyint         IDENTITY(1,1) NOT NULL,

            CTR_name        nvarchar(100)   NOT NULL,

            CTR_created_at  datetime2(0)    NOT NULL,
            CTR_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_CTR
                PRIMARY KEY CLUSTERED
                (
                    CTR_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : reference.Country';
        PRINT N'            Prefix                          : CTR';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : CTR_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : reference.Country';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: CTR_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Country')

            AND c.name = N'CTR_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : CTR_id';

            ;THROW 50282,
                N'Column CTR_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : CTR_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_CTR
        --------------------------------------------------------------------------*/

        DECLARE @CTR_ActualPrimaryKeyName sysname;


        SELECT
            @CTR_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'reference.Country')

        AND kc.type = N'PK';


        IF @CTR_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_CTR';

            ;THROW 50283,
                N'Primary key for reference.Country does not exist.',
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
                    OBJECT_ID(N'reference.Country')

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
                AND c.name = N'CTR_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @CTR_ActualPrimaryKeyName;

            ;THROW 50284,
                N'Primary key does not match the expected clustered definition CTR_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @CTR_ActualPrimaryKeyName <> N'PK_CTR'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_CTR';
            PRINT N'                Actual                       : '
                + @CTR_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_CTR';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CTR_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.Country',
            N'CTR_name'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.Country
                ADD CTR_name nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : CTR_name';
            PRINT N'            [!] Pending action                : Backfill CTR_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Country')

            AND c.name = N'CTR_name'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CTR_name';

            ;THROW 50285,
                N'Column CTR_name does not match the expected data type nvarchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Country')

            AND c.name = N'CTR_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CTR_name';
            PRINT N'            [!] Expected final definition     : nvarchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CTR_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CTR_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.Country',
            N'CTR_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.Country
                ADD CTR_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CTR_created_at';
            PRINT N'            [!] Pending action                : Backfill CTR_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Country')

            AND c.name = N'CTR_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CTR_created_at';

            ;THROW 50286,
                N'Column CTR_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Country')

            AND c.name = N'CTR_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CTR_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CTR_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CTR_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.Country',
            N'CTR_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.Country
                ADD CTR_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CTR_updated_at';
            PRINT N'            [!] Pending action                : Backfill CTR_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Country')

            AND c.name = N'CTR_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CTR_updated_at';

            ;THROW 50287,
                N'Column CTR_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Country')

            AND c.name = N'CTR_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CTR_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CTR_updated_at';

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
                OBJECT_ID(N'reference.Country')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : reference.Country';

        ;THROW 50288,
            N'reference.Country is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : reference.Country';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';