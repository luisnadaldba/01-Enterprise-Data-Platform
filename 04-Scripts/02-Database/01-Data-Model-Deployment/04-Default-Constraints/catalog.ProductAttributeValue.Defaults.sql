    PRINT N'    catalog.ProductAttributeValue';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT VARIABLES
    ==============================================================================*/

    DECLARE @PATVL_default_expected_name          sysname;
    DECLARE @PATVL_default_actual_name            sysname;
    DECLARE @PATVL_default_actual_definition      nvarchar(4000);
    DECLARE @PATVL_default_normalized_definition  nvarchar(4000);
    DECLARE @PATVL_default_parent_object          nvarchar(517);


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PATVL_is_active
    ==============================================================================*/

    SET @PATVL_default_expected_name = N'DF_PATVL_is_active';

    SET @PATVL_default_actual_name = NULL;
    SET @PATVL_default_actual_definition = NULL;
    SET @PATVL_default_normalized_definition = NULL;
    SET @PATVL_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH PATVL_is_active
    ----------------------------------------------------------------------*/

    SELECT
        @PATVL_default_actual_name = dc.name,
        @PATVL_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc

    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

    WHERE dc.parent_object_id =
            OBJECT_ID(N'catalog.ProductAttributeValue')

    AND c.name = N'PATVL_is_active';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON PATVL_is_active
    ----------------------------------------------------------------------*/

    IF @PATVL_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'catalog.DF_PATVL_is_active', N'D') IS NOT NULL
        BEGIN

            SELECT
                @PATVL_default_parent_object =
                    QUOTENAME
                    (
                        OBJECT_SCHEMA_NAME(dc.parent_object_id)
                    )
                    + N'.'
                    + QUOTENAME
                    (
                        OBJECT_NAME(dc.parent_object_id)
                    )

            FROM sys.default_constraints AS dc

            WHERE dc.object_id =
                OBJECT_ID
                (
                    N'catalog.DF_PATVL_is_active',
                    N'D'
                );


            PRINT N'        [!] Default constraint name conflict : DF_PATVL_is_active';
            PRINT N'            Expected Table                  : catalog.ProductAttributeValue';
            PRINT N'            Expected Column                 : PATVL_is_active';
            PRINT N'            Existing Parent                 : '
                + COALESCE
                (
                    @PATVL_default_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50240,
                N'Default constraint DF_PATVL_is_active already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductAttributeValue
            ADD CONSTRAINT DF_PATVL_is_active
            DEFAULT (1) FOR PATVL_is_active;


        PRINT N'        [+] Default constraint added        : DF_PATVL_is_active';
        PRINT N'            Column                          : PATVL_is_active';
        PRINT N'            Definition                      : DEFAULT (1)';

    END

    ELSE
    BEGIN

        SET @PATVL_default_normalized_definition =
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
                                @PATVL_default_actual_definition,
                                N'(',
                                N''
                            ),
                            N')',
                            N''
                        ),
                        N' ',
                        N''
                    ),
                    NCHAR(9),
                    N''
                )
            );


        IF @PATVL_default_actual_name =
                @PATVL_default_expected_name

        AND TRY_CONVERT
            (
                int,
                @PATVL_default_normalized_definition
            ) = 1
        BEGIN

            PRINT N'        [•] Default constraint validated    : DF_PATVL_is_active';
            PRINT N'            Column                          : PATVL_is_active';
            PRINT N'            Definition                      : DEFAULT (1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch     : PATVL_is_active';
            PRINT N'            Expected Name                   : DF_PATVL_is_active';
            PRINT N'            Actual Name                     : '
                + COALESCE
                (
                    @PATVL_default_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition             : DEFAULT (1)';
            PRINT N'            Actual Definition               : '
                + COALESCE
                (
                    @PATVL_default_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PATVL_created_at
    ==============================================================================*/

    SET @PATVL_default_expected_name = N'DF_PATVL_created_at';

    SET @PATVL_default_actual_name = NULL;
    SET @PATVL_default_actual_definition = NULL;
    SET @PATVL_default_normalized_definition = NULL;
    SET @PATVL_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH PATVL_created_at
    ----------------------------------------------------------------------*/

    SELECT
        @PATVL_default_actual_name = dc.name,
        @PATVL_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc

    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

    WHERE dc.parent_object_id =
            OBJECT_ID(N'catalog.ProductAttributeValue')

    AND c.name = N'PATVL_created_at';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON PATVL_created_at
    ----------------------------------------------------------------------*/

    IF @PATVL_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'catalog.DF_PATVL_created_at', N'D') IS NOT NULL
        BEGIN

            SELECT
                @PATVL_default_parent_object =
                    QUOTENAME
                    (
                        OBJECT_SCHEMA_NAME(dc.parent_object_id)
                    )
                    + N'.'
                    + QUOTENAME
                    (
                        OBJECT_NAME(dc.parent_object_id)
                    )

            FROM sys.default_constraints AS dc

            WHERE dc.object_id =
                OBJECT_ID
                (
                    N'catalog.DF_PATVL_created_at',
                    N'D'
                );


            PRINT N'        [!] Default constraint name conflict : DF_PATVL_created_at';
            PRINT N'            Expected Table                  : catalog.ProductAttributeValue';
            PRINT N'            Expected Column                 : PATVL_created_at';
            PRINT N'            Existing Parent                 : '
                + COALESCE
                (
                    @PATVL_default_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50241,
                N'Default constraint DF_PATVL_created_at already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductAttributeValue
            ADD CONSTRAINT DF_PATVL_created_at
            DEFAULT (SYSDATETIME()) FOR PATVL_created_at;


        PRINT N'        [+] Default constraint added        : DF_PATVL_created_at';
        PRINT N'            Column                          : PATVL_created_at';
        PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

    END

    ELSE
    BEGIN

        SET @PATVL_default_normalized_definition =
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
                                @PATVL_default_actual_definition,
                                N'(',
                                N''
                            ),
                            N')',
                            N''
                        ),
                        N' ',
                        N''
                    ),
                    NCHAR(9),
                    N''
                )
            );


        IF @PATVL_default_actual_name =
                @PATVL_default_expected_name

        AND @PATVL_default_normalized_definition =
                N'sysdatetime'
        BEGIN

            PRINT N'        [•] Default constraint validated    : DF_PATVL_created_at';
            PRINT N'            Column                          : PATVL_created_at';
            PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch     : PATVL_created_at';
            PRINT N'            Expected Name                   : DF_PATVL_created_at';
            PRINT N'            Actual Name                     : '
                + COALESCE
                (
                    @PATVL_default_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition             : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition               : '
                + COALESCE
                (
                    @PATVL_default_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PATVL_updated_at
    ==============================================================================*/

    SET @PATVL_default_expected_name = N'DF_PATVL_updated_at';

    SET @PATVL_default_actual_name = NULL;
    SET @PATVL_default_actual_definition = NULL;
    SET @PATVL_default_normalized_definition = NULL;
    SET @PATVL_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH PATVL_updated_at
    ----------------------------------------------------------------------*/

    SELECT
        @PATVL_default_actual_name = dc.name,
        @PATVL_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc

    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

    WHERE dc.parent_object_id =
            OBJECT_ID(N'catalog.ProductAttributeValue')

    AND c.name = N'PATVL_updated_at';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON PATVL_updated_at
    ----------------------------------------------------------------------*/

    IF @PATVL_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'catalog.DF_PATVL_updated_at', N'D') IS NOT NULL
        BEGIN

            SELECT
                @PATVL_default_parent_object =
                    QUOTENAME
                    (
                        OBJECT_SCHEMA_NAME(dc.parent_object_id)
                    )
                    + N'.'
                    + QUOTENAME
                    (
                        OBJECT_NAME(dc.parent_object_id)
                    )

            FROM sys.default_constraints AS dc

            WHERE dc.object_id =
                OBJECT_ID
                (
                    N'catalog.DF_PATVL_updated_at',
                    N'D'
                );


            PRINT N'        [!] Default constraint name conflict : DF_PATVL_updated_at';
            PRINT N'            Expected Table                  : catalog.ProductAttributeValue';
            PRINT N'            Expected Column                 : PATVL_updated_at';
            PRINT N'            Existing Parent                 : '
                + COALESCE
                (
                    @PATVL_default_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50242,
                N'Default constraint DF_PATVL_updated_at already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductAttributeValue
            ADD CONSTRAINT DF_PATVL_updated_at
            DEFAULT (SYSDATETIME()) FOR PATVL_updated_at;


        PRINT N'        [+] Default constraint added        : DF_PATVL_updated_at';
        PRINT N'            Column                          : PATVL_updated_at';
        PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

    END

    ELSE
    BEGIN

        SET @PATVL_default_normalized_definition =
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
                                @PATVL_default_actual_definition,
                                N'(',
                                N''
                            ),
                            N')',
                            N''
                        ),
                        N' ',
                        N''
                    ),
                    NCHAR(9),
                    N''
                )
            );


        IF @PATVL_default_actual_name =
                @PATVL_default_expected_name

        AND @PATVL_default_normalized_definition =
                N'sysdatetime'
        BEGIN

            PRINT N'        [•] Default constraint validated    : DF_PATVL_updated_at';
            PRINT N'            Column                          : PATVL_updated_at';
            PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch     : PATVL_updated_at';
            PRINT N'            Expected Name                   : DF_PATVL_updated_at';
            PRINT N'            Actual Name                     : '
                + COALESCE
                (
                    @PATVL_default_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition             : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition               : '
                + COALESCE
                (
                    @PATVL_default_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';