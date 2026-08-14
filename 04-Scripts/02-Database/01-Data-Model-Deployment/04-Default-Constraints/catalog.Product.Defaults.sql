    PRINT N'    catalog.Product';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRD_is_active
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.Product')
        AND c.name = N'PRD_is_active'
    )
    BEGIN

        ALTER TABLE catalog.Product
            ADD CONSTRAINT DF_PRD_is_active
            DEFAULT (1) FOR PRD_is_active;

        PRINT N'        [+] Default constraint added      : DF_PRD_is_active';
        PRINT N'            Column                        : PRD_is_active';
        PRINT N'            Definition                    : DEFAULT (1)';

    END
    ELSE
    BEGIN

        DECLARE
            @PRD_is_active_constraint_name sysname,
            @PRD_is_active_definition      nvarchar(4000);


        SELECT
            @PRD_is_active_constraint_name = dc.name,
            @PRD_is_active_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.Product')
        AND c.name = N'PRD_is_active';


        IF @PRD_is_active_constraint_name = N'DF_PRD_is_active'
        AND REPLACE(REPLACE(@PRD_is_active_definition, N'(', N''), N')', N'') = N'1'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRD_is_active';
            PRINT N'            Column                        : PRD_is_active';
            PRINT N'            Definition                    : DEFAULT (1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRD_is_active';
            PRINT N'            Expected Name                 : DF_PRD_is_active';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PRD_is_active_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PRD_is_active';
            PRINT N'            Expected Definition           : DEFAULT (1)';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PRD_is_active_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRD_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.Product')
        AND c.name = N'PRD_created_at'
    )
    BEGIN

        ALTER TABLE catalog.Product
            ADD CONSTRAINT DF_PRD_created_at
            DEFAULT (SYSDATETIME()) FOR PRD_created_at;

        PRINT N'        [+] Default constraint added      : DF_PRD_created_at';
        PRINT N'            Column                        : PRD_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PRD_created_at_constraint_name sysname,
            @PRD_created_at_definition      nvarchar(4000);


        SELECT
            @PRD_created_at_constraint_name = dc.name,
            @PRD_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.Product')
        AND c.name = N'PRD_created_at';


        IF @PRD_created_at_constraint_name = N'DF_PRD_created_at'
        AND UPPER(REPLACE(REPLACE(@PRD_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRD_created_at';
            PRINT N'            Column                        : PRD_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRD_created_at';
            PRINT N'            Expected Name                 : DF_PRD_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PRD_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PRD_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PRD_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRD_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.Product')
        AND c.name = N'PRD_updated_at'
    )
    BEGIN

        ALTER TABLE catalog.Product
            ADD CONSTRAINT DF_PRD_updated_at
            DEFAULT (SYSDATETIME()) FOR PRD_updated_at;

        PRINT N'        [+] Default constraint added      : DF_PRD_updated_at';
        PRINT N'            Column                        : PRD_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PRD_updated_at_constraint_name sysname,
            @PRD_updated_at_definition      nvarchar(4000);


        SELECT
            @PRD_updated_at_constraint_name = dc.name,
            @PRD_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.Product')
        AND c.name = N'PRD_updated_at';


        IF @PRD_updated_at_constraint_name = N'DF_PRD_updated_at'
        AND UPPER(REPLACE(REPLACE(@PRD_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRD_updated_at';
            PRINT N'            Column                        : PRD_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRD_updated_at';
            PRINT N'            Expected Name                 : DF_PRD_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PRD_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PRD_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PRD_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';