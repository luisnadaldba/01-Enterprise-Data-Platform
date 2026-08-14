    PRINT N'    catalog.Product';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PRD_FV_validation_errors int = 0;

    DECLARE @PRD_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRD_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRD_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRD_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRD_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRD_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRD_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRD_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRD_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRD_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRD_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.Product', N'U') IS NOT NULL
    BEGIN
        SET @PRD_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRD_FV_table_status = N'FAILED';
        SET @PRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PRD_FV_pk_actual_name     sysname;
    DECLARE @PRD_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PRD_FV_pk_data_space      sysname;


    SELECT
        @PRD_FV_pk_actual_name = kc.name,
        @PRD_FV_pk_data_space = ds.name,

        @PRD_FV_pk_actual_columns =
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
            OBJECT_ID(N'catalog.Product')

    AND kc.type = N'PK';


    IF @PRD_FV_pk_actual_name = N'PK_PRD'
    AND @PRD_FV_pk_actual_columns = N'PRD_id'
    AND @PRD_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @PRD_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRD_FV_primary_key_status = N'FAILED';
        SET @PRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PRD_FV_expected_column_count int = 6;
    DECLARE @PRD_FV_actual_column_count   int;


    SELECT
        @PRD_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'catalog.Product');


    IF @PRD_FV_actual_column_count =
            @PRD_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'catalog.Product')

        AND c.name = N'PRD_id'
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
                OBJECT_ID(N'catalog.Product')

        AND ic.name = N'PRD_id'
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
                OBJECT_ID(N'catalog.Product')

        AND c.name = N'PRD_BRD_id'
        AND t.name = N'smallint'
        AND c.max_length = 2
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
                OBJECT_ID(N'catalog.Product')

        AND c.name = N'PRD_name'
        AND t.name = N'nvarchar'
        AND c.max_length = 400
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'catalog.Product')

        AND c.name = N'PRD_is_active'
        AND t.name = N'bit'
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'catalog.Product')

        AND c.name = N'PRD_created_at'
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
                OBJECT_ID(N'catalog.Product')

        AND c.name = N'PRD_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @PRD_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRD_FV_columns_status = N'FAILED';
        SET @PRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PRD_FV_expected_documentation TABLE
    (
        PRD_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PRD_doc_object_type           nvarchar(10) NOT NULL,
        PRD_doc_column_name           sysname NULL,
        PRD_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @PRD_FV_doc_current_id        tinyint;
    DECLARE @PRD_FV_doc_max_id            tinyint;
    DECLARE @PRD_FV_doc_object_type       nvarchar(10);
    DECLARE @PRD_FV_doc_column_name       sysname;
    DECLARE @PRD_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PRD_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PRD_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            catalog.Product.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @PRD_FV_expected_documentation
    (
        PRD_doc_object_type,
        PRD_doc_column_name,
        PRD_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the commercial identity of products available in the Atlas Commerce catalog independently from their sellable variants.'
    ),
    (
        N'COLUMN',
        N'PRD_id',
        N'Primary key of catalog.Product.'
    ),
    (
        N'COLUMN',
        N'PRD_BRD_id',
        N'Foreign key of catalog.Brand.'
    ),
    (
        N'COLUMN',
        N'PRD_name',
        N'Stores the commercial name used to identify the product in the catalog.'
    ),
    (
        N'COLUMN',
        N'PRD_is_active',
        N'Indicates whether the product is currently available for use in catalog operations while preserving inactive products for historical integrity.'
    ),
    (
        N'COLUMN',
        N'PRD_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'PRD_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    SELECT
        @PRD_FV_doc_current_id =
            MIN(PRD_doc_id),

        @PRD_FV_doc_max_id =
            MAX(PRD_doc_id)

    FROM @PRD_FV_expected_documentation;


    WHILE @PRD_FV_doc_current_id <=
        @PRD_FV_doc_max_id
    BEGIN

        SET @PRD_FV_doc_object_type = NULL;
        SET @PRD_FV_doc_column_name = NULL;
        SET @PRD_FV_doc_expected_value = NULL;
        SET @PRD_FV_doc_actual_value = NULL;


        SELECT
            @PRD_FV_doc_object_type =
                PRD_doc_object_type,

            @PRD_FV_doc_column_name =
                PRD_doc_column_name,

            @PRD_FV_doc_expected_value =
                PRD_doc_expected_description

        FROM @PRD_FV_expected_documentation

        WHERE PRD_doc_id =
                @PRD_FV_doc_current_id;


        IF @PRD_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @PRD_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'catalog.Product')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @PRD_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'catalog.Product')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @PRD_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @PRD_FV_doc_actual_value,
            N''
        )
        <>
        @PRD_FV_doc_expected_value
        BEGIN

            SET @PRD_FV_invalid_documentation += 1;

        END;


        SET @PRD_FV_doc_current_id += 1;

    END;


    IF @PRD_FV_invalid_documentation = 0
    BEGIN
        SET @PRD_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRD_FV_documentation_status = N'FAILED';
        SET @PRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'Product'
        AND PFX_prefix = N'PRD'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @PRD_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRD_FV_seed_data_status = N'FAILED';
        SET @PRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PRD_FV_expected_defaults TABLE
    (
        PRD_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        PRD_default_column_name          sysname NOT NULL,
        PRD_default_constraint_name      sysname NOT NULL,
        PRD_default_expected_definition  nvarchar(4000) NOT NULL
    );


    DECLARE @PRD_FV_default_current_id          tinyint;
    DECLARE @PRD_FV_default_max_id              tinyint;
    DECLARE @PRD_FV_default_column_name         sysname;
    DECLARE @PRD_FV_default_expected_name       sysname;
    DECLARE @PRD_FV_default_actual_name         sysname;
    DECLARE @PRD_FV_default_expected_definition nvarchar(4000);
    DECLARE @PRD_FV_default_actual_definition   nvarchar(4000);
    DECLARE @PRD_FV_default_expected_normalized nvarchar(4000);
    DECLARE @PRD_FV_default_actual_normalized   nvarchar(4000);
    DECLARE @PRD_FV_invalid_defaults            int = 0;


    INSERT INTO @PRD_FV_expected_defaults
    (
        PRD_default_column_name,
        PRD_default_constraint_name,
        PRD_default_expected_definition
    )
    VALUES
    (
        N'PRD_is_active',
        N'DF_PRD_is_active',
        N'1'
    ),
    (
        N'PRD_created_at',
        N'DF_PRD_created_at',
        N'sysdatetime'
    ),
    (
        N'PRD_updated_at',
        N'DF_PRD_updated_at',
        N'sysdatetime'
    );


    SELECT
        @PRD_FV_default_current_id =
            MIN(PRD_default_id),

        @PRD_FV_default_max_id =
            MAX(PRD_default_id)

    FROM @PRD_FV_expected_defaults;


    WHILE @PRD_FV_default_current_id <=
        @PRD_FV_default_max_id
    BEGIN

        SET @PRD_FV_default_column_name = NULL;
        SET @PRD_FV_default_expected_name = NULL;
        SET @PRD_FV_default_actual_name = NULL;
        SET @PRD_FV_default_expected_definition = NULL;
        SET @PRD_FV_default_actual_definition = NULL;


        SELECT
            @PRD_FV_default_column_name =
                PRD_default_column_name,

            @PRD_FV_default_expected_name =
                PRD_default_constraint_name,

            @PRD_FV_default_expected_definition =
                PRD_default_expected_definition

        FROM @PRD_FV_expected_defaults

        WHERE PRD_default_id =
                @PRD_FV_default_current_id;


        SELECT
            @PRD_FV_default_actual_name =
                dc.name,

            @PRD_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.Product')

        AND c.name =
                @PRD_FV_default_column_name;


        SET @PRD_FV_default_expected_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @PRD_FV_default_expected_definition,
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


        SET @PRD_FV_default_actual_normalized =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            @PRD_FV_default_actual_definition,
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


        IF @PRD_FV_default_actual_name IS NULL
        OR @PRD_FV_default_actual_name <>
                @PRD_FV_default_expected_name
        OR @PRD_FV_default_actual_definition IS NULL
        OR @PRD_FV_default_actual_normalized <>
                @PRD_FV_default_expected_normalized
        BEGIN

            SET @PRD_FV_invalid_defaults += 1;

        END;


        SET @PRD_FV_default_current_id += 1;

    END;


    IF @PRD_FV_invalid_defaults = 0
    BEGIN
        SET @PRD_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRD_FV_defaults_status = N'FAILED';
        SET @PRD_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PRD_FV_uq_actual_name        sysname;
    DECLARE @PRD_FV_uq_actual_columns     nvarchar(4000);
    DECLARE @PRD_FV_uq_actual_disabled    bit;
    DECLARE @PRD_FV_uq_actual_data_space  sysname;


    SELECT
        @PRD_FV_uq_actual_name =
            kc.name,

        @PRD_FV_uq_actual_disabled =
            i.is_disabled,

        @PRD_FV_uq_actual_data_space =
            ds.name,

        @PRD_FV_uq_actual_columns =
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
            OBJECT_ID(N'catalog.Product')

    AND kc.type = N'UQ'

    AND kc.name =
            N'UQ_PRD_brand_name';


    IF @PRD_FV_uq_actual_name =
            N'UQ_PRD_brand_name'

    AND @PRD_FV_uq_actual_columns =
            N'PRD_BRD_id|PRD_name'

    AND @PRD_FV_uq_actual_disabled = 0

    AND @PRD_FV_uq_actual_data_space =
            N'FG_CORE'
    BEGIN

        SET @PRD_FV_uniques_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @PRD_FV_uniques_status = N'FAILED';
        SET @PRD_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PRD_FV_fk_actual_name                sysname;
    DECLARE @PRD_FV_fk_parent_columns             nvarchar(4000);
    DECLARE @PRD_FV_fk_referenced_columns         nvarchar(4000);
    DECLARE @PRD_FV_fk_referenced_schema          sysname;
    DECLARE @PRD_FV_fk_referenced_table           sysname;
    DECLARE @PRD_FV_fk_delete_action              nvarchar(60);
    DECLARE @PRD_FV_fk_update_action              nvarchar(60);
    DECLARE @PRD_FV_fk_is_disabled                bit;
    DECLARE @PRD_FV_fk_is_not_trusted             bit;


    SELECT
        @PRD_FV_fk_actual_name =
            fk.name,

        @PRD_FV_fk_referenced_schema =
            OBJECT_SCHEMA_NAME
            (
                fk.referenced_object_id
            ),

        @PRD_FV_fk_referenced_table =
            OBJECT_NAME
            (
                fk.referenced_object_id
            ),

        @PRD_FV_fk_delete_action =
            fk.delete_referential_action_desc,

        @PRD_FV_fk_update_action =
            fk.update_referential_action_desc,

        @PRD_FV_fk_is_disabled =
            fk.is_disabled,

        @PRD_FV_fk_is_not_trusted =
            fk.is_not_trusted,

        @PRD_FV_fk_parent_columns =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), pc.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY fkc.constraint_column_id
                )

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS pc
                ON  pc.object_id =
                        fkc.parent_object_id

                AND pc.column_id =
                        fkc.parent_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id
        ),

        @PRD_FV_fk_referenced_columns =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), rc.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY fkc.constraint_column_id
                )

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS rc
                ON  rc.object_id =
                        fkc.referenced_object_id

                AND rc.column_id =
                        fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
            OBJECT_ID(N'catalog.Product')

    AND fk.name =
            N'FK_PRD_BRD';


    IF @PRD_FV_fk_actual_name =
            N'FK_PRD_BRD'

    AND @PRD_FV_fk_parent_columns =
            N'PRD_BRD_id'

    AND @PRD_FV_fk_referenced_schema =
            N'catalog'

    AND @PRD_FV_fk_referenced_table =
            N'Brand'

    AND @PRD_FV_fk_referenced_columns =
            N'BRD_id'

    AND @PRD_FV_fk_delete_action =
            N'NO_ACTION'

    AND @PRD_FV_fk_update_action =
            N'NO_ACTION'

    AND @PRD_FV_fk_is_disabled = 0

    AND @PRD_FV_fk_is_not_trusted = 0
    BEGIN

        SET @PRD_FV_foreign_keys_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @PRD_FV_foreign_keys_status = N'FAILED';
        SET @PRD_FV_validation_errors += 1;

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

    PRINT N'        Table                         : ' + @PRD_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PRD_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PRD_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PRD_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PRD_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PRD_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PRD_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PRD_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PRD_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PRD_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @PRD_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @PRD_FV_validation_errors = 0
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
                @PRD_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50200,
            N'Final validation failed for catalog.Product.',
            1;

    END;


    PRINT N'';