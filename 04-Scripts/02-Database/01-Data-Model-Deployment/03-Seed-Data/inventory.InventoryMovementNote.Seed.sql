    PRINT N'';
    PRINT N'    ● inventory.InventoryMovementNote';
    PRINT N'';

    DECLARE @INVMN_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        inventory.InventoryMovementNote -> INVMN
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'inventory'
        AND PFX_table_name = N'InventoryMovementNote'
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
            N'InventoryMovementNote',
            N'INVMN',
            1,
            @INVMN_seed_timestamp,
            @INVMN_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : inventory.InventoryMovementNote -> INVMN';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'InventoryMovementNote'
            AND PFX_prefix = N'INVMN'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : inventory.InventoryMovementNote -> INVMN';

        END
        ELSE
        BEGIN

            DECLARE @INVMN_actual_prefix    nvarchar(5);
            DECLARE @INVMN_actual_is_active bit;


            SELECT
                @INVMN_actual_prefix =
                    PFX_prefix,

                @INVMN_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'InventoryMovementNote';


            PRINT N'        [!] Prefix registration mismatch  : inventory.InventoryMovementNote';
            PRINT N'            Expected Prefix              : INVMN';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@INVMN_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INVMN_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';