    PRINT N'';
    PRINT N'    ● catalog.ProductVariantPrice';
    PRINT N'';

    DECLARE @PRDVP_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        catalog.ProductVariantPrice -> PRDVP
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'ProductVariantPrice'
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
            N'ProductVariantPrice',
            N'PRDVP',
            1,
            @PRDVP_seed_timestamp,
            @PRDVP_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : catalog.ProductVariantPrice -> PRDVP';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductVariantPrice'
            AND PFX_prefix = N'PRDVP'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : catalog.ProductVariantPrice -> PRDVP';

        END
        ELSE
        BEGIN

            DECLARE @PRDVP_actual_prefix    nvarchar(5);
            DECLARE @PRDVP_actual_is_active bit;


            SELECT
                @PRDVP_actual_prefix =
                    PFX_prefix,

                @PRDVP_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductVariantPrice';


            PRINT N'        [!] Prefix registration mismatch  : catalog.ProductVariantPrice';
            PRINT N'            Expected Prefix              : PRDVP';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PRDVP_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PRDVP_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';