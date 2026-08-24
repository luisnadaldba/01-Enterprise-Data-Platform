    /*==============================================================================
        ATLAS COMMERCE - INVENTORY.INVENTORYMOVEMENTNOTE
    ==============================================================================

        Object      : inventory.InventoryMovementNote
        Type        : Operational History Detail Table
        Prefix      : INVMN
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains optional free-text notes associated with inventory movement
        events in Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Allow zero or many notes for each InventoryMovement.
        - Keep free-text operational context outside InventoryMovement.
        - Do not use note text to classify or derive inventory movement reasons.
        - Preserve note history as separate rows instead of overwriting prior notes.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Deploy additional indexes in the dedicated Indexes stage.
        - Store inventory movement notes in FG_CORE.
        - Do not partition this table in the current scope.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● inventory.InventoryMovementNote';
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

        ;THROW 51000,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovementNote', N'U') IS NULL
    BEGIN

        CREATE TABLE inventory.InventoryMovementNote
        (
            INVMN_id          bigint         IDENTITY(1,1) NOT NULL,

            INVMN_INVMV_id    bigint         NOT NULL,

            INVMN_note        nvarchar(1000) NOT NULL,

            INVMN_created_at  datetime2(0)   NOT NULL,
            INVMN_updated_at  datetime2(0)   NOT NULL,

            CONSTRAINT PK_INVMN
                PRIMARY KEY CLUSTERED
                (
                    INVMN_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : inventory.InventoryMovementNote';
        PRINT N'            Prefix                          : INVMN';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : INVMN_id';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : inventory.InventoryMovementNote';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: INVMN_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')

            AND c.name =
                    N'INVMN_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'bigint'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : INVMN_id';

            ;THROW 51001,
                N'Column INVMN_id does not match the expected definition bigint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : INVMN_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_INVMN
        --------------------------------------------------------------------------*/

        DECLARE @INVMN_ActualPrimaryKeyName sysname;


        SELECT
            @INVMN_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND kc.type =
                N'PK';


        IF @INVMN_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_INVMN';

            ;THROW 51002,
                N'Primary key for inventory.InventoryMovementNote does not exist.',
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
                    OBJECT_ID(N'inventory.InventoryMovementNote')

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
                        N'INVMN_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @INVMN_ActualPrimaryKeyName;

            ;THROW 51003,
                N'Primary key does not match the expected clustered definition INVMN_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @INVMN_ActualPrimaryKeyName <>
                N'PK_INVMN'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_INVMN';
            PRINT N'                Actual                       : '
                + @INVMN_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_INVMN';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVMN_INVMV_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'inventory.InventoryMovementNote',
            N'INVMN_INVMV_id'
        ) IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryMovementNote
                ADD INVMN_INVMV_id bigint NULL;

            PRINT N'            [+] Column added                  : INVMN_INVMV_id';
            PRINT N'            [!] Pending action                : Backfill INVMN_INVMV_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')

            AND c.name =
                    N'INVMN_INVMV_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'bigint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVMN_INVMV_id';

            ;THROW 51004,
                N'Column INVMN_INVMV_id does not match the expected data type bigint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')

            AND c.name =
                    N'INVMN_INVMV_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVMN_INVMV_id';
            PRINT N'            [!] Expected final definition     : bigint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVMN_INVMV_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVMN_note
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'inventory.InventoryMovementNote',
            N'INVMN_note'
        ) IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryMovementNote
                ADD INVMN_note nvarchar(1000) NULL;

            PRINT N'            [+] Column added                  : INVMN_note';
            PRINT N'            [!] Pending action                : Backfill INVMN_note before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')

            AND c.name =
                    N'INVMN_note'

            AND TYPE_NAME(c.user_type_id) =
                    N'nvarchar'

            AND c.max_length = 2000
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVMN_note';

            ;THROW 51005,
                N'Column INVMN_note does not match the expected data type nvarchar(1000).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')

            AND c.name =
                    N'INVMN_note'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVMN_note';
            PRINT N'            [!] Expected final definition     : nvarchar(1000) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVMN_note';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVMN_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'inventory.InventoryMovementNote',
            N'INVMN_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryMovementNote
                ADD INVMN_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVMN_created_at';
            PRINT N'            [!] Pending action                : Backfill INVMN_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')

            AND c.name =
                    N'INVMN_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVMN_created_at';

            ;THROW 51006,
                N'Column INVMN_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')

            AND c.name =
                    N'INVMN_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVMN_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVMN_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVMN_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'inventory.InventoryMovementNote',
            N'INVMN_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryMovementNote
                ADD INVMN_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVMN_updated_at';
            PRINT N'            [!] Pending action                : Backfill INVMN_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')

            AND c.name =
                    N'INVMN_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVMN_updated_at';

            ;THROW 51007,
                N'Column INVMN_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')

            AND c.name =
                    N'INVMN_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVMN_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVMN_updated_at';

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
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : inventory.InventoryMovementNote';

        ;THROW 51008,
            N'inventory.InventoryMovementNote is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : inventory.InventoryMovementNote';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';