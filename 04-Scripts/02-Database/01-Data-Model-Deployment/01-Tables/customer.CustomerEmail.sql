    /*==============================================================================
        ATLAS COMMERCE - CUSTOMER.CUSTOMEREMAIL
    ==============================================================================

        Object      : customer.CustomerEmail
        Type        : Dependent Table
        Prefix      : CSTEM
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains email addresses associated with identified customers while
        allowing the same email address to be shared by multiple customers.

        Design Principles
        --------------------------------------------------------------------------
        - Associate each CustomerEmail with one Customer.
        - Allow multiple email addresses for the same customer.
        - Allow the same email address to be associated with multiple customers.
        - Support shared email addresses used by parents, guardians or households.
        - Identify the primary active email independently from historical emails.
        - Preserve inactive email records when they are no longer in use.
        - Do not enforce global uniqueness on the email address.
        - Store customer email data in FG_CORE.
        - Do not partition customer dependent tables.
        - Deploy check constraints in the dedicated check constraint stage.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Deploy additional indexes in the dedicated index stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    customer.CustomerEmail';
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

        ;THROW 50700,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerEmail', N'U') IS NULL
    BEGIN

        CREATE TABLE customer.CustomerEmail
        (
            CSTEM_id          int             IDENTITY(1,1) NOT NULL,

            CSTEM_CST_id      int             NOT NULL,

            CSTEM_email       varchar(254)    NOT NULL,

            CSTEM_is_primary  bit             NOT NULL,
            CSTEM_is_active   bit             NOT NULL,

            CSTEM_created_at  datetime2(0)    NOT NULL,
            CSTEM_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_CSTEM
                PRIMARY KEY CLUSTERED
                (
                    CSTEM_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : customer.CustomerEmail';
        PRINT N'            Prefix                          : CSTEM';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : CSTEM_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : customer.CustomerEmail';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: CSTEM_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : CSTEM_id';

            ;THROW 50701,
                N'Column CSTEM_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : CSTEM_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_CSTEM
        --------------------------------------------------------------------------*/

        DECLARE @CSTEM_ActualPrimaryKeyName sysname;


        SELECT
            @CSTEM_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND kc.type =
                N'PK';


        IF @CSTEM_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_CSTEM';

            ;THROW 50702,
                N'Primary key for customer.CustomerEmail does not exist.',
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
                    OBJECT_ID(N'customer.CustomerEmail')

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
                        N'CSTEM_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @CSTEM_ActualPrimaryKeyName;

            ;THROW 50703,
                N'Primary key does not match the expected clustered definition CSTEM_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @CSTEM_ActualPrimaryKeyName <>
            N'PK_CSTEM'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_CSTEM';
            PRINT N'                Actual                       : '
                + @CSTEM_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_CSTEM';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTEM_CST_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerEmail',
            N'CSTEM_CST_id'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerEmail
                ADD CSTEM_CST_id int NULL;

            PRINT N'            [+] Column added                  : CSTEM_CST_id';
            PRINT N'            [!] Pending action                : Backfill CSTEM_CST_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_CST_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTEM_CST_id';

            ;THROW 50704,
                N'Column CSTEM_CST_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_CST_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTEM_CST_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTEM_CST_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTEM_email
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerEmail',
            N'CSTEM_email'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerEmail
                ADD CSTEM_email varchar(254) NULL;

            PRINT N'            [+] Column added                  : CSTEM_email';
            PRINT N'            [!] Pending action                : Backfill CSTEM_email before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_email'

            AND TYPE_NAME(c.user_type_id) =
                    N'varchar'

            AND c.max_length = 254
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTEM_email';

            ;THROW 50705,
                N'Column CSTEM_email does not match the expected data type varchar(254).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_email'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTEM_email';
            PRINT N'            [!] Expected final definition     : varchar(254) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTEM_email';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTEM_is_primary
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerEmail',
            N'CSTEM_is_primary'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerEmail
                ADD CSTEM_is_primary bit NULL;

            PRINT N'            [+] Column added                  : CSTEM_is_primary';
            PRINT N'            [!] Pending action                : Backfill CSTEM_is_primary before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_is_primary'

            AND TYPE_NAME(c.user_type_id) =
                    N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTEM_is_primary';

            ;THROW 50706,
                N'Column CSTEM_is_primary does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_is_primary'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTEM_is_primary';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTEM_is_primary';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTEM_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerEmail',
            N'CSTEM_is_active'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerEmail
                ADD CSTEM_is_active bit NULL;

            PRINT N'            [+] Column added                  : CSTEM_is_active';
            PRINT N'            [!] Pending action                : Backfill CSTEM_is_active before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_is_active'

            AND TYPE_NAME(c.user_type_id) =
                    N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTEM_is_active';

            ;THROW 50707,
                N'Column CSTEM_is_active does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_is_active'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTEM_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTEM_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTEM_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerEmail',
            N'CSTEM_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerEmail
                ADD CSTEM_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CSTEM_created_at';
            PRINT N'            [!] Pending action                : Backfill CSTEM_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTEM_created_at';

            ;THROW 50708,
                N'Column CSTEM_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTEM_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTEM_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTEM_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerEmail',
            N'CSTEM_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerEmail
                ADD CSTEM_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CSTEM_updated_at';
            PRINT N'            [!] Pending action                : Backfill CSTEM_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTEM_updated_at';

            ;THROW 50709,
                N'Column CSTEM_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND c.name =
                    N'CSTEM_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTEM_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTEM_updated_at';

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
                OBJECT_ID(N'customer.CustomerEmail')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : customer.CustomerEmail';

        ;THROW 50710,
            N'customer.CustomerEmail is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : customer.CustomerEmail';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';