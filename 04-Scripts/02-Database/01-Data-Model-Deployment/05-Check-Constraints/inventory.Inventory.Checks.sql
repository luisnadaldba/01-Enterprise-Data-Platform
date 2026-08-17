    PRINT N'    inventory.Inventory';
    PRINT N'    --------------------------------------------------------------------------';


    DECLARE @INV_check_expected_name          sysname;
    DECLARE @INV_check_actual_name            sysname;
    DECLARE @INV_check_actual_definition      nvarchar(4000);
    DECLARE @INV_check_normalized_definition  nvarchar(4000);
    DECLARE @INV_check_is_disabled            bit;
    DECLARE @INV_check_is_not_trusted         bit;
    DECLARE @INV_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_INV_quantity_on_hand
    ==============================================================================*/

    SET @INV_check_expected_name = N'CK_INV_quantity_on_hand';

    SET @INV_check_actual_name = NULL;
    SET @INV_check_actual_definition = NULL;
    SET @INV_check_normalized_definition = NULL;
    SET @INV_check_is_disabled = NULL;
    SET @INV_check_is_not_trusted = NULL;
    SET @INV_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH INV_quantity_on_hand
    ----------------------------------------------------------------------*/

    SELECT
        @INV_check_actual_name       = cc.name,
        @INV_check_actual_definition = cc.definition,
        @INV_check_is_disabled       = cc.is_disabled,
        @INV_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'inventory.Inventory')
    AND cc.definition LIKE N'%INV_quantity_on_hand%'
    AND cc.definition NOT LIKE N'%INV_quantity_reserved%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS ON INV_quantity_on_hand
    ----------------------------------------------------------------------*/

    IF @INV_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'inventory.CK_INV_quantity_on_hand', N'C') IS NOT NULL
        BEGIN

            SELECT
                @INV_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'inventory.CK_INV_quantity_on_hand', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_INV_quantity_on_hand';
            PRINT N'            Expected Table                : inventory.Inventory';
            PRINT N'            Expected Column               : INV_quantity_on_hand';
            PRINT N'            Existing Parent               : '
                + COALESCE(@INV_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50510,
                N'Check constraint CK_INV_quantity_on_hand already exists on another object.',
                1;

        END;


        ALTER TABLE inventory.Inventory WITH CHECK
            ADD CONSTRAINT CK_INV_quantity_on_hand
            CHECK
            (
                INV_quantity_on_hand >= 0
            );


        PRINT N'        [+] Check constraint added         : CK_INV_quantity_on_hand';
        PRINT N'            Column                         : INV_quantity_on_hand';
        PRINT N'            Definition                     : CHECK (INV_quantity_on_hand >= 0)';

    END

    ELSE
    BEGIN

        SET @INV_check_normalized_definition =
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
                                @INV_check_actual_definition,
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


        IF @INV_check_actual_name = @INV_check_expected_name

        AND @INV_check_normalized_definition LIKE
            N'%inv_quantity_on_hand>=(0)%'

        AND @INV_check_is_disabled = 0

        AND @INV_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_INV_quantity_on_hand';
            PRINT N'            Column                         : INV_quantity_on_hand';
            PRINT N'            Definition                     : CHECK (INV_quantity_on_hand >= 0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : INV_quantity_on_hand';
            PRINT N'            Expected Name                  : CK_INV_quantity_on_hand';
            PRINT N'            Actual Name                    : '
                + COALESCE(@INV_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (INV_quantity_on_hand >= 0)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@INV_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INV_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INV_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_INV_quantity_reserved
    ==============================================================================*/

    SET @INV_check_expected_name = N'CK_INV_quantity_reserved';

    SET @INV_check_actual_name = NULL;
    SET @INV_check_actual_definition = NULL;
    SET @INV_check_normalized_definition = NULL;
    SET @INV_check_is_disabled = NULL;
    SET @INV_check_is_not_trusted = NULL;
    SET @INV_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH INV_quantity_reserved
    ----------------------------------------------------------------------*/

    SELECT
        @INV_check_actual_name       = cc.name,
        @INV_check_actual_definition = cc.definition,
        @INV_check_is_disabled       = cc.is_disabled,
        @INV_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'inventory.Inventory')
    AND cc.definition LIKE N'%INV_quantity_reserved%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS ON INV_quantity_reserved
    ----------------------------------------------------------------------*/

    IF @INV_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'inventory.CK_INV_quantity_reserved', N'C') IS NOT NULL
        BEGIN

            SELECT
                @INV_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'inventory.CK_INV_quantity_reserved', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_INV_quantity_reserved';
            PRINT N'            Expected Table                : inventory.Inventory';
            PRINT N'            Expected Column               : INV_quantity_reserved';
            PRINT N'            Existing Parent               : '
                + COALESCE(@INV_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50511,
                N'Check constraint CK_INV_quantity_reserved already exists on another object.',
                1;

        END;


        ALTER TABLE inventory.Inventory WITH CHECK
            ADD CONSTRAINT CK_INV_quantity_reserved
            CHECK
            (
                INV_quantity_reserved >= 0
                AND INV_quantity_reserved <= INV_quantity_on_hand
            );


        PRINT N'        [+] Check constraint added         : CK_INV_quantity_reserved';
        PRINT N'            Column                         : INV_quantity_reserved';
        PRINT N'            Definition                     : CHECK (INV_quantity_reserved >= 0 AND INV_quantity_reserved <= INV_quantity_on_hand)';

    END

    ELSE
    BEGIN

        SET @INV_check_normalized_definition =
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
                                @INV_check_actual_definition,
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


        IF @INV_check_actual_name = @INV_check_expected_name

        AND @INV_check_normalized_definition LIKE
            N'%inv_quantity_reserved>=(0)%'

        AND @INV_check_normalized_definition LIKE
            N'%inv_quantity_reserved<=inv_quantity_on_hand%'

        AND @INV_check_is_disabled = 0

        AND @INV_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_INV_quantity_reserved';
            PRINT N'            Column                         : INV_quantity_reserved';
            PRINT N'            Definition                     : CHECK (INV_quantity_reserved >= 0 AND INV_quantity_reserved <= INV_quantity_on_hand)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : INV_quantity_reserved';
            PRINT N'            Expected Name                  : CK_INV_quantity_reserved';
            PRINT N'            Actual Name                    : '
                + COALESCE(@INV_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (INV_quantity_reserved >= 0 AND INV_quantity_reserved <= INV_quantity_on_hand)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@INV_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INV_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INV_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';