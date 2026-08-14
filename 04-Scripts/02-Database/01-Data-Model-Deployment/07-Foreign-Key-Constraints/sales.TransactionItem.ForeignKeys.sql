    PRINT N'    sales.TransactionItem';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        FOREIGN KEY: FK_TRNIT_TRN
    ==============================================================================*/

    DECLARE @TRNIT_TRN_FK_actual_name               sysname;
    DECLARE @TRNIT_TRN_FK_actual_parent_columns     nvarchar(4000);
    DECLARE @TRNIT_TRN_FK_actual_referenced_columns nvarchar(4000);
    DECLARE @TRNIT_TRN_FK_actual_delete_action      nvarchar(60);
    DECLARE @TRNIT_TRN_FK_actual_update_action      nvarchar(60);
    DECLARE @TRNIT_TRN_FK_actual_is_disabled        bit;
    DECLARE @TRNIT_TRN_FK_actual_is_not_trusted     bit;
    DECLARE @TRNIT_TRN_FK_equivalent_name           sysname;


    /*--------------------------------------------------------------------------
        DEPENDENCY VALIDATION
    --------------------------------------------------------------------------*/

    IF OBJECT_ID(N'sales.TransactionItem', N'U') IS NULL
    BEGIN
        THROW 50196,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because sales.TransactionItem does not exist.',
            1;
    END;

    IF OBJECT_ID(N'sales.Transaction', N'U') IS NULL
    BEGIN
        THROW 50197,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because sales.Transaction does not exist.',
            1;
    END;

    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_TRN_id') IS NULL
    OR COL_LENGTH(N'sales.TransactionItem', N'TRNIT_transaction_at') IS NULL
    OR COL_LENGTH(N'sales.Transaction', N'TRN_id') IS NULL
    OR COL_LENGTH(N'sales.Transaction', N'TRN_transaction_at') IS NULL
    BEGIN
        THROW 50198,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because one or more participating columns do not exist.',
            1;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.columns p1
        JOIN sys.columns r1
        ON r1.object_id = OBJECT_ID(N'sales.Transaction')
        AND r1.name = N'TRN_id'
        WHERE p1.object_id = OBJECT_ID(N'sales.TransactionItem')
        AND p1.name = N'TRNIT_TRN_id'
        AND p1.system_type_id = r1.system_type_id
        AND p1.max_length = r1.max_length
        AND p1.precision = r1.precision
        AND p1.scale = r1.scale
    )
    OR NOT EXISTS
    (
        SELECT 1
        FROM sys.columns p2
        JOIN sys.columns r2
        ON r2.object_id = OBJECT_ID(N'sales.Transaction')
        AND r2.name = N'TRN_transaction_at'
        WHERE p2.object_id = OBJECT_ID(N'sales.TransactionItem')
        AND p2.name = N'TRNIT_transaction_at'
        AND p2.system_type_id = r2.system_type_id
        AND p2.max_length = r2.max_length
        AND p2.precision = r2.precision
        AND p2.scale = r2.scale
    )
    BEGIN
        THROW 50199,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because participating columns are incompatible.',
            1;
    END;

    PRINT N'        [✓] Foreign key dependencies validated : FK_TRNIT_TRN';


    /*--------------------------------------------------------------------------
        LOOK FOR EXPECTED NAME
    --------------------------------------------------------------------------*/

    SELECT
        @TRNIT_TRN_FK_actual_name = fk.name,
        @TRNIT_TRN_FK_actual_delete_action = fk.delete_referential_action_desc,
        @TRNIT_TRN_FK_actual_update_action = fk.update_referential_action_desc,
        @TRNIT_TRN_FK_actual_is_disabled = fk.is_disabled,
        @TRNIT_TRN_FK_actual_is_not_trusted = fk.is_not_trusted,
        @TRNIT_TRN_FK_actual_parent_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), pc.name), N'|')
                WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns fkc
            JOIN sys.columns pc
            ON pc.object_id = fkc.parent_object_id
            AND pc.column_id = fkc.parent_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        ),
        @TRNIT_TRN_FK_actual_referenced_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), rc.name), N'|')
                WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns fkc
            JOIN sys.columns rc
            ON rc.object_id = fkc.referenced_object_id
            AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        )
    FROM sys.foreign_keys fk
    WHERE fk.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
    AND fk.name = N'FK_TRNIT_TRN';

    IF @TRNIT_TRN_FK_actual_name IS NOT NULL
    BEGIN
        IF @TRNIT_TRN_FK_actual_parent_columns = N'TRNIT_TRN_id|TRNIT_transaction_at'
        AND @TRNIT_TRN_FK_actual_referenced_columns = N'TRN_id|TRN_transaction_at'
        AND EXISTS
            (SELECT 1 FROM sys.foreign_keys WHERE parent_object_id=OBJECT_ID(N'sales.TransactionItem')
            AND name=N'FK_TRNIT_TRN' AND referenced_object_id=OBJECT_ID(N'sales.Transaction'))
        AND @TRNIT_TRN_FK_actual_delete_action = N'CASCADE'
        AND @TRNIT_TRN_FK_actual_update_action = N'NO_ACTION'
        AND @TRNIT_TRN_FK_actual_is_disabled = 0
        AND @TRNIT_TRN_FK_actual_is_not_trusted = 0
        BEGIN
            PRINT N'        [•] Foreign key validated            : FK_TRNIT_TRN';
            PRINT N'            Columns                         : TRNIT_TRN_id, TRNIT_transaction_at';
            PRINT N'            References                      : sales.Transaction(TRN_id, TRN_transaction_at)';
            PRINT N'            ON DELETE                       : CASCADE';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';
        END
        ELSE
        BEGIN
            PRINT N'        [X] Foreign key mismatch             : FK_TRNIT_TRN';
            THROW 50200,
                N'Foreign key FK_TRNIT_TRN exists but does not match the expected definition.',
                1;
        END;
    END
    ELSE
    BEGIN
        SELECT TOP (1) @TRNIT_TRN_FK_equivalent_name = fk.name
        FROM sys.foreign_keys fk
        WHERE fk.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
        AND fk.referenced_object_id = OBJECT_ID(N'sales.Transaction')
        AND fk.name <> N'FK_TRNIT_TRN'
        AND fk.delete_referential_action_desc = N'CASCADE'
        AND fk.update_referential_action_desc = N'NO_ACTION'
        AND (SELECT COUNT(*) FROM sys.foreign_key_columns fkc WHERE fkc.constraint_object_id=fk.object_id) = 2
        AND EXISTS
        (
            SELECT 1 FROM sys.foreign_key_columns fkc
            JOIN sys.columns pc ON pc.object_id=fkc.parent_object_id AND pc.column_id=fkc.parent_column_id
            JOIN sys.columns rc ON rc.object_id=fkc.referenced_object_id AND rc.column_id=fkc.referenced_column_id
            WHERE fkc.constraint_object_id=fk.object_id AND fkc.constraint_column_id=1
                AND pc.name=N'TRNIT_TRN_id' AND rc.name=N'TRN_id'
        )
        AND EXISTS
        (
            SELECT 1 FROM sys.foreign_key_columns fkc
            JOIN sys.columns pc ON pc.object_id=fkc.parent_object_id AND pc.column_id=fkc.parent_column_id
            JOIN sys.columns rc ON rc.object_id=fkc.referenced_object_id AND rc.column_id=fkc.referenced_column_id
            WHERE fkc.constraint_object_id=fk.object_id AND fkc.constraint_column_id=2
                AND pc.name=N'TRNIT_transaction_at' AND rc.name=N'TRN_transaction_at'
        );

        IF @TRNIT_TRN_FK_equivalent_name IS NOT NULL
        BEGIN
            PRINT N'        [X] Foreign key naming mismatch      : FK_TRNIT_TRN';
            PRINT N'            Actual Name                     : ' + @TRNIT_TRN_FK_equivalent_name;
            THROW 50201,
                N'An equivalent foreign key for FK_TRNIT_TRN exists with another name.',
                1;
        END;

        ALTER TABLE sales.TransactionItem
            WITH CHECK
            ADD CONSTRAINT FK_TRNIT_TRN
            FOREIGN KEY (TRNIT_TRN_id, TRNIT_transaction_at)
            REFERENCES sales.[Transaction] (TRN_id, TRN_transaction_at)
            ON DELETE CASCADE
            ON UPDATE NO ACTION;

        ALTER TABLE sales.TransactionItem
            CHECK CONSTRAINT FK_TRNIT_TRN;

        PRINT N'        [+] Foreign key constraint added    : FK_TRNIT_TRN';
        PRINT N'            Columns                         : TRNIT_TRN_id, TRNIT_transaction_at';
        PRINT N'            References                      : sales.Transaction(TRN_id, TRN_transaction_at)';
        PRINT N'            ON DELETE                       : CASCADE';
        PRINT N'            ON UPDATE                       : NO ACTION';
        PRINT N'            Enabled                         : YES';
        PRINT N'            Trusted                         : YES';
    END;

    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_TRNIT_PRDVA
    ==============================================================================*/

    DECLARE @TRNIT_PRDVA_FK_actual_name               sysname;
    DECLARE @TRNIT_PRDVA_FK_actual_parent_columns     nvarchar(4000);
    DECLARE @TRNIT_PRDVA_FK_actual_referenced_columns nvarchar(4000);
    DECLARE @TRNIT_PRDVA_FK_actual_delete_action      nvarchar(60);
    DECLARE @TRNIT_PRDVA_FK_actual_update_action      nvarchar(60);
    DECLARE @TRNIT_PRDVA_FK_actual_is_disabled        bit;
    DECLARE @TRNIT_PRDVA_FK_actual_is_not_trusted     bit;
    DECLARE @TRNIT_PRDVA_FK_equivalent_name           sysname;

    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NULL
    BEGIN
        THROW 50202,
            N'Foreign key FK_TRNIT_PRDVA cannot be deployed because catalog.ProductVariant does not exist.',
            1;
    END;

    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_PRDVA_id') IS NULL
    OR COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_id') IS NULL
    BEGIN
        THROW 50203,
            N'Foreign key FK_TRNIT_PRDVA cannot be deployed because one or more participating columns do not exist.',
            1;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.columns p
        JOIN sys.columns r
        ON r.object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND r.name = N'PRDVA_id'
        WHERE p.object_id = OBJECT_ID(N'sales.TransactionItem')
        AND p.name = N'TRNIT_PRDVA_id'
        AND p.system_type_id = r.system_type_id
        AND p.max_length = r.max_length
        AND p.precision = r.precision
        AND p.scale = r.scale
    )
    BEGIN
        THROW 50204,
            N'Foreign key FK_TRNIT_PRDVA cannot be deployed because participating columns are incompatible.',
            1;
    END;

    PRINT N'        [✓] Foreign key dependencies validated : FK_TRNIT_PRDVA';

    SELECT
        @TRNIT_PRDVA_FK_actual_name = fk.name,
        @TRNIT_PRDVA_FK_actual_delete_action = fk.delete_referential_action_desc,
        @TRNIT_PRDVA_FK_actual_update_action = fk.update_referential_action_desc,
        @TRNIT_PRDVA_FK_actual_is_disabled = fk.is_disabled,
        @TRNIT_PRDVA_FK_actual_is_not_trusted = fk.is_not_trusted,
        @TRNIT_PRDVA_FK_actual_parent_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), pc.name), N'|')
                WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns fkc
            JOIN sys.columns pc ON pc.object_id=fkc.parent_object_id AND pc.column_id=fkc.parent_column_id
            WHERE fkc.constraint_object_id=fk.object_id
        ),
        @TRNIT_PRDVA_FK_actual_referenced_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), rc.name), N'|')
                WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns fkc
            JOIN sys.columns rc ON rc.object_id=fkc.referenced_object_id AND rc.column_id=fkc.referenced_column_id
            WHERE fkc.constraint_object_id=fk.object_id
        )
    FROM sys.foreign_keys fk
    WHERE fk.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
    AND fk.name = N'FK_TRNIT_PRDVA';

    IF @TRNIT_PRDVA_FK_actual_name IS NOT NULL
    BEGIN
        IF @TRNIT_PRDVA_FK_actual_parent_columns = N'TRNIT_PRDVA_id'
        AND @TRNIT_PRDVA_FK_actual_referenced_columns = N'PRDVA_id'
        AND EXISTS
            (SELECT 1 FROM sys.foreign_keys WHERE parent_object_id=OBJECT_ID(N'sales.TransactionItem')
            AND name=N'FK_TRNIT_PRDVA' AND referenced_object_id=OBJECT_ID(N'catalog.ProductVariant'))
        AND @TRNIT_PRDVA_FK_actual_delete_action = N'NO_ACTION'
        AND @TRNIT_PRDVA_FK_actual_update_action = N'NO_ACTION'
        AND @TRNIT_PRDVA_FK_actual_is_disabled = 0
        AND @TRNIT_PRDVA_FK_actual_is_not_trusted = 0
        BEGIN
            PRINT N'        [•] Foreign key validated            : FK_TRNIT_PRDVA';
            PRINT N'            Column                          : TRNIT_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';
        END
        ELSE
        BEGIN
            PRINT N'        [X] Foreign key mismatch             : FK_TRNIT_PRDVA';
            THROW 50205,
                N'Foreign key FK_TRNIT_PRDVA exists but does not match the expected definition.',
                1;
        END;
    END
    ELSE
    BEGIN
        SELECT TOP (1) @TRNIT_PRDVA_FK_equivalent_name = fk.name
        FROM sys.foreign_keys fk
        WHERE fk.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
        AND fk.referenced_object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND fk.name <> N'FK_TRNIT_PRDVA'
        AND fk.delete_referential_action_desc = N'NO_ACTION'
        AND fk.update_referential_action_desc = N'NO_ACTION'
        AND (SELECT COUNT(*) FROM sys.foreign_key_columns fkc WHERE fkc.constraint_object_id=fk.object_id) = 1
        AND EXISTS
        (
            SELECT 1 FROM sys.foreign_key_columns fkc
            JOIN sys.columns pc ON pc.object_id=fkc.parent_object_id AND pc.column_id=fkc.parent_column_id
            JOIN sys.columns rc ON rc.object_id=fkc.referenced_object_id AND rc.column_id=fkc.referenced_column_id
            WHERE fkc.constraint_object_id=fk.object_id
                AND pc.name=N'TRNIT_PRDVA_id' AND rc.name=N'PRDVA_id'
        );

        IF @TRNIT_PRDVA_FK_equivalent_name IS NOT NULL
        BEGIN
            PRINT N'        [X] Foreign key naming mismatch      : FK_TRNIT_PRDVA';
            PRINT N'            Actual Name                     : ' + @TRNIT_PRDVA_FK_equivalent_name;
            THROW 50206,
                N'An equivalent foreign key for FK_TRNIT_PRDVA exists with another name.',
                1;
        END;

        ALTER TABLE sales.TransactionItem
            WITH CHECK
            ADD CONSTRAINT FK_TRNIT_PRDVA
            FOREIGN KEY (TRNIT_PRDVA_id)
            REFERENCES catalog.ProductVariant (PRDVA_id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;

        ALTER TABLE sales.TransactionItem
            CHECK CONSTRAINT FK_TRNIT_PRDVA;

        PRINT N'        [+] Foreign key constraint added    : FK_TRNIT_PRDVA';
        PRINT N'            Column                          : TRNIT_PRDVA_id';
        PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
        PRINT N'            ON DELETE                       : NO ACTION';
        PRINT N'            ON UPDATE                       : NO ACTION';
        PRINT N'            Enabled                         : YES';
        PRINT N'            Trusted                         : YES';
    END;

    PRINT N'';