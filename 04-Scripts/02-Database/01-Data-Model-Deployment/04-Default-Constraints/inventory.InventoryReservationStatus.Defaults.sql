    PRINT N'    inventory.InventoryReservationStatus';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVRS_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND c.name = N'INVRS_created_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryReservationStatus
            ADD CONSTRAINT DF_INVRS_created_at
            DEFAULT (SYSDATETIME()) FOR INVRS_created_at;

        PRINT N'        [+] Default constraint added      : DF_INVRS_created_at';
        PRINT N'            Column                        : INVRS_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVRS_created_at_constraint_name sysname,
            @INVRS_created_at_definition      nvarchar(4000);


        SELECT
            @INVRS_created_at_constraint_name = dc.name,
            @INVRS_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND c.name = N'INVRS_created_at';


        IF @INVRS_created_at_constraint_name = N'DF_INVRS_created_at'
        AND UPPER(REPLACE(REPLACE(@INVRS_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVRS_created_at';
            PRINT N'            Column                        : INVRS_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVRS_created_at';
            PRINT N'            Expected Name                 : DF_INVRS_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVRS_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVRS_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVRS_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_INVRS_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND c.name = N'INVRS_updated_at'
    )
    BEGIN

        ALTER TABLE inventory.InventoryReservationStatus
            ADD CONSTRAINT DF_INVRS_updated_at
            DEFAULT (SYSDATETIME()) FOR INVRS_updated_at;

        PRINT N'        [+] Default constraint added      : DF_INVRS_updated_at';
        PRINT N'            Column                        : INVRS_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @INVRS_updated_at_constraint_name sysname,
            @INVRS_updated_at_definition      nvarchar(4000);


        SELECT
            @INVRS_updated_at_constraint_name = dc.name,
            @INVRS_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND c.name = N'INVRS_updated_at';


        IF @INVRS_updated_at_constraint_name = N'DF_INVRS_updated_at'
        AND UPPER(REPLACE(REPLACE(@INVRS_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_INVRS_updated_at';
            PRINT N'            Column                        : INVRS_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_INVRS_updated_at';
            PRINT N'            Expected Name                 : DF_INVRS_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@INVRS_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : INVRS_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@INVRS_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';