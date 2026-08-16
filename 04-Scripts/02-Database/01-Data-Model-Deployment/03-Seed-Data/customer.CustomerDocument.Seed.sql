    PRINT N'    customer.CustomerDocument';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @CSTCD_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        customer.CustomerDocument -> CSTCD
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'customer'
        AND PFX_table_name = N'CustomerDocument'
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
            N'customer',
            N'CustomerDocument',
            N'CSTCD',
            1,
            @CSTCD_seed_timestamp,
            @CSTCD_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : customer.CustomerDocument -> CSTCD';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerDocument'
            AND PFX_prefix = N'CSTCD'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : customer.CustomerDocument -> CSTCD';

        END
        ELSE
        BEGIN

            DECLARE @CSTCD_actual_prefix    nvarchar(5);
            DECLARE @CSTCD_actual_is_active bit;


            SELECT
                @CSTCD_actual_prefix =
                    PFX_prefix,

                @CSTCD_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerDocument';


            PRINT N'        [!] Prefix registration mismatch  : customer.CustomerDocument';
            PRINT N'            Expected Prefix              : CSTCD';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@CSTCD_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTCD_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';