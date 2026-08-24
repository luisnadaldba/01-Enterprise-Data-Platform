    PRINT N'';
    PRINT N'    ● sales.TransactionItem';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRNIT_unit_discount
    ==============================================================================*/

    DECLARE @TRNIT_default_expected_name          sysname;
    DECLARE @TRNIT_default_actual_name            sysname;
    DECLARE @TRNIT_default_actual_definition      nvarchar(4000);
    DECLARE @TRNIT_default_normalized_definition  nvarchar(4000);
    DECLARE @TRNIT_default_parent_object          nvarchar(517);


    /*----------------------------------------------------------------------
        DEFAULT CONSTRAINT: DF_TRNIT_unit_discount
    ----------------------------------------------------------------------*/

    SET @TRNIT_default_expected_name = N'DF_TRNIT_unit_discount';

    SET @TRNIT_default_actual_name = NULL;
    SET @TRNIT_default_actual_definition = NULL;
    SET @TRNIT_default_normalized_definition = NULL;
    SET @TRNIT_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH TRNIT_unit_discount
    ----------------------------------------------------------------------*/

    SELECT
        @TRNIT_default_actual_name = dc.name,
        @TRNIT_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
    AND c.name = N'TRNIT_unit_discount';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON TRNIT_unit_discount
    ----------------------------------------------------------------------*/

    IF @TRNIT_default_actual_name IS NULL
    BEGIN

        /*
            Before creating the expected constraint, validate that its
            deterministic name is not already being used by another object.
        */

        IF OBJECT_ID(N'sales.DF_TRNIT_unit_discount', N'D') IS NOT NULL
        BEGIN

            SELECT
                @TRNIT_default_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRNIT_unit_discount', N'D');


            PRINT N'        [!] Default constraint name conflict : DF_TRNIT_unit_discount';
            PRINT N'            Expected Table                : sales.TransactionItem';
            PRINT N'            Expected Column               : TRNIT_unit_discount';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRNIT_default_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50065,
                N'Default constraint DF_TRNIT_unit_discount already exists on another object.',
                1;

        END;


        ALTER TABLE sales.TransactionItem
            ADD CONSTRAINT DF_TRNIT_unit_discount
            DEFAULT (0.00) FOR TRNIT_unit_discount;


        PRINT N'        [+] Default constraint added      : DF_TRNIT_unit_discount';
        PRINT N'            Column                        : TRNIT_unit_discount';
        PRINT N'            Definition                    : DEFAULT (0.00)';

    END
    ELSE
    BEGIN

        SET @TRNIT_default_normalized_definition =
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
                                @TRNIT_default_actual_definition,
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

        IF @TRNIT_default_actual_name = @TRNIT_default_expected_name
        AND TRY_CONVERT(decimal(19,2), @TRNIT_default_normalized_definition) = 0.00
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_TRNIT_unit_discount';
            PRINT N'            Column                        : TRNIT_unit_discount';
            PRINT N'            Definition                    : DEFAULT (0.00)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : TRNIT_unit_discount';
            PRINT N'            Expected Name                 : DF_TRNIT_unit_discount';
            PRINT N'            Actual Name                   : '
                + COALESCE(@TRNIT_default_actual_name, N'<NULL>');
            PRINT N'            Expected Definition           : DEFAULT (0.00)';
            PRINT N'            Actual Definition             : '
                + COALESCE(@TRNIT_default_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRNIT_created_at
    ==============================================================================*/

    SET @TRNIT_default_expected_name = N'DF_TRNIT_created_at';

    SET @TRNIT_default_actual_name = NULL;
    SET @TRNIT_default_actual_definition = NULL;
    SET @TRNIT_default_normalized_definition = NULL;
    SET @TRNIT_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH TRNIT_created_at
    ----------------------------------------------------------------------*/

    SELECT
        @TRNIT_default_actual_name = dc.name,
        @TRNIT_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
    AND c.name = N'TRNIT_created_at';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON TRNIT_created_at
    ----------------------------------------------------------------------*/

    IF @TRNIT_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.DF_TRNIT_created_at', N'D') IS NOT NULL
        BEGIN

            SELECT
                @TRNIT_default_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRNIT_created_at', N'D');


            PRINT N'        [!] Default constraint name conflict : DF_TRNIT_created_at';
            PRINT N'            Expected Table                : sales.TransactionItem';
            PRINT N'            Expected Column               : TRNIT_created_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRNIT_default_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50066,
                N'Default constraint DF_TRNIT_created_at already exists on another object.',
                1;

        END;


        ALTER TABLE sales.TransactionItem
            ADD CONSTRAINT DF_TRNIT_created_at
            DEFAULT (SYSDATETIME()) FOR TRNIT_created_at;


        PRINT N'        [+] Default constraint added      : DF_TRNIT_created_at';
        PRINT N'            Column                        : TRNIT_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        SET @TRNIT_default_normalized_definition =
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
                                @TRNIT_default_actual_definition,
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


        IF @TRNIT_default_actual_name = @TRNIT_default_expected_name
        AND @TRNIT_default_normalized_definition = N'sysdatetime'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_TRNIT_created_at';
            PRINT N'            Column                        : TRNIT_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : TRNIT_created_at';
            PRINT N'            Expected Name                 : DF_TRNIT_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@TRNIT_default_actual_name, N'<NULL>');
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : '
                + COALESCE(@TRNIT_default_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRNIT_updated_at
    ==============================================================================*/

    SET @TRNIT_default_expected_name = N'DF_TRNIT_updated_at';

    SET @TRNIT_default_actual_name = NULL;
    SET @TRNIT_default_actual_definition = NULL;
    SET @TRNIT_default_normalized_definition = NULL;
    SET @TRNIT_default_parent_object = NULL;


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH TRNIT_updated_at
    ----------------------------------------------------------------------*/

    SELECT
        @TRNIT_default_actual_name = dc.name,
        @TRNIT_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.TransactionItem')
    AND c.name = N'TRNIT_updated_at';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON TRNIT_updated_at
    ----------------------------------------------------------------------*/

    IF @TRNIT_default_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.DF_TRNIT_updated_at', N'D') IS NOT NULL
        BEGIN

            SELECT
                @TRNIT_default_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRNIT_updated_at', N'D');


            PRINT N'        [!] Default constraint name conflict : DF_TRNIT_updated_at';
            PRINT N'            Expected Table                : sales.TransactionItem';
            PRINT N'            Expected Column               : TRNIT_updated_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRNIT_default_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50067,
                N'Default constraint DF_TRNIT_updated_at already exists on another object.',
                1;

        END;


        ALTER TABLE sales.TransactionItem
            ADD CONSTRAINT DF_TRNIT_updated_at
            DEFAULT (SYSDATETIME()) FOR TRNIT_updated_at;


        PRINT N'        [+] Default constraint added      : DF_TRNIT_updated_at';
        PRINT N'            Column                        : TRNIT_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        SET @TRNIT_default_normalized_definition =
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
                                @TRNIT_default_actual_definition,
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


        IF @TRNIT_default_actual_name = @TRNIT_default_expected_name
        AND @TRNIT_default_normalized_definition = N'sysdatetime'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_TRNIT_updated_at';
            PRINT N'            Column                        : TRNIT_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : TRNIT_updated_at';
            PRINT N'            Expected Name                 : DF_TRNIT_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@TRNIT_default_actual_name, N'<NULL>');
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : '
                + COALESCE(@TRNIT_default_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';  