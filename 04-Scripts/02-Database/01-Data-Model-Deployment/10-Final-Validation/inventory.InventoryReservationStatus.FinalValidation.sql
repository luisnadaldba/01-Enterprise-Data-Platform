    PRINT N'    ● inventory.InventoryReservationStatus';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @INVRS_FV_validation_errors int = 0;

    DECLARE @INVRS_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRS_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRS_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRS_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRS_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRS_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRS_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @INVRS_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRS_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @INVRS_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @INVRS_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'inventory.InventoryReservationStatus', N'U') IS NOT NULL
    BEGIN
        SET @INVRS_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRS_FV_table_status = N'FAILED';
        SET @INVRS_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @INVRS_FV_pk_actual_name     sysname;
    DECLARE @INVRS_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @INVRS_FV_pk_data_space      sysname;


    SELECT
        @INVRS_FV_pk_actual_name = kc.name,
        @INVRS_FV_pk_data_space = ds.name,

        @INVRS_FV_pk_actual_columns =
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
            OBJECT_ID(N'inventory.InventoryReservationStatus')

    AND kc.type = N'PK';


    IF @INVRS_FV_pk_actual_name = N'PK_INVRS'
    AND @INVRS_FV_pk_actual_columns = N'INVRS_id'
    AND @INVRS_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @INVRS_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRS_FV_primary_key_status = N'FAILED';
        SET @INVRS_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @INVRS_FV_expected_column_count int = 4;
    DECLARE @INVRS_FV_actual_column_count   int;


    SELECT
        @INVRS_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'inventory.InventoryReservationStatus');


    IF @INVRS_FV_actual_column_count =
            @INVRS_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'inventory.InventoryReservationStatus')

        AND c.name = N'INVRS_id'
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
                OBJECT_ID(N'inventory.InventoryReservationStatus')

        AND ic.name = N'INVRS_id'
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
                OBJECT_ID(N'inventory.InventoryReservationStatus')

        AND c.name = N'INVRS_name'
        AND t.name = N'nvarchar'
        AND c.max_length = 100
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'inventory.InventoryReservationStatus')

        AND c.name = N'INVRS_created_at'
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
                OBJECT_ID(N'inventory.InventoryReservationStatus')

        AND c.name = N'INVRS_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @INVRS_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRS_FV_columns_status = N'FAILED';
        SET @INVRS_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @INVRS_FV_expected_documentation TABLE
    (
        INVRS_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        INVRS_doc_object_type           nvarchar(10) NOT NULL,
        INVRS_doc_column_name           sysname NULL,
        INVRS_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @INVRS_FV_doc_current_id        tinyint;
    DECLARE @INVRS_FV_doc_max_id            tinyint;
    DECLARE @INVRS_FV_doc_object_type       nvarchar(10);
    DECLARE @INVRS_FV_doc_column_name       sysname;
    DECLARE @INVRS_FV_doc_expected_value    nvarchar(4000);
    DECLARE @INVRS_FV_doc_actual_value      nvarchar(4000);
    DECLARE @INVRS_FV_invalid_documentation int = 0;


    INSERT INTO @INVRS_FV_expected_documentation
    (
        INVRS_doc_object_type,
        INVRS_doc_column_name,
        INVRS_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Defines the controlled statuses used to represent the lifecycle of inventory reservations in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'INVRS_id',
        N'Primary key of inventory.InventoryReservationStatus.'
    ),
    (
        N'COLUMN',
        N'INVRS_name',
        N'Stores the controlled name of the inventory reservation status used by Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'INVRS_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'INVRS_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @INVRS_FV_doc_current_id =
            MIN(INVRS_doc_id),

        @INVRS_FV_doc_max_id =
            MAX(INVRS_doc_id)

    FROM @INVRS_FV_expected_documentation;


    WHILE @INVRS_FV_doc_current_id <=
        @INVRS_FV_doc_max_id
    BEGIN

        SET @INVRS_FV_doc_object_type = NULL;
        SET @INVRS_FV_doc_column_name = NULL;
        SET @INVRS_FV_doc_expected_value = NULL;
        SET @INVRS_FV_doc_actual_value = NULL;


        SELECT
            @INVRS_FV_doc_object_type =
                INVRS_doc_object_type,

            @INVRS_FV_doc_column_name =
                INVRS_doc_column_name,

            @INVRS_FV_doc_expected_value =
                INVRS_doc_expected_description

        FROM @INVRS_FV_expected_documentation

        WHERE INVRS_doc_id =
                @INVRS_FV_doc_current_id;


        IF @INVRS_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @INVRS_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @INVRS_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @INVRS_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @INVRS_FV_doc_actual_value,
            N''
        )
        <>
        @INVRS_FV_doc_expected_value
        BEGIN

            SET @INVRS_FV_invalid_documentation += 1;

        END;


        SET @INVRS_FV_doc_current_id += 1;

    END;


    IF @INVRS_FV_invalid_documentation = 0
    BEGIN
        SET @INVRS_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRS_FV_documentation_status = N'FAILED';
        SET @INVRS_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    DECLARE @INVRS_FV_invalid_seed_rows int = 0;

    DECLARE @INVRS_FV_expected_statuses TABLE
    (
        INVRS_status_name nvarchar(50) NOT NULL
    );


    INSERT INTO @INVRS_FV_expected_statuses
    (
        INVRS_status_name
    )
    VALUES
        (N'ACTIVE'),
        (N'CONSUMED'),
        (N'RELEASED'),
        (N'EXPIRED');


    /*--------------------------------------------------------------------------
        All contracted statuses must exist.
    --------------------------------------------------------------------------*/

    IF EXISTS
    (
        SELECT 1

        FROM @INVRS_FV_expected_statuses AS expected

        WHERE NOT EXISTS
        (
            SELECT 1

            FROM inventory.InventoryReservationStatus AS actual

            WHERE actual.INVRS_name =
                    expected.INVRS_status_name
        )
    )
    BEGIN
        SET @INVRS_FV_invalid_seed_rows += 1;
    END;


    /*--------------------------------------------------------------------------
        No additional status rows are allowed.
    --------------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)
        FROM inventory.InventoryReservationStatus
    ) <> 4
    BEGIN
        SET @INVRS_FV_invalid_seed_rows += 1;
    END;


    IF @INVRS_FV_invalid_seed_rows = 0
    BEGIN
        SET @INVRS_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRS_FV_seed_data_status = N'FAILED';
        SET @INVRS_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @INVRS_FV_expected_defaults TABLE
    (
        INVRS_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        INVRS_default_column_name          sysname NOT NULL,
        INVRS_default_constraint_name      sysname NOT NULL,
        INVRS_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @INVRS_FV_default_current_id          tinyint;
    DECLARE @INVRS_FV_default_max_id              tinyint;
    DECLARE @INVRS_FV_default_column_name         sysname;
    DECLARE @INVRS_FV_default_expected_name       sysname;
    DECLARE @INVRS_FV_default_actual_name         sysname;
    DECLARE @INVRS_FV_default_expected_definition nvarchar(4000);
    DECLARE @INVRS_FV_default_actual_definition   nvarchar(4000);
    DECLARE @INVRS_FV_default_expected_normalized nvarchar(4000);
    DECLARE @INVRS_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @INVRS_FV_invalid_defaults            int = 0;


    INSERT INTO @INVRS_FV_expected_defaults
    (
        INVRS_default_column_name,
        INVRS_default_constraint_name,
        INVRS_default_expected_definition
    )
    VALUES
    (
        N'INVRS_created_at',
        N'DF_INVRS_created_at',
        N'sysdatetime'
    ),
    (
        N'INVRS_updated_at',
        N'DF_INVRS_updated_at',
        N'sysdatetime'
    );


    SELECT
        @INVRS_FV_default_current_id =
            MIN(INVRS_default_id),

        @INVRS_FV_default_max_id =
            MAX(INVRS_default_id)

    FROM @INVRS_FV_expected_defaults;


    WHILE @INVRS_FV_default_current_id <=
        @INVRS_FV_default_max_id
    BEGIN

        SET @INVRS_FV_default_column_name = NULL;
        SET @INVRS_FV_default_expected_name = NULL;
        SET @INVRS_FV_default_actual_name = NULL;
        SET @INVRS_FV_default_expected_definition = NULL;
        SET @INVRS_FV_default_actual_definition = NULL;


        SELECT
            @INVRS_FV_default_column_name =
                INVRS_default_column_name,

            @INVRS_FV_default_expected_name =
                INVRS_default_constraint_name,

            @INVRS_FV_default_expected_definition =
                INVRS_default_expected_definition

        FROM @INVRS_FV_expected_defaults

        WHERE INVRS_default_id =
                @INVRS_FV_default_current_id;


        SELECT
            @INVRS_FV_default_actual_name =
                dc.name,

            @INVRS_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservationStatus')

        AND c.name =
                @INVRS_FV_default_column_name;


        SET @INVRS_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @INVRS_FV_default_expected_definition,
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


        SET @INVRS_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @INVRS_FV_default_actual_definition,
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


        IF @INVRS_FV_default_actual_name IS NULL
        OR @INVRS_FV_default_actual_name <>
                @INVRS_FV_default_expected_name
        OR @INVRS_FV_default_actual_definition IS NULL
        OR @INVRS_FV_default_actual_normalized <>
                @INVRS_FV_default_expected_normalized
        BEGIN

            SET @INVRS_FV_invalid_defaults += 1;

        END;


        SET @INVRS_FV_default_current_id += 1;

    END;


    IF @INVRS_FV_invalid_defaults = 0
    BEGIN
        SET @INVRS_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRS_FV_defaults_status = N'FAILED';
        SET @INVRS_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @INVRS_FV_uq_actual_name        sysname;
    DECLARE @INVRS_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @INVRS_FV_uq_actual_disabled    bit;
    DECLARE @INVRS_FV_uq_actual_data_space  sysname;


    SELECT
        @INVRS_FV_uq_actual_name =
            kc.name,

        @INVRS_FV_uq_actual_disabled =
            i.is_disabled,

        @INVRS_FV_uq_actual_data_space =
            ds.name,

        @INVRS_FV_uq_actual_columns =
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
            OBJECT_ID(N'inventory.InventoryReservationStatus')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_INVRS_name';


    IF @INVRS_FV_uq_actual_name =
            N'UQ_INVRS_name'

    AND @INVRS_FV_uq_actual_columns =
            N'INVRS_name'

    AND @INVRS_FV_uq_actual_disabled = 0

    AND @INVRS_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @INVRS_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @INVRS_FV_uniques_status = N'FAILED';
        SET @INVRS_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @INVRS_FV_table_status;
    PRINT N'        Primary Key                   : ' + @INVRS_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @INVRS_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @INVRS_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @INVRS_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @INVRS_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @INVRS_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @INVRS_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @INVRS_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @INVRS_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @INVRS_FV_temporal_integrity_status;
    PRINT N'';

    IF @INVRS_FV_validation_errors = 0
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
                @INVRS_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @INVRS_FV_validation_errors > 0
    BEGIN

        ;THROW 50931,
            N'Final validation failed for inventory.InventoryReservationStatus.',
            1;

    END;