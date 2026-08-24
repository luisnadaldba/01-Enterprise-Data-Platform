    PRINT N'    ● inventory.InventoryMovement';


    /*==========================================================================
        FINAL VALIDATION STATE
    ==========================================================================*/

    DECLARE @INVMV_FV_validation_errors int = 0;

    DECLARE @INVMV_FV_table_status               nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMV_FV_primary_key_status         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMV_FV_columns_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMV_FV_documentation_status       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMV_FV_seed_data_status           nvarchar(20) = N'NOT APPLICABLE';
    DECLARE @INVMV_FV_defaults_status            nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMV_FV_checks_status              nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMV_FV_uniques_status             nvarchar(20) = N'NOT REQUIRED';
    DECLARE @INVMV_FV_foreign_keys_status        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMV_FV_indexes_status             nvarchar(20) = N'NOT VALIDATED';
    DECLARE @INVMV_FV_temporal_integrity_status  nvarchar(20) = N'NOT REQUIRED';


    /*==========================================================================
        TABLE VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovement', N'U') IS NOT NULL
        SET @INVMV_FV_table_status = N'VALID';
    ELSE
    BEGIN
        SET @INVMV_FV_table_status = N'FAILED';
        SET @INVMV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        PRIMARY KEY VALIDATION
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
        WHERE kc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND kc.type = N'PK'
        AND kc.name = N'PK_INVMV'
        AND ds.name = N'FG_CORE'
        AND
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
        ) = N'INVMV_id'
    )
        SET @INVMV_FV_primary_key_status = N'VALID';
    ELSE
    BEGIN
        SET @INVMV_FV_primary_key_status = N'FAILED';
        SET @INVMV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        COLUMNS VALIDATION
    ==========================================================================*/

    DECLARE @INVMV_FV_invalid_columns int = 0;

    IF (SELECT COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID(N'inventory.InventoryMovement')) <> 9
        SET @INVMV_FV_invalid_columns += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_id' AND t.name = N'bigint'
        AND c.max_length = 8 AND c.is_nullable = 0 AND c.is_identity = 1
    )
        SET @INVMV_FV_invalid_columns += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.identity_columns
        WHERE object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND name = N'INVMV_id'
        AND CONVERT(bigint, seed_value) = 1
        AND CONVERT(bigint, increment_value) = 1
    )
        SET @INVMV_FV_invalid_columns += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_PRDVA_id' AND t.name = N'int'
        AND c.max_length = 4 AND c.is_nullable = 0 AND c.is_identity = 0
    )
        SET @INVMV_FV_invalid_columns += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_INVMR_id' AND t.name = N'smallint'
        AND c.max_length = 2 AND c.is_nullable = 0 AND c.is_identity = 0
    )
        SET @INVMV_FV_invalid_columns += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_TRNIT_id' AND t.name = N'bigint'
        AND c.max_length = 8 AND c.is_nullable = 1 AND c.is_identity = 0
    )
        SET @INVMV_FV_invalid_columns += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_TRNIT_transaction_at' AND t.name = N'datetime2'
        AND c.scale = 0 AND c.is_nullable = 1
    )
        SET @INVMV_FV_invalid_columns += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_quantity' AND t.name = N'int'
        AND c.max_length = 4 AND c.is_nullable = 0 AND c.is_identity = 0
    )
        SET @INVMV_FV_invalid_columns += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_movement_at' AND t.name = N'datetime2'
        AND c.scale = 0 AND c.is_nullable = 0
    )
        SET @INVMV_FV_invalid_columns += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_created_at' AND t.name = N'datetime2'
        AND c.scale = 0 AND c.is_nullable = 0
    )
        SET @INVMV_FV_invalid_columns += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.columns AS c
        INNER JOIN sys.types AS t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_updated_at' AND t.name = N'datetime2'
        AND c.scale = 0 AND c.is_nullable = 0
    )
        SET @INVMV_FV_invalid_columns += 1;

    IF @INVMV_FV_invalid_columns = 0
        SET @INVMV_FV_columns_status = N'VALID';
    ELSE
    BEGIN
        SET @INVMV_FV_columns_status = N'FAILED';
        SET @INVMV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        OBJECT DOCUMENTATION VALIDATION
    ==========================================================================*/

    DECLARE @INVMV_FV_expected_documentation TABLE
    (
        doc_id tinyint IDENTITY(1,1) NOT NULL,
        object_type nvarchar(10) NOT NULL,
        column_name sysname NULL,
        expected_description nvarchar(4000) NOT NULL
    );

    INSERT INTO @INVMV_FV_expected_documentation
    (
        object_type,
        column_name,
        expected_description
    )
    VALUES
    (N'TABLE', NULL, N'Maintains the historical inventory movements for each product variant in Atlas Commerce.'),
    (N'COLUMN', N'INVMV_id', N'Primary key of inventory.InventoryMovement.'),
    (N'COLUMN', N'INVMV_PRDVA_id', N'Foreign key referencing catalog.ProductVariant.'),
    (N'COLUMN', N'INVMV_INVMR_id', N'Foreign key referencing inventory.InventoryMovementReason.'),
    (N'COLUMN', N'INVMV_TRNIT_id', N'Optional identifier component of the composite foreign key referencing sales.TransactionItem when the inventory movement originates from a sales transaction item.'),
    (N'COLUMN', N'INVMV_TRNIT_transaction_at', N'Optional transaction timestamp component of the composite foreign key referencing sales.TransactionItem when the inventory movement originates from a sales transaction item.'),
    (N'COLUMN', N'INVMV_quantity', N'Stores the signed inventory quantity moved. Positive values represent entries and negative values represent exits.'),
    (N'COLUMN', N'INVMV_movement_at', N'Records the date and time when the inventory movement actually occurred.'),
    (N'COLUMN', N'INVMV_created_at', N'Records the date and time when the row was created.'),
    (N'COLUMN', N'INVMV_updated_at', N'Records the date and time when the row was last updated.');

    DECLARE @INVMV_FV_invalid_documentation int = 0;

    IF NOT EXISTS
    (
        SELECT 1
        FROM @INVMV_FV_expected_documentation AS e
        OUTER APPLY
        (
            SELECT CONVERT(nvarchar(4000), ep.value) AS actual_description
            FROM sys.extended_properties AS ep
            WHERE e.object_type = N'TABLE'
            AND ep.class = 1
            AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND ep.minor_id = 0
            AND ep.name = N'MS_Description'

            UNION ALL

            SELECT CONVERT(nvarchar(4000), ep.value)
            FROM sys.extended_properties AS ep
            INNER JOIN sys.columns AS c
                ON c.object_id = ep.major_id
                AND c.column_id = ep.minor_id
            WHERE e.object_type = N'COLUMN'
            AND ep.class = 1
            AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
            AND ep.name = N'MS_Description'
            AND c.name = e.column_name
        ) AS a
        WHERE ISNULL(a.actual_description, N'') <> e.expected_description
    )
        SET @INVMV_FV_documentation_status = N'VALID';
    ELSE
    BEGIN
        SET @INVMV_FV_documentation_status = N'FAILED';
        SET @INVMV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        DEFAULT CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @INVMV_FV_invalid_defaults int = 0;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND dc.name = N'DF_INVMV_movement_at'
        AND c.name = N'INVMV_movement_at'
        AND LOWER(REPLACE(REPLACE(REPLACE(dc.definition,N'(',N''),N')',N''),N' ',N'')) = N'sysdatetime'
    )
        SET @INVMV_FV_invalid_defaults += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND dc.name = N'DF_INVMV_created_at'
        AND c.name = N'INVMV_created_at'
        AND LOWER(REPLACE(REPLACE(REPLACE(dc.definition,N'(',N''),N')',N''),N' ',N'')) = N'sysdatetime'
    )
        SET @INVMV_FV_invalid_defaults += 1;

    IF NOT EXISTS
    (
        SELECT 1 FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND dc.name = N'DF_INVMV_updated_at'
        AND c.name = N'INVMV_updated_at'
        AND LOWER(REPLACE(REPLACE(REPLACE(dc.definition,N'(',N''),N')',N''),N' ',N'')) = N'sysdatetime'
    )
        SET @INVMV_FV_invalid_defaults += 1;

    IF @INVMV_FV_invalid_defaults = 0
        SET @INVMV_FV_defaults_status = N'VALID';
    ELSE
    BEGIN
        SET @INVMV_FV_defaults_status = N'FAILED';
        SET @INVMV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        CHECK CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @INVMV_FV_invalid_checks int = 0;
    DECLARE @INVMV_FV_check_definition nvarchar(4000);

    SET @INVMV_FV_check_definition = NULL;

    SELECT @INVMV_FV_check_definition =
        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(cc.definition,N'[',N''),N']',N''),N' ',N''),NCHAR(9),N''))
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
    AND cc.name = N'CK_INVMV_quantity'
    AND cc.is_disabled = 0
    AND cc.is_not_trusted = 0;

    IF @INVMV_FV_check_definition IS NULL
    OR @INVMV_FV_check_definition NOT LIKE N'%invmv_quantity<>(0)%'
        SET @INVMV_FV_invalid_checks += 1;

    SET @INVMV_FV_check_definition = NULL;

    SELECT @INVMV_FV_check_definition =
        LOWER(REPLACE(REPLACE(REPLACE(REPLACE(cc.definition,N'[',N''),N']',N''),N' ',N''),NCHAR(9),N''))
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
    AND cc.name = N'CK_INVMV_TRNIT_reference'
    AND cc.is_disabled = 0
    AND cc.is_not_trusted = 0;

    IF @INVMV_FV_check_definition IS NULL
    OR @INVMV_FV_check_definition NOT LIKE N'%invmv_trnit_idisnull%'
    OR @INVMV_FV_check_definition NOT LIKE N'%invmv_trnit_transaction_atisnull%'
    OR @INVMV_FV_check_definition NOT LIKE N'%invmv_trnit_idisnotnull%'
    OR @INVMV_FV_check_definition NOT LIKE N'%invmv_trnit_transaction_atisnotnull%'
        SET @INVMV_FV_invalid_checks += 1;

    IF @INVMV_FV_invalid_checks = 0
        SET @INVMV_FV_checks_status = N'VALID';
    ELSE
    BEGIN
        SET @INVMV_FV_checks_status = N'FAILED';
        SET @INVMV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FOREIGN KEY CONSTRAINTS VALIDATION
    ==========================================================================*/

    DECLARE @INVMV_FV_invalid_foreign_keys int = 0;

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND fk.referenced_object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND fk.name = N'FK_INVMV_PRDVA'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0
        AND (SELECT COUNT(*) FROM sys.foreign_key_columns WHERE constraint_object_id = fk.object_id) = 1
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
            AND pc.name = N'INVMV_PRDVA_id'
            AND rc.name = N'PRDVA_id'
        )
    )
        SET @INVMV_FV_invalid_foreign_keys += 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND fk.referenced_object_id = OBJECT_ID(N'inventory.InventoryMovementReason')
        AND fk.name = N'FK_INVMV_INVMR'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0
        AND (SELECT COUNT(*) FROM sys.foreign_key_columns WHERE constraint_object_id = fk.object_id) = 1
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
            AND pc.name = N'INVMV_INVMR_id'
            AND rc.name = N'INVMR_id'
        )
    )
        SET @INVMV_FV_invalid_foreign_keys += 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND fk.referenced_object_id = OBJECT_ID(N'sales.TransactionItem')
        AND fk.name = N'FK_INVMV_TRNIT'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
        AND fk.is_disabled = 0
        AND fk.is_not_trusted = 0
        AND
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), pc.name), N'|')
                   WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        ) = N'INVMV_TRNIT_id|INVMV_TRNIT_transaction_at'
        AND
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), rc.name), N'|')
                   WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        ) = N'TRNIT_id|TRNIT_transaction_at'
    )
        SET @INVMV_FV_invalid_foreign_keys += 1;

    IF @INVMV_FV_invalid_foreign_keys = 0
        SET @INVMV_FV_foreign_keys_status = N'VALID';
    ELSE
    BEGIN
        SET @INVMV_FV_foreign_keys_status = N'FAILED';
        SET @INVMV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        ADDITIONAL INDEXES VALIDATION
    ==========================================================================*/

    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes AS i
        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id
        WHERE i.object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND i.name = N'IX_INVMV_PRDVA_movement_at'
        AND i.type = 2
        AND i.is_unique = 0
        AND i.has_filter = 0
        AND i.is_disabled = 0
        AND ds.name = N'FG_CORE'
        AND
        (
            SELECT STRING_AGG
            (
                CONVERT(nvarchar(max),
                    c.name + CASE WHEN ic.is_descending_key = 1 THEN N' DESC' ELSE N' ASC' END
                ),
                N'|'
            )
            WITHIN GROUP (ORDER BY ic.key_ordinal)
            FROM sys.index_columns AS ic
            INNER JOIN sys.columns AS c
                ON c.object_id = ic.object_id
                AND c.column_id = ic.column_id
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        ) = N'INVMV_PRDVA_id ASC|INVMV_movement_at ASC'
        AND NOT EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
        )
    )
        SET @INVMV_FV_indexes_status = N'VALID';
    ELSE
    BEGIN
        SET @INVMV_FV_indexes_status = N'FAILED';
        SET @INVMV_FV_validation_errors += 1;
    END;


    /*==========================================================================
        FINAL STATE
    ==========================================================================*/

    PRINT N'';
    PRINT N'    FINAL STATE';
    PRINT N'';

    PRINT N'        Table                         : ' + @INVMV_FV_table_status;
    PRINT N'        Primary Key                   : ' + @INVMV_FV_primary_key_status;
    PRINT N'        Columns                       : ' + @INVMV_FV_columns_status;
    PRINT N'        Object Documentation          : ' + @INVMV_FV_documentation_status;
    PRINT N'        Seed Data                     : ' + @INVMV_FV_seed_data_status;
    PRINT N'        Default Constraints           : ' + @INVMV_FV_defaults_status;
    PRINT N'        Check Constraints             : ' + @INVMV_FV_checks_status;
    PRINT N'        Unique Constraints            : ' + @INVMV_FV_uniques_status;
    PRINT N'        Foreign Key Constraints       : ' + @INVMV_FV_foreign_keys_status;
    PRINT N'        Additional Indexes            : ' + @INVMV_FV_indexes_status;
    PRINT N'        Temporal Integrity            : ' + @INVMV_FV_temporal_integrity_status;
    PRINT N'';

    IF @INVMV_FV_validation_errors = 0
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
                @INVMV_FV_validation_errors
            );

    END;

    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    IF @INVMV_FV_validation_errors > 0
    BEGIN

        ;THROW 50990,
            N'Final validation failed for inventory.InventoryMovement.',
            1;

    END;