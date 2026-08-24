    PRINT N'    ● catalog.ProductVariantPrice';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PRDVP_FV_validation_errors int = 0;

    DECLARE @PRDVP_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVP_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVP_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVP_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVP_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @PRDVP_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVP_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVP_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PRDVP_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVP_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PRDVP_FV_temporal_integrity_status  nvarchar(20) = N'NOT VALIDATED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariantPrice', N'U') IS NOT NULL
    BEGIN
        SET @PRDVP_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PRDVP_FV_table_status = N'FAILED';
        SET @PRDVP_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PRDVP_FV_pk_actual_name     sysname;
    DECLARE @PRDVP_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PRDVP_FV_pk_data_space      sysname;


    SELECT
        @PRDVP_FV_pk_actual_name =
            kc.name,

        @PRDVP_FV_pk_data_space =
            ds.name,

        @PRDVP_FV_pk_actual_columns =
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
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND kc.type = N'PK';


    IF @PRDVP_FV_pk_actual_name = N'PK_PRDVP'
    AND @PRDVP_FV_pk_actual_columns = N'PRDVP_id'
    AND @PRDVP_FV_pk_data_space = N'FG_CORE'
    BEGIN

        SET @PRDVP_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @PRDVP_FV_primary_key_status = N'FAILED';
        SET @PRDVP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PRDVP_FV_expected_column_count int = 6;
    DECLARE @PRDVP_FV_actual_column_count   int;


    SELECT
        @PRDVP_FV_actual_column_count =
            COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'catalog.ProductVariantPrice');


    IF @PRDVP_FV_actual_column_count =
            @PRDVP_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND c.name = N'PRDVP_id'
        AND t.name = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.identity_columns AS ic

        WHERE ic.object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ic.name = N'PRDVP_id'
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
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND c.name = N'PRDVP_PRDVA_id'
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
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND c.name = N'PRDVP_price'
        AND t.name = N'decimal'
        AND c.precision = 19
        AND c.scale = 2
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND c.name = N'PRDVP_valid_from'
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
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND c.name = N'PRDVP_valid_to'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 1
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.columns AS c

        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id

        WHERE c.object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND c.name = N'PRDVP_created_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN

        SET @PRDVP_FV_columns_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @PRDVP_FV_columns_status = N'FAILED';
        SET @PRDVP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PRDVP_FV_expected_documentation TABLE
    (
        PRDVP_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PRDVP_doc_object_type           nvarchar(10) NOT NULL,
        PRDVP_doc_column_name           sysname NULL,
        PRDVP_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @PRDVP_FV_doc_current_id        tinyint;
    DECLARE @PRDVP_FV_doc_max_id            tinyint;
    DECLARE @PRDVP_FV_doc_object_type       nvarchar(10);
    DECLARE @PRDVP_FV_doc_column_name       sysname;
    DECLARE @PRDVP_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PRDVP_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PRDVP_FV_invalid_documentation int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION

        IMPORTANT:
            These descriptions intentionally match
            catalog.ProductVariantPrice.Documentation.sql.
    --------------------------------------------------------------------------*/

    INSERT INTO @PRDVP_FV_expected_documentation
    (
        PRDVP_doc_object_type,
        PRDVP_doc_column_name,
        PRDVP_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the price history and temporal validity of sellable product variants in the Atlas Commerce catalog without overwriting prior commercial prices.'
    ),
    (
        N'COLUMN',
        N'PRDVP_id',
        N'Primary key of catalog.ProductVariantPrice.'
    ),
    (
        N'COLUMN',
        N'PRDVP_PRDVA_id',
        N'Foreign key referencing catalog.ProductVariant.'
    ),
    (
        N'COLUMN',
        N'PRDVP_price',
        N'Stores the commercial price applicable to the product variant during the validity interval represented by the row.'
    ),
    (
        N'COLUMN',
        N'PRDVP_valid_from',
        N'Defines the inclusive lower boundary of the period during which the price becomes applicable to the product variant.'
    ),
    (
        N'COLUMN',
        N'PRDVP_valid_to',
        N'Defines the exclusive upper boundary of the price validity interval. NULL represents an open-ended period with no defined end date.'
    ),
    (
        N'COLUMN',
        N'PRDVP_created_at',
        N'Records the date and time when the row was created.'
    );


    SELECT
        @PRDVP_FV_doc_current_id =
            MIN(PRDVP_doc_id),

        @PRDVP_FV_doc_max_id =
            MAX(PRDVP_doc_id)

    FROM @PRDVP_FV_expected_documentation;


    WHILE @PRDVP_FV_doc_current_id <=
        @PRDVP_FV_doc_max_id
    BEGIN

        SET @PRDVP_FV_doc_object_type = NULL;
        SET @PRDVP_FV_doc_column_name = NULL;
        SET @PRDVP_FV_doc_expected_value = NULL;
        SET @PRDVP_FV_doc_actual_value = NULL;


        SELECT
            @PRDVP_FV_doc_object_type =
                PRDVP_doc_object_type,

            @PRDVP_FV_doc_column_name =
                PRDVP_doc_column_name,

            @PRDVP_FV_doc_expected_value =
                PRDVP_doc_expected_description

        FROM @PRDVP_FV_expected_documentation

        WHERE PRDVP_doc_id =
                @PRDVP_FV_doc_current_id;


        IF @PRDVP_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @PRDVP_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @PRDVP_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON  c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id =
                    OBJECT_ID(N'catalog.ProductVariantPrice')
            AND ep.name = N'MS_Description'
            AND c.name =
                    @PRDVP_FV_doc_column_name;

        END;


        IF ISNULL
        (
            @PRDVP_FV_doc_actual_value,
            N''
        )
        <>
        @PRDVP_FV_doc_expected_value
        BEGIN

            SET @PRDVP_FV_invalid_documentation += 1;

        END;


        SET @PRDVP_FV_doc_current_id += 1;

    END;


    IF @PRDVP_FV_invalid_documentation = 0
    BEGIN

        SET @PRDVP_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @PRDVP_FV_documentation_status = N'FAILED';
        SET @PRDVP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PRDVP_FV_default_actual_name         sysname;
    DECLARE @PRDVP_FV_default_actual_definition   nvarchar(4000);
    DECLARE @PRDVP_FV_default_normalized          nvarchar(4000);


    SELECT
        @PRDVP_FV_default_actual_name =
            dc.name,

        @PRDVP_FV_default_actual_definition =
            dc.definition

    FROM sys.default_constraints AS dc

    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

    WHERE dc.parent_object_id =
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND c.name =
            N'PRDVP_created_at';


    SET @PRDVP_FV_default_normalized =
        LOWER
        (
            REPLACE
            (
                REPLACE
                (
                    REPLACE
                    (
                        @PRDVP_FV_default_actual_definition,
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


    IF @PRDVP_FV_default_actual_name =
            N'DF_PRDVP_created_at'

    AND @PRDVP_FV_default_normalized =
            N'sysdatetime'
    BEGIN

        SET @PRDVP_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @PRDVP_FV_defaults_status = N'FAILED';
        SET @PRDVP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        CHECK CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PRDVP_FV_expected_checks TABLE
    (
        PRDVP_check_id                    tinyint IDENTITY(1,1) NOT NULL,
        PRDVP_check_name                  sysname NOT NULL,
        PRDVP_check_expected_definition   nvarchar(4000) NOT NULL
    );


    DECLARE @PRDVP_FV_check_current_id          tinyint;
    DECLARE @PRDVP_FV_check_max_id              tinyint;
    DECLARE @PRDVP_FV_check_expected_name       sysname;
    DECLARE @PRDVP_FV_check_expected_definition nvarchar(4000);
    DECLARE @PRDVP_FV_check_actual_name         sysname;
    DECLARE @PRDVP_FV_check_actual_definition   nvarchar(4000);
    DECLARE @PRDVP_FV_check_actual_normalized   nvarchar(4000);
    DECLARE @PRDVP_FV_check_is_disabled         bit;
    DECLARE @PRDVP_FV_check_is_not_trusted      bit;
    DECLARE @PRDVP_FV_invalid_checks            int = 0;


    INSERT INTO @PRDVP_FV_expected_checks
    (
        PRDVP_check_name,
        PRDVP_check_expected_definition
    )
    VALUES
    (
        N'CK_PRDVP_price',
        N'prdvp_price>0.00'
    ),
    (
        N'CK_PRDVP_valid_period',
        N'prdvp_valid_toisnullorprdvp_valid_to>prdvp_valid_from'
    );


    SELECT
        @PRDVP_FV_check_current_id =
            MIN(PRDVP_check_id),

        @PRDVP_FV_check_max_id =
            MAX(PRDVP_check_id)

    FROM @PRDVP_FV_expected_checks;


    WHILE @PRDVP_FV_check_current_id <=
        @PRDVP_FV_check_max_id
    BEGIN

        SET @PRDVP_FV_check_expected_name = NULL;
        SET @PRDVP_FV_check_expected_definition = NULL;
        SET @PRDVP_FV_check_actual_name = NULL;
        SET @PRDVP_FV_check_actual_definition = NULL;
        SET @PRDVP_FV_check_actual_normalized = NULL;
        SET @PRDVP_FV_check_is_disabled = NULL;
        SET @PRDVP_FV_check_is_not_trusted = NULL;


        SELECT
            @PRDVP_FV_check_expected_name =
                PRDVP_check_name,

            @PRDVP_FV_check_expected_definition =
                PRDVP_check_expected_definition

        FROM @PRDVP_FV_expected_checks

        WHERE PRDVP_check_id =
                @PRDVP_FV_check_current_id;


        SELECT
            @PRDVP_FV_check_actual_name =
                cc.name,

            @PRDVP_FV_check_actual_definition =
                cc.definition,

            @PRDVP_FV_check_is_disabled =
                cc.is_disabled,

            @PRDVP_FV_check_is_not_trusted =
                cc.is_not_trusted

        FROM sys.check_constraints AS cc

        WHERE cc.parent_object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND cc.name =
                @PRDVP_FV_check_expected_name;


        SET @PRDVP_FV_check_actual_normalized =
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
                                        @PRDVP_FV_check_actual_definition,
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


        IF @PRDVP_FV_check_actual_name IS NULL
        OR @PRDVP_FV_check_actual_normalized <>
                @PRDVP_FV_check_expected_definition
        OR @PRDVP_FV_check_is_disabled <> 0
        OR @PRDVP_FV_check_is_not_trusted <> 0
        BEGIN

            SET @PRDVP_FV_invalid_checks += 1;

        END;


        SET @PRDVP_FV_check_current_id += 1;

    END;


    IF @PRDVP_FV_invalid_checks = 0
    BEGIN

        SET @PRDVP_FV_checks_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @PRDVP_FV_checks_status = N'FAILED';
        SET @PRDVP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PRDVP_FV_fk_actual_name                sysname;
    DECLARE @PRDVP_FV_fk_parent_columns             nvarchar(4000);
    DECLARE @PRDVP_FV_fk_referenced_columns         nvarchar(4000);
    DECLARE @PRDVP_FV_fk_referenced_schema          sysname;
    DECLARE @PRDVP_FV_fk_referenced_table           sysname;
    DECLARE @PRDVP_FV_fk_delete_action              nvarchar(60);
    DECLARE @PRDVP_FV_fk_update_action              nvarchar(60);
    DECLARE @PRDVP_FV_fk_is_disabled                bit;
    DECLARE @PRDVP_FV_fk_is_not_trusted             bit;


    SELECT
        @PRDVP_FV_fk_actual_name =
            fk.name,

        @PRDVP_FV_fk_referenced_schema =
            OBJECT_SCHEMA_NAME(fk.referenced_object_id),

        @PRDVP_FV_fk_referenced_table =
            OBJECT_NAME(fk.referenced_object_id),

        @PRDVP_FV_fk_delete_action =
            fk.delete_referential_action_desc,

        @PRDVP_FV_fk_update_action =
            fk.update_referential_action_desc,

        @PRDVP_FV_fk_is_disabled =
            fk.is_disabled,

        @PRDVP_FV_fk_is_not_trusted =
            fk.is_not_trusted,

        @PRDVP_FV_fk_parent_columns =
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
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id
        ),

        @PRDVP_FV_fk_referenced_columns =
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
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND fk.name =
            N'FK_PRDVP_PRDVA';


    IF @PRDVP_FV_fk_actual_name =
            N'FK_PRDVP_PRDVA'

    AND @PRDVP_FV_fk_parent_columns =
            N'PRDVP_PRDVA_id'

    AND @PRDVP_FV_fk_referenced_schema =
            N'catalog'

    AND @PRDVP_FV_fk_referenced_table =
            N'ProductVariant'

    AND @PRDVP_FV_fk_referenced_columns =
            N'PRDVA_id'

    AND @PRDVP_FV_fk_delete_action =
            N'NO_ACTION'

    AND @PRDVP_FV_fk_update_action =
            N'NO_ACTION'

    AND @PRDVP_FV_fk_is_disabled = 0

    AND @PRDVP_FV_fk_is_not_trusted = 0
    BEGIN

        SET @PRDVP_FV_foreign_keys_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @PRDVP_FV_foreign_keys_status = N'FAILED';
        SET @PRDVP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        ADDITIONAL INDEXES VALIDATION
    ==========================================================================*/

    DECLARE @PRDVP_FV_invalid_indexes int = 0;


    /*--------------------------------------------------------------------------
        INDEX: UX_PRDVP_open_period
    --------------------------------------------------------------------------*/

    DECLARE @PRDVP_FV_open_index_name              sysname;
    DECLARE @PRDVP_FV_open_index_type              tinyint;
    DECLARE @PRDVP_FV_open_index_is_unique         bit;
    DECLARE @PRDVP_FV_open_index_is_disabled       bit;
    DECLARE @PRDVP_FV_open_index_has_filter        bit;
    DECLARE @PRDVP_FV_open_index_filter            nvarchar(4000);
    DECLARE @PRDVP_FV_open_index_normalized_filter nvarchar(4000);
    DECLARE @PRDVP_FV_open_index_columns           nvarchar(4000);
    DECLARE @PRDVP_FV_open_index_includes          nvarchar(4000);
    DECLARE @PRDVP_FV_open_index_data_space        sysname;


    SELECT
        @PRDVP_FV_open_index_name =
            i.name,

        @PRDVP_FV_open_index_type =
            i.type,

        @PRDVP_FV_open_index_is_unique =
            i.is_unique,

        @PRDVP_FV_open_index_is_disabled =
            i.is_disabled,

        @PRDVP_FV_open_index_has_filter =
            i.has_filter,

        @PRDVP_FV_open_index_filter =
            i.filter_definition,

        @PRDVP_FV_open_index_data_space =
            ds.name,

        @PRDVP_FV_open_index_columns =
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

            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ),

        @PRDVP_FV_open_index_includes =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY ic.index_column_id
                )

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

    WHERE i.object_id =
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND i.name =
            N'UX_PRDVP_open_period';


    SET @PRDVP_FV_open_index_normalized_filter =
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
                                    @PRDVP_FV_open_index_filter,
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


    IF @PRDVP_FV_open_index_name <> N'UX_PRDVP_open_period'
    OR @PRDVP_FV_open_index_type <> 2
    OR @PRDVP_FV_open_index_is_unique <> 1
    OR @PRDVP_FV_open_index_is_disabled <> 0
    OR @PRDVP_FV_open_index_has_filter <> 1
    OR @PRDVP_FV_open_index_normalized_filter <>
            N'prdvp_valid_toisnull'
    OR @PRDVP_FV_open_index_columns <>
            N'PRDVP_PRDVA_id'
    OR @PRDVP_FV_open_index_includes IS NOT NULL
    OR @PRDVP_FV_open_index_data_space <>
            N'FG_CORE'
    BEGIN

        SET @PRDVP_FV_invalid_indexes += 1;

    END;


    /*--------------------------------------------------------------------------
        INDEX: IX_PRDVP_PRDVA_valid_from
    --------------------------------------------------------------------------*/

    DECLARE @PRDVP_FV_hist_index_name          sysname;
    DECLARE @PRDVP_FV_hist_index_type          tinyint;
    DECLARE @PRDVP_FV_hist_index_is_unique     bit;
    DECLARE @PRDVP_FV_hist_index_is_disabled   bit;
    DECLARE @PRDVP_FV_hist_index_has_filter    bit;
    DECLARE @PRDVP_FV_hist_index_columns       nvarchar(4000);
    DECLARE @PRDVP_FV_hist_index_includes      nvarchar(4000);
    DECLARE @PRDVP_FV_hist_index_data_space    sysname;


    SELECT
        @PRDVP_FV_hist_index_name =
            i.name,

        @PRDVP_FV_hist_index_type =
            i.type,

        @PRDVP_FV_hist_index_is_unique =
            i.is_unique,

        @PRDVP_FV_hist_index_is_disabled =
            i.is_disabled,

        @PRDVP_FV_hist_index_has_filter =
            i.has_filter,

        @PRDVP_FV_hist_index_data_space =
            ds.name,

        @PRDVP_FV_hist_index_columns =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT
                    (
                        nvarchar(max),

                        c.name
                        + CASE
                            WHEN ic.is_descending_key = 1
                                THEN N' DESC'
                            ELSE N' ASC'
                        END
                    ),
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

            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ),

        @PRDVP_FV_hist_index_includes =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY ic.index_column_id
                )

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

    WHERE i.object_id =
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND i.name =
            N'IX_PRDVP_PRDVA_valid_from';


    IF @PRDVP_FV_hist_index_name <>
            N'IX_PRDVP_PRDVA_valid_from'

    OR @PRDVP_FV_hist_index_type <> 2

    OR @PRDVP_FV_hist_index_is_unique <> 0

    OR @PRDVP_FV_hist_index_is_disabled <> 0

    OR @PRDVP_FV_hist_index_has_filter <> 0

    OR @PRDVP_FV_hist_index_columns <>
            N'PRDVP_PRDVA_id ASC|PRDVP_valid_from DESC'

    OR @PRDVP_FV_hist_index_includes <>
            N'PRDVP_valid_to|PRDVP_price'

    OR @PRDVP_FV_hist_index_data_space <>
            N'FG_CORE'
    BEGIN

        SET @PRDVP_FV_invalid_indexes += 1;

    END;


    IF @PRDVP_FV_invalid_indexes = 0
    BEGIN

        SET @PRDVP_FV_indexes_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @PRDVP_FV_indexes_status = N'FAILED';
        SET @PRDVP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        TEMPORAL INTEGRITY VALIDATION
    ==========================================================================*/

    DECLARE @PRDVP_FV_ti_actual_name             sysname;
    DECLARE @PRDVP_FV_ti_parent                  nvarchar(517);
    DECLARE @PRDVP_FV_ti_is_disabled             bit;
    DECLARE @PRDVP_FV_ti_is_instead_of           bit;
    DECLARE @PRDVP_FV_ti_definition              nvarchar(max);
    DECLARE @PRDVP_FV_ti_normalized_definition   nvarchar(max);

    DECLARE @PRDVP_FV_ti_insert_event             bit = 0;
    DECLARE @PRDVP_FV_ti_update_event             bit = 0;
    DECLARE @PRDVP_FV_ti_delete_event             bit = 0;


    SELECT
        @PRDVP_FV_ti_actual_name =
            tr.name,

        @PRDVP_FV_ti_parent =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(tr.parent_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(tr.parent_id)
            ),

        @PRDVP_FV_ti_is_disabled =
            tr.is_disabled,

        @PRDVP_FV_ti_is_instead_of =
            tr.is_instead_of_trigger,

        @PRDVP_FV_ti_definition =
            OBJECT_DEFINITION(tr.object_id)

    FROM sys.triggers AS tr

    WHERE tr.parent_id =
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND tr.name =
            N'TR_PRDVP_no_overlap';


    IF EXISTS
    (
        SELECT 1

        FROM sys.trigger_events AS te

        INNER JOIN sys.triggers AS tr
            ON tr.object_id = te.object_id

        WHERE tr.parent_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND tr.name =
                N'TR_PRDVP_no_overlap'

        AND te.type_desc =
                N'INSERT'
    )
    BEGIN

        SET @PRDVP_FV_ti_insert_event = 1;

    END;


    IF EXISTS
    (
        SELECT 1

        FROM sys.trigger_events AS te

        INNER JOIN sys.triggers AS tr
            ON tr.object_id = te.object_id

        WHERE tr.parent_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND tr.name =
                N'TR_PRDVP_no_overlap'

        AND te.type_desc =
                N'UPDATE'
    )
    BEGIN

        SET @PRDVP_FV_ti_update_event = 1;

    END;


    IF EXISTS
    (
        SELECT 1

        FROM sys.trigger_events AS te

        INNER JOIN sys.triggers AS tr
            ON tr.object_id = te.object_id

        WHERE tr.parent_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND tr.name =
                N'TR_PRDVP_no_overlap'

        AND te.type_desc =
                N'DELETE'
    )
    BEGIN

        SET @PRDVP_FV_ti_delete_event = 1;

    END;


    SET @PRDVP_FV_ti_normalized_definition =
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
                            @PRDVP_FV_ti_definition,
                            N' ',
                            N''
                        ),
                        NCHAR(9),
                        N''
                    ),
                    NCHAR(13),
                    N''
                ),
                NCHAR(10),
                N''
            )
        );


    IF @PRDVP_FV_ti_actual_name =
            N'TR_PRDVP_no_overlap'

    AND @PRDVP_FV_ti_parent =
            N'[catalog].[ProductVariantPrice]'

    AND @PRDVP_FV_ti_is_disabled = 0

    AND @PRDVP_FV_ti_is_instead_of = 0

    AND @PRDVP_FV_ti_insert_event = 1

    AND @PRDVP_FV_ti_update_event = 1

    AND @PRDVP_FV_ti_delete_event = 0

    /* Concurrency protection */
    AND @PRDVP_FV_ti_normalized_definition LIKE
            N'%updlock%'

    AND @PRDVP_FV_ti_normalized_definition LIKE
            N'%holdlock%'

    AND @PRDVP_FV_ti_normalized_definition LIKE
            N'%index(ix_prdvp_prdva_valid_from)%'

    /* Set-based handling */
    AND @PRDVP_FV_ti_normalized_definition LIKE
            N'%frominserted%'

    /* Open-ended interval support */
    AND @PRDVP_FV_ti_normalized_definition LIKE
            N'%prdvp_valid_toisnull%'

    /* Temporal overlap comparison */
    AND @PRDVP_FV_ti_normalized_definition LIKE
            N'%prdvp_valid_from<b.prdvp_valid_to%'

    AND @PRDVP_FV_ti_normalized_definition LIKE
            N'%b.prdvp_valid_from<a.prdvp_valid_to%'

    /* Expected business error */
    AND @PRDVP_FV_ti_normalized_definition LIKE
            N'%throw50534%'
    BEGIN

        SET @PRDVP_FV_temporal_integrity_status =
            N'VALID';

    END
    ELSE
    BEGIN

        SET @PRDVP_FV_temporal_integrity_status =
            N'FAILED';

        SET @PRDVP_FV_validation_errors += 1;

    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @PRDVP_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PRDVP_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PRDVP_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PRDVP_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PRDVP_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PRDVP_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PRDVP_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PRDVP_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PRDVP_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PRDVP_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @PRDVP_FV_temporal_integrity_status;
    PRINT N'';

    IF @PRDVP_FV_validation_errors = 0
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
                @PRDVP_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @PRDVP_FV_validation_errors > 0
    BEGIN

        ;THROW 50540,
            N'Final validation failed for catalog.ProductVariantPrice.',
            1;

    END;