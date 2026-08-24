    PRINT N'    ● sales.TransactionItem';

    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @TRNIT_FV_validation_errors int = 0;

    DECLARE @TRNIT_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNIT_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNIT_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNIT_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNIT_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @TRNIT_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNIT_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNIT_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @TRNIT_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNIT_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @TRNIT_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';

    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'sales.TransactionItem', N'U') IS NOT NULL
    BEGIN
        SET @TRNIT_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNIT_FV_table_status = N'FAILED';
        SET @TRNIT_FV_validation_errors = @TRNIT_FV_validation_errors + 1;
    END;

    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @TRNIT_FV_pk_actual_name     sysname;
    DECLARE @TRNIT_FV_pk_actual_columns  nvarchar(4000);

    SELECT
        @TRNIT_FV_pk_actual_name =
            kc.name,

        @TRNIT_FV_pk_actual_columns =
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
            OBJECT_ID(N'sales.TransactionItem')

    AND kc.type = N'PK';


    IF @TRNIT_FV_pk_actual_columns =
        N'TRNIT_id|TRNIT_transaction_at'
    BEGIN

        SET @TRNIT_FV_primary_key_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRNIT_FV_primary_key_status = N'FAILED';
        SET @TRNIT_FV_validation_errors =
            @TRNIT_FV_validation_errors + 1;

    END;

    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @TRNIT_FV_expected_column_count int = 9;
    DECLARE @TRNIT_FV_actual_column_count   int;

    SELECT @TRNIT_FV_actual_column_count = COUNT(*)
    FROM sys.columns
    WHERE object_id = OBJECT_ID(N'sales.TransactionItem');

    IF @TRNIT_FV_actual_column_count = @TRNIT_FV_expected_column_count
    AND EXISTS (SELECT 1 FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id WHERE c.object_id=OBJECT_ID(N'sales.TransactionItem') AND c.name=N'TRNIT_id' AND t.name=N'bigint' AND c.max_length=8 AND c.is_nullable=0 AND c.is_identity=1)
    AND EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id=OBJECT_ID(N'sales.TransactionItem') AND name=N'TRNIT_id' AND CONVERT(bigint,seed_value)=1 AND CONVERT(bigint,increment_value)=1)
    AND EXISTS (SELECT 1 FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id WHERE c.object_id=OBJECT_ID(N'sales.TransactionItem') AND c.name=N'TRNIT_transaction_at' AND t.name=N'datetime2' AND c.scale=0 AND c.is_nullable=0)
    AND EXISTS (SELECT 1 FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id WHERE c.object_id=OBJECT_ID(N'sales.TransactionItem') AND c.name=N'TRNIT_TRN_id' AND t.name=N'bigint' AND c.max_length=8 AND c.is_nullable=0)
    AND EXISTS (SELECT 1 FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id WHERE c.object_id=OBJECT_ID(N'sales.TransactionItem') AND c.name=N'TRNIT_PRDVA_id' AND t.name=N'int' AND c.max_length=4 AND c.is_nullable=0)
    AND EXISTS (SELECT 1 FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id WHERE c.object_id=OBJECT_ID(N'sales.TransactionItem') AND c.name=N'TRNIT_quantity' AND t.name=N'int' AND c.max_length=4 AND c.is_nullable=0)
    AND EXISTS (SELECT 1 FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id WHERE c.object_id=OBJECT_ID(N'sales.TransactionItem') AND c.name=N'TRNIT_unit_price' AND t.name=N'decimal' AND c.precision=19 AND c.scale=2 AND c.is_nullable=0)
    AND EXISTS (SELECT 1 FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id WHERE c.object_id=OBJECT_ID(N'sales.TransactionItem') AND c.name=N'TRNIT_unit_discount' AND t.name=N'decimal' AND c.precision=19 AND c.scale=2 AND c.is_nullable=0)
    AND EXISTS (SELECT 1 FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id WHERE c.object_id=OBJECT_ID(N'sales.TransactionItem') AND c.name=N'TRNIT_created_at' AND t.name=N'datetime2' AND c.scale=0 AND c.is_nullable=0)
    AND EXISTS (SELECT 1 FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id WHERE c.object_id=OBJECT_ID(N'sales.TransactionItem') AND c.name=N'TRNIT_updated_at' AND t.name=N'datetime2' AND c.scale=0 AND c.is_nullable=0)
        SET @TRNIT_FV_columns_status = N'VALID';
    ELSE
    BEGIN
        SET @TRNIT_FV_columns_status = N'FAILED';
        SET @TRNIT_FV_validation_errors = @TRNIT_FV_validation_errors + 1;
    END;

    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @TRNIT_FV_expected_documentation TABLE
    (
        TRNIT_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        TRNIT_doc_object_type           nvarchar(10)           NOT NULL,
        TRNIT_doc_column_name           sysname                NULL,
        TRNIT_doc_expected_description  nvarchar(4000)         NOT NULL
    );

    DECLARE @TRNIT_FV_doc_current_id          tinyint;
    DECLARE @TRNIT_FV_doc_max_id              tinyint;

    DECLARE @TRNIT_FV_doc_object_type         nvarchar(10);
    DECLARE @TRNIT_FV_doc_column_name         sysname;

    DECLARE @TRNIT_FV_doc_expected_value      nvarchar(4000);
    DECLARE @TRNIT_FV_doc_actual_value        nvarchar(4000);

    DECLARE @TRNIT_FV_invalid_documentation   int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DOCUMENTATION DEFINITIONS
    --------------------------------------------------------------------------*/

    INSERT INTO @TRNIT_FV_expected_documentation
    (
        TRNIT_doc_object_type,
        TRNIT_doc_column_name,
        TRNIT_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the individual product items associated with sales transactions in Atlas Commerce, including product variant, quantity, unit price, unit discount, and the originating transaction timestamp.'
    ),
    (
        N'COLUMN',
        N'TRNIT_id',
        N'Primary key of sales.TransactionItem.'
    ),
    (
        N'COLUMN',
        N'TRNIT_transaction_at',
        N'Records the date and time of the parent sales transaction and supports aligned partitioning with sales.Transaction.'
    ),
    (
        N'COLUMN',
        N'TRNIT_TRN_id',
        N'Foreign key referencing sales.Transaction.'
    ),
    (
        N'COLUMN',
        N'TRNIT_PRDVA_id',
        N'Foreign key referencing catalog.ProductVariant.'
    ),
    (
        N'COLUMN',
        N'TRNIT_quantity',
        N'Stores the quantity of the product variant included in the transaction item.'
    ),
    (
        N'COLUMN',
        N'TRNIT_unit_price',
        N'Stores the unit price of the product variant recorded for the transaction item.'
    ),
    (
        N'COLUMN',
        N'TRNIT_unit_discount',
        N'Stores the unit discount applied to the product variant for the transaction item.'
    ),
    (
        N'COLUMN',
        N'TRNIT_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'TRNIT_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @TRNIT_FV_doc_current_id = MIN(TRNIT_doc_id),
        @TRNIT_FV_doc_max_id     = MAX(TRNIT_doc_id)
    FROM @TRNIT_FV_expected_documentation;


    /*--------------------------------------------------------------------------
        VALIDATE DOCUMENTATION CONTENT
    --------------------------------------------------------------------------*/

    WHILE @TRNIT_FV_doc_current_id <= @TRNIT_FV_doc_max_id
    BEGIN

        SET @TRNIT_FV_doc_object_type     = NULL;
        SET @TRNIT_FV_doc_column_name     = NULL;
        SET @TRNIT_FV_doc_expected_value  = NULL;
        SET @TRNIT_FV_doc_actual_value    = NULL;


        SELECT
            @TRNIT_FV_doc_object_type =
                TRNIT_doc_object_type,

            @TRNIT_FV_doc_column_name =
                TRNIT_doc_column_name,

            @TRNIT_FV_doc_expected_value =
                TRNIT_doc_expected_description

        FROM @TRNIT_FV_expected_documentation
        WHERE TRNIT_doc_id = @TRNIT_FV_doc_current_id;


        /*----------------------------------------------------------------------
            TABLE DESCRIPTION
        ----------------------------------------------------------------------*/

        IF @TRNIT_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @TRNIT_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'sales.TransactionItem')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END


        /*----------------------------------------------------------------------
            COLUMN DESCRIPTION
        ----------------------------------------------------------------------*/

        ELSE IF @TRNIT_FV_doc_object_type = N'COLUMN'
        BEGIN

            SELECT
                @TRNIT_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.columns AS c

            LEFT JOIN sys.extended_properties AS ep
                ON  ep.class = 1
                AND ep.major_id = c.object_id
                AND ep.minor_id = c.column_id
                AND ep.name = N'MS_Description'

            WHERE c.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

            AND c.name =
                    @TRNIT_FV_doc_column_name;

        END;


        IF @TRNIT_FV_doc_actual_value IS NULL
        OR @TRNIT_FV_doc_actual_value <> @TRNIT_FV_doc_expected_value
        BEGIN

            SET @TRNIT_FV_invalid_documentation =
                @TRNIT_FV_invalid_documentation + 1;

        END;


        SET @TRNIT_FV_doc_current_id =
            @TRNIT_FV_doc_current_id + 1;

    END;


    /*--------------------------------------------------------------------------
        FINAL DOCUMENTATION STATUS
    --------------------------------------------------------------------------*/

    IF @TRNIT_FV_invalid_documentation = 0
    BEGIN

        SET @TRNIT_FV_documentation_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRNIT_FV_documentation_status = N'FAILED';

        SET @TRNIT_FV_validation_errors =
            @TRNIT_FV_validation_errors + 1;

    END;

    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @TRNIT_FV_expected_defaults TABLE
    (
        TRNIT_default_id                   tinyint IDENTITY(1,1) NOT NULL,
        TRNIT_default_column_name          sysname                NOT NULL,
        TRNIT_default_constraint_name      sysname                NOT NULL,
        TRNIT_default_expected_definition  nvarchar(4000)         NOT NULL
    );

    DECLARE @TRNIT_FV_default_current_id          tinyint;
    DECLARE @TRNIT_FV_default_max_id              tinyint;

    DECLARE @TRNIT_FV_default_column_name         sysname;
    DECLARE @TRNIT_FV_default_expected_name       sysname;
    DECLARE @TRNIT_FV_default_actual_name         sysname;

    DECLARE @TRNIT_FV_default_expected_definition nvarchar(4000);
    DECLARE @TRNIT_FV_default_actual_definition   nvarchar(4000);

    DECLARE @TRNIT_FV_invalid_defaults            int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED DEFAULT CONSTRAINT DEFINITIONS
    --------------------------------------------------------------------------*/

    INSERT INTO @TRNIT_FV_expected_defaults
    (
        TRNIT_default_column_name,
        TRNIT_default_constraint_name,
        TRNIT_default_expected_definition
    )
    VALUES
    (N'TRNIT_unit_discount', N'DF_TRNIT_unit_discount', N'((0.00))'),
    (N'TRNIT_created_at', N'DF_TRNIT_created_at', N'(sysdatetime())'),
    (N'TRNIT_updated_at', N'DF_TRNIT_updated_at', N'(sysdatetime())');


    SELECT
        @TRNIT_FV_default_current_id = MIN(TRNIT_default_id),
        @TRNIT_FV_default_max_id     = MAX(TRNIT_default_id)
    FROM @TRNIT_FV_expected_defaults;


    /*--------------------------------------------------------------------------
        VALIDATE DEFAULT CONSTRAINTS
    --------------------------------------------------------------------------*/

    WHILE @TRNIT_FV_default_current_id <= @TRNIT_FV_default_max_id
    BEGIN

        SET @TRNIT_FV_default_column_name         = NULL;
        SET @TRNIT_FV_default_expected_name       = NULL;
        SET @TRNIT_FV_default_actual_name         = NULL;
        SET @TRNIT_FV_default_expected_definition = NULL;
        SET @TRNIT_FV_default_actual_definition   = NULL;


        SELECT
            @TRNIT_FV_default_column_name =
                TRNIT_default_column_name,

            @TRNIT_FV_default_expected_name =
                TRNIT_default_constraint_name,

            @TRNIT_FV_default_expected_definition =
                TRNIT_default_expected_definition

        FROM @TRNIT_FV_expected_defaults
        WHERE TRNIT_default_id = @TRNIT_FV_default_current_id;


        SELECT
            @TRNIT_FV_default_actual_name =
                dc.name,

            @TRNIT_FV_default_actual_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND c.name =
                @TRNIT_FV_default_column_name;


        IF @TRNIT_FV_default_actual_name IS NULL
        OR @TRNIT_FV_default_actual_name <> @TRNIT_FV_default_expected_name
        OR @TRNIT_FV_default_actual_definition IS NULL
        OR LOWER(REPLACE(REPLACE(@TRNIT_FV_default_actual_definition, N' ', N''), N'(', N''))
            <> LOWER(REPLACE(REPLACE(@TRNIT_FV_default_expected_definition, N' ', N''), N'(', N''))
        BEGIN

            SET @TRNIT_FV_invalid_defaults =
                @TRNIT_FV_invalid_defaults + 1;

        END;


        SET @TRNIT_FV_default_current_id =
            @TRNIT_FV_default_current_id + 1;

    END;


    /*--------------------------------------------------------------------------
        FINAL DEFAULT CONSTRAINT STATUS
    --------------------------------------------------------------------------*/

    IF @TRNIT_FV_invalid_defaults = 0
    BEGIN

        SET @TRNIT_FV_defaults_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRNIT_FV_defaults_status = N'FAILED';

        SET @TRNIT_FV_validation_errors =
            @TRNIT_FV_validation_errors + 1;

    END;

    /*==========================================================================
        CHECK CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @TRNIT_FV_expected_checks TABLE
    (
        TRNIT_check_id                    tinyint IDENTITY(1,1) NOT NULL,
        TRNIT_check_constraint_name       sysname                NOT NULL,
        TRNIT_check_expected_definition   nvarchar(4000)         NOT NULL
    );

    DECLARE @TRNIT_FV_check_current_id          tinyint;
    DECLARE @TRNIT_FV_check_max_id              tinyint;

    DECLARE @TRNIT_FV_check_expected_name       sysname;
    DECLARE @TRNIT_FV_check_actual_name         sysname;

    DECLARE @TRNIT_FV_check_expected_definition nvarchar(4000);
    DECLARE @TRNIT_FV_check_actual_definition   nvarchar(4000);

    DECLARE @TRNIT_FV_check_is_disabled         bit;
    DECLARE @TRNIT_FV_check_is_not_trusted      bit;

    DECLARE @TRNIT_FV_invalid_checks            int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED CHECK CONSTRAINT DEFINITIONS
    --------------------------------------------------------------------------*/

    INSERT INTO @TRNIT_FV_expected_checks
    (
        TRNIT_check_constraint_name,
        TRNIT_check_expected_definition
    )
    VALUES
    (N'CK_TRNIT_quantity', N'TRNIT_quantity>0'),
    (N'CK_TRNIT_unit_price', N'TRNIT_unit_price>=0.00'),
    (N'CK_TRNIT_unit_discount', N'TRNIT_unit_discount>=0.00'),
    (N'CK_TRNIT_discount_not_greater_than_price', N'TRNIT_unit_discount<=TRNIT_unit_price');


    SELECT
        @TRNIT_FV_check_current_id = MIN(TRNIT_check_id),
        @TRNIT_FV_check_max_id     = MAX(TRNIT_check_id)
    FROM @TRNIT_FV_expected_checks;


    /*--------------------------------------------------------------------------
        VALIDATE CHECK CONSTRAINTS
    --------------------------------------------------------------------------*/

    WHILE @TRNIT_FV_check_current_id <= @TRNIT_FV_check_max_id
    BEGIN

        SET @TRNIT_FV_check_expected_name       = NULL;
        SET @TRNIT_FV_check_actual_name         = NULL;

        SET @TRNIT_FV_check_expected_definition = NULL;
        SET @TRNIT_FV_check_actual_definition   = NULL;

        SET @TRNIT_FV_check_is_disabled         = NULL;
        SET @TRNIT_FV_check_is_not_trusted      = NULL;


        SELECT
            @TRNIT_FV_check_expected_name =
                TRNIT_check_constraint_name,

            @TRNIT_FV_check_expected_definition =
                TRNIT_check_expected_definition

        FROM @TRNIT_FV_expected_checks
        WHERE TRNIT_check_id = @TRNIT_FV_check_current_id;


        SELECT
            @TRNIT_FV_check_actual_name =
                cc.name,

            @TRNIT_FV_check_actual_definition =
                cc.definition,

            @TRNIT_FV_check_is_disabled =
                cc.is_disabled,

            @TRNIT_FV_check_is_not_trusted =
                cc.is_not_trusted

        FROM sys.check_constraints AS cc

        WHERE cc.parent_object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND cc.name =
                @TRNIT_FV_check_expected_name;


        /*----------------------------------------------------------------------
            NORMALIZE AND VALIDATE
        ----------------------------------------------------------------------*/

        IF @TRNIT_FV_check_actual_name IS NULL
        OR @TRNIT_FV_check_actual_definition IS NULL

        OR LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            REPLACE
                            (
                                @TRNIT_FV_check_actual_definition,
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
                )
            )
            <>
            LOWER
            (
                REPLACE
                (
                    @TRNIT_FV_check_expected_definition,
                    N' ',
                    N''
                )
            )

        OR @TRNIT_FV_check_is_disabled <> 0
        OR @TRNIT_FV_check_is_not_trusted <> 0
        BEGIN

            SET @TRNIT_FV_invalid_checks =
                @TRNIT_FV_invalid_checks + 1;

        END;


        SET @TRNIT_FV_check_current_id =
            @TRNIT_FV_check_current_id + 1;

    END;


    /*--------------------------------------------------------------------------
        FINAL CHECK CONSTRAINT STATUS
    --------------------------------------------------------------------------*/

    IF @TRNIT_FV_invalid_checks = 0
    BEGIN

        SET @TRNIT_FV_checks_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRNIT_FV_checks_status = N'FAILED';

        SET @TRNIT_FV_validation_errors =
            @TRNIT_FV_validation_errors + 1;

    END;


    /*==========================================================================
        FOREIGN KEY VALIDATION
    ==========================================================================*/

    DECLARE @TRNIT_FV_invalid_foreign_keys int = 0;

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
        AND fk.referenced_object_id = OBJECT_ID(N'sales.Transaction')
        AND fk.name = N'FK_TRNIT_TRN'
        AND fk.delete_referential_action_desc = N'CASCADE'
        AND fk.update_referential_action_desc = N'NO_ACTION'
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
            AND pc.name = N'TRNIT_TRN_id'
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
            AND pc.name = N'TRNIT_transaction_at'
            AND rc.name = N'TRN_transaction_at'
        )
    )
    BEGIN
        SET @TRNIT_FV_invalid_foreign_keys =
            @TRNIT_FV_invalid_foreign_keys + 1;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
        AND fk.referenced_object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND fk.name = N'FK_TRNIT_PRDVA'
        AND fk.delete_referential_action_desc = N'NO_ACTION'
        AND fk.update_referential_action_desc = N'NO_ACTION'
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
            AND pc.name = N'TRNIT_PRDVA_id'
            AND rc.name = N'PRDVA_id'
        )
    )
    BEGIN
        SET @TRNIT_FV_invalid_foreign_keys =
            @TRNIT_FV_invalid_foreign_keys + 1;
    END;

    IF @TRNIT_FV_invalid_foreign_keys = 0
    BEGIN
        SET @TRNIT_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @TRNIT_FV_foreign_keys_status = N'FAILED';
        SET @TRNIT_FV_validation_errors =
            @TRNIT_FV_validation_errors + 1;
    END;

    /*==========================================================================
        INDEX VALIDATION
    ==========================================================================*/

    DECLARE @TRNIT_FV_expected_indexes TABLE
    (
        TRNIT_index_id                    tinyint IDENTITY(1,1) NOT NULL,
        TRNIT_index_name                  sysname                NOT NULL,
        TRNIT_index_expected_keys         nvarchar(4000)         NOT NULL,
        TRNIT_index_expected_includes     nvarchar(4000)         NOT NULL,
        TRNIT_index_expected_data_space   sysname                NOT NULL,
        TRNIT_index_partition_column      sysname                NOT NULL
    );

    DECLARE @TRNIT_FV_index_current_id          tinyint;
    DECLARE @TRNIT_FV_index_max_id              tinyint;

    DECLARE @TRNIT_FV_index_expected_name       sysname;
    DECLARE @TRNIT_FV_index_expected_keys       nvarchar(4000);
    DECLARE @TRNIT_FV_index_expected_includes   nvarchar(4000);
    DECLARE @TRNIT_FV_index_expected_data_space sysname;
    DECLARE @TRNIT_FV_index_expected_part_col   sysname;

    DECLARE @TRNIT_FV_index_actual_name         sysname;
    DECLARE @TRNIT_FV_index_actual_type         tinyint;
    DECLARE @TRNIT_FV_index_actual_unique       bit;
    DECLARE @TRNIT_FV_index_actual_disabled     bit;
    DECLARE @TRNIT_FV_index_actual_hypothetical bit;

    DECLARE @TRNIT_FV_index_actual_keys         nvarchar(4000);
    DECLARE @TRNIT_FV_index_actual_includes     nvarchar(4000);
    DECLARE @TRNIT_FV_index_actual_data_space   sysname;
    DECLARE @TRNIT_FV_index_actual_part_col     sysname;

    DECLARE @TRNIT_FV_invalid_indexes           int = 0;


    /*--------------------------------------------------------------------------
        EXPECTED INDEX DEFINITIONS
    --------------------------------------------------------------------------*/

    INSERT INTO @TRNIT_FV_expected_indexes
    (
        TRNIT_index_name,
        TRNIT_index_expected_keys,
        TRNIT_index_expected_includes,
        TRNIT_index_expected_data_space,
        TRNIT_index_partition_column
    )
    VALUES
    (N'IX_TRNIT_TRN_transaction_at', N'TRNIT_TRN_id ASC|TRNIT_transaction_at ASC', N'NONE', N'PS_SALES_MONTHLY', N'TRNIT_transaction_at'),
    (N'IX_TRNIT_PRDVA', N'TRNIT_PRDVA_id ASC', N'NONE', N'PS_SALES_MONTHLY', N'TRNIT_transaction_at'),
    (N'IX_TRNIT_updated_at', N'TRNIT_updated_at ASC', N'NONE', N'PS_SALES_MONTHLY', N'TRNIT_transaction_at');


    SELECT
        @TRNIT_FV_index_current_id = MIN(TRNIT_index_id),
        @TRNIT_FV_index_max_id     = MAX(TRNIT_index_id)
    FROM @TRNIT_FV_expected_indexes;


    /*--------------------------------------------------------------------------
        VALIDATE INDEXES
    --------------------------------------------------------------------------*/

    WHILE @TRNIT_FV_index_current_id <= @TRNIT_FV_index_max_id
    BEGIN

        SET @TRNIT_FV_index_expected_name       = NULL;
        SET @TRNIT_FV_index_expected_keys       = NULL;
        SET @TRNIT_FV_index_expected_includes   = NULL;
        SET @TRNIT_FV_index_expected_data_space = NULL;
        SET @TRNIT_FV_index_expected_part_col   = NULL;

        SET @TRNIT_FV_index_actual_name         = NULL;
        SET @TRNIT_FV_index_actual_type         = NULL;
        SET @TRNIT_FV_index_actual_unique       = NULL;
        SET @TRNIT_FV_index_actual_disabled     = NULL;
        SET @TRNIT_FV_index_actual_hypothetical = NULL;

        SET @TRNIT_FV_index_actual_keys         = NULL;
        SET @TRNIT_FV_index_actual_includes     = NULL;
        SET @TRNIT_FV_index_actual_data_space   = NULL;
        SET @TRNIT_FV_index_actual_part_col     = NULL;


        SELECT
            @TRNIT_FV_index_expected_name =
                TRNIT_index_name,

            @TRNIT_FV_index_expected_keys =
                TRNIT_index_expected_keys,

            @TRNIT_FV_index_expected_includes =
                TRNIT_index_expected_includes,

            @TRNIT_FV_index_expected_data_space =
                TRNIT_index_expected_data_space,

            @TRNIT_FV_index_expected_part_col =
                TRNIT_index_partition_column

        FROM @TRNIT_FV_expected_indexes

        WHERE TRNIT_index_id =
            @TRNIT_FV_index_current_id;


        /*----------------------------------------------------------------------
            INDEX METADATA
        ----------------------------------------------------------------------*/

        SELECT
            @TRNIT_FV_index_actual_name =
                i.name,

            @TRNIT_FV_index_actual_type =
                i.type,

            @TRNIT_FV_index_actual_unique =
                i.is_unique,

            @TRNIT_FV_index_actual_disabled =
                i.is_disabled,

            @TRNIT_FV_index_actual_hypothetical =
                i.is_hypothetical,

            @TRNIT_FV_index_actual_data_space =
                ds.name

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND i.name =
                @TRNIT_FV_index_expected_name;


        /*----------------------------------------------------------------------
            ACTUAL KEY COLUMNS
        ----------------------------------------------------------------------*/

        SELECT
            @TRNIT_FV_index_actual_keys =
                STRING_AGG
                (
                    CONVERT
                    (
                        nvarchar(max),
                        c.name
                        +
                        CASE
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

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND i.name =
                @TRNIT_FV_index_expected_name;


        /*----------------------------------------------------------------------
            ACTUAL USER INCLUDE COLUMNS

            The automatically added partition column of IX_TRNIT_updated_at is
            not considered an INCLUDE because SQL Server exposes it with:

                key_ordinal        = 0
                is_included_column = 0
                partition_ordinal  = 1
        ----------------------------------------------------------------------*/

        SELECT
            @TRNIT_FV_index_actual_includes =
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY ic.index_column_id
                )

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND i.name =
                @TRNIT_FV_index_expected_name;


        SET @TRNIT_FV_index_actual_includes =
            COALESCE
            (
                @TRNIT_FV_index_actual_includes,
                N'NONE'
            );


        /*----------------------------------------------------------------------
            ACTUAL PARTITION COLUMN
        ----------------------------------------------------------------------*/

        SELECT
            @TRNIT_FV_index_actual_part_col =
                c.name

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.partition_ordinal = 1

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND i.name =
                @TRNIT_FV_index_expected_name;


        /*----------------------------------------------------------------------
            VALIDATE INDEX CONTRACT
        ----------------------------------------------------------------------*/

        IF @TRNIT_FV_index_actual_name IS NULL

        OR @TRNIT_FV_index_actual_type <> 2
        OR @TRNIT_FV_index_actual_unique <> 0
        OR @TRNIT_FV_index_actual_disabled <> 0
        OR @TRNIT_FV_index_actual_hypothetical <> 0

        OR @TRNIT_FV_index_actual_keys <>
                @TRNIT_FV_index_expected_keys

        OR @TRNIT_FV_index_actual_includes <>
                @TRNIT_FV_index_expected_includes

        OR @TRNIT_FV_index_actual_data_space <>
                @TRNIT_FV_index_expected_data_space

        OR ISNULL(@TRNIT_FV_index_actual_part_col, N'') <>
                @TRNIT_FV_index_expected_part_col
        BEGIN

            SET @TRNIT_FV_invalid_indexes =
                @TRNIT_FV_invalid_indexes + 1;

        END;


        SET @TRNIT_FV_index_current_id =
            @TRNIT_FV_index_current_id + 1;

    END;


    /*--------------------------------------------------------------------------
        FINAL INDEX STATUS
    --------------------------------------------------------------------------*/

    IF @TRNIT_FV_invalid_indexes = 0
    BEGIN

        SET @TRNIT_FV_indexes_status = N'VALID';

    END
    ELSE
    BEGIN

        SET @TRNIT_FV_indexes_status = N'FAILED';

        SET @TRNIT_FV_validation_errors =
            @TRNIT_FV_validation_errors + 1;

    END;

    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @TRNIT_FV_table_status;
    PRINT N'        Primary Key                   : ' + @TRNIT_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @TRNIT_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @TRNIT_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @TRNIT_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @TRNIT_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @TRNIT_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @TRNIT_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @TRNIT_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @TRNIT_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @TRNIT_FV_temporal_integrity_status;
    PRINT N'';

    IF @TRNIT_FV_validation_errors = 0
    BEGIN

        PRINT N'        Result                        : PASSED';

    END
    ELSE
    BEGIN

        PRINT N'        Result                        : FAILED';
        PRINT N'        Validation Errors             : '
            + CONVERT(nvarchar(10), @TRNIT_FV_validation_errors);

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @TRNIT_FV_validation_errors > 0
    BEGIN

        ;THROW 50078,
            N'Final validation failed for sales.TransactionItem.',
            1;

    END;