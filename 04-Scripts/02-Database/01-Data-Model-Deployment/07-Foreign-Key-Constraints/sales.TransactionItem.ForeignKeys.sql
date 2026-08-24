    PRINT N'';
    PRINT N'    ● sales.TransactionItem';
    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_TRNIT_TRN
    ==============================================================================*/

    DECLARE @TRNIT_TRN_FK_expected_name                sysname;
    DECLARE @TRNIT_TRN_FK_actual_name                  sysname;

    DECLARE @TRNIT_TRN_FK_actual_parent_table          nvarchar(517);
    DECLARE @TRNIT_TRN_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @TRNIT_TRN_FK_actual_referenced_table      nvarchar(517);
    DECLARE @TRNIT_TRN_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @TRNIT_TRN_FK_actual_delete_action         nvarchar(60);
    DECLARE @TRNIT_TRN_FK_actual_update_action         nvarchar(60);

    DECLARE @TRNIT_TRN_FK_actual_is_disabled           bit;
    DECLARE @TRNIT_TRN_FK_actual_is_not_trusted        bit;

    DECLARE @TRNIT_TRN_FK_equivalent_name              sysname;
    DECLARE @TRNIT_TRN_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @TRNIT_TRN_FK_equivalent_update_action     nvarchar(60);
    DECLARE @TRNIT_TRN_FK_equivalent_is_disabled       bit;
    DECLARE @TRNIT_TRN_FK_equivalent_is_not_trusted    bit;

    DECLARE @TRNIT_TRN_FK_conflict_parent              nvarchar(517);


    SET @TRNIT_TRN_FK_expected_name = N'FK_TRNIT_TRN';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'sales.TransactionItem', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.TransactionItem';

        ;THROW 50196,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because sales.TransactionItem does not exist.',
            1;

    END;


    IF OBJECT_ID(N'sales.[Transaction]', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.Transaction';

        ;THROW 50197,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because sales.Transaction does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_TRN_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : TRNIT_TRN_id';

        ;THROW 50198,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because TRNIT_TRN_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : TRNIT_transaction_at';

        ;THROW 50199,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because TRNIT_transaction_at does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRN_id';

        ;THROW 50200,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because referenced column sales.Transaction.TRN_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRN_transaction_at';

        ;THROW 50201,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because referenced column sales.Transaction.TRN_transaction_at does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            TRNIT_TRN_id           -> bigint NOT NULL
            TRN_id                 -> bigint NOT NULL
            TRNIT_transaction_at   -> datetime2 NOT NULL
            TRN_transaction_at     -> datetime2 NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.[Transaction]')

        WHERE parent_column.object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND parent_column.name =
                N'TRNIT_TRN_id'

        AND referenced_column.name =
                N'TRN_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale

        AND TYPE_NAME(parent_column.user_type_id) =
                N'bigint'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'bigint'
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : TRNIT_TRN_id -> TRN_id';

        ;THROW 50202,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because participating columns are incompatible.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.[Transaction]')

        WHERE parent_column.object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND parent_column.name =
                N'TRNIT_transaction_at'

        AND referenced_column.name =
                N'TRN_transaction_at'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale

        AND TYPE_NAME(parent_column.user_type_id) =
                N'datetime2'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'datetime2'
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : TRNIT_transaction_at -> TRN_transaction_at';

        ;THROW 50203,
            N'Foreign key FK_TRNIT_TRN cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_TRNIT_TRN';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @TRNIT_TRN_FK_actual_name =
            fk.name,

        @TRNIT_TRN_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @TRNIT_TRN_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @TRNIT_TRN_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @TRNIT_TRN_FK_actual_update_action =
            fk.update_referential_action_desc,

        @TRNIT_TRN_FK_actual_is_disabled =
            fk.is_disabled,

        @TRNIT_TRN_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @TRNIT_TRN_FK_actual_parent_columns =
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

        @TRNIT_TRN_FK_actual_referenced_columns =
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
            OBJECT_ID(N'sales.TransactionItem')

    AND fk.name =
            @TRNIT_TRN_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @TRNIT_TRN_FK_actual_name IS NOT NULL
    BEGIN

        IF @TRNIT_TRN_FK_actual_parent_table =
                N'[sales].[TransactionItem]'

        AND @TRNIT_TRN_FK_actual_parent_columns =
                N'TRNIT_TRN_id|TRNIT_transaction_at'

        AND @TRNIT_TRN_FK_actual_referenced_table =
                N'[sales].[Transaction]'

        AND @TRNIT_TRN_FK_actual_referenced_columns =
                N'TRN_id|TRN_transaction_at'

        AND @TRNIT_TRN_FK_actual_delete_action =
                N'CASCADE'

        AND @TRNIT_TRN_FK_actual_update_action =
                N'NO_ACTION'

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

            PRINT N'        [!] Foreign key mismatch             : FK_TRNIT_TRN';

            PRINT N'            Expected Table                  : sales.TransactionItem';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @TRNIT_TRN_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Columns                : TRNIT_TRN_id, TRNIT_transaction_at';
            PRINT N'            Actual Columns                  : '
                + COALESCE
                (
                    REPLACE
                    (
                        @TRNIT_TRN_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : sales.Transaction(TRN_id, TRN_transaction_at)';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @TRNIT_TRN_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Columns       : '
                + COALESCE
                (
                    REPLACE
                    (
                        @TRNIT_TRN_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : CASCADE';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @TRNIT_TRN_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @TRNIT_TRN_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRNIT_TRN_FK_actual_is_disabled
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
                        @TRNIT_TRN_FK_actual_is_not_trusted
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

            @TRNIT_TRN_FK_equivalent_name =
                fk.name,

            @TRNIT_TRN_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @TRNIT_TRN_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @TRNIT_TRN_FK_equivalent_is_disabled =
                fk.is_disabled,

            @TRNIT_TRN_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND fk.name <>
                @TRNIT_TRN_FK_expected_name

        AND fk.delete_referential_action = 1

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
                    N'TRNIT_TRN_id'

            AND rc.name =
                    N'TRN_id'
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
                    N'TRNIT_transaction_at'

            AND rc.name =
                    N'TRN_transaction_at'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @TRNIT_TRN_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_TRNIT_TRN';

            PRINT N'            Actual Name                    : '
                + @TRNIT_TRN_FK_equivalent_name;

            PRINT N'            Columns                         : TRNIT_TRN_id, TRNIT_transaction_at';

            PRINT N'            References                     : sales.Transaction(TRN_id, TRN_transaction_at)';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @TRNIT_TRN_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @TRNIT_TRN_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRNIT_TRN_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRNIT_TRN_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'sales.FK_TRNIT_TRN', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @TRNIT_TRN_FK_conflict_parent =
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
                            N'sales.FK_TRNIT_TRN',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_TRNIT_TRN';
                PRINT N'            Expected Table                  : sales.TransactionItem';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @TRNIT_TRN_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50204,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE sales.TransactionItem
                WITH CHECK
                ADD CONSTRAINT FK_TRNIT_TRN
                FOREIGN KEY
                (
                    TRNIT_TRN_id,
                    TRNIT_transaction_at
                )
                REFERENCES sales.[Transaction]
                (
                    TRN_id,
                    TRN_transaction_at
                )
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

    END;


    /*==============================================================================
        FOREIGN KEY: FK_TRNIT_PRDVA
    ==============================================================================*/

    DECLARE @TRNIT_PRDVA_FK_expected_name                sysname;
    DECLARE @TRNIT_PRDVA_FK_actual_name                  sysname;

    DECLARE @TRNIT_PRDVA_FK_actual_parent_table          nvarchar(517);
    DECLARE @TRNIT_PRDVA_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @TRNIT_PRDVA_FK_actual_referenced_table      nvarchar(517);
    DECLARE @TRNIT_PRDVA_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @TRNIT_PRDVA_FK_actual_delete_action         nvarchar(60);
    DECLARE @TRNIT_PRDVA_FK_actual_update_action         nvarchar(60);

    DECLARE @TRNIT_PRDVA_FK_actual_is_disabled           bit;
    DECLARE @TRNIT_PRDVA_FK_actual_is_not_trusted        bit;

    DECLARE @TRNIT_PRDVA_FK_equivalent_name              sysname;
    DECLARE @TRNIT_PRDVA_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @TRNIT_PRDVA_FK_equivalent_update_action     nvarchar(60);
    DECLARE @TRNIT_PRDVA_FK_equivalent_is_disabled       bit;
    DECLARE @TRNIT_PRDVA_FK_equivalent_is_not_trusted    bit;

    DECLARE @TRNIT_PRDVA_FK_conflict_parent              nvarchar(517);


    SET @TRNIT_PRDVA_FK_expected_name = N'FK_TRNIT_PRDVA';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'sales.TransactionItem', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.TransactionItem';

        ;THROW 50205,
            N'Foreign key FK_TRNIT_PRDVA cannot be deployed because sales.TransactionItem does not exist.',
            1;

    END;


    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductVariant';

        ;THROW 50206,
            N'Foreign key FK_TRNIT_PRDVA cannot be deployed because catalog.ProductVariant does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : TRNIT_PRDVA_id';

        ;THROW 50207,
            N'Foreign key FK_TRNIT_PRDVA cannot be deployed because TRNIT_PRDVA_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PRDVA_id';

        ;THROW 50208,
            N'Foreign key FK_TRNIT_PRDVA cannot be deployed because referenced column catalog.ProductVariant.PRDVA_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            TRNIT_PRDVA_id -> int NOT NULL
            PRDVA_id       -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

        WHERE parent_column.object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND parent_column.name =
                N'TRNIT_PRDVA_id'

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

        AND TYPE_NAME(parent_column.user_type_id) =
                N'int'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'int'
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : TRNIT_PRDVA_id -> PRDVA_id';

        ;THROW 50209,
            N'Foreign key FK_TRNIT_PRDVA cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_TRNIT_PRDVA';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @TRNIT_PRDVA_FK_actual_name =
            fk.name,

        @TRNIT_PRDVA_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @TRNIT_PRDVA_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @TRNIT_PRDVA_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @TRNIT_PRDVA_FK_actual_update_action =
            fk.update_referential_action_desc,

        @TRNIT_PRDVA_FK_actual_is_disabled =
            fk.is_disabled,

        @TRNIT_PRDVA_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @TRNIT_PRDVA_FK_actual_parent_columns =
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

        @TRNIT_PRDVA_FK_actual_referenced_columns =
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
            OBJECT_ID(N'sales.TransactionItem')

    AND fk.name =
            @TRNIT_PRDVA_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @TRNIT_PRDVA_FK_actual_name IS NOT NULL
    BEGIN

        IF @TRNIT_PRDVA_FK_actual_parent_table =
                N'[sales].[TransactionItem]'

        AND @TRNIT_PRDVA_FK_actual_parent_columns =
                N'TRNIT_PRDVA_id'

        AND @TRNIT_PRDVA_FK_actual_referenced_table =
                N'[catalog].[ProductVariant]'

        AND @TRNIT_PRDVA_FK_actual_referenced_columns =
                N'PRDVA_id'

        AND @TRNIT_PRDVA_FK_actual_delete_action =
                N'NO_ACTION'

        AND @TRNIT_PRDVA_FK_actual_update_action =
                N'NO_ACTION'

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

            PRINT N'        [!] Foreign key mismatch             : FK_TRNIT_PRDVA';

            PRINT N'            Expected Table                  : sales.TransactionItem';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @TRNIT_PRDVA_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : TRNIT_PRDVA_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @TRNIT_PRDVA_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.ProductVariant.PRDVA_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @TRNIT_PRDVA_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @TRNIT_PRDVA_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @TRNIT_PRDVA_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @TRNIT_PRDVA_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRNIT_PRDVA_FK_actual_is_disabled
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
                        @TRNIT_PRDVA_FK_actual_is_not_trusted
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

            @TRNIT_PRDVA_FK_equivalent_name =
                fk.name,

            @TRNIT_PRDVA_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @TRNIT_PRDVA_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @TRNIT_PRDVA_FK_equivalent_is_disabled =
                fk.is_disabled,

            @TRNIT_PRDVA_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND fk.name <>
                @TRNIT_PRDVA_FK_expected_name

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
                    N'TRNIT_PRDVA_id'

            AND rc.name =
                    N'PRDVA_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @TRNIT_PRDVA_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_TRNIT_PRDVA';

            PRINT N'            Actual Name                    : '
                + @TRNIT_PRDVA_FK_equivalent_name;

            PRINT N'            Column                         : TRNIT_PRDVA_id';

            PRINT N'            References                     : catalog.ProductVariant.PRDVA_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @TRNIT_PRDVA_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @TRNIT_PRDVA_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRNIT_PRDVA_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRNIT_PRDVA_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'sales.FK_TRNIT_PRDVA', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @TRNIT_PRDVA_FK_conflict_parent =
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
                            N'sales.FK_TRNIT_PRDVA',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_TRNIT_PRDVA';
                PRINT N'            Expected Table                  : sales.TransactionItem';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @TRNIT_PRDVA_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50210,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE sales.TransactionItem
                WITH CHECK
                ADD CONSTRAINT FK_TRNIT_PRDVA
                FOREIGN KEY
                (
                    TRNIT_PRDVA_id
                )
                REFERENCES catalog.ProductVariant
                (
                    PRDVA_id
                );


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

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';