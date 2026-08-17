    PRINT N'    inventory.InventoryMovementNote';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @INVMN_FV_validation_errors int = 0;

    DECLARE @INVMN_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMN_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMN_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMN_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMN_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMN_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMN_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @INVMN_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @INVMN_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMN_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMN_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovementNote', N'U') IS NOT NULL
    BEGIN
        SET @INVMN_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMN_FV_table_status = N'FAILED';
        SET @INVMN_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @INVMN_FV_pk_actual_name     sysname;
    DECLARE @INVMN_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @INVMN_FV_pk_data_space      sysname;


    SELECT
        @INVMN_FV_pk_actual_name = kc.name,
        @INVMN_FV_pk_data_space = ds.name,

        @INVMN_FV_pk_actual_columns =
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
            OBJECT_ID(N'inventory.InventoryMovementNote')

    AND kc.type = N'PK';


    IF @INVMN_FV_pk_actual_name = N'PK_INVMN'
    AND @INVMN_FV_pk_actual_columns = N'INVMN_id'
    AND @INVMN_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @INVMN_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMN_FV_primary_key_status = N'FAILED';
        SET @INVMN_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @INVMN_FV_expected_column_count int = 5;
    DECLARE @INVMN_FV_actual_column_count   int;


    SELECT
        @INVMN_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'inventory.InventoryMovementNote');


    IF @INVMN_FV_actual_column_count =
            @INVMN_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND c.name = N'INVMN_id'
        AND t.name = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.identity_columns AS ic

        WHERE ic.object_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ic.name = N'INVMN_id'
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
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND c.name = N'INVMN_INVMV_id'
        AND t.name = N'bigint'
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
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND c.name = N'INVMN_note'
        AND t.name = N'nvarchar'
        AND c.max_length = 2000
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
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND c.name = N'INVMN_created_at'
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
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND c.name = N'INVMN_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @INVMN_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMN_FV_columns_status = N'FAILED';
        SET @INVMN_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @INVMN_FV_expected_documentation TABLE
    (
        INVMN_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        INVMN_doc_object_type           nvarchar(10) NOT NULL,
        INVMN_doc_column_name           sysname NULL,
        INVMN_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @INVMN_FV_doc_current_id        tinyint;
    DECLARE @INVMN_FV_doc_max_id            tinyint;
    DECLARE @INVMN_FV_doc_object_type       nvarchar(10);
    DECLARE @INVMN_FV_doc_column_name       sysname;
    DECLARE @INVMN_FV_doc_expected_value    nvarchar(4000);
    DECLARE @INVMN_FV_doc_actual_value      nvarchar(4000);
    DECLARE @INVMN_FV_invalid_documentation int = 0;


    INSERT INTO @INVMN_FV_expected_documentation
    (
        INVMN_doc_object_type,
        INVMN_doc_column_name,
        INVMN_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains optional free-text notes associated with inventory movement events in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'INVMN_id',
        N'Primary key of inventory.InventoryMovementNote.'
    ),
    (
        N'COLUMN',
        N'INVMN_INVMV_id',
        N'Foreign key of inventory.InventoryMovement.'
    ),
    (
        N'COLUMN',
        N'INVMN_note',
        N'Stores optional free-text operational context associated with the inventory movement without replacing its structured reason classification.'
    ),
    (
        N'COLUMN',
        N'INVMN_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'INVMN_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @INVMN_FV_doc_current_id =
            MIN(INVMN_doc_id),

        @INVMN_FV_doc_max_id =
            MAX(INVMN_doc_id)

    FROM @INVMN_FV_expected_documentation;


    WHILE @INVMN_FV_doc_current_id <=
        @INVMN_FV_doc_max_id
    BEGIN

        SET @INVMN_FV_doc_object_type = NULL;
        SET @INVMN_FV_doc_column_name = NULL;
        SET @INVMN_FV_doc_expected_value = NULL;
        SET @INVMN_FV_doc_actual_value = NULL;


        SELECT
            @INVMN_FV_doc_object_type =
                INVMN_doc_object_type,

            @INVMN_FV_doc_column_name =
                INVMN_doc_column_name,

            @INVMN_FV_doc_expected_value =
                INVMN_doc_expected_description

        FROM @INVMN_FV_expected_documentation

        WHERE INVMN_doc_id =
                @INVMN_FV_doc_current_id;


        IF @INVMN_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @INVMN_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @INVMN_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'inventory.InventoryMovementNote')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @INVMN_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @INVMN_FV_doc_actual_value,
            N''
        )
        <>
        @INVMN_FV_doc_expected_value
        BEGIN

            SET @INVMN_FV_invalid_documentation += 1;

        END;


        SET @INVMN_FV_doc_current_id += 1;

    END;


    IF @INVMN_FV_invalid_documentation = 0
    BEGIN
        SET @INVMN_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMN_FV_documentation_status = N'FAILED';
        SET @INVMN_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'inventory'
        AND PFX_table_name = N'InventoryMovementNote'
        AND PFX_prefix = N'INVMN'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @INVMN_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMN_FV_seed_data_status = N'FAILED';
        SET @INVMN_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @INVMN_FV_expected_defaults TABLE
    (
        INVMN_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        INVMN_default_column_name          sysname NOT NULL,
        INVMN_default_constraint_name      sysname NOT NULL,
        INVMN_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @INVMN_FV_default_current_id          tinyint;
    DECLARE @INVMN_FV_default_max_id              tinyint;
    DECLARE @INVMN_FV_default_column_name         sysname;
    DECLARE @INVMN_FV_default_expected_name       sysname;
    DECLARE @INVMN_FV_default_actual_name         sysname;
    DECLARE @INVMN_FV_default_expected_definition nvarchar(4000);
    DECLARE @INVMN_FV_default_actual_definition   nvarchar(4000);
    DECLARE @INVMN_FV_default_expected_normalized nvarchar(4000);
    DECLARE @INVMN_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @INVMN_FV_invalid_defaults            int = 0;


    INSERT INTO @INVMN_FV_expected_defaults
    (
        INVMN_default_column_name,
        INVMN_default_constraint_name,
        INVMN_default_expected_definition
    )
    VALUES
    (
        N'INVMN_created_at',
        N'DF_INVMN_created_at',
        N'sysdatetime'
    ),
    (
        N'INVMN_updated_at',
        N'DF_INVMN_updated_at',
        N'sysdatetime'
    );


    SELECT
        @INVMN_FV_default_current_id =
            MIN(INVMN_default_id),

        @INVMN_FV_default_max_id =
            MAX(INVMN_default_id)

    FROM @INVMN_FV_expected_defaults;


    WHILE @INVMN_FV_default_current_id <=
        @INVMN_FV_default_max_id
    BEGIN

        SET @INVMN_FV_default_column_name = NULL;
        SET @INVMN_FV_default_expected_name = NULL;
        SET @INVMN_FV_default_actual_name = NULL;
        SET @INVMN_FV_default_expected_definition = NULL;
        SET @INVMN_FV_default_actual_definition = NULL;


        SELECT
            @INVMN_FV_default_column_name =
                INVMN_default_column_name,

            @INVMN_FV_default_expected_name =
                INVMN_default_constraint_name,

            @INVMN_FV_default_expected_definition =
                INVMN_default_expected_definition

        FROM @INVMN_FV_expected_defaults

        WHERE INVMN_default_id =
                @INVMN_FV_default_current_id;


        SELECT
            @INVMN_FV_default_actual_name =
                dc.name,

            @INVMN_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND c.name =
                @INVMN_FV_default_column_name;


        SET @INVMN_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @INVMN_FV_default_expected_definition,
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


        SET @INVMN_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @INVMN_FV_default_actual_definition,
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


        IF @INVMN_FV_default_actual_name IS NULL
        OR @INVMN_FV_default_actual_name <>
                @INVMN_FV_default_expected_name
        OR @INVMN_FV_default_actual_definition IS NULL
        OR @INVMN_FV_default_actual_normalized <>
                @INVMN_FV_default_expected_normalized
        BEGIN

            SET @INVMN_FV_invalid_defaults += 1;

        END;


        SET @INVMN_FV_default_current_id += 1;

    END;


    IF @INVMN_FV_invalid_defaults = 0
    BEGIN
        SET @INVMN_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMN_FV_defaults_status = N'FAILED';
        SET @INVMN_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND fk.referenced_object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND fk.name =
                N'FK_INVMN_INVMV'

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

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'INVMN_INVMV_id'

            AND rc.name =
                    N'INVMV_id'
        )
    )
    BEGIN

        SET @INVMN_FV_foreign_keys_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @INVMN_FV_foreign_keys_status = N'FAILED';
        SET @INVMN_FV_validation_errors += 1;

    END;


    /*==========================================================================
        ADDITIONAL INDEXES VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND i.name =
                N'IX_INVMN_INVMV'

        AND i.type = 2
        AND i.is_unique = 0
        AND i.is_primary_key = 0
        AND i.is_unique_constraint = 0
        AND i.is_hypothetical = 0
        AND i.has_filter = 0
        AND i.is_disabled = 0
        AND ds.name = N'FG_CORE'

        AND
        (
            SELECT COUNT(*)

            FROM sys.index_columns AS ic

            WHERE ic.object_id =
                    i.object_id

            AND ic.index_id =
                    i.index_id

            AND ic.key_ordinal > 0
        ) = 1

        AND EXISTS
        (
            SELECT 1

            FROM sys.index_columns AS ic

            INNER JOIN sys.columns AS c
                ON  c.object_id =
                        ic.object_id

                AND c.column_id =
                        ic.column_id

            WHERE ic.object_id =
                    i.object_id

            AND ic.index_id =
                    i.index_id

            AND ic.key_ordinal = 1

            AND ic.is_descending_key = 0

            AND c.name =
                    N'INVMN_INVMV_id'
        )

        AND NOT EXISTS
        (
            SELECT 1

            FROM sys.index_columns AS ic

            WHERE ic.object_id =
                    i.object_id

            AND ic.index_id =
                    i.index_id

            AND ic.is_included_column = 1
        )
    )
    BEGIN

        SET @INVMN_FV_indexes_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @INVMN_FV_indexes_status = N'FAILED';
        SET @INVMN_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @INVMN_FV_table_status;
    PRINT N'        Primary Key                   : ' + @INVMN_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @INVMN_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @INVMN_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @INVMN_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @INVMN_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @INVMN_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @INVMN_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @INVMN_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @INVMN_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @INVMN_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @INVMN_FV_validation_errors = 0
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
                @INVMN_FV_validation_errors
            );

        PRINT N'';


        ;THROW 51090,
            N'Final validation failed for inventory.InventoryMovementNote.',
            1;

    END;


    PRINT N'';