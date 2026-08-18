    PRINT N'    shipping.ShipmentStatus';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @SHPST_FV_validation_errors int = 0;

    DECLARE @SHPST_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPST_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPST_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPST_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPST_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPST_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPST_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @SHPST_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPST_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @SHPST_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @SHPST_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'shipping.ShipmentStatus', N'U') IS NOT NULL
    BEGIN
        SET @SHPST_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPST_FV_table_status = N'FAILED';
        SET @SHPST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @SHPST_FV_pk_actual_name     sysname;
    DECLARE @SHPST_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @SHPST_FV_pk_data_space      sysname;


    SELECT
        @SHPST_FV_pk_actual_name = kc.name,
        @SHPST_FV_pk_data_space = ds.name,

        @SHPST_FV_pk_actual_columns =
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
            OBJECT_ID(N'shipping.ShipmentStatus')

    AND kc.type = N'PK';


    IF @SHPST_FV_pk_actual_name = N'PK_SHPST'
    AND @SHPST_FV_pk_actual_columns = N'SHPST_id'
    AND @SHPST_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @SHPST_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPST_FV_primary_key_status = N'FAILED';
        SET @SHPST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @SHPST_FV_expected_column_count int = 4;
    DECLARE @SHPST_FV_actual_column_count   int;


    SELECT
        @SHPST_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'shipping.ShipmentStatus');


    IF @SHPST_FV_actual_column_count =
            @SHPST_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND c.name = N'SHPST_id'
        AND t.name = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ic.name = N'SHPST_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND c.name = N'SHPST_name'
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
        WHERE c.object_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND c.name = N'SHPST_created_at'
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
        WHERE c.object_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND c.name = N'SHPST_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @SHPST_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPST_FV_columns_status = N'FAILED';
        SET @SHPST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @SHPST_FV_expected_documentation TABLE
    (
        SHPST_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        SHPST_doc_object_type           nvarchar(10) NOT NULL,
        SHPST_doc_column_name           sysname NULL,
        SHPST_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @SHPST_FV_doc_current_id        tinyint;
    DECLARE @SHPST_FV_doc_max_id            tinyint;
    DECLARE @SHPST_FV_doc_object_type       nvarchar(10);
    DECLARE @SHPST_FV_doc_column_name       sysname;
    DECLARE @SHPST_FV_doc_expected_value    nvarchar(4000);
    DECLARE @SHPST_FV_doc_actual_value      nvarchar(4000);
    DECLARE @SHPST_FV_invalid_documentation int = 0;


    INSERT INTO @SHPST_FV_expected_documentation
    (
        SHPST_doc_object_type,
        SHPST_doc_column_name,
        SHPST_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Defines the controlled statuses used to represent the operational lifecycle of Atlas Commerce shipments.'
    ),
    (
        N'COLUMN',
        N'SHPST_id',
        N'Primary key of shipping.ShipmentStatus.'
    ),
    (
        N'COLUMN',
        N'SHPST_name',
        N'Stores the controlled shipment status representing the current operational state of a shipment.'
    ),
    (
        N'COLUMN',
        N'SHPST_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'SHPST_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @SHPST_FV_doc_current_id = MIN(SHPST_doc_id),
        @SHPST_FV_doc_max_id = MAX(SHPST_doc_id)
    FROM @SHPST_FV_expected_documentation;


    WHILE @SHPST_FV_doc_current_id <= @SHPST_FV_doc_max_id
    BEGIN

        SET @SHPST_FV_doc_object_type = NULL;
        SET @SHPST_FV_doc_column_name = NULL;
        SET @SHPST_FV_doc_expected_value = NULL;
        SET @SHPST_FV_doc_actual_value = NULL;


        SELECT
            @SHPST_FV_doc_object_type =
                SHPST_doc_object_type,

            @SHPST_FV_doc_column_name =
                SHPST_doc_column_name,

            @SHPST_FV_doc_expected_value =
                SHPST_doc_expected_description

        FROM @SHPST_FV_expected_documentation

        WHERE SHPST_doc_id =
                @SHPST_FV_doc_current_id;


        IF @SHPST_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @SHPST_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'shipping.ShipmentStatus')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @SHPST_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'shipping.ShipmentStatus')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @SHPST_FV_doc_column_name;

        END;


        IF ISNULL(@SHPST_FV_doc_actual_value, N'') <>
            @SHPST_FV_doc_expected_value
        BEGIN
            SET @SHPST_FV_invalid_documentation += 1;
        END;


        SET @SHPST_FV_doc_current_id += 1;

    END;


    IF @SHPST_FV_invalid_documentation = 0
    BEGIN
        SET @SHPST_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPST_FV_documentation_status = N'FAILED';
        SET @SHPST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'shipping'
        AND PFX_table_name = N'ShipmentStatus'
        AND PFX_prefix = N'SHPST'
        AND PFX_is_active = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentStatus
        WHERE SHPST_name = N'PENDING'
    )

    AND EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentStatus
        WHERE SHPST_name = N'POSTED'
    )

    AND EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentStatus
        WHERE SHPST_name = N'DELIVERED'
    )

    AND EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentStatus
        WHERE SHPST_name = N'CANCELLED'
    )

    AND EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentStatus
        WHERE SHPST_name = N'RETURNED'
    )

    AND
    (
        SELECT COUNT(*)
        FROM shipping.ShipmentStatus
        WHERE SHPST_name IN
        (
            N'PENDING',
            N'POSTED',
            N'DELIVERED',
            N'CANCELLED',
            N'RETURNED'
        )
    ) = 5

    BEGIN
        SET @SHPST_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPST_FV_seed_data_status = N'FAILED';
        SET @SHPST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @SHPST_FV_expected_defaults TABLE
    (
        SHPST_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        SHPST_default_column_name          sysname NOT NULL,
        SHPST_default_constraint_name      sysname NOT NULL,
        SHPST_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @SHPST_FV_default_current_id          tinyint;
    DECLARE @SHPST_FV_default_max_id              tinyint;
    DECLARE @SHPST_FV_default_column_name         sysname;
    DECLARE @SHPST_FV_default_expected_name       sysname;
    DECLARE @SHPST_FV_default_actual_name         sysname;
    DECLARE @SHPST_FV_default_expected_definition nvarchar(4000);
    DECLARE @SHPST_FV_default_actual_definition   nvarchar(4000);
    DECLARE @SHPST_FV_default_expected_normalized nvarchar(4000);
    DECLARE @SHPST_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @SHPST_FV_invalid_defaults            int = 0;


    INSERT INTO @SHPST_FV_expected_defaults
    (
        SHPST_default_column_name,
        SHPST_default_constraint_name,
        SHPST_default_expected_definition
    )
    VALUES
    (
        N'SHPST_created_at',
        N'DF_SHPST_created_at',
        N'sysdatetime'
    ),
    (
        N'SHPST_updated_at',
        N'DF_SHPST_updated_at',
        N'sysdatetime'
    );


    SELECT
        @SHPST_FV_default_current_id =
            MIN(SHPST_default_id),

        @SHPST_FV_default_max_id =
            MAX(SHPST_default_id)

    FROM @SHPST_FV_expected_defaults;


    WHILE @SHPST_FV_default_current_id <=
        @SHPST_FV_default_max_id
    BEGIN

        SET @SHPST_FV_default_column_name = NULL;
        SET @SHPST_FV_default_expected_name = NULL;
        SET @SHPST_FV_default_actual_name = NULL;
        SET @SHPST_FV_default_expected_definition = NULL;
        SET @SHPST_FV_default_actual_definition = NULL;


        SELECT
            @SHPST_FV_default_column_name =
                SHPST_default_column_name,

            @SHPST_FV_default_expected_name =
                SHPST_default_constraint_name,

            @SHPST_FV_default_expected_definition =
                SHPST_default_expected_definition

        FROM @SHPST_FV_expected_defaults

        WHERE SHPST_default_id =
                @SHPST_FV_default_current_id;


        SELECT
            @SHPST_FV_default_actual_name =
                dc.name,

            @SHPST_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'shipping.ShipmentStatus')

        AND c.name =
                @SHPST_FV_default_column_name;


        SET @SHPST_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @SHPST_FV_default_expected_definition,
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


        SET @SHPST_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @SHPST_FV_default_actual_definition,
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


        IF @SHPST_FV_default_actual_name IS NULL
        OR @SHPST_FV_default_actual_name <>
                @SHPST_FV_default_expected_name
        OR @SHPST_FV_default_actual_definition IS NULL
        OR @SHPST_FV_default_actual_normalized <>
                @SHPST_FV_default_expected_normalized
        BEGIN
            SET @SHPST_FV_invalid_defaults += 1;
        END;


        SET @SHPST_FV_default_current_id += 1;

    END;


    IF @SHPST_FV_invalid_defaults = 0
    BEGIN
        SET @SHPST_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPST_FV_defaults_status = N'FAILED';
        SET @SHPST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @SHPST_FV_uq_actual_name        sysname;
    DECLARE @SHPST_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @SHPST_FV_uq_actual_disabled    bit;
    DECLARE @SHPST_FV_uq_actual_data_space  sysname;


    SELECT
        @SHPST_FV_uq_actual_name =
            kc.name,

        @SHPST_FV_uq_actual_disabled =
            i.is_disabled,

        @SHPST_FV_uq_actual_data_space =
            ds.name,

        @SHPST_FV_uq_actual_columns =
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
            OBJECT_ID(N'shipping.ShipmentStatus')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_SHPST_name';


    IF @SHPST_FV_uq_actual_name = N'UQ_SHPST_name'
    AND @SHPST_FV_uq_actual_columns = N'SHPST_name'
    AND @SHPST_FV_uq_actual_disabled = 0
    AND @SHPST_FV_uq_actual_data_space = N'FG_CORE'
    BEGIN

        SET @SHPST_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @SHPST_FV_uniques_status = N'FAILED';
        SET @SHPST_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @SHPST_FV_table_status;
    PRINT N'        Primary Key                   : ' + @SHPST_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @SHPST_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @SHPST_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @SHPST_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @SHPST_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @SHPST_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @SHPST_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @SHPST_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @SHPST_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @SHPST_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @SHPST_FV_validation_errors = 0
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
            + CONVERT(nvarchar(10), @SHPST_FV_validation_errors);

        PRINT N'';

        ;THROW 51130,
            N'Final validation failed for shipping.ShipmentStatus.',
            1;

    END;


    PRINT N'';