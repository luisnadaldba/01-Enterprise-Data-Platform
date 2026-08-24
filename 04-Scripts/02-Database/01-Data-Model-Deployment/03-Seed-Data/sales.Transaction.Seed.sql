    PRINT N'';
    PRINT N'    ● sales.Transaction';
    PRINT N'';

    DECLARE @TRN_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        sales.Transaction -> TRN
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'sales'
        AND PFX_table_name = N'Transaction'
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
            N'sales',
            N'Transaction',
            N'TRN',
            1,
            @TRN_seed_timestamp,
            @TRN_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : sales.Transaction -> TRN';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'sales'
            AND PFX_table_name = N'Transaction'
            AND PFX_prefix = N'TRN'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : sales.Transaction -> TRN';

        END
        ELSE
        BEGIN

            DECLARE @TRN_actual_prefix    nvarchar(5);
            DECLARE @TRN_actual_is_active bit;


            SELECT
                @TRN_actual_prefix =
                    PFX_prefix,

                @TRN_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'sales'
            AND PFX_table_name = N'Transaction';


            PRINT N'        [!] Prefix registration mismatch  : sales.Transaction';
            PRINT N'            Expected Prefix              : TRN';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@TRN_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @TRN_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';