    PRINT N'';
    PRINT N'    ● catalog.ProductImage';
    PRINT N'';

    DECLARE @PRDIM_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        catalog.ProductImage -> PRDIM
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'ProductImage'
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
            N'ProductImage',
            N'PRDIM',
            1,
            @PRDIM_seed_timestamp,
            @PRDIM_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : catalog.ProductImage -> PRDIM';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductImage'
            AND PFX_prefix = N'PRDIM'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : catalog.ProductImage -> PRDIM';

        END
        ELSE
        BEGIN

            DECLARE @PRDIM_actual_prefix    nvarchar(5);
            DECLARE @PRDIM_actual_is_active bit;


            SELECT
                @PRDIM_actual_prefix =
                    PFX_prefix,

                @PRDIM_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductImage';


            PRINT N'        [!] Prefix registration mismatch  : catalog.ProductImage';
            PRINT N'            Expected Prefix              : PRDIM';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PRDIM_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PRDIM_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';