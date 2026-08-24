    PRINT N'';
    PRINT N'    ● payment.PaymentRefund';
    PRINT N'';

    DECLARE @PAYRF_expected_description nvarchar(4000);
    DECLARE @PAYRF_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PAYRF_expected_description =
        N'Records full and partial refund events associated with Atlas Commerce payments, including the refunded amount, standardized refund reason and refund business-event timestamp.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRF_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefund';

        PRINT N'        [+] Table description added       : payment.PaymentRefund';

    END
    ELSE
    BEGIN

        SET @PAYRF_existing_description = NULL;


        SELECT
            @PAYRF_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @PAYRF_existing_description =
            @PAYRF_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : payment.PaymentRefund';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : payment.PaymentRefund';
            PRINT N'            Expected                     : '
                + @PAYRF_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRF_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRF_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRF_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRF_id
    ----------------------------------------------------------------------*/

    SET @PAYRF_expected_description =
        N'Primary key of payment.PaymentRefund.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRF_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefund',
            @level2type = N'COLUMN',
            @level2name = N'PAYRF_id';

        PRINT N'        [+] Column description added      : PAYRF_id';

    END
    ELSE
    BEGIN

        SET @PAYRF_existing_description = NULL;


        SELECT
            @PAYRF_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_id';


        IF @PAYRF_existing_description =
            @PAYRF_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRF_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRF_id';
            PRINT N'            Expected                     : '
                + @PAYRF_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRF_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRF_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRF_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRF_PAY_id
    ----------------------------------------------------------------------*/

    SET @PAYRF_expected_description =
        N'Foreign key referencing payment.Payment.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_PAY_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRF_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefund',
            @level2type = N'COLUMN',
            @level2name = N'PAYRF_PAY_id';

        PRINT N'        [+] Column description added      : PAYRF_PAY_id';

    END
    ELSE
    BEGIN

        SET @PAYRF_existing_description = NULL;


        SELECT
            @PAYRF_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_PAY_id';


        IF @PAYRF_existing_description =
            @PAYRF_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRF_PAY_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRF_PAY_id';
            PRINT N'            Expected                     : '
                + @PAYRF_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRF_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRF_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRF_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRF_PAYRR_id
    ----------------------------------------------------------------------*/

    SET @PAYRF_expected_description =
        N'Foreign key referencing payment.PaymentRefundReason.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_PAYRR_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRF_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefund',
            @level2type = N'COLUMN',
            @level2name = N'PAYRF_PAYRR_id';

        PRINT N'        [+] Column description added      : PAYRF_PAYRR_id';

    END
    ELSE
    BEGIN

        SET @PAYRF_existing_description = NULL;


        SELECT
            @PAYRF_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_PAYRR_id';


        IF @PAYRF_existing_description =
            @PAYRF_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRF_PAYRR_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRF_PAYRR_id';
            PRINT N'            Expected                     : '
                + @PAYRF_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRF_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRF_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRF_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRF_amount
    ----------------------------------------------------------------------*/

    SET @PAYRF_expected_description =
        N'Stores the monetary amount associated with the individual refund event.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_amount'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRF_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefund',
            @level2type = N'COLUMN',
            @level2name = N'PAYRF_amount';

        PRINT N'        [+] Column description added      : PAYRF_amount';

    END
    ELSE
    BEGIN

        SET @PAYRF_existing_description = NULL;


        SELECT
            @PAYRF_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_amount';


        IF @PAYRF_existing_description =
            @PAYRF_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRF_amount';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRF_amount';
            PRINT N'            Expected                     : '
                + @PAYRF_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRF_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRF_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRF_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRF_refunded_at
    ----------------------------------------------------------------------*/

    SET @PAYRF_expected_description =
        N'Records the date and time when the refund event occurred.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_refunded_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRF_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefund',
            @level2type = N'COLUMN',
            @level2name = N'PAYRF_refunded_at';

        PRINT N'        [+] Column description added      : PAYRF_refunded_at';

    END
    ELSE
    BEGIN

        SET @PAYRF_existing_description = NULL;


        SELECT
            @PAYRF_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_refunded_at';


        IF @PAYRF_existing_description =
            @PAYRF_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRF_refunded_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRF_refunded_at';
            PRINT N'            Expected                     : '
                + @PAYRF_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRF_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRF_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRF_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRF_created_at
    ----------------------------------------------------------------------*/

    SET @PAYRF_expected_description =
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
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRF_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefund',
            @level2type = N'COLUMN',
            @level2name = N'PAYRF_created_at';

        PRINT N'        [+] Column description added      : PAYRF_created_at';

    END
    ELSE
    BEGIN

        SET @PAYRF_existing_description = NULL;


        SELECT
            @PAYRF_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_created_at';


        IF @PAYRF_existing_description =
            @PAYRF_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRF_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRF_created_at';
            PRINT N'            Expected                     : '
                + @PAYRF_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRF_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRF_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRF_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRF_updated_at
    ----------------------------------------------------------------------*/

    SET @PAYRF_expected_description =
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
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRF_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefund',
            @level2type = N'COLUMN',
            @level2name = N'PAYRF_updated_at';

        PRINT N'        [+] Column description added      : PAYRF_updated_at';

    END
    ELSE
    BEGIN

        SET @PAYRF_existing_description = NULL;


        SELECT
            @PAYRF_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRF_updated_at';


        IF @PAYRF_existing_description =
            @PAYRF_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRF_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRF_updated_at';
            PRINT N'            Expected                     : '
                + @PAYRF_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRF_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRF_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRF_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';