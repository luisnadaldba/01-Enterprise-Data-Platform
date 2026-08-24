    PRINT N'    ● reference.Address';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @ADR_FV_validation_errors int = 0;

    DECLARE @ADR_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADR_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADR_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADR_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADR_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @ADR_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADR_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADR_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADR_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @ADR_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @ADR_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'reference.Address', N'U') IS NOT NULL
    BEGIN

        SET @ADR_FV_table_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADR_FV_table_status = N'FAILED';
        SET @ADR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @ADR_FV_pk_actual_name     sysname;
    DECLARE @ADR_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @ADR_FV_pk_data_space      sysname;


    SELECT
        @ADR_FV_pk_actual_name = kc.name,
        @ADR_FV_pk_data_space = ds.name,

        @ADR_FV_pk_actual_columns =
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
            OBJECT_ID(N'reference.Address')

    AND kc.type = N'PK';


    IF @ADR_FV_pk_actual_name = N'PK_ADR'
    AND @ADR_FV_pk_actual_columns = N'ADR_id'
    AND @ADR_FV_pk_data_space = N'FG_CORE'
    BEGIN

        SET @ADR_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADR_FV_primary_key_status = N'FAILED';
        SET @ADR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @ADR_FV_expected_column_count int = 6;
    DECLARE @ADR_FV_actual_column_count   int;


    SELECT
        @ADR_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'reference.Address');


    IF @ADR_FV_actual_column_count =
            @ADR_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'reference.Address')

        AND c.name = N'ADR_id'
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
                OBJECT_ID(N'reference.Address')

        AND ic.name = N'ADR_id'
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
                OBJECT_ID(N'reference.Address')

        AND c.name = N'ADR_CTY_id'
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
                OBJECT_ID(N'reference.Address')

        AND c.name = N'ADR_postal_code'
        AND t.name = N'varchar'
        AND c.max_length = 8
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
                OBJECT_ID(N'reference.Address')

        AND c.name = N'ADR_street'
        AND t.name = N'nvarchar'
        AND c.max_length = 400
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
                OBJECT_ID(N'reference.Address')

        AND c.name = N'ADR_created_at'
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
                OBJECT_ID(N'reference.Address')

        AND c.name = N'ADR_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )
    BEGIN

        SET @ADR_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADR_FV_columns_status = N'FAILED';
        SET @ADR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @ADR_FV_expected_documentation TABLE
    (
        ADR_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        ADR_doc_object_type           nvarchar(10) NOT NULL,
        ADR_doc_column_name           sysname NULL,
        ADR_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @ADR_FV_doc_current_id        tinyint;
    DECLARE @ADR_FV_doc_max_id            tinyint;
    DECLARE @ADR_FV_doc_object_type       nvarchar(10);
    DECLARE @ADR_FV_doc_column_name       sysname;
    DECLARE @ADR_FV_doc_expected_value    nvarchar(4000);
    DECLARE @ADR_FV_doc_actual_value      nvarchar(4000);
    DECLARE @ADR_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            reference.Address.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @ADR_FV_expected_documentation
    (
        ADR_doc_object_type,
        ADR_doc_column_name,
        ADR_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains reusable physical street address references associated with controlled cities in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'ADR_id',
        N'Primary key of reference.Address.'
    ),
    (
        N'COLUMN',
        N'ADR_CTY_id',
        N'Foreign key referencing reference.City.'
    ),
    (
        N'COLUMN',
        N'ADR_postal_code',
        N'Stores the eight-digit Brazilian postal code without presentation formatting.'
    ),
    (
        N'COLUMN',
        N'ADR_street',
        N'Stores the street or public-place name associated with the address reference.'
    ),
    (
        N'COLUMN',
        N'ADR_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'ADR_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @ADR_FV_doc_current_id =
            MIN(ADR_doc_id),

        @ADR_FV_doc_max_id =
            MAX(ADR_doc_id)

    FROM @ADR_FV_expected_documentation;


    WHILE @ADR_FV_doc_current_id <=
        @ADR_FV_doc_max_id
    BEGIN

        SET @ADR_FV_doc_object_type = NULL;
        SET @ADR_FV_doc_column_name = NULL;
        SET @ADR_FV_doc_expected_value = NULL;
        SET @ADR_FV_doc_actual_value = NULL;


        SELECT
            @ADR_FV_doc_object_type =
                ADR_doc_object_type,

            @ADR_FV_doc_column_name =
                ADR_doc_column_name,

            @ADR_FV_doc_expected_value =
                ADR_doc_expected_description

        FROM @ADR_FV_expected_documentation

        WHERE ADR_doc_id =
                @ADR_FV_doc_current_id;


        IF @ADR_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @ADR_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'reference.Address')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @ADR_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'reference.Address')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @ADR_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @ADR_FV_doc_actual_value,
            N''
        )
        <>
        @ADR_FV_doc_expected_value
        BEGIN

            SET @ADR_FV_invalid_documentation += 1;

        END;


        SET @ADR_FV_doc_current_id += 1;

    END;


    IF @ADR_FV_invalid_documentation = 0
    BEGIN

        SET @ADR_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADR_FV_documentation_status = N'FAILED';
        SET @ADR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @ADR_FV_expected_defaults TABLE
    (
        ADR_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        ADR_default_column_name          sysname NOT NULL,
        ADR_default_constraint_name      sysname NOT NULL,
        ADR_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @ADR_FV_default_current_id          tinyint;
    DECLARE @ADR_FV_default_max_id              tinyint;
    DECLARE @ADR_FV_default_column_name         sysname;
    DECLARE @ADR_FV_default_expected_name       sysname;
    DECLARE @ADR_FV_default_actual_name         sysname;
    DECLARE @ADR_FV_default_expected_definition nvarchar(4000);
    DECLARE @ADR_FV_default_actual_definition   nvarchar(4000);
    DECLARE @ADR_FV_default_expected_normalized nvarchar(4000);
    DECLARE @ADR_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @ADR_FV_invalid_defaults            int = 0;


    INSERT INTO @ADR_FV_expected_defaults
    (
        ADR_default_column_name,
        ADR_default_constraint_name,
        ADR_default_expected_definition
    )
    VALUES
    (
        N'ADR_created_at',
        N'DF_ADR_created_at',
        N'sysdatetime'
    ),
    (
        N'ADR_updated_at',
        N'DF_ADR_updated_at',
        N'sysdatetime'
    );


    SELECT
        @ADR_FV_default_current_id =
            MIN(ADR_default_id),

        @ADR_FV_default_max_id =
            MAX(ADR_default_id)

    FROM @ADR_FV_expected_defaults;


    WHILE @ADR_FV_default_current_id <=
        @ADR_FV_default_max_id
    BEGIN

        SET @ADR_FV_default_column_name = NULL;
        SET @ADR_FV_default_expected_name = NULL;
        SET @ADR_FV_default_actual_name = NULL;
        SET @ADR_FV_default_expected_definition = NULL;
        SET @ADR_FV_default_actual_definition = NULL;


        SELECT
            @ADR_FV_default_column_name =
                ADR_default_column_name,

            @ADR_FV_default_expected_name =
                ADR_default_constraint_name,

            @ADR_FV_default_expected_definition =
                ADR_default_expected_definition

        FROM @ADR_FV_expected_defaults

        WHERE ADR_default_id =
                @ADR_FV_default_current_id;


        SELECT
            @ADR_FV_default_actual_name =
                dc.name,

            @ADR_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'reference.Address')

        AND c.name =
                @ADR_FV_default_column_name;


        SET @ADR_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @ADR_FV_default_expected_definition,
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


        SET @ADR_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @ADR_FV_default_actual_definition,
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


        IF @ADR_FV_default_actual_name IS NULL
        OR @ADR_FV_default_actual_name <>
                @ADR_FV_default_expected_name
        OR @ADR_FV_default_actual_definition IS NULL
        OR @ADR_FV_default_actual_normalized <>
                @ADR_FV_default_expected_normalized
        BEGIN

            SET @ADR_FV_invalid_defaults += 1;

        END;


        SET @ADR_FV_default_current_id += 1;

    END;


    IF @ADR_FV_invalid_defaults = 0
    BEGIN

        SET @ADR_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADR_FV_defaults_status = N'FAILED';
        SET @ADR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        CHECK CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @ADR_FV_check_actual_name           sysname;
    DECLARE @ADR_FV_check_actual_definition     nvarchar(4000);
    DECLARE @ADR_FV_check_normalized_definition nvarchar(4000);
    DECLARE @ADR_FV_check_is_disabled           bit;
    DECLARE @ADR_FV_check_is_not_trusted        bit;


    SELECT
        @ADR_FV_check_actual_name =
            cc.name,

        @ADR_FV_check_actual_definition =
            cc.definition,

        @ADR_FV_check_is_disabled =
            cc.is_disabled,

        @ADR_FV_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'reference.Address')

    AND cc.name =
            N'CK_ADR_postal_code';


    SET @ADR_FV_check_normalized_definition =
        LOWER
        (
            REPLACE
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @ADR_FV_check_actual_definition,
                            N'[',
                            N''
                        ),
                        N']',
                        N''
                    ),
                    N' ',
                    N''
                ),
                NCHAR(9),
                N''
            )
        );


    IF @ADR_FV_check_actual_name =
            N'CK_ADR_postal_code'

    AND @ADR_FV_check_normalized_definition LIKE
            N'%len(adr_postal_code)=(8)%'

    AND @ADR_FV_check_normalized_definition LIKE
            N'%notadr_postal_codelike''%[^0-9]%''%'

    AND @ADR_FV_check_is_disabled = 0

    AND @ADR_FV_check_is_not_trusted = 0
    BEGIN

        SET @ADR_FV_checks_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADR_FV_checks_status = N'FAILED';
        SET @ADR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @ADR_FV_uq_actual_name        sysname;
    DECLARE @ADR_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @ADR_FV_uq_actual_disabled    bit;
    DECLARE @ADR_FV_uq_actual_data_space  sysname;


    SELECT
        @ADR_FV_uq_actual_name =
            kc.name,

        @ADR_FV_uq_actual_disabled =
            i.is_disabled,

        @ADR_FV_uq_actual_data_space =
            ds.name,

        @ADR_FV_uq_actual_columns =
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
            OBJECT_ID(N'reference.Address')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_ADR_city_postal_code_street';


    IF @ADR_FV_uq_actual_name =
            N'UQ_ADR_city_postal_code_street'

    AND @ADR_FV_uq_actual_columns =
            N'ADR_CTY_id|ADR_postal_code|ADR_street'

    AND @ADR_FV_uq_actual_disabled = 0

    AND @ADR_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @ADR_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADR_FV_uniques_status = N'FAILED';
        SET @ADR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @ADR_FV_fk_actual_name                sysname;
    DECLARE @ADR_FV_fk_parent_columns             nvarchar(4000);
    DECLARE @ADR_FV_fk_referenced_columns         nvarchar(4000);
    DECLARE @ADR_FV_fk_referenced_schema          sysname;
    DECLARE @ADR_FV_fk_referenced_table           sysname;
    DECLARE @ADR_FV_fk_delete_action              nvarchar(60);
    DECLARE @ADR_FV_fk_update_action              nvarchar(60);
    DECLARE @ADR_FV_fk_is_disabled                bit;
    DECLARE @ADR_FV_fk_is_not_trusted             bit;


    SELECT
        @ADR_FV_fk_actual_name =
            fk.name,

        @ADR_FV_fk_referenced_schema =
            OBJECT_SCHEMA_NAME
            (
                fk.referenced_object_id
            ),

        @ADR_FV_fk_referenced_table =
            OBJECT_NAME
            (
                fk.referenced_object_id
            ),

        @ADR_FV_fk_delete_action =
            fk.delete_referential_action_desc,

        @ADR_FV_fk_update_action =
            fk.update_referential_action_desc,

        @ADR_FV_fk_is_disabled =
            fk.is_disabled,

        @ADR_FV_fk_is_not_trusted =
            fk.is_not_trusted,

        @ADR_FV_fk_parent_columns =
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

        @ADR_FV_fk_referenced_columns =
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
            OBJECT_ID(N'reference.Address')

    AND fk.name =
            N'FK_ADR_CTY';


    IF @ADR_FV_fk_actual_name =
            N'FK_ADR_CTY'

    AND @ADR_FV_fk_parent_columns =
            N'ADR_CTY_id'

    AND @ADR_FV_fk_referenced_schema =
            N'reference'

    AND @ADR_FV_fk_referenced_table =
            N'City'

    AND @ADR_FV_fk_referenced_columns =
            N'CTY_id'

    AND @ADR_FV_fk_delete_action =
            N'NO_ACTION'

    AND @ADR_FV_fk_update_action =
            N'NO_ACTION'

    AND @ADR_FV_fk_is_disabled = 0

    AND @ADR_FV_fk_is_not_trusted = 0

    AND
    (
        SELECT COUNT(*)

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'reference.Address')
    ) = 1
    BEGIN

        SET @ADR_FV_foreign_keys_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @ADR_FV_foreign_keys_status = N'FAILED';
        SET @ADR_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @ADR_FV_table_status;
    PRINT N'        Primary Key                   : ' + @ADR_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @ADR_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @ADR_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @ADR_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @ADR_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @ADR_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @ADR_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @ADR_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @ADR_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @ADR_FV_temporal_integrity_status;
    PRINT N'';

    IF @ADR_FV_validation_errors = 0
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
                @ADR_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @ADR_FV_validation_errors > 0
    BEGIN

        ;THROW 50200,
            N'Final validation failed for reference.Address.',
            1;

    END;