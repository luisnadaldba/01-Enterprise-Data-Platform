    PRINT N'    catalog.Category';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @CTG_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        catalog.Category -> CTG
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'Category'
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
            N'Category',
            N'CTG',
            1,
            @CTG_seed_timestamp,
            @CTG_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : catalog.Category -> CTG';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'Category'
            AND PFX_prefix = N'CTG'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : catalog.Category -> CTG';

        END
        ELSE
        BEGIN

            DECLARE @CTG_actual_prefix    nvarchar(5);
            DECLARE @CTG_actual_is_active bit;


            SELECT
                @CTG_actual_prefix =
                    PFX_prefix,

                @CTG_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'Category';


            PRINT N'        [!] Prefix registration mismatch  : catalog.Category';
            PRINT N'            Expected Prefix              : CTG';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@CTG_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CTG_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';