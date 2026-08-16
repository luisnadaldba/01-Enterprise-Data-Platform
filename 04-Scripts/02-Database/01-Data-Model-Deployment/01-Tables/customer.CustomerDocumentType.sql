    /*==============================================================================
        ATLAS COMMERCE - CUSTOMER.CUSTOMERDOCUMENTTYPE
    ==============================================================================

        Object      : customer.CustomerDocumentType
        Type        : Domain Table
        Prefix      : DTP
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled set of document types that may be associated
        with customers in Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Centralize customer document type definitions.
        - Prevent document type names from being repeated in CustomerDocument.
        - Support different document identifiers without changing CustomerDocument.
        - Keep document type definitions independent from customer records.
        - Store customer domain data in FG_CORE.
        - Do not partition customer domain tables.
        - Deploy unique constraints in the dedicated unique constraint stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    customer.CustomerDocumentType';
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

        ;THROW 50510,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerDocumentType', N'U') IS NULL
    BEGIN

        CREATE TABLE customer.CustomerDocumentType
        (
            DTP_id          smallint        IDENTITY(1,1) NOT NULL,

            DTP_name        nvarchar(100)   NOT NULL,

            DTP_created_at  datetime2(0)    NOT NULL,
            DTP_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_DTP
                PRIMARY KEY CLUSTERED
                (
                    DTP_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : customer.CustomerDocumentType';
        PRINT N'            Prefix                          : DTP';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : DTP_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : customer.CustomerDocumentType';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: DTP_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocumentType')

            AND c.name =
                    N'DTP_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'smallint'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : DTP_id';

            ;THROW 50511,
                N'Column DTP_id does not match the expected definition smallint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : DTP_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_DTP
        --------------------------------------------------------------------------*/

        DECLARE @DTP_ActualPrimaryKeyName sysname;


        SELECT
            @DTP_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND kc.type =
                N'PK';


        IF @DTP_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_DTP';

            ;THROW 50512,
                N'Primary key for customer.CustomerDocumentType does not exist.',
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
                    OBJECT_ID(N'customer.CustomerDocumentType')

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
                        N'DTP_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @DTP_ActualPrimaryKeyName;

            ;THROW 50513,
                N'Primary key does not match the expected clustered definition DTP_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @DTP_ActualPrimaryKeyName <>
            N'PK_DTP'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_DTP';
            PRINT N'                Actual                       : '
                + @DTP_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_DTP';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: DTP_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerDocumentType',
            N'DTP_name'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerDocumentType
                ADD DTP_name nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : DTP_name';
            PRINT N'            [!] Pending action                : Backfill DTP_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocumentType')

            AND c.name =
                    N'DTP_name'

            AND TYPE_NAME(c.user_type_id) =
                    N'nvarchar'

            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : DTP_name';

            ;THROW 50514,
                N'Column DTP_name does not match the expected data type nvarchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocumentType')

            AND c.name =
                    N'DTP_name'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : DTP_name';
            PRINT N'            [!] Expected final definition     : nvarchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : DTP_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: DTP_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerDocumentType',
            N'DTP_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerDocumentType
                ADD DTP_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : DTP_created_at';
            PRINT N'            [!] Pending action                : Backfill DTP_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocumentType')

            AND c.name =
                    N'DTP_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : DTP_created_at';

            ;THROW 50515,
                N'Column DTP_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocumentType')

            AND c.name =
                    N'DTP_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : DTP_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill DTP_created_at before enforcing NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : DTP_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: DTP_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'customer.CustomerDocumentType',
            N'DTP_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE customer.CustomerDocumentType
                ADD DTP_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : DTP_updated_at';
            PRINT N'            [!] Pending action                : Backfill DTP_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocumentType')

            AND c.name =
                    N'DTP_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : DTP_updated_at';

            ;THROW 50516,
                N'Column DTP_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'customer.CustomerDocumentType')

            AND c.name =
                    N'DTP_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : DTP_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill DTP_updated_at before enforcing NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : DTP_updated_at';

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
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : customer.CustomerDocumentType';

        ;THROW 50517,
            N'customer.CustomerDocumentType is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : customer.CustomerDocumentType';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';