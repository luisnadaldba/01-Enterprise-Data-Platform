    PRINT N'    catalog.Brand';
    PRINT N'    --------------------------------------------------------------------------';

    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @BRD_FV_validation_errors int = 0;

    DECLARE @BRD_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @BRD_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @BRD_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @BRD_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @BRD_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @BRD_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @BRD_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @BRD_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @BRD_FV_foreign_keys_status        nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @BRD_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @BRD_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.Brand', N'U') IS NOT NULL
    BEGIN
        SET @BRD_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @BRD_FV_table_status = N'FAILED';
        SET @BRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @BRD_FV_pk_actual_name     sysname;
    DECLARE @BRD_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @BRD_FV_pk_data_space      sysname;


    SELECT
        @BRD_FV_pk_actual_name = kc.name,

        @BRD_FV_pk_data_space = ds.name,

        @BRD_FV_pk_actual_columns =
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
            OBJECT_ID(N'catalog.Brand')

    AND kc.type = N'PK';


    IF @BRD_FV_pk_actual_name = N'PK_BRD'
    AND @BRD_FV_pk_actual_columns = N'BRD_id'
    AND @BRD_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @BRD_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @BRD_FV_primary_key_status = N'FAILED';
        SET @BRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @BRD_FV_expected_column_count int = 5;
    DECLARE @BRD_FV_actual_column_count   int;


    SELECT
        @BRD_FV_actual_column_count = COUNT(*)
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'catalog.Brand');


    IF @BRD_FV_actual_column_count = @BRD_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id = OBJECT_ID(N'catalog.Brand')
        AND c.name = N'BRD_id'
        AND t.name = N'smallint'
        AND c.max_length = 2
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.identity_columns AS ic

        WHERE ic.object_id = OBJECT_ID(N'catalog.Brand')
        AND ic.name = N'BRD_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id = OBJECT_ID(N'catalog.Brand')
        AND c.name = N'BRD_name'
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

        WHERE c.object_id = OBJECT_ID(N'catalog.Brand')
        AND c.name = N'BRD_is_active'
        AND t.name = N'bit'
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id = OBJECT_ID(N'catalog.Brand')
        AND c.name = N'BRD_created_at'
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

        WHERE c.object_id = OBJECT_ID(N'catalog.Brand')
        AND c.name = N'BRD_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @BRD_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @BRD_FV_columns_status = N'FAILED';
        SET @BRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @BRD_FV_expected_documentation TABLE
    (
        BRD_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        BRD_doc_object_type           nvarchar(10) NOT NULL,
        BRD_doc_column_name           sysname NULL,
        BRD_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @BRD_FV_doc_current_id        tinyint;
    DECLARE @BRD_FV_doc_max_id            tinyint;
    DECLARE @BRD_FV_doc_object_type       nvarchar(10);
    DECLARE @BRD_FV_doc_column_name       sysname;
    DECLARE @BRD_FV_doc_expected_value    nvarchar(4000);
    DECLARE @BRD_FV_doc_actual_value      nvarchar(4000);
    DECLARE @BRD_FV_invalid_documentation int = 0;


    INSERT INTO @BRD_FV_expected_documentation
    (
        BRD_doc_object_type,
        BRD_doc_column_name,
        BRD_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the controlled set of commercial brands used to consistently classify products in the Atlas Commerce catalog.'
    ),
    (
        N'COLUMN',
        N'BRD_id',
        N'Primary key of catalog.Brand.'
    ),
    (
        N'COLUMN',
        N'BRD_name',
        N'Stores the commercial name used to identify the brand associated with catalog products.'
    ),
    (
        N'COLUMN',
        N'BRD_is_active',
        N'Indicates whether the brand is currently available for use in catalog operations while preserving inactive brands for historical integrity.'
    ),
    (
        N'COLUMN',
        N'BRD_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'BRD_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @BRD_FV_doc_current_id = MIN(BRD_doc_id),
        @BRD_FV_doc_max_id = MAX(BRD_doc_id)
    FROM @BRD_FV_expected_documentation;


    WHILE @BRD_FV_doc_current_id <= @BRD_FV_doc_max_id
    BEGIN

        SET @BRD_FV_doc_object_type = NULL;
        SET @BRD_FV_doc_column_name = NULL;
        SET @BRD_FV_doc_expected_value = NULL;
        SET @BRD_FV_doc_actual_value = NULL;


        SELECT
            @BRD_FV_doc_object_type =
                BRD_doc_object_type,

            @BRD_FV_doc_column_name =
                BRD_doc_column_name,

            @BRD_FV_doc_expected_value =
                BRD_doc_expected_description

        FROM @BRD_FV_expected_documentation

        WHERE BRD_doc_id =
                @BRD_FV_doc_current_id;


        IF @BRD_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @BRD_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.Brand')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @BRD_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.Brand')
            AND ep.name = N'MS_Description'
            AND c.name = @BRD_FV_doc_column_name;

        END;


        IF ISNULL(@BRD_FV_doc_actual_value, N'') <>
                @BRD_FV_doc_expected_value
        BEGIN
            SET @BRD_FV_invalid_documentation += 1;
        END;


        SET @BRD_FV_doc_current_id += 1;

    END;


    IF @BRD_FV_invalid_documentation = 0
    BEGIN
        SET @BRD_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @BRD_FV_documentation_status = N'FAILED';
        SET @BRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'Brand'
        AND PFX_prefix = N'BRD'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @BRD_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @BRD_FV_seed_data_status = N'FAILED';
        SET @BRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @BRD_FV_expected_defaults TABLE
    (
        BRD_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        BRD_default_column_name          sysname NOT NULL,
        BRD_default_constraint_name      sysname NOT NULL,
        BRD_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @BRD_FV_default_current_id          tinyint;
    DECLARE @BRD_FV_default_max_id              tinyint;
    DECLARE @BRD_FV_default_column_name         sysname;
    DECLARE @BRD_FV_default_expected_name       sysname;
    DECLARE @BRD_FV_default_actual_name         sysname;
    DECLARE @BRD_FV_default_expected_definition nvarchar(4000);
    DECLARE @BRD_FV_default_actual_definition   nvarchar(4000);
    DECLARE @BRD_FV_default_expected_normalized nvarchar(4000);
    DECLARE @BRD_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @BRD_FV_invalid_defaults            int = 0;


    INSERT INTO @BRD_FV_expected_defaults
    (
        BRD_default_column_name,
        BRD_default_constraint_name,
        BRD_default_expected_definition
    )
    VALUES
    (
        N'BRD_is_active',
        N'DF_BRD_is_active',
        N'1'
    ),
    (
        N'BRD_created_at',
        N'DF_BRD_created_at',
        N'sysdatetime'
    ),
    (
        N'BRD_updated_at',
        N'DF_BRD_updated_at',
        N'sysdatetime'
    );


    SELECT
        @BRD_FV_default_current_id = MIN(BRD_default_id),
        @BRD_FV_default_max_id = MAX(BRD_default_id)
    FROM @BRD_FV_expected_defaults;


    WHILE @BRD_FV_default_current_id <= @BRD_FV_default_max_id
    BEGIN

        SET @BRD_FV_default_column_name = NULL;
        SET @BRD_FV_default_expected_name = NULL;
        SET @BRD_FV_default_actual_name = NULL;
        SET @BRD_FV_default_expected_definition = NULL;
        SET @BRD_FV_default_actual_definition = NULL;


        SELECT
            @BRD_FV_default_column_name =
                BRD_default_column_name,

            @BRD_FV_default_expected_name =
                BRD_default_constraint_name,

            @BRD_FV_default_expected_definition =
                BRD_default_expected_definition

        FROM @BRD_FV_expected_defaults

        WHERE BRD_default_id =
                @BRD_FV_default_current_id;


        SELECT
            @BRD_FV_default_actual_name =
                dc.name,

            @BRD_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.Brand')

        AND c.name =
                @BRD_FV_default_column_name;


        SET @BRD_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @BRD_FV_default_expected_definition,
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


        SET @BRD_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @BRD_FV_default_actual_definition,
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


        IF @BRD_FV_default_actual_name IS NULL
        OR @BRD_FV_default_actual_name <>
                @BRD_FV_default_expected_name
        OR @BRD_FV_default_actual_definition IS NULL
        OR @BRD_FV_default_actual_normalized <>
                @BRD_FV_default_expected_normalized
        BEGIN
            SET @BRD_FV_invalid_defaults += 1;
        END;


        SET @BRD_FV_default_current_id += 1;

    END;


    IF @BRD_FV_invalid_defaults = 0
    BEGIN
        SET @BRD_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @BRD_FV_defaults_status = N'FAILED';
        SET @BRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @BRD_FV_uq_actual_name        sysname;
    DECLARE @BRD_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @BRD_FV_uq_actual_disabled    bit;
    DECLARE @BRD_FV_uq_actual_data_space  sysname;


    SELECT
        @BRD_FV_uq_actual_name =
            kc.name,

        @BRD_FV_uq_actual_disabled =
            i.is_disabled,

        @BRD_FV_uq_actual_data_space =
            ds.name,

        @BRD_FV_uq_actual_columns =
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
            OBJECT_ID(N'catalog.Brand')

    AND kc.type = N'UQ'

    AND kc.name = N'UQ_BRD_name';


    IF @BRD_FV_uq_actual_name = N'UQ_BRD_name'
    AND @BRD_FV_uq_actual_columns = N'BRD_name'
    AND @BRD_FV_uq_actual_disabled = 0
    AND @BRD_FV_uq_actual_data_space = N'FG_CORE'
    BEGIN
        SET @BRD_FV_uniques_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @BRD_FV_uniques_status = N'FAILED';
        SET @BRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    PRINT N'        Table                         : ' + @BRD_FV_table_status;
    PRINT N'        Primary Key                   : ' + @BRD_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @BRD_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @BRD_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @BRD_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @BRD_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @BRD_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @BRD_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @BRD_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @BRD_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @BRD_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @BRD_FV_validation_errors = 0
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
            + CONVERT(nvarchar(10), @BRD_FV_validation_errors);
        PRINT N'';

        ;THROW 50076,
            N'Final validation failed for catalog.Brand.',
            1;

    END;


    PRINT N'';