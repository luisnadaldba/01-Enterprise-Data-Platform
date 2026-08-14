    PRINT N'    catalog.ProductVariant';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRDVA_is_active
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_is_active'
    )
    BEGIN

        ALTER TABLE catalog.ProductVariant
            ADD CONSTRAINT DF_PRDVA_is_active
            DEFAULT (1) FOR PRDVA_is_active;

        PRINT N'        [+] Default constraint added      : DF_PRDVA_is_active';
        PRINT N'            Column                        : PRDVA_is_active';
        PRINT N'            Definition                    : DEFAULT (1)';

    END
    ELSE
    BEGIN

        DECLARE
            @PRDVA_is_active_constraint_name sysname,
            @PRDVA_is_active_definition      nvarchar(4000);


        SELECT
            @PRDVA_is_active_constraint_name = dc.name,
            @PRDVA_is_active_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_is_active';


        IF @PRDVA_is_active_constraint_name = N'DF_PRDVA_is_active'
        AND REPLACE(REPLACE(@PRDVA_is_active_definition, N'(', N''), N')', N'') = N'1'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRDVA_is_active';
            PRINT N'            Column                        : PRDVA_is_active';
            PRINT N'            Definition                    : DEFAULT (1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRDVA_is_active';
            PRINT N'            Expected Name                 : DF_PRDVA_is_active';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PRDVA_is_active_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PRDVA_is_active';
            PRINT N'            Expected Definition           : DEFAULT (1)';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PRDVA_is_active_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRDVA_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_created_at'
    )
    BEGIN

        ALTER TABLE catalog.ProductVariant
            ADD CONSTRAINT DF_PRDVA_created_at
            DEFAULT (SYSDATETIME()) FOR PRDVA_created_at;

        PRINT N'        [+] Default constraint added      : DF_PRDVA_created_at';
        PRINT N'            Column                        : PRDVA_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PRDVA_created_at_constraint_name sysname,
            @PRDVA_created_at_definition      nvarchar(4000);


        SELECT
            @PRDVA_created_at_constraint_name = dc.name,
            @PRDVA_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_created_at';


        IF @PRDVA_created_at_constraint_name = N'DF_PRDVA_created_at'
        AND UPPER(REPLACE(REPLACE(@PRDVA_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRDVA_created_at';
            PRINT N'            Column                        : PRDVA_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRDVA_created_at';
            PRINT N'            Expected Name                 : DF_PRDVA_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PRDVA_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PRDVA_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PRDVA_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRDVA_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_updated_at'
    )
    BEGIN

        ALTER TABLE catalog.ProductVariant
            ADD CONSTRAINT DF_PRDVA_updated_at
            DEFAULT (SYSDATETIME()) FOR PRDVA_updated_at;

        PRINT N'        [+] Default constraint added      : DF_PRDVA_updated_at';
        PRINT N'            Column                        : PRDVA_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PRDVA_updated_at_constraint_name sysname,
            @PRDVA_updated_at_definition      nvarchar(4000);


        SELECT
            @PRDVA_updated_at_constraint_name = dc.name,
            @PRDVA_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'catalog.ProductVariant')
        AND c.name = N'PRDVA_updated_at';


        IF @PRDVA_updated_at_constraint_name = N'DF_PRDVA_updated_at'
        AND UPPER(REPLACE(REPLACE(@PRDVA_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRDVA_updated_at';
            PRINT N'            Column                        : PRDVA_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRDVA_updated_at';
            PRINT N'            Expected Name                 : DF_PRDVA_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PRDVA_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PRDVA_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PRDVA_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';