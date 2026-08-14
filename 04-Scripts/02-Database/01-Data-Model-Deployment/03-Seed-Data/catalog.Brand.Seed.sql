    PRINT N'    catalog.Brand';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @BRD_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        catalog.Brand -> BRD
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'Brand'
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
            N'Brand',
            N'BRD',
            1,
            @BRD_seed_timestamp,
            @BRD_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : catalog.Brand -> BRD';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'Brand'
            AND PFX_prefix = N'BRD'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : catalog.Brand -> BRD';

        END
        ELSE
        BEGIN

            DECLARE @BRD_actual_prefix    nvarchar(5);
            DECLARE @BRD_actual_is_active bit;


            SELECT
                @BRD_actual_prefix =
                    PFX_prefix,

                @BRD_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'Brand';


            PRINT N'        [!] Prefix registration mismatch  : catalog.Brand';
            PRINT N'            Expected Prefix              : BRD';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@BRD_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @BRD_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';