    PRINT N'    catalog.ProductCategory';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @PRDCT_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        catalog.ProductCategory -> PRDCT
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'ProductCategory'
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
            N'ProductCategory',
            N'PRDCT',
            1,
            @PRDCT_seed_timestamp,
            @PRDCT_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : catalog.ProductCategory -> PRDCT';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductCategory'
            AND PFX_prefix = N'PRDCT'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : catalog.ProductCategory -> PRDCT';

        END
        ELSE
        BEGIN

            DECLARE @PRDCT_actual_prefix    nvarchar(5);
            DECLARE @PRDCT_actual_is_active bit;


            SELECT
                @PRDCT_actual_prefix =
                    PFX_prefix,

                @PRDCT_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductCategory';


            PRINT N'        [!] Prefix registration mismatch  : catalog.ProductCategory';
            PRINT N'            Expected Prefix              : PRDCT';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PRDCT_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PRDCT_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';