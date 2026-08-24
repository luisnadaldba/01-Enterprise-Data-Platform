    PRINT N'    ● customer.CustomerContact';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @CSTCN_FV_validation_errors int = 0;

    DECLARE @CSTCN_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCN_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCN_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCN_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCN_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @CSTCN_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCN_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCN_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @CSTCN_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCN_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @CSTCN_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'customer.CustomerContact', N'U') IS NOT NULL
    BEGIN

        SET @CSTCN_FV_table_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCN_FV_table_status = N'FAILED';
        SET @CSTCN_FV_validation_errors += 1;

    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @CSTCN_FV_pk_actual_name     sysname;
    DECLARE @CSTCN_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @CSTCN_FV_pk_data_space      sysname;


    SELECT
        @CSTCN_FV_pk_actual_name =
            kc.name,

        @CSTCN_FV_pk_data_space =
            ds.name,

        @CSTCN_FV_pk_actual_columns =
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
            OBJECT_ID(N'customer.CustomerContact')

    AND kc.type =
            N'PK';


    IF @CSTCN_FV_pk_actual_name =
            N'PK_CSTCN'

    AND @CSTCN_FV_pk_actual_columns =
            N'CSTCN_id'

    AND @CSTCN_FV_pk_data_space =
            N'FG_CORE'
    BEGIN

        SET @CSTCN_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCN_FV_primary_key_status = N'FAILED';
        SET @CSTCN_FV_validation_errors += 1;

    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @CSTCN_FV_expected_column_count int = 8;
    DECLARE @CSTCN_FV_actual_column_count   int;


    SELECT
        @CSTCN_FV_actual_column_count =
            COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'customer.CustomerContact');


    IF @CSTCN_FV_actual_column_count =
            @CSTCN_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'customer.CustomerContact')
        AND ic.name = N'CSTCN_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_CST_id'
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
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_CTP_id'
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
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_value'
        AND t.name = N'varchar'
        AND c.max_length = 20
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_is_primary'
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
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_is_active'
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
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_created_at'
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
        WHERE c.object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN

        SET @CSTCN_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCN_FV_columns_status = N'FAILED';
        SET @CSTCN_FV_validation_errors += 1;

    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @CSTCN_FV_expected_documentation TABLE
    (
        CSTCN_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        CSTCN_doc_object_type           nvarchar(10) NOT NULL,
        CSTCN_doc_column_name           sysname NULL,
        CSTCN_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @CSTCN_FV_doc_current_id        tinyint;
    DECLARE @CSTCN_FV_doc_max_id            tinyint;
    DECLARE @CSTCN_FV_doc_object_type       nvarchar(10);
    DECLARE @CSTCN_FV_doc_column_name       sysname;
    DECLARE @CSTCN_FV_doc_expected_value    nvarchar(4000);
    DECLARE @CSTCN_FV_doc_actual_value      nvarchar(4000);
    DECLARE @CSTCN_FV_invalid_documentation int = 0;


    INSERT INTO @CSTCN_FV_expected_documentation
    (
        CSTCN_doc_object_type,
        CSTCN_doc_column_name,
        CSTCN_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains telephone contact information associated with identified customers in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'CSTCN_id',
        N'Primary key of customer.CustomerContact.'
    ),
    (
        N'COLUMN',
        N'CSTCN_CST_id',
        N'Foreign key referencing customer.Customer.'
    ),
    (
        N'COLUMN',
        N'CSTCN_CTP_id',
        N'Foreign key referencing reference.ContactType.'
    ),
    (
        N'COLUMN',
        N'CSTCN_value',
        N'Stores the telephone number without presentation formatting.'
    ),
    (
        N'COLUMN',
        N'CSTCN_is_primary',
        N'Indicates whether the contact is the primary active telephone contact for the customer.'
    ),
    (
        N'COLUMN',
        N'CSTCN_is_active',
        N'Indicates whether the customer contact is currently active and available for use.'
    ),
    (
        N'COLUMN',
        N'CSTCN_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'CSTCN_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @CSTCN_FV_doc_current_id =
            MIN(CSTCN_doc_id),

        @CSTCN_FV_doc_max_id =
            MAX(CSTCN_doc_id)

    FROM @CSTCN_FV_expected_documentation;


    WHILE @CSTCN_FV_doc_current_id <=
        @CSTCN_FV_doc_max_id
    BEGIN

        SET @CSTCN_FV_doc_object_type = NULL;
        SET @CSTCN_FV_doc_column_name = NULL;
        SET @CSTCN_FV_doc_expected_value = NULL;
        SET @CSTCN_FV_doc_actual_value = NULL;


        SELECT
            @CSTCN_FV_doc_object_type =
                CSTCN_doc_object_type,

            @CSTCN_FV_doc_column_name =
                CSTCN_doc_column_name,

            @CSTCN_FV_doc_expected_value =
                CSTCN_doc_expected_description

        FROM @CSTCN_FV_expected_documentation

        WHERE CSTCN_doc_id =
                @CSTCN_FV_doc_current_id;


        IF @CSTCN_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @CSTCN_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1

            AND ep.major_id =
                    OBJECT_ID(N'customer.CustomerContact')

            AND ep.minor_id = 0

            AND ep.name =
                    N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @CSTCN_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1

            AND ep.major_id =
                    OBJECT_ID(N'customer.CustomerContact')

            AND ep.name =
                    N'MS_Description'

            AND c.name =
                    @CSTCN_FV_doc_column_name;

        END;


        IF ISNULL(@CSTCN_FV_doc_actual_value, N'')
            <> @CSTCN_FV_doc_expected_value
        BEGIN

            SET @CSTCN_FV_invalid_documentation += 1;

        END;


        SET @CSTCN_FV_doc_current_id += 1;

    END;


    IF @CSTCN_FV_invalid_documentation = 0
    BEGIN

        SET @CSTCN_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCN_FV_documentation_status = N'FAILED';
        SET @CSTCN_FV_validation_errors += 1;

    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @CSTCN_FV_expected_defaults TABLE
    (
        CSTCN_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        CSTCN_default_column_name          sysname NOT NULL,
        CSTCN_default_constraint_name      sysname NOT NULL,
        CSTCN_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @CSTCN_FV_default_current_id          tinyint;
    DECLARE @CSTCN_FV_default_max_id              tinyint;
    DECLARE @CSTCN_FV_default_column_name         sysname;
    DECLARE @CSTCN_FV_default_expected_name       sysname;
    DECLARE @CSTCN_FV_default_actual_name         sysname;
    DECLARE @CSTCN_FV_default_expected_definition nvarchar(4000);
    DECLARE @CSTCN_FV_default_actual_definition   nvarchar(4000);
    DECLARE @CSTCN_FV_default_expected_normalized nvarchar(4000);
    DECLARE @CSTCN_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @CSTCN_FV_invalid_defaults            int = 0;


    INSERT INTO @CSTCN_FV_expected_defaults
    (
        CSTCN_default_column_name,
        CSTCN_default_constraint_name,
        CSTCN_default_expected_definition
    )
    VALUES
    (
        N'CSTCN_is_primary',
        N'DF_CSTCN_is_primary',
        N'0'
    ),
    (
        N'CSTCN_is_active',
        N'DF_CSTCN_is_active',
        N'1'
    ),
    (
        N'CSTCN_created_at',
        N'DF_CSTCN_created_at',
        N'sysdatetime'
    ),
    (
        N'CSTCN_updated_at',
        N'DF_CSTCN_updated_at',
        N'sysdatetime'
    );


    SELECT
        @CSTCN_FV_default_current_id =
            MIN(CSTCN_default_id),

        @CSTCN_FV_default_max_id =
            MAX(CSTCN_default_id)

    FROM @CSTCN_FV_expected_defaults;


    WHILE @CSTCN_FV_default_current_id <=
        @CSTCN_FV_default_max_id
    BEGIN

        SET @CSTCN_FV_default_column_name = NULL;
        SET @CSTCN_FV_default_expected_name = NULL;
        SET @CSTCN_FV_default_actual_name = NULL;
        SET @CSTCN_FV_default_expected_definition = NULL;
        SET @CSTCN_FV_default_actual_definition = NULL;


        SELECT
            @CSTCN_FV_default_column_name =
                CSTCN_default_column_name,

            @CSTCN_FV_default_expected_name =
                CSTCN_default_constraint_name,

            @CSTCN_FV_default_expected_definition =
                CSTCN_default_expected_definition

        FROM @CSTCN_FV_expected_defaults

        WHERE CSTCN_default_id =
                @CSTCN_FV_default_current_id;


        SELECT
            @CSTCN_FV_default_actual_name =
                dc.name,

            @CSTCN_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND c.name =
                @CSTCN_FV_default_column_name;


        SET @CSTCN_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CSTCN_FV_default_expected_definition,
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


        SET @CSTCN_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @CSTCN_FV_default_actual_definition,
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


        IF @CSTCN_FV_default_actual_name IS NULL

        OR @CSTCN_FV_default_actual_name <>
                @CSTCN_FV_default_expected_name

        OR @CSTCN_FV_default_actual_definition IS NULL

        OR @CSTCN_FV_default_actual_normalized <>
                @CSTCN_FV_default_expected_normalized
        BEGIN

            SET @CSTCN_FV_invalid_defaults += 1;

        END;


        SET @CSTCN_FV_default_current_id += 1;

    END;


    IF @CSTCN_FV_invalid_defaults = 0
    BEGIN

        SET @CSTCN_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCN_FV_defaults_status = N'FAILED';
        SET @CSTCN_FV_validation_errors += 1;

    END;


    /*==========================================================================
        CHECK CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CSTCN_FV_check_actual_name        sysname;
    DECLARE @CSTCN_FV_check_definition         nvarchar(4000);
    DECLARE @CSTCN_FV_check_normalized         nvarchar(4000);
    DECLARE @CSTCN_FV_check_is_disabled        bit;
    DECLARE @CSTCN_FV_check_is_not_trusted     bit;


    SELECT
        @CSTCN_FV_check_actual_name =
            cc.name,

        @CSTCN_FV_check_definition =
            cc.definition,

        @CSTCN_FV_check_is_disabled =
            cc.is_disabled,

        @CSTCN_FV_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'customer.CustomerContact')

    AND cc.name =
            N'CK_CSTCN_primary_active';


    SET @CSTCN_FV_check_normalized =
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
                            @CSTCN_FV_check_definition,
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


    IF @CSTCN_FV_check_actual_name =
            N'CK_CSTCN_primary_active'

    AND @CSTCN_FV_check_normalized LIKE
            N'%cstcn_is_primary=(0)%'

    AND @CSTCN_FV_check_normalized LIKE
            N'%orcstcn_is_active=(1)%'

    AND @CSTCN_FV_check_is_disabled = 0

    AND @CSTCN_FV_check_is_not_trusted = 0
    BEGIN

        SET @CSTCN_FV_checks_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCN_FV_checks_status = N'FAILED';
        SET @CSTCN_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @CSTCN_FV_invalid_foreign_keys int = 0;


    /*--------------------------------------------------------------------------
        FK_CSTCN_CST
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.Customer')

        AND fk.name =
                N'FK_CSTCN_CST'

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
                    N'CSTCN_CST_id'

            AND rc.name =
                    N'CST_id'
        )
    )
    BEGIN

        SET @CSTCN_FV_invalid_foreign_keys += 1;

    END;


    /*--------------------------------------------------------------------------
        FK_CSTCN_CTP
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND fk.referenced_object_id =
                OBJECT_ID(N'reference.ContactType')

        AND fk.name =
                N'FK_CSTCN_CTP'

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
                    N'CSTCN_CTP_id'

            AND rc.name =
                    N'CTP_id'
        )
    )
    BEGIN

        SET @CSTCN_FV_invalid_foreign_keys += 1;

    END;


    /*--------------------------------------------------------------------------
        ENSURE EXACT EXPECTED FOREIGN KEY COUNT
    --------------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerContact')
    ) <> 2
    BEGIN

        SET @CSTCN_FV_invalid_foreign_keys += 1;

    END;


    IF @CSTCN_FV_invalid_foreign_keys = 0
    BEGIN

        SET @CSTCN_FV_foreign_keys_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCN_FV_foreign_keys_status = N'FAILED';
        SET @CSTCN_FV_validation_errors += 1;

    END;


    /*==========================================================================
        ADDITIONAL INDEX VALIDATION
    ==========================================================================*/

    DECLARE @CSTCN_FV_index_actual_name         sysname;
    DECLARE @CSTCN_FV_index_type                tinyint;
    DECLARE @CSTCN_FV_index_is_unique           bit;
    DECLARE @CSTCN_FV_index_is_disabled         bit;
    DECLARE @CSTCN_FV_index_has_filter          bit;
    DECLARE @CSTCN_FV_index_filter_definition   nvarchar(4000);
    DECLARE @CSTCN_FV_index_filter_normalized   nvarchar(4000);
    DECLARE @CSTCN_FV_index_data_space          sysname;
    DECLARE @CSTCN_FV_index_key_columns         nvarchar(4000);
    DECLARE @CSTCN_FV_index_include_count       int;


    SELECT
        @CSTCN_FV_index_actual_name =
            i.name,

        @CSTCN_FV_index_type =
            i.type,

        @CSTCN_FV_index_is_unique =
            i.is_unique,

        @CSTCN_FV_index_is_disabled =
            i.is_disabled,

        @CSTCN_FV_index_has_filter =
            i.has_filter,

        @CSTCN_FV_index_filter_definition =
            i.filter_definition,

        @CSTCN_FV_index_data_space =
            ds.name,

        @CSTCN_FV_index_key_columns =
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
                    i.object_id

            AND ic.index_id =
                    i.index_id

            AND ic.key_ordinal > 0
        ),

        @CSTCN_FV_index_include_count =
        (
            SELECT COUNT(*)

            FROM sys.index_columns AS ic

            WHERE ic.object_id =
                    i.object_id

            AND ic.index_id =
                    i.index_id

            AND ic.is_included_column = 1
        )

    FROM sys.indexes AS i

    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id =
            i.data_space_id

    WHERE i.object_id =
            OBJECT_ID(N'customer.CustomerContact')

    AND i.name =
            N'UX_CSTCN_primary_active';


    SET @CSTCN_FV_index_filter_normalized =
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
                                    @CSTCN_FV_index_filter_definition,
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


    IF @CSTCN_FV_index_actual_name =
            N'UX_CSTCN_primary_active'

    AND @CSTCN_FV_index_type = 2

    AND @CSTCN_FV_index_is_unique = 1

    AND @CSTCN_FV_index_is_disabled = 0

    AND @CSTCN_FV_index_has_filter = 1

    AND @CSTCN_FV_index_key_columns =
            N'CSTCN_CST_id'

    AND @CSTCN_FV_index_include_count = 0

    AND
    (
        @CSTCN_FV_index_filter_normalized =
            N'cstcn_is_primary=1andcstcn_is_active=1'

        OR

        @CSTCN_FV_index_filter_normalized =
            N'cstcn_is_active=1andcstcn_is_primary=1'
    )

    AND @CSTCN_FV_index_data_space =
            N'FG_CORE'
    BEGIN

        SET @CSTCN_FV_indexes_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @CSTCN_FV_indexes_status = N'FAILED';
        SET @CSTCN_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @CSTCN_FV_table_status;
    PRINT N'        Primary Key                   : ' + @CSTCN_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @CSTCN_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @CSTCN_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @CSTCN_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @CSTCN_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @CSTCN_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @CSTCN_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @CSTCN_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @CSTCN_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @CSTCN_FV_temporal_integrity_status;
    PRINT N'';

    IF @CSTCN_FV_validation_errors = 0
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
                @CSTCN_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @CSTCN_FV_validation_errors > 0
    BEGIN

        ;THROW 50690,
            N'Final validation failed for customer.CustomerContact.',
            1;

    END;