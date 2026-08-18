    PRINT N'    payment.PaymentRefundReason';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAYRR_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentRefundReason')
        AND c.name = N'PAYRR_created_at'
    )
    BEGIN

        ALTER TABLE payment.PaymentRefundReason
            ADD CONSTRAINT DF_PAYRR_created_at
            DEFAULT (SYSDATETIME()) FOR PAYRR_created_at;

        PRINT N'        [+] Default constraint added      : DF_PAYRR_created_at';
        PRINT N'            Column                        : PAYRR_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PAYRR_created_at_constraint_name sysname,
            @PAYRR_created_at_definition      nvarchar(4000);


        SELECT
            @PAYRR_created_at_constraint_name = dc.name,
            @PAYRR_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentRefundReason')
        AND c.name = N'PAYRR_created_at';


        IF @PAYRR_created_at_constraint_name = N'DF_PAYRR_created_at'
        AND UPPER(REPLACE(REPLACE(@PAYRR_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PAYRR_created_at';
            PRINT N'            Column                        : PAYRR_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PAYRR_created_at';
            PRINT N'            Expected Name                 : DF_PAYRR_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PAYRR_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PAYRR_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PAYRR_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PAYRR_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentRefundReason')
        AND c.name = N'PAYRR_updated_at'
    )
    BEGIN

        ALTER TABLE payment.PaymentRefundReason
            ADD CONSTRAINT DF_PAYRR_updated_at
            DEFAULT (SYSDATETIME()) FOR PAYRR_updated_at;

        PRINT N'        [+] Default constraint added      : DF_PAYRR_updated_at';
        PRINT N'            Column                        : PAYRR_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PAYRR_updated_at_constraint_name sysname,
            @PAYRR_updated_at_definition      nvarchar(4000);


        SELECT
            @PAYRR_updated_at_constraint_name = dc.name,
            @PAYRR_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'payment.PaymentRefundReason')
        AND c.name = N'PAYRR_updated_at';


        IF @PAYRR_updated_at_constraint_name = N'DF_PAYRR_updated_at'
        AND UPPER(REPLACE(REPLACE(@PAYRR_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PAYRR_updated_at';
            PRINT N'            Column                        : PAYRR_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PAYRR_updated_at';
            PRINT N'            Expected Name                 : DF_PAYRR_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PAYRR_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : PAYRR_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@PAYRR_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';