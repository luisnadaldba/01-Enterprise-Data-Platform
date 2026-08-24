    PRINT N'    ● inventory.Inventory';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @INV_FV_validation_errors int = 0;

    DECLARE @INV_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INV_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INV_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INV_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INV_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @INV_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INV_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INV_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INV_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INV_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @INV_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'inventory.Inventory', N'U') IS NOT NULL
    BEGIN
        SET @INV_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INV_FV_table_status = N'FAILED';
        SET @INV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @INV_FV_pk_actual_name     sysname;
    DECLARE @INV_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @INV_FV_pk_data_space      sysname;


    SELECT
        @INV_FV_pk_actual_name = kc.name,
        @INV_FV_pk_data_space = ds.name,

        @INV_FV_pk_actual_columns =
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
            OBJECT_ID(N'inventory.Inventory')

    AND kc.type = N'PK';


    IF @INV_FV_pk_actual_name = N'PK_INV'
    AND @INV_FV_pk_actual_columns = N'INV_id'
    AND @INV_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @INV_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INV_FV_primary_key_status = N'FAILED';
        SET @INV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @INV_FV_expected_column_count int = 6;
    DECLARE @INV_FV_actual_column_count   int;


    SELECT
        @INV_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'inventory.Inventory');


    IF @INV_FV_actual_column_count =
            @INV_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'inventory.Inventory')

        AND c.name = N'INV_id'
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
                OBJECT_ID(N'inventory.Inventory')

        AND ic.name = N'INV_id'
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
                OBJECT_ID(N'inventory.Inventory')

        AND c.name = N'INV_PRDVA_id'
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

        WHERE c.object_id =
                OBJECT_ID(N'inventory.Inventory')

        AND c.name = N'INV_quantity_on_hand'
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

        WHERE c.object_id =
                OBJECT_ID(N'inventory.Inventory')

        AND c.name = N'INV_quantity_reserved'
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

        WHERE c.object_id =
                OBJECT_ID(N'inventory.Inventory')

        AND c.name = N'INV_created_at'
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
                OBJECT_ID(N'inventory.Inventory')

        AND c.name = N'INV_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @INV_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INV_FV_columns_status = N'FAILED';
        SET @INV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @INV_FV_expected_documentation TABLE
    (
        INV_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        INV_doc_object_type           nvarchar(10) NOT NULL,
        INV_doc_column_name           sysname NULL,
        INV_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @INV_FV_doc_current_id        tinyint;
    DECLARE @INV_FV_doc_max_id            tinyint;
    DECLARE @INV_FV_doc_object_type       nvarchar(10);
    DECLARE @INV_FV_doc_column_name       sysname;
    DECLARE @INV_FV_doc_expected_value    nvarchar(4000);
    DECLARE @INV_FV_doc_actual_value      nvarchar(4000);
    DECLARE @INV_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            inventory.Inventory.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @INV_FV_expected_documentation
    (
        INV_doc_object_type,
        INV_doc_column_name,
        INV_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the current usable and reserved inventory quantities for each product variant in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'INV_id',
        N'Primary key of inventory.Inventory.'
    ),
    (
        N'COLUMN',
        N'INV_PRDVA_id',
        N'Foreign key referencing catalog.ProductVariant.'
    ),
    (
        N'COLUMN',
        N'INV_quantity_on_hand',
        N'Stores the current quantity of usable units physically available in inventory for the product variant.'
    ),
    (
        N'COLUMN',
        N'INV_quantity_reserved',
        N'Stores the quantity of usable inventory units already reserved and therefore unavailable for new sales.'
    ),
    (
        N'COLUMN',
        N'INV_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'INV_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @INV_FV_doc_current_id =
            MIN(INV_doc_id),

        @INV_FV_doc_max_id =
            MAX(INV_doc_id)

    FROM @INV_FV_expected_documentation;


    WHILE @INV_FV_doc_current_id <=
        @INV_FV_doc_max_id
    BEGIN

        SET @INV_FV_doc_object_type = NULL;
        SET @INV_FV_doc_column_name = NULL;
        SET @INV_FV_doc_expected_value = NULL;
        SET @INV_FV_doc_actual_value = NULL;


        SELECT
            @INV_FV_doc_object_type =
                INV_doc_object_type,

            @INV_FV_doc_column_name =
                INV_doc_column_name,

            @INV_FV_doc_expected_value =
                INV_doc_expected_description

        FROM @INV_FV_expected_documentation

        WHERE INV_doc_id =
                @INV_FV_doc_current_id;


        IF @INV_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @INV_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'inventory.Inventory')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @INV_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'inventory.Inventory')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @INV_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @INV_FV_doc_actual_value,
            N''
        )
        <>
        @INV_FV_doc_expected_value
        BEGIN

            SET @INV_FV_invalid_documentation += 1;

        END;


        SET @INV_FV_doc_current_id += 1;

    END;


    IF @INV_FV_invalid_documentation = 0
    BEGIN
        SET @INV_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INV_FV_documentation_status = N'FAILED';
        SET @INV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @INV_FV_expected_defaults TABLE
    (
        INV_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        INV_default_column_name          sysname NOT NULL,
        INV_default_constraint_name      sysname NOT NULL,
        INV_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @INV_FV_default_current_id          tinyint;
    DECLARE @INV_FV_default_max_id              tinyint;
    DECLARE @INV_FV_default_column_name         sysname;
    DECLARE @INV_FV_default_expected_name       sysname;
    DECLARE @INV_FV_default_actual_name         sysname;
    DECLARE @INV_FV_default_expected_definition nvarchar(4000);
    DECLARE @INV_FV_default_actual_definition   nvarchar(4000);
    DECLARE @INV_FV_default_expected_normalized nvarchar(4000);
    DECLARE @INV_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @INV_FV_invalid_defaults            int = 0;


    INSERT INTO @INV_FV_expected_defaults
    (
        INV_default_column_name,
        INV_default_constraint_name,
        INV_default_expected_definition
    )
    VALUES
    (
        N'INV_quantity_on_hand',
        N'DF_INV_quantity_on_hand',
        N'0'
    ),
    (
        N'INV_quantity_reserved',
        N'DF_INV_quantity_reserved',
        N'0'
    ),
    (
        N'INV_created_at',
        N'DF_INV_created_at',
        N'sysdatetime'
    ),
    (
        N'INV_updated_at',
        N'DF_INV_updated_at',
        N'sysdatetime'
    );


    SELECT
        @INV_FV_default_current_id =
            MIN(INV_default_id),

        @INV_FV_default_max_id =
            MAX(INV_default_id)

    FROM @INV_FV_expected_defaults;


    WHILE @INV_FV_default_current_id <=
        @INV_FV_default_max_id
    BEGIN

        SET @INV_FV_default_column_name = NULL;
        SET @INV_FV_default_expected_name = NULL;
        SET @INV_FV_default_actual_name = NULL;
        SET @INV_FV_default_expected_definition = NULL;
        SET @INV_FV_default_actual_definition = NULL;


        SELECT
            @INV_FV_default_column_name =
                INV_default_column_name,

            @INV_FV_default_expected_name =
                INV_default_constraint_name,

            @INV_FV_default_expected_definition =
                INV_default_expected_definition

        FROM @INV_FV_expected_defaults

        WHERE INV_default_id =
                @INV_FV_default_current_id;


        SELECT
            @INV_FV_default_actual_name =
                dc.name,

            @INV_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'inventory.Inventory')

        AND c.name =
                @INV_FV_default_column_name;


        SET @INV_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @INV_FV_default_expected_definition,
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


        SET @INV_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @INV_FV_default_actual_definition,
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


        IF @INV_FV_default_actual_name IS NULL
        OR @INV_FV_default_actual_name <>
                @INV_FV_default_expected_name
        OR @INV_FV_default_actual_definition IS NULL
        OR @INV_FV_default_actual_normalized <>
                @INV_FV_default_expected_normalized
        BEGIN

            SET @INV_FV_invalid_defaults += 1;

        END;


        SET @INV_FV_default_current_id += 1;

    END;


    IF @INV_FV_invalid_defaults = 0
    BEGIN
        SET @INV_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INV_FV_defaults_status = N'FAILED';
        SET @INV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        CHECK CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @INV_FV_invalid_checks int = 0;

    DECLARE @INV_FV_check_actual_name          sysname;
    DECLARE @INV_FV_check_actual_definition    nvarchar(4000);
    DECLARE @INV_FV_check_normalized           nvarchar(4000);
    DECLARE @INV_FV_check_is_disabled          bit;
    DECLARE @INV_FV_check_is_not_trusted       bit;


    /*--------------------------------------------------------------------------
        CK_INV_quantity_on_hand
    --------------------------------------------------------------------------*/

    SET @INV_FV_check_actual_name = NULL;
    SET @INV_FV_check_actual_definition = NULL;
    SET @INV_FV_check_normalized = NULL;
    SET @INV_FV_check_is_disabled = NULL;
    SET @INV_FV_check_is_not_trusted = NULL;


    SELECT
        @INV_FV_check_actual_name =
            cc.name,

        @INV_FV_check_actual_definition =
            cc.definition,

        @INV_FV_check_is_disabled =
            cc.is_disabled,

        @INV_FV_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'inventory.Inventory')

    AND cc.name =
            N'CK_INV_quantity_on_hand';


    SET @INV_FV_check_normalized =
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
                            @INV_FV_check_actual_definition,
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


    IF @INV_FV_check_actual_name <>
            N'CK_INV_quantity_on_hand'

    OR @INV_FV_check_normalized NOT LIKE
            N'%inv_quantity_on_hand>=(0)%'

    OR @INV_FV_check_is_disabled <> 0

    OR @INV_FV_check_is_not_trusted <> 0
    BEGIN

        SET @INV_FV_invalid_checks += 1;

    END;


    /*--------------------------------------------------------------------------
        CK_INV_quantity_reserved
    --------------------------------------------------------------------------*/

    SET @INV_FV_check_actual_name = NULL;
    SET @INV_FV_check_actual_definition = NULL;
    SET @INV_FV_check_normalized = NULL;
    SET @INV_FV_check_is_disabled = NULL;
    SET @INV_FV_check_is_not_trusted = NULL;


    SELECT
        @INV_FV_check_actual_name =
            cc.name,

        @INV_FV_check_actual_definition =
            cc.definition,

        @INV_FV_check_is_disabled =
            cc.is_disabled,

        @INV_FV_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'inventory.Inventory')

    AND cc.name =
            N'CK_INV_quantity_reserved';


    SET @INV_FV_check_normalized =
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
                            @INV_FV_check_actual_definition,
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


    IF @INV_FV_check_actual_name <>
            N'CK_INV_quantity_reserved'

    OR @INV_FV_check_normalized NOT LIKE
            N'%inv_quantity_reserved>=(0)%'

    OR @INV_FV_check_normalized NOT LIKE
            N'%inv_quantity_reserved<=inv_quantity_on_hand%'

    OR @INV_FV_check_is_disabled <> 0

    OR @INV_FV_check_is_not_trusted <> 0
    BEGIN

        SET @INV_FV_invalid_checks += 1;

    END;


    IF @INV_FV_invalid_checks = 0
    BEGIN
        SET @INV_FV_checks_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INV_FV_checks_status = N'FAILED';
        SET @INV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @INV_FV_uq_actual_name         sysname;
    DECLARE @INV_FV_uq_actual_columns      nvarchar(4000);
    DECLARE @INV_FV_uq_is_disabled         bit;
    DECLARE @INV_FV_uq_data_space          sysname;


    SELECT
        @INV_FV_uq_actual_name =
            kc.name,

        @INV_FV_uq_is_disabled =
            i.is_disabled,

        @INV_FV_uq_data_space =
            ds.name,

        @INV_FV_uq_actual_columns =
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
            OBJECT_ID(N'inventory.Inventory')

    AND kc.type = N'UQ'

    AND kc.name = N'UQ_INV_PRDVA';


    IF @INV_FV_uq_actual_name = N'UQ_INV_PRDVA'
    AND @INV_FV_uq_actual_columns = N'INV_PRDVA_id'
    AND @INV_FV_uq_is_disabled = 0
    AND @INV_FV_uq_data_space = N'FG_CORE'
    BEGIN

        SET @INV_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @INV_FV_uniques_status = N'FAILED';
        SET @INV_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @INV_FV_invalid_foreign_keys int = 0;


    /*--------------------------------------------------------------------------
        FK_INV_PRDVA
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.Inventory')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND fk.name =
                N'FK_INV_PRDVA'

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
                    N'INV_PRDVA_id'

            AND rc.name =
                    N'PRDVA_id'
        )
    )
    BEGIN

        SET @INV_FV_invalid_foreign_keys += 1;

    END;


    IF @INV_FV_invalid_foreign_keys = 0
    BEGIN

        SET @INV_FV_foreign_keys_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @INV_FV_foreign_keys_status = N'FAILED';
        SET @INV_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @INV_FV_table_status;
    PRINT N'        Primary Key                   : ' + @INV_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @INV_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @INV_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @INV_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @INV_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @INV_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @INV_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @INV_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @INV_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @INV_FV_temporal_integrity_status;
    PRINT N'';

    IF @INV_FV_validation_errors = 0
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
                @INV_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @INV_FV_validation_errors > 0
    BEGIN

        ;THROW 50600,
            N'Final validation failed for inventory.Inventory.',
            1;

    END;