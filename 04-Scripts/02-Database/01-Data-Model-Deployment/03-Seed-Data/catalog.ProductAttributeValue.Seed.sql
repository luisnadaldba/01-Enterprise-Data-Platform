    PRINT N'';
    PRINT N'    ● catalog.ProductAttributeValue';
    PRINT N'';

    DECLARE @PATVL_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        catalog.ProductAttributeValue -> PATVL
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'ProductAttributeValue'
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
            N'ProductAttributeValue',
            N'PATVL',
            1,
            @PATVL_seed_timestamp,
            @PATVL_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : catalog.ProductAttributeValue -> PATVL';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductAttributeValue'
            AND PFX_prefix = N'PATVL'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : catalog.ProductAttributeValue -> PATVL';

        END
        ELSE
        BEGIN

            DECLARE @PATVL_actual_prefix     nvarchar(5);
            DECLARE @PATVL_actual_is_active  bit;


            SELECT
                @PATVL_actual_prefix =
                    PFX_prefix,

                @PATVL_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'catalog'
            AND PFX_table_name = N'ProductAttributeValue';


            PRINT N'        [!] Prefix registration mismatch  : catalog.ProductAttributeValue';
            PRINT N'            Expected Prefix              : PATVL';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PATVL_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PATVL_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';