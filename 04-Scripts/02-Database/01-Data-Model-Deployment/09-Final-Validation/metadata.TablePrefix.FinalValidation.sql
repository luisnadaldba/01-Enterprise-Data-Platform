    PRINT N'    metadata.TablePrefix';
    PRINT N'    --------------------------------------------------------------------------';

    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PFX_validation_errors int = 0;

    DECLARE @PFX_table_status          nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PFX_primary_key_status    nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PFX_columns_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PFX_documentation_status  nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PFX_seed_data_status      nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PFX_defaults_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PFX_checks_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PFX_uniques_status        nvarchar(20) = N'NOT VALIDATED';

    DECLARE @PFX_foreign_keys_status   nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @PFX_indexes_status        nvarchar(20) = N'NOT REQUIRED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'metadata.TablePrefix', N'U') IS NOT NULL
    BEGIN
        SET @PFX_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PFX_table_status = N'FAILED';
        SET @PFX_validation_errors = @PFX_validation_errors + 1;
    END;

    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PFX_pk_actual_name     sysname;
    DECLARE @PFX_pk_actual_columns  nvarchar(4000);

    SELECT
        @PFX_pk_actual_name =
            kc.name,

        @PFX_pk_actual_columns =
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

    WHERE kc.parent_object_id =
            OBJECT_ID(N'metadata.TablePrefix')

      AND kc.type = N'PK';

    IF @PFX_pk_actual_name = N'PK_PFX'
       AND @PFX_pk_actual_columns = N'PFX_id'
    BEGIN
        SET @PFX_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PFX_primary_key_status = N'FAILED';
        SET @PFX_validation_errors = @PFX_validation_errors + 1;
    END;

    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PFX_invalid_columns int = 0;

    /*--------------------------------------------------------------------------
        PFX_id
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.identity_columns AS ic
            ON  ic.object_id = c.object_id
            AND ic.column_id = c.column_id
        WHERE c.object_id = OBJECT_ID(N'metadata.TablePrefix')
          AND c.name = N'PFX_id'
          AND TYPE_NAME(c.user_type_id) = N'smallint'
          AND c.is_nullable = 0
          AND c.is_identity = 1
          AND CONVERT(bigint, ic.seed_value) = 1
          AND CONVERT(bigint, ic.increment_value) = 1
    )
    BEGIN
        SET @PFX_invalid_columns = @PFX_invalid_columns + 1;
    END;

    /*--------------------------------------------------------------------------
        PFX_schema_name
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'metadata.TablePrefix')
          AND c.name = N'PFX_schema_name'
          AND TYPE_NAME(c.user_type_id) = N'sysname'
          AND c.is_nullable = 0
    )
    BEGIN
        SET @PFX_invalid_columns = @PFX_invalid_columns + 1;
    END;

    /*--------------------------------------------------------------------------
        PFX_table_name
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'metadata.TablePrefix')
          AND c.name = N'PFX_table_name'
          AND TYPE_NAME(c.user_type_id) = N'sysname'
          AND c.is_nullable = 0
    )
    BEGIN
        SET @PFX_invalid_columns = @PFX_invalid_columns + 1;
    END;

    /*--------------------------------------------------------------------------
        PFX_prefix
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'metadata.TablePrefix')
          AND c.name = N'PFX_prefix'
          AND TYPE_NAME(c.user_type_id) = N'nvarchar'
          AND c.max_length = 10
          AND c.is_nullable = 0
    )
    BEGIN
        SET @PFX_invalid_columns = @PFX_invalid_columns + 1;
    END;

    /*--------------------------------------------------------------------------
        PFX_is_active
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'metadata.TablePrefix')
          AND c.name = N'PFX_is_active'
          AND TYPE_NAME(c.user_type_id) = N'bit'
          AND c.is_nullable = 0
    )
    BEGIN
        SET @PFX_invalid_columns = @PFX_invalid_columns + 1;
    END;

    /*--------------------------------------------------------------------------
        PFX_created_at
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'metadata.TablePrefix')
          AND c.name = N'PFX_created_at'
          AND TYPE_NAME(c.user_type_id) = N'datetime2'
          AND c.scale = 0
          AND c.is_nullable = 0
    )
    BEGIN
        SET @PFX_invalid_columns = @PFX_invalid_columns + 1;
    END;

    /*--------------------------------------------------------------------------
        PFX_updated_at
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'metadata.TablePrefix')
          AND c.name = N'PFX_updated_at'
          AND TYPE_NAME(c.user_type_id) = N'datetime2'
          AND c.scale = 0
          AND c.is_nullable = 0
    )
    BEGIN
        SET @PFX_invalid_columns = @PFX_invalid_columns + 1;
    END;

    /*--------------------------------------------------------------------------
        COLUMN SET

        The table must contain exactly the seven expected columns.
    --------------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)
        FROM sys.columns
        WHERE object_id = OBJECT_ID(N'metadata.TablePrefix')
    ) <> 7
    BEGIN
        SET @PFX_invalid_columns = @PFX_invalid_columns + 1;
    END;

    /*--------------------------------------------------------------------------
        FINAL COLUMN STATUS
    --------------------------------------------------------------------------*/

    IF @PFX_invalid_columns = 0
    BEGIN
        SET @PFX_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PFX_columns_status = N'FAILED';
        SET @PFX_validation_errors = @PFX_validation_errors + 1;
    END;

    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PFX_expected_documentation TABLE
    (
        PFX_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PFX_doc_object_type           nvarchar(10)           NOT NULL,
        PFX_doc_column_name           sysname                NULL,
        PFX_doc_expected_description  nvarchar(4000)         NOT NULL
    );

    DECLARE @PFX_doc_current_id          tinyint;
    DECLARE @PFX_doc_max_id              tinyint;

    DECLARE @PFX_doc_object_type         nvarchar(10);
    DECLARE @PFX_doc_column_name         sysname;

    DECLARE @PFX_doc_expected_value      nvarchar(4000);
    DECLARE @PFX_doc_actual_value        nvarchar(4000);

    DECLARE @PFX_invalid_documentation   int = 0;

    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION DEFINITIONS
    --------------------------------------------------------------------------*/

    INSERT INTO @PFX_expected_documentation
    (
        PFX_doc_object_type,
        PFX_doc_column_name,
        PFX_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the authoritative registry of table prefixes used to enforce naming consistency, prevent prefix reuse, and preserve prefix assignment history across AtlasCommerce.'
    ),
    (
        N'COLUMN',
        N'PFX_id',
        N'Primary key of metadata.TablePrefix.'
    ),
    (
        N'COLUMN',
        N'PFX_schema_name',
        N'Stores the schema name of the table associated with the registered prefix.'
    ),
    (
        N'COLUMN',
        N'PFX_table_name',
        N'Stores the table name associated with the registered prefix within its owning schema.'
    ),
    (
        N'COLUMN',
        N'PFX_prefix',
        N'Stores the unique and permanently reserved prefix assigned to the registered table for use in its column naming convention.'
    ),
    (
        N'COLUMN',
        N'PFX_is_active',
        N'Indicates whether the registered table prefix is currently active while preserving inactive assignments for historical governance and preventing prefix reuse.'
    ),
    (
        N'COLUMN',
        N'PFX_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'PFX_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );

    SELECT
        @PFX_doc_current_id = MIN(PFX_doc_id),
        @PFX_doc_max_id     = MAX(PFX_doc_id)
    FROM @PFX_expected_documentation;

    /*--------------------------------------------------------------------------
        VALIDATE DOCUMENTATION CONTENT
    --------------------------------------------------------------------------*/

    WHILE @PFX_doc_current_id <= @PFX_doc_max_id
    BEGIN

        SET @PFX_doc_object_type     = NULL;
        SET @PFX_doc_column_name     = NULL;
        SET @PFX_doc_expected_value  = NULL;
        SET @PFX_doc_actual_value    = NULL;

        SELECT
            @PFX_doc_object_type =
                PFX_doc_object_type,

            @PFX_doc_column_name =
                PFX_doc_column_name,

            @PFX_doc_expected_value =
                PFX_doc_expected_description

        FROM @PFX_expected_documentation
        WHERE PFX_doc_id = @PFX_doc_current_id;

        /*----------------------------------------------------------------------
            TABLE DESCRIPTION
        ----------------------------------------------------------------------*/

        IF @PFX_doc_object_type = N'TABLE'
        BEGIN
            SELECT
                @PFX_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
              AND ep.major_id = OBJECT_ID(N'metadata.TablePrefix')
              AND ep.minor_id = 0
              AND ep.name = N'MS_Description';
        END

        /*----------------------------------------------------------------------
            COLUMN DESCRIPTION
        ----------------------------------------------------------------------*/

        ELSE IF @PFX_doc_object_type = N'COLUMN'
        BEGIN
            SELECT
                @PFX_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.columns AS c

            LEFT JOIN sys.extended_properties AS ep
                ON  ep.class = 1
                AND ep.major_id = c.object_id
                AND ep.minor_id = c.column_id
                AND ep.name = N'MS_Description'

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

              AND c.name =
                    @PFX_doc_column_name;
        END;

        /*----------------------------------------------------------------------
            DESCRIPTION MUST EXIST AND MATCH EXPECTED CONTENT
        ----------------------------------------------------------------------*/

        IF @PFX_doc_actual_value IS NULL
           OR @PFX_doc_actual_value COLLATE Latin1_General_100_BIN2
                <>
              @PFX_doc_expected_value COLLATE Latin1_General_100_BIN2
        BEGIN
            SET @PFX_invalid_documentation =
                @PFX_invalid_documentation + 1;
        END;


        SET @PFX_doc_current_id =
            @PFX_doc_current_id + 1;

    END;

    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    DECLARE @PFX_seed_matching_rows int = 0;
    DECLARE @PFX_seed_canonical_rows int = 0;

    /*--------------------------------------------------------------------------
        CANONICAL REGISTRATION

        Expected:
            Schema      : metadata
            Table       : TablePrefix
            Prefix      : PFX
            Active      : 1
    --------------------------------------------------------------------------*/

    SELECT
        @PFX_seed_matching_rows = COUNT(*)
    FROM metadata.TablePrefix
    WHERE PFX_schema_name = N'metadata'
      AND PFX_table_name  = N'TablePrefix';


    SELECT
        @PFX_seed_canonical_rows = COUNT(*)
    FROM metadata.TablePrefix
    WHERE PFX_schema_name = N'metadata'
      AND PFX_table_name  = N'TablePrefix'
      AND PFX_prefix      = N'PFX'
      AND PFX_is_active   = 1;

    /*--------------------------------------------------------------------------
        FINAL SEED DATA STATUS
    --------------------------------------------------------------------------*/

    IF @PFX_seed_matching_rows = 1
       AND @PFX_seed_canonical_rows = 1
    BEGIN
        SET @PFX_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PFX_seed_data_status = N'FAILED';
        SET @PFX_validation_errors = @PFX_validation_errors + 1;
    END;

    /*--------------------------------------------------------------------------
        FINAL DOCUMENTATION STATUS
    --------------------------------------------------------------------------*/

    IF @PFX_invalid_documentation = 0
    BEGIN
        SET @PFX_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PFX_documentation_status = N'FAILED';
        SET @PFX_validation_errors = @PFX_validation_errors + 1;
    END;

    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PFX_df_actual_name        sysname;
    DECLARE @PFX_df_actual_definition  nvarchar(4000);
    DECLARE @PFX_df_actual_column      sysname;
    DECLARE @PFX_df_normalized         nvarchar(4000);


    SELECT
        @PFX_df_actual_name =
            dc.name,

        @PFX_df_actual_definition =
            dc.definition,

        @PFX_df_actual_column =
            c.name

    FROM sys.default_constraints AS dc

    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

    WHERE dc.parent_object_id =
            OBJECT_ID(N'metadata.TablePrefix')

      AND c.name =
            N'PFX_is_active';

    /*--------------------------------------------------------------------------
        NORMALIZE STORED DEFAULT DEFINITION

        SQL Server may persist DEFAULT (1) as ((1)).
    --------------------------------------------------------------------------*/

    SET @PFX_df_normalized =
        REPLACE
        (
            REPLACE
            (
                REPLACE
                (
                    REPLACE
                    (
                        @PFX_df_actual_definition,
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
        );

    /*--------------------------------------------------------------------------
        FINAL DEFAULT CONSTRAINT STATUS
    --------------------------------------------------------------------------*/

    IF @PFX_df_actual_name = N'DF_PFX_is_active'
       AND @PFX_df_actual_column = N'PFX_is_active'
       AND @PFX_df_normalized = N'1'
    BEGIN
        SET @PFX_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PFX_defaults_status = N'FAILED';
        SET @PFX_validation_errors = @PFX_validation_errors + 1;
    END;

    /*==========================================================================
        CHECK CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PFX_invalid_checks int = 0;

    DECLARE @PFX_ck_format_definition nvarchar(4000);
    DECLARE @PFX_ck_format_disabled   bit;
    DECLARE @PFX_ck_format_trusted    bit;

    DECLARE @PFX_ck_length_definition nvarchar(4000);
    DECLARE @PFX_ck_length_disabled   bit;
    DECLARE @PFX_ck_length_trusted    bit;


    /*--------------------------------------------------------------------------
        CK_PFX_prefix_format
    --------------------------------------------------------------------------*/

    SELECT
        @PFX_ck_format_definition = cc.definition,
        @PFX_ck_format_disabled   = cc.is_disabled,
        @PFX_ck_format_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'metadata.TablePrefix')
      AND cc.name = N'CK_PFX_prefix_format';


    IF @PFX_ck_format_definition IS NULL
       OR @PFX_ck_format_definition NOT LIKE
            N'%PFX_prefix%Latin1_General_100_BIN2%[^A-Z]%'
       OR @PFX_ck_format_disabled <> 0
       OR @PFX_ck_format_trusted <> 0
    BEGIN
        SET @PFX_invalid_checks = @PFX_invalid_checks + 1;
    END;


    /*--------------------------------------------------------------------------
        CK_PFX_prefix_length
    --------------------------------------------------------------------------*/

    SELECT
        @PFX_ck_length_definition = cc.definition,
        @PFX_ck_length_disabled   = cc.is_disabled,
        @PFX_ck_length_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'metadata.TablePrefix')
      AND cc.name = N'CK_PFX_prefix_length';


    IF @PFX_ck_length_definition IS NULL
       OR
       (
           @PFX_ck_length_definition NOT LIKE N'%LEN%PFX_prefix%'
           OR @PFX_ck_length_definition NOT LIKE N'%>=%(2)%'
           OR @PFX_ck_length_definition NOT LIKE N'%<=%(5)%'
       )
       OR @PFX_ck_length_disabled <> 0
       OR @PFX_ck_length_trusted <> 0
    BEGIN
        SET @PFX_invalid_checks = @PFX_invalid_checks + 1;
    END;


    /*--------------------------------------------------------------------------
        EXPECTED CHECK CONSTRAINT COUNT
    --------------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)
        FROM sys.check_constraints
        WHERE parent_object_id = OBJECT_ID(N'metadata.TablePrefix')
    ) <> 2
    BEGIN
        SET @PFX_invalid_checks = @PFX_invalid_checks + 1;
    END;

    /*--------------------------------------------------------------------------
        FINAL CHECK CONSTRAINT STATUS
    --------------------------------------------------------------------------*/

    IF @PFX_invalid_checks = 0
    BEGIN
        SET @PFX_checks_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PFX_checks_status = N'FAILED';
        SET @PFX_validation_errors = @PFX_validation_errors + 1;
    END;

    /*==========================================================================
        UNIQUE CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PFX_invalid_uniques int = 0;

    DECLARE @PFX_uq_prefix_columns   nvarchar(4000);
    DECLARE @PFX_uq_prefix_disabled  bit;

    DECLARE @PFX_uq_table_columns    nvarchar(4000);
    DECLARE @PFX_uq_table_disabled   bit;

    /*--------------------------------------------------------------------------
        UQ_PFX_prefix
    --------------------------------------------------------------------------*/

    SELECT
        @PFX_uq_prefix_disabled =
            i.is_disabled,

        @PFX_uq_prefix_columns =
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

    WHERE kc.parent_object_id =
            OBJECT_ID(N'metadata.TablePrefix')

      AND kc.type =
            N'UQ'

      AND kc.name =
            N'UQ_PFX_prefix';


    IF @PFX_uq_prefix_columns IS NULL
       OR @PFX_uq_prefix_columns COLLATE Latin1_General_100_BIN2
            <>
          N'PFX_prefix' COLLATE Latin1_General_100_BIN2
       OR @PFX_uq_prefix_disabled <> 0
    BEGIN
        SET @PFX_invalid_uniques =
            @PFX_invalid_uniques + 1;
    END;

    /*--------------------------------------------------------------------------
        UQ_PFX_table
    --------------------------------------------------------------------------*/

    SELECT
        @PFX_uq_table_disabled =
            i.is_disabled,

        @PFX_uq_table_columns =
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

    WHERE kc.parent_object_id =
            OBJECT_ID(N'metadata.TablePrefix')

      AND kc.type =
            N'UQ'

      AND kc.name =
            N'UQ_PFX_table';


    IF @PFX_uq_table_columns IS NULL
       OR @PFX_uq_table_columns COLLATE Latin1_General_100_BIN2
            <>
          N'PFX_schema_name|PFX_table_name'
            COLLATE Latin1_General_100_BIN2
       OR @PFX_uq_table_disabled <> 0
    BEGIN
        SET @PFX_invalid_uniques =
            @PFX_invalid_uniques + 1;
    END;

    /*--------------------------------------------------------------------------
        EXPECTED UNIQUE CONSTRAINT COUNT
    --------------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)
        FROM sys.key_constraints
        WHERE parent_object_id =
                OBJECT_ID(N'metadata.TablePrefix')
          AND type = N'UQ'
    ) <> 2
    BEGIN
        SET @PFX_invalid_uniques =
            @PFX_invalid_uniques + 1;
    END;

    /*--------------------------------------------------------------------------
        FINAL UNIQUE CONSTRAINT STATUS
    --------------------------------------------------------------------------*/

    IF @PFX_invalid_uniques = 0
    BEGIN
        SET @PFX_uniques_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PFX_uniques_status = N'FAILED';
        SET @PFX_validation_errors =
            @PFX_validation_errors + 1;
    END;

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';
    PRINT N'        Table                         : ' + @PFX_table_status;
    PRINT N'        Primary Key                   : ' + @PFX_primary_key_status;
    PRINT N'        Columns                       : ' + @PFX_columns_status;
    PRINT N'        Object Documentation          : ' + @PFX_documentation_status;
    PRINT N'        Seed Data                     : ' + @PFX_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PFX_defaults_status;
    PRINT N'        Check Constraints             : ' + @PFX_checks_status;
    PRINT N'        Unique Constraints            : ' + @PFX_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PFX_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PFX_indexes_status;
    PRINT N'';

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';

    IF @PFX_validation_errors = 0
    BEGIN
        PRINT N'        Result                         : PASSED';
    END
    ELSE
    BEGIN
        PRINT N'        Result                         : FAILED';
    END;

    PRINT N'';

    IF @PFX_validation_errors > 0
    BEGIN
        ;THROW 50005,
            N'Final validation failed for metadata.TablePrefix.',
            1;
    END;