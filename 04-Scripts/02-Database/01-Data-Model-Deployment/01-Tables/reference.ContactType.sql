    /*==============================================================================
        ATLAS COMMERCE - REFERENCE.CONTACTTYPE
    ==============================================================================

        Object      : reference.ContactType
        Type        : Reference Table
        Prefix      : CTP
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the shared controlled domain of contact types used by
        Atlas Commerce objects that store telephone contact information.

        Design Principles
        --------------------------------------------------------------------------
        - Provide a single controlled domain for telephone contact types.
        - Distinguish fixed telephone numbers from mobile telephone numbers.
        - Be reusable across schemas and business domains.
        - Do not represent communication services such as WhatsApp as contact types.
        - Keep reference data in FG_CORE.
        - Do not partition reference tables.
        - Deploy unique constraints in the dedicated unique constraint stage.
        - Deploy foreign key constraints in the dedicated FK stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    reference.ContactType';
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

        ;THROW 50600,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    IF SCHEMA_ID(N'reference') IS NULL
    BEGIN

        ;THROW 50601,
            N'Required schema reference does not exist.',
            1;

    END;


    PRINT N'        [✓] Schema dependency validated     : reference';
    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'reference.ContactType', N'U') IS NULL
    BEGIN

        CREATE TABLE reference.ContactType
        (
            CTP_id          tinyint         IDENTITY(1,1) NOT NULL,

            CTP_name        nvarchar(100)   NOT NULL,

            CTP_created_at  datetime2(0)    NOT NULL,
            CTP_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_CTP
                PRIMARY KEY CLUSTERED
                (
                    CTP_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : reference.ContactType';
        PRINT N'            Prefix                          : CTP';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : CTP_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : reference.ContactType';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: CTP_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'reference.ContactType')

            AND c.name =
                    N'CTP_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'tinyint'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : CTP_id';

            ;THROW 50602,
                N'Column CTP_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : CTP_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_CTP
        --------------------------------------------------------------------------*/

        DECLARE @CTP_ActualPrimaryKeyName sysname;


        SELECT
            @CTP_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'reference.ContactType')

        AND kc.type =
                N'PK';


        IF @CTP_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_CTP';

            ;THROW 50603,
                N'Primary key for reference.ContactType does not exist.',
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
                    OBJECT_ID(N'reference.ContactType')

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
                        N'CTP_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @CTP_ActualPrimaryKeyName;

            ;THROW 50604,
                N'Primary key does not match the expected clustered definition CTP_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @CTP_ActualPrimaryKeyName <>
            N'PK_CTP'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_CTP';
            PRINT N'                Actual                       : '
                + @CTP_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_CTP';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CTP_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.ContactType',
            N'CTP_name'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.ContactType
                ADD CTP_name nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : CTP_name';
            PRINT N'            [!] Pending action                : Backfill CTP_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.ContactType')

            AND c.name =
                    N'CTP_name'

            AND TYPE_NAME(c.user_type_id) =
                    N'nvarchar'

            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CTP_name';

            ;THROW 50605,
                N'Column CTP_name does not match the expected data type nvarchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.ContactType')

            AND c.name =
                    N'CTP_name'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CTP_name';
            PRINT N'            [!] Expected final definition     : nvarchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CTP_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CTP_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.ContactType',
            N'CTP_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.ContactType
                ADD CTP_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CTP_created_at';
            PRINT N'            [!] Pending action                : Backfill CTP_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.ContactType')

            AND c.name =
                    N'CTP_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CTP_created_at';

            ;THROW 50606,
                N'Column CTP_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.ContactType')

            AND c.name =
                    N'CTP_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CTP_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill CTP_created_at before enforcing NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CTP_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: CTP_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'reference.ContactType',
            N'CTP_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE reference.ContactType
                ADD CTP_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : CTP_updated_at';
            PRINT N'            [!] Pending action                : Backfill CTP_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.ContactType')

            AND c.name =
                    N'CTP_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : CTP_updated_at';

            ;THROW 50607,
                N'Column CTP_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.ContactType')

            AND c.name =
                    N'CTP_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : CTP_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill CTP_updated_at before enforcing NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : CTP_updated_at';

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
                OBJECT_ID(N'reference.ContactType')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : reference.ContactType';

        ;THROW 50608,
            N'reference.ContactType is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : reference.ContactType';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';