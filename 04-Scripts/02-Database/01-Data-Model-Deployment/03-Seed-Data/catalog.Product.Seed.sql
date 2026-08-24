    PRINT N'';
    PRINT N'    ● catalog.Product';
    PRINT N'';

    DECLARE @PRD_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        catalog.Product -> PRD
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'Product'
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
            N'Product',
            N'PRD',
            1,
            @PRD_seed_timestamp,
            @PRD_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : catalog.Product -> PRD';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'Product'
            AND PFX_prefix = N'PRD'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : catalog.Product -> PRD';

        END
        ELSE
        BEGIN

            DECLARE @PRD_actual_prefix     nvarchar(5);
            DECLARE @PRD_actual_is_active  bit;


            SELECT
                @PRD_actual_prefix =
                    PFX_prefix,

                @PRD_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'Product';


            PRINT N'        [!] Prefix registration mismatch  : catalog.Product';
            PRINT N'            Expected Prefix              : PRD';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PRD_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PRD_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';