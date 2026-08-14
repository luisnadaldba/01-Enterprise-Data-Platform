    /*==============================================================================
        ATLAS COMMERCE - SALES.TRANSACTIONCHANNEL
    ==============================================================================

        Object      : sales.TransactionChannel
        Type        : Reference / Domain Table
        Prefix      : TRNCH
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the authoritative set of transaction channels used by the
        transactional sales model.

        Design Principles
        --------------------------------------------------------------------------
        - Keep channel identifiers compact and stable.
        - Use a stable system code independently from its business description.
        - Preserve inactive channels instead of deleting historical definitions.
        - Store reference data in FG_CORE.
        - Do not partition small reference/domain tables.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    sales.TransactionChannel';
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

        ;THROW 50076,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'sales.TransactionChannel', N'U') IS NULL
    BEGIN

        CREATE TABLE sales.TransactionChannel
        (
            TRNCH_id          tinyint         IDENTITY(1,1) NOT NULL,

            TRNCH_code        varchar(30)     NOT NULL,
            TRNCH_name        varchar(100)    NOT NULL,

            TRNCH_is_active   bit             NOT NULL,

            TRNCH_created_at  datetime2(0)    NOT NULL,
            TRNCH_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_TRNCH
                PRIMARY KEY CLUSTERED
                (
                    TRNCH_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : sales.TransactionChannel';
        PRINT N'            Prefix                          : TRNCH';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : TRNCH_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : sales.TransactionChannel';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: TRNCH_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionChannel')

            AND c.name = N'TRNCH_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : TRNCH_id';

            ;THROW 50077,
                N'Column TRNCH_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : TRNCH_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_TRNCH
        --------------------------------------------------------------------------*/

        DECLARE @TRNCH_TABLE_ActualPrimaryKeyName sysname;


        SELECT
            @TRNCH_TABLE_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        WHERE kc.parent_object_id =
                OBJECT_ID(N'sales.TransactionChannel')

        AND kc.type = N'PK';


        IF @TRNCH_TABLE_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_TRNCH';

            ;THROW 50078,
                N'Primary key for sales.TransactionChannel does not exist.',
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
                    OBJECT_ID(N'sales.TransactionChannel')

            AND kc.type = N'PK'

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
                    AND c.name = N'TRNCH_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @TRNCH_TABLE_ActualPrimaryKeyName;

            ;THROW 50079,
                N'Primary key does not match the expected clustered definition TRNCH_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @TRNCH_TABLE_ActualPrimaryKeyName <> N'PK_TRNCH'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_TRNCH';
            PRINT N'                Actual                       : '
                + @TRNCH_TABLE_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_TRNCH';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNCH_code
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.TransactionChannel', N'TRNCH_code') IS NULL
        BEGIN

            ALTER TABLE sales.TransactionChannel
                ADD TRNCH_code varchar(30) NULL;

            PRINT N'            [+] Column added                  : TRNCH_code';
            PRINT N'            [!] Pending action                : Backfill TRNCH_code before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionChannel')

            AND c.name = N'TRNCH_code'
            AND TYPE_NAME(c.user_type_id) = N'varchar'
            AND c.max_length = 30
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNCH_code';

            ;THROW 50080,
                N'Column TRNCH_code does not match the expected data type varchar(30).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
            AND c.name = N'TRNCH_code'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNCH_code';
            PRINT N'            [!] Expected final definition     : varchar(30) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNCH_code';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNCH_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.TransactionChannel', N'TRNCH_name') IS NULL
        BEGIN

            ALTER TABLE sales.TransactionChannel
                ADD TRNCH_name varchar(100) NULL;

            PRINT N'            [+] Column added                  : TRNCH_name';
            PRINT N'            [!] Pending action                : Backfill TRNCH_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
            AND c.name = N'TRNCH_name'
            AND TYPE_NAME(c.user_type_id) = N'varchar'
            AND c.max_length = 100
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNCH_name';

            ;THROW 50081,
                N'Column TRNCH_name does not match the expected data type varchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
            AND c.name = N'TRNCH_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNCH_name';
            PRINT N'            [!] Expected final definition     : varchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNCH_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNCH_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.TransactionChannel', N'TRNCH_is_active') IS NULL
        BEGIN

            ALTER TABLE sales.TransactionChannel
                ADD TRNCH_is_active bit NULL;

            PRINT N'            [+] Column added                  : TRNCH_is_active';
            PRINT N'            [!] Pending action                : Backfill TRNCH_is_active before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
            AND c.name = N'TRNCH_is_active'
            AND TYPE_NAME(c.user_type_id) = N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNCH_is_active';

            ;THROW 50082,
                N'Column TRNCH_is_active does not match the expected data type bit.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
            AND c.name = N'TRNCH_is_active'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNCH_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNCH_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNCH_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.TransactionChannel', N'TRNCH_created_at') IS NULL
        BEGIN

            ALTER TABLE sales.TransactionChannel
                ADD TRNCH_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : TRNCH_created_at';
            PRINT N'            [!] Pending action                : Backfill TRNCH_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
            AND c.name = N'TRNCH_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNCH_created_at';

            ;THROW 50083,
                N'Column TRNCH_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
            AND c.name = N'TRNCH_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNCH_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNCH_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: TRNCH_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'sales.TransactionChannel', N'TRNCH_updated_at') IS NULL
        BEGIN

            ALTER TABLE sales.TransactionChannel
                ADD TRNCH_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : TRNCH_updated_at';
            PRINT N'            [!] Pending action                : Backfill TRNCH_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
            AND c.name = N'TRNCH_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : TRNCH_updated_at';

            ;THROW 50084,
                N'Column TRNCH_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
            AND c.name = N'TRNCH_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : TRNCH_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : TRNCH_updated_at';

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
                OBJECT_ID(N'sales.TransactionChannel')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : sales.TransactionChannel';

        ;THROW 50085,
            N'sales.TransactionChannel is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : sales.TransactionChannel';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';