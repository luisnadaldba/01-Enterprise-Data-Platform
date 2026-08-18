    PRINT N'    payment.PaymentRefund';
    PRINT N'    --------------------------------------------------------------------------';


    DECLARE @PAYRF_check_expected_name          sysname;
    DECLARE @PAYRF_check_actual_name            sysname;
    DECLARE @PAYRF_check_actual_definition      nvarchar(4000);
    DECLARE @PAYRF_check_normalized_definition  nvarchar(4000);
    DECLARE @PAYRF_check_is_disabled            bit;
    DECLARE @PAYRF_check_is_not_trusted         bit;
    DECLARE @PAYRF_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_PAYRF_amount
    ==============================================================================*/

    SET @PAYRF_check_expected_name = N'CK_PAYRF_amount';

    SET @PAYRF_check_actual_name = NULL;
    SET @PAYRF_check_actual_definition = NULL;
    SET @PAYRF_check_normalized_definition = NULL;
    SET @PAYRF_check_is_disabled = NULL;
    SET @PAYRF_check_is_not_trusted = NULL;
    SET @PAYRF_check_parent_object = NULL;


    SELECT
        @PAYRF_check_actual_name       = cc.name,
        @PAYRF_check_actual_definition = cc.definition,
        @PAYRF_check_is_disabled       = cc.is_disabled,
        @PAYRF_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'payment.PaymentRefund')
    AND cc.definition LIKE N'%PAYRF_amount%';


    IF @PAYRF_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'payment.CK_PAYRF_amount', N'C') IS NOT NULL
        BEGIN

            SELECT
                @PAYRF_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'payment.CK_PAYRF_amount', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_PAYRF_amount';
            PRINT N'            Expected Table                : payment.PaymentRefund';
            PRINT N'            Expected Column               : PAYRF_amount';
            PRINT N'            Existing Parent               : '
                + COALESCE(@PAYRF_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50980,
                N'Check constraint CK_PAYRF_amount already exists on another object.',
                1;

        END;


        ALTER TABLE payment.PaymentRefund WITH CHECK
            ADD CONSTRAINT CK_PAYRF_amount
            CHECK
            (
                PAYRF_amount > 0
            );


        PRINT N'        [+] Check constraint added         : CK_PAYRF_amount';
        PRINT N'            Column                         : PAYRF_amount';
        PRINT N'            Definition                     : CHECK (PAYRF_amount > 0)';

    END

    ELSE
    BEGIN

        SET @PAYRF_check_normalized_definition =
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
                                @PAYRF_check_actual_definition,
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


        IF @PAYRF_check_actual_name = @PAYRF_check_expected_name

        AND @PAYRF_check_normalized_definition LIKE
            N'%payrf_amount>(0)%'

        AND @PAYRF_check_is_disabled = 0

        AND @PAYRF_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PAYRF_amount';
            PRINT N'            Column                         : PAYRF_amount';
            PRINT N'            Definition                     : CHECK (PAYRF_amount > 0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : PAYRF_amount';
            PRINT N'            Expected Name                  : CK_PAYRF_amount';
            PRINT N'            Actual Name                    : '
                + COALESCE(@PAYRF_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (PAYRF_amount > 0)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@PAYRF_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAYRF_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @PAYRF_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';