    PRINT N'';
    PRINT N'    ● reference.Address';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_ADR_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'reference.Address')
        AND c.name = N'ADR_created_at'
    )
    BEGIN

        ALTER TABLE reference.Address
            ADD CONSTRAINT DF_ADR_created_at
            DEFAULT (SYSDATETIME()) FOR ADR_created_at;

        PRINT N'        [+] Default constraint added      : DF_ADR_created_at';
        PRINT N'            Column                        : ADR_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @ADR_created_at_constraint_name sysname,
            @ADR_created_at_definition      nvarchar(4000);


        SELECT
            @ADR_created_at_constraint_name = dc.name,
            @ADR_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'reference.Address')
        AND c.name = N'ADR_created_at';


        IF @ADR_created_at_constraint_name = N'DF_ADR_created_at'
        AND UPPER(REPLACE(REPLACE(@ADR_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_ADR_created_at';
            PRINT N'            Column                        : ADR_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_ADR_created_at';
            PRINT N'            Expected Name                 : DF_ADR_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@ADR_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : ADR_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@ADR_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_ADR_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'reference.Address')
        AND c.name = N'ADR_updated_at'
    )
    BEGIN

        ALTER TABLE reference.Address
            ADD CONSTRAINT DF_ADR_updated_at
            DEFAULT (SYSDATETIME()) FOR ADR_updated_at;

        PRINT N'        [+] Default constraint added      : DF_ADR_updated_at';
        PRINT N'            Column                        : ADR_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @ADR_updated_at_constraint_name sysname,
            @ADR_updated_at_definition      nvarchar(4000);


        SELECT
            @ADR_updated_at_constraint_name = dc.name,
            @ADR_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'reference.Address')
        AND c.name = N'ADR_updated_at';


        IF @ADR_updated_at_constraint_name = N'DF_ADR_updated_at'
        AND UPPER(REPLACE(REPLACE(@ADR_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_ADR_updated_at';
            PRINT N'            Column                        : ADR_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_ADR_updated_at';
            PRINT N'            Expected Name                 : DF_ADR_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@ADR_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : ADR_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@ADR_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';