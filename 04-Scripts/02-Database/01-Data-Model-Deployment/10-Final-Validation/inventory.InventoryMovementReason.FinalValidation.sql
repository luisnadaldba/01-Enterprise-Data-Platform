    PRINT N'    inventory.InventoryMovementReason';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @INVMR_FV_validation_errors int = 0;

    DECLARE @INVMR_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMR_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMR_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMR_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMR_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMR_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMR_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @INVMR_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMR_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @INVMR_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @INVMR_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovementReason', N'U') IS NOT NULL
    BEGIN
        SET @INVMR_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMR_FV_table_status = N'FAILED';
        SET @INVMR_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @INVMR_FV_pk_actual_name     sysname;
    DECLARE @INVMR_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @INVMR_FV_pk_data_space      sysname;


    SELECT
        @INVMR_FV_pk_actual_name = kc.name,
        @INVMR_FV_pk_data_space = ds.name,

        @INVMR_FV_pk_actual_columns =
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
            OBJECT_ID(N'inventory.InventoryMovementReason')

    AND kc.type = N'PK';


    IF @INVMR_FV_pk_actual_name = N'PK_INVMR'
    AND @INVMR_FV_pk_actual_columns = N'INVMR_id'
    AND @INVMR_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @INVMR_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMR_FV_primary_key_status = N'FAILED';
        SET @INVMR_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @INVMR_FV_expected_column_count int = 4;
    DECLARE @INVMR_FV_actual_column_count   int;


    SELECT
        @INVMR_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'inventory.InventoryMovementReason');


    IF @INVMR_FV_actual_column_count =
            @INVMR_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND c.name = N'INVMR_id'
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
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ic.name = N'INVMR_id'
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
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND c.name = N'INVMR_name'
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
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND c.name = N'INVMR_created_at'
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
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND c.name = N'INVMR_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @INVMR_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMR_FV_columns_status = N'FAILED';
        SET @INVMR_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @INVMR_FV_expected_documentation TABLE
    (
        INVMR_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        INVMR_doc_object_type           nvarchar(10) NOT NULL,
        INVMR_doc_column_name           sysname NULL,
        INVMR_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @INVMR_FV_doc_current_id        tinyint;
    DECLARE @INVMR_FV_doc_max_id            tinyint;
    DECLARE @INVMR_FV_doc_object_type       nvarchar(10);
    DECLARE @INVMR_FV_doc_column_name       sysname;
    DECLARE @INVMR_FV_doc_expected_value    nvarchar(4000);
    DECLARE @INVMR_FV_doc_actual_value      nvarchar(4000);
    DECLARE @INVMR_FV_invalid_documentation int = 0;


    INSERT INTO @INVMR_FV_expected_documentation
    (
        INVMR_doc_object_type,
        INVMR_doc_column_name,
        INVMR_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the controlled reasons used to classify inventory movements in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'INVMR_id',
        N'Primary key of inventory.InventoryMovementReason.'
    ),
    (
        N'COLUMN',
        N'INVMR_name',
        N'Stores the controlled business name of the inventory movement reason.'
    ),
    (
        N'COLUMN',
        N'INVMR_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'INVMR_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @INVMR_FV_doc_current_id =
            MIN(INVMR_doc_id),

        @INVMR_FV_doc_max_id =
            MAX(INVMR_doc_id)

    FROM @INVMR_FV_expected_documentation;


    WHILE @INVMR_FV_doc_current_id <=
        @INVMR_FV_doc_max_id
    BEGIN

        SET @INVMR_FV_doc_object_type = NULL;
        SET @INVMR_FV_doc_column_name = NULL;
        SET @INVMR_FV_doc_expected_value = NULL;
        SET @INVMR_FV_doc_actual_value = NULL;


        SELECT
            @INVMR_FV_doc_object_type =
                INVMR_doc_object_type,

            @INVMR_FV_doc_column_name =
                INVMR_doc_column_name,

            @INVMR_FV_doc_expected_value =
                INVMR_doc_expected_description

        FROM @INVMR_FV_expected_documentation

        WHERE INVMR_doc_id =
                @INVMR_FV_doc_current_id;


        IF @INVMR_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @INVMR_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'inventory.InventoryMovementReason')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @INVMR_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'inventory.InventoryMovementReason')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @INVMR_FV_doc_column_name;

        END;


        IF ISNULL(@INVMR_FV_doc_actual_value, N'')
            <> @INVMR_FV_doc_expected_value
        BEGIN

            SET @INVMR_FV_invalid_documentation += 1;

        END;


        SET @INVMR_FV_doc_current_id += 1;

    END;


    IF @INVMR_FV_invalid_documentation = 0
    BEGIN
        SET @INVMR_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMR_FV_documentation_status = N'FAILED';
        SET @INVMR_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    DECLARE @INVMR_FV_invalid_seed_rows int = 0;


    IF NOT EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'inventory'
        AND PFX_table_name = N'InventoryMovementReason'
        AND PFX_prefix = N'INVMR'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @INVMR_FV_invalid_seed_rows += 1;
    END;


    DECLARE @INVMR_FV_expected_reasons TABLE
    (
        INVMR_reason_name nvarchar(100) NOT NULL
    );


    INSERT INTO @INVMR_FV_expected_reasons
    (
        INVMR_reason_name
    )
    VALUES
        (N'PURCHASE_RECEIPT'),
        (N'SALE'),
        (N'CUSTOMER_RETURN'),
        (N'DAMAGED_IN_TRANSIT'),
        (N'DAMAGED_INTERNAL'),
        (N'LOSS_IN_TRANSIT'),
        (N'LOSS_INTERNAL'),
        (N'FOUND_INTERNAL'),
        (N'INVENTORY_ADJUSTMENT_IN'),
        (N'INVENTORY_ADJUSTMENT_OUT');


    IF EXISTS
    (
        SELECT 1

        FROM @INVMR_FV_expected_reasons AS expected

        WHERE NOT EXISTS
        (
            SELECT 1

            FROM inventory.InventoryMovementReason AS actual

            WHERE actual.INVMR_name =
                    expected.INVMR_reason_name
        )
    )
    BEGIN
        SET @INVMR_FV_invalid_seed_rows += 1;
    END;


    IF @INVMR_FV_invalid_seed_rows = 0
    BEGIN
        SET @INVMR_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMR_FV_seed_data_status = N'FAILED';
        SET @INVMR_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @INVMR_FV_expected_defaults TABLE
    (
        INVMR_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        INVMR_default_column_name          sysname NOT NULL,
        INVMR_default_constraint_name      sysname NOT NULL,
        INVMR_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @INVMR_FV_default_current_id          tinyint;
    DECLARE @INVMR_FV_default_max_id              tinyint;
    DECLARE @INVMR_FV_default_column_name         sysname;
    DECLARE @INVMR_FV_default_expected_name       sysname;
    DECLARE @INVMR_FV_default_actual_name         sysname;
    DECLARE @INVMR_FV_default_expected_definition nvarchar(4000);
    DECLARE @INVMR_FV_default_actual_definition   nvarchar(4000);
    DECLARE @INVMR_FV_default_expected_normalized nvarchar(4000);
    DECLARE @INVMR_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @INVMR_FV_invalid_defaults            int = 0;


    INSERT INTO @INVMR_FV_expected_defaults
    (
        INVMR_default_column_name,
        INVMR_default_constraint_name,
        INVMR_default_expected_definition
    )
    VALUES
    (
        N'INVMR_created_at',
        N'DF_INVMR_created_at',
        N'sysdatetime'
    ),
    (
        N'INVMR_updated_at',
        N'DF_INVMR_updated_at',
        N'sysdatetime'
    );


    SELECT
        @INVMR_FV_default_current_id =
            MIN(INVMR_default_id),

        @INVMR_FV_default_max_id =
            MAX(INVMR_default_id)

    FROM @INVMR_FV_expected_defaults;


    WHILE @INVMR_FV_default_current_id <=
        @INVMR_FV_default_max_id
    BEGIN

        SET @INVMR_FV_default_column_name = NULL;
        SET @INVMR_FV_default_expected_name = NULL;
        SET @INVMR_FV_default_actual_name = NULL;
        SET @INVMR_FV_default_expected_definition = NULL;
        SET @INVMR_FV_default_actual_definition = NULL;


        SELECT
            @INVMR_FV_default_column_name =
                INVMR_default_column_name,

            @INVMR_FV_default_expected_name =
                INVMR_default_constraint_name,

            @INVMR_FV_default_expected_definition =
                INVMR_default_expected_definition

        FROM @INVMR_FV_expected_defaults

        WHERE INVMR_default_id =
                @INVMR_FV_default_current_id;


        SELECT
            @INVMR_FV_default_actual_name =
                dc.name,

            @INVMR_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND c.name =
                @INVMR_FV_default_column_name;


        SET @INVMR_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @INVMR_FV_default_expected_definition,
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


        SET @INVMR_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @INVMR_FV_default_actual_definition,
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


        IF @INVMR_FV_default_actual_name IS NULL
        OR @INVMR_FV_default_actual_name <>
                @INVMR_FV_default_expected_name
        OR @INVMR_FV_default_actual_definition IS NULL
        OR @INVMR_FV_default_actual_normalized <>
                @INVMR_FV_default_expected_normalized
        BEGIN

            SET @INVMR_FV_invalid_defaults += 1;

        END;


        SET @INVMR_FV_default_current_id += 1;

    END;


    IF @INVMR_FV_invalid_defaults = 0
    BEGIN
        SET @INVMR_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVMR_FV_defaults_status = N'FAILED';
        SET @INVMR_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @INVMR_FV_uq_actual_name         sysname;
    DECLARE @INVMR_FV_uq_actual_columns      nvarchar(4000);
    DECLARE @INVMR_FV_uq_is_disabled         bit;
    DECLARE @INVMR_FV_uq_data_space          sysname;


    SELECT
        @INVMR_FV_uq_actual_name =
            kc.name,

        @INVMR_FV_uq_is_disabled =
            i.is_disabled,

        @INVMR_FV_uq_data_space =
            ds.name,

        @INVMR_FV_uq_actual_columns =
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
            OBJECT_ID(N'inventory.InventoryMovementReason')

    AND kc.type = N'UQ'

    AND kc.name = N'UQ_INVMR_name';


    IF @INVMR_FV_uq_actual_name = N'UQ_INVMR_name'
    AND @INVMR_FV_uq_actual_columns = N'INVMR_name'
    AND @INVMR_FV_uq_is_disabled = 0
    AND @INVMR_FV_uq_data_space = N'FG_CORE'
    BEGIN

        SET @INVMR_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @INVMR_FV_uniques_status = N'FAILED';
        SET @INVMR_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @INVMR_FV_table_status;
    PRINT N'        Primary Key                   : ' + @INVMR_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @INVMR_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @INVMR_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @INVMR_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @INVMR_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @INVMR_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @INVMR_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @INVMR_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @INVMR_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @INVMR_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @INVMR_FV_validation_errors = 0
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
                @INVMR_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50850,
            N'Final validation failed for inventory.InventoryMovementReason.',
            1;

    END;


    PRINT N'';