    PRINT N'    ● catalog.ProductCategory';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PRDCT_FV_validation_errors int = 0;

    DECLARE @PRDCT_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDCT_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDCT_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDCT_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDCT_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @PRDCT_FV_defaults_status            nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDCT_FV_checks_status              nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDCT_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDCT_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDCT_FV_indexes_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDCT_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.ProductCategory', N'U') IS NOT NULL
    BEGIN
        SET @PRDCT_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDCT_FV_table_status = N'FAILED';
        SET @PRDCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PRDCT_FV_pk_actual_name     sysname;
    DECLARE @PRDCT_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PRDCT_FV_pk_data_space      sysname;


    SELECT
        @PRDCT_FV_pk_actual_name = kc.name,
        @PRDCT_FV_pk_data_space = ds.name,

        @PRDCT_FV_pk_actual_columns =
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
            OBJECT_ID(N'catalog.ProductCategory')

    AND kc.type = N'PK';


    IF @PRDCT_FV_pk_actual_name = N'PK_PRDCT'
    AND @PRDCT_FV_pk_actual_columns = N'PRDCT_PRD_id|PRDCT_CTG_id'
    AND @PRDCT_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @PRDCT_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDCT_FV_primary_key_status = N'FAILED';
        SET @PRDCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PRDCT_FV_expected_column_count int = 2;
    DECLARE @PRDCT_FV_actual_column_count   int;


    SELECT
        @PRDCT_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'catalog.ProductCategory');


    IF @PRDCT_FV_actual_column_count =
            @PRDCT_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'catalog.ProductCategory')

        AND c.name = N'PRDCT_PRD_id'
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
                OBJECT_ID(N'catalog.ProductCategory')

        AND c.name = N'PRDCT_CTG_id'
        AND t.name = N'smallint'
        AND c.max_length = 2
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )
    BEGIN
        SET @PRDCT_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDCT_FV_columns_status = N'FAILED';
        SET @PRDCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PRDCT_FV_expected_documentation TABLE
    (
        PRDCT_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PRDCT_doc_object_type           nvarchar(10) NOT NULL,
        PRDCT_doc_column_name           sysname NULL,
        PRDCT_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @PRDCT_FV_doc_current_id        tinyint;
    DECLARE @PRDCT_FV_doc_max_id            tinyint;
    DECLARE @PRDCT_FV_doc_object_type       nvarchar(10);
    DECLARE @PRDCT_FV_doc_column_name       sysname;
    DECLARE @PRDCT_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PRDCT_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PRDCT_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            catalog.ProductCategory.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @PRDCT_FV_expected_documentation
    (
        PRDCT_doc_object_type,
        PRDCT_doc_column_name,
        PRDCT_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Associates products with the catalog categories in which they are classified.'
    ),
    (
        N'COLUMN',
        N'PRDCT_PRD_id',
        N'Foreign key referencing catalog.Product.'
    ),
    (
        N'COLUMN',
        N'PRDCT_CTG_id',
        N'Foreign key referencing catalog.Category.'
    );


    SELECT
        @PRDCT_FV_doc_current_id =
            MIN(PRDCT_doc_id),

        @PRDCT_FV_doc_max_id =
            MAX(PRDCT_doc_id)

    FROM @PRDCT_FV_expected_documentation;


    WHILE @PRDCT_FV_doc_current_id <=
        @PRDCT_FV_doc_max_id
    BEGIN

        SET @PRDCT_FV_doc_object_type = NULL;
        SET @PRDCT_FV_doc_column_name = NULL;
        SET @PRDCT_FV_doc_expected_value = NULL;
        SET @PRDCT_FV_doc_actual_value = NULL;


        SELECT
            @PRDCT_FV_doc_object_type =
                PRDCT_doc_object_type,

            @PRDCT_FV_doc_column_name =
                PRDCT_doc_column_name,

            @PRDCT_FV_doc_expected_value =
                PRDCT_doc_expected_description

        FROM @PRDCT_FV_expected_documentation

        WHERE PRDCT_doc_id =
                @PRDCT_FV_doc_current_id;


        IF @PRDCT_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @PRDCT_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'catalog.ProductCategory')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @PRDCT_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'catalog.ProductCategory')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @PRDCT_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @PRDCT_FV_doc_actual_value,
            N''
        )
        <>
        @PRDCT_FV_doc_expected_value
        BEGIN

            SET @PRDCT_FV_invalid_documentation += 1;

        END;


        SET @PRDCT_FV_doc_current_id += 1;

    END;


    IF @PRDCT_FV_invalid_documentation = 0
    BEGIN
        SET @PRDCT_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDCT_FV_documentation_status = N'FAILED';
        SET @PRDCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PRDCT_FV_invalid_foreign_keys int = 0;


    /*--------------------------------------------------------------------------
        FK_PRDCT_PRD
    --------------------------------------------------------------------------*/

    DECLARE @PRDCT_FV_fk1_actual_name                sysname;
    DECLARE @PRDCT_FV_fk1_parent_columns             nvarchar(4000);
    DECLARE @PRDCT_FV_fk1_referenced_columns         nvarchar(4000);
    DECLARE @PRDCT_FV_fk1_referenced_schema          sysname;
    DECLARE @PRDCT_FV_fk1_referenced_table           sysname;
    DECLARE @PRDCT_FV_fk1_delete_action              nvarchar(60);
    DECLARE @PRDCT_FV_fk1_update_action              nvarchar(60);
    DECLARE @PRDCT_FV_fk1_is_disabled                bit;
    DECLARE @PRDCT_FV_fk1_is_not_trusted             bit;


    SELECT
        @PRDCT_FV_fk1_actual_name = fk.name,

        @PRDCT_FV_fk1_referenced_schema =
            OBJECT_SCHEMA_NAME(fk.referenced_object_id),

        @PRDCT_FV_fk1_referenced_table =
            OBJECT_NAME(fk.referenced_object_id),

        @PRDCT_FV_fk1_delete_action =
            fk.delete_referential_action_desc,

        @PRDCT_FV_fk1_update_action =
            fk.update_referential_action_desc,

        @PRDCT_FV_fk1_is_disabled =
            fk.is_disabled,

        @PRDCT_FV_fk1_is_not_trusted =
            fk.is_not_trusted,

        @PRDCT_FV_fk1_parent_columns =
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

        @PRDCT_FV_fk1_referenced_columns =
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
            OBJECT_ID(N'catalog.ProductCategory')

    AND fk.name =
            N'FK_PRDCT_PRD';


    IF NOT
    (
        @PRDCT_FV_fk1_actual_name = N'FK_PRDCT_PRD'
        AND @PRDCT_FV_fk1_parent_columns = N'PRDCT_PRD_id'
        AND @PRDCT_FV_fk1_referenced_schema = N'catalog'
        AND @PRDCT_FV_fk1_referenced_table = N'Product'
        AND @PRDCT_FV_fk1_referenced_columns = N'PRD_id'
        AND @PRDCT_FV_fk1_delete_action = N'NO_ACTION'
        AND @PRDCT_FV_fk1_update_action = N'NO_ACTION'
        AND @PRDCT_FV_fk1_is_disabled = 0
        AND @PRDCT_FV_fk1_is_not_trusted = 0
    )
    BEGIN

        SET @PRDCT_FV_invalid_foreign_keys += 1;

    END;


    /*--------------------------------------------------------------------------
        FK_PRDCT_CTG
    --------------------------------------------------------------------------*/

    DECLARE @PRDCT_FV_fk2_actual_name                sysname;
    DECLARE @PRDCT_FV_fk2_parent_columns             nvarchar(4000);
    DECLARE @PRDCT_FV_fk2_referenced_columns         nvarchar(4000);
    DECLARE @PRDCT_FV_fk2_referenced_schema          sysname;
    DECLARE @PRDCT_FV_fk2_referenced_table           sysname;
    DECLARE @PRDCT_FV_fk2_delete_action              nvarchar(60);
    DECLARE @PRDCT_FV_fk2_update_action              nvarchar(60);
    DECLARE @PRDCT_FV_fk2_is_disabled                bit;
    DECLARE @PRDCT_FV_fk2_is_not_trusted             bit;


    SELECT
        @PRDCT_FV_fk2_actual_name = fk.name,

        @PRDCT_FV_fk2_referenced_schema =
            OBJECT_SCHEMA_NAME(fk.referenced_object_id),

        @PRDCT_FV_fk2_referenced_table =
            OBJECT_NAME(fk.referenced_object_id),

        @PRDCT_FV_fk2_delete_action =
            fk.delete_referential_action_desc,

        @PRDCT_FV_fk2_update_action =
            fk.update_referential_action_desc,

        @PRDCT_FV_fk2_is_disabled =
            fk.is_disabled,

        @PRDCT_FV_fk2_is_not_trusted =
            fk.is_not_trusted,

        @PRDCT_FV_fk2_parent_columns =
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

        @PRDCT_FV_fk2_referenced_columns =
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
            OBJECT_ID(N'catalog.ProductCategory')

    AND fk.name =
            N'FK_PRDCT_CTG';


    IF NOT
    (
        @PRDCT_FV_fk2_actual_name = N'FK_PRDCT_CTG'
        AND @PRDCT_FV_fk2_parent_columns = N'PRDCT_CTG_id'
        AND @PRDCT_FV_fk2_referenced_schema = N'catalog'
        AND @PRDCT_FV_fk2_referenced_table = N'Category'
        AND @PRDCT_FV_fk2_referenced_columns = N'CTG_id'
        AND @PRDCT_FV_fk2_delete_action = N'NO_ACTION'
        AND @PRDCT_FV_fk2_update_action = N'NO_ACTION'
        AND @PRDCT_FV_fk2_is_disabled = 0
        AND @PRDCT_FV_fk2_is_not_trusted = 0
    )
    BEGIN

        SET @PRDCT_FV_invalid_foreign_keys += 1;

    END;


    IF @PRDCT_FV_invalid_foreign_keys = 0
    BEGIN
        SET @PRDCT_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDCT_FV_foreign_keys_status = N'FAILED';
        SET @PRDCT_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @PRDCT_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PRDCT_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PRDCT_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PRDCT_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PRDCT_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PRDCT_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PRDCT_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PRDCT_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PRDCT_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PRDCT_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @PRDCT_FV_temporal_integrity_status;
    PRINT N'';

    IF @PRDCT_FV_validation_errors = 0
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
                @PRDCT_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @PRDCT_FV_validation_errors > 0
    BEGIN

        ;THROW 50410,
            N'Final validation failed for catalog.ProductCategory.',
            1;

    END;