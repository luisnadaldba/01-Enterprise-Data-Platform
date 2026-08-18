    PRINT N'    inventory.InventoryReservation';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVRE_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_created_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryReservation
            ADD CONSTRAINT DF_INVRE_created_at
            DEFAULT (SYSDATETIME()) FOR INVRE_created_at;

        PRINT N'        [+] Default constraint added      : DF_INVRE_created_at';
        PRINT N'            Column                        : INVRE_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVRE_created_at_constraint_name sysname,
            @INVRE_created_at_definition      nvarchar(4000);


        SELECT
            @INVRE_created_at_constraint_name = dc.name,
            @INVRE_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_created_at';


        IF @INVRE_created_at_constraint_name = N'DF_INVRE_created_at'
        AND UPPER(REPLACE(REPLACE(@INVRE_created_at_definition, N'(', N''), N')', N''))
                = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVRE_created_at';
            PRINT N'            Column                        : INVRE_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVRE_created_at';
            PRINT N'            Expected Name                 : DF_INVRE_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVRE_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVRE_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVRE_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVRE_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_updated_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryReservation
            ADD CONSTRAINT DF_INVRE_updated_at
            DEFAULT (SYSDATETIME()) FOR INVRE_updated_at;

        PRINT N'        [+] Default constraint added      : DF_INVRE_updated_at';
        PRINT N'            Column                        : INVRE_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVRE_updated_at_constraint_name sysname,
            @INVRE_updated_at_definition      nvarchar(4000);


        SELECT
            @INVRE_updated_at_constraint_name = dc.name,
            @INVRE_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND c.name = N'INVRE_updated_at';


        IF @INVRE_updated_at_constraint_name = N'DF_INVRE_updated_at'
        AND UPPER(REPLACE(REPLACE(@INVRE_updated_at_definition, N'(', N''), N')', N''))
                = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVRE_updated_at';
            PRINT N'            Column                        : INVRE_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVRE_updated_at';
            PRINT N'            Expected Name                 : DF_INVRE_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVRE_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVRE_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVRE_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';