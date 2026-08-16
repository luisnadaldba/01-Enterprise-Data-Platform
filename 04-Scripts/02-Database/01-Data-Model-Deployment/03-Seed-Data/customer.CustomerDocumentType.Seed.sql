    PRINT N'    customer.CustomerDocumentType';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @DTP_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        customer.CustomerDocumentType -> DTP
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'customer'
        AND PFX_table_name = N'CustomerDocumentType'
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
            N'CustomerDocumentType',
            N'DTP',
            1,
            @DTP_seed_timestamp,
            @DTP_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : customer.CustomerDocumentType -> DTP';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerDocumentType'
            AND PFX_prefix = N'DTP'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : customer.CustomerDocumentType -> DTP';

        END
        ELSE
        BEGIN

            DECLARE @DTP_actual_prefix    nvarchar(5);
            DECLARE @DTP_actual_is_active bit;


            SELECT
                @DTP_actual_prefix =
                    PFX_prefix,

                @DTP_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'customer'
            AND PFX_table_name = N'CustomerDocumentType';


            PRINT N'        [!] Prefix registration mismatch  : customer.CustomerDocumentType';
            PRINT N'            Expected Prefix              : DTP';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@DTP_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @DTP_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        CUSTOMER DOCUMENT TYPES
    ==============================================================================*/

    /*----------------------------------------------------------------------
        CPF
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM customer.CustomerDocumentType
        WHERE DTP_name = N'CPF'
    )
    BEGIN

        INSERT INTO customer.CustomerDocumentType
        (
            DTP_name,
            DTP_created_at,
            DTP_updated_at
        )
        VALUES
        (
            N'CPF',
            @DTP_seed_timestamp,
            @DTP_seed_timestamp
        );

        PRINT N'        [+] Customer document type added   : CPF';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Customer document type validated : CPF';

    END;


    /*----------------------------------------------------------------------
        CNPJ
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM customer.CustomerDocumentType
        WHERE DTP_name = N'CNPJ'
    )
    BEGIN

        INSERT INTO customer.CustomerDocumentType
        (
            DTP_name,
            DTP_created_at,
            DTP_updated_at
        )
        VALUES
        (
            N'CNPJ',
            @DTP_seed_timestamp,
            @DTP_seed_timestamp
        );

        PRINT N'        [+] Customer document type added   : CNPJ';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Customer document type validated : CNPJ';

    END;


    /*----------------------------------------------------------------------
        RG
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM customer.CustomerDocumentType
        WHERE DTP_name = N'RG'
    )
    BEGIN

        INSERT INTO customer.CustomerDocumentType
        (
            DTP_name,
            DTP_created_at,
            DTP_updated_at
        )
        VALUES
        (
            N'RG',
            @DTP_seed_timestamp,
            @DTP_seed_timestamp
        );

        PRINT N'        [+] Customer document type added   : RG';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Customer document type validated : RG';

    END;


    /*----------------------------------------------------------------------
        CNH
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM customer.CustomerDocumentType
        WHERE DTP_name = N'CNH'
    )
    BEGIN

        INSERT INTO customer.CustomerDocumentType
        (
            DTP_name,
            DTP_created_at,
            DTP_updated_at
        )
        VALUES
        (
            N'CNH',
            @DTP_seed_timestamp,
            @DTP_seed_timestamp
        );

        PRINT N'        [+] Customer document type added   : CNH';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Customer document type validated : CNH';

    END;


    /*----------------------------------------------------------------------
        PASSPORT
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM customer.CustomerDocumentType
        WHERE DTP_name = N'PASSPORT'
    )
    BEGIN

        INSERT INTO customer.CustomerDocumentType
        (
            DTP_name,
            DTP_created_at,
            DTP_updated_at
        )
        VALUES
        (
            N'PASSPORT',
            @DTP_seed_timestamp,
            @DTP_seed_timestamp
        );

        PRINT N'        [+] Customer document type added   : PASSPORT';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Customer document type validated : PASSPORT';

    END;


    PRINT N'';