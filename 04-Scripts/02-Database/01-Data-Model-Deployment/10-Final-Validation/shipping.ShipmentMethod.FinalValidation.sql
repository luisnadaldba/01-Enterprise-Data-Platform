    PRINT N'    shipping.ShipmentMethod';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @SHPMT_FV_validation_errors int = 0;

    DECLARE @SHPMT_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPMT_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPMT_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPMT_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPMT_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPMT_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPMT_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @SHPMT_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHPMT_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @SHPMT_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @SHPMT_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'shipping.ShipmentMethod', N'U') IS NOT NULL
    BEGIN
        SET @SHPMT_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPMT_FV_table_status = N'FAILED';
        SET @SHPMT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @SHPMT_FV_pk_actual_name     sysname;
    DECLARE @SHPMT_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @SHPMT_FV_pk_data_space      sysname;


    SELECT
        @SHPMT_FV_pk_actual_name = kc.name,
        @SHPMT_FV_pk_data_space = ds.name,

        @SHPMT_FV_pk_actual_columns =
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
            OBJECT_ID(N'shipping.ShipmentMethod')

    AND kc.type = N'PK';


    IF @SHPMT_FV_pk_actual_name = N'PK_SHPMT'
    AND @SHPMT_FV_pk_actual_columns = N'SHPMT_id'
    AND @SHPMT_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @SHPMT_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPMT_FV_primary_key_status = N'FAILED';
        SET @SHPMT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @SHPMT_FV_expected_column_count int = 4;
    DECLARE @SHPMT_FV_actual_column_count   int;


    SELECT
        @SHPMT_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'shipping.ShipmentMethod');


    IF @SHPMT_FV_actual_column_count =
            @SHPMT_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'shipping.ShipmentMethod')

        AND c.name = N'SHPMT_id'
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
                OBJECT_ID(N'shipping.ShipmentMethod')

        AND ic.name = N'SHPMT_id'
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
                OBJECT_ID(N'shipping.ShipmentMethod')

        AND c.name = N'SHPMT_name'
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

        WHERE c.object_id =
                OBJECT_ID(N'shipping.ShipmentMethod')

        AND c.name = N'SHPMT_created_at'
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
                OBJECT_ID(N'shipping.ShipmentMethod')

        AND c.name = N'SHPMT_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @SHPMT_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPMT_FV_columns_status = N'FAILED';
        SET @SHPMT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @SHPMT_FV_expected_documentation TABLE
    (
        SHPMT_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        SHPMT_doc_object_type           nvarchar(10) NOT NULL,
        SHPMT_doc_column_name           sysname NULL,
        SHPMT_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @SHPMT_FV_doc_current_id        tinyint;
    DECLARE @SHPMT_FV_doc_max_id            tinyint;
    DECLARE @SHPMT_FV_doc_object_type       nvarchar(10);
    DECLARE @SHPMT_FV_doc_column_name       sysname;
    DECLARE @SHPMT_FV_doc_expected_value    nvarchar(4000);
    DECLARE @SHPMT_FV_doc_actual_value      nvarchar(4000);
    DECLARE @SHPMT_FV_invalid_documentation int = 0;


    INSERT INTO @SHPMT_FV_expected_documentation
    (
        SHPMT_doc_object_type,
        SHPMT_doc_column_name,
        SHPMT_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Defines the controlled shipment methods available for Atlas Commerce deliveries.'
    ),
    (
        N'COLUMN',
        N'SHPMT_id',
        N'Primary key of shipping.ShipmentMethod.'
    ),
    (
        N'COLUMN',
        N'SHPMT_name',
        N'Stores the controlled shipment method selected for Atlas Commerce deliveries.'
    ),
    (
        N'COLUMN',
        N'SHPMT_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'SHPMT_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @SHPMT_FV_doc_current_id =
            MIN(SHPMT_doc_id),

        @SHPMT_FV_doc_max_id =
            MAX(SHPMT_doc_id)

    FROM @SHPMT_FV_expected_documentation;


    WHILE @SHPMT_FV_doc_current_id <=
        @SHPMT_FV_doc_max_id
    BEGIN

        SET @SHPMT_FV_doc_object_type = NULL;
        SET @SHPMT_FV_doc_column_name = NULL;
        SET @SHPMT_FV_doc_expected_value = NULL;
        SET @SHPMT_FV_doc_actual_value = NULL;


        SELECT
            @SHPMT_FV_doc_object_type =
                SHPMT_doc_object_type,

            @SHPMT_FV_doc_column_name =
                SHPMT_doc_column_name,

            @SHPMT_FV_doc_expected_value =
                SHPMT_doc_expected_description

        FROM @SHPMT_FV_expected_documentation

        WHERE SHPMT_doc_id =
                @SHPMT_FV_doc_current_id;


        IF @SHPMT_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @SHPMT_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'shipping.ShipmentMethod')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @SHPMT_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'shipping.ShipmentMethod')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @SHPMT_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @SHPMT_FV_doc_actual_value,
            N''
        )
        <>
        @SHPMT_FV_doc_expected_value
        BEGIN

            SET @SHPMT_FV_invalid_documentation += 1;

        END;


        SET @SHPMT_FV_doc_current_id += 1;

    END;


    IF @SHPMT_FV_invalid_documentation = 0
    BEGIN
        SET @SHPMT_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPMT_FV_documentation_status = N'FAILED';
        SET @SHPMT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'shipping'
        AND PFX_table_name = N'ShipmentMethod'
        AND PFX_prefix = N'SHPMT'
        AND PFX_is_active = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentMethod
        WHERE SHPMT_name = N'PAC'
    )

    AND EXISTS
    (
        SELECT 1
        FROM shipping.ShipmentMethod
        WHERE SHPMT_name = N'SEDEX'
    )

    AND
    (
        SELECT COUNT(*)
        FROM shipping.ShipmentMethod
        WHERE SHPMT_name IN
        (
            N'PAC',
            N'SEDEX'
        )
    ) = 2

    BEGIN
        SET @SHPMT_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPMT_FV_seed_data_status = N'FAILED';
        SET @SHPMT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @SHPMT_FV_expected_defaults TABLE
    (
        SHPMT_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        SHPMT_default_column_name          sysname NOT NULL,
        SHPMT_default_constraint_name      sysname NOT NULL,
        SHPMT_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @SHPMT_FV_default_current_id          tinyint;
    DECLARE @SHPMT_FV_default_max_id              tinyint;
    DECLARE @SHPMT_FV_default_column_name         sysname;
    DECLARE @SHPMT_FV_default_expected_name       sysname;
    DECLARE @SHPMT_FV_default_actual_name         sysname;
    DECLARE @SHPMT_FV_default_expected_definition nvarchar(4000);
    DECLARE @SHPMT_FV_default_actual_definition   nvarchar(4000);
    DECLARE @SHPMT_FV_default_expected_normalized nvarchar(4000);
    DECLARE @SHPMT_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @SHPMT_FV_invalid_defaults            int = 0;


    INSERT INTO @SHPMT_FV_expected_defaults
    (
        SHPMT_default_column_name,
        SHPMT_default_constraint_name,
        SHPMT_default_expected_definition
    )
    VALUES
    (
        N'SHPMT_created_at',
        N'DF_SHPMT_created_at',
        N'sysdatetime'
    ),
    (
        N'SHPMT_updated_at',
        N'DF_SHPMT_updated_at',
        N'sysdatetime'
    );


    SELECT
        @SHPMT_FV_default_current_id =
            MIN(SHPMT_default_id),

        @SHPMT_FV_default_max_id =
            MAX(SHPMT_default_id)

    FROM @SHPMT_FV_expected_defaults;


    WHILE @SHPMT_FV_default_current_id <=
        @SHPMT_FV_default_max_id
    BEGIN

        SET @SHPMT_FV_default_column_name = NULL;
        SET @SHPMT_FV_default_expected_name = NULL;
        SET @SHPMT_FV_default_actual_name = NULL;
        SET @SHPMT_FV_default_expected_definition = NULL;
        SET @SHPMT_FV_default_actual_definition = NULL;


        SELECT
            @SHPMT_FV_default_column_name =
                SHPMT_default_column_name,

            @SHPMT_FV_default_expected_name =
                SHPMT_default_constraint_name,

            @SHPMT_FV_default_expected_definition =
                SHPMT_default_expected_definition

        FROM @SHPMT_FV_expected_defaults

        WHERE SHPMT_default_id =
                @SHPMT_FV_default_current_id;


        SELECT
            @SHPMT_FV_default_actual_name =
                dc.name,

            @SHPMT_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'shipping.ShipmentMethod')

        AND c.name =
                @SHPMT_FV_default_column_name;


        SET @SHPMT_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @SHPMT_FV_default_expected_definition,
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


        SET @SHPMT_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @SHPMT_FV_default_actual_definition,
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


        IF @SHPMT_FV_default_actual_name IS NULL
        OR @SHPMT_FV_default_actual_name <>
                @SHPMT_FV_default_expected_name
        OR @SHPMT_FV_default_actual_definition IS NULL
        OR @SHPMT_FV_default_actual_normalized <>
                @SHPMT_FV_default_expected_normalized
        BEGIN

            SET @SHPMT_FV_invalid_defaults += 1;

        END;


        SET @SHPMT_FV_default_current_id += 1;

    END;


    IF @SHPMT_FV_invalid_defaults = 0
    BEGIN
        SET @SHPMT_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHPMT_FV_defaults_status = N'FAILED';
        SET @SHPMT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @SHPMT_FV_uq_actual_name        sysname;
    DECLARE @SHPMT_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @SHPMT_FV_uq_actual_disabled    bit;
    DECLARE @SHPMT_FV_uq_actual_data_space  sysname;


    SELECT
        @SHPMT_FV_uq_actual_name =
            kc.name,

        @SHPMT_FV_uq_actual_disabled =
            i.is_disabled,

        @SHPMT_FV_uq_actual_data_space =
            ds.name,

        @SHPMT_FV_uq_actual_columns =
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
            OBJECT_ID(N'shipping.ShipmentMethod')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_SHPMT_name';


    IF @SHPMT_FV_uq_actual_name =
            N'UQ_SHPMT_name'

    AND @SHPMT_FV_uq_actual_columns =
            N'SHPMT_name'

    AND @SHPMT_FV_uq_actual_disabled = 0

    AND @SHPMT_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @SHPMT_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @SHPMT_FV_uniques_status = N'FAILED';
        SET @SHPMT_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @SHPMT_FV_table_status;
    PRINT N'        Primary Key                   : ' + @SHPMT_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @SHPMT_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @SHPMT_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @SHPMT_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @SHPMT_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @SHPMT_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @SHPMT_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @SHPMT_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @SHPMT_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @SHPMT_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @SHPMT_FV_validation_errors = 0
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
                @SHPMT_FV_validation_errors
            );

        PRINT N'';


        ;THROW 51030,
            N'Final validation failed for shipping.ShipmentMethod.',
            1;

    END;


    PRINT N'';