    /*==============================================================================
        ATLAS COMMERCE - PAYMENT.PAYMENT
    ==============================================================================

        Object      : payment.Payment
        Type        : Operational Transaction Table
        Prefix      : PAY
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Records payment attempts associated with Atlas Commerce sales
        transactions, including successful, declined, pending and cancelled
        payment operations.

        Design Principles
        --------------------------------------------------------------------------
        - Allow multiple payment attempts or payment methods per Transaction.
        - Preserve unsuccessful payment attempts for operational and analytical use.
        - Store the amount associated with each individual payment operation.
        - Preserve the originating sales transaction timestamp required by the
          composite relationship with sales.[Transaction].
        - Store installment count only when installment payment applies.
        - Preserve business-event timestamps separately from row audit timestamps.
        - Keep refund events outside this table in payment.PaymentRefund.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy check constraints in the dedicated Checks stage.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Deploy additional indexes in the dedicated Indexes stage when required.
        - Store payment operational data in FG_CORE.
        - Do not partition this table in the current training scope.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    payment.Payment';
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

        ;THROW 50920,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'payment.Payment', N'U') IS NULL
    BEGIN

        CREATE TABLE payment.Payment
        (
            PAY_id                  bigint          IDENTITY(1,1) NOT NULL,

            PAY_TRN_id              bigint          NOT NULL,
            PAY_transaction_at      datetime2(0)    NOT NULL,

            PAY_PAYME_id            tinyint         NOT NULL,
            PAY_PAYST_id            tinyint         NOT NULL,

            PAY_amount              decimal(19,2)   NOT NULL,
            PAY_installment_count   tinyint         NULL,

            PAY_attempted_at        datetime2(0)    NOT NULL,
            PAY_approved_at         datetime2(0)    NULL,
            PAY_cancelled_at        datetime2(0)    NULL,

            PAY_created_at          datetime2(0)    NOT NULL,
            PAY_updated_at          datetime2(0)    NOT NULL,

            CONSTRAINT PK_PAY
                PRIMARY KEY CLUSTERED
                (
                    PAY_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : payment.Payment';
        PRINT N'            Prefix                          : PAY';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PAY_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : payment.Payment';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PAY_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_id'
            AND TYPE_NAME(c.user_type_id) = N'bigint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PAY_id';

            ;THROW 50921,
                N'Column PAY_id does not match the expected definition bigint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PAY_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PAY
        --------------------------------------------------------------------------*/

        DECLARE @PAY_ActualPrimaryKeyName sysname;


        SELECT
            @PAY_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'payment.Payment')

        AND kc.type = N'PK';


        IF @PAY_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PAY';

            ;THROW 50922,
                N'Primary key for payment.Payment does not exist.',
                1;

        END;


        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.key_constraints AS kc

            INNER JOIN sys.indexes AS i
                ON  i.object_id = kc.parent_object_id
                AND i.index_id = kc.unique_index_id

            WHERE kc.parent_object_id =
                    OBJECT_ID(N'payment.Payment')

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
                AND c.name = N'PAY_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PAY_ActualPrimaryKeyName;

            ;THROW 50923,
                N'Primary key does not match the expected clustered definition PAY_id.',
                1;

        END;


        IF @PAY_ActualPrimaryKeyName <> N'PK_PAY'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PAY';
            PRINT N'                Actual                       : '
                + @PAY_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PAY';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_TRN_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_TRN_id') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_TRN_id bigint NULL;

            PRINT N'            [+] Column added                  : PAY_TRN_id';
            PRINT N'            [!] Pending action                : Backfill PAY_TRN_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_TRN_id'
            AND TYPE_NAME(c.user_type_id) = N'bigint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_TRN_id';

            ;THROW 50924,
                N'Column PAY_TRN_id does not match the expected data type bigint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_TRN_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAY_TRN_id';
            PRINT N'            [!] Expected final definition     : bigint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_TRN_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_transaction_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_transaction_at') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_transaction_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAY_transaction_at';
            PRINT N'            [!] Pending action                : Backfill PAY_transaction_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_transaction_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_transaction_at';

            ;THROW 50925,
                N'Column PAY_transaction_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_transaction_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAY_transaction_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_transaction_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_PAYME_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_PAYME_id') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_PAYME_id tinyint NULL;

            PRINT N'            [+] Column added                  : PAY_PAYME_id';
            PRINT N'            [!] Pending action                : Backfill PAY_PAYME_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_PAYME_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_PAYME_id';

            ;THROW 50926,
                N'Column PAY_PAYME_id does not match the expected data type tinyint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_PAYME_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAY_PAYME_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_PAYME_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_PAYST_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_PAYST_id') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_PAYST_id tinyint NULL;

            PRINT N'            [+] Column added                  : PAY_PAYST_id';
            PRINT N'            [!] Pending action                : Backfill PAY_PAYST_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_PAYST_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_PAYST_id';

            ;THROW 50927,
                N'Column PAY_PAYST_id does not match the expected data type tinyint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_PAYST_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAY_PAYST_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_PAYST_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_amount
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_amount') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_amount decimal(19,2) NULL;

            PRINT N'            [+] Column added                  : PAY_amount';
            PRINT N'            [!] Pending action                : Backfill PAY_amount before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_amount'
            AND TYPE_NAME(c.user_type_id) = N'decimal'
            AND c.precision = 19
            AND c.scale = 2
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_amount';

            ;THROW 50928,
                N'Column PAY_amount does not match the expected data type decimal(19,2).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_amount'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAY_amount';
            PRINT N'            [!] Expected final definition     : decimal(19,2) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_amount';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_installment_count
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_installment_count') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_installment_count tinyint NULL;

            PRINT N'            [+] Column added                  : PAY_installment_count';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_installment_count'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_installment_count';

            ;THROW 50929,
                N'Column PAY_installment_count does not match the expected definition tinyint NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_installment_count';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_attempted_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_attempted_at') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_attempted_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAY_attempted_at';
            PRINT N'            [!] Pending action                : Backfill PAY_attempted_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_attempted_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_attempted_at';

            ;THROW 50930,
                N'Column PAY_attempted_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_attempted_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAY_attempted_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_attempted_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_approved_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_approved_at') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_approved_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAY_approved_at';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_approved_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_approved_at';

            ;THROW 50931,
                N'Column PAY_approved_at does not match the expected definition datetime2(0) NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_approved_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_cancelled_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_cancelled_at') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_cancelled_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAY_cancelled_at';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_cancelled_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_cancelled_at';

            ;THROW 50932,
                N'Column PAY_cancelled_at does not match the expected definition datetime2(0) NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_cancelled_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_created_at') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAY_created_at';
            PRINT N'            [!] Pending action                : Backfill PAY_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_created_at';

            ;THROW 50933,
                N'Column PAY_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAY_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAY_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'payment.Payment', N'PAY_updated_at') IS NULL
        BEGIN

            ALTER TABLE payment.Payment
                ADD PAY_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAY_updated_at';
            PRINT N'            [!] Pending action                : Backfill PAY_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAY_updated_at';

            ;THROW 50934,
                N'Column PAY_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'payment.Payment')
            AND c.name = N'PAY_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAY_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAY_updated_at';

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
                OBJECT_ID(N'payment.Payment')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : payment.Payment';

        ;THROW 50935,
            N'payment.Payment is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : payment.Payment';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';