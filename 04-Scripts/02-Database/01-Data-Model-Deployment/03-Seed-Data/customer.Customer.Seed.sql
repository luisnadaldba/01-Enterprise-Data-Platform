    PRINT N'';
    PRINT N'    ● customer.Customer';
    PRINT N'';

    DECLARE @CST_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        customer.Customer -> CST
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'customer'
        AND PFX_table_name = N'Customer'
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
            N'Customer',
            N'CST',
            1,
            @CST_seed_timestamp,
            @CST_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : customer.Customer -> CST';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'Customer'
            AND PFX_prefix = N'CST'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : customer.Customer -> CST';

        END
        ELSE
        BEGIN

            DECLARE @CST_actual_prefix    nvarchar(5);
            DECLARE @CST_actual_is_active bit;


            SELECT
                @CST_actual_prefix =
                    PFX_prefix,

                @CST_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'Customer';


            PRINT N'        [!] Prefix registration mismatch  : customer.Customer';
            PRINT N'            Expected Prefix              : CST';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@CST_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';