    /*==============================================================================
        ATLAS COMMERCE - PAYSTNT.PAYSTNTSTATUS
    ==============================================================================

        Object      : payment.PaymentStatus
        Type        : Reference Table
        Prefix      : PAYST
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled payment statuses used by Atlas Commerce
        payment transactions.

        Design Principles
        --------------------------------------------------------------------------
        - Use controlled payment statuses instead of free-text classifications.
        - Support consistent operational and analytical interpretation.
        - Store only the payment status master data in this table.
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
    PRINT N'    payment.PaymentStatus';
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

        ;THROW 50900,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'payment.PaymentStatus', N'U') IS NULL
    BEGIN

        CREATE TABLE payment.PaymentStatus
        (
            PAYST_id          tinyint         IDENTITY(1,1) NOT NULL,

            PAYST_name        varchar(30)     NOT NULL,

            PAYST_created_at  datetime2(0)    NOT NULL,
            PAYST_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_PAYST
                PRIMARY KEY CLUSTERED
                (
                    PAYST_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : payment.PaymentStatus';
        PRINT N'            Prefix                          : PAYST';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PAYST_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : payment.PaymentStatus';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PAYST_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'payment.PaymentStatus')
            AND c.name = N'PAYST_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PAYST_id';

            ;THROW 50901,
                N'Column PAYST_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PAYST_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PAYST
        --------------------------------------------------------------------------*/

        DECLARE @PAYST_ActualPrimaryKeyName sysname;


        SELECT
            @PAYST_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND kc.type = N'PK';


        IF @PAYST_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PAYST';

            ;THROW 50902,
                N'Primary key for payment.PaymentStatus does not exist.',
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
                    OBJECT_ID(N'payment.PaymentStatus')

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
                AND c.name = N'PAYST_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PAYST_ActualPrimaryKeyName;

            ;THROW 50903,
                N'Primary key does not match the expected clustered definition PAYST_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PAYST_ActualPrimaryKeyName <> N'PK_PAYST'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PAYST';
            PRINT N'                Actual                       : '
                + @PAYST_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PAYST';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYST_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.PaymentStatus', N'PAYST_name') IS NULL
        BEGIN

            ALTER TABLE payment.PaymentStatus
                ADD PAYST_name varchar(30) NULL;

            PRINT N'            [+] Column added                  : PAYST_name';
            PRINT N'            [!] Pending action                : Backfill PAYST_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentStatus')

            AND c.name = N'PAYST_name'
            AND TYPE_NAME(c.user_type_id) = N'varchar'
            AND c.max_length = 30
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYST_name';

            ;THROW 50904,
                N'Column PAYST_name does not match the expected data type varchar(30).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentStatus')

            AND c.name = N'PAYST_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYST_name';
            PRINT N'            [!] Expected final definition     : varchar(30) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYST_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYST_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.PaymentStatus', N'PAYST_created_at') IS NULL
        BEGIN

            ALTER TABLE payment.PaymentStatus
                ADD PAYST_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAYST_created_at';
            PRINT N'            [!] Pending action                : Backfill PAYST_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentStatus')

            AND c.name = N'PAYST_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYST_created_at';

            ;THROW 50905,
                N'Column PAYST_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentStatus')

            AND c.name = N'PAYST_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYST_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYST_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYST_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.PaymentStatus', N'PAYST_updated_at') IS NULL
        BEGIN

            ALTER TABLE payment.PaymentStatus
                ADD PAYST_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAYST_updated_at';
            PRINT N'            [!] Pending action                : Backfill PAYST_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentStatus')

            AND c.name = N'PAYST_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYST_updated_at';

            ;THROW 50906,
                N'Column PAYST_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentStatus')

            AND c.name = N'PAYST_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYST_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYST_updated_at';

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
                OBJECT_ID(N'payment.PaymentStatus')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : payment.PaymentStatus';

        ;THROW 50907,
            N'payment.PaymentStatus is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : payment.PaymentStatus';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';