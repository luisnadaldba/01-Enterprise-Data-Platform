    PRINT N'';
    PRINT N'    ● reference.ContactType';
    PRINT N'';

    DECLARE @CTP_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        reference.ContactType -> CTP
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'reference'
        AND PFX_table_name = N'ContactType'
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
            N'reference',
            N'ContactType',
            N'CTP',
            1,
            @CTP_seed_timestamp,
            @CTP_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : reference.ContactType -> CTP';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'ContactType'
            AND PFX_prefix = N'CTP'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : reference.ContactType -> CTP';

        END
        ELSE
        BEGIN

            DECLARE @CTP_actual_prefix    nvarchar(5);
            DECLARE @CTP_actual_is_active bit;


            SELECT
                @CTP_actual_prefix =
                    PFX_prefix,

                @CTP_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'ContactType';


            PRINT N'        [!] Prefix registration mismatch  : reference.ContactType';
            PRINT N'            Expected Prefix              : CTP';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@CTP_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CTP_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        CONTACT TYPES
    ==============================================================================*/

    /*----------------------------------------------------------------------
        PHONE
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM reference.ContactType
        WHERE CTP_name = N'PHONE'
    )
    BEGIN

        INSERT INTO reference.ContactType
        (
            CTP_name,
            CTP_created_at,
            CTP_updated_at
        )
        VALUES
        (
            N'PHONE',
            @CTP_seed_timestamp,
            @CTP_seed_timestamp
        );

        PRINT N'        [+] Contact type added             : PHONE';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Contact type validated         : PHONE';

    END;


    /*----------------------------------------------------------------------
        MOBILE
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM reference.ContactType
        WHERE CTP_name = N'MOBILE'
    )
    BEGIN

        INSERT INTO reference.ContactType
        (
            CTP_name,
            CTP_created_at,
            CTP_updated_at
        )
        VALUES
        (
            N'MOBILE',
            @CTP_seed_timestamp,
            @CTP_seed_timestamp
        );

        PRINT N'        [+] Contact type added             : MOBILE';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Contact type validated         : MOBILE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';