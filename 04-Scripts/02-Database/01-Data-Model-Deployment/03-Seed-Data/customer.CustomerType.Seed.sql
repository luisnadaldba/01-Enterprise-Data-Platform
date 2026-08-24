    PRINT N'';
    PRINT N'    ● customer.CustomerType';
    PRINT N'';

    DECLARE @CSTCT_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        customer.CustomerType -> CSTCT
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'customer'
        AND PFX_table_name = N'CustomerType'
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
            N'CustomerType',
            N'CSTCT',
            1,
            @CSTCT_seed_timestamp,
            @CSTCT_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : customer.CustomerType -> CSTCT';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerType'
            AND PFX_prefix = N'CSTCT'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : customer.CustomerType -> CSTCT';

        END
        ELSE
        BEGIN

            DECLARE @CSTCT_actual_prefix    nvarchar(5);
            DECLARE @CSTCT_actual_is_active bit;


            SELECT
                @CSTCT_actual_prefix =
                    PFX_prefix,

                @CSTCT_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerType';


            PRINT N'        [!] Prefix registration mismatch  : customer.CustomerType';
            PRINT N'            Expected Prefix              : CSTCT';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@CSTCT_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTCT_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        CUSTOMER TYPE DATA
    ==============================================================================*/

    /*----------------------------------------------------------------------
        INDIVIDUAL
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM customer.CustomerType
        WHERE CSTCT_code = N'INDIVIDUAL'
    )
    BEGIN

        INSERT INTO customer.CustomerType
        (
            CSTCT_code,
            CSTCT_name,
            CSTCT_created_at,
            CSTCT_updated_at
        )
        VALUES
        (
            N'INDIVIDUAL',
            N'Pessoa Física',
            @CSTCT_seed_timestamp,
            @CSTCT_seed_timestamp
        );

        PRINT N'        [+] Customer type added            : INDIVIDUAL';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM customer.CustomerType
            WHERE CSTCT_code = N'INDIVIDUAL'
            AND CSTCT_name = N'Pessoa Física'
        )
        BEGIN

            PRINT N'        [•] Customer type validated        : INDIVIDUAL';

        END
        ELSE
        BEGIN

            DECLARE @CSTCT_individual_actual_name nvarchar(100);


            SELECT
                @CSTCT_individual_actual_name =
                    CSTCT_name

            FROM customer.CustomerType

            WHERE CSTCT_code = N'INDIVIDUAL';


            PRINT N'        [!] Customer type mismatch         : INDIVIDUAL';
            PRINT N'            Expected Name                : Pessoa Física';
            PRINT N'            Actual Name                  : '
                + COALESCE(@CSTCT_individual_actual_name, N'<NULL>');
            PRINT N'            Existing row was preserved for review.';

        END;

    END;


    /*----------------------------------------------------------------------
        COMPANY
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM customer.CustomerType
        WHERE CSTCT_code = N'COMPANY'
    )
    BEGIN

        INSERT INTO customer.CustomerType
        (
            CSTCT_code,
            CSTCT_name,
            CSTCT_created_at,
            CSTCT_updated_at
        )
        VALUES
        (
            N'COMPANY',
            N'Pessoa Jurídica',
            @CSTCT_seed_timestamp,
            @CSTCT_seed_timestamp
        );

        PRINT N'        [+] Customer type added            : COMPANY';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM customer.CustomerType
            WHERE CSTCT_code = N'COMPANY'
            AND CSTCT_name = N'Pessoa Jurídica'
        )
        BEGIN

            PRINT N'        [•] Customer type validated        : COMPANY';

        END
        ELSE
        BEGIN

            DECLARE @CSTCT_company_actual_name nvarchar(100);


            SELECT
                @CSTCT_company_actual_name =
                    CSTCT_name

            FROM customer.CustomerType

            WHERE CSTCT_code = N'COMPANY';


            PRINT N'        [!] Customer type mismatch         : COMPANY';
            PRINT N'            Expected Name                : Pessoa Jurídica';
            PRINT N'            Actual Name                  : '
                + COALESCE(@CSTCT_company_actual_name, N'<NULL>');
            PRINT N'            Existing row was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';