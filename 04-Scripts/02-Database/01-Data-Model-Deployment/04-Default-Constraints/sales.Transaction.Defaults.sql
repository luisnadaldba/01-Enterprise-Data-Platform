    PRINT N'    sales.Transaction';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRN_discount_amount
    ==============================================================================*/

    DECLARE @TRN_default_expected_name          sysname;
    DECLARE @TRN_default_actual_name            sysname;
    DECLARE @TRN_default_actual_definition      nvarchar(4000);
    DECLARE @TRN_default_normalized_definition  nvarchar(4000);
    DECLARE @TRN_default_parent_object          nvarchar(517);


    /*----------------------------------------------------------------------
        DEFAULT CONSTRAINT: DF_TRN_discount_amount
    ----------------------------------------------------------------------*/

    SET @TRN_default_expected_name = N'DF_TRN_discount_amount';

    SET @TRN_default_actual_name = NULL;
    SET @TRN_default_actual_definition = NULL;
    SET @TRN_default_normalized_definition = NULL;
    SET @TRN_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH TRN_discount_amount
    ----------------------------------------------------------------------*/

    SELECT
        @TRN_default_actual_name = dc.name,
        @TRN_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.[Transaction]')
    AND c.name = N'TRN_discount_amount';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON TRN_discount_amount
    ----------------------------------------------------------------------*/

    IF @TRN_default_actual_name IS NULL
    BEGIN

        /*
            Before creating the expected constraint, validate that its
            deterministic name is not already being used by another object.
        */

        IF OBJECT_ID(N'sales.DF_TRN_discount_amount', N'D') IS NOT NULL
        BEGIN
            SELECT
                @TRN_default_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRN_discount_amount', N'D');

            PRINT N'        [!] Default constraint name conflict : DF_TRN_discount_amount';
            PRINT N'            Expected Table                  : sales.Transaction';
            PRINT N'            Expected Column                 : TRN_discount_amount';
            PRINT N'            Existing Parent                 : '
                + COALESCE(@TRN_default_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50046,
                N'Default constraint DF_TRN_discount_amount already exists on another object.',
                1;
        END;

        ALTER TABLE sales.[Transaction]
            ADD CONSTRAINT DF_TRN_discount_amount
            DEFAULT (0.00) FOR TRN_discount_amount;

        PRINT N'        [+] Default constraint added        : DF_TRN_discount_amount';
        PRINT N'            Column                          : TRN_discount_amount';
        PRINT N'            Definition                      : DEFAULT (0.00)';
    END

    ELSE
    BEGIN

        SET @TRN_default_normalized_definition =
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
                                @TRN_default_actual_definition,
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


        /*------------------------------------------------------------------
            EXPECTED DEFAULT EXISTS AND MATCHES
        ------------------------------------------------------------------*/

        IF @TRN_default_actual_name = @TRN_default_expected_name
        AND TRY_CONVERT(decimal(19,2), @TRN_default_normalized_definition) = 0.00
        BEGIN
            PRINT N'        [•] Default constraint validated    : DF_TRN_discount_amount';
            PRINT N'            Column                          : TRN_discount_amount';
            PRINT N'            Definition                      : DEFAULT (0.00)';
        END

        ELSE
        BEGIN
            PRINT N'        [!] Default constraint mismatch     : TRN_discount_amount';
            PRINT N'            Expected Name                   : DF_TRN_discount_amount';
            PRINT N'            Actual Name                     : '
                + COALESCE(@TRN_default_actual_name, N'<NULL>');
            PRINT N'            Expected Definition             : DEFAULT (0.00)';
            PRINT N'            Actual Definition               : '
                + COALESCE(@TRN_default_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRN_created_at
    ==============================================================================*/

    SET @TRN_default_expected_name = N'DF_TRN_created_at';

    SET @TRN_default_actual_name = NULL;
    SET @TRN_default_actual_definition = NULL;
    SET @TRN_default_normalized_definition = NULL;
    SET @TRN_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH TRN_created_at
    ----------------------------------------------------------------------*/

    SELECT
        @TRN_default_actual_name = dc.name,
        @TRN_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.[Transaction]')
    AND c.name = N'TRN_created_at';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON TRN_created_at
    ----------------------------------------------------------------------*/

    IF @TRN_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.DF_TRN_created_at', N'D') IS NOT NULL
        BEGIN
            SELECT
                @TRN_default_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRN_created_at', N'D');

            PRINT N'        [!] Default constraint name conflict : DF_TRN_created_at';
            PRINT N'            Expected Table                  : sales.Transaction';
            PRINT N'            Expected Column                 : TRN_created_at';
            PRINT N'            Existing Parent                 : '
                + COALESCE(@TRN_default_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50048,
                N'Default constraint DF_TRN_created_at already exists on another object.',
                1;
        END;

        ALTER TABLE sales.[Transaction]
            ADD CONSTRAINT DF_TRN_created_at
            DEFAULT (SYSDATETIME()) FOR TRN_created_at;

        PRINT N'        [+] Default constraint added        : DF_TRN_created_at';
        PRINT N'            Column                          : TRN_created_at';
        PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';
    END

    ELSE
    BEGIN

        SET @TRN_default_normalized_definition =
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
                                @TRN_default_actual_definition,
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

        IF @TRN_default_actual_name = @TRN_default_expected_name
        AND @TRN_default_normalized_definition = N'sysdatetime'
        BEGIN
            PRINT N'        [•] Default constraint validated    : DF_TRN_created_at';
            PRINT N'            Column                          : TRN_created_at';
            PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';
        END

        ELSE
        BEGIN
            PRINT N'        [!] Default constraint mismatch     : TRN_created_at';
            PRINT N'            Expected Name                   : DF_TRN_created_at';
            PRINT N'            Actual Name                     : '
                + COALESCE(@TRN_default_actual_name, N'<NULL>');
            PRINT N'            Expected Definition             : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition               : '
                + COALESCE(@TRN_default_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRN_updated_at
    ==============================================================================*/

    SET @TRN_default_expected_name = N'DF_TRN_updated_at';

    SET @TRN_default_actual_name = NULL;
    SET @TRN_default_actual_definition = NULL;
    SET @TRN_default_normalized_definition = NULL;
    SET @TRN_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH TRN_updated_at
    ----------------------------------------------------------------------*/

    SELECT
        @TRN_default_actual_name = dc.name,
        @TRN_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.[Transaction]')
    AND c.name = N'TRN_updated_at';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON TRN_updated_at
    ----------------------------------------------------------------------*/

    IF @TRN_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.DF_TRN_updated_at', N'D') IS NOT NULL
        BEGIN
            SELECT
                @TRN_default_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRN_updated_at', N'D');

            PRINT N'        [!] Default constraint name conflict : DF_TRN_updated_at';
            PRINT N'            Expected Table                  : sales.Transaction';
            PRINT N'            Expected Column                 : TRN_updated_at';
            PRINT N'            Existing Parent                 : '
                + COALESCE(@TRN_default_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';

            ;THROW 50049,
                N'Default constraint DF_TRN_updated_at already exists on another object.',
                1;
        END;

        ALTER TABLE sales.[Transaction]
            ADD CONSTRAINT DF_TRN_updated_at
            DEFAULT (SYSDATETIME()) FOR TRN_updated_at;

        PRINT N'        [+] Default constraint added        : DF_TRN_updated_at';
        PRINT N'            Column                          : TRN_updated_at';
        PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';
    END

    ELSE
    BEGIN

        SET @TRN_default_normalized_definition =
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
                                @TRN_default_actual_definition,
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

        IF @TRN_default_actual_name = @TRN_default_expected_name
        AND @TRN_default_normalized_definition = N'sysdatetime'
        BEGIN
            PRINT N'        [•] Default constraint validated    : DF_TRN_updated_at';
            PRINT N'            Column                          : TRN_updated_at';
            PRINT N'            Definition                      : DEFAULT (SYSDATETIME())';
        END

        ELSE
        BEGIN
            PRINT N'        [!] Default constraint mismatch     : TRN_updated_at';
            PRINT N'            Expected Name                   : DF_TRN_updated_at';
            PRINT N'            Actual Name                     : '
                + COALESCE(@TRN_default_actual_name, N'<NULL>');
            PRINT N'            Expected Definition             : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition               : '
                + COALESCE(@TRN_default_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';
        END;
    END;


    PRINT N'';