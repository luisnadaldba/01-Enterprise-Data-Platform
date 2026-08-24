    /*==============================================================================
        ATLAS COMMERCE - SHIPPING.SHIPMENT
    ==============================================================================

        Object      : shipping.Shipment
        Type        : Operational Transaction Table
        Prefix      : SHP
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Records the delivery process associated with Atlas Commerce online sales
        transactions.

        Design Principles
        --------------------------------------------------------------------------
        - Allow at most one shipment per sales Transaction.
        - Create shipments only for transactions requiring delivery.
        - Preserve the originating sales transaction timestamp required by the
        composite relationship with sales.[Transaction].
        - Reference the customer address selected for the shipment without
        duplicating address data.
        - Preserve the shipment method and current shipment status through
        controlled reference tables.
        - Preserve the shipping amount charged to the customer for this shipment.
        - Preserve the delivery date estimate presented at checkout.
        - Store postal tracking information only after it becomes available.
        - Preserve posting and delivery business-event timestamps separately from
        row audit timestamps.
        - Keep detailed postal tracking events outside the current training scope.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy check constraints in the dedicated Checks stage.
        - Deploy unique constraints and indexes in their dedicated stages.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Store shipment operational data in FG_CORE.
        - Do not partition this table in the current training scope.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● shipping.Shipment';
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

        ;THROW 51200,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'shipping.Shipment', N'U') IS NULL
    BEGIN

        CREATE TABLE shipping.Shipment
        (
            SHP_id                         bigint          IDENTITY(1,1) NOT NULL,

            SHP_TRN_id                     bigint          NOT NULL,
            SHP_transaction_at             datetime2(0)    NOT NULL,

            SHP_CSTAD_id                   int             NOT NULL,
            SHP_SHPMT_id                   tinyint         NOT NULL,
            SHP_SHPST_id                   tinyint         NOT NULL,

            SHP_shipping_amount            decimal(19,2)   NOT NULL,
            SHP_estimated_delivery_date    date            NOT NULL,

            SHP_tracking_code              varchar(30)     NULL,

            SHP_posted_at                  datetime2(0)    NULL,
            SHP_delivered_at               datetime2(0)    NULL,

            SHP_created_at                 datetime2(0)    NOT NULL,
            SHP_updated_at                 datetime2(0)    NOT NULL,

            CONSTRAINT PK_SHP
                PRIMARY KEY CLUSTERED
                (
                    SHP_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : shipping.Shipment';
        PRINT N'            Prefix                          : SHP';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : SHP_id';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : shipping.Shipment';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: SHP_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'bigint'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : SHP_id';

            ;THROW 51201,
                N'Column SHP_id does not match the expected definition bigint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : SHP_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_SHP
        --------------------------------------------------------------------------*/

        DECLARE @SHP_ActualPrimaryKeyName sysname;


        SELECT
            @SHP_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND kc.type =
                N'PK';


        IF @SHP_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_SHP';

            ;THROW 51202,
                N'Primary key for shipping.Shipment does not exist.',
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
                    OBJECT_ID(N'shipping.Shipment')

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
                        N'SHP_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @SHP_ActualPrimaryKeyName;

            ;THROW 51203,
                N'Primary key does not match the expected clustered definition SHP_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @SHP_ActualPrimaryKeyName <>
                N'PK_SHP'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_SHP';
            PRINT N'                Actual                       : '
                + @SHP_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_SHP';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_TRN_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_TRN_id'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_TRN_id bigint NULL;

            PRINT N'            [+] Column added                  : SHP_TRN_id';
            PRINT N'            [!] Pending action                : Backfill SHP_TRN_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_TRN_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'bigint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_TRN_id';

            ;THROW 51204,
                N'Column SHP_TRN_id does not match the expected data type bigint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_TRN_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHP_TRN_id';
            PRINT N'            [!] Expected final definition     : bigint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_TRN_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_transaction_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_transaction_at'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_transaction_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : SHP_transaction_at';
            PRINT N'            [!] Pending action                : Backfill SHP_transaction_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_transaction_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_transaction_at';

            ;THROW 51205,
                N'Column SHP_transaction_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_transaction_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHP_transaction_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_transaction_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_CSTAD_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_CSTAD_id'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_CSTAD_id int NULL;

            PRINT N'            [+] Column added                  : SHP_CSTAD_id';
            PRINT N'            [!] Pending action                : Backfill SHP_CSTAD_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_CSTAD_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_CSTAD_id';

            ;THROW 51206,
                N'Column SHP_CSTAD_id does not match the expected data type int.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_CSTAD_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHP_CSTAD_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_CSTAD_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_SHPMT_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_SHPMT_id'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_SHPMT_id tinyint NULL;

            PRINT N'            [+] Column added                  : SHP_SHPMT_id';
            PRINT N'            [!] Pending action                : Backfill SHP_SHPMT_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_SHPMT_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_SHPMT_id';

            ;THROW 51207,
                N'Column SHP_SHPMT_id does not match the expected data type tinyint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_SHPMT_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHP_SHPMT_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_SHPMT_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_SHPST_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_SHPST_id'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_SHPST_id tinyint NULL;

            PRINT N'            [+] Column added                  : SHP_SHPST_id';
            PRINT N'            [!] Pending action                : Backfill SHP_SHPST_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_SHPST_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_SHPST_id';

            ;THROW 51208,
                N'Column SHP_SHPST_id does not match the expected data type tinyint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_SHPST_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHP_SHPST_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_SHPST_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_shipping_amount
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_shipping_amount'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_shipping_amount decimal(19,2) NULL;

            PRINT N'            [+] Column added                  : SHP_shipping_amount';
            PRINT N'            [!] Pending action                : Backfill SHP_shipping_amount before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_shipping_amount'

            AND TYPE_NAME(c.user_type_id) =
                    N'decimal'

            AND c.precision = 19

            AND c.scale = 2
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_shipping_amount';

            ;THROW 51209,
                N'Column SHP_shipping_amount does not match the expected data type decimal(19,2).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_shipping_amount'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHP_shipping_amount';
            PRINT N'            [!] Expected final definition     : decimal(19,2) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_shipping_amount';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_estimated_delivery_date
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_estimated_delivery_date'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_estimated_delivery_date date NULL;

            PRINT N'            [+] Column added                  : SHP_estimated_delivery_date';
            PRINT N'            [!] Pending action                : Backfill SHP_estimated_delivery_date before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_estimated_delivery_date'

            AND TYPE_NAME(c.user_type_id) =
                    N'date'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_estimated_delivery_date';

            ;THROW 51210,
                N'Column SHP_estimated_delivery_date does not match the expected data type date.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_estimated_delivery_date'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHP_estimated_delivery_date';
            PRINT N'            [!] Expected final definition     : date NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_estimated_delivery_date';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_tracking_code
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_tracking_code'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_tracking_code varchar(30) NULL;

            PRINT N'            [+] Column added                  : SHP_tracking_code';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_tracking_code'

            AND TYPE_NAME(c.user_type_id) =
                    N'varchar'

            AND c.max_length = 30

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_tracking_code';

            ;THROW 51211,
                N'Column SHP_tracking_code does not match the expected definition varchar(30) NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_tracking_code';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_posted_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_posted_at'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_posted_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : SHP_posted_at';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_posted_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_posted_at';

            ;THROW 51212,
                N'Column SHP_posted_at does not match the expected definition datetime2(0) NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_posted_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_delivered_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_delivered_at'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_delivered_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : SHP_delivered_at';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_delivered_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_delivered_at';

            ;THROW 51213,
                N'Column SHP_delivered_at does not match the expected definition datetime2(0) NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_delivered_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : SHP_created_at';
            PRINT N'            [!] Pending action                : Backfill SHP_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_created_at';

            ;THROW 51214,
                N'Column SHP_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHP_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHP_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.Shipment',
            N'SHP_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.Shipment
                ADD SHP_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : SHP_updated_at';
            PRINT N'            [!] Pending action                : Backfill SHP_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHP_updated_at';

            ;THROW 51215,
                N'Column SHP_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.Shipment')

            AND c.name =
                    N'SHP_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHP_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHP_updated_at';

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
                OBJECT_ID(N'shipping.Shipment')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : shipping.Shipment';

        ;THROW 51216,
            N'shipping.Shipment is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : shipping.Shipment';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';