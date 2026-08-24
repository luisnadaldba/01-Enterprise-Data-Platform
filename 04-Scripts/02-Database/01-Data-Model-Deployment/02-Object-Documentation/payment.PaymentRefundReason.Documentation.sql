    PRINT N'';
    PRINT N'    ● payment.PaymentRefundReason';
    PRINT N'';

    DECLARE @PAYRR_expected_description nvarchar(4000);
    DECLARE @PAYRR_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PAYRR_expected_description =
        N'Defines the controlled reasons used to classify payment refunds in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefundReason';

        PRINT N'        [+] Table description added       : payment.PaymentRefundReason';

    END
    ELSE
    BEGIN

        SET @PAYRR_existing_description = NULL;


        SELECT
            @PAYRR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @PAYRR_existing_description =
            @PAYRR_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : payment.PaymentRefundReason';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : payment.PaymentRefundReason';
            PRINT N'            Expected                     : '
                + @PAYRR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRR_id
    ----------------------------------------------------------------------*/

    SET @PAYRR_expected_description =
        N'Primary key of payment.PaymentRefundReason.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRR_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefundReason',
            @level2type = N'COLUMN',
            @level2name = N'PAYRR_id';

        PRINT N'        [+] Column description added      : PAYRR_id';

    END
    ELSE
    BEGIN

        SET @PAYRR_existing_description = NULL;


        SELECT
            @PAYRR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRR_id';


        IF @PAYRR_existing_description =
            @PAYRR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRR_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRR_id';
            PRINT N'            Expected                     : '
                + @PAYRR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRR_name
    ----------------------------------------------------------------------*/

    SET @PAYRR_expected_description =
        N'Stores the controlled name of the reason associated with a payment refund.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRR_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefundReason',
            @level2type = N'COLUMN',
            @level2name = N'PAYRR_name';

        PRINT N'        [+] Column description added      : PAYRR_name';

    END
    ELSE
    BEGIN

        SET @PAYRR_existing_description = NULL;


        SELECT
            @PAYRR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRR_name';


        IF @PAYRR_existing_description =
            @PAYRR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRR_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRR_name';
            PRINT N'            Expected                     : '
                + @PAYRR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRR_created_at
    ----------------------------------------------------------------------*/

    SET @PAYRR_expected_description =
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
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRR_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefundReason',
            @level2type = N'COLUMN',
            @level2name = N'PAYRR_created_at';

        PRINT N'        [+] Column description added      : PAYRR_created_at';

    END
    ELSE
    BEGIN

        SET @PAYRR_existing_description = NULL;


        SELECT
            @PAYRR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRR_created_at';


        IF @PAYRR_existing_description =
            @PAYRR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRR_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRR_created_at';
            PRINT N'            Expected                     : '
                + @PAYRR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYRR_updated_at
    ----------------------------------------------------------------------*/

    SET @PAYRR_expected_description =
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
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRR_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYRR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentRefundReason',
            @level2type = N'COLUMN',
            @level2name = N'PAYRR_updated_at';

        PRINT N'        [+] Column description added      : PAYRR_updated_at';

    END
    ELSE
    BEGIN

        SET @PAYRR_existing_description = NULL;


        SELECT
            @PAYRR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentRefundReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYRR_updated_at';


        IF @PAYRR_existing_description =
            @PAYRR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYRR_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYRR_updated_at';
            PRINT N'            Expected                     : '
                + @PAYRR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYRR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYRR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYRR_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';