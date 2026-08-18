    PRINT N'    sales.TransactionStatus';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @TRNST_SEEDRUN_timestamp datetime2(0) = SYSDATETIME();


    /*==============================================================================
        PREFIX REGISTRATION
    ==============================================================================*/

    /*----------------------------------------------------------------------
        sales.TransactionStatus -> TRNST
    ----------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'sales'
        AND PFX_table_name = N'TransactionStatus'
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
            N'TransactionStatus',
            N'TRNST',
            1,
            @TRNST_SEEDRUN_timestamp,
            @TRNST_SEEDRUN_timestamp
        );

        PRINT N'        [+] Prefix registration added     : sales.TransactionStatus -> TRNST';

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM metadata.TablePrefix
            WHERE PFX_schema_name = N'sales'
            AND PFX_table_name = N'TransactionStatus'
            AND PFX_prefix = N'TRNST'
            AND PFX_is_active = 1
        )
        BEGIN

            PRINT N'        [•] Prefix registration validated : sales.TransactionStatus -> TRNST';

        END
        ELSE
        BEGIN

            DECLARE @TRNST_PREFIXSEED_actual_prefix    nvarchar(5);
            DECLARE @TRNST_PREFIXSEED_actual_is_active bit;

            SELECT
                @TRNST_PREFIXSEED_actual_prefix =
                    PFX_prefix,

                @TRNST_PREFIXSEED_actual_is_active =
                    PFX_is_active

            FROM metadata.TablePrefix

            WHERE PFX_schema_name = N'sales'
            AND PFX_table_name = N'TransactionStatus';


            PRINT N'        [!] Prefix registration mismatch  : sales.TransactionStatus';
            PRINT N'            Expected Prefix              : TRNST';
            PRINT N'            Actual Prefix                : '
                + COALESCE(@TRNST_PREFIXSEED_actual_prefix, N'<NULL>');
            PRINT N'            Expected Active              : 1';
            PRINT N'            Actual Active                : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @TRNST_PREFIXSEED_actual_is_active),
                    N'<NULL>'
                );
            PRINT N'            Existing registration was preserved for review.';

        END;

    END;


    PRINT N'';


    /*==============================================================================
        TRANSACTION STATUS DOMAIN DATA
    ==============================================================================*/

    DECLARE @TRNST_DOMAINSEED_expected TABLE
    (
        TRNST_seed_id          tinyint IDENTITY(1,1) NOT NULL,
        TRNST_seed_code        varchar(30)            NOT NULL,
        TRNST_seed_name        varchar(100)           NOT NULL,
        TRNST_seed_is_active   bit                    NOT NULL
    );


    INSERT INTO @TRNST_DOMAINSEED_expected
    (
        TRNST_seed_code,
        TRNST_seed_name,
        TRNST_seed_is_active
    )
    VALUES
    (
        'PENDING',
        'Pending',
        1
    ),
    (
        'CONFIRMED',
        'Confirmed',
        1
    ),
    (
        'COMPLETED',
        'Completed',
        1
    ),
    (
        'CANCELLED',
        'Cancelled',
        1
    ),
    (
        'FAILED',
        'Failed',
        1
    );


    /*==============================================================================
        PROCESS EXPECTED STATUS DEFINITIONS
    ==============================================================================*/

    DECLARE @TRNST_DOMAINSEED_current_id tinyint;
    DECLARE @TRNST_DOMAINSEED_max_id     tinyint;

    DECLARE @TRNST_DOMAINSEED_code       varchar(30);
    DECLARE @TRNST_DOMAINSEED_name       varchar(100);
    DECLARE @TRNST_DOMAINSEED_is_active  bit;

    DECLARE @TRNST_DOMAINSEED_actual_name       varchar(100);
    DECLARE @TRNST_DOMAINSEED_actual_is_active  bit;

    DECLARE @TRNST_DOMAINSEED_existing_count int;


    SELECT
        @TRNST_DOMAINSEED_current_id = MIN(TRNST_seed_id),
        @TRNST_DOMAINSEED_max_id     = MAX(TRNST_seed_id)

    FROM @TRNST_DOMAINSEED_expected;


    WHILE @TRNST_DOMAINSEED_current_id <= @TRNST_DOMAINSEED_max_id
    BEGIN

        SET @TRNST_DOMAINSEED_code              = NULL;
        SET @TRNST_DOMAINSEED_name              = NULL;
        SET @TRNST_DOMAINSEED_is_active         = NULL;
        SET @TRNST_DOMAINSEED_actual_name       = NULL;
        SET @TRNST_DOMAINSEED_actual_is_active  = NULL;
        SET @TRNST_DOMAINSEED_existing_count    = 0;


        SELECT
            @TRNST_DOMAINSEED_code =
                TRNST_seed_code,

            @TRNST_DOMAINSEED_name =
                TRNST_seed_name,

            @TRNST_DOMAINSEED_is_active =
                TRNST_seed_is_active

        FROM @TRNST_DOMAINSEED_expected

        WHERE TRNST_seed_id =
            @TRNST_DOMAINSEED_current_id;


        SELECT
            @TRNST_DOMAINSEED_existing_count = COUNT(*)

        FROM sales.TransactionStatus

        WHERE TRNST_code =
            @TRNST_DOMAINSEED_code;


        /*--------------------------------------------------------------------------
            STATUS DOES NOT EXIST
        --------------------------------------------------------------------------*/

        IF @TRNST_DOMAINSEED_existing_count = 0
        BEGIN

            INSERT INTO sales.TransactionStatus
            (
                TRNST_code,
                TRNST_name,
                TRNST_is_active,
                TRNST_created_at,
                TRNST_updated_at
            )
            VALUES
            (
                @TRNST_DOMAINSEED_code,
                @TRNST_DOMAINSEED_name,
                @TRNST_DOMAINSEED_is_active,
                @TRNST_SEEDRUN_timestamp,
                @TRNST_SEEDRUN_timestamp
            );


            PRINT N'        [+] Transaction status added       : '
                + @TRNST_DOMAINSEED_code;

            PRINT N'            Name                           : '
                + @TRNST_DOMAINSEED_name;

            PRINT N'            Active                         : '
                + CONVERT(nvarchar(1), @TRNST_DOMAINSEED_is_active);

        END


        /*--------------------------------------------------------------------------
            DUPLICATE STATUS CODE

            The intended architecture requires TRNST_code to be unique.
            Seed processing must not silently choose one duplicated row.
        --------------------------------------------------------------------------*/

        ELSE IF @TRNST_DOMAINSEED_existing_count > 1
        BEGIN

            PRINT N'        [X] Duplicate transaction status    : '
                + @TRNST_DOMAINSEED_code;

            PRINT N'            Existing Rows                  : '
                + CONVERT(nvarchar(10), @TRNST_DOMAINSEED_existing_count);

            PRINT N'            Manual review is required.';


            ;THROW 50070,
                N'Duplicate transaction status code detected in sales.TransactionStatus.',
                1;

        END


        /*--------------------------------------------------------------------------
            STATUS EXISTS - VALIDATE EXPECTED VALUES
        --------------------------------------------------------------------------*/

        ELSE
        BEGIN

            SELECT
                @TRNST_DOMAINSEED_actual_name =
                    TRNST_name,

                @TRNST_DOMAINSEED_actual_is_active =
                    TRNST_is_active

            FROM sales.TransactionStatus

            WHERE TRNST_code =
                @TRNST_DOMAINSEED_code;


            IF @TRNST_DOMAINSEED_actual_name = @TRNST_DOMAINSEED_name
            AND @TRNST_DOMAINSEED_actual_is_active = @TRNST_DOMAINSEED_is_active
            BEGIN

                PRINT N'        [•] Transaction status validated   : '
                    + @TRNST_DOMAINSEED_code;

                PRINT N'            Name                           : '
                    + @TRNST_DOMAINSEED_name;

                PRINT N'            Active                         : '
                    + CONVERT(nvarchar(1), @TRNST_DOMAINSEED_is_active);

            END
            ELSE
            BEGIN

                PRINT N'        [!] Transaction status mismatch    : '
                    + @TRNST_DOMAINSEED_code;

                PRINT N'            Expected Name                  : '
                    + @TRNST_DOMAINSEED_name;

                PRINT N'            Actual Name                    : '
                    + COALESCE(@TRNST_DOMAINSEED_actual_name, N'<NULL>');

                PRINT N'            Expected Active                : '
                    + CONVERT(nvarchar(1), @TRNST_DOMAINSEED_is_active);

                PRINT N'            Actual Active                  : '
                    + COALESCE
                    (
                        CONVERT
                        (
                            nvarchar(1),
                            @TRNST_DOMAINSEED_actual_is_active
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Existing status was preserved for review.';

            END;

        END;


        SET @TRNST_DOMAINSEED_current_id =
            @TRNST_DOMAINSEED_current_id + 1;

    END;


    PRINT N'';