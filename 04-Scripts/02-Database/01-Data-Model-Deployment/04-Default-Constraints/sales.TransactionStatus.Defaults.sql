    PRINT N'    sales.TransactionStatus';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINTS
    ==============================================================================*/

    DECLARE @TRNST_DEFAULT_expected_name          sysname;
    DECLARE @TRNST_DEFAULT_actual_name            sysname;
    DECLARE @TRNST_DEFAULT_actual_definition      nvarchar(4000);
    DECLARE @TRNST_DEFAULT_normalized_definition  nvarchar(4000);
    DECLARE @TRNST_DEFAULT_parent_object          nvarchar(517);


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRNST_is_active
    ==============================================================================*/

    SET @TRNST_DEFAULT_expected_name = N'DF_TRNST_is_active';

    SET @TRNST_DEFAULT_actual_name = NULL;
    SET @TRNST_DEFAULT_actual_definition = NULL;
    SET @TRNST_DEFAULT_normalized_definition = NULL;
    SET @TRNST_DEFAULT_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH TRNST_is_active
    ----------------------------------------------------------------------*/

    SELECT
        @TRNST_DEFAULT_actual_name = dc.name,
        @TRNST_DEFAULT_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.TransactionStatus')
    AND c.name = N'TRNST_is_active';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON TRNST_is_active
    ----------------------------------------------------------------------*/

    IF @TRNST_DEFAULT_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.DF_TRNST_is_active', N'D') IS NOT NULL
        BEGIN

            SELECT
                @TRNST_DEFAULT_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRNST_is_active', N'D');

            PRINT N'        [!] Default constraint name conflict : DF_TRNST_is_active';
            PRINT N'            Expected Table                  : sales.TransactionStatus';
            PRINT N'            Expected Column                 : TRNST_is_active';
            PRINT N'            Existing Parent                 : '
                + COALESCE(@TRNST_DEFAULT_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50071,
                N'Default constraint DF_TRNST_is_active already exists on another object.',
                1;

        END;

        ALTER TABLE sales.TransactionStatus
            ADD CONSTRAINT DF_TRNST_is_active
            DEFAULT (1) FOR TRNST_is_active;

        PRINT N'        [+] Default constraint added        : DF_TRNST_is_active';
        PRINT N'            Column                          : TRNST_is_active';
        PRINT N'            Definition                      : DEFAULT (1)';

    END

    ELSE
    BEGIN

        SET @TRNST_DEFAULT_normalized_definition =
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
                                @TRNST_DEFAULT_actual_definition,
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

        IF @TRNST_DEFAULT_actual_name = @TRNST_DEFAULT_expected_name
        AND TRY_CONVERT(int, @TRNST_DEFAULT_normalized_definition) = 1
        BEGIN

            PRINT N'        [•] Default constraint validated    : DF_TRNST_is_active';
            PRINT N'            Column                          : TRNST_is_active';
            PRINT N'            Definition                      : DEFAULT (1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch     : TRNST_is_active';
            PRINT N'            Expected Name                   : DF_TRNST_is_active';
            PRINT N'            Actual Name                     : '
                + COALESCE(@TRNST_DEFAULT_actual_name, N'<NULL>');
            PRINT N'            Expected Definition             : DEFAULT (1)';
            PRINT N'            Actual Definition               : '
                + COALESCE(@TRNST_DEFAULT_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRNST_created_at
    ==============================================================================*/

    SET @TRNST_DEFAULT_expected_name = N'DF_TRNST_created_at';

    SET @TRNST_DEFAULT_actual_name = NULL;
    SET @TRNST_DEFAULT_actual_definition = NULL;
    SET @TRNST_DEFAULT_normalized_definition = NULL;
    SET @TRNST_DEFAULT_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH TRNST_created_at
    ----------------------------------------------------------------------*/

    SELECT
        @TRNST_DEFAULT_actual_name = dc.name,
        @TRNST_DEFAULT_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.TransactionStatus')
    AND c.name = N'TRNST_created_at';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON TRNST_created_at
    ----------------------------------------------------------------------*/

    IF @TRNST_DEFAULT_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.DF_TRNST_created_at', N'D') IS NOT NULL
        BEGIN

            SELECT
                @TRNST_DEFAULT_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRNST_created_at', N'D');

            PRINT N'        [!] Default constraint name conflict : DF_TRNST_created_at';
            PRINT N'            Expected Table                  : sales.TransactionStatus';
            PRINT N'            Expected Column                 : TRNST_created_at';
            PRINT N'            Existing Parent                 : '
                + COALESCE(@TRNST_DEFAULT_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50072,
                N'Default constraint DF_TRNST_created_at already exists on another object.',
                1;

        END;

        ALTER TABLE sales.TransactionStatus
            ADD CONSTRAINT DF_TRNST_created_at
            DEFAULT (SYSDATETIME()) FOR TRNST_created_at;

        PRINT N'        [+] Default constraint added        : DF_TRNST_created_at';
        PRINT N'            Column                          : TRNST_created_at';
        PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

    END

    ELSE
    BEGIN

        SET @TRNST_DEFAULT_normalized_definition =
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
                                @TRNST_DEFAULT_actual_definition,
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

        IF @TRNST_DEFAULT_actual_name = @TRNST_DEFAULT_expected_name
        AND @TRNST_DEFAULT_normalized_definition = N'sysdatetime'
        BEGIN

            PRINT N'        [•] Default constraint validated    : DF_TRNST_created_at';
            PRINT N'            Column                          : TRNST_created_at';
            PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch     : TRNST_created_at';
            PRINT N'            Expected Name                   : DF_TRNST_created_at';
            PRINT N'            Actual Name                     : '
                + COALESCE(@TRNST_DEFAULT_actual_name, N'<NULL>');
            PRINT N'            Expected Definition             : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition               : '
                + COALESCE(@TRNST_DEFAULT_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRNST_updated_at
    ==============================================================================*/

    SET @TRNST_DEFAULT_expected_name = N'DF_TRNST_updated_at';

    SET @TRNST_DEFAULT_actual_name = NULL;
    SET @TRNST_DEFAULT_actual_definition = NULL;
    SET @TRNST_DEFAULT_normalized_definition = NULL;
    SET @TRNST_DEFAULT_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH TRNST_updated_at
    ----------------------------------------------------------------------*/

    SELECT
        @TRNST_DEFAULT_actual_name = dc.name,
        @TRNST_DEFAULT_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.TransactionStatus')
    AND c.name = N'TRNST_updated_at';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON TRNST_updated_at
    ----------------------------------------------------------------------*/

    IF @TRNST_DEFAULT_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.DF_TRNST_updated_at', N'D') IS NOT NULL
        BEGIN

            SELECT
                @TRNST_DEFAULT_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRNST_updated_at', N'D');

            PRINT N'        [!] Default constraint name conflict : DF_TRNST_updated_at';
            PRINT N'            Expected Table                  : sales.TransactionStatus';
            PRINT N'            Expected Column                 : TRNST_updated_at';
            PRINT N'            Existing Parent                 : '
                + COALESCE(@TRNST_DEFAULT_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50073,
                N'Default constraint DF_TRNST_updated_at already exists on another object.',
                1;

        END;

        ALTER TABLE sales.TransactionStatus
            ADD CONSTRAINT DF_TRNST_updated_at
            DEFAULT (SYSDATETIME()) FOR TRNST_updated_at;

        PRINT N'        [+] Default constraint added        : DF_TRNST_updated_at';
        PRINT N'            Column                          : TRNST_updated_at';
        PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

    END

    ELSE
    BEGIN

        SET @TRNST_DEFAULT_normalized_definition =
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
                                @TRNST_DEFAULT_actual_definition,
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

        IF @TRNST_DEFAULT_actual_name = @TRNST_DEFAULT_expected_name
        AND @TRNST_DEFAULT_normalized_definition = N'sysdatetime'
        BEGIN

            PRINT N'        [•] Default constraint validated    : DF_TRNST_updated_at';
            PRINT N'            Column                          : TRNST_updated_at';
            PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch     : TRNST_updated_at';
            PRINT N'            Expected Name                   : DF_TRNST_updated_at';
            PRINT N'            Actual Name                     : '
                + COALESCE(@TRNST_DEFAULT_actual_name, N'<NULL>');
            PRINT N'            Expected Definition             : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition               : '
                + COALESCE(@TRNST_DEFAULT_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';