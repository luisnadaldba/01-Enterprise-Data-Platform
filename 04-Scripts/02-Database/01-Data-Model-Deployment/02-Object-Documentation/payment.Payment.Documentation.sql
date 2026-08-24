    PRINT N'';
    PRINT N'    ● payment.Payment';
    PRINT N'';

    DECLARE @PAY_expected_description nvarchar(4000);
    DECLARE @PAY_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Records payment attempts associated with Atlas Commerce sales transactions, including payment method, status, amount, installment information and relevant business-event timestamps.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment';

        PRINT N'        [+] Table description added       : payment.Payment';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : payment.Payment';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : payment.Payment';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_id
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Primary key of payment.Payment.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_id';

        PRINT N'        [+] Column description added      : PAY_id';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_id';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_id';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_TRN_id
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Foreign key referencing sales.Transaction.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_TRN_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_TRN_id';

        PRINT N'        [+] Column description added      : PAY_TRN_id';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_TRN_id';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_TRN_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_TRN_id';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_transaction_at
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Stores the originating sales transaction timestamp and participates with PAY_TRN_id in the composite foreign key to sales.Transaction.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_transaction_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_transaction_at';

        PRINT N'        [+] Column description added      : PAY_transaction_at';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_transaction_at';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_transaction_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_transaction_at';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_PAYME_id
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Foreign key referencing payment.PaymentMethod.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_PAYME_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_PAYME_id';

        PRINT N'        [+] Column description added      : PAY_PAYME_id';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_PAYME_id';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_PAYME_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_PAYME_id';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_PAYST_id
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Foreign key referencing payment.PaymentStatus.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_PAYST_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_PAYST_id';

        PRINT N'        [+] Column description added      : PAY_PAYST_id';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_PAYST_id';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_PAYST_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_PAYST_id';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_amount
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Stores the monetary amount associated with the individual payment attempt or payment operation.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_amount'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_amount';

        PRINT N'        [+] Column description added      : PAY_amount';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_amount';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_amount';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_amount';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_installment_count
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Stores the number of installments when the payment is installment-based; NULL when installments do not apply.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_installment_count'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_installment_count';

        PRINT N'        [+] Column description added      : PAY_installment_count';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_installment_count';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_installment_count';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_installment_count';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_attempted_at
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Records the date and time when the payment attempt occurred.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_attempted_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_attempted_at';

        PRINT N'        [+] Column description added      : PAY_attempted_at';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_attempted_at';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_attempted_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_attempted_at';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_approved_at
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Records the date and time when the payment was approved, when applicable.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_approved_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_approved_at';

        PRINT N'        [+] Column description added      : PAY_approved_at';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_approved_at';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_approved_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_approved_at';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_cancelled_at
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Records the date and time when the payment was cancelled, when applicable.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_cancelled_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_cancelled_at';

        PRINT N'        [+] Column description added      : PAY_cancelled_at';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_cancelled_at';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_cancelled_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_cancelled_at';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_created_at
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Records the date and time when the row was created.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_created_at';

        PRINT N'        [+] Column description added      : PAY_created_at';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_created_at';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_created_at';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAY_updated_at
    ----------------------------------------------------------------------*/

    SET @PAY_expected_description =
        N'Records the date and time when the row was last updated.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'Payment',
            @level2type = N'COLUMN',
            @level2name = N'PAY_updated_at';

        PRINT N'        [+] Column description added      : PAY_updated_at';

    END
    ELSE
    BEGIN

        SET @PAY_existing_description = NULL;


        SELECT
            @PAY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.Payment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAY_updated_at';


        IF @PAY_existing_description =
            @PAY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAY_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAY_updated_at';
            PRINT N'            Expected                     : '
                + @PAY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAY_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';