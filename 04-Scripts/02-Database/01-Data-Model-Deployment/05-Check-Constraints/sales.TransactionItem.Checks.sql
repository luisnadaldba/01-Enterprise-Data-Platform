    PRINT N'    sales.TransactionItem';
    PRINT N'    --------------------------------------------------------------------------';


    DECLARE @TRNIT_check_expected_name          sysname;
    DECLARE @TRNIT_check_actual_name            sysname;
    DECLARE @TRNIT_check_actual_definition      nvarchar(4000);
    DECLARE @TRNIT_check_normalized_definition  nvarchar(4000);
    DECLARE @TRNIT_check_is_disabled            bit;
    DECLARE @TRNIT_check_is_not_trusted         bit;
    DECLARE @TRNIT_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_TRNIT_quantity
    ==============================================================================*/

    SET @TRNIT_check_expected_name = N'CK_TRNIT_quantity';

    SET @TRNIT_check_actual_name = NULL;
    SET @TRNIT_check_actual_definition = NULL;
    SET @TRNIT_check_normalized_definition = NULL;
    SET @TRNIT_check_is_disabled = NULL;
    SET @TRNIT_check_is_not_trusted = NULL;
    SET @TRNIT_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH TRNIT_quantity
    ----------------------------------------------------------------------*/

    SELECT
        @TRNIT_check_actual_name        = cc.name,
        @TRNIT_check_actual_definition  = cc.definition,
        @TRNIT_check_is_disabled        = cc.is_disabled,
        @TRNIT_check_is_not_trusted     = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
    AND cc.definition LIKE N'%TRNIT_quantity%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS ON TRNIT_quantity
    ----------------------------------------------------------------------*/

    IF @TRNIT_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.CK_TRNIT_quantity', N'C') IS NOT NULL
        BEGIN
            SELECT
                @TRNIT_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'sales.CK_TRNIT_quantity', N'C');

            PRINT N'        [!] Check constraint name conflict : CK_TRNIT_quantity';
            PRINT N'            Expected Table                : sales.TransactionItem';
            PRINT N'            Expected Column               : TRNIT_quantity';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRNIT_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50068,
                N'Check constraint CK_TRNIT_quantity already exists on another object.',
                1;
        END;

        ALTER TABLE sales.TransactionItem WITH CHECK
            ADD CONSTRAINT CK_TRNIT_quantity
            CHECK (TRNIT_quantity > 0);

        PRINT N'        [+] Check constraint added         : CK_TRNIT_quantity';
        PRINT N'            Column                         : TRNIT_quantity';
        PRINT N'            Definition                     : CHECK (TRNIT_quantity > 0)';
    END

    ELSE
    BEGIN

        SET @TRNIT_check_normalized_definition =
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
                                @TRNIT_check_actual_definition,
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

        IF @TRNIT_check_actual_name = @TRNIT_check_expected_name
        AND @TRNIT_check_normalized_definition LIKE N'%trnit_quantity>(0)%'
        AND @TRNIT_check_is_disabled = 0
        AND @TRNIT_check_is_not_trusted = 0
        BEGIN
            PRINT N'        [•] Check constraint validated     : CK_TRNIT_quantity';
            PRINT N'            Column                         : TRNIT_quantity';
            PRINT N'            Definition                     : CHECK (TRNIT_quantity > 0)';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Check constraint mismatch      : TRNIT_quantity';
            PRINT N'            Expected Name                  : CK_TRNIT_quantity';
            PRINT N'            Actual Name                    : '
                + COALESCE(@TRNIT_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (TRNIT_quantity > 0)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@TRNIT_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @TRNIT_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @TRNIT_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_TRNIT_unit_price
    ==============================================================================*/

    SET @TRNIT_check_expected_name = N'CK_TRNIT_unit_price';

    SET @TRNIT_check_actual_name = NULL;
    SET @TRNIT_check_actual_definition = NULL;
    SET @TRNIT_check_normalized_definition = NULL;
    SET @TRNIT_check_is_disabled = NULL;
    SET @TRNIT_check_is_not_trusted = NULL;
    SET @TRNIT_check_parent_object = NULL;


    SELECT
        @TRNIT_check_actual_name        = cc.name,
        @TRNIT_check_actual_definition  = cc.definition,
        @TRNIT_check_is_disabled        = cc.is_disabled,
        @TRNIT_check_is_not_trusted     = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
    AND cc.definition LIKE N'%TRNIT_unit_price%'
    AND cc.definition NOT LIKE N'%TRNIT_unit_discount%';


    IF @TRNIT_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.CK_TRNIT_unit_price', N'C') IS NOT NULL
        BEGIN
            SELECT
                @TRNIT_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'sales.CK_TRNIT_unit_price', N'C');

            PRINT N'        [!] Check constraint name conflict : CK_TRNIT_unit_price';
            PRINT N'            Expected Table                : sales.TransactionItem';
            PRINT N'            Expected Column               : TRNIT_unit_price';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRNIT_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50069,
                N'Check constraint CK_TRNIT_unit_price already exists on another object.',
                1;
        END;

        ALTER TABLE sales.TransactionItem WITH CHECK
            ADD CONSTRAINT CK_TRNIT_unit_price
            CHECK (TRNIT_unit_price >= 0.00);

        PRINT N'        [+] Check constraint added         : CK_TRNIT_unit_price';
        PRINT N'            Column                         : TRNIT_unit_price';
        PRINT N'            Definition                     : CHECK (TRNIT_unit_price >= 0.00)';
    END

    ELSE
    BEGIN

        SET @TRNIT_check_normalized_definition =
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
                                @TRNIT_check_actual_definition,
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

        IF @TRNIT_check_actual_name = @TRNIT_check_expected_name
        AND @TRNIT_check_normalized_definition LIKE N'%trnit_unit_price>=(0.00)%'
        AND @TRNIT_check_is_disabled = 0
        AND @TRNIT_check_is_not_trusted = 0
        BEGIN
            PRINT N'        [•] Check constraint validated     : CK_TRNIT_unit_price';
            PRINT N'            Column                         : TRNIT_unit_price';
            PRINT N'            Definition                     : CHECK (TRNIT_unit_price >= 0.00)';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Check constraint mismatch      : TRNIT_unit_price';
            PRINT N'            Expected Name                  : CK_TRNIT_unit_price';
            PRINT N'            Actual Name                    : '
                + COALESCE(@TRNIT_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (TRNIT_unit_price >= 0.00)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@TRNIT_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @TRNIT_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @TRNIT_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_TRNIT_unit_discount
    ==============================================================================*/

    SET @TRNIT_check_expected_name = N'CK_TRNIT_unit_discount';

    SET @TRNIT_check_actual_name = NULL;
    SET @TRNIT_check_actual_definition = NULL;
    SET @TRNIT_check_normalized_definition = NULL;
    SET @TRNIT_check_is_disabled = NULL;
    SET @TRNIT_check_is_not_trusted = NULL;
    SET @TRNIT_check_parent_object = NULL;


    SELECT
        @TRNIT_check_actual_name        = cc.name,
        @TRNIT_check_actual_definition  = cc.definition,
        @TRNIT_check_is_disabled        = cc.is_disabled,
        @TRNIT_check_is_not_trusted     = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
    AND cc.definition LIKE N'%TRNIT_unit_discount%'
    AND cc.definition NOT LIKE N'%TRNIT_unit_price%';


    IF @TRNIT_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.CK_TRNIT_unit_discount', N'C') IS NOT NULL
        BEGIN
            SELECT
                @TRNIT_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'sales.CK_TRNIT_unit_discount', N'C');

            PRINT N'        [!] Check constraint name conflict : CK_TRNIT_unit_discount';
            PRINT N'            Expected Table                : sales.TransactionItem';
            PRINT N'            Expected Column               : TRNIT_unit_discount';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRNIT_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50070,
                N'Check constraint CK_TRNIT_unit_discount already exists on another object.',
                1;
        END;

        ALTER TABLE sales.TransactionItem WITH CHECK
            ADD CONSTRAINT CK_TRNIT_unit_discount
            CHECK (TRNIT_unit_discount >= 0.00);

        PRINT N'        [+] Check constraint added         : CK_TRNIT_unit_discount';
        PRINT N'            Column                         : TRNIT_unit_discount';
        PRINT N'            Definition                     : CHECK (TRNIT_unit_discount >= 0.00)';
    END

    ELSE
    BEGIN

        SET @TRNIT_check_normalized_definition =
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
                                @TRNIT_check_actual_definition,
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

        IF @TRNIT_check_actual_name = @TRNIT_check_expected_name
        AND @TRNIT_check_normalized_definition LIKE N'%trnit_unit_discount>=(0.00)%'
        AND @TRNIT_check_is_disabled = 0
        AND @TRNIT_check_is_not_trusted = 0
        BEGIN
            PRINT N'        [•] Check constraint validated     : CK_TRNIT_unit_discount';
            PRINT N'            Column                         : TRNIT_unit_discount';
            PRINT N'            Definition                     : CHECK (TRNIT_unit_discount >= 0.00)';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Check constraint mismatch      : TRNIT_unit_discount';
            PRINT N'            Expected Name                  : CK_TRNIT_unit_discount';
            PRINT N'            Actual Name                    : '
                + COALESCE(@TRNIT_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (TRNIT_unit_discount >= 0.00)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@TRNIT_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @TRNIT_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @TRNIT_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_TRNIT_discount_not_greater_than_price
    ==============================================================================*/

    SET @TRNIT_check_expected_name = N'CK_TRNIT_discount_not_greater_than_price';

    SET @TRNIT_check_actual_name = NULL;
    SET @TRNIT_check_actual_definition = NULL;
    SET @TRNIT_check_normalized_definition = NULL;
    SET @TRNIT_check_is_disabled = NULL;
    SET @TRNIT_check_is_not_trusted = NULL;
    SET @TRNIT_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK ASSOCIATED WITH PRICE / DISCOUNT RELATIONSHIP
    ----------------------------------------------------------------------*/

    SELECT
        @TRNIT_check_actual_name        = cc.name,
        @TRNIT_check_actual_definition  = cc.definition,
        @TRNIT_check_is_disabled        = cc.is_disabled,
        @TRNIT_check_is_not_trusted     = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
    AND cc.definition LIKE N'%TRNIT_unit_discount%'
    AND cc.definition LIKE N'%TRNIT_unit_price%';


    IF @TRNIT_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.CK_TRNIT_discount_not_greater_than_price', N'C') IS NOT NULL
        BEGIN
            SELECT
                @TRNIT_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'sales.CK_TRNIT_discount_not_greater_than_price', N'C');

            PRINT N'        [!] Check constraint name conflict : CK_TRNIT_discount_not_greater_than_price';
            PRINT N'            Expected Table                : sales.TransactionItem';
            PRINT N'            Expected Columns              : TRNIT_unit_discount, TRNIT_unit_price';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRNIT_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50071,
                N'Check constraint CK_TRNIT_discount_not_greater_than_price already exists on another object.',
                1;
        END;

        ALTER TABLE sales.TransactionItem WITH CHECK
            ADD CONSTRAINT CK_TRNIT_discount_not_greater_than_price
            CHECK (TRNIT_unit_discount <= TRNIT_unit_price);

        PRINT N'        [+] Check constraint added         : CK_TRNIT_discount_not_greater_than_price';
        PRINT N'            Columns                        : TRNIT_unit_discount, TRNIT_unit_price';
        PRINT N'            Definition                     : CHECK (TRNIT_unit_discount <= TRNIT_unit_price)';
    END

    ELSE
    BEGIN

        SET @TRNIT_check_normalized_definition =
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
                                @TRNIT_check_actual_definition,
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

        IF @TRNIT_check_actual_name = @TRNIT_check_expected_name
        AND @TRNIT_check_normalized_definition LIKE N'%trnit_unit_discount<=trnit_unit_price%'
        AND @TRNIT_check_is_disabled = 0
        AND @TRNIT_check_is_not_trusted = 0
        BEGIN
            PRINT N'        [•] Check constraint validated     : CK_TRNIT_discount_not_greater_than_price';
            PRINT N'            Columns                        : TRNIT_unit_discount, TRNIT_unit_price';
            PRINT N'            Definition                     : CHECK (TRNIT_unit_discount <= TRNIT_unit_price)';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Check constraint mismatch      : TRNIT_unit_discount, TRNIT_unit_price';
            PRINT N'            Expected Name                  : CK_TRNIT_discount_not_greater_than_price';
            PRINT N'            Actual Name                    : '
                + COALESCE(@TRNIT_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (TRNIT_unit_discount <= TRNIT_unit_price)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@TRNIT_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @TRNIT_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @TRNIT_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    PRINT N'';