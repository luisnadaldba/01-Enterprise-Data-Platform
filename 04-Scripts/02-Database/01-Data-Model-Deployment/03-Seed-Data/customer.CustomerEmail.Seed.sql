    PRINT N'    customer.CustomerEmail';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @CSTEM_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        customer.CustomerEmail -> CSTEM
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'customer'
        AND PFX_table_name = N'CustomerEmail'
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
            N'CustomerEmail',
            N'CSTEM',
            1,
            @CSTEM_seed_timestamp,
            @CSTEM_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : customer.CustomerEmail -> CSTEM';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerEmail'
            AND PFX_prefix = N'CSTEM'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : customer.CustomerEmail -> CSTEM';

        END
        ELSE
        BEGIN

            DECLARE @CSTEM_actual_prefix    nvarchar(5);
            DECLARE @CSTEM_actual_is_active bit;


            SELECT
                @CSTEM_actual_prefix =
                    PFX_prefix,

                @CSTEM_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerEmail';


            PRINT N'        [!] Prefix registration mismatch  : customer.CustomerEmail';
            PRINT N'            Expected Prefix              : CSTEM';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@CSTEM_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTEM_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';