    PRINT N'    payment.PaymentStatus';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @PAYST_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        payment.PaymentStatus -> PAYST
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'payment'
        AND PFX_table_name = N'PaymentStatus'
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
            N'PaymentStatus',
            N'PAYST',
            1,
            @PAYST_seed_timestamp,
            @PAYST_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : payment.PaymentStatus -> PAYST';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'payment'
            AND PFX_table_name = N'PaymentStatus'
            AND PFX_prefix = N'PAYST'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : payment.PaymentStatus -> PAYST';

        END
        ELSE
        BEGIN

            DECLARE @PAYST_actual_prefix    nvarchar(5);
            DECLARE @PAYST_actual_is_active bit;


            SELECT
                @PAYST_actual_prefix =
                    PFX_prefix,

                @PAYST_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'payment'
            AND PFX_table_name = N'PaymentStatus';


            PRINT N'        [!] Prefix registration mismatch  : payment.PaymentStatus';
            PRINT N'            Expected Prefix              : PAYST';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PAYST_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAYST_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        PAYMENT STATUS DATA
    ==============================================================================*/

    /*----------------------------------------------------------------------
        PENDING
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentStatus
        WHERE PAYST_name = N'PENDING'
    )
    BEGIN

        INSERT INTO payment.PaymentStatus
        (
            PAYST_name,
            PAYST_created_at,
            PAYST_updated_at
        )
        VALUES
        (
            N'PENDING',
            @PAYST_seed_timestamp,
            @PAYST_seed_timestamp
        );

        PRINT N'        [+] Payment status added           : PENDING';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment status validated       : PENDING';

    END;


    /*----------------------------------------------------------------------
        APPROVED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentStatus
        WHERE PAYST_name = N'APPROVED'
    )
    BEGIN

        INSERT INTO payment.PaymentStatus
        (
            PAYST_name,
            PAYST_created_at,
            PAYST_updated_at
        )
        VALUES
        (
            N'APPROVED',
            @PAYST_seed_timestamp,
            @PAYST_seed_timestamp
        );

        PRINT N'        [+] Payment status added           : APPROVED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment status validated       : APPROVED';

    END;


    /*----------------------------------------------------------------------
        DECLINED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentStatus
        WHERE PAYST_name = N'DECLINED'
    )
    BEGIN

        INSERT INTO payment.PaymentStatus
        (
            PAYST_name,
            PAYST_created_at,
            PAYST_updated_at
        )
        VALUES
        (
            N'DECLINED',
            @PAYST_seed_timestamp,
            @PAYST_seed_timestamp
        );

        PRINT N'        [+] Payment status added           : DECLINED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment status validated       : DECLINED';

    END;


    /*----------------------------------------------------------------------
        CANCELLED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentStatus
        WHERE PAYST_name = N'CANCELLED'
    )
    BEGIN

        INSERT INTO payment.PaymentStatus
        (
            PAYST_name,
            PAYST_created_at,
            PAYST_updated_at
        )
        VALUES
        (
            N'CANCELLED',
            @PAYST_seed_timestamp,
            @PAYST_seed_timestamp
        );

        PRINT N'        [+] Payment status added           : CANCELLED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment status validated       : CANCELLED';

    END;


    /*----------------------------------------------------------------------
        PARTIALLY_REFUNDED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentStatus
        WHERE PAYST_name = N'PARTIALLY_REFUNDED'
    )
    BEGIN

        INSERT INTO payment.PaymentStatus
        (
            PAYST_name,
            PAYST_created_at,
            PAYST_updated_at
        )
        VALUES
        (
            N'PARTIALLY_REFUNDED',
            @PAYST_seed_timestamp,
            @PAYST_seed_timestamp
        );

        PRINT N'        [+] Payment status added           : PARTIALLY_REFUNDED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment status validated       : PARTIALLY_REFUNDED';

    END;


    /*----------------------------------------------------------------------
        REFUNDED
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM payment.PaymentStatus
        WHERE PAYST_name = N'REFUNDED'
    )
    BEGIN

        INSERT INTO payment.PaymentStatus
        (
            PAYST_name,
            PAYST_created_at,
            PAYST_updated_at
        )
        VALUES
        (
            N'REFUNDED',
            @PAYST_seed_timestamp,
            @PAYST_seed_timestamp
        );

        PRINT N'        [+] Payment status added           : REFUNDED';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Payment status validated       : REFUNDED';

    END;


    PRINT N'';