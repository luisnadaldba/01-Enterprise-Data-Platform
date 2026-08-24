    PRINT N'';
    PRINT N'    ● metadata.TablePrefix';
    PRINT N'';

    DECLARE @PFX_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        metadata.TablePrefix -> PFX
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'metadata'
        AND PFX_table_name = N'TablePrefix'
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
            N'metadata',
            N'TablePrefix',
            N'PFX',
            1,
            @PFX_seed_timestamp,
            @PFX_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : metadata.TablePrefix -> PFX';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'metadata'
            AND PFX_table_name = N'TablePrefix'
            AND PFX_prefix = N'PFX'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : metadata.TablePrefix -> PFX';

        END
        ELSE
        BEGIN

            DECLARE @PFX_actual_prefix     nvarchar(5);
            DECLARE @PFX_actual_is_active  bit;


            SELECT
                @PFX_actual_prefix =
                    PFX_prefix,

                @PFX_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'metadata'
            AND PFX_table_name = N'TablePrefix';


            PRINT N'        [!] Prefix registration mismatch  : metadata.TablePrefix';
            PRINT N'            Expected Prefix              : PFX';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@PFX_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PFX_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';