    PRINT N'';
    PRINT N'    ● shipping.ShipmentMethod';
    PRINT N'';

    DECLARE @SHPMT_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        shipping.ShipmentMethod -> SHPMT
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'shipping'
        AND PFX_table_name = N'ShipmentMethod'
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
            N'ShipmentMethod',
            N'SHPMT',
            1,
            @SHPMT_seed_timestamp,
            @SHPMT_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : shipping.ShipmentMethod -> SHPMT';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'shipping'
            AND PFX_table_name = N'ShipmentMethod'
            AND PFX_prefix = N'SHPMT'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : shipping.ShipmentMethod -> SHPMT';

        END
        ELSE
        BEGIN

            DECLARE @SHPMT_actual_prefix    nvarchar(5);
            DECLARE @SHPMT_actual_is_active bit;


            SELECT
                @SHPMT_actual_prefix =
                    PFX_prefix,

                @SHPMT_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'shipping'
            AND PFX_table_name = N'ShipmentMethod';


            PRINT N'        [!] Prefix registration mismatch  : shipping.ShipmentMethod';
            PRINT N'            Expected Prefix              : SHPMT';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@SHPMT_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @SHPMT_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        SHIPMENT METHOD DATA
    ==============================================================================*/

    /*----------------------------------------------------------------------
        PAC
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentMethod
        WHERE SHPMT_name = N'PAC'
    )
    BEGIN

        INSERT INTO shipping.ShipmentMethod
        (
            SHPMT_name,
            SHPMT_created_at,
            SHPMT_updated_at
        )
        VALUES
        (
            N'PAC',
            @SHPMT_seed_timestamp,
            @SHPMT_seed_timestamp
        );

        PRINT N'        [+] Shipment method added          : PAC';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Shipment method validated      : PAC';

    END;


    /*----------------------------------------------------------------------
        SEDEX
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentMethod
        WHERE SHPMT_name = N'SEDEX'
    )
    BEGIN

        INSERT INTO shipping.ShipmentMethod
        (
            SHPMT_name,
            SHPMT_created_at,
            SHPMT_updated_at
        )
        VALUES
        (
            N'SEDEX',
            @SHPMT_seed_timestamp,
            @SHPMT_seed_timestamp
        );

        PRINT N'        [+] Shipment method added          : SEDEX';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Shipment method validated      : SEDEX';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';