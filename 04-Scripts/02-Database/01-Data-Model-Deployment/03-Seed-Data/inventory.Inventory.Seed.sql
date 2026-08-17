    PRINT N'    inventory.Inventory';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @INV_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        inventory.Inventory -> INV
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'inventory'
        AND PFX_table_name = N'Inventory'
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
            N'Inventory',
            N'INV',
            1,
            @INV_seed_timestamp,
            @INV_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : inventory.Inventory -> INV';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'Inventory'
            AND PFX_prefix = N'INV'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : inventory.Inventory -> INV';

        END
        ELSE
        BEGIN

            DECLARE @INV_actual_prefix     nvarchar(5);
            DECLARE @INV_actual_is_active  bit;


            SELECT
                @INV_actual_prefix =
                    PFX_prefix,

                @INV_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'Inventory';


            PRINT N'        [!] Prefix registration mismatch  : inventory.Inventory';
            PRINT N'            Expected Prefix              : INV';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@INV_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INV_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';