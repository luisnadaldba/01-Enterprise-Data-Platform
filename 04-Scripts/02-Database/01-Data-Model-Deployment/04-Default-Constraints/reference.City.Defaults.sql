    PRINT N'';
    PRINT N'    ● reference.City';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CTY_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'reference.City')
        AND c.name = N'CTY_created_at'
    )
    BEGIN

        ALTER TABLE reference.City
            ADD CONSTRAINT DF_CTY_created_at
            DEFAULT (SYSDATETIME()) FOR CTY_created_at;

        PRINT N'        [+] Default constraint added      : DF_CTY_created_at';
        PRINT N'            Column                        : CTY_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CTY_created_at_constraint_name sysname,
            @CTY_created_at_definition      nvarchar(4000);


        SELECT
            @CTY_created_at_constraint_name = dc.name,
            @CTY_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'reference.City')
        AND c.name = N'CTY_created_at';


        IF @CTY_created_at_constraint_name = N'DF_CTY_created_at'
        AND UPPER(REPLACE(REPLACE(@CTY_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CTY_created_at';
            PRINT N'            Column                        : CTY_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CTY_created_at';
            PRINT N'            Expected Name                 : DF_CTY_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CTY_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CTY_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CTY_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CTY_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'reference.City')
        AND c.name = N'CTY_updated_at'
    )
    BEGIN

        ALTER TABLE reference.City
            ADD CONSTRAINT DF_CTY_updated_at
            DEFAULT (SYSDATETIME()) FOR CTY_updated_at;

        PRINT N'        [+] Default constraint added      : DF_CTY_updated_at';
        PRINT N'            Column                        : CTY_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CTY_updated_at_constraint_name sysname,
            @CTY_updated_at_definition      nvarchar(4000);


        SELECT
            @CTY_updated_at_constraint_name = dc.name,
            @CTY_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'reference.City')
        AND c.name = N'CTY_updated_at';


        IF @CTY_updated_at_constraint_name = N'DF_CTY_updated_at'
        AND UPPER(REPLACE(REPLACE(@CTY_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CTY_updated_at';
            PRINT N'            Column                        : CTY_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CTY_updated_at';
            PRINT N'            Expected Name                 : DF_CTY_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CTY_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CTY_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CTY_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';