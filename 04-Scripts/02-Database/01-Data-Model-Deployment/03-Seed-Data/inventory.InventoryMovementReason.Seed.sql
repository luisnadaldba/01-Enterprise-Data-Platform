    PRINT N'';
    PRINT N'    ● inventory.InventoryMovementReason';
    PRINT N'';

    DECLARE @INVMR_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        inventory.InventoryMovementReason -> INVMR
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'inventory'
        AND PFX_table_name = N'InventoryMovementReason'
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
            N'InventoryMovementReason',
            N'INVMR',
            1,
            @INVMR_seed_timestamp,
            @INVMR_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : inventory.InventoryMovementReason -> INVMR';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'InventoryMovementReason'
            AND PFX_prefix = N'INVMR'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : inventory.InventoryMovementReason -> INVMR';

        END
        ELSE
        BEGIN

            DECLARE @INVMR_actual_prefix    nvarchar(5);
            DECLARE @INVMR_actual_is_active bit;


            SELECT
                @INVMR_actual_prefix =
                    PFX_prefix,

                @INVMR_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'inventory'
            AND PFX_table_name = N'InventoryMovementReason';


            PRINT N'        [!] Prefix registration mismatch  : inventory.InventoryMovementReason';
            PRINT N'            Expected Prefix              : INVMR';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@INVMR_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INVMR_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        INVENTORY MOVEMENT REASON SEED
    ==============================================================================*/

    DECLARE @INVMR_expected_reasons TABLE
    (
        INVMR_seed_id    tinyint IDENTITY(1,1) NOT NULL,
        INVMR_seed_name  nvarchar(100) NOT NULL
    );


    INSERT INTO @INVMR_expected_reasons
    (
        INVMR_seed_name
    )
    VALUES
        (N'PURCHASE_RECEIPT'),
        (N'SALE'),
        (N'CUSTOMER_RETURN'),
        (N'DAMAGED_IN_TRANSIT'),
        (N'DAMAGED_INTERNAL'),
        (N'LOSS_IN_TRANSIT'),
        (N'LOSS_INTERNAL'),
        (N'FOUND_INTERNAL'),
        (N'INVENTORY_ADJUSTMENT_IN'),
        (N'INVENTORY_ADJUSTMENT_OUT');


    DECLARE @INVMR_seed_current_id tinyint;
    DECLARE @INVMR_seed_max_id     tinyint;
    DECLARE @INVMR_seed_name       nvarchar(100);


    SELECT
        @INVMR_seed_current_id = MIN(INVMR_seed_id),
        @INVMR_seed_max_id     = MAX(INVMR_seed_id)
    FROM @INVMR_expected_reasons;


    WHILE @INVMR_seed_current_id <= @INVMR_seed_max_id
    BEGIN

        SET @INVMR_seed_name = NULL;


        SELECT
            @INVMR_seed_name =
                INVMR_seed_name

        FROM @INVMR_expected_reasons

        WHERE INVMR_seed_id =
                @INVMR_seed_current_id;


        IF NOT EXISTS
        (
            SELECT 1

            FROM inventory.InventoryMovementReason

            WHERE INVMR_name =
                    @INVMR_seed_name
        )
        BEGIN

            INSERT INTO inventory.InventoryMovementReason
            (
                INVMR_name,
                INVMR_created_at,
                INVMR_updated_at
            )
            VALUES
            (
                @INVMR_seed_name,
                @INVMR_seed_timestamp,
                @INVMR_seed_timestamp
            );


            PRINT N'        [+] Seed row added                 : '
                + @INVMR_seed_name;

        END
        ELSE
        BEGIN

            PRINT N'        [•] Seed row validated             : '
                + @INVMR_seed_name;

        END;


        SET @INVMR_seed_current_id =
            @INVMR_seed_current_id + 1;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';