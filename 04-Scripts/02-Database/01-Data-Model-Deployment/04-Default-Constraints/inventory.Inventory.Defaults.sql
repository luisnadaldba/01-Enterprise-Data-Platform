    PRINT N'    inventory.Inventory';
    PRINT N'    --------------------------------------------------------------------------';

    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INV_quantity_on_hand
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.Inventory')
        AND c.name = N'INV_quantity_on_hand'
    )
    BEGIN

        ALTER TABLE inventory.Inventory
            ADD CONSTRAINT DF_INV_quantity_on_hand
            DEFAULT (0) FOR INV_quantity_on_hand;

        PRINT N'        [+] Default constraint added      : DF_INV_quantity_on_hand';
        PRINT N'            Column                        : INV_quantity_on_hand';
        PRINT N'            Definition                    : DEFAULT (0)';

    END
    ELSE
    BEGIN

        DECLARE
            @INV_quantity_on_hand_constraint_name sysname,
            @INV_quantity_on_hand_definition      nvarchar(4000);


        SELECT
            @INV_quantity_on_hand_constraint_name = dc.name,
            @INV_quantity_on_hand_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.Inventory')
        AND c.name = N'INV_quantity_on_hand';


        IF @INV_quantity_on_hand_constraint_name = N'DF_INV_quantity_on_hand'
        AND REPLACE(REPLACE(@INV_quantity_on_hand_definition, N'(', N''), N')', N'')
            = N'0'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INV_quantity_on_hand';
            PRINT N'            Column                        : INV_quantity_on_hand';
            PRINT N'            Definition                    : DEFAULT (0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INV_quantity_on_hand';
            PRINT N'            Expected Name                 : DF_INV_quantity_on_hand';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INV_quantity_on_hand_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INV_quantity_on_hand';
            PRINT N'            Expected Definition           : DEFAULT (0)';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INV_quantity_on_hand_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INV_quantity_reserved
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.Inventory')
        AND c.name = N'INV_quantity_reserved'
    )
    BEGIN

        ALTER TABLE inventory.Inventory
            ADD CONSTRAINT DF_INV_quantity_reserved
            DEFAULT (0) FOR INV_quantity_reserved;

        PRINT N'        [+] Default constraint added      : DF_INV_quantity_reserved';
        PRINT N'            Column                        : INV_quantity_reserved';
        PRINT N'            Definition                    : DEFAULT (0)';

    END
    ELSE
    BEGIN

        DECLARE
            @INV_quantity_reserved_constraint_name sysname,
            @INV_quantity_reserved_definition      nvarchar(4000);


        SELECT
            @INV_quantity_reserved_constraint_name = dc.name,
            @INV_quantity_reserved_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.Inventory')
        AND c.name = N'INV_quantity_reserved';


        IF @INV_quantity_reserved_constraint_name = N'DF_INV_quantity_reserved'
        AND REPLACE(REPLACE(@INV_quantity_reserved_definition, N'(', N''), N')', N'')
            = N'0'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INV_quantity_reserved';
            PRINT N'            Column                        : INV_quantity_reserved';
            PRINT N'            Definition                    : DEFAULT (0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INV_quantity_reserved';
            PRINT N'            Expected Name                 : DF_INV_quantity_reserved';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INV_quantity_reserved_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INV_quantity_reserved';
            PRINT N'            Expected Definition           : DEFAULT (0)';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INV_quantity_reserved_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INV_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.Inventory')
        AND c.name = N'INV_created_at'
    )
    BEGIN

        ALTER TABLE inventory.Inventory
            ADD CONSTRAINT DF_INV_created_at
            DEFAULT (SYSDATETIME()) FOR INV_created_at;

        PRINT N'        [+] Default constraint added      : DF_INV_created_at';
        PRINT N'            Column                        : INV_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INV_created_at_constraint_name sysname,
            @INV_created_at_definition      nvarchar(4000);


        SELECT
            @INV_created_at_constraint_name = dc.name,
            @INV_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.Inventory')
        AND c.name = N'INV_created_at';


        IF @INV_created_at_constraint_name = N'DF_INV_created_at'
        AND UPPER(REPLACE(REPLACE(@INV_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INV_created_at';
            PRINT N'            Column                        : INV_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INV_created_at';
            PRINT N'            Expected Name                 : DF_INV_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INV_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INV_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INV_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INV_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.Inventory')
        AND c.name = N'INV_updated_at'
    )
    BEGIN

        ALTER TABLE inventory.Inventory
            ADD CONSTRAINT DF_INV_updated_at
            DEFAULT (SYSDATETIME()) FOR INV_updated_at;

        PRINT N'        [+] Default constraint added      : DF_INV_updated_at';
        PRINT N'            Column                        : INV_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INV_updated_at_constraint_name sysname,
            @INV_updated_at_definition      nvarchar(4000);


        SELECT
            @INV_updated_at_constraint_name = dc.name,
            @INV_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.Inventory')
        AND c.name = N'INV_updated_at';


        IF @INV_updated_at_constraint_name = N'DF_INV_updated_at'
        AND UPPER(REPLACE(REPLACE(@INV_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INV_updated_at';
            PRINT N'            Column                        : INV_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INV_updated_at';
            PRINT N'            Expected Name                 : DF_INV_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INV_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INV_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INV_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';