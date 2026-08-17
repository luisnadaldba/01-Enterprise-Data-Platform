    /*==============================================================================
        ATLAS COMMERCE - INVENTORY.INVENTORYMOVEMENTREASON
    ==============================================================================

        Object      : inventory.InventoryMovementReason
        Type        : Reference Table
        Prefix      : INVMR
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled reasons used to classify inventory movements
        in Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Use controlled movement reasons instead of free-text classifications.
        - Support consistent operational and analytical interpretation.
        - Keep movement direction semantics aligned with the movement quantity sign.
        - Store only the reason master data in this table.
        - Keep movement history outside this table.
        - Deploy seed data in the dedicated Seed stage.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy unique constraints in the dedicated Unique stage.
        - Store inventory reference data in FG_CORE.
        - Do not partition this reference table.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    inventory.InventoryMovementReason';
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

        ;THROW 50800,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovementReason', N'U') IS NULL
    BEGIN

        CREATE TABLE inventory.InventoryMovementReason
        (
            INVMR_id          smallint        IDENTITY(1,1) NOT NULL,

            INVMR_name        nvarchar(100)   NOT NULL,

            INVMR_created_at  datetime2(0)    NOT NULL,
            INVMR_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_INVMR
                PRIMARY KEY CLUSTERED
                (
                    INVMR_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : inventory.InventoryMovementReason';
        PRINT N'            Prefix                          : INVMR';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : INVMR_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : inventory.InventoryMovementReason';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: INVMR_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovementReason')
            AND c.name = N'INVMR_id'
            AND TYPE_NAME(c.user_type_id) = N'smallint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : INVMR_id';

            ;THROW 50801,
                N'Column INVMR_id does not match the expected definition smallint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : INVMR_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_INVMR
        --------------------------------------------------------------------------*/

        DECLARE @INVMR_ActualPrimaryKeyName sysname;


        SELECT
            @INVMR_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND kc.type = N'PK';


        IF @INVMR_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_INVMR';

            ;THROW 50802,
                N'Primary key for inventory.InventoryMovementReason does not exist.',
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
                    OBJECT_ID(N'inventory.InventoryMovementReason')

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
                AND c.name = N'INVMR_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @INVMR_ActualPrimaryKeyName;

            ;THROW 50803,
                N'Primary key does not match the expected clustered definition INVMR_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @INVMR_ActualPrimaryKeyName <> N'PK_INVMR'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_INVMR';
            PRINT N'                Actual                       : '
                + @INVMR_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_INVMR';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVMR_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovementReason', N'INVMR_name') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryMovementReason
                ADD INVMR_name nvarchar(100) NULL;

            PRINT N'            [+] Column added                  : INVMR_name';
            PRINT N'            [!] Pending action                : Backfill INVMR_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementReason')

            AND c.name = N'INVMR_name'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 200
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVMR_name';

            ;THROW 50804,
                N'Column INVMR_name does not match the expected data type nvarchar(100).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementReason')

            AND c.name = N'INVMR_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVMR_name';
            PRINT N'            [!] Expected final definition     : nvarchar(100) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVMR_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVMR_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovementReason', N'INVMR_created_at') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryMovementReason
                ADD INVMR_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVMR_created_at';
            PRINT N'            [!] Pending action                : Backfill INVMR_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementReason')

            AND c.name = N'INVMR_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVMR_created_at';

            ;THROW 50805,
                N'Column INVMR_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementReason')

            AND c.name = N'INVMR_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVMR_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVMR_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVMR_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovementReason', N'INVMR_updated_at') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryMovementReason
                ADD INVMR_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVMR_updated_at';
            PRINT N'            [!] Pending action                : Backfill INVMR_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementReason')

            AND c.name = N'INVMR_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVMR_updated_at';

            ;THROW 50806,
                N'Column INVMR_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementReason')

            AND c.name = N'INVMR_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVMR_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVMR_updated_at';

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
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : inventory.InventoryMovementReason';

        ;THROW 50807,
            N'inventory.InventoryMovementReason is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : inventory.InventoryMovementReason';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';