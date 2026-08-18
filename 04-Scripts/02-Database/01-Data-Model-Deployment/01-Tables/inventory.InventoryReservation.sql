    /*==============================================================================
        ATLAS COMMERCE - INVENTORY.INVENTORYRESERVATION
    ==============================================================================

        Object      : inventory.InventoryReservation
        Type        : Operational Table
        Prefix      : INVRE
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the current reservation associated with each sales transaction
        item and tracks its lifecycle within Atlas Commerce.

        Design Principles
        --------------------------------------------------------------------------
        - Maintain at most one reservation per sales.TransactionItem.
        - Associate each reservation with the ProductVariant being reserved.
        - Track the quantity committed to the reservation.
        - Track reservation lifecycle through InventoryReservationStatus.
        - Store the reservation creation and expiration business timestamps.
        - Store a single closing timestamp for consumed, released, or expired
        reservations.
        - Keep physical inventory movements outside this table.
        - Keep current aggregate reserved quantity in inventory.Inventory.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy check constraints in the dedicated Checks stage.
        - Deploy unique constraints in the dedicated Unique stage.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Deploy additional indexes only when operationally justified.
        - Store reservation state in FG_CORE.
        - Do not partition this table for the current scope.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    inventory.InventoryReservation';
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

        ;THROW 50940,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryReservation', N'U') IS NULL
    BEGIN

        CREATE TABLE inventory.InventoryReservation
        (
            INVRE_id                    bigint       IDENTITY(1,1) NOT NULL,

            INVRE_TRNIT_id              bigint       NOT NULL,
            INVRE_TRNIT_transaction_at  datetime2(0) NOT NULL,

            INVRE_PRDVA_id              int          NOT NULL,
            INVRE_INVRS_id              tinyint      NOT NULL,

            INVRE_quantity              int          NOT NULL,

            INVRE_reserved_at           datetime2(0) NOT NULL,
            INVRE_expires_at            datetime2(0) NOT NULL,
            INVRE_closed_at             datetime2(0) NULL,

            INVRE_created_at            datetime2(0) NOT NULL,
            INVRE_updated_at            datetime2(0) NOT NULL,

            CONSTRAINT PK_INVRE
                PRIMARY KEY CLUSTERED
                (
                    INVRE_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : inventory.InventoryReservation';
        PRINT N'            Prefix                          : INVRE';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : INVRE_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : inventory.InventoryReservation';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: INVRE_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'inventory.InventoryReservation')

            AND c.name = N'INVRE_id'
            AND TYPE_NAME(c.user_type_id) = N'bigint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : INVRE_id';

            ;THROW 50941,
                N'Column INVRE_id does not match the expected definition bigint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : INVRE_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_INVRE
        --------------------------------------------------------------------------*/

        DECLARE @INVRE_ActualPrimaryKeyName sysname;


        SELECT
            @INVRE_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')

        AND kc.type = N'PK';


        IF @INVRE_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_INVRE';

            ;THROW 50942,
                N'Primary key for inventory.InventoryReservation does not exist.',
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
                    OBJECT_ID(N'inventory.InventoryReservation')

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
                AND c.name = N'INVRE_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @INVRE_ActualPrimaryKeyName;

            ;THROW 50943,
                N'Primary key does not match the expected clustered definition INVRE_id.',
                1;

        END;


        IF @INVRE_ActualPrimaryKeyName <> N'PK_INVRE'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_INVRE';
            PRINT N'                Actual                       : '
                + @INVRE_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_INVRE';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRE_TRNIT_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_TRNIT_id') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                ADD INVRE_TRNIT_id bigint NULL;

            PRINT N'            [+] Column added                  : INVRE_TRNIT_id';
            PRINT N'            [!] Pending action                : Backfill INVRE_TRNIT_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_TRNIT_id'
            AND TYPE_NAME(user_type_id) = N'bigint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRE_TRNIT_id';

            ;THROW 50944,
                N'Column INVRE_TRNIT_id does not match the expected data type bigint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_TRNIT_id'
            AND is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRE_TRNIT_id';
            PRINT N'            [!] Expected final definition     : bigint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRE_TRNIT_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRE_TRNIT_transaction_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_TRNIT_transaction_at') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                ADD INVRE_TRNIT_transaction_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVRE_TRNIT_transaction_at';
            PRINT N'            [!] Pending action                : Backfill INVRE_TRNIT_transaction_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_TRNIT_transaction_at'
            AND TYPE_NAME(user_type_id) = N'datetime2'
            AND scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRE_TRNIT_transaction_at';

            ;THROW 50945,
                N'Column INVRE_TRNIT_transaction_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_TRNIT_transaction_at'
            AND is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRE_TRNIT_transaction_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRE_TRNIT_transaction_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRE_PRDVA_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_PRDVA_id') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                ADD INVRE_PRDVA_id int NULL;

            PRINT N'            [+] Column added                  : INVRE_PRDVA_id';
            PRINT N'            [!] Pending action                : Backfill INVRE_PRDVA_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_PRDVA_id'
            AND TYPE_NAME(user_type_id) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRE_PRDVA_id';

            ;THROW 50946,
                N'Column INVRE_PRDVA_id does not match the expected data type int.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_PRDVA_id'
            AND is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRE_PRDVA_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRE_PRDVA_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRE_INVRS_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_INVRS_id') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                ADD INVRE_INVRS_id tinyint NULL;

            PRINT N'            [+] Column added                  : INVRE_INVRS_id';
            PRINT N'            [!] Pending action                : Backfill INVRE_INVRS_id before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_INVRS_id'
            AND TYPE_NAME(user_type_id) = N'tinyint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRE_INVRS_id';

            ;THROW 50947,
                N'Column INVRE_INVRS_id does not match the expected data type tinyint.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_INVRS_id'
            AND is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRE_INVRS_id';
            PRINT N'            [!] Expected final definition     : tinyint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRE_INVRS_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRE_quantity
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_quantity') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                ADD INVRE_quantity int NULL;

            PRINT N'            [+] Column added                  : INVRE_quantity';
            PRINT N'            [!] Pending action                : Backfill INVRE_quantity before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_quantity'
            AND TYPE_NAME(user_type_id) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRE_quantity';

            ;THROW 50948,
                N'Column INVRE_quantity does not match the expected data type int.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_quantity'
            AND is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRE_quantity';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRE_quantity';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRE_reserved_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_reserved_at') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                ADD INVRE_reserved_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVRE_reserved_at';
            PRINT N'            [!] Pending action                : Backfill INVRE_reserved_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_reserved_at'
            AND TYPE_NAME(user_type_id) = N'datetime2'
            AND scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRE_reserved_at';

            ;THROW 50949,
                N'Column INVRE_reserved_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_reserved_at'
            AND is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRE_reserved_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRE_reserved_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRE_expires_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_expires_at') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                ADD INVRE_expires_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVRE_expires_at';
            PRINT N'            [!] Pending action                : Backfill INVRE_expires_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_expires_at'
            AND TYPE_NAME(user_type_id) = N'datetime2'
            AND scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRE_expires_at';

            ;THROW 50950,
                N'Column INVRE_expires_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_expires_at'
            AND is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRE_expires_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRE_expires_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRE_closed_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_closed_at') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                ADD INVRE_closed_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVRE_closed_at';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_closed_at'
            AND TYPE_NAME(user_type_id) = N'datetime2'
            AND scale = 0
            AND is_nullable = 1
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRE_closed_at';

            ;THROW 50951,
                N'Column INVRE_closed_at does not match the expected definition datetime2(0) NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRE_closed_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRE_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_created_at') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                ADD INVRE_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVRE_created_at';
            PRINT N'            [!] Pending action                : Backfill INVRE_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_created_at'
            AND TYPE_NAME(user_type_id) = N'datetime2'
            AND scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRE_created_at';

            ;THROW 50952,
                N'Column INVRE_created_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_created_at'
            AND is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRE_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRE_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: INVRE_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_updated_at') IS NULL
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                ADD INVRE_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : INVRE_updated_at';
            PRINT N'            [!] Pending action                : Backfill INVRE_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_updated_at'
            AND TYPE_NAME(user_type_id) = N'datetime2'
            AND scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : INVRE_updated_at';

            ;THROW 50953,
                N'Column INVRE_updated_at does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1
            FROM sys.columns
            WHERE object_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND name = N'INVRE_updated_at'
            AND is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : INVRE_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : INVRE_updated_at';

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
                OBJECT_ID(N'inventory.InventoryReservation')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : inventory.InventoryReservation';

        ;THROW 50954,
            N'inventory.InventoryReservation is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : inventory.InventoryReservation';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';