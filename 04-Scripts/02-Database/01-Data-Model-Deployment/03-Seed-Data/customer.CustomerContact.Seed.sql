    PRINT N'';
    PRINT N'    ● customer.CustomerContact';
    PRINT N'';

    DECLARE @CSTCN_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        customer.CustomerContact -> CSTCN
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'customer'
        AND PFX_table_name = N'CustomerContact'
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
            N'CustomerContact',
            N'CSTCN',
            1,
            @CSTCN_seed_timestamp,
            @CSTCN_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : customer.CustomerContact -> CSTCN';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerContact'
            AND PFX_prefix = N'CSTCN'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : customer.CustomerContact -> CSTCN';

        END
        ELSE
        BEGIN

            DECLARE @CSTCN_actual_prefix    nvarchar(5);
            DECLARE @CSTCN_actual_is_active bit;


            SELECT
                @CSTCN_actual_prefix =
                    PFX_prefix,

                @CSTCN_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerContact';


            PRINT N'        [!] Prefix registration mismatch  : customer.CustomerContact';
            PRINT N'            Expected Prefix              : CSTCN';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@CSTCN_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTCN_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';