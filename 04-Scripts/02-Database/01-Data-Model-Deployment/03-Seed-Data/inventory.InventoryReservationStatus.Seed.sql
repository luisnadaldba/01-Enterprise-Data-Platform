    PRINT N'';
    PRINT N'    ● inventory.InventoryReservationStatus';
    PRINT N'';

    DECLARE @INVRS_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        inventory.InventoryReservationStatus -> INVRS
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'inventory'
        AND PFX_table_name = N'InventoryReservationStatus'
    )
    BEGIN

        INSERT INTO metadata.TablePrefix
        (
            PFX_schema_name,
            PFX_table_name,
            PFX_prefix,
            PFX_is_active,
            PFX_created_at,
            PFX_updated_at
        )
        VALUES
        (
            N'inventory',
            N'InventoryReservationStatus',
            N'INVRS',
            1,
            @INVRS_seed_timestamp,
            @INVRS_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : inventory.InventoryReservationStatus -> INVRS';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'InventoryReservationStatus'
            AND PFX_prefix = N'INVRS'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : inventory.InventoryReservationStatus -> INVRS';

        END
        ELSE
        BEGIN

            DECLARE @INVRS_actual_prefix    nvarchar(5);
            DECLARE @INVRS_actual_is_active bit;


            SELECT
                @INVRS_actual_prefix =
                    PFX_prefix,

                @INVRS_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'InventoryReservationStatus';


            PRINT N'        [!] Prefix registration mismatch  : inventory.InventoryReservationStatus';
            PRINT N'            Expected Prefix              : INVRS';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@INVRS_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INVRS_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        INVENTORY RESERVATION STATUS DATA
    ==============================================================================*/

    /*----------------------------------------------------------------------
        ACTIVE
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM inventory.InventoryReservationStatus
        WHERE INVRS_name = N'ACTIVE'
    )
    BEGIN

        INSERT INTO inventory.InventoryReservationStatus
        (
            INVRS_name,
            INVRS_created_at,
            INVRS_updated_at
        )
        VALUES
        (
            N'ACTIVE',
            @INVRS_seed_timestamp,
            @INVRS_seed_timestamp
        );

        PRINT N'        [+] Inventory reservation status added : ACTIVE';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Inventory reservation status validated : ACTIVE';

    END;


    /*----------------------------------------------------------------------
        CONSUMED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM inventory.InventoryReservationStatus
        WHERE INVRS_name = N'CONSUMED'
    )
    BEGIN

        INSERT INTO inventory.InventoryReservationStatus
        (
            INVRS_name,
            INVRS_created_at,
            INVRS_updated_at
        )
        VALUES
        (
            N'CONSUMED',
            @INVRS_seed_timestamp,
            @INVRS_seed_timestamp
        );

        PRINT N'        [+] Inventory reservation status added : CONSUMED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Inventory reservation status validated : CONSUMED';

    END;


    /*----------------------------------------------------------------------
        RELEASED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM inventory.InventoryReservationStatus
        WHERE INVRS_name = N'RELEASED'
    )
    BEGIN

        INSERT INTO inventory.InventoryReservationStatus
        (
            INVRS_name,
            INVRS_created_at,
            INVRS_updated_at
        )
        VALUES
        (
            N'RELEASED',
            @INVRS_seed_timestamp,
            @INVRS_seed_timestamp
        );

        PRINT N'        [+] Inventory reservation status added : RELEASED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Inventory reservation status validated : RELEASED';

    END;


    /*----------------------------------------------------------------------
        EXPIRED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM inventory.InventoryReservationStatus
        WHERE INVRS_name = N'EXPIRED'
    )
    BEGIN

        INSERT INTO inventory.InventoryReservationStatus
        (
            INVRS_name,
            INVRS_created_at,
            INVRS_updated_at
        )
        VALUES
        (
            N'EXPIRED',
            @INVRS_seed_timestamp,
            @INVRS_seed_timestamp
        );

        PRINT N'        [+] Inventory reservation status added : EXPIRED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Inventory reservation status validated : EXPIRED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';