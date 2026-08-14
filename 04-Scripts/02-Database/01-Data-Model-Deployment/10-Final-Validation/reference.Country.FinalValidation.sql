    PRINT N'    reference.Country';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @CTR_FV_validation_errors int = 0;

    DECLARE @CTR_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTR_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTR_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTR_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTR_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTR_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTR_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CTR_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTR_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CTR_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CTR_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'reference.Country', N'U') IS NOT NULL
    BEGIN

        SET @CTR_FV_table_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTR_FV_table_status = N'FAILED';
        SET @CTR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @CTR_FV_pk_actual_name     sysname;
    DECLARE @CTR_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @CTR_FV_pk_data_space      sysname;


    SELECT
        @CTR_FV_pk_actual_name = kc.name,
        @CTR_FV_pk_data_space = ds.name,

        @CTR_FV_pk_actual_columns =
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
            OBJECT_ID(N'reference.Country')

    AND kc.type = N'PK';


    IF @CTR_FV_pk_actual_name = N'PK_CTR'
    AND @CTR_FV_pk_actual_columns = N'CTR_id'
    AND @CTR_FV_pk_data_space = N'FG_CORE'
    BEGIN

        SET @CTR_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTR_FV_primary_key_status = N'FAILED';
        SET @CTR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @CTR_FV_expected_column_count int = 4;
    DECLARE @CTR_FV_actual_column_count   int;


    SELECT
        @CTR_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'reference.Country');


    IF @CTR_FV_actual_column_count =
            @CTR_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'reference.Country')

        AND c.name = N'CTR_id'
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
                OBJECT_ID(N'reference.Country')

        AND ic.name = N'CTR_id'
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
                OBJECT_ID(N'reference.Country')

        AND c.name = N'CTR_name'
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
                OBJECT_ID(N'reference.Country')

        AND c.name = N'CTR_created_at'
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
                OBJECT_ID(N'reference.Country')

        AND c.name = N'CTR_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )
    BEGIN

        SET @CTR_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTR_FV_columns_status = N'FAILED';
        SET @CTR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @CTR_FV_expected_documentation TABLE
    (
        CTR_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        CTR_doc_object_type           nvarchar(10) NOT NULL,
        CTR_doc_column_name           sysname NULL,
        CTR_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @CTR_FV_doc_current_id        tinyint;
    DECLARE @CTR_FV_doc_max_id            tinyint;
    DECLARE @CTR_FV_doc_object_type       nvarchar(10);
    DECLARE @CTR_FV_doc_column_name       sysname;
    DECLARE @CTR_FV_doc_expected_value    nvarchar(4000);
    DECLARE @CTR_FV_doc_actual_value      nvarchar(4000);
    DECLARE @CTR_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            reference.Country.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @CTR_FV_expected_documentation
    (
        CTR_doc_object_type,
        CTR_doc_column_name,
        CTR_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains controlled countries used by Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'CTR_id',
        N'Primary key of reference.Country.'
    ),
    (
        N'COLUMN',
        N'CTR_name',
        N'Stores the official name used to identify the country.'
    ),
    (
        N'COLUMN',
        N'CTR_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'CTR_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @CTR_FV_doc_current_id =
            MIN(CTR_doc_id),

        @CTR_FV_doc_max_id =
            MAX(CTR_doc_id)

    FROM @CTR_FV_expected_documentation;


    WHILE @CTR_FV_doc_current_id <=
        @CTR_FV_doc_max_id
    BEGIN

        SET @CTR_FV_doc_object_type = NULL;
        SET @CTR_FV_doc_column_name = NULL;
        SET @CTR_FV_doc_expected_value = NULL;
        SET @CTR_FV_doc_actual_value = NULL;


        SELECT
            @CTR_FV_doc_object_type =
                CTR_doc_object_type,

            @CTR_FV_doc_column_name =
                CTR_doc_column_name,

            @CTR_FV_doc_expected_value =
                CTR_doc_expected_description

        FROM @CTR_FV_expected_documentation

        WHERE CTR_doc_id =
                @CTR_FV_doc_current_id;


        IF @CTR_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @CTR_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'reference.Country')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @CTR_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'reference.Country')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @CTR_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @CTR_FV_doc_actual_value,
            N''
        )
        <>
        @CTR_FV_doc_expected_value
        BEGIN

            SET @CTR_FV_invalid_documentation += 1;

        END;


        SET @CTR_FV_doc_current_id += 1;

    END;


    IF @CTR_FV_invalid_documentation = 0
    BEGIN

        SET @CTR_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTR_FV_documentation_status = N'FAILED';
        SET @CTR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'reference'
        AND PFX_table_name = N'Country'
        AND PFX_prefix = N'CTR'
        AND PFX_is_active = 1
    )
    BEGIN

        SET @CTR_FV_seed_data_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTR_FV_seed_data_status = N'FAILED';
        SET @CTR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @CTR_FV_expected_defaults TABLE
    (
        CTR_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        CTR_default_column_name          sysname NOT NULL,
        CTR_default_constraint_name      sysname NOT NULL,
        CTR_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @CTR_FV_default_current_id          tinyint;
    DECLARE @CTR_FV_default_max_id              tinyint;
    DECLARE @CTR_FV_default_column_name         sysname;
    DECLARE @CTR_FV_default_expected_name       sysname;
    DECLARE @CTR_FV_default_actual_name         sysname;
    DECLARE @CTR_FV_default_expected_definition nvarchar(4000);
    DECLARE @CTR_FV_default_actual_definition   nvarchar(4000);
    DECLARE @CTR_FV_default_expected_normalized nvarchar(4000);
    DECLARE @CTR_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @CTR_FV_invalid_defaults            int = 0;


    INSERT INTO @CTR_FV_expected_defaults
    (
        CTR_default_column_name,
        CTR_default_constraint_name,
        CTR_default_expected_definition
    )
    VALUES
    (
        N'CTR_created_at',
        N'DF_CTR_created_at',
        N'sysdatetime'
    ),
    (
        N'CTR_updated_at',
        N'DF_CTR_updated_at',
        N'sysdatetime'
    );


    SELECT
        @CTR_FV_default_current_id =
            MIN(CTR_default_id),

        @CTR_FV_default_max_id =
            MAX(CTR_default_id)

    FROM @CTR_FV_expected_defaults;


    WHILE @CTR_FV_default_current_id <=
        @CTR_FV_default_max_id
    BEGIN

        SET @CTR_FV_default_column_name = NULL;
        SET @CTR_FV_default_expected_name = NULL;
        SET @CTR_FV_default_actual_name = NULL;
        SET @CTR_FV_default_expected_definition = NULL;
        SET @CTR_FV_default_actual_definition = NULL;


        SELECT
            @CTR_FV_default_column_name =
                CTR_default_column_name,

            @CTR_FV_default_expected_name =
                CTR_default_constraint_name,

            @CTR_FV_default_expected_definition =
                CTR_default_expected_definition

        FROM @CTR_FV_expected_defaults

        WHERE CTR_default_id =
                @CTR_FV_default_current_id;


        SELECT
            @CTR_FV_default_actual_name =
                dc.name,

            @CTR_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'reference.Country')

        AND c.name =
                @CTR_FV_default_column_name;


        SET @CTR_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CTR_FV_default_expected_definition,
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


        SET @CTR_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CTR_FV_default_actual_definition,
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


        IF @CTR_FV_default_actual_name IS NULL
        OR @CTR_FV_default_actual_name <>
                @CTR_FV_default_expected_name
        OR @CTR_FV_default_actual_definition IS NULL
        OR @CTR_FV_default_actual_normalized <>
                @CTR_FV_default_expected_normalized
        BEGIN

            SET @CTR_FV_invalid_defaults += 1;

        END;


        SET @CTR_FV_default_current_id += 1;

    END;


    IF @CTR_FV_invalid_defaults = 0
    BEGIN

        SET @CTR_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTR_FV_defaults_status = N'FAILED';
        SET @CTR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CTR_FV_uq_actual_name        sysname;
    DECLARE @CTR_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @CTR_FV_uq_actual_disabled    bit;
    DECLARE @CTR_FV_uq_actual_data_space  sysname;


    SELECT
        @CTR_FV_uq_actual_name =
            kc.name,

        @CTR_FV_uq_actual_disabled =
            i.is_disabled,

        @CTR_FV_uq_actual_data_space =
            ds.name,

        @CTR_FV_uq_actual_columns =
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
            OBJECT_ID(N'reference.Country')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_CTR_name';


    IF @CTR_FV_uq_actual_name =
            N'UQ_CTR_name'

    AND @CTR_FV_uq_actual_columns =
            N'CTR_name'

    AND @CTR_FV_uq_actual_disabled = 0

    AND @CTR_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @CTR_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTR_FV_uniques_status = N'FAILED';
        SET @CTR_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @CTR_FV_table_status;
    PRINT N'        Primary Key                   : ' + @CTR_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @CTR_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @CTR_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @CTR_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @CTR_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @CTR_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @CTR_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @CTR_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @CTR_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @CTR_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @CTR_FV_validation_errors = 0
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
                @CTR_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50200,
            N'Final validation failed for reference.Country.',
            1;

    END;


    PRINT N'';