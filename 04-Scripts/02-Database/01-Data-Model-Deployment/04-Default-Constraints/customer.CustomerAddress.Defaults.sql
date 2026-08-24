    PRINT N'';
    PRINT N'    ● customer.CustomerAddress';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CSTAD_is_primary
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerAddress')
        AND c.name = N'CSTAD_is_primary'
    )
    BEGIN

        ALTER TABLE customer.CustomerAddress
            ADD CONSTRAINT DF_CSTAD_is_primary
            DEFAULT (0) FOR CSTAD_is_primary;

        PRINT N'        [+] Default constraint added      : DF_CSTAD_is_primary';
        PRINT N'            Column                        : CSTAD_is_primary';
        PRINT N'            Definition                    : DEFAULT (0)';

    END
    ELSE
    BEGIN

        DECLARE
            @CSTAD_is_primary_constraint_name sysname,
            @CSTAD_is_primary_definition      nvarchar(4000);


        SELECT
            @CSTAD_is_primary_constraint_name = dc.name,
            @CSTAD_is_primary_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerAddress')
        AND c.name = N'CSTAD_is_primary';


        IF @CSTAD_is_primary_constraint_name = N'DF_CSTAD_is_primary'
        AND REPLACE(REPLACE(@CSTAD_is_primary_definition, N'(', N''), N')', N'') = N'0'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CSTAD_is_primary';
            PRINT N'            Column                        : CSTAD_is_primary';
            PRINT N'            Definition                    : DEFAULT (0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CSTAD_is_primary';
            PRINT N'            Expected Name                 : DF_CSTAD_is_primary';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CSTAD_is_primary_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CSTAD_is_primary';
            PRINT N'            Expected Definition           : DEFAULT (0)';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CSTAD_is_primary_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CSTAD_is_active
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerAddress')
        AND c.name = N'CSTAD_is_active'
    )
    BEGIN

        ALTER TABLE customer.CustomerAddress
            ADD CONSTRAINT DF_CSTAD_is_active
            DEFAULT (1) FOR CSTAD_is_active;

        PRINT N'        [+] Default constraint added      : DF_CSTAD_is_active';
        PRINT N'            Column                        : CSTAD_is_active';
        PRINT N'            Definition                    : DEFAULT (1)';

    END
    ELSE
    BEGIN

        DECLARE
            @CSTAD_is_active_constraint_name sysname,
            @CSTAD_is_active_definition      nvarchar(4000);


        SELECT
            @CSTAD_is_active_constraint_name = dc.name,
            @CSTAD_is_active_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerAddress')
        AND c.name = N'CSTAD_is_active';


        IF @CSTAD_is_active_constraint_name = N'DF_CSTAD_is_active'
        AND REPLACE(REPLACE(@CSTAD_is_active_definition, N'(', N''), N')', N'') = N'1'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CSTAD_is_active';
            PRINT N'            Column                        : CSTAD_is_active';
            PRINT N'            Definition                    : DEFAULT (1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CSTAD_is_active';
            PRINT N'            Expected Name                 : DF_CSTAD_is_active';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CSTAD_is_active_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CSTAD_is_active';
            PRINT N'            Expected Definition           : DEFAULT (1)';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CSTAD_is_active_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CSTAD_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerAddress')
        AND c.name = N'CSTAD_created_at'
    )
    BEGIN

        ALTER TABLE customer.CustomerAddress
            ADD CONSTRAINT DF_CSTAD_created_at
            DEFAULT (SYSDATETIME()) FOR CSTAD_created_at;

        PRINT N'        [+] Default constraint added      : DF_CSTAD_created_at';
        PRINT N'            Column                        : CSTAD_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CSTAD_created_at_constraint_name sysname,
            @CSTAD_created_at_definition      nvarchar(4000);


        SELECT
            @CSTAD_created_at_constraint_name = dc.name,
            @CSTAD_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerAddress')
        AND c.name = N'CSTAD_created_at';


        IF @CSTAD_created_at_constraint_name = N'DF_CSTAD_created_at'
        AND UPPER(REPLACE(REPLACE(@CSTAD_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CSTAD_created_at';
            PRINT N'            Column                        : CSTAD_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CSTAD_created_at';
            PRINT N'            Expected Name                 : DF_CSTAD_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CSTAD_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CSTAD_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CSTAD_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CSTAD_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerAddress')
        AND c.name = N'CSTAD_updated_at'
    )
    BEGIN

        ALTER TABLE customer.CustomerAddress
            ADD CONSTRAINT DF_CSTAD_updated_at
            DEFAULT (SYSDATETIME()) FOR CSTAD_updated_at;

        PRINT N'        [+] Default constraint added      : DF_CSTAD_updated_at';
        PRINT N'            Column                        : CSTAD_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CSTAD_updated_at_constraint_name sysname,
            @CSTAD_updated_at_definition      nvarchar(4000);


        SELECT
            @CSTAD_updated_at_constraint_name = dc.name,
            @CSTAD_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerAddress')
        AND c.name = N'CSTAD_updated_at';


        IF @CSTAD_updated_at_constraint_name = N'DF_CSTAD_updated_at'
        AND UPPER(REPLACE(REPLACE(@CSTAD_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CSTAD_updated_at';
            PRINT N'            Column                        : CSTAD_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CSTAD_updated_at';
            PRINT N'            Expected Name                 : DF_CSTAD_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CSTAD_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CSTAD_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CSTAD_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';