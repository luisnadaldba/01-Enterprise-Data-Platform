    PRINT N'    ● reference.City';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @CTY_FV_validation_errors int = 0;

    DECLARE @CTY_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTY_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTY_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTY_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTY_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @CTY_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTY_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CTY_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTY_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CTY_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CTY_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'reference.City', N'U') IS NOT NULL
    BEGIN

        SET @CTY_FV_table_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTY_FV_table_status = N'FAILED';
        SET @CTY_FV_validation_errors += 1;

    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @CTY_FV_pk_actual_name     sysname;
    DECLARE @CTY_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @CTY_FV_pk_data_space      sysname;


    SELECT
        @CTY_FV_pk_actual_name = kc.name,
        @CTY_FV_pk_data_space = ds.name,

        @CTY_FV_pk_actual_columns =
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
            OBJECT_ID(N'reference.City')

    AND kc.type = N'PK';


    IF @CTY_FV_pk_actual_name = N'PK_CTY'
    AND @CTY_FV_pk_actual_columns = N'CTY_id'
    AND @CTY_FV_pk_data_space = N'FG_CORE'
    BEGIN

        SET @CTY_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTY_FV_primary_key_status = N'FAILED';
        SET @CTY_FV_validation_errors += 1;

    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @CTY_FV_expected_column_count int = 5;
    DECLARE @CTY_FV_actual_column_count   int;


    SELECT
        @CTY_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'reference.City');


    IF @CTY_FV_actual_column_count =
            @CTY_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'reference.City')

        AND c.name = N'CTY_id'
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
                OBJECT_ID(N'reference.City')

        AND ic.name = N'CTY_id'
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
                OBJECT_ID(N'reference.City')

        AND c.name = N'CTY_ADV_id'
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
                OBJECT_ID(N'reference.City')

        AND c.name = N'CTY_name'
        AND t.name = N'nvarchar'
        AND c.max_length = 300
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
                OBJECT_ID(N'reference.City')

        AND c.name = N'CTY_created_at'
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
                OBJECT_ID(N'reference.City')

        AND c.name = N'CTY_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )
    BEGIN

        SET @CTY_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTY_FV_columns_status = N'FAILED';
        SET @CTY_FV_validation_errors += 1;

    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @CTY_FV_expected_documentation TABLE
    (
        CTY_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        CTY_doc_object_type           nvarchar(10) NOT NULL,
        CTY_doc_column_name           sysname NULL,
        CTY_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @CTY_FV_doc_current_id        tinyint;
    DECLARE @CTY_FV_doc_max_id            tinyint;
    DECLARE @CTY_FV_doc_object_type       nvarchar(10);
    DECLARE @CTY_FV_doc_column_name       sysname;
    DECLARE @CTY_FV_doc_expected_value    nvarchar(4000);
    DECLARE @CTY_FV_doc_actual_value      nvarchar(4000);
    DECLARE @CTY_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            reference.City.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @CTY_FV_expected_documentation
    (
        CTY_doc_object_type,
        CTY_doc_column_name,
        CTY_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains controlled Brazilian cities associated with administrative divisions in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'CTY_id',
        N'Primary key of reference.City.'
    ),
    (
        N'COLUMN',
        N'CTY_ADV_id',
        N'Foreign key referencing reference.AdministrativeDivision.'
    ),
    (
        N'COLUMN',
        N'CTY_name',
        N'Stores the official name used to identify the city.'
    ),
    (
        N'COLUMN',
        N'CTY_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'CTY_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @CTY_FV_doc_current_id =
            MIN(CTY_doc_id),

        @CTY_FV_doc_max_id =
            MAX(CTY_doc_id)

    FROM @CTY_FV_expected_documentation;


    WHILE @CTY_FV_doc_current_id <=
        @CTY_FV_doc_max_id
    BEGIN

        SET @CTY_FV_doc_object_type = NULL;
        SET @CTY_FV_doc_column_name = NULL;
        SET @CTY_FV_doc_expected_value = NULL;
        SET @CTY_FV_doc_actual_value = NULL;


        SELECT
            @CTY_FV_doc_object_type =
                CTY_doc_object_type,

            @CTY_FV_doc_column_name =
                CTY_doc_column_name,

            @CTY_FV_doc_expected_value =
                CTY_doc_expected_description

        FROM @CTY_FV_expected_documentation

        WHERE CTY_doc_id =
                @CTY_FV_doc_current_id;


        IF @CTY_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @CTY_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'reference.City')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @CTY_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'reference.City')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @CTY_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @CTY_FV_doc_actual_value,
            N''
        )
        <>
        @CTY_FV_doc_expected_value
        BEGIN

            SET @CTY_FV_invalid_documentation += 1;

        END;


        SET @CTY_FV_doc_current_id += 1;

    END;


    IF @CTY_FV_invalid_documentation = 0
    BEGIN

        SET @CTY_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTY_FV_documentation_status = N'FAILED';
        SET @CTY_FV_validation_errors += 1;

    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @CTY_FV_expected_defaults TABLE
    (
        CTY_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        CTY_default_column_name          sysname NOT NULL,
        CTY_default_constraint_name      sysname NOT NULL,
        CTY_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @CTY_FV_default_current_id          tinyint;
    DECLARE @CTY_FV_default_max_id              tinyint;
    DECLARE @CTY_FV_default_column_name         sysname;
    DECLARE @CTY_FV_default_expected_name       sysname;
    DECLARE @CTY_FV_default_actual_name         sysname;
    DECLARE @CTY_FV_default_expected_definition nvarchar(4000);
    DECLARE @CTY_FV_default_actual_definition   nvarchar(4000);
    DECLARE @CTY_FV_default_expected_normalized nvarchar(4000);
    DECLARE @CTY_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @CTY_FV_invalid_defaults            int = 0;


    INSERT INTO @CTY_FV_expected_defaults
    (
        CTY_default_column_name,
        CTY_default_constraint_name,
        CTY_default_expected_definition
    )
    VALUES
    (
        N'CTY_created_at',
        N'DF_CTY_created_at',
        N'sysdatetime'
    ),
    (
        N'CTY_updated_at',
        N'DF_CTY_updated_at',
        N'sysdatetime'
    );


    SELECT
        @CTY_FV_default_current_id =
            MIN(CTY_default_id),

        @CTY_FV_default_max_id =
            MAX(CTY_default_id)

    FROM @CTY_FV_expected_defaults;


    WHILE @CTY_FV_default_current_id <=
        @CTY_FV_default_max_id
    BEGIN

        SET @CTY_FV_default_column_name = NULL;
        SET @CTY_FV_default_expected_name = NULL;
        SET @CTY_FV_default_actual_name = NULL;
        SET @CTY_FV_default_expected_definition = NULL;
        SET @CTY_FV_default_actual_definition = NULL;


        SELECT
            @CTY_FV_default_column_name =
                CTY_default_column_name,

            @CTY_FV_default_expected_name =
                CTY_default_constraint_name,

            @CTY_FV_default_expected_definition =
                CTY_default_expected_definition

        FROM @CTY_FV_expected_defaults

        WHERE CTY_default_id =
                @CTY_FV_default_current_id;


        SELECT
            @CTY_FV_default_actual_name =
                dc.name,

            @CTY_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'reference.City')

        AND c.name =
                @CTY_FV_default_column_name;


        SET @CTY_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CTY_FV_default_expected_definition,
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


        SET @CTY_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CTY_FV_default_actual_definition,
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


        IF @CTY_FV_default_actual_name IS NULL
        OR @CTY_FV_default_actual_name <>
                @CTY_FV_default_expected_name
        OR @CTY_FV_default_actual_definition IS NULL
        OR @CTY_FV_default_actual_normalized <>
                @CTY_FV_default_expected_normalized
        BEGIN

            SET @CTY_FV_invalid_defaults += 1;

        END;


        SET @CTY_FV_default_current_id += 1;

    END;


    IF @CTY_FV_invalid_defaults = 0
    BEGIN

        SET @CTY_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTY_FV_defaults_status = N'FAILED';
        SET @CTY_FV_validation_errors += 1;

    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CTY_FV_uq_actual_name        sysname;
    DECLARE @CTY_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @CTY_FV_uq_actual_disabled    bit;
    DECLARE @CTY_FV_uq_actual_data_space  sysname;


    SELECT
        @CTY_FV_uq_actual_name =
            kc.name,

        @CTY_FV_uq_actual_disabled =
            i.is_disabled,

        @CTY_FV_uq_actual_data_space =
            ds.name,

        @CTY_FV_uq_actual_columns =
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
            OBJECT_ID(N'reference.City')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_CTY_administrative_division_name';


    IF @CTY_FV_uq_actual_name =
            N'UQ_CTY_administrative_division_name'

    AND @CTY_FV_uq_actual_columns =
            N'CTY_ADV_id|CTY_name'

    AND @CTY_FV_uq_actual_disabled = 0

    AND @CTY_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @CTY_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTY_FV_uniques_status = N'FAILED';
        SET @CTY_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CTY_FV_fk_actual_name                sysname;
    DECLARE @CTY_FV_fk_parent_columns             nvarchar(4000);
    DECLARE @CTY_FV_fk_referenced_columns         nvarchar(4000);
    DECLARE @CTY_FV_fk_referenced_schema          sysname;
    DECLARE @CTY_FV_fk_referenced_table           sysname;
    DECLARE @CTY_FV_fk_delete_action              nvarchar(60);
    DECLARE @CTY_FV_fk_update_action              nvarchar(60);
    DECLARE @CTY_FV_fk_is_disabled                bit;
    DECLARE @CTY_FV_fk_is_not_trusted             bit;


    SELECT
        @CTY_FV_fk_actual_name =
            fk.name,

        @CTY_FV_fk_referenced_schema =
            OBJECT_SCHEMA_NAME
            (
                fk.referenced_object_id
            ),

        @CTY_FV_fk_referenced_table =
            OBJECT_NAME
            (
                fk.referenced_object_id
            ),

        @CTY_FV_fk_delete_action =
            fk.delete_referential_action_desc,

        @CTY_FV_fk_update_action =
            fk.update_referential_action_desc,

        @CTY_FV_fk_is_disabled =
            fk.is_disabled,

        @CTY_FV_fk_is_not_trusted =
            fk.is_not_trusted,

        @CTY_FV_fk_parent_columns =
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

        @CTY_FV_fk_referenced_columns =
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
            OBJECT_ID(N'reference.City')

    AND fk.name =
            N'FK_CTY_ADV';


    IF @CTY_FV_fk_actual_name =
            N'FK_CTY_ADV'

    AND @CTY_FV_fk_parent_columns =
            N'CTY_ADV_id'

    AND @CTY_FV_fk_referenced_schema =
            N'reference'

    AND @CTY_FV_fk_referenced_table =
            N'AdministrativeDivision'

    AND @CTY_FV_fk_referenced_columns =
            N'ADV_id'

    AND @CTY_FV_fk_delete_action =
            N'NO_ACTION'

    AND @CTY_FV_fk_update_action =
            N'NO_ACTION'

    AND @CTY_FV_fk_is_disabled = 0

    AND @CTY_FV_fk_is_not_trusted = 0

    AND
    (
        SELECT COUNT(*)

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'reference.City')
    ) = 1
    BEGIN

        SET @CTY_FV_foreign_keys_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CTY_FV_foreign_keys_status = N'FAILED';
        SET @CTY_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @CTY_FV_table_status;
    PRINT N'        Primary Key                   : ' + @CTY_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @CTY_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @CTY_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @CTY_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @CTY_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @CTY_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @CTY_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @CTY_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @CTY_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @CTY_FV_temporal_integrity_status;
    PRINT N'';

    IF @CTY_FV_validation_errors = 0
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
                @CTY_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @CTY_FV_validation_errors > 0
    BEGIN

        ;THROW 50200,
            N'Final validation failed for reference.City.',
            1;

    END;