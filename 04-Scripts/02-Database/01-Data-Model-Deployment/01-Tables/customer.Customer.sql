    /*==============================================================================
        ATLAS COMMERCE - CUSTOMER.CUSTOMER
    ==============================================================================

        Object      : customer.Customer
        Type        : Master Table
        Prefix      : CST
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the core identity and lifecycle information of identified
        customers in Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Represent both individual and company customers in a single entity.
        - Associate each Customer with one controlled CustomerType.
        - Represent active/inactive state directly through CST_is_active.
        - Allow birth date only when applicable or provided.
        - Keep documents outside Customer.
        - Keep contacts outside Customer.
        - Keep addresses outside Customer.
        - Allow sales to exist without an identified Customer.
        - Store customer master data in FG_CORE.
        - Do not partition customer master tables.
        - Deploy foreign key constraints in the dedicated FK stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    customer.Customer';
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

        ;THROW 50340,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'customer.Customer', N'U') IS NULL
    BEGIN

        CREATE TABLE customer.Customer
        (
            CST_id          int             IDENTITY(1,1) NOT NULL,

            CST_CSTCT_id    smallint        NOT NULL,

            CST_name        nvarchar(200)   NOT NULL,

            CST_birth_date  date            NULL,

            CST_is_active   bit             NOT NULL,

            CST_created_at  datetime2(0)    NOT NULL,
            CST_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_CST
                PRIMARY KEY CLUSTERED
                (
                    CST_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : customer.Customer';
        PRINT N'            Prefix                          : CST';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : CST_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : customer.Customer';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: CST_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'customer.Customer')
            AND c.name = N'CST_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : CST_id';

            ;THROW 50341,
                N'Column CST_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : CST_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_CST
        --------------------------------------------------------------------------*/

        DECLARE @CST_ActualPrimaryKeyName sysname;


        SELECT
            @CST_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'customer.Customer')

        AND kc.type = N'PK';


        IF @CST_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_CST';

            ;THROW 50342,
                N'Primary key for customer.Customer does not exist.',
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
                    OBJECT_ID(N'customer.Customer')

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
                    AND c.name = N'CST_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @CST_ActualPrimaryKeyName;

            ;THROW 50343,
                N'Primary key does not match the expected clustered definition CST_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @CST_ActualPrimaryKeyName <> N'PK_CST'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_CST';
            PRINT N'                Actual                       : '
                + @CST_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_CST';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CST_CSTCT_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'customer.Customer', N'CST_CSTCT_id') IS NULL
        BEGIN

            ALTER TABLE customer.Customer
                ADD CST_CSTCT_id smallint NULL;

            PRINT N'            [+] Column added                  : CST_CSTCT_id';
            PRINT N'            [!] Pending action                : Backfill CST_CSTCT_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_CSTCT_id'
            AND TYPE_NAME(c.user_type_id) = N'smallint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CST_CSTCT_id';

            ;THROW 50344,
                N'Column CST_CSTCT_id does not match the expected data type smallint.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_CSTCT_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CST_CSTCT_id';
            PRINT N'            [!] Expected final definition     : smallint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CST_CSTCT_id';

        END;

        /*--------------------------------------------------------------------------
            COLUMN: CST_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'customer.Customer', N'CST_is_active') IS NULL
        BEGIN

            ALTER TABLE customer.Customer
                ADD CST_is_active bit NULL;

            PRINT N'            [+] Column added                  : CST_is_active';
            PRINT N'            [!] Pending action                : Backfill CST_is_active before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_is_active'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CST_is_active';

            ;THROW 50345,
                N'Column CST_is_active does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_is_active'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CST_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CST_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CST_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'customer.Customer', N'CST_name') IS NULL
        BEGIN

            ALTER TABLE customer.Customer
                ADD CST_name nvarchar(200) NULL;

            PRINT N'            [+] Column added                  : CST_name';
            PRINT N'            [!] Pending action                : Backfill CST_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_name'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 400
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CST_name';

            ;THROW 50346,
                N'Column CST_name does not match the expected data type nvarchar(200).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CST_name';
            PRINT N'            [!] Expected final definition     : nvarchar(200) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CST_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CST_birth_date
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'customer.Customer', N'CST_birth_date') IS NULL
        BEGIN

            ALTER TABLE customer.Customer
                ADD CST_birth_date date NULL;

            PRINT N'            [+] Column added                  : CST_birth_date';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_birth_date'
            AND TYPE_NAME(c.user_type_id) = N'date'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CST_birth_date';

            ;THROW 50347,
                N'Column CST_birth_date does not match the expected data type date.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_birth_date'
            AND c.is_nullable = 0
        )
        BEGIN

            PRINT N'            [X] Column nullability mismatch   : CST_birth_date';

            ;THROW 50348,
                N'Column CST_birth_date must allow NULL values.',
                1;

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CST_birth_date';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CST_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'customer.Customer', N'CST_created_at') IS NULL
        BEGIN

            ALTER TABLE customer.Customer
                ADD CST_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CST_created_at';
            PRINT N'            [!] Pending action                : Backfill CST_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CST_created_at';

            ;THROW 50349,
                N'Column CST_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CST_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CST_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CST_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'customer.Customer', N'CST_updated_at') IS NULL
        BEGIN

            ALTER TABLE customer.Customer
                ADD CST_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CST_updated_at';
            PRINT N'            [!] Pending action                : Backfill CST_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CST_updated_at';

            ;THROW 50350,
                N'Column CST_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.Customer')

            AND c.name = N'CST_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CST_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CST_updated_at';

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
                OBJECT_ID(N'customer.Customer')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : customer.Customer';

        ;THROW 50351,
            N'customer.Customer is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : customer.Customer';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';