    PRINT N'';
    PRINT N'    ● payment.Payment';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAY_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_created_at'
    )
    BEGIN

        ALTER TABLE payment.Payment
            ADD CONSTRAINT DF_PAY_created_at
            DEFAULT (SYSDATETIME()) FOR PAY_created_at;

        PRINT N'        [+] Default constraint added      : DF_PAY_created_at';
        PRINT N'            Column                        : PAY_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PAY_created_at_constraint_name sysname,
            @PAY_created_at_definition      nvarchar(4000);


        SELECT
            @PAY_created_at_constraint_name = dc.name,
            @PAY_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_created_at';


        IF @PAY_created_at_constraint_name = N'DF_PAY_created_at'
        AND UPPER(REPLACE(REPLACE(@PAY_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PAY_created_at';
            PRINT N'            Column                        : PAY_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PAY_created_at';
            PRINT N'            Expected Name                 : DF_PAY_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PAY_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PAY_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PAY_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAY_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_updated_at'
    )
    BEGIN

        ALTER TABLE payment.Payment
            ADD CONSTRAINT DF_PAY_updated_at
            DEFAULT (SYSDATETIME()) FOR PAY_updated_at;

        PRINT N'        [+] Default constraint added      : DF_PAY_updated_at';
        PRINT N'            Column                        : PAY_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PAY_updated_at_constraint_name sysname,
            @PAY_updated_at_definition      nvarchar(4000);


        SELECT
            @PAY_updated_at_constraint_name = dc.name,
            @PAY_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.Payment')
        AND c.name = N'PAY_updated_at';


        IF @PAY_updated_at_constraint_name = N'DF_PAY_updated_at'
        AND UPPER(REPLACE(REPLACE(@PAY_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PAY_updated_at';
            PRINT N'            Column                        : PAY_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PAY_updated_at';
            PRINT N'            Expected Name                 : DF_PAY_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PAY_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PAY_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PAY_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';