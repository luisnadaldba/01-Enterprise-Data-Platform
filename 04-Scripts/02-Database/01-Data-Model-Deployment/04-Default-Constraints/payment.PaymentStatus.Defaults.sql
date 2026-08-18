    PRINT N'    payment.PaymentStatus';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAYST_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentStatus')
        AND c.name = N'PAYST_created_at'
    )
    BEGIN

        ALTER TABLE payment.PaymentStatus
            ADD CONSTRAINT DF_PAYST_created_at
            DEFAULT (SYSDATETIME()) FOR PAYST_created_at;

        PRINT N'        [+] Default constraint added      : DF_PAYST_created_at';
        PRINT N'            Column                        : PAYST_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PAYST_created_at_constraint_name sysname,
            @PAYST_created_at_definition      nvarchar(4000);


        SELECT
            @PAYST_created_at_constraint_name = dc.name,
            @PAYST_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentStatus')
        AND c.name = N'PAYST_created_at';


        IF @PAYST_created_at_constraint_name = N'DF_PAYST_created_at'
        AND UPPER(REPLACE(REPLACE(@PAYST_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PAYST_created_at';
            PRINT N'            Column                        : PAYST_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PAYST_created_at';
            PRINT N'            Expected Name                 : DF_PAYST_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PAYST_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PAYST_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PAYST_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAYST_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentStatus')
        AND c.name = N'PAYST_updated_at'
    )
    BEGIN

        ALTER TABLE payment.PaymentStatus
            ADD CONSTRAINT DF_PAYST_updated_at
            DEFAULT (SYSDATETIME()) FOR PAYST_updated_at;

        PRINT N'        [+] Default constraint added      : DF_PAYST_updated_at';
        PRINT N'            Column                        : PAYST_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PAYST_updated_at_constraint_name sysname,
            @PAYST_updated_at_definition      nvarchar(4000);


        SELECT
            @PAYST_updated_at_constraint_name = dc.name,
            @PAYST_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentStatus')
        AND c.name = N'PAYST_updated_at';


        IF @PAYST_updated_at_constraint_name = N'DF_PAYST_updated_at'
        AND UPPER(REPLACE(REPLACE(@PAYST_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PAYST_updated_at';
            PRINT N'            Column                        : PAYST_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PAYST_updated_at';
            PRINT N'            Expected Name                 : DF_PAYST_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PAYST_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PAYST_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PAYST_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';