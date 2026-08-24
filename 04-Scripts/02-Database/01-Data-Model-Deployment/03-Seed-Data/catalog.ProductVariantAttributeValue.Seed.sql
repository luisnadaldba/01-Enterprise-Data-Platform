    PRINT N'';
    PRINT N'    ● catalog.ProductVariantAttributeValue';
    PRINT N'';

    DECLARE @PRDAV_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        catalog.ProductVariantAttributeValue -> PRDAV
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'ProductVariantAttributeValue'
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
            N'ProductVariantAttributeValue',
            N'PRDAV',
            1,
            @PRDAV_seed_timestamp,
            @PRDAV_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : catalog.ProductVariantAttributeValue -> PRDAV';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductVariantAttributeValue'
            AND PFX_prefix = N'PRDAV'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : catalog.ProductVariantAttributeValue -> PRDAV';

        END
        ELSE
        BEGIN

            DECLARE @PRDAV_actual_prefix    nvarchar(5);
            DECLARE @PRDAV_actual_is_active bit;


            SELECT
                @PRDAV_actual_prefix =
                    PFX_prefix,

                @PRDAV_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductVariantAttributeValue';


            PRINT N'        [!] Prefix registration mismatch  : catalog.ProductVariantAttributeValue';
            PRINT N'            Expected Prefix              : PRDAV';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PRDAV_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PRDAV_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';