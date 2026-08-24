    PRINT N'    ● sales.Transaction';

    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @TRN_FV_validation_errors int = 0;

    DECLARE @TRN_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRN_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRN_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRN_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRN_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @TRN_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRN_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRN_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @TRN_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRN_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRN_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'sales.[Transaction]', N'U') IS NOT NULL
    BEGIN
        SET @TRN_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRN_FV_table_status = N'FAILED';
        SET @TRN_FV_validation_errors = @TRN_FV_validation_errors + 1;
    END;

    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @TRN_FV_pk_actual_name     sysname;
    DECLARE @TRN_FV_pk_actual_columns  nvarchar(4000);

    SELECT
        @TRN_FV_pk_actual_name =
            kc.name,

        @TRN_FV_pk_actual_columns =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY ic.key_ordinal
                )

            FROM sys.index_columns AS ic

            INNER JOIN sys.columns AS c
                ON  c.object_id = ic.object_id
                AND c.column_id = ic.column_id

            WHERE ic.object_id =
                    kc.parent_object_id

            AND ic.index_id =
                    kc.unique_index_id

            AND ic.key_ordinal > 0
        )

    FROM sys.key_constraints AS kc

    WHERE kc.parent_object_id =
            OBJECT_ID(N'sales.[Transaction]')

    AND kc.type = N'PK';


    IF @TRN_FV_pk_actual_columns =
        N'TRN_id|TRN_transaction_at'
    BEGIN

        SET @TRN_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRN_FV_primary_key_status = N'FAILED';
        SET @TRN_FV_validation_errors =
            @TRN_FV_validation_errors + 1;

    END;

    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @TRN_FV_expected_column_count int = 9;
    DECLARE @TRN_FV_actual_column_count   int;

    SELECT
        @TRN_FV_actual_column_count = COUNT(*)
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'sales.[Transaction]');


    IF @TRN_FV_actual_column_count = @TRN_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
        AND c.name = N'TRN_id'
        AND t.name = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'sales.[Transaction]')
        AND ic.name = N'TRN_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
        AND c.name = N'TRN_CST_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
        AND c.name = N'TRN_transaction_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
        AND c.name = N'TRN_TRNCH_id'
        AND t.name = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
        AND c.name = N'TRN_TRNST_id'
        AND t.name = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
        AND c.name = N'TRN_gross_amount'
        AND t.name = N'decimal'
        AND c.precision = 19
        AND c.scale = 2
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
        AND c.name = N'TRN_discount_amount'
        AND t.name = N'decimal'
        AND c.precision = 19
        AND c.scale = 2
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
        AND c.name = N'TRN_created_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.[Transaction]')
        AND c.name = N'TRN_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN

        SET @TRN_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRN_FV_columns_status = N'FAILED';

        SET @TRN_FV_validation_errors =
            @TRN_FV_validation_errors + 1;

    END;

    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @TRN_FV_expected_documentation TABLE
    (
        TRN_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        TRN_doc_object_type           nvarchar(10)           NOT NULL,
        TRN_doc_column_name           sysname                NULL,
        TRN_doc_expected_description  nvarchar(4000)         NOT NULL
    );

    DECLARE @TRN_FV_doc_current_id          tinyint;
    DECLARE @TRN_FV_doc_max_id              tinyint;

    DECLARE @TRN_FV_doc_object_type         nvarchar(10);
    DECLARE @TRN_FV_doc_column_name         sysname;

    DECLARE @TRN_FV_doc_expected_value      nvarchar(4000);
    DECLARE @TRN_FV_doc_actual_value        nvarchar(4000);

    DECLARE @TRN_FV_invalid_documentation   int = 0;


    INSERT INTO @TRN_FV_expected_documentation
    (
        TRN_doc_object_type,
        TRN_doc_column_name,
        TRN_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the core sales transaction records processed by Atlas Commerce, including customer, status, channel, monetary amounts, and the transaction business timestamp.'
    ),
    (
        N'COLUMN',
        N'TRN_id',
        N'Primary key of sales.Transaction.'
    ),
    (
        N'COLUMN',
        N'TRN_transaction_at',
        N'Records the date and time when the transaction occurred.'
    ),
    (
        N'COLUMN',
        N'TRN_CST_id',
        N'Foreign key referencing customer.Customer.'
    ),
    (
        N'COLUMN',
        N'TRN_TRNCH_id',
        N'Foreign key referencing sales.TransactionChannel.'
    ),
    (
        N'COLUMN',
        N'TRN_TRNST_id',
        N'Foreign key referencing sales.TransactionStatus.'
    ),
    (
        N'COLUMN',
        N'TRN_gross_amount',
        N'Stores the gross monetary amount of the transaction before discounts.'
    ),
    (
        N'COLUMN',
        N'TRN_discount_amount',
        N'Stores the total monetary discount amount applied to the transaction.'
    ),
    (
        N'COLUMN',
        N'TRN_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'TRN_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @TRN_FV_doc_current_id = MIN(TRN_doc_id),
        @TRN_FV_doc_max_id     = MAX(TRN_doc_id)
    FROM @TRN_FV_expected_documentation;


    WHILE @TRN_FV_doc_current_id <= @TRN_FV_doc_max_id
    BEGIN

        SET @TRN_FV_doc_object_type     = NULL;
        SET @TRN_FV_doc_column_name     = NULL;
        SET @TRN_FV_doc_expected_value  = NULL;
        SET @TRN_FV_doc_actual_value    = NULL;


        SELECT
            @TRN_FV_doc_object_type =
                TRN_doc_object_type,

            @TRN_FV_doc_column_name =
                TRN_doc_column_name,

            @TRN_FV_doc_expected_value =
                TRN_doc_expected_description

        FROM @TRN_FV_expected_documentation
        WHERE TRN_doc_id = @TRN_FV_doc_current_id;


        IF @TRN_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @TRN_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END

        ELSE IF @TRN_FV_doc_object_type = N'COLUMN'
        BEGIN

            SELECT
                @TRN_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.columns AS c

            LEFT JOIN sys.extended_properties AS ep
                ON  ep.class = 1
                AND ep.major_id = c.object_id
                AND ep.minor_id = c.column_id
                AND ep.name = N'MS_Description'

            WHERE c.object_id =
                    OBJECT_ID(N'sales.[Transaction]')

            AND c.name =
                    @TRN_FV_doc_column_name;

        END;


        IF @TRN_FV_doc_actual_value IS NULL
        OR @TRN_FV_doc_actual_value <> @TRN_FV_doc_expected_value
        BEGIN

            SET @TRN_FV_invalid_documentation =
                @TRN_FV_invalid_documentation + 1;

        END;


        SET @TRN_FV_doc_current_id =
            @TRN_FV_doc_current_id + 1;

    END;


    IF @TRN_FV_invalid_documentation = 0
    BEGIN

        SET @TRN_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRN_FV_documentation_status = N'FAILED';

        SET @TRN_FV_validation_errors =
            @TRN_FV_validation_errors + 1;

    END;

    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @TRN_FV_expected_defaults TABLE
    (
        TRN_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        TRN_default_column_name          sysname                NOT NULL,
        TRN_default_constraint_name      sysname                NOT NULL,
        TRN_default_expected_definition  nvarchar(4000)         NOT NULL
    );

    DECLARE @TRN_FV_default_current_id          tinyint;
    DECLARE @TRN_FV_default_max_id              tinyint;

    DECLARE @TRN_FV_default_column_name         sysname;
    DECLARE @TRN_FV_default_expected_name       sysname;
    DECLARE @TRN_FV_default_actual_name         sysname;

    DECLARE @TRN_FV_default_expected_definition nvarchar(4000);
    DECLARE @TRN_FV_default_actual_definition   nvarchar(4000);

    DECLARE @TRN_FV_invalid_defaults            int = 0;


    INSERT INTO @TRN_FV_expected_defaults
    (
        TRN_default_column_name,
        TRN_default_constraint_name,
        TRN_default_expected_definition
    )
    VALUES
    (
        N'TRN_discount_amount',
        N'DF_TRN_discount_amount',
        N'((0.00))'
    ),
    (
        N'TRN_created_at',
        N'DF_TRN_created_at',
        N'(sysdatetime())'
    ),
    (
        N'TRN_updated_at',
        N'DF_TRN_updated_at',
        N'(sysdatetime())'
    );


    SELECT
        @TRN_FV_default_current_id = MIN(TRN_default_id),
        @TRN_FV_default_max_id     = MAX(TRN_default_id)
    FROM @TRN_FV_expected_defaults;


    WHILE @TRN_FV_default_current_id <= @TRN_FV_default_max_id
    BEGIN

        SET @TRN_FV_default_column_name         = NULL;
        SET @TRN_FV_default_expected_name       = NULL;
        SET @TRN_FV_default_actual_name         = NULL;
        SET @TRN_FV_default_expected_definition = NULL;
        SET @TRN_FV_default_actual_definition   = NULL;


        SELECT
            @TRN_FV_default_column_name =
                TRN_default_column_name,

            @TRN_FV_default_expected_name =
                TRN_default_constraint_name,

            @TRN_FV_default_expected_definition =
                TRN_default_expected_definition

        FROM @TRN_FV_expected_defaults
        WHERE TRN_default_id = @TRN_FV_default_current_id;


        SELECT
            @TRN_FV_default_actual_name =
                dc.name,

            @TRN_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND c.name =
                @TRN_FV_default_column_name;


        IF @TRN_FV_default_actual_name IS NULL
        OR @TRN_FV_default_actual_name <> @TRN_FV_default_expected_name
        OR @TRN_FV_default_actual_definition IS NULL
        OR LOWER(REPLACE(REPLACE(@TRN_FV_default_actual_definition, N' ', N''), N'(', N''))
            <> LOWER(REPLACE(REPLACE(@TRN_FV_default_expected_definition, N' ', N''), N'(', N''))
        BEGIN

            SET @TRN_FV_invalid_defaults =
                @TRN_FV_invalid_defaults + 1;

        END;


        SET @TRN_FV_default_current_id =
            @TRN_FV_default_current_id + 1;

    END;


    IF @TRN_FV_invalid_defaults = 0
    BEGIN

        SET @TRN_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRN_FV_defaults_status = N'FAILED';

        SET @TRN_FV_validation_errors =
            @TRN_FV_validation_errors + 1;

    END;

    /*==========================================================================
        CHECK CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @TRN_FV_expected_checks TABLE
    (
        TRN_check_id                    tinyint IDENTITY(1,1) NOT NULL,
        TRN_check_constraint_name       sysname                NOT NULL,
        TRN_check_expected_definition   nvarchar(4000)         NOT NULL
    );

    DECLARE @TRN_FV_check_current_id          tinyint;
    DECLARE @TRN_FV_check_max_id              tinyint;

    DECLARE @TRN_FV_check_expected_name       sysname;
    DECLARE @TRN_FV_check_actual_name         sysname;

    DECLARE @TRN_FV_check_expected_definition nvarchar(4000);
    DECLARE @TRN_FV_check_actual_definition   nvarchar(4000);

    DECLARE @TRN_FV_check_is_disabled         bit;
    DECLARE @TRN_FV_check_is_not_trusted      bit;

    DECLARE @TRN_FV_invalid_checks            int = 0;


    INSERT INTO @TRN_FV_expected_checks
    (
        TRN_check_constraint_name,
        TRN_check_expected_definition
    )
    VALUES
    (
        N'CK_TRN_gross_amount',
        N'TRN_gross_amount>=0.00'
    ),
    (
        N'CK_TRN_discount_amount',
        N'TRN_discount_amount>=0.00'
    );


    SELECT
        @TRN_FV_check_current_id = MIN(TRN_check_id),
        @TRN_FV_check_max_id     = MAX(TRN_check_id)
    FROM @TRN_FV_expected_checks;


    WHILE @TRN_FV_check_current_id <= @TRN_FV_check_max_id
    BEGIN

        SET @TRN_FV_check_expected_name       = NULL;
        SET @TRN_FV_check_actual_name         = NULL;

        SET @TRN_FV_check_expected_definition = NULL;
        SET @TRN_FV_check_actual_definition   = NULL;

        SET @TRN_FV_check_is_disabled         = NULL;
        SET @TRN_FV_check_is_not_trusted      = NULL;


        SELECT
            @TRN_FV_check_expected_name =
                TRN_check_constraint_name,

            @TRN_FV_check_expected_definition =
                TRN_check_expected_definition

        FROM @TRN_FV_expected_checks
        WHERE TRN_check_id = @TRN_FV_check_current_id;


        SELECT
            @TRN_FV_check_actual_name =
                cc.name,

            @TRN_FV_check_actual_definition =
                cc.definition,

            @TRN_FV_check_is_disabled =
                cc.is_disabled,

            @TRN_FV_check_is_not_trusted =
                cc.is_not_trusted

        FROM sys.check_constraints AS cc

        WHERE cc.parent_object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND cc.name =
                @TRN_FV_check_expected_name;


        IF @TRN_FV_check_actual_name IS NULL
        OR @TRN_FV_check_actual_definition IS NULL

        OR LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            REPLACE
                            (
                                @TRN_FV_check_actual_definition,
                                N'[',
                                N''
                            ),
                            N']',
                            N''
                        ),
                        N'(',
                        N''
                    ),
                    N')',
                    N''
                )
            )
            <>
            LOWER
            (
                REPLACE
                (
                    @TRN_FV_check_expected_definition,
                    N' ',
                    N''
                )
            )

        OR @TRN_FV_check_is_disabled <> 0
        OR @TRN_FV_check_is_not_trusted <> 0
        BEGIN

            SET @TRN_FV_invalid_checks =
                @TRN_FV_invalid_checks + 1;

        END;


        SET @TRN_FV_check_current_id =
            @TRN_FV_check_current_id + 1;

    END;


    IF @TRN_FV_invalid_checks = 0
    BEGIN

        SET @TRN_FV_checks_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRN_FV_checks_status = N'FAILED';

        SET @TRN_FV_validation_errors =
            @TRN_FV_validation_errors + 1;

    END;

    /*==========================================================================
        FOREIGN KEY CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @TRN_FV_expected_foreign_keys TABLE
    (
        TRN_fk_id                    tinyint IDENTITY(1,1) NOT NULL,
        TRN_fk_name                  sysname                NOT NULL,
        TRN_fk_parent_columns        nvarchar(4000)         NOT NULL,
        TRN_fk_referenced_schema     sysname                NOT NULL,
        TRN_fk_referenced_table      sysname                NOT NULL,
        TRN_fk_referenced_columns    nvarchar(4000)         NOT NULL,
        TRN_fk_delete_action         nvarchar(60)           NOT NULL,
        TRN_fk_update_action         nvarchar(60)           NOT NULL
    );


    DECLARE @TRN_FV_fk_current_id             tinyint;
    DECLARE @TRN_FV_fk_max_id                 tinyint;

    DECLARE @TRN_FV_fk_expected_name          sysname;
    DECLARE @TRN_FV_fk_expected_parent_cols   nvarchar(4000);
    DECLARE @TRN_FV_fk_expected_ref_schema    sysname;
    DECLARE @TRN_FV_fk_expected_ref_table     sysname;
    DECLARE @TRN_FV_fk_expected_ref_cols      nvarchar(4000);
    DECLARE @TRN_FV_fk_expected_delete_action nvarchar(60);
    DECLARE @TRN_FV_fk_expected_update_action nvarchar(60);

    DECLARE @TRN_FV_fk_actual_name            sysname;
    DECLARE @TRN_FV_fk_actual_parent_cols     nvarchar(4000);
    DECLARE @TRN_FV_fk_actual_ref_schema      sysname;
    DECLARE @TRN_FV_fk_actual_ref_table       sysname;
    DECLARE @TRN_FV_fk_actual_ref_cols        nvarchar(4000);
    DECLARE @TRN_FV_fk_actual_delete_action   nvarchar(60);
    DECLARE @TRN_FV_fk_actual_update_action   nvarchar(60);
    DECLARE @TRN_FV_fk_actual_is_disabled     bit;
    DECLARE @TRN_FV_fk_actual_is_not_trusted  bit;

    DECLARE @TRN_FV_invalid_foreign_keys      int = 0;


    INSERT INTO @TRN_FV_expected_foreign_keys
    (
        TRN_fk_name,
        TRN_fk_parent_columns,
        TRN_fk_referenced_schema,
        TRN_fk_referenced_table,
        TRN_fk_referenced_columns,
        TRN_fk_delete_action,
        TRN_fk_update_action
    )
    VALUES
    (
        N'FK_TRN_CST',
        N'TRN_CST_id',
        N'customer',
        N'Customer',
        N'CST_id',
        N'NO_ACTION',
        N'NO_ACTION'
    ),
    (
        N'FK_TRN_TRNST',
        N'TRN_TRNST_id',
        N'sales',
        N'TransactionStatus',
        N'TRNST_id',
        N'NO_ACTION',
        N'NO_ACTION'
    ),
    (
        N'FK_TRN_TRNCH',
        N'TRN_TRNCH_id',
        N'sales',
        N'TransactionChannel',
        N'TRNCH_id',
        N'NO_ACTION',
        N'NO_ACTION'
    );


    SELECT
        @TRN_FV_fk_current_id =
            MIN(TRN_fk_id),

        @TRN_FV_fk_max_id =
            MAX(TRN_fk_id)

    FROM @TRN_FV_expected_foreign_keys;


    WHILE @TRN_FV_fk_current_id <=
        @TRN_FV_fk_max_id
    BEGIN

        SET @TRN_FV_fk_expected_name = NULL;
        SET @TRN_FV_fk_expected_parent_cols = NULL;
        SET @TRN_FV_fk_expected_ref_schema = NULL;
        SET @TRN_FV_fk_expected_ref_table = NULL;
        SET @TRN_FV_fk_expected_ref_cols = NULL;
        SET @TRN_FV_fk_expected_delete_action = NULL;
        SET @TRN_FV_fk_expected_update_action = NULL;

        SET @TRN_FV_fk_actual_name = NULL;
        SET @TRN_FV_fk_actual_parent_cols = NULL;
        SET @TRN_FV_fk_actual_ref_schema = NULL;
        SET @TRN_FV_fk_actual_ref_table = NULL;
        SET @TRN_FV_fk_actual_ref_cols = NULL;
        SET @TRN_FV_fk_actual_delete_action = NULL;
        SET @TRN_FV_fk_actual_update_action = NULL;
        SET @TRN_FV_fk_actual_is_disabled = NULL;
        SET @TRN_FV_fk_actual_is_not_trusted = NULL;


        SELECT
            @TRN_FV_fk_expected_name =
                TRN_fk_name,

            @TRN_FV_fk_expected_parent_cols =
                TRN_fk_parent_columns,

            @TRN_FV_fk_expected_ref_schema =
                TRN_fk_referenced_schema,

            @TRN_FV_fk_expected_ref_table =
                TRN_fk_referenced_table,

            @TRN_FV_fk_expected_ref_cols =
                TRN_fk_referenced_columns,

            @TRN_FV_fk_expected_delete_action =
                TRN_fk_delete_action,

            @TRN_FV_fk_expected_update_action =
                TRN_fk_update_action

        FROM @TRN_FV_expected_foreign_keys

        WHERE TRN_fk_id =
            @TRN_FV_fk_current_id;


        SELECT
            @TRN_FV_fk_actual_name =
                fk.name,

            @TRN_FV_fk_actual_ref_schema =
                OBJECT_SCHEMA_NAME
                (
                    fk.referenced_object_id
                ),

            @TRN_FV_fk_actual_ref_table =
                OBJECT_NAME
                (
                    fk.referenced_object_id
                ),

            @TRN_FV_fk_actual_delete_action =
                fk.delete_referential_action_desc,

            @TRN_FV_fk_actual_update_action =
                fk.update_referential_action_desc,

            @TRN_FV_fk_actual_is_disabled =
                fk.is_disabled,

            @TRN_FV_fk_actual_is_not_trusted =
                fk.is_not_trusted,

            @TRN_FV_fk_actual_parent_cols =
            (
                SELECT
                    STRING_AGG
                    (
                        CONVERT
                        (
                            nvarchar(max),
                            pc.name
                        ),
                        N'|'
                    )
                    WITHIN GROUP
                    (
                        ORDER BY
                            fkc.constraint_column_id
                    )

                FROM sys.foreign_key_columns AS fkc

                INNER JOIN sys.columns AS pc
                    ON pc.object_id =
                        fkc.parent_object_id

                    AND pc.column_id =
                        fkc.parent_column_id

                WHERE fkc.constraint_object_id =
                    fk.object_id
            ),

            @TRN_FV_fk_actual_ref_cols =
            (
                SELECT
                    STRING_AGG
                    (
                        CONVERT
                        (
                            nvarchar(max),
                            rc.name
                        ),
                        N'|'
                    )
                    WITHIN GROUP
                    (
                        ORDER BY
                            fkc.constraint_column_id
                    )

                FROM sys.foreign_key_columns AS fkc

                INNER JOIN sys.columns AS rc
                    ON rc.object_id =
                        fkc.referenced_object_id

                    AND rc.column_id =
                        fkc.referenced_column_id

                WHERE fkc.constraint_object_id =
                    fk.object_id
            )

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
            OBJECT_ID(N'sales.[Transaction]')

        AND fk.name =
            @TRN_FV_fk_expected_name;


        IF @TRN_FV_fk_actual_name IS NULL

        OR @TRN_FV_fk_actual_name <>
            @TRN_FV_fk_expected_name

        OR @TRN_FV_fk_actual_parent_cols <>
            @TRN_FV_fk_expected_parent_cols

        OR @TRN_FV_fk_actual_ref_schema <>
            @TRN_FV_fk_expected_ref_schema

        OR @TRN_FV_fk_actual_ref_table <>
            @TRN_FV_fk_expected_ref_table

        OR @TRN_FV_fk_actual_ref_cols <>
            @TRN_FV_fk_expected_ref_cols

        OR @TRN_FV_fk_actual_delete_action <>
            @TRN_FV_fk_expected_delete_action

        OR @TRN_FV_fk_actual_update_action <>
            @TRN_FV_fk_expected_update_action

        OR @TRN_FV_fk_actual_is_disabled <> 0

        OR @TRN_FV_fk_actual_is_not_trusted <> 0
        BEGIN

            SET @TRN_FV_invalid_foreign_keys =
                @TRN_FV_invalid_foreign_keys + 1;

        END;


        SET @TRN_FV_fk_current_id =
            @TRN_FV_fk_current_id + 1;

    END;


    IF
    (
        SELECT COUNT(*)

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
            OBJECT_ID(N'sales.[Transaction]')
    ) <> 3
    BEGIN

        SET @TRN_FV_invalid_foreign_keys =
            @TRN_FV_invalid_foreign_keys + 1;

    END;


    IF @TRN_FV_invalid_foreign_keys = 0
    BEGIN

        SET @TRN_FV_foreign_keys_status =
            N'VALID';

    END
    ELSE
    BEGIN

        SET @TRN_FV_foreign_keys_status =
            N'FAILED';

        SET @TRN_FV_validation_errors =
            @TRN_FV_validation_errors + 1;

    END;

    /*==========================================================================
        INDEX VALIDATION
    ==========================================================================*/

    DECLARE @TRN_FV_expected_indexes TABLE
    (
        TRN_index_id                    tinyint IDENTITY(1,1) NOT NULL,
        TRN_index_name                  sysname                NOT NULL,
        TRN_index_expected_keys         nvarchar(4000)         NOT NULL,
        TRN_index_expected_includes     nvarchar(4000)         NOT NULL,
        TRN_index_expected_data_space   sysname                NOT NULL,
        TRN_index_partition_column      sysname                NOT NULL
    );

    DECLARE @TRN_FV_index_current_id          tinyint;
    DECLARE @TRN_FV_index_max_id              tinyint;

    DECLARE @TRN_FV_index_expected_name       sysname;
    DECLARE @TRN_FV_index_expected_keys       nvarchar(4000);
    DECLARE @TRN_FV_index_expected_includes   nvarchar(4000);
    DECLARE @TRN_FV_index_expected_data_space sysname;
    DECLARE @TRN_FV_index_expected_part_col   sysname;

    DECLARE @TRN_FV_index_actual_name         sysname;
    DECLARE @TRN_FV_index_actual_type         tinyint;
    DECLARE @TRN_FV_index_actual_unique       bit;
    DECLARE @TRN_FV_index_actual_disabled     bit;
    DECLARE @TRN_FV_index_actual_hypothetical bit;

    DECLARE @TRN_FV_index_actual_keys         nvarchar(4000);
    DECLARE @TRN_FV_index_actual_includes     nvarchar(4000);
    DECLARE @TRN_FV_index_actual_data_space   sysname;
    DECLARE @TRN_FV_index_actual_part_col     sysname;

    DECLARE @TRN_FV_invalid_indexes           int = 0;


    INSERT INTO @TRN_FV_expected_indexes
    (
        TRN_index_name,
        TRN_index_expected_keys,
        TRN_index_expected_includes,
        TRN_index_expected_data_space,
        TRN_index_partition_column
    )
    VALUES
    (
        N'IX_TRN_CST_transaction_at',
        N'TRN_CST_id ASC|TRN_transaction_at ASC',
        N'NONE',
        N'PS_SALES_MONTHLY',
        N'TRN_transaction_at'
    ),
    (
        N'IX_TRN_updated_at',
        N'TRN_updated_at ASC',
        N'NONE',
        N'PS_SALES_MONTHLY',
        N'TRN_transaction_at'
    ),
    (
        N'IX_TRN_transaction_at',
        N'TRN_transaction_at ASC',
        N'NONE',
        N'PS_SALES_MONTHLY',
        N'TRN_transaction_at'
    );


    SELECT
        @TRN_FV_index_current_id = MIN(TRN_index_id),
        @TRN_FV_index_max_id     = MAX(TRN_index_id)
    FROM @TRN_FV_expected_indexes;


    WHILE @TRN_FV_index_current_id <= @TRN_FV_index_max_id
    BEGIN

        SET @TRN_FV_index_expected_name       = NULL;
        SET @TRN_FV_index_expected_keys       = NULL;
        SET @TRN_FV_index_expected_includes   = NULL;
        SET @TRN_FV_index_expected_data_space = NULL;
        SET @TRN_FV_index_expected_part_col   = NULL;

        SET @TRN_FV_index_actual_name         = NULL;
        SET @TRN_FV_index_actual_type         = NULL;
        SET @TRN_FV_index_actual_unique       = NULL;
        SET @TRN_FV_index_actual_disabled     = NULL;
        SET @TRN_FV_index_actual_hypothetical = NULL;

        SET @TRN_FV_index_actual_keys         = NULL;
        SET @TRN_FV_index_actual_includes     = NULL;
        SET @TRN_FV_index_actual_data_space   = NULL;
        SET @TRN_FV_index_actual_part_col     = NULL;


        SELECT
            @TRN_FV_index_expected_name =
                TRN_index_name,

            @TRN_FV_index_expected_keys =
                TRN_index_expected_keys,

            @TRN_FV_index_expected_includes =
                TRN_index_expected_includes,

            @TRN_FV_index_expected_data_space =
                TRN_index_expected_data_space,

            @TRN_FV_index_expected_part_col =
                TRN_index_partition_column

        FROM @TRN_FV_expected_indexes

        WHERE TRN_index_id =
            @TRN_FV_index_current_id;


        SELECT
            @TRN_FV_index_actual_name =
                i.name,

            @TRN_FV_index_actual_type =
                i.type,

            @TRN_FV_index_actual_unique =
                i.is_unique,

            @TRN_FV_index_actual_disabled =
                i.is_disabled,

            @TRN_FV_index_actual_hypothetical =
                i.is_hypothetical,

            @TRN_FV_index_actual_data_space =
                ds.name

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND i.name =
                @TRN_FV_index_expected_name;


        SELECT
            @TRN_FV_index_actual_keys =
                STRING_AGG
                (
                    CONVERT
                    (
                        nvarchar(max),
                        c.name
                        +
                        CASE
                            WHEN ic.is_descending_key = 1
                                THEN N' DESC'
                            ELSE N' ASC'
                        END
                    ),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY ic.key_ordinal
                )

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND i.name =
                @TRN_FV_index_expected_name;


        SELECT
            @TRN_FV_index_actual_includes =
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY ic.index_column_id
                )

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND i.name =
                @TRN_FV_index_expected_name;


        SET @TRN_FV_index_actual_includes =
            COALESCE
            (
                @TRN_FV_index_actual_includes,
                N'NONE'
            );


        SELECT
            @TRN_FV_index_actual_part_col =
                c.name

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.partition_ordinal = 1

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND i.name =
                @TRN_FV_index_expected_name;


        IF @TRN_FV_index_actual_name IS NULL

        OR @TRN_FV_index_actual_type <> 2
        OR @TRN_FV_index_actual_unique <> 0
        OR @TRN_FV_index_actual_disabled <> 0
        OR @TRN_FV_index_actual_hypothetical <> 0

        OR @TRN_FV_index_actual_keys <>
                @TRN_FV_index_expected_keys

        OR @TRN_FV_index_actual_includes <>
                @TRN_FV_index_expected_includes

        OR @TRN_FV_index_actual_data_space <>
                @TRN_FV_index_expected_data_space

        OR ISNULL(@TRN_FV_index_actual_part_col, N'') <>
                @TRN_FV_index_expected_part_col
        BEGIN

            SET @TRN_FV_invalid_indexes =
                @TRN_FV_invalid_indexes + 1;

        END;


        SET @TRN_FV_index_current_id =
            @TRN_FV_index_current_id + 1;

    END;


    IF @TRN_FV_invalid_indexes = 0
    BEGIN

        SET @TRN_FV_indexes_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRN_FV_indexes_status = N'FAILED';

        SET @TRN_FV_validation_errors =
            @TRN_FV_validation_errors + 1;

    END;

    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @TRN_FV_table_status;
    PRINT N'        Primary Key                   : ' + @TRN_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @TRN_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @TRN_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @TRN_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @TRN_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @TRN_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @TRN_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @TRN_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @TRN_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @TRN_FV_temporal_integrity_status;
    PRINT N'';

    IF @TRN_FV_validation_errors = 0
    BEGIN

        PRINT N'        Result                        : PASSED';

    END
    ELSE
    BEGIN

        PRINT N'        Result                        : FAILED';
        PRINT N'        Validation Errors             : '
            + CONVERT(nvarchar(10), @TRN_FV_validation_errors);

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @TRN_FV_validation_errors > 0
    BEGIN

        ;THROW 50059,
            N'Final validation failed for sales.Transaction.',
            1;

    END;