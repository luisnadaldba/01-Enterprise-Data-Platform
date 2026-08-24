    /*==============================================================================
        ATLAS COMMERCE - CUSTOMER.CUSTOMERADDRESS
    ==============================================================================

        Object      : customer.CustomerAddress
        Type        : Dependent Table
        Prefix      : CSTAD
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the association between identified customers and reusable
        physical addresses while preserving customer-specific address information.

        Design Principles
        --------------------------------------------------------------------------
        - Associate each CustomerAddress with one Customer.
        - Associate each CustomerAddress with one reusable reference.Address.
        - Keep street and postal code information in reference.Address.
        - Store customer-specific street number and complement in CustomerAddress.
        - Preserve historical customer addresses by deactivating associations
        instead of deleting them.
        - Allow one active address to be identified as the customer's primary
        address.
        - Do not enforce address uniqueness through the CustomerAddress table.
        - Store customer address data in FG_CORE.
        - Do not partition customer master tables.
        - Deploy foreign key constraints in the dedicated FK stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● customer.CustomerAddress';
    PRINT N'';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.filegroups

        WHERE name =
                N'FG_CORE'
    )
    BEGIN

        ;THROW 50440,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerAddress', N'U') IS NULL
    BEGIN

        CREATE TABLE customer.CustomerAddress
        (
            CSTAD_id          int             IDENTITY(1,1) NOT NULL,

            CSTAD_CST_id      int             NOT NULL,
            CSTAD_ADR_id      int             NOT NULL,

            CSTAD_number      nvarchar(20)    NOT NULL,
            CSTAD_complement  nvarchar(100)   NULL,

            CSTAD_is_primary  bit             NOT NULL,
            CSTAD_is_active   bit             NOT NULL,

            CSTAD_created_at  datetime2(0)    NOT NULL,
            CSTAD_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_CSTAD
                PRIMARY KEY CLUSTERED
                (
                    CSTAD_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : customer.CustomerAddress';
        PRINT N'            Prefix                          : CSTAD';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : CSTAD_id';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : customer.CustomerAddress';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: CSTAD_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : CSTAD_id';

            ;THROW 50441,
                N'Column CSTAD_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : CSTAD_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_CSTAD
        --------------------------------------------------------------------------*/

        DECLARE @CSTAD_ActualPrimaryKeyName sysname;


        SELECT
            @CSTAD_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'customer.CustomerAddress')

        AND kc.type =
                N'PK';


        IF @CSTAD_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_CSTAD';

            ;THROW 50442,
                N'Primary key for customer.CustomerAddress does not exist.',
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
                    OBJECT_ID(N'customer.CustomerAddress')

            AND kc.type =
                    N'PK'

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
                        N'CSTAD_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @CSTAD_ActualPrimaryKeyName;

            ;THROW 50443,
                N'Primary key does not match the expected clustered definition CSTAD_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @CSTAD_ActualPrimaryKeyName <>
                N'PK_CSTAD'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_CSTAD';
            PRINT N'                Actual                       : '
                + @CSTAD_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_CSTAD';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTAD_CST_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerAddress',
            N'CSTAD_CST_id'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerAddress
                ADD CSTAD_CST_id int NULL;

            PRINT N'            [+] Column added                  : CSTAD_CST_id';
            PRINT N'            [!] Pending action                : Backfill CSTAD_CST_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_CST_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTAD_CST_id';

            ;THROW 50444,
                N'Column CSTAD_CST_id does not match the expected data type int.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_CST_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTAD_CST_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTAD_CST_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTAD_ADR_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerAddress',
            N'CSTAD_ADR_id'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerAddress
                ADD CSTAD_ADR_id int NULL;

            PRINT N'            [+] Column added                  : CSTAD_ADR_id';
            PRINT N'            [!] Pending action                : Backfill CSTAD_ADR_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_ADR_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTAD_ADR_id';

            ;THROW 50445,
                N'Column CSTAD_ADR_id does not match the expected data type int.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_ADR_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTAD_ADR_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTAD_ADR_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTAD_number
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerAddress',
            N'CSTAD_number'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerAddress
                ADD CSTAD_number nvarchar(20) NULL;

            PRINT N'            [+] Column added                  : CSTAD_number';
            PRINT N'            [!] Pending action                : Backfill CSTAD_number before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_number'

            AND TYPE_NAME(c.user_type_id) =
                    N'nvarchar'

            AND c.max_length = 40
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTAD_number';

            ;THROW 50446,
                N'Column CSTAD_number does not match the expected data type nvarchar(20).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_number'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTAD_number';
            PRINT N'            [!] Expected final definition     : nvarchar(20) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTAD_number';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTAD_complement
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerAddress',
            N'CSTAD_complement'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerAddress
                ADD CSTAD_complement nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : CSTAD_complement';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_complement'

            AND TYPE_NAME(c.user_type_id) =
                    N'nvarchar'

            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTAD_complement';

            ;THROW 50447,
                N'Column CSTAD_complement does not match the expected data type nvarchar(100).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_complement'

            AND c.is_nullable = 0
        )
        BEGIN

            PRINT N'            [X] Column nullability mismatch   : CSTAD_complement';

            ;THROW 50448,
                N'Column CSTAD_complement must allow NULL values.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTAD_complement';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTAD_is_primary
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerAddress',
            N'CSTAD_is_primary'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerAddress
                ADD CSTAD_is_primary bit NULL;

            PRINT N'            [+] Column added                  : CSTAD_is_primary';
            PRINT N'            [!] Pending action                : Backfill CSTAD_is_primary before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_is_primary'

            AND TYPE_NAME(c.user_type_id) =
                    N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTAD_is_primary';

            ;THROW 50449,
                N'Column CSTAD_is_primary does not match the expected data type bit.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_is_primary'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTAD_is_primary';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTAD_is_primary';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTAD_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerAddress',
            N'CSTAD_is_active'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerAddress
                ADD CSTAD_is_active bit NULL;

            PRINT N'            [+] Column added                  : CSTAD_is_active';
            PRINT N'            [!] Pending action                : Backfill CSTAD_is_active before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_is_active'

            AND TYPE_NAME(c.user_type_id) =
                    N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTAD_is_active';

            ;THROW 50450,
                N'Column CSTAD_is_active does not match the expected data type bit.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_is_active'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTAD_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTAD_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTAD_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerAddress',
            N'CSTAD_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerAddress
                ADD CSTAD_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CSTAD_created_at';
            PRINT N'            [!] Pending action                : Backfill CSTAD_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTAD_created_at';

            ;THROW 50451,
                N'Column CSTAD_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTAD_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTAD_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTAD_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerAddress',
            N'CSTAD_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerAddress
                ADD CSTAD_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CSTAD_updated_at';
            PRINT N'            [!] Pending action                : Backfill CSTAD_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTAD_updated_at';

            ;THROW 50452,
                N'Column CSTAD_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

            AND c.name =
                    N'CSTAD_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTAD_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTAD_updated_at';

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
                OBJECT_ID(N'customer.CustomerAddress')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : customer.CustomerAddress';

        ;THROW 50453,
            N'customer.CustomerAddress is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : customer.CustomerAddress';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';