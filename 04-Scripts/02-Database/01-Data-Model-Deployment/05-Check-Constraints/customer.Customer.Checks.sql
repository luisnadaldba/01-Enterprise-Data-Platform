    PRINT N'';
    PRINT N'    ● customer.Customer';
    PRINT N'';


    DECLARE @CST_check_expected_name          sysname;
    DECLARE @CST_check_actual_name            sysname;
    DECLARE @CST_check_actual_definition      nvarchar(4000);
    DECLARE @CST_check_normalized_definition  nvarchar(4000);
    DECLARE @CST_check_is_disabled            bit;
    DECLARE @CST_check_is_not_trusted         bit;
    DECLARE @CST_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_CST_birth_date
    ==============================================================================*/

    SET @CST_check_expected_name = N'CK_CST_birth_date';

    SET @CST_check_actual_name = NULL;
    SET @CST_check_actual_definition = NULL;
    SET @CST_check_normalized_definition = NULL;
    SET @CST_check_is_disabled = NULL;
    SET @CST_check_is_not_trusted = NULL;
    SET @CST_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH CST_birth_date
    ----------------------------------------------------------------------*/

    SELECT
        @CST_check_actual_name       = cc.name,
        @CST_check_actual_definition = cc.definition,
        @CST_check_is_disabled       = cc.is_disabled,
        @CST_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'customer.Customer')
    AND cc.definition LIKE N'%CST_birth_date%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS ON CST_birth_date
    ----------------------------------------------------------------------*/

    IF @CST_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'customer.CK_CST_birth_date', N'C') IS NOT NULL
        BEGIN

            SELECT
                @CST_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'customer.CK_CST_birth_date', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_CST_birth_date';
            PRINT N'            Expected Table                : customer.Customer';
            PRINT N'            Expected Column               : CST_birth_date';
            PRINT N'            Existing Parent               : '
                + COALESCE(@CST_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50360,
                N'Check constraint CK_CST_birth_date already exists on another object.',
                1;

        END;


        ALTER TABLE customer.Customer WITH CHECK
            ADD CONSTRAINT CK_CST_birth_date
            CHECK
            (
                CST_birth_date IS NULL
                OR CST_birth_date <= CONVERT(date, SYSDATETIME())
            );


        PRINT N'        [+] Check constraint added         : CK_CST_birth_date';
        PRINT N'            Column                         : CST_birth_date';
        PRINT N'            Definition                     : CHECK (CST_birth_date IS NULL OR CST_birth_date <= CONVERT(date, SYSDATETIME()))';

    END

    ELSE
    BEGIN

        SET @CST_check_normalized_definition =
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
                                @CST_check_actual_definition,
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


        IF @CST_check_actual_name = @CST_check_expected_name

        AND @CST_check_normalized_definition LIKE
            N'%cst_birth_dateisnull%'

        AND @CST_check_normalized_definition LIKE
            N'%cst_birth_date<=convert(date,sysdatetime())%'

        AND @CST_check_is_disabled = 0

        AND @CST_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_CST_birth_date';
            PRINT N'            Column                         : CST_birth_date';
            PRINT N'            Definition                     : CHECK (CST_birth_date IS NULL OR CST_birth_date <= CONVERT(date, SYSDATETIME()))';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CST_birth_date';
            PRINT N'            Expected Name                  : CK_CST_birth_date';
            PRINT N'            Actual Name                    : '
                + COALESCE(@CST_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (CST_birth_date IS NULL OR CST_birth_date <= CONVERT(date, SYSDATETIME()))';
            PRINT N'            Actual Definition              : '
                + COALESCE(@CST_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';