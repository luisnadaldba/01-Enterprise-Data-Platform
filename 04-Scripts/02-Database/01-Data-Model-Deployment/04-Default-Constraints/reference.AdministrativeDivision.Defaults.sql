    PRINT N'';
    PRINT N'    ● reference.AdministrativeDivision';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_ADV_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'reference.AdministrativeDivision')
        AND c.name = N'ADV_created_at'
    )
    BEGIN

        ALTER TABLE reference.AdministrativeDivision
            ADD CONSTRAINT DF_ADV_created_at
            DEFAULT (SYSDATETIME()) FOR ADV_created_at;

        PRINT N'        [+] Default constraint added      : DF_ADV_created_at';
        PRINT N'            Column                        : ADV_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @ADV_created_at_constraint_name sysname,
            @ADV_created_at_definition      nvarchar(4000);


        SELECT
            @ADV_created_at_constraint_name = dc.name,
            @ADV_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'reference.AdministrativeDivision')
        AND c.name = N'ADV_created_at';


        IF @ADV_created_at_constraint_name = N'DF_ADV_created_at'
        AND UPPER(REPLACE(REPLACE(@ADV_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_ADV_created_at';
            PRINT N'            Column                        : ADV_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_ADV_created_at';
            PRINT N'            Expected Name                 : DF_ADV_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@ADV_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : ADV_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@ADV_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_ADV_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'reference.AdministrativeDivision')
        AND c.name = N'ADV_updated_at'
    )
    BEGIN

        ALTER TABLE reference.AdministrativeDivision
            ADD CONSTRAINT DF_ADV_updated_at
            DEFAULT (SYSDATETIME()) FOR ADV_updated_at;

        PRINT N'        [+] Default constraint added      : DF_ADV_updated_at';
        PRINT N'            Column                        : ADV_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @ADV_updated_at_constraint_name sysname,
            @ADV_updated_at_definition      nvarchar(4000);


        SELECT
            @ADV_updated_at_constraint_name = dc.name,
            @ADV_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'reference.AdministrativeDivision')
        AND c.name = N'ADV_updated_at';


        IF @ADV_updated_at_constraint_name = N'DF_ADV_updated_at'
        AND UPPER(REPLACE(REPLACE(@ADV_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_ADV_updated_at';
            PRINT N'            Column                        : ADV_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_ADV_updated_at';
            PRINT N'            Expected Name                 : DF_ADV_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@ADV_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : ADV_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@ADV_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';