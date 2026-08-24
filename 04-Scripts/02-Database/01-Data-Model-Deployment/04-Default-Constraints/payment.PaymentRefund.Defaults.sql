    PRINT N'';
    PRINT N'    ● payment.PaymentRefund';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAYRF_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_created_at'
    )
    BEGIN

        ALTER TABLE payment.PaymentRefund
            ADD CONSTRAINT DF_PAYRF_created_at
            DEFAULT (SYSDATETIME()) FOR PAYRF_created_at;

        PRINT N'        [+] Default constraint added      : DF_PAYRF_created_at';
        PRINT N'            Column                        : PAYRF_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PAYRF_created_at_constraint_name sysname,
            @PAYRF_created_at_definition      nvarchar(4000);


        SELECT
            @PAYRF_created_at_constraint_name = dc.name,
            @PAYRF_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_created_at';


        IF @PAYRF_created_at_constraint_name = N'DF_PAYRF_created_at'
        AND UPPER(REPLACE(REPLACE(@PAYRF_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PAYRF_created_at';
            PRINT N'            Column                        : PAYRF_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PAYRF_created_at';
            PRINT N'            Expected Name                 : DF_PAYRF_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PAYRF_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PAYRF_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PAYRF_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAYRF_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_updated_at'
    )
    BEGIN

        ALTER TABLE payment.PaymentRefund
            ADD CONSTRAINT DF_PAYRF_updated_at
            DEFAULT (SYSDATETIME()) FOR PAYRF_updated_at;

        PRINT N'        [+] Default constraint added      : DF_PAYRF_updated_at';
        PRINT N'            Column                        : PAYRF_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PAYRF_updated_at_constraint_name sysname,
            @PAYRF_updated_at_definition      nvarchar(4000);


        SELECT
            @PAYRF_updated_at_constraint_name = dc.name,
            @PAYRF_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND c.name = N'PAYRF_updated_at';


        IF @PAYRF_updated_at_constraint_name = N'DF_PAYRF_updated_at'
        AND UPPER(REPLACE(REPLACE(@PAYRF_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PAYRF_updated_at';
            PRINT N'            Column                        : PAYRF_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PAYRF_updated_at';
            PRINT N'            Expected Name                 : DF_PAYRF_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PAYRF_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PAYRF_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PAYRF_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';