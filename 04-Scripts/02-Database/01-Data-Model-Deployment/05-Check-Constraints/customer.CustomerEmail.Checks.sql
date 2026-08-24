    PRINT N'';
    PRINT N'    ● customer.CustomerEmail';
    PRINT N'';


    DECLARE @CSTEM_check_expected_name          sysname;
    DECLARE @CSTEM_check_actual_name            sysname;
    DECLARE @CSTEM_check_actual_definition      nvarchar(4000);
    DECLARE @CSTEM_check_normalized_definition  nvarchar(4000);
    DECLARE @CSTEM_check_is_disabled            bit;
    DECLARE @CSTEM_check_is_not_trusted         bit;
    DECLARE @CSTEM_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_CSTEM_primary_active
    ==============================================================================*/

    SET @CSTEM_check_expected_name = N'CK_CSTEM_primary_active';

    SET @CSTEM_check_actual_name = NULL;
    SET @CSTEM_check_actual_definition = NULL;
    SET @CSTEM_check_normalized_definition = NULL;
    SET @CSTEM_check_is_disabled = NULL;
    SET @CSTEM_check_is_not_trusted = NULL;
    SET @CSTEM_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH PRIMARY/ACTIVE RULE
    ----------------------------------------------------------------------*/

    SELECT
        @CSTEM_check_actual_name       = cc.name,
        @CSTEM_check_actual_definition = cc.definition,
        @CSTEM_check_is_disabled       = cc.is_disabled,
        @CSTEM_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'customer.CustomerEmail')
    AND cc.definition LIKE N'%CSTEM_is_primary%'
    AND cc.definition LIKE N'%CSTEM_is_active%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS FOR PRIMARY/ACTIVE RULE
    ----------------------------------------------------------------------*/

    IF @CSTEM_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'customer.CK_CSTEM_primary_active', N'C') IS NOT NULL
        BEGIN

            SELECT
                @CSTEM_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'customer.CK_CSTEM_primary_active', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_CSTEM_primary_active';
            PRINT N'            Expected Table                : customer.CustomerEmail';
            PRINT N'            Expected Rule                 : Primary email must be active';
            PRINT N'            Existing Parent               : '
                + COALESCE(@CSTEM_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50720,
                N'Check constraint CK_CSTEM_primary_active already exists on another object.',
                1;

        END;


        ALTER TABLE customer.CustomerEmail WITH CHECK
            ADD CONSTRAINT CK_CSTEM_primary_active
            CHECK
            (
                CSTEM_is_primary = 0
                OR CSTEM_is_active = 1
            );


        PRINT N'        [+] Check constraint added         : CK_CSTEM_primary_active';
        PRINT N'            Columns                        : CSTEM_is_primary, CSTEM_is_active';
        PRINT N'            Definition                     : CHECK (CSTEM_is_primary = 0 OR CSTEM_is_active = 1)';

    END

    ELSE
    BEGIN

        SET @CSTEM_check_normalized_definition =
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
                                @CSTEM_check_actual_definition,
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


        IF @CSTEM_check_actual_name = @CSTEM_check_expected_name

        AND @CSTEM_check_normalized_definition LIKE
            N'%cstem_is_primary=(0)%'

        AND @CSTEM_check_normalized_definition LIKE
            N'%orcstem_is_active=(1)%'

        AND @CSTEM_check_is_disabled = 0

        AND @CSTEM_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_CSTEM_primary_active';
            PRINT N'            Columns                        : CSTEM_is_primary, CSTEM_is_active';
            PRINT N'            Definition                     : CHECK (CSTEM_is_primary = 0 OR CSTEM_is_active = 1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_CSTEM_primary_active';
            PRINT N'            Expected Name                  : CK_CSTEM_primary_active';
            PRINT N'            Actual Name                    : '
                + COALESCE(@CSTEM_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (CSTEM_is_primary = 0 OR CSTEM_is_active = 1)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@CSTEM_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTEM_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTEM_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';