    PRINT N'';
    PRINT N'    ● inventory.InventoryReservation';
    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_INVRE_TRNIT
    ==============================================================================*/

    DECLARE @INVRE_TRNIT_FK_expected_name                sysname;
    DECLARE @INVRE_TRNIT_FK_actual_name                  sysname;

    DECLARE @INVRE_TRNIT_FK_actual_parent_table          nvarchar(517);
    DECLARE @INVRE_TRNIT_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @INVRE_TRNIT_FK_actual_referenced_table      nvarchar(517);
    DECLARE @INVRE_TRNIT_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @INVRE_TRNIT_FK_actual_delete_action         nvarchar(60);
    DECLARE @INVRE_TRNIT_FK_actual_update_action         nvarchar(60);

    DECLARE @INVRE_TRNIT_FK_actual_is_disabled           bit;
    DECLARE @INVRE_TRNIT_FK_actual_is_not_trusted        bit;

    DECLARE @INVRE_TRNIT_FK_equivalent_name              sysname;
    DECLARE @INVRE_TRNIT_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @INVRE_TRNIT_FK_equivalent_update_action     nvarchar(60);
    DECLARE @INVRE_TRNIT_FK_equivalent_is_disabled       bit;
    DECLARE @INVRE_TRNIT_FK_equivalent_is_not_trusted    bit;

    DECLARE @INVRE_TRNIT_FK_conflict_parent              nvarchar(517);


    SET @INVRE_TRNIT_FK_expected_name = N'FK_INVRE_TRNIT';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryReservation', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.InventoryReservation';

        ;THROW 50980,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because inventory.InventoryReservation does not exist.',
            1;

    END;


    IF OBJECT_ID(N'sales.TransactionItem', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.TransactionItem';

        ;THROW 50981,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because sales.TransactionItem does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_TRNIT_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : INVRE_TRNIT_id';

        ;THROW 50982,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because INVRE_TRNIT_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_TRNIT_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : INVRE_TRNIT_transaction_at';

        ;THROW 50983,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because INVRE_TRNIT_transaction_at does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRNIT_id';

        ;THROW 50984,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because referenced column sales.TransactionItem.TRNIT_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRNIT_transaction_at';

        ;THROW 50985,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because referenced column sales.TransactionItem.TRNIT_transaction_at does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            INVRE_TRNIT_id             -> TRNIT_id
            INVRE_TRNIT_transaction_at -> TRNIT_transaction_at
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

        WHERE parent_column.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')

        AND parent_column.name =
                N'INVRE_TRNIT_id'

        AND referenced_column.name =
                N'TRNIT_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : INVRE_TRNIT_id -> TRNIT_id';

        ;THROW 50986,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because participating columns are incompatible.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

        WHERE parent_column.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')

        AND parent_column.name =
                N'INVRE_TRNIT_transaction_at'

        AND referenced_column.name =
                N'TRNIT_transaction_at'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : INVRE_TRNIT_transaction_at -> TRNIT_transaction_at';

        ;THROW 50987,
            N'Foreign key FK_INVRE_TRNIT cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INVRE_TRNIT';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @INVRE_TRNIT_FK_actual_name =
            fk.name,

        @INVRE_TRNIT_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @INVRE_TRNIT_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @INVRE_TRNIT_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @INVRE_TRNIT_FK_actual_update_action =
            fk.update_referential_action_desc,

        @INVRE_TRNIT_FK_actual_is_disabled =
            fk.is_disabled,

        @INVRE_TRNIT_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @INVRE_TRNIT_FK_actual_parent_columns =
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

        @INVRE_TRNIT_FK_actual_referenced_columns =
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
            OBJECT_ID(N'inventory.InventoryReservation')

    AND fk.name =
            @INVRE_TRNIT_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @INVRE_TRNIT_FK_actual_name IS NOT NULL
    BEGIN

        IF @INVRE_TRNIT_FK_actual_parent_table =
                N'[inventory].[InventoryReservation]'

        AND @INVRE_TRNIT_FK_actual_parent_columns =
                N'INVRE_TRNIT_id|INVRE_TRNIT_transaction_at'

        AND @INVRE_TRNIT_FK_actual_referenced_table =
                N'[sales].[TransactionItem]'

        AND @INVRE_TRNIT_FK_actual_referenced_columns =
                N'TRNIT_id|TRNIT_transaction_at'

        AND @INVRE_TRNIT_FK_actual_delete_action =
                N'NO_ACTION'

        AND @INVRE_TRNIT_FK_actual_update_action =
                N'NO_ACTION'

        AND @INVRE_TRNIT_FK_actual_is_disabled = 0

        AND @INVRE_TRNIT_FK_actual_is_not_trusted = 0
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

            PRINT N'            Expected Table                  : inventory.InventoryReservation';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @INVRE_TRNIT_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Columns                : INVRE_TRNIT_id, INVRE_TRNIT_transaction_at';
            PRINT N'            Actual Columns                  : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVRE_TRNIT_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : sales.TransactionItem(TRNIT_id, TRNIT_transaction_at)';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @INVRE_TRNIT_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Columns       : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVRE_TRNIT_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @INVRE_TRNIT_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @INVRE_TRNIT_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_TRNIT_FK_actual_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_TRNIT_FK_actual_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END

    ELSE
    BEGIN

        /*==============================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==============================================================================*/

        SELECT TOP (1)

            @INVRE_TRNIT_FK_equivalent_name =
                fk.name,

            @INVRE_TRNIT_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @INVRE_TRNIT_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @INVRE_TRNIT_FK_equivalent_is_disabled =
                fk.is_disabled,

            @INVRE_TRNIT_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')

        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND fk.name <>
                @INVRE_TRNIT_FK_expected_name

        AND fk.delete_referential_action = 0

        AND fk.update_referential_action = 0

        AND
        (
            SELECT COUNT(*)

            FROM sys.foreign_key_columns AS fkc

            WHERE fkc.constraint_object_id =
                    fk.object_id

        ) = 2

        AND EXISTS
        (
            SELECT 1

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS pc
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'INVRE_TRNIT_id'

            AND rc.name =
                    N'TRNIT_id'
        )

        AND EXISTS
        (
            SELECT 1

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS pc
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 2

            AND pc.name =
                    N'INVRE_TRNIT_transaction_at'

            AND rc.name =
                    N'TRNIT_transaction_at'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @INVRE_TRNIT_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_INVRE_TRNIT';

            PRINT N'            Actual Name                    : '
                + @INVRE_TRNIT_FK_equivalent_name;

            PRINT N'            Columns                         : INVRE_TRNIT_id, INVRE_TRNIT_transaction_at';

            PRINT N'            References                     : sales.TransactionItem(TRNIT_id, TRNIT_transaction_at)';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @INVRE_TRNIT_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @INVRE_TRNIT_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_TRNIT_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_TRNIT_FK_equivalent_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END

        ELSE
        BEGIN

            /*==============================================================================
                VALIDATE EXPECTED NAME IS NOT USED BY ANOTHER FK
            ==============================================================================*/

            IF OBJECT_ID(N'inventory.FK_INVRE_TRNIT', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @INVRE_TRNIT_FK_conflict_parent =
                        QUOTENAME
                        (
                            OBJECT_SCHEMA_NAME
                            (
                                fk.parent_object_id
                            )
                        )
                        + N'.'
                        + QUOTENAME
                        (
                            OBJECT_NAME
                            (
                                fk.parent_object_id
                            )
                        )

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID
                        (
                            N'inventory.FK_INVRE_TRNIT',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_INVRE_TRNIT';
                PRINT N'            Expected Table                  : inventory.InventoryReservation';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @INVRE_TRNIT_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50988,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

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

    DECLARE @INVRE_PRDVA_FK_expected_name                sysname;
    DECLARE @INVRE_PRDVA_FK_actual_name                  sysname;

    DECLARE @INVRE_PRDVA_FK_actual_parent_table          nvarchar(517);
    DECLARE @INVRE_PRDVA_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @INVRE_PRDVA_FK_actual_referenced_table      nvarchar(517);
    DECLARE @INVRE_PRDVA_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @INVRE_PRDVA_FK_actual_delete_action         nvarchar(60);
    DECLARE @INVRE_PRDVA_FK_actual_update_action         nvarchar(60);

    DECLARE @INVRE_PRDVA_FK_actual_is_disabled           bit;
    DECLARE @INVRE_PRDVA_FK_actual_is_not_trusted        bit;

    DECLARE @INVRE_PRDVA_FK_equivalent_name              sysname;
    DECLARE @INVRE_PRDVA_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @INVRE_PRDVA_FK_equivalent_update_action     nvarchar(60);
    DECLARE @INVRE_PRDVA_FK_equivalent_is_disabled       bit;
    DECLARE @INVRE_PRDVA_FK_equivalent_is_not_trusted    bit;

    DECLARE @INVRE_PRDVA_FK_conflict_parent              nvarchar(517);


    SET @INVRE_PRDVA_FK_expected_name = N'FK_INVRE_PRDVA';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryReservation', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.InventoryReservation';

        ;THROW 50989,
            N'Foreign key FK_INVRE_PRDVA cannot be deployed because inventory.InventoryReservation does not exist.',
            1;

    END;


    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductVariant';

        ;THROW 50990,
            N'Foreign key FK_INVRE_PRDVA cannot be deployed because catalog.ProductVariant does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : INVRE_PRDVA_id';

        ;THROW 50991,
            N'Foreign key FK_INVRE_PRDVA cannot be deployed because INVRE_PRDVA_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PRDVA_id';

        ;THROW 50992,
            N'Foreign key FK_INVRE_PRDVA cannot be deployed because referenced column catalog.ProductVariant.PRDVA_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            INVRE_PRDVA_id -> PRDVA_id
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

        WHERE parent_column.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')

        AND parent_column.name =
                N'INVRE_PRDVA_id'

        AND referenced_column.name =
                N'PRDVA_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : INVRE_PRDVA_id -> PRDVA_id';

        ;THROW 50993,
            N'Foreign key FK_INVRE_PRDVA cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INVRE_PRDVA';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @INVRE_PRDVA_FK_actual_name =
            fk.name,

        @INVRE_PRDVA_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @INVRE_PRDVA_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @INVRE_PRDVA_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @INVRE_PRDVA_FK_actual_update_action =
            fk.update_referential_action_desc,

        @INVRE_PRDVA_FK_actual_is_disabled =
            fk.is_disabled,

        @INVRE_PRDVA_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @INVRE_PRDVA_FK_actual_parent_columns =
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

        @INVRE_PRDVA_FK_actual_referenced_columns =
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
            OBJECT_ID(N'inventory.InventoryReservation')

    AND fk.name =
            @INVRE_PRDVA_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @INVRE_PRDVA_FK_actual_name IS NOT NULL
    BEGIN

        IF @INVRE_PRDVA_FK_actual_parent_table =
                N'[inventory].[InventoryReservation]'

        AND @INVRE_PRDVA_FK_actual_parent_columns =
                N'INVRE_PRDVA_id'

        AND @INVRE_PRDVA_FK_actual_referenced_table =
                N'[catalog].[ProductVariant]'

        AND @INVRE_PRDVA_FK_actual_referenced_columns =
                N'PRDVA_id'

        AND @INVRE_PRDVA_FK_actual_delete_action =
                N'NO_ACTION'

        AND @INVRE_PRDVA_FK_actual_update_action =
                N'NO_ACTION'

        AND @INVRE_PRDVA_FK_actual_is_disabled = 0

        AND @INVRE_PRDVA_FK_actual_is_not_trusted = 0
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

            PRINT N'            Expected Table                  : inventory.InventoryReservation';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @INVRE_PRDVA_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : INVRE_PRDVA_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVRE_PRDVA_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.ProductVariant.PRDVA_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @INVRE_PRDVA_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVRE_PRDVA_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @INVRE_PRDVA_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @INVRE_PRDVA_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_PRDVA_FK_actual_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_PRDVA_FK_actual_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END

    ELSE
    BEGIN

        /*==============================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==============================================================================*/

        SELECT TOP (1)

            @INVRE_PRDVA_FK_equivalent_name =
                fk.name,

            @INVRE_PRDVA_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @INVRE_PRDVA_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @INVRE_PRDVA_FK_equivalent_is_disabled =
                fk.is_disabled,

            @INVRE_PRDVA_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND fk.name <>
                @INVRE_PRDVA_FK_expected_name

        AND fk.delete_referential_action = 0

        AND fk.update_referential_action = 0

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
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'INVRE_PRDVA_id'

            AND rc.name =
                    N'PRDVA_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @INVRE_PRDVA_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_INVRE_PRDVA';

            PRINT N'            Actual Name                    : '
                + @INVRE_PRDVA_FK_equivalent_name;

            PRINT N'            Column                         : INVRE_PRDVA_id';

            PRINT N'            References                     : catalog.ProductVariant.PRDVA_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @INVRE_PRDVA_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @INVRE_PRDVA_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_PRDVA_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_PRDVA_FK_equivalent_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END

        ELSE
        BEGIN

            /*==============================================================================
                VALIDATE EXPECTED NAME IS NOT USED BY ANOTHER FK
            ==============================================================================*/

            IF OBJECT_ID(N'inventory.FK_INVRE_PRDVA', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @INVRE_PRDVA_FK_conflict_parent =
                        QUOTENAME
                        (
                            OBJECT_SCHEMA_NAME
                            (
                                fk.parent_object_id
                            )
                        )
                        + N'.'
                        + QUOTENAME
                        (
                            OBJECT_NAME
                            (
                                fk.parent_object_id
                            )
                        )

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID
                        (
                            N'inventory.FK_INVRE_PRDVA',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_INVRE_PRDVA';
                PRINT N'            Expected Table                  : inventory.InventoryReservation';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @INVRE_PRDVA_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50994,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

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

    END;


    /*==============================================================================
        FOREIGN KEY: FK_INVRE_INVRS
    ==============================================================================*/

    DECLARE @INVRE_INVRS_FK_expected_name                sysname;
    DECLARE @INVRE_INVRS_FK_actual_name                  sysname;

    DECLARE @INVRE_INVRS_FK_actual_parent_table          nvarchar(517);
    DECLARE @INVRE_INVRS_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @INVRE_INVRS_FK_actual_referenced_table      nvarchar(517);
    DECLARE @INVRE_INVRS_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @INVRE_INVRS_FK_actual_delete_action         nvarchar(60);
    DECLARE @INVRE_INVRS_FK_actual_update_action         nvarchar(60);

    DECLARE @INVRE_INVRS_FK_actual_is_disabled           bit;
    DECLARE @INVRE_INVRS_FK_actual_is_not_trusted        bit;

    DECLARE @INVRE_INVRS_FK_equivalent_name              sysname;
    DECLARE @INVRE_INVRS_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @INVRE_INVRS_FK_equivalent_update_action     nvarchar(60);
    DECLARE @INVRE_INVRS_FK_equivalent_is_disabled       bit;
    DECLARE @INVRE_INVRS_FK_equivalent_is_not_trusted    bit;

    DECLARE @INVRE_INVRS_FK_conflict_parent              nvarchar(517);


    SET @INVRE_INVRS_FK_expected_name = N'FK_INVRE_INVRS';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryReservation', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.InventoryReservation';

        ;THROW 50995,
            N'Foreign key FK_INVRE_INVRS cannot be deployed because inventory.InventoryReservation does not exist.',
            1;

    END;


    IF OBJECT_ID(N'inventory.InventoryReservationStatus', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.InventoryReservationStatus';

        ;THROW 50996,
            N'Foreign key FK_INVRE_INVRS cannot be deployed because inventory.InventoryReservationStatus does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_INVRS_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : INVRE_INVRS_id';

        ;THROW 50997,
            N'Foreign key FK_INVRE_INVRS cannot be deployed because INVRE_INVRS_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryReservationStatus', N'INVRS_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : INVRS_id';

        ;THROW 50998,
            N'Foreign key FK_INVRE_INVRS cannot be deployed because referenced column inventory.InventoryReservationStatus.INVRS_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            INVRE_INVRS_id -> INVRS_id
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'inventory.InventoryReservationStatus')

        WHERE parent_column.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')

        AND parent_column.name =
                N'INVRE_INVRS_id'

        AND referenced_column.name =
                N'INVRS_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : INVRE_INVRS_id -> INVRS_id';

        ;THROW 50999,
            N'Foreign key FK_INVRE_INVRS cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INVRE_INVRS';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @INVRE_INVRS_FK_actual_name =
            fk.name,

        @INVRE_INVRS_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @INVRE_INVRS_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @INVRE_INVRS_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @INVRE_INVRS_FK_actual_update_action =
            fk.update_referential_action_desc,

        @INVRE_INVRS_FK_actual_is_disabled =
            fk.is_disabled,

        @INVRE_INVRS_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @INVRE_INVRS_FK_actual_parent_columns =
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

        @INVRE_INVRS_FK_actual_referenced_columns =
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
            OBJECT_ID(N'inventory.InventoryReservation')

    AND fk.name =
            @INVRE_INVRS_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @INVRE_INVRS_FK_actual_name IS NOT NULL
    BEGIN

        IF @INVRE_INVRS_FK_actual_parent_table =
                N'[inventory].[InventoryReservation]'

        AND @INVRE_INVRS_FK_actual_parent_columns =
                N'INVRE_INVRS_id'

        AND @INVRE_INVRS_FK_actual_referenced_table =
                N'[inventory].[InventoryReservationStatus]'

        AND @INVRE_INVRS_FK_actual_referenced_columns =
                N'INVRS_id'

        AND @INVRE_INVRS_FK_actual_delete_action =
                N'NO_ACTION'

        AND @INVRE_INVRS_FK_actual_update_action =
                N'NO_ACTION'

        AND @INVRE_INVRS_FK_actual_is_disabled = 0

        AND @INVRE_INVRS_FK_actual_is_not_trusted = 0
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

            PRINT N'            Expected Table                  : inventory.InventoryReservation';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @INVRE_INVRS_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : INVRE_INVRS_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVRE_INVRS_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : inventory.InventoryReservationStatus.INVRS_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @INVRE_INVRS_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVRE_INVRS_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @INVRE_INVRS_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @INVRE_INVRS_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_INVRS_FK_actual_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_INVRS_FK_actual_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END

    ELSE
    BEGIN

        /*==============================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==============================================================================*/

        SELECT TOP (1)

            @INVRE_INVRS_FK_equivalent_name =
                fk.name,

            @INVRE_INVRS_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @INVRE_INVRS_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @INVRE_INVRS_FK_equivalent_is_disabled =
                fk.is_disabled,

            @INVRE_INVRS_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')

        AND fk.referenced_object_id =
                OBJECT_ID(N'inventory.InventoryReservationStatus')

        AND fk.name <>
                @INVRE_INVRS_FK_expected_name

        AND fk.delete_referential_action = 0

        AND fk.update_referential_action = 0

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
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'INVRE_INVRS_id'

            AND rc.name =
                    N'INVRS_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @INVRE_INVRS_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_INVRE_INVRS';

            PRINT N'            Actual Name                    : '
                + @INVRE_INVRS_FK_equivalent_name;

            PRINT N'            Column                         : INVRE_INVRS_id';

            PRINT N'            References                     : inventory.InventoryReservationStatus.INVRS_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @INVRE_INVRS_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @INVRE_INVRS_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_INVRS_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_INVRS_FK_equivalent_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END

        ELSE
        BEGIN

            /*==============================================================================
                VALIDATE EXPECTED NAME IS NOT USED BY ANOTHER FK
            ==============================================================================*/

            IF OBJECT_ID(N'inventory.FK_INVRE_INVRS', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @INVRE_INVRS_FK_conflict_parent =
                        QUOTENAME
                        (
                            OBJECT_SCHEMA_NAME
                            (
                                fk.parent_object_id
                            )
                        )
                        + N'.'
                        + QUOTENAME
                        (
                            OBJECT_NAME
                            (
                                fk.parent_object_id
                            )
                        )

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID
                        (
                            N'inventory.FK_INVRE_INVRS',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_INVRE_INVRS';
                PRINT N'            Expected Table                  : inventory.InventoryReservation';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @INVRE_INVRS_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 51000,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

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

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';