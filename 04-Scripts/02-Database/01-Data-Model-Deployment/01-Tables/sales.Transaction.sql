    /*==============================================================================
        ATLAS COMMERCE - SALES.TRANSACTION
    ==============================================================================

        Object      : sales.[Transaction]
        Type        : Transactional Table
        Prefix      : TRN
        Database    : AtlasCommerce

        Purpose
        --------------------------------------------------------------------------
        Stores the core sales transaction record.

        Design Principles
        --------------------------------------------------------------------------
        - Keep the transaction record narrow.
        - Store only attributes required by the transactional core.
        - Use numeric foreign keys instead of repeated descriptive strings.
        - Allow anonymous customers.
        - Preserve business transaction time independently from record creation time.
        - Support incremental data pipelines through creation and update timestamps.
        - Partition transaction data by business transaction date.

        Partitioning
        --------------------------------------------------------------------------
        Partition Function : PF_SALES_MONTHLY
        Partition Scheme   : PS_SALES_MONTHLY
        Partition Column   : TRN_transaction_at
        Range              : RIGHT

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    sales.Transaction';
    PRINT N'    ------------------------------------------------------------';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.partition_functions
        WHERE name = N'PF_SALES_MONTHLY'
    )
    BEGIN

        ;THROW 50030,
            N'Required partition function PF_SALES_MONTHLY does not exist.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.partition_schemes
        WHERE name = N'PS_SALES_MONTHLY'
    )
    BEGIN

        ;THROW 50031,
            N'Required partition scheme PS_SALES_MONTHLY does not exist.',
            1;

    END;


    PRINT N'        [✓] Partition dependencies validated';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'sales.[Transaction]', N'U') IS NULL
    BEGIN

        CREATE TABLE sales.[Transaction]
        (
            TRN_id                 bigint          IDENTITY(1,1) NOT NULL,
            TRN_transaction_at     datetime2(0)    NOT NULL,

            TRN_CST_id             int             NULL,
            TRN_TRNST_id           tinyint         NOT NULL,
            TRN_TRNCH_id           tinyint         NOT NULL,

            TRN_gross_amount       decimal(19,2)   NOT NULL,
            TRN_discount_amount    decimal(19,2)   NOT NULL,
            TRN_shipping_amount    decimal(19,2)   NOT NULL,

            TRN_created_at         datetime2(0)    NOT NULL,
            TRN_updated_at         datetime2(0)    NOT NULL,

            CONSTRAINT PK_TRN
                PRIMARY KEY CLUSTERED
                (
                    TRN_id,
                    TRN_transaction_at
                )
                ON PS_SALES_MONTHLY(TRN_transaction_at)
        )
        ON PS_SALES_MONTHLY(TRN_transaction_at);


        PRINT N'        [+] Table created                   : sales.Transaction';
        PRINT N'            Prefix                          : TRN';
        PRINT N'            Partition Scheme                : PS_SALES_MONTHLY';
        PRINT N'            Partition Column                : TRN_transaction_at';
        PRINT N'            Primary Key                     : TRN_id, TRN_transaction_at';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : sales.Transaction';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: TRN_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_id'
            AND TYPE_NAME(c.user_type_id) = N'bigint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : TRN_id';

            ;THROW 50032,
                N'Column TRN_id does not match the expected definition bigint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : TRN_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY / PARTITION COLUMN: TRN_transaction_at
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_transaction_at'
        )
        BEGIN

            PRINT N'            [X] Partition column missing      : TRN_transaction_at';

            ;THROW 50033,
                N'Partition column TRN_transaction_at is missing. Automatic creation is not safe because the column participates in the primary key and partitioning architecture.',
                1;

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_transaction_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
            AND c.is_nullable = 0
        )
        BEGIN

            PRINT N'            [X] Partition column mismatch     : TRN_transaction_at';

            ;THROW 50034,
                N'Partition column TRN_transaction_at does not match the expected definition datetime2(0) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Partition column validated    : TRN_transaction_at';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_TRN
        --------------------------------------------------------------------------*/

        DECLARE @TRN_ActualPrimaryKeyName sysname;

        SELECT
            @TRN_ActualPrimaryKeyName = kc.name
        FROM sys.key_constraints AS kc
        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id
        WHERE kc.parent_object_id = OBJECT_ID(N'sales.[Transaction]')
          AND kc.type = N'PK';


        IF @TRN_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_TRN';

            ;THROW 50035,
                N'Primary key for sales.Transaction does not exist.',
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

            WHERE kc.parent_object_id = OBJECT_ID(N'sales.[Transaction]')
              AND kc.type = N'PK'

              -- Clustered and unique
              AND i.type = 1
              AND i.is_unique = 1

              -- Exactly two key columns
              AND
              (
                  SELECT COUNT(*)
                  FROM sys.index_columns AS ic
                  WHERE ic.object_id = kc.parent_object_id
                    AND ic.index_id = kc.unique_index_id
                    AND ic.key_ordinal > 0
              ) = 2

              -- First key column: TRN_id
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
                    AND c.name = N'TRN_id'
              )

              -- Second key column: TRN_transaction_at
              AND EXISTS
              (
                  SELECT 1
                  FROM sys.index_columns AS ic

                  INNER JOIN sys.columns AS c
                      ON  c.object_id = ic.object_id
                      AND c.column_id = ic.column_id

                  WHERE ic.object_id = kc.parent_object_id
                    AND ic.index_id = kc.unique_index_id
                    AND ic.key_ordinal = 2
                    AND c.name = N'TRN_transaction_at'
              )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                  + @TRN_ActualPrimaryKeyName;

            ;THROW 50036,
                N'Primary key does not match the expected clustered definition TRN_id, TRN_transaction_at.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @TRN_ActualPrimaryKeyName <> N'PK_TRN'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_TRN';
            PRINT N'                Actual                       : '
                  + @TRN_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_TRN';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRN_CST_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.[Transaction]', N'TRN_CST_id') IS NULL
        BEGIN

            ALTER TABLE sales.[Transaction]
                ADD TRN_CST_id int NULL;

            PRINT N'            [+] Column added                  : TRN_CST_id';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_CST_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRN_CST_id';

            ;THROW 50037,
                N'Column TRN_CST_id does not match the expected definition int NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRN_CST_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRN_TRNST_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.[Transaction]', N'TRN_TRNST_id') IS NULL
        BEGIN

            ALTER TABLE sales.[Transaction]
                ADD TRN_TRNST_id tinyint NULL;

            PRINT N'            [+] Column added                  : TRN_TRNST_id';
            PRINT N'            [!] Pending action                : Backfill TRN_TRNST_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_TRNST_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRN_TRNST_id';

            ;THROW 50038,
                N'Column TRN_TRNST_id does not match the expected data type tinyint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_TRNST_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRN_TRNST_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRN_TRNST_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRN_TRNCH_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.[Transaction]', N'TRN_TRNCH_id') IS NULL
        BEGIN

            ALTER TABLE sales.[Transaction]
                ADD TRN_TRNCH_id tinyint NULL;

            PRINT N'            [+] Column added                  : TRN_TRNCH_id';
            PRINT N'            [!] Pending action                : Backfill TRN_TRNCH_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_TRNCH_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRN_TRNCH_id';

            ;THROW 50039,
                N'Column TRN_TRNCH_id does not match the expected data type tinyint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_TRNCH_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRN_TRNCH_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRN_TRNCH_id';

        END;

        /*----------------------------------------------------------------------
            COLUMN: TRN_gross_amount
        ----------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.[Transaction]', N'TRN_gross_amount') IS NULL
        BEGIN

            ALTER TABLE sales.[Transaction]
                ADD TRN_gross_amount decimal(19,2) NULL;

            PRINT N'            [+] Column added                  : TRN_gross_amount';
            PRINT N'            [!] Pending action                : Backfill TRN_gross_amount before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_gross_amount'
            AND TYPE_NAME(c.user_type_id) = N'decimal'
            AND c.precision = 19
            AND c.scale = 2
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRN_gross_amount';

            ;THROW 50040,
                N'Column TRN_gross_amount does not match the expected data type decimal(19,2).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_gross_amount'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRN_gross_amount';
            PRINT N'            [!] Expected final definition     : decimal(19,2) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRN_gross_amount';

        END;


        /*----------------------------------------------------------------------
            COLUMN: TRN_discount_amount
        ----------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.[Transaction]', N'TRN_discount_amount') IS NULL
        BEGIN

            ALTER TABLE sales.[Transaction]
                ADD TRN_discount_amount decimal(19,2) NULL;

            PRINT N'            [+] Column added                  : TRN_discount_amount';
            PRINT N'            [!] Pending action                : Backfill TRN_discount_amount before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_discount_amount'
            AND TYPE_NAME(c.user_type_id) = N'decimal'
            AND c.precision = 19
            AND c.scale = 2
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRN_discount_amount';

            ;THROW 50041,
                N'Column TRN_discount_amount does not match the expected data type decimal(19,2).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_discount_amount'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRN_discount_amount';
            PRINT N'            [!] Expected final definition     : decimal(19,2) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRN_discount_amount';

        END;


        /*----------------------------------------------------------------------
            COLUMN: TRN_shipping_amount
        ----------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.[Transaction]', N'TRN_shipping_amount') IS NULL
        BEGIN

            ALTER TABLE sales.[Transaction]
                ADD TRN_shipping_amount decimal(19,2) NULL;

            PRINT N'            [+] Column added                  : TRN_shipping_amount';
            PRINT N'            [!] Pending action                : Backfill TRN_shipping_amount before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_shipping_amount'
            AND TYPE_NAME(c.user_type_id) = N'decimal'
            AND c.precision = 19
            AND c.scale = 2
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRN_shipping_amount';

            ;THROW 50042,
                N'Column TRN_shipping_amount does not match the expected data type decimal(19,2).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_shipping_amount'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRN_shipping_amount';
            PRINT N'            [!] Expected final definition     : decimal(19,2) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRN_shipping_amount';

        END;

        /*----------------------------------------------------------------------
            COLUMN: TRN_created_at
        ----------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.[Transaction]', N'TRN_created_at') IS NULL
        BEGIN

            ALTER TABLE sales.[Transaction]
                ADD TRN_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : TRN_created_at';
            PRINT N'            [!] Pending action                : Backfill TRN_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRN_created_at';

            ;THROW 50043,
                N'Column TRN_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRN_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRN_created_at';

        END;


        /*----------------------------------------------------------------------
            COLUMN: TRN_updated_at
        ----------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.[Transaction]', N'TRN_updated_at') IS NULL
        BEGIN

            ALTER TABLE sales.[Transaction]
                ADD TRN_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : TRN_updated_at';
            PRINT N'            [!] Pending action                : Backfill TRN_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRN_updated_at';

            ;THROW 50044,
                N'Column TRN_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
            AND c.name = N'TRN_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRN_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRN_updated_at';

        END;

    END;

    /*==============================================================================
        PARTITION STRUCTURE VALIDATION
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

        INNER JOIN sys.partition_schemes AS ps
            ON ps.data_space_id = ds.data_space_id

        INNER JOIN sys.partition_functions AS pf
            ON pf.function_id = ps.function_id

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.partition_ordinal = 1

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id = OBJECT_ID(N'sales.[Transaction]')
          AND i.type = 1
          AND i.is_unique = 1
          AND ps.name = N'PS_SALES_MONTHLY'
          AND pf.name = N'PF_SALES_MONTHLY'
          AND c.name = N'TRN_transaction_at'
    )
    BEGIN

        PRINT N'        [X] Partition structure mismatch     : sales.Transaction';

        ;THROW 50045,
            N'sales.Transaction is not correctly aligned with PS_SALES_MONTHLY using TRN_transaction_at.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Partition structure validated    : sales.Transaction';
        PRINT N'            Partition Function               : PF_SALES_MONTHLY';
        PRINT N'            Partition Scheme                 : PS_SALES_MONTHLY';
        PRINT N'            Partition Column                 : TRN_transaction_at';

    END;

    PRINT N'';
