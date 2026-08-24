    PRINT N'';
    PRINT N'    ● inventory.InventoryMovementNote';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVMN_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovementNote')
        AND c.name = N'INVMN_created_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryMovementNote
            ADD CONSTRAINT DF_INVMN_created_at
            DEFAULT (SYSDATETIME()) FOR INVMN_created_at;

        PRINT N'        [+] Default constraint added      : DF_INVMN_created_at';
        PRINT N'            Column                        : INVMN_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVMN_created_at_constraint_name sysname,
            @INVMN_created_at_definition      nvarchar(4000);


        SELECT
            @INVMN_created_at_constraint_name = dc.name,
            @INVMN_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovementNote')
        AND c.name = N'INVMN_created_at';


        IF @INVMN_created_at_constraint_name = N'DF_INVMN_created_at'
        AND UPPER(REPLACE(REPLACE(@INVMN_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVMN_created_at';
            PRINT N'            Column                        : INVMN_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVMN_created_at';
            PRINT N'            Expected Name                 : DF_INVMN_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVMN_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVMN_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVMN_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVMN_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovementNote')
        AND c.name = N'INVMN_updated_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryMovementNote
            ADD CONSTRAINT DF_INVMN_updated_at
            DEFAULT (SYSDATETIME()) FOR INVMN_updated_at;

        PRINT N'        [+] Default constraint added      : DF_INVMN_updated_at';
        PRINT N'            Column                        : INVMN_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVMN_updated_at_constraint_name sysname,
            @INVMN_updated_at_definition      nvarchar(4000);


        SELECT
            @INVMN_updated_at_constraint_name = dc.name,
            @INVMN_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovementNote')
        AND c.name = N'INVMN_updated_at';


        IF @INVMN_updated_at_constraint_name = N'DF_INVMN_updated_at'
        AND UPPER(REPLACE(REPLACE(@INVMN_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVMN_updated_at';
            PRINT N'            Column                        : INVMN_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVMN_updated_at';
            PRINT N'            Expected Name                 : DF_INVMN_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVMN_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVMN_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVMN_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';