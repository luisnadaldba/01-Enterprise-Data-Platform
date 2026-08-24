    PRINT N'';
    PRINT N'    ● inventory.InventoryMovement';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVMV_movement_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_movement_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryMovement
            ADD CONSTRAINT DF_INVMV_movement_at
            DEFAULT (SYSDATETIME()) FOR INVMV_movement_at;

        PRINT N'        [+] Default constraint added      : DF_INVMV_movement_at';
        PRINT N'            Column                        : INVMV_movement_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVMV_movement_at_constraint_name sysname,
            @INVMV_movement_at_definition      nvarchar(4000);


        SELECT
            @INVMV_movement_at_constraint_name = dc.name,
            @INVMV_movement_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_movement_at';


        IF @INVMV_movement_at_constraint_name = N'DF_INVMV_movement_at'
        AND UPPER(REPLACE(REPLACE(@INVMV_movement_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVMV_movement_at';
            PRINT N'            Column                        : INVMV_movement_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVMV_movement_at';
            PRINT N'            Expected Name                 : DF_INVMV_movement_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVMV_movement_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVMV_movement_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVMV_movement_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVMV_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_created_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryMovement
            ADD CONSTRAINT DF_INVMV_created_at
            DEFAULT (SYSDATETIME()) FOR INVMV_created_at;

        PRINT N'        [+] Default constraint added      : DF_INVMV_created_at';
        PRINT N'            Column                        : INVMV_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVMV_created_at_constraint_name sysname,
            @INVMV_created_at_definition      nvarchar(4000);


        SELECT
            @INVMV_created_at_constraint_name = dc.name,
            @INVMV_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_created_at';


        IF @INVMV_created_at_constraint_name = N'DF_INVMV_created_at'
        AND UPPER(REPLACE(REPLACE(@INVMV_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVMV_created_at';
            PRINT N'            Column                        : INVMV_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVMV_created_at';
            PRINT N'            Expected Name                 : DF_INVMV_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVMV_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVMV_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVMV_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVMV_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_updated_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryMovement
            ADD CONSTRAINT DF_INVMV_updated_at
            DEFAULT (SYSDATETIME()) FOR INVMV_updated_at;

        PRINT N'        [+] Default constraint added      : DF_INVMV_updated_at';
        PRINT N'            Column                        : INVMV_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVMV_updated_at_constraint_name sysname,
            @INVMV_updated_at_definition      nvarchar(4000);


        SELECT
            @INVMV_updated_at_constraint_name = dc.name,
            @INVMV_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND c.name = N'INVMV_updated_at';


        IF @INVMV_updated_at_constraint_name = N'DF_INVMV_updated_at'
        AND UPPER(REPLACE(REPLACE(@INVMV_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVMV_updated_at';
            PRINT N'            Column                        : INVMV_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVMV_updated_at';
            PRINT N'            Expected Name                 : DF_INVMV_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVMV_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVMV_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVMV_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';