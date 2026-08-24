    PRINT N'';
    PRINT N'    ● customer.CustomerEmail';
    PRINT N'';

    DECLARE @CSTEM_expected_description nvarchar(4000);
    DECLARE @CSTEM_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @CSTEM_expected_description =
        N'Maintains email addresses associated with identified customers while allowing shared email addresses across multiple customers.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTEM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerEmail';

        PRINT N'        [+] Table description added       : customer.CustomerEmail';

    END
    ELSE
    BEGIN

        SET @CSTEM_existing_description = NULL;


        SELECT
            @CSTEM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @CSTEM_existing_description =
            @CSTEM_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : customer.CustomerEmail';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : customer.CustomerEmail';
            PRINT N'            Expected                     : '
                + @CSTEM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTEM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTEM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTEM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTEM_id
    ----------------------------------------------------------------------*/

    SET @CSTEM_expected_description =
        N'Primary key of customer.CustomerEmail.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTEM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerEmail',
            @level2type = N'COLUMN',
            @level2name = N'CSTEM_id';

        PRINT N'        [+] Column description added      : CSTEM_id';

    END
    ELSE
    BEGIN

        SET @CSTEM_existing_description = NULL;


        SELECT
            @CSTEM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_id';


        IF @CSTEM_existing_description =
            @CSTEM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTEM_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTEM_id';
            PRINT N'            Expected                     : '
                + @CSTEM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTEM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTEM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTEM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTEM_CST_id
    ----------------------------------------------------------------------*/

    SET @CSTEM_expected_description =
        N'Foreign key referencing customer.Customer.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_CST_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTEM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerEmail',
            @level2type = N'COLUMN',
            @level2name = N'CSTEM_CST_id';

        PRINT N'        [+] Column description added      : CSTEM_CST_id';

    END
    ELSE
    BEGIN

        SET @CSTEM_existing_description = NULL;


        SELECT
            @CSTEM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_CST_id';


        IF @CSTEM_existing_description =
            @CSTEM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTEM_CST_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTEM_CST_id';
            PRINT N'            Expected                     : '
                + @CSTEM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTEM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTEM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTEM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTEM_email
    ----------------------------------------------------------------------*/

    SET @CSTEM_expected_description =
        N'Stores the email address associated with the customer.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_email'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTEM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerEmail',
            @level2type = N'COLUMN',
            @level2name = N'CSTEM_email';

        PRINT N'        [+] Column description added      : CSTEM_email';

    END
    ELSE
    BEGIN

        SET @CSTEM_existing_description = NULL;


        SELECT
            @CSTEM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_email';


        IF @CSTEM_existing_description =
            @CSTEM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTEM_email';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTEM_email';
            PRINT N'            Expected                     : '
                + @CSTEM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTEM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTEM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTEM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTEM_is_primary
    ----------------------------------------------------------------------*/

    SET @CSTEM_expected_description =
        N'Indicates whether the email is the primary active email address for the customer.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_is_primary'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTEM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerEmail',
            @level2type = N'COLUMN',
            @level2name = N'CSTEM_is_primary';

        PRINT N'        [+] Column description added      : CSTEM_is_primary';

    END
    ELSE
    BEGIN

        SET @CSTEM_existing_description = NULL;


        SELECT
            @CSTEM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_is_primary';


        IF @CSTEM_existing_description =
            @CSTEM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTEM_is_primary';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTEM_is_primary';
            PRINT N'            Expected                     : '
                + @CSTEM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTEM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTEM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTEM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTEM_is_active
    ----------------------------------------------------------------------*/

    SET @CSTEM_expected_description =
        N'Indicates whether the customer email address is currently active and available for use.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTEM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerEmail',
            @level2type = N'COLUMN',
            @level2name = N'CSTEM_is_active';

        PRINT N'        [+] Column description added      : CSTEM_is_active';

    END
    ELSE
    BEGIN

        SET @CSTEM_existing_description = NULL;


        SELECT
            @CSTEM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_is_active';


        IF @CSTEM_existing_description =
            @CSTEM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTEM_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTEM_is_active';
            PRINT N'            Expected                     : '
                + @CSTEM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTEM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTEM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTEM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTEM_created_at
    ----------------------------------------------------------------------*/

    SET @CSTEM_expected_description =
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
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTEM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerEmail',
            @level2type = N'COLUMN',
            @level2name = N'CSTEM_created_at';

        PRINT N'        [+] Column description added      : CSTEM_created_at';

    END
    ELSE
    BEGIN

        SET @CSTEM_existing_description = NULL;


        SELECT
            @CSTEM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_created_at';


        IF @CSTEM_existing_description =
            @CSTEM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTEM_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTEM_created_at';
            PRINT N'            Expected                     : '
                + @CSTEM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTEM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTEM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTEM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTEM_updated_at
    ----------------------------------------------------------------------*/

    SET @CSTEM_expected_description =
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
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTEM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerEmail',
            @level2type = N'COLUMN',
            @level2name = N'CSTEM_updated_at';

        PRINT N'        [+] Column description added      : CSTEM_updated_at';

    END
    ELSE
    BEGIN

        SET @CSTEM_existing_description = NULL;


        SELECT
            @CSTEM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTEM_updated_at';


        IF @CSTEM_existing_description =
            @CSTEM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTEM_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTEM_updated_at';
            PRINT N'            Expected                     : '
                + @CSTEM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTEM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTEM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTEM_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';