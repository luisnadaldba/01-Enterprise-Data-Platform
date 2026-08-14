    PRINT N'    catalog.ProductVariantPrice';
    PRINT N'    --------------------------------------------------------------------------';


    DECLARE @PRDVP_check_expected_name          sysname;
    DECLARE @PRDVP_check_actual_name            sysname;
    DECLARE @PRDVP_check_actual_definition      nvarchar(4000);
    DECLARE @PRDVP_check_normalized_definition  nvarchar(4000);
    DECLARE @PRDVP_check_is_disabled            bit;
    DECLARE @PRDVP_check_is_not_trusted         bit;
    DECLARE @PRDVP_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_PRDVP_price

        Business Rule:
            A commercial price must be greater than zero.
    ==============================================================================*/

    SET @PRDVP_check_expected_name =
        N'CK_PRDVP_price';

    SET @PRDVP_check_actual_name = NULL;
    SET @PRDVP_check_actual_definition = NULL;
    SET @PRDVP_check_normalized_definition = NULL;
    SET @PRDVP_check_is_disabled = NULL;
    SET @PRDVP_check_is_not_trusted = NULL;
    SET @PRDVP_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH PRDVP_price
    ----------------------------------------------------------------------*/

    SELECT
        @PRDVP_check_actual_name =
            cc.name,

        @PRDVP_check_actual_definition =
            cc.definition,

        @PRDVP_check_is_disabled =
            cc.is_disabled,

        @PRDVP_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND cc.definition LIKE
            N'%PRDVP_price%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS ON PRDVP_price
    ----------------------------------------------------------------------*/

    IF @PRDVP_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID
        (
            N'catalog.CK_PRDVP_price',
            N'C'
        ) IS NOT NULL
        BEGIN

            SELECT
                @PRDVP_check_parent_object =
                    QUOTENAME
                    (
                        OBJECT_SCHEMA_NAME
                        (
                            cc.parent_object_id
                        )
                    )
                    + N'.'
                    + QUOTENAME
                    (
                        OBJECT_NAME
                        (
                            cc.parent_object_id
                        )
                    )

            FROM sys.check_constraints AS cc

            WHERE cc.object_id =
                    OBJECT_ID
                    (
                        N'catalog.CK_PRDVP_price',
                        N'C'
                    );


            PRINT N'        [!] Check constraint name conflict : CK_PRDVP_price';
            PRINT N'            Expected Table                : catalog.ProductVariantPrice';
            PRINT N'            Expected Column               : PRDVP_price';
            PRINT N'            Existing Parent               : '
                + COALESCE
                (
                    @PRDVP_check_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50480,
                N'Check constraint CK_PRDVP_price already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductVariantPrice
            WITH CHECK
            ADD CONSTRAINT CK_PRDVP_price
            CHECK
            (
                PRDVP_price > 0.00
            );


        PRINT N'        [+] Check constraint added         : CK_PRDVP_price';
        PRINT N'            Column                         : PRDVP_price';
        PRINT N'            Definition                     : CHECK (PRDVP_price > 0.00)';

    END

    ELSE
    BEGIN

        SET @PRDVP_check_normalized_definition =
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
                                @PRDVP_check_actual_definition,
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


        IF @PRDVP_check_actual_name =
                @PRDVP_check_expected_name

        AND @PRDVP_check_normalized_definition LIKE
                N'%prdvp_price>(0.00)%'

        AND @PRDVP_check_is_disabled = 0

        AND @PRDVP_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PRDVP_price';
            PRINT N'            Column                         : PRDVP_price';
            PRINT N'            Definition                     : CHECK (PRDVP_price > 0.00)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : PRDVP_price';

            PRINT N'            Expected Name                  : CK_PRDVP_price';

            PRINT N'            Actual Name                    : '
                + COALESCE
                (
                    @PRDVP_check_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition            : CHECK (PRDVP_price > 0.00)';

            PRINT N'            Actual Definition              : '
                + COALESCE
                (
                    @PRDVP_check_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDVP_check_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDVP_check_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_PRDVP_valid_period

        Business Rule:
            PRDVP_valid_from is the inclusive lower boundary.

            PRDVP_valid_to is the exclusive upper boundary.

            NULL valid_to represents an open-ended validity interval.

            Therefore, when valid_to exists, it must be strictly greater than
            valid_from.
    ==============================================================================*/

    SET @PRDVP_check_expected_name =
        N'CK_PRDVP_valid_period';

    SET @PRDVP_check_actual_name = NULL;
    SET @PRDVP_check_actual_definition = NULL;
    SET @PRDVP_check_normalized_definition = NULL;
    SET @PRDVP_check_is_disabled = NULL;
    SET @PRDVP_check_is_not_trusted = NULL;
    SET @PRDVP_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH VALIDITY PERIOD
    ----------------------------------------------------------------------*/

    SELECT
        @PRDVP_check_actual_name =
            cc.name,

        @PRDVP_check_actual_definition =
            cc.definition,

        @PRDVP_check_is_disabled =
            cc.is_disabled,

        @PRDVP_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND cc.definition LIKE
            N'%PRDVP_valid_from%'

    AND cc.definition LIKE
            N'%PRDVP_valid_to%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS FOR VALIDITY PERIOD
    ----------------------------------------------------------------------*/

    IF @PRDVP_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID
        (
            N'catalog.CK_PRDVP_valid_period',
            N'C'
        ) IS NOT NULL
        BEGIN

            SELECT
                @PRDVP_check_parent_object =
                    QUOTENAME
                    (
                        OBJECT_SCHEMA_NAME
                        (
                            cc.parent_object_id
                        )
                    )
                    + N'.'
                    + QUOTENAME
                    (
                        OBJECT_NAME
                        (
                            cc.parent_object_id
                        )
                    )

            FROM sys.check_constraints AS cc

            WHERE cc.object_id =
                    OBJECT_ID
                    (
                        N'catalog.CK_PRDVP_valid_period',
                        N'C'
                    );


            PRINT N'        [!] Check constraint name conflict : CK_PRDVP_valid_period';
            PRINT N'            Expected Table                : catalog.ProductVariantPrice';
            PRINT N'            Expected Columns              : PRDVP_valid_from, PRDVP_valid_to';
            PRINT N'            Existing Parent               : '
                + COALESCE
                (
                    @PRDVP_check_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50481,
                N'Check constraint CK_PRDVP_valid_period already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductVariantPrice
            WITH CHECK
            ADD CONSTRAINT CK_PRDVP_valid_period
            CHECK
            (
                PRDVP_valid_to IS NULL
                OR PRDVP_valid_to > PRDVP_valid_from
            );


        PRINT N'        [+] Check constraint added         : CK_PRDVP_valid_period';
        PRINT N'            Columns                        : PRDVP_valid_from, PRDVP_valid_to';
        PRINT N'            Definition                     : CHECK (PRDVP_valid_to IS NULL OR PRDVP_valid_to > PRDVP_valid_from)';

    END

    ELSE
    BEGIN

        SET @PRDVP_check_normalized_definition =
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
                                @PRDVP_check_actual_definition,
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


        IF @PRDVP_check_actual_name =
                @PRDVP_check_expected_name

        AND @PRDVP_check_normalized_definition LIKE
                N'%prdvp_valid_toisnull%'

        AND @PRDVP_check_normalized_definition LIKE
                N'%orprdvp_valid_to>prdvp_valid_from%'

        AND @PRDVP_check_is_disabled = 0

        AND @PRDVP_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PRDVP_valid_period';
            PRINT N'            Columns                        : PRDVP_valid_from, PRDVP_valid_to';
            PRINT N'            Definition                     : CHECK (PRDVP_valid_to IS NULL OR PRDVP_valid_to > PRDVP_valid_from)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_PRDVP_valid_period';

            PRINT N'            Expected Name                  : CK_PRDVP_valid_period';

            PRINT N'            Actual Name                    : '
                + COALESCE
                (
                    @PRDVP_check_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition            : CHECK (PRDVP_valid_to IS NULL OR PRDVP_valid_to > PRDVP_valid_from)';

            PRINT N'            Actual Definition              : '
                + COALESCE
                (
                    @PRDVP_check_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDVP_check_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDVP_check_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';