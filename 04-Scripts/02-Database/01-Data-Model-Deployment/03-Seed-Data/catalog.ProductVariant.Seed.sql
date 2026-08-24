    PRINT N'';
    PRINT N'    ● catalog.ProductVariant';
    PRINT N'';

    DECLARE @PRDVA_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        catalog.ProductVariant -> PRDVA
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'ProductVariant'
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
            N'catalog',
            N'ProductVariant',
            N'PRDVA',
            1,
            @PRDVA_seed_timestamp,
            @PRDVA_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : catalog.ProductVariant -> PRDVA';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductVariant'
            AND PFX_prefix = N'PRDVA'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : catalog.ProductVariant -> PRDVA';

        END
        ELSE
        BEGIN

            DECLARE @PRDVA_actual_prefix    nvarchar(5);
            DECLARE @PRDVA_actual_is_active bit;


            SELECT
                @PRDVA_actual_prefix =
                    PFX_prefix,

                @PRDVA_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductVariant';


            PRINT N'        [!] Prefix registration mismatch  : catalog.ProductVariant';
            PRINT N'            Expected Prefix              : PRDVA';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PRDVA_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PRDVA_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';