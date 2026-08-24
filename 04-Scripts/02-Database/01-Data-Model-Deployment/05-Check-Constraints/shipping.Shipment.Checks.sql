    PRINT N'';
    PRINT N'    ● shipping.Shipment';
    PRINT N'';


    DECLARE @SHP_check_expected_name          sysname;
    DECLARE @SHP_check_actual_name            sysname;
    DECLARE @SHP_check_actual_definition      nvarchar(4000);
    DECLARE @SHP_check_normalized_definition  nvarchar(4000);
    DECLARE @SHP_check_is_disabled            bit;
    DECLARE @SHP_check_is_not_trusted         bit;
    DECLARE @SHP_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_SHP_shipping_amount
    ==============================================================================*/

    SET @SHP_check_expected_name = N'CK_SHP_shipping_amount';

    SET @SHP_check_actual_name = NULL;
    SET @SHP_check_actual_definition = NULL;
    SET @SHP_check_normalized_definition = NULL;
    SET @SHP_check_is_disabled = NULL;
    SET @SHP_check_is_not_trusted = NULL;
    SET @SHP_check_parent_object = NULL;


    SELECT
        @SHP_check_actual_name       = cc.name,
        @SHP_check_actual_definition = cc.definition,
        @SHP_check_is_disabled       = cc.is_disabled,
        @SHP_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'shipping.Shipment')
    AND cc.definition LIKE N'%SHP_shipping_amount%';


    IF @SHP_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'shipping.CK_SHP_shipping_amount', N'C') IS NOT NULL
        BEGIN

            SELECT
                @SHP_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'shipping.CK_SHP_shipping_amount', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_SHP_shipping_amount';
            PRINT N'            Expected Table                : shipping.Shipment';
            PRINT N'            Expected Column               : SHP_shipping_amount';
            PRINT N'            Existing Parent               : '
                + COALESCE(@SHP_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 51220,
                N'Check constraint CK_SHP_shipping_amount already exists on another object.',
                1;

        END;


        ALTER TABLE shipping.Shipment WITH CHECK
            ADD CONSTRAINT CK_SHP_shipping_amount
            CHECK
            (
                SHP_shipping_amount >= 0
            );


        PRINT N'        [+] Check constraint added         : CK_SHP_shipping_amount';
        PRINT N'            Column                         : SHP_shipping_amount';
        PRINT N'            Definition                     : CHECK (SHP_shipping_amount >= 0)';

    END

    ELSE
    BEGIN

        SET @SHP_check_normalized_definition =
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
                                @SHP_check_actual_definition,
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


        IF @SHP_check_actual_name = @SHP_check_expected_name

        AND @SHP_check_normalized_definition LIKE
            N'%shp_shipping_amount>=(0)%'

        AND @SHP_check_is_disabled = 0

        AND @SHP_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_SHP_shipping_amount';
            PRINT N'            Column                         : SHP_shipping_amount';
            PRINT N'            Definition                     : CHECK (SHP_shipping_amount >= 0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : SHP_shipping_amount';
            PRINT N'            Expected Name                  : CK_SHP_shipping_amount';
            PRINT N'            Actual Name                    : '
                + COALESCE(@SHP_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (SHP_shipping_amount >= 0)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@SHP_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @SHP_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @SHP_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_SHP_estimated_delivery_date
    ==============================================================================*/

    SET @SHP_check_expected_name = N'CK_SHP_estimated_delivery_date';

    SET @SHP_check_actual_name = NULL;
    SET @SHP_check_actual_definition = NULL;
    SET @SHP_check_normalized_definition = NULL;
    SET @SHP_check_is_disabled = NULL;
    SET @SHP_check_is_not_trusted = NULL;
    SET @SHP_check_parent_object = NULL;


    SELECT
        @SHP_check_actual_name       = cc.name,
        @SHP_check_actual_definition = cc.definition,
        @SHP_check_is_disabled       = cc.is_disabled,
        @SHP_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'shipping.Shipment')
    AND cc.definition LIKE N'%SHP_estimated_delivery_date%'
    AND cc.definition LIKE N'%SHP_transaction_at%';


    IF @SHP_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'shipping.CK_SHP_estimated_delivery_date', N'C') IS NOT NULL
        BEGIN

            SELECT
                @SHP_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'shipping.CK_SHP_estimated_delivery_date', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_SHP_estimated_delivery_date';
            PRINT N'            Expected Table                : shipping.Shipment';
            PRINT N'            Expected Columns              : SHP_estimated_delivery_date, SHP_transaction_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@SHP_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 51221,
                N'Check constraint CK_SHP_estimated_delivery_date already exists on another object.',
                1;

        END;


        ALTER TABLE shipping.Shipment WITH CHECK
            ADD CONSTRAINT CK_SHP_estimated_delivery_date
            CHECK
            (
                SHP_estimated_delivery_date >=
                    CONVERT(date, SHP_transaction_at)
            );


        PRINT N'        [+] Check constraint added         : CK_SHP_estimated_delivery_date';
        PRINT N'            Columns                        : SHP_estimated_delivery_date, SHP_transaction_at';
        PRINT N'            Definition                     : CHECK (SHP_estimated_delivery_date >= CONVERT(date, SHP_transaction_at))';

    END

    ELSE
    BEGIN

        SET @SHP_check_normalized_definition =
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
                                @SHP_check_actual_definition,
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


        IF @SHP_check_actual_name = @SHP_check_expected_name

        AND @SHP_check_normalized_definition LIKE
            N'%shp_estimated_delivery_date>=convert(date,shp_transaction_at)%'

        AND @SHP_check_is_disabled = 0

        AND @SHP_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_SHP_estimated_delivery_date';
            PRINT N'            Columns                        : SHP_estimated_delivery_date, SHP_transaction_at';
            PRINT N'            Definition                     : CHECK (SHP_estimated_delivery_date >= CONVERT(date, SHP_transaction_at))';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_SHP_estimated_delivery_date';
            PRINT N'            Expected Name                  : CK_SHP_estimated_delivery_date';
            PRINT N'            Actual Name                    : '
                + COALESCE(@SHP_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (SHP_estimated_delivery_date >= CONVERT(date, SHP_transaction_at))';
            PRINT N'            Actual Definition              : '
                + COALESCE(@SHP_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @SHP_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @SHP_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_SHP_posted_at
    ==============================================================================*/

    SET @SHP_check_expected_name = N'CK_SHP_posted_at';

    SET @SHP_check_actual_name = NULL;
    SET @SHP_check_actual_definition = NULL;
    SET @SHP_check_normalized_definition = NULL;
    SET @SHP_check_is_disabled = NULL;
    SET @SHP_check_is_not_trusted = NULL;
    SET @SHP_check_parent_object = NULL;


    SELECT
        @SHP_check_actual_name       = cc.name,
        @SHP_check_actual_definition = cc.definition,
        @SHP_check_is_disabled       = cc.is_disabled,
        @SHP_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'shipping.Shipment')
    AND cc.definition LIKE N'%SHP_posted_at%'
    AND cc.definition LIKE N'%SHP_transaction_at%';


    IF @SHP_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'shipping.CK_SHP_posted_at', N'C') IS NOT NULL
        BEGIN

            SELECT
                @SHP_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'shipping.CK_SHP_posted_at', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_SHP_posted_at';
            PRINT N'            Expected Table                : shipping.Shipment';
            PRINT N'            Expected Columns              : SHP_posted_at, SHP_transaction_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@SHP_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 51222,
                N'Check constraint CK_SHP_posted_at already exists on another object.',
                1;

        END;


        ALTER TABLE shipping.Shipment WITH CHECK
            ADD CONSTRAINT CK_SHP_posted_at
            CHECK
            (
                SHP_posted_at IS NULL
                OR SHP_posted_at >= SHP_transaction_at
            );


        PRINT N'        [+] Check constraint added         : CK_SHP_posted_at';
        PRINT N'            Columns                        : SHP_posted_at, SHP_transaction_at';
        PRINT N'            Definition                     : CHECK (SHP_posted_at IS NULL OR SHP_posted_at >= SHP_transaction_at)';

    END

    ELSE
    BEGIN

        SET @SHP_check_normalized_definition =
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
                                @SHP_check_actual_definition,
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


        IF @SHP_check_actual_name = @SHP_check_expected_name

        AND @SHP_check_normalized_definition LIKE
            N'%shp_posted_atisnull%'

        AND @SHP_check_normalized_definition LIKE
            N'%shp_posted_at>=shp_transaction_at%'

        AND @SHP_check_is_disabled = 0

        AND @SHP_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_SHP_posted_at';
            PRINT N'            Columns                        : SHP_posted_at, SHP_transaction_at';
            PRINT N'            Definition                     : CHECK (SHP_posted_at IS NULL OR SHP_posted_at >= SHP_transaction_at)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_SHP_posted_at';
            PRINT N'            Expected Name                  : CK_SHP_posted_at';
            PRINT N'            Actual Name                    : '
                + COALESCE(@SHP_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (SHP_posted_at IS NULL OR SHP_posted_at >= SHP_transaction_at)';
            PRINT N'            Actual Definition              : '
                + COALESCE(@SHP_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @SHP_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @SHP_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_SHP_delivered_at
    ==============================================================================*/

    SET @SHP_check_expected_name = N'CK_SHP_delivered_at';

    SET @SHP_check_actual_name = NULL;
    SET @SHP_check_actual_definition = NULL;
    SET @SHP_check_normalized_definition = NULL;
    SET @SHP_check_is_disabled = NULL;
    SET @SHP_check_is_not_trusted = NULL;
    SET @SHP_check_parent_object = NULL;


    SELECT
        @SHP_check_actual_name       = cc.name,
        @SHP_check_actual_definition = cc.definition,
        @SHP_check_is_disabled       = cc.is_disabled,
        @SHP_check_is_not_trusted    = cc.is_not_trusted
    FROM sys.check_constraints AS cc
    WHERE cc.parent_object_id = OBJECT_ID(N'shipping.Shipment')
    AND cc.definition LIKE N'%SHP_delivered_at%'
    AND cc.definition LIKE N'%SHP_posted_at%';


    IF @SHP_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'shipping.CK_SHP_delivered_at', N'C') IS NOT NULL
        BEGIN

            SELECT
                @SHP_check_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
            FROM sys.check_constraints AS cc
            WHERE cc.object_id =
                OBJECT_ID(N'shipping.CK_SHP_delivered_at', N'C');


            PRINT N'        [!] Check constraint name conflict : CK_SHP_delivered_at';
            PRINT N'            Expected Table                : shipping.Shipment';
            PRINT N'            Expected Columns              : SHP_delivered_at, SHP_posted_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@SHP_check_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 51223,
                N'Check constraint CK_SHP_delivered_at already exists on another object.',
                1;

        END;


        ALTER TABLE shipping.Shipment WITH CHECK
            ADD CONSTRAINT CK_SHP_delivered_at
            CHECK
            (
                SHP_delivered_at IS NULL
                OR
                (
                    SHP_posted_at IS NOT NULL
                    AND SHP_delivered_at >= SHP_posted_at
                )
            );


        PRINT N'        [+] Check constraint added         : CK_SHP_delivered_at';
        PRINT N'            Columns                        : SHP_delivered_at, SHP_posted_at';
        PRINT N'            Definition                     : CHECK (SHP_delivered_at IS NULL OR (SHP_posted_at IS NOT NULL AND SHP_delivered_at >= SHP_posted_at))';

    END

    ELSE
    BEGIN

        SET @SHP_check_normalized_definition =
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
                                @SHP_check_actual_definition,
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


        IF @SHP_check_actual_name = @SHP_check_expected_name

        AND @SHP_check_normalized_definition LIKE
            N'%shp_delivered_atisnull%'

        AND @SHP_check_normalized_definition LIKE
            N'%shp_posted_atisnotnull%'

        AND @SHP_check_normalized_definition LIKE
            N'%shp_delivered_at>=shp_posted_at%'

        AND @SHP_check_is_disabled = 0

        AND @SHP_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_SHP_delivered_at';
            PRINT N'            Columns                        : SHP_delivered_at, SHP_posted_at';
            PRINT N'            Definition                     : CHECK (SHP_delivered_at IS NULL OR (SHP_posted_at IS NOT NULL AND SHP_delivered_at >= SHP_posted_at))';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_SHP_delivered_at';
            PRINT N'            Expected Name                  : CK_SHP_delivered_at';
            PRINT N'            Actual Name                    : '
                + COALESCE(@SHP_check_actual_name, N'<NULL>');
            PRINT N'            Expected Definition            : CHECK (SHP_delivered_at IS NULL OR (SHP_posted_at IS NOT NULL AND SHP_delivered_at >= SHP_posted_at))';
            PRINT N'            Actual Definition              : '
                + COALESCE(@SHP_check_actual_definition, N'<NULL>');
            PRINT N'            Is Disabled                    : '
                + COALESCE(CONVERT(nvarchar(1), @SHP_check_is_disabled), N'<NULL>');
            PRINT N'            Is Not Trusted                 : '
                + COALESCE(CONVERT(nvarchar(1), @SHP_check_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';