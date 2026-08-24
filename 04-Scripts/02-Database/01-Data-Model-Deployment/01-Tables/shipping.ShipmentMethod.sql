    /*==============================================================================
        ATLAS COMMERCE - SHIPPING.SHIPMENTMETHOD
    ==============================================================================

        Object      : shipping.ShipmentMethod
        Type        : Reference Table
        Prefix      : SHPMT
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled shipment methods available for Atlas Commerce
        deliveries.

        Design Principles
        --------------------------------------------------------------------------
        - Use controlled shipment methods instead of free-text classifications.
        - Support consistent operational and analytical interpretation.
        - Store only the shipment method master data in this table.
        - Keep shipment cost, delivery estimates, and tracking data outside this table.
        - Deploy seed data in the dedicated Seed stage.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy unique constraints in the dedicated Unique stage.
        - Store shipment reference data in FG_CORE.
        - Do not partition this reference table.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● shipping.ShipmentMethod';
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

    IF OBJECT_ID(N'shipping.ShipmentMethod', N'U') IS NULL
    BEGIN

        CREATE TABLE shipping.ShipmentMethod
        (
            SHPMT_id          tinyint         IDENTITY(1,1) NOT NULL,

            SHPMT_name        varchar(30)     NOT NULL,

            SHPMT_created_at  datetime2(0)    NOT NULL,
            SHPMT_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_SHPMT
                PRIMARY KEY CLUSTERED
                (
                    SHPMT_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : shipping.ShipmentMethod';
        PRINT N'            Prefix                          : SHPMT';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : SHPMT_id';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : shipping.ShipmentMethod';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: SHPMT_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentMethod')

            AND c.name =
                    N'SHPMT_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'tinyint'

            AND c.is_nullable = 0

            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1

            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : SHPMT_id';

            ;THROW 51001,
                N'Column SHPMT_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : SHPMT_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_SHPMT
        --------------------------------------------------------------------------*/

        DECLARE @SHPMT_ActualPrimaryKeyName sysname;


        SELECT
            @SHPMT_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'shipping.ShipmentMethod')

        AND kc.type =
                N'PK';


        IF @SHPMT_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_SHPMT';

            ;THROW 51002,
                N'Primary key for shipping.ShipmentMethod does not exist.',
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
                    OBJECT_ID(N'shipping.ShipmentMethod')

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
                        N'SHPMT_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @SHPMT_ActualPrimaryKeyName;

            ;THROW 51003,
                N'Primary key does not match the expected clustered definition SHPMT_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @SHPMT_ActualPrimaryKeyName <>
                N'PK_SHPMT'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_SHPMT';
            PRINT N'                Actual                       : '
                + @SHPMT_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_SHPMT';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHPMT_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.ShipmentMethod',
            N'SHPMT_name'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.ShipmentMethod
                ADD SHPMT_name varchar(30) NULL;

            PRINT N'            [+] Column added                  : SHPMT_name';
            PRINT N'            [!] Pending action                : Backfill SHPMT_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentMethod')

            AND c.name =
                    N'SHPMT_name'

            AND TYPE_NAME(c.user_type_id) =
                    N'varchar'

            AND c.max_length = 30
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHPMT_name';

            ;THROW 51004,
                N'Column SHPMT_name does not match the expected data type varchar(30).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentMethod')

            AND c.name =
                    N'SHPMT_name'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHPMT_name';
            PRINT N'            [!] Expected final definition     : varchar(30) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHPMT_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHPMT_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.ShipmentMethod',
            N'SHPMT_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.ShipmentMethod
                ADD SHPMT_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : SHPMT_created_at';
            PRINT N'            [!] Pending action                : Backfill SHPMT_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentMethod')

            AND c.name =
                    N'SHPMT_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHPMT_created_at';

            ;THROW 51005,
                N'Column SHPMT_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentMethod')

            AND c.name =
                    N'SHPMT_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHPMT_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHPMT_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHPMT_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'shipping.ShipmentMethod',
            N'SHPMT_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE shipping.ShipmentMethod
                ADD SHPMT_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : SHPMT_updated_at';
            PRINT N'            [!] Pending action                : Backfill SHPMT_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentMethod')

            AND c.name =
                    N'SHPMT_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHPMT_updated_at';

            ;THROW 51006,
                N'Column SHPMT_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentMethod')

            AND c.name =
                    N'SHPMT_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHPMT_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHPMT_updated_at';

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
                OBJECT_ID(N'shipping.ShipmentMethod')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : shipping.ShipmentMethod';

        ;THROW 51007,
            N'shipping.ShipmentMethod is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : shipping.ShipmentMethod';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';