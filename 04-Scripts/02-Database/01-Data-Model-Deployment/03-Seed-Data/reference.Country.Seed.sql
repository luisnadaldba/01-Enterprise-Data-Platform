    PRINT N'';
    PRINT N'    ● reference.Country';
    PRINT N'';

    DECLARE @CTR_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        reference.Country -> CTR
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'reference'
        AND PFX_table_name = N'Country'
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
            N'Country',
            N'CTR',
            1,
            @CTR_seed_timestamp,
            @CTR_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : reference.Country -> CTR';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'Country'
            AND PFX_prefix = N'CTR'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : reference.Country -> CTR';

        END
        ELSE
        BEGIN

            DECLARE @CTR_actual_prefix    nvarchar(5);
            DECLARE @CTR_actual_is_active bit;


            SELECT
                @CTR_actual_prefix =
                    PFX_prefix,

                @CTR_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'Country';


            PRINT N'        [!] Prefix registration mismatch  : reference.Country';
            PRINT N'            Expected Prefix              : CTR';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@CTR_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CTR_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';