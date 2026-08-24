    PRINT N'';
    PRINT N'    ● customer.CustomerContact';
    PRINT N'';


    DECLARE @CSTCN_check_expected_name          sysname;
    DECLARE @CSTCN_check_actual_name            sysname;
    DECLARE @CSTCN_check_actual_definition      nvarchar(4000);
    DECLARE @CSTCN_check_normalized_definition  nvarchar(4000);
    DECLARE @CSTCN_check_is_disabled            bit;
    DECLARE @CSTCN_check_is_not_trusted         bit;
    DECLARE @CSTCN_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_CSTCN_primary_active
    ==============================================================================*/

    SET @CSTCN_check_expected_name = N'CK_CSTCN_primary_active';

    SET @CSTCN_check_actual_name = NULL;
    SET @CSTCN_check_actual_definition = NULL;
    SET @CSTCN_check_normalized_definition = NULL;
    SET @CSTCN_check_is_disabled = NULL;
    SET @CSTCN_check_is_not_trusted = NULL;
    SET @CSTCN_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH PRIMARY/ACTIVE RULE
    ----------------------------------------------------------------------*/

    SELECT
        @CSTCN_check_actual_name       = cc.name,
        @CSTCN_check_actual_definition = cc.definition,
        @CSTCN_check_is_disabled       = cc.is_disabled,
        @CSTCN_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'customer.CustomerContact')
    AND cc.definition LIKE N'%CSTCN_is_primary%'
    AND cc.definition LIKE N'%CSTCN_is_active%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS FOR PRIMARY/ACTIVE RULE
    ----------------------------------------------------------------------*/

    IF @CSTCN_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'customer.CK_CSTCN_primary_active', N'C') IS NOT NULL
        BEGIN

            SELECT
                @CSTCN_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'customer.CK_CSTCN_primary_active', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_CSTCN_primary_active';
            PRINT N'            Expected Table                : customer.CustomerContact';
            PRINT N'            Expected Rule                 : Primary contact must be active';
            PRINT N'            Existing Parent               : '
                + COALESCE(@CSTCN_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50650,
                N'Check constraint CK_CSTCN_primary_active already exists on another object.',
                1;

        END;


        ALTER TABLE customer.CustomerContact WITH CHECK
            ADD CONSTRAINT CK_CSTCN_primary_active
            CHECK
            (
                CSTCN_is_primary = 0
                OR CSTCN_is_active = 1
            );


        PRINT N'        [+] Check constraint added         : CK_CSTCN_primary_active';
        PRINT N'            Columns                        : CSTCN_is_primary, CSTCN_is_active';
        PRINT N'            Definition                     : CHECK (CSTCN_is_primary = 0 OR CSTCN_is_active = 1)';

    END

    ELSE
    BEGIN

        SET @CSTCN_check_normalized_definition =
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
                                @CSTCN_check_actual_definition,
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


        IF @CSTCN_check_actual_name = @CSTCN_check_expected_name

        AND @CSTCN_check_normalized_definition LIKE
            N'%cstcn_is_primary=(0)%'

        AND @CSTCN_check_normalized_definition LIKE
            N'%orcstcn_is_active=(1)%'

        AND @CSTCN_check_is_disabled = 0

        AND @CSTCN_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_CSTCN_primary_active';
            PRINT N'            Columns                        : CSTCN_is_primary, CSTCN_is_active';
            PRINT N'            Definition                     : CHECK (CSTCN_is_primary = 0 OR CSTCN_is_active = 1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_CSTCN_primary_active';
            PRINT N'            Expected Name                  : CK_CSTCN_primary_active';
            PRINT N'            Actual Name                    : '
                + COALESCE(@CSTCN_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (CSTCN_is_primary = 0 OR CSTCN_is_active = 1)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@CSTCN_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTCN_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTCN_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';