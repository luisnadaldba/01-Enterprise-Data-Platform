    PRINT N'    ● reference.AdministrativeDivision';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @ADV_FV_validation_errors int = 0;

    DECLARE @ADV_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADV_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADV_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADV_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADV_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @ADV_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADV_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @ADV_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADV_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADV_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @ADV_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'reference.AdministrativeDivision', N'U') IS NOT NULL
    BEGIN

        SET @ADV_FV_table_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADV_FV_table_status = N'FAILED';
        SET @ADV_FV_validation_errors += 1;

    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @ADV_FV_pk_actual_name     sysname;
    DECLARE @ADV_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @ADV_FV_pk_data_space      sysname;


    SELECT
        @ADV_FV_pk_actual_name = kc.name,
        @ADV_FV_pk_data_space = ds.name,

        @ADV_FV_pk_actual_columns =
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
            OBJECT_ID(N'reference.AdministrativeDivision')

    AND kc.type = N'PK';


    IF @ADV_FV_pk_actual_name = N'PK_ADV'
    AND @ADV_FV_pk_actual_columns = N'ADV_id'
    AND @ADV_FV_pk_data_space = N'FG_CORE'
    BEGIN

        SET @ADV_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADV_FV_primary_key_status = N'FAILED';
        SET @ADV_FV_validation_errors += 1;

    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @ADV_FV_expected_column_count int = 6;
    DECLARE @ADV_FV_actual_column_count   int;


    SELECT
        @ADV_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'reference.AdministrativeDivision');


    IF @ADV_FV_actual_column_count =
            @ADV_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND c.name = N'ADV_id'
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
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ic.name = N'ADV_id'
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
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND c.name = N'ADV_CTR_id'
        AND t.name = N'tinyint'
        AND c.max_length = 1
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
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND c.name = N'ADV_code'
        AND t.name = N'char'
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
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND c.name = N'ADV_name'
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
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND c.name = N'ADV_created_at'
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
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND c.name = N'ADV_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )
    BEGIN

        SET @ADV_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADV_FV_columns_status = N'FAILED';
        SET @ADV_FV_validation_errors += 1;

    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @ADV_FV_expected_documentation TABLE
    (
        ADV_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        ADV_doc_object_type           nvarchar(10) NOT NULL,
        ADV_doc_column_name           sysname NULL,
        ADV_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @ADV_FV_doc_current_id        tinyint;
    DECLARE @ADV_FV_doc_max_id            tinyint;
    DECLARE @ADV_FV_doc_object_type       nvarchar(10);
    DECLARE @ADV_FV_doc_column_name       sysname;
    DECLARE @ADV_FV_doc_expected_value    nvarchar(4000);
    DECLARE @ADV_FV_doc_actual_value      nvarchar(4000);
    DECLARE @ADV_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            reference.AdministrativeDivision.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @ADV_FV_expected_documentation
    (
        ADV_doc_object_type,
        ADV_doc_column_name,
        ADV_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains controlled Brazilian administrative divisions associated with countries in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'ADV_id',
        N'Primary key of reference.AdministrativeDivision.'
    ),
    (
        N'COLUMN',
        N'ADV_CTR_id',
        N'Foreign key referencing reference.Country.'
    ),
    (
        N'COLUMN',
        N'ADV_code',
        N'Stores the official two-character abbreviation of the administrative division.'
    ),
    (
        N'COLUMN',
        N'ADV_name',
        N'Stores the official name used to identify the administrative division.'
    ),
    (
        N'COLUMN',
        N'ADV_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'ADV_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @ADV_FV_doc_current_id =
            MIN(ADV_doc_id),

        @ADV_FV_doc_max_id =
            MAX(ADV_doc_id)

    FROM @ADV_FV_expected_documentation;


    WHILE @ADV_FV_doc_current_id <=
        @ADV_FV_doc_max_id
    BEGIN

        SET @ADV_FV_doc_object_type = NULL;
        SET @ADV_FV_doc_column_name = NULL;
        SET @ADV_FV_doc_expected_value = NULL;
        SET @ADV_FV_doc_actual_value = NULL;


        SELECT
            @ADV_FV_doc_object_type =
                ADV_doc_object_type,

            @ADV_FV_doc_column_name =
                ADV_doc_column_name,

            @ADV_FV_doc_expected_value =
                ADV_doc_expected_description

        FROM @ADV_FV_expected_documentation

        WHERE ADV_doc_id =
                @ADV_FV_doc_current_id;


        IF @ADV_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @ADV_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @ADV_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @ADV_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @ADV_FV_doc_actual_value,
            N''
        )
        <>
        @ADV_FV_doc_expected_value
        BEGIN

            SET @ADV_FV_invalid_documentation += 1;

        END;


        SET @ADV_FV_doc_current_id += 1;

    END;


    IF @ADV_FV_invalid_documentation = 0
    BEGIN

        SET @ADV_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADV_FV_documentation_status = N'FAILED';
        SET @ADV_FV_validation_errors += 1;

    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @ADV_FV_expected_defaults TABLE
    (
        ADV_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        ADV_default_column_name          sysname NOT NULL,
        ADV_default_constraint_name      sysname NOT NULL,
        ADV_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @ADV_FV_default_current_id          tinyint;
    DECLARE @ADV_FV_default_max_id              tinyint;
    DECLARE @ADV_FV_default_column_name         sysname;
    DECLARE @ADV_FV_default_expected_name       sysname;
    DECLARE @ADV_FV_default_actual_name         sysname;
    DECLARE @ADV_FV_default_expected_definition nvarchar(4000);
    DECLARE @ADV_FV_default_actual_definition   nvarchar(4000);
    DECLARE @ADV_FV_default_expected_normalized nvarchar(4000);
    DECLARE @ADV_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @ADV_FV_invalid_defaults            int = 0;


    INSERT INTO @ADV_FV_expected_defaults
    (
        ADV_default_column_name,
        ADV_default_constraint_name,
        ADV_default_expected_definition
    )
    VALUES
    (
        N'ADV_created_at',
        N'DF_ADV_created_at',
        N'sysdatetime'
    ),
    (
        N'ADV_updated_at',
        N'DF_ADV_updated_at',
        N'sysdatetime'
    );


    SELECT
        @ADV_FV_default_current_id =
            MIN(ADV_default_id),

        @ADV_FV_default_max_id =
            MAX(ADV_default_id)

    FROM @ADV_FV_expected_defaults;


    WHILE @ADV_FV_default_current_id <=
        @ADV_FV_default_max_id
    BEGIN

        SET @ADV_FV_default_column_name = NULL;
        SET @ADV_FV_default_expected_name = NULL;
        SET @ADV_FV_default_actual_name = NULL;
        SET @ADV_FV_default_expected_definition = NULL;
        SET @ADV_FV_default_actual_definition = NULL;


        SELECT
            @ADV_FV_default_column_name =
                ADV_default_column_name,

            @ADV_FV_default_expected_name =
                ADV_default_constraint_name,

            @ADV_FV_default_expected_definition =
                ADV_default_expected_definition

        FROM @ADV_FV_expected_defaults

        WHERE ADV_default_id =
                @ADV_FV_default_current_id;


        SELECT
            @ADV_FV_default_actual_name =
                dc.name,

            @ADV_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND c.name =
                @ADV_FV_default_column_name;


        SET @ADV_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @ADV_FV_default_expected_definition,
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


        SET @ADV_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @ADV_FV_default_actual_definition,
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


        IF @ADV_FV_default_actual_name IS NULL
        OR @ADV_FV_default_actual_name <>
                @ADV_FV_default_expected_name
        OR @ADV_FV_default_actual_definition IS NULL
        OR @ADV_FV_default_actual_normalized <>
                @ADV_FV_default_expected_normalized
        BEGIN

            SET @ADV_FV_invalid_defaults += 1;

        END;


        SET @ADV_FV_default_current_id += 1;

    END;


    IF @ADV_FV_invalid_defaults = 0
    BEGIN

        SET @ADV_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADV_FV_defaults_status = N'FAILED';
        SET @ADV_FV_validation_errors += 1;

    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @ADV_FV_uq_actual_name        sysname;
    DECLARE @ADV_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @ADV_FV_uq_actual_disabled    bit;
    DECLARE @ADV_FV_uq_actual_data_space  sysname;


    SELECT
        @ADV_FV_uq_actual_name =
            kc.name,

        @ADV_FV_uq_actual_disabled =
            i.is_disabled,

        @ADV_FV_uq_actual_data_space =
            ds.name,

        @ADV_FV_uq_actual_columns =
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
            OBJECT_ID(N'reference.AdministrativeDivision')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_ADV_country_code';


    IF @ADV_FV_uq_actual_name =
            N'UQ_ADV_country_code'

    AND @ADV_FV_uq_actual_columns =
            N'ADV_CTR_id|ADV_code'

    AND @ADV_FV_uq_actual_disabled = 0

    AND @ADV_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @ADV_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADV_FV_uniques_status = N'FAILED';
        SET @ADV_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @ADV_FV_fk_actual_name                sysname;
    DECLARE @ADV_FV_fk_parent_columns             nvarchar(4000);
    DECLARE @ADV_FV_fk_referenced_columns         nvarchar(4000);
    DECLARE @ADV_FV_fk_referenced_schema          sysname;
    DECLARE @ADV_FV_fk_referenced_table           sysname;
    DECLARE @ADV_FV_fk_delete_action              nvarchar(60);
    DECLARE @ADV_FV_fk_update_action              nvarchar(60);
    DECLARE @ADV_FV_fk_is_disabled                bit;
    DECLARE @ADV_FV_fk_is_not_trusted             bit;


    SELECT
        @ADV_FV_fk_actual_name =
            fk.name,

        @ADV_FV_fk_referenced_schema =
            OBJECT_SCHEMA_NAME
            (
                fk.referenced_object_id
            ),

        @ADV_FV_fk_referenced_table =
            OBJECT_NAME
            (
                fk.referenced_object_id
            ),

        @ADV_FV_fk_delete_action =
            fk.delete_referential_action_desc,

        @ADV_FV_fk_update_action =
            fk.update_referential_action_desc,

        @ADV_FV_fk_is_disabled =
            fk.is_disabled,

        @ADV_FV_fk_is_not_trusted =
            fk.is_not_trusted,

        @ADV_FV_fk_parent_columns =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), pc.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY fkc.constraint_column_id
                )

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS pc
                ON  pc.object_id =
                        fkc.parent_object_id

                AND pc.column_id =
                        fkc.parent_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id
        ),

        @ADV_FV_fk_referenced_columns =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), rc.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY fkc.constraint_column_id
                )

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS rc
                ON  rc.object_id =
                        fkc.referenced_object_id

                AND rc.column_id =
                        fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
            OBJECT_ID(N'reference.AdministrativeDivision')

    AND fk.name =
            N'FK_ADV_CTR';


    IF @ADV_FV_fk_actual_name =
            N'FK_ADV_CTR'

    AND @ADV_FV_fk_parent_columns =
            N'ADV_CTR_id'

    AND @ADV_FV_fk_referenced_schema =
            N'reference'

    AND @ADV_FV_fk_referenced_table =
            N'Country'

    AND @ADV_FV_fk_referenced_columns =
            N'CTR_id'

    AND @ADV_FV_fk_delete_action =
            N'NO_ACTION'

    AND @ADV_FV_fk_update_action =
            N'NO_ACTION'

    AND @ADV_FV_fk_is_disabled = 0

    AND @ADV_FV_fk_is_not_trusted = 0

    AND
    (
        SELECT COUNT(*)

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'reference.AdministrativeDivision')
    ) = 1
    BEGIN

        SET @ADV_FV_foreign_keys_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADV_FV_foreign_keys_status = N'FAILED';
        SET @ADV_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @ADV_FV_table_status;
    PRINT N'        Primary Key                   : ' + @ADV_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @ADV_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @ADV_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @ADV_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @ADV_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @ADV_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @ADV_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @ADV_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @ADV_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @ADV_FV_temporal_integrity_status;
    PRINT N'';

    IF @ADV_FV_validation_errors = 0
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
                @ADV_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @ADV_FV_validation_errors > 0
    BEGIN

        ;THROW 50200,
            N'Final validation failed for reference.AdministrativeDivision.',
            1;

    END;