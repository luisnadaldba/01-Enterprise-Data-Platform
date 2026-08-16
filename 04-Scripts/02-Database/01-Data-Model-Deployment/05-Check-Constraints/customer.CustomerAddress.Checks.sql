    PRINT N'    customer.CustomerAddress';
    PRINT N'    --------------------------------------------------------------------------';


    DECLARE @CSTAD_check_expected_name          sysname;
    DECLARE @CSTAD_check_actual_name            sysname;
    DECLARE @CSTAD_check_actual_definition      nvarchar(4000);
    DECLARE @CSTAD_check_normalized_definition  nvarchar(4000);
    DECLARE @CSTAD_check_is_disabled            bit;
    DECLARE @CSTAD_check_is_not_trusted         bit;
    DECLARE @CSTAD_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_CSTAD_primary_active
    ==============================================================================*/

    SET @CSTAD_check_expected_name = N'CK_CSTAD_primary_active';

    SET @CSTAD_check_actual_name = NULL;
    SET @CSTAD_check_actual_definition = NULL;
    SET @CSTAD_check_normalized_definition = NULL;
    SET @CSTAD_check_is_disabled = NULL;
    SET @CSTAD_check_is_not_trusted = NULL;
    SET @CSTAD_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH PRIMARY/ACTIVE RULE
    ----------------------------------------------------------------------*/

    SELECT
        @CSTAD_check_actual_name       = cc.name,
        @CSTAD_check_actual_definition = cc.definition,
        @CSTAD_check_is_disabled       = cc.is_disabled,
        @CSTAD_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'customer.CustomerAddress')
    AND cc.definition LIKE N'%CSTAD_is_primary%'
    AND cc.definition LIKE N'%CSTAD_is_active%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS FOR PRIMARY/ACTIVE RULE
    ----------------------------------------------------------------------*/

    IF @CSTAD_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'customer.CK_CSTAD_primary_active', N'C') IS NOT NULL
        BEGIN

            SELECT
                @CSTAD_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'customer.CK_CSTAD_primary_active', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_CSTAD_primary_active';
            PRINT N'            Expected Table                : customer.CustomerAddress';
            PRINT N'            Expected Rule                 : Primary address must be active';
            PRINT N'            Existing Parent               : '
                + COALESCE(@CSTAD_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50460,
                N'Check constraint CK_CSTAD_primary_active already exists on another object.',
                1;

        END;


        ALTER TABLE customer.CustomerAddress WITH CHECK
            ADD CONSTRAINT CK_CSTAD_primary_active
            CHECK
            (
                CSTAD_is_primary = 0
                OR CSTAD_is_active = 1
            );


        PRINT N'        [+] Check constraint added         : CK_CSTAD_primary_active';
        PRINT N'            Columns                        : CSTAD_is_primary, CSTAD_is_active';
        PRINT N'            Definition                     : CHECK (CSTAD_is_primary = 0 OR CSTAD_is_active = 1)';

    END

    ELSE
    BEGIN

        SET @CSTAD_check_normalized_definition =
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
                                @CSTAD_check_actual_definition,
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


        IF @CSTAD_check_actual_name = @CSTAD_check_expected_name

        AND @CSTAD_check_normalized_definition LIKE
            N'%cstad_is_primary=(0)%'

        AND @CSTAD_check_normalized_definition LIKE
            N'%orcstad_is_active=(1)%'

        AND @CSTAD_check_is_disabled = 0

        AND @CSTAD_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_CSTAD_primary_active';
            PRINT N'            Columns                        : CSTAD_is_primary, CSTAD_is_active';
            PRINT N'            Definition                     : CHECK (CSTAD_is_primary = 0 OR CSTAD_is_active = 1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_CSTAD_primary_active';
            PRINT N'            Expected Name                  : CK_CSTAD_primary_active';
            PRINT N'            Actual Name                    : '
                + COALESCE(@CSTAD_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (CSTAD_is_primary = 0 OR CSTAD_is_active = 1)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@CSTAD_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTAD_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTAD_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';