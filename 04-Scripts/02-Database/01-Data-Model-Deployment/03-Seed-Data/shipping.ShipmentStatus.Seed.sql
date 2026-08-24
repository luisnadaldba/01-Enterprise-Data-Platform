    PRINT N'';
    PRINT N'    ● shipping.ShipmentStatus';
    PRINT N'';

    DECLARE @SHPST_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        shipping.ShipmentStatus -> SHPST
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'shipping'
        AND PFX_table_name = N'ShipmentStatus'
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
            N'shipping',
            N'ShipmentStatus',
            N'SHPST',
            1,
            @SHPST_seed_timestamp,
            @SHPST_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : shipping.ShipmentStatus -> SHPST';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'shipping'
            AND PFX_table_name = N'ShipmentStatus'
            AND PFX_prefix = N'SHPST'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : shipping.ShipmentStatus -> SHPST';

        END
        ELSE
        BEGIN

            DECLARE @SHPST_actual_prefix    nvarchar(5);
            DECLARE @SHPST_actual_is_active bit;


            SELECT
                @SHPST_actual_prefix =
                    PFX_prefix,

                @SHPST_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'shipping'
            AND PFX_table_name = N'ShipmentStatus';


            PRINT N'        [!] Prefix registration mismatch  : shipping.ShipmentStatus';
            PRINT N'            Expected Prefix              : SHPST';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@SHPST_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @SHPST_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        SHIPMENT STATUS DATA
    ==============================================================================*/

    /*----------------------------------------------------------------------
        PENDING
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentStatus
        WHERE SHPST_name = N'PENDING'
    )
    BEGIN

        INSERT INTO shipping.ShipmentStatus
        (
            SHPST_name,
            SHPST_created_at,
            SHPST_updated_at
        )
        VALUES
        (
            N'PENDING',
            @SHPST_seed_timestamp,
            @SHPST_seed_timestamp
        );

        PRINT N'        [+] Shipment status added          : PENDING';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Shipment status validated      : PENDING';

    END;


    /*----------------------------------------------------------------------
        POSTED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentStatus
        WHERE SHPST_name = N'POSTED'
    )
    BEGIN

        INSERT INTO shipping.ShipmentStatus
        (
            SHPST_name,
            SHPST_created_at,
            SHPST_updated_at
        )
        VALUES
        (
            N'POSTED',
            @SHPST_seed_timestamp,
            @SHPST_seed_timestamp
        );

        PRINT N'        [+] Shipment status added          : POSTED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Shipment status validated      : POSTED';

    END;


    /*----------------------------------------------------------------------
        DELIVERED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentStatus
        WHERE SHPST_name = N'DELIVERED'
    )
    BEGIN

        INSERT INTO shipping.ShipmentStatus
        (
            SHPST_name,
            SHPST_created_at,
            SHPST_updated_at
        )
        VALUES
        (
            N'DELIVERED',
            @SHPST_seed_timestamp,
            @SHPST_seed_timestamp
        );

        PRINT N'        [+] Shipment status added          : DELIVERED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Shipment status validated      : DELIVERED';

    END;


    /*----------------------------------------------------------------------
        CANCELLED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentStatus
        WHERE SHPST_name = N'CANCELLED'
    )
    BEGIN

        INSERT INTO shipping.ShipmentStatus
        (
            SHPST_name,
            SHPST_created_at,
            SHPST_updated_at
        )
        VALUES
        (
            N'CANCELLED',
            @SHPST_seed_timestamp,
            @SHPST_seed_timestamp
        );

        PRINT N'        [+] Shipment status added          : CANCELLED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Shipment status validated      : CANCELLED';

    END;


    /*----------------------------------------------------------------------
        RETURNED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentStatus
        WHERE SHPST_name = N'RETURNED'
    )
    BEGIN

        INSERT INTO shipping.ShipmentStatus
        (
            SHPST_name,
            SHPST_created_at,
            SHPST_updated_at
        )
        VALUES
        (
            N'RETURNED',
            @SHPST_seed_timestamp,
            @SHPST_seed_timestamp
        );

        PRINT N'        [+] Shipment status added          : RETURNED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Shipment status validated      : RETURNED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';