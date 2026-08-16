    PRINT N'    customer.CustomerEmail';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @CSTEM_FV_validation_errors int = 0;

    DECLARE @CSTEM_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTEM_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTEM_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTEM_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTEM_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTEM_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTEM_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTEM_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CSTEM_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTEM_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTEM_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'customer.CustomerEmail', N'U') IS NOT NULL
    BEGIN
        SET @CSTEM_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTEM_FV_table_status = N'FAILED';
        SET @CSTEM_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @CSTEM_FV_pk_actual_name     sysname;
    DECLARE @CSTEM_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @CSTEM_FV_pk_data_space      sysname;


    SELECT
        @CSTEM_FV_pk_actual_name =
            kc.name,

        @CSTEM_FV_pk_data_space =
            ds.name,

        @CSTEM_FV_pk_actual_columns =
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
            OBJECT_ID(N'customer.CustomerEmail')

    AND kc.type =
            N'PK';


    IF @CSTEM_FV_pk_actual_name = N'PK_CSTEM'
    AND @CSTEM_FV_pk_actual_columns = N'CSTEM_id'
    AND @CSTEM_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @CSTEM_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTEM_FV_primary_key_status = N'FAILED';
        SET @CSTEM_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @CSTEM_FV_expected_column_count int = 7;
    DECLARE @CSTEM_FV_actual_column_count   int;


    SELECT
        @CSTEM_FV_actual_column_count =
            COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'customer.CustomerEmail');


    IF @CSTEM_FV_actual_column_count = @CSTEM_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerEmail')
        AND c.name = N'CSTEM_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'customer.CustomerEmail')
        AND ic.name = N'CSTEM_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerEmail')
        AND c.name = N'CSTEM_CST_id'
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
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerEmail')
        AND c.name = N'CSTEM_email'
        AND t.name = N'varchar'
        AND c.max_length = 254
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerEmail')
        AND c.name = N'CSTEM_is_primary'
        AND t.name = N'bit'
        AND c.max_length = 1
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerEmail')
        AND c.name = N'CSTEM_is_active'
        AND t.name = N'bit'
        AND c.max_length = 1
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerEmail')
        AND c.name = N'CSTEM_created_at'
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
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerEmail')
        AND c.name = N'CSTEM_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @CSTEM_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTEM_FV_columns_status = N'FAILED';
        SET @CSTEM_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @CSTEM_FV_expected_documentation TABLE
    (
        CSTEM_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        CSTEM_doc_object_type           nvarchar(10) NOT NULL,
        CSTEM_doc_column_name           sysname NULL,
        CSTEM_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @CSTEM_FV_doc_current_id        tinyint;
    DECLARE @CSTEM_FV_doc_max_id            tinyint;
    DECLARE @CSTEM_FV_doc_object_type       nvarchar(10);
    DECLARE @CSTEM_FV_doc_column_name       sysname;
    DECLARE @CSTEM_FV_doc_expected_value    nvarchar(4000);
    DECLARE @CSTEM_FV_doc_actual_value      nvarchar(4000);
    DECLARE @CSTEM_FV_invalid_documentation int = 0;


    INSERT INTO @CSTEM_FV_expected_documentation
    (
        CSTEM_doc_object_type,
        CSTEM_doc_column_name,
        CSTEM_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains email addresses associated with identified customers while allowing shared email addresses across multiple customers.'
    ),
    (
        N'COLUMN',
        N'CSTEM_id',
        N'Primary key of customer.CustomerEmail.'
    ),
    (
        N'COLUMN',
        N'CSTEM_CST_id',
        N'Foreign key referencing customer.Customer.CST_id.'
    ),
    (
        N'COLUMN',
        N'CSTEM_email',
        N'Stores the email address associated with the customer.'
    ),
    (
        N'COLUMN',
        N'CSTEM_is_primary',
        N'Indicates whether the email is the primary active email address for the customer.'
    ),
    (
        N'COLUMN',
        N'CSTEM_is_active',
        N'Indicates whether the customer email address is currently active and available for use.'
    ),
    (
        N'COLUMN',
        N'CSTEM_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'CSTEM_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @CSTEM_FV_doc_current_id =
            MIN(CSTEM_doc_id),

        @CSTEM_FV_doc_max_id =
            MAX(CSTEM_doc_id)

    FROM @CSTEM_FV_expected_documentation;


    WHILE @CSTEM_FV_doc_current_id <= @CSTEM_FV_doc_max_id
    BEGIN

        SET @CSTEM_FV_doc_object_type = NULL;
        SET @CSTEM_FV_doc_column_name = NULL;
        SET @CSTEM_FV_doc_expected_value = NULL;
        SET @CSTEM_FV_doc_actual_value = NULL;


        SELECT
            @CSTEM_FV_doc_object_type =
                CSTEM_doc_object_type,

            @CSTEM_FV_doc_column_name =
                CSTEM_doc_column_name,

            @CSTEM_FV_doc_expected_value =
                CSTEM_doc_expected_description

        FROM @CSTEM_FV_expected_documentation

        WHERE CSTEM_doc_id =
                @CSTEM_FV_doc_current_id;


        IF @CSTEM_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @CSTEM_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1

            AND ep.major_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND ep.minor_id = 0

            AND ep.name =
                    N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @CSTEM_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1

            AND ep.major_id =
                    OBJECT_ID(N'customer.CustomerEmail')

            AND ep.name =
                    N'MS_Description'

            AND c.name =
                    @CSTEM_FV_doc_column_name;

        END;


        IF ISNULL(@CSTEM_FV_doc_actual_value, N'')
            <> @CSTEM_FV_doc_expected_value
        BEGIN

            SET @CSTEM_FV_invalid_documentation += 1;

        END;


        SET @CSTEM_FV_doc_current_id += 1;

    END;


    IF @CSTEM_FV_invalid_documentation = 0
    BEGIN
        SET @CSTEM_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTEM_FV_documentation_status = N'FAILED';
        SET @CSTEM_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'customer'

        AND PFX_table_name = N'CustomerEmail'

        AND PFX_prefix = N'CSTEM'

        AND PFX_is_active = 1
    )
    BEGIN
        SET @CSTEM_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTEM_FV_seed_data_status = N'FAILED';
        SET @CSTEM_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @CSTEM_FV_expected_defaults TABLE
    (
        CSTEM_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        CSTEM_default_column_name          sysname NOT NULL,
        CSTEM_default_constraint_name      sysname NOT NULL,
        CSTEM_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @CSTEM_FV_default_current_id          tinyint;
    DECLARE @CSTEM_FV_default_max_id              tinyint;
    DECLARE @CSTEM_FV_default_column_name         sysname;
    DECLARE @CSTEM_FV_default_expected_name       sysname;
    DECLARE @CSTEM_FV_default_actual_name         sysname;
    DECLARE @CSTEM_FV_default_expected_definition nvarchar(4000);
    DECLARE @CSTEM_FV_default_actual_definition   nvarchar(4000);
    DECLARE @CSTEM_FV_default_expected_normalized nvarchar(4000);
    DECLARE @CSTEM_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @CSTEM_FV_invalid_defaults            int = 0;


    INSERT INTO @CSTEM_FV_expected_defaults
    (
        CSTEM_default_column_name,
        CSTEM_default_constraint_name,
        CSTEM_default_expected_definition
    )
    VALUES
    (
        N'CSTEM_is_primary',
        N'DF_CSTEM_is_primary',
        N'0'
    ),
    (
        N'CSTEM_is_active',
        N'DF_CSTEM_is_active',
        N'1'
    ),
    (
        N'CSTEM_created_at',
        N'DF_CSTEM_created_at',
        N'sysdatetime'
    ),
    (
        N'CSTEM_updated_at',
        N'DF_CSTEM_updated_at',
        N'sysdatetime'
    );


    SELECT
        @CSTEM_FV_default_current_id =
            MIN(CSTEM_default_id),

        @CSTEM_FV_default_max_id =
            MAX(CSTEM_default_id)

    FROM @CSTEM_FV_expected_defaults;


    WHILE @CSTEM_FV_default_current_id <= @CSTEM_FV_default_max_id
    BEGIN

        SET @CSTEM_FV_default_column_name = NULL;
        SET @CSTEM_FV_default_expected_name = NULL;
        SET @CSTEM_FV_default_actual_name = NULL;
        SET @CSTEM_FV_default_expected_definition = NULL;
        SET @CSTEM_FV_default_actual_definition = NULL;


        SELECT
            @CSTEM_FV_default_column_name =
                CSTEM_default_column_name,

            @CSTEM_FV_default_expected_name =
                CSTEM_default_constraint_name,

            @CSTEM_FV_default_expected_definition =
                CSTEM_default_expected_definition

        FROM @CSTEM_FV_expected_defaults

        WHERE CSTEM_default_id =
                @CSTEM_FV_default_current_id;


        SELECT
            @CSTEM_FV_default_actual_name =
                dc.name,

            @CSTEM_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND c.name =
                @CSTEM_FV_default_column_name;


        SET @CSTEM_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CSTEM_FV_default_expected_definition,
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


        SET @CSTEM_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CSTEM_FV_default_actual_definition,
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


        IF @CSTEM_FV_default_actual_name IS NULL

        OR @CSTEM_FV_default_actual_name <>
                @CSTEM_FV_default_expected_name

        OR @CSTEM_FV_default_actual_definition IS NULL

        OR @CSTEM_FV_default_actual_normalized <>
                @CSTEM_FV_default_expected_normalized
        BEGIN

            SET @CSTEM_FV_invalid_defaults += 1;

        END;


        SET @CSTEM_FV_default_current_id += 1;

    END;


    IF @CSTEM_FV_invalid_defaults = 0
    BEGIN
        SET @CSTEM_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTEM_FV_defaults_status = N'FAILED';
        SET @CSTEM_FV_validation_errors += 1;
    END;


    /*==========================================================================
        CHECK CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CSTEM_FV_check_actual_name        sysname;
    DECLARE @CSTEM_FV_check_definition         nvarchar(4000);
    DECLARE @CSTEM_FV_check_normalized         nvarchar(4000);
    DECLARE @CSTEM_FV_check_is_disabled        bit;
    DECLARE @CSTEM_FV_check_is_not_trusted     bit;


    SELECT
        @CSTEM_FV_check_actual_name =
            cc.name,

        @CSTEM_FV_check_definition =
            cc.definition,

        @CSTEM_FV_check_is_disabled =
            cc.is_disabled,

        @CSTEM_FV_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'customer.CustomerEmail')

    AND cc.name =
            N'CK_CSTEM_primary_active';


    SET @CSTEM_FV_check_normalized =
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
                            @CSTEM_FV_check_definition,
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


    IF @CSTEM_FV_check_actual_name =
            N'CK_CSTEM_primary_active'

    AND @CSTEM_FV_check_normalized LIKE
            N'%cstem_is_primary=(0)%'

    AND @CSTEM_FV_check_normalized LIKE
            N'%orcstem_is_active=(1)%'

    AND @CSTEM_FV_check_is_disabled = 0

    AND @CSTEM_FV_check_is_not_trusted = 0
    BEGIN
        SET @CSTEM_FV_checks_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTEM_FV_checks_status = N'FAILED';
        SET @CSTEM_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CSTEM_FV_invalid_foreign_keys int = 0;


    /*--------------------------------------------------------------------------
        FK_CSTEM_CST
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.Customer')

        AND fk.name =
                N'FK_CSTEM_CST'

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
                    N'CSTEM_CST_id'

            AND rc.name =
                    N'CST_id'
        )
    )
    BEGIN
        SET @CSTEM_FV_invalid_foreign_keys += 1;
    END;


    /*--------------------------------------------------------------------------
        ENSURE EXACT EXPECTED FOREIGN KEY COUNT
    --------------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerEmail')
    ) <> 1
    BEGIN
        SET @CSTEM_FV_invalid_foreign_keys += 1;
    END;


    IF @CSTEM_FV_invalid_foreign_keys = 0
    BEGIN
        SET @CSTEM_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTEM_FV_foreign_keys_status = N'FAILED';
        SET @CSTEM_FV_validation_errors += 1;
    END;


    /*==========================================================================
        ADDITIONAL INDEX VALIDATION
    ==========================================================================*/

    DECLARE @CSTEM_FV_index_actual_name         sysname;
    DECLARE @CSTEM_FV_index_type                tinyint;
    DECLARE @CSTEM_FV_index_is_unique           bit;
    DECLARE @CSTEM_FV_index_is_disabled         bit;
    DECLARE @CSTEM_FV_index_has_filter          bit;
    DECLARE @CSTEM_FV_index_filter_definition   nvarchar(4000);
    DECLARE @CSTEM_FV_index_filter_normalized   nvarchar(4000);
    DECLARE @CSTEM_FV_index_data_space          sysname;
    DECLARE @CSTEM_FV_index_key_columns         nvarchar(4000);
    DECLARE @CSTEM_FV_index_include_count       int;


    SELECT
        @CSTEM_FV_index_actual_name =
            i.name,

        @CSTEM_FV_index_type =
            i.type,

        @CSTEM_FV_index_is_unique =
            i.is_unique,

        @CSTEM_FV_index_is_disabled =
            i.is_disabled,

        @CSTEM_FV_index_has_filter =
            i.has_filter,

        @CSTEM_FV_index_filter_definition =
            i.filter_definition,

        @CSTEM_FV_index_data_space =
            ds.name,

        @CSTEM_FV_index_key_columns =
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

            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ),

        @CSTEM_FV_index_include_count =
        (
            SELECT COUNT(*)

            FROM sys.index_columns AS ic

            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
        )

    FROM sys.indexes AS i

    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id

    WHERE i.object_id =
            OBJECT_ID(N'customer.CustomerEmail')

    AND i.name =
            N'UX_CSTEM_primary_active';


    SET @CSTEM_FV_index_filter_normalized =
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
                            REPLACE
                            (
                                REPLACE
                                (
                                    @CSTEM_FV_index_filter_definition,
                                    N'[',
                                    N''
                                ),
                                N']',
                                N''
                            ),
                            N'(',
                            N''
                        ),
                        N')',
                        N''
                    ),
                    N' ',
                    N''
                ),
                NCHAR(9),
                N''
            )
        );


    IF @CSTEM_FV_index_actual_name =
            N'UX_CSTEM_primary_active'

    AND @CSTEM_FV_index_type = 2

    AND @CSTEM_FV_index_is_unique = 1

    AND @CSTEM_FV_index_is_disabled = 0

    AND @CSTEM_FV_index_has_filter = 1

    AND @CSTEM_FV_index_key_columns =
            N'CSTEM_CST_id'

    AND @CSTEM_FV_index_include_count = 0

    AND
    (
        @CSTEM_FV_index_filter_normalized =
            N'cstem_is_primary=1andcstem_is_active=1'

        OR

        @CSTEM_FV_index_filter_normalized =
            N'cstem_is_active=1andcstem_is_primary=1'
    )

    AND @CSTEM_FV_index_data_space =
            N'FG_CORE'
    BEGIN
        SET @CSTEM_FV_indexes_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @CSTEM_FV_indexes_status = N'FAILED';
        SET @CSTEM_FV_validation_errors += 1;
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

    PRINT N'        Table                         : ' + @CSTEM_FV_table_status;
    PRINT N'        Primary Key                   : ' + @CSTEM_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @CSTEM_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @CSTEM_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @CSTEM_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @CSTEM_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @CSTEM_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @CSTEM_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @CSTEM_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @CSTEM_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @CSTEM_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @CSTEM_FV_validation_errors = 0
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
                @CSTEM_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50750,
            N'Final validation failed for customer.CustomerEmail.',
            1;

    END;


    PRINT N'';