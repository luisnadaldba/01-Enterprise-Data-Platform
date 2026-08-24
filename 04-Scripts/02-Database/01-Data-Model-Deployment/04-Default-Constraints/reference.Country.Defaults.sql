    PRINT N'';
    PRINT N'    ● reference.Country';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CTR_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'reference.Country')
        AND c.name = N'CTR_created_at'
    )
    BEGIN

        ALTER TABLE reference.Country
            ADD CONSTRAINT DF_CTR_created_at
            DEFAULT (SYSDATETIME()) FOR CTR_created_at;

        PRINT N'        [+] Default constraint added      : DF_CTR_created_at';
        PRINT N'            Column                        : CTR_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CTR_created_at_constraint_name sysname,
            @CTR_created_at_definition      nvarchar(4000);


        SELECT
            @CTR_created_at_constraint_name = dc.name,
            @CTR_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'reference.Country')
        AND c.name = N'CTR_created_at';


        IF @CTR_created_at_constraint_name = N'DF_CTR_created_at'
        AND UPPER(REPLACE(REPLACE(@CTR_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CTR_created_at';
            PRINT N'            Column                        : CTR_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CTR_created_at';
            PRINT N'            Expected Name                 : DF_CTR_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CTR_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CTR_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CTR_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CTR_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'reference.Country')
        AND c.name = N'CTR_updated_at'
    )
    BEGIN

        ALTER TABLE reference.Country
            ADD CONSTRAINT DF_CTR_updated_at
            DEFAULT (SYSDATETIME()) FOR CTR_updated_at;

        PRINT N'        [+] Default constraint added      : DF_CTR_updated_at';
        PRINT N'            Column                        : CTR_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CTR_updated_at_constraint_name sysname,
            @CTR_updated_at_definition      nvarchar(4000);


        SELECT
            @CTR_updated_at_constraint_name = dc.name,
            @CTR_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'reference.Country')
        AND c.name = N'CTR_updated_at';


        IF @CTR_updated_at_constraint_name = N'DF_CTR_updated_at'
        AND UPPER(REPLACE(REPLACE(@CTR_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CTR_updated_at';
            PRINT N'            Column                        : CTR_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CTR_updated_at';
            PRINT N'            Expected Name                 : DF_CTR_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CTR_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CTR_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CTR_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';