    /*==============================================================================
        ATLAS COMMERCE - PAYMENT.PAYMENTREFUND
    ==============================================================================

        Object      : payment.PaymentRefund
        Type        : Operational Transaction Table
        Prefix      : PAYRF
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Records full and partial refund events associated with Atlas Commerce
        payment operations, preserving refund amount, reason and business-event
        timestamp for operational and analytical use.

        Design Principles
        --------------------------------------------------------------------------
        - Allow multiple refund events for the same Payment.
        - Preserve partial refunds as independent historical events.
        - Associate each refund with a standardized refund reason.
        - Store the amount associated with each individual refund event.
        - Preserve the refund business-event timestamp separately from row audit
        timestamps.
        - Validate positive refund amounts in the dedicated Checks stage.
        - Validate relationships in the dedicated FK stage.
        - Enforce aggregate refund integrity in a dedicated integrity stage so the
        cumulative refunded amount cannot exceed the original payment amount.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy additional indexes in the dedicated Indexes stage when required.
        - Store payment refund operational data in FG_CORE.
        - Do not partition this table in the current training scope.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● payment.PaymentRefund';
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

        ;THROW 50960,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'payment.PaymentRefund', N'U') IS NULL
    BEGIN

        CREATE TABLE payment.PaymentRefund
        (
            PAYRF_id              bigint          IDENTITY(1,1) NOT NULL,

            PAYRF_PAY_id          bigint          NOT NULL,
            PAYRF_PAYRR_id        tinyint         NOT NULL,

            PAYRF_amount          decimal(19,2)   NOT NULL,
            PAYRF_refunded_at     datetime2(0)    NOT NULL,

            PAYRF_created_at      datetime2(0)    NOT NULL,
            PAYRF_updated_at      datetime2(0)    NOT NULL,

            CONSTRAINT PK_PAYRF
                PRIMARY KEY CLUSTERED
                (
                    PAYRF_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : payment.PaymentRefund';
        PRINT N'            Prefix                          : PAYRF';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PAYRF_id';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : payment.PaymentRefund';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PAYRF_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'bigint'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PAYRF_id';

            ;THROW 50961,
                N'Column PAYRF_id does not match the expected definition bigint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PAYRF_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PAYRF
        --------------------------------------------------------------------------*/

        DECLARE @PAYRF_ActualPrimaryKeyName sysname;


        SELECT
            @PAYRF_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND kc.type =
                N'PK';


        IF @PAYRF_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PAYRF';

            ;THROW 50962,
                N'Primary key for payment.PaymentRefund does not exist.',
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
                    OBJECT_ID(N'payment.PaymentRefund')

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
                        N'PAYRF_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PAYRF_ActualPrimaryKeyName;

            ;THROW 50963,
                N'Primary key does not match the expected clustered definition PAYRF_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PAYRF_ActualPrimaryKeyName <>
                N'PK_PAYRF'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PAYRF';
            PRINT N'                Actual                       : '
                + @PAYRF_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PAYRF';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYRF_PAY_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'payment.PaymentRefund',
            N'PAYRF_PAY_id'
        ) IS NULL
        BEGIN

            ALTER TABLE payment.PaymentRefund
                ADD PAYRF_PAY_id bigint NULL;

            PRINT N'            [+] Column added                  : PAYRF_PAY_id';
            PRINT N'            [!] Pending action                : Backfill PAYRF_PAY_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_PAY_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'bigint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYRF_PAY_id';

            ;THROW 50964,
                N'Column PAYRF_PAY_id does not match the expected data type bigint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_PAY_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYRF_PAY_id';
            PRINT N'            [!] Expected final definition     : bigint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYRF_PAY_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYRF_PAYRR_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'payment.PaymentRefund',
            N'PAYRF_PAYRR_id'
        ) IS NULL
        BEGIN

            ALTER TABLE payment.PaymentRefund
                ADD PAYRF_PAYRR_id tinyint NULL;

            PRINT N'            [+] Column added                  : PAYRF_PAYRR_id';
            PRINT N'            [!] Pending action                : Backfill PAYRF_PAYRR_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_PAYRR_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYRF_PAYRR_id';

            ;THROW 50965,
                N'Column PAYRF_PAYRR_id does not match the expected data type tinyint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_PAYRR_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYRF_PAYRR_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYRF_PAYRR_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYRF_amount
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'payment.PaymentRefund',
            N'PAYRF_amount'
        ) IS NULL
        BEGIN

            ALTER TABLE payment.PaymentRefund
                ADD PAYRF_amount decimal(19,2) NULL;

            PRINT N'            [+] Column added                  : PAYRF_amount';
            PRINT N'            [!] Pending action                : Backfill PAYRF_amount before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_amount'

            AND TYPE_NAME(c.user_type_id) =
                    N'decimal'

            AND c.precision = 19

            AND c.scale = 2
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYRF_amount';

            ;THROW 50966,
                N'Column PAYRF_amount does not match the expected data type decimal(19,2).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_amount'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYRF_amount';
            PRINT N'            [!] Expected final definition     : decimal(19,2) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYRF_amount';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYRF_refunded_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'payment.PaymentRefund',
            N'PAYRF_refunded_at'
        ) IS NULL
        BEGIN

            ALTER TABLE payment.PaymentRefund
                ADD PAYRF_refunded_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAYRF_refunded_at';
            PRINT N'            [!] Pending action                : Backfill PAYRF_refunded_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_refunded_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYRF_refunded_at';

            ;THROW 50967,
                N'Column PAYRF_refunded_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_refunded_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYRF_refunded_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYRF_refunded_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYRF_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'payment.PaymentRefund',
            N'PAYRF_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE payment.PaymentRefund
                ADD PAYRF_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAYRF_created_at';
            PRINT N'            [!] Pending action                : Backfill PAYRF_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYRF_created_at';

            ;THROW 50968,
                N'Column PAYRF_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYRF_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYRF_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PAYRF_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'payment.PaymentRefund',
            N'PAYRF_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE payment.PaymentRefund
                ADD PAYRF_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : PAYRF_updated_at';
            PRINT N'            [!] Pending action                : Backfill PAYRF_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PAYRF_updated_at';

            ;THROW 50969,
                N'Column PAYRF_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'payment.PaymentRefund')

            AND c.name =
                    N'PAYRF_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PAYRF_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PAYRF_updated_at';

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
                OBJECT_ID(N'payment.PaymentRefund')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : payment.PaymentRefund';

        ;THROW 50970,
            N'payment.PaymentRefund is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : payment.PaymentRefund';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';