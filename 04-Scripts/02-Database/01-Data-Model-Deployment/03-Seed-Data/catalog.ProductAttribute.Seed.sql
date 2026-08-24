    PRINT N'';
    PRINT N'    ● catalog.ProductAttribute';
    PRINT N'';

    DECLARE @PAT_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        catalog.ProductAttribute -> PAT
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'ProductAttribute'
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
            N'ProductAttribute',
            N'PAT',
            1,
            @PAT_seed_timestamp,
            @PAT_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : catalog.ProductAttribute -> PAT';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductAttribute'
            AND PFX_prefix = N'PAT'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : catalog.ProductAttribute -> PAT';

        END
        ELSE
        BEGIN

            DECLARE @PAT_actual_prefix     nvarchar(5);
            DECLARE @PAT_actual_is_active  bit;


            SELECT
                @PAT_actual_prefix =
                    PFX_prefix,

                @PAT_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductAttribute';


            PRINT N'        [!] Prefix registration mismatch  : catalog.ProductAttribute';
            PRINT N'            Expected Prefix              : PAT';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PAT_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAT_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';