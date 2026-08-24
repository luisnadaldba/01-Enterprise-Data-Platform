    PRINT N'';
    PRINT N'    ● payment.Payment';
    PRINT N'';

    DECLARE @PAY_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        payment.Payment -> PAY
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'payment'
        AND PFX_table_name = N'Payment'
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
            N'Payment',
            N'PAY',
            1,
            @PAY_seed_timestamp,
            @PAY_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : payment.Payment -> PAY';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'payment'
            AND PFX_table_name = N'Payment'
            AND PFX_prefix = N'PAY'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : payment.Payment -> PAY';

        END
        ELSE
        BEGIN

            DECLARE @PAY_actual_prefix    nvarchar(5);
            DECLARE @PAY_actual_is_active bit;


            SELECT
                @PAY_actual_prefix =
                    PFX_prefix,

                @PAY_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'payment'
            AND PFX_table_name = N'Payment';


            PRINT N'        [!] Prefix registration mismatch  : payment.Payment';
            PRINT N'            Expected Prefix              : PAY';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PAY_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAY_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';