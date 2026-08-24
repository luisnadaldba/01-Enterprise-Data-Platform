    PRINT N'';
    PRINT N'    ● payment.PaymentRefundReason';
    PRINT N'';

    DECLARE @PAYRR_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        payment.PaymentRefundReason -> PAYRR
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'payment'
        AND PFX_table_name = N'PaymentRefundReason'
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
            N'PaymentRefundReason',
            N'PAYRR',
            1,
            @PAYRR_seed_timestamp,
            @PAYRR_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : payment.PaymentRefundReason -> PAYRR';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'payment'
            AND PFX_table_name = N'PaymentRefundReason'
            AND PFX_prefix = N'PAYRR'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : payment.PaymentRefundReason -> PAYRR';

        END
        ELSE
        BEGIN

            DECLARE @PAYRR_actual_prefix    nvarchar(5);
            DECLARE @PAYRR_actual_is_active bit;


            SELECT
                @PAYRR_actual_prefix =
                    PFX_prefix,

                @PAYRR_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'payment'
            AND PFX_table_name = N'PaymentRefundReason';


            PRINT N'        [!] Prefix registration mismatch  : payment.PaymentRefundReason';
            PRINT N'            Expected Prefix              : PAYRR';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PAYRR_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAYRR_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        PAYMENT REFUND REASON DATA
    ==============================================================================*/

    /*----------------------------------------------------------------------
        CUSTOMER_RETURN
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentRefundReason
        WHERE PAYRR_name = N'CUSTOMER_RETURN'
    )
    BEGIN

        INSERT INTO payment.PaymentRefundReason
        (
            PAYRR_name,
            PAYRR_created_at,
            PAYRR_updated_at
        )
        VALUES
        (
            N'CUSTOMER_RETURN',
            @PAYRR_seed_timestamp,
            @PAYRR_seed_timestamp
        );

        PRINT N'        [+] Payment refund reason added : CUSTOMER_RETURN';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment refund reason validated : CUSTOMER_RETURN';

    END;


    /*----------------------------------------------------------------------
        DUPLICATE_CHARGE
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentRefundReason
        WHERE PAYRR_name = N'DUPLICATE_CHARGE'
    )
    BEGIN

        INSERT INTO payment.PaymentRefundReason
        (
            PAYRR_name,
            PAYRR_created_at,
            PAYRR_updated_at
        )
        VALUES
        (
            N'DUPLICATE_CHARGE',
            @PAYRR_seed_timestamp,
            @PAYRR_seed_timestamp
        );

        PRINT N'        [+] Payment refund reason added : DUPLICATE_CHARGE';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment refund reason validated : DUPLICATE_CHARGE';

    END;


    /*----------------------------------------------------------------------
        FRAUD
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentRefundReason
        WHERE PAYRR_name = N'FRAUD'
    )
    BEGIN

        INSERT INTO payment.PaymentRefundReason
        (
            PAYRR_name,
            PAYRR_created_at,
            PAYRR_updated_at
        )
        VALUES
        (
            N'FRAUD',
            @PAYRR_seed_timestamp,
            @PAYRR_seed_timestamp
        );

        PRINT N'        [+] Payment refund reason added : FRAUD';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment refund reason validated : FRAUD';

    END;


    /*----------------------------------------------------------------------
        OPERATIONAL_ERROR
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentRefundReason
        WHERE PAYRR_name = N'OPERATIONAL_ERROR'
    )
    BEGIN

        INSERT INTO payment.PaymentRefundReason
        (
            PAYRR_name,
            PAYRR_created_at,
            PAYRR_updated_at
        )
        VALUES
        (
            N'OPERATIONAL_ERROR',
            @PAYRR_seed_timestamp,
            @PAYRR_seed_timestamp
        );

        PRINT N'        [+] Payment refund reason added : OPERATIONAL_ERROR';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment refund reason validated : OPERATIONAL_ERROR';

    END;


    /*----------------------------------------------------------------------
        ORDER_CANCELLATION
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentRefundReason
        WHERE PAYRR_name = N'ORDER_CANCELLATION'
    )
    BEGIN

        INSERT INTO payment.PaymentRefundReason
        (
            PAYRR_name,
            PAYRR_created_at,
            PAYRR_updated_at
        )
        VALUES
        (
            N'ORDER_CANCELLATION',
            @PAYRR_seed_timestamp,
            @PAYRR_seed_timestamp
        );

        PRINT N'        [+] Payment refund reason added : ORDER_CANCELLATION';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment refund reason validated : ORDER_CANCELLATION';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';