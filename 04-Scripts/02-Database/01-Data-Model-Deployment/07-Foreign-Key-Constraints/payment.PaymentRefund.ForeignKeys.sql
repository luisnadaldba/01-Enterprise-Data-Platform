    PRINT N'';
    PRINT N'    ● payment.PaymentRefund';
    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_PAYRF_PAY
    ==============================================================================*/

    DECLARE @PAYRF_PAY_FK_expected_name                sysname;
    DECLARE @PAYRF_PAY_FK_actual_name                  sysname;

    DECLARE @PAYRF_PAY_FK_actual_parent_table          nvarchar(517);
    DECLARE @PAYRF_PAY_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @PAYRF_PAY_FK_actual_referenced_table      nvarchar(517);
    DECLARE @PAYRF_PAY_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @PAYRF_PAY_FK_actual_delete_action         nvarchar(60);
    DECLARE @PAYRF_PAY_FK_actual_update_action         nvarchar(60);

    DECLARE @PAYRF_PAY_FK_actual_is_disabled           bit;
    DECLARE @PAYRF_PAY_FK_actual_is_not_trusted        bit;

    DECLARE @PAYRF_PAY_FK_equivalent_name              sysname;
    DECLARE @PAYRF_PAY_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @PAYRF_PAY_FK_equivalent_update_action     nvarchar(60);
    DECLARE @PAYRF_PAY_FK_equivalent_is_disabled       bit;
    DECLARE @PAYRF_PAY_FK_equivalent_is_not_trusted    bit;

    DECLARE @PAYRF_PAY_FK_conflict_parent              nvarchar(517);


    SET @PAYRF_PAY_FK_expected_name = N'FK_PAYRF_PAY';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'payment.PaymentRefund', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : payment.PaymentRefund';

        ;THROW 50990,
            N'Foreign key FK_PAYRF_PAY cannot be deployed because payment.PaymentRefund does not exist.',
            1;

    END;


    IF OBJECT_ID(N'payment.Payment', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : payment.Payment';

        ;THROW 50991,
            N'Foreign key FK_PAYRF_PAY cannot be deployed because payment.Payment does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.PaymentRefund', N'PAYRF_PAY_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PAYRF_PAY_id';

        ;THROW 50992,
            N'Foreign key FK_PAYRF_PAY cannot be deployed because PAYRF_PAY_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.Payment', N'PAY_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PAY_id';

        ;THROW 50993,
            N'Foreign key FK_PAYRF_PAY cannot be deployed because referenced column payment.Payment.PAY_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PAYRF_PAY_id -> bigint NOT NULL
            PAY_id       -> bigint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'payment.Payment')

        WHERE parent_column.object_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND parent_column.name =
                N'PAYRF_PAY_id'

        AND referenced_column.name =
                N'PAY_id'

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

        PRINT N'        [X] Foreign key column mismatch    : PAYRF_PAY_id -> PAY_id';

        ;THROW 50994,
            N'Foreign key FK_PAYRF_PAY cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PAYRF_PAY';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @PAYRF_PAY_FK_actual_name =
            fk.name,

        @PAYRF_PAY_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PAYRF_PAY_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PAYRF_PAY_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @PAYRF_PAY_FK_actual_update_action =
            fk.update_referential_action_desc,

        @PAYRF_PAY_FK_actual_is_disabled =
            fk.is_disabled,

        @PAYRF_PAY_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @PAYRF_PAY_FK_actual_parent_columns =
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

        @PAYRF_PAY_FK_actual_referenced_columns =
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
            OBJECT_ID(N'payment.PaymentRefund')

    AND fk.name =
            @PAYRF_PAY_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @PAYRF_PAY_FK_actual_name IS NOT NULL
    BEGIN

        IF @PAYRF_PAY_FK_actual_parent_table =
                N'[payment].[PaymentRefund]'

        AND @PAYRF_PAY_FK_actual_parent_columns =
                N'PAYRF_PAY_id'

        AND @PAYRF_PAY_FK_actual_referenced_table =
                N'[payment].[Payment]'

        AND @PAYRF_PAY_FK_actual_referenced_columns =
                N'PAY_id'

        AND @PAYRF_PAY_FK_actual_delete_action =
                N'NO_ACTION'

        AND @PAYRF_PAY_FK_actual_update_action =
                N'NO_ACTION'

        AND @PAYRF_PAY_FK_actual_is_disabled = 0

        AND @PAYRF_PAY_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PAYRF_PAY';
            PRINT N'            Column                          : PAYRF_PAY_id';
            PRINT N'            References                      : payment.Payment.PAY_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PAYRF_PAY';

            PRINT N'            Expected Table                  : payment.Payment';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @PAYRF_PAY_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : PAYRF_PAY_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PAYRF_PAY_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : payment.Payment.PAY_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @PAYRF_PAY_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PAYRF_PAY_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @PAYRF_PAY_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @PAYRF_PAY_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAYRF_PAY_FK_actual_is_disabled
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
                        @PAYRF_PAY_FK_actual_is_not_trusted
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

            @PAYRF_PAY_FK_equivalent_name =
                fk.name,

            @PAYRF_PAY_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PAYRF_PAY_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @PAYRF_PAY_FK_equivalent_is_disabled =
                fk.is_disabled,

            @PAYRF_PAY_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND fk.referenced_object_id =
                OBJECT_ID(N'payment.Payment')

        AND fk.name <>
                @PAYRF_PAY_FK_expected_name

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
                    N'PAYRF_PAY_id'

            AND rc.name =
                    N'PAY_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @PAYRF_PAY_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PAYRF_PAY';

            PRINT N'            Actual Name                    : '
                + @PAYRF_PAY_FK_equivalent_name;

            PRINT N'            Column                         : PAYRF_PAY_id';

            PRINT N'            References                     : payment.Payment.PAY_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PAYRF_PAY_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PAYRF_PAY_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAYRF_PAY_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAYRF_PAY_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'payment.FK_PAYRF_PAY', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PAYRF_PAY_FK_conflict_parent =
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
                            N'payment.FK_PAYRF_PAY',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PAYRF_PAY';
                PRINT N'            Expected Table                  : payment.PaymentRefund';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PAYRF_PAY_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50995,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE payment.PaymentRefund
                WITH CHECK
                ADD CONSTRAINT FK_PAYRF_PAY
                FOREIGN KEY
                (
                    PAYRF_PAY_id
                )
                REFERENCES payment.Payment
                (
                    PAY_id
                );


            ALTER TABLE payment.PaymentRefund
                CHECK CONSTRAINT FK_PAYRF_PAY;


            PRINT N'        [+] Foreign key constraint added    : FK_PAYRF_PAY';
            PRINT N'            Column                          : PAYRF_PAY_id';
            PRINT N'            References                      : payment.Payment.PAY_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_PAYRF_PAYRR
    ==============================================================================*/

    DECLARE @PAYRF_PAYRR_FK_expected_name                sysname;
    DECLARE @PAYRF_PAYRR_FK_actual_name                  sysname;

    DECLARE @PAYRF_PAYRR_FK_actual_parent_table          nvarchar(517);
    DECLARE @PAYRF_PAYRR_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @PAYRF_PAYRR_FK_actual_referenced_table      nvarchar(517);
    DECLARE @PAYRF_PAYRR_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @PAYRF_PAYRR_FK_actual_delete_action         nvarchar(60);
    DECLARE @PAYRF_PAYRR_FK_actual_update_action         nvarchar(60);

    DECLARE @PAYRF_PAYRR_FK_actual_is_disabled           bit;
    DECLARE @PAYRF_PAYRR_FK_actual_is_not_trusted        bit;

    DECLARE @PAYRF_PAYRR_FK_equivalent_name              sysname;
    DECLARE @PAYRF_PAYRR_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @PAYRF_PAYRR_FK_equivalent_update_action     nvarchar(60);
    DECLARE @PAYRF_PAYRR_FK_equivalent_is_disabled       bit;
    DECLARE @PAYRF_PAYRR_FK_equivalent_is_not_trusted    bit;

    DECLARE @PAYRF_PAYRR_FK_conflict_parent              nvarchar(517);


    SET @PAYRF_PAYRR_FK_expected_name = N'FK_PAYRF_PAYRR';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'payment.PaymentRefund', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : payment.PaymentRefund';

        ;THROW 51000,
            N'Foreign key FK_PAYRF_PAYRR cannot be deployed because payment.PaymentRefund does not exist.',
            1;

    END;


    IF OBJECT_ID(N'payment.PaymentRefundReason', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : payment.PaymentRefundReason';

        ;THROW 51001,
            N'Foreign key FK_PAYRF_PAYRR cannot be deployed because payment.PaymentRefundReason does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.PaymentRefund', N'PAYRF_PAYRR_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PAYRF_PAYRR_id';

        ;THROW 51002,
            N'Foreign key FK_PAYRF_PAYRR cannot be deployed because PAYRF_PAYRR_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.PaymentRefundReason', N'PAYRR_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PAYRR_id';

        ;THROW 51003,
            N'Foreign key FK_PAYRF_PAYRR cannot be deployed because referenced column payment.PaymentRefundReason.PAYRR_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PAYRF_PAYRR_id -> tinyint NOT NULL
            PAYRR_id       -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'payment.PaymentRefundReason')

        WHERE parent_column.object_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND parent_column.name =
                N'PAYRF_PAYRR_id'

        AND referenced_column.name =
                N'PAYRR_id'

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

        PRINT N'        [X] Foreign key column mismatch    : PAYRF_PAYRR_id -> PAYRR_id';

        ;THROW 51004,
            N'Foreign key FK_PAYRF_PAYRR cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PAYRF_PAYRR';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @PAYRF_PAYRR_FK_actual_name =
            fk.name,

        @PAYRF_PAYRR_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PAYRF_PAYRR_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PAYRF_PAYRR_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @PAYRF_PAYRR_FK_actual_update_action =
            fk.update_referential_action_desc,

        @PAYRF_PAYRR_FK_actual_is_disabled =
            fk.is_disabled,

        @PAYRF_PAYRR_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @PAYRF_PAYRR_FK_actual_parent_columns =
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

        @PAYRF_PAYRR_FK_actual_referenced_columns =
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
            OBJECT_ID(N'payment.PaymentRefund')

    AND fk.name =
            @PAYRF_PAYRR_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @PAYRF_PAYRR_FK_actual_name IS NOT NULL
    BEGIN

        IF @PAYRF_PAYRR_FK_actual_parent_table =
                N'[payment].[PaymentRefund]'

        AND @PAYRF_PAYRR_FK_actual_parent_columns =
                N'PAYRF_PAYRR_id'

        AND @PAYRF_PAYRR_FK_actual_referenced_table =
                N'[payment].[PaymentRefundReason]'

        AND @PAYRF_PAYRR_FK_actual_referenced_columns =
                N'PAYRR_id'

        AND @PAYRF_PAYRR_FK_actual_delete_action =
                N'NO_ACTION'

        AND @PAYRF_PAYRR_FK_actual_update_action =
                N'NO_ACTION'

        AND @PAYRF_PAYRR_FK_actual_is_disabled = 0

        AND @PAYRF_PAYRR_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PAYRF_PAYRR';
            PRINT N'            Column                          : PAYRF_PAYRR_id';
            PRINT N'            References                      : payment.PaymentRefundReason.PAYRR_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PAYRF_PAYRR';

            PRINT N'            Expected Table                  : payment.PaymentRefund';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @PAYRF_PAYRR_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : PAYRF_PAYRR_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PAYRF_PAYRR_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : payment.PaymentRefundReason.PAYRR_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @PAYRF_PAYRR_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PAYRF_PAYRR_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @PAYRF_PAYRR_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @PAYRF_PAYRR_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAYRF_PAYRR_FK_actual_is_disabled
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
                        @PAYRF_PAYRR_FK_actual_is_not_trusted
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

            @PAYRF_PAYRR_FK_equivalent_name =
                fk.name,

            @PAYRF_PAYRR_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PAYRF_PAYRR_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @PAYRF_PAYRR_FK_equivalent_is_disabled =
                fk.is_disabled,

            @PAYRF_PAYRR_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND fk.referenced_object_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND fk.name <>
                @PAYRF_PAYRR_FK_expected_name

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
                    N'PAYRF_PAYRR_id'

            AND rc.name =
                    N'PAYRR_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @PAYRF_PAYRR_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PAYRF_PAYRR';

            PRINT N'            Actual Name                    : '
                + @PAYRF_PAYRR_FK_equivalent_name;

            PRINT N'            Column                         : PAYRF_PAYRR_id';

            PRINT N'            References                     : payment.PaymentRefundReason.PAYRR_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PAYRF_PAYRR_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PAYRF_PAYRR_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAYRF_PAYRR_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAYRF_PAYRR_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'payment.FK_PAYRF_PAYRR', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PAYRF_PAYRR_FK_conflict_parent =
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
                            N'payment.FK_PAYRF_PAYRR',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PAYRF_PAYRR';
                PRINT N'            Expected Table                  : payment.PaymentRefund';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PAYRF_PAYRR_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 51005,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE payment.PaymentRefund
                WITH CHECK
                ADD CONSTRAINT FK_PAYRF_PAYRR
                FOREIGN KEY
                (
                    PAYRF_PAYRR_id
                )
                REFERENCES payment.PaymentRefundReason
                (
                    PAYRR_id
                );


            ALTER TABLE payment.PaymentRefund
                CHECK CONSTRAINT FK_PAYRF_PAYRR;


            PRINT N'        [+] Foreign key constraint added    : FK_PAYRF_PAYRR';
            PRINT N'            Column                          : PAYRF_PAYRR_id';
            PRINT N'            References                      : payment.PaymentRefundReason.PAYRR_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';