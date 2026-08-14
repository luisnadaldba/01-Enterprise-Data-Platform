    PRINT N'    reference.Address';
    PRINT N'    --------------------------------------------------------------------------';


    DECLARE @ADR_check_expected_name          sysname;
    DECLARE @ADR_check_actual_name            sysname;
    DECLARE @ADR_check_actual_definition      nvarchar(4000);
    DECLARE @ADR_check_normalized_definition  nvarchar(4000);
    DECLARE @ADR_check_is_disabled            bit;
    DECLARE @ADR_check_is_not_trusted         bit;
    DECLARE @ADR_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_ADR_postal_code
    ==============================================================================*/

    SET @ADR_check_expected_name = N'CK_ADR_postal_code';

    SET @ADR_check_actual_name = NULL;
    SET @ADR_check_actual_definition = NULL;
    SET @ADR_check_normalized_definition = NULL;
    SET @ADR_check_is_disabled = NULL;
    SET @ADR_check_is_not_trusted = NULL;
    SET @ADR_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH ADR_postal_code
    ----------------------------------------------------------------------*/

    SELECT
        @ADR_check_actual_name       = cc.name,
        @ADR_check_actual_definition = cc.definition,
        @ADR_check_is_disabled       = cc.is_disabled,
        @ADR_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'reference.Address')
    AND cc.definition LIKE N'%ADR_postal_code%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS ON ADR_postal_code
    ----------------------------------------------------------------------*/

    IF @ADR_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'reference.CK_ADR_postal_code', N'C') IS NOT NULL
        BEGIN

            SELECT
                @ADR_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'reference.CK_ADR_postal_code', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_ADR_postal_code';
            PRINT N'            Expected Table                : reference.Address';
            PRINT N'            Expected Column               : ADR_postal_code';
            PRINT N'            Existing Parent               : '
                + COALESCE(@ADR_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50050,
                N'Check constraint CK_ADR_postal_code already exists on another object.',
                1;

        END;


        ALTER TABLE reference.Address WITH CHECK
            ADD CONSTRAINT CK_ADR_postal_code
            CHECK
            (
                LEN(ADR_postal_code) = 8
                AND ADR_postal_code NOT LIKE '%[^0-9]%'
            );


        PRINT N'        [+] Check constraint added         : CK_ADR_postal_code';
        PRINT N'            Column                         : ADR_postal_code';
        PRINT N'            Definition                     : CHECK (LEN(ADR_postal_code) = 8 AND ADR_postal_code NOT LIKE ''%[^0-9]%'')';

    END

    ELSE
    BEGIN

        SET @ADR_check_normalized_definition =
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
                                @ADR_check_actual_definition,
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


        IF @ADR_check_actual_name = @ADR_check_expected_name

        AND @ADR_check_normalized_definition LIKE            N'%len(adr_postal_code)=(8)%'
        AND @ADR_check_normalized_definition LIKE            N'%notadr_postal_codelike''%[^0-9]%''%'

        AND @ADR_check_is_disabled = 0

        AND @ADR_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_ADR_postal_code';
            PRINT N'            Column                         : ADR_postal_code';
            PRINT N'            Definition                     : CHECK (LEN(ADR_postal_code) = 8 AND ADR_postal_code NOT LIKE ''%[^0-9]%'')';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : ADR_postal_code';
            PRINT N'            Expected Name                  : CK_ADR_postal_code';
            PRINT N'            Actual Name                    : '
                + COALESCE(@ADR_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (LEN(ADR_postal_code) = 8 AND ADR_postal_code NOT LIKE ''%[^0-9]%'')';
            PRINT N'            Actual Definition              : '
                + COALESCE(@ADR_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @ADR_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @ADR_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';