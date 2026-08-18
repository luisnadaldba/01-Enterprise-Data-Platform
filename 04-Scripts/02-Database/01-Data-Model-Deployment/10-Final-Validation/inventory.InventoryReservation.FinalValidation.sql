    PRINT N'    inventory.InventoryReservation';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @INVRE_FV_validation_errors int = 0;

    DECLARE @INVRE_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRE_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRE_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRE_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRE_FV_seed_data_status           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRE_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRE_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRE_FV_uniques_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRE_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRE_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVRE_FV_temporal_integrity_status  nvarchar(20) = N'NOT VALIDATED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'inventory.InventoryReservation', N'U') IS NOT NULL
    BEGIN
        SET @INVRE_FV_table_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_table_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
    ==========================================================================*/

    DECLARE @INVRE_FV_pk_actual_name     sysname;
    DECLARE @INVRE_FV_pk_actual_columns  nvarchar(4000);
    DECLARE @INVRE_FV_pk_data_space      sysname;


    SELECT
        @INVRE_FV_pk_actual_name = kc.name,
        @INVRE_FV_pk_data_space = ds.name,

        @INVRE_FV_pk_actual_columns =
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
            OBJECT_ID(N'inventory.InventoryReservation')

    AND kc.type = N'PK';


    IF @INVRE_FV_pk_actual_name = N'PK_INVRE'
    AND @INVRE_FV_pk_actual_columns = N'INVRE_id'
    AND @INVRE_FV_pk_data_space = N'FG_CORE'
    BEGIN
        SET @INVRE_FV_primary_key_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_primary_key_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @INVRE_FV_expected_column_count int = 11;
    DECLARE @INVRE_FV_actual_column_count   int;


    SELECT
        @INVRE_FV_actual_column_count = COUNT(*)

    FROM sys.columns

    WHERE object_id =
            OBJECT_ID(N'inventory.InventoryReservation');


    IF @INVRE_FV_actual_column_count = @INVRE_FV_expected_column_count

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_id'
        AND t.name = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
        AND c.is_identity = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.identity_columns AS ic
        WHERE ic.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ic.name = N'INVRE_id'
        AND CONVERT(bigint, ic.seed_value) = 1
        AND CONVERT(bigint, ic.increment_value) = 1
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_TRNIT_id'
        AND t.name = N'bigint'
        AND c.max_length = 8
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_TRNIT_transaction_at'
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
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_PRDVA_id'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_INVRS_id'
        AND t.name = N'tinyint'
        AND c.max_length = 1
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_quantity'
        AND t.name = N'int'
        AND c.max_length = 4
        AND c.is_nullable = 0
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.columns AS c
        INNER JOIN sys.types AS t
            ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_reserved_at'
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
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_expires_at'
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
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_closed_at'
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
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_created_at'
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
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_updated_at'
        AND t.name = N'datetime2'
        AND c.scale = 0
        AND c.is_nullable = 0
    )
    BEGIN
        SET @INVRE_FV_columns_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_columns_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @INVRE_FV_expected_documentation TABLE
    (
        INVRE_doc_id                    tinyint IDENTITY(1,1) NOT NULL,
        INVRE_doc_object_type           nvarchar(10) NOT NULL,
        INVRE_doc_column_name           sysname NULL,
        INVRE_doc_expected_description  nvarchar(4000) NOT NULL
    );


    INSERT INTO @INVRE_FV_expected_documentation
    (
        INVRE_doc_object_type,
        INVRE_doc_column_name,
        INVRE_doc_expected_description
    )
    VALUES
    (
        N'TABLE',
        NULL,
        N'Maintains the current inventory reservation associated with each sales transaction item and its lifecycle in Atlas Commerce.'
    ),
    (
        N'COLUMN',
        N'INVRE_id',
        N'Primary key of inventory.InventoryReservation.'
    ),
    (
        N'COLUMN',
        N'INVRE_TRNIT_id',
        N'Identifier component of the composite foreign key to sales.TransactionItem that owns the reservation.'
    ),
    (
        N'COLUMN',
        N'INVRE_TRNIT_transaction_at',
        N'Transaction date component of the composite foreign key to sales.TransactionItem.'
    ),
    (
        N'COLUMN',
        N'INVRE_PRDVA_id',
        N'Foreign key of catalog.ProductVariant identifying the product variant reserved.'
    ),
    (
        N'COLUMN',
        N'INVRE_INVRS_id',
        N'Foreign key of inventory.InventoryReservationStatus identifying the current reservation status.'
    ),
    (
        N'COLUMN',
        N'INVRE_quantity',
        N'Stores the quantity of usable inventory units committed to the reservation.'
    ),
    (
        N'COLUMN',
        N'INVRE_reserved_at',
        N'Records the date and time when the inventory reservation became effective.'
    ),
    (
        N'COLUMN',
        N'INVRE_expires_at',
        N'Records the date and time when the reservation is expected to expire if it is not consumed or released earlier.'
    ),
    (
        N'COLUMN',
        N'INVRE_closed_at',
        N'Records the date and time when the reservation was consumed, released, or expired; NULL while the reservation remains active.'
    ),
    (
        N'COLUMN',
        N'INVRE_created_at',
        N'Records the date and time when the row was initially created.'
    ),
    (
        N'COLUMN',
        N'INVRE_updated_at',
        N'Records the date and time of the most recent meaningful modification to the row.'
    );


    DECLARE
        @INVRE_FV_doc_current_id        tinyint,
        @INVRE_FV_doc_max_id            tinyint,
        @INVRE_FV_doc_object_type       nvarchar(10),
        @INVRE_FV_doc_column_name       sysname,
        @INVRE_FV_doc_expected_value    nvarchar(4000),
        @INVRE_FV_doc_actual_value      nvarchar(4000),
        @INVRE_FV_invalid_documentation int = 0;


    SELECT
        @INVRE_FV_doc_current_id = MIN(INVRE_doc_id),
        @INVRE_FV_doc_max_id = MAX(INVRE_doc_id)
    FROM @INVRE_FV_expected_documentation;


    WHILE @INVRE_FV_doc_current_id <= @INVRE_FV_doc_max_id
    BEGIN

        SET @INVRE_FV_doc_actual_value = NULL;

        SELECT
            @INVRE_FV_doc_object_type = INVRE_doc_object_type,
            @INVRE_FV_doc_column_name = INVRE_doc_column_name,
            @INVRE_FV_doc_expected_value = INVRE_doc_expected_description
        FROM @INVRE_FV_expected_documentation
        WHERE INVRE_doc_id = @INVRE_FV_doc_current_id;


        IF @INVRE_FV_doc_object_type = N'TABLE'
        BEGIN

            SELECT
                @INVRE_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description';

        END
        ELSE
        BEGIN

            SELECT
                @INVRE_FV_doc_actual_value =
                    CONVERT(nvarchar(4000), ep.value)

            FROM sys.extended_properties AS ep

            INNER JOIN sys.columns AS c
                ON c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

            WHERE ep.class = 1
            AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
            AND ep.name = N'MS_Description'
            AND c.name = @INVRE_FV_doc_column_name;

        END;


        IF ISNULL(@INVRE_FV_doc_actual_value, N'')
            <> @INVRE_FV_doc_expected_value
        BEGIN
            SET @INVRE_FV_invalid_documentation += 1;
        END;


        SET @INVRE_FV_doc_current_id += 1;

    END;


    IF @INVRE_FV_invalid_documentation = 0
    BEGIN
        SET @INVRE_FV_documentation_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_documentation_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
    END;


    /*==========================================================================
        SEED DATA VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1
        FROM metadata.TablePrefix
        WHERE PFX_schema_name = N'inventory'
        AND PFX_table_name = N'InventoryReservation'
        AND PFX_prefix = N'INVRE'
        AND PFX_is_active = 1
    )
    BEGIN
        SET @INVRE_FV_seed_data_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_seed_data_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_created_at'
        AND dc.name = N'DF_INVRE_created_at'
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
    AND EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_updated_at'
        AND dc.name = N'DF_INVRE_updated_at'
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
        SET @INVRE_FV_defaults_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_defaults_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
    END;


    /*==========================================================================
        CHECK CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @INVRE_FV_invalid_checks int = 0;


    /* CK_INVRE_quantity */

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.check_constraints AS cc
        WHERE cc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND cc.name = N'CK_INVRE_quantity'
        AND cc.is_disabled = 0
        AND cc.is_not_trusted = 0
        AND LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            REPLACE(cc.definition, N'[', N''),
                            N']',
                            N''
                        ),
                        N' ',
                        N''
                    ),
                    NCHAR(9),
                    N''
                )
            ) LIKE N'%invre_quantity>(0)%'
    )
    BEGIN
        SET @INVRE_FV_invalid_checks += 1;
    END;


    /* CK_INVRE_expires_at */

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.check_constraints AS cc
        WHERE cc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND cc.name = N'CK_INVRE_expires_at'
        AND cc.is_disabled = 0
        AND cc.is_not_trusted = 0
        AND LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            REPLACE(cc.definition, N'[', N''),
                            N']',
                            N''
                        ),
                        N' ',
                        N''
                    ),
                    NCHAR(9),
                    N''
                )
            ) LIKE N'%invre_expires_at>invre_reserved_at%'
    )
    BEGIN
        SET @INVRE_FV_invalid_checks += 1;
    END;


    /* CK_INVRE_closed_at */

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.check_constraints AS cc
        WHERE cc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND cc.name = N'CK_INVRE_closed_at'
        AND cc.is_disabled = 0
        AND cc.is_not_trusted = 0
        AND LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            REPLACE(cc.definition, N'[', N''),
                            N']',
                            N''
                        ),
                        N' ',
                        N''
                    ),
                    NCHAR(9),
                    N''
                )
            ) LIKE N'%invre_closed_atisnull%'
        AND LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            REPLACE(cc.definition, N'[', N''),
                            N']',
                            N''
                        ),
                        N' ',
                        N''
                    ),
                    NCHAR(9),
                    N''
                )
            ) LIKE N'%invre_closed_at>=invre_reserved_at%'
    )
    BEGIN
        SET @INVRE_FV_invalid_checks += 1;
    END;


    IF @INVRE_FV_invalid_checks = 0
    BEGIN
        SET @INVRE_FV_checks_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_checks_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
    END;


    /*==========================================================================
        UNIQUE CONSTRAINT VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON i.object_id = kc.parent_object_id
        AND i.index_id = kc.unique_index_id

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')

        AND kc.type = N'UQ'
        AND kc.name = N'UQ_INVRE_TRNIT'
        AND i.is_disabled = 0
        AND ds.name = N'FG_CORE'

        AND
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
                ON c.object_id = ic.object_id
            AND c.column_id = ic.column_id

            WHERE ic.object_id = kc.parent_object_id
            AND ic.index_id = kc.unique_index_id
            AND ic.key_ordinal > 0

        ) = N'INVRE_TRNIT_id|INVRE_TRNIT_transaction_at'
    )
    BEGIN
        SET @INVRE_FV_uniques_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_uniques_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINT VALIDATION
    ==========================================================================*/

    DECLARE @INVRE_FV_invalid_foreign_keys int = 0;


    /* FK_INVRE_TRNIT */

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.TransactionItem')
        AND fk.name = N'FK_INVRE_TRNIT'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
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
            AND pc.name = N'INVRE_TRNIT_id'
            AND rc.name = N'TRNIT_id'
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
            AND pc.name = N'INVRE_TRNIT_transaction_at'
            AND rc.name = N'TRNIT_transaction_at'
        )
    )
    BEGIN
        SET @INVRE_FV_invalid_foreign_keys += 1;
    END;


    /* FK_INVRE_PRDVA */

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        INNER JOIN sys.foreign_key_columns AS fkc
            ON fkc.constraint_object_id = fk.object_id
        INNER JOIN sys.columns AS pc
            ON pc.object_id = fkc.parent_object_id
        AND pc.column_id = fkc.parent_column_id
        INNER JOIN sys.columns AS rc
            ON rc.object_id = fkc.referenced_object_id
        AND rc.column_id = fkc.referenced_column_id
        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.ProductVariant')
        AND fk.name = N'FK_INVRE_PRDVA'
        AND pc.name = N'INVRE_PRDVA_id'
        AND rc.name = N'PRDVA_id'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0
    )
    BEGIN
        SET @INVRE_FV_invalid_foreign_keys += 1;
    END;


    /* FK_INVRE_INVRS */

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        INNER JOIN sys.foreign_key_columns AS fkc
            ON fkc.constraint_object_id = fk.object_id
        INNER JOIN sys.columns AS pc
            ON pc.object_id = fkc.parent_object_id
        AND pc.column_id = fkc.parent_column_id
        INNER JOIN sys.columns AS rc
            ON rc.object_id = fkc.referenced_object_id
        AND rc.column_id = fkc.referenced_column_id
        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND fk.referenced_object_id =
                OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND fk.name = N'FK_INVRE_INVRS'
        AND pc.name = N'INVRE_INVRS_id'
        AND rc.name = N'INVRS_id'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0
    )
    BEGIN
        SET @INVRE_FV_invalid_foreign_keys += 1;
    END;


    IF @INVRE_FV_invalid_foreign_keys = 0
    BEGIN
        SET @INVRE_FV_foreign_keys_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_foreign_keys_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
    END;


    /*==========================================================================
        ADDITIONAL INDEX VALIDATION
    ==========================================================================*/

    DECLARE @INVRE_FV_invalid_indexes int = 0;


    /* IX_INVRE_PRDVA_INVRS */

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.indexes AS i
        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id
        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND i.name = N'IX_INVRE_PRDVA_INVRS'
        AND i.type = 2
        AND i.is_unique = 0
        AND i.is_disabled = 0
        AND i.has_filter = 0
        AND ds.name = N'FG_CORE'
        AND
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), c.name), N'|')
                WITHIN GROUP (ORDER BY ic.key_ordinal)
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
            AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ) = N'INVRE_PRDVA_id|INVRE_INVRS_id'
    )
    BEGIN
        SET @INVRE_FV_invalid_indexes += 1;
    END;


    /* IX_INVRE_INVRS_expires_at */

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.indexes AS i
        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id
        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND i.name = N'IX_INVRE_INVRS_expires_at'
        AND i.type = 2
        AND i.is_unique = 0
        AND i.is_disabled = 0
        AND i.has_filter = 0
        AND ds.name = N'FG_CORE'
        AND
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), c.name), N'|')
                WITHIN GROUP (ORDER BY ic.key_ordinal)
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
            AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ) = N'INVRE_INVRS_id|INVRE_expires_at'
    )
    BEGIN
        SET @INVRE_FV_invalid_indexes += 1;
    END;


    IF @INVRE_FV_invalid_indexes = 0
    BEGIN
        SET @INVRE_FV_indexes_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_indexes_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
    END;


    /*==========================================================================
        TEMPORAL / LIFECYCLE INTEGRITY VALIDATION
    ==========================================================================*/

    DECLARE @INVRE_FV_invalid_temporal int = 0;
    DECLARE @INVRE_FV_trigger_definition nvarchar(max);


    /*----------------------------------------------------------------------
        Trigger structural validation
    ----------------------------------------------------------------------*/

    SELECT
        @INVRE_FV_trigger_definition =
            OBJECT_DEFINITION(tr.object_id)

    FROM sys.triggers AS tr

    WHERE tr.parent_id =
            OBJECT_ID(N'inventory.InventoryReservation')

    AND tr.name =
            N'TR_INVRE_reservation_temporal_integrity'

    AND tr.is_disabled = 0

    AND tr.is_instead_of_trigger = 0;


    IF @INVRE_FV_trigger_definition IS NULL
    BEGIN

        SET @INVRE_FV_invalid_temporal += 1;

    END
    ELSE
    BEGIN

        /*----------------------------------------------------------------------
            Validate that the deployed trigger contains the expected rules.

            This complements the exact definition validation performed during
            Temporal Integrity deployment and protects Final Validation from
            accepting an older trigger version accidentally.
        ----------------------------------------------------------------------*/

        IF LOWER(@INVRE_FV_trigger_definition)
            NOT LIKE N'%active%'
        BEGIN
            SET @INVRE_FV_invalid_temporal += 1;
        END;

        IF LOWER(@INVRE_FV_trigger_definition)
            NOT LIKE N'%consumed%'
        BEGIN
            SET @INVRE_FV_invalid_temporal += 1;
        END;

        IF LOWER(@INVRE_FV_trigger_definition)
            NOT LIKE N'%released%'
        BEGIN
            SET @INVRE_FV_invalid_temporal += 1;
        END;

        IF LOWER(@INVRE_FV_trigger_definition)
            NOT LIKE N'%expired%'
        BEGIN
            SET @INVRE_FV_invalid_temporal += 1;
        END;

        IF LOWER(@INVRE_FV_trigger_definition)
            NOT LIKE N'%trnit_prdva_id%'
        OR LOWER(@INVRE_FV_trigger_definition)
            NOT LIKE N'%invre_prdva_id%'
        BEGIN
            SET @INVRE_FV_invalid_temporal += 1;
        END;

    END;


    /*----------------------------------------------------------------------
        ACTIVE must remain open
    ----------------------------------------------------------------------*/

    IF EXISTS
    (
        SELECT 1
        FROM inventory.InventoryReservation AS R
        INNER JOIN inventory.InventoryReservationStatus AS S
            ON S.INVRS_id = R.INVRE_INVRS_id
        WHERE S.INVRS_name = N'ACTIVE'
        AND R.INVRE_closed_at IS NOT NULL
    )
    BEGIN
        SET @INVRE_FV_invalid_temporal += 1;
    END;


    /*----------------------------------------------------------------------
        Terminal statuses require closed_at
    ----------------------------------------------------------------------*/

    IF EXISTS
    (
        SELECT 1
        FROM inventory.InventoryReservation AS R
        INNER JOIN inventory.InventoryReservationStatus AS S
            ON S.INVRS_id = R.INVRE_INVRS_id
        WHERE S.INVRS_name IN
        (
            N'CONSUMED',
            N'RELEASED',
            N'EXPIRED'
        )
        AND R.INVRE_closed_at IS NULL
    )
    BEGIN
        SET @INVRE_FV_invalid_temporal += 1;
    END;


    /*----------------------------------------------------------------------
        EXPIRED cannot close before expires_at
    ----------------------------------------------------------------------*/

    IF EXISTS
    (
        SELECT 1
        FROM inventory.InventoryReservation AS R
        INNER JOIN inventory.InventoryReservationStatus AS S
            ON S.INVRS_id = R.INVRE_INVRS_id
        WHERE S.INVRS_name = N'EXPIRED'
        AND R.INVRE_closed_at < R.INVRE_expires_at
    )
    BEGIN
        SET @INVRE_FV_invalid_temporal += 1;
    END;


    /*----------------------------------------------------------------------
        Only supported lifecycle statuses
    ----------------------------------------------------------------------*/

    IF EXISTS
    (
        SELECT 1
        FROM inventory.InventoryReservation AS R
        INNER JOIN inventory.InventoryReservationStatus AS S
            ON S.INVRS_id = R.INVRE_INVRS_id
        WHERE S.INVRS_name NOT IN
        (
            N'ACTIVE',
            N'CONSUMED',
            N'RELEASED',
            N'EXPIRED'
        )
    )
    BEGIN
        SET @INVRE_FV_invalid_temporal += 1;
    END;


    /*--------------------------------------------------------------------------
        CROSS-OBJECT BUSINESS CONSISTENCY

        The ProductVariant stored in the reservation must match the
        ProductVariant of the referenced TransactionItem.
    --------------------------------------------------------------------------*/

    IF EXISTS
    (
        SELECT 1

        FROM inventory.InventoryReservation AS R

        INNER JOIN sales.TransactionItem AS TI
            ON TI.TRNIT_id =
                R.INVRE_TRNIT_id
        AND TI.TRNIT_transaction_at =
                R.INVRE_TRNIT_transaction_at

        WHERE TI.TRNIT_PRDVA_id <>
                R.INVRE_PRDVA_id
    )
    BEGIN
        SET @INVRE_FV_invalid_temporal += 1;
    END;


    IF @INVRE_FV_invalid_temporal = 0
    BEGIN
        SET @INVRE_FV_temporal_integrity_status = N'VALID';
    END
    ELSE
    BEGIN
        SET @INVRE_FV_temporal_integrity_status = N'FAILED';
        SET @INVRE_FV_validation_errors += 1;
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

    PRINT N'        Table                         : ' + @INVRE_FV_table_status;
    PRINT N'        Primary Key                   : ' + @INVRE_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @INVRE_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @INVRE_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @INVRE_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @INVRE_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @INVRE_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @INVRE_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @INVRE_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @INVRE_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @INVRE_FV_temporal_integrity_status;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';


    IF @INVRE_FV_validation_errors = 0
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
                @INVRE_FV_validation_errors
            );

        PRINT N'';


        ;THROW 51060,
            N'Final validation failed for inventory.InventoryReservation.',
            1;

    END;


    PRINT N'';