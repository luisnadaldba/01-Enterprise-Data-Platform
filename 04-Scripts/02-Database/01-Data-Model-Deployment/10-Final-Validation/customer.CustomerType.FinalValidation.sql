    PRINT N'    customer.CustomerType';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @CSTCT_FV_validation_errors int = 0;

    DECLARE @CSTCT_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCT_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCT_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCT_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCT_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCT_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCT_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CSTCT_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCT_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CSTCT_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CSTCT_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'customer.CustomerType', N'U') IS NOT NULL
    BEGIN
        SET @CSTCT_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTCT_FV_table_status = N'FAILED';
        SET @CSTCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @CSTCT_FV_pk_actual_name     sysname;
    DECLARE @CSTCT_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @CSTCT_FV_pk_data_space      sysname;


    SELECT
        @CSTCT_FV_pk_actual_name = kc.name,
        @CSTCT_FV_pk_data_space = ds.name,

        @CSTCT_FV_pk_actual_columns =
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
            OBJECT_ID(N'customer.CustomerType')

    AND kc.type = N'PK';


    IF @CSTCT_FV_pk_actual_name = N'PK_CSTCT'
    AND @CSTCT_FV_pk_actual_columns = N'CSTCT_id'
    AND @CSTCT_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @CSTCT_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTCT_FV_primary_key_status = N'FAILED';
        SET @CSTCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @CSTCT_FV_expected_column_count int = 5;
    DECLARE @CSTCT_FV_actual_column_count   int;


    SELECT
        @CSTCT_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'customer.CustomerType');


    IF @CSTCT_FV_actual_column_count =
            @CSTCT_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'customer.CustomerType')

        AND c.name = N'CSTCT_id'
        AND t.name = N'smallint'
        AND c.max_length = 2
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.identity_columns AS ic

        WHERE ic.object_id =
                OBJECT_ID(N'customer.CustomerType')

        AND ic.name = N'CSTCT_id'
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
                OBJECT_ID(N'customer.CustomerType')

        AND c.name = N'CSTCT_code'
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

        WHERE c.object_id =
                OBJECT_ID(N'customer.CustomerType')

        AND c.name = N'CSTCT_name'
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

        WHERE c.object_id =
                OBJECT_ID(N'customer.CustomerType')

        AND c.name = N'CSTCT_created_at'
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

        WHERE c.object_id =
                OBJECT_ID(N'customer.CustomerType')

        AND c.name = N'CSTCT_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @CSTCT_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTCT_FV_columns_status = N'FAILED';
        SET @CSTCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @CSTCT_FV_expected_documentation TABLE
    (
        CSTCT_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        CSTCT_doc_object_type           nvarchar(10) NOT NULL,
        CSTCT_doc_column_name           sysname NULL,
        CSTCT_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @CSTCT_FV_doc_current_id        tinyint;
    DECLARE @CSTCT_FV_doc_max_id            tinyint;
    DECLARE @CSTCT_FV_doc_object_type       nvarchar(10);
    DECLARE @CSTCT_FV_doc_column_name       sysname;
    DECLARE @CSTCT_FV_doc_expected_value    nvarchar(4000);
    DECLARE @CSTCT_FV_doc_actual_value      nvarchar(4000);
    DECLARE @CSTCT_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            customer.CustomerType.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @CSTCT_FV_expected_documentation
    (
        CSTCT_doc_object_type,
        CSTCT_doc_column_name,
        CSTCT_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the controlled customer types supported by Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'CSTCT_id',
        N'Primary key of customer.CustomerType.'
    ),
    (
        N'COLUMN',
        N'CSTCT_code',
        N'Stores the stable technical code used to identify the customer type.'
    ),
    (
        N'COLUMN',
        N'CSTCT_name',
        N'Stores the descriptive name of the customer type.'
    ),
    (
        N'COLUMN',
        N'CSTCT_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'CSTCT_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @CSTCT_FV_doc_current_id =
            MIN(CSTCT_doc_id),

        @CSTCT_FV_doc_max_id =
            MAX(CSTCT_doc_id)

    FROM @CSTCT_FV_expected_documentation;


    WHILE @CSTCT_FV_doc_current_id <=
        @CSTCT_FV_doc_max_id
    BEGIN

        SET @CSTCT_FV_doc_object_type = NULL;
        SET @CSTCT_FV_doc_column_name = NULL;
        SET @CSTCT_FV_doc_expected_value = NULL;
        SET @CSTCT_FV_doc_actual_value = NULL;


        SELECT
            @CSTCT_FV_doc_object_type =
                CSTCT_doc_object_type,

            @CSTCT_FV_doc_column_name =
                CSTCT_doc_column_name,

            @CSTCT_FV_doc_expected_value =
                CSTCT_doc_expected_description

        FROM @CSTCT_FV_expected_documentation

        WHERE CSTCT_doc_id =
                @CSTCT_FV_doc_current_id;


        IF @CSTCT_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @CSTCT_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'customer.CustomerType')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @CSTCT_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'customer.CustomerType')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @CSTCT_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @CSTCT_FV_doc_actual_value,
            N''
        )
        <>
        @CSTCT_FV_doc_expected_value
        BEGIN

            SET @CSTCT_FV_invalid_documentation += 1;

        END;


        SET @CSTCT_FV_doc_current_id += 1;

    END;


    IF @CSTCT_FV_invalid_documentation = 0
    BEGIN
        SET @CSTCT_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTCT_FV_documentation_status = N'FAILED';
        SET @CSTCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'customer'
        AND PFX_table_name = N'CustomerType'
        AND PFX_prefix = N'CSTCT'
        AND PFX_is_active = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM customer.CustomerType

        WHERE CSTCT_code = N'INDIVIDUAL'
        AND CSTCT_name = N'Pessoa Física'
    )

    AND EXISTS
    (
        SELECT 1

        FROM customer.CustomerType

        WHERE CSTCT_code = N'COMPANY'
        AND CSTCT_name = N'Pessoa Jurídica'
    )

    AND
    (
        SELECT COUNT(*)

        FROM customer.CustomerType

        WHERE CSTCT_code IN
        (
            N'INDIVIDUAL',
            N'COMPANY'
        )
    ) = 2

    BEGIN
        SET @CSTCT_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTCT_FV_seed_data_status = N'FAILED';
        SET @CSTCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @CSTCT_FV_expected_defaults TABLE
    (
        CSTCT_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        CSTCT_default_column_name          sysname NOT NULL,
        CSTCT_default_constraint_name      sysname NOT NULL,
        CSTCT_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @CSTCT_FV_default_current_id          tinyint;
    DECLARE @CSTCT_FV_default_max_id              tinyint;
    DECLARE @CSTCT_FV_default_column_name         sysname;
    DECLARE @CSTCT_FV_default_expected_name       sysname;
    DECLARE @CSTCT_FV_default_actual_name         sysname;
    DECLARE @CSTCT_FV_default_expected_definition nvarchar(4000);
    DECLARE @CSTCT_FV_default_actual_definition   nvarchar(4000);
    DECLARE @CSTCT_FV_default_expected_normalized nvarchar(4000);
    DECLARE @CSTCT_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @CSTCT_FV_invalid_defaults            int = 0;


    INSERT INTO @CSTCT_FV_expected_defaults
    (
        CSTCT_default_column_name,
        CSTCT_default_constraint_name,
        CSTCT_default_expected_definition
    )
    VALUES
    (
        N'CSTCT_created_at',
        N'DF_CSTCT_created_at',
        N'sysdatetime'
    ),
    (
        N'CSTCT_updated_at',
        N'DF_CSTCT_updated_at',
        N'sysdatetime'
    );


    SELECT
        @CSTCT_FV_default_current_id =
            MIN(CSTCT_default_id),

        @CSTCT_FV_default_max_id =
            MAX(CSTCT_default_id)

    FROM @CSTCT_FV_expected_defaults;


    WHILE @CSTCT_FV_default_current_id <=
        @CSTCT_FV_default_max_id
    BEGIN

        SET @CSTCT_FV_default_column_name = NULL;
        SET @CSTCT_FV_default_expected_name = NULL;
        SET @CSTCT_FV_default_actual_name = NULL;
        SET @CSTCT_FV_default_expected_definition = NULL;
        SET @CSTCT_FV_default_actual_definition = NULL;


        SELECT
            @CSTCT_FV_default_column_name =
                CSTCT_default_column_name,

            @CSTCT_FV_default_expected_name =
                CSTCT_default_constraint_name,

            @CSTCT_FV_default_expected_definition =
                CSTCT_default_expected_definition

        FROM @CSTCT_FV_expected_defaults

        WHERE CSTCT_default_id =
                @CSTCT_FV_default_current_id;


        SELECT
            @CSTCT_FV_default_actual_name =
                dc.name,

            @CSTCT_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'customer.CustomerType')

        AND c.name =
                @CSTCT_FV_default_column_name;


        SET @CSTCT_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CSTCT_FV_default_expected_definition,
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


        SET @CSTCT_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CSTCT_FV_default_actual_definition,
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


        IF @CSTCT_FV_default_actual_name IS NULL
        OR @CSTCT_FV_default_actual_name <>
                @CSTCT_FV_default_expected_name
        OR @CSTCT_FV_default_actual_definition IS NULL
        OR @CSTCT_FV_default_actual_normalized <>
                @CSTCT_FV_default_expected_normalized
        BEGIN

            SET @CSTCT_FV_invalid_defaults += 1;

        END;


        SET @CSTCT_FV_default_current_id += 1;

    END;


    IF @CSTCT_FV_invalid_defaults = 0
    BEGIN
        SET @CSTCT_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTCT_FV_defaults_status = N'FAILED';
        SET @CSTCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CSTCT_FV_uq_actual_name        sysname;
    DECLARE @CSTCT_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @CSTCT_FV_uq_actual_disabled    bit;
    DECLARE @CSTCT_FV_uq_actual_data_space  sysname;


    SELECT
        @CSTCT_FV_uq_actual_name =
            kc.name,

        @CSTCT_FV_uq_actual_disabled =
            i.is_disabled,

        @CSTCT_FV_uq_actual_data_space =
            ds.name,

        @CSTCT_FV_uq_actual_columns =
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
            OBJECT_ID(N'customer.CustomerType')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_CSTCT_code';


    IF @CSTCT_FV_uq_actual_name =
            N'UQ_CSTCT_code'

    AND @CSTCT_FV_uq_actual_columns =
            N'CSTCT_code'

    AND @CSTCT_FV_uq_actual_disabled = 0

    AND @CSTCT_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @CSTCT_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCT_FV_uniques_status = N'FAILED';
        SET @CSTCT_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @CSTCT_FV_table_status;
    PRINT N'        Primary Key                   : ' + @CSTCT_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @CSTCT_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @CSTCT_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @CSTCT_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @CSTCT_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @CSTCT_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @CSTCT_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @CSTCT_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @CSTCT_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @CSTCT_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @CSTCT_FV_validation_errors = 0
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
                @CSTCT_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50330,
            N'Final validation failed for customer.CustomerType.',
            1;

    END;


    PRINT N'';