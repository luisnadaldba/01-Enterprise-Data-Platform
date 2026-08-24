    PRINT N'';
    PRINT N'    ● reference.City';
    PRINT N'';

    DECLARE @CTY_seed_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        reference.City -> CTY
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'reference'
        AND PFX_table_name = N'City'
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
            N'City',
            N'CTY',
            1,
            @CTY_seed_timestamp,
            @CTY_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : reference.City -> CTY';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'City'
            AND PFX_prefix = N'CTY'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : reference.City -> CTY';

        END
        ELSE
        BEGIN

            DECLARE @CTY_actual_prefix    nvarchar(5);
            DECLARE @CTY_actual_is_active bit;


            SELECT
                @CTY_actual_prefix =
                    PFX_prefix,

                @CTY_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'reference'
            AND PFX_table_name = N'City';


            PRINT N'        [!] Prefix registration mismatch  : reference.City';
            PRINT N'            Expected Prefix              : CTY';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@CTY_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CTY_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';