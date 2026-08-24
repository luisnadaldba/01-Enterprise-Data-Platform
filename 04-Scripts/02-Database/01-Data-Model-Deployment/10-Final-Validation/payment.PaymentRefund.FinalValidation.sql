    PRINT N'    ● payment.PaymentRefund';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @PAYRF_FV_validation_errors int = 0;

    DECLARE @PAYRF_FV_table_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYRF_FV_primary_key_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYRF_FV_columns_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYRF_FV_documentation_status      nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYRF_FV_seed_data_status          nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @PAYRF_FV_defaults_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYRF_FV_checks_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYRF_FV_uniques_status            nvarchar(20) = N'NOT REQUIRED';
    DECLARE @PAYRF_FV_foreign_keys_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYRF_FV_indexes_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @PAYRF_FV_refund_integrity_status   nvarchar(20) = N'NOT VALIDATED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'payment.PaymentRefund', N'U') IS NOT NULL
    BEGIN
        SET @PAYRF_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYRF_FV_table_status = N'FAILED';
        SET @PAYRF_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @PAYRF_FV_pk_actual_name     sysname;
    DECLARE @PAYRF_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @PAYRF_FV_pk_data_space      sysname;


    SELECT
        @PAYRF_FV_pk_actual_name = kc.name,
        @PAYRF_FV_pk_data_space = ds.name,

        @PAYRF_FV_pk_actual_columns =
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), c.name), N'|')
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

    WHERE kc.parent_object_id =
            OBJECT_ID(N'payment.PaymentRefund')

    AND kc.type = N'PK';


    IF @PAYRF_FV_pk_actual_name = N'PK_PAYRF'
    AND @PAYRF_FV_pk_actual_columns = N'PAYRF_id'
    AND @PAYRF_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @PAYRF_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYRF_FV_primary_key_status = N'FAILED';
        SET @PAYRF_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @PAYRF_FV_expected_column_count int = 7;
    DECLARE @PAYRF_FV_actual_column_count   int;


    SELECT
        @PAYRF_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'payment.PaymentRefund');


    IF @PAYRF_FV_actual_column_count = @PAYRF_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_id'
        AND TYPE_NAME(c.user_type_id) = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND ic.name = N'PAYRF_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_PAY_id'
        AND TYPE_NAME(c.user_type_id) = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_PAYRR_id'
        AND TYPE_NAME(c.user_type_id) = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_amount'
        AND TYPE_NAME(c.user_type_id) = N'decimal'
        AND c.precision = 19
        AND c.scale = 2
        AND c.is_nullable = 0
        AND c.is_identity = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_refunded_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_created_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        WHERE c.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_updated_at'
        AND TYPE_NAME(c.user_type_id) = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @PAYRF_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYRF_FV_columns_status = N'FAILED';
        SET @PAYRF_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @PAYRF_FV_expected_documentation TABLE
    (
        PAYRF_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        PAYRF_doc_object_type           nvarchar(10) NOT NULL,
        PAYRF_doc_column_name           sysname NULL,
        PAYRF_doc_expected_description  nvarchar(4000) NOT NULL
    );


    DECLARE @PAYRF_FV_doc_current_id        tinyint;
    DECLARE @PAYRF_FV_doc_max_id            tinyint;
    DECLARE @PAYRF_FV_doc_object_type       nvarchar(10);
    DECLARE @PAYRF_FV_doc_column_name       sysname;
    DECLARE @PAYRF_FV_doc_expected_value    nvarchar(4000);
    DECLARE @PAYRF_FV_doc_actual_value      nvarchar(4000);
    DECLARE @PAYRF_FV_invalid_documentation int = 0;


    INSERT INTO @PAYRF_FV_expected_documentation
    (
        PAYRF_doc_object_type,
        PAYRF_doc_column_name,
        PAYRF_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Records full and partial refund events associated with Atlas Commerce payments, including the refunded amount, standardized refund reason and refund business-event timestamp.'
    ),
    (
        N'COLUMN',
        N'PAYRF_id',
        N'Primary key of payment.PaymentRefund.'
    ),
    (
        N'COLUMN',
        N'PAYRF_PAY_id',
        N'Foreign key referencing payment.Payment.'
    ),
    (
        N'COLUMN',
        N'PAYRF_PAYRR_id',
        N'Foreign key referencing payment.PaymentRefundReason.'
    ),
    (
        N'COLUMN',
        N'PAYRF_amount',
        N'Stores the monetary amount associated with the individual refund event.'
    ),
    (
        N'COLUMN',
        N'PAYRF_refunded_at',
        N'Records the date and time when the refund event occurred.'
    ),
    (
        N'COLUMN',
        N'PAYRF_created_at',
        N'Records the date and time when the row was created.'
    ),
    (
        N'COLUMN',
        N'PAYRF_updated_at',
        N'Records the date and time when the row was last updated.'
    );


    SELECT
        @PAYRF_FV_doc_current_id = MIN(PAYRF_doc_id),
        @PAYRF_FV_doc_max_id = MAX(PAYRF_doc_id)

    FROM @PAYRF_FV_expected_documentation;


    WHILE @PAYRF_FV_doc_current_id <= @PAYRF_FV_doc_max_id
    BEGIN

        SET @PAYRF_FV_doc_object_type = NULL;
        SET @PAYRF_FV_doc_column_name = NULL;
        SET @PAYRF_FV_doc_expected_value = NULL;
        SET @PAYRF_FV_doc_actual_value = NULL;


        SELECT
            @PAYRF_FV_doc_object_type = PAYRF_doc_object_type,
            @PAYRF_FV_doc_column_name = PAYRF_doc_column_name,
            @PAYRF_FV_doc_expected_value = PAYRF_doc_expected_description

        FROM @PAYRF_FV_expected_documentation

        WHERE PAYRF_doc_id = @PAYRF_FV_doc_current_id;


        IF @PAYRF_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @PAYRF_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'payment.PaymentRefund')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @PAYRF_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON c.object_id = ep.major_id
                AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'payment.PaymentRefund')
            AND ep.name = N'MS_Description'
            AND c.name = @PAYRF_FV_doc_column_name;

        END;


        IF ISNULL(@PAYRF_FV_doc_actual_value, N'') <>
            @PAYRF_FV_doc_expected_value
        BEGIN

            SET @PAYRF_FV_invalid_documentation += 1;

        END;


        SET @PAYRF_FV_doc_current_id += 1;

    END;


    IF @PAYRF_FV_invalid_documentation = 0
    BEGIN
        SET @PAYRF_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYRF_FV_documentation_status = N'FAILED';
        SET @PAYRF_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @PAYRF_FV_invalid_defaults int = 0;


    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_created_at'
        AND dc.name = N'DF_PAYRF_created_at'
        AND LOWER
        (
            REPLACE
            (
                REPLACE
                (
                    REPLACE(dc.definition, N'(', N''),
                    N')',
                    N''
                ),
                N' ',
                N''
            )
        ) = N'sysdatetime'
    )
    BEGIN
        SET @PAYRF_FV_invalid_defaults += 1;
    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_updated_at'
        AND dc.name = N'DF_PAYRF_updated_at'
        AND LOWER
        (
            REPLACE
            (
                REPLACE
                (
                    REPLACE(dc.definition, N'(', N''),
                    N')',
                    N''
                ),
                N' ',
                N''
            )
        ) = N'sysdatetime'
    )
    BEGIN
        SET @PAYRF_FV_invalid_defaults += 1;
    END;


    IF @PAYRF_FV_invalid_defaults = 0
    BEGIN
        SET @PAYRF_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYRF_FV_defaults_status = N'FAILED';
        SET @PAYRF_FV_validation_errors += 1;
    END;


    /*==========================================================================
        CHECK CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PAYRF_FV_check_definition   nvarchar(4000);
    DECLARE @PAYRF_FV_check_normalized   nvarchar(4000);
    DECLARE @PAYRF_FV_check_disabled     bit;
    DECLARE @PAYRF_FV_check_not_trusted  bit;


    SELECT
        @PAYRF_FV_check_definition = cc.definition,
        @PAYRF_FV_check_disabled = cc.is_disabled,
        @PAYRF_FV_check_not_trusted = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'payment.PaymentRefund')

    AND cc.name =
            N'CK_PAYRF_amount';


    SET @PAYRF_FV_check_normalized =
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
                            @PAYRF_FV_check_definition,
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


    IF @PAYRF_FV_check_definition IS NOT NULL
    AND @PAYRF_FV_check_normalized LIKE N'%payrf_amount>(0)%'
    AND @PAYRF_FV_check_disabled = 0
    AND @PAYRF_FV_check_not_trusted = 0
    BEGIN
        SET @PAYRF_FV_checks_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYRF_FV_checks_status = N'FAILED';
        SET @PAYRF_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @PAYRF_FV_invalid_foreign_keys int = 0;


    /*--------------------------------------------------------------------------
        FK_PAYRF_PAY
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND fk.referenced_object_id =
                OBJECT_ID(N'payment.Payment')

        AND fk.name =
                N'FK_PAYRF_PAY'

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
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'PAYRF_PAY_id'

            AND rc.name =
                    N'PAY_id'
        )
    )
    BEGIN
        SET @PAYRF_FV_invalid_foreign_keys += 1;
    END;


    /*--------------------------------------------------------------------------
        FK_PAYRF_PAYRR
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND fk.referenced_object_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND fk.name =
                N'FK_PAYRF_PAYRR'

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
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'PAYRF_PAYRR_id'

            AND rc.name =
                    N'PAYRR_id'
        )
    )
    BEGIN
        SET @PAYRF_FV_invalid_foreign_keys += 1;
    END;


    /*--------------------------------------------------------------------------
        ENSURE EXACT EXPECTED FOREIGN KEY COUNT
    --------------------------------------------------------------------------*/

    IF
    (
        SELECT COUNT(*)

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'payment.PaymentRefund')
    ) <> 2
    BEGIN
        SET @PAYRF_FV_invalid_foreign_keys += 1;
    END;


    IF @PAYRF_FV_invalid_foreign_keys = 0
    BEGIN
        SET @PAYRF_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYRF_FV_foreign_keys_status = N'FAILED';
        SET @PAYRF_FV_validation_errors += 1;
    END;


    /*==========================================================================
        ADDITIONAL INDEX VALIDATION
    ==========================================================================*/

    DECLARE @PAYRF_FV_invalid_indexes int = 0;


    /*--------------------------------------------------------------------------
        IX_PAYRF_PAY
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND i.name =
                N'IX_PAYRF_PAY'

        AND i.type = 2
        AND i.is_unique = 0
        AND i.is_disabled = 0
        AND i.is_hypothetical = 0
        AND i.has_filter = 0
        AND ds.name = N'FG_CORE'

        AND
        (
            SELECT COUNT(*)

            FROM sys.index_columns AS ic

            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ) = 2

        AND
        (
            SELECT COUNT(*)

            FROM sys.index_columns AS ic

            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
        ) = 1

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
            AND c.name = N'PAYRF_PAY_id'
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
            AND ic.is_descending_key = 0
            AND c.name = N'PAYRF_refunded_at'
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
            AND ic.is_included_column = 1
            AND c.name = N'PAYRF_amount'
        )
    )
    BEGIN
        SET @PAYRF_FV_invalid_indexes += 1;
    END;


    /*--------------------------------------------------------------------------
        IX_PAYRF_updated_at
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND i.name =
                N'IX_PAYRF_updated_at'

        AND i.type = 2
        AND i.is_unique = 0
        AND i.is_disabled = 0
        AND i.is_hypothetical = 0
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
            AND c.name = N'PAYRF_updated_at'
        )
    )
    BEGIN
        SET @PAYRF_FV_invalid_indexes += 1;
    END;


    IF @PAYRF_FV_invalid_indexes = 0
    BEGIN
        SET @PAYRF_FV_indexes_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYRF_FV_indexes_status = N'FAILED';
        SET @PAYRF_FV_validation_errors += 1;
    END;


    /*==========================================================================
        REFUND INTEGRITY VALIDATION
    ==========================================================================*/

    DECLARE @PAYRF_FV_trigger_definition        nvarchar(max);
    DECLARE @PAYRF_FV_trigger_normalized        nvarchar(max);
    DECLARE @PAYRF_FV_trigger_is_disabled       bit;
    DECLARE @PAYRF_FV_trigger_is_instead_of     bit;


    SELECT
        @PAYRF_FV_trigger_definition =
            OBJECT_DEFINITION(tr.object_id),

        @PAYRF_FV_trigger_is_disabled =
            tr.is_disabled,

        @PAYRF_FV_trigger_is_instead_of =
            tr.is_instead_of_trigger

    FROM sys.triggers AS tr

    WHERE tr.parent_id =
            OBJECT_ID(N'payment.PaymentRefund')

    AND tr.name =
            N'TR_PAYRF_refund_integrity';


    SET @PAYRF_FV_trigger_normalized =
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
                            @PAYRF_FV_trigger_definition,
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


    IF @PAYRF_FV_trigger_definition IS NOT NULL
    AND @PAYRF_FV_trigger_is_disabled = 0
    AND @PAYRF_FV_trigger_is_instead_of = 0

    AND @PAYRF_FV_trigger_normalized LIKE
            N'%afterinsert,update%'

    AND @PAYRF_FV_trigger_normalized LIKE
            N'%payrf_refunded_at<p.pay_attempted_at%'

    AND @PAYRF_FV_trigger_normalized LIKE
            N'%refundedamount>convert(decimal(38,2),p.pay_amount)%'

    AND @PAYRF_FV_trigger_normalized LIKE
            N'%updlock%'

    AND @PAYRF_FV_trigger_normalized LIKE
            N'%holdlock%'

    AND @PAYRF_FV_trigger_normalized LIKE
            N'%ix_payrf_pay%'
    BEGIN
        SET @PAYRF_FV_refund_integrity_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @PAYRF_FV_refund_integrity_status = N'FAILED';
        SET @PAYRF_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @PAYRF_FV_table_status;
    PRINT N'        Primary Key                   : ' + @PAYRF_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @PAYRF_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @PAYRF_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @PAYRF_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @PAYRF_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @PAYRF_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @PAYRF_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @PAYRF_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @PAYRF_FV_indexes_status;
    PRINT N'        Refund Integrity              : ' + @PAYRF_FV_refund_integrity_status;
    PRINT N'';

    IF @PAYRF_FV_validation_errors = 0
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
                @PAYRF_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @PAYRF_FV_validation_errors > 0
    BEGIN

        ;THROW 51040,
            N'Final validation failed for payment.PaymentRefund.',
            1;

    END;