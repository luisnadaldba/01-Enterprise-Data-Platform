    PRINT N'    ● catalog.ProductAttributeValue';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PATVL_FV_validation_errors int = 0;

    DECLARE @PATVL_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PATVL_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PATVL_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PATVL_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PATVL_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @PATVL_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PATVL_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PATVL_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PATVL_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PATVL_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PATVL_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.ProductAttributeValue', N'U') IS NOT NULL
    BEGIN
        SET @PATVL_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PATVL_FV_table_status = N'FAILED';
        SET @PATVL_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PATVL_FV_pk_actual_name     sysname;
    DECLARE @PATVL_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PATVL_FV_pk_data_space      sysname;


    SELECT
        @PATVL_FV_pk_actual_name = kc.name,
        @PATVL_FV_pk_data_space = ds.name,
        @PATVL_FV_pk_actual_columns =
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
    WHERE kc.parent_object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
    AND kc.type = N'PK';


    IF @PATVL_FV_pk_actual_name = N'PK_PATVL'
    AND @PATVL_FV_pk_actual_columns = N'PATVL_id'
    AND @PATVL_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @PATVL_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PATVL_FV_primary_key_status = N'FAILED';
        SET @PATVL_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PATVL_FV_expected_column_count int = 6;
    DECLARE @PATVL_FV_actual_column_count   int;


    SELECT
        @PATVL_FV_actual_column_count = COUNT(*)
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'catalog.ProductAttributeValue');


    IF @PATVL_FV_actual_column_count = @PATVL_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND c.name = N'PATVL_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ic.name = N'PATVL_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND c.name = N'PATVL_PAT_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND c.name = N'PATVL_value'
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
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND c.name = N'PATVL_is_active'
        AND t.name = N'bit'
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND c.name = N'PATVL_created_at'
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
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND c.name = N'PATVL_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @PATVL_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PATVL_FV_columns_status = N'FAILED';
        SET @PATVL_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PATVL_FV_expected_documentation TABLE
    (
        PATVL_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PATVL_doc_object_type           nvarchar(10) NOT NULL,
        PATVL_doc_column_name           sysname NULL,
        PATVL_doc_expected_description  nvarchar(4000) NOT NULL
    );

    DECLARE @PATVL_FV_doc_current_id        tinyint;
    DECLARE @PATVL_FV_doc_max_id            tinyint;
    DECLARE @PATVL_FV_doc_object_type       nvarchar(10);
    DECLARE @PATVL_FV_doc_column_name       sysname;
    DECLARE @PATVL_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PATVL_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PATVL_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            catalog.ProductAttributeValue.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @PATVL_FV_expected_documentation
    (
        PATVL_doc_object_type,
        PATVL_doc_column_name,
        PATVL_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the controlled set of values available for reusable product attributes.'
    ),
    (
        N'COLUMN',
        N'PATVL_id',
        N'Primary key of catalog.ProductAttributeValue.'
    ),
    (
        N'COLUMN',
        N'PATVL_PAT_id',
        N'Foreign key referencing catalog.ProductAttribute.'
    ),
    (
        N'COLUMN',
        N'PATVL_value',
        N'Stores the value used to identify a valid option for the associated product attribute.'
    ),
    (
        N'COLUMN',
        N'PATVL_is_active',
        N'Indicates whether the product attribute value is currently available for use in catalog operations while preserving inactive values for historical integrity.'
    ),
    (
        N'COLUMN',
        N'PATVL_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'PATVL_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @PATVL_FV_doc_current_id = MIN(PATVL_doc_id),
        @PATVL_FV_doc_max_id = MAX(PATVL_doc_id)
    FROM @PATVL_FV_expected_documentation;


    WHILE @PATVL_FV_doc_current_id <= @PATVL_FV_doc_max_id
    BEGIN
        SET @PATVL_FV_doc_object_type = NULL;
        SET @PATVL_FV_doc_column_name = NULL;
        SET @PATVL_FV_doc_expected_value = NULL;
        SET @PATVL_FV_doc_actual_value = NULL;

        SELECT
            @PATVL_FV_doc_object_type = PATVL_doc_object_type,
            @PATVL_FV_doc_column_name = PATVL_doc_column_name,
            @PATVL_FV_doc_expected_value = PATVL_doc_expected_description
        FROM @PATVL_FV_expected_documentation
        WHERE PATVL_doc_id = @PATVL_FV_doc_current_id;

        IF @PATVL_FV_doc_object_type = N'TABLE'
        BEGIN
            SELECT
                @PATVL_FV_doc_actual_value = CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';
        END
        ELSE
        BEGIN
            SELECT
                @PATVL_FV_doc_actual_value = CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id
            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
            AND ep.name = N'MS_Description'
            AND c.name = @PATVL_FV_doc_column_name;
        END;

        IF ISNULL(@PATVL_FV_doc_actual_value, N'') <> @PATVL_FV_doc_expected_value
        BEGIN
            SET @PATVL_FV_invalid_documentation += 1;
        END;

        SET @PATVL_FV_doc_current_id += 1;
    END;


    IF @PATVL_FV_invalid_documentation = 0
    BEGIN
        SET @PATVL_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PATVL_FV_documentation_status = N'FAILED';
        SET @PATVL_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PATVL_FV_expected_defaults TABLE
    (
        PATVL_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        PATVL_default_column_name          sysname NOT NULL,
        PATVL_default_constraint_name      sysname NOT NULL,
        PATVL_default_expected_definition  nvarchar(4000) NOT NULL
    );

    DECLARE @PATVL_FV_default_current_id          tinyint;
    DECLARE @PATVL_FV_default_max_id              tinyint;
    DECLARE @PATVL_FV_default_column_name         sysname;
    DECLARE @PATVL_FV_default_expected_name       sysname;
    DECLARE @PATVL_FV_default_actual_name         sysname;
    DECLARE @PATVL_FV_default_expected_definition nvarchar(4000);
    DECLARE @PATVL_FV_default_actual_definition   nvarchar(4000);
    DECLARE @PATVL_FV_default_expected_normalized nvarchar(4000);
    DECLARE @PATVL_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @PATVL_FV_invalid_defaults            int = 0;


    INSERT INTO @PATVL_FV_expected_defaults
    (
        PATVL_default_column_name,
        PATVL_default_constraint_name,
        PATVL_default_expected_definition
    )
    VALUES
    (N'PATVL_is_active',  N'DF_PATVL_is_active',  N'1'),
    (N'PATVL_created_at', N'DF_PATVL_created_at', N'sysdatetime'),
    (N'PATVL_updated_at', N'DF_PATVL_updated_at', N'sysdatetime');


    SELECT
        @PATVL_FV_default_current_id = MIN(PATVL_default_id),
        @PATVL_FV_default_max_id = MAX(PATVL_default_id)
    FROM @PATVL_FV_expected_defaults;


    WHILE @PATVL_FV_default_current_id <= @PATVL_FV_default_max_id
    BEGIN
        SET @PATVL_FV_default_column_name = NULL;
        SET @PATVL_FV_default_expected_name = NULL;
        SET @PATVL_FV_default_actual_name = NULL;
        SET @PATVL_FV_default_expected_definition = NULL;
        SET @PATVL_FV_default_actual_definition = NULL;

        SELECT
            @PATVL_FV_default_column_name = PATVL_default_column_name,
            @PATVL_FV_default_expected_name = PATVL_default_constraint_name,
            @PATVL_FV_default_expected_definition = PATVL_default_expected_definition
        FROM @PATVL_FV_expected_defaults
        WHERE PATVL_default_id = @PATVL_FV_default_current_id;

        SELECT
            @PATVL_FV_default_actual_name = dc.name,
            @PATVL_FV_default_actual_definition = dc.definition
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND c.name = @PATVL_FV_default_column_name;

        SET @PATVL_FV_default_expected_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(@PATVL_FV_default_expected_definition, N'(', N''), N')', N''), N' ', N''));

        SET @PATVL_FV_default_actual_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(@PATVL_FV_default_actual_definition, N'(', N''), N')', N''), N' ', N''));

        IF @PATVL_FV_default_actual_name IS NULL
        OR @PATVL_FV_default_actual_name <> @PATVL_FV_default_expected_name
        OR @PATVL_FV_default_actual_definition IS NULL
        OR @PATVL_FV_default_actual_normalized <> @PATVL_FV_default_expected_normalized
        BEGIN
            SET @PATVL_FV_invalid_defaults += 1;
        END;

        SET @PATVL_FV_default_current_id += 1;
    END;


    IF @PATVL_FV_invalid_defaults = 0
    BEGIN
        SET @PATVL_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PATVL_FV_defaults_status = N'FAILED';
        SET @PATVL_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PATVL_FV_uq_actual_name        sysname;
    DECLARE @PATVL_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @PATVL_FV_uq_actual_disabled    bit;
    DECLARE @PATVL_FV_uq_actual_data_space  sysname;


    SELECT
        @PATVL_FV_uq_actual_name = kc.name,
        @PATVL_FV_uq_actual_disabled = i.is_disabled,
        @PATVL_FV_uq_actual_data_space = ds.name,
        @PATVL_FV_uq_actual_columns =
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
    WHERE kc.parent_object_id = OBJECT_ID(N'catalog.ProductAttributeValue')
    AND kc.type = N'UQ'
    AND kc.name = N'UQ_PATVL_attribute_value';


    IF @PATVL_FV_uq_actual_name = N'UQ_PATVL_attribute_value'
    AND @PATVL_FV_uq_actual_columns = N'PATVL_PAT_id|PATVL_value'
    AND @PATVL_FV_uq_actual_disabled = 0
    AND @PATVL_FV_uq_actual_data_space = N'FG_CORE'
    BEGIN
        SET @PATVL_FV_uniques_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PATVL_FV_uniques_status = N'FAILED';
        SET @PATVL_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PATVL_FV_fk_actual_name              sysname;
    DECLARE @PATVL_FV_fk_parent_columns           nvarchar(4000);
    DECLARE @PATVL_FV_fk_referenced_columns       nvarchar(4000);
    DECLARE @PATVL_FV_fk_referenced_schema        sysname;
    DECLARE @PATVL_FV_fk_referenced_table         sysname;
    DECLARE @PATVL_FV_fk_delete_action            nvarchar(60);
    DECLARE @PATVL_FV_fk_update_action            nvarchar(60);
    DECLARE @PATVL_FV_fk_is_disabled              bit;
    DECLARE @PATVL_FV_fk_is_not_trusted           bit;


    SELECT
        @PATVL_FV_fk_actual_name = fk.name,
        @PATVL_FV_fk_referenced_schema =
            OBJECT_SCHEMA_NAME(fk.referenced_object_id),
        @PATVL_FV_fk_referenced_table =
            OBJECT_NAME(fk.referenced_object_id),
        @PATVL_FV_fk_delete_action =
            fk.delete_referential_action_desc,
        @PATVL_FV_fk_update_action =
            fk.update_referential_action_desc,
        @PATVL_FV_fk_is_disabled =
            fk.is_disabled,
        @PATVL_FV_fk_is_not_trusted =
            fk.is_not_trusted,

        @PATVL_FV_fk_parent_columns =
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), pc.name), N'|')
                    WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        ),

        @PATVL_FV_fk_referenced_columns =
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), rc.name), N'|')
                    WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        )

    FROM sys.foreign_keys AS fk
    WHERE fk.parent_object_id =
            OBJECT_ID(N'catalog.ProductAttributeValue')
    AND fk.name = N'FK_PATVL_PAT';


    IF @PATVL_FV_fk_actual_name = N'FK_PATVL_PAT'
    AND @PATVL_FV_fk_parent_columns = N'PATVL_PAT_id'
    AND @PATVL_FV_fk_referenced_schema = N'catalog'
    AND @PATVL_FV_fk_referenced_table = N'ProductAttribute'
    AND @PATVL_FV_fk_referenced_columns = N'PAT_id'
    AND @PATVL_FV_fk_delete_action = N'NO_ACTION'
    AND @PATVL_FV_fk_update_action = N'NO_ACTION'
    AND @PATVL_FV_fk_is_disabled = 0
    AND @PATVL_FV_fk_is_not_trusted = 0
    BEGIN
        SET @PATVL_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PATVL_FV_foreign_keys_status = N'FAILED';
        SET @PATVL_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @PATVL_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PATVL_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PATVL_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PATVL_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PATVL_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PATVL_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PATVL_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PATVL_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PATVL_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PATVL_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @PATVL_FV_temporal_integrity_status;
    PRINT N'';

    IF @PATVL_FV_validation_errors = 0
    BEGIN

        PRINT N'        Result                        : PASSED';

    END
    ELSE
    BEGIN

        PRINT N'        Result                        : FAILED';

        PRINT N'        Validation Errors             : '
            + CONVERT(nvarchar(10), @PATVL_FV_validation_errors);

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @PATVL_FV_validation_errors > 0
    BEGIN

        ;THROW 50270,
            N'Final validation failed for catalog.ProductAttributeValue.',
            1;

    END;