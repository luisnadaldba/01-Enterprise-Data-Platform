    PRINT N'    sales.Transaction';
    PRINT N'    --------------------------------------------------------------------------';


    DECLARE @TRN_check_expected_name          sysname;
    DECLARE @TRN_check_actual_name            sysname;
    DECLARE @TRN_check_actual_definition      nvarchar(4000);
    DECLARE @TRN_check_normalized_definition  nvarchar(4000);
    DECLARE @TRN_check_is_disabled            bit;
    DECLARE @TRN_check_is_not_trusted         bit;
    DECLARE @TRN_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_TRN_gross_amount
    ==============================================================================*/

    SET @TRN_check_expected_name = N'CK_TRN_gross_amount';

    SET @TRN_check_actual_name = NULL;
    SET @TRN_check_actual_definition = NULL;
    SET @TRN_check_normalized_definition = NULL;
    SET @TRN_check_is_disabled = NULL;
    SET @TRN_check_is_not_trusted = NULL;
    SET @TRN_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH TRN_gross_amount
    ----------------------------------------------------------------------*/

    SELECT
        @TRN_check_actual_name       = cc.name,
        @TRN_check_actual_definition = cc.definition,
        @TRN_check_is_disabled       = cc.is_disabled,
        @TRN_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'sales.[Transaction]')
    AND cc.definition LIKE N'%TRN_gross_amount%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS ON TRN_gross_amount
    ----------------------------------------------------------------------*/

    IF @TRN_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.CK_TRN_gross_amount', N'C') IS NOT NULL
        BEGIN
            SELECT
                @TRN_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'sales.CK_TRN_gross_amount', N'C');

            PRINT N'        [!] Check constraint name conflict : CK_TRN_gross_amount';
            PRINT N'            Expected Table                : sales.Transaction';
            PRINT N'            Expected Column               : TRN_gross_amount';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRN_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50050,
                N'Check constraint CK_TRN_gross_amount already exists on another object.',
                1;
        END;

        ALTER TABLE sales.[Transaction] WITH CHECK
            ADD CONSTRAINT CK_TRN_gross_amount
            CHECK (TRN_gross_amount >= 0.00);

        PRINT N'        [+] Check constraint added         : CK_TRN_gross_amount';
        PRINT N'            Column                         : TRN_gross_amount';
        PRINT N'            Definition                     : CHECK (TRN_gross_amount >= 0.00)';
    END

    ELSE
    BEGIN

        SET @TRN_check_normalized_definition =
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
                                @TRN_check_actual_definition,
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

        IF @TRN_check_actual_name = @TRN_check_expected_name
        AND @TRN_check_normalized_definition LIKE N'%trn_gross_amount>=(0.00)%'
        AND @TRN_check_is_disabled = 0
        AND @TRN_check_is_not_trusted = 0
        BEGIN
            PRINT N'        [•] Check constraint validated     : CK_TRN_gross_amount';
            PRINT N'            Column                         : TRN_gross_amount';
            PRINT N'            Definition                     : CHECK (TRN_gross_amount >= 0.00)';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Check constraint mismatch      : TRN_gross_amount';
            PRINT N'            Expected Name                  : CK_TRN_gross_amount';
            PRINT N'            Actual Name                    : '
                + COALESCE(@TRN_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (TRN_gross_amount >= 0.00)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@TRN_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @TRN_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @TRN_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_TRN_discount_amount
    ==============================================================================*/

    SET @TRN_check_expected_name = N'CK_TRN_discount_amount';

    SET @TRN_check_actual_name = NULL;
    SET @TRN_check_actual_definition = NULL;
    SET @TRN_check_normalized_definition = NULL;
    SET @TRN_check_is_disabled = NULL;
    SET @TRN_check_is_not_trusted = NULL;
    SET @TRN_check_parent_object = NULL;


    SELECT
        @TRN_check_actual_name       = cc.name,
        @TRN_check_actual_definition = cc.definition,
        @TRN_check_is_disabled       = cc.is_disabled,
        @TRN_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'sales.[Transaction]')
    AND cc.definition LIKE N'%TRN_discount_amount%';


    IF @TRN_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.CK_TRN_discount_amount', N'C') IS NOT NULL
        BEGIN
            SELECT
                @TRN_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'sales.CK_TRN_discount_amount', N'C');

            PRINT N'        [!] Check constraint name conflict : CK_TRN_discount_amount';
            PRINT N'            Expected Table                : sales.Transaction';
            PRINT N'            Expected Column               : TRN_discount_amount';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRN_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50051,
                N'Check constraint CK_TRN_discount_amount already exists on another object.',
                1;
        END;

        ALTER TABLE sales.[Transaction] WITH CHECK
            ADD CONSTRAINT CK_TRN_discount_amount
            CHECK (TRN_discount_amount >= 0.00);

        PRINT N'        [+] Check constraint added         : CK_TRN_discount_amount';
        PRINT N'            Column                         : TRN_discount_amount';
        PRINT N'            Definition                     : CHECK (TRN_discount_amount >= 0.00)';
    END

    ELSE
    BEGIN

        SET @TRN_check_normalized_definition =
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
                                @TRN_check_actual_definition,
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

        IF @TRN_check_actual_name = @TRN_check_expected_name
        AND @TRN_check_normalized_definition LIKE N'%trn_discount_amount>=(0.00)%'
        AND @TRN_check_is_disabled = 0
        AND @TRN_check_is_not_trusted = 0
        BEGIN
            PRINT N'        [•] Check constraint validated     : CK_TRN_discount_amount';
            PRINT N'            Column                         : TRN_discount_amount';
            PRINT N'            Definition                     : CHECK (TRN_discount_amount >= 0.00)';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Check constraint mismatch      : TRN_discount_amount';
            PRINT N'            Expected Name                  : CK_TRN_discount_amount';
            PRINT N'            Actual Name                    : '
                + COALESCE(@TRN_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (TRN_discount_amount >= 0.00)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@TRN_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @TRN_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @TRN_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    PRINT N'';