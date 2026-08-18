    PRINT N'    shipping.Shipment';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @SHP_FV_validation_errors int = 0;

    DECLARE @SHP_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHP_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHP_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHP_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHP_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHP_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHP_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHP_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHP_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHP_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SHP_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'shipping.Shipment', N'U') IS NOT NULL
    BEGIN
        SET @SHP_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHP_FV_table_status = N'FAILED';
        SET @SHP_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @SHP_FV_pk_actual_name     sysname;
    DECLARE @SHP_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @SHP_FV_pk_data_space      sysname;


    SELECT
        @SHP_FV_pk_actual_name = kc.name,
        @SHP_FV_pk_data_space = ds.name,

        @SHP_FV_pk_actual_columns =
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), c.name), N'|')
                WITHIN GROUP (ORDER BY ic.key_ordinal)

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
            OBJECT_ID(N'shipping.Shipment')

    AND kc.type = N'PK';


    IF @SHP_FV_pk_actual_name = N'PK_SHP'
    AND @SHP_FV_pk_actual_columns = N'SHP_id'
    AND @SHP_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @SHP_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHP_FV_primary_key_status = N'FAILED';
        SET @SHP_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @SHP_FV_expected_column_count int = 13;
    DECLARE @SHP_FV_actual_column_count   int;


    SELECT
        @SHP_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'shipping.Shipment');


    IF @SHP_FV_actual_column_count = @SHP_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_id'
        AND TYPE_NAME(c.user_type_id) = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'shipping.Shipment')
        AND ic.name = N'SHP_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_TRN_id'
        AND TYPE_NAME(c.user_type_id) = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_transaction_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_CSTAD_id'
        AND TYPE_NAME(c.user_type_id) = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_SHPMT_id'
        AND TYPE_NAME(c.user_type_id) = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_SHPST_id'
        AND TYPE_NAME(c.user_type_id) = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_shipping_amount'
        AND TYPE_NAME(c.user_type_id) = N'decimal'
        AND c.precision = 19
        AND c.scale = 2
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_estimated_delivery_date'
        AND TYPE_NAME(c.user_type_id) = N'date'
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_tracking_code'
        AND TYPE_NAME(c.user_type_id) = N'varchar'
        AND c.max_length = 30
        AND c.is_nullable = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_posted_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_delivered_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_created_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_updated_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @SHP_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHP_FV_columns_status = N'FAILED';
        SET @SHP_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @SHP_FV_expected_documentation TABLE
    (
        SHP_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        SHP_doc_object_type           nvarchar(10) NOT NULL,
        SHP_doc_column_name           sysname NULL,
        SHP_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @SHP_FV_doc_current_id        tinyint;
    DECLARE @SHP_FV_doc_max_id            tinyint;
    DECLARE @SHP_FV_doc_object_type       nvarchar(10);
    DECLARE @SHP_FV_doc_column_name       sysname;
    DECLARE @SHP_FV_doc_expected_value    nvarchar(4000);
    DECLARE @SHP_FV_doc_actual_value      nvarchar(4000);
    DECLARE @SHP_FV_invalid_documentation int = 0;


    INSERT INTO @SHP_FV_expected_documentation
    (
        SHP_doc_object_type,
        SHP_doc_column_name,
        SHP_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Records the delivery process associated with Atlas Commerce online sales transactions, including destination, shipment method, status, freight amount, delivery estimate, tracking information and relevant business-event timestamps.'
    ),
    (
        N'COLUMN',
        N'SHP_id',
        N'Primary key of shipping.Shipment.'
    ),
    (
        N'COLUMN',
        N'SHP_TRN_id',
        N'Foreign key of sales.Transaction.'
    ),
    (
        N'COLUMN',
        N'SHP_transaction_at',
        N'Stores the originating sales transaction timestamp and participates with SHP_TRN_id in the composite foreign key to sales.Transaction.'
    ),
    (
        N'COLUMN',
        N'SHP_CSTAD_id',
        N'Foreign key of customer.CustomerAddress identifying the customer address selected for this shipment.'
    ),
    (
        N'COLUMN',
        N'SHP_SHPMT_id',
        N'Foreign key of shipping.ShipmentMethod identifying the shipment method selected for this delivery.'
    ),
    (
        N'COLUMN',
        N'SHP_SHPST_id',
        N'Foreign key of shipping.ShipmentStatus identifying the current operational state of this shipment.'
    ),
    (
        N'COLUMN',
        N'SHP_shipping_amount',
        N'Stores the shipping amount charged to the customer for this shipment.'
    ),
    (
        N'COLUMN',
        N'SHP_estimated_delivery_date',
        N'Stores the estimated delivery date presented to the customer when the shipment method was selected.'
    ),
    (
        N'COLUMN',
        N'SHP_tracking_code',
        N'Stores the postal tracking code assigned to the shipment when available.'
    ),
    (
        N'COLUMN',
        N'SHP_posted_at',
        N'Records the date and time when the shipment was handed over to the postal service for delivery.'
    ),
    (
        N'COLUMN',
        N'SHP_delivered_at',
        N'Records the date and time when the shipment was successfully delivered to the recipient.'
    ),
    (
        N'COLUMN',
        N'SHP_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'SHP_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @SHP_FV_doc_current_id = MIN(SHP_doc_id),
        @SHP_FV_doc_max_id = MAX(SHP_doc_id)

    FROM @SHP_FV_expected_documentation;


    WHILE @SHP_FV_doc_current_id <= @SHP_FV_doc_max_id
    BEGIN

        SET @SHP_FV_doc_object_type = NULL;
        SET @SHP_FV_doc_column_name = NULL;
        SET @SHP_FV_doc_expected_value = NULL;
        SET @SHP_FV_doc_actual_value = NULL;


        SELECT
            @SHP_FV_doc_object_type = SHP_doc_object_type,
            @SHP_FV_doc_column_name = SHP_doc_column_name,
            @SHP_FV_doc_expected_value = SHP_doc_expected_description

        FROM @SHP_FV_expected_documentation

        WHERE SHP_doc_id = @SHP_FV_doc_current_id;


        IF @SHP_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @SHP_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'shipping.Shipment')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @SHP_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'shipping.Shipment')
            AND ep.name = N'MS_Description'
            AND c.name = @SHP_FV_doc_column_name;

        END;


        IF ISNULL(@SHP_FV_doc_actual_value, N'') <>
            @SHP_FV_doc_expected_value
        BEGIN
            SET @SHP_FV_invalid_documentation += 1;
        END;


        SET @SHP_FV_doc_current_id += 1;

    END;


    IF @SHP_FV_invalid_documentation = 0
    BEGIN
        SET @SHP_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHP_FV_documentation_status = N'FAILED';
        SET @SHP_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'shipping'
        AND PFX_table_name = N'Shipment'
        AND PFX_prefix = N'SHP'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @SHP_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHP_FV_seed_data_status = N'FAILED';
        SET @SHP_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @SHP_FV_expected_defaults TABLE
    (
        SHP_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        SHP_default_column_name          sysname NOT NULL,
        SHP_default_constraint_name      sysname NOT NULL,
        SHP_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @SHP_FV_default_current_id          tinyint;
    DECLARE @SHP_FV_default_max_id              tinyint;
    DECLARE @SHP_FV_default_column_name         sysname;
    DECLARE @SHP_FV_default_expected_name       sysname;
    DECLARE @SHP_FV_default_actual_name         sysname;
    DECLARE @SHP_FV_default_expected_definition nvarchar(4000);
    DECLARE @SHP_FV_default_actual_definition   nvarchar(4000);
    DECLARE @SHP_FV_default_expected_normalized nvarchar(4000);
    DECLARE @SHP_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @SHP_FV_invalid_defaults            int = 0;


    INSERT INTO @SHP_FV_expected_defaults
    (
        SHP_default_column_name,
        SHP_default_constraint_name,
        SHP_default_expected_definition
    )
    VALUES
    (
        N'SHP_created_at',
        N'DF_SHP_created_at',
        N'sysdatetime'
    ),
    (
        N'SHP_updated_at',
        N'DF_SHP_updated_at',
        N'sysdatetime'
    );


    SELECT
        @SHP_FV_default_current_id = MIN(SHP_default_id),
        @SHP_FV_default_max_id = MAX(SHP_default_id)

    FROM @SHP_FV_expected_defaults;


    WHILE @SHP_FV_default_current_id <=
        @SHP_FV_default_max_id
    BEGIN

        SET @SHP_FV_default_column_name = NULL;
        SET @SHP_FV_default_expected_name = NULL;
        SET @SHP_FV_default_actual_name = NULL;
        SET @SHP_FV_default_expected_definition = NULL;
        SET @SHP_FV_default_actual_definition = NULL;


        SELECT
            @SHP_FV_default_column_name =
                SHP_default_column_name,

            @SHP_FV_default_expected_name =
                SHP_default_constraint_name,

            @SHP_FV_default_expected_definition =
                SHP_default_expected_definition

        FROM @SHP_FV_expected_defaults

        WHERE SHP_default_id =
                @SHP_FV_default_current_id;


        SELECT
            @SHP_FV_default_actual_name = dc.name,
            @SHP_FV_default_actual_definition = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND c.name =
                @SHP_FV_default_column_name;


        SET @SHP_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @SHP_FV_default_expected_definition,
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


        SET @SHP_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @SHP_FV_default_actual_definition,
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


        IF @SHP_FV_default_actual_name IS NULL
        OR @SHP_FV_default_actual_name <>
                @SHP_FV_default_expected_name
        OR @SHP_FV_default_actual_definition IS NULL
        OR @SHP_FV_default_actual_normalized <>
                @SHP_FV_default_expected_normalized
        BEGIN
            SET @SHP_FV_invalid_defaults += 1;
        END;


        SET @SHP_FV_default_current_id += 1;

    END;


    IF @SHP_FV_invalid_defaults = 0
    BEGIN
        SET @SHP_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHP_FV_defaults_status = N'FAILED';
        SET @SHP_FV_validation_errors += 1;
    END;


    /*==========================================================================
        CHECK CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @SHP_FV_invalid_checks int = 0;
    DECLARE @SHP_FV_check_actual_name        sysname;
    DECLARE @SHP_FV_check_actual_definition  nvarchar(4000);
    DECLARE @SHP_FV_check_normalized         nvarchar(4000);
    DECLARE @SHP_FV_check_is_disabled        bit;
    DECLARE @SHP_FV_check_is_not_trusted     bit;


    /*--------------------------------------------------------------------------
        CK_SHP_shipping_amount
    --------------------------------------------------------------------------*/

    SELECT
        @SHP_FV_check_actual_name = cc.name,
        @SHP_FV_check_actual_definition = cc.definition,
        @SHP_FV_check_is_disabled = cc.is_disabled,
        @SHP_FV_check_is_not_trusted = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'shipping.Shipment')

    AND cc.name =
            N'CK_SHP_shipping_amount';


    SET @SHP_FV_check_normalized =
        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(
            @SHP_FV_check_actual_definition,
            N'[', N''), N']', N''), N' ', N''), NCHAR(9), N''));


    IF @SHP_FV_check_actual_name <> N'CK_SHP_shipping_amount'
    OR @SHP_FV_check_normalized NOT LIKE N'%shp_shipping_amount>=(0)%'
    OR @SHP_FV_check_is_disabled <> 0
    OR @SHP_FV_check_is_not_trusted <> 0
    BEGIN
        SET @SHP_FV_invalid_checks += 1;
    END;


    /*--------------------------------------------------------------------------
        CK_SHP_estimated_delivery_date
    --------------------------------------------------------------------------*/

    SET @SHP_FV_check_actual_name = NULL;
    SET @SHP_FV_check_actual_definition = NULL;
    SET @SHP_FV_check_normalized = NULL;
    SET @SHP_FV_check_is_disabled = NULL;
    SET @SHP_FV_check_is_not_trusted = NULL;


    SELECT
        @SHP_FV_check_actual_name = cc.name,
        @SHP_FV_check_actual_definition = cc.definition,
        @SHP_FV_check_is_disabled = cc.is_disabled,
        @SHP_FV_check_is_not_trusted = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'shipping.Shipment')

    AND cc.name =
            N'CK_SHP_estimated_delivery_date';


    SET @SHP_FV_check_normalized =
        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(
            @SHP_FV_check_actual_definition,
            N'[', N''), N']', N''), N' ', N''), NCHAR(9), N''));


    IF @SHP_FV_check_actual_name <>
            N'CK_SHP_estimated_delivery_date'

    OR @SHP_FV_check_normalized NOT LIKE
            N'%shp_estimated_delivery_date>=convert(date,shp_transaction_at)%'

    OR @SHP_FV_check_is_disabled <> 0
    OR @SHP_FV_check_is_not_trusted <> 0
    BEGIN
        SET @SHP_FV_invalid_checks += 1;
    END;


    /*--------------------------------------------------------------------------
        CK_SHP_posted_at
    --------------------------------------------------------------------------*/

    SET @SHP_FV_check_actual_name = NULL;
    SET @SHP_FV_check_actual_definition = NULL;
    SET @SHP_FV_check_normalized = NULL;
    SET @SHP_FV_check_is_disabled = NULL;
    SET @SHP_FV_check_is_not_trusted = NULL;


    SELECT
        @SHP_FV_check_actual_name = cc.name,
        @SHP_FV_check_actual_definition = cc.definition,
        @SHP_FV_check_is_disabled = cc.is_disabled,
        @SHP_FV_check_is_not_trusted = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'shipping.Shipment')

    AND cc.name =
            N'CK_SHP_posted_at';


    SET @SHP_FV_check_normalized =
        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(
            @SHP_FV_check_actual_definition,
            N'[', N''), N']', N''), N' ', N''), NCHAR(9), N''));


    IF @SHP_FV_check_actual_name <> N'CK_SHP_posted_at'
    OR @SHP_FV_check_normalized NOT LIKE N'%shp_posted_atisnull%'
    OR @SHP_FV_check_normalized NOT LIKE N'%shp_posted_at>=shp_transaction_at%'
    OR @SHP_FV_check_is_disabled <> 0
    OR @SHP_FV_check_is_not_trusted <> 0
    BEGIN
        SET @SHP_FV_invalid_checks += 1;
    END;


    /*--------------------------------------------------------------------------
        CK_SHP_delivered_at
    --------------------------------------------------------------------------*/

    SET @SHP_FV_check_actual_name = NULL;
    SET @SHP_FV_check_actual_definition = NULL;
    SET @SHP_FV_check_normalized = NULL;
    SET @SHP_FV_check_is_disabled = NULL;
    SET @SHP_FV_check_is_not_trusted = NULL;


    SELECT
        @SHP_FV_check_actual_name = cc.name,
        @SHP_FV_check_actual_definition = cc.definition,
        @SHP_FV_check_is_disabled = cc.is_disabled,
        @SHP_FV_check_is_not_trusted = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'shipping.Shipment')

    AND cc.name =
            N'CK_SHP_delivered_at';


    SET @SHP_FV_check_normalized =
        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(
            @SHP_FV_check_actual_definition,
            N'[', N''), N']', N''), N' ', N''), NCHAR(9), N''));


    IF @SHP_FV_check_actual_name <> N'CK_SHP_delivered_at'
    OR @SHP_FV_check_normalized NOT LIKE N'%shp_delivered_atisnull%'
    OR @SHP_FV_check_normalized NOT LIKE N'%shp_posted_atisnotnull%'
    OR @SHP_FV_check_normalized NOT LIKE N'%shp_delivered_at>=shp_posted_at%'
    OR @SHP_FV_check_is_disabled <> 0
    OR @SHP_FV_check_is_not_trusted <> 0
    BEGIN
        SET @SHP_FV_invalid_checks += 1;
    END;


    IF @SHP_FV_invalid_checks = 0
    BEGIN
        SET @SHP_FV_checks_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHP_FV_checks_status = N'FAILED';
        SET @SHP_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND kc.name = N'UQ_SHP_TRN'
        AND kc.type = N'UQ'
        AND i.type = 2
        AND i.is_unique = 1
        AND i.is_disabled = 0
        AND ds.name = N'FG_CORE'

        AND
        (
            SELECT COUNT(*)
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ) = 2

        AND EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
                AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal = 1
            AND c.name = N'SHP_TRN_id'
        )

        AND EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
                AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal = 2
            AND c.name = N'SHP_transaction_at'
        )
    )
    BEGIN
        SET @SHP_FV_uniques_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHP_FV_uniques_status = N'FAILED';
        SET @SHP_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @SHP_FV_invalid_foreign_keys int = 0;


    /*--------------------------------------------------------------------------
        FK_SHP_TRN
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND fk.name = N'FK_SHP_TRN'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0

        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id = fk.object_id
        ) = 2

        AND EXISTS
        (
            SELECT 1
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
            AND fkc.constraint_column_id = 1
            AND pc.name = N'SHP_TRN_id'
            AND rc.name = N'TRN_id'
        )

        AND EXISTS
        (
            SELECT 1
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
            AND fkc.constraint_column_id = 2
            AND pc.name = N'SHP_transaction_at'
            AND rc.name = N'TRN_transaction_at'
        )
    )
    BEGIN
        SET @SHP_FV_invalid_foreign_keys += 1;
    END;


    /*--------------------------------------------------------------------------
        FK_SHP_CSTAD
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.CustomerAddress')

        AND fk.name = N'FK_SHP_CSTAD'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0

        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id = fk.object_id
        ) = 1

        AND EXISTS
        (
            SELECT 1
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
            AND pc.name = N'SHP_CSTAD_id'
            AND rc.name = N'CSTAD_id'
        )
    )
    BEGIN
        SET @SHP_FV_invalid_foreign_keys += 1;
    END;


    /*--------------------------------------------------------------------------
        FK_SHP_SHPMT
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'shipping.ShipmentMethod')

        AND fk.name = N'FK_SHP_SHPMT'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0

        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id = fk.object_id
        ) = 1

        AND EXISTS
        (
            SELECT 1
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
            AND pc.name = N'SHP_SHPMT_id'
            AND rc.name = N'SHPMT_id'
        )
    )
    BEGIN
        SET @SHP_FV_invalid_foreign_keys += 1;
    END;


    /*--------------------------------------------------------------------------
        FK_SHP_SHPST
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'shipping.ShipmentStatus')

        AND fk.name = N'FK_SHP_SHPST'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0

        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id = fk.object_id
        ) = 1

        AND EXISTS
        (
            SELECT 1
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
            AND pc.name = N'SHP_SHPST_id'
            AND rc.name = N'SHPST_id'
        )
    )
    BEGIN
        SET @SHP_FV_invalid_foreign_keys += 1;
    END;


    IF @SHP_FV_invalid_foreign_keys = 0
    BEGIN
        SET @SHP_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHP_FV_foreign_keys_status = N'FAILED';
        SET @SHP_FV_validation_errors += 1;
    END;


    /*==========================================================================
        ADDITIONAL INDEX VALIDATION
    ==========================================================================*/

    DECLARE @SHP_FV_invalid_indexes int = 0;


    /*--------------------------------------------------------------------------
        UX_SHP_tracking_code
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND i.name = N'UX_SHP_tracking_code'
        AND i.type = 2
        AND i.is_unique = 1
        AND i.is_disabled = 0
        AND i.is_hypothetical = 0
        AND i.is_unique_constraint = 0
        AND i.is_primary_key = 0
        AND i.has_filter = 1
        AND ds.name = N'FG_CORE'

        AND LOWER
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
                                    COALESCE(i.filter_definition, N''),
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
        ) = N'shp_tracking_codeisnotnull'

        AND
        (
            SELECT COUNT(*)
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ) = 1

        AND NOT EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
        )

        AND EXISTS
        (
            SELECT 1

            FROM sys.index_columns AS ic

            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
                AND c.column_id = ic.column_id

            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal = 1
            AND ic.is_descending_key = 0
            AND c.name = N'SHP_tracking_code'
        )
    )
    BEGIN
        SET @SHP_FV_invalid_indexes += 1;
    END;


    /*--------------------------------------------------------------------------
        IX_SHP_updated_at
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND i.name = N'IX_SHP_updated_at'
        AND i.type = 2
        AND i.is_unique = 0
        AND i.is_disabled = 0
        AND i.is_hypothetical = 0
        AND i.is_unique_constraint = 0
        AND i.is_primary_key = 0
        AND i.has_filter = 0
        AND ds.name = N'FG_CORE'

        AND
        (
            SELECT COUNT(*)
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ) = 1

        AND NOT EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
        )

        AND EXISTS
        (
            SELECT 1

            FROM sys.index_columns AS ic

            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
                AND c.column_id = ic.column_id

            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal = 1
            AND ic.is_descending_key = 0
            AND c.name = N'SHP_updated_at'
        )
    )
    BEGIN
        SET @SHP_FV_invalid_indexes += 1;
    END;


    IF @SHP_FV_invalid_indexes = 0
    BEGIN
        SET @SHP_FV_indexes_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @SHP_FV_indexes_status = N'FAILED';
        SET @SHP_FV_validation_errors += 1;
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

    PRINT N'        Table                         : ' + @SHP_FV_table_status;
    PRINT N'        Primary Key                   : ' + @SHP_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @SHP_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @SHP_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @SHP_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @SHP_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @SHP_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @SHP_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @SHP_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @SHP_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @SHP_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @SHP_FV_validation_errors = 0
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
                @SHP_FV_validation_errors
            );

        PRINT N'';


        ;THROW 51260,
            N'Final validation failed for shipping.Shipment.',
            1;

    END;


    PRINT N'';