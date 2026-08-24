    PRINT N'    ● customer.CustomerDocumentType';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @DTP_FV_validation_errors int = 0;

    DECLARE @DTP_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @DTP_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @DTP_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @DTP_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @DTP_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @DTP_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @DTP_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @DTP_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @DTP_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @DTP_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @DTP_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'customer.CustomerDocumentType', N'U') IS NOT NULL
    BEGIN

        SET @DTP_FV_table_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @DTP_FV_table_status = N'FAILED';
        SET @DTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @DTP_FV_pk_actual_name     sysname;
    DECLARE @DTP_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @DTP_FV_pk_data_space      sysname;


    SELECT
        @DTP_FV_pk_actual_name =
            kc.name,

        @DTP_FV_pk_data_space =
            ds.name,

        @DTP_FV_pk_actual_columns =
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
            OBJECT_ID(N'customer.CustomerDocumentType')

    AND kc.type =
            N'PK';


    IF @DTP_FV_pk_actual_name =
            N'PK_DTP'

    AND @DTP_FV_pk_actual_columns =
            N'DTP_id'

    AND @DTP_FV_pk_data_space =
            N'FG_CORE'
    BEGIN

        SET @DTP_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @DTP_FV_primary_key_status = N'FAILED';
        SET @DTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @DTP_FV_expected_column_count int = 4;
    DECLARE @DTP_FV_actual_column_count   int;


    SELECT
        @DTP_FV_actual_column_count =
            COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'customer.CustomerDocumentType');


    IF @DTP_FV_actual_column_count =
            @DTP_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND c.name = N'DTP_id'
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
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND ic.name = N'DTP_id'
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
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND c.name = N'DTP_name'
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
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND c.name = N'DTP_created_at'
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
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND c.name = N'DTP_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN

        SET @DTP_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @DTP_FV_columns_status = N'FAILED';
        SET @DTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @DTP_FV_expected_documentation TABLE
    (
        DTP_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        DTP_doc_object_type           nvarchar(10) NOT NULL,
        DTP_doc_column_name           sysname NULL,
        DTP_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @DTP_FV_doc_current_id        tinyint;
    DECLARE @DTP_FV_doc_max_id            tinyint;
    DECLARE @DTP_FV_doc_object_type       nvarchar(10);
    DECLARE @DTP_FV_doc_column_name       sysname;
    DECLARE @DTP_FV_doc_expected_value    nvarchar(4000);
    DECLARE @DTP_FV_doc_actual_value      nvarchar(4000);
    DECLARE @DTP_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            customer.CustomerDocumentType.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @DTP_FV_expected_documentation
    (
        DTP_doc_object_type,
        DTP_doc_column_name,
        DTP_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the controlled set of document types that may be associated with customers in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'DTP_id',
        N'Primary key of customer.CustomerDocumentType.'
    ),
    (
        N'COLUMN',
        N'DTP_name',
        N'Stores the controlled name used to identify a customer document type.'
    ),
    (
        N'COLUMN',
        N'DTP_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'DTP_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @DTP_FV_doc_current_id =
            MIN(DTP_doc_id),

        @DTP_FV_doc_max_id =
            MAX(DTP_doc_id)

    FROM @DTP_FV_expected_documentation;


    WHILE @DTP_FV_doc_current_id <=
        @DTP_FV_doc_max_id
    BEGIN

        SET @DTP_FV_doc_object_type = NULL;
        SET @DTP_FV_doc_column_name = NULL;
        SET @DTP_FV_doc_expected_value = NULL;
        SET @DTP_FV_doc_actual_value = NULL;


        SELECT
            @DTP_FV_doc_object_type =
                DTP_doc_object_type,

            @DTP_FV_doc_column_name =
                DTP_doc_column_name,

            @DTP_FV_doc_expected_value =
                DTP_doc_expected_description

        FROM @DTP_FV_expected_documentation

        WHERE DTP_doc_id =
                @DTP_FV_doc_current_id;


        IF @DTP_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @DTP_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1

            AND ep.major_id =
                    OBJECT_ID(N'customer.CustomerDocumentType')

            AND ep.minor_id = 0

            AND ep.name =
                    N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @DTP_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1

            AND ep.major_id =
                    OBJECT_ID(N'customer.CustomerDocumentType')

            AND ep.name =
                    N'MS_Description'

            AND c.name =
                    @DTP_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @DTP_FV_doc_actual_value,
            N''
        )
        <>
        @DTP_FV_doc_expected_value
        BEGIN

            SET @DTP_FV_invalid_documentation += 1;

        END;


        SET @DTP_FV_doc_current_id += 1;

    END;


    IF @DTP_FV_invalid_documentation = 0
    BEGIN

        SET @DTP_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @DTP_FV_documentation_status = N'FAILED';
        SET @DTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    DECLARE @DTP_FV_invalid_seed_data int = 0;


    /*--------------------------------------------------------------------------
        DOCUMENT TYPES
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM customer.CustomerDocumentType

        WHERE DTP_name = N'CPF'
    )
    BEGIN

        SET @DTP_FV_invalid_seed_data += 1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM customer.CustomerDocumentType

        WHERE DTP_name = N'CNPJ'
    )
    BEGIN

        SET @DTP_FV_invalid_seed_data += 1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM customer.CustomerDocumentType

        WHERE DTP_name = N'RG'
    )
    BEGIN

        SET @DTP_FV_invalid_seed_data += 1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM customer.CustomerDocumentType

        WHERE DTP_name = N'CNH'
    )
    BEGIN

        SET @DTP_FV_invalid_seed_data += 1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM customer.CustomerDocumentType

        WHERE DTP_name = N'PASSPORT'
    )
    BEGIN

        SET @DTP_FV_invalid_seed_data += 1;

    END;


    /*--------------------------------------------------------------------------
        ENSURE EXACT EXPECTED DOMAIN ROW COUNT
    --------------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)

        FROM customer.CustomerDocumentType
    ) <> 5
    BEGIN

        SET @DTP_FV_invalid_seed_data += 1;

    END;


    IF @DTP_FV_invalid_seed_data = 0
    BEGIN

        SET @DTP_FV_seed_data_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @DTP_FV_seed_data_status = N'FAILED';
        SET @DTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @DTP_FV_expected_defaults TABLE
    (
        DTP_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        DTP_default_column_name          sysname NOT NULL,
        DTP_default_constraint_name      sysname NOT NULL,
        DTP_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @DTP_FV_default_current_id          tinyint;
    DECLARE @DTP_FV_default_max_id              tinyint;
    DECLARE @DTP_FV_default_column_name         sysname;
    DECLARE @DTP_FV_default_expected_name       sysname;
    DECLARE @DTP_FV_default_actual_name         sysname;
    DECLARE @DTP_FV_default_expected_definition nvarchar(4000);
    DECLARE @DTP_FV_default_actual_definition   nvarchar(4000);
    DECLARE @DTP_FV_default_expected_normalized nvarchar(4000);
    DECLARE @DTP_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @DTP_FV_invalid_defaults            int = 0;


    INSERT INTO @DTP_FV_expected_defaults
    (
        DTP_default_column_name,
        DTP_default_constraint_name,
        DTP_default_expected_definition
    )
    VALUES
    (
        N'DTP_created_at',
        N'DF_DTP_created_at',
        N'sysdatetime'
    ),
    (
        N'DTP_updated_at',
        N'DF_DTP_updated_at',
        N'sysdatetime'
    );


    SELECT
        @DTP_FV_default_current_id =
            MIN(DTP_default_id),

        @DTP_FV_default_max_id =
            MAX(DTP_default_id)

    FROM @DTP_FV_expected_defaults;


    WHILE @DTP_FV_default_current_id <=
        @DTP_FV_default_max_id
    BEGIN

        SET @DTP_FV_default_column_name = NULL;
        SET @DTP_FV_default_expected_name = NULL;
        SET @DTP_FV_default_actual_name = NULL;
        SET @DTP_FV_default_expected_definition = NULL;
        SET @DTP_FV_default_actual_definition = NULL;


        SELECT
            @DTP_FV_default_column_name =
                DTP_default_column_name,

            @DTP_FV_default_expected_name =
                DTP_default_constraint_name,

            @DTP_FV_default_expected_definition =
                DTP_default_expected_definition

        FROM @DTP_FV_expected_defaults

        WHERE DTP_default_id =
                @DTP_FV_default_current_id;


        SELECT
            @DTP_FV_default_actual_name =
                dc.name,

            @DTP_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND c.name =
                @DTP_FV_default_column_name;


        SET @DTP_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @DTP_FV_default_expected_definition,
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


        SET @DTP_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @DTP_FV_default_actual_definition,
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


        IF @DTP_FV_default_actual_name IS NULL

        OR @DTP_FV_default_actual_name <>
                @DTP_FV_default_expected_name

        OR @DTP_FV_default_actual_definition IS NULL

        OR @DTP_FV_default_actual_normalized <>
                @DTP_FV_default_expected_normalized
        BEGIN

            SET @DTP_FV_invalid_defaults += 1;

        END;


        SET @DTP_FV_default_current_id += 1;

    END;


    IF @DTP_FV_invalid_defaults = 0
    BEGIN

        SET @DTP_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @DTP_FV_defaults_status = N'FAILED';
        SET @DTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @DTP_FV_uq_actual_name        sysname;
    DECLARE @DTP_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @DTP_FV_uq_is_disabled        bit;
    DECLARE @DTP_FV_uq_data_space         sysname;


    SELECT
        @DTP_FV_uq_actual_name =
            kc.name,

        @DTP_FV_uq_is_disabled =
            i.is_disabled,

        @DTP_FV_uq_data_space =
            ds.name,

        @DTP_FV_uq_actual_columns =
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
            OBJECT_ID(N'customer.CustomerDocumentType')

    AND kc.type =
            N'UQ'

    AND kc.name =
            N'UQ_DTP_name';


    IF @DTP_FV_uq_actual_name =
            N'UQ_DTP_name'

    AND @DTP_FV_uq_actual_columns =
            N'DTP_name'

    AND @DTP_FV_uq_is_disabled = 0

    AND @DTP_FV_uq_data_space =
            N'FG_CORE'
    BEGIN

        SET @DTP_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @DTP_FV_uniques_status = N'FAILED';
        SET @DTP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @DTP_FV_table_status;
    PRINT N'        Primary Key                   : ' + @DTP_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @DTP_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @DTP_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @DTP_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @DTP_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @DTP_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @DTP_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @DTP_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @DTP_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @DTP_FV_temporal_integrity_status;
    PRINT N'';

    IF @DTP_FV_validation_errors = 0
    BEGIN

        PRINT N'        Result                        : PASSED';

    END
    ELSE
    BEGIN

        PRINT N'        Result                        : FAILED';

        PRINT N'        Validation Errors             : '
            + CONVERT
            (
                nvarchar(10),
                @DTP_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @DTP_FV_validation_errors > 0
    BEGIN

        ;THROW 50530,
            N'Final validation failed for customer.CustomerDocumentType.',
            1;

    END;