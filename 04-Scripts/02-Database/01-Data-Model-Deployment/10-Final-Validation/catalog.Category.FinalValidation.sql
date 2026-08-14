    PRINT N'    catalog.Category';
    PRINT N'    --------------------------------------------------------------------------';

    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @CTG_FV_validation_errors int = 0;

    DECLARE @CTG_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTG_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTG_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTG_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTG_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTG_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTG_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CTG_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTG_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTG_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CTG_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.Category', N'U') IS NOT NULL
    BEGIN
        SET @CTG_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CTG_FV_table_status = N'FAILED';
        SET @CTG_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @CTG_FV_pk_actual_name     sysname;
    DECLARE @CTG_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @CTG_FV_pk_data_space      sysname;


    SELECT
        @CTG_FV_pk_actual_name = kc.name,
        @CTG_FV_pk_data_space = ds.name,
        @CTG_FV_pk_actual_columns =
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
    WHERE kc.parent_object_id = OBJECT_ID(N'catalog.Category')
    AND kc.type = N'PK';


    IF @CTG_FV_pk_actual_name = N'PK_CTG'
    AND @CTG_FV_pk_actual_columns = N'CTG_id'
    AND @CTG_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @CTG_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CTG_FV_primary_key_status = N'FAILED';
        SET @CTG_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @CTG_FV_expected_column_count int = 6;
    DECLARE @CTG_FV_actual_column_count   int;


    SELECT
        @CTG_FV_actual_column_count = COUNT(*)
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'catalog.Category');


    IF @CTG_FV_actual_column_count = @CTG_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.Category')
        AND c.name = N'CTG_id'
        AND t.name = N'smallint'
        AND c.max_length = 2
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'catalog.Category')
        AND ic.name = N'CTG_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.Category')
        AND c.name = N'CTG_CTG_id'
        AND t.name = N'smallint'
        AND c.max_length = 2
        AND c.is_nullable = 1
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.Category')
        AND c.name = N'CTG_name'
        AND t.name = N'nvarchar'
        AND c.max_length = 300
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.Category')
        AND c.name = N'CTG_is_active'
        AND t.name = N'bit'
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.Category')
        AND c.name = N'CTG_created_at'
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
        WHERE c.object_id = OBJECT_ID(N'catalog.Category')
        AND c.name = N'CTG_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @CTG_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CTG_FV_columns_status = N'FAILED';
        SET @CTG_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @CTG_FV_expected_documentation TABLE
    (
        CTG_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        CTG_doc_object_type           nvarchar(10) NOT NULL,
        CTG_doc_column_name           sysname NULL,
        CTG_doc_expected_description  nvarchar(4000) NOT NULL
    );

    DECLARE @CTG_FV_doc_current_id        tinyint;
    DECLARE @CTG_FV_doc_max_id            tinyint;
    DECLARE @CTG_FV_doc_object_type       nvarchar(10);
    DECLARE @CTG_FV_doc_column_name       sysname;
    DECLARE @CTG_FV_doc_expected_value    nvarchar(4000);
    DECLARE @CTG_FV_doc_actual_value      nvarchar(4000);
    DECLARE @CTG_FV_invalid_documentation int = 0;


    INSERT INTO @CTG_FV_expected_documentation
    (
        CTG_doc_object_type,
        CTG_doc_column_name,
        CTG_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the hierarchical category structure used to organize products in the Atlas Commerce catalog.'
    ),
    (
        N'COLUMN',
        N'CTG_id',
        N'Primary key of catalog.Category.'
    ),
    (
        N'COLUMN',
        N'CTG_CTG_id',
        N'Identifies the parent category in the catalog hierarchy. NULL indicates a root category.'
    ),
    (
        N'COLUMN',
        N'CTG_name',
        N'Stores the business name used to identify the category within the catalog hierarchy.'
    ),
    (
        N'COLUMN',
        N'CTG_is_active',
        N'Indicates whether the category is currently available for use in catalog operations while preserving inactive categories for historical integrity.'
    ),
    (
        N'COLUMN',
        N'CTG_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'CTG_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @CTG_FV_doc_current_id = MIN(CTG_doc_id),
        @CTG_FV_doc_max_id = MAX(CTG_doc_id)
    FROM @CTG_FV_expected_documentation;


    WHILE @CTG_FV_doc_current_id <= @CTG_FV_doc_max_id
    BEGIN
        SET @CTG_FV_doc_object_type = NULL;
        SET @CTG_FV_doc_column_name = NULL;
        SET @CTG_FV_doc_expected_value = NULL;
        SET @CTG_FV_doc_actual_value = NULL;

        SELECT
            @CTG_FV_doc_object_type = CTG_doc_object_type,
            @CTG_FV_doc_column_name = CTG_doc_column_name,
            @CTG_FV_doc_expected_value = CTG_doc_expected_description
        FROM @CTG_FV_expected_documentation
        WHERE CTG_doc_id = @CTG_FV_doc_current_id;

        IF @CTG_FV_doc_object_type = N'TABLE'
        BEGIN
            SELECT
                @CTG_FV_doc_actual_value = CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.Category')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';
        END
        ELSE
        BEGIN
            SELECT
                @CTG_FV_doc_actual_value = CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id
            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.Category')
            AND ep.name = N'MS_Description'
            AND c.name = @CTG_FV_doc_column_name;
        END;

        IF ISNULL(@CTG_FV_doc_actual_value, N'') <> @CTG_FV_doc_expected_value
        BEGIN
            SET @CTG_FV_invalid_documentation += 1;
        END;

        SET @CTG_FV_doc_current_id += 1;
    END;


    IF @CTG_FV_invalid_documentation = 0
    BEGIN
        SET @CTG_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CTG_FV_documentation_status = N'FAILED';
        SET @CTG_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'Category'
        AND PFX_prefix = N'CTG'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @CTG_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CTG_FV_seed_data_status = N'FAILED';
        SET @CTG_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @CTG_FV_expected_defaults TABLE
    (
        CTG_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        CTG_default_column_name          sysname NOT NULL,
        CTG_default_constraint_name      sysname NOT NULL,
        CTG_default_expected_definition  nvarchar(4000) NOT NULL
    );

    DECLARE @CTG_FV_default_current_id          tinyint;
    DECLARE @CTG_FV_default_max_id              tinyint;
    DECLARE @CTG_FV_default_column_name         sysname;
    DECLARE @CTG_FV_default_expected_name       sysname;
    DECLARE @CTG_FV_default_actual_name         sysname;
    DECLARE @CTG_FV_default_expected_definition nvarchar(4000);
    DECLARE @CTG_FV_default_actual_definition   nvarchar(4000);
    DECLARE @CTG_FV_default_expected_normalized nvarchar(4000);
    DECLARE @CTG_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @CTG_FV_invalid_defaults            int = 0;


    INSERT INTO @CTG_FV_expected_defaults
    (
        CTG_default_column_name,
        CTG_default_constraint_name,
        CTG_default_expected_definition
    )
    VALUES
    (N'CTG_is_active',  N'DF_CTG_is_active',  N'1'),
    (N'CTG_created_at', N'DF_CTG_created_at', N'sysdatetime'),
    (N'CTG_updated_at', N'DF_CTG_updated_at', N'sysdatetime');


    SELECT
        @CTG_FV_default_current_id = MIN(CTG_default_id),
        @CTG_FV_default_max_id = MAX(CTG_default_id)
    FROM @CTG_FV_expected_defaults;


    WHILE @CTG_FV_default_current_id <= @CTG_FV_default_max_id
    BEGIN
        SET @CTG_FV_default_column_name = NULL;
        SET @CTG_FV_default_expected_name = NULL;
        SET @CTG_FV_default_actual_name = NULL;
        SET @CTG_FV_default_expected_definition = NULL;
        SET @CTG_FV_default_actual_definition = NULL;

        SELECT
            @CTG_FV_default_column_name = CTG_default_column_name,
            @CTG_FV_default_expected_name = CTG_default_constraint_name,
            @CTG_FV_default_expected_definition = CTG_default_expected_definition
        FROM @CTG_FV_expected_defaults
        WHERE CTG_default_id = @CTG_FV_default_current_id;

        SELECT
            @CTG_FV_default_actual_name = dc.name,
            @CTG_FV_default_actual_definition = dc.definition
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.Category')
        AND c.name = @CTG_FV_default_column_name;

        SET @CTG_FV_default_expected_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(@CTG_FV_default_expected_definition, N'(', N''), N')', N''), N' ', N''));

        SET @CTG_FV_default_actual_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(@CTG_FV_default_actual_definition, N'(', N''), N')', N''), N' ', N''));

        IF @CTG_FV_default_actual_name IS NULL
        OR @CTG_FV_default_actual_name <> @CTG_FV_default_expected_name
        OR @CTG_FV_default_actual_definition IS NULL
        OR @CTG_FV_default_actual_normalized <> @CTG_FV_default_expected_normalized
        BEGIN
            SET @CTG_FV_invalid_defaults += 1;
        END;

        SET @CTG_FV_default_current_id += 1;
    END;


    IF @CTG_FV_invalid_defaults = 0
    BEGIN
        SET @CTG_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CTG_FV_defaults_status = N'FAILED';
        SET @CTG_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CTG_FV_uq_actual_name        sysname;
    DECLARE @CTG_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @CTG_FV_uq_actual_disabled    bit;
    DECLARE @CTG_FV_uq_actual_data_space  sysname;


    SELECT
        @CTG_FV_uq_actual_name = kc.name,
        @CTG_FV_uq_actual_disabled = i.is_disabled,
        @CTG_FV_uq_actual_data_space = ds.name,
        @CTG_FV_uq_actual_columns =
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
    WHERE kc.parent_object_id = OBJECT_ID(N'catalog.Category')
    AND kc.type = N'UQ'
    AND kc.name = N'UQ_CTG_parent_name';


    IF @CTG_FV_uq_actual_name = N'UQ_CTG_parent_name'
    AND @CTG_FV_uq_actual_columns = N'CTG_CTG_id|CTG_name'
    AND @CTG_FV_uq_actual_disabled = 0
    AND @CTG_FV_uq_actual_data_space = N'FG_CORE'
    BEGIN
        SET @CTG_FV_uniques_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CTG_FV_uniques_status = N'FAILED';
        SET @CTG_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CTG_FV_fk_actual_name                sysname;
    DECLARE @CTG_FV_fk_parent_columns             nvarchar(4000);
    DECLARE @CTG_FV_fk_referenced_columns         nvarchar(4000);
    DECLARE @CTG_FV_fk_referenced_schema          sysname;
    DECLARE @CTG_FV_fk_referenced_table           sysname;
    DECLARE @CTG_FV_fk_delete_action              nvarchar(60);
    DECLARE @CTG_FV_fk_update_action              nvarchar(60);
    DECLARE @CTG_FV_fk_is_disabled                bit;
    DECLARE @CTG_FV_fk_is_not_trusted             bit;


    SELECT
        @CTG_FV_fk_actual_name = fk.name,
        @CTG_FV_fk_referenced_schema = OBJECT_SCHEMA_NAME(fk.referenced_object_id),
        @CTG_FV_fk_referenced_table = OBJECT_NAME(fk.referenced_object_id),
        @CTG_FV_fk_delete_action = fk.delete_referential_action_desc,
        @CTG_FV_fk_update_action = fk.update_referential_action_desc,
        @CTG_FV_fk_is_disabled = fk.is_disabled,
        @CTG_FV_fk_is_not_trusted = fk.is_not_trusted,
        @CTG_FV_fk_parent_columns =
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
        @CTG_FV_fk_referenced_columns =
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
    WHERE fk.parent_object_id = OBJECT_ID(N'catalog.Category')
    AND fk.name = N'FK_CTG_CTG';


    IF @CTG_FV_fk_actual_name = N'FK_CTG_CTG'
    AND @CTG_FV_fk_parent_columns = N'CTG_CTG_id'
    AND @CTG_FV_fk_referenced_schema = N'catalog'
    AND @CTG_FV_fk_referenced_table = N'Category'
    AND @CTG_FV_fk_referenced_columns = N'CTG_id'
    AND @CTG_FV_fk_delete_action = N'NO_ACTION'
    AND @CTG_FV_fk_update_action = N'NO_ACTION'
    AND @CTG_FV_fk_is_disabled = 0
    AND @CTG_FV_fk_is_not_trusted = 0
    BEGIN
        SET @CTG_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CTG_FV_foreign_keys_status = N'FAILED';
        SET @CTG_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    PRINT N'        Table                         : ' + @CTG_FV_table_status;
    PRINT N'        Primary Key                   : ' + @CTG_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @CTG_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @CTG_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @CTG_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @CTG_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @CTG_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @CTG_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @CTG_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @CTG_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @CTG_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @CTG_FV_validation_errors = 0
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
            + CONVERT(nvarchar(10), @CTG_FV_validation_errors);
        PRINT N'';

        ;THROW 50170,
            N'Final validation failed for catalog.Category.',
            1;
    END;


    PRINT N'';