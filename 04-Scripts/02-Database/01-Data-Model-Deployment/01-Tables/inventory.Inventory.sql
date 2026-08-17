    /*==============================================================================
        ATLAS COMMERCE - INVENTORY.INVENTORY
    ==============================================================================

        Object      : inventory.Inventory
        Type        : Operational Table
        Prefix      : INV
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the current usable and reserved stock quantities for each
        product variant in Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Maintain one current inventory balance per ProductVariant.
        - Track only usable physical stock in INV_quantity_on_hand.
        - Track stock already committed to active reservations separately.
        - Derive available stock as quantity on hand minus quantity reserved.
        - Do not store derived available quantity redundantly.
        - Keep inventory history outside this table in the movement structure.
        - Support a single physical inventory location for the current scope.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy check constraints in the dedicated Checks stage.
        - Deploy unique constraints in the dedicated Unique stage.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Store current inventory state in FG_CORE.
        - Do not partition this current-state operational table.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    inventory.Inventory';
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

        ;THROW 50700,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.Inventory', N'U') IS NULL
    BEGIN

        CREATE TABLE inventory.Inventory
        (
            INV_id                 int          IDENTITY(1,1) NOT NULL,

            INV_PRDVA_id           int          NOT NULL,

            INV_quantity_on_hand   int          NOT NULL,
            INV_quantity_reserved  int          NOT NULL,

            INV_created_at         datetime2(0) NOT NULL,
            INV_updated_at         datetime2(0) NOT NULL,

            CONSTRAINT PK_INV
                PRIMARY KEY CLUSTERED
                (
                    INV_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : inventory.Inventory';
        PRINT N'            Prefix                          : INV';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : INV_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : inventory.Inventory';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: INV_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'inventory.Inventory')
            AND c.name = N'INV_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : INV_id';

            ;THROW 50701,
                N'Column INV_id does not match the expected definition int IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : INV_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_INV
        --------------------------------------------------------------------------*/

        DECLARE @INV_ActualPrimaryKeyName sysname;


        SELECT
            @INV_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'inventory.Inventory')

        AND kc.type = N'PK';


        IF @INV_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_INV';

            ;THROW 50702,
                N'Primary key for inventory.Inventory does not exist.',
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
                    OBJECT_ID(N'inventory.Inventory')

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
                AND c.name = N'INV_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @INV_ActualPrimaryKeyName;

            ;THROW 50703,
                N'Primary key does not match the expected clustered definition INV_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @INV_ActualPrimaryKeyName <> N'PK_INV'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_INV';
            PRINT N'                Actual                       : '
                + @INV_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_INV';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INV_PRDVA_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.Inventory', N'INV_PRDVA_id') IS NULL
        BEGIN

            ALTER TABLE inventory.Inventory
                ADD INV_PRDVA_id int NULL;

            PRINT N'            [+] Column added                  : INV_PRDVA_id';
            PRINT N'            [!] Pending action                : Backfill INV_PRDVA_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.Inventory')

            AND c.name = N'INV_PRDVA_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INV_PRDVA_id';

            ;THROW 50704,
                N'Column INV_PRDVA_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.Inventory')

            AND c.name = N'INV_PRDVA_id'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INV_PRDVA_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INV_PRDVA_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INV_quantity_on_hand
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.Inventory', N'INV_quantity_on_hand') IS NULL
        BEGIN

            ALTER TABLE inventory.Inventory
                ADD INV_quantity_on_hand int NULL;

            PRINT N'            [+] Column added                  : INV_quantity_on_hand';
            PRINT N'            [!] Pending action                : Backfill INV_quantity_on_hand before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.Inventory')

            AND c.name = N'INV_quantity_on_hand'
            AND TYPE_NAME(c.user_type_id) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INV_quantity_on_hand';

            ;THROW 50705,
                N'Column INV_quantity_on_hand does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.Inventory')

            AND c.name = N'INV_quantity_on_hand'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INV_quantity_on_hand';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INV_quantity_on_hand';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INV_quantity_reserved
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.Inventory', N'INV_quantity_reserved') IS NULL
        BEGIN

            ALTER TABLE inventory.Inventory
                ADD INV_quantity_reserved int NULL;

            PRINT N'            [+] Column added                  : INV_quantity_reserved';
            PRINT N'            [!] Pending action                : Backfill INV_quantity_reserved before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.Inventory')

            AND c.name = N'INV_quantity_reserved'
            AND TYPE_NAME(c.user_type_id) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INV_quantity_reserved';

            ;THROW 50706,
                N'Column INV_quantity_reserved does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.Inventory')

            AND c.name = N'INV_quantity_reserved'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INV_quantity_reserved';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INV_quantity_reserved';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INV_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.Inventory', N'INV_created_at') IS NULL
        BEGIN

            ALTER TABLE inventory.Inventory
                ADD INV_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INV_created_at';
            PRINT N'            [!] Pending action                : Backfill INV_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.Inventory')

            AND c.name = N'INV_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INV_created_at';

            ;THROW 50707,
                N'Column INV_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.Inventory')

            AND c.name = N'INV_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INV_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INV_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INV_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.Inventory', N'INV_updated_at') IS NULL
        BEGIN

            ALTER TABLE inventory.Inventory
                ADD INV_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INV_updated_at';
            PRINT N'            [!] Pending action                : Backfill INV_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.Inventory')

            AND c.name = N'INV_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INV_updated_at';

            ;THROW 50708,
                N'Column INV_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.Inventory')

            AND c.name = N'INV_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INV_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INV_updated_at';

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
                OBJECT_ID(N'inventory.Inventory')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : inventory.Inventory';

        ;THROW 50709,
            N'inventory.Inventory is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : inventory.Inventory';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';