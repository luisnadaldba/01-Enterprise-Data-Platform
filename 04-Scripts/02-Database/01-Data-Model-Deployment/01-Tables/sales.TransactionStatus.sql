    /*==============================================================================
        ATLAS COMMERCE - SALES.TRANSACTIONSTATUS
    ==============================================================================

        Object      : sales.TransactionStatus
        Type        : Reference / Domain Table
        Prefix      : TRNST
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the authoritative set of transaction statuses used by the
        transactional sales model.

        Design Principles
        --------------------------------------------------------------------------
        - Keep status identifiers compact and stable.
        - Use a stable system code independently from the display name.
        - Preserve inactive statuses instead of deleting historical definitions.
        - Store reference data in FG_CORE.
        - Do not partition small reference/domain tables.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● sales.TransactionStatus';
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

        ;THROW 50060,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'sales.TransactionStatus', N'U') IS NULL
    BEGIN

        CREATE TABLE sales.TransactionStatus
        (
            TRNST_id          tinyint         IDENTITY(1,1) NOT NULL,

            TRNST_code        varchar(30)     NOT NULL,
            TRNST_name        varchar(100)    NOT NULL,

            TRNST_is_active   bit             NOT NULL,

            TRNST_created_at  datetime2(0)    NOT NULL,
            TRNST_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_TRNST
                PRIMARY KEY CLUSTERED
                (
                    TRNST_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : sales.TransactionStatus';
        PRINT N'            Prefix                          : TRNST';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : TRNST_id';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : sales.TransactionStatus';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: TRNST_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'tinyint'

            AND c.is_nullable = 0
            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : TRNST_id';

            ;THROW 50061,
                N'Column TRNST_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : TRNST_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_TRNST
        --------------------------------------------------------------------------*/

        DECLARE @TRNST_ActualPrimaryKeyName sysname;


        SELECT
            @TRNST_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND kc.type =
                N'PK';


        IF @TRNST_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_TRNST';

            ;THROW 50062,
                N'Primary key for sales.TransactionStatus does not exist.',
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
                    OBJECT_ID(N'sales.TransactionStatus')

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
                        N'TRNST_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @TRNST_ActualPrimaryKeyName;

            ;THROW 50063,
                N'Primary key does not match the expected clustered definition TRNST_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @TRNST_ActualPrimaryKeyName <>
                N'PK_TRNST'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_TRNST';
            PRINT N'                Actual                       : '
                + @TRNST_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_TRNST';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNST_code
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionStatus',
            N'TRNST_code'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionStatus
                ADD TRNST_code varchar(30) NULL;


            PRINT N'            [+] Column added                  : TRNST_code';
            PRINT N'            [!] Pending action                : Backfill TRNST_code before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_code'

            AND TYPE_NAME(c.user_type_id) =
                    N'varchar'

            AND c.max_length = 30
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNST_code';

            ;THROW 50064,
                N'Column TRNST_code does not match the expected data type varchar(30).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_code'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNST_code';
            PRINT N'            [!] Expected final definition     : varchar(30) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNST_code';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNST_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionStatus',
            N'TRNST_name'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionStatus
                ADD TRNST_name varchar(100) NULL;


            PRINT N'            [+] Column added                  : TRNST_name';
            PRINT N'            [!] Pending action                : Backfill TRNST_name before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_name'

            AND TYPE_NAME(c.user_type_id) =
                    N'varchar'

            AND c.max_length = 100
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNST_name';

            ;THROW 50065,
                N'Column TRNST_name does not match the expected data type varchar(100).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_name'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNST_name';
            PRINT N'            [!] Expected final definition     : varchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNST_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNST_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionStatus',
            N'TRNST_is_active'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionStatus
                ADD TRNST_is_active bit NULL;


            PRINT N'            [+] Column added                  : TRNST_is_active';
            PRINT N'            [!] Pending action                : Backfill TRNST_is_active before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_is_active'

            AND TYPE_NAME(c.user_type_id) =
                    N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNST_is_active';

            ;THROW 50066,
                N'Column TRNST_is_active does not match the expected data type bit.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_is_active'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNST_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNST_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNST_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionStatus',
            N'TRNST_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionStatus
                ADD TRNST_created_at datetime2(0) NULL;


            PRINT N'            [+] Column added                  : TRNST_created_at';
            PRINT N'            [!] Pending action                : Backfill TRNST_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNST_created_at';

            ;THROW 50067,
                N'Column TRNST_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNST_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNST_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNST_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'sales.TransactionStatus',
            N'TRNST_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE sales.TransactionStatus
                ADD TRNST_updated_at datetime2(0) NULL;


            PRINT N'            [+] Column added                  : TRNST_updated_at';
            PRINT N'            [!] Pending action                : Backfill TRNST_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNST_updated_at';

            ;THROW 50068,
                N'Column TRNST_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

            AND c.name =
                    N'TRNST_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNST_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNST_updated_at';

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
                OBJECT_ID(N'sales.TransactionStatus')

        AND i.type = 1
        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : sales.TransactionStatus';

        ;THROW 50069,
            N'sales.TransactionStatus is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : sales.TransactionStatus';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';