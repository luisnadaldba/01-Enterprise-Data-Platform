    PRINT N'    customer.Customer';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @CST_expected_description nvarchar(4000);
    DECLARE @CST_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @CST_expected_description =
        N'Maintains the core identity and lifecycle information of identified customers in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'Customer';

        PRINT N'        [+] Table description added       : customer.Customer';

    END
    ELSE
    BEGIN

        SET @CST_existing_description = NULL;

        SELECT
            @CST_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @CST_existing_description = @CST_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : customer.Customer';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : customer.Customer';
            PRINT N'            Expected                     : '
                + @CST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CST_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CST_id
    ----------------------------------------------------------------------*/

    SET @CST_expected_description =
        N'Primary key of customer.Customer.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'Customer',
            @level2type = N'COLUMN',
            @level2name = N'CST_id';

        PRINT N'        [+] Column description added      : CST_id';

    END
    ELSE
    BEGIN

        SET @CST_existing_description = NULL;

        SELECT
            @CST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_id';

        IF @CST_existing_description = @CST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CST_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CST_id';
            PRINT N'            Expected                     : '
                + @CST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CST_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CST_CSTCT_id
    ----------------------------------------------------------------------*/

    SET @CST_expected_description =
        N'Foreign key of customer.CustomerType.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_CSTCT_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'Customer',
            @level2type = N'COLUMN',
            @level2name = N'CST_CSTCT_id';

        PRINT N'        [+] Column description added      : CST_CSTCT_id';

    END
    ELSE
    BEGIN

        SET @CST_existing_description = NULL;

        SELECT
            @CST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_CSTCT_id';

        IF @CST_existing_description = @CST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CST_CSTCT_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CST_CSTCT_id';
            PRINT N'            Expected                     : '
                + @CST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CST_existing_description
                END;

        END;

    END;

    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CST_is_active
    ----------------------------------------------------------------------*/

    SET @CST_expected_description =
        N'Indicates whether the customer is currently active.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'Customer',
            @level2type = N'COLUMN',
            @level2name = N'CST_is_active';

        PRINT N'        [+] Column description added      : CST_is_active';

    END
    ELSE
    BEGIN

        SET @CST_existing_description = NULL;

        SELECT
            @CST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_is_active';

        IF @CST_existing_description = @CST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CST_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CST_is_active';
            PRINT N'            Expected                     : '
                + @CST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CST_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CST_name
    ----------------------------------------------------------------------*/

    SET @CST_expected_description =
        N'Stores the customer name, representing the full name for individuals or the company name for legal entities.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'Customer',
            @level2type = N'COLUMN',
            @level2name = N'CST_name';

        PRINT N'        [+] Column description added      : CST_name';

    END
    ELSE
    BEGIN

        SET @CST_existing_description = NULL;

        SELECT
            @CST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_name';

        IF @CST_existing_description = @CST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CST_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CST_name';
            PRINT N'            Expected                     : '
                + @CST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CST_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CST_birth_date
    ----------------------------------------------------------------------*/

    SET @CST_expected_description =
        N'Stores the birth date of an individual customer when provided and applicable.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_birth_date'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'Customer',
            @level2type = N'COLUMN',
            @level2name = N'CST_birth_date';

        PRINT N'        [+] Column description added      : CST_birth_date';

    END
    ELSE
    BEGIN

        SET @CST_existing_description = NULL;

        SELECT
            @CST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_birth_date';

        IF @CST_existing_description = @CST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CST_birth_date';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CST_birth_date';
            PRINT N'            Expected                     : '
                + @CST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CST_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CST_created_at
    ----------------------------------------------------------------------*/

    SET @CST_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'Customer',
            @level2type = N'COLUMN',
            @level2name = N'CST_created_at';

        PRINT N'        [+] Column description added      : CST_created_at';

    END
    ELSE
    BEGIN

        SET @CST_existing_description = NULL;

        SELECT
            @CST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_created_at';

        IF @CST_existing_description = @CST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CST_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CST_created_at';
            PRINT N'            Expected                     : '
                + @CST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CST_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CST_updated_at
    ----------------------------------------------------------------------*/

    SET @CST_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'Customer',
            @level2type = N'COLUMN',
            @level2name = N'CST_updated_at';

        PRINT N'        [+] Column description added      : CST_updated_at';

    END
    ELSE
    BEGIN

        SET @CST_existing_description = NULL;

        SELECT
            @CST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.Customer')
        AND ep.name = N'MS_Description'
        AND c.name = N'CST_updated_at';

        IF @CST_existing_description = @CST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CST_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CST_updated_at';
            PRINT N'            Expected                     : '
                + @CST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CST_existing_description
                END;

        END;

    END;


    PRINT N'';