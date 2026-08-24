    /*==============================================================================
        ATLAS COMMERCE - SALES.TRANSACTIONITEM
    ==============================================================================

        Object      : sales.TransactionItem
        Type        : Transactional Detail Table
        Prefix      : TRNIT
        Database    : AtlasCommerce

        Purpose
        --------------------------------------------------------------------------
        Stores the individual product items associated with a sales transaction.

        Design Principles
        --------------------------------------------------------------------------
        - Keep transaction item records narrow.
        - Store only attributes required by the transactional core.
        - Reference ProductVariant instead of duplicating Product relationships.
        - Preserve item-level price and discount values as transaction snapshots.
        - Support incremental data pipelines through creation and update timestamps.
        - Partition transaction item data using the parent transaction business time.
        - Align transaction and transaction item partitioning.
        - Treat transaction time as immutable after record creation.

        Partitioning
        --------------------------------------------------------------------------
        Partition Function : PF_SALES_MONTHLY
        Partition Scheme   : PS_SALES_MONTHLY
        Partition Column   : TRNIT_transaction_at
        Range              : RIGHT

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● sales.TransactionItem';
    PRINT N'';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.partition_functions

        WHERE name =
                N'PF_SALES_MONTHLY'
    )
    BEGIN

        ;THROW 50050,
            N'Required partition function PF_SALES_MONTHLY does not exist.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.partition_schemes

        WHERE name =
                N'PS_SALES_MONTHLY'
    )
    BEGIN

        ;THROW 50051,
            N'Required partition scheme PS_SALES_MONTHLY does not exist.',
            1;

    END;


    PRINT N'        [✓] Partition dependencies validated';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'sales.TransactionItem', N'U') IS NULL
    BEGIN

        CREATE TABLE sales.TransactionItem
        (
            TRNIT_id                 bigint          IDENTITY(1,1) NOT NULL,
            TRNIT_transaction_at     datetime2(0)    NOT NULL,

            TRNIT_TRN_id             bigint          NOT NULL,
            TRNIT_PRDVA_id           int             NOT NULL,

            TRNIT_quantity           int             NOT NULL,
            TRNIT_unit_price         decimal(19,2)   NOT NULL,
            TRNIT_unit_discount      decimal(19,2)   NOT NULL,

            TRNIT_created_at         datetime2(0)    NOT NULL,
            TRNIT_updated_at         datetime2(0)    NOT NULL,

            CONSTRAINT PK_TRNIT
                PRIMARY KEY CLUSTERED
                (
                    TRNIT_id,
                    TRNIT_transaction_at
                )
                ON PS_SALES_MONTHLY(TRNIT_transaction_at)
        )
        ON PS_SALES_MONTHLY(TRNIT_transaction_at);


        PRINT N'        [+] Table created                   : sales.TransactionItem';
        PRINT N'            Prefix                          : TRNIT';
        PRINT N'            Partition Scheme                : PS_SALES_MONTHLY';
        PRINT N'            Partition Column                : TRNIT_transaction_at';
        PRINT N'            Primary Key                     : TRNIT_id, TRNIT_transaction_at';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : sales.TransactionItem';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: TRNIT_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'bigint'

            AND c.is_nullable = 0
            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : TRNIT_id';

            ;THROW 50052,
                N'Column TRNIT_id does not match the expected definition bigint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : TRNIT_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY / PARTITION COLUMN: TRNIT_transaction_at
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_transaction_at'
        )
        BEGIN

            PRINT N'            [X] Partition column missing      : TRNIT_transaction_at';

            ;THROW 50053,
                N'Partition column TRNIT_transaction_at is missing. Automatic creation is not safe because the column participates in the primary key and partitioning architecture.',
                1;

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_transaction_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
            AND c.is_nullable = 0
        )
        BEGIN

            PRINT N'            [X] Partition column mismatch     : TRNIT_transaction_at';

            ;THROW 50054,
                N'Partition column TRNIT_transaction_at does not match the expected definition datetime2(0) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Partition column validated    : TRNIT_transaction_at';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_TRNIT
        --------------------------------------------------------------------------*/

        DECLARE @TRNIT_ActualPrimaryKeyName sysname;


        SELECT
            @TRNIT_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND kc.type =
                N'PK';


        IF @TRNIT_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_TRNIT';

            ;THROW 50055,
                N'Primary key for sales.TransactionItem does not exist.',
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
                    OBJECT_ID(N'sales.TransactionItem')

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
            ) = 2

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
                        N'TRNIT_id'
            )

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

                AND ic.key_ordinal = 2

                AND c.name =
                        N'TRNIT_transaction_at'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @TRNIT_ActualPrimaryKeyName;

            ;THROW 50056,
                N'Primary key does not match the expected clustered definition TRNIT_id, TRNIT_transaction_at.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @TRNIT_ActualPrimaryKeyName <>
                N'PK_TRNIT'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_TRNIT';
            PRINT N'                Actual                       : '
                + @TRNIT_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_TRNIT';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNIT_TRN_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionItem',
            N'TRNIT_TRN_id'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionItem
                ADD TRNIT_TRN_id bigint NULL;


            PRINT N'            [+] Column added                  : TRNIT_TRN_id';
            PRINT N'            [!] Pending action                : Backfill TRNIT_TRN_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_TRN_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'bigint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNIT_TRN_id';

            ;THROW 50057,
                N'Column TRNIT_TRN_id does not match the expected data type bigint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_TRN_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNIT_TRN_id';
            PRINT N'            [!] Expected final definition     : bigint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNIT_TRN_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNIT_PRDVA_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionItem',
            N'TRNIT_PRDVA_id'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionItem
                ADD TRNIT_PRDVA_id int NULL;


            PRINT N'            [+] Column added                  : TRNIT_PRDVA_id';
            PRINT N'            [!] Pending action                : Backfill TRNIT_PRDVA_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_PRDVA_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNIT_PRDVA_id';

            ;THROW 50058,
                N'Column TRNIT_PRDVA_id does not match the expected data type int.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_PRDVA_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNIT_PRDVA_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNIT_PRDVA_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNIT_quantity
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionItem',
            N'TRNIT_quantity'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionItem
                ADD TRNIT_quantity int NULL;


            PRINT N'            [+] Column added                  : TRNIT_quantity';
            PRINT N'            [!] Pending action                : Backfill TRNIT_quantity before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_quantity'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNIT_quantity';

            ;THROW 50059,
                N'Column TRNIT_quantity does not match the expected data type int.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_quantity'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNIT_quantity';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNIT_quantity';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNIT_unit_price
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionItem',
            N'TRNIT_unit_price'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionItem
                ADD TRNIT_unit_price decimal(19,2) NULL;


            PRINT N'            [+] Column added                  : TRNIT_unit_price';
            PRINT N'            [!] Pending action                : Backfill TRNIT_unit_price before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_unit_price'

            AND TYPE_NAME(c.user_type_id) =
                    N'decimal'

            AND c.precision = 19
            AND c.scale = 2
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNIT_unit_price';

            ;THROW 50060,
                N'Column TRNIT_unit_price does not match the expected data type decimal(19,2).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_unit_price'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNIT_unit_price';
            PRINT N'            [!] Expected final definition     : decimal(19,2) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNIT_unit_price';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNIT_unit_discount
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionItem',
            N'TRNIT_unit_discount'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionItem
                ADD TRNIT_unit_discount decimal(19,2) NULL;


            PRINT N'            [+] Column added                  : TRNIT_unit_discount';
            PRINT N'            [!] Pending action                : Backfill TRNIT_unit_discount before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_unit_discount'

            AND TYPE_NAME(c.user_type_id) =
                    N'decimal'

            AND c.precision = 19
            AND c.scale = 2
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNIT_unit_discount';

            ;THROW 50061,
                N'Column TRNIT_unit_discount does not match the expected data type decimal(19,2).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_unit_discount'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNIT_unit_discount';
            PRINT N'            [!] Expected final definition     : decimal(19,2) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNIT_unit_discount';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNIT_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionItem',
            N'TRNIT_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionItem
                ADD TRNIT_created_at datetime2(0) NULL;


            PRINT N'            [+] Column added                  : TRNIT_created_at';
            PRINT N'            [!] Pending action                : Backfill TRNIT_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNIT_created_at';

            ;THROW 50062,
                N'Column TRNIT_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNIT_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNIT_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNIT_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionItem',
            N'TRNIT_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionItem
                ADD TRNIT_updated_at datetime2(0) NULL;


            PRINT N'            [+] Column added                  : TRNIT_updated_at';
            PRINT N'            [!] Pending action                : Backfill TRNIT_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNIT_updated_at';

            ;THROW 50063,
                N'Column TRNIT_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    N'TRNIT_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNIT_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNIT_updated_at';

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

        WHERE i.object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND i.type = 1
        AND i.is_unique = 1

        AND ps.name =
                N'PS_SALES_MONTHLY'

        AND pf.name =
                N'PF_SALES_MONTHLY'

        AND c.name =
                N'TRNIT_transaction_at'
    )
    BEGIN

        PRINT N'        [X] Partition structure mismatch     : sales.TransactionItem';

        ;THROW 50064,
            N'sales.TransactionItem is not correctly aligned with PS_SALES_MONTHLY using TRNIT_transaction_at.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Partition structure validated    : sales.TransactionItem';
        PRINT N'            Partition Function               : PF_SALES_MONTHLY';
        PRINT N'            Partition Scheme                 : PS_SALES_MONTHLY';
        PRINT N'            Partition Column                 : TRNIT_transaction_at';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';