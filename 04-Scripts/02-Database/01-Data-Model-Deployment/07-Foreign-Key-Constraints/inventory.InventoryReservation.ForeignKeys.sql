    PRINT N'    inventory.InventoryReservation';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        FOREIGN KEY: FK_INVRE_TRNIT
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryReservation', N'U') IS NULL
    BEGIN
        ;THROW 50980,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because inventory.InventoryReservation does not exist.',
            1;
    END;

    IF OBJECT_ID(N'sales.TransactionItem', N'U') IS NULL
    BEGIN
        ;THROW 50981,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because sales.TransactionItem does not exist.',
            1;
    END;

    IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_TRNIT_id') IS NULL
    OR COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_TRNIT_transaction_at') IS NULL
    BEGIN
        ;THROW 50982,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because one or more parent columns do not exist.',
            1;
    END;

    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_id') IS NULL
    OR COL_LENGTH(N'sales.TransactionItem', N'TRNIT_transaction_at') IS NULL
    BEGIN
        ;THROW 50983,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because one or more referenced columns do not exist.',
            1;
    END;


    /*------------------------------------------------------------------------------
        Validate participating column compatibility
    ------------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.columns AS p
        INNER JOIN sys.columns AS r
            ON r.object_id = OBJECT_ID(N'sales.TransactionItem')
        WHERE p.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND p.name = N'INVRE_TRNIT_id'
        AND r.name = N'TRNIT_id'
        AND p.system_type_id = r.system_type_id
        AND p.max_length = r.max_length
        AND p.precision = r.precision
        AND p.scale = r.scale
    )
    OR NOT EXISTS
    (
        SELECT 1
        FROM sys.columns AS p
        INNER JOIN sys.columns AS r
            ON r.object_id = OBJECT_ID(N'sales.TransactionItem')
        WHERE p.object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND p.name = N'INVRE_TRNIT_transaction_at'
        AND r.name = N'TRNIT_transaction_at'
        AND p.system_type_id = r.system_type_id
        AND p.max_length = r.max_length
        AND p.precision = r.precision
        AND p.scale = r.scale
    )
    BEGIN
        ;THROW 50984,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because participating columns are incompatible.',
            1;
    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INVRE_TRNIT';


    DECLARE
        @INVRE_TRNIT_actual_name       sysname,
        @INVRE_TRNIT_parent_columns    nvarchar(4000),
        @INVRE_TRNIT_ref_columns       nvarchar(4000),
        @INVRE_TRNIT_delete_action     nvarchar(60),
        @INVRE_TRNIT_update_action     nvarchar(60),
        @INVRE_TRNIT_disabled          bit,
        @INVRE_TRNIT_not_trusted       bit;


    SELECT
        @INVRE_TRNIT_actual_name = fk.name,
        @INVRE_TRNIT_delete_action = fk.delete_referential_action_desc,
        @INVRE_TRNIT_update_action = fk.update_referential_action_desc,
        @INVRE_TRNIT_disabled = fk.is_disabled,
        @INVRE_TRNIT_not_trusted = fk.is_not_trusted,

        @INVRE_TRNIT_parent_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), pc.name), N'|')
                WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
            AND pc.column_id = fkc.parent_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        ),

        @INVRE_TRNIT_ref_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), rc.name), N'|')
                WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
            AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
            OBJECT_ID(N'inventory.InventoryReservation')
    AND fk.name = N'FK_INVRE_TRNIT';


    IF @INVRE_TRNIT_actual_name IS NOT NULL
    BEGIN

        IF @INVRE_TRNIT_parent_columns =
                N'INVRE_TRNIT_id|INVRE_TRNIT_transaction_at'
        AND @INVRE_TRNIT_ref_columns =
                N'TRNIT_id|TRNIT_transaction_at'
        AND @INVRE_TRNIT_delete_action = N'NO_ACTION'
        AND @INVRE_TRNIT_update_action = N'NO_ACTION'
        AND @INVRE_TRNIT_disabled = 0
        AND @INVRE_TRNIT_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_INVRE_TRNIT';
            PRINT N'            Columns                         : INVRE_TRNIT_id, INVRE_TRNIT_transaction_at';
            PRINT N'            References                      : sales.TransactionItem(TRNIT_id, TRNIT_transaction_at)';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_INVRE_TRNIT';
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END
    ELSE
    BEGIN

        DECLARE @INVRE_TRNIT_equivalent_name sysname;

        SELECT TOP (1)
            @INVRE_TRNIT_equivalent_name = fk.name

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.TransactionItem')
        AND fk.name <> N'FK_INVRE_TRNIT'
        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0
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
        );

        IF @INVRE_TRNIT_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';
            PRINT N'            Expected Name                  : FK_INVRE_TRNIT';
            PRINT N'            Actual Name                    : '
                + @INVRE_TRNIT_equivalent_name;
            PRINT N'            Existing constraint was preserved for review.';

        END
        ELSE
        BEGIN

            IF OBJECT_ID(N'inventory.FK_INVRE_TRNIT', N'F') IS NOT NULL
            BEGIN
                ;THROW 50985,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;
            END;


            ALTER TABLE inventory.InventoryReservation
                WITH CHECK
                ADD CONSTRAINT FK_INVRE_TRNIT
                FOREIGN KEY
                (
                    INVRE_TRNIT_id,
                    INVRE_TRNIT_transaction_at
                )
                REFERENCES sales.TransactionItem
                (
                    TRNIT_id,
                    TRNIT_transaction_at
                );


            ALTER TABLE inventory.InventoryReservation
                CHECK CONSTRAINT FK_INVRE_TRNIT;


            PRINT N'        [+] Foreign key constraint added    : FK_INVRE_TRNIT';
            PRINT N'            Columns                         : INVRE_TRNIT_id, INVRE_TRNIT_transaction_at';
            PRINT N'            References                      : sales.TransactionItem(TRNIT_id, TRNIT_transaction_at)';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_INVRE_PRDVA
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NULL
    BEGIN
        ;THROW 50986,
            N'Foreign key FK_INVRE_PRDVA cannot be deployed because catalog.ProductVariant does not exist.',
            1;
    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INVRE_PRDVA';


    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys
        WHERE parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND name = N'FK_INVRE_PRDVA'
    )
    BEGIN

        IF EXISTS
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
            AND pc.name = N'INVRE_PRDVA_id'
            AND rc.name = N'PRDVA_id'
        )
        BEGIN

            PRINT N'        [!] Functionally equivalent foreign key already exists';
            PRINT N'            Expected Name                  : FK_INVRE_PRDVA';
            PRINT N'            Existing constraint was preserved for review.';

        END
        ELSE
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                WITH CHECK
                ADD CONSTRAINT FK_INVRE_PRDVA
                FOREIGN KEY
                (
                    INVRE_PRDVA_id
                )
                REFERENCES catalog.ProductVariant
                (
                    PRDVA_id
                );


            ALTER TABLE inventory.InventoryReservation
                CHECK CONSTRAINT FK_INVRE_PRDVA;


            PRINT N'        [+] Foreign key constraint added    : FK_INVRE_PRDVA';
            PRINT N'            Column                          : INVRE_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END
    ELSE
    BEGIN

        IF EXISTS
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
            AND fk.name = N'FK_INVRE_PRDVA'
            AND fk.referenced_object_id =
                    OBJECT_ID(N'catalog.ProductVariant')
            AND pc.name = N'INVRE_PRDVA_id'
            AND rc.name = N'PRDVA_id'
            AND fk.delete_referential_action = 0
            AND fk.update_referential_action = 0
            AND fk.is_disabled = 0
            AND fk.is_not_trusted = 0
        )
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_INVRE_PRDVA';
            PRINT N'            Column                          : INVRE_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_INVRE_PRDVA';
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_INVRE_INVRS
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryReservationStatus', N'U') IS NULL
    BEGIN
        ;THROW 50987,
            N'Foreign key FK_INVRE_INVRS cannot be deployed because inventory.InventoryReservationStatus does not exist.',
            1;
    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INVRE_INVRS';


    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys
        WHERE parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND name = N'FK_INVRE_INVRS'
    )
    BEGIN

        IF EXISTS
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
            AND pc.name = N'INVRE_INVRS_id'
            AND rc.name = N'INVRS_id'
        )
        BEGIN

            PRINT N'        [!] Functionally equivalent foreign key already exists';
            PRINT N'            Expected Name                  : FK_INVRE_INVRS';
            PRINT N'            Existing constraint was preserved for review.';

        END
        ELSE
        BEGIN

            ALTER TABLE inventory.InventoryReservation
                WITH CHECK
                ADD CONSTRAINT FK_INVRE_INVRS
                FOREIGN KEY
                (
                    INVRE_INVRS_id
                )
                REFERENCES inventory.InventoryReservationStatus
                (
                    INVRS_id
                );


            ALTER TABLE inventory.InventoryReservation
                CHECK CONSTRAINT FK_INVRE_INVRS;


            PRINT N'        [+] Foreign key constraint added    : FK_INVRE_INVRS';
            PRINT N'            Column                          : INVRE_INVRS_id';
            PRINT N'            References                      : inventory.InventoryReservationStatus.INVRS_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END
    ELSE
    BEGIN

        IF EXISTS
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
            AND fk.name = N'FK_INVRE_INVRS'
            AND fk.referenced_object_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')
            AND pc.name = N'INVRE_INVRS_id'
            AND rc.name = N'INVRS_id'
            AND fk.delete_referential_action = 0
            AND fk.update_referential_action = 0
            AND fk.is_disabled = 0
            AND fk.is_not_trusted = 0
        )
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_INVRE_INVRS';
            PRINT N'            Column                          : INVRE_INVRS_id';
            PRINT N'            References                      : inventory.InventoryReservationStatus.INVRS_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_INVRE_INVRS';
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';