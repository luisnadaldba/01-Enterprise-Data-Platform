    PRINT N'    catalog.ProductAttribute';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT VARIABLES
    ==============================================================================*/

    DECLARE @PAT_default_expected_name          sysname;
    DECLARE @PAT_default_actual_name            sysname;
    DECLARE @PAT_default_actual_definition      nvarchar(4000);
    DECLARE @PAT_default_normalized_definition  nvarchar(4000);
    DECLARE @PAT_default_parent_object          nvarchar(517);


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAT_is_active
    ==============================================================================*/

    SET @PAT_default_expected_name = N'DF_PAT_is_active';

    SET @PAT_default_actual_name = NULL;
    SET @PAT_default_actual_definition = NULL;
    SET @PAT_default_normalized_definition = NULL;
    SET @PAT_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH PAT_is_active
    ----------------------------------------------------------------------*/

    SELECT
        @PAT_default_actual_name = dc.name,
        @PAT_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc

    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

    WHERE dc.parent_object_id =
            OBJECT_ID(N'catalog.ProductAttribute')

    AND c.name = N'PAT_is_active';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON PAT_is_active
    ----------------------------------------------------------------------*/

    IF @PAT_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'catalog.DF_PAT_is_active', N'D') IS NOT NULL
        BEGIN

            SELECT
                @PAT_default_parent_object =
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
                    N'catalog.DF_PAT_is_active',
                    N'D'
                );


            PRINT N'        [!] Default constraint name conflict : DF_PAT_is_active';
            PRINT N'            Expected Table                  : catalog.ProductAttribute';
            PRINT N'            Expected Column                 : PAT_is_active';
            PRINT N'            Existing Parent                 : '
                + COALESCE
                (
                    @PAT_default_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50220,
                N'Default constraint DF_PAT_is_active already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductAttribute
            ADD CONSTRAINT DF_PAT_is_active
            DEFAULT (1) FOR PAT_is_active;


        PRINT N'        [+] Default constraint added        : DF_PAT_is_active';
        PRINT N'            Column                          : PAT_is_active';
        PRINT N'            Definition                      : DEFAULT (1)';

    END

    ELSE
    BEGIN

        SET @PAT_default_normalized_definition =
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
                                @PAT_default_actual_definition,
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


        IF @PAT_default_actual_name =
                @PAT_default_expected_name

        AND TRY_CONVERT
            (
                int,
                @PAT_default_normalized_definition
            ) = 1
        BEGIN

            PRINT N'        [•] Default constraint validated    : DF_PAT_is_active';
            PRINT N'            Column                          : PAT_is_active';
            PRINT N'            Definition                      : DEFAULT (1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch     : PAT_is_active';
            PRINT N'            Expected Name                   : DF_PAT_is_active';
            PRINT N'            Actual Name                     : '
                + COALESCE
                (
                    @PAT_default_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition             : DEFAULT (1)';
            PRINT N'            Actual Definition               : '
                + COALESCE
                (
                    @PAT_default_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAT_created_at
    ==============================================================================*/

    SET @PAT_default_expected_name = N'DF_PAT_created_at';

    SET @PAT_default_actual_name = NULL;
    SET @PAT_default_actual_definition = NULL;
    SET @PAT_default_normalized_definition = NULL;
    SET @PAT_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH PAT_created_at
    ----------------------------------------------------------------------*/

    SELECT
        @PAT_default_actual_name = dc.name,
        @PAT_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc

    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

    WHERE dc.parent_object_id =
            OBJECT_ID(N'catalog.ProductAttribute')

    AND c.name = N'PAT_created_at';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON PAT_created_at
    ----------------------------------------------------------------------*/

    IF @PAT_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'catalog.DF_PAT_created_at', N'D') IS NOT NULL
        BEGIN

            SELECT
                @PAT_default_parent_object =
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
                    N'catalog.DF_PAT_created_at',
                    N'D'
                );


            PRINT N'        [!] Default constraint name conflict : DF_PAT_created_at';
            PRINT N'            Expected Table                  : catalog.ProductAttribute';
            PRINT N'            Expected Column                 : PAT_created_at';
            PRINT N'            Existing Parent                 : '
                + COALESCE
                (
                    @PAT_default_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50221,
                N'Default constraint DF_PAT_created_at already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductAttribute
            ADD CONSTRAINT DF_PAT_created_at
            DEFAULT (SYSDATETIME()) FOR PAT_created_at;


        PRINT N'        [+] Default constraint added        : DF_PAT_created_at';
        PRINT N'            Column                          : PAT_created_at';
        PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

    END

    ELSE
    BEGIN

        SET @PAT_default_normalized_definition =
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
                                @PAT_default_actual_definition,
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


        IF @PAT_default_actual_name =
                @PAT_default_expected_name

        AND @PAT_default_normalized_definition =
                N'sysdatetime'
        BEGIN

            PRINT N'        [•] Default constraint validated    : DF_PAT_created_at';
            PRINT N'            Column                          : PAT_created_at';
            PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch     : PAT_created_at';
            PRINT N'            Expected Name                   : DF_PAT_created_at';
            PRINT N'            Actual Name                     : '
                + COALESCE
                (
                    @PAT_default_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition             : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition               : '
                + COALESCE
                (
                    @PAT_default_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAT_updated_at
    ==============================================================================*/

    SET @PAT_default_expected_name = N'DF_PAT_updated_at';

    SET @PAT_default_actual_name = NULL;
    SET @PAT_default_actual_definition = NULL;
    SET @PAT_default_normalized_definition = NULL;
    SET @PAT_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH PAT_updated_at
    ----------------------------------------------------------------------*/

    SELECT
        @PAT_default_actual_name = dc.name,
        @PAT_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc

    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

    WHERE dc.parent_object_id =
            OBJECT_ID(N'catalog.ProductAttribute')

    AND c.name = N'PAT_updated_at';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON PAT_updated_at
    ----------------------------------------------------------------------*/

    IF @PAT_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'catalog.DF_PAT_updated_at', N'D') IS NOT NULL
        BEGIN

            SELECT
                @PAT_default_parent_object =
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
                    N'catalog.DF_PAT_updated_at',
                    N'D'
                );


            PRINT N'        [!] Default constraint name conflict : DF_PAT_updated_at';
            PRINT N'            Expected Table                  : catalog.ProductAttribute';
            PRINT N'            Expected Column                 : PAT_updated_at';
            PRINT N'            Existing Parent                 : '
                + COALESCE
                (
                    @PAT_default_parent_object,
                    N'<UNKNOWN>'
                );

            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50222,
                N'Default constraint DF_PAT_updated_at already exists on another object.',
                1;

        END;


        ALTER TABLE catalog.ProductAttribute
            ADD CONSTRAINT DF_PAT_updated_at
            DEFAULT (SYSDATETIME()) FOR PAT_updated_at;


        PRINT N'        [+] Default constraint added        : DF_PAT_updated_at';
        PRINT N'            Column                          : PAT_updated_at';
        PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

    END

    ELSE
    BEGIN

        SET @PAT_default_normalized_definition =
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
                                @PAT_default_actual_definition,
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


        IF @PAT_default_actual_name =
                @PAT_default_expected_name

        AND @PAT_default_normalized_definition =
                N'sysdatetime'
        BEGIN

            PRINT N'        [•] Default constraint validated    : DF_PAT_updated_at';
            PRINT N'            Column                          : PAT_updated_at';
            PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch     : PAT_updated_at';
            PRINT N'            Expected Name                   : DF_PAT_updated_at';
            PRINT N'            Actual Name                     : '
                + COALESCE
                (
                    @PAT_default_actual_name,
                    N'<NULL>'
                );

            PRINT N'            Expected Definition             : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition               : '
                + COALESCE
                (
                    @PAT_default_actual_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';