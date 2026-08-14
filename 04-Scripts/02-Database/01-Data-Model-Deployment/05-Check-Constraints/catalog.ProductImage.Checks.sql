    PRINT N'    catalog.ProductImage';
    PRINT N'    --------------------------------------------------------------------------';


    DECLARE @PRDIM_check_expected_name          sysname;
    DECLARE @PRDIM_check_actual_name            sysname;
    DECLARE @PRDIM_check_actual_definition      nvarchar(4000);
    DECLARE @PRDIM_check_normalized_definition  nvarchar(4000);
    DECLARE @PRDIM_check_is_disabled            bit;
    DECLARE @PRDIM_check_is_not_trusted         bit;
    DECLARE @PRDIM_check_parent_object          nvarchar(517);


    /*==============================================================================
        CHECK CONSTRAINT: CK_PRDIM_display_order
    ==============================================================================*/

    SET @PRDIM_check_expected_name = N'CK_PRDIM_display_order';

    SET @PRDIM_check_actual_name = NULL;
    SET @PRDIM_check_actual_definition = NULL;
    SET @PRDIM_check_normalized_definition = NULL;
    SET @PRDIM_check_is_disabled = NULL;
    SET @PRDIM_check_is_not_trusted = NULL;
    SET @PRDIM_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH PRDIM_display_order
    ----------------------------------------------------------------------*/

    SELECT
        @PRDIM_check_actual_name =
            cc.name,

        @PRDIM_check_actual_definition =
            cc.definition,

        @PRDIM_check_is_disabled =
            cc.is_disabled,

        @PRDIM_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'catalog.ProductImage')

    AND cc.definition LIKE
            N'%PRDIM_display_order%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS ON PRDIM_display_order
    ----------------------------------------------------------------------*/

    IF @PRDIM_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID
        (
            N'catalog.CK_PRDIM_display_order',
            N'C'
        ) IS NOT NULL
        BEGIN

            SELECT
                @PRDIM_check_parent_object =
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
                        N'catalog.CK_PRDIM_display_order',
                        N'C'
                    );


            PRINT N'        [!] Check constraint name conflict : CK_PRDIM_display_order';
            PRINT N'            Expected Table                : catalog.ProductImage';
            PRINT N'            Expected Column               : PRDIM_display_order';
            PRINT N'            Existing Parent               : '
                + COALESCE
                (
                    @PRDIM_check_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50420,
                N'Check constraint CK_PRDIM_display_order already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductImage
            WITH CHECK
            ADD CONSTRAINT CK_PRDIM_display_order
            CHECK
            (
                PRDIM_display_order >= 1
            );


        PRINT N'        [+] Check constraint added         : CK_PRDIM_display_order';
        PRINT N'            Column                         : PRDIM_display_order';
        PRINT N'            Definition                     : CHECK (PRDIM_display_order >= 1)';

    END

    ELSE
    BEGIN

        SET @PRDIM_check_normalized_definition =
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
                                @PRDIM_check_actual_definition,
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


        IF @PRDIM_check_actual_name =
                @PRDIM_check_expected_name

        AND @PRDIM_check_normalized_definition LIKE
                N'%prdim_display_order>=(1)%'

        AND @PRDIM_check_is_disabled = 0

        AND @PRDIM_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PRDIM_display_order';
            PRINT N'            Column                         : PRDIM_display_order';
            PRINT N'            Definition                     : CHECK (PRDIM_display_order >= 1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : PRDIM_display_order';

            PRINT N'            Expected Name                  : CK_PRDIM_display_order';

            PRINT N'            Actual Name                    : '
                + COALESCE
                (
                    @PRDIM_check_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition            : CHECK (PRDIM_display_order >= 1)';

            PRINT N'            Actual Definition              : '
                + COALESCE
                (
                    @PRDIM_check_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDIM_check_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDIM_check_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_PRDIM_primary_active

        Rule:
            An image identified as the primary image of a Product must be active.

            Valid:
                is_primary = 0 / is_active = 0
                is_primary = 0 / is_active = 1
                is_primary = 1 / is_active = 1

            Invalid:
                is_primary = 1 / is_active = 0
    ==============================================================================*/

    SET @PRDIM_check_expected_name =
        N'CK_PRDIM_primary_active';

    SET @PRDIM_check_actual_name = NULL;
    SET @PRDIM_check_actual_definition = NULL;
    SET @PRDIM_check_normalized_definition = NULL;
    SET @PRDIM_check_is_disabled = NULL;
    SET @PRDIM_check_is_not_trusted = NULL;
    SET @PRDIM_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH PRIMARY / ACTIVE RULE
    ----------------------------------------------------------------------*/

    SELECT
        @PRDIM_check_actual_name =
            cc.name,

        @PRDIM_check_actual_definition =
            cc.definition,

        @PRDIM_check_is_disabled =
            cc.is_disabled,

        @PRDIM_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'catalog.ProductImage')

    AND cc.definition LIKE
            N'%PRDIM_is_primary%'

    AND cc.definition LIKE
            N'%PRDIM_is_active%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS FOR PRIMARY / ACTIVE RULE
    ----------------------------------------------------------------------*/

    IF @PRDIM_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID
        (
            N'catalog.CK_PRDIM_primary_active',
            N'C'
        ) IS NOT NULL
        BEGIN

            SELECT
                @PRDIM_check_parent_object =
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
                        N'catalog.CK_PRDIM_primary_active',
                        N'C'
                    );


            PRINT N'        [!] Check constraint name conflict : CK_PRDIM_primary_active';
            PRINT N'            Expected Table                : catalog.ProductImage';
            PRINT N'            Expected Columns              : PRDIM_is_primary, PRDIM_is_active';
            PRINT N'            Existing Parent               : '
                + COALESCE
                (
                    @PRDIM_check_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50421,
                N'Check constraint CK_PRDIM_primary_active already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductImage
            WITH CHECK
            ADD CONSTRAINT CK_PRDIM_primary_active
            CHECK
            (
                PRDIM_is_primary = 0
                OR PRDIM_is_active = 1
            );


        PRINT N'        [+] Check constraint added         : CK_PRDIM_primary_active';
        PRINT N'            Columns                        : PRDIM_is_primary, PRDIM_is_active';
        PRINT N'            Definition                     : CHECK (PRDIM_is_primary = 0 OR PRDIM_is_active = 1)';

    END

    ELSE
    BEGIN

        SET @PRDIM_check_normalized_definition =
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
                                @PRDIM_check_actual_definition,
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


        IF @PRDIM_check_actual_name =
                @PRDIM_check_expected_name

        AND @PRDIM_check_normalized_definition LIKE
                N'%prdim_is_primary=(0)%'

        AND @PRDIM_check_normalized_definition LIKE
                N'%orprdim_is_active=(1)%'

        AND @PRDIM_check_is_disabled = 0

        AND @PRDIM_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PRDIM_primary_active';
            PRINT N'            Columns                        : PRDIM_is_primary, PRDIM_is_active';
            PRINT N'            Definition                     : CHECK (PRDIM_is_primary = 0 OR PRDIM_is_active = 1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : CK_PRDIM_primary_active';

            PRINT N'            Expected Name                  : CK_PRDIM_primary_active';

            PRINT N'            Actual Name                    : '
                + COALESCE
                (
                    @PRDIM_check_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition            : CHECK (PRDIM_is_primary = 0 OR PRDIM_is_active = 1)';

            PRINT N'            Actual Definition              : '
                + COALESCE
                (
                    @PRDIM_check_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDIM_check_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDIM_check_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        CHECK CONSTRAINT: CK_PRDIM_path

        Rule:
            An image reference must contain a meaningful value.

            PRDIM_path is already NOT NULL, but NOT NULL alone would still permit:
                N''
                N'   '

            This constraint prevents both cases.
    ==============================================================================*/

    SET @PRDIM_check_expected_name =
        N'CK_PRDIM_path';

    SET @PRDIM_check_actual_name = NULL;
    SET @PRDIM_check_actual_definition = NULL;
    SET @PRDIM_check_normalized_definition = NULL;
    SET @PRDIM_check_is_disabled = NULL;
    SET @PRDIM_check_is_not_trusted = NULL;
    SET @PRDIM_check_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE CHECK CURRENTLY ASSOCIATED WITH PRDIM_path
    ----------------------------------------------------------------------*/

    SELECT
        @PRDIM_check_actual_name =
            cc.name,

        @PRDIM_check_actual_definition =
            cc.definition,

        @PRDIM_check_is_disabled =
            cc.is_disabled,

        @PRDIM_check_is_not_trusted =
            cc.is_not_trusted

    FROM sys.check_constraints AS cc

    WHERE cc.parent_object_id =
            OBJECT_ID(N'catalog.ProductImage')

    AND cc.definition LIKE
            N'%PRDIM_path%';


    /*----------------------------------------------------------------------
        NO CHECK CURRENTLY EXISTS ON PRDIM_path
    ----------------------------------------------------------------------*/

    IF @PRDIM_check_actual_name IS NULL
    BEGIN

        IF OBJECT_ID
        (
            N'catalog.CK_PRDIM_path',
            N'C'
        ) IS NOT NULL
        BEGIN

            SELECT
                @PRDIM_check_parent_object =
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
                        N'catalog.CK_PRDIM_path',
                        N'C'
                    );


            PRINT N'        [!] Check constraint name conflict : CK_PRDIM_path';
            PRINT N'            Expected Table                : catalog.ProductImage';
            PRINT N'            Expected Column               : PRDIM_path';
            PRINT N'            Existing Parent               : '
                + COALESCE
                (
                    @PRDIM_check_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50422,
                N'Check constraint CK_PRDIM_path already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductImage
            WITH CHECK
            ADD CONSTRAINT CK_PRDIM_path
            CHECK
            (
                LEN
                (
                    LTRIM
                    (
                        RTRIM(PRDIM_path)
                    )
                ) > 0
            );


        PRINT N'        [+] Check constraint added         : CK_PRDIM_path';
        PRINT N'            Column                         : PRDIM_path';
        PRINT N'            Definition                     : CHECK (LEN(LTRIM(RTRIM(PRDIM_path))) > 0)';

    END

    ELSE
    BEGIN

        SET @PRDIM_check_normalized_definition =
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
                                @PRDIM_check_actual_definition,
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


        IF @PRDIM_check_actual_name =
                @PRDIM_check_expected_name

        AND @PRDIM_check_normalized_definition LIKE
                N'%len(ltrim(rtrim(prdim_path)))>(0)%'

        AND @PRDIM_check_is_disabled = 0

        AND @PRDIM_check_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Check constraint validated     : CK_PRDIM_path';
            PRINT N'            Column                         : PRDIM_path';
            PRINT N'            Definition                     : CHECK (LEN(LTRIM(RTRIM(PRDIM_path))) > 0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Check constraint mismatch      : PRDIM_path';

            PRINT N'            Expected Name                  : CK_PRDIM_path';

            PRINT N'            Actual Name                    : '
                + COALESCE
                (
                    @PRDIM_check_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition            : CHECK (LEN(LTRIM(RTRIM(PRDIM_path))) > 0)';

            PRINT N'            Actual Definition              : '
                + COALESCE
                (
                    @PRDIM_check_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Is Disabled                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDIM_check_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Is Not Trusted                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDIM_check_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';