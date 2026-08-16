    PRINT N'    customer.CustomerDocument';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CSTCD_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerDocument')
        AND c.name = N'CSTCD_created_at'
    )
    BEGIN

        ALTER TABLE customer.CustomerDocument
            ADD CONSTRAINT DF_CSTCD_created_at
            DEFAULT (SYSDATETIME()) FOR CSTCD_created_at;

        PRINT N'        [+] Default constraint added      : DF_CSTCD_created_at';
        PRINT N'            Column                        : CSTCD_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CSTCD_created_at_constraint_name sysname,
            @CSTCD_created_at_definition      nvarchar(4000);


        SELECT
            @CSTCD_created_at_constraint_name = dc.name,
            @CSTCD_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerDocument')
        AND c.name = N'CSTCD_created_at';


        IF @CSTCD_created_at_constraint_name = N'DF_CSTCD_created_at'
        AND UPPER(REPLACE(REPLACE(@CSTCD_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CSTCD_created_at';
            PRINT N'            Column                        : CSTCD_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CSTCD_created_at';
            PRINT N'            Expected Name                 : DF_CSTCD_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CSTCD_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CSTCD_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CSTCD_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CSTCD_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerDocument')
        AND c.name = N'CSTCD_updated_at'
    )
    BEGIN

        ALTER TABLE customer.CustomerDocument
            ADD CONSTRAINT DF_CSTCD_updated_at
            DEFAULT (SYSDATETIME()) FOR CSTCD_updated_at;

        PRINT N'        [+] Default constraint added      : DF_CSTCD_updated_at';
        PRINT N'            Column                        : CSTCD_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CSTCD_updated_at_constraint_name sysname,
            @CSTCD_updated_at_definition      nvarchar(4000);


        SELECT
            @CSTCD_updated_at_constraint_name = dc.name,
            @CSTCD_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerDocument')
        AND c.name = N'CSTCD_updated_at';


        IF @CSTCD_updated_at_constraint_name = N'DF_CSTCD_updated_at'
        AND UPPER(REPLACE(REPLACE(@CSTCD_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CSTCD_updated_at';
            PRINT N'            Column                        : CSTCD_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CSTCD_updated_at';
            PRINT N'            Expected Name                 : DF_CSTCD_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CSTCD_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CSTCD_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CSTCD_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';