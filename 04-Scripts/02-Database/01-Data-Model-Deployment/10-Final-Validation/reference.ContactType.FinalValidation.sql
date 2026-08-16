    PRINT N'    reference.ContactType';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @CTP_FV_validation_errors int = 0;

    DECLARE @CTP_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTP_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTP_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTP_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTP_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTP_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTP_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CTP_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTP_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CTP_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CTP_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'reference.ContactType', N'U') IS NOT NULL
    BEGIN

        SET @CTP_FV_table_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTP_FV_table_status = N'FAILED';
        SET @CTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @CTP_FV_pk_actual_name     sysname;
    DECLARE @CTP_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @CTP_FV_pk_data_space      sysname;


    SELECT
        @CTP_FV_pk_actual_name =
            kc.name,

        @CTP_FV_pk_data_space =
            ds.name,

        @CTP_FV_pk_actual_columns =
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
            OBJECT_ID(N'reference.ContactType')

    AND kc.type =
            N'PK';


    IF @CTP_FV_pk_actual_name =
            N'PK_CTP'

    AND @CTP_FV_pk_actual_columns =
            N'CTP_id'

    AND @CTP_FV_pk_data_space =
            N'FG_CORE'
    BEGIN

        SET @CTP_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTP_FV_primary_key_status = N'FAILED';
        SET @CTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @CTP_FV_expected_column_count int = 4;
    DECLARE @CTP_FV_actual_column_count   int;


    SELECT
        @CTP_FV_actual_column_count =
            COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'reference.ContactType');


    IF @CTP_FV_actual_column_count =
            @CTP_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'reference.ContactType')

        AND c.name = N'CTP_id'
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
                OBJECT_ID(N'reference.ContactType')

        AND ic.name = N'CTP_id'
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
                OBJECT_ID(N'reference.ContactType')

        AND c.name = N'CTP_name'
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
                OBJECT_ID(N'reference.ContactType')

        AND c.name = N'CTP_created_at'
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
                OBJECT_ID(N'reference.ContactType')

        AND c.name = N'CTP_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )
    BEGIN

        SET @CTP_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTP_FV_columns_status = N'FAILED';
        SET @CTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @CTP_FV_expected_documentation TABLE
    (
        CTP_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        CTP_doc_object_type           nvarchar(10) NOT NULL,
        CTP_doc_column_name           sysname NULL,
        CTP_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @CTP_FV_doc_current_id        tinyint;
    DECLARE @CTP_FV_doc_max_id            tinyint;
    DECLARE @CTP_FV_doc_object_type       nvarchar(10);
    DECLARE @CTP_FV_doc_column_name       sysname;
    DECLARE @CTP_FV_doc_expected_value    nvarchar(4000);
    DECLARE @CTP_FV_doc_actual_value      nvarchar(4000);
    DECLARE @CTP_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            reference.ContactType.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @CTP_FV_expected_documentation
    (
        CTP_doc_object_type,
        CTP_doc_column_name,
        CTP_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains reusable telephone contact type values shared across Atlas Commerce domains.'
    ),
    (
        N'COLUMN',
        N'CTP_id',
        N'Primary key of reference.ContactType.'
    ),
    (
        N'COLUMN',
        N'CTP_name',
        N'Stores the controlled name used to identify the telephone contact type.'
    ),
    (
        N'COLUMN',
        N'CTP_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'CTP_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @CTP_FV_doc_current_id =
            MIN(CTP_doc_id),

        @CTP_FV_doc_max_id =
            MAX(CTP_doc_id)

    FROM @CTP_FV_expected_documentation;


    WHILE @CTP_FV_doc_current_id <=
        @CTP_FV_doc_max_id
    BEGIN

        SET @CTP_FV_doc_object_type = NULL;
        SET @CTP_FV_doc_column_name = NULL;
        SET @CTP_FV_doc_expected_value = NULL;
        SET @CTP_FV_doc_actual_value = NULL;


        SELECT
            @CTP_FV_doc_object_type =
                CTP_doc_object_type,

            @CTP_FV_doc_column_name =
                CTP_doc_column_name,

            @CTP_FV_doc_expected_value =
                CTP_doc_expected_description

        FROM @CTP_FV_expected_documentation

        WHERE CTP_doc_id =
                @CTP_FV_doc_current_id;


        IF @CTP_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @CTP_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1

            AND ep.major_id =
                    OBJECT_ID(N'reference.ContactType')

            AND ep.minor_id = 0

            AND ep.name =
                    N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @CTP_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1

            AND ep.major_id =
                    OBJECT_ID(N'reference.ContactType')

            AND ep.name =
                    N'MS_Description'

            AND c.name =
                    @CTP_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @CTP_FV_doc_actual_value,
            N''
        )
        <>
        @CTP_FV_doc_expected_value
        BEGIN

            SET @CTP_FV_invalid_documentation += 1;

        END;


        SET @CTP_FV_doc_current_id += 1;

    END;


    IF @CTP_FV_invalid_documentation = 0
    BEGIN

        SET @CTP_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTP_FV_documentation_status = N'FAILED';
        SET @CTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    DECLARE @CTP_FV_invalid_seed_data int = 0;


    /*--------------------------------------------------------------------------
        PREFIX REGISTRATION
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name =
                N'reference'

        AND PFX_table_name =
                N'ContactType'

        AND PFX_prefix =
                N'CTP'

        AND PFX_is_active = 1
    )
    BEGIN

        SET @CTP_FV_invalid_seed_data += 1;

    END;


    /*--------------------------------------------------------------------------
        CONTACT TYPES
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM reference.ContactType
        WHERE CTP_name = N'PHONE'
    )
    BEGIN

        SET @CTP_FV_invalid_seed_data += 1;

    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM reference.ContactType
        WHERE CTP_name = N'MOBILE'
    )
    BEGIN

        SET @CTP_FV_invalid_seed_data += 1;

    END;


    /*--------------------------------------------------------------------------
        ENSURE EXACT EXPECTED DOMAIN ROW COUNT
    --------------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)
        FROM reference.ContactType
    ) <> 2
    BEGIN

        SET @CTP_FV_invalid_seed_data += 1;

    END;


    IF @CTP_FV_invalid_seed_data = 0
    BEGIN

        SET @CTP_FV_seed_data_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTP_FV_seed_data_status = N'FAILED';
        SET @CTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @CTP_FV_expected_defaults TABLE
    (
        CTP_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        CTP_default_column_name          sysname NOT NULL,
        CTP_default_constraint_name      sysname NOT NULL,
        CTP_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @CTP_FV_default_current_id          tinyint;
    DECLARE @CTP_FV_default_max_id              tinyint;
    DECLARE @CTP_FV_default_column_name         sysname;
    DECLARE @CTP_FV_default_expected_name       sysname;
    DECLARE @CTP_FV_default_actual_name         sysname;
    DECLARE @CTP_FV_default_expected_definition nvarchar(4000);
    DECLARE @CTP_FV_default_actual_definition   nvarchar(4000);
    DECLARE @CTP_FV_default_expected_normalized nvarchar(4000);
    DECLARE @CTP_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @CTP_FV_invalid_defaults            int = 0;


    INSERT INTO @CTP_FV_expected_defaults
    (
        CTP_default_column_name,
        CTP_default_constraint_name,
        CTP_default_expected_definition
    )
    VALUES
    (
        N'CTP_created_at',
        N'DF_CTP_created_at',
        N'sysdatetime'
    ),
    (
        N'CTP_updated_at',
        N'DF_CTP_updated_at',
        N'sysdatetime'
    );


    SELECT
        @CTP_FV_default_current_id =
            MIN(CTP_default_id),

        @CTP_FV_default_max_id =
            MAX(CTP_default_id)

    FROM @CTP_FV_expected_defaults;


    WHILE @CTP_FV_default_current_id <=
        @CTP_FV_default_max_id
    BEGIN

        SET @CTP_FV_default_column_name = NULL;
        SET @CTP_FV_default_expected_name = NULL;
        SET @CTP_FV_default_actual_name = NULL;
        SET @CTP_FV_default_expected_definition = NULL;
        SET @CTP_FV_default_actual_definition = NULL;


        SELECT
            @CTP_FV_default_column_name =
                CTP_default_column_name,

            @CTP_FV_default_expected_name =
                CTP_default_constraint_name,

            @CTP_FV_default_expected_definition =
                CTP_default_expected_definition

        FROM @CTP_FV_expected_defaults

        WHERE CTP_default_id =
                @CTP_FV_default_current_id;


        SELECT
            @CTP_FV_default_actual_name =
                dc.name,

            @CTP_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'reference.ContactType')

        AND c.name =
                @CTP_FV_default_column_name;


        SET @CTP_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CTP_FV_default_expected_definition,
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


        SET @CTP_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CTP_FV_default_actual_definition,
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


        IF @CTP_FV_default_actual_name IS NULL

        OR @CTP_FV_default_actual_name <>
                @CTP_FV_default_expected_name

        OR @CTP_FV_default_actual_definition IS NULL

        OR @CTP_FV_default_actual_normalized <>
                @CTP_FV_default_expected_normalized
        BEGIN

            SET @CTP_FV_invalid_defaults += 1;

        END;


        SET @CTP_FV_default_current_id += 1;

    END;


    IF @CTP_FV_invalid_defaults = 0
    BEGIN

        SET @CTP_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTP_FV_defaults_status = N'FAILED';
        SET @CTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CTP_FV_uq_actual_name        sysname;
    DECLARE @CTP_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @CTP_FV_uq_actual_disabled    bit;
    DECLARE @CTP_FV_uq_actual_data_space  sysname;


    SELECT
        @CTP_FV_uq_actual_name =
            kc.name,

        @CTP_FV_uq_actual_disabled =
            i.is_disabled,

        @CTP_FV_uq_actual_data_space =
            ds.name,

        @CTP_FV_uq_actual_columns =
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
            OBJECT_ID(N'reference.ContactType')

    AND kc.type =
            N'UQ'

    AND kc.name =
            N'UQ_CTP_name';


    IF @CTP_FV_uq_actual_name =
            N'UQ_CTP_name'

    AND @CTP_FV_uq_actual_columns =
            N'CTP_name'

    AND @CTP_FV_uq_actual_disabled = 0

    AND @CTP_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @CTP_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTP_FV_uniques_status = N'FAILED';
        SET @CTP_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @CTP_FV_table_status;
    PRINT N'        Primary Key                   : ' + @CTP_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @CTP_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @CTP_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @CTP_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @CTP_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @CTP_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @CTP_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @CTP_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @CTP_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @CTP_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @CTP_FV_validation_errors = 0
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
                @CTP_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50620,
            N'Final validation failed for reference.ContactType.',
            1;

    END;


    PRINT N'';