    PRINT N'';
    PRINT N'    ● sales.TransactionChannel';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINTS
    ==============================================================================*/

    DECLARE @TRNCH_DEFAULT_expected_name          sysname;
    DECLARE @TRNCH_DEFAULT_actual_name            sysname;
    DECLARE @TRNCH_DEFAULT_actual_definition      nvarchar(4000);
    DECLARE @TRNCH_DEFAULT_normalized_definition  nvarchar(4000);
    DECLARE @TRNCH_DEFAULT_parent_object          nvarchar(517);


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRNCH_is_active
    ==============================================================================*/

    SET @TRNCH_DEFAULT_expected_name = N'DF_TRNCH_is_active';

    SET @TRNCH_DEFAULT_actual_name = NULL;
    SET @TRNCH_DEFAULT_actual_definition = NULL;
    SET @TRNCH_DEFAULT_normalized_definition = NULL;
    SET @TRNCH_DEFAULT_parent_object = NULL;


    SELECT
        @TRNCH_DEFAULT_actual_name = dc.name,
        @TRNCH_DEFAULT_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.TransactionChannel')
    AND c.name = N'TRNCH_is_active';


    IF @TRNCH_DEFAULT_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.DF_TRNCH_is_active', N'D') IS NOT NULL
        BEGIN

            SELECT
                @TRNCH_DEFAULT_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRNCH_is_active', N'D');


            PRINT N'        [!] Default constraint name conflict : DF_TRNCH_is_active';
            PRINT N'            Expected Table                : sales.TransactionChannel';
            PRINT N'            Expected Column               : TRNCH_is_active';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRNCH_DEFAULT_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50087,
                N'Default constraint DF_TRNCH_is_active already exists on another object.',
                1;

        END;


        ALTER TABLE sales.TransactionChannel
            ADD CONSTRAINT DF_TRNCH_is_active
            DEFAULT (1) FOR TRNCH_is_active;


        PRINT N'        [+] Default constraint added      : DF_TRNCH_is_active';
        PRINT N'            Column                        : TRNCH_is_active';
        PRINT N'            Definition                    : DEFAULT (1)';

    END

    ELSE
    BEGIN

        SET @TRNCH_DEFAULT_normalized_definition =
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
                                @TRNCH_DEFAULT_actual_definition,
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


        IF @TRNCH_DEFAULT_actual_name = @TRNCH_DEFAULT_expected_name
        AND TRY_CONVERT(int, @TRNCH_DEFAULT_normalized_definition) = 1
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_TRNCH_is_active';
            PRINT N'            Column                        : TRNCH_is_active';
            PRINT N'            Definition                    : DEFAULT (1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : TRNCH_is_active';
            PRINT N'            Expected Name                 : DF_TRNCH_is_active';
            PRINT N'            Actual Name                   : '
                + COALESCE(@TRNCH_DEFAULT_actual_name, N'<NULL>');
            PRINT N'            Expected Definition           : DEFAULT (1)';
            PRINT N'            Actual Definition             : '
                + COALESCE(@TRNCH_DEFAULT_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRNCH_created_at
    ==============================================================================*/

    SET @TRNCH_DEFAULT_expected_name = N'DF_TRNCH_created_at';

    SET @TRNCH_DEFAULT_actual_name = NULL;
    SET @TRNCH_DEFAULT_actual_definition = NULL;
    SET @TRNCH_DEFAULT_normalized_definition = NULL;
    SET @TRNCH_DEFAULT_parent_object = NULL;


    SELECT
        @TRNCH_DEFAULT_actual_name = dc.name,
        @TRNCH_DEFAULT_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.TransactionChannel')
    AND c.name = N'TRNCH_created_at';


    IF @TRNCH_DEFAULT_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.DF_TRNCH_created_at', N'D') IS NOT NULL
        BEGIN

            SELECT
                @TRNCH_DEFAULT_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRNCH_created_at', N'D');


            PRINT N'        [!] Default constraint name conflict : DF_TRNCH_created_at';
            PRINT N'            Expected Table                : sales.TransactionChannel';
            PRINT N'            Expected Column               : TRNCH_created_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRNCH_DEFAULT_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50088,
                N'Default constraint DF_TRNCH_created_at already exists on another object.',
                1;

        END;


        ALTER TABLE sales.TransactionChannel
            ADD CONSTRAINT DF_TRNCH_created_at
            DEFAULT (SYSDATETIME()) FOR TRNCH_created_at;


        PRINT N'        [+] Default constraint added      : DF_TRNCH_created_at';
        PRINT N'            Column                        : TRNCH_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END

    ELSE
    BEGIN

        SET @TRNCH_DEFAULT_normalized_definition =
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
                                @TRNCH_DEFAULT_actual_definition,
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


        IF @TRNCH_DEFAULT_actual_name = @TRNCH_DEFAULT_expected_name
        AND @TRNCH_DEFAULT_normalized_definition = N'sysdatetime'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_TRNCH_created_at';
            PRINT N'            Column                        : TRNCH_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : TRNCH_created_at';
            PRINT N'            Expected Name                 : DF_TRNCH_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@TRNCH_DEFAULT_actual_name, N'<NULL>');
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : '
                + COALESCE(@TRNCH_DEFAULT_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_TRNCH_updated_at
    ==============================================================================*/

    SET @TRNCH_DEFAULT_expected_name = N'DF_TRNCH_updated_at';

    SET @TRNCH_DEFAULT_actual_name = NULL;
    SET @TRNCH_DEFAULT_actual_definition = NULL;
    SET @TRNCH_DEFAULT_normalized_definition = NULL;
    SET @TRNCH_DEFAULT_parent_object = NULL;


    SELECT
        @TRNCH_DEFAULT_actual_name = dc.name,
        @TRNCH_DEFAULT_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'sales.TransactionChannel')
    AND c.name = N'TRNCH_updated_at';


    IF @TRNCH_DEFAULT_actual_name IS NULL
    BEGIN

        IF OBJECT_ID(N'sales.DF_TRNCH_updated_at', N'D') IS NOT NULL
        BEGIN

            SELECT
                @TRNCH_DEFAULT_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'sales.DF_TRNCH_updated_at', N'D');


            PRINT N'        [!] Default constraint name conflict : DF_TRNCH_updated_at';
            PRINT N'            Expected Table                : sales.TransactionChannel';
            PRINT N'            Expected Column               : TRNCH_updated_at';
            PRINT N'            Existing Parent               : '
                + COALESCE(@TRNCH_DEFAULT_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50089,
                N'Default constraint DF_TRNCH_updated_at already exists on another object.',
                1;

        END;


        ALTER TABLE sales.TransactionChannel
            ADD CONSTRAINT DF_TRNCH_updated_at
            DEFAULT (SYSDATETIME()) FOR TRNCH_updated_at;


        PRINT N'        [+] Default constraint added      : DF_TRNCH_updated_at';
        PRINT N'            Column                        : TRNCH_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END

    ELSE
    BEGIN

        SET @TRNCH_DEFAULT_normalized_definition =
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
                                @TRNCH_DEFAULT_actual_definition,
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


        IF @TRNCH_DEFAULT_actual_name = @TRNCH_DEFAULT_expected_name
        AND @TRNCH_DEFAULT_normalized_definition = N'sysdatetime'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_TRNCH_updated_at';
            PRINT N'            Column                        : TRNCH_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : TRNCH_updated_at';
            PRINT N'            Expected Name                 : DF_TRNCH_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@TRNCH_DEFAULT_actual_name, N'<NULL>');
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : '
                + COALESCE(@TRNCH_DEFAULT_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';