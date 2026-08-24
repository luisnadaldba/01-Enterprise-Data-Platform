    PRINT N'    ● catalog.ProductAttribute';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PAT_FV_validation_errors int = 0;

    DECLARE @PAT_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAT_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAT_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAT_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAT_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @PAT_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAT_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PAT_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAT_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PAT_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PAT_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.ProductAttribute', N'U') IS NOT NULL
    BEGIN
        SET @PAT_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAT_FV_table_status = N'FAILED';
        SET @PAT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PAT_FV_pk_actual_name     sysname;
    DECLARE @PAT_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PAT_FV_pk_data_space      sysname;


    SELECT
        @PAT_FV_pk_actual_name = kc.name,
        @PAT_FV_pk_data_space = ds.name,
        @PAT_FV_pk_actual_columns =
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
    WHERE kc.parent_object_id = OBJECT_ID(N'catalog.ProductAttribute')
    AND kc.type = N'PK';


    IF @PAT_FV_pk_actual_name = N'PK_PAT'
    AND @PAT_FV_pk_actual_columns = N'PAT_id'
    AND @PAT_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @PAT_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAT_FV_primary_key_status = N'FAILED';
        SET @PAT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PAT_FV_expected_column_count int = 5;
    DECLARE @PAT_FV_actual_column_count   int;


    SELECT
        @PAT_FV_actual_column_count = COUNT(*)
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'catalog.ProductAttribute');


    IF @PAT_FV_actual_column_count = @PAT_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND c.name = N'PAT_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ic.name = N'PAT_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND c.name = N'PAT_name'
        AND t.name = N'nvarchar'
        AND c.max_length = 200
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND c.name = N'PAT_is_active'
        AND t.name = N'bit'
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND c.name = N'PAT_created_at'
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
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND c.name = N'PAT_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @PAT_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAT_FV_columns_status = N'FAILED';
        SET @PAT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PAT_FV_expected_documentation TABLE
    (
        PAT_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PAT_doc_object_type           nvarchar(10) NOT NULL,
        PAT_doc_column_name           sysname NULL,
        PAT_doc_expected_description  nvarchar(4000) NOT NULL
    );

    DECLARE @PAT_FV_doc_current_id        tinyint;
    DECLARE @PAT_FV_doc_max_id            tinyint;
    DECLARE @PAT_FV_doc_object_type       nvarchar(10);
    DECLARE @PAT_FV_doc_column_name       sysname;
    DECLARE @PAT_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PAT_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PAT_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            catalog.ProductAttribute.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @PAT_FV_expected_documentation
    (
        PAT_doc_object_type,
        PAT_doc_column_name,
        PAT_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the controlled set of reusable product attributes used to describe characteristics of products and their sellable variants.'
    ),
    (
        N'COLUMN',
        N'PAT_id',
        N'Primary key of catalog.ProductAttribute.'
    ),
    (
        N'COLUMN',
        N'PAT_name',
        N'Stores the name used to identify the product attribute in the catalog.'
    ),
    (
        N'COLUMN',
        N'PAT_is_active',
        N'Indicates whether the product attribute is currently available for use in catalog operations while preserving inactive attributes for historical integrity.'
    ),
    (
        N'COLUMN',
        N'PAT_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'PAT_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @PAT_FV_doc_current_id = MIN(PAT_doc_id),
        @PAT_FV_doc_max_id = MAX(PAT_doc_id)
    FROM @PAT_FV_expected_documentation;


    WHILE @PAT_FV_doc_current_id <= @PAT_FV_doc_max_id
    BEGIN
        SET @PAT_FV_doc_object_type = NULL;
        SET @PAT_FV_doc_column_name = NULL;
        SET @PAT_FV_doc_expected_value = NULL;
        SET @PAT_FV_doc_actual_value = NULL;

        SELECT
            @PAT_FV_doc_object_type = PAT_doc_object_type,
            @PAT_FV_doc_column_name = PAT_doc_column_name,
            @PAT_FV_doc_expected_value = PAT_doc_expected_description
        FROM @PAT_FV_expected_documentation
        WHERE PAT_doc_id = @PAT_FV_doc_current_id;

        IF @PAT_FV_doc_object_type = N'TABLE'
        BEGIN
            SELECT
                @PAT_FV_doc_actual_value = CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';
        END
        ELSE
        BEGIN
            SELECT
                @PAT_FV_doc_actual_value = CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id
            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
            AND ep.name = N'MS_Description'
            AND c.name = @PAT_FV_doc_column_name;
        END;

        IF ISNULL(@PAT_FV_doc_actual_value, N'') <> @PAT_FV_doc_expected_value
        BEGIN
            SET @PAT_FV_invalid_documentation += 1;
        END;

        SET @PAT_FV_doc_current_id += 1;
    END;


    IF @PAT_FV_invalid_documentation = 0
    BEGIN
        SET @PAT_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAT_FV_documentation_status = N'FAILED';
        SET @PAT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PAT_FV_expected_defaults TABLE
    (
        PAT_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        PAT_default_column_name          sysname NOT NULL,
        PAT_default_constraint_name      sysname NOT NULL,
        PAT_default_expected_definition  nvarchar(4000) NOT NULL
    );

    DECLARE @PAT_FV_default_current_id          tinyint;
    DECLARE @PAT_FV_default_max_id              tinyint;
    DECLARE @PAT_FV_default_column_name         sysname;
    DECLARE @PAT_FV_default_expected_name       sysname;
    DECLARE @PAT_FV_default_actual_name         sysname;
    DECLARE @PAT_FV_default_expected_definition nvarchar(4000);
    DECLARE @PAT_FV_default_actual_definition   nvarchar(4000);
    DECLARE @PAT_FV_default_expected_normalized nvarchar(4000);
    DECLARE @PAT_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @PAT_FV_invalid_defaults            int = 0;


    INSERT INTO @PAT_FV_expected_defaults
    (
        PAT_default_column_name,
        PAT_default_constraint_name,
        PAT_default_expected_definition
    )
    VALUES
    (N'PAT_is_active',  N'DF_PAT_is_active',  N'1'),
    (N'PAT_created_at', N'DF_PAT_created_at', N'sysdatetime'),
    (N'PAT_updated_at', N'DF_PAT_updated_at', N'sysdatetime');


    SELECT
        @PAT_FV_default_current_id = MIN(PAT_default_id),
        @PAT_FV_default_max_id = MAX(PAT_default_id)
    FROM @PAT_FV_expected_defaults;


    WHILE @PAT_FV_default_current_id <= @PAT_FV_default_max_id
    BEGIN
        SET @PAT_FV_default_column_name = NULL;
        SET @PAT_FV_default_expected_name = NULL;
        SET @PAT_FV_default_actual_name = NULL;
        SET @PAT_FV_default_expected_definition = NULL;
        SET @PAT_FV_default_actual_definition = NULL;

        SELECT
            @PAT_FV_default_column_name = PAT_default_column_name,
            @PAT_FV_default_expected_name = PAT_default_constraint_name,
            @PAT_FV_default_expected_definition = PAT_default_expected_definition
        FROM @PAT_FV_expected_defaults
        WHERE PAT_default_id = @PAT_FV_default_current_id;

        SELECT
            @PAT_FV_default_actual_name = dc.name,
            @PAT_FV_default_actual_definition = dc.definition
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND c.name = @PAT_FV_default_column_name;

        SET @PAT_FV_default_expected_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(@PAT_FV_default_expected_definition, N'(', N''), N')', N''), N' ', N''));

        SET @PAT_FV_default_actual_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(@PAT_FV_default_actual_definition, N'(', N''), N')', N''), N' ', N''));

        IF @PAT_FV_default_actual_name IS NULL
        OR @PAT_FV_default_actual_name <> @PAT_FV_default_expected_name
        OR @PAT_FV_default_actual_definition IS NULL
        OR @PAT_FV_default_actual_normalized <> @PAT_FV_default_expected_normalized
        BEGIN
            SET @PAT_FV_invalid_defaults += 1;
        END;

        SET @PAT_FV_default_current_id += 1;
    END;


    IF @PAT_FV_invalid_defaults = 0
    BEGIN
        SET @PAT_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAT_FV_defaults_status = N'FAILED';
        SET @PAT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PAT_FV_uq_actual_name        sysname;
    DECLARE @PAT_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @PAT_FV_uq_actual_disabled    bit;
    DECLARE @PAT_FV_uq_actual_data_space  sysname;


    SELECT
        @PAT_FV_uq_actual_name = kc.name,
        @PAT_FV_uq_actual_disabled = i.is_disabled,
        @PAT_FV_uq_actual_data_space = ds.name,
        @PAT_FV_uq_actual_columns =
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
    WHERE kc.parent_object_id = OBJECT_ID(N'catalog.ProductAttribute')
    AND kc.type = N'UQ'
    AND kc.name = N'UQ_PAT_name';


    IF @PAT_FV_uq_actual_name = N'UQ_PAT_name'
    AND @PAT_FV_uq_actual_columns = N'PAT_name'
    AND @PAT_FV_uq_actual_disabled = 0
    AND @PAT_FV_uq_actual_data_space = N'FG_CORE'
    BEGIN
        SET @PAT_FV_uniques_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAT_FV_uniques_status = N'FAILED';
        SET @PAT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @PAT_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PAT_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PAT_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PAT_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PAT_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PAT_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PAT_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PAT_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PAT_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PAT_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @PAT_FV_temporal_integrity_status;
    PRINT N'';

    IF @PAT_FV_validation_errors = 0
    BEGIN

        PRINT N'        Result                        : PASSED';

    END
    ELSE
    BEGIN

        PRINT N'        Result                        : FAILED';

        PRINT N'        Validation Errors             : '
            + CONVERT(nvarchar(10), @PAT_FV_validation_errors);

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @PAT_FV_validation_errors > 0
    BEGIN

        ;THROW 50210,
            N'Final validation failed for catalog.ProductAttribute.',
            1;

    END;