    PRINT N'';
    PRINT N'    ● payment.PaymentStatus';
    PRINT N'';

    DECLARE @PAYST_expected_description nvarchar(4000);
    DECLARE @PAYST_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PAYST_expected_description =
        N'Defines the controlled payment statuses used to represent the lifecycle of payment attempts in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentStatus';

        PRINT N'        [+] Table description added       : payment.PaymentStatus';

    END
    ELSE
    BEGIN

        SET @PAYST_existing_description = NULL;


        SELECT
            @PAYST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @PAYST_existing_description =
            @PAYST_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : payment.PaymentStatus';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : payment.PaymentStatus';
            PRINT N'            Expected                     : '
                + @PAYST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYST_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYST_id
    ----------------------------------------------------------------------*/

    SET @PAYST_expected_description =
        N'Primary key of payment.PaymentStatus.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYST_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentStatus',
            @level2type = N'COLUMN',
            @level2name = N'PAYST_id';

        PRINT N'        [+] Column description added      : PAYST_id';

    END
    ELSE
    BEGIN

        SET @PAYST_existing_description = NULL;


        SELECT
            @PAYST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYST_id';


        IF @PAYST_existing_description =
            @PAYST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYST_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYST_id';
            PRINT N'            Expected                     : '
                + @PAYST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYST_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYST_name
    ----------------------------------------------------------------------*/

    SET @PAYST_expected_description =
        N'Stores the controlled name of the payment status used by Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYST_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentStatus',
            @level2type = N'COLUMN',
            @level2name = N'PAYST_name';

        PRINT N'        [+] Column description added      : PAYST_name';

    END
    ELSE
    BEGIN

        SET @PAYST_existing_description = NULL;


        SELECT
            @PAYST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYST_name';


        IF @PAYST_existing_description =
            @PAYST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYST_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYST_name';
            PRINT N'            Expected                     : '
                + @PAYST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYST_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYST_created_at
    ----------------------------------------------------------------------*/

    SET @PAYST_expected_description =
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
                OBJECT_ID(N'payment.PaymentStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYST_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentStatus',
            @level2type = N'COLUMN',
            @level2name = N'PAYST_created_at';

        PRINT N'        [+] Column description added      : PAYST_created_at';

    END
    ELSE
    BEGIN

        SET @PAYST_existing_description = NULL;


        SELECT
            @PAYST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYST_created_at';


        IF @PAYST_existing_description =
            @PAYST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYST_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYST_created_at';
            PRINT N'            Expected                     : '
                + @PAYST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYST_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAYST_updated_at
    ----------------------------------------------------------------------*/

    SET @PAYST_expected_description =
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
                OBJECT_ID(N'payment.PaymentStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYST_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAYST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'payment',
            @level1type = N'TABLE',
            @level1name = N'PaymentStatus',
            @level2type = N'COLUMN',
            @level2name = N'PAYST_updated_at';

        PRINT N'        [+] Column description added      : PAYST_updated_at';

    END
    ELSE
    BEGIN

        SET @PAYST_existing_description = NULL;


        SELECT
            @PAYST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'payment.PaymentStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PAYST_updated_at';


        IF @PAYST_existing_description =
            @PAYST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAYST_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAYST_updated_at';
            PRINT N'            Expected                     : '
                + @PAYST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAYST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAYST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAYST_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';