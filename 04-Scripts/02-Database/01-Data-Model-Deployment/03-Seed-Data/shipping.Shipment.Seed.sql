    PRINT N'';
    PRINT N'    ● shipping.Shipment';
    PRINT N'';

    DECLARE @SHP_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        shipping.Shipment -> SHP
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'shipping'
        AND PFX_table_name = N'Shipment'
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
            N'Shipment',
            N'SHP',
            1,
            @SHP_seed_timestamp,
            @SHP_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : shipping.Shipment -> SHP';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'shipping'
            AND PFX_table_name = N'Shipment'
            AND PFX_prefix = N'SHP'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : shipping.Shipment -> SHP';

        END
        ELSE
        BEGIN

            DECLARE @SHP_actual_prefix    nvarchar(5);
            DECLARE @SHP_actual_is_active bit;


            SELECT
                @SHP_actual_prefix =
                    PFX_prefix,

                @SHP_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'shipping'
            AND PFX_table_name = N'Shipment';


            PRINT N'        [!] Prefix registration mismatch  : shipping.Shipment';
            PRINT N'            Expected Prefix              : SHP';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@SHP_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @SHP_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';