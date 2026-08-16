    PRINT N'    customer.CustomerDocument';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @CSTCD_FV_validation_errors int = 0;

    DECLARE @CSTCD_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCD_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCD_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCD_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCD_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCD_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCD_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CSTCD_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCD_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCD_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CSTCD_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'customer.CustomerDocument', N'U') IS NOT NULL
    BEGIN

        SET @CSTCD_FV_table_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCD_FV_table_status = N'FAILED';
        SET @CSTCD_FV_validation_errors += 1;

    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @CSTCD_FV_pk_actual_name     sysname;
    DECLARE @CSTCD_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @CSTCD_FV_pk_data_space      sysname;


    SELECT
        @CSTCD_FV_pk_actual_name =
            kc.name,

        @CSTCD_FV_pk_data_space =
            ds.name,

        @CSTCD_FV_pk_actual_columns =
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
            OBJECT_ID(N'customer.CustomerDocument')

    AND kc.type =
            N'PK';


    IF @CSTCD_FV_pk_actual_name =
            N'PK_CSTCD'

    AND @CSTCD_FV_pk_actual_columns =
            N'CSTCD_id'

    AND @CSTCD_FV_pk_data_space =
            N'FG_CORE'
    BEGIN

        SET @CSTCD_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCD_FV_primary_key_status = N'FAILED';
        SET @CSTCD_FV_validation_errors += 1;

    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @CSTCD_FV_expected_column_count int = 6;
    DECLARE @CSTCD_FV_actual_column_count   int;


    SELECT
        @CSTCD_FV_actual_column_count =
            COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'customer.CustomerDocument');


    IF @CSTCD_FV_actual_column_count =
            @CSTCD_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND c.name = N'CSTCD_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.identity_columns AS ic

        WHERE ic.object_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ic.name = N'CSTCD_id'
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
                OBJECT_ID(N'customer.CustomerDocument')

        AND c.name = N'CSTCD_CST_id'
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

        WHERE c.object_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND c.name = N'CSTCD_DTP_id'
        AND t.name = N'smallint'
        AND c.max_length = 2
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
                OBJECT_ID(N'customer.CustomerDocument')

        AND c.name = N'CSTCD_value'
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
                OBJECT_ID(N'customer.CustomerDocument')

        AND c.name = N'CSTCD_created_at'
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
                OBJECT_ID(N'customer.CustomerDocument')

        AND c.name = N'CSTCD_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN

        SET @CSTCD_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCD_FV_columns_status = N'FAILED';
        SET @CSTCD_FV_validation_errors += 1;

    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @CSTCD_FV_expected_documentation TABLE
    (
        CSTCD_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        CSTCD_doc_object_type           nvarchar(10) NOT NULL,
        CSTCD_doc_column_name           sysname NULL,
        CSTCD_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @CSTCD_FV_doc_current_id        tinyint;
    DECLARE @CSTCD_FV_doc_max_id            tinyint;
    DECLARE @CSTCD_FV_doc_object_type       nvarchar(10);
    DECLARE @CSTCD_FV_doc_column_name       sysname;
    DECLARE @CSTCD_FV_doc_expected_value    nvarchar(4000);
    DECLARE @CSTCD_FV_doc_actual_value      nvarchar(4000);
    DECLARE @CSTCD_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            customer.CustomerDocument.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @CSTCD_FV_expected_documentation
    (
        CSTCD_doc_object_type,
        CSTCD_doc_column_name,
        CSTCD_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains document identifiers associated with identified customers while keeping document information separated from the core Customer entity.'
    ),
    (
        N'COLUMN',
        N'CSTCD_id',
        N'Primary key of customer.CustomerDocument.'
    ),
    (
        N'COLUMN',
        N'CSTCD_CST_id',
        N'Foreign key referencing customer.Customer.CST_id.'
    ),
    (
        N'COLUMN',
        N'CSTCD_DTP_id',
        N'Foreign key referencing customer.CustomerDocumentType.DTP_id.'
    ),
    (
        N'COLUMN',
        N'CSTCD_value',
        N'Stores the normalized document identifier value without presentation formatting.'
    ),
    (
        N'COLUMN',
        N'CSTCD_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'CSTCD_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @CSTCD_FV_doc_current_id =
            MIN(CSTCD_doc_id),

        @CSTCD_FV_doc_max_id =
            MAX(CSTCD_doc_id)

    FROM @CSTCD_FV_expected_documentation;


    WHILE @CSTCD_FV_doc_current_id <=
        @CSTCD_FV_doc_max_id
    BEGIN

        SET @CSTCD_FV_doc_object_type = NULL;
        SET @CSTCD_FV_doc_column_name = NULL;
        SET @CSTCD_FV_doc_expected_value = NULL;
        SET @CSTCD_FV_doc_actual_value = NULL;


        SELECT
            @CSTCD_FV_doc_object_type =
                CSTCD_doc_object_type,

            @CSTCD_FV_doc_column_name =
                CSTCD_doc_column_name,

            @CSTCD_FV_doc_expected_value =
                CSTCD_doc_expected_description

        FROM @CSTCD_FV_expected_documentation

        WHERE CSTCD_doc_id =
                @CSTCD_FV_doc_current_id;


        IF @CSTCD_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @CSTCD_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1

            AND ep.major_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND ep.minor_id = 0

            AND ep.name =
                    N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @CSTCD_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1

            AND ep.major_id =
                    OBJECT_ID(N'customer.CustomerDocument')

            AND ep.name =
                    N'MS_Description'

            AND c.name =
                    @CSTCD_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @CSTCD_FV_doc_actual_value,
            N''
        )
        <>
        @CSTCD_FV_doc_expected_value
        BEGIN

            SET @CSTCD_FV_invalid_documentation += 1;

        END;


        SET @CSTCD_FV_doc_current_id += 1;

    END;


    IF @CSTCD_FV_invalid_documentation = 0
    BEGIN

        SET @CSTCD_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCD_FV_documentation_status = N'FAILED';
        SET @CSTCD_FV_validation_errors += 1;

    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name =
                N'customer'

        AND PFX_table_name =
                N'CustomerDocument'

        AND PFX_prefix =
                N'CSTCD'

        AND PFX_is_active = 1
    )
    BEGIN

        SET @CSTCD_FV_seed_data_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCD_FV_seed_data_status = N'FAILED';
        SET @CSTCD_FV_validation_errors += 1;

    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @CSTCD_FV_expected_defaults TABLE
    (
        CSTCD_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        CSTCD_default_column_name          sysname NOT NULL,
        CSTCD_default_constraint_name      sysname NOT NULL,
        CSTCD_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @CSTCD_FV_default_current_id          tinyint;
    DECLARE @CSTCD_FV_default_max_id              tinyint;
    DECLARE @CSTCD_FV_default_column_name         sysname;
    DECLARE @CSTCD_FV_default_expected_name       sysname;
    DECLARE @CSTCD_FV_default_actual_name         sysname;
    DECLARE @CSTCD_FV_default_expected_definition nvarchar(4000);
    DECLARE @CSTCD_FV_default_actual_definition   nvarchar(4000);
    DECLARE @CSTCD_FV_default_expected_normalized nvarchar(4000);
    DECLARE @CSTCD_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @CSTCD_FV_invalid_defaults            int = 0;


    INSERT INTO @CSTCD_FV_expected_defaults
    (
        CSTCD_default_column_name,
        CSTCD_default_constraint_name,
        CSTCD_default_expected_definition
    )
    VALUES
    (
        N'CSTCD_created_at',
        N'DF_CSTCD_created_at',
        N'sysdatetime'
    ),
    (
        N'CSTCD_updated_at',
        N'DF_CSTCD_updated_at',
        N'sysdatetime'
    );


    SELECT
        @CSTCD_FV_default_current_id =
            MIN(CSTCD_default_id),

        @CSTCD_FV_default_max_id =
            MAX(CSTCD_default_id)

    FROM @CSTCD_FV_expected_defaults;


    WHILE @CSTCD_FV_default_current_id <=
        @CSTCD_FV_default_max_id
    BEGIN

        SET @CSTCD_FV_default_column_name = NULL;
        SET @CSTCD_FV_default_expected_name = NULL;
        SET @CSTCD_FV_default_actual_name = NULL;
        SET @CSTCD_FV_default_expected_definition = NULL;
        SET @CSTCD_FV_default_actual_definition = NULL;


        SELECT
            @CSTCD_FV_default_column_name =
                CSTCD_default_column_name,

            @CSTCD_FV_default_expected_name =
                CSTCD_default_constraint_name,

            @CSTCD_FV_default_expected_definition =
                CSTCD_default_expected_definition

        FROM @CSTCD_FV_expected_defaults

        WHERE CSTCD_default_id =
                @CSTCD_FV_default_current_id;


        SELECT
            @CSTCD_FV_default_actual_name =
                dc.name,

            @CSTCD_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND c.name =
                @CSTCD_FV_default_column_name;


        SET @CSTCD_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CSTCD_FV_default_expected_definition,
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


        SET @CSTCD_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CSTCD_FV_default_actual_definition,
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


        IF @CSTCD_FV_default_actual_name IS NULL

        OR @CSTCD_FV_default_actual_name <>
                @CSTCD_FV_default_expected_name

        OR @CSTCD_FV_default_actual_definition IS NULL

        OR @CSTCD_FV_default_actual_normalized <>
                @CSTCD_FV_default_expected_normalized
        BEGIN

            SET @CSTCD_FV_invalid_defaults += 1;

        END;


        SET @CSTCD_FV_default_current_id += 1;

    END;


    IF @CSTCD_FV_invalid_defaults = 0
    BEGIN

        SET @CSTCD_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCD_FV_defaults_status = N'FAILED';
        SET @CSTCD_FV_validation_errors += 1;

    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CSTCD_FV_uq_actual_name        sysname;
    DECLARE @CSTCD_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @CSTCD_FV_uq_is_disabled        bit;
    DECLARE @CSTCD_FV_uq_data_space         sysname;


    SELECT
        @CSTCD_FV_uq_actual_name =
            kc.name,

        @CSTCD_FV_uq_is_disabled =
            i.is_disabled,

        @CSTCD_FV_uq_data_space =
            ds.name,

        @CSTCD_FV_uq_actual_columns =
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
            OBJECT_ID(N'customer.CustomerDocument')

    AND kc.type =
            N'UQ'

    AND kc.name =
            N'UQ_CSTCD_document';


    IF @CSTCD_FV_uq_actual_name =
            N'UQ_CSTCD_document'

    AND @CSTCD_FV_uq_actual_columns =
            N'CSTCD_DTP_id|CSTCD_value'

    AND @CSTCD_FV_uq_is_disabled = 0

    AND @CSTCD_FV_uq_data_space =
            N'FG_CORE'
    BEGIN

        SET @CSTCD_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCD_FV_uniques_status = N'FAILED';
        SET @CSTCD_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CSTCD_FV_invalid_foreign_keys int = 0;


    /*--------------------------------------------------------------------------
        FK_CSTCD_CST
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.Customer')

        AND fk.name =
                N'FK_CSTCD_CST'

        AND fk.delete_referential_action = 0

        AND fk.update_referential_action = 0

        AND fk.is_disabled = 0

        AND fk.is_not_trusted = 0

        AND
        (
            SELECT COUNT(*)

            FROM sys.foreign_key_columns AS fkc

            WHERE fkc.constraint_object_id =
                    fk.object_id
        ) = 1

        AND EXISTS
        (
            SELECT 1

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS pc
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'CSTCD_CST_id'

            AND rc.name =
                    N'CST_id'
        )
    )
    BEGIN

        SET @CSTCD_FV_invalid_foreign_keys += 1;

    END;


    /*--------------------------------------------------------------------------
        FK_CSTCD_DTP
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND fk.name =
                N'FK_CSTCD_DTP'

        AND fk.delete_referential_action = 0

        AND fk.update_referential_action = 0

        AND fk.is_disabled = 0

        AND fk.is_not_trusted = 0

        AND
        (
            SELECT COUNT(*)

            FROM sys.foreign_key_columns AS fkc

            WHERE fkc.constraint_object_id =
                    fk.object_id
        ) = 1

        AND EXISTS
        (
            SELECT 1

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS pc
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'CSTCD_DTP_id'

            AND rc.name =
                    N'DTP_id'
        )
    )
    BEGIN

        SET @CSTCD_FV_invalid_foreign_keys += 1;

    END;


    /*--------------------------------------------------------------------------
        ENSURE EXACT EXPECTED FOREIGN KEY COUNT
    --------------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerDocument')
    ) <> 2
    BEGIN

        SET @CSTCD_FV_invalid_foreign_keys += 1;

    END;


    IF @CSTCD_FV_invalid_foreign_keys = 0
    BEGIN

        SET @CSTCD_FV_foreign_keys_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCD_FV_foreign_keys_status = N'FAILED';
        SET @CSTCD_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @CSTCD_FV_table_status;
    PRINT N'        Primary Key                   : ' + @CSTCD_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @CSTCD_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @CSTCD_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @CSTCD_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @CSTCD_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @CSTCD_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @CSTCD_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @CSTCD_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @CSTCD_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @CSTCD_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @CSTCD_FV_validation_errors = 0
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
                @CSTCD_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50590,
            N'Final validation failed for customer.CustomerDocument.',
            1;

    END;


    PRINT N'';