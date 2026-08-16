    PRINT N'    customer.Customer';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CST_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.Customer')
        AND c.name = N'CST_created_at'
    )
    BEGIN

        ALTER TABLE customer.Customer
            ADD CONSTRAINT DF_CST_created_at
            DEFAULT (SYSDATETIME()) FOR CST_created_at;

        PRINT N'        [+] Default constraint added      : DF_CST_created_at';
        PRINT N'            Column                        : CST_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CST_created_at_constraint_name sysname,
            @CST_created_at_definition      nvarchar(4000);


        SELECT
            @CST_created_at_constraint_name = dc.name,
            @CST_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.Customer')
        AND c.name = N'CST_created_at';


        IF @CST_created_at_constraint_name = N'DF_CST_created_at'
        AND UPPER(REPLACE(REPLACE(@CST_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CST_created_at';
            PRINT N'            Column                        : CST_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CST_created_at';
            PRINT N'            Expected Name                 : DF_CST_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CST_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CST_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CST_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CST_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.Customer')
        AND c.name = N'CST_updated_at'
    )
    BEGIN

        ALTER TABLE customer.Customer
            ADD CONSTRAINT DF_CST_updated_at
            DEFAULT (SYSDATETIME()) FOR CST_updated_at;

        PRINT N'        [+] Default constraint added      : DF_CST_updated_at';
        PRINT N'            Column                        : CST_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CST_updated_at_constraint_name sysname,
            @CST_updated_at_definition      nvarchar(4000);


        SELECT
            @CST_updated_at_constraint_name = dc.name,
            @CST_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.Customer')
        AND c.name = N'CST_updated_at';


        IF @CST_updated_at_constraint_name = N'DF_CST_updated_at'
        AND UPPER(REPLACE(REPLACE(@CST_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CST_updated_at';
            PRINT N'            Column                        : CST_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CST_updated_at';
            PRINT N'            Expected Name                 : DF_CST_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CST_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CST_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CST_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';