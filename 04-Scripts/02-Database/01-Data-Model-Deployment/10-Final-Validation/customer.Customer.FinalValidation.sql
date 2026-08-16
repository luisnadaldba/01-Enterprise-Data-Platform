    PRINT N'    customer.Customer';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @CST_FV_validation_errors int = 0;

    DECLARE @CST_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CST_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CST_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CST_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CST_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CST_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CST_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CST_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CST_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CST_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CST_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'customer.Customer', N'U') IS NOT NULL
    BEGIN
        SET @CST_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CST_FV_table_status = N'FAILED';
        SET @CST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @CST_FV_pk_actual_name     sysname;
    DECLARE @CST_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @CST_FV_pk_data_space      sysname;


    SELECT
        @CST_FV_pk_actual_name = kc.name,
        @CST_FV_pk_data_space = ds.name,

        @CST_FV_pk_actual_columns =
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
            OBJECT_ID(N'customer.Customer')

    AND kc.type = N'PK';


    IF @CST_FV_pk_actual_name = N'PK_CST'
    AND @CST_FV_pk_actual_columns = N'CST_id'
    AND @CST_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @CST_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CST_FV_primary_key_status = N'FAILED';
        SET @CST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @CST_FV_expected_column_count int = 7;
    DECLARE @CST_FV_actual_column_count   int;


    SELECT
        @CST_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'customer.Customer');


    IF @CST_FV_actual_column_count =
            @CST_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'customer.Customer')

        AND c.name = N'CST_id'
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
                OBJECT_ID(N'customer.Customer')

        AND ic.name = N'CST_id'
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
                OBJECT_ID(N'customer.Customer')

        AND c.name = N'CST_CSTCT_id'
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
                OBJECT_ID(N'customer.Customer')

        AND c.name = N'CST_is_active'
        AND t.name = N'bit'
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
                OBJECT_ID(N'customer.Customer')

        AND c.name = N'CST_name'
        AND t.name = N'nvarchar'
        AND c.max_length = 400
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'customer.Customer')

        AND c.name = N'CST_birth_date'
        AND t.name = N'date'
        AND c.is_nullable = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'customer.Customer')

        AND c.name = N'CST_created_at'
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
                OBJECT_ID(N'customer.Customer')

        AND c.name = N'CST_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @CST_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CST_FV_columns_status = N'FAILED';
        SET @CST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @CST_FV_expected_documentation TABLE
    (
        CST_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        CST_doc_object_type           nvarchar(10) NOT NULL,
        CST_doc_column_name           sysname NULL,
        CST_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @CST_FV_doc_current_id        tinyint;
    DECLARE @CST_FV_doc_max_id            tinyint;
    DECLARE @CST_FV_doc_object_type       nvarchar(10);
    DECLARE @CST_FV_doc_column_name       sysname;
    DECLARE @CST_FV_doc_expected_value    nvarchar(4000);
    DECLARE @CST_FV_doc_actual_value      nvarchar(4000);
    DECLARE @CST_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            customer.Customer.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @CST_FV_expected_documentation
    (
        CST_doc_object_type,
        CST_doc_column_name,
        CST_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the core identity and lifecycle information of identified customers in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'CST_id',
        N'Primary key of customer.Customer.'
    ),
    (
        N'COLUMN',
        N'CST_CSTCT_id',
        N'Foreign key of customer.CustomerType.'
    ),
    (
        N'COLUMN',
        N'CST_is_active',
        N'Indicates whether the customer is currently active.'
    ),
    (
        N'COLUMN',
        N'CST_name',
        N'Stores the customer name, representing the full name for individuals or the company name for legal entities.'
    ),
    (
        N'COLUMN',
        N'CST_birth_date',
        N'Stores the birth date of an individual customer when provided and applicable.'
    ),
    (
        N'COLUMN',
        N'CST_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'CST_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @CST_FV_doc_current_id =
            MIN(CST_doc_id),

        @CST_FV_doc_max_id =
            MAX(CST_doc_id)

    FROM @CST_FV_expected_documentation;


    WHILE @CST_FV_doc_current_id <=
        @CST_FV_doc_max_id
    BEGIN

        SET @CST_FV_doc_object_type = NULL;
        SET @CST_FV_doc_column_name = NULL;
        SET @CST_FV_doc_expected_value = NULL;
        SET @CST_FV_doc_actual_value = NULL;


        SELECT
            @CST_FV_doc_object_type =
                CST_doc_object_type,

            @CST_FV_doc_column_name =
                CST_doc_column_name,

            @CST_FV_doc_expected_value =
                CST_doc_expected_description

        FROM @CST_FV_expected_documentation

        WHERE CST_doc_id =
                @CST_FV_doc_current_id;


        IF @CST_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @CST_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'customer.Customer')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @CST_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'customer.Customer')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @CST_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @CST_FV_doc_actual_value,
            N''
        )
        <>
        @CST_FV_doc_expected_value
        BEGIN

            SET @CST_FV_invalid_documentation += 1;

        END;


        SET @CST_FV_doc_current_id += 1;

    END;


    IF @CST_FV_invalid_documentation = 0
    BEGIN
        SET @CST_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CST_FV_documentation_status = N'FAILED';
        SET @CST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'customer'
        AND PFX_table_name = N'Customer'
        AND PFX_prefix = N'CST'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @CST_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CST_FV_seed_data_status = N'FAILED';
        SET @CST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @CST_FV_expected_defaults TABLE
    (
        CST_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        CST_default_column_name          sysname NOT NULL,
        CST_default_constraint_name      sysname NOT NULL,
        CST_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @CST_FV_default_current_id          tinyint;
    DECLARE @CST_FV_default_max_id              tinyint;
    DECLARE @CST_FV_default_column_name         sysname;
    DECLARE @CST_FV_default_expected_name       sysname;
    DECLARE @CST_FV_default_actual_name         sysname;
    DECLARE @CST_FV_default_expected_definition nvarchar(4000);
    DECLARE @CST_FV_default_actual_definition   nvarchar(4000);
    DECLARE @CST_FV_default_expected_normalized nvarchar(4000);
    DECLARE @CST_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @CST_FV_invalid_defaults            int = 0;


    INSERT INTO @CST_FV_expected_defaults
    (
        CST_default_column_name,
        CST_default_constraint_name,
        CST_default_expected_definition
    )
    VALUES
    (
        N'CST_is_active',
        N'DF_CST_is_active',
        N'1'
    ),
    (
        N'CST_created_at',
        N'DF_CST_created_at',
        N'sysdatetime'
    ),
    (
        N'CST_updated_at',
        N'DF_CST_updated_at',
        N'sysdatetime'
    );


    SELECT
        @CST_FV_default_current_id =
            MIN(CST_default_id),

        @CST_FV_default_max_id =
            MAX(CST_default_id)

    FROM @CST_FV_expected_defaults;


    WHILE @CST_FV_default_current_id <=
        @CST_FV_default_max_id
    BEGIN

        SET @CST_FV_default_column_name = NULL;
        SET @CST_FV_default_expected_name = NULL;
        SET @CST_FV_default_actual_name = NULL;
        SET @CST_FV_default_expected_definition = NULL;
        SET @CST_FV_default_actual_definition = NULL;


        SELECT
            @CST_FV_default_column_name =
                CST_default_column_name,

            @CST_FV_default_expected_name =
                CST_default_constraint_name,

            @CST_FV_default_expected_definition =
                CST_default_expected_definition

        FROM @CST_FV_expected_defaults

        WHERE CST_default_id =
                @CST_FV_default_current_id;


        SELECT
            @CST_FV_default_actual_name =
                dc.name,

            @CST_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'customer.Customer')

        AND c.name =
                @CST_FV_default_column_name;


        SET @CST_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CST_FV_default_expected_definition,
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


        SET @CST_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CST_FV_default_actual_definition,
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


        IF @CST_FV_default_actual_name IS NULL
        OR @CST_FV_default_actual_name <>
                @CST_FV_default_expected_name
        OR @CST_FV_default_actual_definition IS NULL
        OR @CST_FV_default_actual_normalized <>
                @CST_FV_default_expected_normalized
        BEGIN

            SET @CST_FV_invalid_defaults += 1;

        END;


        SET @CST_FV_default_current_id += 1;

    END;


    IF @CST_FV_invalid_defaults = 0
    BEGIN
        SET @CST_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CST_FV_defaults_status = N'FAILED';
        SET @CST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        CHECK CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CST_FV_check_actual_name          sysname;
    DECLARE @CST_FV_check_actual_definition    nvarchar(4000);
    DECLARE @CST_FV_check_normalized           nvarchar(4000);
    DECLARE @CST_FV_check_is_disabled          bit;
    DECLARE @CST_FV_check_is_not_trusted       bit;


    SELECT
        @CST_FV_check_actual_name =
            cc.name,

        @CST_FV_check_actual_definition =
            cc.definition,

        @CST_FV_check_is_disabled =
            cc.is_disabled,

        @CST_FV_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'customer.Customer')

    AND cc.name =
            N'CK_CST_birth_date';


    SET @CST_FV_check_normalized =
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
                            @CST_FV_check_actual_definition,
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


    IF @CST_FV_check_actual_name =
            N'CK_CST_birth_date'

    AND @CST_FV_check_normalized LIKE
            N'%cst_birth_dateisnull%'

    AND @CST_FV_check_normalized LIKE
            N'%cst_birth_date<=convert(date,sysdatetime())%'

    AND @CST_FV_check_is_disabled = 0

    AND @CST_FV_check_is_not_trusted = 0
    BEGIN

        SET @CST_FV_checks_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CST_FV_checks_status = N'FAILED';
        SET @CST_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CST_FV_invalid_foreign_keys int = 0;


    /*--------------------------------------------------------------------------
        FK_CST_CSTCT
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.Customer')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.CustomerType')

        AND fk.name =
                N'FK_CST_CSTCT'

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
                ON  pc.object_id =
                        fkc.parent_object_id

                AND pc.column_id =
                        fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON  rc.object_id =
                        fkc.referenced_object_id

                AND rc.column_id =
                        fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND pc.name =
                    N'CST_CSTCT_id'

            AND rc.name =
                    N'CSTCT_id'
        )
    )
    BEGIN

        SET @CST_FV_invalid_foreign_keys += 1;

    END;


    IF @CST_FV_invalid_foreign_keys = 0
    BEGIN

        SET @CST_FV_foreign_keys_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CST_FV_foreign_keys_status = N'FAILED';
        SET @CST_FV_validation_errors += 1;

    END;


    /*==========================================================================
        ADDITIONAL INDEX VALIDATION
    ==========================================================================*/

    DECLARE @CST_FV_ix_actual_name         sysname;
    DECLARE @CST_FV_ix_actual_type         tinyint;
    DECLARE @CST_FV_ix_actual_is_unique    bit;
    DECLARE @CST_FV_ix_actual_is_disabled  bit;
    DECLARE @CST_FV_ix_actual_data_space   sysname;
    DECLARE @CST_FV_ix_actual_columns      nvarchar(4000);
    DECLARE @CST_FV_ix_actual_includes     nvarchar(4000);
    DECLARE @CST_FV_ix_actual_has_filter   bit;


    SELECT
        @CST_FV_ix_actual_name =
            i.name,

        @CST_FV_ix_actual_type =
            i.type,

        @CST_FV_ix_actual_is_unique =
            i.is_unique,

        @CST_FV_ix_actual_is_disabled =
            i.is_disabled,

        @CST_FV_ix_actual_data_space =
            ds.name,

        @CST_FV_ix_actual_has_filter =
            i.has_filter

    FROM sys.indexes AS i

    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id =
            i.data_space_id

    WHERE i.object_id =
            OBJECT_ID(N'customer.Customer')

    AND i.name =
            N'IX_CST_name';


    SELECT
        @CST_FV_ix_actual_columns =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),

                    c.name
                    + CASE
                        WHEN ic.is_descending_key = 1
                            THEN N' DESC'
                        ELSE N' ASC'
                    END
                ),
                N'|'
            )
            WITHIN GROUP
            (
                ORDER BY ic.key_ordinal
            )

    FROM sys.indexes AS i

    INNER JOIN sys.index_columns AS ic
        ON  ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal > 0

    INNER JOIN sys.columns AS c
        ON  c.object_id = ic.object_id
        AND c.column_id = ic.column_id

    WHERE i.object_id =
            OBJECT_ID(N'customer.Customer')

    AND i.name =
            N'IX_CST_name';


    SELECT
        @CST_FV_ix_actual_includes =
            STRING_AGG
            (
                CONVERT(nvarchar(max), c.name),
                N'|'
            )

    FROM sys.indexes AS i

    INNER JOIN sys.index_columns AS ic
        ON  ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1

    INNER JOIN sys.columns AS c
        ON  c.object_id = ic.object_id
        AND c.column_id = ic.column_id

    WHERE i.object_id =
            OBJECT_ID(N'customer.Customer')

    AND i.name =
            N'IX_CST_name';


    IF @CST_FV_ix_actual_name =
            N'IX_CST_name'

    AND @CST_FV_ix_actual_type = 2

    AND @CST_FV_ix_actual_is_unique = 0

    AND @CST_FV_ix_actual_is_disabled = 0

    AND @CST_FV_ix_actual_data_space =
            N'FG_CORE'

    AND @CST_FV_ix_actual_columns =
            N'CST_name ASC'

    AND @CST_FV_ix_actual_includes IS NULL

    AND @CST_FV_ix_actual_has_filter = 0
    BEGIN

        SET @CST_FV_indexes_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CST_FV_indexes_status = N'FAILED';
        SET @CST_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @CST_FV_table_status;
    PRINT N'        Primary Key                   : ' + @CST_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @CST_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @CST_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @CST_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @CST_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @CST_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @CST_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @CST_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @CST_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @CST_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @CST_FV_validation_errors = 0
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
                @CST_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50400,
            N'Final validation failed for customer.Customer.',
            1;

    END;


    PRINT N'';