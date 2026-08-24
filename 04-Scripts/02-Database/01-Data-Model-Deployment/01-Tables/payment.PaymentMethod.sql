    /*==============================================================================
        ATLAS COMMERCE - PAYMENT.PAYMENTMETHOD
    ==============================================================================

        Object      : payment.PaymentMethod
        Type        : Reference Table
        Prefix      : PAYME
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled payment methods available for Atlas Commerce
        transactions.

        Design Principles
        --------------------------------------------------------------------------
        - Use controlled payment methods instead of free-text classifications.
        - Support consistent operational and analytical interpretation.
        - Store only the payment method master data in this table.
        - Keep payment attempts and payment history outside this table.
        - Deploy seed data in the dedicated Seed stage.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy unique constraints in the dedicated Unique stage.
        - Store payment reference data in FG_CORE.
        - Do not partition this reference table.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● payment.PaymentMethod';
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

        ;THROW 50900,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'payment.PaymentMethod', N'U') IS NULL
    BEGIN

        CREATE TABLE payment.PaymentMethod
        (
            PAYME_id          tinyint         IDENTITY(1,1) NOT NULL,

            PAYME_name        varchar(30)     NOT NULL,

            PAYME_created_at  datetime2(0)    NOT NULL,
            PAYME_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_PAYME
                PRIMARY KEY CLUSTERED
                (
                    PAYME_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : payment.PaymentMethod';
        PRINT N'            Prefix                          : PAYME';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PAYME_id';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : payment.PaymentMethod';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PAYME_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentMethod')

            AND c.name =
                    N'PAYME_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'tinyint'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PAYME_id';

            ;THROW 50901,
                N'Column PAYME_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PAYME_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PAYME
        --------------------------------------------------------------------------*/

        DECLARE @PAYME_ActualPrimaryKeyName sysname;


        SELECT
            @PAYME_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'payment.PaymentMethod')

        AND kc.type =
                N'PK';


        IF @PAYME_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PAYME';

            ;THROW 50902,
                N'Primary key for payment.PaymentMethod does not exist.',
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
                    OBJECT_ID(N'payment.PaymentMethod')

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
                        N'PAYME_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PAYME_ActualPrimaryKeyName;

            ;THROW 50903,
                N'Primary key does not match the expected clustered definition PAYME_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PAYME_ActualPrimaryKeyName <>
                N'PK_PAYME'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PAYME';
            PRINT N'                Actual                       : '
                + @PAYME_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PAYME';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYME_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'payment.PaymentMethod',
            N'PAYME_name'
        ) IS NULL
        BEGIN

            ALTER TABLE payment.PaymentMethod
                ADD PAYME_name varchar(30) NULL;

            PRINT N'            [+] Column added                  : PAYME_name';
            PRINT N'            [!] Pending action                : Backfill PAYME_name before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentMethod')

            AND c.name =
                    N'PAYME_name'

            AND TYPE_NAME(c.user_type_id) =
                    N'varchar'

            AND c.max_length = 30
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYME_name';

            ;THROW 50904,
                N'Column PAYME_name does not match the expected data type varchar(30).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentMethod')

            AND c.name =
                    N'PAYME_name'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYME_name';
            PRINT N'            [!] Expected final definition     : varchar(30) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYME_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYME_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'payment.PaymentMethod',
            N'PAYME_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE payment.PaymentMethod
                ADD PAYME_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAYME_created_at';
            PRINT N'            [!] Pending action                : Backfill PAYME_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentMethod')

            AND c.name =
                    N'PAYME_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYME_created_at';

            ;THROW 50905,
                N'Column PAYME_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentMethod')

            AND c.name =
                    N'PAYME_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYME_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYME_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYME_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'payment.PaymentMethod',
            N'PAYME_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE payment.PaymentMethod
                ADD PAYME_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAYME_updated_at';
            PRINT N'            [!] Pending action                : Backfill PAYME_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentMethod')

            AND c.name =
                    N'PAYME_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYME_updated_at';

            ;THROW 50906,
                N'Column PAYME_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentMethod')

            AND c.name =
                    N'PAYME_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYME_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYME_updated_at';

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
                OBJECT_ID(N'payment.PaymentMethod')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : payment.PaymentMethod';

        ;THROW 50907,
            N'payment.PaymentMethod is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : payment.PaymentMethod';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';