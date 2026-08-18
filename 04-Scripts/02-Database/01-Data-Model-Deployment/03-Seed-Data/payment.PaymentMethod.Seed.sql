    PRINT N'    payment.PaymentMethod';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @PAYME_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        payment.PaymentMethod -> PAYME
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'payment'
        AND PFX_table_name = N'PaymentMethod'
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
            N'PaymentMethod',
            N'PAYME',
            1,
            @PAYME_seed_timestamp,
            @PAYME_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : payment.PaymentMethod -> PAYME';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'payment'
            AND PFX_table_name = N'PaymentMethod'
            AND PFX_prefix = N'PAYME'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : payment.PaymentMethod -> PAYME';

        END
        ELSE
        BEGIN

            DECLARE @PAYME_actual_prefix    nvarchar(5);
            DECLARE @PAYME_actual_is_active bit;


            SELECT
                @PAYME_actual_prefix =
                    PFX_prefix,

                @PAYME_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'payment'
            AND PFX_table_name = N'PaymentMethod';


            PRINT N'        [!] Prefix registration mismatch  : payment.PaymentMethod';
            PRINT N'            Expected Prefix              : PAYME';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PAYME_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAYME_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        PAYMENT METHOD DATA
    ==============================================================================*/

    /*----------------------------------------------------------------------
        PIX
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentMethod
        WHERE PAYME_name = N'PIX'
    )
    BEGIN

        INSERT INTO payment.PaymentMethod
        (
            PAYME_name,
            PAYME_created_at,
            PAYME_updated_at
        )
        VALUES
        (
            N'PIX',
            @PAYME_seed_timestamp,
            @PAYME_seed_timestamp
        );

        PRINT N'        [+] Payment method added           : PIX';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment method validated       : PIX';

    END;


    /*----------------------------------------------------------------------
        CREDIT_CARD
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentMethod
        WHERE PAYME_name = N'CREDIT_CARD'
    )
    BEGIN

        INSERT INTO payment.PaymentMethod
        (
            PAYME_name,
            PAYME_created_at,
            PAYME_updated_at
        )
        VALUES
        (
            N'CREDIT_CARD',
            @PAYME_seed_timestamp,
            @PAYME_seed_timestamp
        );

        PRINT N'        [+] Payment method added           : CREDIT_CARD';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment method validated       : CREDIT_CARD';

    END;


    /*----------------------------------------------------------------------
        DEBIT_CARD
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentMethod
        WHERE PAYME_name = N'DEBIT_CARD'
    )
    BEGIN

        INSERT INTO payment.PaymentMethod
        (
            PAYME_name,
            PAYME_created_at,
            PAYME_updated_at
        )
        VALUES
        (
            N'DEBIT_CARD',
            @PAYME_seed_timestamp,
            @PAYME_seed_timestamp
        );

        PRINT N'        [+] Payment method added           : DEBIT_CARD';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment method validated       : DEBIT_CARD';

    END;


    /*----------------------------------------------------------------------
        CASH
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentMethod
        WHERE PAYME_name = N'CASH'
    )
    BEGIN

        INSERT INTO payment.PaymentMethod
        (
            PAYME_name,
            PAYME_created_at,
            PAYME_updated_at
        )
        VALUES
        (
            N'CASH',
            @PAYME_seed_timestamp,
            @PAYME_seed_timestamp
        );

        PRINT N'        [+] Payment method added           : CASH';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment method validated       : CASH';

    END;


    PRINT N'';