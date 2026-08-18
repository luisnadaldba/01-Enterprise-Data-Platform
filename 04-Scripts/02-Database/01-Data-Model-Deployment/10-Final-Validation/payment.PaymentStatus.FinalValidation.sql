    PRINT N'    payment.PaymentStatus';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PAYST_FV_validation_errors int = 0;

    DECLARE @PAYST_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYST_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYST_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYST_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYST_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYST_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYST_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PAYST_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYST_FV_foreign_keys_status        nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PAYST_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PAYST_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'payment.PaymentStatus', N'U') IS NOT NULL
    BEGIN
        SET @PAYST_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYST_FV_table_status = N'FAILED';
        SET @PAYST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PAYST_FV_pk_actual_name     sysname;
    DECLARE @PAYST_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PAYST_FV_pk_data_space      sysname;


    SELECT
        @PAYST_FV_pk_actual_name = kc.name,
        @PAYST_FV_pk_data_space = ds.name,

        @PAYST_FV_pk_actual_columns =
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
            OBJECT_ID(N'payment.PaymentStatus')

    AND kc.type = N'PK';


    IF @PAYST_FV_pk_actual_name = N'PK_PAYST'
    AND @PAYST_FV_pk_actual_columns = N'PAYST_id'
    AND @PAYST_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @PAYST_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYST_FV_primary_key_status = N'FAILED';
        SET @PAYST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PAYST_FV_expected_column_count int = 4;
    DECLARE @PAYST_FV_actual_column_count   int;


    SELECT
        @PAYST_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'payment.PaymentStatus');


    IF @PAYST_FV_actual_column_count =
            @PAYST_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND c.name = N'PAYST_id'
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
                OBJECT_ID(N'payment.PaymentStatus')

        AND ic.name = N'PAYST_id'
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
                OBJECT_ID(N'payment.PaymentStatus')

        AND c.name = N'PAYST_name'
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
                OBJECT_ID(N'payment.PaymentStatus')

        AND c.name = N'PAYST_created_at'
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
                OBJECT_ID(N'payment.PaymentStatus')

        AND c.name = N'PAYST_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @PAYST_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYST_FV_columns_status = N'FAILED';
        SET @PAYST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PAYST_FV_expected_documentation TABLE
    (
        PAYST_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PAYST_doc_object_type           nvarchar(10) NOT NULL,
        PAYST_doc_column_name           sysname NULL,
        PAYST_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @PAYST_FV_doc_current_id        tinyint;
    DECLARE @PAYST_FV_doc_max_id            tinyint;
    DECLARE @PAYST_FV_doc_object_type       nvarchar(10);
    DECLARE @PAYST_FV_doc_column_name       sysname;
    DECLARE @PAYST_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PAYST_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PAYST_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            payment.PaymentStatus.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @PAYST_FV_expected_documentation
    (
        PAYST_doc_object_type,
        PAYST_doc_column_name,
        PAYST_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Defines the controlled payment statuses used to represent the lifecycle of payment attempts in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'PAYST_id',
        N'Primary key of payment.PaymentStatus.'
    ),
    (
        N'COLUMN',
        N'PAYST_name',
        N'Stores the controlled name of the payment status used by Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'PAYST_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'PAYST_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @PAYST_FV_doc_current_id =
            MIN(PAYST_doc_id),

        @PAYST_FV_doc_max_id =
            MAX(PAYST_doc_id)

    FROM @PAYST_FV_expected_documentation;


    WHILE @PAYST_FV_doc_current_id <=
        @PAYST_FV_doc_max_id
    BEGIN

        SET @PAYST_FV_doc_object_type = NULL;
        SET @PAYST_FV_doc_column_name = NULL;
        SET @PAYST_FV_doc_expected_value = NULL;
        SET @PAYST_FV_doc_actual_value = NULL;


        SELECT
            @PAYST_FV_doc_object_type =
                PAYST_doc_object_type,

            @PAYST_FV_doc_column_name =
                PAYST_doc_column_name,

            @PAYST_FV_doc_expected_value =
                PAYST_doc_expected_description

        FROM @PAYST_FV_expected_documentation

        WHERE PAYST_doc_id =
                @PAYST_FV_doc_current_id;


        IF @PAYST_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @PAYST_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'payment.PaymentStatus')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @PAYST_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'payment.PaymentStatus')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @PAYST_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @PAYST_FV_doc_actual_value,
            N''
        )
        <>
        @PAYST_FV_doc_expected_value
        BEGIN

            SET @PAYST_FV_invalid_documentation += 1;

        END;


        SET @PAYST_FV_doc_current_id += 1;

    END;


    IF @PAYST_FV_invalid_documentation = 0
    BEGIN
        SET @PAYST_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYST_FV_documentation_status = N'FAILED';
        SET @PAYST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'payment'
        AND PFX_table_name = N'PaymentStatus'
        AND PFX_prefix = N'PAYST'
        AND PFX_is_active = 1
    )
    AND
    (
        SELECT COUNT(*)
        FROM payment.PaymentStatus
        WHERE PAYST_name IN
        (
            N'PENDING',
            N'APPROVED',
            N'DECLINED',
            N'CANCELLED',
            N'PARTIALLY_REFUNDED',
            N'REFUNDED'
        )
    ) = 6
    AND NOT EXISTS
    (
        SELECT V.PAYST_name
        FROM
        (
            VALUES
                (N'PENDING'),
                (N'APPROVED'),
                (N'DECLINED'),
                (N'CANCELLED'),
                (N'PARTIALLY_REFUNDED'),
                (N'REFUNDED')
        ) AS V(PAYST_name)
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM payment.PaymentStatus AS PS
            WHERE PS.PAYST_name = V.PAYST_name
        )
    )
    BEGIN
        SET @PAYST_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYST_FV_seed_data_status = N'FAILED';
        SET @PAYST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PAYST_FV_expected_defaults TABLE
    (
        PAYST_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        PAYST_default_column_name          sysname NOT NULL,
        PAYST_default_constraint_name      sysname NOT NULL,
        PAYST_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @PAYST_FV_default_current_id          tinyint;
    DECLARE @PAYST_FV_default_max_id              tinyint;
    DECLARE @PAYST_FV_default_column_name         sysname;
    DECLARE @PAYST_FV_default_expected_name       sysname;
    DECLARE @PAYST_FV_default_actual_name         sysname;
    DECLARE @PAYST_FV_default_expected_definition nvarchar(4000);
    DECLARE @PAYST_FV_default_actual_definition   nvarchar(4000);
    DECLARE @PAYST_FV_default_expected_normalized nvarchar(4000);
    DECLARE @PAYST_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @PAYST_FV_invalid_defaults            int = 0;


    INSERT INTO @PAYST_FV_expected_defaults
    (
        PAYST_default_column_name,
        PAYST_default_constraint_name,
        PAYST_default_expected_definition
    )
    VALUES
    (
        N'PAYST_created_at',
        N'DF_PAYST_created_at',
        N'sysdatetime'
    ),
    (
        N'PAYST_updated_at',
        N'DF_PAYST_updated_at',
        N'sysdatetime'
    );


    SELECT
        @PAYST_FV_default_current_id =
            MIN(PAYST_default_id),

        @PAYST_FV_default_max_id =
            MAX(PAYST_default_id)

    FROM @PAYST_FV_expected_defaults;


    WHILE @PAYST_FV_default_current_id <=
        @PAYST_FV_default_max_id
    BEGIN

        SET @PAYST_FV_default_column_name = NULL;
        SET @PAYST_FV_default_expected_name = NULL;
        SET @PAYST_FV_default_actual_name = NULL;
        SET @PAYST_FV_default_expected_definition = NULL;
        SET @PAYST_FV_default_actual_definition = NULL;


        SELECT
            @PAYST_FV_default_column_name =
                PAYST_default_column_name,

            @PAYST_FV_default_expected_name =
                PAYST_default_constraint_name,

            @PAYST_FV_default_expected_definition =
                PAYST_default_expected_definition

        FROM @PAYST_FV_expected_defaults

        WHERE PAYST_default_id =
                @PAYST_FV_default_current_id;


        SELECT
            @PAYST_FV_default_actual_name =
                dc.name,

            @PAYST_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND c.name =
                @PAYST_FV_default_column_name;


        SET @PAYST_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @PAYST_FV_default_expected_definition,
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


        SET @PAYST_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @PAYST_FV_default_actual_definition,
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


        IF @PAYST_FV_default_actual_name IS NULL
        OR @PAYST_FV_default_actual_name <>
                @PAYST_FV_default_expected_name
        OR @PAYST_FV_default_actual_definition IS NULL
        OR @PAYST_FV_default_actual_normalized <>
                @PAYST_FV_default_expected_normalized
        BEGIN

            SET @PAYST_FV_invalid_defaults += 1;

        END;


        SET @PAYST_FV_default_current_id += 1;

    END;


    IF @PAYST_FV_invalid_defaults = 0
    BEGIN
        SET @PAYST_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYST_FV_defaults_status = N'FAILED';
        SET @PAYST_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PAYST_FV_uq_actual_name        sysname;
    DECLARE @PAYST_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @PAYST_FV_uq_actual_disabled    bit;
    DECLARE @PAYST_FV_uq_actual_data_space  sysname;


    SELECT
        @PAYST_FV_uq_actual_name =
            kc.name,

        @PAYST_FV_uq_actual_disabled =
            i.is_disabled,

        @PAYST_FV_uq_actual_data_space =
            ds.name,

        @PAYST_FV_uq_actual_columns =
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
            OBJECT_ID(N'payment.PaymentStatus')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_PAYST_name';


    IF @PAYST_FV_uq_actual_name =
            N'UQ_PAYST_name'

    AND @PAYST_FV_uq_actual_columns =
            N'PAYST_name'

    AND @PAYST_FV_uq_actual_disabled = 0

    AND @PAYST_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @PAYST_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @PAYST_FV_uniques_status = N'FAILED';
        SET @PAYST_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @PAYST_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PAYST_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PAYST_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PAYST_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PAYST_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PAYST_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PAYST_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PAYST_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PAYST_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PAYST_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @PAYST_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @PAYST_FV_validation_errors = 0
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
                @PAYST_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50330,
            N'Final validation failed for payment.PaymentStatus.',
            1;

    END;


    PRINT N'';