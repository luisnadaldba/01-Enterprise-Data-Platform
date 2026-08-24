    PRINT N'';
    PRINT N'    ● payment.PaymentMethod';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAYME_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentMethod')
        AND c.name = N'PAYME_created_at'
    )
    BEGIN

        ALTER TABLE payment.PaymentMethod
            ADD CONSTRAINT DF_PAYME_created_at
            DEFAULT (SYSDATETIME()) FOR PAYME_created_at;

        PRINT N'        [+] Default constraint added      : DF_PAYME_created_at';
        PRINT N'            Column                        : PAYME_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PAYME_created_at_constraint_name sysname,
            @PAYME_created_at_definition      nvarchar(4000);


        SELECT
            @PAYME_created_at_constraint_name = dc.name,
            @PAYME_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentMethod')
        AND c.name = N'PAYME_created_at';


        IF @PAYME_created_at_constraint_name = N'DF_PAYME_created_at'
        AND UPPER(REPLACE(REPLACE(@PAYME_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PAYME_created_at';
            PRINT N'            Column                        : PAYME_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PAYME_created_at';
            PRINT N'            Expected Name                 : DF_PAYME_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PAYME_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PAYME_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PAYME_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAYME_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentMethod')
        AND c.name = N'PAYME_updated_at'
    )
    BEGIN

        ALTER TABLE payment.PaymentMethod
            ADD CONSTRAINT DF_PAYME_updated_at
            DEFAULT (SYSDATETIME()) FOR PAYME_updated_at;

        PRINT N'        [+] Default constraint added      : DF_PAYME_updated_at';
        PRINT N'            Column                        : PAYME_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PAYME_updated_at_constraint_name sysname,
            @PAYME_updated_at_definition      nvarchar(4000);


        SELECT
            @PAYME_updated_at_constraint_name = dc.name,
            @PAYME_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentMethod')
        AND c.name = N'PAYME_updated_at';


        IF @PAYME_updated_at_constraint_name = N'DF_PAYME_updated_at'
        AND UPPER(REPLACE(REPLACE(@PAYME_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PAYME_updated_at';
            PRINT N'            Column                        : PAYME_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PAYME_updated_at';
            PRINT N'            Expected Name                 : DF_PAYME_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PAYME_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PAYME_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PAYME_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';