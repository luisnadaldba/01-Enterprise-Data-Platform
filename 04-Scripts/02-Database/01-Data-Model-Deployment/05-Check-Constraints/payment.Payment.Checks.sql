    PRINT N'    payment.Payment';
    PRINT N'    --------------------------------------------------------------------------';


    DECLARE @PAY_check_expected_name          sysname;
    DECLARE @PAY_check_actual_name            sysname;
    DECLARE @PAY_check_actual_definition      nvarchar(4000);
    DECLARE @PAY_check_normalized_definition  nvarchar(4000);
    DECLARE @PAY_check_is_disabled            bit;
    DECLARE @PAY_check_is_not_trusted         bit;
    DECLARE @PAY_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_PAY_amount
    ==============================================================================*/

    SET @PAY_check_expected_name = N'CK_PAY_amount';

    SET @PAY_check_actual_name = NULL;
    SET @PAY_check_actual_definition = NULL;
    SET @PAY_check_normalized_definition = NULL;
    SET @PAY_check_is_disabled = NULL;
    SET @PAY_check_is_not_trusted = NULL;
    SET @PAY_check_parent_object = NULL;


    SELECT
        @PAY_check_actual_name       = cc.name,
        @PAY_check_actual_definition = cc.definition,
        @PAY_check_is_disabled       = cc.is_disabled,
        @PAY_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'payment.Payment')
    AND cc.definition LIKE N'%PAY_amount%';


    IF @PAY_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'payment.CK_PAY_amount', N'C') IS NOT NULL
        BEGIN

            SELECT
                @PAY_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'payment.CK_PAY_amount', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_PAY_amount';
            PRINT N'            Expected Table                : payment.Payment';
            PRINT N'            Expected Column               : PAY_amount';
            PRINT N'            Existing Parent               : '
                + COALESCE(@PAY_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50940,
                N'Check constraint CK_PAY_amount already exists on another object.',
                1;

        END;


        ALTER TABLE payment.Payment WITH CHECK
            ADD CONSTRAINT CK_PAY_amount
            CHECK
            (
                PAY_amount > 0
            );


        PRINT N'        [+] Check constraint added         : CK_PAY_amount';
        PRINT N'            Column                         : PAY_amount';
        PRINT N'            Definition                     : CHECK (PAY_amount > 0)';

    END

    ELSE
    BEGIN

        SET @PAY_check_normalized_definition =
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
                                @PAY_check_actual_definition,
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


        IF @PAY_check_actual_name = @PAY_check_expected_name

        AND @PAY_check_normalized_definition LIKE
            N'%pay_amount>(0)%'

        AND @PAY_check_is_disabled = 0

        AND @PAY_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PAY_amount';
            PRINT N'            Column                         : PAY_amount';
            PRINT N'            Definition                     : CHECK (PAY_amount > 0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : PAY_amount';
            PRINT N'            Expected Name                  : CK_PAY_amount';
            PRINT N'            Actual Name                    : '
                + COALESCE(@PAY_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (PAY_amount > 0)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@PAY_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAY_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAY_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_PAY_installment_count
    ==============================================================================*/

    SET @PAY_check_expected_name = N'CK_PAY_installment_count';

    SET @PAY_check_actual_name = NULL;
    SET @PAY_check_actual_definition = NULL;
    SET @PAY_check_normalized_definition = NULL;
    SET @PAY_check_is_disabled = NULL;
    SET @PAY_check_is_not_trusted = NULL;
    SET @PAY_check_parent_object = NULL;


    SELECT
        @PAY_check_actual_name       = cc.name,
        @PAY_check_actual_definition = cc.definition,
        @PAY_check_is_disabled       = cc.is_disabled,
        @PAY_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'payment.Payment')
    AND cc.definition LIKE N'%PAY_installment_count%';


    IF @PAY_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'payment.CK_PAY_installment_count', N'C') IS NOT NULL
        BEGIN

            SELECT
                @PAY_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'payment.CK_PAY_installment_count', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_PAY_installment_count';
            PRINT N'            Expected Table                : payment.Payment';
            PRINT N'            Expected Column               : PAY_installment_count';
            PRINT N'            Existing Parent               : '
                + COALESCE(@PAY_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50941,
                N'Check constraint CK_PAY_installment_count already exists on another object.',
                1;

        END;


        ALTER TABLE payment.Payment WITH CHECK
            ADD CONSTRAINT CK_PAY_installment_count
            CHECK
            (
                PAY_installment_count IS NULL
                OR PAY_installment_count > 1
            );


        PRINT N'        [+] Check constraint added         : CK_PAY_installment_count';
        PRINT N'            Column                         : PAY_installment_count';
        PRINT N'            Definition                     : CHECK (PAY_installment_count IS NULL OR PAY_installment_count > 1)';

    END

    ELSE
    BEGIN

        SET @PAY_check_normalized_definition =
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
                                @PAY_check_actual_definition,
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


        IF @PAY_check_actual_name = @PAY_check_expected_name

        AND @PAY_check_normalized_definition LIKE
            N'%pay_installment_countisnull%'

        AND @PAY_check_normalized_definition LIKE
            N'%pay_installment_count>(1)%'

        AND @PAY_check_is_disabled = 0

        AND @PAY_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PAY_installment_count';
            PRINT N'            Column                         : PAY_installment_count';
            PRINT N'            Definition                     : CHECK (PAY_installment_count IS NULL OR PAY_installment_count > 1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : PAY_installment_count';
            PRINT N'            Expected Name                  : CK_PAY_installment_count';
            PRINT N'            Actual Name                    : '
                + COALESCE(@PAY_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (PAY_installment_count IS NULL OR PAY_installment_count > 1)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@PAY_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAY_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAY_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_PAY_attempted_at
    ==============================================================================*/

    SET @PAY_check_expected_name = N'CK_PAY_attempted_at';

    SET @PAY_check_actual_name = NULL;
    SET @PAY_check_actual_definition = NULL;
    SET @PAY_check_normalized_definition = NULL;
    SET @PAY_check_is_disabled = NULL;
    SET @PAY_check_is_not_trusted = NULL;
    SET @PAY_check_parent_object = NULL;


    SELECT
        @PAY_check_actual_name       = cc.name,
        @PAY_check_actual_definition = cc.definition,
        @PAY_check_is_disabled       = cc.is_disabled,
        @PAY_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'payment.Payment')
    AND cc.definition LIKE N'%PAY_attempted_at%'
    AND cc.definition LIKE N'%PAY_transaction_at%';


    IF @PAY_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'payment.CK_PAY_attempted_at', N'C') IS NOT NULL
        BEGIN

            SELECT
                @PAY_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'payment.CK_PAY_attempted_at', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_PAY_attempted_at';
            PRINT N'            Expected Table                : payment.Payment';
            PRINT N'            Expected Columns              : PAY_attempted_at, PAY_transaction_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@PAY_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50942,
                N'Check constraint CK_PAY_attempted_at already exists on another object.',
                1;

        END;


        ALTER TABLE payment.Payment WITH CHECK
            ADD CONSTRAINT CK_PAY_attempted_at
            CHECK
            (
                PAY_attempted_at >= PAY_transaction_at
            );


        PRINT N'        [+] Check constraint added         : CK_PAY_attempted_at';
        PRINT N'            Columns                        : PAY_attempted_at, PAY_transaction_at';
        PRINT N'            Definition                     : CHECK (PAY_attempted_at >= PAY_transaction_at)';

    END

    ELSE
    BEGIN

        SET @PAY_check_normalized_definition =
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
                                @PAY_check_actual_definition,
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


        IF @PAY_check_actual_name = @PAY_check_expected_name

        AND @PAY_check_normalized_definition LIKE
            N'%pay_attempted_at>=pay_transaction_at%'

        AND @PAY_check_is_disabled = 0

        AND @PAY_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PAY_attempted_at';
            PRINT N'            Columns                        : PAY_attempted_at, PAY_transaction_at';
            PRINT N'            Definition                     : CHECK (PAY_attempted_at >= PAY_transaction_at)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_PAY_attempted_at';
            PRINT N'            Expected Name                  : CK_PAY_attempted_at';
            PRINT N'            Actual Name                    : '
                + COALESCE(@PAY_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (PAY_attempted_at >= PAY_transaction_at)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@PAY_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @PAY_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @PAY_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_PAY_approved_at
    ==============================================================================*/

    SET @PAY_check_expected_name = N'CK_PAY_approved_at';

    SET @PAY_check_actual_name = NULL;
    SET @PAY_check_actual_definition = NULL;
    SET @PAY_check_normalized_definition = NULL;
    SET @PAY_check_is_disabled = NULL;
    SET @PAY_check_is_not_trusted = NULL;
    SET @PAY_check_parent_object = NULL;


    SELECT
        @PAY_check_actual_name       = cc.name,
        @PAY_check_actual_definition = cc.definition,
        @PAY_check_is_disabled       = cc.is_disabled,
        @PAY_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'payment.Payment')
    AND cc.definition LIKE N'%PAY_approved_at%'
    AND cc.definition LIKE N'%PAY_attempted_at%';


    IF @PAY_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'payment.CK_PAY_approved_at', N'C') IS NOT NULL
        BEGIN

            SELECT
                @PAY_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'payment.CK_PAY_approved_at', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_PAY_approved_at';
            PRINT N'            Expected Table                : payment.Payment';
            PRINT N'            Expected Columns              : PAY_approved_at, PAY_attempted_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@PAY_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50943,
                N'Check constraint CK_PAY_approved_at already exists on another object.',
                1;

        END;


        ALTER TABLE payment.Payment WITH CHECK
            ADD CONSTRAINT CK_PAY_approved_at
            CHECK
            (
                PAY_approved_at IS NULL
                OR PAY_approved_at >= PAY_attempted_at
            );


        PRINT N'        [+] Check constraint added         : CK_PAY_approved_at';
        PRINT N'            Columns                        : PAY_approved_at, PAY_attempted_at';
        PRINT N'            Definition                     : CHECK (PAY_approved_at IS NULL OR PAY_approved_at >= PAY_attempted_at)';

    END

    ELSE
    BEGIN

        SET @PAY_check_normalized_definition =
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
                                @PAY_check_actual_definition,
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


        IF @PAY_check_actual_name = @PAY_check_expected_name

        AND @PAY_check_normalized_definition LIKE
            N'%pay_approved_atisnull%'

        AND @PAY_check_normalized_definition LIKE
            N'%pay_approved_at>=pay_attempted_at%'

        AND @PAY_check_is_disabled = 0

        AND @PAY_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PAY_approved_at';
            PRINT N'            Columns                        : PAY_approved_at, PAY_attempted_at';
            PRINT N'            Definition                     : CHECK (PAY_approved_at IS NULL OR PAY_approved_at >= PAY_attempted_at)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_PAY_approved_at';
            PRINT N'            Expected Name                  : CK_PAY_approved_at';
            PRINT N'            Actual Name                    : '
                + COALESCE(@PAY_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (PAY_approved_at IS NULL OR PAY_approved_at >= PAY_attempted_at)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@PAY_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @PAY_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @PAY_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_PAY_cancelled_at
    ==============================================================================*/

    SET @PAY_check_expected_name = N'CK_PAY_cancelled_at';

    SET @PAY_check_actual_name = NULL;
    SET @PAY_check_actual_definition = NULL;
    SET @PAY_check_normalized_definition = NULL;
    SET @PAY_check_is_disabled = NULL;
    SET @PAY_check_is_not_trusted = NULL;
    SET @PAY_check_parent_object = NULL;


    SELECT
        @PAY_check_actual_name       = cc.name,
        @PAY_check_actual_definition = cc.definition,
        @PAY_check_is_disabled       = cc.is_disabled,
        @PAY_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'payment.Payment')
    AND cc.definition LIKE N'%PAY_cancelled_at%'
    AND cc.definition LIKE N'%PAY_attempted_at%';


    IF @PAY_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'payment.CK_PAY_cancelled_at', N'C') IS NOT NULL
        BEGIN

            SELECT
                @PAY_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'payment.CK_PAY_cancelled_at', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_PAY_cancelled_at';
            PRINT N'            Expected Table                : payment.Payment';
            PRINT N'            Expected Columns              : PAY_cancelled_at, PAY_attempted_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@PAY_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50944,
                N'Check constraint CK_PAY_cancelled_at already exists on another object.',
                1;

        END;


        ALTER TABLE payment.Payment WITH CHECK
            ADD CONSTRAINT CK_PAY_cancelled_at
            CHECK
            (
                PAY_cancelled_at IS NULL
                OR PAY_cancelled_at >= PAY_attempted_at
            );


        PRINT N'        [+] Check constraint added         : CK_PAY_cancelled_at';
        PRINT N'            Columns                        : PAY_cancelled_at, PAY_attempted_at';
        PRINT N'            Definition                     : CHECK (PAY_cancelled_at IS NULL OR PAY_cancelled_at >= PAY_attempted_at)';

    END

    ELSE
    BEGIN

        SET @PAY_check_normalized_definition =
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
                                @PAY_check_actual_definition,
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


        IF @PAY_check_actual_name = @PAY_check_expected_name

        AND @PAY_check_normalized_definition LIKE
            N'%pay_cancelled_atisnull%'

        AND @PAY_check_normalized_definition LIKE
            N'%pay_cancelled_at>=pay_attempted_at%'

        AND @PAY_check_is_disabled = 0

        AND @PAY_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PAY_cancelled_at';
            PRINT N'            Columns                        : PAY_cancelled_at, PAY_attempted_at';
            PRINT N'            Definition                     : CHECK (PAY_cancelled_at IS NULL OR PAY_cancelled_at >= PAY_attempted_at)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_PAY_cancelled_at';
            PRINT N'            Expected Name                  : CK_PAY_cancelled_at';
            PRINT N'            Actual Name                    : '
                + COALESCE(@PAY_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (PAY_cancelled_at IS NULL OR PAY_cancelled_at >= PAY_attempted_at)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@PAY_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @PAY_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @PAY_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';