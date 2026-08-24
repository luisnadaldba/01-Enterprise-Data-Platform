    PRINT N'';
    PRINT N'    ● inventory.InventoryReservation';
    PRINT N'';


    DECLARE @INVRE_check_expected_name          sysname;
    DECLARE @INVRE_check_actual_name            sysname;
    DECLARE @INVRE_check_actual_definition      nvarchar(4000);
    DECLARE @INVRE_check_normalized_definition  nvarchar(4000);
    DECLARE @INVRE_check_is_disabled            bit;
    DECLARE @INVRE_check_is_not_trusted         bit;
    DECLARE @INVRE_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_INVRE_quantity
    ==============================================================================*/

    SET @INVRE_check_expected_name = N'CK_INVRE_quantity';

    SET @INVRE_check_actual_name = NULL;
    SET @INVRE_check_actual_definition = NULL;
    SET @INVRE_check_normalized_definition = NULL;
    SET @INVRE_check_is_disabled = NULL;
    SET @INVRE_check_is_not_trusted = NULL;
    SET @INVRE_check_parent_object = NULL;


    SELECT
        @INVRE_check_actual_name       = cc.name,
        @INVRE_check_actual_definition = cc.definition,
        @INVRE_check_is_disabled       = cc.is_disabled,
        @INVRE_check_is_not_trusted    = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'inventory.InventoryReservation')

    AND cc.definition LIKE N'%INVRE_quantity%';


    IF @INVRE_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'inventory.CK_INVRE_quantity', N'C') IS NOT NULL
        BEGIN

            SELECT
                @INVRE_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))

            FROM sys.check_constraints AS cc

            WHERE cc.object_id =
                OBJECT_ID(N'inventory.CK_INVRE_quantity', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_INVRE_quantity';
            PRINT N'            Expected Table                : inventory.InventoryReservation';
            PRINT N'            Expected Column               : INVRE_quantity';
            PRINT N'            Existing Parent               : '
                + COALESCE(@INVRE_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50960,
                N'Check constraint CK_INVRE_quantity already exists on another object.',
                1;

        END;


        ALTER TABLE inventory.InventoryReservation WITH CHECK
            ADD CONSTRAINT CK_INVRE_quantity
            CHECK
            (
                INVRE_quantity > 0
            );


        PRINT N'        [+] Check constraint added         : CK_INVRE_quantity';
        PRINT N'            Column                         : INVRE_quantity';
        PRINT N'            Definition                     : CHECK (INVRE_quantity > 0)';

    END

    ELSE
    BEGIN

        SET @INVRE_check_normalized_definition =
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
                                @INVRE_check_actual_definition,
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


        IF @INVRE_check_actual_name = @INVRE_check_expected_name

        AND @INVRE_check_normalized_definition LIKE
            N'%invre_quantity>(0)%'

        AND @INVRE_check_is_disabled = 0

        AND @INVRE_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_INVRE_quantity';
            PRINT N'            Column                         : INVRE_quantity';
            PRINT N'            Definition                     : CHECK (INVRE_quantity > 0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : INVRE_quantity';
            PRINT N'            Expected Name                  : CK_INVRE_quantity';
            PRINT N'            Actual Name                    : '
                + COALESCE(@INVRE_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (INVRE_quantity > 0)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@INVRE_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @INVRE_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @INVRE_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_INVRE_expires_at
    ==============================================================================*/

    SET @INVRE_check_expected_name = N'CK_INVRE_expires_at';

    SET @INVRE_check_actual_name = NULL;
    SET @INVRE_check_actual_definition = NULL;
    SET @INVRE_check_normalized_definition = NULL;
    SET @INVRE_check_is_disabled = NULL;
    SET @INVRE_check_is_not_trusted = NULL;
    SET @INVRE_check_parent_object = NULL;


    SELECT
        @INVRE_check_actual_name       = cc.name,
        @INVRE_check_actual_definition = cc.definition,
        @INVRE_check_is_disabled       = cc.is_disabled,
        @INVRE_check_is_not_trusted    = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'inventory.InventoryReservation')

    AND cc.definition LIKE N'%INVRE_expires_at%';


    IF @INVRE_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'inventory.CK_INVRE_expires_at', N'C') IS NOT NULL
        BEGIN

            SELECT
                @INVRE_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))

            FROM sys.check_constraints AS cc

            WHERE cc.object_id =
                OBJECT_ID(N'inventory.CK_INVRE_expires_at', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_INVRE_expires_at';
            PRINT N'            Expected Table                : inventory.InventoryReservation';
            PRINT N'            Expected Columns              : INVRE_reserved_at, INVRE_expires_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@INVRE_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50961,
                N'Check constraint CK_INVRE_expires_at already exists on another object.',
                1;

        END;


        ALTER TABLE inventory.InventoryReservation WITH CHECK
            ADD CONSTRAINT CK_INVRE_expires_at
            CHECK
            (
                INVRE_expires_at > INVRE_reserved_at
            );


        PRINT N'        [+] Check constraint added         : CK_INVRE_expires_at';
        PRINT N'            Columns                        : INVRE_reserved_at, INVRE_expires_at';
        PRINT N'            Definition                     : CHECK (INVRE_expires_at > INVRE_reserved_at)';

    END

    ELSE
    BEGIN

        SET @INVRE_check_normalized_definition =
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
                                @INVRE_check_actual_definition,
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


        IF @INVRE_check_actual_name = @INVRE_check_expected_name

        AND @INVRE_check_normalized_definition LIKE
            N'%invre_expires_at>invre_reserved_at%'

        AND @INVRE_check_is_disabled = 0

        AND @INVRE_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_INVRE_expires_at';
            PRINT N'            Columns                        : INVRE_reserved_at, INVRE_expires_at';
            PRINT N'            Definition                     : CHECK (INVRE_expires_at > INVRE_reserved_at)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : INVRE_expires_at';
            PRINT N'            Expected Name                  : CK_INVRE_expires_at';
            PRINT N'            Actual Name                    : '
                + COALESCE(@INVRE_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (INVRE_expires_at > INVRE_reserved_at)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@INVRE_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @INVRE_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @INVRE_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_INVRE_closed_at
    ==============================================================================*/

    SET @INVRE_check_expected_name = N'CK_INVRE_closed_at';

    SET @INVRE_check_actual_name = NULL;
    SET @INVRE_check_actual_definition = NULL;
    SET @INVRE_check_normalized_definition = NULL;
    SET @INVRE_check_is_disabled = NULL;
    SET @INVRE_check_is_not_trusted = NULL;
    SET @INVRE_check_parent_object = NULL;


    SELECT
        @INVRE_check_actual_name       = cc.name,
        @INVRE_check_actual_definition = cc.definition,
        @INVRE_check_is_disabled       = cc.is_disabled,
        @INVRE_check_is_not_trusted    = cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'inventory.InventoryReservation')

    AND cc.definition LIKE N'%INVRE_closed_at%';


    IF @INVRE_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'inventory.CK_INVRE_closed_at', N'C') IS NOT NULL
        BEGIN

            SELECT
                @INVRE_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))

            FROM sys.check_constraints AS cc

            WHERE cc.object_id =
                OBJECT_ID(N'inventory.CK_INVRE_closed_at', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_INVRE_closed_at';
            PRINT N'            Expected Table                : inventory.InventoryReservation';
            PRINT N'            Expected Columns              : INVRE_reserved_at, INVRE_closed_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@INVRE_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50962,
                N'Check constraint CK_INVRE_closed_at already exists on another object.',
                1;

        END;


        ALTER TABLE inventory.InventoryReservation WITH CHECK
            ADD CONSTRAINT CK_INVRE_closed_at
            CHECK
            (
                INVRE_closed_at IS NULL
                OR INVRE_closed_at >= INVRE_reserved_at
            );


        PRINT N'        [+] Check constraint added         : CK_INVRE_closed_at';
        PRINT N'            Columns                        : INVRE_reserved_at, INVRE_closed_at';
        PRINT N'            Definition                     : CHECK (INVRE_closed_at IS NULL OR INVRE_closed_at >= INVRE_reserved_at)';

    END

    ELSE
    BEGIN

        SET @INVRE_check_normalized_definition =
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
                                @INVRE_check_actual_definition,
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


        IF @INVRE_check_actual_name = @INVRE_check_expected_name

        AND @INVRE_check_normalized_definition LIKE
            N'%invre_closed_atisnull%'

        AND @INVRE_check_normalized_definition LIKE
            N'%invre_closed_at>=invre_reserved_at%'

        AND @INVRE_check_is_disabled = 0

        AND @INVRE_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_INVRE_closed_at';
            PRINT N'            Columns                        : INVRE_reserved_at, INVRE_closed_at';
            PRINT N'            Definition                     : CHECK (INVRE_closed_at IS NULL OR INVRE_closed_at >= INVRE_reserved_at)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : INVRE_closed_at';
            PRINT N'            Expected Name                  : CK_INVRE_closed_at';
            PRINT N'            Actual Name                    : '
                + COALESCE(@INVRE_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (INVRE_closed_at IS NULL OR INVRE_closed_at >= INVRE_reserved_at)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@INVRE_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @INVRE_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @INVRE_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';