    /*==============================================================================
        ATLAS COMMERCE - CUSTOMER.CUSTOMERCONTACT
    ==============================================================================

        Object      : customer.CustomerContact
        Type        : Dependent Table
        Prefix      : CSTCN
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains telephone contact information associated with identified
        customers in Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Associate each CustomerContact with one Customer.
        - Associate each CustomerContact with one controlled ContactType.
        - Store telephone numbers without presentation formatting.
        - Support both fixed and mobile telephone numbers.
        - Allow multiple contact numbers for the same customer.
        - Identify the primary active contact independently from historical contacts.
        - Preserve inactive contact records when they are no longer in use.
        - Store customer contact data in FG_CORE.
        - Do not partition customer dependent tables.
        - Deploy check constraints in the dedicated check constraint stage.
        - Deploy unique constraints in the dedicated unique constraint stage.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Deploy additional indexes in the dedicated index stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    customer.CustomerContact';
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

        ;THROW 50630,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerContact', N'U') IS NULL
    BEGIN

        CREATE TABLE customer.CustomerContact
        (
            CSTCN_id          int             IDENTITY(1,1) NOT NULL,

            CSTCN_CST_id      int             NOT NULL,
            CSTCN_CTP_id      tinyint         NOT NULL,

            CSTCN_value       varchar(20)     NOT NULL,

            CSTCN_is_primary  bit             NOT NULL,
            CSTCN_is_active   bit             NOT NULL,

            CSTCN_created_at  datetime2(0)    NOT NULL,
            CSTCN_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_CSTCN
                PRIMARY KEY CLUSTERED
                (
                    CSTCN_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : customer.CustomerContact';
        PRINT N'            Prefix                          : CSTCN';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : CSTCN_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : customer.CustomerContact';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: CSTCN_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')

            AND c.name =
                    N'CSTCN_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : CSTCN_id';

            ;THROW 50631,
                N'Column CSTCN_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : CSTCN_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_CSTCN
        --------------------------------------------------------------------------*/

        DECLARE @CSTCN_ActualPrimaryKeyName sysname;


        SELECT
            @CSTCN_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND kc.type =
                N'PK';


        IF @CSTCN_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_CSTCN';

            ;THROW 50632,
                N'Primary key for customer.CustomerContact does not exist.',
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
                    OBJECT_ID(N'customer.CustomerContact')

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
                        N'CSTCN_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @CSTCN_ActualPrimaryKeyName;

            ;THROW 50633,
                N'Primary key does not match the expected clustered definition CSTCN_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @CSTCN_ActualPrimaryKeyName <>
            N'PK_CSTCN'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_CSTCN';
            PRINT N'                Actual                       : '
                + @CSTCN_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_CSTCN';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCN_CST_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerContact',
            N'CSTCN_CST_id'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerContact
                ADD CSTCN_CST_id int NULL;

            PRINT N'            [+] Column added                  : CSTCN_CST_id';
            PRINT N'            [!] Pending action                : Backfill CSTCN_CST_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_CST_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCN_CST_id';

            ;THROW 50634,
                N'Column CSTCN_CST_id does not match the expected data type int.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_CST_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCN_CST_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCN_CST_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCN_CTP_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerContact',
            N'CSTCN_CTP_id'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerContact
                ADD CSTCN_CTP_id tinyint NULL;

            PRINT N'            [+] Column added                  : CSTCN_CTP_id';
            PRINT N'            [!] Pending action                : Backfill CSTCN_CTP_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_CTP_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCN_CTP_id';

            ;THROW 50635,
                N'Column CSTCN_CTP_id does not match the expected data type tinyint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_CTP_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCN_CTP_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCN_CTP_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCN_value
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerContact',
            N'CSTCN_value'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerContact
                ADD CSTCN_value varchar(20) NULL;

            PRINT N'            [+] Column added                  : CSTCN_value';
            PRINT N'            [!] Pending action                : Backfill CSTCN_value before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_value'
            AND TYPE_NAME(c.user_type_id) = N'varchar'
            AND c.max_length = 20
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCN_value';

            ;THROW 50636,
                N'Column CSTCN_value does not match the expected data type varchar(20).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_value'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCN_value';
            PRINT N'            [!] Expected final definition     : varchar(20) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCN_value';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCN_is_primary
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerContact',
            N'CSTCN_is_primary'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerContact
                ADD CSTCN_is_primary bit NULL;

            PRINT N'            [+] Column added                  : CSTCN_is_primary';
            PRINT N'            [!] Pending action                : Backfill CSTCN_is_primary before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_is_primary'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCN_is_primary';

            ;THROW 50637,
                N'Column CSTCN_is_primary does not match the expected data type bit.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_is_primary'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCN_is_primary';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCN_is_primary';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCN_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerContact',
            N'CSTCN_is_active'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerContact
                ADD CSTCN_is_active bit NULL;

            PRINT N'            [+] Column added                  : CSTCN_is_active';
            PRINT N'            [!] Pending action                : Backfill CSTCN_is_active before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_is_active'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCN_is_active';

            ;THROW 50638,
                N'Column CSTCN_is_active does not match the expected data type bit.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_is_active'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCN_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCN_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCN_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerContact',
            N'CSTCN_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerContact
                ADD CSTCN_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CSTCN_created_at';
            PRINT N'            [!] Pending action                : Backfill CSTCN_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCN_created_at';

            ;THROW 50639,
                N'Column CSTCN_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCN_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCN_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCN_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerContact',
            N'CSTCN_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerContact
                ADD CSTCN_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CSTCN_updated_at';
            PRINT N'            [!] Pending action                : Backfill CSTCN_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCN_updated_at';

            ;THROW 50640,
                N'Column CSTCN_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerContact')
            AND c.name = N'CSTCN_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCN_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCN_updated_at';

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
                OBJECT_ID(N'customer.CustomerContact')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : customer.CustomerContact';

        ;THROW 50641,
            N'customer.CustomerContact is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : customer.CustomerContact';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';