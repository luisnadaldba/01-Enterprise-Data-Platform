    /*==============================================================================
        ATLAS COMMERCE - INVENTORY.INVENTORYRESERVATIONSTATUS
    ==============================================================================

        Object      : inventory.InventoryReservationStatus
        Type        : Reference Table
        Prefix      : INVRS
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled statuses used to represent the lifecycle of
        inventory reservations in Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Use controlled inventory reservation statuses instead of free-text
        classifications.
        - Support consistent operational and analytical interpretation.
        - Store only the inventory reservation status master data in this table.
        - Keep inventory reservation events and lifecycle dates outside this table.
        - Deploy seed data in the dedicated Seed stage.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy unique constraints in the dedicated Unique stage.
        - Store inventory reference data in FG_CORE.
        - Do not partition this reference table.

    ===========================================================-- :r $===================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    inventory.InventoryReservationStatus';
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

        ;THROW 50920,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryReservationStatus', N'U') IS NULL
    BEGIN

        CREATE TABLE inventory.InventoryReservationStatus
        (
            INVRS_id          tinyint         IDENTITY(1,1) NOT NULL,

            INVRS_name        nvarchar(50)    NOT NULL,

            INVRS_created_at  datetime2(0)    NOT NULL,
            INVRS_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_INVRS
                PRIMARY KEY CLUSTERED
                (
                    INVRS_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : inventory.InventoryReservationStatus';
        PRINT N'            Prefix                          : INVRS';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : INVRS_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : inventory.InventoryReservationStatus';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: INVRS_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')

            AND c.name = N'INVRS_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : INVRS_id';

            ;THROW 50921,
                N'Column INVRS_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : INVRS_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_INVRS
        --------------------------------------------------------------------------*/

        DECLARE @INVRS_ActualPrimaryKeyName sysname;


        SELECT
            @INVRS_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservationStatus')

        AND kc.type = N'PK';


        IF @INVRS_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_INVRS';

            ;THROW 50922,
                N'Primary key for inventory.InventoryReservationStatus does not exist.',
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
                    OBJECT_ID(N'inventory.InventoryReservationStatus')

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
                AND c.name = N'INVRS_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @INVRS_ActualPrimaryKeyName;

            ;THROW 50923,
                N'Primary key does not match the expected clustered definition INVRS_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @INVRS_ActualPrimaryKeyName <> N'PK_INVRS'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_INVRS';
            PRINT N'                Actual                       : '
                + @INVRS_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_INVRS';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRS_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'inventory.InventoryReservationStatus',
            N'INVRS_name'
        ) IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservationStatus
                ADD INVRS_name nvarchar(50) NULL;

            PRINT N'            [+] Column added                  : INVRS_name';
            PRINT N'            [!] Pending action                : Backfill INVRS_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')

            AND c.name = N'INVRS_name'
            AND TYPE_NAME(c.user_type_id) = N'nvarchar'
            AND c.max_length = 100
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRS_name';

            ;THROW 50924,
                N'Column INVRS_name does not match the expected data type nvarchar(50).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')

            AND c.name = N'INVRS_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRS_name';
            PRINT N'            [!] Expected final definition     : nvarchar(50) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRS_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRS_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'inventory.InventoryReservationStatus',
            N'INVRS_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservationStatus
                ADD INVRS_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVRS_created_at';
            PRINT N'            [!] Pending action                : Backfill INVRS_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')

            AND c.name = N'INVRS_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRS_created_at';

            ;THROW 50925,
                N'Column INVRS_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')

            AND c.name = N'INVRS_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRS_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRS_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRS_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'inventory.InventoryReservationStatus',
            N'INVRS_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservationStatus
                ADD INVRS_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVRS_updated_at';
            PRINT N'            [!] Pending action                : Backfill INVRS_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')

            AND c.name = N'INVRS_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRS_updated_at';

            ;THROW 50926,
                N'Column INVRS_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')

            AND c.name = N'INVRS_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRS_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRS_updated_at';

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
                OBJECT_ID(N'inventory.InventoryReservationStatus')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : inventory.InventoryReservationStatus';

        ;THROW 50927,
            N'inventory.InventoryReservationStatus is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : inventory.InventoryReservationStatus';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';