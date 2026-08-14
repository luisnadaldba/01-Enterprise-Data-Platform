    /*==============================================================================
        ATLAS COMMERCE - REFERENCE.ADDRESS
    ==============================================================================

        Object      : reference.Address
        Type        : Reference Table
        Prefix      : ADR
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains reusable physical street addresses used across Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Represent a physical street address independently from customer-specific
        address information.
        - Associate each Address with one controlled City.
        - Keep street number outside Address.
        - Keep complement outside Address.
        - Keep customer-specific lifecycle and status outside Address.
        - Store postal code without presentation formatting.
        - Derive Administrative Division and Country through City.
        - Store reference data in FG_CORE.
        - Do not partition reference tables.
        - Deploy foreign key constraints in the dedicated FK stage.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    reference.Address';
    PRINT N'    ------------------------------------------------------------';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.schemas
        WHERE name = N'reference'
    )
    BEGIN

        ;THROW 50210,
            N'Required schema reference does not exist.',
            1;

    END;


    PRINT N'        [✓] Schema dependency validated     : reference';


    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.filegroups
        WHERE name = N'FG_CORE'
    )
    BEGIN

        ;THROW 50211,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'reference.Address', N'U') IS NULL
    BEGIN

        CREATE TABLE reference.Address
        (
            ADR_id              int             IDENTITY(1,1) NOT NULL,

            ADR_CTY_id          int             NOT NULL,

            ADR_postal_code     varchar(8)      NOT NULL,
            ADR_street          nvarchar(200)   NOT NULL,

            ADR_created_at      datetime2(0)    NOT NULL,
            ADR_updated_at      datetime2(0)    NOT NULL,

            CONSTRAINT PK_ADR
                PRIMARY KEY CLUSTERED
                (
                    ADR_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : reference.Address';
        PRINT N'            Prefix                          : ADR';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : ADR_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : reference.Address';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: ADR_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'reference.Address')
            AND c.name = N'ADR_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : ADR_id';

            ;THROW 50212,
                N'Column ADR_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : ADR_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_ADR
        --------------------------------------------------------------------------*/

        DECLARE @ADR_ActualPrimaryKeyName sysname;


        SELECT
            @ADR_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'reference.Address')

        AND kc.type = N'PK';


        IF @ADR_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_ADR';

            ;THROW 50213,
                N'Primary key for reference.Address does not exist.',
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
                    OBJECT_ID(N'reference.Address')

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
                AND c.name = N'ADR_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @ADR_ActualPrimaryKeyName;

            ;THROW 50214,
                N'Primary key does not match the expected clustered definition ADR_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @ADR_ActualPrimaryKeyName <> N'PK_ADR'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_ADR';
            PRINT N'                Actual                       : '
                + @ADR_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_ADR';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: ADR_CTY_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.Address', N'ADR_CTY_id') IS NULL
        BEGIN

            ALTER TABLE reference.Address
                ADD ADR_CTY_id int NULL;

            PRINT N'            [+] Column added                  : ADR_CTY_id';
            PRINT N'            [!] Pending action                : Backfill ADR_CTY_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Address')

            AND c.name = N'ADR_CTY_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : ADR_CTY_id';

            ;THROW 50215,
                N'Column ADR_CTY_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Address')

            AND c.name = N'ADR_CTY_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : ADR_CTY_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : ADR_CTY_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: ADR_postal_code
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.Address', N'ADR_postal_code') IS NULL
        BEGIN

            ALTER TABLE reference.Address
                ADD ADR_postal_code varchar(8) NULL;

            PRINT N'            [+] Column added                  : ADR_postal_code';
            PRINT N'            [!] Pending action                : Backfill ADR_postal_code before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Address')

            AND c.name = N'ADR_postal_code'
            AND TYPE_NAME(c.user_type_id) = N'varchar'
            AND c.max_length = 8
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : ADR_postal_code';

            ;THROW 50216,
                N'Column ADR_postal_code does not match the expected data type varchar(8).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Address')

            AND c.name = N'ADR_postal_code'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : ADR_postal_code';
            PRINT N'            [!] Expected final definition     : varchar(8) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : ADR_postal_code';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: ADR_street
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.Address', N'ADR_street') IS NULL
        BEGIN

            ALTER TABLE reference.Address
                ADD ADR_street nvarchar(200) NULL;

            PRINT N'            [+] Column added                  : ADR_street';
            PRINT N'            [!] Pending action                : Backfill ADR_street before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Address')

            AND c.name = N'ADR_street'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 400
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : ADR_street';

            ;THROW 50217,
                N'Column ADR_street does not match the expected data type nvarchar(200).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Address')

            AND c.name = N'ADR_street'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : ADR_street';
            PRINT N'            [!] Expected final definition     : nvarchar(200) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : ADR_street';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: ADR_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.Address', N'ADR_created_at') IS NULL
        BEGIN

            ALTER TABLE reference.Address
                ADD ADR_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : ADR_created_at';
            PRINT N'            [!] Pending action                : Backfill ADR_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Address')

            AND c.name = N'ADR_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : ADR_created_at';

            ;THROW 50218,
                N'Column ADR_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Address')

            AND c.name = N'ADR_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : ADR_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : ADR_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: ADR_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'reference.Address', N'ADR_updated_at') IS NULL
        BEGIN

            ALTER TABLE reference.Address
                ADD ADR_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : ADR_updated_at';
            PRINT N'            [!] Pending action                : Backfill ADR_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Address')

            AND c.name = N'ADR_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : ADR_updated_at';

            ;THROW 50219,
                N'Column ADR_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'reference.Address')

            AND c.name = N'ADR_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : ADR_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : ADR_updated_at';

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
                OBJECT_ID(N'reference.Address')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : reference.Address';

        ;THROW 50220,
            N'reference.Address is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : reference.Address';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';