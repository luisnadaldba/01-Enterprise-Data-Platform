    PRINT N'    inventory.InventoryMovementReason';
    PRINT N'    --------------------------------------------------------------------------';

    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVMR_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovementReason')
        AND c.name = N'INVMR_created_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryMovementReason
            ADD CONSTRAINT DF_INVMR_created_at
            DEFAULT (SYSDATETIME()) FOR INVMR_created_at;

        PRINT N'        [+] Default constraint added      : DF_INVMR_created_at';
        PRINT N'            Column                        : INVMR_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVMR_created_at_constraint_name sysname,
            @INVMR_created_at_definition      nvarchar(4000);


        SELECT
            @INVMR_created_at_constraint_name = dc.name,
            @INVMR_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovementReason')
        AND c.name = N'INVMR_created_at';


        IF @INVMR_created_at_constraint_name = N'DF_INVMR_created_at'
        AND UPPER(REPLACE(REPLACE(@INVMR_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVMR_created_at';
            PRINT N'            Column                        : INVMR_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVMR_created_at';
            PRINT N'            Expected Name                 : DF_INVMR_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVMR_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVMR_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVMR_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVMR_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovementReason')
        AND c.name = N'INVMR_updated_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryMovementReason
            ADD CONSTRAINT DF_INVMR_updated_at
            DEFAULT (SYSDATETIME()) FOR INVMR_updated_at;

        PRINT N'        [+] Default constraint added      : DF_INVMR_updated_at';
        PRINT N'            Column                        : INVMR_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVMR_updated_at_constraint_name sysname,
            @INVMR_updated_at_definition      nvarchar(4000);


        SELECT
            @INVMR_updated_at_constraint_name = dc.name,
            @INVMR_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryMovementReason')
        AND c.name = N'INVMR_updated_at';


        IF @INVMR_updated_at_constraint_name = N'DF_INVMR_updated_at'
        AND UPPER(REPLACE(REPLACE(@INVMR_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVMR_updated_at';
            PRINT N'            Column                        : INVMR_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVMR_updated_at';
            PRINT N'            Expected Name                 : DF_INVMR_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVMR_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVMR_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVMR_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';