    PRINT N'    customer.CustomerType';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @CSTCT_expected_description nvarchar(4000);
    DECLARE @CSTCT_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @CSTCT_expected_description =
        N'Maintains the controlled customer types supported by Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerType';

        PRINT N'        [+] Table description added       : customer.CustomerType';

    END
    ELSE
    BEGIN

        SET @CSTCT_existing_description = NULL;

        SELECT
            @CSTCT_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @CSTCT_existing_description = @CSTCT_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : customer.CustomerType';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : customer.CustomerType';
            PRINT N'            Expected                     : '
                + @CSTCT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCT_id
    ----------------------------------------------------------------------*/

    SET @CSTCT_expected_description =
        N'Primary key of customer.CustomerType.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTCT_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerType',
            @level2type = N'COLUMN',
            @level2name = N'CSTCT_id';

        PRINT N'        [+] Column description added      : CSTCT_id';

    END
    ELSE
    BEGIN

        SET @CSTCT_existing_description = NULL;

        SELECT
            @CSTCT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTCT_id';

        IF @CSTCT_existing_description = @CSTCT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCT_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCT_id';
            PRINT N'            Expected                     : '
                + @CSTCT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTCT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTCT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCT_code
    ----------------------------------------------------------------------*/

    SET @CSTCT_expected_description =
        N'Stores the stable technical code used to identify the customer type.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTCT_code'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerType',
            @level2type = N'COLUMN',
            @level2name = N'CSTCT_code';

        PRINT N'        [+] Column description added      : CSTCT_code';

    END
    ELSE
    BEGIN

        SET @CSTCT_existing_description = NULL;

        SELECT
            @CSTCT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTCT_code';

        IF @CSTCT_existing_description = @CSTCT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCT_code';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCT_code';
            PRINT N'            Expected                     : '
                + @CSTCT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTCT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTCT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCT_name
    ----------------------------------------------------------------------*/

    SET @CSTCT_expected_description =
        N'Stores the descriptive name of the customer type.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTCT_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerType',
            @level2type = N'COLUMN',
            @level2name = N'CSTCT_name';

        PRINT N'        [+] Column description added      : CSTCT_name';

    END
    ELSE
    BEGIN

        SET @CSTCT_existing_description = NULL;

        SELECT
            @CSTCT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTCT_name';

        IF @CSTCT_existing_description = @CSTCT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCT_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCT_name';
            PRINT N'            Expected                     : '
                + @CSTCT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTCT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTCT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCT_created_at
    ----------------------------------------------------------------------*/

    SET @CSTCT_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTCT_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerType',
            @level2type = N'COLUMN',
            @level2name = N'CSTCT_created_at';

        PRINT N'        [+] Column description added      : CSTCT_created_at';

    END
    ELSE
    BEGIN

        SET @CSTCT_existing_description = NULL;

        SELECT
            @CSTCT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTCT_created_at';

        IF @CSTCT_existing_description = @CSTCT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCT_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCT_created_at';
            PRINT N'            Expected                     : '
                + @CSTCT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTCT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTCT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCT_updated_at
    ----------------------------------------------------------------------*/

    SET @CSTCT_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTCT_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerType',
            @level2type = N'COLUMN',
            @level2name = N'CSTCT_updated_at';

        PRINT N'        [+] Column description added      : CSTCT_updated_at';

    END
    ELSE
    BEGIN

        SET @CSTCT_existing_description = NULL;

        SELECT
            @CSTCT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTCT_updated_at';

        IF @CSTCT_existing_description = @CSTCT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCT_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCT_updated_at';
            PRINT N'            Expected                     : '
                + @CSTCT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTCT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTCT_existing_description
                END;

        END;

    END;


    PRINT N'';