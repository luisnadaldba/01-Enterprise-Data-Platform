    /*==============================================================================
        ATLAS COMMERCE - PAYRRNT.PAYRRNTREFUNDREASON
    ==============================================================================

        Object      : payment.PaymentRefundReason
        Type        : Reference Table
        Prefix      : PAYRR
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled reasons used to classify payment refunds in
        Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Use controlled refund reasons instead of free-text classifications.
        - Support consistent operational and analytical interpretation.
        - Store only the refund reason master data in this table.
        - Keep refund events and payment history outside this table.
        - Deploy seed data in the dedicated Seed stage.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy unique constraints in the dedicated Unique stage.
        - Store payment refund reference data in FG_CORE.
        - Do not partition this reference table.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    payment.PaymentRefundReason';
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

    IF OBJECT_ID(N'payment.PaymentRefundReason', N'U') IS NULL
    BEGIN

        CREATE TABLE payment.PaymentRefundReason
        (
            PAYRR_id          tinyint         IDENTITY(1,1) NOT NULL,

            PAYRR_name        varchar(40)     NOT NULL,

            PAYRR_created_at  datetime2(0)    NOT NULL,
            PAYRR_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_PAYRR
                PRIMARY KEY CLUSTERED
                (
                    PAYRR_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : payment.PaymentRefundReason';
        PRINT N'            Prefix                          : PAYRR';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PAYRR_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : payment.PaymentRefundReason';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PAYRR_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'payment.PaymentRefundReason')
            AND c.name = N'PAYRR_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PAYRR_id';

            ;THROW 50901,
                N'Column PAYRR_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PAYRR_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PAYRR
        --------------------------------------------------------------------------*/

        DECLARE @PAYRR_ActualPrimaryKeyName sysname;


        SELECT
            @PAYRR_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND kc.type = N'PK';


        IF @PAYRR_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PAYRR';

            ;THROW 50902,
                N'Primary key for payment.PaymentRefundReason does not exist.',
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
                    OBJECT_ID(N'payment.PaymentRefundReason')

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
                AND c.name = N'PAYRR_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PAYRR_ActualPrimaryKeyName;

            ;THROW 50903,
                N'Primary key does not match the expected clustered definition PAYRR_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PAYRR_ActualPrimaryKeyName <> N'PK_PAYRR'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PAYRR';
            PRINT N'                Actual                       : '
                + @PAYRR_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PAYRR';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYRR_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.PaymentRefundReason', N'PAYRR_name') IS NULL
        BEGIN

            ALTER TABLE payment.PaymentRefundReason
                ADD PAYRR_name varchar(40) NULL;

            PRINT N'            [+] Column added                  : PAYRR_name';
            PRINT N'            [!] Pending action                : Backfill PAYRR_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefundReason')

            AND c.name = N'PAYRR_name'
            AND TYPE_NAME(c.user_type_id) = N'varchar'
            AND c.max_length = 40
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYRR_name';

            ;THROW 50904,
                N'Column PAYRR_name does not match the expected data type varchar(40).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefundReason')

            AND c.name = N'PAYRR_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYRR_name';
            PRINT N'            [!] Expected final definition     : varchar(40) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYRR_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYRR_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.PaymentRefundReason', N'PAYRR_created_at') IS NULL
        BEGIN

            ALTER TABLE payment.PaymentRefundReason
                ADD PAYRR_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAYRR_created_at';
            PRINT N'            [!] Pending action                : Backfill PAYRR_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefundReason')

            AND c.name = N'PAYRR_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYRR_created_at';

            ;THROW 50905,
                N'Column PAYRR_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefundReason')

            AND c.name = N'PAYRR_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYRR_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYRR_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYRR_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.PaymentRefundReason', N'PAYRR_updated_at') IS NULL
        BEGIN

            ALTER TABLE payment.PaymentRefundReason
                ADD PAYRR_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAYRR_updated_at';
            PRINT N'            [!] Pending action                : Backfill PAYRR_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefundReason')

            AND c.name = N'PAYRR_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYRR_updated_at';

            ;THROW 50906,
                N'Column PAYRR_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefundReason')

            AND c.name = N'PAYRR_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYRR_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYRR_updated_at';

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
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : payment.PaymentRefundReason';

        ;THROW 50907,
            N'payment.PaymentRefundReason is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : payment.PaymentRefundReason';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';