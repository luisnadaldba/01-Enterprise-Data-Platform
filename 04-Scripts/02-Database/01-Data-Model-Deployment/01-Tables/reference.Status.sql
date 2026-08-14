    /*==============================================================================
        ATLAS COMMERCE - REFERENCE.STATUS
    ==============================================================================

        Object      : reference.Status
        Type        : Reference Table
        Prefix      : STS
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the shared active/inactive status domain used by Atlas Commerce
        objects that require only a generic lifecycle state.

        Design Principles
        --------------------------------------------------------------------------
        - Provide a single controlled domain for ACTIVE and INACTIVE states.
        - Be reusable across schemas and business domains.
        - Do not store business-specific lifecycle states such as PAID, SHIPPED
        or CANCELLED.
        - Keep reference data in FG_CORE.
        - Do not partition reference tables.
        - Deploy foreign key constraints in the dedicated FK stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    reference.Status';
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

        ;THROW 50200,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    IF SCHEMA_ID(N'reference') IS NULL
    BEGIN

        ;THROW 50201,
            N'Required schema reference does not exist.',
            1;

    END;


    PRINT N'        [✓] Schema dependency validated     : reference';
    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'reference.Status', N'U') IS NULL
    BEGIN

        CREATE TABLE reference.Status
        (
            STS_id          tinyint         IDENTITY(1,1) NOT NULL,

            STS_code        varchar(30)     NOT NULL,

            STS_name        nvarchar(100)   NOT NULL,

            STS_created_at  datetime2(0)    NOT NULL,
            STS_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_STS
                PRIMARY KEY CLUSTERED
                (
                    STS_id
                )
                ON FG_CORE,

            CONSTRAINT UQ_STS_code
                UNIQUE
                (
                    STS_code
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : reference.Status';
        PRINT N'            Prefix                          : STS';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : STS_id';
        PRINT N'            Unique Key                      : STS_code';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : reference.Status';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: STS_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'reference.Status')
            AND c.name = N'STS_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : STS_id';

            ;THROW 50202,
                N'Column STS_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : STS_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_STS
        --------------------------------------------------------------------------*/

        DECLARE @STS_ActualPrimaryKeyName sysname;


        SELECT
            @STS_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'reference.Status')

        AND kc.type = N'PK';


        IF @STS_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_STS';

            ;THROW 50203,
                N'Primary key for reference.Status does not exist.',
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
                    OBJECT_ID(N'reference.Status')

            AND kc.type = N'PK'

            AND i.type = 1
            AND i.is_unique = 1

            AND
            (
                SELECT COUNT(*)

                FROM sys.index_columns AS ic

                WHERE ic.object_id = kc.parent_object_id
                    AND ic.index_id = kc.unique_index_id
                    AND ic.key_ordinal > 0
            ) = 1

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
                    AND c.name = N'STS_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @STS_ActualPrimaryKeyName;

            ;THROW 50204,
                N'Primary key does not match the expected clustered definition STS_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @STS_ActualPrimaryKeyName <> N'PK_STS'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_STS';
            PRINT N'                Actual                       : '
                + @STS_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_STS';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: STS_code
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.Status', N'STS_code') IS NULL
        BEGIN

            ALTER TABLE reference.Status
                ADD STS_code varchar(30) NULL;

            PRINT N'            [+] Column added                  : STS_code';
            PRINT N'            [!] Pending action                : Backfill STS_code before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Status')

            AND c.name = N'STS_code'
            AND TYPE_NAME(c.user_type_id) = N'varchar'
            AND c.max_length = 30
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : STS_code';

            ;THROW 50205,
                N'Column STS_code does not match the expected data type varchar(30).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Status')

            AND c.name = N'STS_code'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : STS_code';
            PRINT N'            [!] Expected final definition     : varchar(30) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : STS_code';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: STS_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.Status', N'STS_name') IS NULL
        BEGIN

            ALTER TABLE reference.Status
                ADD STS_name nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : STS_name';
            PRINT N'            [!] Pending action                : Backfill STS_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Status')

            AND c.name = N'STS_name'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : STS_name';

            ;THROW 50206,
                N'Column STS_name does not match the expected data type nvarchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Status')

            AND c.name = N'STS_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : STS_name';
            PRINT N'            [!] Expected final definition     : nvarchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : STS_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: STS_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.Status', N'STS_created_at') IS NULL
        BEGIN

            ALTER TABLE reference.Status
                ADD STS_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : STS_created_at';
            PRINT N'            [!] Pending action                : Backfill STS_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Status')

            AND c.name = N'STS_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : STS_created_at';

            ;THROW 50207,
                N'Column STS_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Status')

            AND c.name = N'STS_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : STS_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : STS_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: STS_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.Status', N'STS_updated_at') IS NULL
        BEGIN

            ALTER TABLE reference.Status
                ADD STS_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : STS_updated_at';
            PRINT N'            [!] Pending action                : Backfill STS_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Status')

            AND c.name = N'STS_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : STS_updated_at';

            ;THROW 50208,
                N'Column STS_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Status')

            AND c.name = N'STS_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : STS_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : STS_updated_at';

        END;


        /*--------------------------------------------------------------------------
            UNIQUE KEY: STS_code
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.indexes AS i

            INNER JOIN sys.index_columns AS ic
                ON  ic.object_id = i.object_id
                AND ic.index_id = i.index_id
                AND ic.key_ordinal = 1

            INNER JOIN sys.columns AS c
                ON  c.object_id = ic.object_id
                AND c.column_id = ic.column_id

            WHERE i.object_id =
                    OBJECT_ID(N'reference.Status')

            AND i.is_unique = 1
            AND i.is_hypothetical = 0
            AND c.name = N'STS_code'

            AND
            (
                SELECT COUNT(*)

                FROM sys.index_columns AS ic2

                WHERE ic2.object_id = i.object_id
                    AND ic2.index_id = i.index_id
                    AND ic2.key_ordinal > 0
            ) = 1
        )
        BEGIN

            IF COL_LENGTH(N'reference.Status', N'STS_code') IS NOT NULL
            AND NOT EXISTS
            (
                SELECT STS_code

                FROM reference.Status

                WHERE STS_code IS NOT NULL

                GROUP BY STS_code

                HAVING COUNT(*) > 1
            )
            AND NOT EXISTS
            (
                SELECT 1

                FROM sys.columns AS c

                WHERE c.object_id = OBJECT_ID(N'reference.Status')
                AND c.name = N'STS_code'
                AND c.is_nullable = 1
            )
            BEGIN

                ALTER TABLE reference.Status
                    ADD CONSTRAINT UQ_STS_code
                    UNIQUE
                    (
                        STS_code
                    )
                    ON FG_CORE;

                PRINT N'            [+] Unique key created            : UQ_STS_code';

            END
            ELSE
            BEGIN

                PRINT N'            [!] Unique key pending            : STS_code';
                PRINT N'            [!] Action                        : Resolve NULLability or duplicate values before enforcing uniqueness';

            END

        END
        ELSE
        BEGIN

            PRINT N'            [•] Unique key validated          : STS_code';

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
                OBJECT_ID(N'reference.Status')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : reference.Status';

        ;THROW 50209,
            N'reference.Status is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : reference.Status';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';