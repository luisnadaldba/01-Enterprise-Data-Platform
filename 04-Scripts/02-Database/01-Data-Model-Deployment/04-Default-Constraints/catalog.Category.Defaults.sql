    PRINT N'    catalog.Category';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT VARIABLES
    ==============================================================================*/

    DECLARE @CTG_default_expected_name          sysname;
    DECLARE @CTG_default_actual_name            sysname;
    DECLARE @CTG_default_actual_definition      nvarchar(4000);
    DECLARE @CTG_default_normalized_definition  nvarchar(4000);
    DECLARE @CTG_default_parent_object          nvarchar(517);


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CTG_is_active
    ==============================================================================*/

    SET @CTG_default_expected_name = N'DF_CTG_is_active';

    SET @CTG_default_actual_name = NULL;
    SET @CTG_default_actual_definition = NULL;
    SET @CTG_default_normalized_definition = NULL;
    SET @CTG_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH CTG_is_active
    ----------------------------------------------------------------------*/

    SELECT
        @CTG_default_actual_name = dc.name,
        @CTG_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'catalog.Category')
    AND c.name = N'CTG_is_active';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON CTG_is_active
    ----------------------------------------------------------------------*/

    IF @CTG_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'catalog.DF_CTG_is_active', N'D') IS NOT NULL
        BEGIN
            SELECT
                @CTG_default_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'catalog.DF_CTG_is_active', N'D');

            PRINT N'        [!] Default constraint name conflict : DF_CTG_is_active';
            PRINT N'            Expected Table                  : catalog.Category';
            PRINT N'            Expected Column                 : CTG_is_active';
            PRINT N'            Existing Parent                 : '
                + COALESCE(@CTG_default_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50140,
                N'Default constraint DF_CTG_is_active already exists on another object.',
                1;
        END;

        ALTER TABLE catalog.Category
            ADD CONSTRAINT DF_CTG_is_active
            DEFAULT (1) FOR CTG_is_active;

        PRINT N'        [+] Default constraint added        : DF_CTG_is_active';
        PRINT N'            Column                          : CTG_is_active';
        PRINT N'            Definition                      : DEFAULT (1)';
    END

    ELSE
    BEGIN

        SET @CTG_default_normalized_definition =
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
                                @CTG_default_actual_definition,
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

        IF @CTG_default_actual_name = @CTG_default_expected_name
        AND TRY_CONVERT(int, @CTG_default_normalized_definition) = 1
        BEGIN
            PRINT N'        [•] Default constraint validated    : DF_CTG_is_active';
            PRINT N'            Column                          : CTG_is_active';
            PRINT N'            Definition                      : DEFAULT (1)';
        END

        ELSE
        BEGIN
            PRINT N'        [!] Default constraint mismatch     : CTG_is_active';
            PRINT N'            Expected Name                   : DF_CTG_is_active';
            PRINT N'            Actual Name                     : '
                + COALESCE(@CTG_default_actual_name, N'<NULL>');
            PRINT N'            Expected Definition             : DEFAULT (1)';
            PRINT N'            Actual Definition               : '
                + COALESCE(@CTG_default_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CTG_created_at
    ==============================================================================*/

    SET @CTG_default_expected_name = N'DF_CTG_created_at';

    SET @CTG_default_actual_name = NULL;
    SET @CTG_default_actual_definition = NULL;
    SET @CTG_default_normalized_definition = NULL;
    SET @CTG_default_parent_object = NULL;


    SELECT
        @CTG_default_actual_name = dc.name,
        @CTG_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'catalog.Category')
    AND c.name = N'CTG_created_at';


    IF @CTG_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'catalog.DF_CTG_created_at', N'D') IS NOT NULL
        BEGIN
            SELECT
                @CTG_default_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'catalog.DF_CTG_created_at', N'D');

            PRINT N'        [!] Default constraint name conflict : DF_CTG_created_at';
            PRINT N'            Expected Table                  : catalog.Category';
            PRINT N'            Expected Column                 : CTG_created_at';
            PRINT N'            Existing Parent                 : '
                + COALESCE(@CTG_default_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50141,
                N'Default constraint DF_CTG_created_at already exists on another object.',
                1;
        END;

        ALTER TABLE catalog.Category
            ADD CONSTRAINT DF_CTG_created_at
            DEFAULT (SYSDATETIME()) FOR CTG_created_at;

        PRINT N'        [+] Default constraint added        : DF_CTG_created_at';
        PRINT N'            Column                          : CTG_created_at';
        PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';
    END

    ELSE
    BEGIN

        SET @CTG_default_normalized_definition =
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
                                @CTG_default_actual_definition,
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

        IF @CTG_default_actual_name = @CTG_default_expected_name
        AND @CTG_default_normalized_definition = N'sysdatetime'
        BEGIN
            PRINT N'        [•] Default constraint validated    : DF_CTG_created_at';
            PRINT N'            Column                          : CTG_created_at';
            PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';
        END

        ELSE
        BEGIN
            PRINT N'        [!] Default constraint mismatch     : CTG_created_at';
            PRINT N'            Expected Name                   : DF_CTG_created_at';
            PRINT N'            Actual Name                     : '
                + COALESCE(@CTG_default_actual_name, N'<NULL>');
            PRINT N'            Expected Definition             : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition               : '
                + COALESCE(@CTG_default_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CTG_updated_at
    ==============================================================================*/

    SET @CTG_default_expected_name = N'DF_CTG_updated_at';

    SET @CTG_default_actual_name = NULL;
    SET @CTG_default_actual_definition = NULL;
    SET @CTG_default_normalized_definition = NULL;
    SET @CTG_default_parent_object = NULL;


    SELECT
        @CTG_default_actual_name = dc.name,
        @CTG_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'catalog.Category')
    AND c.name = N'CTG_updated_at';


    IF @CTG_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'catalog.DF_CTG_updated_at', N'D') IS NOT NULL
        BEGIN
            SELECT
                @CTG_default_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'catalog.DF_CTG_updated_at', N'D');

            PRINT N'        [!] Default constraint name conflict : DF_CTG_updated_at';
            PRINT N'            Expected Table                  : catalog.Category';
            PRINT N'            Expected Column                 : CTG_updated_at';
            PRINT N'            Existing Parent                 : '
                + COALESCE(@CTG_default_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50142,
                N'Default constraint DF_CTG_updated_at already exists on another object.',
                1;
        END;

        ALTER TABLE catalog.Category
            ADD CONSTRAINT DF_CTG_updated_at
            DEFAULT (SYSDATETIME()) FOR CTG_updated_at;

        PRINT N'        [+] Default constraint added        : DF_CTG_updated_at';
        PRINT N'            Column                          : CTG_updated_at';
        PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';
    END

    ELSE
    BEGIN

        SET @CTG_default_normalized_definition =
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
                                @CTG_default_actual_definition,
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

        IF @CTG_default_actual_name = @CTG_default_expected_name
        AND @CTG_default_normalized_definition = N'sysdatetime'
        BEGIN
            PRINT N'        [•] Default constraint validated    : DF_CTG_updated_at';
            PRINT N'            Column                          : CTG_updated_at';
            PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';
        END

        ELSE
        BEGIN
            PRINT N'        [!] Default constraint mismatch     : CTG_updated_at';
            PRINT N'            Expected Name                   : DF_CTG_updated_at';
            PRINT N'            Actual Name                     : '
                + COALESCE(@CTG_default_actual_name, N'<NULL>');
            PRINT N'            Expected Definition             : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition               : '
                + COALESCE(@CTG_default_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    PRINT N'';