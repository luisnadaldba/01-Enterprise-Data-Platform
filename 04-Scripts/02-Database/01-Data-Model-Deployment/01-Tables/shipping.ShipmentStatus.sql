    /*==============================================================================
        ATLAS COMMERCE - SHIPPING.SHIPMENTSTATUS
    ==============================================================================

        Object      : shipping.ShipmentStatus
        Type        : Reference Table
        Prefix      : SHPST
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Maintains the controlled shipment statuses used by Atlas Commerce
        deliveries.

        Design Principles
        --------------------------------------------------------------------------
        - Use controlled shipment statuses instead of free-text classifications.
        - Support consistent operational and analytical interpretation.
        - Store only the shipment status master data in this table.
        - Keep shipment lifecycle events and tracking data outside this table.
        - Deploy seed data in the dedicated Seed stage.
        - Deploy default constraints in the dedicated Defaults stage.
        - Deploy unique constraints in the dedicated Unique stage.
        - Store shipment reference data in FG_CORE.
        - Do not partition this reference table.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    shipping.ShipmentStatus';
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

        ;THROW 51100,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'shipping.ShipmentStatus', N'U') IS NULL
    BEGIN

        CREATE TABLE shipping.ShipmentStatus
        (
            SHPST_id          tinyint         IDENTITY(1,1) NOT NULL,

            SHPST_name        varchar(30)     NOT NULL,

            SHPST_created_at  datetime2(0)    NOT NULL,
            SHPST_updated_at  datetime2(0)    NOT NULL,

            CONSTRAINT PK_SHPST
                PRIMARY KEY CLUSTERED
                (
                    SHPST_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : shipping.ShipmentStatus';
        PRINT N'            Prefix                          : SHPST';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : SHPST_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : shipping.ShipmentStatus';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: SHPST_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id = OBJECT_ID(N'shipping.ShipmentStatus')
            AND c.name = N'SHPST_id'
            AND TYPE_NAME(c.user_type_id) = N'tinyint'
            AND c.is_nullable = 0
            AND c.is_identity = 1
            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : SHPST_id';

            ;THROW 51101,
                N'Column SHPST_id does not match the expected definition tinyint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : SHPST_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_SHPST
        --------------------------------------------------------------------------*/

        DECLARE @SHPST_ActualPrimaryKeyName sysname;


        SELECT
            @SHPST_ActualPrimaryKeyName = kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'shipping.ShipmentStatus')

        AND kc.type = N'PK';


        IF @SHPST_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_SHPST';

            ;THROW 51102,
                N'Primary key for shipping.ShipmentStatus does not exist.',
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
                    OBJECT_ID(N'shipping.ShipmentStatus')

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
                AND c.name = N'SHPST_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @SHPST_ActualPrimaryKeyName;

            ;THROW 51103,
                N'Primary key does not match the expected clustered definition SHPST_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @SHPST_ActualPrimaryKeyName <> N'PK_SHPST'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_SHPST';
            PRINT N'                Actual                       : '
                + @SHPST_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_SHPST';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHPST_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'shipping.ShipmentStatus', N'SHPST_name') IS NULL
        BEGIN

            ALTER TABLE shipping.ShipmentStatus
                ADD SHPST_name varchar(30) NULL;

            PRINT N'            [+] Column added                  : SHPST_name';
            PRINT N'            [!] Pending action                : Backfill SHPST_name before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentStatus')

            AND c.name = N'SHPST_name'
            AND TYPE_NAME(c.user_type_id) = N'varchar'
            AND c.max_length = 30
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHPST_name';

            ;THROW 51104,
                N'Column SHPST_name does not match the expected data type varchar(30).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentStatus')

            AND c.name = N'SHPST_name'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHPST_name';
            PRINT N'            [!] Expected final definition     : varchar(30) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHPST_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHPST_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'shipping.ShipmentStatus', N'SHPST_created_at') IS NULL
        BEGIN

            ALTER TABLE shipping.ShipmentStatus
                ADD SHPST_created_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : SHPST_created_at';
            PRINT N'            [!] Pending action                : Backfill SHPST_created_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentStatus')

            AND c.name = N'SHPST_created_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHPST_created_at';

            ;THROW 51105,
                N'Column SHPST_created_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentStatus')

            AND c.name = N'SHPST_created_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHPST_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill SHPST_created_at before enforcing NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHPST_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: SHPST_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH(N'shipping.ShipmentStatus', N'SHPST_updated_at') IS NULL
        BEGIN

            ALTER TABLE shipping.ShipmentStatus
                ADD SHPST_updated_at datetime2(0) NULL;

            PRINT N'            [+] Column added                  : SHPST_updated_at';
            PRINT N'            [!] Pending action                : Backfill SHPST_updated_at before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentStatus')

            AND c.name = N'SHPST_updated_at'
            AND TYPE_NAME(c.user_type_id) = N'datetime2'
            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : SHPST_updated_at';

            ;THROW 51106,
                N'Column SHPST_updated_at does not match the expected data type datetime2(0).',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'shipping.ShipmentStatus')

            AND c.name = N'SHPST_updated_at'
            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : SHPST_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : SHPST_updated_at';

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
                OBJECT_ID(N'shipping.ShipmentStatus')

        AND i.type = 1
        AND i.is_unique = 1
        AND ds.name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : shipping.ShipmentStatus';

        ;THROW 51107,
            N'shipping.ShipmentStatus is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : shipping.ShipmentStatus';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';