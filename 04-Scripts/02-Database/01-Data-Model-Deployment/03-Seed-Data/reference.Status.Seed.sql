    PRINT N'    reference.Status';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @STS_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        reference.Status -> STS
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'reference'
        AND PFX_table_name = N'Status'
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
            N'Status',
            N'STS',
            1,
            @STS_seed_timestamp,
            @STS_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : reference.Status -> STS';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'Status'
            AND PFX_prefix = N'STS'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : reference.Status -> STS';

        END
        ELSE
        BEGIN

            DECLARE @STS_actual_prefix    nvarchar(5);
            DECLARE @STS_actual_is_active bit;


            SELECT
                @STS_actual_prefix =
                    PFX_prefix,

                @STS_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'Status';


            PRINT N'        [!] Prefix registration mismatch  : reference.Status';
            PRINT N'            Expected Prefix              : STS';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@STS_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @STS_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';