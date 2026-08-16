    PRINT N'    customer.CustomerDocumentType';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @DTP_expected_description nvarchar(4000);
    DECLARE @DTP_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @DTP_expected_description =
        N'Maintains the controlled set of document types that may be associated with customers in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @DTP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocumentType';

        PRINT N'        [+] Table description added       : customer.CustomerDocumentType';

    END
    ELSE
    BEGIN

        SET @DTP_existing_description = NULL;

        SELECT
            @DTP_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @DTP_existing_description = @DTP_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : customer.CustomerDocumentType';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : customer.CustomerDocumentType';
            PRINT N'            Expected                     : '
                + @DTP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @DTP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@DTP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @DTP_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: DTP_id
    ----------------------------------------------------------------------*/

    SET @DTP_expected_description =
        N'Primary key of customer.CustomerDocumentType.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND ep.name = N'MS_Description'
        AND c.name = N'DTP_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @DTP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocumentType',
            @level2type = N'COLUMN',
            @level2name = N'DTP_id';

        PRINT N'        [+] Column description added      : DTP_id';

    END
    ELSE
    BEGIN

        SET @DTP_existing_description = NULL;

        SELECT
            @DTP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND ep.name = N'MS_Description'
        AND c.name = N'DTP_id';

        IF @DTP_existing_description = @DTP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : DTP_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : DTP_id';
            PRINT N'            Expected                     : '
                + @DTP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @DTP_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@DTP_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @DTP_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: DTP_name
    ----------------------------------------------------------------------*/

    SET @DTP_expected_description =
        N'Stores the controlled name used to identify a customer document type.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND ep.name = N'MS_Description'
        AND c.name = N'DTP_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @DTP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocumentType',
            @level2type = N'COLUMN',
            @level2name = N'DTP_name';

        PRINT N'        [+] Column description added      : DTP_name';

    END
    ELSE
    BEGIN

        SET @DTP_existing_description = NULL;

        SELECT
            @DTP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND ep.name = N'MS_Description'
        AND c.name = N'DTP_name';

        IF @DTP_existing_description = @DTP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : DTP_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : DTP_name';
            PRINT N'            Expected                     : '
                + @DTP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @DTP_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@DTP_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @DTP_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: DTP_created_at
    ----------------------------------------------------------------------*/

    SET @DTP_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND ep.name = N'MS_Description'
        AND c.name = N'DTP_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @DTP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocumentType',
            @level2type = N'COLUMN',
            @level2name = N'DTP_created_at';

        PRINT N'        [+] Column description added      : DTP_created_at';

    END
    ELSE
    BEGIN

        SET @DTP_existing_description = NULL;

        SELECT
            @DTP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND ep.name = N'MS_Description'
        AND c.name = N'DTP_created_at';

        IF @DTP_existing_description = @DTP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : DTP_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : DTP_created_at';
            PRINT N'            Expected                     : '
                + @DTP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @DTP_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@DTP_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @DTP_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: DTP_updated_at
    ----------------------------------------------------------------------*/

    SET @DTP_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND ep.name = N'MS_Description'
        AND c.name = N'DTP_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @DTP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerDocumentType',
            @level2type = N'COLUMN',
            @level2name = N'DTP_updated_at';

        PRINT N'        [+] Column description added      : DTP_updated_at';

    END
    ELSE
    BEGIN

        SET @DTP_existing_description = NULL;

        SELECT
            @DTP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerDocumentType')
        AND ep.name = N'MS_Description'
        AND c.name = N'DTP_updated_at';

        IF @DTP_existing_description = @DTP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : DTP_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : DTP_updated_at';
            PRINT N'            Expected                     : '
                + @DTP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @DTP_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@DTP_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @DTP_existing_description
                END;

        END;

    END;


    PRINT N'';