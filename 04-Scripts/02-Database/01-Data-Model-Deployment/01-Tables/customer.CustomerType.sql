    /*==============================================================================
        ATLAS COMMERCE - CUSTOMER.CUSTOMERTYPE
    ==============================================================================

        Object      : customer.CustomerType
        Type        : Reference Table
        Prefix      : CSTCT
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled customer types supported by Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Distinguish individual customers from company customers.
        - Keep customer classification controlled and independent from Customer.
        - Avoid storing customer type as free text in Customer.
        - Store customer reference data in FG_CORE.
        - Do not partition customer reference tables.
        - Deploy unique constraints in the dedicated constraint stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● customer.CustomerType';
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

        ;THROW 50300,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerType', N'U') IS NULL
    BEGIN

        CREATE TABLE customer.CustomerType
        (
            CSTCT_id          smallint        IDENTITY(1,1) NOT NULL,

            CSTCT_code        varchar(30)     NOT NULL,

            CSTCT_name        nvarchar(100)   NOT NULL,

            CSTCT_created_at  datetime2(0)    NOT NULL,
            CSTCT_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_CSTCT
                PRIMARY KEY CLUSTERED
                (
                    CSTCT_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : customer.CustomerType';
        PRINT N'            Prefix                          : CSTCT';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : CSTCT_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : customer.CustomerType';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: CSTCT_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerType')

            AND c.name =
                    N'CSTCT_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'smallint'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : CSTCT_id';

            ;THROW 50301,
                N'Column CSTCT_id does not match the expected definition smallint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : CSTCT_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_CSTCT
        --------------------------------------------------------------------------*/

        DECLARE @CSTCT_ActualPrimaryKeyName sysname;


        SELECT
            @CSTCT_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'customer.CustomerType')

        AND kc.type =
                N'PK';


        IF @CSTCT_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_CSTCT';

            ;THROW 50302,
                N'Primary key for customer.CustomerType does not exist.',
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
                    OBJECT_ID(N'customer.CustomerType')

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
                        N'CSTCT_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @CSTCT_ActualPrimaryKeyName;

            ;THROW 50303,
                N'Primary key does not match the expected clustered definition CSTCT_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @CSTCT_ActualPrimaryKeyName <>
                N'PK_CSTCT'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_CSTCT';
            PRINT N'                Actual                       : '
                + @CSTCT_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_CSTCT';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCT_code
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerType',
            N'CSTCT_code'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerType
                ADD CSTCT_code varchar(30) NULL;

            PRINT N'            [+] Column added                  : CSTCT_code';
            PRINT N'            [!] Pending action                : Backfill CSTCT_code before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerType')

            AND c.name =
                    N'CSTCT_code'

            AND TYPE_NAME(c.user_type_id) =
                    N'varchar'

            AND c.max_length = 30
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCT_code';

            ;THROW 50304,
                N'Column CSTCT_code does not match the expected data type varchar(30).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerType')

            AND c.name =
                    N'CSTCT_code'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCT_code';
            PRINT N'            [!] Expected final definition     : varchar(30) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCT_code';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCT_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerType',
            N'CSTCT_name'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerType
                ADD CSTCT_name nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : CSTCT_name';
            PRINT N'            [!] Pending action                : Backfill CSTCT_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerType')

            AND c.name =
                    N'CSTCT_name'

            AND TYPE_NAME(c.user_type_id) =
                    N'nvarchar'

            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCT_name';

            ;THROW 50305,
                N'Column CSTCT_name does not match the expected data type nvarchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerType')

            AND c.name =
                    N'CSTCT_name'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCT_name';
            PRINT N'            [!] Expected final definition     : nvarchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCT_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCT_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerType',
            N'CSTCT_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerType
                ADD CSTCT_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CSTCT_created_at';
            PRINT N'            [!] Pending action                : Backfill CSTCT_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerType')

            AND c.name =
                    N'CSTCT_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCT_created_at';

            ;THROW 50306,
                N'Column CSTCT_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerType')

            AND c.name =
                    N'CSTCT_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCT_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCT_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCT_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerType',
            N'CSTCT_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerType
                ADD CSTCT_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CSTCT_updated_at';
            PRINT N'            [!] Pending action                : Backfill CSTCT_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerType')

            AND c.name =
                    N'CSTCT_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCT_updated_at';

            ;THROW 50307,
                N'Column CSTCT_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerType')

            AND c.name =
                    N'CSTCT_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCT_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCT_updated_at';

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
                OBJECT_ID(N'customer.CustomerType')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : customer.CustomerType';

        ;THROW 50308,
            N'customer.CustomerType is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : customer.CustomerType';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';