    PRINT N'    ● catalog.ProductVariant';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PRDVA_FV_validation_errors int = 0;

    DECLARE @PRDVA_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVA_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVA_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVA_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVA_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVA_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVA_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDVA_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVA_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVA_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVA_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NOT NULL
    BEGIN
        SET @PRDVA_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDVA_FV_table_status = N'FAILED';
        SET @PRDVA_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PRDVA_FV_pk_actual_name     sysname;
    DECLARE @PRDVA_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PRDVA_FV_pk_data_space      sysname;


    SELECT
        @PRDVA_FV_pk_actual_name = kc.name,
        @PRDVA_FV_pk_data_space = ds.name,

        @PRDVA_FV_pk_actual_columns =
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
            OBJECT_ID(N'catalog.ProductVariant')

    AND kc.type = N'PK';


    IF @PRDVA_FV_pk_actual_name = N'PK_PRDVA'
    AND @PRDVA_FV_pk_actual_columns = N'PRDVA_id'
    AND @PRDVA_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @PRDVA_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDVA_FV_primary_key_status = N'FAILED';
        SET @PRDVA_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PRDVA_FV_expected_column_count int = 7;
    DECLARE @PRDVA_FV_actual_column_count   int;


    SELECT
        @PRDVA_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'catalog.ProductVariant');


    IF @PRDVA_FV_actual_column_count =
            @PRDVA_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND ic.name = N'PRDVA_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_PRD_id'
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
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_sku'
        AND t.name = N'nvarchar'
        AND c.max_length = 200
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_barcode'
        AND t.name = N'nvarchar'
        AND c.max_length = 100
        AND c.is_nullable = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_is_active'
        AND t.name = N'bit'
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_created_at'
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
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @PRDVA_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDVA_FV_columns_status = N'FAILED';
        SET @PRDVA_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PRDVA_FV_expected_documentation TABLE
    (
        PRDVA_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PRDVA_doc_object_type           nvarchar(10) NOT NULL,
        PRDVA_doc_column_name           sysname NULL,
        PRDVA_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @PRDVA_FV_doc_current_id        tinyint;
    DECLARE @PRDVA_FV_doc_max_id            tinyint;
    DECLARE @PRDVA_FV_doc_object_type       nvarchar(10);
    DECLARE @PRDVA_FV_doc_column_name       sysname;
    DECLARE @PRDVA_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PRDVA_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PRDVA_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            catalog.ProductVariant.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @PRDVA_FV_expected_documentation
    (
        PRDVA_doc_object_type,
        PRDVA_doc_column_name,
        PRDVA_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the sellable variants associated with products in the Atlas Commerce catalog.'
    ),
    (
        N'COLUMN',
        N'PRDVA_id',
        N'Primary key of catalog.ProductVariant.'
    ),
    (
        N'COLUMN',
        N'PRDVA_PRD_id',
        N'Foreign key referencing catalog.Product.'
    ),
    (
        N'COLUMN',
        N'PRDVA_sku',
        N'Stores the stock keeping unit (SKU) used to uniquely identify the sellable product variant.'
    ),
    (
        N'COLUMN',
        N'PRDVA_barcode',
        N'Stores the optional barcode associated with the sellable product variant.'
    ),
    (
        N'COLUMN',
        N'PRDVA_is_active',
        N'Indicates whether the product variant is currently available for use in catalog operations while preserving inactive variants for historical integrity.'
    ),
    (
        N'COLUMN',
        N'PRDVA_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'PRDVA_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @PRDVA_FV_doc_current_id = MIN(PRDVA_doc_id),
        @PRDVA_FV_doc_max_id = MAX(PRDVA_doc_id)
    FROM @PRDVA_FV_expected_documentation;


    WHILE @PRDVA_FV_doc_current_id <= @PRDVA_FV_doc_max_id
    BEGIN

        SET @PRDVA_FV_doc_object_type = NULL;
        SET @PRDVA_FV_doc_column_name = NULL;
        SET @PRDVA_FV_doc_expected_value = NULL;
        SET @PRDVA_FV_doc_actual_value = NULL;


        SELECT
            @PRDVA_FV_doc_object_type = PRDVA_doc_object_type,
            @PRDVA_FV_doc_column_name = PRDVA_doc_column_name,
            @PRDVA_FV_doc_expected_value = PRDVA_doc_expected_description
        FROM @PRDVA_FV_expected_documentation
        WHERE PRDVA_doc_id = @PRDVA_FV_doc_current_id;


        IF @PRDVA_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @PRDVA_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.ProductVariant')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @PRDVA_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id
            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.ProductVariant')
            AND ep.name = N'MS_Description'
            AND c.name = @PRDVA_FV_doc_column_name;

        END;


        IF ISNULL(@PRDVA_FV_doc_actual_value, N'')
            <> @PRDVA_FV_doc_expected_value
        BEGIN
            SET @PRDVA_FV_invalid_documentation += 1;
        END;


        SET @PRDVA_FV_doc_current_id += 1;

    END;


    IF @PRDVA_FV_invalid_documentation = 0
    BEGIN
        SET @PRDVA_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDVA_FV_documentation_status = N'FAILED';
        SET @PRDVA_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'ProductVariant'
        AND PFX_prefix = N'PRDVA'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @PRDVA_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDVA_FV_seed_data_status = N'FAILED';
        SET @PRDVA_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PRDVA_FV_expected_defaults TABLE
    (
        PRDVA_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        PRDVA_default_column_name          sysname NOT NULL,
        PRDVA_default_constraint_name      sysname NOT NULL,
        PRDVA_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @PRDVA_FV_default_current_id          tinyint;
    DECLARE @PRDVA_FV_default_max_id              tinyint;
    DECLARE @PRDVA_FV_default_column_name         sysname;
    DECLARE @PRDVA_FV_default_expected_name       sysname;
    DECLARE @PRDVA_FV_default_actual_name         sysname;
    DECLARE @PRDVA_FV_default_expected_definition nvarchar(4000);
    DECLARE @PRDVA_FV_default_actual_definition   nvarchar(4000);
    DECLARE @PRDVA_FV_default_expected_normalized nvarchar(4000);
    DECLARE @PRDVA_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @PRDVA_FV_invalid_defaults            int = 0;


    INSERT INTO @PRDVA_FV_expected_defaults
    (
        PRDVA_default_column_name,
        PRDVA_default_constraint_name,
        PRDVA_default_expected_definition
    )
    VALUES
    (
        N'PRDVA_is_active',
        N'DF_PRDVA_is_active',
        N'1'
    ),
    (
        N'PRDVA_created_at',
        N'DF_PRDVA_created_at',
        N'sysdatetime'
    ),
    (
        N'PRDVA_updated_at',
        N'DF_PRDVA_updated_at',
        N'sysdatetime'
    );


    SELECT
        @PRDVA_FV_default_current_id = MIN(PRDVA_default_id),
        @PRDVA_FV_default_max_id = MAX(PRDVA_default_id)
    FROM @PRDVA_FV_expected_defaults;


    WHILE @PRDVA_FV_default_current_id <= @PRDVA_FV_default_max_id
    BEGIN

        SET @PRDVA_FV_default_column_name = NULL;
        SET @PRDVA_FV_default_expected_name = NULL;
        SET @PRDVA_FV_default_actual_name = NULL;
        SET @PRDVA_FV_default_expected_definition = NULL;
        SET @PRDVA_FV_default_actual_definition = NULL;


        SELECT
            @PRDVA_FV_default_column_name = PRDVA_default_column_name,
            @PRDVA_FV_default_expected_name = PRDVA_default_constraint_name,
            @PRDVA_FV_default_expected_definition = PRDVA_default_expected_definition
        FROM @PRDVA_FV_expected_defaults
        WHERE PRDVA_default_id = @PRDVA_FV_default_current_id;


        SELECT
            @PRDVA_FV_default_actual_name = dc.name,
            @PRDVA_FV_default_actual_definition = dc.definition
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = @PRDVA_FV_default_column_name;


        SET @PRDVA_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @PRDVA_FV_default_expected_definition,
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


        SET @PRDVA_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @PRDVA_FV_default_actual_definition,
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


        IF @PRDVA_FV_default_actual_name IS NULL
        OR @PRDVA_FV_default_actual_name <> @PRDVA_FV_default_expected_name
        OR @PRDVA_FV_default_actual_definition IS NULL
        OR @PRDVA_FV_default_actual_normalized <> @PRDVA_FV_default_expected_normalized
        BEGIN
            SET @PRDVA_FV_invalid_defaults += 1;
        END;


        SET @PRDVA_FV_default_current_id += 1;

    END;


    IF @PRDVA_FV_invalid_defaults = 0
    BEGIN
        SET @PRDVA_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDVA_FV_defaults_status = N'FAILED';
        SET @PRDVA_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PRDVA_FV_uq_actual_name        sysname;
    DECLARE @PRDVA_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @PRDVA_FV_uq_actual_disabled    bit;
    DECLARE @PRDVA_FV_uq_actual_data_space  sysname;


    SELECT
        @PRDVA_FV_uq_actual_name = kc.name,
        @PRDVA_FV_uq_actual_disabled = i.is_disabled,
        @PRDVA_FV_uq_actual_data_space = ds.name,

        @PRDVA_FV_uq_actual_columns =
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
            OBJECT_ID(N'catalog.ProductVariant')

    AND kc.type = N'UQ'

    AND kc.name = N'UQ_PRDVA_sku';


    IF @PRDVA_FV_uq_actual_name = N'UQ_PRDVA_sku'
    AND @PRDVA_FV_uq_actual_columns = N'PRDVA_sku'
    AND @PRDVA_FV_uq_actual_disabled = 0
    AND @PRDVA_FV_uq_actual_data_space = N'FG_CORE'
    BEGIN
        SET @PRDVA_FV_uniques_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDVA_FV_uniques_status = N'FAILED';
        SET @PRDVA_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PRDVA_FV_fk_actual_name                sysname;
    DECLARE @PRDVA_FV_fk_parent_columns             nvarchar(4000);
    DECLARE @PRDVA_FV_fk_referenced_columns         nvarchar(4000);
    DECLARE @PRDVA_FV_fk_referenced_schema          sysname;
    DECLARE @PRDVA_FV_fk_referenced_table           sysname;
    DECLARE @PRDVA_FV_fk_delete_action              nvarchar(60);
    DECLARE @PRDVA_FV_fk_update_action              nvarchar(60);
    DECLARE @PRDVA_FV_fk_is_disabled                bit;
    DECLARE @PRDVA_FV_fk_is_not_trusted             bit;


    SELECT
        @PRDVA_FV_fk_actual_name = fk.name,
        @PRDVA_FV_fk_referenced_schema = OBJECT_SCHEMA_NAME(fk.referenced_object_id),
        @PRDVA_FV_fk_referenced_table = OBJECT_NAME(fk.referenced_object_id),
        @PRDVA_FV_fk_delete_action = fk.delete_referential_action_desc,
        @PRDVA_FV_fk_update_action = fk.update_referential_action_desc,
        @PRDVA_FV_fk_is_disabled = fk.is_disabled,
        @PRDVA_FV_fk_is_not_trusted = fk.is_not_trusted,

        @PRDVA_FV_fk_parent_columns =
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), pc.name), N'|')
                    WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        ),

        @PRDVA_FV_fk_referenced_columns =
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), rc.name), N'|')
                    WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
            OBJECT_ID(N'catalog.ProductVariant')

    AND fk.name = N'FK_PRDVA_PRD';


    IF @PRDVA_FV_fk_actual_name = N'FK_PRDVA_PRD'
    AND @PRDVA_FV_fk_parent_columns = N'PRDVA_PRD_id'
    AND @PRDVA_FV_fk_referenced_schema = N'catalog'
    AND @PRDVA_FV_fk_referenced_table = N'Product'
    AND @PRDVA_FV_fk_referenced_columns = N'PRD_id'
    AND @PRDVA_FV_fk_delete_action = N'NO_ACTION'
    AND @PRDVA_FV_fk_update_action = N'NO_ACTION'
    AND @PRDVA_FV_fk_is_disabled = 0
    AND @PRDVA_FV_fk_is_not_trusted = 0
    BEGIN
        SET @PRDVA_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDVA_FV_foreign_keys_status = N'FAILED';
        SET @PRDVA_FV_validation_errors += 1;
    END;


    /*==========================================================================
        ADDITIONAL INDEXES VALIDATION
    ==========================================================================*/

    DECLARE @PRDVA_FV_index_actual_name              sysname;
    DECLARE @PRDVA_FV_index_actual_type              tinyint;
    DECLARE @PRDVA_FV_index_actual_is_unique         bit;
    DECLARE @PRDVA_FV_index_actual_is_disabled       bit;
    DECLARE @PRDVA_FV_index_actual_has_filter        bit;
    DECLARE @PRDVA_FV_index_actual_filter            nvarchar(4000);
    DECLARE @PRDVA_FV_index_actual_normalized_filter nvarchar(4000);
    DECLARE @PRDVA_FV_index_actual_columns           nvarchar(4000);
    DECLARE @PRDVA_FV_index_actual_includes          nvarchar(4000);
    DECLARE @PRDVA_FV_index_actual_data_space        sysname;


    SELECT
        @PRDVA_FV_index_actual_name = i.name,
        @PRDVA_FV_index_actual_type = i.type,
        @PRDVA_FV_index_actual_is_unique = i.is_unique,
        @PRDVA_FV_index_actual_is_disabled = i.is_disabled,
        @PRDVA_FV_index_actual_has_filter = i.has_filter,
        @PRDVA_FV_index_actual_filter = i.filter_definition,
        @PRDVA_FV_index_actual_data_space = ds.name,

        @PRDVA_FV_index_actual_columns =
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), c.name), N'|')
                    WITHIN GROUP (ORDER BY ic.key_ordinal)
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON  c.object_id = ic.object_id
                AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ),

        @PRDVA_FV_index_actual_includes =
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), c.name), N'|')
                    WITHIN GROUP (ORDER BY ic.index_column_id)
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON  c.object_id = ic.object_id
                AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
        )

    FROM sys.indexes AS i

    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id

    WHERE i.object_id = OBJECT_ID(N'catalog.ProductVariant')
    AND i.name = N'UX_PRDVA_barcode';


    SET @PRDVA_FV_index_actual_normalized_filter =
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
                                    @PRDVA_FV_index_actual_filter,
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


    IF @PRDVA_FV_index_actual_name = N'UX_PRDVA_barcode'
    AND @PRDVA_FV_index_actual_type = 2
    AND @PRDVA_FV_index_actual_is_unique = 1
    AND @PRDVA_FV_index_actual_is_disabled = 0
    AND @PRDVA_FV_index_actual_has_filter = 1
    AND @PRDVA_FV_index_actual_normalized_filter = N'prdva_barcodeisnotnull'
    AND @PRDVA_FV_index_actual_columns = N'PRDVA_barcode'
    AND @PRDVA_FV_index_actual_includes IS NULL
    AND @PRDVA_FV_index_actual_data_space = N'FG_CORE'
    BEGIN
        SET @PRDVA_FV_indexes_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDVA_FV_indexes_status = N'FAILED';
        SET @PRDVA_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @PRDVA_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PRDVA_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PRDVA_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PRDVA_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PRDVA_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PRDVA_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PRDVA_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PRDVA_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PRDVA_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PRDVA_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @PRDVA_FV_temporal_integrity_status;
    PRINT N'';

    IF @PRDVA_FV_validation_errors = 0
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
                @PRDVA_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @PRDVA_FV_validation_errors > 0
    BEGIN

        ;THROW 50330,
            N'Final validation failed for catalog.ProductVariant.',
            1;

    END;