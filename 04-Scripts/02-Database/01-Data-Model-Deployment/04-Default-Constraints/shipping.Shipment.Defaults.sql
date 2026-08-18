    PRINT N'    shipping.Shipment';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_SHP_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_created_at'
    )
    BEGIN

        ALTER TABLE shipping.Shipment
            ADD CONSTRAINT DF_SHP_created_at
            DEFAULT (SYSDATETIME()) FOR SHP_created_at;

        PRINT N'        [+] Default constraint added      : DF_SHP_created_at';
        PRINT N'            Column                        : SHP_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @SHP_created_at_constraint_name sysname,
            @SHP_created_at_definition      nvarchar(4000);


        SELECT
            @SHP_created_at_constraint_name = dc.name,
            @SHP_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_created_at';


        IF @SHP_created_at_constraint_name = N'DF_SHP_created_at'
        AND UPPER(REPLACE(REPLACE(@SHP_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_SHP_created_at';
            PRINT N'            Column                        : SHP_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_SHP_created_at';
            PRINT N'            Expected Name                 : DF_SHP_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@SHP_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : SHP_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@SHP_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_SHP_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_updated_at'
    )
    BEGIN

        ALTER TABLE shipping.Shipment
            ADD CONSTRAINT DF_SHP_updated_at
            DEFAULT (SYSDATETIME()) FOR SHP_updated_at;

        PRINT N'        [+] Default constraint added      : DF_SHP_updated_at';
        PRINT N'            Column                        : SHP_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @SHP_updated_at_constraint_name sysname,
            @SHP_updated_at_definition      nvarchar(4000);


        SELECT
            @SHP_updated_at_constraint_name = dc.name,
            @SHP_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'shipping.Shipment')
        AND c.name = N'SHP_updated_at';


        IF @SHP_updated_at_constraint_name = N'DF_SHP_updated_at'
        AND UPPER(REPLACE(REPLACE(@SHP_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_SHP_updated_at';
            PRINT N'            Column                        : SHP_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_SHP_updated_at';
            PRINT N'            Expected Name                 : DF_SHP_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@SHP_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : SHP_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@SHP_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';