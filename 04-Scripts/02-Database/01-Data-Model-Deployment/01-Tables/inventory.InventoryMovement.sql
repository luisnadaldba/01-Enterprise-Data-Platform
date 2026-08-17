    /*==============================================================================
        ATLAS COMMERCE - INVENTORY.INVENTORYMOVEMENT
    ==============================================================================

        Object      : inventory.InventoryMovement
        Type        : Transactional History Table
        Prefix      : INVMV
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the historical inventory movements for each product variant
        in Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Record each physical inventory change as a separate historical event.
        - Store movement quantity with sign: positive for entries and negative
          for exits.
        - Do not allow zero-quantity movements.
        - Classify each movement through InventoryMovementReason.
        - Optionally relate sale-originated movements to the composite key of sales.TransactionItem.
        - Preserve the business event time separately from row creation time.
        - Prefer compensating movements instead of rewriting historical facts.
        - Keep free-text observations outside this table in InventoryMovementNote.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy check constraints in the dedicated Checks stage.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Store inventory movement history in FG_CORE.
        - Do not partition this table in the current scope.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    inventory.InventoryMovement';
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

        ;THROW 50900,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovement', N'U') IS NULL
    BEGIN

        CREATE TABLE inventory.InventoryMovement
        (
            INVMV_id            bigint       IDENTITY(1,1) NOT NULL,

            INVMV_PRDVA_id      int          NOT NULL,
            INVMV_INVMR_id      smallint     NOT NULL,
            INVMV_TRNIT_id              bigint       NULL,
            INVMV_TRNIT_transaction_at  datetime2(0) NULL,

            INVMV_quantity      int          NOT NULL,
            INVMV_movement_at   datetime2(0) NOT NULL,

            INVMV_created_at    datetime2(0) NOT NULL,
            INVMV_updated_at    datetime2(0) NOT NULL,

            CONSTRAINT PK_INVMV
                PRIMARY KEY CLUSTERED
                (
                    INVMV_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : inventory.InventoryMovement';
        PRINT N'            Prefix                          : INVMV';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : INVMV_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : inventory.InventoryMovement';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: INVMV_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_id'
            AND TYPE_NAME(c.user_type_id) = N'bigint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : INVMV_id';

            ;THROW 50901,
                N'Column INVMV_id does not match the expected definition bigint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : INVMV_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_INVMV
        --------------------------------------------------------------------------*/

        DECLARE @INVMV_ActualPrimaryKeyName sysname;


        SELECT
            @INVMV_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND kc.type = N'PK';


        IF @INVMV_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_INVMV';

            ;THROW 50902,
                N'Primary key for inventory.InventoryMovement does not exist.',
                1;

        END;


        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.key_constraints AS kc

            INNER JOIN sys.indexes AS i
                ON  i.object_id = kc.parent_object_id
                AND i.index_id = kc.unique_index_id

            WHERE kc.parent_object_id =
                    OBJECT_ID(N'inventory.InventoryMovement')

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
                AND c.name = N'INVMV_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @INVMV_ActualPrimaryKeyName;

            ;THROW 50903,
                N'Primary key does not match the expected clustered definition INVMV_id.',
                1;

        END;


        IF @INVMV_ActualPrimaryKeyName <> N'PK_INVMV'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_INVMV';
            PRINT N'                Actual                       : '
                + @INVMV_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_INVMV';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVMV_PRDVA_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_PRDVA_id') IS NULL
        BEGIN
            ALTER TABLE inventory.InventoryMovement
                ADD INVMV_PRDVA_id int NULL;

            PRINT N'            [+] Column added                  : INVMV_PRDVA_id';
            PRINT N'            [!] Pending action                : Backfill INVMV_PRDVA_id before enforcing NOT NULL';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_PRDVA_id'
            AND TYPE_NAME(c.user_type_id) = N'int'
        )
        BEGIN
            PRINT N'            [X] Column definition mismatch    : INVMV_PRDVA_id';
            ;THROW 50904, N'Column INVMV_PRDVA_id does not match the expected data type int.', 1;
        END
        ELSE IF EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_PRDVA_id'
            AND c.is_nullable = 1
        )
        BEGIN
            PRINT N'            [!] Column nullable               : INVMV_PRDVA_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';
        END
        ELSE
            PRINT N'            [•] Column validated              : INVMV_PRDVA_id';


        /*--------------------------------------------------------------------------
            COLUMN: INVMV_INVMR_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_INVMR_id') IS NULL
        BEGIN
            ALTER TABLE inventory.InventoryMovement
                ADD INVMV_INVMR_id smallint NULL;

            PRINT N'            [+] Column added                  : INVMV_INVMR_id';
            PRINT N'            [!] Pending action                : Backfill INVMV_INVMR_id before enforcing NOT NULL';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_INVMR_id'
            AND TYPE_NAME(c.user_type_id) = N'smallint'
        )
        BEGIN
            PRINT N'            [X] Column definition mismatch    : INVMV_INVMR_id';
            ;THROW 50905, N'Column INVMV_INVMR_id does not match the expected data type smallint.', 1;
        END
        ELSE IF EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_INVMR_id'
            AND c.is_nullable = 1
        )
        BEGIN
            PRINT N'            [!] Column nullable               : INVMV_INVMR_id';
            PRINT N'            [!] Expected final definition     : smallint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';
        END
        ELSE
            PRINT N'            [•] Column validated              : INVMV_INVMR_id';


        /*--------------------------------------------------------------------------
            COLUMN: INVMV_TRNIT_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_TRNIT_id') IS NULL
        BEGIN
            ALTER TABLE inventory.InventoryMovement
                ADD INVMV_TRNIT_id bigint NULL;

            PRINT N'            [+] Column added                  : INVMV_TRNIT_id';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_TRNIT_id'
            AND TYPE_NAME(c.user_type_id) = N'bigint'
            AND c.is_nullable = 1
        )
        BEGIN
            PRINT N'            [X] Column definition mismatch    : INVMV_TRNIT_id';
            ;THROW 50906, N'Column INVMV_TRNIT_id does not match the expected definition bigint NULL.', 1;
        END
        ELSE
            PRINT N'            [•] Column validated              : INVMV_TRNIT_id';


        /*--------------------------------------------------------------------------
            COLUMN: INVMV_TRNIT_transaction_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_TRNIT_transaction_at') IS NULL
        BEGIN
            ALTER TABLE inventory.InventoryMovement
                ADD INVMV_TRNIT_transaction_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVMV_TRNIT_transaction_at';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_TRNIT_transaction_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
            AND c.is_nullable = 1
        )
        BEGIN
            PRINT N'            [X] Column definition mismatch    : INVMV_TRNIT_transaction_at';

            ;THROW 50912,
                N'Column INVMV_TRNIT_transaction_at does not match the expected definition datetime2(0) NULL.',
                1;
        END
        ELSE
        BEGIN
            PRINT N'            [•] Column validated              : INVMV_TRNIT_transaction_at';
        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVMV_quantity
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_quantity') IS NULL
        BEGIN
            ALTER TABLE inventory.InventoryMovement
                ADD INVMV_quantity int NULL;

            PRINT N'            [+] Column added                  : INVMV_quantity';
            PRINT N'            [!] Pending action                : Backfill INVMV_quantity before enforcing NOT NULL';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_quantity'
            AND TYPE_NAME(c.user_type_id) = N'int'
        )
        BEGIN
            PRINT N'            [X] Column definition mismatch    : INVMV_quantity';
            ;THROW 50907, N'Column INVMV_quantity does not match the expected data type int.', 1;
        END
        ELSE IF EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_quantity'
            AND c.is_nullable = 1
        )
        BEGIN
            PRINT N'            [!] Column nullable               : INVMV_quantity';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';
        END
        ELSE
            PRINT N'            [•] Column validated              : INVMV_quantity';


        /*--------------------------------------------------------------------------
            COLUMN: INVMV_movement_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_movement_at') IS NULL
        BEGIN
            ALTER TABLE inventory.InventoryMovement
                ADD INVMV_movement_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVMV_movement_at';
            PRINT N'            [!] Pending action                : Backfill INVMV_movement_at before enforcing NOT NULL';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_movement_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN
            PRINT N'            [X] Column definition mismatch    : INVMV_movement_at';
            ;THROW 50908, N'Column INVMV_movement_at does not match the expected data type datetime2(0).', 1;
        END
        ELSE IF EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_movement_at'
            AND c.is_nullable = 1
        )
        BEGIN
            PRINT N'            [!] Column nullable               : INVMV_movement_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';
        END
        ELSE
            PRINT N'            [•] Column validated              : INVMV_movement_at';


        /*--------------------------------------------------------------------------
            COLUMN: INVMV_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_created_at') IS NULL
        BEGIN
            ALTER TABLE inventory.InventoryMovement
                ADD INVMV_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVMV_created_at';
            PRINT N'            [!] Pending action                : Backfill INVMV_created_at before enforcing NOT NULL';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN
            PRINT N'            [X] Column definition mismatch    : INVMV_created_at';
            ;THROW 50909, N'Column INVMV_created_at does not match the expected data type datetime2(0).', 1;
        END
        ELSE IF EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_created_at'
            AND c.is_nullable = 1
        )
        BEGIN
            PRINT N'            [!] Column nullable               : INVMV_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';
        END
        ELSE
            PRINT N'            [•] Column validated              : INVMV_created_at';


        /*--------------------------------------------------------------------------
            COLUMN: INVMV_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_updated_at') IS NULL
        BEGIN
            ALTER TABLE inventory.InventoryMovement
                ADD INVMV_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVMV_updated_at';
            PRINT N'            [!] Pending action                : Backfill INVMV_updated_at before enforcing NOT NULL';
        END
        ELSE IF NOT EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN
            PRINT N'            [X] Column definition mismatch    : INVMV_updated_at';
            ;THROW 50910, N'Column INVMV_updated_at does not match the expected data type datetime2(0).', 1;
        END
        ELSE IF EXISTS
        (
            SELECT 1 FROM sys.columns AS c
            WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND c.name = N'INVMV_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN
            PRINT N'            [!] Column nullable               : INVMV_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';
        END
        ELSE
            PRINT N'            [•] Column validated              : INVMV_updated_at';

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
                OBJECT_ID(N'inventory.InventoryMovement')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : inventory.InventoryMovement';

        ;THROW 50911,
            N'inventory.InventoryMovement is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : inventory.InventoryMovement';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';