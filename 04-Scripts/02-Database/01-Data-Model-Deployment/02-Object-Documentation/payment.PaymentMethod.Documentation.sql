    PRINT N'    payment.PaymentMethod';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @PAYME_expected_description nvarchar(4000);
    DECLARE @PAYME_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PAYME_expected_description =
        N'Defines the controlled payment methods available for Atlas Commerce transactions.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'payment.PaymentMethod')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYME_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentMethod';

        PRINT N'        [+] Table description added       : payment.PaymentMethod';

    END
    ELSE
    BEGIN

        SET @PAYME_existing_description = NULL;

        SELECT
            @PAYME_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'payment.PaymentMethod')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @PAYME_existing_description = @PAYME_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : payment.PaymentMethod';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : payment.PaymentMethod';
            PRINT N'            Expected                     : '
                + @PAYME_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYME_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYME_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYME_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYME_id
    ----------------------------------------------------------------------*/

    SET @PAYME_expected_description =
        N'Primary key of payment.PaymentMethod.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'payment.PaymentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAYME_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYME_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentMethod',
            @level2type = N'COLUMN',
            @level2name = N'PAYME_id';

        PRINT N'        [+] Column description added      : PAYME_id';

    END
    ELSE
    BEGIN

        SET @PAYME_existing_description = NULL;

        SELECT
            @PAYME_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'payment.PaymentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAYME_id';

        IF @PAYME_existing_description = @PAYME_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYME_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYME_id';
            PRINT N'            Expected                     : '
                + @PAYME_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYME_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PAYME_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PAYME_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYME_name
    ----------------------------------------------------------------------*/

    SET @PAYME_expected_description =
        N'Stores the controlled name of the payment method used by Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'payment.PaymentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAYME_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYME_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentMethod',
            @level2type = N'COLUMN',
            @level2name = N'PAYME_name';

        PRINT N'        [+] Column description added      : PAYME_name';

    END
    ELSE
    BEGIN

        SET @PAYME_existing_description = NULL;

        SELECT
            @PAYME_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'payment.PaymentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAYME_name';

        IF @PAYME_existing_description = @PAYME_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYME_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYME_name';
            PRINT N'            Expected                     : '
                + @PAYME_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYME_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PAYME_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PAYME_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYME_created_at
    ----------------------------------------------------------------------*/

    SET @PAYME_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'payment.PaymentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAYME_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYME_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentMethod',
            @level2type = N'COLUMN',
            @level2name = N'PAYME_created_at';

        PRINT N'        [+] Column description added      : PAYME_created_at';

    END
    ELSE
    BEGIN

        SET @PAYME_existing_description = NULL;

        SELECT
            @PAYME_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'payment.PaymentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAYME_created_at';

        IF @PAYME_existing_description = @PAYME_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYME_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYME_created_at';
            PRINT N'            Expected                     : '
                + @PAYME_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYME_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PAYME_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PAYME_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYME_updated_at
    ----------------------------------------------------------------------*/

    SET @PAYME_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'payment.PaymentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAYME_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYME_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentMethod',
            @level2type = N'COLUMN',
            @level2name = N'PAYME_updated_at';

        PRINT N'        [+] Column description added      : PAYME_updated_at';

    END
    ELSE
    BEGIN

        SET @PAYME_existing_description = NULL;

        SELECT
            @PAYME_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'payment.PaymentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAYME_updated_at';

        IF @PAYME_existing_description = @PAYME_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYME_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYME_updated_at';
            PRINT N'            Expected                     : '
                + @PAYME_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYME_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PAYME_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PAYME_existing_description
                END;

        END;

    END;


    PRINT N'';