    PRINT N'';
    PRINT N'    ● inventory.InventoryMovement';
    PRINT N'';


    DECLARE @INVMV_check_expected_name          sysname;
    DECLARE @INVMV_check_actual_name            sysname;
    DECLARE @INVMV_check_actual_definition      nvarchar(4000);
    DECLARE @INVMV_check_normalized_definition  nvarchar(4000);
    DECLARE @INVMV_check_is_disabled            bit;
    DECLARE @INVMV_check_is_not_trusted         bit;
    DECLARE @INVMV_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_INVMV_quantity
    ==============================================================================*/

    SET @INVMV_check_expected_name = N'CK_INVMV_quantity';

    SET @INVMV_check_actual_name = NULL;
    SET @INVMV_check_actual_definition = NULL;
    SET @INVMV_check_normalized_definition = NULL;
    SET @INVMV_check_is_disabled = NULL;
    SET @INVMV_check_is_not_trusted = NULL;
    SET @INVMV_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH INVMV_quantity
    ----------------------------------------------------------------------*/

    SELECT
        @INVMV_check_actual_name       = cc.name,
        @INVMV_check_actual_definition = cc.definition,
        @INVMV_check_is_disabled       = cc.is_disabled,
        @INVMV_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
    AND cc.definition LIKE N'%INVMV_quantity%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS ON INVMV_quantity
    ----------------------------------------------------------------------*/

    IF @INVMV_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'inventory.CK_INVMV_quantity', N'C') IS NOT NULL
        BEGIN

            SELECT
                @INVMV_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'inventory.CK_INVMV_quantity', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_INVMV_quantity';
            PRINT N'            Expected Table                : inventory.InventoryMovement';
            PRINT N'            Expected Column               : INVMV_quantity';
            PRINT N'            Existing Parent               : '
                + COALESCE(@INVMV_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50920,
                N'Check constraint CK_INVMV_quantity already exists on another object.',
                1;

        END;


        ALTER TABLE inventory.InventoryMovement WITH CHECK
            ADD CONSTRAINT CK_INVMV_quantity
            CHECK
            (
                INVMV_quantity <> 0
            );


        PRINT N'        [+] Check constraint added         : CK_INVMV_quantity';
        PRINT N'            Column                         : INVMV_quantity';
        PRINT N'            Definition                     : CHECK (INVMV_quantity <> 0)';

    END

    ELSE
    BEGIN

        SET @INVMV_check_normalized_definition =
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
                                @INVMV_check_actual_definition,
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


        IF @INVMV_check_actual_name = @INVMV_check_expected_name

        AND
        (
            @INVMV_check_normalized_definition LIKE
                N'%invmv_quantity<>(0)%'
            OR
            @INVMV_check_normalized_definition LIKE
                N'%invmv_quantity!=(0)%'
        )

        AND @INVMV_check_is_disabled = 0

        AND @INVMV_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_INVMV_quantity';
            PRINT N'            Column                         : INVMV_quantity';
            PRINT N'            Definition                     : CHECK (INVMV_quantity <> 0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : INVMV_quantity';
            PRINT N'            Expected Name                  : CK_INVMV_quantity';
            PRINT N'            Actual Name                    : '
                + COALESCE(@INVMV_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (INVMV_quantity <> 0)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@INVMV_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INVMV_check_is_disabled),
                    N'<NULL>'
                );
            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INVMV_check_is_not_trusted),
                    N'<NULL>'
                );
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_INVMV_TRNIT_reference
    ==============================================================================*/

    SET @INVMV_check_expected_name = N'CK_INVMV_TRNIT_reference';
    SET @INVMV_check_actual_name = NULL;
    SET @INVMV_check_actual_definition = NULL;
    SET @INVMV_check_normalized_definition = NULL;
    SET @INVMV_check_is_disabled = NULL;
    SET @INVMV_check_is_not_trusted = NULL;
    SET @INVMV_check_parent_object = NULL;


    SELECT
        @INVMV_check_actual_name = cc.name,
        @INVMV_check_actual_definition = cc.definition,
        @INVMV_check_is_disabled = cc.is_disabled,
        @INVMV_check_is_not_trusted = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
    AND cc.definition LIKE N'%INVMV_TRNIT_id%'
    AND cc.definition LIKE N'%INVMV_TRNIT_transaction_at%';


    IF @INVMV_check_actual_name IS NULL
    BEGIN

        ALTER TABLE inventory.InventoryMovement WITH CHECK
            ADD CONSTRAINT CK_INVMV_TRNIT_reference
            CHECK
            (
                (INVMV_TRNIT_id IS NULL AND INVMV_TRNIT_transaction_at IS NULL)
                OR
                (INVMV_TRNIT_id IS NOT NULL AND INVMV_TRNIT_transaction_at IS NOT NULL)
            );


        PRINT N'        [+] Check constraint added         : CK_INVMV_TRNIT_reference';
        PRINT N'            Columns                        : INVMV_TRNIT_id, INVMV_TRNIT_transaction_at';
        PRINT N'            Definition                     : CHECK (both TransactionItem key values are NULL or both are NOT NULL)';

    END
    ELSE
    BEGIN

        SET @INVMV_check_normalized_definition =
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
                                @INVMV_check_actual_definition,
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


        IF @INVMV_check_actual_name = @INVMV_check_expected_name

        AND @INVMV_check_normalized_definition LIKE
            N'%invmv_trnit_idisnull%'

        AND @INVMV_check_normalized_definition LIKE
            N'%invmv_trnit_transaction_atisnull%'

        AND @INVMV_check_normalized_definition LIKE
            N'%invmv_trnit_idisnotnull%'

        AND @INVMV_check_normalized_definition LIKE
            N'%invmv_trnit_transaction_atisnotnull%'

        AND @INVMV_check_is_disabled = 0

        AND @INVMV_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_INVMV_TRNIT_reference';
            PRINT N'            Columns                        : INVMV_TRNIT_id, INVMV_TRNIT_transaction_at';
            PRINT N'            Definition                     : CHECK (both TransactionItem key values are NULL or both are NOT NULL)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_INVMV_TRNIT_reference';
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';