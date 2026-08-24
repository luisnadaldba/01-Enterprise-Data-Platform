    PRINT N'';
    PRINT N'    ● shipping.ShipmentMethod';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_SHPMT_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND c.name = N'SHPMT_created_at'
    )
    BEGIN

        ALTER TABLE shipping.ShipmentMethod
            ADD CONSTRAINT DF_SHPMT_created_at
            DEFAULT (SYSDATETIME()) FOR SHPMT_created_at;

        PRINT N'        [+] Default constraint added      : DF_SHPMT_created_at';
        PRINT N'            Column                        : SHPMT_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @SHPMT_created_at_constraint_name sysname,
            @SHPMT_created_at_definition      nvarchar(4000);


        SELECT
            @SHPMT_created_at_constraint_name = dc.name,
            @SHPMT_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND c.name = N'SHPMT_created_at';


        IF @SHPMT_created_at_constraint_name = N'DF_SHPMT_created_at'
        AND UPPER(REPLACE(REPLACE(@SHPMT_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_SHPMT_created_at';
            PRINT N'            Column                        : SHPMT_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_SHPMT_created_at';
            PRINT N'            Expected Name                 : DF_SHPMT_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@SHPMT_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : SHPMT_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@SHPMT_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_SHPMT_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND c.name = N'SHPMT_updated_at'
    )
    BEGIN

        ALTER TABLE shipping.ShipmentMethod
            ADD CONSTRAINT DF_SHPMT_updated_at
            DEFAULT (SYSDATETIME()) FOR SHPMT_updated_at;

        PRINT N'        [+] Default constraint added      : DF_SHPMT_updated_at';
        PRINT N'            Column                        : SHPMT_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @SHPMT_updated_at_constraint_name sysname,
            @SHPMT_updated_at_definition      nvarchar(4000);


        SELECT
            @SHPMT_updated_at_constraint_name = dc.name,
            @SHPMT_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND c.name = N'SHPMT_updated_at';


        IF @SHPMT_updated_at_constraint_name = N'DF_SHPMT_updated_at'
        AND UPPER(REPLACE(REPLACE(@SHPMT_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_SHPMT_updated_at';
            PRINT N'            Column                        : SHPMT_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_SHPMT_updated_at';
            PRINT N'            Expected Name                 : DF_SHPMT_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@SHPMT_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : SHPMT_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@SHPMT_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';