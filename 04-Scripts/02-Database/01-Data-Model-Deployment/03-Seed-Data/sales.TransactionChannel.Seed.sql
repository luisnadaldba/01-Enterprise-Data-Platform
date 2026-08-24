    PRINT N'';
    PRINT N'    ● sales.TransactionChannel';
    PRINT N'';

    DECLARE @TRNCH_SEEDRUN_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        sales.TransactionChannel -> TRNCH
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'sales'
        AND PFX_table_name = N'TransactionChannel'
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
            N'TransactionChannel',
            N'TRNCH',
            1,
            @TRNCH_SEEDRUN_timestamp,
            @TRNCH_SEEDRUN_timestamp
        );

        PRINT N'        [+] Prefix registration added     : sales.TransactionChannel -> TRNCH';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'sales'
            AND PFX_table_name = N'TransactionChannel'
            AND PFX_prefix = N'TRNCH'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : sales.TransactionChannel -> TRNCH';

        END
        ELSE
        BEGIN

            DECLARE @TRNCH_PREFIXSEED_actual_prefix    nvarchar(5);
            DECLARE @TRNCH_PREFIXSEED_actual_is_active bit;


            SELECT
                @TRNCH_PREFIXSEED_actual_prefix =
                    PFX_prefix,

                @TRNCH_PREFIXSEED_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'sales'
            AND PFX_table_name = N'TransactionChannel';


            PRINT N'        [!] Prefix registration mismatch  : sales.TransactionChannel';
            PRINT N'            Expected Prefix              : TRNCH';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@TRNCH_PREFIXSEED_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @TRNCH_PREFIXSEED_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    /*==============================================================================
        TRANSACTION CHANNEL DOMAIN DATA
    ==============================================================================*/

    DECLARE @TRNCH_DOMAINSEED_expected TABLE
    (
        TRNCH_seed_id          tinyint IDENTITY(1,1) NOT NULL,
        TRNCH_seed_code        varchar(30)            NOT NULL,
        TRNCH_seed_name        varchar(100)           NOT NULL,
        TRNCH_seed_is_active   bit                    NOT NULL
    );


    INSERT INTO @TRNCH_DOMAINSEED_expected
    (
        TRNCH_seed_code,
        TRNCH_seed_name,
        TRNCH_seed_is_active
    )
    VALUES
    (
        'ONLINE',
        'Online transaction',
        1
    ),
    (
        'STORE',
        'Physical store transaction',
        1
    );


    /*==============================================================================
        PROCESS EXPECTED CHANNEL DEFINITIONS
    ==============================================================================*/

    DECLARE @TRNCH_DOMAINSEED_current_id tinyint;
    DECLARE @TRNCH_DOMAINSEED_max_id     tinyint;

    DECLARE @TRNCH_DOMAINSEED_code       varchar(30);
    DECLARE @TRNCH_DOMAINSEED_name       varchar(100);
    DECLARE @TRNCH_DOMAINSEED_is_active  bit;

    DECLARE @TRNCH_DOMAINSEED_actual_name       varchar(100);
    DECLARE @TRNCH_DOMAINSEED_actual_is_active  bit;

    DECLARE @TRNCH_DOMAINSEED_existing_count int;


    SELECT
        @TRNCH_DOMAINSEED_current_id = MIN(TRNCH_seed_id),
        @TRNCH_DOMAINSEED_max_id     = MAX(TRNCH_seed_id)

    FROM @TRNCH_DOMAINSEED_expected;


    WHILE @TRNCH_DOMAINSEED_current_id <= @TRNCH_DOMAINSEED_max_id
    BEGIN

        SET @TRNCH_DOMAINSEED_code              = NULL;
        SET @TRNCH_DOMAINSEED_name              = NULL;
        SET @TRNCH_DOMAINSEED_is_active         = NULL;
        SET @TRNCH_DOMAINSEED_actual_name       = NULL;
        SET @TRNCH_DOMAINSEED_actual_is_active  = NULL;
        SET @TRNCH_DOMAINSEED_existing_count    = 0;


        SELECT
            @TRNCH_DOMAINSEED_code =
                TRNCH_seed_code,

            @TRNCH_DOMAINSEED_name =
                TRNCH_seed_name,

            @TRNCH_DOMAINSEED_is_active =
                TRNCH_seed_is_active

        FROM @TRNCH_DOMAINSEED_expected

        WHERE TRNCH_seed_id =
            @TRNCH_DOMAINSEED_current_id;


        SELECT
            @TRNCH_DOMAINSEED_existing_count = COUNT(*)

        FROM sales.TransactionChannel

        WHERE TRNCH_code =
            @TRNCH_DOMAINSEED_code;


        /*--------------------------------------------------------------------------
            CHANNEL DOES NOT EXIST
        --------------------------------------------------------------------------*/

        IF @TRNCH_DOMAINSEED_existing_count = 0
        BEGIN

            INSERT INTO sales.TransactionChannel
            (
                TRNCH_code,
                TRNCH_name,
                TRNCH_is_active,
                TRNCH_created_at,
                TRNCH_updated_at
            )
            VALUES
            (
                @TRNCH_DOMAINSEED_code,
                @TRNCH_DOMAINSEED_name,
                @TRNCH_DOMAINSEED_is_active,
                @TRNCH_SEEDRUN_timestamp,
                @TRNCH_SEEDRUN_timestamp
            );


            PRINT N'        [+] Transaction channel added      : '
                + @TRNCH_DOMAINSEED_code;

            PRINT N'            Name                           : '
                + @TRNCH_DOMAINSEED_name;

            PRINT N'            Active                         : '
                + CONVERT(nvarchar(1), @TRNCH_DOMAINSEED_is_active);

        END


        /*--------------------------------------------------------------------------
            DUPLICATE CHANNEL CODE

            The intended architecture requires TRNCH_code to be unique.
            Seed processing must not silently choose one duplicated row.
        --------------------------------------------------------------------------*/

        ELSE IF @TRNCH_DOMAINSEED_existing_count > 1
        BEGIN

            PRINT N'        [X] Duplicate transaction channel   : '
                + @TRNCH_DOMAINSEED_code;

            PRINT N'            Existing Rows                  : '
                + CONVERT(nvarchar(10), @TRNCH_DOMAINSEED_existing_count);

            PRINT N'            Manual review is required.';


            ;THROW 50086,
                N'Duplicate transaction channel code detected in sales.TransactionChannel.',
                1;

        END


        /*--------------------------------------------------------------------------
            CHANNEL EXISTS - VALIDATE EXPECTED VALUES
        --------------------------------------------------------------------------*/

        ELSE
        BEGIN

            SELECT
                @TRNCH_DOMAINSEED_actual_name =
                    TRNCH_name,

                @TRNCH_DOMAINSEED_actual_is_active =
                    TRNCH_is_active

            FROM sales.TransactionChannel

            WHERE TRNCH_code =
                @TRNCH_DOMAINSEED_code;


            IF @TRNCH_DOMAINSEED_actual_name = @TRNCH_DOMAINSEED_name
            AND @TRNCH_DOMAINSEED_actual_is_active = @TRNCH_DOMAINSEED_is_active
            BEGIN

                PRINT N'        [•] Transaction channel validated  : '
                    + @TRNCH_DOMAINSEED_code;

                PRINT N'            Name                           : '
                    + @TRNCH_DOMAINSEED_name;

                PRINT N'            Active                         : '
                    + CONVERT(nvarchar(1), @TRNCH_DOMAINSEED_is_active);

            END
            ELSE
            BEGIN

                PRINT N'        [!] Transaction channel mismatch   : '
                    + @TRNCH_DOMAINSEED_code;

                PRINT N'            Expected Name                  : '
                    + @TRNCH_DOMAINSEED_name;

                PRINT N'            Actual Name                    : '
                    + COALESCE(@TRNCH_DOMAINSEED_actual_name, N'<NULL>');

                PRINT N'            Expected Active                : '
                    + CONVERT(nvarchar(1), @TRNCH_DOMAINSEED_is_active);

                PRINT N'            Actual Active                  : '
                    + COALESCE
                    (
                        CONVERT
                        (
                            nvarchar(1),
                            @TRNCH_DOMAINSEED_actual_is_active
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Existing channel was preserved for review.';

            END;

        END;


        SET @TRNCH_DOMAINSEED_current_id =
            @TRNCH_DOMAINSEED_current_id + 1;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';