    PRINT N'';
    PRINT N'    ● inventory.InventoryReservation';
    PRINT N'';

    DECLARE @INVRE_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        inventory.InventoryReservation -> INVRE
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'inventory'
        AND PFX_table_name = N'InventoryReservation'
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
            N'InventoryReservation',
            N'INVRE',
            1,
            @INVRE_seed_timestamp,
            @INVRE_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : inventory.InventoryReservation -> INVRE';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'InventoryReservation'
            AND PFX_prefix = N'INVRE'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : inventory.InventoryReservation -> INVRE';

        END
        ELSE
        BEGIN

            DECLARE @INVRE_actual_prefix    nvarchar(5);
            DECLARE @INVRE_actual_is_active bit;


            SELECT
                @INVRE_actual_prefix =
                    PFX_prefix,

                @INVRE_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'InventoryReservation';


            PRINT N'        [!] Prefix registration mismatch  : inventory.InventoryReservation';
            PRINT N'            Expected Prefix              : INVRE';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@INVRE_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INVRE_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';