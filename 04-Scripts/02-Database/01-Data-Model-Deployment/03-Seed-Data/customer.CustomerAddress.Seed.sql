    PRINT N'';
    PRINT N'    ● customer.CustomerAddress';
    PRINT N'';

    DECLARE @CSTAD_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        customer.CustomerAddress -> CSTAD
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'customer'
        AND PFX_table_name = N'CustomerAddress'
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
            N'CustomerAddress',
            N'CSTAD',
            1,
            @CSTAD_seed_timestamp,
            @CSTAD_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : customer.CustomerAddress -> CSTAD';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerAddress'
            AND PFX_prefix = N'CSTAD'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : customer.CustomerAddress -> CSTAD';

        END
        ELSE
        BEGIN

            DECLARE @CSTAD_actual_prefix    nvarchar(5);
            DECLARE @CSTAD_actual_is_active bit;


            SELECT
                @CSTAD_actual_prefix =
                    PFX_prefix,

                @CSTAD_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerAddress';


            PRINT N'        [!] Prefix registration mismatch  : customer.CustomerAddress';
            PRINT N'            Expected Prefix              : CSTAD';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@CSTAD_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTAD_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';