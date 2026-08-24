    PRINT N'    ● sales.TransactionChannel';

    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @TRNCH_FV_validation_errors int = 0;

    DECLARE @TRNCH_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNCH_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNCH_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNCH_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNCH_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNCH_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNCH_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @TRNCH_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNCH_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @TRNCH_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @TRNCH_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'sales.TransactionChannel', N'U') IS NOT NULL
    BEGIN
        SET @TRNCH_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNCH_FV_table_status = N'FAILED';
        SET @TRNCH_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @TRNCH_FV_pk_actual_name     sysname;
    DECLARE @TRNCH_FV_pk_actual_columns  nvarchar(4000);

    SELECT
        @TRNCH_FV_pk_actual_name = kc.name,

        @TRNCH_FV_pk_actual_columns =
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
            OBJECT_ID(N'sales.TransactionChannel')

    AND kc.type = N'PK';


    IF @TRNCH_FV_pk_actual_name = N'PK_TRNCH'
    AND @TRNCH_FV_pk_actual_columns = N'TRNCH_id'
    BEGIN
        SET @TRNCH_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNCH_FV_primary_key_status = N'FAILED';
        SET @TRNCH_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @TRNCH_FV_expected_column_count int = 6;
    DECLARE @TRNCH_FV_actual_column_count   int;

    SELECT
        @TRNCH_FV_actual_column_count = COUNT(*)
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'sales.TransactionChannel');


    IF @TRNCH_FV_actual_column_count = @TRNCH_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
        AND c.name = N'TRNCH_id'
        AND t.name = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ic.name = N'TRNCH_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
        AND c.name = N'TRNCH_code'
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
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
        AND c.name = N'TRNCH_name'
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
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
        AND c.name = N'TRNCH_is_active'
        AND t.name = N'bit'
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
        AND c.name = N'TRNCH_created_at'
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
        WHERE c.object_id = OBJECT_ID(N'sales.TransactionChannel')
        AND c.name = N'TRNCH_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @TRNCH_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNCH_FV_columns_status = N'FAILED';
        SET @TRNCH_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @TRNCH_FV_expected_documentation TABLE
    (
        TRNCH_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        TRNCH_doc_object_type           nvarchar(10) NOT NULL,
        TRNCH_doc_column_name           sysname NULL,
        TRNCH_doc_expected_description  nvarchar(4000) NOT NULL
    );

    DECLARE @TRNCH_FV_doc_current_id        tinyint;
    DECLARE @TRNCH_FV_doc_max_id            tinyint;
    DECLARE @TRNCH_FV_doc_object_type       nvarchar(10);
    DECLARE @TRNCH_FV_doc_column_name       sysname;
    DECLARE @TRNCH_FV_doc_expected_value    nvarchar(4000);
    DECLARE @TRNCH_FV_doc_actual_value      nvarchar(4000);
    DECLARE @TRNCH_FV_invalid_documentation int = 0;


    INSERT INTO @TRNCH_FV_expected_documentation
    (
        TRNCH_doc_object_type,
        TRNCH_doc_column_name,
        TRNCH_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the controlled transaction channels used to classify how sales transactions are originated in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'TRNCH_id',
        N'Primary key of sales.TransactionChannel.'
    ),
    (
        N'COLUMN',
        N'TRNCH_code',
        N'Stores the stable system code that uniquely identifies the transaction channel.'
    ),
    (
        N'COLUMN',
        N'TRNCH_name',
        N'Provides the business description associated with the transaction channel code.'
    ),
    (
        N'COLUMN',
        N'TRNCH_is_active',
        N'Indicates whether the transaction channel is currently available for operational use while preserving inactive channels for historical integrity.'
    ),
    (
        N'COLUMN',
        N'TRNCH_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'TRNCH_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @TRNCH_FV_doc_current_id = MIN(TRNCH_doc_id),
        @TRNCH_FV_doc_max_id = MAX(TRNCH_doc_id)
    FROM @TRNCH_FV_expected_documentation;


    WHILE @TRNCH_FV_doc_current_id <= @TRNCH_FV_doc_max_id
    BEGIN

        SET @TRNCH_FV_doc_object_type = NULL;
        SET @TRNCH_FV_doc_column_name = NULL;
        SET @TRNCH_FV_doc_expected_value = NULL;
        SET @TRNCH_FV_doc_actual_value = NULL;


        SELECT
            @TRNCH_FV_doc_object_type =
                TRNCH_doc_object_type,

            @TRNCH_FV_doc_column_name =
                TRNCH_doc_column_name,

            @TRNCH_FV_doc_expected_value =
                TRNCH_doc_expected_description

        FROM @TRNCH_FV_expected_documentation
        WHERE TRNCH_doc_id = @TRNCH_FV_doc_current_id;


        IF @TRNCH_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @TRNCH_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @TRNCH_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
            AND ep.name = N'MS_Description'
            AND c.name = @TRNCH_FV_doc_column_name;

        END;


        IF ISNULL(@TRNCH_FV_doc_actual_value, N'') <>
        @TRNCH_FV_doc_expected_value
        BEGIN
            SET @TRNCH_FV_invalid_documentation += 1;
        END;


        SET @TRNCH_FV_doc_current_id += 1;

    END;


    IF @TRNCH_FV_invalid_documentation = 0
    BEGIN
        SET @TRNCH_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNCH_FV_documentation_status = N'FAILED';
        SET @TRNCH_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    DECLARE @TRNCH_FV_invalid_seed int = 0;


    /*----------------------------------------------------------------------
        EXPECT EXACTLY THE TWO CONTRACTED CHANNEL CODES
    ----------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)
        FROM sales.TransactionChannel
    ) <> 2
    BEGIN
        SET @TRNCH_FV_invalid_seed += 1;
    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM sales.TransactionChannel
        WHERE TRNCH_code = N'ONLINE'
        AND TRNCH_name = N'Online transaction'
        AND TRNCH_is_active = 1
    )
    BEGIN
        SET @TRNCH_FV_invalid_seed += 1;
    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM sales.TransactionChannel
        WHERE TRNCH_code = N'STORE'
        AND TRNCH_name = N'Physical store transaction'
        AND TRNCH_is_active = 1
    )
    BEGIN
        SET @TRNCH_FV_invalid_seed += 1;
    END;


    IF @TRNCH_FV_invalid_seed = 0
    BEGIN
        SET @TRNCH_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNCH_FV_seed_data_status = N'FAILED';
        SET @TRNCH_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @TRNCH_FV_expected_defaults TABLE
    (
        TRNCH_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        TRNCH_default_column_name          sysname NOT NULL,
        TRNCH_default_constraint_name      sysname NOT NULL,
        TRNCH_default_expected_definition  nvarchar(4000) NOT NULL
    );

    DECLARE @TRNCH_FV_default_current_id          tinyint;
    DECLARE @TRNCH_FV_default_max_id              tinyint;
    DECLARE @TRNCH_FV_default_column_name         sysname;
    DECLARE @TRNCH_FV_default_expected_name       sysname;
    DECLARE @TRNCH_FV_default_actual_name         sysname;
    DECLARE @TRNCH_FV_default_expected_definition nvarchar(4000);
    DECLARE @TRNCH_FV_default_actual_definition   nvarchar(4000);
    DECLARE @TRNCH_FV_default_expected_normalized nvarchar(4000);
    DECLARE @TRNCH_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @TRNCH_FV_invalid_defaults            int = 0;


    INSERT INTO @TRNCH_FV_expected_defaults
    (
        TRNCH_default_column_name,
        TRNCH_default_constraint_name,
        TRNCH_default_expected_definition
    )
    VALUES
    (
        N'TRNCH_is_active',
        N'DF_TRNCH_is_active',
        N'1'
    ),
    (
        N'TRNCH_created_at',
        N'DF_TRNCH_created_at',
        N'sysdatetime'
    ),
    (
        N'TRNCH_updated_at',
        N'DF_TRNCH_updated_at',
        N'sysdatetime'
    );


    SELECT
        @TRNCH_FV_default_current_id = MIN(TRNCH_default_id),
        @TRNCH_FV_default_max_id = MAX(TRNCH_default_id)
    FROM @TRNCH_FV_expected_defaults;


    WHILE @TRNCH_FV_default_current_id <= @TRNCH_FV_default_max_id
    BEGIN

        SET @TRNCH_FV_default_column_name = NULL;
        SET @TRNCH_FV_default_expected_name = NULL;
        SET @TRNCH_FV_default_actual_name = NULL;
        SET @TRNCH_FV_default_expected_definition = NULL;
        SET @TRNCH_FV_default_actual_definition = NULL;


        SELECT
            @TRNCH_FV_default_column_name =
                TRNCH_default_column_name,

            @TRNCH_FV_default_expected_name =
                TRNCH_default_constraint_name,

            @TRNCH_FV_default_expected_definition =
                TRNCH_default_expected_definition

        FROM @TRNCH_FV_expected_defaults
        WHERE TRNCH_default_id = @TRNCH_FV_default_current_id;


        SELECT
            @TRNCH_FV_default_actual_name =
                dc.name,

            @TRNCH_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'sales.TransactionChannel')

        AND c.name =
                @TRNCH_FV_default_column_name;


        SET @TRNCH_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @TRNCH_FV_default_expected_definition,
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


        SET @TRNCH_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @TRNCH_FV_default_actual_definition,
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


        IF @TRNCH_FV_default_actual_name IS NULL
        OR @TRNCH_FV_default_actual_name <>
                @TRNCH_FV_default_expected_name
        OR @TRNCH_FV_default_actual_definition IS NULL
        OR @TRNCH_FV_default_actual_normalized <>
                @TRNCH_FV_default_expected_normalized
        BEGIN
            SET @TRNCH_FV_invalid_defaults += 1;
        END;


        SET @TRNCH_FV_default_current_id += 1;

    END;


    IF @TRNCH_FV_invalid_defaults = 0
    BEGIN
        SET @TRNCH_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNCH_FV_defaults_status = N'FAILED';
        SET @TRNCH_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @TRNCH_FV_uq_actual_name        sysname;
    DECLARE @TRNCH_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @TRNCH_FV_uq_actual_disabled    bit;
    DECLARE @TRNCH_FV_uq_actual_data_space  sysname;


    SELECT
        @TRNCH_FV_uq_actual_name =
            kc.name,

        @TRNCH_FV_uq_actual_disabled =
            i.is_disabled,

        @TRNCH_FV_uq_actual_data_space =
            ds.name,

        @TRNCH_FV_uq_actual_columns =
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
            OBJECT_ID(N'sales.TransactionChannel')

    AND kc.type = N'UQ'

    AND kc.name = N'UQ_TRNCH_code';


    IF @TRNCH_FV_uq_actual_name = N'UQ_TRNCH_code'
    AND @TRNCH_FV_uq_actual_columns = N'TRNCH_code'
    AND @TRNCH_FV_uq_actual_disabled = 0
    AND @TRNCH_FV_uq_actual_data_space = N'FG_CORE'
    BEGIN
        SET @TRNCH_FV_uniques_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNCH_FV_uniques_status = N'FAILED';
        SET @TRNCH_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @TRNCH_FV_table_status;
    PRINT N'        Primary Key                   : ' + @TRNCH_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @TRNCH_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @TRNCH_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @TRNCH_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @TRNCH_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @TRNCH_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @TRNCH_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @TRNCH_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @TRNCH_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @TRNCH_FV_temporal_integrity_status;
    PRINT N'';

    IF @TRNCH_FV_validation_errors = 0
    BEGIN

        PRINT N'        Result                        : PASSED';

    END
    ELSE
    BEGIN

        PRINT N'        Result                        : FAILED';
        PRINT N'        Validation Errors             : '
            + CONVERT(nvarchar(10), @TRNCH_FV_validation_errors);

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @TRNCH_FV_validation_errors > 0
    BEGIN

        ;THROW 50091,
            N'Final validation failed for sales.TransactionChannel.',
            1;

    END;