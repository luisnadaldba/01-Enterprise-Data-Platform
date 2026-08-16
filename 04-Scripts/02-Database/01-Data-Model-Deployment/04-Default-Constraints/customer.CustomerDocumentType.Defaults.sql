    PRINT N'    customer.CustomerDocumentType';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_DTP_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND c.name = N'DTP_created_at'
    )
    BEGIN

        ALTER TABLE customer.CustomerDocumentType
            ADD CONSTRAINT DF_DTP_created_at
            DEFAULT (SYSDATETIME()) FOR DTP_created_at;

        PRINT N'        [+] Default constraint added      : DF_DTP_created_at';
        PRINT N'            Column                        : DTP_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @DTP_created_at_constraint_name sysname,
            @DTP_created_at_definition      nvarchar(4000);


        SELECT
            @DTP_created_at_constraint_name = dc.name,
            @DTP_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND c.name = N'DTP_created_at';


        IF @DTP_created_at_constraint_name = N'DF_DTP_created_at'
        AND UPPER(REPLACE(REPLACE(@DTP_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_DTP_created_at';
            PRINT N'            Column                        : DTP_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_DTP_created_at';
            PRINT N'            Expected Name                 : DF_DTP_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@DTP_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : DTP_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@DTP_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_DTP_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND c.name = N'DTP_updated_at'
    )
    BEGIN

        ALTER TABLE customer.CustomerDocumentType
            ADD CONSTRAINT DF_DTP_updated_at
            DEFAULT (SYSDATETIME()) FOR DTP_updated_at;

        PRINT N'        [+] Default constraint added      : DF_DTP_updated_at';
        PRINT N'            Column                        : DTP_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @DTP_updated_at_constraint_name sysname,
            @DTP_updated_at_definition      nvarchar(4000);


        SELECT
            @DTP_updated_at_constraint_name = dc.name,
            @DTP_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND c.name = N'DTP_updated_at';


        IF @DTP_updated_at_constraint_name = N'DF_DTP_updated_at'
        AND UPPER(REPLACE(REPLACE(@DTP_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_DTP_updated_at';
            PRINT N'            Column                        : DTP_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_DTP_updated_at';
            PRINT N'            Expected Name                 : DF_DTP_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@DTP_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : DTP_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@DTP_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';