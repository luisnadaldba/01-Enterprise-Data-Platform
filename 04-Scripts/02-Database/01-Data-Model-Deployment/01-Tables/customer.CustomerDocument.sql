    /*==============================================================================
        ATLAS COMMERCE - CUSTOMER.CUSTOMERDOCUMENT
    ==============================================================================

        Object      : customer.CustomerDocument
        Type        : Dependent Table
        Prefix      : CSTCD
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains document identifiers associated with identified customers while
        keeping document information separated from the core Customer entity.

        Design Principles
        --------------------------------------------------------------------------
        - Associate each CustomerDocument with one Customer.
        - Associate each CustomerDocument with one controlled CustomerDocumentType.
        - Store the document identifier independently from its presentation format.
        - Support numeric and alphanumeric document identifiers.
        - Keep customer document information outside Customer.
        - Reduce unnecessary exposure of document information in customer queries.
        - Prevent the same document identifier of the same type from belonging to
        multiple customers through a dedicated unique constraint.
        - Store customer document data in FG_CORE.
        - Do not partition customer dependent tables.
        - Deploy unique constraints in the dedicated unique constraint stage.
        - Deploy foreign key constraints in the dedicated FK stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● customer.CustomerDocument';
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

        ;THROW 50540,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerDocument', N'U') IS NULL
    BEGIN

        CREATE TABLE customer.CustomerDocument
        (
            CSTCD_id          int             IDENTITY(1,1) NOT NULL,

            CSTCD_CST_id      int             NOT NULL,
            CSTCD_DTP_id      smallint        NOT NULL,

            CSTCD_value       varchar(30)     NOT NULL,

            CSTCD_created_at  datetime2(0)    NOT NULL,
            CSTCD_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_CSTCD
                PRIMARY KEY CLUSTERED
                (
                    CSTCD_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : customer.CustomerDocument';
        PRINT N'            Prefix                          : CSTCD';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : CSTCD_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : customer.CustomerDocument';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: CSTCD_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : CSTCD_id';

            ;THROW 50541,
                N'Column CSTCD_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : CSTCD_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_CSTCD
        --------------------------------------------------------------------------*/

        DECLARE @CSTCD_ActualPrimaryKeyName sysname;


        SELECT
            @CSTCD_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND kc.type =
                N'PK';


        IF @CSTCD_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_CSTCD';

            ;THROW 50542,
                N'Primary key for customer.CustomerDocument does not exist.',
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
                    OBJECT_ID(N'customer.CustomerDocument')

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
                        N'CSTCD_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @CSTCD_ActualPrimaryKeyName;

            ;THROW 50543,
                N'Primary key does not match the expected clustered definition CSTCD_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @CSTCD_ActualPrimaryKeyName <>
                N'PK_CSTCD'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_CSTCD';
            PRINT N'                Actual                       : '
                + @CSTCD_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_CSTCD';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCD_CST_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerDocument',
            N'CSTCD_CST_id'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerDocument
                ADD CSTCD_CST_id int NULL;

            PRINT N'            [+] Column added                  : CSTCD_CST_id';
            PRINT N'            [!] Pending action                : Backfill CSTCD_CST_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_CST_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCD_CST_id';

            ;THROW 50544,
                N'Column CSTCD_CST_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_CST_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCD_CST_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCD_CST_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCD_DTP_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerDocument',
            N'CSTCD_DTP_id'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerDocument
                ADD CSTCD_DTP_id smallint NULL;

            PRINT N'            [+] Column added                  : CSTCD_DTP_id';
            PRINT N'            [!] Pending action                : Backfill CSTCD_DTP_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_DTP_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'smallint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCD_DTP_id';

            ;THROW 50545,
                N'Column CSTCD_DTP_id does not match the expected data type smallint.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_DTP_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCD_DTP_id';
            PRINT N'            [!] Expected final definition     : smallint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCD_DTP_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCD_value
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerDocument',
            N'CSTCD_value'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerDocument
                ADD CSTCD_value varchar(30) NULL;

            PRINT N'            [+] Column added                  : CSTCD_value';
            PRINT N'            [!] Pending action                : Backfill CSTCD_value before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_value'

            AND TYPE_NAME(c.user_type_id) =
                    N'varchar'

            AND c.max_length = 30
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCD_value';

            ;THROW 50546,
                N'Column CSTCD_value does not match the expected data type varchar(30).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_value'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCD_value';
            PRINT N'            [!] Expected final definition     : varchar(30) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCD_value';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCD_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerDocument',
            N'CSTCD_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerDocument
                ADD CSTCD_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CSTCD_created_at';
            PRINT N'            [!] Pending action                : Backfill CSTCD_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCD_created_at';

            ;THROW 50547,
                N'Column CSTCD_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCD_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCD_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CSTCD_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerDocument',
            N'CSTCD_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerDocument
                ADD CSTCD_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CSTCD_updated_at';
            PRINT N'            [!] Pending action                : Backfill CSTCD_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CSTCD_updated_at';

            ;THROW 50548,
                N'Column CSTCD_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND c.name =
                    N'CSTCD_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CSTCD_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CSTCD_updated_at';

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
                OBJECT_ID(N'customer.CustomerDocument')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : customer.CustomerDocument';

        ;THROW 50549,
            N'customer.CustomerDocument is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : customer.CustomerDocument';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';