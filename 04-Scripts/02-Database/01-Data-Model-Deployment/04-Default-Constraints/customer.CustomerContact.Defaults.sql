    PRINT N'';
    PRINT N'    ● customer.CustomerContact';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CSTCN_is_primary
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_is_primary'
    )
    BEGIN

        ALTER TABLE customer.CustomerContact
            ADD CONSTRAINT DF_CSTCN_is_primary
            DEFAULT (0) FOR CSTCN_is_primary;

        PRINT N'        [+] Default constraint added      : DF_CSTCN_is_primary';
        PRINT N'            Column                        : CSTCN_is_primary';
        PRINT N'            Definition                    : DEFAULT (0)';

    END
    ELSE
    BEGIN

        DECLARE
            @CSTCN_is_primary_constraint_name sysname,
            @CSTCN_is_primary_definition      nvarchar(4000);


        SELECT
            @CSTCN_is_primary_constraint_name = dc.name,
            @CSTCN_is_primary_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_is_primary';


        IF @CSTCN_is_primary_constraint_name = N'DF_CSTCN_is_primary'
        AND REPLACE(REPLACE(@CSTCN_is_primary_definition, N'(', N''), N')', N'') = N'0'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CSTCN_is_primary';
            PRINT N'            Column                        : CSTCN_is_primary';
            PRINT N'            Definition                    : DEFAULT (0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CSTCN_is_primary';
            PRINT N'            Expected Name                 : DF_CSTCN_is_primary';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CSTCN_is_primary_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CSTCN_is_primary';
            PRINT N'            Expected Definition           : DEFAULT (0)';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CSTCN_is_primary_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CSTCN_is_active
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_is_active'
    )
    BEGIN

        ALTER TABLE customer.CustomerContact
            ADD CONSTRAINT DF_CSTCN_is_active
            DEFAULT (1) FOR CSTCN_is_active;

        PRINT N'        [+] Default constraint added      : DF_CSTCN_is_active';
        PRINT N'            Column                        : CSTCN_is_active';
        PRINT N'            Definition                    : DEFAULT (1)';

    END
    ELSE
    BEGIN

        DECLARE
            @CSTCN_is_active_constraint_name sysname,
            @CSTCN_is_active_definition      nvarchar(4000);


        SELECT
            @CSTCN_is_active_constraint_name = dc.name,
            @CSTCN_is_active_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_is_active';


        IF @CSTCN_is_active_constraint_name = N'DF_CSTCN_is_active'
        AND REPLACE(REPLACE(@CSTCN_is_active_definition, N'(', N''), N')', N'') = N'1'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CSTCN_is_active';
            PRINT N'            Column                        : CSTCN_is_active';
            PRINT N'            Definition                    : DEFAULT (1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CSTCN_is_active';
            PRINT N'            Expected Name                 : DF_CSTCN_is_active';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CSTCN_is_active_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CSTCN_is_active';
            PRINT N'            Expected Definition           : DEFAULT (1)';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CSTCN_is_active_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CSTCN_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_created_at'
    )
    BEGIN

        ALTER TABLE customer.CustomerContact
            ADD CONSTRAINT DF_CSTCN_created_at
            DEFAULT (SYSDATETIME()) FOR CSTCN_created_at;

        PRINT N'        [+] Default constraint added      : DF_CSTCN_created_at';
        PRINT N'            Column                        : CSTCN_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CSTCN_created_at_constraint_name sysname,
            @CSTCN_created_at_definition      nvarchar(4000);


        SELECT
            @CSTCN_created_at_constraint_name = dc.name,
            @CSTCN_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_created_at';


        IF @CSTCN_created_at_constraint_name = N'DF_CSTCN_created_at'
        AND UPPER(REPLACE(REPLACE(@CSTCN_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CSTCN_created_at';
            PRINT N'            Column                        : CSTCN_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CSTCN_created_at';
            PRINT N'            Expected Name                 : DF_CSTCN_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CSTCN_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CSTCN_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CSTCN_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CSTCN_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_updated_at'
    )
    BEGIN

        ALTER TABLE customer.CustomerContact
            ADD CONSTRAINT DF_CSTCN_updated_at
            DEFAULT (SYSDATETIME()) FOR CSTCN_updated_at;

        PRINT N'        [+] Default constraint added      : DF_CSTCN_updated_at';
        PRINT N'            Column                        : CSTCN_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CSTCN_updated_at_constraint_name sysname,
            @CSTCN_updated_at_definition      nvarchar(4000);


        SELECT
            @CSTCN_updated_at_constraint_name = dc.name,
            @CSTCN_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerContact')
        AND c.name = N'CSTCN_updated_at';


        IF @CSTCN_updated_at_constraint_name = N'DF_CSTCN_updated_at'
        AND UPPER(REPLACE(REPLACE(@CSTCN_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CSTCN_updated_at';
            PRINT N'            Column                        : CSTCN_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CSTCN_updated_at';
            PRINT N'            Expected Name                 : DF_CSTCN_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CSTCN_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CSTCN_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CSTCN_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';