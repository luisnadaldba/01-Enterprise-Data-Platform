    PRINT N'    shipping.ShipmentStatus';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_SHPST_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND c.name = N'SHPST_created_at'
    )
    BEGIN

        ALTER TABLE shipping.ShipmentStatus
            ADD CONSTRAINT DF_SHPST_created_at
            DEFAULT (SYSDATETIME()) FOR SHPST_created_at;

        PRINT N'        [+] Default constraint added      : DF_SHPST_created_at';
        PRINT N'            Column                        : SHPST_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @SHPST_created_at_constraint_name sysname,
            @SHPST_created_at_definition      nvarchar(4000);


        SELECT
            @SHPST_created_at_constraint_name = dc.name,
            @SHPST_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND c.name = N'SHPST_created_at';


        IF @SHPST_created_at_constraint_name = N'DF_SHPST_created_at'
        AND UPPER(REPLACE(REPLACE(@SHPST_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_SHPST_created_at';
            PRINT N'            Column                        : SHPST_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_SHPST_created_at';
            PRINT N'            Expected Name                 : DF_SHPST_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@SHPST_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : SHPST_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@SHPST_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_SHPST_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND c.name = N'SHPST_updated_at'
    )
    BEGIN

        ALTER TABLE shipping.ShipmentStatus
            ADD CONSTRAINT DF_SHPST_updated_at
            DEFAULT (SYSDATETIME()) FOR SHPST_updated_at;

        PRINT N'        [+] Default constraint added      : DF_SHPST_updated_at';
        PRINT N'            Column                        : SHPST_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @SHPST_updated_at_constraint_name sysname,
            @SHPST_updated_at_definition      nvarchar(4000);


        SELECT
            @SHPST_updated_at_constraint_name = dc.name,
            @SHPST_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND c.name = N'SHPST_updated_at';


        IF @SHPST_updated_at_constraint_name = N'DF_SHPST_updated_at'
        AND UPPER(REPLACE(REPLACE(@SHPST_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_SHPST_updated_at';
            PRINT N'            Column                        : SHPST_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_SHPST_updated_at';
            PRINT N'            Expected Name                 : DF_SHPST_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@SHPST_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : SHPST_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@SHPST_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';