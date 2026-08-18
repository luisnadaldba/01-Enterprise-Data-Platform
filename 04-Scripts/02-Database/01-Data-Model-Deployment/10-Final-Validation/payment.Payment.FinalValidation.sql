    PRINT N'    payment.Payment';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PAY_FV_validation_errors int = 0;

    DECLARE @PAY_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAY_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAY_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAY_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAY_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAY_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAY_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAY_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PAY_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAY_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAY_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'payment.Payment', N'U') IS NOT NULL
    BEGIN
        SET @PAY_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAY_FV_table_status = N'FAILED';
        SET @PAY_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PAY_FV_pk_actual_name     sysname;
    DECLARE @PAY_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PAY_FV_pk_data_space      sysname;


    SELECT
        @PAY_FV_pk_actual_name = kc.name,
        @PAY_FV_pk_data_space = ds.name,

        @PAY_FV_pk_actual_columns =
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), c.name), N'|')
                WITHIN GROUP (ORDER BY ic.key_ordinal)

            FROM sys.index_columns AS ic

            INNER JOIN sys.columns AS c
                ON  c.object_id = ic.object_id
                AND c.column_id = ic.column_id

            WHERE ic.object_id = kc.parent_object_id
            AND ic.index_id = kc.unique_index_id
            AND ic.key_ordinal > 0
        )

    FROM sys.key_constraints AS kc

    INNER JOIN sys.indexes AS i
        ON  i.object_id = kc.parent_object_id
        AND i.index_id = kc.unique_index_id

    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id

    WHERE kc.parent_object_id =
            OBJECT_ID(N'payment.Payment')

    AND kc.type = N'PK';


    IF @PAY_FV_pk_actual_name = N'PK_PAY'
    AND @PAY_FV_pk_actual_columns = N'PAY_id'
    AND @PAY_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @PAY_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAY_FV_primary_key_status = N'FAILED';
        SET @PAY_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PAY_FV_expected_column_count int = 12;
    DECLARE @PAY_FV_actual_column_count   int;


    SELECT
        @PAY_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'payment.Payment');


    IF @PAY_FV_actual_column_count = @PAY_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_id'
        AND TYPE_NAME(c.user_type_id) = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'payment.Payment')
        AND ic.name = N'PAY_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_TRN_id'
        AND TYPE_NAME(c.user_type_id) = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_transaction_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_PAYME_id'
        AND TYPE_NAME(c.user_type_id) = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_PAYST_id'
        AND TYPE_NAME(c.user_type_id) = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_amount'
        AND TYPE_NAME(c.user_type_id) = N'decimal'
        AND c.precision = 19
        AND c.scale = 2
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_installment_count'
        AND TYPE_NAME(c.user_type_id) = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 1
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_attempted_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_approved_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_cancelled_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_created_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_updated_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @PAY_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAY_FV_columns_status = N'FAILED';
        SET @PAY_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PAY_FV_expected_documentation TABLE
    (
        PAY_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PAY_doc_object_type           nvarchar(10) NOT NULL,
        PAY_doc_column_name           sysname NULL,
        PAY_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @PAY_FV_doc_current_id        tinyint;
    DECLARE @PAY_FV_doc_max_id            tinyint;
    DECLARE @PAY_FV_doc_object_type       nvarchar(10);
    DECLARE @PAY_FV_doc_column_name       sysname;
    DECLARE @PAY_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PAY_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PAY_FV_invalid_documentation int = 0;


    INSERT INTO @PAY_FV_expected_documentation
    (
        PAY_doc_object_type,
        PAY_doc_column_name,
        PAY_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Records payment attempts associated with Atlas Commerce sales transactions, including payment method, status, amount, installment information and relevant business-event timestamps.'
    ),
    (
        N'COLUMN',
        N'PAY_id',
        N'Primary key of payment.Payment.'
    ),
    (
        N'COLUMN',
        N'PAY_TRN_id',
        N'Foreign key of sales.Transaction.'
    ),
    (
        N'COLUMN',
        N'PAY_transaction_at',
        N'Stores the originating sales transaction timestamp and participates with PAY_TRN_id in the composite foreign key to sales.Transaction.'
    ),
    (
        N'COLUMN',
        N'PAY_PAYME_id',
        N'Foreign key of payment.PaymentMethod.'
    ),
    (
        N'COLUMN',
        N'PAY_PAYST_id',
        N'Foreign key of payment.PaymentStatus.'
    ),
    (
        N'COLUMN',
        N'PAY_amount',
        N'Stores the monetary amount associated with the individual payment attempt or payment operation.'
    ),
    (
        N'COLUMN',
        N'PAY_installment_count',
        N'Stores the number of installments when the payment is installment-based; NULL when installments do not apply.'
    ),
    (
        N'COLUMN',
        N'PAY_attempted_at',
        N'Records the date and time when the payment attempt occurred.'
    ),
    (
        N'COLUMN',
        N'PAY_approved_at',
        N'Records the date and time when the payment was approved, when applicable.'
    ),
    (
        N'COLUMN',
        N'PAY_cancelled_at',
        N'Records the date and time when the payment was cancelled, when applicable.'
    ),
    (
        N'COLUMN',
        N'PAY_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'PAY_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @PAY_FV_doc_current_id = MIN(PAY_doc_id),
        @PAY_FV_doc_max_id = MAX(PAY_doc_id)

    FROM @PAY_FV_expected_documentation;


    WHILE @PAY_FV_doc_current_id <= @PAY_FV_doc_max_id
    BEGIN

        SET @PAY_FV_doc_object_type = NULL;
        SET @PAY_FV_doc_column_name = NULL;
        SET @PAY_FV_doc_expected_value = NULL;
        SET @PAY_FV_doc_actual_value = NULL;


        SELECT
            @PAY_FV_doc_object_type = PAY_doc_object_type,
            @PAY_FV_doc_column_name = PAY_doc_column_name,
            @PAY_FV_doc_expected_value = PAY_doc_expected_description

        FROM @PAY_FV_expected_documentation

        WHERE PAY_doc_id = @PAY_FV_doc_current_id;


        IF @PAY_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @PAY_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'payment.Payment')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @PAY_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'payment.Payment')
            AND ep.name = N'MS_Description'
            AND c.name = @PAY_FV_doc_column_name;

        END;


        IF ISNULL(@PAY_FV_doc_actual_value, N'') <>
            @PAY_FV_doc_expected_value
        BEGIN

            SET @PAY_FV_invalid_documentation += 1;

        END;


        SET @PAY_FV_doc_current_id += 1;

    END;


    IF @PAY_FV_invalid_documentation = 0
    BEGIN
        SET @PAY_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAY_FV_documentation_status = N'FAILED';
        SET @PAY_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'payment'
        AND PFX_table_name = N'Payment'
        AND PFX_prefix = N'PAY'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @PAY_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAY_FV_seed_data_status = N'FAILED';
        SET @PAY_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PAY_FV_expected_defaults TABLE
    (
        PAY_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        PAY_default_column_name          sysname NOT NULL,
        PAY_default_constraint_name      sysname NOT NULL,
        PAY_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @PAY_FV_default_current_id          tinyint;
    DECLARE @PAY_FV_default_max_id              tinyint;
    DECLARE @PAY_FV_default_column_name         sysname;
    DECLARE @PAY_FV_default_expected_name       sysname;
    DECLARE @PAY_FV_default_actual_name         sysname;
    DECLARE @PAY_FV_default_expected_definition nvarchar(4000);
    DECLARE @PAY_FV_default_actual_definition   nvarchar(4000);
    DECLARE @PAY_FV_default_expected_normalized nvarchar(4000);
    DECLARE @PAY_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @PAY_FV_invalid_defaults            int = 0;


    INSERT INTO @PAY_FV_expected_defaults
    (
        PAY_default_column_name,
        PAY_default_constraint_name,
        PAY_default_expected_definition
    )
    VALUES
    (
        N'PAY_created_at',
        N'DF_PAY_created_at',
        N'sysdatetime'
    ),
    (
        N'PAY_updated_at',
        N'DF_PAY_updated_at',
        N'sysdatetime'
    );


    SELECT
        @PAY_FV_default_current_id = MIN(PAY_default_id),
        @PAY_FV_default_max_id = MAX(PAY_default_id)

    FROM @PAY_FV_expected_defaults;


    WHILE @PAY_FV_default_current_id <= @PAY_FV_default_max_id
    BEGIN

        SET @PAY_FV_default_column_name = NULL;
        SET @PAY_FV_default_expected_name = NULL;
        SET @PAY_FV_default_actual_name = NULL;
        SET @PAY_FV_default_expected_definition = NULL;
        SET @PAY_FV_default_actual_definition = NULL;


        SELECT
            @PAY_FV_default_column_name = PAY_default_column_name,
            @PAY_FV_default_expected_name = PAY_default_constraint_name,
            @PAY_FV_default_expected_definition = PAY_default_expected_definition

        FROM @PAY_FV_expected_defaults

        WHERE PAY_default_id = @PAY_FV_default_current_id;


        SELECT
            @PAY_FV_default_actual_name = dc.name,
            @PAY_FV_default_actual_definition = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = @PAY_FV_default_column_name;


        SET @PAY_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @PAY_FV_default_expected_definition,
                            N'(',
                            N''
                        ),
                        N')',
                        N''
                    ),
                    N' ',
                    N''
                )
            );


        SET @PAY_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @PAY_FV_default_actual_definition,
                            N'(',
                            N''
                        ),
                        N')',
                        N''
                    ),
                    N' ',
                    N''
                )
            );


        IF @PAY_FV_default_actual_name IS NULL
        OR @PAY_FV_default_actual_name <> @PAY_FV_default_expected_name
        OR @PAY_FV_default_actual_definition IS NULL
        OR @PAY_FV_default_actual_normalized <>
                @PAY_FV_default_expected_normalized
        BEGIN

            SET @PAY_FV_invalid_defaults += 1;

        END;


        SET @PAY_FV_default_current_id += 1;

    END;


    IF @PAY_FV_invalid_defaults = 0
    BEGIN
        SET @PAY_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAY_FV_defaults_status = N'FAILED';
        SET @PAY_FV_validation_errors += 1;
    END;


    /*==========================================================================
        CHECK CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PAY_FV_invalid_checks int = 0;
    DECLARE @PAY_FV_check_actual_name          sysname;
    DECLARE @PAY_FV_check_actual_definition    nvarchar(4000);
    DECLARE @PAY_FV_check_normalized           nvarchar(4000);
    DECLARE @PAY_FV_check_is_disabled          bit;
    DECLARE @PAY_FV_check_is_not_trusted       bit;


    /*--------------------------------------------------------------------------
        CK_PAY_amount
    --------------------------------------------------------------------------*/

    SELECT
        @PAY_FV_check_actual_name = cc.name,
        @PAY_FV_check_actual_definition = cc.definition,
        @PAY_FV_check_is_disabled = cc.is_disabled,
        @PAY_FV_check_is_not_trusted = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id = OBJECT_ID(N'payment.Payment')
    AND cc.name = N'CK_PAY_amount';


    SET @PAY_FV_check_normalized =
        LOWER
        (
            REPLACE
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @PAY_FV_check_actual_definition,
                            N'[',
                            N''
                        ),
                        N']',
                        N''
                    ),
                    N' ',
                    N''
                ),
                NCHAR(9),
                N''
            )
        );


    IF @PAY_FV_check_actual_name <> N'CK_PAY_amount'
    OR @PAY_FV_check_normalized NOT LIKE N'%pay_amount>(0)%'
    OR @PAY_FV_check_is_disabled <> 0
    OR @PAY_FV_check_is_not_trusted <> 0
    BEGIN
        SET @PAY_FV_invalid_checks += 1;
    END;


    /*--------------------------------------------------------------------------
        CK_PAY_installment_count
    --------------------------------------------------------------------------*/

    SET @PAY_FV_check_actual_name = NULL;
    SET @PAY_FV_check_actual_definition = NULL;
    SET @PAY_FV_check_normalized = NULL;
    SET @PAY_FV_check_is_disabled = NULL;
    SET @PAY_FV_check_is_not_trusted = NULL;


    SELECT
        @PAY_FV_check_actual_name = cc.name,
        @PAY_FV_check_actual_definition = cc.definition,
        @PAY_FV_check_is_disabled = cc.is_disabled,
        @PAY_FV_check_is_not_trusted = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id = OBJECT_ID(N'payment.Payment')
    AND cc.name = N'CK_PAY_installment_count';


    SET @PAY_FV_check_normalized =
        LOWER
        (
            REPLACE(REPLACE(REPLACE(REPLACE(
                @PAY_FV_check_actual_definition,
                N'[', N''), N']', N''), N' ', N''), NCHAR(9), N'')
        );


    IF @PAY_FV_check_actual_name <> N'CK_PAY_installment_count'
    OR @PAY_FV_check_normalized NOT LIKE N'%pay_installment_countisnull%'
    OR @PAY_FV_check_normalized NOT LIKE N'%pay_installment_count>(1)%'
    OR @PAY_FV_check_is_disabled <> 0
    OR @PAY_FV_check_is_not_trusted <> 0
    BEGIN
        SET @PAY_FV_invalid_checks += 1;
    END;


    /*--------------------------------------------------------------------------
        CK_PAY_attempted_at
    --------------------------------------------------------------------------*/

    SET @PAY_FV_check_actual_name = NULL;
    SET @PAY_FV_check_actual_definition = NULL;
    SET @PAY_FV_check_normalized = NULL;
    SET @PAY_FV_check_is_disabled = NULL;
    SET @PAY_FV_check_is_not_trusted = NULL;


    SELECT
        @PAY_FV_check_actual_name = cc.name,
        @PAY_FV_check_actual_definition = cc.definition,
        @PAY_FV_check_is_disabled = cc.is_disabled,
        @PAY_FV_check_is_not_trusted = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id = OBJECT_ID(N'payment.Payment')
    AND cc.name = N'CK_PAY_attempted_at';


    SET @PAY_FV_check_normalized =
        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(
            @PAY_FV_check_actual_definition,
            N'[', N''), N']', N''), N' ', N''), NCHAR(9), N''));


    IF @PAY_FV_check_actual_name <> N'CK_PAY_attempted_at'
    OR @PAY_FV_check_normalized NOT LIKE N'%pay_attempted_at>=pay_transaction_at%'
    OR @PAY_FV_check_is_disabled <> 0
    OR @PAY_FV_check_is_not_trusted <> 0
    BEGIN
        SET @PAY_FV_invalid_checks += 1;
    END;


    /*--------------------------------------------------------------------------
        CK_PAY_approved_at
    --------------------------------------------------------------------------*/

    SET @PAY_FV_check_actual_name = NULL;
    SET @PAY_FV_check_actual_definition = NULL;
    SET @PAY_FV_check_normalized = NULL;
    SET @PAY_FV_check_is_disabled = NULL;
    SET @PAY_FV_check_is_not_trusted = NULL;


    SELECT
        @PAY_FV_check_actual_name = cc.name,
        @PAY_FV_check_actual_definition = cc.definition,
        @PAY_FV_check_is_disabled = cc.is_disabled,
        @PAY_FV_check_is_not_trusted = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id = OBJECT_ID(N'payment.Payment')
    AND cc.name = N'CK_PAY_approved_at';


    SET @PAY_FV_check_normalized =
        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(
            @PAY_FV_check_actual_definition,
            N'[', N''), N']', N''), N' ', N''), NCHAR(9), N''));


    IF @PAY_FV_check_actual_name <> N'CK_PAY_approved_at'
    OR @PAY_FV_check_normalized NOT LIKE N'%pay_approved_atisnull%'
    OR @PAY_FV_check_normalized NOT LIKE N'%pay_approved_at>=pay_attempted_at%'
    OR @PAY_FV_check_is_disabled <> 0
    OR @PAY_FV_check_is_not_trusted <> 0
    BEGIN
        SET @PAY_FV_invalid_checks += 1;
    END;


    /*--------------------------------------------------------------------------
        CK_PAY_cancelled_at
    --------------------------------------------------------------------------*/

    SET @PAY_FV_check_actual_name = NULL;
    SET @PAY_FV_check_actual_definition = NULL;
    SET @PAY_FV_check_normalized = NULL;
    SET @PAY_FV_check_is_disabled = NULL;
    SET @PAY_FV_check_is_not_trusted = NULL;


    SELECT
        @PAY_FV_check_actual_name = cc.name,
        @PAY_FV_check_actual_definition = cc.definition,
        @PAY_FV_check_is_disabled = cc.is_disabled,
        @PAY_FV_check_is_not_trusted = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id = OBJECT_ID(N'payment.Payment')
    AND cc.name = N'CK_PAY_cancelled_at';


    SET @PAY_FV_check_normalized =
        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(
            @PAY_FV_check_actual_definition,
            N'[', N''), N']', N''), N' ', N''), NCHAR(9), N''));


    IF @PAY_FV_check_actual_name <> N'CK_PAY_cancelled_at'
    OR @PAY_FV_check_normalized NOT LIKE N'%pay_cancelled_atisnull%'
    OR @PAY_FV_check_normalized NOT LIKE N'%pay_cancelled_at>=pay_attempted_at%'
    OR @PAY_FV_check_is_disabled <> 0
    OR @PAY_FV_check_is_not_trusted <> 0
    BEGIN
        SET @PAY_FV_invalid_checks += 1;
    END;


    IF @PAY_FV_invalid_checks = 0
    BEGIN
        SET @PAY_FV_checks_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAY_FV_checks_status = N'FAILED';
        SET @PAY_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PAY_FV_invalid_foreign_keys int = 0;


    /*--------------------------------------------------------------------------
        FK_PAY_TRN
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id = OBJECT_ID(N'payment.Payment')
        AND fk.referenced_object_id = OBJECT_ID(N'sales.[Transaction]')
        AND fk.name = N'FK_PAY_TRN'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0

        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id = fk.object_id
        ) = 2

        AND EXISTS
        (
            SELECT 1
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
            AND fkc.constraint_column_id = 1
            AND pc.name = N'PAY_TRN_id'
            AND rc.name = N'TRN_id'
        )

        AND EXISTS
        (
            SELECT 1
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
            AND fkc.constraint_column_id = 2
            AND pc.name = N'PAY_transaction_at'
            AND rc.name = N'TRN_transaction_at'
        )
    )
    BEGIN
        SET @PAY_FV_invalid_foreign_keys += 1;
    END;


    /*--------------------------------------------------------------------------
        FK_PAY_PAYME
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id = OBJECT_ID(N'payment.Payment')
        AND fk.referenced_object_id = OBJECT_ID(N'payment.PaymentMethod')
        AND fk.name = N'FK_PAY_PAYME'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0
        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id = fk.object_id
        ) = 1
        AND EXISTS
        (
            SELECT 1
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
            AND pc.name = N'PAY_PAYME_id'
            AND rc.name = N'PAYME_id'
        )
    )
    BEGIN
        SET @PAY_FV_invalid_foreign_keys += 1;
    END;


    /*--------------------------------------------------------------------------
        FK_PAY_PAYST
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id = OBJECT_ID(N'payment.Payment')
        AND fk.referenced_object_id = OBJECT_ID(N'payment.PaymentStatus')
        AND fk.name = N'FK_PAY_PAYST'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0
        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id = fk.object_id
        ) = 1
        AND EXISTS
        (
            SELECT 1
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
            AND pc.name = N'PAY_PAYST_id'
            AND rc.name = N'PAYST_id'
        )
    )
    BEGIN
        SET @PAY_FV_invalid_foreign_keys += 1;
    END;


    IF @PAY_FV_invalid_foreign_keys = 0
    BEGIN
        SET @PAY_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAY_FV_foreign_keys_status = N'FAILED';
        SET @PAY_FV_validation_errors += 1;
    END;


    /*==========================================================================
        ADDITIONAL INDEX VALIDATION
    ==========================================================================*/

    DECLARE @PAY_FV_invalid_indexes int = 0;


    /*--------------------------------------------------------------------------
        IX_PAY_TRN
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id = OBJECT_ID(N'payment.Payment')
        AND i.name = N'IX_PAY_TRN'
        AND i.type = 2
        AND i.is_unique = 0
        AND i.is_disabled = 0
        AND i.is_hypothetical = 0
        AND i.has_filter = 0
        AND ds.name = N'FG_CORE'

        AND
        (
            SELECT COUNT(*)
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ) = 2

        AND NOT EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
        )

        AND EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
                AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal = 1
            AND ic.is_descending_key = 0
            AND c.name = N'PAY_TRN_id'
        )

        AND EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
                AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal = 2
            AND ic.is_descending_key = 0
            AND c.name = N'PAY_transaction_at'
        )
    )
    BEGIN
        SET @PAY_FV_invalid_indexes += 1;
    END;


    /*--------------------------------------------------------------------------
        IX_PAY_updated_at
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id = OBJECT_ID(N'payment.Payment')
        AND i.name = N'IX_PAY_updated_at'
        AND i.type = 2
        AND i.is_unique = 0
        AND i.is_disabled = 0
        AND i.is_hypothetical = 0
        AND i.has_filter = 0
        AND ds.name = N'FG_CORE'

        AND
        (
            SELECT COUNT(*)
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ) = 1

        AND NOT EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
        )

        AND EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
                AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal = 1
            AND ic.is_descending_key = 0
            AND c.name = N'PAY_updated_at'
        )
    )
    BEGIN
        SET @PAY_FV_invalid_indexes += 1;
    END;


    IF @PAY_FV_invalid_indexes = 0
    BEGIN
        SET @PAY_FV_indexes_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAY_FV_indexes_status = N'FAILED';
        SET @PAY_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    PRINT N'        Table                         : ' + @PAY_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PAY_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PAY_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PAY_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PAY_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PAY_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PAY_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PAY_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PAY_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PAY_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @PAY_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @PAY_FV_validation_errors = 0
    BEGIN

        PRINT N'';
        PRINT N'        Result                        : PASSED';
        PRINT N'';

    END
    ELSE
    BEGIN

        PRINT N'';
        PRINT N'        Result                        : FAILED';

        PRINT N'        Validation Errors             : '
            + CONVERT(nvarchar(10), @PAY_FV_validation_errors);

        PRINT N'';


        ;THROW 51000,
            N'Final validation failed for payment.Payment.',
            1;

    END;


    PRINT N'';