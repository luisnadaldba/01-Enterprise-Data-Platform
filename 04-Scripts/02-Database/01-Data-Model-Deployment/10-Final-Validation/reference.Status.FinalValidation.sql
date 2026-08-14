    PRINT N'    reference.Status';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @STS_FV_validation_errors int = 0;

    DECLARE @STS_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @STS_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @STS_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @STS_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @STS_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @STS_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @STS_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @STS_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @STS_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @STS_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @STS_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'reference.Status', N'U') IS NOT NULL
    BEGIN

        SET @STS_FV_table_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @STS_FV_table_status = N'FAILED';
        SET @STS_FV_validation_errors += 1;

    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @STS_FV_pk_actual_name     sysname;
    DECLARE @STS_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @STS_FV_pk_data_space      sysname;


    SELECT
        @STS_FV_pk_actual_name = kc.name,
        @STS_FV_pk_data_space = ds.name,

        @STS_FV_pk_actual_columns =
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
            OBJECT_ID(N'reference.Status')

    AND kc.type = N'PK';


    IF @STS_FV_pk_actual_name = N'PK_STS'
    AND @STS_FV_pk_actual_columns = N'STS_id'
    AND @STS_FV_pk_data_space = N'FG_CORE'
    BEGIN

        SET @STS_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @STS_FV_primary_key_status = N'FAILED';
        SET @STS_FV_validation_errors += 1;

    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @STS_FV_expected_column_count int = 5;
    DECLARE @STS_FV_actual_column_count   int;


    SELECT
        @STS_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'reference.Status');


    IF @STS_FV_actual_column_count =
            @STS_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'reference.Status')

        AND c.name = N'STS_id'
        AND t.name = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.identity_columns AS ic

        WHERE ic.object_id =
                OBJECT_ID(N'reference.Status')

        AND ic.name = N'STS_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'reference.Status')

        AND c.name = N'STS_code'
        AND t.name = N'varchar'
        AND c.max_length = 30
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'reference.Status')

        AND c.name = N'STS_name'
        AND t.name = N'nvarchar'
        AND c.max_length = 200
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'reference.Status')

        AND c.name = N'STS_created_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'reference.Status')

        AND c.name = N'STS_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )
    BEGIN

        SET @STS_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @STS_FV_columns_status = N'FAILED';
        SET @STS_FV_validation_errors += 1;

    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @STS_FV_expected_documentation TABLE
    (
        STS_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        STS_doc_object_type           nvarchar(10) NOT NULL,
        STS_doc_column_name           sysname NULL,
        STS_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @STS_FV_doc_current_id        tinyint;
    DECLARE @STS_FV_doc_max_id            tinyint;
    DECLARE @STS_FV_doc_object_type       nvarchar(10);
    DECLARE @STS_FV_doc_column_name       sysname;
    DECLARE @STS_FV_doc_expected_value    nvarchar(4000);
    DECLARE @STS_FV_doc_actual_value      nvarchar(4000);
    DECLARE @STS_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            reference.Status.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @STS_FV_expected_documentation
    (
        STS_doc_object_type,
        STS_doc_column_name,
        STS_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains reusable status values shared across Atlas Commerce domains where a simple active or inactive state is required.'
    ),
    (
        N'COLUMN',
        N'STS_id',
        N'Primary key of reference.Status.'
    ),
    (
        N'COLUMN',
        N'STS_code',
        N'Stores the unique stable code used to identify the status programmatically.'
    ),
    (
        N'COLUMN',
        N'STS_name',
        N'Stores the descriptive name of the status for human-readable use.'
    ),
    (
        N'COLUMN',
        N'STS_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'STS_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @STS_FV_doc_current_id =
            MIN(STS_doc_id),

        @STS_FV_doc_max_id =
            MAX(STS_doc_id)

    FROM @STS_FV_expected_documentation;


    WHILE @STS_FV_doc_current_id <=
        @STS_FV_doc_max_id
    BEGIN

        SET @STS_FV_doc_object_type = NULL;
        SET @STS_FV_doc_column_name = NULL;
        SET @STS_FV_doc_expected_value = NULL;
        SET @STS_FV_doc_actual_value = NULL;


        SELECT
            @STS_FV_doc_object_type =
                STS_doc_object_type,

            @STS_FV_doc_column_name =
                STS_doc_column_name,

            @STS_FV_doc_expected_value =
                STS_doc_expected_description

        FROM @STS_FV_expected_documentation

        WHERE STS_doc_id =
                @STS_FV_doc_current_id;


        IF @STS_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @STS_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'reference.Status')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @STS_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'reference.Status')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @STS_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @STS_FV_doc_actual_value,
            N''
        )
        <>
        @STS_FV_doc_expected_value
        BEGIN

            SET @STS_FV_invalid_documentation += 1;

        END;


        SET @STS_FV_doc_current_id += 1;

    END;


    IF @STS_FV_invalid_documentation = 0
    BEGIN

        SET @STS_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @STS_FV_documentation_status = N'FAILED';
        SET @STS_FV_validation_errors += 1;

    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'reference'
        AND PFX_table_name = N'Status'
        AND PFX_prefix = N'STS'
        AND PFX_is_active = 1
    )
    BEGIN

        SET @STS_FV_seed_data_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @STS_FV_seed_data_status = N'FAILED';
        SET @STS_FV_validation_errors += 1;

    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @STS_FV_expected_defaults TABLE
    (
        STS_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        STS_default_column_name          sysname NOT NULL,
        STS_default_constraint_name      sysname NOT NULL,
        STS_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @STS_FV_default_current_id          tinyint;
    DECLARE @STS_FV_default_max_id              tinyint;
    DECLARE @STS_FV_default_column_name         sysname;
    DECLARE @STS_FV_default_expected_name       sysname;
    DECLARE @STS_FV_default_actual_name         sysname;
    DECLARE @STS_FV_default_expected_definition nvarchar(4000);
    DECLARE @STS_FV_default_actual_definition   nvarchar(4000);
    DECLARE @STS_FV_default_expected_normalized nvarchar(4000);
    DECLARE @STS_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @STS_FV_invalid_defaults            int = 0;


    INSERT INTO @STS_FV_expected_defaults
    (
        STS_default_column_name,
        STS_default_constraint_name,
        STS_default_expected_definition
    )
    VALUES
    (
        N'STS_created_at',
        N'DF_STS_created_at',
        N'sysdatetime'
    ),
    (
        N'STS_updated_at',
        N'DF_STS_updated_at',
        N'sysdatetime'
    );


    SELECT
        @STS_FV_default_current_id =
            MIN(STS_default_id),

        @STS_FV_default_max_id =
            MAX(STS_default_id)

    FROM @STS_FV_expected_defaults;


    WHILE @STS_FV_default_current_id <=
        @STS_FV_default_max_id
    BEGIN

        SET @STS_FV_default_column_name = NULL;
        SET @STS_FV_default_expected_name = NULL;
        SET @STS_FV_default_actual_name = NULL;
        SET @STS_FV_default_expected_definition = NULL;
        SET @STS_FV_default_actual_definition = NULL;


        SELECT
            @STS_FV_default_column_name =
                STS_default_column_name,

            @STS_FV_default_expected_name =
                STS_default_constraint_name,

            @STS_FV_default_expected_definition =
                STS_default_expected_definition

        FROM @STS_FV_expected_defaults

        WHERE STS_default_id =
                @STS_FV_default_current_id;


        SELECT
            @STS_FV_default_actual_name =
                dc.name,

            @STS_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'reference.Status')

        AND c.name =
                @STS_FV_default_column_name;


        SET @STS_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @STS_FV_default_expected_definition,
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


        SET @STS_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @STS_FV_default_actual_definition,
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


        IF @STS_FV_default_actual_name IS NULL
        OR @STS_FV_default_actual_name <>
                @STS_FV_default_expected_name
        OR @STS_FV_default_actual_definition IS NULL
        OR @STS_FV_default_actual_normalized <>
                @STS_FV_default_expected_normalized
        BEGIN

            SET @STS_FV_invalid_defaults += 1;

        END;


        SET @STS_FV_default_current_id += 1;

    END;


    IF @STS_FV_invalid_defaults = 0
    BEGIN

        SET @STS_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @STS_FV_defaults_status = N'FAILED';
        SET @STS_FV_validation_errors += 1;

    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @STS_FV_uq_actual_name        sysname;
    DECLARE @STS_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @STS_FV_uq_actual_disabled    bit;
    DECLARE @STS_FV_uq_actual_data_space  sysname;


    SELECT
        @STS_FV_uq_actual_name =
            kc.name,

        @STS_FV_uq_actual_disabled =
            i.is_disabled,

        @STS_FV_uq_actual_data_space =
            ds.name,

        @STS_FV_uq_actual_columns =
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

    INNER JOIN sys.indexes AS i
        ON  i.object_id = kc.parent_object_id
        AND i.index_id = kc.unique_index_id

    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id

    WHERE kc.parent_object_id =
            OBJECT_ID(N'reference.Status')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_STS_code';


    IF @STS_FV_uq_actual_name =
            N'UQ_STS_code'

    AND @STS_FV_uq_actual_columns =
            N'STS_code'

    AND @STS_FV_uq_actual_disabled = 0

    AND @STS_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @STS_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @STS_FV_uniques_status = N'FAILED';
        SET @STS_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @STS_FV_table_status;
    PRINT N'        Primary Key                   : ' + @STS_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @STS_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @STS_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @STS_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @STS_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @STS_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @STS_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @STS_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @STS_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @STS_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @STS_FV_validation_errors = 0
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
            + CONVERT
            (
                nvarchar(10),
                @STS_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50200,
            N'Final validation failed for reference.Status.',
            1;

    END;


    PRINT N'';