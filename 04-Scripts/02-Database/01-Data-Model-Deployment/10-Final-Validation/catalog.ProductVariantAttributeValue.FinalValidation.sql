    PRINT N'    catalog.ProductVariantAttributeValue';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PRDAV_FV_validation_errors int = 0;

    DECLARE @PRDAV_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDAV_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDAV_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDAV_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDAV_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDAV_FV_defaults_status            nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDAV_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDAV_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDAV_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDAV_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDAV_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariantAttributeValue', N'U') IS NOT NULL
    BEGIN
        SET @PRDAV_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDAV_FV_table_status = N'FAILED';
        SET @PRDAV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PRDAV_FV_pk_actual_name     sysname;
    DECLARE @PRDAV_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PRDAV_FV_pk_data_space      sysname;


    SELECT
        @PRDAV_FV_pk_actual_name = kc.name,
        @PRDAV_FV_pk_data_space = ds.name,

        @PRDAV_FV_pk_actual_columns =
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
            OBJECT_ID(N'catalog.ProductVariantAttributeValue')

    AND kc.type = N'PK';


    IF @PRDAV_FV_pk_actual_name = N'PK_PRDAV'
    AND @PRDAV_FV_pk_actual_columns = N'PRDAV_PRDVA_id|PRDAV_PATVL_id'
    AND @PRDAV_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @PRDAV_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDAV_FV_primary_key_status = N'FAILED';
        SET @PRDAV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PRDAV_FV_expected_column_count int = 2;
    DECLARE @PRDAV_FV_actual_column_count   int;


    SELECT
        @PRDAV_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'catalog.ProductVariantAttributeValue');


    IF @PRDAV_FV_actual_column_count =
            @PRDAV_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'catalog.ProductVariantAttributeValue')

        AND c.name = N'PRDAV_PRDVA_id'
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
                OBJECT_ID(N'catalog.ProductVariantAttributeValue')

        AND c.name = N'PRDAV_PATVL_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )
    BEGIN
        SET @PRDAV_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDAV_FV_columns_status = N'FAILED';
        SET @PRDAV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PRDAV_FV_expected_documentation TABLE
    (
        PRDAV_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PRDAV_doc_object_type           nvarchar(10) NOT NULL,
        PRDAV_doc_column_name           sysname NULL,
        PRDAV_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @PRDAV_FV_doc_current_id        tinyint;
    DECLARE @PRDAV_FV_doc_max_id            tinyint;
    DECLARE @PRDAV_FV_doc_object_type       nvarchar(10);
    DECLARE @PRDAV_FV_doc_column_name       sysname;
    DECLARE @PRDAV_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PRDAV_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PRDAV_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            catalog.ProductVariantAttributeValue.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @PRDAV_FV_expected_documentation
    (
        PRDAV_doc_object_type,
        PRDAV_doc_column_name,
        PRDAV_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Associates sellable product variants with the controlled product attribute values that define their catalog characteristics.'
    ),
    (
        N'COLUMN',
        N'PRDAV_PRDVA_id',
        N'Foreign key of catalog.ProductVariant.'
    ),
    (
        N'COLUMN',
        N'PRDAV_PATVL_id',
        N'Foreign key of catalog.ProductAttributeValue.'
    );


    SELECT
        @PRDAV_FV_doc_current_id =
            MIN(PRDAV_doc_id),

        @PRDAV_FV_doc_max_id =
            MAX(PRDAV_doc_id)

    FROM @PRDAV_FV_expected_documentation;


    WHILE @PRDAV_FV_doc_current_id <=
        @PRDAV_FV_doc_max_id
    BEGIN

        SET @PRDAV_FV_doc_object_type = NULL;
        SET @PRDAV_FV_doc_column_name = NULL;
        SET @PRDAV_FV_doc_expected_value = NULL;
        SET @PRDAV_FV_doc_actual_value = NULL;


        SELECT
            @PRDAV_FV_doc_object_type =
                PRDAV_doc_object_type,

            @PRDAV_FV_doc_column_name =
                PRDAV_doc_column_name,

            @PRDAV_FV_doc_expected_value =
                PRDAV_doc_expected_description

        FROM @PRDAV_FV_expected_documentation

        WHERE PRDAV_doc_id =
                @PRDAV_FV_doc_current_id;


        IF @PRDAV_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @PRDAV_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'catalog.ProductVariantAttributeValue')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @PRDAV_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'catalog.ProductVariantAttributeValue')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @PRDAV_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @PRDAV_FV_doc_actual_value,
            N''
        )
        <>
        @PRDAV_FV_doc_expected_value
        BEGIN

            SET @PRDAV_FV_invalid_documentation += 1;

        END;


        SET @PRDAV_FV_doc_current_id += 1;

    END;


    IF @PRDAV_FV_invalid_documentation = 0
    BEGIN
        SET @PRDAV_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDAV_FV_documentation_status = N'FAILED';
        SET @PRDAV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM metadata.TablePrefix

        WHERE PFX_schema_name = N'catalog'
        AND PFX_table_name = N'ProductVariantAttributeValue'
        AND PFX_prefix = N'PRDAV'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @PRDAV_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDAV_FV_seed_data_status = N'FAILED';
        SET @PRDAV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PRDAV_FV_invalid_foreign_keys int = 0;


    /*--------------------------------------------------------------------------
        FK_PRDAV_PRDVA
    --------------------------------------------------------------------------*/

    DECLARE @PRDAV_FV_fk1_actual_name                sysname;
    DECLARE @PRDAV_FV_fk1_parent_columns             nvarchar(4000);
    DECLARE @PRDAV_FV_fk1_referenced_columns         nvarchar(4000);
    DECLARE @PRDAV_FV_fk1_referenced_schema          sysname;
    DECLARE @PRDAV_FV_fk1_referenced_table           sysname;
    DECLARE @PRDAV_FV_fk1_delete_action              nvarchar(60);
    DECLARE @PRDAV_FV_fk1_update_action              nvarchar(60);
    DECLARE @PRDAV_FV_fk1_is_disabled                bit;
    DECLARE @PRDAV_FV_fk1_is_not_trusted             bit;


    SELECT
        @PRDAV_FV_fk1_actual_name = fk.name,

        @PRDAV_FV_fk1_referenced_schema =
            OBJECT_SCHEMA_NAME(fk.referenced_object_id),

        @PRDAV_FV_fk1_referenced_table =
            OBJECT_NAME(fk.referenced_object_id),

        @PRDAV_FV_fk1_delete_action =
            fk.delete_referential_action_desc,

        @PRDAV_FV_fk1_update_action =
            fk.update_referential_action_desc,

        @PRDAV_FV_fk1_is_disabled =
            fk.is_disabled,

        @PRDAV_FV_fk1_is_not_trusted =
            fk.is_not_trusted,

        @PRDAV_FV_fk1_parent_columns =
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

        @PRDAV_FV_fk1_referenced_columns =
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
            OBJECT_ID(N'catalog.ProductVariantAttributeValue')

    AND fk.name =
            N'FK_PRDAV_PRDVA';


    IF NOT
    (
        @PRDAV_FV_fk1_actual_name = N'FK_PRDAV_PRDVA'
        AND @PRDAV_FV_fk1_parent_columns = N'PRDAV_PRDVA_id'
        AND @PRDAV_FV_fk1_referenced_schema = N'catalog'
        AND @PRDAV_FV_fk1_referenced_table = N'ProductVariant'
        AND @PRDAV_FV_fk1_referenced_columns = N'PRDVA_id'
        AND @PRDAV_FV_fk1_delete_action = N'NO_ACTION'
        AND @PRDAV_FV_fk1_update_action = N'NO_ACTION'
        AND @PRDAV_FV_fk1_is_disabled = 0
        AND @PRDAV_FV_fk1_is_not_trusted = 0
    )
    BEGIN

        SET @PRDAV_FV_invalid_foreign_keys += 1;

    END;


    /*--------------------------------------------------------------------------
        FK_PRDAV_PATVL
    --------------------------------------------------------------------------*/

    DECLARE @PRDAV_FV_fk2_actual_name                sysname;
    DECLARE @PRDAV_FV_fk2_parent_columns             nvarchar(4000);
    DECLARE @PRDAV_FV_fk2_referenced_columns         nvarchar(4000);
    DECLARE @PRDAV_FV_fk2_referenced_schema          sysname;
    DECLARE @PRDAV_FV_fk2_referenced_table           sysname;
    DECLARE @PRDAV_FV_fk2_delete_action              nvarchar(60);
    DECLARE @PRDAV_FV_fk2_update_action              nvarchar(60);
    DECLARE @PRDAV_FV_fk2_is_disabled                bit;
    DECLARE @PRDAV_FV_fk2_is_not_trusted             bit;


    SELECT
        @PRDAV_FV_fk2_actual_name = fk.name,

        @PRDAV_FV_fk2_referenced_schema =
            OBJECT_SCHEMA_NAME(fk.referenced_object_id),

        @PRDAV_FV_fk2_referenced_table =
            OBJECT_NAME(fk.referenced_object_id),

        @PRDAV_FV_fk2_delete_action =
            fk.delete_referential_action_desc,

        @PRDAV_FV_fk2_update_action =
            fk.update_referential_action_desc,

        @PRDAV_FV_fk2_is_disabled =
            fk.is_disabled,

        @PRDAV_FV_fk2_is_not_trusted =
            fk.is_not_trusted,

        @PRDAV_FV_fk2_parent_columns =
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

        @PRDAV_FV_fk2_referenced_columns =
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
            OBJECT_ID(N'catalog.ProductVariantAttributeValue')

    AND fk.name =
            N'FK_PRDAV_PATVL';


    IF NOT
    (
        @PRDAV_FV_fk2_actual_name = N'FK_PRDAV_PATVL'
        AND @PRDAV_FV_fk2_parent_columns = N'PRDAV_PATVL_id'
        AND @PRDAV_FV_fk2_referenced_schema = N'catalog'
        AND @PRDAV_FV_fk2_referenced_table = N'ProductAttributeValue'
        AND @PRDAV_FV_fk2_referenced_columns = N'PATVL_id'
        AND @PRDAV_FV_fk2_delete_action = N'NO_ACTION'
        AND @PRDAV_FV_fk2_update_action = N'NO_ACTION'
        AND @PRDAV_FV_fk2_is_disabled = 0
        AND @PRDAV_FV_fk2_is_not_trusted = 0
    )
    BEGIN

        SET @PRDAV_FV_invalid_foreign_keys += 1;

    END;


    IF @PRDAV_FV_invalid_foreign_keys = 0
    BEGIN
        SET @PRDAV_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDAV_FV_foreign_keys_status = N'FAILED';
        SET @PRDAV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    PRINT N'        Table                         : ' + @PRDAV_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PRDAV_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PRDAV_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PRDAV_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PRDAV_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PRDAV_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PRDAV_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PRDAV_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PRDAV_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PRDAV_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @PRDAV_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @PRDAV_FV_validation_errors = 0
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
                @PRDAV_FV_validation_errors
            );

        PRINT N'';


        ;THROW 50370,
            N'Final validation failed for catalog.ProductVariantAttributeValue.',
            1;

    END;


    PRINT N'';