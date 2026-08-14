    PRINT N'    reference.Address';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @ADR_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        reference.Address -> ADR
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'reference'
        AND PFX_table_name = N'Address'
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
            N'Address',
            N'ADR',
            1,
            @ADR_seed_timestamp,
            @ADR_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : reference.Address -> ADR';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'Address'
            AND PFX_prefix = N'ADR'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : reference.Address -> ADR';

        END
        ELSE
        BEGIN

            DECLARE @ADR_actual_prefix    nvarchar(5);
            DECLARE @ADR_actual_is_active bit;


            SELECT
                @ADR_actual_prefix =
                    PFX_prefix,

                @ADR_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'Address';


            PRINT N'        [!] Prefix registration mismatch  : reference.Address';
            PRINT N'            Expected Prefix              : ADR';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@ADR_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @ADR_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';