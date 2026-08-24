    PRINT N'';
    PRINT N'    ● payment.PaymentRefund';
    PRINT N'';

    DECLARE @PAYRF_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        payment.PaymentRefund -> PAYRF
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'payment'
        AND PFX_table_name = N'PaymentRefund'
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
            N'payment',
            N'PaymentRefund',
            N'PAYRF',
            1,
            @PAYRF_seed_timestamp,
            @PAYRF_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : payment.PaymentRefund -> PAYRF';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'payment'
            AND PFX_table_name = N'PaymentRefund'
            AND PFX_prefix = N'PAYRF'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : payment.PaymentRefund -> PAYRF';

        END
        ELSE
        BEGIN

            DECLARE @PAYRF_actual_prefix    nvarchar(5);
            DECLARE @PAYRF_actual_is_active bit;


            SELECT
                @PAYRF_actual_prefix =
                    PFX_prefix,

                @PAYRF_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'payment'
            AND PFX_table_name = N'PaymentRefund';


            PRINT N'        [!] Prefix registration mismatch  : payment.PaymentRefund';
            PRINT N'            Expected Prefix              : PAYRF';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PAYRF_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAYRF_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';