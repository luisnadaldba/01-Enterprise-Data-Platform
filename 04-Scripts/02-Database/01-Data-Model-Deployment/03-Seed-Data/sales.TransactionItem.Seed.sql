    PRINT N'    sales.TransactionItem';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @TRNIT_seed_timestamp datetime2(0) = SYSDATETIME();


    /*----------------------------------------------------------------------
        sales.TransactionItem -> sales.TransactionItem / TRNIT
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'sales'
        AND PFX_table_name = N'TransactionItem'
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
            N'sales',
            N'TransactionItem',
            N'TRNIT',
            1,
            @TRNIT_seed_timestamp,
            @TRNIT_seed_timestamp
        );

        PRINT N'        [+] Prefix registration added     : sales.TransactionItem -> TRNIT';
    END
    ELSE
    BEGIN
        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'sales'
            AND PFX_table_name = N'TransactionItem'
            AND PFX_prefix = N'TRNIT'
            AND PFX_is_active = 1
        )
        BEGIN
            PRINT N'        [•] Prefix registration validated : sales.TransactionItem -> TRNIT';
        END
        ELSE
        BEGIN
            DECLARE @TRNIT_actual_prefix     nvarchar(5);
            DECLARE @TRNIT_actual_is_active  bit;

            SELECT
                @TRNIT_actual_prefix     = PFX_prefix,
                @TRNIT_actual_is_active  = PFX_is_active
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'sales'
            AND PFX_table_name = N'TransactionItem';

            PRINT N'        [!] Prefix registration mismatch  : sales.TransactionItem';
            PRINT N'            Expected Prefix              : TRNIT';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@TRNIT_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE(CONVERT(nvarchar(1), @TRNIT_actual_is_active), N'<NULL>');
            PRINT N'            Existing registration was preserved for review.';
        END;
    END;

    PRINT N'';