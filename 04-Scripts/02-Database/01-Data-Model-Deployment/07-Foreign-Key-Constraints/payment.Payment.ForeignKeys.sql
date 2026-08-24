    PRINT N'';
    PRINT N'    ● payment.Payment';
    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_PAY_TRN
    ==============================================================================*/

    DECLARE @PAY_TRN_FK_expected_name                sysname;
    DECLARE @PAY_TRN_FK_actual_name                  sysname;

    DECLARE @PAY_TRN_FK_actual_parent_table          nvarchar(517);
    DECLARE @PAY_TRN_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @PAY_TRN_FK_actual_referenced_table      nvarchar(517);
    DECLARE @PAY_TRN_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @PAY_TRN_FK_actual_delete_action         nvarchar(60);
    DECLARE @PAY_TRN_FK_actual_update_action         nvarchar(60);

    DECLARE @PAY_TRN_FK_actual_is_disabled           bit;
    DECLARE @PAY_TRN_FK_actual_is_not_trusted        bit;

    DECLARE @PAY_TRN_FK_equivalent_name              sysname;
    DECLARE @PAY_TRN_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @PAY_TRN_FK_equivalent_update_action     nvarchar(60);
    DECLARE @PAY_TRN_FK_equivalent_is_disabled       bit;
    DECLARE @PAY_TRN_FK_equivalent_is_not_trusted    bit;

    DECLARE @PAY_TRN_FK_conflict_parent              nvarchar(517);


    SET @PAY_TRN_FK_expected_name = N'FK_PAY_TRN';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'payment.Payment', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : payment.Payment';

        ;THROW 50950,
            N'Foreign key FK_PAY_TRN cannot be deployed because payment.Payment does not exist.',
            1;

    END;


    IF OBJECT_ID(N'sales.[Transaction]', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.Transaction';

        ;THROW 50951,
            N'Foreign key FK_PAY_TRN cannot be deployed because sales.Transaction does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.Payment', N'PAY_TRN_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PAY_TRN_id';

        ;THROW 50952,
            N'Foreign key FK_PAY_TRN cannot be deployed because PAY_TRN_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.Payment', N'PAY_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PAY_transaction_at';

        ;THROW 50953,
            N'Foreign key FK_PAY_TRN cannot be deployed because PAY_transaction_at does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRN_id';

        ;THROW 50954,
            N'Foreign key FK_PAY_TRN cannot be deployed because referenced column sales.Transaction.TRN_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRN_transaction_at';

        ;THROW 50955,
            N'Foreign key FK_PAY_TRN cannot be deployed because referenced column sales.Transaction.TRN_transaction_at does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PAY_TRN_id         -> bigint NOT NULL
            TRN_id             -> bigint NOT NULL

            PAY_transaction_at -> datetime2(0) NOT NULL
            TRN_transaction_at -> datetime2(0) NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.[Transaction]')

        WHERE parent_column.object_id =
                OBJECT_ID(N'payment.Payment')

        AND parent_column.name =
                N'PAY_TRN_id'

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

        PRINT N'        [X] Foreign key column mismatch    : PAY_TRN_id -> TRN_id';

        ;THROW 50956,
            N'Foreign key FK_PAY_TRN cannot be deployed because PAY_TRN_id and TRN_id are incompatible.',
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
                OBJECT_ID(N'payment.Payment')

        AND parent_column.name =
                N'PAY_transaction_at'

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

        PRINT N'        [X] Foreign key column mismatch    : PAY_transaction_at -> TRN_transaction_at';

        ;THROW 50957,
            N'Foreign key FK_PAY_TRN cannot be deployed because PAY_transaction_at and TRN_transaction_at are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PAY_TRN';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @PAY_TRN_FK_actual_name =
            fk.name,

        @PAY_TRN_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PAY_TRN_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PAY_TRN_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @PAY_TRN_FK_actual_update_action =
            fk.update_referential_action_desc,

        @PAY_TRN_FK_actual_is_disabled =
            fk.is_disabled,

        @PAY_TRN_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @PAY_TRN_FK_actual_parent_columns =
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

        @PAY_TRN_FK_actual_referenced_columns =
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
            OBJECT_ID(N'payment.Payment')

    AND fk.name =
            @PAY_TRN_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @PAY_TRN_FK_actual_name IS NOT NULL
    BEGIN

        IF @PAY_TRN_FK_actual_parent_table =
                N'[payment].[Payment]'

        AND @PAY_TRN_FK_actual_parent_columns =
                N'PAY_TRN_id|PAY_transaction_at'

        AND @PAY_TRN_FK_actual_referenced_table =
                N'[sales].[Transaction]'

        AND @PAY_TRN_FK_actual_referenced_columns =
                N'TRN_id|TRN_transaction_at'

        AND @PAY_TRN_FK_actual_delete_action =
                N'NO_ACTION'

        AND @PAY_TRN_FK_actual_update_action =
                N'NO_ACTION'

        AND @PAY_TRN_FK_actual_is_disabled = 0

        AND @PAY_TRN_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PAY_TRN';
            PRINT N'            Columns                         : PAY_TRN_id, PAY_transaction_at';
            PRINT N'            References                      : sales.Transaction(TRN_id, TRN_transaction_at)';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PAY_TRN';

            PRINT N'            Expected Table                  : payment.Payment';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @PAY_TRN_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Columns                : PAY_TRN_id, PAY_transaction_at';
            PRINT N'            Actual Columns                  : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PAY_TRN_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : sales.Transaction(TRN_id, TRN_transaction_at)';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @PAY_TRN_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Columns       : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PAY_TRN_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @PAY_TRN_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @PAY_TRN_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAY_TRN_FK_actual_is_disabled
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
                        @PAY_TRN_FK_actual_is_not_trusted
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

            @PAY_TRN_FK_equivalent_name =
                fk.name,

            @PAY_TRN_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PAY_TRN_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @PAY_TRN_FK_equivalent_is_disabled =
                fk.is_disabled,

            @PAY_TRN_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'payment.Payment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND fk.name <>
                @PAY_TRN_FK_expected_name

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
                    N'PAY_TRN_id'

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
                    N'PAY_transaction_at'

            AND rc.name =
                    N'TRN_transaction_at'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @PAY_TRN_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PAY_TRN';

            PRINT N'            Actual Name                    : '
                + @PAY_TRN_FK_equivalent_name;

            PRINT N'            Columns                         : PAY_TRN_id, PAY_transaction_at';

            PRINT N'            References                     : sales.Transaction(TRN_id, TRN_transaction_at)';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PAY_TRN_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PAY_TRN_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAY_TRN_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAY_TRN_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'payment.FK_PAY_TRN', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PAY_TRN_FK_conflict_parent =
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
                            N'payment.FK_PAY_TRN',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PAY_TRN';
                PRINT N'            Expected Table                  : payment.Payment';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PAY_TRN_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50958,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE payment.Payment
                WITH CHECK
                ADD CONSTRAINT FK_PAY_TRN
                FOREIGN KEY
                (
                    PAY_TRN_id,
                    PAY_transaction_at
                )
                REFERENCES sales.[Transaction]
                (
                    TRN_id,
                    TRN_transaction_at
                );


            ALTER TABLE payment.Payment
                CHECK CONSTRAINT FK_PAY_TRN;


            PRINT N'        [+] Foreign key constraint added    : FK_PAY_TRN';
            PRINT N'            Columns                         : PAY_TRN_id, PAY_transaction_at';
            PRINT N'            References                      : sales.Transaction(TRN_id, TRN_transaction_at)';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_PAY_PAYME
    ==============================================================================*/

    DECLARE @PAY_PAYME_FK_expected_name                sysname;
    DECLARE @PAY_PAYME_FK_actual_name                  sysname;

    DECLARE @PAY_PAYME_FK_actual_parent_table          nvarchar(517);
    DECLARE @PAY_PAYME_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @PAY_PAYME_FK_actual_referenced_table      nvarchar(517);
    DECLARE @PAY_PAYME_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @PAY_PAYME_FK_actual_delete_action         nvarchar(60);
    DECLARE @PAY_PAYME_FK_actual_update_action         nvarchar(60);

    DECLARE @PAY_PAYME_FK_actual_is_disabled           bit;
    DECLARE @PAY_PAYME_FK_actual_is_not_trusted        bit;

    DECLARE @PAY_PAYME_FK_equivalent_name              sysname;
    DECLARE @PAY_PAYME_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @PAY_PAYME_FK_equivalent_update_action     nvarchar(60);
    DECLARE @PAY_PAYME_FK_equivalent_is_disabled       bit;
    DECLARE @PAY_PAYME_FK_equivalent_is_not_trusted    bit;

    DECLARE @PAY_PAYME_FK_conflict_parent              nvarchar(517);


    SET @PAY_PAYME_FK_expected_name = N'FK_PAY_PAYME';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'payment.Payment', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : payment.Payment';

        ;THROW 50960,
            N'Foreign key FK_PAY_PAYME cannot be deployed because payment.Payment does not exist.',
            1;

    END;


    IF OBJECT_ID(N'payment.PaymentMethod', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : payment.PaymentMethod';

        ;THROW 50961,
            N'Foreign key FK_PAY_PAYME cannot be deployed because payment.PaymentMethod does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.Payment', N'PAY_PAYME_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PAY_PAYME_id';

        ;THROW 50962,
            N'Foreign key FK_PAY_PAYME cannot be deployed because PAY_PAYME_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.PaymentMethod', N'PAYME_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PAYME_id';

        ;THROW 50963,
            N'Foreign key FK_PAY_PAYME cannot be deployed because referenced column payment.PaymentMethod.PAYME_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PAY_PAYME_id -> tinyint NOT NULL
            PAYME_id     -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'payment.PaymentMethod')

        WHERE parent_column.object_id =
                OBJECT_ID(N'payment.Payment')

        AND parent_column.name =
                N'PAY_PAYME_id'

        AND referenced_column.name =
                N'PAYME_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale

        AND TYPE_NAME(parent_column.user_type_id) =
                N'tinyint'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'tinyint'
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : PAY_PAYME_id -> PAYME_id';

        ;THROW 50964,
            N'Foreign key FK_PAY_PAYME cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PAY_PAYME';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @PAY_PAYME_FK_actual_name =
            fk.name,

        @PAY_PAYME_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PAY_PAYME_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PAY_PAYME_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @PAY_PAYME_FK_actual_update_action =
            fk.update_referential_action_desc,

        @PAY_PAYME_FK_actual_is_disabled =
            fk.is_disabled,

        @PAY_PAYME_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @PAY_PAYME_FK_actual_parent_columns =
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

        @PAY_PAYME_FK_actual_referenced_columns =
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
            OBJECT_ID(N'payment.Payment')

    AND fk.name =
            @PAY_PAYME_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @PAY_PAYME_FK_actual_name IS NOT NULL
    BEGIN

        IF @PAY_PAYME_FK_actual_parent_table =
                N'[payment].[Payment]'

        AND @PAY_PAYME_FK_actual_parent_columns =
                N'PAY_PAYME_id'

        AND @PAY_PAYME_FK_actual_referenced_table =
                N'[payment].[PaymentMethod]'

        AND @PAY_PAYME_FK_actual_referenced_columns =
                N'PAYME_id'

        AND @PAY_PAYME_FK_actual_delete_action =
                N'NO_ACTION'

        AND @PAY_PAYME_FK_actual_update_action =
                N'NO_ACTION'

        AND @PAY_PAYME_FK_actual_is_disabled = 0

        AND @PAY_PAYME_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PAY_PAYME';
            PRINT N'            Column                          : PAY_PAYME_id';
            PRINT N'            References                      : payment.PaymentMethod.PAYME_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PAY_PAYME';

            PRINT N'            Expected Table                  : payment.Payment';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @PAY_PAYME_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : PAY_PAYME_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PAY_PAYME_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : payment.PaymentMethod.PAYME_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @PAY_PAYME_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PAY_PAYME_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @PAY_PAYME_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @PAY_PAYME_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAY_PAYME_FK_actual_is_disabled
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
                        @PAY_PAYME_FK_actual_is_not_trusted
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

            @PAY_PAYME_FK_equivalent_name =
                fk.name,

            @PAY_PAYME_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PAY_PAYME_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @PAY_PAYME_FK_equivalent_is_disabled =
                fk.is_disabled,

            @PAY_PAYME_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'payment.Payment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'payment.PaymentMethod')

        AND fk.name <>
                @PAY_PAYME_FK_expected_name

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
                    N'PAY_PAYME_id'

            AND rc.name =
                    N'PAYME_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @PAY_PAYME_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PAY_PAYME';

            PRINT N'            Actual Name                    : '
                + @PAY_PAYME_FK_equivalent_name;

            PRINT N'            Column                         : PAY_PAYME_id';

            PRINT N'            References                     : payment.PaymentMethod.PAYME_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PAY_PAYME_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PAY_PAYME_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAY_PAYME_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAY_PAYME_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'payment.FK_PAY_PAYME', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PAY_PAYME_FK_conflict_parent =
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
                            N'payment.FK_PAY_PAYME',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PAY_PAYME';
                PRINT N'            Expected Table                  : payment.Payment';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PAY_PAYME_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50965,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE payment.Payment
                WITH CHECK
                ADD CONSTRAINT FK_PAY_PAYME
                FOREIGN KEY
                (
                    PAY_PAYME_id
                )
                REFERENCES payment.PaymentMethod
                (
                    PAYME_id
                );


            ALTER TABLE payment.Payment
                CHECK CONSTRAINT FK_PAY_PAYME;


            PRINT N'        [+] Foreign key constraint added    : FK_PAY_PAYME';
            PRINT N'            Column                          : PAY_PAYME_id';
            PRINT N'            References                      : payment.PaymentMethod.PAYME_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_PAY_PAYST
    ==============================================================================*/

    DECLARE @PAY_PAYST_FK_expected_name                sysname;
    DECLARE @PAY_PAYST_FK_actual_name                  sysname;

    DECLARE @PAY_PAYST_FK_actual_parent_table          nvarchar(517);
    DECLARE @PAY_PAYST_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @PAY_PAYST_FK_actual_referenced_table      nvarchar(517);
    DECLARE @PAY_PAYST_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @PAY_PAYST_FK_actual_delete_action         nvarchar(60);
    DECLARE @PAY_PAYST_FK_actual_update_action         nvarchar(60);

    DECLARE @PAY_PAYST_FK_actual_is_disabled           bit;
    DECLARE @PAY_PAYST_FK_actual_is_not_trusted        bit;

    DECLARE @PAY_PAYST_FK_equivalent_name              sysname;
    DECLARE @PAY_PAYST_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @PAY_PAYST_FK_equivalent_update_action     nvarchar(60);
    DECLARE @PAY_PAYST_FK_equivalent_is_disabled       bit;
    DECLARE @PAY_PAYST_FK_equivalent_is_not_trusted    bit;

    DECLARE @PAY_PAYST_FK_conflict_parent              nvarchar(517);


    SET @PAY_PAYST_FK_expected_name = N'FK_PAY_PAYST';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'payment.Payment', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : payment.Payment';

        ;THROW 50970,
            N'Foreign key FK_PAY_PAYST cannot be deployed because payment.Payment does not exist.',
            1;

    END;


    IF OBJECT_ID(N'payment.PaymentStatus', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : payment.PaymentStatus';

        ;THROW 50971,
            N'Foreign key FK_PAY_PAYST cannot be deployed because payment.PaymentStatus does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.Payment', N'PAY_PAYST_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PAY_PAYST_id';

        ;THROW 50972,
            N'Foreign key FK_PAY_PAYST cannot be deployed because PAY_PAYST_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.PaymentStatus', N'PAYST_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PAYST_id';

        ;THROW 50973,
            N'Foreign key FK_PAY_PAYST cannot be deployed because referenced column payment.PaymentStatus.PAYST_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PAY_PAYST_id -> tinyint NOT NULL
            PAYST_id     -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'payment.PaymentStatus')

        WHERE parent_column.object_id =
                OBJECT_ID(N'payment.Payment')

        AND parent_column.name =
                N'PAY_PAYST_id'

        AND referenced_column.name =
                N'PAYST_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale

        AND TYPE_NAME(parent_column.user_type_id) =
                N'tinyint'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'tinyint'
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : PAY_PAYST_id -> PAYST_id';

        ;THROW 50974,
            N'Foreign key FK_PAY_PAYST cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PAY_PAYST';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @PAY_PAYST_FK_actual_name =
            fk.name,

        @PAY_PAYST_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PAY_PAYST_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PAY_PAYST_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @PAY_PAYST_FK_actual_update_action =
            fk.update_referential_action_desc,

        @PAY_PAYST_FK_actual_is_disabled =
            fk.is_disabled,

        @PAY_PAYST_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @PAY_PAYST_FK_actual_parent_columns =
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

        @PAY_PAYST_FK_actual_referenced_columns =
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
            OBJECT_ID(N'payment.Payment')

    AND fk.name =
            @PAY_PAYST_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @PAY_PAYST_FK_actual_name IS NOT NULL
    BEGIN

        IF @PAY_PAYST_FK_actual_parent_table =
                N'[payment].[Payment]'

        AND @PAY_PAYST_FK_actual_parent_columns =
                N'PAY_PAYST_id'

        AND @PAY_PAYST_FK_actual_referenced_table =
                N'[payment].[PaymentStatus]'

        AND @PAY_PAYST_FK_actual_referenced_columns =
                N'PAYST_id'

        AND @PAY_PAYST_FK_actual_delete_action =
                N'NO_ACTION'

        AND @PAY_PAYST_FK_actual_update_action =
                N'NO_ACTION'

        AND @PAY_PAYST_FK_actual_is_disabled = 0

        AND @PAY_PAYST_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PAY_PAYST';
            PRINT N'            Column                          : PAY_PAYST_id';
            PRINT N'            References                      : payment.PaymentStatus.PAYST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PAY_PAYST';

            PRINT N'            Expected Table                  : payment.Payment';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @PAY_PAYST_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : PAY_PAYST_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PAY_PAYST_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : payment.PaymentStatus.PAYST_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @PAY_PAYST_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PAY_PAYST_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @PAY_PAYST_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @PAY_PAYST_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAY_PAYST_FK_actual_is_disabled
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
                        @PAY_PAYST_FK_actual_is_not_trusted
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

            @PAY_PAYST_FK_equivalent_name =
                fk.name,

            @PAY_PAYST_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PAY_PAYST_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @PAY_PAYST_FK_equivalent_is_disabled =
                fk.is_disabled,

            @PAY_PAYST_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'payment.Payment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND fk.name <>
                @PAY_PAYST_FK_expected_name

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
                    N'PAY_PAYST_id'

            AND rc.name =
                    N'PAYST_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @PAY_PAYST_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PAY_PAYST';

            PRINT N'            Actual Name                    : '
                + @PAY_PAYST_FK_equivalent_name;

            PRINT N'            Column                         : PAY_PAYST_id';

            PRINT N'            References                     : payment.PaymentStatus.PAYST_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PAY_PAYST_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PAY_PAYST_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAY_PAYST_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAY_PAYST_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'payment.FK_PAY_PAYST', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PAY_PAYST_FK_conflict_parent =
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
                            N'payment.FK_PAY_PAYST',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PAY_PAYST';
                PRINT N'            Expected Table                  : payment.Payment';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PAY_PAYST_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50975,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE payment.Payment
                WITH CHECK
                ADD CONSTRAINT FK_PAY_PAYST
                FOREIGN KEY
                (
                    PAY_PAYST_id
                )
                REFERENCES payment.PaymentStatus
                (
                    PAYST_id
                );


            ALTER TABLE payment.Payment
                CHECK CONSTRAINT FK_PAY_PAYST;


            PRINT N'        [+] Foreign key constraint added    : FK_PAY_PAYST';
            PRINT N'            Column                          : PAY_PAYST_id';
            PRINT N'            References                      : payment.PaymentStatus.PAYST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';