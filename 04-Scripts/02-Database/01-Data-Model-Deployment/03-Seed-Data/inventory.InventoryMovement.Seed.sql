    PRINT N'';
    PRINT N'    ● inventory.InventoryMovement';
    PRINT N'';

    DECLARE @INVMV_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        inventory.InventoryMovement -> INVMV
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'inventory'
        AND PFX_table_name = N'InventoryMovement'
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
            N'InventoryMovement',
            N'INVMV',
            1,
            @INVMV_seed_timestamp,
            @INVMV_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : inventory.InventoryMovement -> INVMV';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'InventoryMovement'
            AND PFX_prefix = N'INVMV'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : inventory.InventoryMovement -> INVMV';

        END
        ELSE
        BEGIN

            DECLARE @INVMV_actual_prefix    nvarchar(5);
            DECLARE @INVMV_actual_is_active bit;


            SELECT
                @INVMV_actual_prefix =
                    PFX_prefix,

                @INVMV_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'InventoryMovement';


            PRINT N'        [!] Prefix registration mismatch  : inventory.InventoryMovement';
            PRINT N'            Expected Prefix              : INVMV';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@INVMV_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INVMV_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';