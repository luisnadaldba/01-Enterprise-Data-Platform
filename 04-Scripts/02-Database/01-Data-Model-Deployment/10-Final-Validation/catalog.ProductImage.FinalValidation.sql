    PRINT N'    catalog.ProductImage';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        FINAL VALIDATION STATE
    ==============================================================================*/

    DECLARE @PRDIM_FV_validation_errors int = 0;

    DECLARE @PRDIM_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDIM_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDIM_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDIM_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDIM_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDIM_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDIM_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDIM_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDIM_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDIM_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDIM_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';

    /*==============================================================================
        TABLE VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductImage', N'U') IS NOT NULL
    BEGIN
        SET @PRDIM_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDIM_FV_table_status = N'FAILED';
        SET @PRDIM_FV_validation_errors += 1;
    END;


    /*==============================================================================
        PRIMARY KEY VALIDATION
    ==============================================================================*/

    DECLARE @PRDIM_FV_pk_actual_name     sysname;
    DECLARE @PRDIM_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PRDIM_FV_pk_data_space      sysname;

    SELECT
        @PRDIM_FV_pk_actual_name = kc.name,
        @PRDIM_FV_pk_data_space = ds.name,
        @PRDIM_FV_pk_actual_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), c.name), N'|')
                WITHIN GROUP (ORDER BY ic.key_ordinal)
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
            AND c.column_id = ic.column_id
            WHERE ic.object_id = kc.parent_object_id
            AND ic.index_id = kc.unique_index_id
            AND ic.key_ordinal > 0
        )
    FROM sys.key_constraints AS kc
    INNER JOIN sys.indexes AS i
        ON i.object_id = kc.parent_object_id
    AND i.index_id = kc.unique_index_id
    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id
    WHERE kc.parent_object_id = OBJECT_ID(N'catalog.ProductImage')
    AND kc.type = N'PK';

    IF @PRDIM_FV_pk_actual_name = N'PK_PRDIM'
    AND @PRDIM_FV_pk_actual_columns = N'PRDIM_id'
    AND @PRDIM_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @PRDIM_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDIM_FV_primary_key_status = N'FAILED';
        SET @PRDIM_FV_validation_errors += 1;
    END;


    /*==============================================================================
        COLUMNS VALIDATION
    ==============================================================================*/

    DECLARE @PRDIM_FV_expected_column_count int = 8;
    DECLARE @PRDIM_FV_actual_column_count   int;

    SELECT @PRDIM_FV_actual_column_count = COUNT(*)
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'catalog.ProductImage');

    IF @PRDIM_FV_actual_column_count = @PRDIM_FV_expected_column_count
    AND EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND c.name = N'PRDIM_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )
    AND EXISTS
    (
        SELECT 1 FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND ic.name = N'PRDIM_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )
    AND EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND c.name = N'PRDIM_PRD_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )
    AND EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND c.name = N'PRDIM_path'
        AND t.name = N'nvarchar'
        AND c.max_length = 2000
        AND c.is_nullable = 0
    )
    AND EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND c.name = N'PRDIM_display_order'
        AND t.name = N'smallint'
        AND c.max_length = 2
        AND c.is_nullable = 0
    )
    AND EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND c.name = N'PRDIM_is_primary'
        AND t.name = N'bit'
        AND c.is_nullable = 0
    )
    AND EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND c.name = N'PRDIM_is_active'
        AND t.name = N'bit'
        AND c.is_nullable = 0
    )
    AND EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND c.name = N'PRDIM_created_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    AND EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND c.name = N'PRDIM_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @PRDIM_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDIM_FV_columns_status = N'FAILED';
        SET @PRDIM_FV_validation_errors += 1;
    END;


    /*==============================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==============================================================================*/

    DECLARE @PRDIM_FV_expected_documentation TABLE
    (
        PRDIM_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PRDIM_doc_object_type           nvarchar(10) NOT NULL,
        PRDIM_doc_column_name           sysname NULL,
        PRDIM_doc_expected_description  nvarchar(4000) NOT NULL
    );

    DECLARE @PRDIM_FV_doc_current_id        tinyint;
    DECLARE @PRDIM_FV_doc_max_id            tinyint;
    DECLARE @PRDIM_FV_doc_object_type       nvarchar(10);
    DECLARE @PRDIM_FV_doc_column_name       sysname;
    DECLARE @PRDIM_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PRDIM_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PRDIM_FV_invalid_documentation int = 0;

    INSERT INTO @PRDIM_FV_expected_documentation
    (
        PRDIM_doc_object_type,
        PRDIM_doc_column_name,
        PRDIM_doc_expected_description
    )
    VALUES
    (N'TABLE', NULL,
    N'Maintains references and presentation metadata for images associated with products in the Atlas Commerce catalog while keeping binary image content outside the relational database.'),
    (N'COLUMN', N'PRDIM_id',
    N'Primary key of catalog.ProductImage.'),
    (N'COLUMN', N'PRDIM_PRD_id',
    N'Foreign key of catalog.Product identifying the product associated with the image.'),
    (N'COLUMN', N'PRDIM_path',
    N'Stores the external path or object reference used to locate the product image while keeping binary image content outside the relational database.'),
    (N'COLUMN', N'PRDIM_display_order',
    N'Defines the presentation sequence of the image within the collection of images associated with the product.'),
    (N'COLUMN', N'PRDIM_is_primary',
    N'Indicates whether the image is the primary image used to represent the product in catalog presentation.'),
    (N'COLUMN', N'PRDIM_is_active',
    N'Indicates whether the image is currently available for use in catalog presentation while preserving inactive image records for historical integrity.'),
    (N'COLUMN', N'PRDIM_created_at',
    N'Records the date and time when the row was initially created.'),
    (N'COLUMN', N'PRDIM_updated_at',
    N'Records the date and time of the most recent meaningful modification to the row.');

    SELECT
        @PRDIM_FV_doc_current_id = MIN(PRDIM_doc_id),
        @PRDIM_FV_doc_max_id = MAX(PRDIM_doc_id)
    FROM @PRDIM_FV_expected_documentation;

    WHILE @PRDIM_FV_doc_current_id <= @PRDIM_FV_doc_max_id
    BEGIN
        SET @PRDIM_FV_doc_object_type = NULL;
        SET @PRDIM_FV_doc_column_name = NULL;
        SET @PRDIM_FV_doc_expected_value = NULL;
        SET @PRDIM_FV_doc_actual_value = NULL;

        SELECT
            @PRDIM_FV_doc_object_type = PRDIM_doc_object_type,
            @PRDIM_FV_doc_column_name = PRDIM_doc_column_name,
            @PRDIM_FV_doc_expected_value = PRDIM_doc_expected_description
        FROM @PRDIM_FV_expected_documentation
        WHERE PRDIM_doc_id = @PRDIM_FV_doc_current_id;

        IF @PRDIM_FV_doc_object_type = N'TABLE'
        BEGIN
            SELECT @PRDIM_FV_doc_actual_value = CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.ProductImage')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';
        END
        ELSE
        BEGIN
            SELECT @PRDIM_FV_doc_actual_value = CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            INNER JOIN sys.columns AS c
                ON c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'catalog.ProductImage')
            AND ep.name = N'MS_Description'
            AND c.name = @PRDIM_FV_doc_column_name;
        END;

        IF ISNULL(@PRDIM_FV_doc_actual_value, N'') <> @PRDIM_FV_doc_expected_value
            SET @PRDIM_FV_invalid_documentation += 1;

        SET @PRDIM_FV_doc_current_id += 1;
    END;

    IF @PRDIM_FV_invalid_documentation = 0
        SET @PRDIM_FV_documentation_status = N'VALID';
    ELSE
    BEGIN
        SET @PRDIM_FV_documentation_status = N'FAILED';
        SET @PRDIM_FV_validation_errors += 1;
    END;


    /*==============================================================================
        SEED DATA VALIDATION
    ==============================================================================*/

    IF EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'ProductImage'
        AND PFX_prefix = N'PRDIM'
        AND PFX_is_active = 1
    )
        SET @PRDIM_FV_seed_data_status = N'VALID';
    ELSE
    BEGIN
        SET @PRDIM_FV_seed_data_status = N'FAILED';
        SET @PRDIM_FV_validation_errors += 1;
    END;


    /*==============================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==============================================================================*/

    DECLARE @PRDIM_FV_expected_defaults TABLE
    (
        PRDIM_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        PRDIM_default_column_name          sysname NOT NULL,
        PRDIM_default_constraint_name      sysname NOT NULL,
        PRDIM_default_expected_definition  nvarchar(4000) NOT NULL
    );

    DECLARE @PRDIM_FV_default_current_id          tinyint;
    DECLARE @PRDIM_FV_default_max_id              tinyint;
    DECLARE @PRDIM_FV_default_column_name         sysname;
    DECLARE @PRDIM_FV_default_expected_name       sysname;
    DECLARE @PRDIM_FV_default_actual_name         sysname;
    DECLARE @PRDIM_FV_default_expected_definition nvarchar(4000);
    DECLARE @PRDIM_FV_default_actual_definition   nvarchar(4000);
    DECLARE @PRDIM_FV_default_expected_normalized nvarchar(4000);
    DECLARE @PRDIM_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @PRDIM_FV_invalid_defaults            int = 0;

    INSERT INTO @PRDIM_FV_expected_defaults
    (
        PRDIM_default_column_name,
        PRDIM_default_constraint_name,
        PRDIM_default_expected_definition
    )
    VALUES
    (N'PRDIM_is_primary', N'DF_PRDIM_is_primary', N'0'),
    (N'PRDIM_is_active',  N'DF_PRDIM_is_active',  N'1'),
    (N'PRDIM_created_at', N'DF_PRDIM_created_at', N'sysdatetime'),
    (N'PRDIM_updated_at', N'DF_PRDIM_updated_at', N'sysdatetime');

    SELECT
        @PRDIM_FV_default_current_id = MIN(PRDIM_default_id),
        @PRDIM_FV_default_max_id = MAX(PRDIM_default_id)
    FROM @PRDIM_FV_expected_defaults;

    WHILE @PRDIM_FV_default_current_id <= @PRDIM_FV_default_max_id
    BEGIN
        SET @PRDIM_FV_default_column_name = NULL;
        SET @PRDIM_FV_default_expected_name = NULL;
        SET @PRDIM_FV_default_actual_name = NULL;
        SET @PRDIM_FV_default_expected_definition = NULL;
        SET @PRDIM_FV_default_actual_definition = NULL;

        SELECT
            @PRDIM_FV_default_column_name = PRDIM_default_column_name,
            @PRDIM_FV_default_expected_name = PRDIM_default_constraint_name,
            @PRDIM_FV_default_expected_definition = PRDIM_default_expected_definition
        FROM @PRDIM_FV_expected_defaults
        WHERE PRDIM_default_id = @PRDIM_FV_default_current_id;

        SELECT
            @PRDIM_FV_default_actual_name = dc.name,
            @PRDIM_FV_default_actual_definition = dc.definition
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.ProductImage')
        AND c.name = @PRDIM_FV_default_column_name;

        SET @PRDIM_FV_default_expected_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(@PRDIM_FV_default_expected_definition, N'(', N''), N')', N''), N' ', N''));

        SET @PRDIM_FV_default_actual_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(@PRDIM_FV_default_actual_definition, N'(', N''), N')', N''), N' ', N''));

        IF @PRDIM_FV_default_actual_name IS NULL
        OR @PRDIM_FV_default_actual_name <> @PRDIM_FV_default_expected_name
        OR @PRDIM_FV_default_actual_definition IS NULL
        OR @PRDIM_FV_default_actual_normalized <> @PRDIM_FV_default_expected_normalized
            SET @PRDIM_FV_invalid_defaults += 1;

        SET @PRDIM_FV_default_current_id += 1;
    END;

    IF @PRDIM_FV_invalid_defaults = 0
        SET @PRDIM_FV_defaults_status = N'VALID';
    ELSE
    BEGIN
        SET @PRDIM_FV_defaults_status = N'FAILED';
        SET @PRDIM_FV_validation_errors += 1;
    END;


    /*==============================================================================
        CHECK CONSTRAINTS VALIDATION
    ==============================================================================*/

    DECLARE @PRDIM_FV_expected_checks TABLE
    (
        PRDIM_check_id                    tinyint IDENTITY(1,1) NOT NULL,
        PRDIM_check_constraint_name       sysname NOT NULL,
        PRDIM_check_expected_definition   nvarchar(4000) NOT NULL
    );

    DECLARE @PRDIM_FV_check_current_id          tinyint;
    DECLARE @PRDIM_FV_check_max_id              tinyint;
    DECLARE @PRDIM_FV_check_expected_name       sysname;
    DECLARE @PRDIM_FV_check_actual_name         sysname;
    DECLARE @PRDIM_FV_check_expected_definition nvarchar(4000);
    DECLARE @PRDIM_FV_check_actual_definition   nvarchar(4000);
    DECLARE @PRDIM_FV_check_expected_normalized nvarchar(4000);
    DECLARE @PRDIM_FV_check_actual_normalized   nvarchar(4000);
    DECLARE @PRDIM_FV_check_is_disabled         bit;
    DECLARE @PRDIM_FV_check_is_not_trusted      bit;
    DECLARE @PRDIM_FV_invalid_checks            int = 0;

    INSERT INTO @PRDIM_FV_expected_checks
    (
        PRDIM_check_constraint_name,
        PRDIM_check_expected_definition
    )
    VALUES
    (N'CK_PRDIM_display_order', N'PRDIM_display_order>=1'),
    (N'CK_PRDIM_primary_active', N'PRDIM_is_primary=0ORPRDIM_is_active=1'),
    (N'CK_PRDIM_path', N'LENLTRIMRTRIMPRDIM_path>0');

    SELECT
        @PRDIM_FV_check_current_id = MIN(PRDIM_check_id),
        @PRDIM_FV_check_max_id = MAX(PRDIM_check_id)
    FROM @PRDIM_FV_expected_checks;

    WHILE @PRDIM_FV_check_current_id <= @PRDIM_FV_check_max_id
    BEGIN
        SET @PRDIM_FV_check_expected_name = NULL;
        SET @PRDIM_FV_check_actual_name = NULL;
        SET @PRDIM_FV_check_expected_definition = NULL;
        SET @PRDIM_FV_check_actual_definition = NULL;
        SET @PRDIM_FV_check_is_disabled = NULL;
        SET @PRDIM_FV_check_is_not_trusted = NULL;

        SELECT
            @PRDIM_FV_check_expected_name = PRDIM_check_constraint_name,
            @PRDIM_FV_check_expected_definition = PRDIM_check_expected_definition
        FROM @PRDIM_FV_expected_checks
        WHERE PRDIM_check_id = @PRDIM_FV_check_current_id;

        SELECT
            @PRDIM_FV_check_actual_name = cc.name,
            @PRDIM_FV_check_actual_definition = cc.definition,
            @PRDIM_FV_check_is_disabled = cc.is_disabled,
            @PRDIM_FV_check_is_not_trusted = cc.is_not_trusted
        FROM sys.check_constraints AS cc
        WHERE cc.parent_object_id = OBJECT_ID(N'catalog.ProductImage')
        AND cc.name = @PRDIM_FV_check_expected_name;

        SET @PRDIM_FV_check_actual_normalized =
            LOWER(
                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                    @PRDIM_FV_check_actual_definition,
                    N'[', N''), N']', N''), N'(', N''), N')', N''), N' ', N''), NCHAR(9), N''), NCHAR(13)+NCHAR(10), N'')
            );

        IF @PRDIM_FV_check_expected_name = N'CK_PRDIM_path'
        BEGIN
            SET @PRDIM_FV_check_actual_normalized =
                REPLACE(@PRDIM_FV_check_actual_normalized, N'len', N'LEN');
            SET @PRDIM_FV_check_actual_normalized =
                REPLACE(@PRDIM_FV_check_actual_normalized, N'ltrim', N'LTRIM');
            SET @PRDIM_FV_check_actual_normalized =
                REPLACE(@PRDIM_FV_check_actual_normalized, N'rtrim', N'RTRIM');
        END;

        SET @PRDIM_FV_check_expected_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                @PRDIM_FV_check_expected_definition,
                N'[', N''), N']', N''), N'(', N''), N')', N''), N' ', N''), NCHAR(9), N''), NCHAR(13)+NCHAR(10), N''));

        IF @PRDIM_FV_check_expected_name = N'CK_PRDIM_path'
        BEGIN
            SET @PRDIM_FV_check_expected_normalized = LOWER(N'lenltrimrtrimprdim_path>0');
            SET @PRDIM_FV_check_actual_normalized = LOWER(@PRDIM_FV_check_actual_normalized);
        END;

        IF @PRDIM_FV_check_actual_name IS NULL
        OR @PRDIM_FV_check_actual_definition IS NULL
        OR @PRDIM_FV_check_actual_normalized <> @PRDIM_FV_check_expected_normalized
        OR @PRDIM_FV_check_is_disabled <> 0
        OR @PRDIM_FV_check_is_not_trusted <> 0
            SET @PRDIM_FV_invalid_checks += 1;

        SET @PRDIM_FV_check_current_id += 1;
    END;

    IF @PRDIM_FV_invalid_checks = 0
        SET @PRDIM_FV_checks_status = N'VALID';
    ELSE
    BEGIN
        SET @PRDIM_FV_checks_status = N'FAILED';
        SET @PRDIM_FV_validation_errors += 1;
    END;


    /*==============================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==============================================================================*/

    DECLARE @PRDIM_FV_fk_actual_name                sysname;
    DECLARE @PRDIM_FV_fk_parent_columns             nvarchar(4000);
    DECLARE @PRDIM_FV_fk_referenced_columns         nvarchar(4000);
    DECLARE @PRDIM_FV_fk_referenced_schema          sysname;
    DECLARE @PRDIM_FV_fk_referenced_table           sysname;
    DECLARE @PRDIM_FV_fk_delete_action              nvarchar(60);
    DECLARE @PRDIM_FV_fk_update_action              nvarchar(60);
    DECLARE @PRDIM_FV_fk_is_disabled                bit;
    DECLARE @PRDIM_FV_fk_is_not_trusted             bit;

    SELECT
        @PRDIM_FV_fk_actual_name = fk.name,
        @PRDIM_FV_fk_referenced_schema = OBJECT_SCHEMA_NAME(fk.referenced_object_id),
        @PRDIM_FV_fk_referenced_table = OBJECT_NAME(fk.referenced_object_id),
        @PRDIM_FV_fk_delete_action = fk.delete_referential_action_desc,
        @PRDIM_FV_fk_update_action = fk.update_referential_action_desc,
        @PRDIM_FV_fk_is_disabled = fk.is_disabled,
        @PRDIM_FV_fk_is_not_trusted = fk.is_not_trusted,
        @PRDIM_FV_fk_parent_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), pc.name), N'|')
                WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
            AND pc.column_id = fkc.parent_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        ),
        @PRDIM_FV_fk_referenced_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), rc.name), N'|')
                WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
            AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        )
    FROM sys.foreign_keys AS fk
    WHERE fk.parent_object_id = OBJECT_ID(N'catalog.ProductImage')
    AND fk.name = N'FK_PRDIM_PRD';

    IF @PRDIM_FV_fk_actual_name = N'FK_PRDIM_PRD'
    AND @PRDIM_FV_fk_parent_columns = N'PRDIM_PRD_id'
    AND @PRDIM_FV_fk_referenced_schema = N'catalog'
    AND @PRDIM_FV_fk_referenced_table = N'Product'
    AND @PRDIM_FV_fk_referenced_columns = N'PRD_id'
    AND @PRDIM_FV_fk_delete_action = N'NO_ACTION'
    AND @PRDIM_FV_fk_update_action = N'NO_ACTION'
    AND @PRDIM_FV_fk_is_disabled = 0
    AND @PRDIM_FV_fk_is_not_trusted = 0
        SET @PRDIM_FV_foreign_keys_status = N'VALID';
    ELSE
    BEGIN
        SET @PRDIM_FV_foreign_keys_status = N'FAILED';
        SET @PRDIM_FV_validation_errors += 1;
    END;


    /*==============================================================================
        ADDITIONAL INDEX VALIDATION
    ==============================================================================*/

    DECLARE @PRDIM_FV_expected_indexes TABLE
    (
        PRDIM_index_id                    tinyint IDENTITY(1,1) NOT NULL,
        PRDIM_index_name                  sysname NOT NULL,
        PRDIM_index_expected_keys         nvarchar(4000) NOT NULL,
        PRDIM_index_expected_filter       nvarchar(4000) NOT NULL,
        PRDIM_index_expected_data_space   sysname NOT NULL
    );

    DECLARE @PRDIM_FV_index_current_id          tinyint;
    DECLARE @PRDIM_FV_index_max_id              tinyint;
    DECLARE @PRDIM_FV_index_expected_name       sysname;
    DECLARE @PRDIM_FV_index_expected_keys       nvarchar(4000);
    DECLARE @PRDIM_FV_index_expected_filter     nvarchar(4000);
    DECLARE @PRDIM_FV_index_expected_data_space sysname;

    DECLARE @PRDIM_FV_index_actual_name         sysname;
    DECLARE @PRDIM_FV_index_actual_type         tinyint;
    DECLARE @PRDIM_FV_index_actual_unique       bit;
    DECLARE @PRDIM_FV_index_actual_disabled     bit;
    DECLARE @PRDIM_FV_index_actual_hypothetical bit;
    DECLARE @PRDIM_FV_index_actual_has_filter   bit;
    DECLARE @PRDIM_FV_index_actual_keys         nvarchar(4000);
    DECLARE @PRDIM_FV_index_actual_includes     nvarchar(4000);
    DECLARE @PRDIM_FV_index_actual_filter       nvarchar(4000);
    DECLARE @PRDIM_FV_index_actual_data_space   sysname;
    DECLARE @PRDIM_FV_index_expected_filter_normalized nvarchar(4000);
    DECLARE @PRDIM_FV_index_actual_filter_normalized   nvarchar(4000);
    DECLARE @PRDIM_FV_invalid_indexes           int = 0;

    INSERT INTO @PRDIM_FV_expected_indexes
    (
        PRDIM_index_name,
        PRDIM_index_expected_keys,
        PRDIM_index_expected_filter,
        PRDIM_index_expected_data_space
    )
    VALUES
    (N'UX_PRDIM_primary_product',
    N'PRDIM_PRD_id ASC',
    N'PRDIM_is_primary=1',
    N'FG_CORE'),
    (N'UX_PRDIM_product_display_order_active',
    N'PRDIM_PRD_id ASC|PRDIM_display_order ASC',
    N'PRDIM_is_active=1',
    N'FG_CORE');

    SELECT
        @PRDIM_FV_index_current_id = MIN(PRDIM_index_id),
        @PRDIM_FV_index_max_id = MAX(PRDIM_index_id)
    FROM @PRDIM_FV_expected_indexes;

    WHILE @PRDIM_FV_index_current_id <= @PRDIM_FV_index_max_id
    BEGIN
        SET @PRDIM_FV_index_expected_name = NULL;
        SET @PRDIM_FV_index_expected_keys = NULL;
        SET @PRDIM_FV_index_expected_filter = NULL;
        SET @PRDIM_FV_index_expected_data_space = NULL;
        SET @PRDIM_FV_index_actual_name = NULL;
        SET @PRDIM_FV_index_actual_type = NULL;
        SET @PRDIM_FV_index_actual_unique = NULL;
        SET @PRDIM_FV_index_actual_disabled = NULL;
        SET @PRDIM_FV_index_actual_hypothetical = NULL;
        SET @PRDIM_FV_index_actual_has_filter = NULL;
        SET @PRDIM_FV_index_actual_keys = NULL;
        SET @PRDIM_FV_index_actual_includes = NULL;
        SET @PRDIM_FV_index_actual_filter = NULL;
        SET @PRDIM_FV_index_actual_data_space = NULL;

        SELECT
            @PRDIM_FV_index_expected_name = PRDIM_index_name,
            @PRDIM_FV_index_expected_keys = PRDIM_index_expected_keys,
            @PRDIM_FV_index_expected_filter = PRDIM_index_expected_filter,
            @PRDIM_FV_index_expected_data_space = PRDIM_index_expected_data_space
        FROM @PRDIM_FV_expected_indexes
        WHERE PRDIM_index_id = @PRDIM_FV_index_current_id;

        SELECT
            @PRDIM_FV_index_actual_name = i.name,
            @PRDIM_FV_index_actual_type = i.type,
            @PRDIM_FV_index_actual_unique = i.is_unique,
            @PRDIM_FV_index_actual_disabled = i.is_disabled,
            @PRDIM_FV_index_actual_hypothetical = i.is_hypothetical,
            @PRDIM_FV_index_actual_has_filter = i.has_filter,
            @PRDIM_FV_index_actual_filter = i.filter_definition,
            @PRDIM_FV_index_actual_data_space = ds.name
        FROM sys.indexes AS i
        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND i.name = @PRDIM_FV_index_expected_name;

        SELECT
            @PRDIM_FV_index_actual_keys =
                STRING_AGG(
                    CONVERT(nvarchar(max),
                        c.name +
                        CASE WHEN ic.is_descending_key = 1 THEN N' DESC' ELSE N' ASC' END
                    ),
                    N'|'
                )
                WITHIN GROUP (ORDER BY ic.key_ordinal)
        FROM sys.indexes AS i
        INNER JOIN sys.index_columns AS ic
            ON ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal > 0
        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND i.name = @PRDIM_FV_index_expected_name;

        SELECT
            @PRDIM_FV_index_actual_includes =
                STRING_AGG(CONVERT(nvarchar(max), c.name), N'|')
                WITHIN GROUP (ORDER BY ic.index_column_id)
        FROM sys.indexes AS i
        INNER JOIN sys.index_columns AS ic
            ON ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1
        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductImage')
        AND i.name = @PRDIM_FV_index_expected_name;

        SET @PRDIM_FV_index_actual_includes =
            COALESCE(@PRDIM_FV_index_actual_includes, N'NONE');

        SET @PRDIM_FV_index_expected_filter_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                @PRDIM_FV_index_expected_filter,
                N'[', N''), N']', N''), N' ', N''), N'(', N''), N')', N''));

        SET @PRDIM_FV_index_actual_filter_normalized =
            LOWER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                @PRDIM_FV_index_actual_filter,
                N'[', N''), N']', N''), N' ', N''), N'(', N''), N')', N''));

        IF @PRDIM_FV_index_actual_name IS NULL
        OR @PRDIM_FV_index_actual_type <> 2
        OR @PRDIM_FV_index_actual_unique <> 1
        OR @PRDIM_FV_index_actual_disabled <> 0
        OR @PRDIM_FV_index_actual_hypothetical <> 0
        OR @PRDIM_FV_index_actual_has_filter <> 1
        OR @PRDIM_FV_index_actual_keys <> @PRDIM_FV_index_expected_keys
        OR @PRDIM_FV_index_actual_includes <> N'NONE'
        OR @PRDIM_FV_index_actual_filter_normalized <> @PRDIM_FV_index_expected_filter_normalized
        OR @PRDIM_FV_index_actual_data_space <> @PRDIM_FV_index_expected_data_space
            SET @PRDIM_FV_invalid_indexes += 1;

        SET @PRDIM_FV_index_current_id += 1;
    END;

    IF @PRDIM_FV_invalid_indexes = 0
        SET @PRDIM_FV_indexes_status = N'VALID';
    ELSE
    BEGIN
        SET @PRDIM_FV_indexes_status = N'FAILED';
        SET @PRDIM_FV_validation_errors += 1;
    END;


    /*==============================================================================
        FINAL STATE
    ==============================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    PRINT N'        Table                         : ' + @PRDIM_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PRDIM_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PRDIM_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PRDIM_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PRDIM_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PRDIM_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PRDIM_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PRDIM_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PRDIM_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PRDIM_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @PRDIM_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';

    IF @PRDIM_FV_validation_errors = 0
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
            + CONVERT(nvarchar(10), @PRDIM_FV_validation_errors);
        PRINT N'';

        ;THROW 50460,
            N'Final validation failed for catalog.ProductImage.',
            1;
    END;

    PRINT N'';