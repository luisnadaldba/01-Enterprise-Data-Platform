    PRINT N'';
    PRINT N'    ● reference.AdministrativeDivision';
    PRINT N'';

    DECLARE @ADV_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        reference.AdministrativeDivision -> ADV
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'reference'
        AND PFX_table_name = N'AdministrativeDivision'
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
            N'AdministrativeDivision',
            N'ADV',
            1,
            @ADV_seed_timestamp,
            @ADV_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : reference.AdministrativeDivision -> ADV';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'AdministrativeDivision'
            AND PFX_prefix = N'ADV'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : reference.AdministrativeDivision -> ADV';

        END
        ELSE
        BEGIN

            DECLARE @ADV_actual_prefix    nvarchar(5);
            DECLARE @ADV_actual_is_active bit;


            SELECT
                @ADV_actual_prefix =
                    PFX_prefix,

                @ADV_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'AdministrativeDivision';


            PRINT N'        [!] Prefix registration mismatch  : reference.AdministrativeDivision';
            PRINT N'            Expected Prefix              : ADV';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@ADV_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @ADV_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';