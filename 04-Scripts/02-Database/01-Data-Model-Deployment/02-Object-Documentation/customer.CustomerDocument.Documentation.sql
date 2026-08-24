    PRINT N'';
    PRINT N'    ● customer.CustomerDocument';
    PRINT N'';

    DECLARE @CSTCD_expected_description nvarchar(4000);
    DECLARE @CSTCD_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @CSTCD_expected_description =
        N'Maintains document identifiers associated with identified customers while keeping document information separated from the core Customer entity.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocument';

        PRINT N'        [+] Table description added       : customer.CustomerDocument';

    END
    ELSE
    BEGIN

        SET @CSTCD_existing_description = NULL;


        SELECT
            @CSTCD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @CSTCD_existing_description =
            @CSTCD_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : customer.CustomerDocument';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : customer.CustomerDocument';
            PRINT N'            Expected                     : '
                + @CSTCD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCD_id
    ----------------------------------------------------------------------*/

    SET @CSTCD_expected_description =
        N'Primary key of customer.CustomerDocument.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocument',
            @level2type = N'COLUMN',
            @level2name = N'CSTCD_id';

        PRINT N'        [+] Column description added      : CSTCD_id';

    END
    ELSE
    BEGIN

        SET @CSTCD_existing_description = NULL;


        SELECT
            @CSTCD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_id';


        IF @CSTCD_existing_description =
            @CSTCD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCD_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCD_id';
            PRINT N'            Expected                     : '
                + @CSTCD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCD_CST_id
    ----------------------------------------------------------------------*/

    SET @CSTCD_expected_description =
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
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_CST_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocument',
            @level2type = N'COLUMN',
            @level2name = N'CSTCD_CST_id';

        PRINT N'        [+] Column description added      : CSTCD_CST_id';

    END
    ELSE
    BEGIN

        SET @CSTCD_existing_description = NULL;


        SELECT
            @CSTCD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_CST_id';


        IF @CSTCD_existing_description =
            @CSTCD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCD_CST_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCD_CST_id';
            PRINT N'            Expected                     : '
                + @CSTCD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCD_DTP_id
    ----------------------------------------------------------------------*/

    SET @CSTCD_expected_description =
        N'Foreign key referencing customer.CustomerDocumentType.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_DTP_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocument',
            @level2type = N'COLUMN',
            @level2name = N'CSTCD_DTP_id';

        PRINT N'        [+] Column description added      : CSTCD_DTP_id';

    END
    ELSE
    BEGIN

        SET @CSTCD_existing_description = NULL;


        SELECT
            @CSTCD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_DTP_id';


        IF @CSTCD_existing_description =
            @CSTCD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCD_DTP_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCD_DTP_id';
            PRINT N'            Expected                     : '
                + @CSTCD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCD_value
    ----------------------------------------------------------------------*/

    SET @CSTCD_expected_description =
        N'Stores the normalized document identifier value without presentation formatting.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_value'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocument',
            @level2type = N'COLUMN',
            @level2name = N'CSTCD_value';

        PRINT N'        [+] Column description added      : CSTCD_value';

    END
    ELSE
    BEGIN

        SET @CSTCD_existing_description = NULL;


        SELECT
            @CSTCD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_value';


        IF @CSTCD_existing_description =
            @CSTCD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCD_value';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCD_value';
            PRINT N'            Expected                     : '
                + @CSTCD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCD_created_at
    ----------------------------------------------------------------------*/

    SET @CSTCD_expected_description =
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
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocument',
            @level2type = N'COLUMN',
            @level2name = N'CSTCD_created_at';

        PRINT N'        [+] Column description added      : CSTCD_created_at';

    END
    ELSE
    BEGIN

        SET @CSTCD_existing_description = NULL;


        SELECT
            @CSTCD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_created_at';


        IF @CSTCD_existing_description =
            @CSTCD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCD_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCD_created_at';
            PRINT N'            Expected                     : '
                + @CSTCD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCD_updated_at
    ----------------------------------------------------------------------*/

    SET @CSTCD_expected_description =
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
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocument',
            @level2type = N'COLUMN',
            @level2name = N'CSTCD_updated_at';

        PRINT N'        [+] Column description added      : CSTCD_updated_at';

    END
    ELSE
    BEGIN

        SET @CSTCD_existing_description = NULL;


        SELECT
            @CSTCD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCD_updated_at';


        IF @CSTCD_existing_description =
            @CSTCD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCD_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCD_updated_at';
            PRINT N'            Expected                     : '
                + @CSTCD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCD_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';