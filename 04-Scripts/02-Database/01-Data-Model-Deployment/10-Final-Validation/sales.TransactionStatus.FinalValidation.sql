    PRINT N'    sales.TransactionStatus';
    PRINT N'    --------------------------------------------------------------------------';

    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @TRNST_FV_validation_errors int = 0;

    DECLARE @TRNST_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNST_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNST_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNST_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNST_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNST_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNST_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @TRNST_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNST_FV_foreign_keys_status        nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @TRNST_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @TRNST_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'sales.TransactionStatus', N'U') IS NOT NULL
    BEGIN
        SET @TRNST_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNST_FV_table_status = N'FAILED';
        SET @TRNST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @TRNST_FV_pk_actual_name     sysname;
    DECLARE @TRNST_FV_pk_actual_columns  nvarchar(4000);

    SELECT
        @TRNST_FV_pk_actual_name = kc.name,

        @TRNST_FV_pk_actual_columns =
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

            WHERE ic.object_id = kc.parent_object_id
            AND ic.index_id = kc.unique_index_id
            AND ic.key_ordinal > 0
        )

    FROM sys.key_constraints AS kc

    WHERE kc.parent_object_id =
            OBJECT_ID(N'sales.TransactionStatus')

    AND kc.type = N'PK';


    IF @TRNST_FV_pk_actual_name = N'PK_TRNST'
    AND @TRNST_FV_pk_actual_columns = N'TRNST_id'
    BEGIN
        SET @TRNST_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNST_FV_primary_key_status = N'FAILED';
        SET @TRNST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @TRNST_FV_expected_column_count int = 6;
    DECLARE @TRNST_FV_actual_column_count   int;

    SELECT
        @TRNST_FV_actual_column_count = COUNT(*)
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'sales.TransactionStatus');


    IF @TRNST_FV_actual_column_count = @TRNST_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionStatus')
        AND c.name = N'TRNST_id'
        AND t.name = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'sales.TransactionStatus')
        AND ic.name = N'TRNST_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionStatus')
        AND c.name = N'TRNST_code'
        AND t.name = N'varchar'
        AND c.max_length = 30
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionStatus')
        AND c.name = N'TRNST_name'
        AND t.name = N'varchar'
        AND c.max_length = 100
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionStatus')
        AND c.name = N'TRNST_is_active'
        AND t.name = N'bit'
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionStatus')
        AND c.name = N'TRNST_created_at'
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
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionStatus')
        AND c.name = N'TRNST_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @TRNST_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNST_FV_columns_status = N'FAILED';
        SET @TRNST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @TRNST_FV_expected_documentation TABLE
    (
        TRNST_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        TRNST_doc_object_type           nvarchar(10) NOT NULL,
        TRNST_doc_column_name           sysname NULL,
        TRNST_doc_expected_description  nvarchar(4000) NOT NULL
    );

    DECLARE @TRNST_FV_doc_current_id        tinyint;
    DECLARE @TRNST_FV_doc_max_id            tinyint;
    DECLARE @TRNST_FV_doc_object_type       nvarchar(10);
    DECLARE @TRNST_FV_doc_column_name       sysname;
    DECLARE @TRNST_FV_doc_expected_value    nvarchar(4000);
    DECLARE @TRNST_FV_doc_actual_value      nvarchar(4000);
    DECLARE @TRNST_FV_invalid_documentation int = 0;


    INSERT INTO @TRNST_FV_expected_documentation
    (
        TRNST_doc_object_type,
        TRNST_doc_column_name,
        TRNST_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the authoritative set of transaction statuses used by the sales transactional model.'
    ),
    (
        N'COLUMN',
        N'TRNST_id',
        N'Primary key of sales.TransactionStatus.'
    ),
    (
        N'COLUMN',
        N'TRNST_code',
        N'Stores the stable system code that uniquely identifies the transaction status.'
    ),
    (
        N'COLUMN',
        N'TRNST_name',
        N'Stores the human-readable name of the transaction status for presentation purposes.'
    ),
    (
        N'COLUMN',
        N'TRNST_is_active',
        N'Indicates whether the transaction status is currently available for operational use while preserving inactive statuses for historical integrity.'
    ),
    (
        N'COLUMN',
        N'TRNST_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'TRNST_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @TRNST_FV_doc_current_id = MIN(TRNST_doc_id),
        @TRNST_FV_doc_max_id = MAX(TRNST_doc_id)
    FROM @TRNST_FV_expected_documentation;


    WHILE @TRNST_FV_doc_current_id <= @TRNST_FV_doc_max_id
    BEGIN

        SET @TRNST_FV_doc_object_type = NULL;
        SET @TRNST_FV_doc_column_name = NULL;
        SET @TRNST_FV_doc_expected_value = NULL;
        SET @TRNST_FV_doc_actual_value = NULL;


        SELECT
            @TRNST_FV_doc_object_type =
                TRNST_doc_object_type,

            @TRNST_FV_doc_column_name =
                TRNST_doc_column_name,

            @TRNST_FV_doc_expected_value =
                TRNST_doc_expected_description

        FROM @TRNST_FV_expected_documentation
        WHERE TRNST_doc_id = @TRNST_FV_doc_current_id;


        IF @TRNST_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @TRNST_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'sales.TransactionStatus')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @TRNST_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'sales.TransactionStatus')
            AND ep.name = N'MS_Description'
            AND c.name = @TRNST_FV_doc_column_name;

        END;


        IF ISNULL(@TRNST_FV_doc_actual_value, N'') <>
        @TRNST_FV_doc_expected_value
        BEGIN
            SET @TRNST_FV_invalid_documentation += 1;
        END;


        SET @TRNST_FV_doc_current_id += 1;

    END;


    IF @TRNST_FV_invalid_documentation = 0
    BEGIN
        SET @TRNST_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNST_FV_documentation_status = N'FAILED';
        SET @TRNST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    DECLARE @TRNST_FV_invalid_seed int = 0;


    /*----------------------------------------------------------------------
        EXPECT EXACTLY THE FOUR CONTRACTED STATUS CODES
    ----------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)
        FROM sales.TransactionStatus
    ) <> 4
    BEGIN
        SET @TRNST_FV_invalid_seed += 1;
    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM sales.TransactionStatus
        WHERE TRNST_code = N'PENDING'
        AND TRNST_name = N'Pending'
        AND TRNST_is_active = 1
    )
    BEGIN
        SET @TRNST_FV_invalid_seed += 1;
    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM sales.TransactionStatus
        WHERE TRNST_code = N'CONFIRMED'
        AND TRNST_name = N'Confirmed'
        AND TRNST_is_active = 1
    )
    BEGIN
        SET @TRNST_FV_invalid_seed += 1;
    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM sales.TransactionStatus
        WHERE TRNST_code = N'CANCELLED'
        AND TRNST_name = N'Cancelled'
        AND TRNST_is_active = 1
    )
    BEGIN
        SET @TRNST_FV_invalid_seed += 1;
    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM sales.TransactionStatus
        WHERE TRNST_code = N'FAILED'
        AND TRNST_name = N'Failed'
        AND TRNST_is_active = 1
    )
    BEGIN
        SET @TRNST_FV_invalid_seed += 1;
    END;


    IF @TRNST_FV_invalid_seed = 0
    BEGIN
        SET @TRNST_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNST_FV_seed_data_status = N'FAILED';
        SET @TRNST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @TRNST_FV_expected_defaults TABLE
    (
        TRNST_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        TRNST_default_column_name          sysname NOT NULL,
        TRNST_default_constraint_name      sysname NOT NULL,
        TRNST_default_expected_definition  nvarchar(4000) NOT NULL
    );

    DECLARE @TRNST_FV_default_current_id          tinyint;
    DECLARE @TRNST_FV_default_max_id              tinyint;
    DECLARE @TRNST_FV_default_column_name         sysname;
    DECLARE @TRNST_FV_default_expected_name       sysname;
    DECLARE @TRNST_FV_default_actual_name         sysname;
    DECLARE @TRNST_FV_default_expected_definition nvarchar(4000);
    DECLARE @TRNST_FV_default_actual_definition   nvarchar(4000);
    DECLARE @TRNST_FV_default_expected_normalized nvarchar(4000);
    DECLARE @TRNST_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @TRNST_FV_invalid_defaults            int = 0;


    INSERT INTO @TRNST_FV_expected_defaults
    (
        TRNST_default_column_name,
        TRNST_default_constraint_name,
        TRNST_default_expected_definition
    )
    VALUES
    (
        N'TRNST_is_active',
        N'DF_TRNST_is_active',
        N'1'
    ),
    (
        N'TRNST_created_at',
        N'DF_TRNST_created_at',
        N'sysdatetime'
    ),
    (
        N'TRNST_updated_at',
        N'DF_TRNST_updated_at',
        N'sysdatetime'
    );


    SELECT
        @TRNST_FV_default_current_id = MIN(TRNST_default_id),
        @TRNST_FV_default_max_id = MAX(TRNST_default_id)
    FROM @TRNST_FV_expected_defaults;


    WHILE @TRNST_FV_default_current_id <= @TRNST_FV_default_max_id
    BEGIN

        SET @TRNST_FV_default_column_name = NULL;
        SET @TRNST_FV_default_expected_name = NULL;
        SET @TRNST_FV_default_actual_name = NULL;
        SET @TRNST_FV_default_expected_definition = NULL;
        SET @TRNST_FV_default_actual_definition = NULL;


        SELECT
            @TRNST_FV_default_column_name =
                TRNST_default_column_name,

            @TRNST_FV_default_expected_name =
                TRNST_default_constraint_name,

            @TRNST_FV_default_expected_definition =
                TRNST_default_expected_definition

        FROM @TRNST_FV_expected_defaults
        WHERE TRNST_default_id = @TRNST_FV_default_current_id;


        SELECT
            @TRNST_FV_default_actual_name =
                dc.name,

            @TRNST_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND c.name =
                @TRNST_FV_default_column_name;


        SET @TRNST_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @TRNST_FV_default_expected_definition,
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


        SET @TRNST_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @TRNST_FV_default_actual_definition,
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


        IF @TRNST_FV_default_actual_name IS NULL
        OR @TRNST_FV_default_actual_name <>
                @TRNST_FV_default_expected_name
        OR @TRNST_FV_default_actual_definition IS NULL
        OR @TRNST_FV_default_actual_normalized <>
                @TRNST_FV_default_expected_normalized
        BEGIN
            SET @TRNST_FV_invalid_defaults += 1;
        END;


        SET @TRNST_FV_default_current_id += 1;

    END;


    IF @TRNST_FV_invalid_defaults = 0
    BEGIN
        SET @TRNST_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNST_FV_defaults_status = N'FAILED';
        SET @TRNST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @TRNST_FV_uq_actual_name        sysname;
    DECLARE @TRNST_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @TRNST_FV_uq_actual_disabled    bit;
    DECLARE @TRNST_FV_uq_actual_data_space  sysname;


    SELECT
        @TRNST_FV_uq_actual_name =
            kc.name,

        @TRNST_FV_uq_actual_disabled =
            i.is_disabled,

        @TRNST_FV_uq_actual_data_space =
            ds.name,

        @TRNST_FV_uq_actual_columns =
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
            OBJECT_ID(N'sales.TransactionStatus')

    AND kc.type = N'UQ'

    AND kc.name = N'UQ_TRNST_code';


    IF @TRNST_FV_uq_actual_name = N'UQ_TRNST_code'
    AND @TRNST_FV_uq_actual_columns = N'TRNST_code'
    AND @TRNST_FV_uq_actual_disabled = 0
    AND @TRNST_FV_uq_actual_data_space = N'FG_CORE'
    BEGIN
        SET @TRNST_FV_uniques_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNST_FV_uniques_status = N'FAILED';
        SET @TRNST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    PRINT N'        Table                         : ' + @TRNST_FV_table_status;
    PRINT N'        Primary Key                   : ' + @TRNST_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @TRNST_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @TRNST_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @TRNST_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @TRNST_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @TRNST_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @TRNST_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @TRNST_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @TRNST_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @TRNST_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @TRNST_FV_validation_errors = 0
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
            + CONVERT(nvarchar(10), @TRNST_FV_validation_errors);
        PRINT N'';

        ;THROW 50075,
            N'Final validation failed for sales.TransactionStatus.',
            1;

    END;


    PRINT N'';